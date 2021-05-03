package hkssprangers.server;

import react.ReactComponent.ReactElement;
import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.server.ServerMain.*;
import hkssprangers.info.menu.EightyNineMenu.*;
import hkssprangers.info.menu.DragonJapaneseCuisineMenu.*;
import hkssprangers.info.menu.KCZenzeroMenu.*;
import hkssprangers.info.menu.YearsHKMenu.*;
import hkssprangers.info.menu.TheParkByYearsMenu.*;
import hkssprangers.info.menu.LaksaStoreMenu.*;
import hkssprangers.info.menu.DongDongMenu.*;
import hkssprangers.info.Shop;
import hkssprangers.info.ShopCluster;
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

    static final clusterStyle = [
        DragonCentreCluster => {
            borderClasses: ["border-red-500"],
            headerClasses: ["bg-pt2-red-500"],
            boxClasses: ["bg-slash-red-500"],
        },
        CLPCluster => {
            borderClasses: ["border-green-400"],
            headerClasses: ["bg-pt2-green-400"],
            boxClasses: [],
        },
        GoldenCluster => {
            borderClasses: ["border-pink-500"],
            headerClasses: ["bg-pt2-pink-500"],
            boxClasses: ["bg-slash-pink-500"],
        },
        SmilingPlazaCluster => {
            borderClasses: ["border-yellow-600"],
            headerClasses: ["bg-pt2-yellow-600"],
            boxClasses: ["bg-slash-yellow-600"],
        },
        ParkCluster => {
            borderClasses: ["border-green-600"],
            headerClasses: ["bg-pt2-green-600"],
            boxClasses: [],
        },
        PakTinCluster => {
            borderClasses: ["border-blue-500"],
            headerClasses: ["bg-pt2-blue-500"],
            boxClasses: [],
        },
    ];

    final style:{
        borderClasses:Array<String>,
        headerClasses:Array<String>,
        boxClasses:Array<String>,
    };
    
    function new(props, context) {
        super(props, context);
        style = clusterStyle[ShopCluster.classify(shop)];
    }

    override function bodyContent() {
        return jsx('
            <main className="overflow-hidden">
                <div className="p-6 md:mb-32 md:p-0 mx-auto md:w-4/5 max-w-screen-lg">
                    <div className="my-6 text-center">
                        <a href="/">
                            ${StaticResource.image("/images/logo-blk-png.png", "埗兵", "inline w-1/4 lg:w-1/6")}
                        </a>
                    </div>
                    <div className=${["border-l-4", "border-r-4", "border-b-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${["border-t-4", "border-b-4", "font-bold"].concat(style.borderClasses).join(" ")}>
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
                renderDragonJapaneseCuisine();
            case YearsHK:
                renderYearsHK();
            case TheParkByYears:
                renderTheParkByYears();
            case LaksaStore:
                renderLaksaStore();
            case DongDong:
                renderDongDong();
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

    function renderItems(items:Array<String>, isAddons = false) {
        return [
            for (item in items)
            renderItemRow(item, isAddons)
        ];
    }

    function renderItemRow(item:String, isAddons = false) {
        var parsed = MenuTools.parsePrice(item);
        function printPrice() return isAddons ? "+$" + parsed.price : "$" + parsed.price;
        return if (parsed.price != null) jsx('
            <div key=${item} className="flex flex-row">
                <div className="flex-grow p-3">${parsed.item}</div>
                <div className="p-3">${printPrice()}</div>
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
                <div className=${["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                ${EightyNineSet.title}: ${EightyNineSet.description}
                </div>
                <div className="md:flex flex-row md:mt-3">
                    <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className="p-3"><b>${EightyNineSet.properties.main.title}</b></div>
                        ${renderItems(EightyNineSet.properties.main.enums())}
                    </div>
                    <div className="md:w-1/2 md:ml-3">
                        <div className="p-3"><b>${EightyNineSet.properties.sub.title}</b></div>
                        ${renderItems(EightyNineSet.properties.sub.enums())}
                    </div>
                </div>
            </div>
        ');
    }

    function renderDragonJapaneseCuisine() {
        return jsx('
            <div className="md:flex flex-row">
                <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>${DragonJapaneseCuisineRamenSet.title}</div>
                    ${renderItems(DragonJapaneseCuisineRamenSet.properties.main.enums())}
                    <div className="font-bold p-3">${DragonJapaneseCuisineRamenSet.properties.drink.title}選擇</div>
                    <div className="p-3">${slashes(DragonJapaneseCuisineRamenSet.properties.drink.enums())}</div>
                    <div className=${["p-1", "m-3", "rounded-xl"].concat(style.boxClasses).join(" ")}>
                        <div className="p-3 text-xl rounded-t-xl font-bold">
                            ${DragonJapaneseCuisineRamenSet.properties.options.title}
                        </div>
                        <div className="bg-body rounded-b-xl">
                            ${renderItems(DragonJapaneseCuisineRamenSet.properties.options.items.enums(), true)}
                        </div>
                    </div>
                </div>

                <div className="p-3 md:w-1/2">
                    <div className=${["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>${DragonJapaneseCuisineRiceSet.title}</div>
                    ${renderItems(DragonJapaneseCuisineRiceSet.properties.main.enums())}
                    <div className="font-bold p-3">${DragonJapaneseCuisineRiceSet.properties.drink.title}選擇</div>
                    <div className="p-3">${slashes(DragonJapaneseCuisineRiceSet.properties.drink.enums())}</div>

                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="p-3">${DragonJapaneseCuisineSingleItem.title}</div>
                    </div>
                    ${renderItems(DragonJapaneseCuisineSingleItem.enums())}
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
                <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${["flex", "flex-row"," text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="flex-grow p-3">${hotdogSet.title}</div>
                        <div className="p-3">${hotdogSet.description}</div>
                    </div>
                    ${renderItems(hotdogSet.properties.main.enums())}

                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="flex-grow p-3">${KCZenzeroLightSet.title}</div>
                        <div className="p-3">$$${MenuTools.parsePrice(KCZenzeroLightSet.description).price}</div>
                    </div>
                    <div className="p-3 font-bold">${KCZenzeroLightSet.properties.main.title}選擇</div>
                    <div className="p-3">${slashes(KCZenzeroLightSet.properties.main.enums())}</div>
                    <div className="p-3 font-bold">${KCZenzeroLightSet.properties.salad.title}選擇</div>
                    <div className="p-3">${slashes(KCZenzeroLightSet.properties.salad.enums())}</div>
                    <div className="font-bold p-3">${KCZenzeroLightSet.properties.drink.title}選擇</div>
                    <div className="p-3">${slashes(KCZenzeroLightSet.properties.drink.enums())}</div>

                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="p-3">${KCZenzeroRiceSet.title}</div>
                    </div>
                    ${renderItems(KCZenzeroRiceSet.properties.main.enums())}
                </div>
                <div className="p-3 md:w-1/2">
                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="flex-grow p-3">${noodleSet.title}</div>
                        <div className="p-3">$$${noodleSet.description.parsePrice().price}</div>
                    </div>
                    <div className="p-3"><b>${noodleSet.properties.options.title}選擇</b> ${noodleSet.properties.options.description}</div>
                    <div className="p-3">
                        ${slashes(noodleSet.properties.options.items.enums())}
                    </div>

                    <div className="font-bold p-3">${noodleSet.properties.noodle.title}選擇</div>
                    <div className="p-3">${slashes(noodleSet.properties.noodle.enums())}</div>

                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="flex-grow p-3">${pastaSet.title}</div>
                        <div className="p-3">$$${pastaSet.description.parsePrice().price}</div>
                    </div>
                    <div className="p-3 font-bold">${pastaSet.properties.main.title}選擇</div>
                    <div className="p-3">${slashes(pastaSet.properties.main.enums())}</div>
                    <div className="p-3 font-bold">${pastaSet.properties.sauce.title}選擇</div>
                    <div className="p-3">${slashes(pastaSet.properties.sauce.enums())}</div>
                    <div className="p-3 font-bold">${pastaSet.properties.noodle.title}選擇</div>
                    <div className="p-3">${slashes(pastaSet.properties.noodle.enums())}</div>

                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="p-3">${KCZenzeroSingle.title}</div>
                    </div>
                    ${renderItems(KCZenzeroSingle.enums())}
                </div>
            </div>
        ');
    }

    function renderYearsHK() {
        var drinks = YearsHKSetDrink.enums();
        var cut = Std.int(drinks.length * 0.5);
        var drinks1 = drinks.slice(0, cut);
        var drinks2 = drinks.slice(cut);
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        return jsx('
            <Fragment>
                <div className=${["border-b-4", "md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${YearsHKSet.properties.main.title}</div>
                        ${renderItems(YearsHKSet.properties.main.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${YearsHKSingle.title}</div>
                        ${renderItems(YearsHKSingle.enums())}
                    </div>
                </div>
                <div className="p-3">
                    <div className=${headerClasses}>${YearsHKSetDrink.title}</div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(drinks1, true)}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            ${renderItems(drinks2, true)}
                        </div>
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderTheParkByYears() {
        var drinks = TheParkByYearsSetDrink.enums();
        var cut = Std.int(drinks.length * 0.5);
        var drinks1 = drinks.slice(0, cut);
        var drinks2 = drinks.slice(cut);
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        return jsx('
            <Fragment>
                <div className=${["border-b-4", "md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${TheParkByYearsSet.properties.main.title}</div>
                        ${renderItems(TheParkByYearsSet.properties.main.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${TheParkByYearsSingle.title}</div>
                        ${renderItems(TheParkByYearsSingle.enums())}
                    </div>
                </div>
                <div className="p-3">
                    <div className=${headerClasses}>${TheParkByYearsSetDrink.title}</div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(drinks1, true)}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            ${renderItems(drinks2, true)}
                        </div>
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderLaksaStore() {
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        return jsx('
            <Fragment>
                <div className="p-3">
                    <div className=${headerClasses}>${renderItemRow(LaksaStoreNoodleSet.description)}</div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            <div className="p-3"><b>${LaksaStoreNoodleSet.properties.soup.title}選擇</b></div>
                            <div className="p-3">${slashes(LaksaStoreNoodleSet.properties.soup.enums())}</div>
                            <div className="p-3"><b>${LaksaStoreNoodleSet.properties.ingredient.title}選擇</b></div>
                            <div className="p-3">${slashes(LaksaStoreNoodleSet.properties.ingredient.enums())}</div>
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            <div className="p-3"><b>${LaksaStoreNoodleSet.properties.noodle.title}選擇</b></div>
                            <div className="p-3">${slashes(LaksaStoreNoodleSet.properties.noodle.enums())}</div>
                            <div className="p-3"><b>${LaksaStoreNoodleSet.properties.drink.title}</b></div>
                            <div className="p-3">${slashes(LaksaStoreNoodleSet.properties.drink.enums())}</div>
                        </div>
                    </div>
                </div>
                <div className=${["md:border-t-4", "p-3"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${LaksaStoreRiceSet.title}</div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(LaksaStoreRiceSet.properties.main.enums())}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                        </div>
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderDongDong() {
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        return jsx('
            <Fragment>
                <div className=${["border-b-4", "md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${DongDongLunchSet.title}</div>
                        <div className="p-3">${DongDongLunchSet.description}</div>
                        ${renderItems(DongDongLunchSet.properties.main.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${DongDongUsualSet.title}</div>
                        <div className="p-3">${DongDongUsualSet.description}</div>
                        ${renderItems(DongDongUsualSet.properties.main.enums())}
                    </div>
                </div>
                <div className="md:flex flex-row">
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${DongDongDinnerSet.title}</div>
                        <div className="p-3">${DongDongDinnerSet.description}</div>
                        ${renderItems(DongDongDinnerSet.properties.main.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>晚餐${DongDongDinnerDish.title}</div>
                        <div className="p-3">${DongDongDinnerDish.description}</div>
                        ${renderItems(DongDongDinnerDish.properties.main.enums())}
                    </div>
                </div>
            </Fragment>
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