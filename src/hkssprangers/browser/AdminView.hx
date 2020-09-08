package hkssprangers.browser;

import js.html.URL;
import moment.Moment;
import js.html.URLSearchParams;
import js_cookie.CookiesStatic;
import global.JsCookieGlobal.*;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import js.npm.material_ui.MaterialUi;
import js.npm.material_ui.Pickers;
import hkssprangers.info.Info;
import js.Browser.*;
import js.lib.Promise;
using hkssprangers.info.Info.OrderTools;
using hkssprangers.info.Info.TimeSlotTools;
using Lambda;
using StringTools;

class AdminView extends ReactComponent {
    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

    public var user(get, never):Null<{
        tg: {
            id:Int,
            username:String,
        }
    }>;
    function get_user() return props.user;

    public var isLoading(get, set):Bool;
    function get_isLoading() return state.isLoading;
    function set_isLoading(v) {
        setState({
            isLoading: v,
        });
        return v;
    }

    public var selectedDate(get, set):Date;
    function get_selectedDate() return state.selectedDate;
    function set_selectedDate(v) {
        setState({
            selectedDate: v,
        });
        return v;
    }

    public var orderString(get, set):String;
    function get_orderString() return state.orderString;
    function set_orderString(v) {
        setState({
            orderString: v,
        });
        return v;
    }

    public function new(props):Void {
        super(props);
        state = {
            isLoading: true,
            selectedDate: Date.now(),
            orderString: "",
        };

        loadOrders(selectedDate);
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
                isLoading = false;
                orderString = str;
            });
    }

    function onSelectedDateChange(date:Moment) {
        var nativeDate:Date = cast date.toDate();
        selectedDate = nativeDate;
        isLoading = true;
        loadOrders(nativeDate);
    }

    override function render() {
        var tgMe = 'https://t.me/${user.tg.username}';
        var content = if (isLoading) {
            jsx('<CircularProgress />');
        } else {
            jsx('<Typography component="pre">${orderString}</Typography>');
        }

        return jsx('
            <Grid container=${true} justify="center">
                <Grid item=${true} xs=${12}>
                    <Typography>Logged in as <a href=${tgMe} target="_blank">@${user.tg.username}</a></Typography>
                </Grid>
                <Grid item=${true} xs=${12}>
                    <MuiPickersUtilsProvider utils=${MomentUtils}>
                        <DatePicker
                            autoOk=${true}
                            disableToolbar=${true}
                            format="YYYY-MM-DD"
                            openTo="date"
                            views=${["year", "month", "date"]}
                            value=${selectedDate}
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