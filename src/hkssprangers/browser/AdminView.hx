package hkssprangers.browser;

import mui.icon.SpaceBar;
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
import react.router.Link;
using hkssprangers.info.OrderTools;
using hkssprangers.info.TgTools;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.MathTools;
using Lambda;
using StringTools;
using DateTools;

typedef AdminViewProps = react.router.Route.RouteRenderProps & {
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
    final deliveries:Array<Delivery>;
}

@:wrap(react.router.ReactRouter.withRouter)
class AdminView extends ReactComponentOf<AdminViewProps, AdminViewState> {
    static final hr = "\n--------------------------------------------------------------------------------\n";

    function getSelectedDate(?search:String) return switch (new URLSearchParams(search != null ? search : props.location.search).get("date")) {
        case null: Date.now();
        case v: Date.fromString(v);
    }
    function setSelectedDate(v:Date) {
        var query = new URLSearchParams(props.location.search);
        query.set("date", v.format("%Y-%m-%d"));
        props.history.push({
            search: Std.string(query),
        });
    }

    override function componentDidUpdate(prevProps:AdminViewProps, prevState:AdminViewState) {
        var currentSelectedDate = getSelectedDate();
        if (getSelectedDate(prevProps.location.search).getTime() != currentSelectedDate.getTime())
            loadOrders(currentSelectedDate);
    }

    public function new(props):Void {
        super(props);
        state = {
            isLoading: true,
            deliveries: [],
        };

        loadOrders(getSelectedDate(), false);
    }

    function loadOrders(date:Date, shouldSetState = true):Promise<Void> {
        if (shouldSetState)
            setState({
                isLoading: true,
            });
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
        setSelectedDate(nativeDate);
    }

    function renderOrder(key:Dynamic, o:Order) {
        var customerNote = if (o.customerNote != null && o.customerNote != "") {
            jsx('<Typography>⚠️ ${o.customerNote}</Typography>');
        } else {
            null;
        }
        return jsx('
            <Grid key=${key} item>
                <Typography>🔸 ${o.shop.info().name}</Typography>
                <Typography className="pre-wrap">${o.orderDetails}</Typography>
                ${customerNote}
                <Typography>${o.wantTableware ? "要餐具" : "唔要餐具"}</Typography>
                <Typography paragraph>食物價錢: $$${o.orderPrice}</Typography>
            </Grid>
        ');
    }

    function renderDelivery(key:Dynamic, d:Delivery) {
        var foodTotal = d.orders.fold((order:Order, result:Float) -> result + order.orderPrice.nanIfNull(), 0.0);

        var tg = if (d.customer.tg != null && d.customer.tg.username != null) {
            var tgUrl = "https://t.me/" + d.customer.tg.username;
            jsx('<Typography><a href=${tgUrl} target="_blank">${tgUrl}</a> ${d.customerPreferredContactMethod == Telegram ? " 👈" : ""}</Typography>');
        } else {
            null;
        }

        var wa = if (d.customer.tel != null) {
            var waUrl = "https://wa.me/852" + d.customer.tel;
            jsx('<Typography><a href=${waUrl} target="_blank">${waUrl}</a> ${d.customerPreferredContactMethod == WhatsApp ? " 👈" : ""}</Typography>');
        } else {
            null;
        }

        var paymentMethods = jsx('<Typography>${d.paymentMethods.map(p -> p.info().name).join(", ")}</Typography>');
        var pickupLocation = jsx('<Typography>${d.pickupLocation + " (" + d.pickupMethod.info().name + ") ($" + d.deliveryFee.nanIfNull() + ")"}</Typography>');

        var customerNote = if (d.customerNote != null && d.customerNote != "") {
            jsx('<Typography>⚠️ ${d.customerNote}</Typography>');
        } else {
            null;
        }

        var subheader = if (d.couriers == null) {
            null;
        } else {
            var couriers = d.couriers.map(c -> jsx('
                <Grid item><a key=${c.tg.username} href=${"https://t.me/" + c.tg.username} target="_blank">@${c.tg.username}</a></Grid>
            '));
            jsx('
                <Grid container wrap=${NoWrap} spacing=${Spacing_1}>${couriers}</Grid>
            ');
        }

        return jsx('
            <Card key=${key} className="mb-3">
                <CardHeader
                    title=${"📃 " + d.deliveryCode}
                    subheader=${subheader}
                />
                <CardContent>
                    <Grid container direction=${Column}>
                        ${d.orders.mapi(renderOrder)}
                    </Grid>

                    <Typography paragraph>總食物價錢+運費: $$${foodTotal + d.deliveryFee.nanIfNull()}</Typography>

                    <Typography>${d.pickupTimeSlot.print()}</Typography>
                    ${tg}
                    ${wa}
                    ${paymentMethods}
                    ${pickupLocation}
                    ${customerNote}
                </CardContent>
            </Card>
        ');
    }

    override function render() {
        var loggedInAs = if (props.user != null)
            jsx('<Typography>Logged in as <a href=${"https://t.me/" + props.user.tg.username} target="_blank">@${props.user.tg.username}</a></Typography>');
        else
            null;
        var content = if (state.isLoading) {
            [jsx('<div key=${0} item><CircularProgress /></div>')];
        } else {
            state.deliveries.mapi(renderDelivery);
        }

        var selectedDate = getSelectedDate();

        return jsx('
            <Container>
                <Grid container justify=${Center} direction=${Column}>
                    <Grid item container justify=${Center}>
                        <Grid item>
                            ${loggedInAs}
                        </Grid>
                    </Grid>
                    <Grid item container justify=${Center}>
                        <Grid item>
                            <MuiPickersUtilsProvider utils=${MomentUtils}>
                                <DatePicker
                                    autoOk
                                    disableToolbar
                                    format="YYYY-MM-DD"
                                    openTo="date"
                                    views=${["year", "month", "date"]}
                                    value=${selectedDate}
                                    onChange=${onSelectedDateChange}
                                    disabled=${state.isLoading}
                                />
                            </MuiPickersUtilsProvider>
                        </Grid>
                    </Grid>
                    <Grid item container justify=${Center} alignItems=${Center}>
                        <Grid item>
                            <CopyButton
                                title=${selectedDate.format("%Y-%m-%d")}
                                text=${state.deliveries.map(DeliveryTools.print).join(hr)}
                            />
                        </Grid>
                    </Grid>
                    <Grid item container justify=${Center} alignItems=${Center}>
                        <Grid item>
                            ${content}
                        </Grid>
                    </Grid>
                </Grid>
            </Container>
        ');
    }
}