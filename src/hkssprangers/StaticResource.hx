package hkssprangers;

import sys.*;
import sys.io.*;
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

    #if (macro || !browser)
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
    #end

    macro static public function R(path:String, ?warnIfNotFound:Bool = true) {
        if (!path.startsWith("/")) {
            Context.error('$path should relative to root (starts with /)', Context.currentPos());
        }

        var staticPath = Path.join([resourcesDir, path]);
        if (!FileSystem.exists(staticPath)) {
            if (warnIfNotFound) {
                Context.warning('$path does not exist', Context.currentPos());
            }
            return macro @:privateAccess $v{path};
        } else {
            var h = hash(staticPath);
            return macro hkssprangers.StaticResource.fingerprint($v{path}, $v{h});
        }
    };

    macro static public function image(path:String, alt:ExprOf<String>, className:ExprOf<String>, ?useBackgroudColor:Bool = null) {
        if (!path.startsWith("/")) {
            Context.error('$path should relative to root (starts with /)', Context.currentPos());
        }

        var staticPath = Path.join([resourcesDir, path]);
        if (!FileSystem.exists(staticPath)) {
            throw Context.error('$path does not exist', Context.currentPos());
        } else {
            var h = hash(staticPath);
            var fpPath = hkssprangers.StaticResource.fingerprint(path, h);
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
            var useBackgroudColor = if (useBackgroudColor != null) {
                useBackgroudColor;
            } else {
                var p = new sys.io.Process("identify", ["-format", "%[opaque]", staticPath]);
                if (p.exitCode() != 0) {
                    Context.error(p.stderr.readAll().toString(), Context.currentPos());
                }
                var out = p.stdout.readAll().toString();
                p.close();
                haxe.Json.parse(out);
            }
            var bg = if (useBackgroudColor) {
                var p = new sys.io.Process("convert", [staticPath, "-scale", "1x1!", "-format", "%[pixel:u]", "info:-"]);
                if (p.exitCode() != 0) {
                    Context.error(p.stderr.readAll().toString(), Context.currentPos());
                }
                var out = p.stdout.readAll().toString();
                p.close();
                var r = ~/^s(rgba?\(.+\))$/;
                if (!r.match(out)) {
                    Context.error("Cannot parse color: " + out, Context.currentPos());
                }
                r.matched(1);
            } else {
                null;
            }
            function createWebp() {
                function newPath(path:String):String {
                    var path = new Path(path);
                    path.ext = "webp";
                    return path.toString();
                }
                var webpStaticPath = newPath(staticPath);
                if (!FileSystem.exists(webpStaticPath)) {
                    var p = new sys.io.Process("convert", [staticPath, webpStaticPath]);
                    if (p.exitCode() != 0) {
                        Context.error(p.stderr.readAll().toString(), Context.currentPos());
                    }
                    p.close();
                }
                return if (FileSystem.stat(webpStaticPath).size < FileSystem.stat(staticPath).size) {
                    var webpPath = newPath(path);
                    hkssprangers.StaticResource.fingerprint(webpPath, hash(webpStaticPath));
                } else {
                    null;
                }
            }
            var webp = createWebp();
            return if (bg != null) macro {
                var className = ${className};
                var alt = ${alt};
                var header = $v{header};
                var webp = $v{webp};
                var webpSource = webp != null ? jsx('<source srcSet=${webp} type="image/webp" />') : null;
                var fpPath = $v{fpPath};
                var bg = $v{bg};
                jsx('
                    <picture>
                        ${webpSource}
                        <source srcSet=${fpPath} />
                        <img alt=${alt} className=${className} width=${header.width} height=${header.height} src=${fpPath} style=${{backgroundColor: bg}} />
                    </picture>
                ');
            } else macro {
                var className = ${className};
                var alt = ${alt};
                var header = $v{header};
                var webp = $v{webp};
                var webpSource = webp != null ? jsx('<source srcSet=${webp} type="image/webp" />') : null;
                var fpPath = $v{fpPath};
                jsx('
                    <picture>
                        ${webpSource}
                        <source srcSet=${fpPath} />
                        <img alt=${alt} className=${className} width=${header.width} height=${header.height} src=${fpPath} />
                    </picture>
                ');
            }
        }
    }

    static public function fingerprint(path:String, hash:String):String {
        var p = new Path(path);
        return Path.join([p.dir != null && p.dir != "" ? p.dir : "/", p.file + "." + hash + "." + p.ext]);
    }

    static public function parseUrl(url:String) {
        var p = new Path(url);
        var r = ~/^(.+)\.([0-9a-f]{32})$/;
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