package hkssprangers.server;

import react.*;
import react.Fragment;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.NodeModules;
import hkssprangers.server.ServerMain.*;
import js.lib.Promise;
using Lambda;
using StringTools;
using hkssprangers.server.FastifyTools;

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

    static public function get(req:Request, reply:Reply):Promise<Dynamic> {
        return Promise.resolve(reply.sendView(Map, {}));
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/map", Map.get);
    }
}