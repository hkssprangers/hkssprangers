package hkssprangers.browser;

import js_cookie.CookiesStatic;
import global.JsCookieGlobal.*;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import js.npm.material_ui.MaterialUi;
import js.npm.react_telegram_login.TelegramLoginButton;
import hkssprangers.info.Info;
using hkssprangers.info.Info.OrderTools;
using hkssprangers.info.Info.TimeSlotTools;
using Lambda;

class AdminView extends ReactComponent {
    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

    public var tgBotTokenSha256(get, never):String;
    function get_tgBotTokenSha256() return props.tgBotTokenSha256;

    function handleTelegramResponse(response) {
        if (TelegramTools.verifyLoginResponse(tgBotTokenSha256, response)) {
            Cookies.set("tg", response, {
                secure: true,
                sameSite: 'strict',
            });
        }
    }

    override function render() {
        return jsx('
            <Grid container=${true}>
                <Grid item=${true} xs=${12}>
                    <TelegramLoginButton
                        botName=${tgBotName}
                        dataOnauth=${handleTelegramResponse}
                    />
                </Grid>
            </Grid>
        ');
    }
}