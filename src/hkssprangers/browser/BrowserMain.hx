package hkssprangers.browser;

import js.html.URLSearchParams;
import mui.core.styles.*;
import haxe.*;
import js.html.DivElement;
import js.Browser.*;
import hkssprangers.CookiePayload;
import hkssprangers.StaticResource.R;

class BrowserMain {
    static public final theme = MuiTheme.createMuiTheme({
        typography: {
            fontFamily: "'Noto Sans HK', sans-serif",
        },
        palette: {
            secondary: {
                main: "#FBBF24",
            },
        },
    });

    static function render(e:ReactFragment, div:DivElement) {
        ReactDOM.render(jsx('
            <BrowserRouter>
                <MuiThemeProvider theme=${theme}>
                    ${e}
                </MuiThemeProvider>
            </BrowserRouter>
        '), div);
    }

    static function onReady():Void {
        switch (document.getElementById("OrderView")) {
            case null:
                //pass
            case elm:
                var div:DivElement = cast elm;
                render(jsx('
                    <OrderView
                        tgBotName=${div.dataset.tgBotName}
                        user=${Json.parse(div.dataset.user)}
                        prefill=${Json.parse(div.dataset.prefill)}
                        currentTime=${div.dataset.currentTime}
                    />
                '), div);
        }

        switch (document.getElementById("LogInView")) {
            case null:
                //pass
            case elm:
                var div:DivElement = cast elm;
                render(jsx('
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
                render(jsx('
                    <AdminView
                        tgBotName=${div.dataset.tgBotName}
                        user=${div.dataset.user != null ? Json.parse(div.dataset.user) : null}
                    />
                '), div);
        }
    }

    static function initSW() {
        if (navigator.serviceWorker != null) {
            trace("Register service worker");
            navigator.serviceWorker.register(R("/serviceWorker.bundled.js"))
                .then(reg -> {
                    trace('Registration succeeded. Scope is ' + reg.scope);
                })
                .catchError(err -> {
                    console.log('Registration failed with ' + err);
                });
        }
    }

    static public final auth:Null<JsonString<CookiePayload>> = cast new URLSearchParams(window.location.search).get("auth");
    static public final deployStage:DeployStage = document.currentScript.dataset.deployStage;

    static function main():Void {
        if (auth != null) {
            // safe auth in cookie
            try {
                JsCookie.value.set("auth", auth, {
                    secure: true,
                    sameSite: 'strict',
                    expires: 1, // days
                });
            } catch (err) {
                console.error(err);
            }

            // hide auth from address bar and from history to be safe
            try {
                window.history.replaceState(null, "", window.location.origin + window.location.pathname);
            } catch (err) {
                console.error(err);
            }
        }

        if (document.readyState == 'loading') {
            document.addEventListener('DOMContentLoaded', _ -> onReady());
        } else {
            onReady();
        }
        initSW();
    }
}