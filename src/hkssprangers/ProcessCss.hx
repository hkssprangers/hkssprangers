package hkssprangers;

import hkssprangers.StaticResource.*;
import haxe.io.Path;
import sys.*;
import sys.io.*;
using StringTools;

typedef CssAst = {
    type:String,
}

@:jsRequire("css")
extern class Css {
    static public function parse(css:String, ?opts:Dynamic):CssAst;
    static public function stringify(ast:CssAst, ?opts:Dynamic):String;
}

class ProcessCss {
    static function processCssRules(rules:Array<{type:String}>) {
        for (rule in rules) {
            switch (rule.type) {
                case "rule":
                    var rule:Dynamic = rule;
                    processCssDeclarations(rule.declarations);
                case "media":
                    var media:Dynamic = rule;
                    processCssRules(media.rules);
                case _:
                    //pass
            }
        }
    }
    static function processCssDeclarations(declarations:Array<{type:String}>) {
        var urlValue = ~/^url\((.+)\)$/;
        for (declaration in declarations)
        switch (declaration.type) {
            case "declaration":
                var declaration:Dynamic = declaration;
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
        var css:Dynamic = Css.parse(cssString);
        // trace(haxe.Json.stringify(css, null, "  "));
        processCssRules(css.stylesheet.rules);
        sys.io.File.saveContent(filePath, Css.stringify(css));
    }

    static function main():Void {
        processCss();
    }
}