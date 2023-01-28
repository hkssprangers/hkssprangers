package hkssprangers.server;

import react.ReactComponent.ReactElement;
import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.info.Recipe;
using hkssprangers.server.FastifyTools;
using Reflect;
using Lambda;

typedef HowToOrderProps = {}

class HowToOrder extends View<HowToOrderProps> {
    override public function title() return '點叫外賣';
    override public function description() return '歡迎大家一齊挑戰埗兵本地菜食譜';
    override function canonical() return Path.join(["https://" + canonicalHost, "how-to-order"]);
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
                <script src=${R("/js/map/map.js")}></script>
                <script src=${R("/js/menu/menu.js")}></script>
                ${super.depScript()}
            </Fragment>
        ');
    }

    override public function render() {
        return super.render();
    }

    override function bodyContent() {
        return jsx('
            <main>
                ${Index.orderButton()}
                ${View.header()}
                <div className="lg:max-w-screen-2xl mx-auto">

                    <div className="py-12 md:py-16 mx-auto container">
                        <div className="md:w-2/3 lg:w-1/2 px-6 md:px-12">
                            <h1 className="text-xl md:text-2xl font-bold text-opacity-75 tracking-wider mb-3">點叫外賣</h1>
                            <div className="text-opacity-75 text-gray-700">
                                <p className="mb-3">快啲㩒 "<a href="/order-food">外賣落單</a>" 搵埗兵幫你手，可以用 WhatsApp 或 Telegram 登入。</p>
                            </div>
                        </div>
                    </div>

                    <div className="pb-12 md:pb-16 px-6 md:px-12 mx-auto container">
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
                                        <div className="border-yellow-300 border-4 rounded-full w-12 h-12 lg:w-24 lg:h-24 flex items-center justify-center text-xl lg:text-4xl font-bold poppins rotate-12">午</div>
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
            </main>
        ');
    }

    static function location(location:String) return jsx('
        <span className=${TailwindTools.badge() + " mx-0.5 px-1 bg-gray-100 whitespace-nowrap"}>${location}</span>
    ');

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/how-to-order", function get(req:Request, reply:Reply):Promise<Dynamic> {
            return Promise.resolve(reply.sendView(HowToOrder, {}));
        });
    }
}