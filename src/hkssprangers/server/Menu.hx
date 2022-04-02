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
import hkssprangers.info.menu.BiuKeeLokYuenMenu;
import hkssprangers.info.menu.BiuKeeLokYuenMenu.*;
import hkssprangers.info.menu.NeighborMenu.*;
import hkssprangers.info.menu.MGYMenu;
import hkssprangers.info.menu.MGYMenu.*;
import hkssprangers.info.menu.FastTasteSSPMenu.*;
import hkssprangers.info.menu.HanaSoftCreamMenu.*;
import hkssprangers.info.menu.BlaBlaBlaMenu.*;
import hkssprangers.info.menu.MyRoomRoomMenu.*;
import hkssprangers.info.menu.ThaiYummyMenu.*;
import hkssprangers.info.menu.ToolssMenu.*;
import hkssprangers.info.menu.KeiHingMenu;
import hkssprangers.info.menu.KeiHingMenu.*;
import hkssprangers.info.menu.PokeGoMenu.*;
import hkssprangers.info.menu.WoStreetMenu.*;
import hkssprangers.info.menu.MinimalMenu.*;
import hkssprangers.info.menu.CafeGoldenMenu.*;
import hkssprangers.info.menu.BlackWindowMenu;
import hkssprangers.info.menu.LonelyPaisleyMenu.*;
import hkssprangers.info.menu.FishFranSSPMenu.*;
import hkssprangers.info.menu.*;
import hkssprangers.info.Shop;
import hkssprangers.info.ShopCluster;
using hkssprangers.server.FastifyTools;
using hkssprangers.info.MenuTools;
using hkssprangers.ValueTools;
using Reflect;
using Lambda;
using StringTools;
using hxLINQ.LINQ;

typedef MenuProps = {
    final shop:Shop;
    final date:LocalDateString;
    final definitions:Dynamic;
}

class Menu extends View<MenuProps> {
    public var shop(get, never):Shop;
    function get_shop() return props.shop;

    override public function title() return '${shop.info().name} 埗兵外賣餐牌';
    override public function description() return '${shop.info().name} 埗兵外賣餐牌';
    override function canonical() return Path.join(["https://" + canonicalHost, "menu", shop]);
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

    override function depScript():ReactElement {
        final mapboxGlCssUrl = 'https://cdn.jsdelivr.net/npm/mapbox-gl@${NodeModules.lockedVersion("mapbox-gl")}/dist/mapbox-gl.css';
        return jsx('
            <Fragment>
                <script src="https://cdn.lordicon.com/libs/frhvbuzj/lord-icon-2.0.2.js"></script>
                <link rel="stylesheet" href=${mapboxGlCssUrl} crossOrigin="anonymous"/>
                <script src=${R("/js/map/map.js")}></script>
                ${super.depScript()}
            </Fragment>
        ');
    }

    static final clusterStyle = [
        DragonCentreCluster => {
            borderClasses: ["border-red-500"],
            headerClasses: ["bg-pt2-red-500"],
            boxClasses: ["bg-slash-red-500"],
            textClasses: ["text-red-500"]
        },
        CLPCluster => {
            borderClasses: ["border-green-400"],
            headerClasses: ["bg-pt2-green-400"],
            boxClasses: [],
            textClasses: ["text-green-500"]
        },
        GoldenCluster => {
            borderClasses: ["border-pink-500"],
            headerClasses: ["bg-pt2-pink-500"],
            boxClasses: ["bg-slash-pink-500"],
            textClasses: ["text-pink-500"]
        },
        PeiHoStreetMarketCluster => {
            borderClasses: ["border-amber-600"],
            headerClasses: ["bg-pt-amber-600"],
            boxClasses: [],
            textClasses: ["text-amber-600"]
        },
        SmilingPlazaCluster => {
            borderClasses: ["border-yellow-500"],
            headerClasses: ["bg-pt2-yellow-500"],
            boxClasses: ["bg-slash-yellow-500"],
            textClasses: ["text-yellow-500"]
        },
        ParkCluster => {
            borderClasses: ["border-green-600"],
            headerClasses: ["bg-pt2-green-600"],
            boxClasses: [],
            textClasses: ["text-green-600"]
        },
        PakTinCluster => {
            borderClasses: ["border-blue-500"],
            headerClasses: ["bg-pt2-blue-500"],
            boxClasses: [],
            textClasses: ["text-blue-500"]
        },
        TungChauStreetParkCluster => {
            borderClasses: ["border-indigo-500"],
            headerClasses: ["bg-pt2-indigo-500"],
            boxClasses: [],
            textClasses: ["text-indigo-500"]
        }
    ];

    final style:{
        borderClasses:Array<String>,
        headerClasses:Array<String>,
        boxClasses:Array<String>,
        textClasses:Array<String>,
    };
    
    function new(props, context) {
        super(props, context);
        style = clusterStyle[ShopCluster.classify(shop)];
    }

    override function bodyContent() {
        final recommendation = switch (shop.info()) {
            case { id: BlackWindow }:
                jsx('
                    <Fragment>
                        <div className="mb-1 text-xs text-gray-400">
                            餐廳自介
                        </div>
                        <div className="mb-3">
                            <p className="mb-1.5">
                                群體共同經營空間：<br/>
                                素食| Infoshop | 圖書漫畫| 音樂 | 放映 | 版畫
                            </p>
                            <p>歡迎過嚟吹水睇書</p>
                        </div>
                    </Fragment>
                ');
            case { recommendation: null }:
                null;
            case { recommendation: v }:
                jsx('
                    <Fragment>
                        <div className="mb-1 text-xs text-gray-400">
                            埗兵推介
                        </div>
                        <div className="mb-3">
                            ${v}
                        </div>
                    </Fragment>
                ');
        }
        return jsx('
            <main>
                <div className="bg-gray-50">
                    <div className="p-3 md:py-6 mx-auto container">
                        <div className="flex items-center">
                            <a href="/">
                                ${StaticResource.image("/images/logo-blk-png.png", "埗兵", "inline w-12 lg:w-16")}
                            </a>
                            <div className="flex-1 pl-3">
                                <b className="text-lg lg:text-xl">埗兵</b>
                                <p>為深水埗黃店服務為主<span className="whitespace-nowrap">嘅外賣平台</span></p>
                            </div>
                        </div>
                    </div>
                    <div className="p-3 py-3 md:py-16 mx-auto container">
                        <div className="lg:flex">
                            <div className="lg:w-1/3 lg:pr-12">
                                <div className="flex items-center mb-3">
                                    <i className=${["fas", "fa-map-marker-alt"].concat(style.textClasses).join(" ")}></i>&nbsp;<span>${ShopCluster.classify(shop).info().name}</span>
                                    <div className="flex-1 ml-3 bg-border-black" >&nbsp;</div>
                                </div>
                                ${renderShopImage()}
                                <div className="rounded-b-md bg-white p-3 mb-3 lg:mb-0">
                                    <h1 className="mb-1 text-xl md:text-2xl">
                                        <b className="whitespace-nowrap">${shop.info().name}</b>
                                    </h1>
                                    ${renderAvailabiltyRest()}
                                    ${recommendation}
                                    <div className="mb-1 text-xs text-gray-400">
                                        更多連結
                                    </div>
                                    <div className="mb-3 text-xs">
                                        ${renderSocialHandle()}
                                    </div>
                                </div>
                            </div>
                            <div className="lg:w-2/3">
                                <div className="bg-white">
                                    ${renderContent()}
                                </div>
                                <div className="p-3 text-center text-xs text-gray-400">
                                    以上餐牌只適用於埗兵外賣
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="index-sticky-nav border-b-4 border-t-4 bg-white border-black sticky top-0 z-50 text-md md:text-lg">
                    <div className="flex text-center h-12 md:h-16 mx-auto container lg:border-x-4">
                        <a className="w-1/2 flex items-center justify-center border-r-4 border-black" href="#sectionMap">
                        <span>合作餐廳&nbsp;<i className="fas fa-utensils"></i></span>
                        </a>
                        <a className="w-1/2 flex items-center justify-center" href="#sectionHow">
                        <span>點叫嘢食&nbsp;<i className="fas fa-clipboard-list"></i></span>
                        </a>
                    </div>
                </div>

                <section id="sectionMap" className="bg-slash-black-20">
                    <div className="py-12 md:py-16 mx-auto container">
                        <div className="mx-3 md:flex border-4 border-black text-center md:text-left">
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
                </section>

                ${Index.howToOrderSection()}
                ${Index.orderButton()}
            </main>
        ');
    };

    function renderShopImage() {
        final styles = "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-auto";
        final image = switch shop {
            case EightyNine:
                StaticResource.image("/images/shops/EightyNine/89.jpg", shop.info().name, styles, true);
            case DragonJapaneseCuisine:
                StaticResource.image("/images/shops/DragonJapaneseCuisine/yyp.jpg", shop.info().name, styles, true);
            case YearsHK:
                StaticResource.image("/images/shops/YearsHK/years.jpg", shop.info().name, styles, true);
            case TheParkByYears:
                StaticResource.image("/images/shops/TheParkByYears/park.jpg", shop.info().name, styles, true);
            case LaksaStore:
                StaticResource.image("/images/shops/LaksaStore/LaksaStore-cover.jpeg", shop.info().name, styles, true);
            case DongDong:
                StaticResource.image("/images/shops/DongDong/dong.jpg", shop.info().name, styles, true);
            case BiuKeeLokYuen:
                StaticResource.image("/images/shops/BiuKeeLokYuen/bill.jpg", shop.info().name, styles, true);
            case KCZenzero:
                StaticResource.image("/images/shops/KCZenzero/tomato.jpg", shop.info().name, styles, true);
            case HanaSoftCream:
                StaticResource.image("/images/shops/HanaSoftCream/hana.jpg", shop.info().name, styles, true);
            case Neighbor:
                StaticResource.image("/images/shops/Neighbor/neighbor.jpg", shop.info().name, styles, true);
            case MGY:
                StaticResource.image("/images/shops/MGY/mgy.jpg", shop.info().name, styles, true);
            case FastTasteSSP:
                StaticResource.image("/images/shops/FastTasteSSP/fasttaste.jpg", shop.info().name, styles, true);
            case BlaBlaBla:
                StaticResource.image("/images/shops/BlaBlaBla/bla.jpg", shop.info().name, styles, true);
            case ZeppelinHotDogSKM:
                StaticResource.image("/images/shops/ZeppelinHotDogSKM/zeppelin.jpg", shop.info().name, styles, true);
            case MyRoomRoom:
                StaticResource.image("/images/shops/MyRoomRoom/MyRoomRoom.jpg", shop.info().name, styles, true);
            case ThaiYummy:
                StaticResource.image("/images/shops/ThaiYummy/ThaiYummy.jpg", shop.info().name, styles, true);
            case Toolss:
                StaticResource.image("/images/shops/Toolss/Toolss.jpg", shop.info().name, styles, true);
            case KeiHing:
                StaticResource.image("/images/shops/KeiHing/keihing.jpg", shop.info().name, styles, true);
            case PokeGo:
                StaticResource.image("/images/shops/PokeGo/PokeGo.jpg", shop.info().name, styles, true);
            case WoStreet:
                StaticResource.image("/images/shops/WoStreet/WoStreet.jpg", shop.info().name, styles, true);
            case AuLawFarm:
                null;
            case Minimal:
                StaticResource.image("/images/shops/Minimal/minimal.jpg", shop.info().name, styles, true);
            case CafeGolden:
                StaticResource.image("/images/shops/CafeGolden/CafeGolden.jpeg", shop.info().name, styles, true);
            case BlackWindow:
                StaticResource.image("/images/shops/BlackWindow/BlackWindow2.jpg", shop.info().name, styles, true);
            case LonelyPaisley:
                StaticResource.image("/images/shops/LonelyPaisley/LonelyPaisley.jpeg", shop.info().name, styles, true);
            case FishFranSSP:
                StaticResource.image("/images/shops/FishFranSSP/FishFranSSP-menu-profile.jpg", shop.info().name, styles, true);
        }

        return jsx('
            <div className="rounded-t-md relative h-64 overflow-hidden">${image}</div>
        ');
    }

    function renderAvailabiltyRest() {
        if (shop.info().restDay != null)
            return jsx('
            <Fragment>
                <div className="mb-3">${shop.info().availablity}<br/>${shop.info().restDay}</div>
            </Fragment>
        ')
        else return jsx('
            <Fragment>
                <div className="mb-3">${shop.info().availablity}</div>
            </Fragment>
            ');
    }

    function renderSocialHandle() {
        if (shop.info().instagram != null)
            return jsx('
            <Fragment>
                <a className="inline-block rounded-full px-2 py-1 mr-2 bg-blue-600 text-white" href=${shop.info().facebook}>Facebook</a>
                <a className="inline-block rounded-full px-2 py-1 mr-2 bg-blue-600 text-white" href="${shop.info().instagram}">Instagram</a>
            </Fragment>
        ')
        else return jsx('
            <Fragment>
                <a className="inline-block rounded-full px-2 py-1 mr-2 bg-blue-600 text-white" href=${shop.info().facebook}>Facebook</a>
            </Fragment>
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
                renderKeiHing();
            case PokeGo:
                renderPokeGo();
            case WoStreet:
                renderWoStreet();
            case AuLawFarm:
                null;
            case Minimal:
                renderMinimal();
            case CafeGolden:
                renderCafeGolden();
            case BlackWindow:
                renderBlackWindow();
            case LonelyPaisley:
                renderLonelyPaisley();
            case FishFranSSP:
                renderFishFranSSP();
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
                        <div className="bg-white rounded-b-xl">
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
        final hotdogSet = KCZenzeroHotdogSet(Lunch);
        final noodleSet = KCZenzeroNoodleSet(Lunch);
        final pastaSet = KCZenzeroPastaSet(Lunch);

        final limited = if (KCZenzeroItem.all(Dinner).has(LimitedSpecial)) {
            jsx('
                <Fragment>
                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="p-3">限定 (晚市供應)</div>
                    </div>
                    <div className="p-3">${KCZenzeroLimitedSpecial.description}</div>
                    ${renderItems(KCZenzeroLimitedSpecial.properties.special.enums())}
                </Fragment>
            ');
        } else {
            null;
        }

        final wontonSet = if (KCZenzeroItem.all(Lunch).has(WontonSet)) {
            jsx('
                <Fragment>
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

                    ${wontonSet}

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

    function renderLonelyPaisley() {
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        final drinks = {
            final items = LonelyPaisleyDrink.enums();
            final cutoff = Math.ceil(items.length * 0.5);
            [
                items.slice(0, cutoff),
                items.slice(cutoff),
            ];
        }
        return jsx('
            <Fragment>
                <div className=${["border-b-4", "md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                            <div className="p-3">${LonelyPaisleyMakeYourOwnChoiceSet.title} (星期一至五全日，六日晚市)</div>
                        </div>
                        <div className="p-3 font-bold">${LonelyPaisleyMakeYourOwnChoiceSet.properties.riceOrPasta.title}</div>
                        <div className="p-3">${slashes(LonelyPaisleyMakeYourOwnChoiceSet.properties.riceOrPasta.enums())}</div>
                        <div className="p-3 font-bold">${LonelyPaisleyMakeYourOwnChoiceSet.properties.meatOrSeafoodOptions.title} (${LonelyPaisleyMakeYourOwnChoiceSet.properties.meatOrSeafoodOptions.description})</div>
                        <div className="p-3">${slashes(LonelyPaisleyMakeYourOwnChoiceSet.properties.meatOrSeafoodOptions.items.enums())}</div>
                        <div className="p-3 font-bold">${LonelyPaisleyMakeYourOwnChoiceSet.properties.vegOptions.title} (${LonelyPaisleyMakeYourOwnChoiceSet.properties.vegOptions.description})</div>
                        <div className="p-3">${slashes(LonelyPaisleyMakeYourOwnChoiceSet.properties.vegOptions.items.enums())}</div>
                        <div className="font-bold p-3">${LonelyPaisleyMakeYourOwnChoiceSet.properties.sauce.title} (選一)</div>
                        <div className="p-3">${slashes(LonelyPaisleyMakeYourOwnChoiceSet.properties.sauce.enums())}</div>
                        <div className="font-bold p-3">${LonelyPaisleyMakeYourOwnChoiceSet.properties.drink.title}</div>
                        <div className="p-3">${slashes(LonelyPaisleyMakeYourOwnChoiceSet.properties.drink.enums().filter(v -> v.endsWith(" +$0")).concat(["咖啡和奶類飲品半價"]))}</div>
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                            <div className="p-3">${LonelyPaisleyLunchSet.title} (星期一至五)</div>
                        </div>
                        <div className="p-3 font-bold">${LonelyPaisleyLunchSet.properties.starter.title}</div>
                        <div className="p-3">${slashes(LonelyPaisleyLunchSet.properties.starter.enums())}</div>
                        <div className="p-3 font-bold">${LonelyPaisleyLunchSet.properties.main.title}</div>
                        ${renderItems(LonelyPaisleyLunchSet.properties.main.enums())}
                        <div className="font-bold p-3">${LonelyPaisleyLunchSet.properties.drink.title}</div>
                        <div className="p-3">${slashes(LonelyPaisleyLunchSet.properties.drink.enums().filter(v -> v.endsWith(" +$0")).concat(["咖啡和奶類飲品半價"]))}</div>
                        <div className="p-3 font-bold">${LonelyPaisleyLunchSet.properties.dessert.title}</div>
                        ${renderItems(LonelyPaisleyLunchSet.properties.dessert.enums(), true)}
                    </div>
                </div>
                <div className="md:flex flex-row">
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${LonelyPaisleySnacks.title}</div>
                        ${renderItems(LonelyPaisleySnacks.enums())}
                        <div className=${headerClasses}>${LonelyPaisleyDessert.title}</div>
                        ${renderItems(LonelyPaisleyDessert.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${LonelyPaisleyPastaRice.title}</div>
                        ${renderItems(LonelyPaisleyPastaRice.enums())}
                        <div className=${headerClasses}>${LonelyPaisleyMain.title}</div>
                        ${renderItems(LonelyPaisleyMain.enums())}
                    </div>
                </div>
                <div className=${["p-3", "md:border-t-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${LonelyPaisleyDrink.title}</div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(drinks[0])}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            ${renderItems(drinks[1])}
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
                        <div className=${headerClasses}>${TheParkByYearsSet.title}${TheParkByYearsSet.properties.main.title}</div>
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
                    <div className="md:flex flex-row">
                        <div className=${["md:w-1/2", "p-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            <div className=${headerClasses}>${LaksaStoreHotpot(null).title}</div>
                            <div className="p-3 whitespace-pre-wrap">${LaksaStoreHotpot(null).description}</div>
                        </div>
                        <div className="md:w-1/2 p-3">
                            <div className=${headerClasses}>${LaksaStoreBakKutTeh.title}</div>
                            ${renderItems(LaksaStoreBakKutTeh.properties.main.enums())}
                        </div>
                    </div>
                </div>
                <div className=${["p-3", "md:border-t-4"].concat(style.borderClasses).join(" ")}>
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
        final noodles = BiuKeeLokYuenNoodleSet.properties.main1.enums().map(MenuTools.parsePrice);
        final lomeins = BiuKeeLokYuenLoMeinSet.properties.main1.enums().map(MenuTools.parsePrice);
        final fused = [
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

        final singleCutoff = Math.ceil(BiuKeeLokYuenSingleDish.enums().length * 0.5);
        final single1 = BiuKeeLokYuenSingleDish.enums().slice(0, singleCutoff);
        final single2 = BiuKeeLokYuenSingleDish.enums().slice(singleCutoff);

        final headerClasses = ["text-xl", "font-bold"].concat(style.headerClasses).join(" ");

        final pot = if (BiuKeeLokYuenItem.all.has(Pot)) {
            jsx('
                <div className=${["p-3", "border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>
                        <div className="p-3">${BiuKeeLokYuenPot.title}</div>
                    </div>
                    ${renderItems(BiuKeeLokYuenPot.enums())}
                </div>
            ');
        } else {
            null;
        }

        return jsx('
            <div>
                ${pot}
                <div className=${["p-3"].concat(style.borderClasses).join(" ")}>
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
                                <div className="bg-white rounded-b-xl">
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
                <div className=${["p-3", "border-t-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>
                        <div className="p-3">${BiuKeeLokYuenIngredient.title}</div>
                    </div>
                    ${renderItems(BiuKeeLokYuenIngredient.enums())}
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
                            <div className="bg-white rounded-b-xl">
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
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        final coldNoodles = if (MGYItem.all.has(ColdNoodles)) {
            jsx('
                <Fragment>
                    <div className=${headerClasses}>${MGYColdNoodles.title}</div>
                    ${renderItems(MGYColdNoodles.properties.coldNoodles.enums())}
                </Fragment>
            ');
        } else {
            null;
        }
        final icecream = if (MGYItem.all.has(Icecream)) {
            jsx('
                <Fragment>
                    <div className=${headerClasses}>${MGYIcecream.title}</div>
                    ${renderItems(MGYIcecream.enums())}
                </Fragment>
            ');
        } else {
            null;
        }
        final dish = {
            final items = {
                final items = MGYSideDish.properties.dish.enums();
                final cutoff = Math.ceil(items.length * 0.5);
                [
                    items.slice(0, cutoff),
                    items.slice(cutoff),
                ];
            }
            jsx('
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${MGYSideDish.title}</div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(items[0])}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            ${renderItems(items[1])}
                        </div>
                    </div>
                </div>
            ');
        }
        return jsx('
            <Fragment>
                ${dish}
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${MGYSnack.title}</div>
                        ${renderItems(MGYSnack.enums())}
                        <div className=${headerClasses}>${MGYStirFriedNoodlesOrRice.title}</div>
                        ${renderItems(MGYStirFriedNoodlesOrRice.properties.fried.enums())}
                        ${coldNoodles}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${MGYDelight.title}</div>
                        ${renderItems(MGYDelight.properties.delight.enums())}
                        ${icecream}
                    </div>
                </div>
            </Fragment>
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
            <Fragment>
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>漢堡</div>
                        ${renderItems(FastTasteSSPBurgers)}
                        <div className=${boxClasses}>
                            <div className="p-3 text-xl rounded-t-xl font-bold">升級配料選擇</div>
                            <div className="bg-white rounded-b-xl">
                                ${renderItems(FastTasteSSPBurgerOptions, true)}
                            </div>
                        </div>
                        <div className=${headerClasses}>${seafood.title}</div>
                        ${renderItems(seafood.properties.seafood.enums())}
                        <div className=${headerClasses}>${salad.title}</div>
                        ${renderItems(salad.properties.salad.enums())}
                        <div className=${boxClasses}>
                            <div className="p-3 text-xl rounded-t-xl font-bold">${salad.title}${salad.properties.options.title}</div>
                            <div className="bg-white rounded-b-xl">
                                ${renderItems(salad.properties.options.items.enums(), true)}
                            </div>
                        </div>
                        <div className=${headerClasses}>${italian.title}</div>
                        ${renderItems(italian.properties.italian.enums())}
                        <div className=${headerClasses}>${misc.title}</div>
                        ${renderItems(misc.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${FastTasteSSPDinnerSet.title}</div>
                        ${renderItems(FastTasteSSPDinnerSet.properties.main.enums())}
                        <div className="font-bold p-3">${FastTasteSSPDinnerSet.properties.sub.title}選擇</div>
                        <div className="p-3">${slashes(FastTasteSSPDinnerSet.properties.sub.enums())}</div>
                        <div className="font-bold p-3">${FastTasteSSPDinnerSet.properties.options.title}選擇</div>
                        <div className="p-3">${slashes(FastTasteSSPDinnerSet.properties.options.items.enums())}</div>
                        <div className="font-bold p-3">${FastTasteSSPDinnerSet.properties.drink.title}選擇</div>
                        <div className="p-3">${slashes(FastTasteSSPDinnerSet.properties.drink.enums())}</div>

                        <div className=${headerClasses}>${meat.title} (晚市供應)</div>
                        ${renderItems(meat.properties.meat.enums())}
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderZeppelinHotDogSKM() {
        return jsx('
            <div className="p-3">
                ${StaticResource.image("/images/shops/ZeppelinHotDogSKM/zeppelin-menu.jpg", ZeppelinHotDogSKM.info().name, "w-full h-auto")}
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

    function renderFishFranSSP() {
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");

        final dish = {
            final items = {
                final items = FishFranSSPDish.enums();
                final cutoff = Math.ceil(items.length * 0.5);
                [
                    items.slice(0, cutoff),
                    items.slice(cutoff),
                ];
            }
            jsx('
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${FishFranSSPDish.title}</div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(items[0])}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            ${renderItems(items[1])}
                        </div>
                    </div>
                </div>
            ');
        }

        return jsx('
            <Fragment>
                ${dish}
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${FishFranSSPFishPot.title}</div>
                        <div className="font-bold p-3">${FishFranSSPFishPot.properties.style.title}</div>
                        <div className="p-3">${slashes(FishFranSSPFishPot.properties.style.enums())}</div>
                        <div className="font-bold p-3">${FishFranSSPFishPot.properties.main.title}</div>
                        ${renderItems(FishFranSSPFishPot.properties.main.enums())}

                        <div className=${headerClasses}>${FishFranSSPPot.title}</div>
                        ${renderItems(FishFranSSPPot.enums())}

                        <div className=${headerClasses}>${FishFranSSPSpicyPot.title}</div>
                        ${renderItems(FishFranSSPSpicyPot.enums())}

                        <div className=${headerClasses}>${FishFranSSPSoupPot.title}</div>
                        ${renderItems(FishFranSSPSoupPot.enums())}

                        <div className=${headerClasses}>${FishFranSSPSpicyThing.title}</div>
                        ${renderItems(FishFranSSPSpicyThing.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${FishFranSSPNoodles.title}</div>
                        <div className="font-bold p-3">${FishFranSSPNoodles.properties.main.title}</div>
                        ${renderItems(FishFranSSPNoodles.properties.main.enums())}
                        <div className="font-bold p-3">${FishFranSSPNoodles.properties.noodles.title}</div>
                        <div className="p-3">${slashes(FishFranSSPNoodles.properties.noodles.enums())}</div>

                        <div className=${headerClasses}>${FishFranSSPRice.title}</div>
                        ${renderItems(FishFranSSPRice.enums())}

                        <div className=${headerClasses}>${FishFranSSPColdDish.title}</div>
                        ${renderItems(FishFranSSPColdDish.enums())}

                        <div className=${headerClasses}>${FishFranSSPDessert.title}</div>
                        ${renderItems(FishFranSSPDessert.enums())}
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderKeiHing() {
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        final cartNoodle = {
            jsx('
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${KeiHingCartNoodles.title} (午市供應)</div>
                    <div className="p-3 text-gray-500">
                        <p>${KeiHingCartNoodles.description}</p>
                        <p>${KeiHingCartNoodles.properties.drink.description}</p>
                    </div>
                    <div className="font-bold p-3">${KeiHingCartNoodles.properties.options.title}</div>
                    <div className="p-3">${slashes(KeiHingCartNoodles.properties.options.items.enums())}</div>
                    <div className="font-bold p-3">${KeiHingCartNoodles.properties.noodle.title}</div>
                    <div className="p-3">${slashes(KeiHingCartNoodles.properties.noodle.enums())}</div>
                    <div className="font-bold p-3">${KeiHingCartNoodles.properties.extraOptions.title}</div>
                    <div className="p-3">${slashes(KeiHingCartNoodles.properties.extraOptions.items.enums())}</div>
                </div>
            ');
        }
        final potRice = if (KeiHingItem.all(Dinner).has(PotRice)) {
            final items = {
                final items = KeiHingPotRice.properties.main.enums();
                final cutoff = Math.ceil(items.length * 0.5);
                [
                    items.slice(0, cutoff),
                    items.slice(cutoff),
                ];
            }
            jsx('
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${KeiHingPotRice.title} (晚市供應)</div>
                    <div className="p-3 text-gray-500">
                        <p>${KeiHingPotRice.description}</p>
                        <p>${KeiHingPotRice.properties.drink.description}</p>
                    </div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(items[0])}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            ${renderItems(items[1])}
                        </div>
                    </div>
                    <div className="font-bold p-3">${KeiHingPotRice.properties.veg.title}</div>
                    <div className="p-3">${slashes(KeiHingPotRice.properties.veg.enums())}</div>
                </div>
            ');
        } else {
            null;
        }

        final noodleAndRice = {
            final items = {
                final items = KeiHingNoodleAndRice.properties.main.enums();
                final cutoff = Math.ceil(items.length * 0.5);
                [
                    items.slice(0, cutoff),
                    items.slice(cutoff),
                ];
            }
            jsx('
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${KeiHingNoodleAndRice.title}</div>
                    <div className="p-3 text-gray-500">
                        <p>${KeiHingNoodleAndRice.properties.drink.description}</p>
                    </div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(items[0])}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            ${renderItems(items[1])}
                        </div>
                    </div>
                </div>
            ');
        }

        final dishSet = {
            final items = {
                final items = KeiHingDishSet.properties.main.enums();
                final cutoff = Math.ceil(items.length * 0.5);
                [
                    items.slice(0, cutoff),
                    items.slice(cutoff),
                ];
            }
            jsx('
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${KeiHingDishSet.title}</div>
                    <div className="p-3 text-gray-500">
                        <p>${KeiHingDishSet.description}</p>
                        <p>${KeiHingDishSet.properties.drink.description}</p>
                    </div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(items[0])}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            ${renderItems(items[1])}
                        </div>
                    </div>
                </div>
            ');
        }

        return jsx('
            <Fragment>
                ${cartNoodle}
                ${potRice}
                ${noodleAndRice}
                ${dishSet}
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${KeiHingChickenLegSet.title}</div>
                        <div className="p-3 text-gray-500">
                            <p>${KeiHingChickenLegSet.properties.drink.description}</p>
                        </div>
                        ${renderItems(KeiHingChickenLegSet.properties.main.enums())}
                        <div className="font-bold p-3">${KeiHingChickenLegSet.properties.sauce.title}</div>
                        <div className="p-3">${slashes(KeiHingChickenLegSet.properties.sauce.enums())}</div>

                        <div className=${headerClasses}>${KeiHingFriedInstantNoodle.title}</div>
                        <div className="p-3 text-gray-500">
                            <p>${KeiHingFriedInstantNoodle.properties.drink.description}</p>
                        </div>
                        ${renderItems(KeiHingFriedInstantNoodle.properties.main.enums())}
                        <div className="font-bold p-3">${KeiHingFriedInstantNoodle.properties.options.title}</div>
                        <div className="p-3">${slashes(KeiHingFriedInstantNoodle.properties.options.items.enums())}</div>

                        <div className=${headerClasses}>${KeiHingCurrySet.title}</div>
                        <div className="p-3 text-gray-500">
                            <p>${KeiHingCurrySet.properties.drink.description}</p>
                        </div>
                        ${renderItems(KeiHingCurrySet.properties.main.enums())}
    
                        <div className=${headerClasses}>${KeiHingUsualSet.title}</div>
                        <div className="p-3 text-gray-500">
                            <p>${KeiHingUsualSet.properties.drink.description}</p>
                        </div>
                        <div className="font-bold p-3">${KeiHingUsualSet.properties.main.title}</div>
                        <div className="p-3">${slashes(KeiHingUsualSet.properties.main.enums())}</div>
                        <div className="font-bold p-3">${KeiHingUsualSet.properties.noodle.title}</div>
                        <div className="p-3">${slashes(KeiHingUsualSet.properties.noodle.enums())}</div>

                        <div className=${headerClasses}>${KeiHingSiuMeiSet.title}</div>
                        <div className="p-3 text-gray-500">
                            <p>單併$$${KeiHingMenu.siuMeiSinglePrice} 雙併+$$${KeiHingMenu.siuMeiDoubleAddCharge}</p>
                            <p>${KeiHingSiuMeiSet.description}</p>
                            <p>${KeiHingSiuMeiSet.properties.drink.description}</p>
                        </div>
                        <div className="p-3">${slashes(KeiHingMenu.siuMeis)}</div>
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${KeiHingChicken.title}</div>
                        ${renderItems(KeiHingChicken.properties.main.enums())}

                        <div className=${headerClasses}>${KeiHingPot.title}</div>
                        <div className="p-3 text-gray-500">
                            <p>${KeiHingPot.description}</p>
                            <p>${KeiHingPot.properties.drink.description}</p>
                        </div>
                        ${renderItems(KeiHingPot.properties.main.enums())}

                        <div className=${headerClasses}>${KeiHingSandwich.title}</div>
                        ${renderItems(KeiHingSandwich.enums())}
    
                        <div className=${headerClasses}>${KeiHingSnack.title}</div>
                        ${renderItems(KeiHingSnack.enums())}
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderPokeGo() {
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        return jsx('
            <Fragment>
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${PokeGoSignatureBowl.title}</div>
                        ${renderItems(PokeGoSignatureBowl.properties.main.oneOf.map(o -> o.title))}
                        <div className="font-bold p-3">${PokeGoSignatureBowl.properties.topupOptions.title}</div>
                        <div className="p-3">${slashes(PokeGoSignatureBowl.properties.topupOptions.items.enums())}</div>


                        <div className=${headerClasses}>${PokeGoBuildYourOwnBowl.title}</div>

                        <div className="font-bold p-3">${PokeGoBuildYourOwnBowl.properties.main.title}</div>
                        ${renderItems(PokeGoBuildYourOwnBowl.properties.main.enums())}

                        <div className="font-bold p-3">${PokeGoBuildYourOwnBowl.properties.baseOptions.title}</div>
                        <div className="p-3 text-gray-500">${PokeGoBuildYourOwnBowl.properties.baseOptions.description}</div>
                        <div className="p-3">${slashes(PokeGoBuildYourOwnBowl.properties.baseOptions.items.enums())}</div>

                        <div className="font-bold p-3">${PokeGoBuildYourOwnBowl.properties.toppingOptions.title}</div>
                        <div className="p-3 text-gray-500">${PokeGoBuildYourOwnBowl.properties.toppingOptions.description}</div>
                        <div className="p-3">${slashes(PokeGoBuildYourOwnBowl.properties.toppingOptions.items.enums())}</div>

                        <div className="font-bold p-3">${PokeGoBuildYourOwnBowl.properties.topupOptions.title}</div>
                        <div className="p-3">${slashes(PokeGoBuildYourOwnBowl.properties.topupOptions.items.enums())}</div>

                        <div className="font-bold p-3">${PokeGoBuildYourOwnBowl.properties.dressings.title}</div>
                        <div className="p-3">${slashes(PokeGoBuildYourOwnBowl.properties.dressings.enums())}</div>

                        <div className="font-bold p-3">${PokeGoBuildYourOwnBowl.properties.seasoningOptions.title}</div>
                        <div className="p-3 text-gray-500">${PokeGoBuildYourOwnBowl.properties.seasoningOptions.description}</div>
                        <div className="p-3">${slashes(PokeGoBuildYourOwnBowl.properties.seasoningOptions.items.enums())}</div>
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${PokeGoSnack.title}</div>
                        ${renderItems(PokeGoSnack.enums())}

                        <div className=${headerClasses}>${PokeGoDrink.title}</div>
                        ${renderItems(PokeGoDrink.enums())}
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderMinimal() {
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        return jsx('
            <Fragment>
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${MinimalSetFor2.description}</div>
                        <div className="font-bold p-3">${MinimalSetFor2.properties.salad.title} (選一)</div>
                        <div className="p-3">${slashes(MinimalSetFor2.properties.salad.enums())}</div>
                        <div className="font-bold p-3">主食 (選二)</div>
                        <div className="p-3">${slashes(MinimalSetFor2.properties.main1.enums()))}</div>
                        <div className="font-bold p-3">飲品 (選二)</div>
                        <div className="p-3">可選任何飲品</div>
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${MinimalSetFor4.description}</div>
                        <div className="font-bold p-3">沙律 (選二)</div>
                        <div className="p-3">${slashes(MinimalSetFor4.properties.salad1.enums())}</div>
                        <div className="font-bold p-3">主食 (選二)</div>
                        <div className="p-3">${slashes(MinimalSetFor4.properties.main1.enums())}</div>
                        <div className="font-bold p-3">${MinimalSetFor4.properties.sousVides.title}</div>
                        <div className="p-3">${slashes(MinimalSetFor4.properties.sousVides.enums())}</div>
                        <div className="font-bold p-3">飲品 (選四)</div>
                        <div className="p-3">可選任何飲品</div>
                    </div>
                </div>
                <div className=${["md:flex", "flex-row", "border-t-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${MinimalTacos.title}</div>
                        ${renderItems(MinimalTacos.properties.main.enums())}

                        <div className=${headerClasses}>${MinimalSalad.title}</div>
                        ${renderItems(MinimalSalad.properties.main.enums())}
                        
                        <div className=${headerClasses}>${MinimalPasta.title}</div>
                        ${renderItems(MinimalPasta.properties.main.enums())}

                        <div className=${headerClasses}>${MinimalSousVide.title}</div>
                        ${renderItems(MinimalSousVide.properties.main.enums())}

                        <div className=${headerClasses}>${MinimalDessert.title}</div>
                        ${renderItems(MinimalDessert.properties.main.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${MinimalDrinks.title}</div>
                        ${renderItems(MinimalDrinks.properties.drink.enums())}
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderCafeGolden() {
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        final drinks = {
            final items = CafeGoldenDrink.properties.drink.enums();
            final cutoff = Math.ceil(items.length * 0.5);
            [
                items.slice(0, cutoff),
                items.slice(cutoff),
            ];
        }
        return jsx('
            <Fragment>
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${CafeGoldenMain.title}</div>
                        ${renderItems(CafeGoldenMain.anyOf.map(v -> v.title))}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${CafeGoldenDessert.title}</div>
                        ${renderItems(CafeGoldenDessert.enums())}
                    </div>
                </div>
                
                <div className=${["p-3", "md:border-t-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${CafeGoldenDrink.title}</div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(drinks[0])}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            ${renderItems(drinks[1])}
                        </div>
                    </div>
                    <div className="p-3 text-gray-500 text-center">${slashes(CafeGoldenDrink.properties.options.items.enums()))}</div>
                </div>
            </Fragment>
        ');
    }

    function renderBlackWindow() {
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        final date = props.date.getDatePart();
        final menu:DynamicAccess<Dynamic> = props.definitions;
        if (menu == null) {
            return jsx('
                <Fragment>
                    <div className=${["flex-row"].concat(style.borderClasses).join(" ")}>
                        <div className=${["p-3", "pb-0"].concat(style.borderClasses).join(" ")}>
                            <div className="p-3 text-xl font-bold">${date} 餐牌 (每日更新)</div>
                            <div className="p-3">未有</div>
                        </div>
                    </div>
                </Fragment>
            ');
        }
        // trace(menu);

        function renderOptionalItems(items:Array<String>) {
            if (items == null || items.length == 0) {
                return renderItems(["無"]);
            }
            return renderItems(items);
        }

        return jsx('
            <Fragment>
                <div className=${["flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "pb-0"].concat(style.borderClasses).join(" ")}>
                        <div className="p-3 text-xl font-bold">${date} 餐牌 (每日更新)</div>
                        <div className="p-3">
                            <p>
                                <span className="pr-3">v=vegan</span>
                                <span className="pr-3">五=五辛</span>
                                <span>*=部分食材為本地作物</span>
                            </p>
                            <p>咖啡只使用燕麥奶</p>
                        </div>
                    </div>
                    <div className=${["p-3"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${BlackWindowItem.Set.getTitle()}</div>
                        <div className="p-3">
                            主食加$$${BlackWindowMenu.mainToSetCharge} 跟湯、一款小食
                        </div>
                    </div>
                </div>

                <div className=${["md:flex", "flex-row", "border-t-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${BlackWindowItem.Soup.getTitle()}</div>
                        ${renderOptionalItems(menu[BlackWindowItem.Soup] == null ? null : menu[BlackWindowItem.Soup].enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${BlackWindowItem.Snack.getTitle()}</div>
                        ${renderOptionalItems(menu[BlackWindowItem.Snack] == null ? null : menu[BlackWindowItem.Snack].enums())}
                    </div>
                </div>

                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${BlackWindowItem.Main.getTitle()}</div>
                        ${renderOptionalItems(menu[BlackWindowItem.Main] == null ? null : menu[BlackWindowItem.Main].properties.main.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${BlackWindowItem.Dessert.getTitle()}</div>
                        ${renderOptionalItems(menu[BlackWindowItem.Dessert] == null ? null : menu[BlackWindowItem.Dessert].enums())}
                    </div>
                </div>

                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${BlackWindowItem.Drink.getTitle()}</div>
                        ${renderOptionalItems(menu[BlackWindowItem.Drink] == null ? null : menu[BlackWindowItem.Drink].enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${BlackWindowItem.Coffee.getTitle()}</div>
                        ${renderOptionalItems(menu[BlackWindowItem.Coffee] == null ? null : menu[BlackWindowItem.Coffee].enums())}
                        <div className=${headerClasses}>${BlackWindowItem.Beer.getTitle()}</div>
                        ${renderOptionalItems(menu[BlackWindowItem.Beer] == null ? null : menu[BlackWindowItem.Beer].enums())}
                        <div className=${headerClasses}>${BlackWindowItem.Cocktail.getTitle()}</div>
                        ${renderOptionalItems(menu[BlackWindowItem.Cocktail] == null ? null : menu[BlackWindowItem.Cocktail].enums())}
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderWoStreet() {
        var headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        return jsx('
            <Fragment>
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${WoStreetWaffleBurger.title}</div>
                        ${renderItems(WoStreetWaffleBurger.enums())}
                        <div className=${headerClasses}>${WoStreetClassicWaffle.title}</div>
                        ${renderItems(WoStreetClassicWaffle.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${WoStreetCake.title}</div>
                        ${renderItems(WoStreetCake.enums())}
                        <div className=${headerClasses}>${WoStreetDrink.title}</div>
                        ${renderItems(WoStreetDrink.enums())}
                    </div>
                </div>
            </Fragment>
        ');
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        for (shop in Shop.all) {
            app.get("/menu/" + shop, function get(req:Request, reply:Reply):Promise<Dynamic> {
                final date:LocalDateString = switch (req.query.date) {
                    case null:
                        Date.now();
                    case date if (~/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/.match(date)):
                        Date.fromString(date + " 00:00:00");
                    case date:
                        throw "Invalid date: " + date;
                }
                final definitions:Promise<Dynamic> = switch shop {
                    case BlackWindow:
                        BlackWindowMenu.getDefinitions(date);
                    case _:
                        Promise.resolve(null);
                }
                return definitions.then(definitions -> {
                    reply
                        .header("Cache-Control", "public, max-age=60, stale-while-revalidate=300") // max-age: 1 minute, stale-while-revalidate: 5 minutes
                        .sendView(Menu, {
                            shop: shop,
                            date: date,
                            definitions: definitions,
                        });
                });
            });
            app.get('/menu/${shop}_:date(^\\d{4}-\\d{2}-\\d{2}).json', function get(req:Request, reply:Reply):Promise<Dynamic> {
                final date:LocalDateString = req.params.date + " 00:00:00";
                final definitions = switch shop {
                    case BlackWindow:
                        BlackWindowMenu.getDefinitions(date);
                    case _:
                        Promise.resolve(null);
                }
                return definitions.then(definitions -> {
                    reply
                        .header("Cache-Control", "public, max-age=60, stale-while-revalidate=300") // max-age: 1 minute, stale-while-revalidate: 5 minutes
                        .send({
                            shop: shop,
                            date: date,
                            definitions: definitions,
                        });
                });
            });
        }
    }
}