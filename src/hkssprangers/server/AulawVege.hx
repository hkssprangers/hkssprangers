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
            <meta property="og:image" content=${Path.join(["https://" + hkssprangers.server.ServerMain.host, R("/images/banner-vege-album.jpg")])} />
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
                                <p className="mb-3">每個星期日我哋都會趁運咖啡渣去農墟，買埋歐羅菜返屋企。獨樂樂不同眾樂樂，索性整個telegram共購群組，叫埋街坊一齊食靚菜。</p>
                                <p className="mb-3">歐羅有機農場有提供<a className="underline" href="https://www.aulaw.org/">月購計劃</a>俾大家訂菜，而深水埗街坊想同埗兵買菜，歡迎加入埗兵本地菜群組。</p>
                                
                                <ul className="list-disc mb-3">
                                    <li>每星期六 14:00 群組內開放預訂，星期日交收</li>
                                    <li>可以揀標記交收 / 埗兵外賣搭送菜</li>
                                    <li>外賣送到深水埗、長沙灣、太子、石硤尾、大角咀、茘枝角等等</li>
                                    <li>我哋會用<a className="underline" href="https://www.facebook.com/HayaKu.ecostudent">環保見習生</a>提供嘅回收雪袋分裝大家嘅菜</li>
                                </ul>
                                <a className="py-3 px-6 flex items-center justify-center rounded-md border border-black focus:ring-2" href="https://t.me/+uHQZCJagi5E3NTk1">加入telegram群組</a>
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
                            <div>${StaticResource.image("/images/vege/basil.jpg", "Basil", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/celery.jpg", "celery", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/chard.jpg", "chard", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/chives.jpg", "chives", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/coriander.jpg", "coriander", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/corn.jpg", "corn", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/green-pepper.jpg", "green pepper", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/italy-lettuce.jpg", "italy lettuce", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/kale.jpg", "kale", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/lemmon-marigold.jpg", "lemmon marigold", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/lettuce.jpg", "lettuce", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/ma-si-yin.jpg", "ma si yin", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/mei-choy.jpg", "mei choy", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/mulburry.jpg", "mulburry", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/nine.jpg", "nine", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/peanuts.jpg", "peanuts", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/peppermint.jpg", "peppermint", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/potato.jpg", "potato", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/purple-cauliflower.jpg", "purple-cauliflower", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/purple-sweet-potato-leaf.jpg", "purple-sweet-potato-leaf", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/salad.jpg", "salad", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/sweet-potato.jpg", "sweet-potato", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/sweet-potato-leaf.jpg", "sweet-potato-leaf", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/tung-choy.jpg", "tung-choy", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/winter-melon.jpg", "winter-melon", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/潺菜.jpg", "潺菜", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/紅莧菜.jpg", "紅莧菜", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/艾草.jpg", "艾草", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/辣椒葉.jpg", "辣椒葉", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/chamomile-tea.jpg", "chamomile-tea", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/shiso-tea.jpg", "shiso-tea", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/dried-vege.jpg", "dried-vege", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/vege/jam.jpg", "jam", "rounded-md")}</div>
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