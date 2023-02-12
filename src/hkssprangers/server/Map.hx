package hkssprangers.server;

import react.*;
import react.Fragment;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.NodeModules;
import hkssprangers.server.ServerMain.*;
import hkssprangers.DeliveryFee;
import hkssprangers.Osm;
import hkssprangers.info.*;
import js.lib.Promise;
using Lambda;
using StringTools;
using hkssprangers.server.FastifyTools;
using hxLINQ.LINQ;

typedef MapProps = {}

class Map extends View<MapProps> {
    override function title():String return "埗兵服務範圍";
    override public function description() return "埗兵服務範圍地圖";
    override function canonical() return Path.join(["https://" + canonicalHost, "map"]);
    override public function render() {
        return super.render();
    }

    override function depCss():ReactElement {
        final maplibreGlCssUrl = 'https://cdn.jsdelivr.net/npm/maplibre-gl@${NodeModules.lockedVersion("maplibre-gl")}/dist/maplibre-gl.css';
        return jsx('
            <Fragment>
                <link rel="stylesheet" href=${maplibreGlCssUrl} crossOrigin="anonymous"/>
                ${super.depCss()}
            </Fragment>
        ');
    }

    override function bodyContent() {
        return jsx('
            <div id="service-area-map" className="w-full h-screen" />
        ');
    }

    static function get(req:Request, reply:Reply):Promise<Dynamic> {
        return Promise.resolve(reply.sendView(Map, {}));
    }

    static function getDeliveryLocations(req:Request, reply:Reply):Promise<Dynamic> {
        final osmData:OsmResult = haxe.Json.parse(sys.io.File.getContent("deliveryLocations.json"));
        final ele = [
            for (e in osmData.elements)
            Osm.printRef(e) => e
        ];
        final locs:Array<DeliveryLocation> = DeliveryFee.heuristics.linq()
            .selectMany((h,i) -> h.osm.map(o -> {
                name: h.place,
                osm: o.url,
                center: Osm.getCenter(ele[Osm.printRef(Osm.parseUrl(o.url))]),
                fee: {
                    final map:DynamicAccess<Float> = {};
                    for (c in ShopCluster.all) {
                        map[c] = h.deliveryFee(c);
                    }
                    map;
                },
            }))
            .toArray();
        return Promise.resolve(reply.send(locs));
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/map", Map.get);
        app.get("/delivery-locations", Map.getDeliveryLocations);
    }
}