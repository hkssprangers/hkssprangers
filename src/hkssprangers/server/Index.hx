package hkssprangers.server;

import react.ReactComponent.ReactElement;
import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.NodeModules;
import hkssprangers.browser.*;
import hkssprangers.server.ServerMain.*;
import hkssprangers.info.Shop;
import hkssprangers.info.ShopCluster;
using hkssprangers.server.FastifyTools;

typedef IndexProps = {

}

class Index extends View<IndexProps> {
    override public function description() return "深水埗區外賣團隊";
    override function canonical() return "https://" + canonicalHost;
    override public function render() {
        return super.render();
    }

    override function bodyClasses() return super.bodyClasses().concat(["view-index"]);

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
                <script src="https://cdn.lordicon.com/libs/frhvbuzj/lord-icon-2.0.2.js"></script>
                <script src=${R("/js/map/map.js")}></script>
                <script src=${R("/js/menu/menu.js")}></script>
                ${super.depScript()}
            </Fragment>
        ');
    }

    override function depCss():ReactElement {
        final splideCssUrl = 'https://cdn.jsdelivr.net/npm/@splidejs/splide@${NodeModules.lockedVersion("@splidejs/splide")}/dist/css/splide.min.css';
        final maplibreGlCssUrl = 'https://cdn.jsdelivr.net/npm/maplibre-gl@${NodeModules.lockedVersion("maplibre-gl")}/dist/maplibre-gl.css';
        return jsx('
            <Fragment>
                <link rel="stylesheet" href=${splideCssUrl} crossOrigin="anonymous"/>
                <link rel="stylesheet" href=${maplibreGlCssUrl} crossOrigin="anonymous"/>
                ${super.depCss()}
            </Fragment>
        ');
    }

    static public function sameAreaNote() return jsx('
        <div className="flex flex-nowrap justify-center pb-6">
            <p className="mx-1">🙋</p>
            <p className="text-center">
                <span className="whitespace-nowrap">可以同一張單叫晒鄰近嘅餐廳，</span>
                <span className="whitespace-nowrap">埗兵一次過送俾你</span>
            </p>
            <p className="mx-1">🙋</p>
        </div>
    ');

    function announcement() {
        return null;
        return jsx('
            <div className="bg-yellow-400 text-center md:text-left px-2">
                <div className="mx-auto md:w-4/5 py-6 md:flex md:items-center max-w-screen-lg">
                    <lord-icon
                        src="https://cdn.lordicon.com/rjzlnunf.json"
                        trigger="loop"
                        colors="primary:#121331,secondary:#ffffff"
                        stroke="70"
                        style=${{ width: 60, height: 60 }}>
                    </lord-icon>
                    <div className="flex-grow md:ml-3">
                        <p className="text-lg font-bold">把握機會多多幫襯壺說同噹噹，佢哋都係做到8月尾咋🥺經過店舖都同老闆娘傾下計同講聲支持!</p>
                    </div>
                </div>
            </div>
        ');
    }

    function banner() {
        final indexSplide = {
            __html: ReactDOMServer.renderToString(jsx('<IndexSplide />'))
        };
        return jsx('
            <div className="py-3 lg:pb-6 mx-auto container">
                <div id="splide" dangerouslySetInnerHTML=${indexSplide} />
            </div>
        ');
    }

    static public function orderButton() return jsx('
        <Fragment>
        <div className="fixed overflow-hidden bottom-0 right-0 select-none z-50">
            <div className="flex p-5 pl-12 pt-12 relative">
                <a
                    className="flex justify-center items-center w-20 h-20 md:w-24 md:h-24 rounded-full transform-colors duration-100 ease-in-out bg-yellow-400 no-underline z-10"
                    href="/order-food"
                >
                    <span className="text-black text-center text-sm">
                        ${image("/images/writing.svg", "order", "w-1/2 inline", false)}
                        <br />
                        外賣落單
                    </span>
                </a>
                <div className="absolute pointer-events-none w-20 h-20 top-12 md:w-24 md:h-24 rounded-full animate-ping opacity-25 bg-yellow-400 z-0">&nbsp;</div>
            </div>
        </div>
        </Fragment>
    ');

    static function location(location:String) return jsx('
        <span className=${TailwindTools.badge() + " mx-0.5 px-1 bg-gray-100 whitespace-nowrap"}>${location}</span>
    ');

    static public function howToOrderSection() return jsx('

        <Fragment>
            <section id="sectionHow">
                <div className="h-12 md:h-16">&nbsp;</div>
            
                <div className="py-12 md:py-16 px-6 md:px-12 mx-auto container">
                    
                        <div className="md:flex border-b-4 border-black items-end">
                            <div className="md:w-1/2">
                            <div className="rounded-full bg-gradient-to-r from-yellow-400 via-red-500 to-yellow-600 flex justify-center p-1 text-center text-md lg:text-lg">
                                <a className="w-1/3 lg:w-1/4 rounded-full bg-white p-1 md:py-3 md:px-4 mr-4 duration-75 cursor-pointer how-step" data-num="0">登入系統</a>
                                <a className="w-1/3 lg:w-1/4 rounded-full text-white font-bold p-1 md:py-3 md:px-4 mr-4 duration-75 cursor-pointer how-step" data-num="1">填寫表格</a>
                                <a className="w-1/3 lg:w-1/4 rounded-full text-white font-bold p-1 md:py-3 md:px-4 duration-75 cursor-pointer how-step" data-num="2">確認訂單</a>
                            </div>
                            <div className="p-0 lg:p-16 lg:pt-16 lg:pr-0">
                                <div className="px-6 py-3 md:py-12 lg:p-16 lg:h-48 how-desp" data-num="0">
                                    <p>經 Telegram / WhatsApp 搵<span className="whitespace-nowrap">埗兵機械人登入系統</span></p>
                                    <ul className="list-disc">
                                        <li>WhatsApp: 輸入"登入落單"，<span className="whitespace-nowrap">㩒連結登入</span></li>
                                        <li>Telegram: 輸入"/start"，<span  className="whitespace-nowrap">㩒 "登入落單" 掣登入</span></li>
                                    </ul>
                                </div>
                                <div className="px-6 py-3 md:py-12 lg:p-16 lg:h-48 how-desp hidden" data-num="1">
                                    <p>選擇送餐時段同食物仲有拎餐方法</p>
                                    <ul className="list-disc">
                                        <li>一張單可以叫晒鄰近嘅餐廳</li>
                                        <li>唔限幾多個餐</li>
                                    </ul>
                                </div>
                                <div className="px-6 py-3 md:py-12 lg:p-16 lg:h-48 how-desp hidden" data-num="2">
                                    <p>截單時間一到，埗兵外賣員就會搵你對單同收款，<span className="whitespace-nowrap">之後好快開餐~付款方法有:</span></p>
                                    <ul className="list-disc">
                                        <li>Payme</li>
                                        <li>FPS</li>
                                    </ul>
                                </div>
                            </div>
                            </div>
                            <div className="md:w-1/2">
                            <div className="flex justify-center text-center lg:pt-16 how-image" data-num="0">
                                ${image("/images/how23.png", "how", "w-4/5 rounded-t-lg inline-block")}
                            </div>
                            <div className="flex justify-center text-center lg:pt-16 how-image hidden" data-num="1">
                                ${image("/images/how35.png", "how", "w-4/5 rounded-t-lg inline-block")}
                            </div>
                            <div className="flex justify-center text-center lg:pt-16 how-image hidden" data-num="2">
                                ${image("/images/how4.png", "how", "w-4/5 rounded-t-lg inline-block")}
                            </div>
                            </div>
                        </div>

                        <div className="md:flex md:mx-auto container pt-3 lg:pt-16 md:px-3">
                            <div className="md:w-1/3 lg:pr-16">
                                <h3 className="text-lg font-bold mb-3"><i className="fas fa-map-marked-alt"></i> 埗兵外賣運費點計?</h3>
                                <h4 className="font-bold">服務範圍:</h4>
                                <p className="mb-3">
                                    以地鐵站位置解釋，${location("深水埗站")}${location("南昌站")}${location("長沙灣站")}${location("石硤尾站")}附近區域都可以送到。
                                </p>
                                <h4 className="font-bold">運費計算:</h4>
                                <p className="mb-3">
                                    以店舖同目的地之間嘅步行距離計算，會因應實際情況(如長樓梯)調整。
                                </p>
                                <div className="mb-3">
                                    步行15分鐘或以內
                                    <p className="text-xl lg:text-4xl font-bold poppins">$$25</p>
                                </div>
                                <div className="mb-3">
                                    步行15至20分鐘
                                    <p className="text-xl lg:text-4xl font-bold poppins">$$35</p>
                                </div>
                                <div className="mb-3">
                                    步行20至30分鐘
                                    <p className="text-xl lg:text-4xl font-bold poppins">$$40</p>
                                </div>
                            </div>
                            <div className="md:w-2/3">
                            <div className="flex mb-3">
                            <div className="p-3 border-t-4 border-b-4 border-r-4 border-yellow-300 flex items-center justify-center">
                                    <div className="border-yellow-300 border-4 rounded-full w-12 h-12 lg:w-24 lg:h-24 flex items-center justify-center text-xl  lg:text-4xl font-bold poppins rotate-12">午</div>
                                </div>
                                <div className="flex-1 md:flex border-t-4 border-b-4 border-yellow-300">
                                    <div className="md:w-2/3 p-3 border-b-4 md:border-b-0 md:border-r-4 border-yellow-300 flex items-center">
                                    <div>
                                        <i className="far fa-clock"></i> 派送時間
                                        <p className="text-xl lg:text-4xl font-bold poppins">12:00-14:30</p>
                                    </div>
                                    </div>
                                    <div className="p-3 border-yellow-300 flex items-center">
                                    <div>
                                        <i className="fas fa-hourglass-end"></i> 截單時間
                                        <p className="text-xl lg:text-4xl font-bold poppins">12:00</p>
                                    </div>
                                    </div>
                                </div>
                                </div>

                                <div className="flex">
                                <div className="p-3 border-t-4 border-b-4 border-r-4 border-blue-800 flex items-center justify-center">
                                    <div className="border-blue-800 border-4 rounded-full w-12 h-12 lg:w-24 lg:h-24 flex items-center justify-center text-xl lg:text-4xl font-bold poppins -rotate-12">晚</div>
                                </div>
                                <div className="flex-1 md:flex border-t-4 border-b-4 border-blue-800">
                                    <div className="md:w-2/3 p-3 border-b-4 md:border-b-0 md:border-r-4 border-blue-800 flex items-center">
                                    <div>
                                        <i className="far fa-clock"></i> 派送時間
                                        <p className="text-xl lg:text-4xl font-bold poppins">18:00-20:30</p>
                                    </div>
                                    </div>
                                    <div className="p-3 border-yellow-300 flex items-center">
                                    <div>
                                        <i className="fas fa-hourglass-end"></i> 截單時間
                                        <p className="text-xl lg:text-4xl font-bold poppins">19:00</p>
                                    </div>
                                    </div>
                                </div>
                                </div>
                            
                            </div>
                        </div>
                </div>

            </section>
        </Fragment>
    
        ');

    static function restDay(shop:Shop) {
        return switch (shop.info().restDay) {
            case null:
                null;
            case restDay:
                jsx('
                    <p className="text-xs">${restDay}</p>
                ');
        };
    }

    static public function renderShopp(shop:Shop) {
        final image = switch shop {
            case EightyNine:
                image("/images/shops/EightyNine/89.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case ThaiHome:
                image("/images/shops/ThaiHome/ThaiHome.jpeg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case YearsHK:
                image("/images/shops/YearsHK/years.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case TheParkByYears:
                image("/images/shops/TheParkByYears/park.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case LaksaStore:
                image("/images/shops/LaksaStore/laksa.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case BiuKeeLokYuen:
                image("/images/shops/BiuKeeLokYuen/bill.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case KCZenzero:
                image("/images/shops/KCZenzero/tomato.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case HanaSoftCream:
                image("/images/shops/HanaSoftCream/hana.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case MGY:
                image("/images/shops/MGY/mgy.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case ZeppelinHotDogSKM:
                image("/images/shops/ZeppelinHotDogSKM/zeppelin.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case PokeGo:
                image("/images/shops/PokeGo/PokeGo.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case WoStreet:
                image("/images/shops/WoStreet/WoStreet.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case Minimal:
                image("/images/shops/Minimal/minimal.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case CafeGolden:
                image("/images/shops/CafeGolden/CafeGolden.jpeg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case BlackWindow:
                image("/images/shops/BlackWindow/BlackWindow2-sq.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case LonelyPaisley:
                image("/images/shops/LonelyPaisley/LonelyPaisley.jpeg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case FishFranSSP:
                image("/images/shops/FishFranSSP/FishFranSSP.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case LittleFishFran:
                image("/images/shops/FishFranSSP/FishFranSSP.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case HowDrunk:
                image("/images/shops/HowDrunk/299782572_119575167494908_7630665123626958584_n_square.jpg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case LoudTeaSSP:
                image("/images/shops/LoudTeaSSP/pink.jpeg", shop.info().name, "absolute -translate-y-1/2 -translate-x-1/2 top-1/2 left-1/2 w-full h-full object-cover");
            case _:
                null;
        }
        return jsx('
        <a className="no-underline" href=${Path.join(["/menu", shop])}>
            <div className="rounded-md relative h-48 md:h-64 overflow-hidden hover:shadow">
                <div className="absolute left-0 right-0 z-10 px-1 pt-3 font-bold text-xs md:text-sm bg-gradient-to-b from-stone-400/50 to-transparent">
                    ${ShopCluster.classify(shop).map(
                        cluster -> {
                            shopClustorLabel(cluster);
                        }
                    )}
                </div>
                <div className="absolute bottom-0 left-0 right-0 z-10">
                    <div className="px-3 pt-4 pb-1 leading-3 bg-gradient-to-t from-white via-white/80 to-transparent">
                        ${restDayy(shop)}
                    </div>
                    <div className="bg-white px-3 pb-3">
                        <h3 className="text-sm md:text-lg font-bold">
                            ${shop.info().name}
                        </h3>
                        <h5 className="pt-1 text-xs md:text-sm text-stone-400 hidden"><i className="fa-solid fa-thumbs-up"></i>&nbsp;</h5>
                    </div>
                </div>
                ${image}
            </div>
        </a>
        ');
    }

    static function restDayy(shop:Shop) {
        return switch (shop.info().restDay) {
            case null:
                jsx('
                    <span className="text-xs md:text-sm">&nbsp;</span>
                ');
            case restDay:
                jsx('
                    <span className="text-xs md:text-sm">${restDay}</span>
                ');
        };
    }

    static function shopClustorLabel(cluster:ShopCluster) {
        final clusterName = switch cluster {
            case DragonCentreCluster:
                ${DragonCentreCluster.info().name};
            case PeiHoStreetMarketCluster:
                ${PeiHoStreetMarketCluster.info().name};
            case GoldenCluster:
                ${GoldenCluster.info().name};
            case ParkCluster:
                 ${ParkCluster.info().name};
            case CLPCluster:
                ${CLPCluster.info().name};
            case PakTinCluster:
                ${PakTinCluster.info().name};
            case _:
                null;
        }
        final textStyle = ShopCluster.clusterStyle[cluster].textClasses.join(" ");
        return jsx('
            <span className="rounded-full px-2 py-1 mr-1 bg-white/90 inline-block"><i className=${textStyle + " fas fa-map-marker-alt"}></i>&nbsp;<span className="">${clusterName}</span></span>
        ');
    }

    static function renderShop(shop:Shop, cluster:ShopCluster, ?extraClasses:Array<String>) {
        final image = switch shop {
            case EightyNine:
                image("/images/shops/EightyNine/89.jpg", shop.info().name, "squircle");
            case ThaiHome:
                image("/images/shops/ThaiHome/ThaiHome-square.jpeg", shop.info().name, "squircle");
            case YearsHK:
                image("/images/shops/YearsHK/years.jpg", shop.info().name, "squircle");
            case TheParkByYears:
                image("/images/shops/TheParkByYears/park.jpg", shop.info().name, "squircle");
            case LaksaStore:
                image("/images/shops/LaksaStore/laksa.jpg", shop.info().name, "squircle");
            case BiuKeeLokYuen:
                image("/images/shops/BiuKeeLokYuen/bill.jpg", shop.info().name, "squircle");
            case KCZenzero:
                image("/images/shops/KCZenzero/tomato.jpg", shop.info().name, "squircle");
            case HanaSoftCream:
                image("/images/shops/HanaSoftCream/hana.jpg", shop.info().name, "squircle");
            case MGY:
                image("/images/shops/MGY/mgy.jpg", shop.info().name, "squircle");
            case ZeppelinHotDogSKM:
                image("/images/shops/ZeppelinHotDogSKM/zeppelin.jpg", shop.info().name, "squircle");
            case PokeGo:
                image("/images/shops/PokeGo/PokeGo.jpg", shop.info().name, "squircle");
            case WoStreet:
                image("/images/shops/WoStreet/WoStreet.jpg", shop.info().name, "squircle");
            case Minimal:
                image("/images/shops/Minimal/minimal.jpg", shop.info().name, "squircle");
            case CafeGolden:
                image("/images/shops/CafeGolden/CafeGolden.jpeg", shop.info().name, "squircle");
            case BlackWindow:
                image("/images/shops/BlackWindow/BlackWindow2-sq.jpg", shop.info().name, "squircle");
            case LonelyPaisley:
                image("/images/shops/LonelyPaisley/LonelyPaisley.jpeg", shop.info().name, "squircle");
            case FishFranSSP:
                image("/images/shops/FishFranSSP/FishFranSSP.jpg", shop.info().name, "squircle");
            case LittleFishFran:
                image("/images/shops/FishFranSSP/FishFranSSP.jpg", shop.info().name, "squircle");
            case HowDrunk:
                image("/images/shops/HowDrunk/299782572_119575167494908_7630665123626958584_n_square.jpg", shop.info().name, "squircle");
            case LoudTeaSSP:
                image("/images/shops/LoudTeaSSP/pink.jpeg", shop.info().name, "squircle");
            case _:
                null;
        }
        final blockClasses2 = "p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link " + (extraClasses != null ? extraClasses : []).join(" ");
        final linkClasses2 = "cursor-pointer menu";
        final thumbnailDivClasses2 = "relative btn-menu w-auto md:w-1/5 my-2 text-center";
        final shopNameClasses = "text-xs lg:text-lg lg:flex-1";
        final textStyle = ShopCluster.clusterStyle[cluster].textClasses.join(" ");
        final clusterDots = ShopCluster.classify(shop).map(c -> jsx('
            <i className=${ShopCluster.clusterStyle[c].textClasses.join(" ") + " md:hidden fas fa-circle"}></i>
        '));
        return jsx('
            <div className=${blockClasses2}>
                <a href=${Path.join(["/menu", shop])} className=${linkClasses2}>
                    <div className="md:flex items-center"> 
                        <div className=${thumbnailDivClasses2}>
                            ${image}
                            <p className="absolute align-center-hover text-xs lg:text-lg"><i className=${textStyle + " fas fa-book-open"}></i><br/>menu</p>
                        </div>
                        <div className="md:ml-3 md:pr-6 md:flex-1 text-center md:text-left">
                            <h1 className=${shopNameClasses}> ${clusterDots} ${shop.info().name}</h1>
                            ${restDay(shop)}
                        </div>
                    </div>
                </a>
            </div>
        ');
    }

    override function bodyContent() {
        return jsx('
            <Fragment>
                ${announcement()}
                <main>
                    ${orderButton()}
                    ${View.header()}
                    ${banner()}

                    <section className="pb-12 md:pb-16 bg-stone-100">
                        <div className="px-3 py-12 md:py-16 mx-auto container">
                            <div className="md:w-2/3 lg:w-1/2">
                                <h1 className="text-xl md:text-2xl font-bold text-opacity-75 tracking-wider mb-3">合作餐廳</h1>
                                可以同一張單叫晒鄰近嘅餐廳唔限幾多個餐，<span className="whitespace-nowrap">埗兵送埋俾你</span>
                            </div>
                        </div>
                        <div className="p-3 mx-auto container">
                            <div className="grid gap-4 md:gap-6 grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
                            ${renderShopp(EightyNine)}
                            ${renderShopp(KCZenzero)}
                            ${renderShopp(ThaiHome)}
                            ${renderShopp(HanaSoftCream)}
                            ${renderShopp(LittleFishFran)}
                            ${renderShopp(BiuKeeLokYuen)}
                            ${renderShopp(BlackWindow)}
                            ${renderShopp(LoudTeaSSP)}
                            ${renderShopp(TheParkByYears)}
                            ${renderShopp(PokeGo)}
                            ${renderShopp(Minimal)}
                            ${renderShopp(YearsHK)}
                            ${renderShopp(LonelyPaisley)}
                            ${renderShopp(CafeGolden)}
                            ${renderShopp(HowDrunk)}
                            </div>
                        </div>
                    </section>

                    <section className="">
                        <div className="px-3 py-12 md:py-16 mx-auto container">
                            <h1 className="text-xl md:text-2xl font-bold pb-3 tracking-wider">關於埗兵</h1>
                            <div className="lg:flex md:w-2/3 lg:w-1/2">
                            <div className="flex-1 py-3 lg:py-6 lg:pr-3">
                                <p>埗兵係由2020年8月5日開始，喺深水埗嘅店舖同一眾街坊幫助之下，開始形成一個外賣團隊。</p>
                                <p>點解想成立埗兵? 官方回答係想喺自己嘅社區內，建立一個同路人嘅外賣平台選擇，唔使每次外賣都叫動物台。而非官方回答就係，有人<s>唔想食老婆煮嘅飯而</s>想叫多啲外賣，所以決定整一個外賣平台，街坊有得用，自己又有得用。</p>
                            </div>
                            <div className="flex-1 py-3 lg:py-6 lg:pl-3">
                                <p>當外賣平台開始服務之後，熱愛地球嘅小編想透過平台做多啲同環保相關嘅事，慢慢展開咗埗兵嘅副業，由<a className="a-link" href="/food-waste-recycle">收咖啡渣</a>開始，到<a className="a-link"  href="/aulaw-vege">團購本地菜</a>同<a className="a-link" href="/recipe">研究食譜</a>，仲試過搞同街坊<a className="a-link" href="https://t.me/hkssprangers/216">收集毛巾</a>嘅活動。</p>
                                <p>埗兵唔係一個賺大錢嘅平台，路途上最大收穫，就係一班有共同理念嘅伙伴，<b>最美的是成就彼此</b>。</p>
                            </div>
                            </div>
                        </div>
                    </section>

                </main>
            </Fragment>
        ');
    }

    static public function get(req:Request, reply:Reply):Promise<Dynamic> {
        return Promise.resolve(
            reply
                .header("Cache-Control", "public, max-age=3600, stale-while-revalidate=21600") // max-age: 1 hour, stale-while-revalidate: 6 hours
                .sendView(Index, {})
        );
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/", Index.get);
    }
}