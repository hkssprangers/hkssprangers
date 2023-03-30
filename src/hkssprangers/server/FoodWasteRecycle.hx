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
                <script src=${R("/js/foodWasteRecycle/foodWasteRecycle.js")}></script>
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
                <div className="">
                    <div className="px-6 py-12 mx-auto lg:max-w-screen-2xl text-center overflow-hidden">
                        <h1 className="text-3xl md:text-6xl text-opacity-75 text-yellow-800 font-bold tracking-widest mb-3">埗兵咖啡渣之旅</h1>
                        <p className=" text-opacity-75 text-gray-700">一步一步，<span className="inline-block">由cafe到農田，將城市同鄉郊，</span><span className="inline-block">以新嘅循環方式建立連繫</span></p>
                        <div className="grid grid-cols-5 grids-rows-10 md:grid-cols-10 md:grids-rows-4" >
                            <div className="row-start-1 row-span-3 col-start-1 col-span-3 md:row-start-1 md:row-span-3 md:col-start-1 md:col-span-4 -ml-16 md:ml-0">
                                ${image("/images/food-waste-recycle/b1.png", "咖啡", "cup")}
                            </div>
                            <div className="row-start-2 row-span-3 col-start-3 col-span-3 md:row-start-2 md:row-span-3 md:col-start-4 md:col-span-4 -mr-16 md:mr-0">
                                ${image("/images/food-waste-recycle/b2.png", "堆肥", "cup2")}
                            </div>
                            <div className="row-start-4 row-span-3 col-start-1 col-span-3 md:row-start-3 md:row-span-3 md:col-start-7 md:col-span-4 -ml-16 md:ml-0">
                                ${image("/images/food-waste-recycle/b3.png", "菜", "cup3")}
                            </div>
                        </div>
                    </div>
                    <div id="section-earth" className="py-12 bg-cover md:bg-contain">
                        <div className="relative overflow-hidden min-h-screen">
                            <div id="earth-circle">&nbsp;</div>
                            <div className="absolute w-2/3 md:w-1/2 top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
                                <div className="mx-auto py-12 text-center text-white">
                                <h1 className="text-2xl md:text-4xl font-bold mb-6 md:mb-12 text-white tracking-wider">點解我哋要收渣?</h1>
                                <h1 className="text-xl font-bold mb-6">改善土壤質素</h1>
                                <p>地球上可以種植嘅土壤不斷流失，每1分鐘就有30塊足球場大嘅土地無法再種植。土壤污染原因有好多，包括工業污染物排放、過度使用農藥等等。</p>
                                <br/>
                                <p>點樣幫到土壤回復健康嘅狀態呢? 其中一個方法就係增加有機物，例如廚餘。咖啡渣可以話係城市裡面最乾淨同易處理嘅廚餘之一，我哋就喺社區收集咖啡渣，再同農場合作，做咖啡渣堆肥，為土壤增值。</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="min-h-screen flex justify-center items-center overflow-hidden">
                        <div className="mx-auto p-6 md:p-12">
                            <h1 className="text-2xl md:text-4xl font-bold pb-6 md:pb-12 text-opacity-75 text-gray-700 tracking-wider text-center">我哋每星期會做咩?</h1>
                            <div className="lg:flex container relative text-opacity-75 text-gray-700">
                                <div className="flex-1 lg:grid lg:grid-cols-5 lg:grid-rows-5">
                                    <div className="w-2/3 lg:w-full lg:row-start-4 lg:row-span-2 lg:col-start-1 lg:col-span-2 mx-auto -mb-16 lg:mb-0 lg:-ml-12 z-10">${image("/images/food-waste-recycle/coffee-cup.png", "咖啡杯", "")}</div>
                                    <div id="bowl" className="w-32 absolute bottom-0 z-20 hidden lg:block">${image("/images/food-waste-recycle/bowl.gif", "埗兵", "")}</div>
                                    <div className="lg:row-start-1 lg:row-span-4 lg:col-start-2 lg:col-span-4 p-6 lg:p-12 flex items-end lg:items-start md:mr-1 bg-gray-200 rounded bg-gray-radial">
                                        <div>
                                            <div className="flex mb-6">
                                                <div className="mr-6 text-white">
                                                <h3 className="font-bold text-4xl">01</h3>
                                                <h1 className="text-xl font-bold">收集</h1>
                                                </div>
                                                <div className="flex-1 bg-border-white">&nbsp;</div>
                                            </div>
                                            
                                            <p className="mb-3">我哋同深水埗區內嘅cafe合作，每星期拖車仔收集咖啡渣同廚餘，由開始時一個外賣飯盒嘅量，到而家一星期會收集到約50kg。</p>
                                            <p className="mb-3">收集後需要進行唔同處理</p>
                                            <p className="mb-3">濾紙: 濾紙同咖啡渣分開後，我哋會將濾紙清洗乾淨後交到 <a className="underline" href="https://www.milmill.hk/">mil mill 喵坊</a>，佢會用回收紙漿製造廁紙。</p>
                                            <p className="mb-3">蛋殼: 收集後，我哋會清洗同炒乾，連同咖啡渣一齊交俾農場。</p>
                                            <p>廚餘: 用密封容器裝好，再交俾農場。</p>
                                        </div>
                                    </div>
                                </div>
                                <div className="flex-1 lg:grid lg:grid-cols-5 lg:grid-rows-5">
                                    <div className="w-2/3 lg:w-full lg:row-start-4 lg:row-span-2 lg:col-start-4 lg:col-span-2 mx-auto -mb-16 lg:mb-0 lg:ml-12 z-10">${image("/images/food-waste-recycle/compost.gif","堆肥","")}</div>
                                    <div className="row-start-1 row-span-4 col-start-1 lg:col-start-1 col-span-5 lg:col-span-4 p-6 lg:p-12 flex items-end lg:items-start rounded bg-gray-radial">
                                        <div>
                                            <div className="flex mb-6">
                                                <div className="mr-6 text-white">
                                                <h3 className="font-bold text-4xl">02</h3>
                                                <h1 className="text-xl font-bold">堆肥</h1>
                                                </div>
                                                <div className="flex-1 bg-border-white">&nbsp;</div>
                                            </div>
                                            <p className="mb-3">返到農場，農夫會將咖啡渣同蛋殼，連同枯枝枯葉同新鮮菜葉等，逐層咁堆放，經過微生物降解之後，咖啡渣同蛋殼就會釋放出鉀、氮、鎂、鈣等豐富嘅營養，同時提升土壤有機質，改善泥土質素。</p>
                                            <p className="mb-3">堆肥需放置最少兩個月，降解期間會產生熱能，亦都要定時咁翻堆。未夠時間嘅堆肥係會燒傷植物根部又或者令植物缺氧㗎。到堆肥熟成嘅一刻，深水埗咖啡渣就正式回歸到大自然喇。</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="relative bg-earth">
                        <div className="min-h-screen flex justify-center items-center">
                            <div className="mx-auto p-6 md:p-12">

                                <h1 className="text-2xl md:text-4xl font-bold mb-6 md:mb-12 text-white tracking-wider text-center">我哋同邊個合作?</h1>

                                <div className="mx-auto md:flex container lg:w-4/5 bg-white rounded pb-12 md:pb-0">
                                <div className="flex-1 text-opacity-75 text-gray-700 p-6 md:p-12">
                                    
                                    <div className="flex mb-6">
                                    <div className="mr-6">
                                        <h1 className="text-xl font-bold">Cafe</h1>
                                    </div>
                                    <div className="flex-1 bg-border-gray700">&nbsp;</div>
                                    </div>

                                    <p className="mb-3">感謝以下嘅cafe參加埗兵咖啡渣回收計劃，希望大家經過深水埗可以多多支持佢哋!</p>
                                    <ul className="list-disc mb-3">
                                        <li>Buff 不苦</li>
                                        <li>Kokoni</li>
                                        <li>Lonely Paisley</li>
                                        <li>Loop Kulture</li>
                                        <li>So Coffee & Gin</li>
                                        <li>The Soulroom 一草一木</li>
                                        <li>Years / The Park</li>
                                        <li>昌盛茶餐廳</li>
                                        <li>黑窗里</li>
                                    </ul>
                                    <p>有興趣參與計劃嘅cafe都歡迎<a className="underline" href="https://www.facebook.com/hkssprangers">留低聯絡</a>俾我哋!</p>
                                </div>

                                <div className="flex-1 text-opacity-75 text-gray-700 p-6 md:p-12">
                                    <div className="flex mb-6">
                                    <div className="mr-6">
                                        <h1 className="text-xl font-bold">農場</h1>
                                    </div>
                                    <div className="flex-1 bg-border-gray700">&nbsp;</div>
                                    </div>
                                    <p className="mb-3">感謝以下嘅農場，一開始有香港歐羅有機農場大大力支持我哋先展開到成個計劃，慢慢有其他農友一齊幫手。</p>
                                    <ul className="list-disc mb-3">
                                    <li>歐羅有機農場</li>
                                    <li>菇菌圓</li>
                                    <li>香城遺菇</li>
                                    <li>農友W</li>
                                    </ul>
                                    <p>2023年，我哋都努力搵唔同嘅團體研究堆肥，發掘更多可能性，例如點樣用蚯蚓幫手分解咖啡渣。</p>
                                </div>
                                </div>
                            </div>
                        </div>
                        <div id="farmer" className="w-1/2 md:w-1/3 lg:w-1/4">${image("/images/food-waste-recycle/f-b.png","咖啡師農友","")}</div>
                    </div>

                    <div className="min-h-screen flex justify-center items-center bg-cover bg-fixed p-6 lg:p-12 bg-vege">
                        <div className="mx-auto md:w-2/3 lg:w-1/2">
                            <svg viewBox="0 0 500 200">
                                <path id="curve" d="M73.2,148.6c4-6.1,65.5-96.8,178.6-95.6c111.3,1.2,170.8,90.3,175.1,97" fill="transparent"/>
                                <text width="500" fill="white" className="text-3xl md:text-4xl font-bold text-white tracking-wider text-center">
                                <textPath xlinkHref="#curve">
                                    我哋帶咗咩返社區?
                                </textPath>
                                </text>
                            </svg>
                            <div className="bg-white bg-opacity-90 rounded">
                                <div className="relative">
                                    <div className="absolute w-1/2 left-3/4 transform -translate-x-1/2 -translate-y-2/3">
                                        ${image("/images/food-waste-recycle/b3.png", "菜", "cup3")}
                                    </div>
                                </div>
                                <div className="p-6 md:p-12 text-opacity-75 text-gray-700 ">
                                
                                <h1 className="text-xl font-bold pb-6">深水埗區本地菜共購</h1>
                                    <p className="mb-3">每次我哋都會趁運咖啡渣去農墟，買埋歐羅菜同孖陳記嘅花草茶返屋企。獨樂樂不同眾樂樂，索性整個telegram共購群組，叫埋街坊一齊食靚菜。</p>
                                    <p className="mb-3">歐羅有機農場有提供<a className="underline" href="https://www.aulaw.org/">月購計劃</a>俾大家訂菜，而深水埗街坊想同埗兵買菜，歡迎加入埗兵本地菜群組。</p>
                                    
                                    <ul className="list-disc mb-3">
                                    <li>星期五群組內開放預訂，星期日交收</li>
                                    <li>可以揀魚鈁交收 / 埗兵外賣搭送菜</li>
                                    <li>外賣送到深水埗、長沙灣、太子、石硤尾、大角咀、茘枝角等等</li>
                                    <li>我哋會用<a className="underline" href="https://www.facebook.com/HayaKu.ecostudent">環保見習生</a>提供嘅回收雪袋分裝大家嘅菜</li>
                                    </ul>
                                    <a className="py-3 px-6 flex items-center justify-center rounded-md border border-black focus:ring-2" href="https://t.me/+uHQZCJagi5E3NTk1">加入telegram群組</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="min-h-screen flex justify-center items-center p-6 lg:p-12">
                        <div className="mx-auto container lg:w-4/5">
                            <div className="lg:flex">
                                <div className="flex-1 text-opacity-75 text-gray-700 p-3 md:pl-0 md:pr-6">
                                    <div className="flex mb-6">
                                        <div className="mr-6">
                                        <h1 className="text-xl font-bold">媒體報導</h1>
                                        </div>
                                        <div className="flex-1 bg-border-gray700">&nbsp;</div>
                                    </div>

                                    <p className="mb-3">在計劃開初，埗兵有榮幸接受到記者謝馨怡訪問，佢仲同小編行左一次收渣之路，非常感謝!</p>
                                    <a className="rounded border inline-block" href="https://hk.finance.yahoo.com/%E5%92%96%E5%95%A1%E6%B8%A3-%E8%9B%8B%E6%AE%BC-%E8%BE%B2%E5%A4%AB-%E6%9C%AC%E5%9C%B0%E8%BE%B2%E6%A5%AD-213208958.html">
                                        ${image("/images/food-waste-recycle/yahoo-news.png", "yahoo新聞 「埗兵」外賣員義務收集咖啡渣及蛋殼供農夫作肥料：種返菜畀香港人食", "rounded-t w-full")}
                                        <div className="p-3 border-t text-opacity-75 text-gray-700">
                                            <h5 className="text-xs">yahoo新聞</h5>
                                            <h3>「埗兵」外賣員義務收集咖啡渣及蛋殼供農夫作肥料：種返菜畀香港人食</h3>
                                        </div>
                                    </a>
                                </div>

                                <div className="flex-1 text-opacity-75 text-gray-700 p-3 md:pr-0 md:pl-6">
                                <div className="flex mb-6">
                                    <div className="mr-6">
                                    <h1 className="text-xl font-bold">特別鳴謝</h1>
                                    </div>
                                    <div className="flex-1 bg-border-gray700">&nbsp;</div>
                                </div>
                                <p className="mb-3">當我哋炒蛋殼炒到傻嘅時候，有一間公司主動聯絡仲冇條件咁送一部廚餘機俾我哋，處理蛋殼快咗好多又冇晒味!處理完嘅廚餘可以直接當肥料用，誠意推薦俾大家: <a href="https://lomi.com/">Lomi家用廚餘機</a> </p>

                                ${image("/images/food-waste-recycle/lomi.png","Lomi廚餘機","")}
                                
                                </div>
                            </div>
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