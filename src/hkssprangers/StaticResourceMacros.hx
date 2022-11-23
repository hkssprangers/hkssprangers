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
#if server
import fastify.*;
#end
using StringTools;
using Lambda;

import hkssprangers.StaticResource.*;

class StaticResourceMacros {
    macro static public function R(path:String, ?warnIfNotFound:Bool = true) {
        if (!path.startsWith("/")) {
            Context.error('$path should relative to root (starts with /)', Context.currentPos());
        }

        if (!exists(path)) {
            if (warnIfNotFound) {
                Context.warning('$path does not exist', Context.currentPos());
            }
            return macro @:privateAccess $v{path};
        }

        #if (!production)
        return macro @:privateAccess $v{path};
        #end

        final h = hash(path);
        return macro @:privateAccess hkssprangers.StaticResource.fingerprint($v{path}, $v{h});
    };

    macro static public function image(path:String, alt:ExprOf<String>, className:ExprOf<String>, ?itemProp:String, ?useBackgroudColor:Bool = null) {
        if (!path.startsWith("/")) {
            Context.error('$path should relative to root (starts with /)', Context.currentPos());
        }

        if (!exists(path)) {
            Context.error('$path does not exist', Context.currentPos());
        }

        final itemPropAttr = itemProp != null ? macro { itemProp: $v{itemProp} } : macro {};

        #if (!production)
        return macro {
            final className = ${className};
            final alt = ${alt};
            final itemPropAttr = ${itemPropAttr};
            final path = $v{path};
            jsx('
                <picture>
                    <img alt=${alt} className=${className} src=${path} {...itemPropAttr} />
                </picture>
            ');
        };
        #end

        final staticPath = Path.join([resourcesDir, path]);
        final h = hash(path);
        final fpPath = hkssprangers.StaticResource.fingerprint(path, h);
        final header:{
            width:Int,
            height:Int,
        } = switch (Path.extension(staticPath).toLowerCase()) {
            case "png":
                final png = new format.png.Reader(File.read(staticPath));
                format.png.Tools.getHeader(png.read());
            case _:
                final p = new sys.io.Process("identify", ["-format", '{"width":%w,"height":%h}', staticPath]);
                if (p.exitCode() != 0) {
                    Context.error(p.stderr.readAll().toString(), Context.currentPos());
                }
                final out = p.stdout.readAll().toString();
                p.close();
                haxe.Json.parse(out);
        }
        final useBackgroudColor = if (useBackgroudColor != null) {
            useBackgroudColor;
        } else {
            final p = new sys.io.Process("identify", ["-format", "%[opaque]", staticPath]);
            if (p.exitCode() != 0) {
                Context.error(p.stderr.readAll().toString(), Context.currentPos());
            }
            final out = p.stdout.readAll().toString();
            p.close();
            haxe.Json.parse(out);
        }
        final bg = if (useBackgroudColor) {
            final p = new sys.io.Process("convert", [staticPath, "-scale", "1x1!", "-format", "%[pixel:u]", "info:-"]);
            if (p.exitCode() != 0) {
                Context.error(p.stderr.readAll().toString(), Context.currentPos());
            }
            final out = p.stdout.readAll().toString();
            p.close();
            final r = ~/^s(rgba?\(.+\))$/;
            if (!r.match(out)) {
                Context.error("Cannot parse color: " + out, Context.currentPos());
            }
            r.matched(1);
        } else {
            null;
        }
        function createWebp() {
            function newPath(path:String):String {
                final path = new Path(path);
                path.ext = "webp";
                return path.toString();
            }
            final webpStaticPath = newPath(staticPath);
            if (!FileSystem.exists(webpStaticPath)) {
                final p = new sys.io.Process("convert", [staticPath, webpStaticPath]);
                if (p.exitCode() != 0) {
                    Context.error(p.stderr.readAll().toString(), Context.currentPos());
                }
                p.close();
            }
            return if (FileSystem.stat(webpStaticPath).size < FileSystem.stat(staticPath).size) {
                final webpPath = newPath(path);
                hkssprangers.StaticResource.fingerprint(webpPath, hash(webpPath));
            } else {
                null;
            }
        }
        final webp = createWebp();
        return if (bg != null) macro {
            final className = ${className};
            final alt = ${alt};
            final header = $v{header};
            final webp = $v{webp};
            final webpSource = webp != null ? jsx('<source srcSet=${webp} type="image/webp" />') : null;
            final fpPath = $v{fpPath};
            final bg = $v{bg};
            final itemPropAttr = ${itemPropAttr};
            jsx('
                <picture>
                    ${webpSource}
                    <source srcSet=${fpPath} />
                    <img alt=${alt} className=${className} width=${header.width} height=${header.height} src=${fpPath} style=${{backgroundColor: bg}} {...itemPropAttr} />
                </picture>
            ');
        } else macro {
            final className = ${className};
            final alt = ${alt};
            final header = $v{header};
            final webp = $v{webp};
            final webpSource = webp != null ? jsx('<source srcSet=${webp} type="image/webp" />') : null;
            final fpPath = $v{fpPath};
            final itemPropAttr = ${itemPropAttr};
            jsx('
                <picture>
                    ${webpSource}
                    <source srcSet=${fpPath} />
                    <img alt=${alt} className=${className} width=${header.width} height=${header.height} src=${fpPath} {...itemPropAttr} />
                </picture>
            ');
        }
    }
}
