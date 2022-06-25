package hkssprangers.browser;

import maplibre_gl.*;
import haxe.io.Path;
import js.Browser;
import js.Lib;
import js.html.*;
import js.html.URLSearchParams;
import mui.core.styles.*;
import haxe.*;
import js.Browser.*;
import hkssprangers.info.Shop;
import hkssprangers.info.ShopCluster;
import hkssprangers.CookiePayload;
import hkssprangers.StaticResource.R;
using Lambda;

class BrowserMain {
    static final clusterStyle = [
        DragonCentreCluster => 'rgb(239,68,68)',
        PeiHoStreetMarketCluster => 'rgb(217,119,6)',
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
                initMap(elm);
        }

        switch (document.getElementById("service-area-map")) {
            case null:
                //pass
            case elm:
                initServiceAreaMap(cast elm);
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

    static function initMap(container:Element) {
        final style:Dynamic = Json.parse(CompileTime.readJsonFile("static/map-style.json"));
        final host = Browser.document.location.origin;
        final pmtiles = Path.join(['pmtiles://${host}', R("/tiles/ssp.pmtiles"), "{z}/{x}/{y}"]);
        style.sources.openmaptiles = {
            "type": "vector",
            "tiles": [pmtiles],
            "maxzoom": 14,
        }
        for (l in (style.layers:Array<Dynamic>)) {
            if (Reflect.hasField(l.layout, "text-font"))
                Reflect.setField(l.layout, "text-font", []);
        }
        final shops = Shop.all.filter(s -> s.info().isInService && s.info().lng != null && s.info().lat != null);
        final shopPts = [
            for (info in shops.map(s -> s.info()))
            new LngLat(info.lng, info.lat)
        ];
        final bounds = new LngLatBounds(shopPts[0], shopPts[0]);
        for (pt in shopPts) {
            bounds.extend(pt);
        }
        final maxBounds = new LngLatBounds(new LngLat(114.1307, 22.3111), new LngLat(114.198, 22.347));
        final map = new maplibre_gl.Map_({
            container: container,
            style: style,
            bounds: bounds,
            fitBoundsOptions: {
                padding: 100,
            },
            maxBounds: maxBounds,
        });
        map.scrollZoom.disable();
        map.addControl(cast new maplibre_gl.NavigationControl({
            showZoom: true,
        }));

        for (shop in shops) {
            final info = shop.info();
            final cluster = ShopCluster.classify(shop);
            final popup = new maplibre_gl.Popup({ offset: 25 }).setText(info.name);
            final marker = new maplibre_gl.Marker({ color: clusterStyle[cluster] })
                .setLngLat([info.lng, info.lat])
                .setPopup(popup)
                .addTo(map);
        }
    }

    static function initServiceAreaMap(div:DivElement) {
        render(jsx('
            <MapView />
        '), div);
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

        Lib.require("maplibre-gl").addProtocol("pmtiles", new pmtiles.ProtocolCache().protocol);

        if (document.readyState == 'loading') {
            document.addEventListener('DOMContentLoaded', _ -> onReady());
        } else {
            onReady();
        }
        initSW();
    }
}