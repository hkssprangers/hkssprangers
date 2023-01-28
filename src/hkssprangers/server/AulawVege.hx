package hkssprangers.server;

import react.ReactComponent.ReactElement;
import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
using hkssprangers.server.FastifyTools;
using Reflect;
using Lambda;

typedef AulawVegeProps = {}

class AulawVege extends View<AulawVegeProps> {
    override public function title() return '深水埗區本地菜共購';
    override public function description() return '歡迎深水埗街坊加入埗兵本地菜共購群組';
    override function canonical() return Path.join(["https://" + canonicalHost, "aulaw-vege"]);
    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${R("/images/banner-vege-album.jpg")} />
        </Fragment>
    ');

    override function depScript():ReactElement {
        return jsx('
            <Fragment>
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
                ${View.header()}
                
                <div className="lg:max-w-screen-2xl mx-auto">

                    <div className="py-12 md:py-16 mx-auto container">
                        
                        <div className="md:w-2/3 lg:w-1/2 px-6 md:px-12">
                            <h1 className="text-xl md:text-2xl font-bold text-opacity-75 tracking-wider mb-3">深水埗區本地菜共購</h1>
                            <div className="text-opacity-75 text-gray-700">
                                <p className="mb-3">每個星期日我哋都會趁<a className="underline" href="/food-waste-recycle">運咖啡渣</a>去農墟，買埋本地菜返屋企。獨樂樂不同眾樂樂，索性整個 Telegram 共購群組，叫埋街坊一齊食靚菜。</p>
                                <p className="mb-3"><a className="underline" href="https://www.facebook.com/aulawfarm/">歐羅有機農場</a>有提供<a className="underline" href="https://www.aulaw.org/">月購計劃</a>俾大家訂菜，而深水埗街坊想同埗兵買菜，歡迎加入埗兵本地菜群組。</p>
                                <ul className="list-disc mb-3">
                                    <li>每星期五晚至星期六 12:00 群組內開放預訂，星期日交收</li>
                                    <li>可以揀標記交收 / 埗兵外賣搭送菜</li>
                                    <li>外賣送到深水埗、長沙灣、太子、石硤尾、大角咀、茘枝角等等</li>
                                    <li>我哋會用<a className="underline" href="https://www.facebook.com/HayaKu.ecostudent">環保見習生</a>提供嘅回收雪袋分裝大家嘅菜</li>
                                </ul>
                                <a className="py-3 px-6 flex items-center justify-center rounded-md border border-black focus:ring-2" href="https://t.me/+uHQZCJagi5E3NTk1">加入 Telegram 群組</a>
                            </div>
                        </div>
                    </div>

                    <div className="py-12 md:py-16 mx-auto container">
                        
                        <div className="md:w-2/3 lg:w-1/2 px-6 md:px-12">
                            <h1 className="text-xl md:text-2xl font-bold text-opacity-75 tracking-wider mb-3">菜菜圖鑑</h1>
                            <div className="text-opacity-75 text-gray-700">
                                <p className="mb-3">歐羅菜係咩樣㗎?我哋幫每個菜款影咗相，等大家有圖有真相!</p>
                            </div>
                        </div>

                        <div className="px-6 md:px-12 grid grid-cols-2 sm:grid-cols-3 2xl:grid-cols-4 gap-2">
                            <div>${image("/images/vege/basil.jpg", "九層塔", "rounded-md")}</div>
                            <div>${image("/images/vege/celery.jpg", "西芹", "rounded-md")}</div>
                            <div>${image("/images/vege/chard.jpg", "彩色君達菜", "rounded-md")}</div>
                            <div>${image("/images/vege/chives.jpg", "蔥", "rounded-md")}</div>
                            <div>${image("/images/vege/coriander.jpg", "芫荽", "rounded-md")}</div>
                            <div>${image("/images/vege/corn.jpg", "粟米", "rounded-md")}</div>
                            <div>${image("/images/vege/green-pepper.jpg", "青椒", "rounded-md")}</div>
                            <div>${image("/images/vege/italy-lettuce.jpg", "意大利生菜", "rounded-md")}</div>
                            <div>${image("/images/vege/kale.jpg", "羽衣甘藍", "rounded-md")}</div>
                            <div>${image("/images/vege/lemmon-marigold.jpg", "芳香萬壽菊", "rounded-md")}</div>
                            <div>${image("/images/vege/lettuce.jpg", "生菜", "rounded-md")}</div>
                            <div>${image("/images/vege/ma-si-yin.jpg", "馬屎莧", "rounded-md")}</div>
                            <div>${image("/images/vege/mei-choy.jpg", "自家梅菜", "rounded-md")}</div>
                            <div>${image("/images/vege/mulburry.jpg", "桑子", "rounded-md")}</div>
                            <div>${image("/images/vege/nine.jpg", "韭菜", "rounded-md")}</div>
                            <div>${image("/images/vege/peanuts.jpg", "花生", "rounded-md")}</div>
                            <div>${image("/images/vege/peppermint.jpg", "薄荷", "rounded-md")}</div>
                            <div>${image("/images/vege/potato.jpg", "薯仔", "rounded-md")}</div>
                            <div>${image("/images/vege/purple-cauliflower.jpg", "紫椰菜花", "rounded-md")}</div>
                            <div>${image("/images/vege/purple-sweet-potato-leaf.jpg", "紫番薯苗", "rounded-md")}</div>
                            <div>${image("/images/vege/salad.jpg", "沙律拼盤", "rounded-md")}</div>
                            <div>${image("/images/vege/sweet-potato.jpg", "番薯", "rounded-md")}</div>
                            <div>${image("/images/vege/sweet-potato-leaf.jpg", "番薯苗", "rounded-md")}</div>
                            <div>${image("/images/vege/tung-choy.jpg", "通菜", "rounded-md")}</div>
                            <div>${image("/images/vege/winter-melon.jpg", "冬瓜", "rounded-md")}</div>
                            <div>${image("/images/vege/潺菜.jpg", "潺菜", "rounded-md")}</div>
                            <div>${image("/images/vege/紅莧菜.jpg", "紅莧菜", "rounded-md")}</div>
                            <div>${image("/images/vege/艾草.jpg", "艾草", "rounded-md")}</div>
                            <div>${image("/images/vege/辣椒葉.jpg", "辣椒葉", "rounded-md")}</div>
                            <div>${image("/images/vege/chamomile-tea.jpg", "小黃菊茶包", "rounded-md")}</div>
                            <div>${image("/images/vege/shiso-tea.jpg", "紫蘇桑葉乾茶包", "rounded-md")}</div>
                            <div>${image("/images/vege/dried-vege.jpg", "自家菜脯", "rounded-md")}</div>
                            <div>${image("/images/vege/jam.jpg", "桑子果醬", "rounded-md")}</div>
                        </div>
                    </div>
                </div>
            </main>
        ');
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/aulaw-vege", function get(req:Request, reply:Reply):Promise<Dynamic> {
            return Promise.resolve(reply.sendView(AulawVege, {}));
        });
    }
}