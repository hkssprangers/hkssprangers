package hkssprangers.server;

import haxe.ds.ReadOnlyArray;
import react.ReactComponent.ReactElement;
import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.server.ServerMain.*;
import hkssprangers.info.Recipe;
using hkssprangers.server.FastifyTools;
using hkssprangers.info.MenuTools;
using hkssprangers.ValueTools;
using Reflect;
using Lambda;
using StringTools;
using hxLINQ.LINQ;

typedef RecipeDetailProps = {
    final recipe:Recipe;
}

class RecipeDetail extends View<RecipeDetailProps> {
    public var recipe(get, never):Recipe;
    function get_recipe() return props.recipe;

    override public function title() return '${recipe.info().name}';
    override public function description() return '${recipe.info().name}';
    override function canonical() return Path.join(["https://" + canonicalHost, "recipe", recipe]);
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
        R("/tiles/ssp.pmtiles"),
    ]);
    
    function new(props, context) {
        super(props, context);
    }

    override function bodyContent() {
        return jsx('
            <main>
                <div>
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
                </div>
                <div className="lg:max-w-screen-2xl mx-auto">
                    <div className="py-12 md:py-16 mx-auto container md:flex">
                        <div className="flex-1 px-6 md:px-12">
                            ${renderImage()}
                        </div>
                        <div className="flex-1 px-6 md:px-12">
                            <div className="pt-6 md:pt-0 flex">
                            <div>
                                <a href="/recipe">埗兵鬼煮意</a>
                                <h1 className="text-xl md:text-2xl font-bold tracking-wider mb-6">${recipe.info().name}</h1>
                            </div>
                            </div>
                            <div className="text-opacity-75 text-gray-700">
                                ${renderContent()}
                            </div>
                        </div>
                        
                    </div>
                </div>   
            </main>
        ');
    };

    function renderImage() {
        return switch recipe {
            case ThreeCupTofu:
                ${StaticResource.image("/images/recipe/3cup-tofu.jpg", recipe.info().name, "rounded-md")}
            case AloeSoda:
                ${StaticResource.image("/images/recipe/aloe-soda.jpg", recipe.info().name, "rounded-md")}
            case BasilTomatoMeat:
                ${StaticResource.image("/images/recipe/basil-tomato-meat.jpg", recipe.info().name, "rounded-md")}
            case BitterMelonVegeEgg:
                ${StaticResource.image("/images/recipe/bitter-melon-vege-egg.jpg", recipe.info().name, "rounded-md")}
            case CatToast:
                ${StaticResource.image("/images/recipe/cat-toast.jpg", recipe.info().name, "rounded-md")}
            case Cauliflower:
                ${StaticResource.image("/images/recipe/cauli.jpg", recipe.info().name, "rounded-md")}
            case Curry:
                ${StaticResource.image("/images/recipe/curry.jpg", recipe.info().name, "rounded-md")}
            case KaleCrisp:
                ${StaticResource.image("/images/recipe/kale-crisp.jpg", recipe.info().name, "rounded-md")}
            case MelonTomatoSoup:
                ${StaticResource.image("/images/recipe/melon-tomato-soup.jpg", recipe.info().name, "rounded-md")}
            case MisoEggplant:
                ${StaticResource.image("/images/recipe/miso-eggplant.jpg", recipe.info().name, "rounded-md")}
            case NinePie:
                ${StaticResource.image("/images/recipe/nine-pie.jpg", recipe.info().name, "rounded-md")}        
            case PotatoCheese:
                ${StaticResource.image("/images/recipe/potato-cheese.jpg", recipe.info().name, "rounded-md")}
            case SandMiso:
                ${StaticResource.image("/images/recipe/sand-miso.jpg", recipe.info().name, "rounded-md")}
            case ShisoTomato:
                ${StaticResource.image("/images/recipe/shiso-tomato.jpg", recipe.info().name, "rounded-md")}
            case Soup:
                ${StaticResource.image("/images/recipe/soup.jpg", recipe.info().name, "rounded-md")}
            case SpanichPasta:
                ${StaticResource.image("/images/recipe/spanich-pasta.jpg", recipe.info().name, "rounded-md")}
            case SweetBitterMelon:
                ${StaticResource.image("/images/recipe/sweet-bitter-melon.jpg", recipe.info().name, "rounded-md")}
            }
    }

    function renderContent() {
        return switch recipe {
            case ThreeCupTofu:
                renderThreeCupTofu();
            case AloeSoda:
                renderAloeSoda();
            case BasilTomatoMeat:
                renderBasilTomatoMeat();
            case BitterMelonVegeEgg:
                renderBitterMelonVegeEgg();
            case CatToast:
                renderCatToast();
            case Cauliflower:
                renderCauliflower();
            case Curry:
                renderCurry();
            case KaleCrisp:
                renderKaleCrisp();
            case MelonTomatoSoup:
                renderMelonTomatoSoup();
            case MisoEggplant:
                renderMisoEggplant();
            case NinePie:
                renderNinePie();
            case PotatoCheese:
                renderPotatoCheese();
            case SandMiso:
                renderSandMiso();
            case ShisoTomato:
                renderShisoTomato();
            case Soup:
                renderSoup();
            case SpanichPasta:
                renderSpanichPasta();
            case SweetBitterMelon:
                renderSweetBitterMelon();
        }
    }

    function renderThreeCupTofu() {
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
              <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">青椒</span>
              <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">九層塔</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
              <p>
              1.豆腐用重物壓至少半個鐘出水，切粒<br/>
              2.青椒切條，薑切片<br/>
              3.用二茶匙麻油爆香薑片到金黃色，再加豆腐同青椒落鑊炒<br/>
              4.加二茶匙蠔油，一茶匙糖，一茶匙味醂，炒勻後收細火繼續收汁<br/>
              5.加入九層塔後炒勻，完成
              </p>
        </fragment>
        ');
    }

    function renderAloeSoda() {
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">蘆薈</span>
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">薄荷</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p className="mb-6">
            1. 先浸洗蘆薈10-15分鐘，確保洗走刺激皮膚嘅大黃素<br/>
            2. 切走兩邊嘅刺同蘆薈頭，再切段，大概4吋一段<br/>
            3. 慢慢片開一邊蘆薈皮，蘆薈𠝹成粒粒，再切落嚟<br/>
            4. 梳打水加入蘆薈肉，檸檬片，新鮮薄荷，完成!
            </p>
            <div className="mb-1 text-xs text-gray-400">備註</div>
            <p>
            - 容易敏感嘅朋友請帶手套<br/>
            - 蘆薈肉會帶有黏液，想爽口嘅朋友可以烚一烚蘆薈肉再過冰水
            </p>
        </fragment>
        ');
    }

    function renderBasilTomatoMeat() {
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">九層塔</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p className="mb-6">
            1.肉碎用麻油醃一醃，蕃茄切塊<br/>
            2.預備醬料，一茶匙豆瓣醬，一茶匙蠔油，攪勻<br/>
            3.開大火先炒肉碎，再加半份蕃茄<br/>
            4.收細火，加醬料用另外半份蕃茄，煮到收汁，唔夠味再加少少鹽<br/>
            5.加入九層塔後炒勻，完成
            </p>
        </fragment>
        ');
    }

    function renderBitterMelonVegeEgg() {
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">沖繩苦瓜</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p className="mb-6">
            1.豆腐用重物壓至少半個鐘出水，再用叉壓碎<br/>
            2.洗乾淨苦瓜後刮走種子同白膜, 切薄片<br/>
            3.怕苦嘅朋友可以拎苦瓜浸鹽水10分鐘<br/>
            4.預熱個鑊加少少油，先炒豆腐，加入1/2茶匙黃薑粉上色<br/>
            5.加入苦瓜片一齊炒，加少少鹽同胡椒粉，完成
            </p>
        </fragment>
        ');
    }

    function renderCatToast() {
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">桑子果醬</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p className="mb-6">
            1. 酵母加50ml水等待到起泡，代表佢可以開工<br/>
            2. 高筋麵粉，鹽，糖攪均<br/>
            3. 加一半水(45ml)慢慢攪均，再加另一半水(45ml)同菜油攪均<br/>
            4. 加酵母水到麵團，搓成光滑圓形後開始第一次發酵，大概1個鐘，建議放入焗爐，側邊放杯熱水保濕同保溫<br/>
            5. 拎麵團出泥搓搓放氣，放入模具再進行第二次發酵，大約90分鐘，視乎情況，麵團發大到模具8成滿就可以開始焗<br/>
            6. 180度焗大概25分鐘，視乎情況調整<br/>
            7. 切包，加果醬，完成
            </p>
            <div className="mb-1 text-xs text-gray-400">備註</div>
            <p>
            純素配方建議份量:<br/>
            ‧高筋麵粉 200g<br/>
            ‧鹽 3g<br/>
            ‧糖 20g<br/>
            ‧酵母 1茶匙<br/>
            ‧水 140ml<br/>
            ‧菜油 12ml
            </p>
        </fragment>
        ');
    }

    function renderCauliflower() {
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">椰菜花</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p>
            1. 用少少鹽, 油, 孜然粉, 煙燻甜紅椒粉，搽均晒切好嘅椰菜花同薯仔<br/>
            2. 加牛油紙蓋面，200度焗20分鐘<br/>
            3. 拎走牛油紙，加芝士，再焗5分鐘
            </p>
        </fragment>
        ');
    }

    function renderCurry() {
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">青椒</span>
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">薯仔</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p>
            1. 1湯匙黃薑粉加半湯匙孜然粉炒配菜(薯仔/甘荀/青椒/翠玉瓜/雪櫃有嘅菜)<br/>
            2. 1湯匙素蠔油加250ml水, 加落鑊中火煮8分鐘煮腍薯仔<br/>
            3️. 加250ml椰奶, 細火煮8分鐘收水
            </p>
        </fragment>
        ');
    }

    function renderKaleCrisp() {
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">羽衣甘藍</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p>
            1. 洗淨羽衣甘藍後fing乾水，葉片搣開細細塊，唔要中間嘅芯<br/>
            2. 用少量油搽均葉面，可以加少少鹽<br/>
            3️. 搵個焗盤放羽衣甘藍，盡量舖平唔重疊，160度焗大約10分鐘，視乎葉片水分抽乾晒未
            </p>
        </fragment>
        ');
    }

    function renderMelonTomatoSoup() {
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">冬瓜</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p className="mb-6">
            1.蕃茄同冬瓜切片，腰果洗乾淨<br/>
            2.用油炒一炒蕃茄到稍稍變稔<br/>
            3.加入冬瓜，腰果，水，中火滾20分鐘，加少少鹽，完成
            </p>
            <div className="mb-1 text-xs text-gray-400">備註</div>
            <p>
            2人建議份量:<br/>
            ‧冬瓜1斤 (600g)<br/>
            ‧蕃茄2隻<br/>
            ‧腰果150g<br/>
            ‧水500mL<br/><br/>
            -蕃茄皮比果肉有更多茄紅素，盡量連皮食啦!
            </p>
        </fragment>
        ');
    }

    function renderMisoEggplant() {
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">茄子</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p className="mb-6">
            1.茄子對半切再𠝹一格格，用鹽醃一醃<br/>
            2.預備醬料，一茶匙味噌，一茶匙豉油，一茶匙味醂，一茶匙糖，攪勻<br/>
            3.茄子皮向上，焗180度10分鐘<br/>
            4.茄子肉向上，搽上醬料，加上芝麻，焗180度5分鐘，完成
            </p>
        </fragment>
        ');
    }
    function renderNinePie() {
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">韮菜</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p className="mb-6">
            1. 韮菜清洗, 抹乾後以半吋大小切粒<br/>
            2. 榨菜切粒<br/>
            3. 打發雞蛋, 加入少量胡椒粉, 以及韮菜榨菜拌勻<br/>
            4. 平底鍋加1湯匙油, 加入蛋漿以中火煎, 成型後翻面再煎香, 完成
            </p>
            <div className="mb-1 text-xs text-gray-400">備註</div>
            <p>
            2底建議份量:<br/>
            ‧韮菜1扎<br/>
            ‧蛋5隻<br/>
            ‧即食榨菜1包<br/>
            ‧白胡椒粉少量
            </p>
        </fragment>
        ');
    }

    function renderPotatoCheese(){
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">薯仔</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p className="mb-6">
            1. 洗淨薯仔批皮切片（半cm厚)<br/>
            2. 常溫水加鹽煲煮，大火冚蓋至水滾，水滾後中火冚蓋煮10分鐘，腍就拎起隔水<br/>
            3. 放兜趁熱壓爛成薯蓉<br/>
            4. 之後加粟粉、鹽、糖、黑椒撈勻<br/>
            5. 攤凍薯蓉時預備定芝士<br/>
            6. 放暖薯蓉後分10份<br/>
            7. 撳扁後中間放芝士慢慢搓至埋口，捏至圓轆狀<br/>
            8. 平底鑊中火熱油後每面煎4分鐘至兩面金黃
            </p>
            <div className="mb-1 text-xs text-gray-400">備註</div>
            <p>
            食譜來自 <a href="https://youtu.be/1h7w2wuPB7g">成波之路 my ways to get fat</a><br/>
            建議份量:<br/>
            ‧薯仔 600g<br/>
            ‧粟粉 4湯匙<br/>
            ‧鹽 1茶匙<br/>
            ‧糖 1茶匙<br/>
            ‧黑椒 1茶匙<br/>
            ‧芝士碎 100g<br/>
            ‧油 2湯匙
            </p>
        </fragment>
        ');
    }

    function renderSandMiso(){
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">沙葛</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p>
            1.幫沙葛同甘荀去皮切片<br/>
            2.預備醬料，二茶匙味噌，一茶匙豉油，一茶匙味醂，一茶匙糖 ，加少少水攪勻<br/>
            3.熱鑊加少少油，先炒稔沙葛甘荀，加芋絲，再加醬料，炒到芋絲上色，完成
            </p>
        </fragment>
        ');
    }
    function renderShisoTomato(){
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">紫蘇</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p>
            1.蕃茄仔洗乾淨切半，用鹽醃至少半個鐘出水<br/>
            2.紫蘇葉切條<br/>
            3.倒走多餘嘅水，蕃茄仔加二茶匙橄欖油，加紫蘇葉，攪勻，完成，未食前可以雪凍再食仲爽口
            </p>
        </fragment>
        ');
    }
    function renderSoup(){
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">粟米</span>
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">紅菜頭</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p>
            1. 洗淨粟米, 紅菜頭, 西芹, 蘋果, 薑, 腰果(約半碗)<br/>
            2. 所有配料放晒落水，開大火到水滾後改用細火煲1個鐘<br/>
            3️. 熄火，加少少鹽
            </p>
        </fragment>
        ');
    }

    function renderSpanichPasta() {
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">菠菜苗</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p>
            1.烚好螺絲粉，瓊乾水備用<br/>
            2.切碎洋蔥、菠菜苗、煙肉<br/>
            3.中火炒洋蔥到半透明，加入煙肉一齊炒<br/>
            4.預備100ml豆漿加二茶匙味噌攪均，收細火後加入<br/>
            5.加螺絲粉同菠菜苗，煮到收汁，完成
            </p>
        </fragment>
        ');
    }

    function renderSweetBitterMelon() {
        return jsx('
        <fragment>
            <div className="mb-1 text-xs text-gray-400">用咗咩歐羅菜</div>
            <div className="mb-6 text-xs">
            <span className="inline-block rounded-full px-2 py-1 mr-2 bg-green-600 text-white">白苦瓜</span>
            </div>
            <div className="mb-1 text-xs text-gray-400">步驟</div>
            <p>
            1.洗乾淨苦瓜後刮走種子同白膜, 切薄片<br/>
            2.怕苦嘅朋友可以拎苦瓜浸鹽水10分鐘<br/>
            3.預備滾水，苦瓜煮1-2分鐘後拎起<br/>
            4.冰鎮苦瓜保持脆卜卜嘅口感<br/>
            5.加入1湯匙醋，1湯匙豉油，1茶匙糖做調味，食得辣可以再加七味粉或乾辣椒，完成
            </p>
        </fragment>
        ');
    }

    
    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        for (recipe in Recipe.all) {
            app.get("/recipe/" + recipe, function get(req:Request, reply:Reply):Promise<Dynamic> {
                return Promise.resolve(
                    reply
                        .header("Cache-Control", "public, max-age=60, stale-while-revalidate=300") // max-age: 1 minute, stale-while-revalidate: 5 minutes
                        .sendView(RecipeDetail, {recipe: recipe})
                );
            });
        }
    }
}