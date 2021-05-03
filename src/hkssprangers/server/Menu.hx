package hkssprangers.server;

import react.ReactComponent.ReactElement;
import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.server.ServerMain.*;
import hkssprangers.info.menu.EightyNineMenu.*;
import hkssprangers.info.menu.KCZenzeroMenu.*;
import hkssprangers.info.Shop;
using hkssprangers.server.FastifyTools;
using hkssprangers.info.MenuTools;
using Reflect;
using Lambda;

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
                renderKCZenzero();
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

    static function slashes(items:Array<String>) return items
        .map(item -> jsx('<span key=${item} className="whitespace-nowrap">${item}</span>'))
        .fold(
            function(item:ReactElement, result:ReactElement):ReactElement {
                return if (result == null) {
                    item;
                } else {
                    jsx('
                        <Fragment>
                            ${result} / ${item}
                        </Fragment>
                    ');
                }
            },
            null
        );

    function renderEightyNine() {
        return jsx('
            <div className="p-3">
                <div className="p-3 text-xl bg-pt2 font-bold">
                ${EightyNineSet.title}: ${EightyNineSet.description}
                </div>
                <div className="md:flex flex-row md:mt-3">
                    <div className="md:w-1/2 md:pr-3 md:border-r-4 border-red-500">
                        <div className="p-3"><b>${EightyNineSet.properties.main.title}</b></div>
                        ${renderItems(EightyNineSet.properties.main.field("enum"))}
                    </div>
                    <div className="md:w-1/2 md:ml-3">
                        <div className="p-3"><b>${EightyNineSet.properties.sub.title}</b></div>
                        ${renderItems(EightyNineSet.properties.sub.field("enum"))}
                    </div>
                </div>
            </div>
        ');
    }

    function renderKCZenzero() {
        var hotdogSet = KCZenzeroHotdogSet(Lunch);
        var noodleSet = KCZenzeroNoodleSet(Lunch);
        var pastaSet = KCZenzeroPastaSet(Lunch);
        
        return jsx('
            <div className="md:flex flex-row">
                <div className="p-3 md:w-1/2 md:border-r-4 border-red-500">
                    <div className="flex flex-row text-xl bg-pt2 font-bold">
                        <div className="flex-grow p-3">${hotdogSet.title}</div>
                        <div className="p-3">${hotdogSet.description}</div>
                    </div>
                    ${renderItems(hotdogSet.properties.main.field("enum"))}

                    <div className="flex flex-row text-xl bg-pt2 font-bold">
                        <div className="flex-grow p-3">${KCZenzeroLightSet.title}</div>
                        <div className="p-3">$$${MenuTools.parsePrice(KCZenzeroLightSet.description).price}</div>
                    </div>
                    <div className="p-3 font-bold">${KCZenzeroLightSet.properties.main.title}選擇</div>
                    <div className="p-3">${slashes(KCZenzeroLightSet.properties.main.enums())}</div>
                    <div className="p-3 font-bold">${KCZenzeroLightSet.properties.salad.title}選擇</div>
                    <div className="p-3">${slashes(KCZenzeroLightSet.properties.salad.enums())}</div>
                    <div className="font-bold p-3">${KCZenzeroLightSet.properties.drink.title}選擇</div>
                    <div className="p-3">${slashes(KCZenzeroLightSet.properties.drink.enums())}</div>

                    <div className="flex flex-row text-xl bg-pt2 font-bold">
                        <div className="p-3">${KCZenzeroRiceSet.title}</div>
                    </div>
                    ${renderItems(KCZenzeroRiceSet.properties.main.enums())}
                </div>
                <div className="p-3 md:w-1/2">
                    <div className="flex flex-row text-xl bg-pt2 font-bold">
                        <div className="flex-grow p-3">${noodleSet.title}</div>
                        <div className="p-3">$$${noodleSet.description.parsePrice().price}</div>
                    </div>
                    <div className="p-3"><b>${noodleSet.properties.options.title}選擇</b> ${noodleSet.properties.options.description}</div>
                    <div className="p-3">
                        ${slashes(noodleSet.properties.options.items.enums())}
                    </div>

                    <div className="font-bold p-3">${noodleSet.properties.noodle.title}選擇</div>
                    <div className="p-3">${slashes(noodleSet.properties.noodle.enums())}</div>

                    <div className="flex flex-row text-xl bg-pt2 font-bold">
                        <div className="flex-grow p-3">${pastaSet.title}</div>
                        <div className="p-3">$$${pastaSet.description.parsePrice().price}</div>
                    </div>
                    <div className="p-3 font-bold">${pastaSet.properties.main.title}選擇</div>
                    <div className="p-3">${slashes(pastaSet.properties.main.enums())}</div>
                    <div className="p-3 font-bold">${pastaSet.properties.sauce.title}選擇</div>
                    <div className="p-3">${slashes(pastaSet.properties.sauce.enums())}</div>
                    <div className="p-3 font-bold">${pastaSet.properties.noodle.title}選擇</div>
                    <div className="p-3">${slashes(pastaSet.properties.noodle.enums())}</div>

                    <div className="flex flex-row text-xl bg-pt2 font-bold">
                        <div className="p-3">${KCZenzeroSingle.title}</div>
                    </div>
                    ${renderItems(KCZenzeroSingle.enums())}
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