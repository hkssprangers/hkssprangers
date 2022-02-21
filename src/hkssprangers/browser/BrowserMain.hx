package hkssprangers.browser;

import js.html.URLSearchParams;
import mui.core.styles.*;
import haxe.*;
import js.html.DivElement;
import js.Browser.*;
import hkssprangers.info.Shop;
import hkssprangers.info.ShopCluster;
import hkssprangers.CookiePayload;
import hkssprangers.StaticResource.R;

class BrowserMain {
    static final clusterStyle = [
        DragonCentreCluster => 'rgb(239,68,68)',
        CLPCluster => 'rgb(52, 211, 153)',
        GoldenCluster => 'rgb(236, 72, 153)',
        SmilingPlazaCluster => 'rgb(245, 158, 11)',
        ParkCluster => 'rgb(5, 150, 105)',
        PakTinCluster => 'rgb(59, 130, 246)',
        TungChauStreetParkCluster => 'rgb(99, 102, 241)'
    ];

    static public final theme = MuiTheme.createMuiTheme({
        typography: {
            fontFamily: "'Noto Sans HK', sans-serif",
        },
        palette: {
            secondary: {
                main: "#FBBF24",
            },
        },
        overrides: {
            MuiSelect: {
                selectMenu: {
                    whiteSpace: "normal",
                },
            },
            MuiMenuItem: {
                root: {
                    whiteSpace: "normal",
                },
            },
        }
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
        switch (document.getElementById("splide")) {
            case null:
                //pass
            case elm:
                var div:DivElement = cast elm;
                ReactDOM.hydrate(jsx('
                    <IndexSplide />
                '), div);
        }
    
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

        switch (document.getElementById("map")) {
            case null:
                //pass
            case elm:
                initMap();
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

    static final mapboxAccessToken = "pk.eyJ1Ijoib250aGV3aW5ncyIsImEiOiJja3p3ZTBjbW0wNWs3Mm5waDBkbG41YjhrIn0.XOF0xjYbJpIXS--nugUSWg";
    static function initMap() {
        MapboxGl.accessToken = mapboxAccessToken;
        final map = new mapbox_gl.Map_({
            container: 'map', // container ID
            style: 'mapbox://styles/onthewings/ckzwgjip4004215oce0zc5ola', // style URL
            center: [114.16025186047068, 22.33114444434112], // starting position [lng, lat]
            zoom: 15 // starting zoom
        });
        map.scrollZoom.disable();
        map.addControl(new mapbox_gl.NavigationControl());

        for (shop in Shop.all) {
            final info = shop.info();
            final cluster = ShopCluster.classify(shop);
            final popup = new mapbox_gl.Popup({ offset: 25 }).setText(info.name);
            final marker = new mapbox_gl.Marker({ color: clusterStyle[cluster] })
                .setLngLat([info.lng, info.lat])
                .setPopup(popup)
                .addTo(map);
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