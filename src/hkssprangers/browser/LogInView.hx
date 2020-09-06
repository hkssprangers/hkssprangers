package hkssprangers.browser;

import js.html.URLSearchParams;
import js_cookie.CookiesStatic;
import global.JsCookieGlobal.*;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import js.npm.material_ui.MaterialUi;
import js.npm.react_telegram_login.TelegramLoginButton;
import hkssprangers.info.Info;
import js.Browser.*;
using hkssprangers.info.Info.OrderTools;
using hkssprangers.info.Info.TimeSlotTools;
using Lambda;

class LogInView extends ReactComponent {
    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

    public var user(get, never):Null<{
        tg: {
            id:Int,
            username:String,
        }
    }>;
    function get_user() return props.user;

    function handleTelegramResponse(response) {
        Cookies.set("tg", response, {
            secure: true,
            sameSite: 'strict',
            expires: 1, // expires 1 day from now
        });
        var params = new URLSearchParams(location.search);
        location.assign(params.get("redirectTo"));
    }

    function renderLoggedIn() {
        var tgMe = 'https://t.me/${user.tg.username}';
        return jsx('
            <Grid container=${true} justify="center">
                <Grid item=${true}>
                    <Typography>Logged in as <a href=${tgMe} target="_blank">@${user.tg.username}</a></Typography>
                </Grid>
            </Grid>
            
        ');
    }

    override function render() {
        return if (user != null)
            renderLoggedIn();
        else
            jsx('
                <Grid container=${true} justify="center">
                    <Grid item=${true}>
                        <TelegramLoginButton
                            botName=${tgBotName}
                            dataOnauth=${handleTelegramResponse}
                        />
                    </Grid>
                </Grid>
            ');
    }
}