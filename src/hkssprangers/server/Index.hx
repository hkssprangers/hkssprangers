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
        var title = "KOLB x 點心紙 x 埗兵 餸包湯包預訂";
        var url = "https://docs.google.com/forms/d/e/1FAIpQLSe2mSyw_3VsiK3lFcrT7lv5slIaDQUEdtpomQR8Ah8AqexJiA/viewform";
        var img = StaticResource.image("/images/kolb3-web-banner.jpg", title, "w-full");
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
                                        ${StaticResource.image("/images/ThaiYummy.jpg", ThaiYummy.info().name, "squircle mb-3")}
                                        <p className="absolute align-center-hover text-lg"><i className="text-yellow-500 fas fa-book-open"></i><br />menu</p>
                                    </div>
                                    <h4>${ThaiYummy.info().name}</h4>
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
                    <div className="p-6 md:mb-32 md:p-0 mx-auto md:w-4/5 max-w-screen-lg">
                        <div className="my-6 text-center">
                            <a href="/">
                                ${StaticResource.image("/images/logo-blk-png.png", "埗兵", "inline w-1/4 lg:w-1/6")}
                            </a>
                        </div>
                        <div className="p-6 text-xl lg:text-4xl font-bold text-center">
                            <h1 className="inline">埗兵</h1>係為<span className="whitespace-nowrap">深水埗黃店</span>服務為主嘅<span className="whitespace-nowrap">外賣平台</span>
                        </div>
                        ${banner()}
                        <div className="p-6 text-xl text-center lg:text-2xl font-bold bg-curve">
                            <h2>合作餐廳 / 商店</h2>
                        </div>
                        ${renderShops()}
                        <div className="p-6 text-xl text-center lg:text-2xl font-bold bg-curve">
                            <h2>服務資訊</h2>
                        </div>
                        <div className="bg-white rounded-xl p-6">
                            <div className="lg:flex mb-6 lg:mb-12">
                                <div className="lg:w-1/3 flex items-center">
                                    <div>
                                        <div className="text-lg font-bold mb-3"><i className="fas fa-utensils"></i> 點搵埗兵叫野食？</div>
                                        <div className="flex mb-3">
                                            <div className="border-black border-4 rounded-full w-9 h-9 flex items-center justify-center font-bold poppins">1</div>
                                            <div className="p-2">填表落單</div>
                                        </div>
                                        <div className="flex mb-3">
                                            <div className="border-black border-4 rounded-full w-9 h-9 flex items-center justify-center font-bold poppins">2</div>
                                            <div className="p-2">外賣員聯絡你</div>
                                        </div>
                                        <div className="flex mb-3">
                                            <div className="border-black border-4 rounded-full w-9 h-9 flex items-center justify-center font-bold poppins">3</div>
                                            <div className="p-2">向外賣員付款 <span className="highlight">(PayMe / FPS)</span></div>
                                        </div>
                                        <div className="flex mb-3">
                                            <div className="border-black border-4 rounded-full w-9 h-9 flex items-center justify-center font-bold poppins transform -rotate-12">4</div>
                                            <div className="p-2">好快有得食 <i className="fas fa-glass-cheers"></i></div>
                                        </div>
                                    </div>
                                </div>
                                <div className="lg:w-2/3">
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

                            <div className="lg:flex">
                                <div className="lg:w-1/3 lg:mr-6 flex">
                                    <div className="">
                                        <div className="text-lg font-bold mb-3"><i className="fas fa-map-marked-alt"></i> 埗兵送到邊？點計錢？</div>
                                        <p className="mb-3">地圖有埗兵主要送餐範圍</p>
                                        <p className="mb-3">運費計算：<br />以店舖同目的地之間嘅步行距離計算，會因應實際情況(如長樓梯)調整。</p>
                                        <div className="mb-3">
                                            步行15分鐘或以內
                                            <p className="text-xl lg:text-4xl font-bold poppins">$$25</p>
                                        </div>
                                        <div className="mb-3">
                                            步行15至20分鐘
                                            <p className="text-xl lg:text-4xl font-bold poppins">$$35</p>
                                        </div>
                                        <div className="mb-3">
                                            距離較遠需要步兵搭車或者車手
                                            <p className="text-xl lg:text-4xl font-bold poppins">$$40</p>
                                        </div>
                                    </div>
                                </div>
                                <div className="lg:w-2/3">
                                    ${StaticResource.image("/images/map3.jpg", "送餐範圍", "rounded-xl")}
                                </div>
                            </div>
                        </div>
                        ${orderButton()}
                    </div>
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