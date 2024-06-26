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
import hkssprangers.info.menu.ThaiHomeMenu.*;
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
import hkssprangers.info.menu.LittleFishFranMenu.*;
import hkssprangers.info.menu.HowDrunkMenu.*;
import hkssprangers.info.menu.LoudTeaSSPMenu;
import hkssprangers.info.menu.*;
import hkssprangers.info.Shop;
import hkssprangers.info.ShopCluster;
import hkssprangers.info.ShopCluster.clusterStyle;
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
            <meta property="og:image" content=${R("/images/ssprangers4-y.png")} />
        </Fragment>
    ');

    override function depScript():ReactElement {
        final maplibreGlCssUrl = 'https://cdn.jsdelivr.net/npm/maplibre-gl@${NodeModules.lockedVersion("maplibre-gl")}/dist/maplibre-gl.css';
        return jsx('
            <Fragment>
                <script src="https://cdn.lordicon.com/libs/frhvbuzj/lord-icon-2.0.2.js"></script>
                <link rel="stylesheet" href=${maplibreGlCssUrl} crossOrigin="anonymous"/>
                <script src=${R("/js/map/map.js")}></script>
                <script src=${R("/js/menu/menu.js")}></script>
                ${super.depScript()}
            </Fragment>
        ');
    }

    final style:{
        borderClasses:Array<String>,
        headerClasses:Array<String>,
        boxClasses:Array<String>,
        textClasses:Array<String>,
    };
    
    function new(props, context) {
        super(props, context);
        style = clusterStyle[ShopCluster.classify(shop)[0]];
    }

    override function bodyContent() {
        final info = shop.info();
        final recommendation = switch (info) {
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
        final clusters = ShopCluster.classify(shop).map(c -> {
            final style = ShopCluster.clusterStyle[c];
            jsx('
                <span className="mr-3">
                    <i className=${["fas", "fa-map-marker-alt"].concat(style.textClasses).join(" ")}></i>&nbsp;<span>${c.info().name}</span>
                </span>'
            );
        });
        return jsx('
            <main>
                <div className="bg-stone-50">
                    ${View.header()}
                    <div className="p-3 py-3 md:py-16 mx-auto container">
                        <div className="lg:flex">
                            <div className="lg:w-1/3 lg:pr-12" itemScope itemType="https://schema.org/${info.type}">
                                <div className="flex items-center mb-3">
                                    ${clusters}
                                    <div className="flex-1 bg-border-black" >&nbsp;</div>
                                </div>
                                ${renderShopImage()}
                                <div className="rounded-b-md bg-white p-3 mb-3 lg:mb-0">
                                    <h1 className="mb-1 text-xl md:text-2xl font-bold whitespace-nowrap" itemProp="name">
                                        ${info.name}
                                    </h1>
                                    <div className="mb-3 text-xs" itemProp="address">
                                        ${info.address}
                                    </div>
                                    ${renderAvailabiltyRest()}
                                    ${recommendation}
                                    <div className="mb-1 text-xs text-gray-400">
                                        更多連結
                                    </div>
                                    <div className="mb-3 text-xs">
                                        ${renderLinks()}
                                    </div>
                                </div>
                            </div>
                            <div className="lg:w-2/3">
                                <div className="bg-white">
                                    ${renderContent()}
                                </div>
                                <div className="p-3 text-center text-xs text-stone-400">
                                    以上餐牌只適用於埗兵外賣
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="index-sticky-nav border-b-4 border-t-4 bg-white border-black sticky top-0 z-50 text-md md:text-lg">
                    <div className="flex text-center h-12 md:h-16 mx-auto container">
                        <a className="w-1/2 flex items-center justify-center border-r-4 border-black" href="#sectionMap">
                        <span>合作餐廳&nbsp;<i className="fas fa-utensils"></i></span>
                        </a>
                        <a className="w-1/2 flex items-center justify-center" href="#sectionHow">
                        <span>點叫嘢食&nbsp;<i className="fas fa-clipboard-list"></i></span>
                        </a>
                    </div>
                </div>

                <section id="sectionMap" className="pb-12 md:pb-16 bg-stone-100">
                    <div className="px-3 pt-16 md:pt-20 mx-auto container">
                        <div className="md:w-2/3 lg:w-1/2">
                            可以同一張單叫晒鄰近嘅餐廳唔限幾多個餐，<span className="whitespace-nowrap">埗兵送埋俾你</span>
                        </div>
                    </div>
                    <div className="p-3 mx-auto container">
                        <div className="grid gap-4 md:gap-6 grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
                        ${Index.renderShopp(EightyNine)}
                        ${Index.renderShopp(KCZenzero)}
                        ${Index.renderShopp(ThaiHome)}
                        ${Index.renderShopp(HanaSoftCream)}
                        ${Index.renderShopp(LittleFishFran)}
                        ${Index.renderShopp(BiuKeeLokYuen)}
                        ${Index.renderShopp(BlackWindow)}
                        ${Index.renderShopp(LoudTeaSSP)}
                        ${Index.renderShopp(TheParkByYears)}
                        ${Index.renderShopp(PokeGo)}
                        ${Index.renderShopp(Minimal)}
                        ${Index.renderShopp(YearsHK)}
                        ${Index.renderShopp(LonelyPaisley)}
                        ${Index.renderShopp(CafeGolden)}
                        ${Index.renderShopp(HowDrunk)}
                        </div>
                    </div>
                </section>

                ${Index.howToOrderSection()}
                ${Index.orderButton()}
            </main>
        ');
    };

    function renderShopImage() {
        final styles = "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover";
        final image = switch shop {
            case EightyNine:
                image("/images/shops/EightyNine/89-menu-profile.jpg", shop.info().name, styles, "image", true);
            case ThaiHome:
                image("/images/shops/ThaiHome/ThaiHome.jpeg", shop.info().name, styles, "image", true);
            case DragonJapaneseCuisine:
                image("/images/shops/DragonJapaneseCuisine/yyp.jpg", shop.info().name, styles, "image", true);
            case YearsHK:
                image("/images/shops/YearsHK/years.jpg", shop.info().name, styles, "image", true);
            case TheParkByYears:
                image("/images/shops/TheParkByYears/park.jpg", shop.info().name, styles, "image", true);
            case LaksaStore:
                image("/images/shops/LaksaStore/LaksaStore-cover.jpeg", shop.info().name, styles, "image", true);
            case DongDong:
                image("/images/shops/DongDong/dong.jpg", shop.info().name, styles, "image", true);
            case BiuKeeLokYuen:
                image("/images/shops/BiuKeeLokYuen/bill.jpg", shop.info().name, styles, "image", true);
            case KCZenzero:
                image("/images/shops/KCZenzero/tomato.jpg", shop.info().name, styles, "image", true);
            case HanaSoftCream:
                image("/images/shops/HanaSoftCream/hana.jpg", shop.info().name, styles, "image", true);
            case Neighbor:
                image("/images/shops/Neighbor/neighbor-menu-profile.jpeg", shop.info().name, styles, "image", true);
            case MGY:
                image("/images/shops/MGY/mgy-menu-profile.jpg", shop.info().name, styles, "image", true);
            case FastTasteSSP:
                image("/images/shops/FastTasteSSP/fasttaste-menu-profile.jpg", shop.info().name, styles, "image", true);
            case BlaBlaBla:
                image("/images/shops/BlaBlaBla/bla.jpg", shop.info().name, styles, "image", true);
            case ZeppelinHotDogSKM:
                image("/images/shops/ZeppelinHotDogSKM/zeppelin-menu-profile.jpg", shop.info().name, styles, "image", true);
            case MyRoomRoom:
                image("/images/shops/MyRoomRoom/MyRoomRoom.jpg", shop.info().name, styles, "image", true);
            case ThaiYummy:
                image("/images/shops/ThaiYummy/ThaiYummy.jpg", shop.info().name, styles, "image", true);
            case Toolss:
                image("/images/shops/Toolss/Toolss.jpg", shop.info().name, styles, "image", true);
            case KeiHing:
                image("/images/shops/KeiHing/keihing.jpg", shop.info().name, styles, "image", true);
            case PokeGo:
                image("/images/shops/PokeGo/PokeGo.jpg", shop.info().name, styles, "image", true);
            case WoStreet:
                image("/images/shops/WoStreet/WoStreet-menu-profile.jpeg", shop.info().name, styles, "image", true);
            case Minimal:
                image("/images/shops/Minimal/minimal-menu-profile.jpg", shop.info().name, styles, "image", true);
            case CafeGolden:
                image("/images/shops/CafeGolden/CafeGolden-menu-profile.jpeg", shop.info().name, styles, "image", true);
            case BlackWindow:
                image("/images/shops/BlackWindow/BlackWindow2.jpg", shop.info().name, styles, "image", true);
            case LonelyPaisley:
                image("/images/shops/LonelyPaisley/LonelyPaisley.jpeg", shop.info().name, styles, "image", true);
            case FishFranSSP:
                image("/images/shops/FishFranSSP/FishFranSSP-menu-profile.jpg", shop.info().name, styles, "image", true);
            case LittleFishFran:
                image("/images/shops/LittleFishFran/LittleFishFran-cover.jpg", shop.info().name, styles, "image", true);
            case HowDrunk:
                image("/images/shops/HowDrunk/299782572_119575167494908_7630665123626958584_n.jpg", shop.info().name, styles, "image", true);
            case LoudTeaSSP:
                image("/images/shops/LoudTeaSSP/pink.jpeg", shop.info().name, styles, "image", true);
            case AuLawFarm:
                null;
            case MxMWorkshop:
                null;
            case NEVeg:
                null;
            case EvaFarming:
                null;
        }

        return jsx('
            <div className="rounded-t-md relative h-64 overflow-hidden">${image}</div>
        ');
    }

    function renderAvailabiltyRest() {
        return switch (shop.info()) {
            case {availablity: null, restDay: null}:
                jsx('
                    <Fragment></Fragment>
                ');
            case {availablity: availablity, restDay: null}:
                jsx('
                    <Fragment>
                        <div className="mb-3">${availablity}</div>
                    </Fragment>
                ');
            case {availablity: availablity, restDay: restDay}:
                jsx('
                    <Fragment>
                        <div className="mb-3">${availablity}<br/>${restDay}</div>
                    </Fragment>
                ');
        }
    }

    function renderLinks() {
        final info = shop.info();
        final style = "inline-block rounded-full px-2 py-1 mr-2 bg-blue-600 text-white";
        final fbLink = switch (info.facebook) {
            case null:
                null;
            case url:
                jsx('<a className=${style} href=${url}>Facebook</a>');
        }
        final igLink = switch (info.instagram) {
            case null:
                null;
            case url:
                jsx('<a className=${style} href=${url}>Instagram</a>');
        }
        return jsx('
            <Fragment>
                ${fbLink}
                ${igLink}
            </Fragment>
        ');
    }

    function renderMsg(msg:String) {
        return jsx('
            <div className="p-5 text-center">${msg}</div>
        ');
    }

    function renderContent() {
        return switch shop {
            case EightyNine:
                renderEightyNine();
            case ThaiHome:
                renderThaiHome();
            case DragonJapaneseCuisine:
                // renderDragonJapaneseCuisine();
                renderMsg("已結業");
            case YearsHK:
                renderYearsHK();
            case TheParkByYears:
                renderTheParkByYears();
            case LaksaStore:
                // renderLaksaStore();
                renderMsg("已結業");
            case DongDong:
                // renderDongDong();
                renderMsg("已結業");
            case BiuKeeLokYuen:
                renderBiuKeeLokYuen();
            case KCZenzero:
                renderKCZenzero();
            case HanaSoftCream:
                renderHanaSoftCream();
            case Neighbor:
                // renderNeighbor();
                renderMsg("深水埗店已結業");
            case MGY:
                renderMGY();
            case FastTasteSSP:
                // renderFastTasteSSP();
                renderMsg("已結業");
            case BlaBlaBla:
                // renderBlaBlaBla();
                renderMsg("已結業");
            case ZeppelinHotDogSKM:
                // renderZeppelinHotDogSKM();
                renderMsg("已結業");
            case MyRoomRoom:
                // renderMyRoomRoom();
                renderMsg("已結業");
            case ThaiYummy:
                // renderThaiYummy();
                renderMsg("埗兵外賣暫停");
            case Toolss:
                // renderToolss();
                renderMsg("已結業");
            case KeiHing:
                // renderKeiHing();
                renderMsg("埗兵外賣暫停");
            case PokeGo:
                renderPokeGo();
            case WoStreet:
                // renderWoStreet();
                renderMsg("埗兵外賣暫停");
            case Minimal:
                renderMinimal();
            case CafeGolden:
                renderCafeGolden();
            case BlackWindow:
                renderBlackWindow();
            case LonelyPaisley:
                renderLonelyPaisley();
            case FishFranSSP:
                renderMsg("深水埗店已結業");
            case LittleFishFran:
                renderLittleFishFran();
            case HowDrunk:
                renderHowDrunk();
            case LoudTeaSSP:
                renderLoudTeaSSP();
            case AuLawFarm:
                null;
            case MxMWorkshop:
                null;
            case NEVeg:
                null;
            case EvaFarming:
                null;
        }
    }

    function renderItems(items:ReadOnlyArray<String>, isAddons = false) {
        return items.map(item -> {
            final parsed = MenuTools.parsePrice(item);
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

    static function slashes(items:ReadOnlyArray<String>)
        return [
            for (i => item in items)
            if (i < items.length - 1)
                jsx('<Fragment key=${item}><span className="whitespace-nowrap">${item} /</span><span> </span></Fragment>')
            else
                jsx('<span key=${item} className="whitespace-nowrap">${item}</span>')
        ];

    function renderEightyNine() {
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        final now:LocalDateString = Date.now();
        final today = now.getDatePart();
        final limited = if (
            today >= EightyNineMenu.EightyNineLimitedSpecial.dateStart
            &&
            today <= EightyNineMenu.EightyNineLimitedSpecial.dateEnd
            &&
            EightyNineMenu.EightyNineLimitedSpecial.available
        ) {
            final def = EightyNineMenu.EightyNineLimitedSpecial.def;
            jsx('
                <Fragment>
                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="p-3">期間限定</div>
                    </div>
                    <div className="p-3">${def.description}</div>
                    ${renderItems(def.properties.special.enums())}
                </Fragment>
            ');
        } else null;

        return jsx('
            <Fragment>
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        ${limited}

                        <div className=${headerClasses}>${EightyNineMainCourse.title}</div>
                        ${renderItems(EightyNineMainCourse.enums())}

                        <div className=${headerClasses}>${EightyNineSnack.title}</div>
                        ${renderItems(EightyNineSnack.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${EightyNineRiceAndNoodle.title} (${EightyNineRiceAndNoodle.properties.drink.title})</div>
                        ${renderItems(EightyNineRiceAndNoodle.properties.main.enums())}
                        <div className="font-bold p-3">${EightyNineRiceAndNoodle.properties.drink.title}</div>
                        ${renderItems(EightyNineRiceAndNoodle.properties.drink.enums().slice(1))}
                    </div>
                </div>
            </Fragment>
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
        final now:LocalDateString = Date.now();
        final today = now.getDatePart();

        final limited = if (
            today >= KCZenzeroMenu.limitedSpecial.dateStart
            &&
            today <= KCZenzeroMenu.limitedSpecial.dateEnd
            &&
            KCZenzeroMenu.limitedSpecial.available
        ) {
            final def = KCZenzeroMenu.limitedSpecial.def;
            jsx('
                <Fragment>
                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="p-3">期間限定</div>
                    </div>
                    <div className="p-3">${def.description}</div>
                    ${renderItems(def.properties.special.enums())}
                </Fragment>
            ');
        } else null;

        final curedMeatRice = {
            final def = KCZenzeroMenu.KCZenzeroCuredMeatRice;
            jsx('
                <Fragment>
                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="p-3">${def.title}</div>
                    </div>
                    ${renderItems(def.properties.main.enums())}
                    <div className="font-bold p-3">${def.properties.drink.title}</div>
                    <div className="p-3">${slashes(KCZenzeroMincedPork.properties.drink.enums().slice(1))}</div>
                </Fragment>
            ');
        };

        final hotpots = {
            final def = KCZenzeroHotpotSet;
            jsx('
                <Fragment>
                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                    <div className="p-3">${def.title}</div>
                    </div>
                    <div className="p-3">${def.description}</div>
                    ${renderItems(def.properties.main.enums())}
                </Fragment>
            ');
        }

        final hoiSinPot = {
            final def = KCZenzeroHoiSinPot;
            jsx('
                <Fragment>
                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                    <div className="p-3">${def.title}</div>
                    </div>
                    <div className="p-3">${def.description}</div>
                    ${renderItems(def.properties.main.enums())}
                    <div className="font-bold p-3">${def.properties.style.title}</div>
                    <div className="p-3">${slashes(def.properties.style.enums())}</div>
                </Fragment>
            ');
        }

        final yiMein = {
            final def = KCZenzeroYiMein;
            jsx('
                <Fragment>
                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="p-3">${def.title}</div>
                    </div>
                    ${renderItems(def.properties.main.enums())}
                    <div className="font-bold p-3">${def.properties.drink.title}</div>
                    <div className="p-3">${slashes(def.properties.drink.enums().slice(1))}</div>
                </Fragment>
            ');
        };

        final squab = {
            final def = KCZenzeroSquab;
            jsx('
                <Fragment>
                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="p-3">${def.title}</div>
                    </div>
                    ${renderItems(def.properties.main.enums())}
                    <div className="font-bold p-3">${def.properties.drink.title}</div>
                    <div className="p-3">${slashes(def.properties.drink.enums().slice(1))}</div>
                </Fragment>
            ');
        };

        final rice = {
            final def = KCZenzeroRice;
            jsx('
                <Fragment>
                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="p-3">${def.title}</div>
                    </div>
                    ${renderItems(def.properties.main.enums())}
                    <div className="font-bold p-3">${def.properties.drink.title}</div>
                    <div className="p-3">${slashes(def.properties.drink.enums().slice(1))}</div>
                </Fragment>
            ');
        };

        final hotDouble = jsx('
            <Fragment>
                <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                    <div className="p-3">${KCZenzeroHotDouble.title}</div>
                </div>
                ${renderItems(KCZenzeroHotDouble.properties.main.enums())}
                <div className="p-3 font-bold">${KCZenzeroHotDouble.properties.drink.title}</div>
                <div className="p-3">${slashes(KCZenzeroHotDouble.properties.drink.enums().slice(1))}</div>
                <div className="p-3 font-bold">${KCZenzeroHotDouble.properties.extraOptions.title}</div>
                <div className="p-3">${slashes(KCZenzeroHotDouble.properties.extraOptions.items.enums())}</div>
            </Fragment>
        ');

        final iceFireSet = jsx('
            <Fragment>
                <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                    <div className="p-3">${KCZenzeroIceFireSet.title}</div>
                </div>
                ${renderItems(KCZenzeroIceFireSet.properties.main.enums())}
                <div className="p-3 font-bold">${KCZenzeroIceFireSet.properties.side.title}</div>
                <div className="p-3">${slashes(KCZenzeroIceFireSet.properties.side.enums())}</div>
                <div className="p-3 font-bold">${KCZenzeroIceFireSet.properties.rice.title}</div>
                <div className="p-3">${slashes(KCZenzeroIceFireSet.properties.rice.enums())}</div>
                <div className="p-3 font-bold">${KCZenzeroIceFireSet.properties.drink.title}</div>
                <div className="p-3">${slashes(KCZenzeroIceFireSet.properties.drink.enums().slice(1))}</div>
            </Fragment>
        ');

        final goldenLeg = jsx('
            <Fragment>
                <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                    <div className="p-3">${KCZenzeroGoldenLeg.title}</div>
                </div>
                ${renderItems(KCZenzeroGoldenLeg.properties.main.enums())}
                <div className="p-3 font-bold">${KCZenzeroGoldenLeg.properties.options.title}</div>
                <div className="p-3">${slashes(KCZenzeroGoldenLeg.properties.options.items.enums())}</div>
                <div className="font-bold p-3">${KCZenzeroGoldenLeg.properties.drink.title}</div>
                <div className="p-3">${slashes(KCZenzeroGoldenLeg.properties.drink.enums().slice(1))}</div>
            </Fragment>
        ');

        final mincedPork = jsx('
            <Fragment>
                <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                    <div className="p-3">${KCZenzeroMincedPork.title}</div>
                </div>
                ${renderItems(KCZenzeroMincedPork.properties.main.enums())}
                <div className="font-bold p-3">${KCZenzeroMincedPork.properties.options.title}</div>
                <div className="p-3">
                    ${slashes(KCZenzeroMincedPork.properties.options.items.enums())}
                </div>
                <div className="font-bold p-3">${KCZenzeroMincedPork.properties.drink.title}</div>
                <div className="p-3">${slashes(KCZenzeroMincedPork.properties.drink.enums().slice(1))}</div>
            </Fragment>
        ');

        final hotdogSet = {
            final hotdogSet = KCZenzeroHotdogSet;
            jsx('
                <Fragment>
                    <div className=${["flex", "flex-row"," text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="flex-grow p-3">${hotdogSet.title}</div>
                        <div className="p-3">${hotdogSet.description}</div>
                    </div>
                    ${renderItems(hotdogSet.properties.main.enums())}
                    <div className="font-bold p-3">${hotdogSet.properties.drink.title}</div>
                    <div className="p-3">${slashes(hotdogSet.properties.drink.enums().slice(1))}</div>
                </Fragment>
            ');
        }

        final noodleSet = {
            final noodleSet = KCZenzeroNoodleSet;
            jsx('
                <Fragment>
                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="flex-grow p-3">${noodleSet.title}</div>
                    </div>
                    <div className="p-3"><b>${noodleSet.properties.main.title}選擇</b></div>
                    <div className="p-3">${slashes(noodleSet.properties.main.enums())}</div>

                    <div className="font-bold p-3">${noodleSet.properties.noodle.title}選擇</div>
                    <div className="p-3">${slashes(noodleSet.properties.noodle.enums())}</div>
                </Fragment>
            ');
        }

        final single = {
            jsx('
                <Fragment>
                    <div className=${["flex", "flex-row", "text-xl", "font-bold"].concat(style.headerClasses).join(" ")}>
                        <div className="p-3">${KCZenzeroSingle.title}</div>
                    </div>
                    ${renderItems(KCZenzeroSingle.enums())}
                </Fragment>
            ');
        }

        return jsx('
            <div className="md:flex flex-row">
                <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                    ${limited}

                    ${iceFireSet}

                    ${hotDouble}

                    ${squab}

                    ${hotdogSet}

                    ${mincedPork}
                </div>
                <div className="p-3 md:w-1/2">
                    ${noodleSet}

                    ${yiMein}
                    
                    ${rice}

                    ${goldenLeg}

                    ${single}
                </div>
            </div>
        ');
    }

    function renderYearsHK() {
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        final drinks = {
            final items = YearsHKSetDrink.enums();
            final cut = Math.ceil(items.length * 0.5);
            final items1 = items.slice(1, cut);
            final items2 = items.slice(cut);
            jsx('
                <div className="p-3">
                    <div className=${headerClasses}>${YearsHKSetDrink.title}</div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(items1, true)}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            ${renderItems(items2, true)}
                        </div>
                    </div>
                </div>
            ');
        }

        final singles = {
            final items = YearsHKSingle.enums();
            final cut = Math.ceil(items.length * 0.5);
            final items1 = items.slice(0, cut);
            final items2 = items.slice(cut);
            jsx('
                <div className="p-3">
                    <div className=${headerClasses}>${YearsHKSingle.title}</div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(items1)}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            ${renderItems(items2)}
                        </div>
                    </div>
                </div>
            ');
        }

        return jsx('
            <Fragment>
                <div className="p-3">
                    ${YearsHKWeekdayLunchSet.description}
                </div>
                <div className=${["border-b-4", "md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${YearsHKWeekdayLunchSet.title}${YearsHKWeekdayLunchSet.properties.main.title}</div>
                        ${renderItems(YearsHKWeekdayLunchSet.properties.main.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${YearsHKDinnerHolidaySet.title}${YearsHKDinnerHolidaySet.properties.main.title}</div>
                        ${renderItems(YearsHKDinnerHolidaySet.properties.main.enums())}
                    </div>
                </div>
                ${drinks}
                ${singles}
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
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${LonelyPaisleyLunchSet.title} (星期一至五,非假期)</div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            <div className="p-3 font-bold">${LonelyPaisleyLunchSet.properties.starter.title}</div>
                            <div className="p-3">${slashes(LonelyPaisleyLunchSet.properties.starter.enums())}</div>
                            <div className="p-3 font-bold">${LonelyPaisleyLunchSet.properties.main.title}</div>
                            ${renderItems(LonelyPaisleyLunchSet.properties.main.enums())}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            <div className="font-bold p-3">${LonelyPaisleyLunchSet.properties.drink.title}</div>
                            ${renderItems(LonelyPaisleyLunchSet.properties.drink.enums().filter(v -> v.endsWith(" +$0")).concat(["咖啡和奶類飲品半價"]))}
                            <div className="p-3 font-bold">${LonelyPaisleyLunchSet.properties.dessert.title}</div>
                            ${renderItems(LonelyPaisleyLunchSet.properties.dessert.enums(), true)}
                        </div>
                    </div>
                </div>
                <div className="md:flex flex-row">
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${LonelyPaisleySaladSnacks.title}</div>
                        ${renderItems(LonelyPaisleySaladSnacks.enums())}
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
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        final drinks = {
            final items = TheParkByYearsSetDrink.enums();
            final cut = Math.ceil(items.length * 0.5);
            final items1 = items.slice(1, cut);
            final items2 = items.slice(cut);
            jsx('
                <div className="p-3">
                    <div className=${headerClasses}>${TheParkByYearsSetDrink.title}</div>
                    <div className="md:flex flex-row md:mt-3">
                        <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${renderItems(items1, true)}
                        </div>
                        <div className="md:w-1/2 md:pl-3">
                            ${renderItems(items2, true)}
                        </div>
                    </div>
                </div>
            ');
        }
        if (false) {
            final singles = {
                final items = TheParkByYearsSingle.enums();
                final cut = Math.ceil(items.length * 0.5);
                final items1 = items.slice(0, cut);
                final items2 = items.slice(cut);
                jsx('
                    <div className="p-3">
                        <div className=${headerClasses}>${TheParkByYearsSingle.title}</div>
                        <div className="md:flex flex-row md:mt-3">
                            <div className=${["md:w-1/2", "md:pr-3", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                                ${renderItems(items1)}
                            </div>
                            <div className="md:w-1/2 md:pl-3">
                                ${renderItems(items2)}
                            </div>
                        </div>
                    </div>
                ');
            }
            return jsx('
                <Fragment>
                    <div className="p-3">
                        ${TheParkByYearsWeekdayLunchSet.description}
                    </div>
                    <div className=${["border-b-4", "md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                        <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            <div className=${headerClasses}>${TheParkByYearsWeekdayLunchSet.title}${TheParkByYearsWeekdayLunchSet.properties.main.title}</div>
                            ${renderItems(TheParkByYearsWeekdayLunchSet.properties.main.enums())}
                        </div>
                        <div className="md:w-1/2 p-3">
                            <div className=${headerClasses}>${TheParkByYearsDinnerHolidaySet.title}${TheParkByYearsDinnerHolidaySet.properties.main.title}</div>
                            ${renderItems(TheParkByYearsDinnerHolidaySet.properties.main.enums())}
                        </div>
                    </div>
                    ${drinks}
                    ${singles}
                </Fragment>
            ');
        } else {
            return jsx('
                <Fragment>
                    <div className="p-3">
                        ${TheParkByYearsSet.description}
                    </div>
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
                    ${drinks}
                </Fragment>
            ');
        } 
    }

    function renderLaksaStore() {
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        final itemPrice = LaksaStoreNoodleSet.description.parsePrice();
        final Hotpot = if (LaksaStoreMenu.LaksaStoreItem.all.has(Hotpot)) {
            jsx('
                <Fragment>
                    <div className=${headerClasses}>${LaksaStoreHotpot(null).title}</div>
                    <div className="p-3 whitespace-pre-wrap">${LaksaStoreHotpot(null).description}</div>
                </Fragment>
            ');
        } else null;
        final BakKutTeh = if (LaksaStoreMenu.LaksaStoreItem.all.has(BakKutTeh)) {
            jsx('
                <Fragment>
                    <div className=${headerClasses}>${LaksaStoreBakKutTeh.title}</div>
                    ${renderItems(LaksaStoreBakKutTeh.properties.main.enums())}
                </Fragment>
            ');
        } else null;
        final row1 = switch [Hotpot, BakKutTeh] {
            case [null, null]:
                null;
            case [_, null]:
                jsx('
                    <div className=${["md:border-b-4"].concat(style.borderClasses).join(" ")}>
                        <div className="p-3">
                            ${Hotpot}
                        </div>
                    </div>
                ');
            case [null, _]:
                jsx('
                    <div className=${["md:border-b-4"].concat(style.borderClasses).join(" ")}>
                        <div className="p-3">
                            ${BakKutTeh}
                        </div>
                    </div>
                ');
            case [_, _]:
                jsx('
                    <div className=${["md:border-b-4", "md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                        <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                            ${Hotpot}
                        </div>
                        <div className="md:w-1/2 p-3">
                            ${BakKutTeh}
                        </div>
                    </div>
                ');
        }
        return jsx('
            <Fragment>
                ${row1}
                <div className=${["p-3"].concat(style.borderClasses).join(" ")}>
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
        final now:LocalDateString = Date.now();
        final today = now.getDatePart();
        final lunch = {
            final items = {
                final items = MGYLunchSet.properties.main.enums();
                final cutoff = Math.ceil(items.length * 0.5);
                [
                    items.slice(0, cutoff),
                    items.slice(cutoff),
                ];
            }
            jsx('
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${MGYLunchSet.title}</div>
                    <div className="p-3 font-bold">${MGYLunchSet.description}</div>
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
                ${lunch}
                ${dish}
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${MGYSnack.title}</div>
                        ${renderItems(MGYSnack.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${MGYStirFriedNoodlesOrRice.title}</div>
                        ${renderItems(MGYStirFriedNoodlesOrRice.properties.fried.enums())}
                        <div className=${headerClasses}>${MGYRice.title}</div>
                        ${renderItems(MGYRice.enums())}
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
                ${image("/images/shops/ZeppelinHotDogSKM/zeppelin-menu.jpg", ZeppelinHotDogSKM.info().name, "w-full h-auto")}
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

    function renderLittleFishFran() {
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");

        final lunchSet = {
            final items = {
                final items = LittleFishFranLunchSet.properties.main.enums();
                final cutoff = Math.ceil(items.length * 0.5);
                [
                    items.slice(0, cutoff),
                    items.slice(cutoff),
                ];
            }
            jsx('
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${LittleFishFranLunchSet.title}</div>
                    <div className="p-3 text-gray-500">
                        <p>${LittleFishFranLunchSet.properties.drink.description}</p>
                        <p>${LittleFishFranLunchSet.properties.veg.title}：${slashes(LittleFishFranLunchSet.properties.veg.enums())}</p>
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

        final dish = {
            final items = {
                final items = LittleFishFranDish.enums();
                final cutoff = Math.ceil(items.length * 0.5);
                [
                    items.slice(0, cutoff),
                    items.slice(cutoff),
                ];
            }
            jsx('
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${LittleFishFranDish.title}</div>
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
                ${lunchSet}
                ${dish}
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${LittleFishFranFishPot.title}</div>
                        <div className="font-bold p-3">${LittleFishFranFishPot.properties.style.title}</div>
                        <div className="p-3">${slashes(LittleFishFranFishPot.properties.style.enums())}</div>
                        <div className="font-bold p-3">${LittleFishFranFishPot.properties.main.title}</div>
                        ${renderItems(LittleFishFranFishPot.properties.main.enums())}

                        <div className=${headerClasses}>${LittleFishFranPot.title}</div>
                        ${renderItems(LittleFishFranPot.enums())}

                        <div className=${headerClasses}>${LittleFishFranSpicyPot.title}</div>
                        ${renderItems(LittleFishFranSpicyPot.enums())}

                        <div className=${headerClasses}>${LittleFishFranSoupPot.title}</div>
                        ${renderItems(LittleFishFranSoupPot.enums())}

                        <div className=${headerClasses}>${LittleFishFranSpicyThing.title}</div>
                        ${renderItems(LittleFishFranSpicyThing.enums())}

                        <div className=${headerClasses}>${LittleFishFranNoodles.title}</div>
                        <div className="font-bold p-3">${LittleFishFranNoodles.properties.main.title}</div>
                        ${renderItems(LittleFishFranNoodles.properties.main.enums())}
                        <div className="font-bold p-3">${LittleFishFranNoodles.properties.noodles.title}</div>
                        <div className="p-3">${slashes(LittleFishFranNoodles.properties.noodles.enums())}</div>
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${LittleFishFranRice.title}</div>
                        ${renderItems(LittleFishFranRice.enums())}

                        <div className=${headerClasses}>${LittleFishFranColdDish.title}</div>
                        ${renderItems(LittleFishFranColdDish.enums())}

                        <div className=${headerClasses}>${LittleFishFranDessert.title}</div>
                        ${renderItems(LittleFishFranDessert.enums())}

                        <div className=${headerClasses}>${LittleFishFranDrink.title}</div>
                        ${renderItems(LittleFishFranDrink.enums())}
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderThaiHome() {
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");

        return jsx('
            <Fragment>
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${ThaiHomeSetFor2.title}</div>
                        ${renderItems(ThaiHomeSetFor2.properties.main.enums())}
                        <div className="font-bold p-3">${ThaiHomeSetFor2.properties.rice.title}</div>
                        <div className="p-3">${slashes(ThaiHomeSetFor2.properties.rice.enums())}</div>
                        <div className="font-bold p-3">${ThaiHomeSetFor2.properties.soup.title}</div>
                        <div className="p-3">${slashes(ThaiHomeSetFor2.properties.soup.enums().slice(1))}</div>
                        
                        <div className=${headerClasses}>${ThaiHomeMainCourse.title}</div>
                        ${renderItems(ThaiHomeMainCourse.enums())}

                        <div className=${headerClasses}>${ThaiHomeSkewer.title}</div>
                        <div className="p-3">${slashes(ThaiHomeSkewer.items.enums())}</div>

                        <div className=${headerClasses}>${ThaiHomeSnack.title}</div>
                        ${renderItems(ThaiHomeSnack.enums())}

                        <div className=${headerClasses}>${ThaiHomeSalad.title}</div>
                        ${renderItems(ThaiHomeSalad.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${ThaiHomeRiceAndNoodle.title}</div>
                        ${renderItems(ThaiHomeRiceAndNoodle.properties.main.enums())}
                        <div className="font-bold p-3">${ThaiHomeRiceAndNoodle.properties.drink.title}</div>
                        ${renderItems(ThaiHomeRiceAndNoodle.properties.drink.enums())}
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderHowDrunk() {
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");

        return jsx('
            <Fragment>
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${HowDrunkSpicy.title}</div>
                        ${renderItems(HowDrunkSpicy.enums())}

                        <div className=${headerClasses}>${HowDrunkFermentedBeanCurd.title}</div>
                        ${renderItems(HowDrunkFermentedBeanCurd.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${HowDrunkDrunkPreOrder.title}</div>
                        ${renderItems(HowDrunkDrunkPreOrder.enums())}

                        <div className=${headerClasses}>${HowDrunkNoodlesAndRice.title}</div>
                        ${renderItems(HowDrunkNoodlesAndRice.enums())}

                        <div className=${headerClasses}>${HowDrunkDrink.title}</div>
                        ${renderItems(HowDrunkDrink.enums())}
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderLoudTeaSSP() {
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        function printDrink(d:LoudTeaSSPDrink) {
            return
                d.name
                + ' (${d.types.join("/")})'
                + " $" + d.price
            ;
        }
        final now = Date.now();
        final drinks = LoudTeaSSPMenu.getDrinks(now.getFullYear());
        final milkFoamOptions = jsx('
            <div className=${["p-1", "m-3", "rounded-xl"].concat(style.boxClasses).join(" ")}>
                <div className="px-3 py-1 rounded-t-xl font-bold">${LoudTeaSSPMilkFoamOption.title}</div>
                <div className="bg-white rounded-b-xl">
                    <div className="px-3 py-1">${slashes(LoudTeaSSPMilkFoamOption.all)}</div>
                </div>
            </div>
        ');
        final pearlOptions = jsx('
            <div className=${["p-1", "m-3", "rounded-xl"].concat(style.boxClasses).join(" ")}>
                <div className="px-3 py-1 rounded-t-xl font-bold">${LoudTeaSSPPearlOption.BlackPearl}可免費轉</div>
                <div className="bg-white rounded-b-xl">
                    <div className="px-3 py-1">${
                        slashes(
                            LoudTeaSSPPearlOption.all
                                .filter(opt -> opt != BlackPearl)
                                .map(opt -> (opt:String).substr(1))
                        )
                    }</div>
                </div>
            </div>
        ');
        final teaOrSoda = jsx('
            <div className=${["p-1", "m-3", "rounded-xl"].concat(style.boxClasses).join(" ")}>
                <div className="px-3 py-1 rounded-t-xl font-bold">${LoudTeaSSPTeaOption.title}</div>
                <div className="bg-white rounded-b-xl">
                    <div className="px-3 py-1">${slashes(LoudTeaSSPTeaOption.teaOrSoda)}</div>
                </div>
            </div>
        ');
        final springTeaOrSoda = jsx('
            <div className=${["p-1", "m-3", "rounded-xl"].concat(style.boxClasses).join(" ")}>
                <div className="px-3 py-1 rounded-t-xl font-bold">${LoudTeaSSPTeaOption.title}</div>
                <div className="bg-white rounded-b-xl">
                    <div className="px-3 py-1">${slashes(LoudTeaSSPTeaOption.springTeaOrSoda)}</div>
                </div>
            </div>
        ');
        final freshMilk = jsx('
            <div className=${["p-1", "m-3", "rounded-xl"].concat(style.boxClasses).join(" ")}>
                <div className="px-3 py-1 rounded-t-xl font-bold">${LoudTeaSSPExtraOption.title}</div>
                <div className="bg-white rounded-b-xl">
                    <div className="px-3 py-1">${slashes([LoudTeaSSPExtraOption.FreshMilk])}</div>
                </div>
            </div>
        ');
        final teas = jsx('
            <div className=${["p-1", "m-3", "rounded-xl"].concat(style.boxClasses).join(" ")}>
                <div className="px-3 py-1 rounded-t-xl font-bold">${LoudTeaSSPTeaOption.title}</div>
                <div className="bg-white rounded-b-xl">
                    <div className="px-3 py-1">${slashes(LoudTeaSSPTeaOption.milkFoamTeas)}</div>
                </div>
            </div>
        ');
        final addons = jsx('
            <div className=${["p-1", "m-3", "rounded-xl"].concat(style.boxClasses).join(" ")}>
                <div className="px-3 py-1 rounded-t-xl font-bold">${LoudTeaSSPAddon.title}</div>
                <div className="bg-white rounded-b-xl">
                    <div className="px-3 py-1">${
                        slashes(
                            LoudTeaSSPAddon.all
                        )
                    }</div>
                </div>
            </div>
        ');
        return jsx('
            <Fragment>
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${LoudTeaSSPDrinkCategory.SignatureDrink}</div>
                        ${renderItems(drinks[SignatureDrink].map(printDrink))}

                        <div className=${headerClasses}>${LoudTeaSSPDrinkCategory.FourSeasonsOfSpringTea}</div>
                        ${milkFoamOptions}
                        ${renderItems(drinks[FourSeasonsOfSpringTea].map(printDrink))}

                        <div className=${headerClasses}>${LoudTeaSSPDrinkCategory.BrownSugarFlavoredLatte}</div>
                        ${pearlOptions}
                        ${renderItems(drinks[BrownSugarFlavoredLatte].map(printDrink))}

                        <div className=${headerClasses}>${LoudTeaSSPDrinkCategory.ClassicChineseTea}</div>
                        ${renderItems(drinks[ClassicChineseTea].map(printDrink))}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${LoudTeaSSPDrinkCategory.FreshFruitTea_BubbleSoda}</div>
                        ${teaOrSoda}
                        ${renderItems(drinks[FreshFruitTea_BubbleSoda].filter(d -> d.teaOpts == LoudTeaSSPTeaOption.teaOrSoda).map(printDrink))}
                        ${springTeaOrSoda}
                        ${renderItems(drinks[FreshFruitTea_BubbleSoda].filter(d -> d.teaOpts == LoudTeaSSPTeaOption.springTeaOrSoda).map(printDrink))}

                        <div className=${headerClasses}>${LoudTeaSSPDrinkCategory.MilkTeaWithBlackPearl}</div>
                        ${freshMilk}
                        ${pearlOptions}
                        ${renderItems(drinks[MilkTeaWithBlackPearl].map(printDrink))}

                        <div className=${headerClasses}>${LoudTeaSSPDrinkCategory.MilkFoamSpecial}</div>
                        ${teas}
                        ${renderItems(drinks[MilkFoamSpecial].map(printDrink))}
                    </div>
                </div>
                <div className=${["md:flex", "flex-row", "border-t-4"].concat(style.borderClasses).join(" ")}>
                    <div className="p-3">
                        ${addons}
                    </div>
                </div>
            </Fragment>
        ');
    }

    function renderKeiHing() {
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        final today = Date.now();
        final daily = {
            final def = KeiHingDailySpecialLunch(Weekday.fromDay(today.getDay()));
            final items = {
                final items = def.properties.main.enums();
                final cutoff = Math.ceil(items.length * 0.5);
                [
                    items.slice(0, cutoff),
                    items.slice(cutoff),
                ];
            }
            jsx('
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${def.title}</div>
                    <div className="p-3 text-gray-500">
                        <p>送：${def.properties.freeSoup.enums()[1]}</p>
                        <p>${def.properties.drink.description}</p>
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
        final cartNoodle = {
            jsx('
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${KeiHingCartNoodles.title}（午市供應）</div>
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
            final def = KeiHingNoodleAndRice;
            jsx('
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${def.title}</div>
                    <div className="p-3 text-gray-500">
                        <p>送：${def.properties.freeSoup.enums()[1]}</p>
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
            final def = KeiHingDishSet;
            final items = {
                final items = def.properties.main.enums();
                final cutoff = Math.ceil(items.length * 0.5);
                [
                    items.slice(0, cutoff),
                    items.slice(cutoff),
                ];
            }
            jsx('
                <div className=${["p-3", "md:border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${headerClasses}>${def.title}</div>
                    <div className="p-3 text-gray-500">
                        <p>${def.description} ${def.properties.freeSoup.enums()[1]}</p>
                        <p>${def.properties.drink.description}</p>
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
                ${daily}
                ${cartNoodle}
                ${potRice}
                ${noodleAndRice}
                ${dishSet}
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${KeiHingChickenLegSet.title}</div>
                        <div className="p-3 text-gray-500">
                            <p>送：${KeiHingChickenLegSet.properties.freeSoup.enums()[1]}</p>
                            <p>${KeiHingChickenLegSet.properties.drink.description}</p>
                        </div>
                        ${renderItems(KeiHingChickenLegSet.properties.main.enums())}
                        <div className="font-bold p-3">${KeiHingChickenLegSet.properties.sauce.title}</div>
                        <div className="p-3">${slashes(KeiHingChickenLegSet.properties.sauce.enums())}</div>

                        <div className=${headerClasses}>${KeiHingFriedInstantNoodle.title}</div>
                        <div className="p-3 text-gray-500">
                            <p>送：${KeiHingFriedInstantNoodle.properties.freeSoup.enums()[1]}</p>
                            <p>${KeiHingFriedInstantNoodle.properties.drink.description}</p>
                        </div>
                        ${renderItems(KeiHingFriedInstantNoodle.properties.main.enums())}
                        <div className="font-bold p-3">${KeiHingFriedInstantNoodle.properties.options.title}</div>
                        <div className="p-3">${slashes(KeiHingFriedInstantNoodle.properties.options.items.enums())}</div>

                        <div className=${headerClasses}>${KeiHingCurrySet.title}</div>
                        <div className="p-3 text-gray-500">
                            <p>送：${KeiHingCurrySet.properties.freeSoup.enums()[1]}</p>
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

                        ${renderItemRow(KeiHingSiuMeiSet.title, "$" + KeiHingMenu.siuMeiPrice, ["text-xl", "font-bold"].concat(style.headerClasses))}
                        <div className="p-3 text-gray-500">
                            <p>${KeiHingSiuMeiSet.description} ${KeiHingSiuMeiSet.properties.freeSoup.enums()[1]}</p>
                            <p>${KeiHingSiuMeiSet.properties.drink.description}</p>
                        </div>
                        <div className="p-3">${slashes(KeiHingMenu.siuMeis)}</div>

                        <div className=${headerClasses}>${KeiHingBakedRice.title}</div>
                        <div className="p-3 text-gray-500">
                            <p>送：${KeiHingBakedRice.properties.freeSoup.enums()[1]}</p>
                            <p>${KeiHingBakedRice.properties.drink.description}</p>
                        </div>
                        ${renderItems(KeiHingBakedRice.properties.main.enums())}

                        <div className=${headerClasses}>${KeiHingRisotto.title}</div>
                        <div className="p-3 text-gray-500">
                            <p>送：${KeiHingRisotto.properties.freeSoup.enums()[1]}</p>
                            <p>${KeiHingRisotto.properties.drink.description}</p>
                        </div>
                        <div className="p-3">${slashes(KeiHingRisotto.properties.main.enums())}</div>
                        <div className="font-bold p-3">${KeiHingRisotto.properties.sub.title}</div>
                        <div className="p-3">${slashes(KeiHingRisotto.properties.sub.enums())}</div>
                        <div className="font-bold p-3">${KeiHingRisotto.properties.sauce.title}</div>
                        <div className="p-3">${slashes(KeiHingRisotto.properties.sauce.enums())}</div>
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${KeiHingChicken.title}</div>
                        ${renderItems(KeiHingChicken.properties.main.enums())}

                        
                        <div className=${headerClasses}>${KeiHingChickenSet.title}</div>
                        <div className="p-3 text-gray-500">
                            <p>${KeiHingChickenSet.description} ${KeiHingChickenSet.properties.freeSoup.enums()[1]}</p>
                            <p>${KeiHingChickenSet.properties.drink1.description} (兩杯)</p>
                        </div>
                        <div className="font-bold p-3">${KeiHingChickenSet.properties.main.title}</div>
                        <div className="p-3">${slashes(KeiHingChickenSet.properties.main.enums())}</div>
                        <div className="font-bold p-3">${KeiHingChickenSet.properties.dish.title}</div>
                        <div className="p-3">任何巧手小菜一款</div>
                        <div className="font-bold p-3">${KeiHingChickenSet.properties.veg.title}</div>
                        <div className="p-3">${slashes(KeiHingChickenSet.properties.veg.enums())}</div>

                        <div className=${headerClasses}>${KeiHingPot.title}</div>
                        <div className="p-3 text-gray-500">
                            <p>${KeiHingPot.description} ${KeiHingPot.properties.freeSoup.enums()[1]}</p>
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
        final headerClasses = ["p-3", "text-xl", "font-bold"].concat(style.headerClasses).join(" ");
        final sets = jsx('
            <div className=${["md:flex", "flex-row", "border-b-4"].concat(style.borderClasses).join(" ")}>
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
        ');
        return jsx('
            <Fragment>
                <div className=${["md:flex", "flex-row", "border-b-4"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "pb-0"].concat(style.borderClasses).join(" ")}>
                        <div className="p-3">
                            <p>${MinimalMenu.legends}</p>
                        </div>
                    </div>
                </div>
                <div className=${["md:flex", "flex-row"].concat(style.borderClasses).join(" ")}>
                    <div className=${["p-3", "md:w-1/2", "md:border-r-4"].concat(style.borderClasses).join(" ")}>
                        <div className=${headerClasses}>${MinimalTacos.title}</div>
                        ${renderItems(MinimalTacos.properties.main.enums())}

                        <div className=${headerClasses}>${MinimalSalad.title}</div>
                        ${renderItems(MinimalSalad.properties.main.enums())}
                        
                        <div className=${headerClasses}>${MinimalMain.title}</div>
                        ${renderItems(MinimalMain.properties.main.enums())}

                        <div className=${headerClasses}>${MinimalSousVide.title}</div>
                        ${renderItems(MinimalSousVide.properties.main.enums())}

                        <div className=${headerClasses}>${MinimalDessert.title}</div>
                        <div className="p-3">
                            <p>${MinimalDessert.description}</p>
                        </div>
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
                        <div className="p-3 font-bold">晚市加 $$${BlackWindowMenu.dinnerMainMarkup}</div>
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
                        <div className=${headerClasses}>${WoStreetClassicWaffle.title}</div>
                        ${renderItems(WoStreetClassicWaffle.enums())}
                        <div className=${headerClasses}>${WoStreetCake.title}</div>
                        ${renderItems(WoStreetCake.enums())}
                    </div>
                    <div className="md:w-1/2 p-3">
                        <div className=${headerClasses}>${WoStreetDrink.title}</div>
                        ${renderItems(WoStreetDrink.enums())}
                    </div>
                </div>
                <div className="p-3">
                    <div className=${headerClasses}>手工蛋糕預訂</div>

                    <div className="p-3">請於至少3日前預訂，部份款式可以自訂字款，或以 $$20 加曲奇字牌</div>
                            
                    <div className="grid grid-cols-2 lg:grid-cols-3 gap-2 p-3">
                        <div className="pb-5">
                            ${image("/images/shops/WoStreet/cake-roll-half.jpg", "真毛巾蛋糕半磅", "rounded")}
                            <div className="flex flex-row"><div className="flex-grow p-3">真毛巾蛋糕半磅</div><div className="p-3 whitespace-nowrap">$$98</div></div>
                        </div>
                        <div className="pb-5">
                            ${image("/images/shops/WoStreet/cake-roll.jpg", "真毛巾蛋糕1磅", "rounded")}
                            <div className="flex flex-row"><div className="flex-grow p-3">真毛巾蛋糕1磅</div><div className="p-3 whitespace-nowrap">$$196</div></div>
                        </div>
                        <div className="pb-5">
                            ${image("/images/shops/WoStreet/cake-word.jpg", "港式噴繪招牌楷書字體", "rounded")}
                            <div className="flex flex-row"><div className="flex-grow p-3">港式噴繪招牌楷書字體</div><div className="p-3 whitespace-nowrap">$$100</div></div>
                        </div>
                        <div className="pb-5">
                            ${image("/images/shops/WoStreet/cake-cheese-1.jpg", "東京第一芝士蛋糕", "rounded")}
                            <div className="flex flex-row"><div className="flex-grow p-3">東京第一芝士蛋糕</div><div className="p-3 whitespace-nowrap">$$128起</div></div>
                        </div>
                        <div className="pb-5">
                            ${image("/images/shops/WoStreet/cake-cheese-2.jpg", "巴斯克焦香芝士蛋糕", "rounded")}
                            <div className="flex flex-row"><div className="flex-grow p-3">巴斯克焦香芝士蛋糕</div><div className="p-3 whitespace-nowrap">$$128起</div></div>
                        </div>
                        <div className="pb-5">
                            ${image("/images/shops/WoStreet/cake-newyork.jpg", "紐約芝士餅", "rounded")}
                            <div className="flex flex-row"><div className="flex-grow p-3">紐約芝士餅</div><div className="p-3 whitespace-nowrap">$$126起</div></div>
                        </div>
                        <div className="pb-5">
                            ${image("/images/shops/WoStreet/cake-prince.jpg", "小王子蛋糕", "rounded")}
                            <div className="flex flex-row"><div className="flex-grow p-3">小王子蛋糕</div><div className="p-3 whitespace-nowrap">$$188</div></div>
                        </div>
                        <div className="pb-5">
                            ${image("/images/shops/WoStreet/cake-choco.jpg", "特濃朱古力蛋糕", "rounded")}
                            <div className="flex flex-row"><div className="flex-grow p-3">特濃朱古力蛋糕</div><div className="p-3 whitespace-nowrap">$$298</div></div>
                        </div>
                        <div className="pb-5">
                            ${image("/images/shops/WoStreet/cake-mango.jpg", "芒果乳酪流心戚風蛋糕", "rounded")}
                            <div className="flex flex-row"><div className="flex-grow p-3">芒果乳酪流心戚風蛋糕</div><div className="p-3 whitespace-nowrap">$$198</div></div>
                        </div>
                        <div className="pb-5">
                            ${image("/images/shops/WoStreet/cake-purple.jpg", "星空朱古力慕斯蛋糕", "rounded")}
                            <div className="flex flex-row"><div className="flex-grow p-3">星空朱古力慕斯蛋糕</div><div className="p-3 whitespace-nowrap">$$218起</div></div>
                        </div>
                        
                    </div>
                </div>
            </Fragment>
        ');
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        for (shop in Shop.all) {
            app.get("/menu/" + shop, function get(req:Request, reply:Reply):Promise<Dynamic> {
                // note that we want to display the lunch prices
                // mains are $9 higher for dinner
                final date:LocalDateString = switch (req.query.date) {
                    case null:
                        final now:LocalDateString = Date.now();
                        Date.fromString(now.getDatePart() + " 09:00:00");
                    case date if (~/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/.match(date)):
                        Date.fromString(date + " 09:00:00");
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
            app.get('/menu/${shop}_:date(^\\d{4}-\\d{2}-\\d{2}_\\d{2}:\\d{2}:\\d{2}).json', function get(req:Request, reply:Reply):Promise<Dynamic> {
                final date:LocalDateString = StringTools.replace(req.params.date, "_", " ");
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