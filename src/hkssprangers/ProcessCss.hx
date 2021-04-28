package hkssprangers;

import hkssprangers.StaticResource.*;
import haxe.io.Path;
import sys.*;
import sys.io.*;
using StringTools;

class ProcessCss {
    static function processCssRules(rules:Array<{type:String}>) {
        for (rule in rules) {
            switch (rule.type) {
                case "rule":
                    var rule:css.Rule = cast rule;
                    processCssDeclarations(rule.declarations);
                case "media":
                    var media:css.Media = cast rule;
                    processCssRules(media.rules);
                case _:
                    //pass
            }
        }
    }
    static function processCssDeclarations(declarations:Array<ts.AnyOf2<css.Declaration, css.Comment>>) {
        var urlValue = ~/^url\((.+)\)$/;
        for (declaration in declarations)
        switch ((declaration:Dynamic).type) {
            case "declaration":
                var declaration:css.Declaration = declaration;
                if (urlValue.match(declaration.value)) {
                    var url = urlValue.matched(1);
                    if (!url.startsWith("data:")) {
                        var staticPath = Path.join([resourcesDir, "css", url]);
                        var path = staticPath.substr(resourcesDir.length + 1);
                        if (!FileSystem.exists(staticPath)) {
                            throw '$url does not exist';
                        } else {
                            var h = hash(staticPath);
                            declaration.value = "url(" + hkssprangers.StaticResource.fingerprint(Path.join(["..", path]), h) + ")";
                        }
                    }
                }
            case _:
                // pass
        }
    }
    static public function processCss() {
        var filePath = Path.join([resourcesDir, "css", "style.css"]);
        var cssString = sys.io.File.getContent(filePath);
        var css = Css.parse(cssString);
        // trace(haxe.Json.stringify(css, null, "  "));
        processCssRules(css.stylesheet.rules);
        sys.io.File.saveContent(filePath, Css.stringify(css));
    }

    static function main():Void {
        processCss();
    }
}