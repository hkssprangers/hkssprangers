package hkssprangers.server;

import react.ReactComponent.ReactElement;
import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.info.Recipe;
using hkssprangers.server.FastifyTools;
using Reflect;
using Lambda;

typedef RestaurantsProps = {}

class Restaurants extends View<RestaurantsProps> {
    override public function title() return '合作餐廳';
    override public function description() return '歡迎大家一齊挑戰埗兵本地菜食譜';
    override function canonical() return Path.join(["https://" + canonicalHost, "recipe"]);
    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${Path.join(["https://" + hkssprangers.server.ServerMain.host, R("/images/banner-vege-album.jpg")])} />
        </Fragment>
    ');

    override function depScript():ReactElement {
        return jsx('
            <Fragment>
                <script src=${R("/js/map/map.js")}></script>
                <script src=${R("/js/menu/menu.js")}></script>
                ${super.depScript()}
            </Fragment>
        ');
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

    override public function render() {
        return super.render();
    }

    override function bodyContent() {
        return jsx('
            <main>
                ${Index.orderButton()}
                ${View.header()}
                <div className="lg:max-w-screen-2xl mx-auto">

                    <div className="py-12 md:py-16 mx-auto container">
                        <div className="md:w-2/3 lg:w-1/2 px-6 md:px-12">
                            <h1 className="text-xl md:text-2xl font-bold text-opacity-75 tracking-wider mb-3">合作餐廳</h1>
                        </div>
                    </div>

                    <div className="pb-12 md:pb-16 mx-auto container">
                        <div className="mx-6 md:flex border-4 border-black text-center md:text-left">
                            <div className="container-rest md:w-1/3 md:overflow-y-scroll bg-white">
                                <div className="container-rest-caption border-b-4 bg-white border-black px-6 py-3">
                                可以同一張單叫晒鄰近嘅餐廳唔限幾多個餐，<span className="whitespace-nowrap">埗兵送埋俾你</span>
                                </div>
                                ${Index.renderShops()}
                            </div>
                            <div className="md:w-2/3 border-l-4 border-black">
                                <div id="map"></div>
                            </div>
                        </div>
                    </div>

                </div>
            </main>
        ');
    }


    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/restaurants", function get(req:Request, reply:Reply):Promise<Dynamic> {
            return Promise.resolve(reply.sendView(Restaurants, {}));
        });
    }
}