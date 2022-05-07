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

    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${Path.join(["https://" + host, R("/images/ssprangers4-y.png")])} />
        </Fragment>
    ');

    override function depScript():ReactElement {
        return jsx('
            <Fragment>
                <script src="https://cdn.lordicon.com/libs/frhvbuzj/lord-icon-2.0.2.js"></script>
                <script src=${R("/js/map/map.js")}></script>
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

    override function prefetch():Array<String> return super.prefetch().concat([
        R("/browser.bundled.js"),
        R("/tiles/ssp.pmtiles"),
    ]);

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
            <div className="p-3 lg:px-0 lg:pb-6 mx-auto container">
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
                        ${StaticResource.image("/images/writing.svg", "order", "w-1/2 inline", false)}
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
            <section className="h-12 md:h-16">&nbsp;</section>
            <section id="sectionHow" className="">

                <div className="py-12 md:py-16 mx-auto container">

                    <div className="mx-3 mt-6 lg:mx-0 lg:mt-0">
                    
                        <div className="md:flex border-b-4 border-black items-end">
                            <div className="md:w-1/2">
                            <div className="rounded-full bg-gradient-to-r from-yellow-400 via-red-500 to-yellow-600 flex justify-center p-1 text-center text-md lg:text-lg">
                                <a className="w-1/3 lg:w-1/4 rounded-full bg-white p-1 md:py-3 md:px-4 mr-4 duration-75 cursor-pointer how-step" data-num="0">登入系統</a>
                                <a className="w-1/3 lg:w-1/4 rounded-full text-white font-bold p-1 md:py-3 md:px-4 mr-4 duration-75 cursor-pointer how-step" data-num="1">填寫表格</a>
                                <a className="w-1/3 lg:w-1/4 rounded-full text-white font-bold p-1 md:py-3 md:px-4 duration-75 cursor-pointer how-step" data-num="2">確認訂單</a>
                            </div>
                            <div className="p-0 lg:p-16 lg:pt-16 lg:pr-0">
                                <div className="px-6 py-3 md:py-12 lg:p-16 lg:h-48 how-desp" data-num="0">
                                    <p>經Telegram / Whatsapp 搵<span className="whitespace-nowrap">埗兵機械人登入系統</span></p>
                                    <ul className="list-disc">
                                        <li>Whatsapp: 輸入"登入落單"，<span className="whitespace-nowrap">㩒連結登入</span></li>
                                        <li>Telegram: 輸入"/start"，<span  className="whitespace-nowrap">㩒"登入落單"掣登入</span></li>
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
                                ${StaticResource.image("/images/how23.png", "how", "w-4/5 rounded-t-lg inline-block")}
                            </div>
                            <div className="flex justify-center text-center lg:pt-16 how-image hidden" data-num="1">
                                ${StaticResource.image("/images/how35.png", "how", "w-4/5 rounded-t-lg inline-block")}
                            </div>
                            <div className="flex justify-center text-center lg:pt-16 how-image hidden" data-num="2">
                                ${StaticResource.image("/images/how4.png", "how", "w-4/5 rounded-t-lg inline-block")}
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

    static public function renderShops() {
        var blockClasses2 = "p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link";
        var linkClasses2 = "cursor-pointer menu";
        var thumbnailDivClasses2 = "relative btn-menu w-auto md:w-1/5 my-2 text-center";
        var shopNameClasses = "text-xs lg:text-lg lg:flex-1";
        
        return jsx('
            <Fragment>
                <div className="grid grid-cols-3 md:grid-cols-1">
                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-red-500 font-bold">
                        <i className="fas fa-map-marker-alt text-red-500"></i>&nbsp;<span>${DragonCentreCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", EightyNine])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/EightyNine/89.jpg", EightyNine.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-red-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-red-500 fas fa-circle"></i> ${EightyNine.info().name}</h1>
                                    ${restDay(EightyNine)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", LaksaStore])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/LaksaStore/laksa.jpg", LaksaStore.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-red-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-red-500 fas fa-circle"></i> ${LaksaStore.info().name}</h1>
                                    ${restDay(LaksaStore)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", KCZenzero])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/KCZenzero/tomato.jpg", KCZenzero.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-red-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-red-500 fas fa-circle"></i> ${KCZenzero.info().name}</h1>
                                    ${restDay(KCZenzero)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", HanaSoftCream])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/HanaSoftCream/hana.jpg", HanaSoftCream.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-red-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-red-500 fas fa-circle"></i> ${HanaSoftCream.info().name}</h1>
                                    ${restDay(HanaSoftCream)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", WoStreet])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/WoStreet/WoStreet.jpg", WoStreet.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-red-500 fas fa-circle"></i> ${WoStreet.info().name}</h1>
                                    ${restDay(WoStreet)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-pink-500 font-bold">
                        <i className="fas fa-map-marker-alt text-pink-500"></i>&nbsp;<span>${GoldenCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", BiuKeeLokYuen])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/BiuKeeLokYuen/bill.jpg", BiuKeeLokYuen.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-pink-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-pink-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-pink-500 fas fa-circle"></i> ${BiuKeeLokYuen.info().name}</h1>
                                    ${restDay(BiuKeeLokYuen)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", FastTasteSSP])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/FastTasteSSP/fasttaste.jpg", FastTasteSSP.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-pink-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-pink-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-pink-500 fas fa-circle"></i> ${FastTasteSSP.info().name}</h1>
                                    ${restDay(FastTasteSSP)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", BlackWindow])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/BlackWindow/BlackWindow2-sq.jpg", BlackWindow.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-pink-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-pink-500 fas fa-circle"></i> ${BlackWindow.info().name}</h1>
                                    ${restDay(BlackWindow)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-amber-600 font-bold">
                        <i className="fas fa-map-marker-alt text-amber-600"></i>&nbsp;<span>${PeiHoStreetMarketCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", FishFranSSP])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/FishFranSSP/FishFranSSP.jpg", FishFranSSP.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-amber-600 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-amber-600 fas fa-circle"></i> ${FishFranSSP.info().name}</h1>
                                    ${restDay(FishFranSSP)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-yellow-500 font-bold">
                        <i className="fas fa-map-marker-alt text-yellow-500"></i>&nbsp;<span>${SmilingPlazaCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", Neighbor])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/Neighbor/neighbor.jpg", Neighbor.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-yellow-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-yellow-500 fas fa-circle"></i> ${Neighbor.info().name}</h1>
                                    ${restDay(Neighbor)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-green-600 font-bold">
                        <i className="fas fa-map-marker-alt text-green-600"></i>&nbsp;<span>${ParkCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", TheParkByYears])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/TheParkByYears/park.jpg", TheParkByYears.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-600 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-green-600 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-green-600 fas fa-circle"></i> ${TheParkByYears.info().name}</h1>
                                    ${restDay(TheParkByYears)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", MGY])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/MGY/mgy.jpg", MGY.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-600 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-green-600 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-green-600 fas fa-circle"></i> ${MGY.info().name}</h1>
                                    ${restDay(MGY)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", PokeGo])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/PokeGo/PokeGo.jpg", PokeGo.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-600 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-green-600 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-green-600 fas fa-circle"></i> ${PokeGo.info().name}</h1>
                                    ${restDay(PokeGo)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", Minimal])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/Minimal/minimal.jpg", Minimal.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-600 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-green-600 fas fa-circle"></i> ${Minimal.info().name}</h1>
                                    ${restDay(Minimal)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-green-400 font-bold">
                        <i className="fas fa-map-marker-alt text-green-400"></i>&nbsp;<span>${CLPCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", YearsHK])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/YearsHK/years.jpg", YearsHK.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-400 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-green-400 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-green-400 fas fa-circle"></i> ${YearsHK.info().name}</h1>
                                    ${restDay(YearsHK)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", LonelyPaisley])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/LonelyPaisley/LonelyPaisley.jpeg", LonelyPaisley.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-400 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-green-400 fas fa-circle"></i> ${LonelyPaisley.info().name}</h1>
                                    ${restDay(LonelyPaisley)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-blue-500 font-bold">
                        <i className="fas fa-map-marker-alt text-blue-500"></i>&nbsp;<span>${PakTinCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", ZeppelinHotDogSKM])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/ZeppelinHotDogSKM/zeppelin.jpg", ZeppelinHotDogSKM.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-blue-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-blue-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-blue-500 fas fa-circle"></i> ${ZeppelinHotDogSKM.info().name}</h1>
                                    ${restDay(ZeppelinHotDogSKM)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", Toolss])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/Toolss/Toolss.jpg", Toolss.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-blue-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-blue-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-blue-500 fas fa-circle"></i> ${Toolss.info().name}</h1>
                                    ${restDay(Toolss)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", CafeGolden])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/CafeGolden/CafeGolden.jpeg", CafeGolden.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-blue-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-blue-500 fas fa-circle"></i> ${CafeGolden.info().name}</h1>
                                    ${restDay(CafeGolden)}
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-indigo-500 font-bold">
                        <i className="fas fa-map-marker-alt text-indigo-500"></i>&nbsp;<span>${TungChauStreetParkCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", KeiHing])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/shops/KeiHing/keihing.jpg", KeiHing.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-indigo-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-indigo-500 fas fa-circle"></i> ${KeiHing.info().name}</h1>
                                    ${restDay(KeiHing)}
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
            </Fragment>
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

                    <div className="index-sticky-nav border-b-4 border-t-4 bg-white border-black sticky top-0 z-40 text-md md:text-lg">
                        <div className="flex text-center h-12 md:h-16 mx-auto container lg:border-x-4">
                            <a className="w-1/2 flex items-center justify-center border-r-4 border-black" href="#sectionMap">
                            <span>合作餐廳&nbsp;<i className="fas fa-utensils"></i></span>
                            </a>
                            <a className="w-1/2 flex items-center justify-center" href="#sectionHow">
                            <span>點叫外賣&nbsp;<i className="fas fa-clipboard-list"></i></span>
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
                                    ${renderShops()}
                                </div>
                                <div className="md:w-2/3 border-l-4 border-black">
                                    <div id="map"></div>
                                </div>
                            </div>
                        </div>
                    </section>

                    ${howToOrderSection()}

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