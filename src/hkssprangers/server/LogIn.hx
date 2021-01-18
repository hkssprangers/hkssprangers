package hkssprangers.server;

import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import hkssprangers.server.ServerMain.*;
using Lambda;
using StringTools;
using hkssprangers.server.FastifyTools;

class LogIn extends View {
    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

    override function title():String return "登入";
    override public function description() return "登入";
    override function canonical() return Path.join(["https://" + canonicalHost, "login"]);
    override public function render() {
        return super.render();
    }

    override function bodyContent() {
        return jsx('
            <div>
                <div className="flex justify-center my-4">
                    <a href="/"><img src=${R("/images/ssprangers4-y.png")} className="rounded-full h-24 w-24" alt="埗兵" /></a>
                </div>
                <div id="LogInView"
                    data-tg-bot-name=${tgBotName}
                />
            </div>
        ');
    }

    static public function middleware(req:Request, reply:Reply):js.lib.Promise<Dynamic> {
        return ServerMain.tgMe.then(tgBotInfo ->
            reply.sendView(LogIn, {
                tgBotName: tgBotInfo.username,
            }))
            .catchError(err -> reply.status(500).send(err));
    }
}