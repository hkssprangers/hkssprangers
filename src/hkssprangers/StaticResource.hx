package hkssprangers;

import sys.*;
import sys.io.*;
import haxe.io.*;
import haxe.macro.*;
#if nodejs
import sys.io.File;
import js.node.Buffer;
import js.node.http.IncomingMessage;
import js.html.URLSearchParams;
#end
#if (js && !browser && !macro)
import js.lib.Promise;
import fastify.*;
#end
using StringTools;
using Lambda;

typedef AbsolutePath = String;
typedef RelativePath = String;
typedef WebRootPath = String;
typedef Hash = String;
typedef ResourceInfo = {
    hash:Hash,
    size:Int,
    ?width:Int,
    ?height:Int,
    ?color:String,
}

class StaticResource {
    static public final resourcesDir = "static";

    #if (macro || !browser)
    static final hashes = new Map<WebRootPath,Hash>();
    static public function hash(path:WebRootPath):Hash {
        if (!path.startsWith("/")) {
            throw '$path should relative to root (starts with /)';
        }
        return switch (hashes[path]) {
            case null:
                hashes[path] = try {
                    _hash(Path.join([hkssprangers.StaticResource.resourcesDir, path]));
                } catch (e) {
                    null;
                }
            case h:
                h;
        }
    }
    static function _hash(file:AbsolutePath):Hash {
        return haxe.crypto.Md5.make(sys.io.File.getBytes(file)).toHex();
    }
    static public function exists(path:WebRootPath):Bool {
        if (!path.startsWith("/")) {
            throw '$path should relative to root (starts with /)';
        }
        final staticPath = Path.join([resourcesDir, path]);
        return hashes.exists(path) || (FileSystem.exists(staticPath) && !FileSystem.isDirectory(staticPath));
    }
    #end

    #if (js && !browser && !macro)
    static public function hook
    <RouteGeneric, RawServer, RawRequest, RawReply, SchemaCompiler, TypeProvider, ContextConfig, Logger, RequestType, ReplyType>
    (
        req:FastifyRequest<RouteGeneric, RawServer, RawRequest, SchemaCompiler, TypeProvider>,
        reply:FastifyReply<RawServer, RawRequest, RawReply, RouteGeneric, ContextConfig>
    ):Promise<Any> {
        final url = new js.html.URL(req.url, "http://example.com");
        final path = url.pathname.urlDecode();
        // if the file exists (no fingerprint)
        if (StaticResource.exists(path)) {
            // trace(path + ' file requested without fingerprint');
            final actual = StaticResource.hash(path);
            final fpUrl = StaticResource.fingerprint(path, actual);
            reply
                #if production
                .header("Cache-Control", "public, max-age=60, stale-while-revalidate=604800") // max-age: 1 min, stale-while-revalidate: 7 days
                #else
                .header("Cache-Control", "no-store")
                #end
                .redirect(fpUrl);
            return Promise.resolve(null);
        }

        switch (StaticResource.parseUrl(path)) {
            case null:
                // no fingerprint in url
                // pass to the other handlers
                return Promise.resolve();
            case {
                file: file,
                hash: hash,
            }:
                // trace(file);
                final actual = StaticResource.hash(file);
                if (hash == actual) {
                    // trace(path + ' hash matched');
                    return Promise.resolve(untyped reply
                        .header("Cache-Control", "public, max-age=31536000, immutable") // 1 year
                        .sendFile(file)
                    );
                } else {
                    // trace(path + ' hash mismatch');
                    final fpUrl = StaticResource.fingerprint(file, actual);
                    reply
                        #if production
                        .header("Cache-Control", "public, max-age=60, stale-while-revalidate=604800") // max-age: 1 min, stale-while-revalidate: 7 days
                        #else
                        .header("Cache-Control", "no-store")
                        #end
                        .redirect(fpUrl);
                    return Promise.resolve(null);
                }
        }
    }
    #end

    static public function fingerprint(path:WebRootPath, hash:String):String {
        final p = new Path(path);
        return Path.join([p.dir != null && p.dir != "" ? p.dir : "/", p.file.urlEncode() + "." + hash + "." + p.ext]);
    }

    static public function parseUrl(url:String) {
        final p = new Path(url);
        final r = ~/^(.+)\.([0-9a-f]{32})$/;
        return if (!r.match(p.file)) {
            null;
        } else {
            file: Path.join(["/", p.dir, r.matched(1) + "." + p.ext]).urlDecode(),
            hash: r.matched(2),
        }
    }

    #if (!browser)
    static function getImageSize(file:AbsolutePath):{
        width:Int,
        height:Int,
    } {
        switch (Path.extension(file).toLowerCase()) {
            case "png":
                final png = new format.png.Reader(File.read(file));
                return format.png.Tools.getHeader(png.read());
            case _:
                final p = new sys.io.Process("identify", ["-format", '{"width":%w,"height":%h}', file]);
                final out = p.stdout.readAll().toString();
                final err = p.stderr.readAll().toString();
                final exitCode = p.exitCode();
                p.close();
                if (exitCode != 0) {
                    throw err;
                }
                return haxe.Json.parse(out);
        }
    }

    static function getImageColor(file:AbsolutePath):String {
        final p = new sys.io.Process("convert", [file, "-scale", "1x1!", "-format", "%[pixel:u]", "info:-"]);
        final out = p.stdout.readAll().toString();
        final err = p.stderr.readAll().toString();
        final exitCode = p.exitCode();
        p.close();
        if (exitCode != 0) {
            throw err;
        }
        final r = ~/^s(rgba?\(.+\))$/;
        if (!r.match(out)) {
            throw "Cannot parse color: " + out;
        }
        return r.matched(1);
    }

    static function convertImage(src:AbsolutePath, out:AbsolutePath):Void {
        final p = new sys.io.Process("convert", [src, out]);
        final err = p.stderr.readAll().toString();
        final exitCode = p.exitCode();
        p.close();
        if (exitCode != 0) {
            throw err;
        }
    }

    static function preprocessFiles(src:WebRootPath, out:RelativePath, infos:DynamicAccess<ResourceInfo>):Void {
        final cwd:AbsolutePath = Sys.getCwd();
        final resourcesDir:AbsolutePath = Path.join([Sys.getCwd(), hkssprangers.StaticResource.resourcesDir]);
        final absSrc:AbsolutePath = Path.join([resourcesDir, src]);

        if (!FileSystem.isDirectory(absSrc)) {
            final file = Path.withoutDirectory(src);
            final info:ResourceInfo = {
                hash: _hash(absSrc),
                size: FileSystem.stat(absSrc).size,
            };
            final fpFile = fingerprint(file, info.hash);
            final outDir = Path.directory(out);
            

            if (file == ".DS_Store") {
                return;
            }

            File.copy(absSrc, Path.join([cwd, out]));
            File.copy(absSrc, Path.join([cwd, outDir, fpFile]));
            infos[src] = info;

            switch Path.extension(file).toLowerCase() {
                case "jpg" | "jpeg" | "png":
                    final d = getImageSize(absSrc);
                    info.width = d.width;
                    info.height = d.height;
                    info.color = getImageColor(absSrc);

                    final webp:AbsolutePath = Path.join([cwd, outDir, Path.withoutExtension(file) + ".webp"]);
                    convertImage(absSrc, webp);
                    final webpInfo:ResourceInfo = {
                        hash: _hash(webp),
                        size: FileSystem.stat(webp).size,
                        width: info.width,
                        height: info.height,
                        color: info.color,
                    };
                    File.copy(webp, fingerprint(webp, webpInfo.hash));
                    infos[Path.withoutExtension(src) + ".webp"] = webpInfo;
                case _:
                    //pass
            }
            return;
        }

        FileSystem.createDirectory(Path.join([cwd, out]));
        for (item in FileSystem.readDirectory(absSrc)) {
            preprocessFiles(Path.join([src, item]), Path.join([out, item]), infos);
        }
    }

    static function main():Void {
        final out = switch (Sys.args()) {
            case []:
                "staticOut";
            case [out]:
                out;
            case _:
                throw "expect 0-1 args";
        }
        final infos = new DynamicAccess();
        preprocessFiles("/", out, infos);
        File.saveContent("static.json", haxe.Json.stringify(infos, null, "  "));
    }
    #end
}