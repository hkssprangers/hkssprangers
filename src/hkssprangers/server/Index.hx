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
import hkssprangers.info.ShopCluster;
using hkssprangers.server.FastifyTools;

typedef IndexProps = {

}

class Index extends View<IndexProps> {
    override public function description() return "深水埗區外賣團隊";
    override function canonical() return "https://" + host;
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
                <link href=${R("/js/splide/splide.min.css")} rel="stylesheet"/>
                <script src=${R("/js/splide/splide.min.js")}></script>
                <script src=${R("/js/splide/banner.js")}></script>
                ${super.depScript()}
            </Fragment>
        ');
    }

    override function prefetch():Array<String> return super.prefetch().concat([
        R("/browser.bundled.js"),
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
        // return null;
        var title = "埗兵團購";
        var url = "https://docs.google.com/forms/d/e/1FAIpQLSdEA89MJzlOB-xKq3Y0qJsnzSKrweJdUSgNaKb1dsoWDxdMPg/viewform";
        var img = StaticResource.image("/images/kolb6-web-banner.jpg", title, "");
        var className = if (img == null) {
            "flex items-center place-content-center text-center bg-white h-32 text-2xl";
        } else {
            "";
        }
        return jsx('
        
        <div className=${className}>
                <a href=${url}>
                    ${img != null ? img : title}
                </a>
                </div>
            ');
    }

    static public function orderButton() return jsx('
        <div className="fixed overflow-hidden bottom-0 right-0 select-none z-40">
            <div className="flex p-5 pl-12 pt-12 relative">
                <a
                    className="flex justify-center items-center w-20 h-20 md:w-24 md:h-24 rounded-full transform-colors duration-100 ease-in-out bg-yellow-400 no-underline z-10"
                    href="/order-food"
                >
                    <span className="text-black text-center text-sm">
                        ${StaticResource.image("/images/writing.svg", "order", "w-1/2 inline", false)}
                        <br />
                        立即落單
                    </span>
                </a>
                <div className="absolute pointer-events-none w-20 h-20 top-12 md:w-24 md:h-24 rounded-full animate-ping opacity-25 bg-yellow-400 z-0">&nbsp;</div>
            </div>
        </div>
    ');

    static public function howToOrderSection() return jsx('

        <Fragment>
            <section className="h-12 md:h-16">&nbsp;</section>
            <section id="sectionHow" className="bg-white">

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
                                <div className="px-6 py-3 md:p-16 md:h-48 how-desp" data-num="0">
                                <p>經Telegram / Whatsapp 搵<span className="whitespace-nowrap">埗兵機械人登入系統</span></p>
                                <ul className="list-disc">
                                    <li>Whatsapp: 輸入"登入落單"，<span className="whitespace-nowrap">㩒連結登入</span></li>
                                    <li>Telegram: 輸入"/start"，<span  className="whitespace-nowrap">㩒"登入落單"掣登入</span></li>
                                </ul>
                                </div>
                                <div className="px-6 py-3 md:p-16 md:h-48 how-desp hidden" data-num="1">
                                <p>選擇送餐時段同食物仲有拎餐方法</p>
                                <ul className="list-disc">
                                    <li>一張單可以叫晒鄰近嘅餐廳</li>
                                    <li>唔限幾多個餐</li>
                                </ul>
                                </div>
                                <div className="px-6 py-3 md:p-16 md:h-48 how-desp hidden" data-num="2">
                                截單時間一到，埗兵外賣員就會搵你對單同收款，<span className="whitespace-nowrap">之後好快開餐~付款方法有:</span>
                                <ul className="list-disc">
                                    <li>Payme</li>
                                    <li>FPS</li>
                                </ul>
                                </div>
                            </div>
                            </div>
                            <div className="md:w-1/2">
                            <div className="flex justify-center lg:pt-16 how-image" data-num="0">
                                <img className="w-4/5 rounded-t-lg" src="images/how23.png"/>
                            </div>
                            <div className="flex justify-center lg:pt-16 how-image hidden" data-num="1">
                                <img className="w-4/5 rounded-t-lg" src="images/how35.png"/>
                            </div>
                            <div className="flex justify-center lg:pt-16 how-image hidden" data-num="2">
                                <img className="w-4/5 rounded-t-lg" src="images/how4.png"/>
                            </div>
                            </div>
                        </div>

                        <div className="md:flex md:mx-auto container pt-3 lg:pt-16">
                            <div className="md:w-1/3 lg:pr-16">
                            
                                <div className="text-lg font-bold mb-3"><i className="fas fa-map-marked-alt"></i> 埗兵運費點計?</div>
                                <p className="mb-3">運費計算:<br/>以店舖同目的地之間嘅步行距離計算，會因應實際情況(如長樓梯)調整。</p>
                                <div className="mb-3">
                                    步行15分鐘或以內
                                    <p className="text-xl lg:text-4xl font-bold poppins">$$25</p>
                                </div>
                                <div className="mb-3">
                                    步行15至20分鐘
                                    <p className="text-xl lg:text-4xl font-bold poppins">$$35</p>
                                </div>
                                <div className="mb-3">
                                    距離較遠需要車手負責外賣
                                    <p className="text-xl lg:text-4xl font-bold poppins">$$40</p>
                                </div>
                                
                            </div>
                            <div className="md:w-2/3">
                            <div className="flex mb-3">
                            <div className="p-3 border-t-4 border-b-4 border-r-4 border-yellow-300 flex items-center justify-center">
                                    <div className="border-yellow-300 border-4 rounded-full w-12 h-12 lg:w-24 lg:h-24 flex items-center justify-center text-xl  lg:text-4xl font-bold poppins transform rotate-12">午</div>
                                </div>
                                <div className="flex-1 md:flex border-t-4 border-b-4 border-yellow-300">
                                    <div className="md:w-2/3 p-3 border-b-4 md:border-b-0 md:border-r-4 border-yellow-300 flex items-center">
                                    <div>
                                        <i className="far fa-clock"></i> 派送時間
                                        <p className="text-xl lg:text-4xl font-bold poppins">12:30-14:30</p>
                                    </div>
                                    </div>
                                    <div className="p-3 border-yellow-300 flex items-center">
                                    <div>
                                        <i className="fas fa-hourglass-end"></i> 截單時間
                                        <p className="text-xl lg:text-4xl font-bold poppins">10:00</p>
                                    </div>
                                    </div>
                                </div>
                                </div>

                                <div className="flex">
                                <div className="p-3 border-t-4 border-b-4 border-r-4 border-blue-800 flex items-center justify-center">
                                    <div className="border-blue-800 border-4 rounded-full w-12 h-12 lg:w-24 lg:h-24 flex items-center justify-center text-xl lg:text-4xl font-bold poppins transform -rotate-12">晚</div>
                                </div>
                                <div className="flex-1 md:flex border-t-4 border-b-4 border-blue-800">
                                    <div className="md:w-2/3 p-3 border-b-4 md:border-b-0 md:border-r-4 border-blue-800 flex items-center">
                                    <div>
                                        <i className="far fa-clock"></i> 派送時間
                                        <p className="text-xl lg:text-4xl font-bold poppins">18:30-20:30</p>
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

    function renderShops() {
        var rowClasses          = "px-4 sm:px-6 lg:p-6 flex flex-wrap lg:flex-nowrap";
        var blockClasses        = "w-1/2 lg:flex-1 mx-auto lg:mx-0 overflow-hidden";
        var linkClasses         = "block text-center cursor-pointer rounded-3xl menu text-black py-4 sm:py-6 lg:py-0";
        var thumbnailDivClasses = "relative btn-menu w-full lg:w-36 mx-auto px-4 sm:px-6 lg:px-0 lg:max-w-full border border-white";
        return jsx('
            <Fragment>
                ${sameAreaNote()}
                <div className="bg-white mb-3 rounded-xl ">
                    <div className="pt-6 px-6">
                        <h3 className="text-lg font-bold"><i className="fas fa-map-marker-alt text-red-500"></i> ${DragonCentreCluster.info().name}</h3>
                    </div>
                    <div className=${rowClasses}>
                        <div className=${blockClasses}>
                            <a href=${Path.join(["/menu", EightyNine])} className=${linkClasses}>
                                <div className=${thumbnailDivClasses}>
                                    ${StaticResource.image("/images/89.jpg", EightyNine.info().name, "squircle mb-3")}
                                    <p className="absolute align-center-hover text-lg"><i className="text-red-500 fas fa-book-open"></i><br />menu</p>
                                </div>
                                <h4>${EightyNine.info().name}</h4>
                            </a>
                        </div>
                        <div className=${blockClasses}>
                            <a href=${Path.join(["/menu", LaksaStore])} className=${linkClasses}>
                                <div className=${thumbnailDivClasses}>
                                    ${StaticResource.image("/images/laksa.jpg", LaksaStore.info().name, "squircle mb-3")}
                                    <p className="absolute align-center-hover text-lg"><i className="text-red-500 fas fa-book-open"></i><br />menu</p>
                                </div>
                                <h4>${LaksaStore.info().name}</h4>
                                <p className="text-xs">逢星期三休息</p>
                            </a>
                        </div>
                        <div className=${blockClasses}>
                            <a href=${Path.join(["/menu", DragonJapaneseCuisine])} className=${linkClasses}>
                                <div className=${thumbnailDivClasses}>
                                    ${StaticResource.image("/images/yyp.jpg", DragonJapaneseCuisine.info().name, "squircle mb-3")}
                                    <p className="absolute align-center-hover text-lg"><i className="text-red-500 fas fa-book-open"></i><br />menu</p>
                                </div>
                                <h4>${DragonJapaneseCuisine.info().name}</h4>
                            </a>
                        </div>
                        <div className=${blockClasses}>
                            <a href=${Path.join(["/menu", KCZenzero])} className=${linkClasses}>
                                <div className=${thumbnailDivClasses}>
                                    ${StaticResource.image("/images/tomato.jpg", KCZenzero.info().name, "squircle mb-3")}
                                    <p className="absolute align-center-hover text-lg"><i className="text-red-500 fas fa-book-open"></i><br />menu</p>
                                </div>
                                <h4>${KCZenzero.info().name}</h4>
                            </a>
                        </div>
                        <div className=${blockClasses}>
                            <a href=${Path.join(["/menu", HanaSoftCream])} className=${linkClasses}>
                                <div className=${thumbnailDivClasses}>
                                    ${StaticResource.image("/images/hana.jpg", HanaSoftCream.info().name, "squircle mb-3")}
                                    <p className="absolute align-center-hover text-lg"><i className="text-red-500 fas fa-book-open"></i><br />menu</p>
                                </div>
                                <h4>${HanaSoftCream.info().name}</h4>
                            </a>
                        </div>
                        <div className=${blockClasses}>
                            <a href=${Path.join(["/menu", WoStreet])} className=${linkClasses}>
                                <div className=${thumbnailDivClasses}>
                                    ${StaticResource.image("/images/WoStreet.jpg", WoStreet.info().name, "squircle mb-3")}
                                    <p className="absolute align-center-hover text-lg"><i className="text-red-500 fas fa-book-open"></i><br />menu</p>
                                </div>
                                <h4>${WoStreet.info().name}</h4>
                            </a>
                        </div>
                        <div className="clear-both lg:hidden"></div>
                    </div>
                </div>
                <div className="lg:grid lg:grid-cols-5 lg:gap-3">
                    <div className="lg:col-span-3 mb-3 bg-white rounded-xl">
                        <div className="pt-6 px-6">
                            <h3 className="text-lg font-bold"><i className="fas fa-map-marker-alt text-pink-500"></i> ${GoldenCluster.info().name}</h3>
                        </div>
                        <div className=${rowClasses}>
                            <div className=${blockClasses}>
                                <a href=${Path.join(["/menu", BiuKeeLokYuen])} className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/bill.jpg", BiuKeeLokYuen.info().name, "squircle mb-3")}
                                        <p className="absolute align-center-hover text-lg"><i className="text-pink-500 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4>${BiuKeeLokYuen.info().name}</h4>
                                </a>
                            </div>
                            <div className=${blockClasses}>
                                <a href=${Path.join(["/menu", FastTasteSSP])} className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/fasttaste.jpg", FastTasteSSP.info().name, "squircle mb-3")}
                                        <p className="absolute align-center-hover text-lg"><i className="text-pink-500 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4>${FastTasteSSP.info().name}</h4>
                                </a>
                            </div>
                            <div className=${blockClasses}>
                                <a href=${Path.join(["/menu", BlaBlaBla])} className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/bla.jpg", BlaBlaBla.info().name, "squircle mb-3 opacity-50")}
                                        <p className="absolute align-center-hover text-lg"><i className="text-pink-500 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4 className="text-gray-500">${BlaBlaBla.info().name}</h4>
                                    <p className="text-xs text-gray-500">已結業</p>
                                </a>
                            </div>
                            <div className="clear-both lg:hidden"></div>
                        </div>
                    </div>
                    <div className="lg:col-span-2 mb-3 bg-white rounded-xl">
                        <div className="pt-6 px-6">
                            <h3 className="text-lg font-bold"><i className="fas fa-map-marker-alt text-yellow-500"></i> ${SmilingPlazaCluster.info().name}</h3>
                        </div>
                        <div className=${rowClasses}>
                            <div className=${blockClasses}>
                                <a href=${Path.join(["/menu", Neighbor])} className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/neighbor.jpg", Neighbor.info().name, "squircle mb-3")}
                                        <p className="absolute align-center-hover text-lg"><i className="text-yellow-500 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4>${Neighbor.info().name}</h4>
                                </a>
                            </div>
                            <div className=${blockClasses}>
                                <a href=${Path.join(["/menu", ThaiYummy])} className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/ThaiYummy.jpg", ThaiYummy.info().name, "squircle mb-3 opacity-50")}
                                        <p className="absolute align-center-hover text-lg"><i className="text-yellow-500 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4 className="text-gray-500">${ThaiYummy.info().name}</h4>
                                    <p className="text-xs text-gray-500">埗兵外賣暫停</p>
                                </a>
                            </div>
                            <div className="clear-both lg:hidden"></div>
                        </div>
                    </div>
                </div>
                <div className="lg:grid lg:grid-cols-5 lg:gap-3">
                    <div className="lg:col-span-3 mb-3 bg-white rounded-xl">
                        <div className="pt-6 px-6">
                            <h3 className="text-lg font-bold"><i className="fas fa-map-marker-alt text-green-600"></i> ${ParkCluster.info().name}</h3>
                        </div>
                        <div className=${rowClasses}>
                            <div className=${blockClasses}>
                                <a href=${Path.join(["/menu", TheParkByYears])} className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/park.jpg", TheParkByYears.info().name, "squircle mb-3")}
                                        <p className="absolute align-center-hover text-lg"><i className="text-green-600 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4>${TheParkByYears.info().name}</h4>
                                </a>
                            </div>
                            <div className=${blockClasses}>
                                <a href=${Path.join(["/menu", MGY])} className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/mgy.jpg", MGY.info().name, "squircle mb-3")}
                                        <p className="absolute align-center-hover text-lg"><i className="text-green-600 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4>${MGY.info().name}</h4>
                                    <p className="text-xs">逢星期一休息</p>
                                </a>
                            </div>
                            <div className=${blockClasses}>
                                <a href=${Path.join(["/menu", PokeGo])} className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/PokeGo.jpg", PokeGo.info().name, "squircle mb-3")}
                                        <p className="absolute align-center-hover text-lg"><i className="text-green-600 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4>${PokeGo.info().name}</h4>
                                </a>
                            </div>
                            <div className="clear-both lg:hidden"></div>
                        </div>
                    </div>
                    <div className="lg:col-span-2 mb-3 bg-white rounded-xl">
                        <div className="pt-6 px-6">
                            <h3 className="text-lg font-bold"><i className="fas fa-map-marker-alt text-green-400"></i> ${CLPCluster.info().name}</h3>
                        </div>
                        <div className=${rowClasses}>
                            <div className=${blockClasses}>
                                <a href=${Path.join(["/menu", YearsHK])} className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/years.jpg", YearsHK.info().name, "squircle mb-3")}
                                        <p className="absolute align-center-hover text-lg"><i className="text-green-400 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4>${YearsHK.info().name}</h4>
                                </a>
                            </div>
                            <div className=${blockClasses}>
                                <a href=${Path.join(["/menu", DongDong])} className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/dong.jpg", DongDong.info().name, "squircle mb-3 opacity-50")}
                                        <p className="absolute align-center-hover text-lg"><i className="text-green-400 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4 className="text-gray-500">${DongDong.info().name}</h4>
                                    <p className="text-xs text-gray-500">已結業</p>
                                </a>
                            </div>
                            <div className="clear-both lg:hidden"></div>
                        </div>
                    </div>
                </div>
                <div className="lg:grid lg:grid-cols-4 lg:gap-3">
                    <div className="lg:col-span-2 mb-3 bg-white rounded-xl">
                        <div className="pt-6 px-6">
                            <h3 className="text-lg font-bold"><i className="fas fa-map-marker-alt text-blue-500"></i> ${PakTinCluster.info().name}</h3>
                        </div>
                        <div className=${rowClasses}>
                            <div className=${blockClasses}>
                                <a href=${Path.join(["/menu", ZeppelinHotDogSKM])} className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/zeppelin.jpg", ZeppelinHotDogSKM.info().name, "squircle mb-3")}
                                        <p className="absolute align-center-hover text-lg"><i className=" text-blue-500 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4>${ZeppelinHotDogSKM.info().name}</h4>
                                </a>
                            </div>
                            <div className=${blockClasses}>
                                <a href=${Path.join(["/menu", Toolss])} className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/Toolss.jpg", Toolss.info().name, "squircle mb-3")}
                                        <p className="absolute align-center-hover text-lg"><i className=" text-blue-500 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4>${Toolss.info().name}</h4>
                                    <p className="text-xs">逢星期一休息</p>
                                </a>
                            </div>
                            <div className="clear-both lg:hidden"></div>
                        </div>
                    </div>
                    <div className="mb-3 bg-white rounded-xl">
                        <div className="pt-6 px-6">
                            <h3 className="text-lg font-bold"><i className="fas fa-map-marker-alt text-indigo-500"></i> ${TungChauStreetParkCluster.info().name}</h3>
                        </div>
                        <div className=${rowClasses}>
                            <div className=${blockClasses}>
                                <a href=${Path.join(["/menu", KeiHing])} className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/keihing.jpg", KeiHing.info().name, "squircle mb-3")}
                                        <p className="absolute align-center-hover text-lg"><i className="text-indigo-500 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4>${KeiHing.info().name}</h4>
                                </a>
                            </div>
                            <div className="clear-both lg:hidden"></div>
                        </div>
                    </div>
                    <div className="mb-3 bg-white rounded-xl">
                        <div className="pt-6 px-6">
                            <h3 className="text-lg font-bold"><i className="fas fa-star text-grey-500"></i> 消毒用品</h3>
                        </div>
                        <div className=${rowClasses}>
                            <div className=${blockClasses}>
                                <a href="https://docs.google.com/forms/d/e/1FAIpQLSebHaeo7cEqGTsNKSBk7s27Jlok4WSLJJc2IRoZa39A6TrAiw/viewform" className=${linkClasses}>
                                    <div className=${thumbnailDivClasses}>
                                        ${StaticResource.image("/images/hyginova.jpg", "Hyginova", "squircle mb-3")}
                                        <p className="absolute align-center-hover text-lg"><i className="text-grey-500 fas fa-shopping-cart"></i><br />預訂</p>
                                    </div>
                                    <h4>Hyginova</h4>
                                </a>
                            </div>
                            <div className="clear-both lg:hidden"></div>
                        </div>
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
                    <div className="p-3 lg:px-0 md:py-6 mx-auto container">

                        <div className="flex items-center">
                            <a href="/">
                                ${StaticResource.image("/images/logo-blk-png.png", "埗兵", "inline w-12 lg:w-16")}
                            </a>
                            <div className="flex-1 pl-3">
                                <b className="text-lg lg:text-xl">埗兵</b>
                                <p>為深水埗黃店服務為主嘅外賣平台</p>
                            </div>
                            <div className="hidden md:block">
                                <a className="py-3 px-6 flex items-center justify-center rounded-md bg-black text-white" href="/">立即落單</a>
                            </div>
                        </div>
                    </div>
                    ${banner()}
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
                            <div className="mx-3 lg:mx-0 md:flex border-4 border-black text-center md:text-left">
                                <div className="container-rest md:w-1/3 md:overflow-y-scroll bg-white">
                                    <div className="container-rest-caption border-b-4 bg-white border-black px-6 py-3">
                                    可以同一張單叫晒鄰近嘅餐廳唔限幾多個餐，<span className="whitespace-nowrap">埗兵送埋俾你</span>
                                    </div>
                                    <div className="grid grid-cols-3 md:grid-cols-1">
                
                                        <div className="hidden md:flex items-center px-6 py-3 bg-pt-red-500 font-bold">
                                            <i className="fas fa-map-marker-alt text-red-500"></i>&nbsp;<span>西九龍中心</span>
                                            <span className="flex-1 mx-3">&nbsp;</span>
                                            <span className="">6</span>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="89.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/89.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-red-500 text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">89美食</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="laksa.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/laksa.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-red-500 text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">喇沙專門店</h1>
                                                    <h3 className="text-xs">逢星期三休息</h3>
                                                </div>
                                                </div>
                                            </a>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="yyp.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/yyp.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-red-500 text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">營業部</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="tomato.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/tomato.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-red-500 text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">蕃廚</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="hana.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/hana.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-red-500 text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">HANA SOFT CREAM</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="hana.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/WoStreet.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">窩Street</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>
                                        
                                        <div className="hidden md:flex items-center px-6 py-3 bg-pt-pink-500 font-bold">
                                            <i className="fas fa-map-marker-alt text-pink-500"></i>&nbsp;<span>黃金商場</span>
                                            <span className="flex-1 mx-3">&nbsp;</span>
                                            <span className="">2</span>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="bill.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/bill.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-pink-500 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-pink-500 text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">標記樂園潮州粉麵菜館</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="fasttaste.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/fasttaste.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-pink-500 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">Fast Taste SSP</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>

                                        <div className="hidden md:flex items-center px-6 py-3 bg-pt-yellow-500 font-bold">
                                            <i className="fas fa-map-marker-alt text-yellow-500"></i>&nbsp;<span>天悅廣場</span>
                                            <span className="flex-1 mx-3">&nbsp;</span>
                                            <span className="">1</span>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="neighbor.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/neighbor.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-yellow-500 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">Neighbor</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>



                                        <div className="hidden md:flex items-center px-6 py-3 bg-pt-green-600 font-bold">
                                            <i className="fas fa-map-marker-alt text-green-600"></i>&nbsp;<span>石硤尾街休憩花園</span>
                                            <span className="flex-1 mx-3">&nbsp;</span>
                                            <span className="">3</span>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="park.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/park.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-600 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-green-600 text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">The Park by Years</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="mgy.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/mgy.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-600 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-green-600 text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">梅貴緣</h1>
                                                    <h3 className="text-xs">逢星期一休息</h3>
                                                </div>
                                                </div>
                                            </a>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="PokeGo.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/PokeGo.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-600 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">Poke Go</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>


                                        <div className="hidden md:flex items-center px-6 py-3 bg-pt-green-400 font-bold">
                                            <i className="fas fa-map-marker-alt text-green-400"></i>&nbsp;<span>中電</span>
                                            <span className="flex-1 mx-3">&nbsp;</span>
                                            <span className="">1</span>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="years.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/years.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-400 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">Years</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>

                                        <div className="hidden md:flex items-center px-6 py-3 bg-pt-blue-500 font-bold">
                                            <i className="fas fa-map-marker-alt text-blue-500"></i>&nbsp;<span>白田</span>
                                            <span className="flex-1 mx-3">&nbsp;</span>
                                            <span className="">2</span>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="zeppelin.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/zeppelin.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-blue-500 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-blue-500 text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">Zeppelin Hot Dog</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="zeppelin.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/Toolss.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-blue-500 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">Toolss</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>


                                        <div className="hidden md:flex items-center px-6 py-3 bg-pt-indigo-500 font-bold">
                                            <i className="fas fa-map-marker-alt text-indigo-500"></i>&nbsp;<span>通州街公園</span>
                                            <span className="flex-1 mx-3">&nbsp;</span>
                                            <span className="">1</span>
                                        </div>

                                        <div className="p-3 md:py-0 md:pr-0 md:pl-6 inline-block menu-link">
                                            <a href="zeppelin.html" className="cursor-pointer menu">
                                                <div className="md:flex"> 
                                                <div className="relative btn-menu w-auto md:w-1/5 my-2 text-center">
                                                    <img className="squircle" src="images/keihing.jpg"/>
                                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-indigo-500 fas fa-book-open"></i><br/>menu</p>
                                                </div>
                                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                                    <h1 className="text-xs lg:text-lg lg:flex-1">琦興餐廳</h1>
                                                </div>
                                                </div>
                                            </a>
                                        </div>


                                    </div>
                                </div>
                                <div className="md:w-2/3 border-l-4 border-black">
                                    <div id="map">map</div>
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