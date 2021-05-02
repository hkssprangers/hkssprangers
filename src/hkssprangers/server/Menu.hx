package hkssprangers.server;

import hkssprangers.info.MenuTools;
import react.ReactComponent.ReactElement;
import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.server.ServerMain.*;
import hkssprangers.info.menu.*;
import hkssprangers.info.Shop;
using hkssprangers.server.FastifyTools;
using Reflect;

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

    function renderItems(items:Array<String>) {
        return [
            for (item in items)
            renderItemRow(item)
        ];
    }

    function renderItemRow(item:String) {
        var parsed = MenuTools.parsePrice(item);
        return if (parsed.price != null) jsx('
            <div key=${item} className="flex flex-row">
                <div className="flex-grow p-3">${parsed.item}</div>
                <div className="p-3">$$${parsed.price}</div>
            </div>
        ') else jsx('
            <div key=${item} className="p-3">${parsed.item}</div>
        ');
    }

    function renderEightyNine() {
        return jsx('
            <div className="p-3">
                <div className="p-3 text-xl bg-pt2 font-bold">
                ${EightyNineMenu.EightyNineSet.title}: ${EightyNineMenu.EightyNineSet.description}
                </div>
                <div className="md:flex flex-row md:mt-3">
                    <div className="md:w-1/2 md:pr-3 md:border-r-4 border-red-500">
                        <div className="p-3"><b>${EightyNineMenu.EightyNineSet.properties.main.title}</b></div>
                        ${renderItems(EightyNineMenu.EightyNineSet.properties.main.field("enum"))}
                    </div>
                    <div className="md:w-1/2 md:ml-3">
                        <div className="p-3"><b>${EightyNineMenu.EightyNineSet.properties.sub.title}</b></div>
                        ${renderItems(EightyNineMenu.EightyNineSet.properties.sub.field("enum"))}
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