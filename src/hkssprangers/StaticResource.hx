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
import js.html.URL;
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
    #if production
    static final infos:DynamicAccess<ResourceInfo> = Json.parse(File.getContent("static.json"));
    static public function info(path:WebRootPath):ResourceInfo {
        if (!path.startsWith("/")) {
            throw '$path should relative to root (starts with /)';
        }
        return infos[path];
    }
    #end
    static function _hash(file:AbsolutePath):Hash {
        return haxe.crypto.Md5.make(sys.io.File.getBytes(file)).toHex();
    }
    static public function exists(path:WebRootPath):Bool {
        if (!path.startsWith("/")) {
            throw '$path should relative to root (starts with /)';
        }
        #if production
        return infos.exists(path);
        #else
        final staticPath = Path.join([resourcesDir, path]);
        return (FileSystem.exists(staticPath) && !FileSystem.isDirectory(staticPath));
        #end
    }
    #end

    #if (js && !browser && !macro)
    static public function hook
    <RouteGeneric, RawServer, RawRequest, RawReply, SchemaCompiler, TypeProvider, ContextConfig, Logger, RequestType, ReplyType>
    (
        req:FastifyRequest<RouteGeneric, RawServer, RawRequest, SchemaCompiler, TypeProvider>,
        reply:FastifyReply<RawServer, RawRequest, RawReply, RouteGeneric, ContextConfig>
    ):Promise<Any> {
        final pathname = new URL(req.url, req.protocol + "://" + req.hostname).pathname;
        if (pathname.startsWith("/font/")) {
            #if !production
            return Promise.resolve(untyped reply
                .header("Cache-Control", "public, max-age=31536000, immutable") // 1 year
                .sendFile(pathname.urlDecode())
            );
            #else
            return Promise.resolve(reply
                .header("Cache-Control", "public, max-age=0, stale-while-revalidate=31536000")
                .redirect(StaticResource.bucketed(pathname, null))
            );
            #end
        }

        if (StaticResource.exists(pathname)) {
            #if !production
            if (
                req.query.bucketed != null
                ||
                pathname == "/favicon.ico"
                ||
                try {
                    new URL(req.headers.referer).pathname.endsWith(".css");
                } catch (err) {
                    trace(err);
                    trace(req.headers);
                    true;
                }
            ) {
                return Promise.resolve(untyped reply
                    .header("Cache-Control", "no-store")
                    .sendFile(pathname)
                );
            } else {
                trace('Requested without `R` or `image`: ${pathname}');
                trace(req.headers);
                return Promise.resolve(reply
                    .header("Cache-Control", "no-store")
                    .status(400)
                    .send("static resource referenced without `R` or `image`")
                );
            }
            #else
            trace('Requested without `R` or `image`: ${pathname}');
            return Promise.resolve(reply
                .header("Cache-Control", "no-store")
                .redirect(StaticResource.bucketed(pathname, StaticResource.info(pathname).hash))
            );
            #end
        }

        return Promise.resolve();
    }
    #end

    static public function fingerprint(path:WebRootPath, hash:String):String {
        final p = new Path(path);
        return Path.join([p.dir != null && p.dir != "" ? p.dir : "/", p.file + "." + hash + "." + p.ext]);
    }

    inline static public final bucketOrigin = "https://d2wv1pgjke9i55.cloudfront.net";

    static public function bucketed(path:WebRootPath, hash:Null<String>):String {
        return if (hash == null)
            Path.join([bucketOrigin, path]);
        else
            Path.join([bucketOrigin, fingerprint(path, hash)]);
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
                final p = new sys.io.Process("identify", ["-format", '{"width":%w,"height":%h}\n', file]);
                final out = p.stdout.readAll().toString();
                final err = p.stderr.readAll().toString();
                final exitCode = p.exitCode();
                p.close();
                if (exitCode != 0) {
                    throw err;
                }
                return try {
                    // for gif, there will be one output per frame
                    // we added "\n" to the output -format, so it's one line per frame
                    haxe.Json.parse(out.split("\n")[0]);
                } catch (err){
                    throw "failed to parse json: " + out;
                }
        }
    }

    static function getImageColor(file:AbsolutePath):String {
        final p = new sys.io.Process("convert", [file, "-scale", "1x1!", "-format", "%[fx:round(255*u.r)],%[fx:round(255*u.g)],%[fx:round(255*u.b)],%[opaque],%[fx:round(u.a*100)/100]\n", "info:-"]);
        final out = p.stdout.readAll().toString();
        final err = p.stderr.readAll().toString();
        final exitCode = p.exitCode();
        p.close();
        if (exitCode != 0) {
            throw err;
        }
        final r = ~/^([0-9]+),([0-9]+),([0-9]+),(.+),([0-9\.]+)?$/;
        // for gif, there will be one output per frame
        // we added "\n" to the output -format, so it's one line per frame
        if (!r.match(out.split("\n")[0])) {
            throw "Cannot parse color: " + out;
        }
        switch(r.matched(4)) {
            case "true": return 'rgb(${r.matched(1)},${r.matched(2)},${r.matched(3)})';
            case "false": return 'rgba(${r.matched(1)},${r.matched(2)},${r.matched(3)},${r.matched(5)})';
            case opaque: throw "cannot parse opaque: " + opaque;
        }
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
            final outDir = Path.directory(out);
            if (src.startsWith("/font/")) {
                File.copy(absSrc, Path.join([cwd, outDir, file]));
                return;
            }

            final fpFile = fingerprint(file, info.hash);

            if (file == ".DS_Store") {
                return;
            }

            if (infos[src] != null) {
                return;
            }

            File.copy(absSrc, Path.join([cwd, outDir, fpFile]));
            infos[src] = info;

            final fileExt = Path.extension(file).toLowerCase();
            switch fileExt {
                case "jpg" | "jpeg" | "png" | "svg" | "gif":
                    final d = getImageSize(absSrc);
                    info.width = d.width;
                    info.height = d.height;
                    info.color = getImageColor(absSrc);
                case _:
                    //pass
            }
            switch fileExt {
                case "jpg" | "jpeg" | "png": // exclude "svg"
                    final webp:AbsolutePath = Path.join([cwd, outDir, Path.withoutExtension(file) + ".webp"]);
                    convertImage(absSrc, webp);
                    final webpInfo:ResourceInfo = {
                        hash: _hash(webp),
                        size: FileSystem.stat(webp).size,
                        width: info.width,
                        height: info.height,
                        color: info.color,
                    };
                    FileSystem.rename(webp, fingerprint(webp, webpInfo.hash));
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
        
        final infoFile = "static.json";
        final infos = if (FileSystem.exists(infoFile)) {
            Json.parse(File.getContent(infoFile));
        } else {
            new DynamicAccess();
        }
        preprocessFiles("/", out, infos);
        File.saveContent(infoFile, haxe.Json.stringify(infos, null, "  "));
    }
    #end
}