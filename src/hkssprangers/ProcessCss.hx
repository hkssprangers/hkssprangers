package hkssprangers;

import js.Node;
import hkssprangers.StaticResource.*;
import haxe.io.Path;
import sys.*;
import sys.io.*;
using StringTools;

@:jsRequire("rework")
extern class Rework {
    @:selfCall
    static public function call(css:String, ?options:Dynamic):Rework;

    public function use(fn:haxe.Constraints.Function):Rework;

    public function toString(?options:Dynamic):String;
}

class ProcessCss {
    static public function processCss() {
        final filePath = Path.join([resourcesDir, "css", "style.css"]);
        final cssString = sys.io.File.getContent(filePath);

        final processed = Rework.call(cssString)
            .use(Node.require("rework-plugin-url")(function(url:String):String {
                if (url.startsWith("data:"))
                    return url;
                final staticPath = Path.join([resourcesDir, "css", url]);
                final path = staticPath.substr(resourcesDir.length + 1);
                if (!FileSystem.exists(staticPath)) {
                    throw '$url does not exist';
                } else {
                    final h = hash(staticPath);
                    return hkssprangers.StaticResource.fingerprint(Path.join(["..", path]), h);
                }
            }))
            .toString();
        sys.io.File.saveContent(filePath, processed);
    }

    static function main():Void {
        processCss();
    }
}