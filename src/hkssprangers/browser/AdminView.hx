package hkssprangers.browser;

import js.html.URL;
import moment.Moment;
import js.html.URLSearchParams;
import js_cookie.CookiesStatic;
import global.JsCookieGlobal.*;
import mui.core.*;
import js.npm.material_ui.Pickers;
import hkssprangers.info.*;
import js.Browser.*;
import js.lib.Promise;
using hkssprangers.info.OrderTools;
using hkssprangers.info.TimeSlotTools;
using Lambda;
using StringTools;
using DateTools;

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
    final deliveries:Array<Delivery>;
}

class AdminView extends ReactComponentOf<AdminViewProps, AdminViewState> {
    static final hr = "\n--------------------------------------------------------------------------------\n";

    public function new(props):Void {
        super(props);
        state = {
            isLoading: true,
            selectedDate: Date.now(),
            deliveries: [],
        };

        loadOrders(state.selectedDate);
    }

    function loadOrders(date:Date):Promise<Void> {
        var qs = new URLSearchParams({
            date: DateTools.format(date, "%Y-%m-%d"),
        });
        return window.fetch("/admin?" + qs, {
            headers: {
                Accept: "application/json",
            },
        })
            .then(r ->
                if (r.redirected && new URL(r.url).pathname.startsWith("/login")) {
                    location.assign("/login?" + new URLSearchParams({
                        redirectTo: location.pathname + location.search,
                    }));
                    null;
                } else if (!r.ok) {
                    location.assign(r.url);
                    null;
                } else {
                    r.json();
                }
            )
            .then(json -> {
                var deliveries:Array<Delivery> = json;
                setState({
                    isLoading: false,
                    deliveries: deliveries,
                });
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
            jsx('<Typography component="pre">${state.deliveries.map(DeliveryTools.print).join(hr)}</Typography>');
        }

        return jsx('
            <Container>
                <Grid container justify=${Center}>
                    <Grid item container xs=${12} justify=${Center}>
                        <Grid item>
                            <Typography>Logged in as <a href=${tgMe} target="_blank">@${props.user.tg.username}</a></Typography>
                        </Grid>
                    </Grid>
                    <Grid item container xs=${12} justify=${Center}>
                        <Grid item>
                            <MuiPickersUtilsProvider utils=${MomentUtils}>
                                <DatePicker
                                    autoOk
                                    disableToolbar
                                    format="YYYY-MM-DD"
                                    openTo="date"
                                    views=${["year", "month", "date"]}
                                    value=${state.selectedDate}
                                    onChange=${onSelectedDateChange}
                                    disabled=${state.isLoading}
                                />
                            </MuiPickersUtilsProvider>
                        </Grid>
                    </Grid>
                    <Grid item container xs=${12} justify=${Center} alignItems=${Center}>
                        <Grid item>
                            <CopyButton
                                title=${state.selectedDate.format("%Y-%m-%d")}
                                text=${state.deliveries.map(DeliveryTools.print).join(hr)}
                            />
                        </Grid>
                    </Grid>
                    <Grid item xs=${12}>
                        ${content}
                    </Grid>
                </Grid>
            </Container>
        ');
    }
}