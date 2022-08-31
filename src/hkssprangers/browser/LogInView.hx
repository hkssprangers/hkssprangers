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
        var redirectToAdmin = redirectTo == Path.join([window.location.origin, "admin"]);
        if (redirectToAdmin) {
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
        } else {
            return jsx('
                <div className="text-center p-2">
                    <p>請使用我哋嘅 Telegram (建議) / WhatsApp 機械人登入我哋嘅落單系統。</p>
                    <div className="flex flex-wrap mt-2 max-w-md mx-auto">
                        <a
                            href=${"https://t.me/" + props.tgBotName}
                            className="flex-1 m-2 py-2 px-5 text-center rounded-lg text-white no-underline"
                            style=${{"backgroundColor": "#0088cc"}}
                        >
                            <h2 className="font-bold whitespace-nowrap"><i className="fab fa-telegram-plane"></i> Telegram</h2>
                            <p className="whitespace-nowrap">@${props.tgBotName}</p>
                        </a>
                        <a
                            href="https://wa.me/85264507612?text=%E7%99%BB%E5%85%A5%E8%90%BD%E5%96%AE"
                            className="flex-1 m-2 py-2 px-5 text-center rounded-lg text-white no-underline"
                            style=${{"backgroundColor": "#25D366"}}
                        >
                            <h2 className="font-bold whitespace-nowrap"><i className="fab fa-whatsapp"></i> WhatsApp</h2>
                            <p className="whitespace-nowrap">+852 64507612</p>
                        </a>
                    </div>
                </div>
            ');
        }
    }
}