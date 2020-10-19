package hkssprangers.browser;

import js.html.URL;
import moment.Moment;
import js.html.URLSearchParams;
import js_cookie.CookiesStatic;
import global.JsCookieGlobal.*;
import react.*;
import react.ReactComponent;
import react.Fragment;
import react.ReactMacro.jsx;
import mui.core.*;
import js.npm.material_ui.Pickers;
import hkssprangers.info.*;
import js.Browser.*;
import js.lib.Promise;
using hkssprangers.info.OrderTools;
using hkssprangers.info.TimeSlotTools;
using Lambda;
using StringTools;

typedef AdminViewProps = {
    final tgBotName:String;
    final user:Null<{
        tg: {
            id:Int,
            username:String,
        }
    }>;
}

typedef AdminViewState = {
    final isLoading:Bool;
    final selectedDate:Date;
    final orderString:String;
}

class AdminView extends ReactComponentOf<AdminViewProps, AdminViewState> {
    public function new(props):Void {
        super(props);
        state = {
            isLoading: true,
            selectedDate: Date.now(),
            orderString: "",
        };

        loadOrders(state.selectedDate);
    }

    function loadOrders(date:Date):Promise<String> {
        var qs = new URLSearchParams({
            date: DateTools.format(date, "%Y-%m-%d"),
        });
        return window.fetch("/admin?" + qs)
            .then(r ->
                if (r.redirected && new URL(r.url).pathname.startsWith("/login")) {
                    location.assign("/login?" + new URLSearchParams({
                        redirectTo: location.pathname + location.search,
                    }));
                    null;
                } else if (!r.ok || !r.headers.get("Content-Type").toLowerCase().contains("text/plain")) {
                    location.assign(r.url);
                    null;
                } else {
                    r.text();
                }
            )
            .then(str -> {
                setState({
                    isLoading: false,
                    orderString: str,
                });
                str;
            });
    }

    function onSelectedDateChange(date:Moment) {
        var nativeDate:Date = cast date.toDate();
        setState({
            selectedDate: nativeDate,
            isLoading: true,
        });
        loadOrders(nativeDate);
    }

    override function render() {
        var tgMe = 'https://t.me/${props.user.tg.username}';
        var content = if (state.isLoading) {
            jsx('<CircularProgress />');
        } else {
            jsx('<Typography component="pre">${state.orderString}</Typography>');
        }

        return jsx('
            <Grid container=${true} justify=${Center}>
                <Grid item=${true} xs=${12}>
                    <Typography>Logged in as <a href=${tgMe} target="_blank">@${props.user.tg.username}</a></Typography>
                </Grid>
                <Grid item=${true} xs=${12}>
                    <MuiPickersUtilsProvider utils=${MomentUtils}>
                        <DatePicker
                            autoOk=${true}
                            disableToolbar=${true}
                            format="YYYY-MM-DD"
                            openTo="date"
                            views=${["year", "month", "date"]}
                            value=${state.selectedDate}
                            onChange=${onSelectedDateChange}
                        />
                    </MuiPickersUtilsProvider>
                </Grid>
                <Grid item=${true} xs=${12}>
                    ${content}
                </Grid>
            </Grid>
        ');
    }
}