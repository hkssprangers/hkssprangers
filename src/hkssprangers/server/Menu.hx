package hkssprangers.server;

import haxe.ds.ReadOnlyArray;
import react.ReactComponent.ReactElement;
import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.server.ServerMain.*;
import hkssprangers.info.menu.EightyNineMenu.*;
import hkssprangers.info.menu.DragonJapaneseCuisineMenu.*;
import hkssprangers.info.menu.KCZenzeroMenu;
import hkssprangers.info.menu.KCZenzeroMenu.*;
import hkssprangers.info.menu.YearsHKMenu.*;
import hkssprangers.info.menu.TheParkByYearsMenu.*;
import hkssprangers.info.menu.LaksaStoreMenu.*;
import hkssprangers.info.menu.DongDongMenu.*;
import hkssprangers.info.menu.BiuKeeLokYuenMenu.*;
import hkssprangers.info.menu.NeighborMenu.*;
import hkssprangers.info.menu.MGYMenu.*;
import hkssprangers.info.menu.FastTasteSSPMenu.*;
import hkssprangers.info.menu.HanaSoftCreamMenu.*;
import hkssprangers.info.menu.BlaBlaBlaMenu.*;
import hkssprangers.info.menu.MyRoomRoomMenu.*;
import hkssprangers.info.menu.ThaiYummyMenu.*;
import hkssprangers.info.menu.ToolssMenu.*;
import hkssprangers.info.Shop;
import hkssprangers.info.ShopCluster;
using hkssprangers.server.FastifyTools;
using hkssprangers.info.MenuTools;
using hkssprangers.ValueTools;
using Reflect;
using Lambda;
using hxLINQ.LINQ;

typedef MenuProps = {
    final shop:Shop;
}

class Menu extends View<MenuProps> {
    public var shop(get, never):Shop;
    function get_shop() return props.shop;

    override public function title() return '${shop.info().name} 埗兵外賣餐牌';
    override public function description() return '${shop.info().name} 埗兵外賣餐牌';
    override function canonical() return Path.join(["https://" + host, "menu", shop]);
    override public function render() {
        return super.render();
    }

    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${Path.join(["https://" + host, R("/images/ssprangers4-y.png")])} />
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
            borderClasses: ["border-yellow-500"],
            headerClasses: ["bg-pt2-yellow-500"],
            boxClasses: ["bg-slash-yellow-500"],
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
        TungChauStreetParkCluster => {
            borderClasses: ["border-gray-700"],
            headerClasses: ["bg-pt2-gray-700"],
            boxClasses: [],
        }
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
                renderBiuKeeLokYuen();
            case KCZenzero:
                renderKCZenzero();
            case HanaSoftCream:
                renderHanaSoftCream();
            case Neighbor:
                renderNeighbor();
            case MGY:
                renderMGY();
            case FastTasteSSP:
                renderFastTasteSSP();
            case BlaBlaBla:
                renderBlaBlaBla();
            case ZeppelinHotDogSKM:
                renderZeppelinHotDogSKM();
            case MyRoomRoom:
                renderMyRoomRoom();
            case ThaiYummy:
                renderThaiYummy();
            case Toolss:
                renderToolss();
            case KeiHing:
                null; // TODO;
        }
    }

    function renderItems(items:ReadOnlyArray<String>, isAddons = false) {
        return items.map(item -> {
            var parsed = MenuTools.parsePrice(item);
            renderItemRow(parsed.item, if (parsed.price != null) {
                isAddons ? "+$" + parsed.price : "$" + parsed.price;
            } else {
                null;
            });
        });
    }

    function renderItemRow(item:String, price:String, ?extraClasses:Array<String>) {
        if (extraClasses == null)
            extraClasses = [];
        return if (price != null) jsx('
            <div key=${item} className=${["flex", "flex-row"].concat(extraClasses).join(" ")}>
                <div className="flex-grow p-3">${item}</div>
                <div className="p-3 whitespace-nowrap">${price}</div>
            </div>
        ') else jsx('
            <div key=${item} className=${["p-3"].concat(extraClasses).join(" ")}>${item}</div>
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

        var limited = if (KCZenzeroItem.all.has(LimitedSpecial)) {
            jsx('
                <Fragment>
                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="p-3">限定</div>
                    </div>
                    <div className="p-3">${KCZenzeroLimitedSpecial.description}</div>
                    ${renderItems(KCZenzeroLimitedSpecial.properties.special.enums())}
                </Fragment>
            ');
        } else {
            null;
        }
        
        return jsx('
            <div className="md:flex flex-row">
                <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                    ${limited}
                    
                    <div className=${["flex", "flex-row"," text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="flex-grow p-3">${hotdogSet.title}</div>
                        <div className="p-3">${hotdogSet.description}</div>
                    </div>
                    ${renderItems(hotdogSet.properties.main.enums())}

                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="p-3">${KCZenzeroWontonSet.title}</div>
                    </div>
                    ${renderItems(KCZenzeroWontonSet.properties.main.enums())}
                    <div className="p-3 font-bold">${KCZenzeroWontonSet.properties.options.title}</div>
                    <div className="p-3">${slashes(KCZenzeroWontonSet.properties.options.items.enums())}</div>
                    <div className="p-3 font-bold">${KCZenzeroWontonSet.properties.sub.title}選擇</div>
                    <div className="p-3">${slashes(KCZenzeroWontonSet.properties.sub.enums())}</div>
                    <div className="font-bold p-3">${KCZenzeroWontonSet.properties.drink.title}選擇</div>
                    <div className="p-3">${slashes(KCZenzeroWontonSet.properties.drink.enums())}</div>

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
        var cut = Math.ceil(drinks.length * 0.5);
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
        var cut = Math.ceil(drinks.length * 0.5);
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
        var itemPrice = LaksaStoreNoodleSet.description.parsePrice();
        return jsx('
            <Fragment>
                <div className="p-3">
                    ${renderItemRow(itemPrice.item, "$" + itemPrice.price, ["text-xl", "font-bold"].concat(style.headerClasses))}
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
                        <div className="p-3"><b>${DongDongUsualSet.properties.main.title}選擇</b></div>
                        <div className="p-3">${slashes(DongDongUsualSet.properties.main.enums())}</div>
                        <div className="p-3"><b>${DongDongUsualSet.properties.noodle.title}選擇</b></div>
                        <div className="p-3">${slashes(DongDongUsualSet.properties.noodle.enums())}</div>
                        <div className="p-3"><b>${DongDongUsualSet.properties.options.title}</b></div>
                        <div className="p-3">${slashes(DongDongUsualSet.properties.options.items.enums())}</div>

                        <div className=${headerClasses}>${DongDongLunchSet.title}/${DongDongUsualSet.title} ${DongDongLunchDrink.title}</div>
                        <div className="p-3">${slashes(DongDongLunchDrink.enums())}</div>
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

                        <div className=${headerClasses}>${DongDongDinnerSet.title}/${DongDongDinnerDish.title} ${DongDongDinnerDrink.title}</div>
                        <div className="p-3">${slashes(DongDongDinnerDrink.enums())}</div>
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderBiuKeeLokYuen() {
        var noodles = BiuKeeLokYuenNoodleSet.properties.main1.enums().map(MenuTools.parsePrice);
        var lomeins = BiuKeeLokYuenLoMeinSet.properties.main1.enums().map(MenuTools.parsePrice);
        var fused = [
            for (p in noodles)
            {
                item: p.item,
                noodlePrice: p.price,
                lomeinPrice: switch (lomeins.find(l -> l.item == p.item)) {
                    case null: null;
                    case l: l.price;
                }
            }
        ].map(p -> {
            renderItemRow(p.item, (p.noodlePrice != null ? "$" + p.noodlePrice : "----") + " / " + (p.lomeinPrice != null ? "$" + p.lomeinPrice : "----"));
        });

        var singleCutoff = Math.ceil(BiuKeeLokYuenSingleDish.enums().length * 0.5);
        var single1 = BiuKeeLokYuenSingleDish.enums().slice(0, singleCutoff);
        var single2 = BiuKeeLokYuenSingleDish.enums().slice(singleCutoff);

        var headerClasses = ["text-xl", "font-bold"].concat(style.headerClasses).join(" ");

        return jsx('
            <div>
                <div className="p-3">
                    <div className=${headerClasses}>
                        <div className="p-3">${BiuKeeLokYuenNoodleSet.title} / ${BiuKeeLokYuenLoMeinSet.title}</div>
                    </div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${fused}
                        </div>
                        <div className="md:w-1/2">
                            <div className="p-3 font-bold">
                                ${BiuKeeLokYuenNoodleSet.title}${BiuKeeLokYuenNoodleSet.properties.noodle.title}選擇
                            </div>
                            <div className="p-3">${slashes(BiuKeeLokYuenNoodleSet.properties.noodle.enums())}</div>
                            <div className="p-3 font-bold">
                                ${BiuKeeLokYuenNoodleSet.properties.options.title}選擇
                            </div>
                            ${renderItems(BiuKeeLokYuenNoodleSet.properties.options.items.enums(), true)}
                            <div className=${["p-1", "m-3", "rounded-xl"].concat(style.boxClasses).join(" ")}>
                                <div className="p-3 text-xl rounded-t-xl font-bold">${BiuKeeLokYuenNoodleSet.properties.main2.title}</div>
                                <div className="bg-body rounded-b-xl">
                                    ${renderItems(BiuKeeLokYuenNoodleSet.properties.main2.enums(), true)}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className=${["p-3", "border-t-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>
                        <div className="p-3">${BiuKeeLokYuenSingleDish.title}</div>
                    </div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(single1)}
                        </div>
                        <div className="md:w-1/2">
                            ${renderItems(single2)}
                        </div>
                    </div>
                </div>
            </div>
        ');
    }

    function renderNeighbor() {
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        return jsx('
            <Fragment>
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${burgerOrHotdog}</div>
                        ${renderItems(NeighborBurgers)}
                        <div className=${headerClasses}>${NeighborSalad.title}</div>
                        ${renderItems(NeighborSalad.properties.salad.enums())}
                        <div className=${["p-1", "m-3", "rounded-xl"].concat(style.boxClasses).join(" ")}>
                            <div className="p-3 text-xl bg-slash rounded-t-xl font-bold">升級配料選擇</div>
                            <div className="bg-body rounded-b-xl">
                                <div className="p-3 font-bold">漢堡 / 熱狗 / 沙律 適用</div>
                                ${renderItems(NeighborOpts, true)}
                            </div>
                        </div>
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${NeighborSub.title}</div>
                        ${renderItems(NeighborSub.enums())}
                    </div>
                </div>
                
                <div className=${["md:border-t-4", "p-3"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${burgerOrHotdog}轉套餐</div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            <div className="p-3 font-bold">
                                ${NeighborSet.properties.sub.title}選擇
                            </div>
                            ${renderItems(NeighborSet.properties.sub.enums())}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            <div className="p-3 font-bold">
                                ${NeighborSetDrink.title}
                            </div>
                            ${renderItems(NeighborSetDrink.enums(), true)}
                        </div>
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderMGY() {
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        return jsx('
            <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${MGYSingleDish.title}</div>
                    ${renderItems(MGYSingleDish.properties.dish.enums())}
                    <div className=${headerClasses}>${MGYSub.title}</div>
                    ${renderItems(MGYSub.enums())}
                </div>
                <div className="md:w-1/2 p-3">
                    <div className=${headerClasses}>${MGYSetMeal.title}</div>
                    <div className="p-3">${MGYSetMeal.description}</div>
                    ${renderItems(MGYSetMeal.properties.setMeal.enums())}
                    <div className=${headerClasses}>${MGYFriedFood.title}</div>
                    ${renderItems(MGYFriedFood.properties.fried.enums())}
                    <div className=${headerClasses}>${MGYColdNoodle.title}</div>
                    ${renderItems(MGYColdNoodle.properties.coldNoodle.enums())}
                </div>
            </div>
        ');
    }

    function renderFastTasteSSP() {
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        var boxClasses = ["p-1", "m-3", "rounded-xl"].concat(style.boxClasses).join(" ");
        var seafood = FastTasteSSPSeafood(Lunch);
        var meat = FastTasteSSPMeat(Dinner);
        var salad = FastTasteSSPSalad();
        var italian = FastTasteSSPItalian(Lunch);
        var veg = FastTasteSSPVeg();
        var misc = FastTasteSSPMisc();
        return jsx('
            <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>漢堡</div>
                    ${renderItems(FastTasteSSPBurgers)}
                    <div className=${boxClasses}>
                        <div className="p-3 text-xl rounded-t-xl font-bold">升級配料選擇</div>
                        <div className="bg-body rounded-b-xl">
                            ${renderItems(FastTasteSSPBurgerOptions, true)}
                        </div>
                    </div>
                    <div className=${headerClasses}>${seafood.title}</div>
                    ${renderItems(seafood.properties.seafood.enums())}
                    <div className=${headerClasses}>${meat.title} (晚餐供應)</div>
                    ${renderItems(meat.properties.meat.enums())}
                    <div className=${headerClasses}>${salad.title}</div>
                    ${renderItems(salad.properties.salad.enums())}
                    <div className=${boxClasses}>
                        <div className="p-3 text-xl rounded-t-xl font-bold">${salad.title}${salad.properties.options.title}</div>
                        <div className="bg-body rounded-b-xl">
                            ${renderItems(salad.properties.options.items.enums(), true)}
                        </div>
                    </div>
                </div>
                <div className="md:w-1/2 p-3">
                    <div className=${headerClasses}>${italian.title}</div>
                    ${renderItems(italian.properties.italian.enums())}
                    <div className=${headerClasses}>${veg.title}</div>
                    ${renderItems(veg.properties.veg.enums())}
                    <div className=${headerClasses}>${misc.title}</div>
                    ${renderItems(misc.enums())}
                </div>
            </div>
        ');
    }

    function renderZeppelinHotDogSKM() {
        return jsx('
            <div className="p-3">
                ${StaticResource.image("/images/zeppelin-menu.jpg", ZeppelinHotDogSKM.info().name, "w-full h-auto")}
            </div>
        ');
    }

    function renderHanaSoftCream() {
        var cutoff = Math.ceil(HanaSoftCreamItem.enums().length * 0.5);
        var items1 = HanaSoftCreamItem.enums().slice(0, cutoff);
        var items2 = HanaSoftCreamItem.enums().slice(cutoff);
        return jsx('
            <div className="p-3">
                <div className="md:flex flex-row md:mt-3">
                    <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        ${renderItems(items1)}
                    </div>
                    <div className="md:w-1/2 md:ml-3">
                        ${renderItems(items2)}
                    </div>
                </div>
            </div>
        ');
    }

    function renderBlaBlaBla() {
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        return jsx('
            <div className="p-3">
                <div className="md:flex flex-row md:mt-3">
                    <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${BlaBlaBlaHotDrink.title}</div>
                        ${renderItems(BlaBlaBlaHotDrink.properties.drink.enums())}
                    </div>
                    <div className="md:w-1/2 md:ml-3">
                        <div className=${headerClasses}>${BlaBlaBlaIceDrink.title}</div>
                        ${renderItems(BlaBlaBlaIceDrink.properties.drink.enums())}
                    </div>
                </div>
            </div>
        ');
    }

    function renderMyRoomRoom() {
        var drinks = MyRoomRoomSetDrink.enums();
        var cut = Math.ceil(drinks.length * 0.5);
        var drinks1 = drinks.slice(0, cut);
        var drinks2 = drinks.slice(cut);
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        return jsx('
            <Fragment>
                <div className=${["border-b-4", "md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${MyRoomRoomPastaRiceSet.properties.main.title}</div>
                        ${renderItems(MyRoomRoomPastaRiceSet.properties.main.enums())}
                        <div className=${headerClasses}>${MyRoomRoomCake.title}</div>
                        ${renderItems(MyRoomRoomCake.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${MyRoomRoomSnacks.title}</div>
                        ${renderItems(MyRoomRoomSnacks.enums())}
                    </div>
                </div>
                <div className="p-3">
                    <div className=${headerClasses}>${MyRoomRoomSetDrink.title}</div>
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

    function renderThaiYummy() {
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        return jsx('
            <Fragment>
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${ThaiYummySnack.title}</div>
                        ${renderItems(ThaiYummySnack.enums())}
                        <div className=${headerClasses}>${ThaiYummyGrill.title}</div>
                        ${renderItems(ThaiYummyGrill.enums())}
                        <div className=${headerClasses}>${ThaiYummySkewer.title}</div>
                        ${renderItems(ThaiYummySkewer.items.enums())}
                        <div className=${headerClasses}>${ThaiYummySalad.title}</div>
                        ${renderItems(ThaiYummySalad.enums())}
                        <div className=${headerClasses}>${ThaiYummyFried.title}</div>
                        ${renderItems(ThaiYummyFried.enums())}
                        <div className=${headerClasses}>${ThaiYummyVegetable.title}</div>
                        <div className="font-bold p-3">${ThaiYummyVegetable.properties.style.title}選擇</div>
                        <div className="p-3">${slashes(ThaiYummyVegetable.properties.style.enums())}</div>
                        <div className="font-bold p-3">${ThaiYummyVegetable.properties.vege.title}選擇</div>
                        ${renderItems(ThaiYummyVegetable.properties.vege.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${ThaiYummySeafood.title}</div>
                        <div className="font-bold p-3">${ThaiYummySeafood.properties.seafood.title}選擇</div>
                        ${renderItems(ThaiYummySeafood.properties.seafood.enums())}
                        <div className="font-bold p-3">${ThaiYummySeafood.properties.style.title}選擇</div>
                        <div className="p-3">${slashes(ThaiYummySeafood.properties.style.enums())}</div>
                        <div className=${headerClasses}>${ThaiYummySoup.title}</div>
                        ${renderItems(ThaiYummySoup.properties.soup.enums())}
                        <div className="p-3">${slashes(ThaiYummySoup.properties.options.items.enums())}</div>
                        <div className=${headerClasses}>${ThaiYummyNoodleAndRice.title}</div>
                        ${renderItems(ThaiYummyNoodleAndRice.enums())}
                        <div className=${headerClasses}>${ThaiYummyDrink.title}</div>
                        ${renderItems(ThaiYummyDrink.enums())}
                        <div className=${headerClasses}>${ThaiYummyCustomDrink.title}</div>
                        <div className="font-bold p-3">${ThaiYummyCustomDrink.description}</div>
                        ${renderItems(ThaiYummyCustomDrink.properties.drink1.enums())}
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderToolss() {
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        return jsx('
            <Fragment>
                <div className=${["border-b-4", "md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        ${renderItemRow(ToolssAllDay.title, ToolssAllDay.description, ["text-xl", "font-bold"].concat(style.headerClasses))}
                        <div className="font-bold p-3">${ToolssAllDay.properties.a.title} ${ToolssAllDay.properties.a.description}</div>
                        <div className="p-3">${slashes(ToolssAllDay.properties.a.enums())}</div>
                        <div className="font-bold p-3">${ToolssAllDay.properties.b.title} ${ToolssAllDay.properties.b.description}</div>
                        <div className="p-3">${slashes(ToolssAllDay.properties.b.enums())}</div>
                        <div className="font-bold p-3">${ToolssAllDay.properties.cOptions.title} ${ToolssAllDay.properties.cOptions.description}</div>
                        <div className="p-3">${slashes(ToolssAllDay.properties.cOptions.items.enums())}</div>
                        <div className="font-bold p-3">${ToolssAllDay.properties.dOptions.title} ${ToolssAllDay.properties.dOptions.description}</div>
                        <div className="p-3">${slashes(ToolssAllDay.properties.dOptions.items.enums())}</div>

                        <div className=${headerClasses}>${ToolssBento.title}</div>
                        ${renderItems(ToolssBento.enums())}

                        <div className=${headerClasses}>${ToolssPasta.title}</div>
                        ${renderItems(ToolssPasta.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${ToolssBread.title}</div>
                        ${renderItems(ToolssBread.enums())}

                        <div className=${headerClasses}>${ToolssSalad.title}</div>
                        ${renderItems(ToolssSalad.enums())}

                        <div className=${headerClasses}>${ToolssSnack.title}</div>
                        ${renderItems(ToolssSnack.enums())}

                        <div className=${headerClasses}>${ToolssCake.title}</div>
                        ${renderItems(ToolssCake.enums())}
                    </div>
                </div>
                <div className="md:flex flex-row">
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${ToolssHotDrink.title}</div>
                        ${renderItems(ToolssHotDrink.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${ToolssIcedDrink.title}</div>
                        ${renderItems(ToolssIcedDrink.enums())}
                    </div>
                </div>
            </Fragment>
        ');
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        for (shop in Shop.all) {
            app.get("/menu/" + shop, function get(req:Request, reply:Reply):Promise<Dynamic> {
                return Promise.resolve(
                    reply
                        .header("Cache-Control", "public, max-age=300, stale-while-revalidate=21600") // max-age: 5 minutes, stale-while-revalidate: 6 hours
                        .sendView(Menu, {
                            shop: shop,
                        })
                );
            });
        }
    }
}