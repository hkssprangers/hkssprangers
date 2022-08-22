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

typedef RecipeProps = {}

class Recipe extends View<RecipeProps> {
    override public function title() return '埗兵鬼煮意';
    override public function description() return '歡迎大家一齊挑戰埗兵本地菜食譜';
    override function canonical() return Path.join(["https://" + canonicalHost, "recipe"]);
    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${Path.join(["https://" + hkssprangers.server.ServerMain.host, R("/images/banner-vege-album.jpg")])} />
        </Fragment>
    ');

    override public function render() {
        return super.render();
    }

    override function bodyContent() {
        return jsx('
            <main>
                ${View.header()}
                <div className="lg:max-w-screen-2xl mx-auto bg-bowl-yellow bg-no-repeat bg-contain bg-right-top">

                    <div className="py-12 md:py-16 mx-auto container">
                        
                        <div className="md:w-2/3 lg:w-1/2 px-6 md:px-12">
                            <h1 className="text-xl md:text-2xl font-bold text-opacity-75 tracking-wider mb-3">埗兵鬼煮意</h1>
                            <div className="text-opacity-75 text-gray-700">
                                <p className="mb-3">自從開始接觸本地菜，我嘅廚房都開始日日爆，歡迎大家一齊挑戰。大部份食譜都係同食純素嘅外賣員菜菜子一齊研究，偶爾有魚有肉。</p>
                            </div>
                        </div>
                    </div>

                    <div className="py-12 md:py-16 mx-auto container">
                        
                        <div className="px-6 md:px-12 grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-2">
                            <div>${StaticResource.image("/images/recipe/3cup-tofu.jpg", "3 cup tofu", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/aloe-soda.jpg", "aloe soda", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/basil-tomato-meat.jpg", "basil-tomato-meat", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/bitter-melon-vege-egg.jpg", "bitter-melon-vege-egg", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/cat-toast.jpg", "cat-toast", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/cauli.jpg", "roasted cauliflower", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/curry.jpg", "curry", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/kale-crisp.jpg", "kale crisp", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/melon-tomato-soup.jpg", "melon tomato soup", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/miso-eggplant.jpg", "miso eggplant", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/nine-pie.jpg", "nine pie", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/potato-cheese.jpg", "potato cheese", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/sand-miso.jpg", "sand miso", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/shiso-tomato.jpg", "shiso tomato", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/soup.jpg", "soup", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/spanich-pasta.jpg", "spanich pasta", "rounded-md")}</div>
                            <div>${StaticResource.image("/images/recipe/sweet-bitter-melon.jpg", "sweet bitter melon", "rounded-md")}</div>
                            
                        </div>
                    </div>
                </div>
            </main>
        ');
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/recipe", function get(req:Request, reply:Reply):Promise<Dynamic> {
            return Promise.resolve(reply.sendView(Recipe, {}));
        });
    }
}