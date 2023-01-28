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
    macro static public function R(path:String) {
        if (!path.startsWith("/")) {
            Context.error('$path should relative to root (starts with /)', Context.currentPos());
        }

        if (!exists(path)) {
            Context.error('$path does not exist', Context.currentPos());
            return macro $v{path};
        }

        #if (!production)
        return macro $v{path + "?bucketed=1"};
        #else
        final h = info(path).hash;
        return macro @:privateAccess hkssprangers.StaticResource.bucketed($v{path}, $v{h});
        #end
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
            final path = $v{path + "?bucketed=1"};
            jsx('
                <picture>
                    <img alt=${alt} className=${className} src=${path} {...itemPropAttr} />
                </picture>
            ');
        };
        #else
        final staticPath = Path.join([resourcesDir, path]);
        final info = hkssprangers.StaticResource.info(path);
        final fpPath = hkssprangers.StaticResource.bucketed(path, info.hash);
        final header:{
            width:Int,
            height:Int,
        } = {
            width: info.width,
            height: info.height,
        }
        final useBackgroudColor = if (useBackgroudColor != null) {
            useBackgroudColor;
        } else {
            !info.color.startsWith("rgba");
        }
        final bg = if (useBackgroudColor) {
            info.color;
        } else {
            null;
        }
        final webp = {
            final path = new Path(path);
            path.ext = "webp";
            final webpPath = path.toString();
            final webpInfo = hkssprangers.StaticResource.info(webpPath);
            if (webpInfo == null) {
                null;
            } else {
                hkssprangers.StaticResource.bucketed(webpPath, webpInfo.hash);
            }
        }
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
        #end
    }
}
