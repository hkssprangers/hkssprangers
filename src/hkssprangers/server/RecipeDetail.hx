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

    override public function title() return '${recipe.info().name} 食譜';
    override public function description() return '${recipe.info().name} 食譜';
    override function canonical() return Path.join(["https://" + canonicalHost, "recipe", recipe]);
    override public function render() {
        return super.render();
    }

    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${imageUrl()} />
        </Fragment>
    ');

    override function depScript():ReactElement {
        return jsx('
            <Fragment>
                <script src="https://cdn.lordicon.com/libs/frhvbuzj/lord-icon-2.0.2.js"></script>
                <script src=${R("/js/menu/menu.js")}></script>
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
                ${View.header()}
                <div className="lg:max-w-screen-2xl mx-auto">
                    <div className="py-12 md:py-16 mx-auto container md:flex" itemScope itemType="https://schema.org/Recipe">
                        <div className="flex-1 px-6 md:px-12">
                            ${renderImage()}
                        </div>
                        <div className="flex-1 px-6 md:pl-0 md:pr-12">
                            <div className="pt-6 md:pt-0 flex">
                            <div>
                                <a href="/recipe"><span itemProp="author">埗兵</span>鬼煮意</a>
                                <h1 className="text-xl md:text-2xl font-bold tracking-wider mb-6" itemProp="name">${recipe.info().name}</h1>
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

    function imageUrl() {
        return switch recipe {
            case ThreeCupTofu:
                R("/images/recipe/3cup-tofu.jpg");
            case AloeSoda:
                R("/images/recipe/aloe-soda.jpg");
            case BasilTomatoMeat:
                R("/images/recipe/basil-tomato-meat.jpg");
            case BitterMelonVegeEgg:
                R("/images/recipe/bitter-melon-vege-egg.jpg");
            case CatToast:
                R("/images/recipe/cat-toast.jpg");
            case Cauliflower:
                R("/images/recipe/cauli.jpg");
            case Curry:
                R("/images/recipe/curry.jpg");
            case KaleCrisp:
                R("/images/recipe/kale-crisp.jpg");
            case MelonTomatoSoup:
                R("/images/recipe/melon-tomato-soup.jpg");
            case MisoEggplant:
                R("/images/recipe/miso-eggplant.jpg");
            case NinePie:
                R("/images/recipe/nine-pie.jpg");
            case PotatoCheese:
                R("/images/recipe/potato-cheese.jpg");
            case SandMiso:
                R("/images/recipe/sand-miso.jpg");
            case ShisoTomato:
                R("/images/recipe/shiso-tomato.jpg");
            case Soup:
                R("/images/recipe/soup.jpg");
            case SpanichPasta:
                R("/images/recipe/spanich-pasta.jpg");
            case SweetBitterMelon:
                R("/images/recipe/sweet-bitter-melon.jpg");
        }
    }

    function renderImage() {
        final style = "rounded-md";
        return switch recipe {
            case ThreeCupTofu:
                ${image("/images/recipe/3cup-tofu.jpg", recipe.info().name, style, "image")}
            case AloeSoda:
                ${image("/images/recipe/aloe-soda.jpg", recipe.info().name, style, "image")}
            case BasilTomatoMeat:
                ${image("/images/recipe/basil-tomato-meat.jpg", recipe.info().name, style, "image")}
            case BitterMelonVegeEgg:
                ${image("/images/recipe/bitter-melon-vege-egg.jpg", recipe.info().name, style, "image")}
            case CatToast:
                ${image("/images/recipe/cat-toast.jpg", recipe.info().name, style, "image")}
            case Cauliflower:
                ${image("/images/recipe/cauli.jpg", recipe.info().name, style, "image")}
            case Curry:
                ${image("/images/recipe/curry.jpg", recipe.info().name, style, "image")}
            case KaleCrisp:
                ${image("/images/recipe/kale-crisp.jpg", recipe.info().name, style, "image")}
            case MelonTomatoSoup:
                ${image("/images/recipe/melon-tomato-soup.jpg", recipe.info().name, style, "image")}
            case MisoEggplant:
                ${image("/images/recipe/miso-eggplant.jpg", recipe.info().name, style, "image")}
            case NinePie:
                ${image("/images/recipe/nine-pie.jpg", recipe.info().name, style, "image")}
            case PotatoCheese:
                ${image("/images/recipe/potato-cheese.jpg", recipe.info().name, style, "image")}
            case SandMiso:
                ${image("/images/recipe/sand-miso.jpg", recipe.info().name, style, "image")}
            case ShisoTomato:
                ${image("/images/recipe/shiso-tomato.jpg", recipe.info().name, style, "image")}
            case Soup:
                ${image("/images/recipe/soup.jpg", recipe.info().name, style, "image")}
            case SpanichPasta:
                ${image("/images/recipe/spanich-pasta.jpg", recipe.info().name, style, "image")}
            case SweetBitterMelon:
                ${image("/images/recipe/sweet-bitter-melon.jpg", recipe.info().name, style, "image")}
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
                <ol className="list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">豆腐用重物壓至少半個鐘出水，切粒</li>
                    <li itemProp="recipeInstructions">青椒切條，薑切片</li>
                    <li itemProp="recipeInstructions">用二茶匙麻油爆香薑片到金黃色，再加豆腐同青椒落鑊炒</li>
                    <li itemProp="recipeInstructions">加二茶匙蠔油，一茶匙糖，一茶匙味醂，炒勻後收細火繼續收汁</li>
                    <li itemProp="recipeInstructions">加入九層塔後炒勻，完成</li>
                </ol>
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
                <ol className="mb-6 list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">先浸洗蘆薈10-15分鐘，確保洗走刺激皮膚嘅大黃素</li>
                    <li itemProp="recipeInstructions">切走兩邊嘅刺同蘆薈頭，再切段，大概4吋一段</li>
                    <li itemProp="recipeInstructions">慢慢片開一邊蘆薈皮，蘆薈𠝹成粒粒，再切落嚟</li>
                    <li itemProp="recipeInstructions">梳打水加入蘆薈肉，檸檬片，新鮮薄荷，完成!</li>
                </ol>
                <div className="mb-1 text-xs text-gray-400">備註</div>
                <ul className="list-disc list-outside pl-4">
                    <li>容易敏感嘅朋友請帶手套</li>
                    <li>蘆薈肉會帶有黏液，想爽口嘅朋友可以烚一烚蘆薈肉再過冰水</li>
                </ul>
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
                <ol className="mb-6 list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">肉碎用麻油醃一醃，蕃茄切塊</li>
                    <li itemProp="recipeInstructions">預備醬料，一茶匙豆瓣醬，一茶匙蠔油，攪勻</li>
                    <li itemProp="recipeInstructions">開大火先炒肉碎，再加半份蕃茄</li>
                    <li itemProp="recipeInstructions">收細火，加醬料用另外半份蕃茄，煮到收汁，唔夠味再加少少鹽</li>
                    <li itemProp="recipeInstructions">加入九層塔後炒勻，完成</li>
                </ol>
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
                <ol className="mb-6 list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">豆腐用重物壓至少半個鐘出水，再用叉壓碎</li>
                    <li itemProp="recipeInstructions">洗乾淨苦瓜後刮走種子同白膜，切薄片</li>
                    <li itemProp="recipeInstructions">怕苦嘅朋友可以拎苦瓜浸鹽水10分鐘</li>
                    <li itemProp="recipeInstructions">預熱個鑊加少少油，先炒豆腐，加入1/2茶匙黃薑粉上色</li>
                    <li itemProp="recipeInstructions">加入苦瓜片一齊炒，加少少鹽同胡椒粉，完成</li>
                </ol>
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
                <ol className="mb-6 list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">酵母加50ml水等待到起泡，代表佢可以開工</li>
                    <li itemProp="recipeInstructions">高筋麵粉，鹽，糖攪均</li>
                    <li itemProp="recipeInstructions">加一半水(45ml)慢慢攪均，再加另一半水(45ml)同菜油攪均</li>
                    <li itemProp="recipeInstructions">加酵母水到麵團，搓成光滑圓形後開始第一次發酵，大概1個鐘，建議放入焗爐，側邊放杯熱水保濕同保溫</li>
                    <li itemProp="recipeInstructions">拎麵團出泥搓搓放氣，放入模具再進行第二次發酵，大約90分鐘，視乎情況，麵團發大到模具8成滿就可以開始焗</li>
                    <li itemProp="recipeInstructions">180度焗大概25分鐘，視乎情況調整</li>
                    <li itemProp="recipeInstructions">切包，加果醬，完成</li>
                </ol>
                <div className="mb-1 text-xs text-gray-400">備註</div>
                <p>純素配方建議份量:</p>
                <ul className="list-disc list-outside pl-4">
                    <li>高筋麵粉 200g</li>
                    <li>鹽 3g</li>
                    <li>糖 20g</li>
                    <li>酵母 1茶匙</li>
                    <li>水 140ml</li>
                    <li>菜油 12ml</li>
                </ul>
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
                <ol className="list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">用少少鹽、油、孜然粉、煙燻甜紅椒粉，搽均晒切好嘅椰菜花同薯仔</li>
                    <li itemProp="recipeInstructions">加牛油紙蓋面，200度焗20分鐘</li>
                    <li itemProp="recipeInstructions">拎走牛油紙，加芝士，再焗5分鐘</li>
                </ol>
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
                <ol className="list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">1湯匙黃薑粉加半湯匙孜然粉炒配菜(薯仔/甘荀/青椒/翠玉瓜/雪櫃有嘅菜)</li>
                    <li itemProp="recipeInstructions">1湯匙素蠔油加250ml水，加落鑊中火煮8分鐘煮腍薯仔</li>
                    <li itemProp="recipeInstructions">加250ml椰奶，細火煮8分鐘收水</li>
                </ol>
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
                <ol className="list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">洗淨羽衣甘藍後揈乾水，葉片搣開細細塊，唔要中間嘅芯</li>
                    <li itemProp="recipeInstructions">用少量油搽均葉面，可以加少少鹽</li>
                    <li itemProp="recipeInstructions">搵個焗盤放羽衣甘藍，盡量舖平唔重疊，160度焗大約10分鐘，視乎葉片水分抽乾晒未</li>
                </ol>
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
                <ol className="mb-6 list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">蕃茄同冬瓜切片，腰果洗乾淨</li>
                    <li itemProp="recipeInstructions">用油炒一炒蕃茄到稍稍變稔</li>
                    <li itemProp="recipeInstructions">加入冬瓜，腰果，水，中火滾20分鐘，加少少鹽，完成</li>
                </ol>
                <div className="mb-1 text-xs text-gray-400">備註</div>
                <p>2人建議份量:</p>
                <ul className="list-disc list-outside pl-4">
                    <li>冬瓜1斤 (600g)</li>
                    <li>蕃茄2隻</li>
                    <li>腰果150g</li>
                    <li>水500mL</li>
                </ul>
                <p>蕃茄皮比果肉有更多茄紅素，盡量連皮食啦!</p>
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
                <ol className="mb-6 list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">茄子對半切再𠝹一格格，用鹽醃一醃</li>
                    <li itemProp="recipeInstructions">預備醬料，一茶匙味噌，一茶匙豉油，一茶匙味醂，一茶匙糖，攪勻</li>
                    <li itemProp="recipeInstructions">茄子皮向上，焗180度10分鐘</li>
                    <li itemProp="recipeInstructions">茄子肉向上，搽上醬料，加上芝麻，焗180度5分鐘，完成</li>
                </ol>
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
                <ol className="mb-6 list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">韮菜清洗，抹乾後以半吋大小切粒</li>
                    <li itemProp="recipeInstructions">榨菜切粒</li>
                    <li itemProp="recipeInstructions">打發雞蛋，加入少量胡椒粉以及韮菜榨菜拌勻</li>
                    <li itemProp="recipeInstructions">平底鍋加1湯匙油，加入蛋漿以中火煎，成型後翻面再煎香，完成</li>
                </ol>
                <div className="mb-1 text-xs text-gray-400">備註</div>
                <p>2底建議份量:</p>
                <ul className="list-disc list-outside pl-4">
                    <li>韮菜1扎</li>
                    <li>蛋5隻</li>
                    <li>即食榨菜1包</li>
                    <li>白胡椒粉少量</li>
                </ul>
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
                <ol className="mb-6 list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">洗淨薯仔批皮切片（半cm厚)</li>
                    <li itemProp="recipeInstructions">常溫水加鹽煲煮，大火冚蓋至水滾，水滾後中火冚蓋煮10分鐘，腍就拎起隔水</li>
                    <li itemProp="recipeInstructions">放兜趁熱壓爛成薯蓉</li>
                    <li itemProp="recipeInstructions">之後加粟粉、鹽、糖、黑椒撈勻</li>
                    <li itemProp="recipeInstructions">攤凍薯蓉時預備定芝士</li>
                    <li itemProp="recipeInstructions">放暖薯蓉後分10份</li>
                    <li itemProp="recipeInstructions">撳扁後中間放芝士慢慢搓至埋口，捏至圓轆狀</li>
                    <li itemProp="recipeInstructions">平底鑊中火熱油後每面煎4分鐘至兩面金黃</li>
                </ol>
                <div className="mb-1 text-xs text-gray-400">備註</div>
                <p>食譜來自 <a href="https://youtu.be/1h7w2wuPB7g">成波之路 my ways to get fat</a></p>
                <p>建議份量:</p>
                <ul className="list-disc list-outside pl-4">
                    <li>薯仔 600g</li>
                    <li>粟粉 4湯匙</li>
                    <li>鹽 1茶匙</li>
                    <li>糖 1茶匙</li>
                    <li>黑椒 1茶匙</li>
                    <li>芝士碎 100g</li>
                    <li>油 2湯匙</li>
                </ul>
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
                <ol className="list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">幫沙葛同甘荀去皮切片</li>
                    <li itemProp="recipeInstructions">預備醬料，二茶匙味噌，一茶匙豉油，一茶匙味醂，一茶匙糖 ，加少少水攪勻</li>
                    <li itemProp="recipeInstructions">熱鑊加少少油，先炒稔沙葛甘荀，加芋絲，再加醬料，炒到芋絲上色，完成</li>
                </ol>
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
                <ol className="list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">蕃茄仔洗乾淨切半，用鹽醃至少半個鐘出水</li>
                    <li itemProp="recipeInstructions">紫蘇葉切條</li>
                    <li itemProp="recipeInstructions">倒走多餘嘅水，蕃茄仔加二茶匙橄欖油，加紫蘇葉，攪勻，完成，未食前可以雪凍再食仲爽口</li>
                </ol>
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
                <ol className="list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">洗淨粟米、紅菜頭、西芹、蘋果、薑、腰果(約半碗)</li>
                    <li itemProp="recipeInstructions">所有配料放晒落水，開大火到水滾後改用細火煲1個鐘</li>
                    <li itemProp="recipeInstructions">熄火，加少少鹽</li>
                </ol>
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
                <ol className="list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">烚好螺絲粉，瓊乾水備用</li>
                    <li itemProp="recipeInstructions">切碎洋蔥、菠菜苗、煙肉</li>
                    <li itemProp="recipeInstructions">中火炒洋蔥到半透明，加入煙肉一齊炒</li>
                    <li itemProp="recipeInstructions">預備100ml豆漿加二茶匙味噌攪均，收細火後加入</li>
                    <li itemProp="recipeInstructions">加螺絲粉同菠菜苗，煮到收汁，完成</li>
                </ol>
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
                <ol className="list-decimal list-outside pl-4">
                    <li itemProp="recipeInstructions">洗乾淨苦瓜後刮走種子同白膜，切薄片</li>
                    <li itemProp="recipeInstructions">怕苦嘅朋友可以拎苦瓜浸鹽水10分鐘</li>
                    <li itemProp="recipeInstructions">預備滾水，苦瓜煮1-2分鐘後拎起</li>
                    <li itemProp="recipeInstructions">冰鎮苦瓜保持脆卜卜嘅口感</li>
                    <li itemProp="recipeInstructions">加入1湯匙醋，1湯匙豉油，1茶匙糖做調味，食得辣可以再加七味粉或乾辣椒，完成</li>
                </ol>
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