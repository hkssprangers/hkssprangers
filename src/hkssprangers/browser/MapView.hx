package hkssprangers.browser;

import js.Browser;
import maplibre_gl.*;
import haxe.io.Path;
import js.html.*;
import mui.core.*;
import js.npm.react_map_gl.Map as ReactMapGl;
import js.npm.react_map_gl.Map;
import hkssprangers.info.*;
import js.Browser.*;
import hkssprangers.info.ShopCluster.clusterStyle;
import hkssprangers.StaticResource.R;
using Lambda;
using StringTools;

typedef MapViewProps = {}

class MapView extends ReactComponentOfProps<MapViewProps> {
    override function render() {
        final style:Dynamic = Json.parse(CompileTime.readJsonFile("static/map-style.json"));
        final host = document.location.origin;
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
        final shopInfos = Shop.all
            .map(s -> s.info())
            .filter(info -> info.isInService);
        final shopPts = [
            for (info in shopInfos)
            if (info.lng != null && info.lat != null)
            new LngLat(info.lng, info.lat)
        ];
        final bounds = new LngLatBounds(shopPts[0], shopPts[0]);
        for (pt in shopPts) {
            bounds.extend(pt);
        }
        final maxBounds = new LngLatBounds(new LngLat(114.1307, 22.3111), new LngLat(114.198, 22.347));
        final initialViewState = {
            bounds: bounds,
            fitBoundsOptions: {
                padding: 100,
            },
        }
        final markers = [
            for (info in shopInfos) {
                final cluster = ShopCluster.classify(info.id);
                final classes = clusterStyle[cluster].textClasses;
                jsx('
                    <Marker longitude=${info.lng} latitude=${info.lat} anchor="bottom" >
                        <span className=${classes}>
                            <i className="fa-solid fa-location-dot fa-2xl"></i>
                        </span>
                    </Marker>
                ');
            }
        ];
        return jsx('
            <ReactMapGl
                mapLib=${MaplibreGl}
                initialViewState=${initialViewState}
                mapStyle=${style}
                maxBounds=${maxBounds}
            >
                ${markers}
            </ReactMapGl>
        ');
    }
}