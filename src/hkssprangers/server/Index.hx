package hkssprangers.server;

import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.server.ServerMain.*;
using hkssprangers.server.FastifyTools;

class Index extends View {
    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

    override public function description() return "深水埗區外賣團隊";
    override function canonical() return host;
    override public function render() {
        return super.render();
    }

    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${Path.join([host, R("/images/ssprangers4-y.png")])} />
        </Fragment>
    ');

    override function bodyContent() {
        return jsx('
            <div>
                <div className="flex justify-center my-4">
                    <a href="/"><img src=${R("/images/ssprangers4-y.png")} className="rounded-full h-24 w-24" alt="埗兵" /></a>
                </div>
                <div id="IndexView"
                    data-tg-bot-name=${tgBotName}
                />
            </div>
        ');
    }

    static public function get(req:Request, reply:Reply):Promise<Dynamic> {
        return Promise.resolve(reply.sendView(Index, {

        }));
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/", Index.get);
    }
}