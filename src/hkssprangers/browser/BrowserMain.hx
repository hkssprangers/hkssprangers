package hkssprangers.browser;

import haxe.*;
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
                        user=${div.dataset.user != null ? Json.parse(div.dataset.user) : null}
                    />
                '), div);
        }
    }

    static function main():Void {
        new JQuery(onReady);
    }
}