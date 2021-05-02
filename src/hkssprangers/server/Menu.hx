package hkssprangers.server;

import react.ReactComponent.ReactElement;
import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.server.ServerMain.*;
import hkssprangers.GoogleForms.formUrls;
import hkssprangers.info.Shop;
using hkssprangers.server.FastifyTools;

class Menu extends View {
    public var shop(get, never):Shop;
    function get_shop() return props.shop;

    override public function title() return '${shop.info().name} 埗兵外賣餐牌';
    override public function description() return '${shop.info().name} 埗兵外賣餐牌';
    override function canonical() return host;
    override public function render() {
        return super.render();
    }

    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${Path.join([host, R("/images/ssprangers4-y.png")])} />
        </Fragment>
    ');

    override function bodyContent() {
        return jsx('
            <main className="overflow-hidden">
                <div className="p-6 md:mb-32 md:p-0 mx-auto md:w-4/5 max-w-screen-lg">
                    <div className="my-6 text-center">
                        <a href="/">
                            ${StaticResource.image("/images/logo-blk-png.png", "埗兵", "inline w-1/4 lg:w-1/6")}
                        </a>
                    </div>
                    <div className="border-l-4 border-r-4 border-b-4 border-red-500">
                        <div className="border-t-4 border-b-4 border-red-500 font-bold">
                            <div className="p-3 text-xl md:text-2xl text-center">
                                <h1>
                                    <span className="whitespace-nowrap">${shop.info().name}</span> <span className="whitespace-nowrap">埗兵外賣餐牌</span>
                                </h1>
                            </div>
                        </div>
                        ${renderContent()}
                    </div>
                </div>
                ${Index.orderButton()}
            </main>
        ');
    }

    function renderContent() {
        return switch shop {
            case EightyNine:
                renderEightyNine();
            case DragonJapaneseCuisine:
                null;
            case YearsHK:
                null;
            case TheParkByYears:
                null;
            case LaksaStore:
                null;
            case DongDong:
                null;
            case BiuKeeLokYuen:
                null;
            case KCZenzero:
                null;
            case HanaSoftCream:
                null;
            case Neighbor:
                null;
            case MGY:
                null;
            case FastTasteSSP:
                null;
            case BlaBlaBla:
                null;
            case ZeppelinHotDogSKM:
                null;
        }
    }

    function renderEightyNine() {
        return jsx('
            <div className="p-3">
                <div className="p-3 text-xl bg-pt2 font-bold">
                    套餐: 主菜 + 配菜 + 絲苗白飯2個
                </div>
                <div className="md:flex flex-row md:mt-3">
                    <div className="md:w-1/2 md:pr-3 md:border-r-4 border-red-500">
                        <div className="p-3"><b>主菜選擇</b></div>
                        <div className="flex flex-row">
                            <div className="flex-grow p-3">香茅豬頸肉</div>
                            <div className="p-3">$$85</div>
                        </div>
                        <div className="flex flex-row">
                            <div className="flex-grow p-3">招牌口水雞 (例)</div>
                            <div className="p-3">$$85</div>
                        </div>
                        <div className="flex flex-row">
                            <div className="flex-grow p-3">去骨海南雞 (例)</div>
                            <div className="p-3">$$85</div>
                        </div>
                        <div className="flex flex-row">
                            <div className="flex-grow p-3"><span className="highlight">招牌口水雞 (例) 拼香茅豬頸肉</span></div>
                            <div className="p-3">$$98</div>
                        </div>
                        <div className="flex flex-row">
                            <div className="flex-grow p-3">去骨海南雞 (例) 拼香茅豬頸肉</div>
                            <div className="p-3">$$98</div>
                        </div>              
                    </div>
                    <div className="md:w-1/2 md:ml-3">
                        <div className="p-3"><b>配菜選擇</b></div>
                        <div className="p-3">涼拌青瓜拼木耳</div>
                        <div className="p-3">郊外油菜</div>
                    </div>
                </div>
            </div>
        ');
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        for (shop in Shop.all) {
            app.get("/menu/" + shop, function get(req:Request, reply:Reply):Promise<Dynamic> {
                return Promise.resolve(reply.sendView(Menu, {
                    shop: shop,
                }));
            });
        }
    }
}