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
            <meta property="og:image" content=${Path.join(["https://" + hkssprangers.server.ServerMain.host, R("/images/food-waste-recycle/banner-coffee2.jpg")])} />
        </Fragment>
    ');
    override public function render() {
        return super.render();
    }

    override function bodyContent() {
        return jsx('
            <main>
                ${View.header()}
            </main>
        ');
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/recipe", function get(req:Request, reply:Reply):Promise<Dynamic> {
            return Promise.resolve(reply.sendView(Recipe, {}));
        });
    }
}