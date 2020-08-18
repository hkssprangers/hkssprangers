package hkssprangers.server;

import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;

class Admin extends View {
    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

    public var tgBotTokenSha256(get, never):String;
    function get_tgBotTokenSha256() return props.tgBotTokenSha256;

    override public function description() return "平台管理";
    override function canonical() return Path.join([domain, "admin"]);
    override public function render() {
        return super.render();
    }

    override function bodyContent() {
        return jsx('
            <div>
                <div className="text-center">
                    <a href="/"><img id="logo" src=${R("/images/ssprangers4-y.png")} className="rounded-circle" alt="埗兵" /></a>
                </div>
                <div id="AdminView"
                    data-tg-bot-name=${tgBotName}
                    data-tg-bot-token-sha256=${tgBotTokenSha256}
                />
            </div>
        ');
    }
}