package hkssprangers.browser;

import haxe.*;
import react.*;
import react.ReactMacro.jsx;
import js.html.DivElement;
import js.jquery.*;
import js.Browser.*;
import charleywong.browser.*;

class BrowserMain {
    static function onReady():Void {
        
    }

    static function main():Void {
        new JQuery(onReady);
    }
}