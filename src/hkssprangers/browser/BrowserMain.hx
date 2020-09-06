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
        switch (document.getElementById("CustomerView")) {
            case null:
                //pass
            case elm:
                var div:DivElement = cast elm;
                ReactDOM.render(jsx('
                    <CustomerView
                        tgBotName=${div.dataset.tgBotName}
                    />
                '), div);
        }

        switch (document.getElementById("LogInView")) {
            case null:
                //pass
            case elm:
                var div:DivElement = cast elm;
                ReactDOM.render(jsx('
                    <LogInView
                        tgBotName=${div.dataset.tgBotName}
                        user=${Json.parse(div.dataset.user)}
                    />
                '), div);
        }
    }

    static function main():Void {
        new JQuery(onReady);
    }
}