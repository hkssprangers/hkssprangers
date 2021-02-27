package hkssprangers.browser;

import haxe.io.Path;
import js.html.URLSearchParams;
import global.JsCookieGlobal.*;
import mui.core.*;
import js.npm.react_telegram_login.TelegramLoginButton;
import hkssprangers.info.*;
import js.Browser.*;
using hkssprangers.info.OrderTools;
using hkssprangers.info.TimeSlotTools;
using Lambda;
using StringTools;

typedef LogInViewProps = {
    final tgBotName:String;
}

class LogInView extends ReactComponentOfProps<LogInViewProps> {
    override function render() {
        var params = new URLSearchParams(location.search);
        var redirectTo = switch (params.get("redirectTo")) {
            case null:
                window.location.origin;
            case redirectTo:
                if (redirectTo.startsWith("https://"))
                    redirectTo;
                else
                    Path.join([window.location.origin, redirectTo]);
        }
        params.set("redirectTo", redirectTo);
        return jsx('
            <Grid container justify=${Center}>
                <Grid item>
                    <TelegramLoginButton
                        widgetVersion=${14}
                        botName=${props.tgBotName}
                        dataAuthUrl=${Path.join([window.location.origin, "tgAuth?" + params])}
                    />
                </Grid>
            </Grid>
        ');
    }
}