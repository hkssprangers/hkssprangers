package hkssprangers.server;

import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.server.ServerMain.*;
using hkssprangers.server.FastifyTools;
using hkssprangers.info.MenuTools;
using hkssprangers.ValueTools;
using Reflect;
using Lambda;
using hxLINQ.LINQ;

typedef PlumWineDIYProps = {

}

class PlumWineDIY extends View<PlumWineDIYProps> {
    override public function title() return '梅酒 DIY';
    override public function description() return '梅酒 DIY 教學';
    override function canonical() return Path.join(["https://" + canonicalHost, "plum-wine-diy"]);
    override public function render() {
        return super.render();
    }

    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${R("/images/plum-wine-diy/5.jpg")} />
        </Fragment>
    ');

    override function bodyContent() {
        var stepClasses = "my-5 p-5 bg-white rounded-lg";
        var stepDespClasses = "text-lg";
        var imgClasses = "rounded-lg";
        return jsx('
            <main className="overflow-hidden">
                <div className="p-6 md:mb-32 md:p-0 mx-auto md:w-4/5 max-w-screen-lg">
                    <div className="my-6 text-center">
                        <a href="/">
                            ${image("/images/logo-blk-png.png", "埗兵", "inline w-1/4 lg:w-1/6")}
                        </a>
                        <h1 className="text-xl">梅酒 DIY 教學</h1>
                    </div>
                    <div>
                        <a href="https://docs.google.com/forms/d/e/1FAIpQLSdrnwDIdDt51Sd5ubnUCv8NvBRMJqBDM37wY8GZ5YYCV6XbRg/viewform">
                            ${image("/images/plum-web-banner.jpg", "埗兵梅酒 DIY SET", "w-full")}
                        </a>
                    </div>
                    <div>
                        <div className=${stepClasses}>
                            ${image("/images/plum-wine-diy/0.jpg", "準備材料：梅子、酒、冰糖、玻璃樽", imgClasses)}
                            <div className=${stepDespClasses}>0. 準備材料：梅子、酒、冰糖、玻璃樽。</div>
                        </div>
                        <div className=${stepClasses}>
                            ${image("/images/plum-wine-diy/1.jpg", "用濕布抺乾淨梅子同玻璃樽", imgClasses)}
                            <div className=${stepDespClasses}>1. 用濕布抺乾淨梅子同玻璃樽。</div>
                        </div>
                        <div className=${stepClasses}>
                            <div className="flex gap-2">
                                ${image("/images/plum-wine-diy/2-1.jpg", "用籤幫梅子去蒂", imgClasses + " flex-1")}
                                ${image("/images/plum-wine-diy/2-2.jpg", "梅子去蒂前後", imgClasses + " flex-1")}
                            </div>
                            <div className=${stepDespClasses}>2. 用籤幫梅子去蒂。</div>
                        </div>
                        <div className=${stepClasses}>
                            ${image("/images/plum-wine-diy/3.jpg", "用叉喺梅子上拮窿", imgClasses)}
                            <div className=${stepDespClasses}>3. 用叉喺梅子上拮窿。每個梅子兩至三排窿就好。</div>
                        </div>
                        <div className=${stepClasses}>
                            ${image("/images/plum-wine-diy/4.jpg", "一層梅子一層冰糖噉放入樽", imgClasses)}
                            <div className=${stepDespClasses}>4. 一層梅子一層冰糖噉放入樽。</div>
                        </div>
                        <div className=${stepClasses}>
                            ${image("/images/plum-wine-diy/5.jpg", "倒酒入樽", imgClasses + " block md:w-1/2 mx-auto")}
                            <div className=${stepDespClasses}>5. 倒酒入樽。閂實樽蓋。</div>
                        </div>
                        <div className=${stepClasses}>
                            ${image("/images/plum-wine-diy/6.jpg", "黐紙喺樽上面", imgClasses)}
                            <div className=${stepDespClasses}>6. 寫低個入樽日期喺紙，黐喺樽上面。</div>
                        </div>
                        <div className=${stepClasses}>
                            <div>放喺陰涼地方。大約每個月開少少樽蓋，放一放啲氣，閂返實。三個月至一年後開封飲用。</div>
                        </div>
                        <div>
                            <div>攝影：<a href="https://www.instagram.com/count.my.days/">@count.my.days</a></div>
                        </div>
                    </div>
                </div>
            </main>
        ');
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/plum-wine-diy", function get(req:Request, reply:Reply):Promise<Dynamic> {
            return Promise.resolve(reply.sendView(PlumWineDIY, {}));
        });
    }
}