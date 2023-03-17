package hkssprangers.server;

import react.ReactComponent.ReactElement;
import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
using hkssprangers.server.FastifyTools;
using Reflect;
using Lambda;

typedef RestaurantsProps = {}

class Restaurants extends View<RestaurantsProps> {
    override public function title() return '合作餐廳';
    override public function description() return '埗兵合作餐廳';
    override function canonical() return Path.join(["https://" + canonicalHost, "restaurants"]);
    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${R("/images/ssprangers4-y.png")} />
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

                    <div className="px-3 py-12 md:py-16 mx-auto container">
                        <div className="md:w-2/3 lg:w-1/2">
                            <h1 className="text-xl md:text-2xl font-bold text-opacity-75 tracking-wider mb-3">合作餐廳</h1>
                            可以同一張單叫晒鄰近嘅餐廳唔限幾多個餐，<span className="whitespace-nowrap">埗兵送埋俾你</span>
                        </div>
                    </div>

                        <div className="p-3 lg:pb-6 mx-auto container">
                            <div className="grid gap-4 md:gap-6 grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
                            ${Index.renderShopp(EightyNine)}
                            ${Index.renderShopp(LaksaStore)}
                            ${Index.renderShopp(KCZenzero)}
                            ${Index.renderShopp(ThaiHome)}
                            ${Index.renderShopp(HanaSoftCream)}
                            ${Index.renderShopp(FishFranSSP)}
                            ${Index.renderShopp(BiuKeeLokYuen)}
                            ${Index.renderShopp(BlackWindow)}
                            ${Index.renderShopp(LoudTeaSSP)}
                            ${Index.renderShopp(TheParkByYears)}
                            ${Index.renderShopp(MGY)}
                            ${Index.renderShopp(PokeGo)}
                            ${Index.renderShopp(Minimal)}
                            ${Index.renderShopp(YearsHK)}
                            ${Index.renderShopp(LonelyPaisley)}
                            ${Index.renderShopp(CafeGolden)}
                            ${Index.renderShopp(HowDrunk)}
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