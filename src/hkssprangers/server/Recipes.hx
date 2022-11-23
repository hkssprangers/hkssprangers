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

typedef RecipeProps = {}

class Recipes extends View<RecipeProps> {
    override public function title() return '埗兵鬼煮意';
    override public function description() return '歡迎大家一齊挑戰埗兵本地菜食譜';
    override function canonical() return Path.join(["https://" + canonicalHost, "recipe"]);
    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${Path.join(["https://" + hkssprangers.server.ServerMain.host, R("/images/banner-recipe.jpg")])} />
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
                            <h1 className="text-xl md:text-2xl font-bold text-opacity-75 tracking-wider mb-3">埗兵鬼煮意</h1>
                            <div className="text-opacity-75 text-gray-700">
                                <p className="mb-3">自從開始接觸本地菜，我嘅廚房都開始日日爆，歡迎大家一齊挑戰。大部份食譜都係同食純素嘅外賣員菜菜子一齊研究，偶爾有魚有肉。</p>
                            </div>
                        </div>
                    </div>
                    <div className="py-12 md:py-16 mx-auto container">
                        <div className="px-6 md:px-12 grid grid-cols-2 sm:grid-cols-3 2xl:grid-cols-4 gap-2">
                            ${renderRecipeLinks()}
                        </div>
                    </div>
                </div>
            </main>
        ');
    }

    function renderRecipeLinks() {
        return Recipe.all.map(recipe -> {
            jsx('<a href="/recipe/${recipe.info().id}">
                <div>${renderImage(recipe)}</div>
            </a>');
        });
    }

    function renderImage(recipe) {
        return switch recipe {
            case ThreeCupTofu:
                ${image("/images/recipe/3cup-tofu.jpg", recipe.info().name, "rounded-md")}
            case AloeSoda:
                ${image("/images/recipe/aloe-soda.jpg", recipe.info().name, "rounded-md")}
            case BasilTomatoMeat:
                ${image("/images/recipe/basil-tomato-meat.jpg", recipe.info().name, "rounded-md")}
            case BitterMelonVegeEgg:
                ${image("/images/recipe/bitter-melon-vege-egg.jpg", recipe.info().name, "rounded-md")}
            case CatToast:
                ${image("/images/recipe/cat-toast.jpg", recipe.info().name, "rounded-md")}
            case Cauliflower:
                ${image("/images/recipe/cauli.jpg", recipe.info().name, "rounded-md")}
            case Curry:
                ${image("/images/recipe/curry.jpg", recipe.info().name, "rounded-md")}
            case KaleCrisp:
                ${image("/images/recipe/kale-crisp.jpg", recipe.info().name, "rounded-md")}
            case MelonTomatoSoup:
                ${image("/images/recipe/melon-tomato-soup.jpg", recipe.info().name, "rounded-md")}
            case MisoEggplant:
                ${image("/images/recipe/miso-eggplant.jpg", recipe.info().name, "rounded-md")}
            case NinePie:
                ${image("/images/recipe/nine-pie.jpg", recipe.info().name, "rounded-md")}
            case PotatoCheese:
                ${image("/images/recipe/potato-cheese.jpg", recipe.info().name, "rounded-md")}
            case SandMiso:
                ${image("/images/recipe/sand-miso.jpg", recipe.info().name, "rounded-md")}
            case ShisoTomato:
                ${image("/images/recipe/shiso-tomato.jpg", recipe.info().name, "rounded-md")}
            case Soup:
                ${image("/images/recipe/soup.jpg", recipe.info().name, "rounded-md")}
            case SpanichPasta:
                ${image("/images/recipe/spanich-pasta.jpg", recipe.info().name, "rounded-md")}
            case SweetBitterMelon:
                ${image("/images/recipe/sweet-bitter-melon.jpg", recipe.info().name, "rounded-md")}
        }
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/recipe", function get(req:Request, reply:Reply):Promise<Dynamic> {
            return Promise.resolve(reply.sendView(Recipes, {}));
        });
    }
}