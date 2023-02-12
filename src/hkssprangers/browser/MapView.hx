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
import CrossFetch.fetch;
import geojson.*;
import hkssprangers.info.ShopCluster.clusterStyle;
import hkssprangers.StaticResourceMacros.R;
using Lambda;
using StringTools;
using hxLINQ.LINQ;

typedef MapViewProps = {}
typedef MapViewState = {
    final isLoading:Bool;
    final deliveryLocations:Array<DeliveryLocation>;
    final selectedCluster:ShopCluster;
}

class MapView extends ReactComponent<MapViewProps,MapViewState> {
    public function new(props):Void {
        super(props);
        state = {
            isLoading: true,
            deliveryLocations: null,
            selectedCluster: null,
        };
        loadDeliveryLocations();
    }

    function loadDeliveryLocations() {
        fetch("/delivery-locations")
            .then(r -> {
                if (!r.ok) {
                    r.text().then(text -> window.alert(text));
                } else {
                    r.json().then(json -> {
                        final locs:Array<DeliveryLocation> = json;
                        setState({
                            deliveryLocations: locs,
                        });
                    });
                }
            })
            .then(_ -> setState({
                isLoading: false,
            }));
    }

    function controls() {
        final clusterRadios = ShopCluster.all
            // .filter(c -> Shop.all.exists(s -> s.info().isInService && ShopCluster.classify(s).has(c)))
            .map(c -> {
                final control = jsx('<Radio />');
                jsx('
                    <FormControlLabel value=${c} control=${control} label=${c.info().name} />
                ');
            });
        return jsx('
            <div className="absolute top-0 left-0 bg-white/75" >
                <Grid container>
                    <Grid item>
                        <RadioGroup
                            className="mb-1 relative left-3"
                            value=${state.selectedCluster}
                            onChange=${(evt:Event) -> setState({
                                selectedCluster: (cast evt.target).value,
                            })}
                        >
                            ${clusterRadios}
                        </RadioGroup>
                    </Grid>
                </Grid>
            </div>
        ');
    }

    override function render() {
        final style:Dynamic = Json.parse(CompileTime.readJsonFile("static/map-style.json"));
        final pmtiles = 'pmtiles://' + Path.join(
            #if production
            [R("/tiles/ssp.pmtiles"), "{z}/{x}/{y}"]
            #else
            [document.location.origin, R("/tiles/ssp.pmtiles"), "{z}/{x}/{y}"]
            #end
        );
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
            for (info in shopInfos)
            if (state.selectedCluster == null || ShopCluster.classify(info.id).has(state.selectedCluster))
            {
                final cluster = state.selectedCluster != null ? state.selectedCluster : ShopCluster.classify(info.id)[0];
                final classes = clusterStyle[cluster].textClasses.concat(["relative"]);
                jsx('
                    <Marker longitude=${info.lng} latitude=${info.lat} anchor="bottom-left" >
                        <span className=${classes.join(" ")}>
                            <i className="fa-solid fa-location-pin fa-2xl -ml-2 absolute bottom-2 -left-2"></i>
                            <span className="bg-white p-0.5 -ml-2 pl-3">${info.name}</span>
                        </span>
                    </Marker>
                ');
            }
        ];
        final locationSource = switch (state) {
            case { selectedCluster: null } | { deliveryLocations: null }:
                null;
            case { selectedCluster: cluster, deliveryLocations: locs }:
                locs.linq().groupBy(l -> l.fee[cluster])
                    .select((g,i) -> {
                        final data:FeatureCollection<Dynamic, Dynamic> = {
                            type: "FeatureCollection",
                            features: g.linq()
                                .select((loc,i) -> ({
                                    type: "Feature",
                                    geometry: {
                                        type: "Point",
                                        coordinates: [loc.center.lon, loc.center.lat],
                                    },
                                    properties: null,
                                }:Feature<Dynamic, Dynamic>))
                                .toArray(),
                        };
                        final locationsPaint = {
                            'circle-radius': 10,
                            'circle-color': switch (g.key) {
                                case 25: "rgba(0, 255, 0, 0.5)";
                                case 35: "rgba(255, 255, 0, 0.5)";
                                case 40: "rgba(255, 0, 0, 0.5)";
                                case _: "rgba(0, 0, 0, 1)";
                            }
                        };
                        jsx('
                            <Source key=${g.key} id=${"locations-source-" + g.key} type="geojson" data=${data}>
                                <Layer id=${"locations-" + g.key} type="circle" paint=${locationsPaint} />
                            </Source>
                        ');
                    })
                    .toArray();
        }
        return jsx('
            <Fragment>
                <ReactMapGl
                    mapLib=${MaplibreGl}
                    initialViewState=${initialViewState}
                    mapStyle=${style}
                    maxBounds=${maxBounds}
                >
                    ${locationSource}
                    ${markers}
                </ReactMapGl>
                ${controls()}
            </Fragment>
        ');
    }
}