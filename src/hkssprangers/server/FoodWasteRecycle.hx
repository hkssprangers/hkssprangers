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
    override public function title() return '';
    override public function description() return '';
    override function canonical() return Path.join(["https://" + canonicalHost, "food-waste-recycle"]);
    override public function render() {
        return super.render();
    }

    override function bodyContent() {
        return jsx('
            <main>
                
            </main>
        ');
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/food-waste-recycle", function get(req:Request, reply:Reply):Promise<Dynamic> {
            return Promise.resolve(reply.sendView(FoodWasteRecycle, {}));
        });
    }
}