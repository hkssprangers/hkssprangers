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
                        tgBotTokenSha256=${div.dataset.tgBotTokenSha256}
                    />
                '), div);
        }

        switch (document.getElementById("AdminView")) {
            case null:
                //pass
            case elm:
                var div:DivElement = cast elm;
                ReactDOM.render(jsx('
                    <AdminView
                        tgBotName=${div.dataset.tgBotName}
                        tgBotTokenSha256=${div.dataset.tgBotTokenSha256}
                    />
                '), div);
        }
    }

    static function main():Void {
        new JQuery(onReady);
    }
}