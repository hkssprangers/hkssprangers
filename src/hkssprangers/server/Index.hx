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
using hkssprangers.server.FastifyTools;

class Index extends View {
    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

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

    static final isNewSystemReleased = switch ServerMain.deployStage {
        case dev | master: true;
        case production: false;
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

    function banner() return !isNewSystemReleased ? null : jsx('
        <div className="bg-yellow-400 text-center md:text-left px-2">
            <div className="mx-auto md:w-4/5 py-6 md:flex max-w-screen-lg">
                <lord-icon
                    src="https://cdn.lordicon.com//lupuorrc.json"
                    trigger="loop"
                    colors="primary:#121331,secondary:#ffffff"
                    stroke="70"
                    style=${{ width: 60, height: 60 }}>
                </lord-icon>
                <div className="flex-grow md:ml-3">
                    <p className="text-lg font-bold">埗兵新系統出世啦!</p>
                    <p>所有餐廳而家分為唔同區域，可以同一張單叫晒鄰近嘅餐廳，埗兵送埋俾你!</p>
                </div>
            </div>
        </div>
    ');

    static public function orderButton() return jsx('
        <div className="fixed overflow-hidden bottom-0 right-0 select-none">
            <div className="p-5 pl-12 pt-12">
                <div className="absolute pointer-events-none w-20 h-20 md:w-24 md:h-24 rounded-full animate-ping opacity-25 bg-yellow-400">&nbsp;</div>
                <a
                    className="flex justify-center items-center w-20 h-20 md:w-24 md:h-24 rounded-full transform-colors duration-100 ease-in-out bg-yellow-400 hover:bg-yellow-1000 no-underline"
                    href="/order-food"
                >
                    <span className="text-black text-center text-sm">
                        ${StaticResource.image("/images/writing.svg", "order", "w-1/2 inline", false)}
                        <br />
                        立即落單
                    </span>
                </a>
            </div>
        </div>
    ');

    override function bodyContent() {
        return jsx('
            <Fragment>
                ${banner()}
                <main>
                    <div className="p-6 md:mb-32 md:p-0 mx-auto md:w-4/5 max-w-screen-lg">
                        <div className="my-6 text-center">
                            <a href="/">
                                ${StaticResource.image("/images/logo-blk-png.png", "埗兵", "inline w-1/4 lg:w-1/6")}
                            </a>
                        </div>
                        <div className="p-6 text-xl lg:text-4xl font-bold text-center">
                            埗兵係為<span className="whitespace-nowrap">深水埗黃店</span>服務為主嘅<span className="whitespace-nowrap">外賣平台</span>
                        </div>
                        <div className="p-6 text-xl text-center lg:text-2xl font-bold bg-curve">
                            合作餐廳 / 商店
                        </div>
                        ${isNewSystemReleased ? sameAreaNote() : null}
                        <div className="bg-white mb-3 rounded-xl ">
                            <div className="pt-6 px-6">
                                <h3 className="text-lg font-bold"><i className="fas fa-map-marker-alt text-red-500"></i> 西九龍中心</h3>
                            </div>
                            <div className="lg:flex">
                                <div className="lg:w-1/4 p-6 h-36 lg:h-auto ice-cream">
                                    <p className="pr-20 lg:pr-0">幫襯任何一間餐廳都可以加購 HANA SOFT CREAM 雪糕 / 特飲</p>
                                </div>
                                <div className="lg:w-3/4 p-6 lg:flex text-center">
                                    <div className="flex flex-1 justify-center mb-6 lg:mb-0">
                                        <a href=${isNewSystemReleased ? Path.join(["/menu", EightyNine]) : formUrls[EightyNine]} className="w-1/2 lg:w-36 mr-3 lg:mr-auto mx-auto text-center cursor-pointer rounded-3xl p-2 menu text-black">
                                            <div className="relative btn-menu">
                                                ${StaticResource.image("/images/89.jpg", EightyNine.info().name, "squircle mb-3")}
                                                <p className="absolute align-center-hover text-lg"><i className="text-red-500 fas fa-book-open"></i><br />menu</p>
                                            </div>
                                            <h1>${EightyNine.info().name}</h1>
                                        </a>
                                        <a href=${isNewSystemReleased ? Path.join(["/menu", LaksaStore]) : formUrls[LaksaStore]} className="w-1/2 lg:w-36 mx-auto text-center cursor-pointer rounded-3xl p-2 menu text-black">
                                            <div className="relative btn-menu">
                                                ${StaticResource.image("/images/laksa.jpg", LaksaStore.info().name, "squircle mb-3")}
                                                <p className="absolute align-center-hover text-lg"><i className="text-red-500 fas fa-book-open"></i><br />menu</p>
                                            </div>
                                            <h1>${LaksaStore.info().name}</h1>
                                            <p className="text-xs">逢星期三休息</p>
                                        </a>
                                    </div>
                                    <div className="flex flex-1 justify-center">
                                        <a href=${isNewSystemReleased ? Path.join(["/menu", DragonJapaneseCuisine]) : formUrls[DragonJapaneseCuisine]} className="w-1/2 lg:w-36 mr-3 lg:mr-auto mx-auto text-center cursor-pointer rounded-3xl p-2 menu  text-black">
                                            <div className="relative btn-menu">
                                                ${StaticResource.image("/images/yyp.jpg", DragonJapaneseCuisine.info().name, "squircle mb-3")}
                                                <p className="absolute align-center-hover text-lg"><i className="text-red-500 fas fa-book-open"></i><br />menu</p>
                                            </div>
                                            <h1>${DragonJapaneseCuisine.info().name}</h1>
                                        </a>
                                        <a href=${isNewSystemReleased ? Path.join(["/menu", KCZenzero]) : formUrls[KCZenzero]} className="w-1/2 lg:w-36 mx-auto text-center cursor-pointer rounded-3xl p-2 menu  text-black">
                                            <div className="relative btn-menu">
                                                ${StaticResource.image("/images/tomato.jpg", KCZenzero.info().name, "squircle mb-3")}
                                                <p className="absolute align-center-hover text-lg"><i className="text-red-500 fas fa-book-open"></i><br />menu</p>
                                            </div>
                                            <h1>${KCZenzero.info().name}</h1>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div className="lg:flex">
                            <div className="lg:w-2/3 mb-3 bg-white rounded-xl">
                                <div className="pt-6 px-6">
                                    <h3 className="text-lg font-bold"><i className="fas fa-map-marker-alt text-pink-500"></i> 黃金商場</h3>
                                </div>
                                <div className="lg:flex">
                                    <div className="lg:w-1/4 p-6 h-36 lg:h-auto blabla">
                                        <p className="pr-20 lg:pr-0">幫襯任何一間餐廳都可以加購壺說飲品</p>
                                    </div>
                                    <div className="lg:w-3/4 p-6">
                                        <div className="flex justify-center">
                                            <a href=${isNewSystemReleased ? Path.join(["/menu", BiuKeeLokYuen]) : formUrls[BiuKeeLokYuen]} className="w-1/2 lg:w-36 mr-3 lg:mr-auto mx-auto text-center cursor-pointer rounded-3xl p-2 menu text-black">
                                                <div className="relative btn-menu">
                                                    ${StaticResource.image("/images/bill.jpg", BiuKeeLokYuen.info().name, "squircle mb-3")}
                                                    <p className="absolute align-center-hover text-lg"><i className="text-pink-500 fas fa-book-open"></i><br />menu</p>
                                                </div>
                                                <h1>${BiuKeeLokYuen.info().name}</h1>
                                            </a>
                                            <a href=${isNewSystemReleased ? Path.join(["/menu", FastTasteSSP]) : formUrls[FastTasteSSP]} className="w-1/2 lg:w-36 mx-auto text-center cursor-pointer rounded-3xl p-2 menu text-black">
                                                <div className="relative btn-menu">
                                                    ${StaticResource.image("/images/fasttaste.jpg", FastTasteSSP.info().name, "squircle mb-3")}
                                                    <p className="absolute align-center-hover text-lg"><i className="text-pink-500 fas fa-book-open"></i><br />menu</p>
                                                </div>
                                                <h1>${FastTasteSSP.info().name}</h1>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div className="lg:w-1/3 mb-3 lg:ml-3 bg-white rounded-xl">
                                <div className="pt-6 px-6">
                                    <h3 className="text-lg font-bold"><i className="fas fa-map-marker-alt text-yellow-600"></i> 天悅廣場</h3>
                                </div>
                                <div className="p-6 flex">
                                    <a href=${isNewSystemReleased ? Path.join(["/menu", Neighbor]) : formUrls[Neighbor]} className="w-1/2 lg:w-36 mx-auto text-center cursor-pointer rounded-3xl p-2 menu text-black">
                                        <div className="relative btn-menu">
                                            ${StaticResource.image("/images/neighbor.jpg", Neighbor.info().name, "squircle mb-3")}
                                            <p className="absolute align-center-hover text-lg"><i className="text-yellow-600 fas fa-book-open"></i><br />menu</p>
                                        </div>
                                        <h1>${Neighbor.info().name}</h1>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div className="lg:flex">
                            <div className="lg:w-1/2 mb-3 bg-white rounded-xl">
                                <div className="pt-6 px-6">
                                    <h3 className="text-lg font-bold"><i className="fas fa-map-marker-alt text-green-600"></i> 石硤尾街休憩花園</h3>
                                </div>
                                <div className="p-6 text-center">
                                    <div className="flex justify-center">
                                        <a href=${isNewSystemReleased ? Path.join(["/menu", TheParkByYears]) : formUrls[TheParkByYears]} className="w-1/2 lg:w-36 mr-3 lg:mr-auto mx-auto text-center cursor-pointer rounded-3xl p-2 menu text-black">
                                            <div className="relative btn-menu">
                                                ${StaticResource.image("/images/park.jpg", TheParkByYears.info().name, "squircle mb-3")}
                                                <p className="absolute align-center-hover text-lg"><i className="text-green-600 fas fa-book-open"></i><br />menu</p>
                                            </div>
                                            <h1>${TheParkByYears.info().name}</h1>
                                        </a>
                                        <a href=${isNewSystemReleased ? Path.join(["/menu", MGY]) : formUrls[MGY]} className="w-1/2 lg:w-36 mx-auto text-center cursor-pointer rounded-3xl p-2 menu text-black">
                                            <div className="relative btn-menu">
                                                ${StaticResource.image("/images/mgy.jpg", MGY.info().name, "squircle mb-3")}
                                                <p className="absolute align-center-hover text-lg"><i className="text-green-600 fas fa-book-open"></i><br />menu</p>
                                            </div>
                                            <h1>${MGY.info().name}</h1>
                                            <p className="text-xs">逢星期一休息</p>
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div className="lg:w-1/2 mb-3 lg:ml-3 bg-white rounded-xl">
                                <div className="pt-6 px-6">
                                    <h3 className="text-lg font-bold"><i className="fas fa-map-marker-alt text-green-400"></i> 中電</h3>
                                </div>
                                <div className="p-6 text-center">
                                    <div className="flex justify-center">
                                        <a href=${isNewSystemReleased ? Path.join(["/menu", YearsHK]) : formUrls[YearsHK]} className="w-1/2 lg:w-36 mr-3 lg:mr-auto mx-auto text-center cursor-pointer rounded-3xl p-2 menu text-black">
                                            <div className="relative btn-menu">
                                                ${StaticResource.image("/images/years.jpg", YearsHK.info().name, "squircle mb-3")}
                                                <p className="absolute align-center-hover text-lg"><i className="text-green-400 fas fa-book-open"></i><br />menu</p>
                                            </div>
                                            <h1>${YearsHK.info().name}</h1>
                                        </a>
                                        <a href=${isNewSystemReleased ? Path.join(["/menu", DongDong]) : formUrls[DongDong]} className="w-1/2 lg:w-36 mx-auto text-center cursor-pointer rounded-3xl p-2 menu text-black">
                                            <div className="relative btn-menu">
                                                ${StaticResource.image("/images/dong.jpg", DongDong.info().name, "squircle mb-3")}
                                                <p className="absolute align-center-hover text-lg"><i className="text-green-400 fas fa-book-open"></i><br />menu</p>
                                            </div>
                                            <h1>${DongDong.info().name}</h1>
                                            <p className="text-xs">逢星期日休息</p>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div className="lg:flex">
                            <div className="lg:w-1/2 mb-3 bg-white rounded-xl">
                                <div className="pt-6 px-6">
                                    <h3 className="text-lg font-bold"><i className="fas fa-map-marker-alt text-blue-500"></i> 白田</h3>
                                </div>
                                <div className="p-6 flex">
                                    <a href=${isNewSystemReleased ? Path.join(["/menu", ZeppelinHotDogSKM]) : formUrls[ZeppelinHotDogSKM]} className="w-1/2 lg:w-36 mx-auto text-center cursor-pointer rounded-3xl p-2 menu text-black">
                                        <div className="relative btn-menu">
                                            ${StaticResource.image("/images/zeppelin.jpg", ZeppelinHotDogSKM.info().name, "squircle mb-3")}
                                            <p className="absolute align-center-hover text-lg"><i className=" text-blue-500 fas fa-book-open"></i><br />menu</p>
                                        </div>
                                        <h1>${ZeppelinHotDogSKM.info().name}</h1>
                                    </a>
                                </div>
                            </div>
                            <div className="lg:w-1/2 mb-3 lg:ml-3 bg-white rounded-xl">
                                <div className="pt-6 px-6">
                                    <h3 className="text-lg font-bold"><i className="fas fa-star text-indigo-500"></i> 同埸加映消毒用品</h3>
                                </div>
                                <div className="p-6 flex">
                                    <a href="https://docs.google.com/forms/d/e/1FAIpQLSebHaeo7cEqGTsNKSBk7s27Jlok4WSLJJc2IRoZa39A6TrAiw/viewform" className="w-1/2 lg:w-36 mx-auto text-center cursor-pointer rounded-3xl p-2 menu text-black">
                                        <div className="relative btn-menu">
                                            ${StaticResource.image("/images/hyginova.jpg", "Hyginova", "squircle mb-3")}
                                            <p className="absolute align-center-hover text-lg"><i className="text-indigo-500 fas fa-shopping-cart"></i><br />預訂</p>
                                        </div>
                                        <h1>Hyginova</h1>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div className="p-6 text-xl text-center lg:text-2xl font-bold bg-curve">
                            服務資訊
                        </div>
                        <div className="bg-white rounded-xl p-6">
                            <div className="lg:flex mb-6 lg:mb-12">
                                <div className="lg:w-1/3 flex items-center">
                                    <div>
                                        <div className="text-lg font-bold mb-3"><i className="fas fa-utensils"></i> 點搵埗兵叫野食?</div>
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
                                        <div className="text-lg font-bold mb-3"><i className="fas fa-map-marked-alt"></i> 埗兵送到邊? 點計錢?</div>
                                        <p className="mb-3">地圖有埗兵主要送餐範圍</p>
                                        <p className="mb-3">運費計算:<br />以店舖同目的地之間嘅步行距離計算，會因應實際情況(如長樓梯)調整。</p>
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
                        ${isNewSystemReleased ? orderButton() : null}
                    </div>
                </main>
            </Fragment>
        ');
    }

    static public function get(req:Request, reply:Reply):Promise<Dynamic> {
        return Promise.resolve(reply.sendView(Index, {

        }));
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/", Index.get);
    }
}