package hkssprangers;

import sys.*;
import sys.io.File;
import sys.io.Process;
import haxe.io.*;
import haxe.macro.*;
#if nodejs
import sys.io.File;
import js.node.Buffer;
#end
using StringTools;
using Lambda;

class StaticResource {
    static public final resourcesDir = "static";

    static final hashes = new Map<String,String>();
    static public function hash(path:String):String {
        return switch (hashes[path]) {
            case null:
                hashes[path] = try {
                    haxe.crypto.Md5.make(sys.io.File.getBytes(path)).toHex();
                } catch (e) {
                    null;
                }
            case h:
                h;
        }
    }

    macro static public function R(path:String) {
        if (!path.startsWith("/")) {
            Context.error('$path should relative to root (starts with /)', Context.currentPos());
        }

        var staticPath = Path.join([resourcesDir, path]);
        if (!FileSystem.exists(staticPath)) {
            Context.warning('$path does not exist', Context.currentPos());
            return macro @:privateAccess $v{path};
        } else {
            var h = hash(staticPath);
            return macro hkssprangers.StaticResource.fingerprint($v{path}, $v{h});
        }
    };

    macro static public function image(path:String, alt:ExprOf<String>, className:ExprOf<String>) {
        if (!path.startsWith("/")) {
            Context.error('$path should relative to root (starts with /)', Context.currentPos());
        }

        var staticPath = Path.join([resourcesDir, path]);
        if (!FileSystem.exists(staticPath)) {
            throw Context.error('$path does not exist', Context.currentPos());
        } else {
            var h = hash(staticPath);
            var path = hkssprangers.StaticResource.fingerprint(path, h);
            var header:{
                width:Int,
                height:Int,
            } = switch (Path.extension(staticPath).toLowerCase()) {
                case "png":
                    var png = new format.png.Reader(File.read(staticPath));
                    format.png.Tools.getHeader(png.read());
                case _:
                    var p = new sys.io.Process("identify", ["-format", '{"width":%w,"height":%h}', staticPath]);
                    if (p.exitCode() != 0) {
                        Context.error(p.stderr.readAll().toString(), Context.currentPos());
                    }
                    var out = p.stdout.readAll().toString();
                    p.close();
                    haxe.Json.parse(out);
            }
            return macro {
                var className = ${className};
                var alt = ${alt};
                var header = $v{header};
                var path = $v{path};
                jsx('<img alt=${alt} className=${className} width=${header.width} height=${header.height} src=${path} />');
            }
        }
    }

    static public function fingerprint(path:String, hash:String):String {
        var p = new Path(path);
        return Path.join([p.dir, p.file + "." + hash + "." + p.ext]);
    }

    static public function parseUrl(url:String) {
        var p = new Path(url);
        var r = ~/^(.+)\.(.{32})$/;
        return if (!r.match(p.file)) {
            url: url,
            hash: null,
        } else {
            url: Path.join([p.dir, r.matched(1) + "." + p.ext]) + "?md5=" + r.matched(2),
            hash: r.matched(2),
        }
    }

    static public function rewriteUrl(url:String):String {
        return parseUrl(url).url;
    }
}