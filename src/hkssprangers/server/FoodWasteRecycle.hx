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

typedef FoodWasteRecycleProps = {}

class FoodWasteRecycle extends View<FoodWasteRecycleProps> {
    override public function title() return '埗兵咖啡渣之旅';
    override public function description() return '一步一步，由cafe到農田，將城市同鄉郊，以新嘅循環方式建立連繫';
    override function canonical() return Path.join(["https://" + canonicalHost, "food-waste-recycle"]);
    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${R("/images/food-waste-recycle/banner-coffee2.jpg")} />
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
                <div className="bg-coffee">
                    <div className="bg-repeat-x bg-top bg-coffee-banner">
                        <div className="lg:max-w-screen-2xl mx-auto">
                            <div className="px-6 py-12 mx-auto lg:max-w-screen-2xl text-center">
                                <h1 className="text-3xl md:text-6xl text-opacity-75 text-yellow-800 font-bold tracking-widest mb-3">埗兵咖啡渣之旅</h1>
                                <p className=" text-opacity-75 text-gray-700">一步一步，<span className="inline-block">由cafe到農田，將城市同鄉郊，</span><span className="inline-block">以新嘅循環方式建立連繫</span></p>
                                <div className="my-3 md:w-2/3 mx-auto flex">
                                    <div className="w-1/3">
                                        ${image("/images/food-waste-recycle/c1.png", "咖啡", "cup")}
                                    </div>
                                    <div className="w-1/3">
                                        ${image("/images/food-waste-recycle/c2.png", "咖啡渣", "cup2")}
                                    </div>
                                    <div className="w-1/3">
                                        ${image("/images/food-waste-recycle/c3.png", "菜苗", "cup3")}
                                    </div>
                                </div>
                            </div>
                            <div className="py-12 mx-auto w-4/5 md:flex items-center">
                                <div className="flex-1">
                                    ${image("/images/food-waste-recycle/01.png", "步驟01: 收集", "")}
                                </div>
                                <div className="flex-1 p-6 md:p-12 text-opacity-75 text-gray-700">
                                    <h1 className="text-2xl md:text-4xl font-bold pb-3 text-opacity-75 text-yellow-800 tracking-wider">收集</h1>

                                    <p className="mb-3">我哋同深水埗多間cafe合作，每星期拖車仔收集咖啡渣同蛋殼，由開始時一個外賣飯盒嘅量，到而家一星期會收集到約50kg。</p>
                                    <p className="mb-3">收集後仲需要處理，將咖啡渣同濾紙分開之後，我哋會將濾紙清洗乾淨後交到 <a className="underline" href="https://www.milmill.hk/">mil mill 喵坊</a>，佢會用回收紙漿製造廁紙。</p>
                                    <p className="mb-3">蛋殼收集後，我哋會清洗同炒乾，連同咖啡渣一齊交俾香港歐羅有機農場。</p>
                                    
                                </div>
                            </div>
                            <div className="py-12 mx-auto w-4/5 md:flex items-center flex-row md:flex-row-reverse">
                                <div className="flex-1">
                                ${image("/images/food-waste-recycle/02.png", "步驟02: 堆肥", "")}
                                </div>
                                <div className="flex-1 p-6 md:p-12 text-opacity-75 text-gray-700">
                                    <h1 className="text-2xl md:text-4xl font-bold pb-3 text-opacity-75 text-yellow-800 tracking-wider">堆肥</h1>
                                    <p className="mb-3">返到農場，農夫會將咖啡渣同蛋殼，連同枯枝枯葉同新鮮菜葉等，逐層咁堆放，經過微生物降解之後，咖啡渣同蛋殼就會釋放出鉀、氮、鎂、鈣等豐富嘅營養，同時提升土壤有機質，改善泥土質素。</p>
                                    <p className="mb-3">堆肥需放置最少兩個月，降解期間會產生熱能，亦都要定時咁翻堆。未夠時間嘅堆肥係會燒傷植物根部又或者令植物缺氧㗎。到堆肥熟成嘅一刻，深水埗咖啡渣就正式回歸到大自然喇。</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div className="w-full bg-cover bg-fixed bg-aulaw">
                    <div className="lg:max-w-screen-2xl mx-auto p-6 md:p-12 md:h-screen text-center flex items-center justify-center">
                        <div className="p-6 lg:w-1/2">
                            <p className="text-white text-shadow">有營養嘅堆肥，仲要有農夫細心嘅照顧，<span className="inline-block">先有咁靚嘅菜㗎，</span><span className="inline-block">喺度感謝同我哋合作嘅農場，無佢哋計劃就唔成事。</span></p>
                            <br/><br/><br/><br/>
                            <div className="bg-white bg-opacity-90 rounded">
                                <div className="relative">
                                    ${image("/images/food-waste-recycle/hing.jpg", "香港歐羅有機農場", "absolute rounded-full w-32 left-1/2 transform -translate-x-1/2 -translate-y-1/2")}
                                </div>
                                <div className="pt-24 px-6 md:px-12 pb-6 text-opacity-75 text-black">
                                    <h3 className="text-lg lg:text-xl font-bold pb-3 text-opacity-75  tracking-wider">香港歐羅有機農場</h3>
                                    <div className="mb-3 flex justify-center items-center">
                                        <a className="mx-2" href="https://www.facebook.com/aulawfarm/"><i className="text-xl fab fa-facebook-f"></i></a>
                                        <a className="mx-2" href="https://www.instagram.com/aulawfarm/"><i className="text-xl fab fa-instagram"></i></a>
                                    </div>
                                    <p>歐羅有機農場 (AuLaw Organic Farm) 位於元朗錦田大江埔村，2010年由黃氏姊弟放下個人事業，回歸出生地一同建立農莊，經過一番努力，現在合共開墾了二十萬平方呎農田投入生產，農場環境自然優美，所有農作物均採用天然地下井水灌溉，種出來的有機蔬菜、瓜、豆、水果份外鮮甜！</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div className="lg:max-w-screen-2xl mx-auto">

                    <div className="py-12 mx-auto w-4/5 md:flex">
                        <div className="flex-1">
                            ${image("/images/food-waste-recycle/04-vege.png", "本地菜", "")}
                        </div>
                        <div className="flex-1 p-6 md:p-12 text-opacity-75 text-gray-700">
                            <h1 className="text-2xl md:text-4xl font-bold pb-3 text-opacity-75 text-yellow-800 tracking-wider">深水埗區本地菜共購</h1>
                            <p className="mb-3">每個星期日我哋都會趁運咖啡渣去農墟，買埋本地菜返屋企。獨樂樂不同眾樂樂，索性整個 Telegram 共購群組，叫埋街坊一齊食靚菜。</p>
                            <p className="mb-3">歐羅有機農場有提供<a className="underline" href="https://www.aulaw.org/">月購計劃</a>俾大家訂菜，而深水埗街坊想同埗兵買菜，歡迎加入埗兵本地菜群組。</p>
                            <ul className="list-disc mb-3">
                                <li>每星期五晚至星期六 12:00 群組內開放預訂，星期日交收</li>
                                <li>可以揀標記交收 / 埗兵外賣搭送菜</li>
                                <li>外賣送到深水埗、長沙灣、太子、石硤尾、大角咀、茘枝角等等</li>
                                <li>我哋會用<a className="underline" href="https://www.facebook.com/HayaKu.ecostudent">環保見習生</a>提供嘅回收雪袋分裝大家嘅菜</li>
                            </ul>
                            <a className="py-3 px-6 flex items-center justify-center rounded-md border border-black focus:ring-2" href="https://t.me/+uHQZCJagi5E3NTk1">加入 Telegram 群組</a>
                        </div>
                    </div>

                    <div className="py-12 mx-auto w-4/5 md:flex items-center">
      
                        <div className="flex-1 p-6 md:p-12 text-opacity-75 text-gray-700">
                            <h1 className="text-2xl md:text-4xl font-bold pb-3 text-opacity-75 text-yellow-800 tracking-wider">媒體報導</h1>
                            <p className="mb-3">在計劃開初，埗兵有榮幸接受到記者謝馨怡訪問，佢仲同小編行左一次收渣之路，非常感謝!</p>
                        </div>
                        <div className="flex-1">
                            <a className="rounded border inline-block" href="https://hk.news.yahoo.com/%E5%92%96%E5%95%A1%E6%B8%A3-%E8%9B%8B%E6%AE%BC-%E8%BE%B2%E5%A4%AB-%E6%9C%AC%E5%9C%B0%E8%BE%B2%E6%A5%AD-213208958.html">
                            ${image("/images/food-waste-recycle/yahoo-news.png", "yahoo新聞 「埗兵」外賣員義務收集咖啡渣及蛋殼供農夫作肥料：種返菜畀香港人食", "rounded-t w-full")}
                            <div className="p-3 border-t text-opacity-75 text-gray-700">
                                <h5 className="text-xs">yahoo新聞</h5>
                                <h3>「埗兵」外賣員義務收集咖啡渣及蛋殼供農夫作肥料：種返菜畀香港人食</h3>
                            </div>
                            </a>
                        </div>
                    </div>

                    <div className="py-12 mx-auto w-4/5 md:flex">
                        <div className="flex-1 p-6 md:p-12 text-opacity-75 text-gray-700">
                            <h1 className="text-2xl md:text-4xl font-bold pb-3 text-opacity-75 text-yellow-800 tracking-wider">特別鳴謝</h1>
                            <p className="mb-3">感謝以下cafe嘅傾力相助，排名不分先後。</p>
                            <p>琉金穗月, Wills Coffee, Dog99 Coffee, 飛龍咖啡, Try my Bread, PRESS THE BUTTON, KOKONI, Openground, COFFEE OF THE DAY, Loop Kulture, Colour Brown, Lonely Paisley, Minimal, The Park by Years, 黑窗里, 十常八九, Flow, SO Coffee & Gin, The Soulroom 一草一木, 不苦</p>
                        </div>
                        <div className="flex-1 p-6 md:p-12 text-opacity-75 text-gray-700">
                            <h1 className="text-2xl md:text-4xl font-bold pb-3 text-opacity-75 text-yellow-800 tracking-wider">埗兵有話兒</h1>
                            <p className="mb-3">傳說中深水埗特別多cafe同傻人，我可以好肯定咁講係真㗎!因為計劃係冇咩利潤，全憑埗兵外賣員嘅傻勁，又有咁多cafe參與，先行到今時今日。前一排讀到地球表面嘅泥土有一半已經消失咗，而堆肥就係其中一個方式令營養回歸土地，咖啡渣回收計劃令到深水埗嘅小店同香港土地產生一種新嘅連結，又多咗街坊一齊支持本地農業，都係埗兵最大嘅收穫。</p>
                        </div>
                    </div>
                </div>

            </main>
        ');
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/food-waste-recycle", function get(req:Request, reply:Reply):Promise<Dynamic> {
            return Promise.resolve(reply.sendView(FoodWasteRecycle, {}));
        });
    }
}