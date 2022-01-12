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
                <script src="https://api.mapbox.com/mapbox-gl-js/v2.4.1/mapbox-gl.js"></script>
                <link href="https://api.mapbox.com/mapbox-gl-js/v2.4.1/mapbox-gl.css" rel="stylesheet"/>
                <script src=${R("/js/map/map.js")}></script>
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
        return null;
        var title1 = "喇沙暖胃肉骨茶";
        var url1 = "/menu/LaksaStore";
        var img1 = StaticResource.image("/images/laksa-buk.jpg", title1, "");
        
        var title4 = "標記羊腩煲";
        var url4 = "/menu/BiuKeeLokYuen";
        var img4 = StaticResource.image("/images/bill-pot.jpg", title4, "");
        
        var title5 = "Poke Go 聖誕新年大餐";
        var url5 = "/menu/PokeGo";
        var img5 = StaticResource.image("/images/xmas-pokego.jpg", title5, "");
        
        var title6 = "埗兵更新服務時間";
        var url6 = "/";
        var img6 = StaticResource.image("/images/newhour.jpg", title6, "");
        
        var title7 = "梅貴緣埗兵埗埗糕昇大行動";
        var url7 = "https://docs.google.com/forms/d/e/1FAIpQLSenLJEbpw4-IDRZdGKQs2wERhYF-jFv0uVxx8WQ-UuVJPlTPQ/viewform";
        var img7 = StaticResource.image("/images/mgy-cake-1.jpg", title7, "");
        
        var title8 = "梅貴緣埗兵埗埗糕昇大行動";
        var url8 = "https://docs.google.com/forms/d/e/1FAIpQLSenLJEbpw4-IDRZdGKQs2wERhYF-jFv0uVxx8WQ-UuVJPlTPQ/viewform";
        var img8 = StaticResource.image("/images/mgy-cake-2.jpg", title8, "");
        
        
        
        return jsx('
        
        <div className="p-3 lg:px-0 lg:pb-6 mx-auto container">
            <div className="splide">
                <div className="splide__track">
                    <ul className="splide__list">
                        <li className="splide__slide"><a href="${url7}"><div className="pr-1 md:p-3">${img7 != null ? img7 : title7}</div></a></li>
                        <li className="splide__slide"><a href="${url8}"><div className="pr-1 md:p-3">${img8 != null ? img8 : title8}</div></a></li>
                        <li className="splide__slide"><a href="${url1}"><div className="pr-1 md:p-3">${img1 != null ? img1 : title1}</div></a></li>
                        <li className="splide__slide"><a href="${url4}"><div className="pr-1 md:p-3">${img4 != null ? img4 : title4}</div></a></li>
                        <li className="splide__slide"><a href="${url5}"><div className="pr-1 md:p-3">${img5 != null ? img5 : title5}</div></a></li>
                        <li className="splide__slide"><a href="${url6}"><div className="pr-1 md:p-3">${img6 != null ? img6 : title6}</div></a></li>
                    </ul>
                </div>
            </div>
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
                                    <div className="border-blue-800 border-4 rounded-full w-12 h-12 lg:w-24 lg:h-24 flex items-center justify-center text-xl lg:text-4xl font-bold poppins transform -rotate-12">晚</div>
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
                        <span className="">5</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", EightyNine])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/89.jpg", EightyNine.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-red-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-red-500 fas fa-circle"></i> ${EightyNine.info().name}</h1>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", LaksaStore])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/laksa.jpg", LaksaStore.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-red-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-red-500 fas fa-circle"></i> ${LaksaStore.info().name}</h1>
                                    <p className="text-xs">逢星期三休息</p>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", KCZenzero])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/tomato.jpg", KCZenzero.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-red-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-red-500 fas fa-circle"></i> ${KCZenzero.info().name}</h1>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", HanaSoftCream])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/hana.jpg", HanaSoftCream.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-red-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-red-500 fas fa-circle"></i> ${HanaSoftCream.info().name}</h1>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", WoStreet])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/WoStreet.jpg", WoStreet.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-red-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-red-500 fas fa-circle"></i> ${WoStreet.info().name}</h1>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-pink-500 font-bold">
                        <i className="fas fa-map-marker-alt text-pink-500"></i>&nbsp;<span>${GoldenCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                        <span className="">2</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", BiuKeeLokYuen])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/bill.jpg", BiuKeeLokYuen.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-pink-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-pink-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-pink-500 fas fa-circle"></i> ${BiuKeeLokYuen.info().name}</h1>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", FastTasteSSP])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/fasttaste.jpg", FastTasteSSP.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-pink-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-pink-500 fas fa-circle"></i> ${FastTasteSSP.info().name}</h1>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-yellow-500 font-bold">
                        <i className="fas fa-map-marker-alt text-yellow-500"></i>&nbsp;<span>${SmilingPlazaCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                        <span className="">1</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", Neighbor])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/neighbor.jpg", Neighbor.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-yellow-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-yellow-500 fas fa-circle"></i> ${Neighbor.info().name}</h1>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-green-600 font-bold">
                        <i className="fas fa-map-marker-alt text-green-600"></i>&nbsp;<span>${ParkCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                        <span className="">3</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", TheParkByYears])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/park.jpg", TheParkByYears.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-600 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-green-600 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-green-600 fas fa-circle"></i> ${TheParkByYears.info().name}</h1>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", MGY])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/mgy.jpg", MGY.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-600 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-green-600 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-green-600 fas fa-circle"></i> ${MGY.info().name}</h1>
                                    <p className="text-xs">逢星期一休息</p>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", PokeGo])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/PokeGo.jpg", PokeGo.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-600 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-green-600 fas fa-circle"></i> ${PokeGo.info().name}</h1>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-green-400 font-bold">
                        <i className="fas fa-map-marker-alt text-green-400"></i>&nbsp;<span>${CLPCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                        <span className="">1</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", YearsHK])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/years.jpg", YearsHK.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-green-400 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-green-400 fas fa-circle"></i> ${YearsHK.info().name}</h1>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-blue-500 font-bold">
                        <i className="fas fa-map-marker-alt text-blue-500"></i>&nbsp;<span>${PakTinCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                        <span className="">2</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", ZeppelinHotDogSKM])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/zeppelin.jpg", ZeppelinHotDogSKM.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-blue-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center md:border-b md:border-blue-500 text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-blue-500 fas fa-circle"></i> ${ZeppelinHotDogSKM.info().name}</h1>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", Toolss])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/Toolss.jpg", Toolss.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-blue-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-blue-500 fas fa-circle"></i> ${Toolss.info().name}</h1>
                                    <p className="text-xs">逢星期一休息</p>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div className="hidden md:flex items-center px-6 py-3 bg-pt-indigo-500 font-bold">
                        <i className="fas fa-map-marker-alt text-indigo-500"></i>&nbsp;<span>${TungChauStreetParkCluster.info().name}</span>
                        <span className="flex-1 mx-3">&nbsp;</span>
                        <span className="">1</span>
                    </div>

                    <div className=${blockClasses2}>
                        <a href=${Path.join(["/menu", KeiHing])} className=${linkClasses2}>
                            <div className="md:flex"> 
                                <div className=${thumbnailDivClasses2}>
                                    ${StaticResource.image("/images/keihing.jpg", KeiHing.info().name, "squircle")}
                                    <p className="absolute align-center-hover text-xs lg:text-lg"><i className="text-indigo-500 fas fa-book-open"></i><br/>menu</p>
                                </div>
                                <div className="md:ml-3 md:pr-6 md:flex-1 flex flex-col justify-center lg:flex-row lg:items-center text-center md:text-left">
                                    <h1 className=${shopNameClasses}> <i className="md:hidden text-indigo-500 fas fa-circle"></i> ${KeiHing.info().name}</h1>
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
                    ${banner()}

                    <div className="p-3 pb-9 lg:px-3 lg:pb-9 mx-auto container">
                        <div className="grid gap-8 grid-cols-2 md:grid-cols-3">
                            <div className="">
                                <div className="flex">
                                    新年必備
                                    <div className="flex-1 ml-3 bg-border-black" >&nbsp;</div>
                                </div>
                                <a href="https://docs.google.com/forms/d/e/1FAIpQLSenLJEbpw4-IDRZdGKQs2wERhYF-jFv0uVxx8WQ-UuVJPlTPQ/viewform">
                                ${StaticResource.image("/images/2022-cake-43.jpg", "埗兵", "w-100 my-3")}
                                </a>
                                <a className="py-3 px-6 flex items-center justify-center rounded-md bg-yellow-500 text-black" href="https://docs.google.com/forms/d/e/1FAIpQLSenLJEbpw4-IDRZdGKQs2wERhYF-jFv0uVxx8WQ-UuVJPlTPQ/viewform">立即落單</a>
                            </div>
                        
                            <div className="hidden md:block">
                                <div className="flex">
                                    年廿八好幫手
                                    <div className="flex-1 ml-3 bg-border-black" >&nbsp;</div>
                                </div>
                                <a href="https://docs.google.com/forms/d/e/1FAIpQLSebHaeo7cEqGTsNKSBk7s27Jlok4WSLJJc2IRoZa39A6TrAiw/viewform">
                                ${StaticResource.image("/images/hyginova43.jpg", "埗兵", "w-100 my-3")}
                                </a>
                                <a className="py-3 px-6 flex items-center justify-center rounded-md bg-yellow-500 text-black" href="https://docs.google.com/forms/d/e/1FAIpQLSebHaeo7cEqGTsNKSBk7s27Jlok4WSLJJc2IRoZa39A6TrAiw/viewform">立即落單</a>
                            </div>

                            <div className="">
                                <div className="flex">
                                    賀年必需酒
                                    <div className="flex-1 ml-3 bg-border-black" >&nbsp;</div>
                                </div>
                                <a href="https://docs.google.com/forms/d/e/1FAIpQLSeGTMjsQNdySCu7RpYIJ3zjHSNE1p3u01dfBIEYa2i7u5AHrg/viewform">
                                ${StaticResource.image("/images/wine2022-cny.jpg", "埗兵", "w-100 my-3")}
                                </a>
                                <a className="py-3 px-6 flex items-center justify-center rounded-md bg-yellow-500 text-black" href="https://docs.google.com/forms/d/e/1FAIpQLSeGTMjsQNdySCu7RpYIJ3zjHSNE1p3u01dfBIEYa2i7u5AHrg/viewform">立即落單</a>
                            </div>
                        </div>
                    </div>

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