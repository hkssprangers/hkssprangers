package hkssprangers.browser;

import js.html.URLSearchParams;
import js_cookie.CookiesStatic;
import global.JsCookieGlobal.*;
import mui.core.*;
import js.npm.react_telegram_login.TelegramLoginButton;
import hkssprangers.info.*;
import js.Browser.*;
using hkssprangers.info.OrderTools;
using hkssprangers.info.TimeSlotTools;
using Lambda;

typedef LogInViewProps = {
    final tgBotName:String;
}

class LogInView extends ReactComponentOfProps<LogInViewProps> {
    function handleTelegramResponse(response) {
        Cookies.set("tg", response, {
            secure: true,
            sameSite: 'strict',
            expires: 1, // expires 1 day from now
        });
        var params = new URLSearchParams(location.search);
        switch (params.get("redirectTo")) {
            case null:
                location.assign("/");
            case redirectTo:
                location.assign(redirectTo);
        }
    }

    override function render() {
        return jsx('
            <Grid container justify=${Center}>
                <Grid item>
                    <TelegramLoginButton
                        botName=${props.tgBotName}
                        dataOnauth=${handleTelegramResponse}
                    />
                </Grid>
            </Grid>
        ');
    }
}