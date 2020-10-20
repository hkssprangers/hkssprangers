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
using hkssprangers.info.OrderTools;
using hkssprangers.info.TgTools;
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
        var foodTotal = d.orders.fold((order:Order, result:Float) -> result + switch (order.orderPrice) {
            case null: Math.NaN;
            case v: v;
        }, 0.0);

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
        var pickupLocation = jsx('<Typography>${d.pickupLocation + " (" + d.pickupMethod.info().name + ") ($" + d.deliveryFee + ")"}</Typography>');

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
            <Grid key=${key} item>
                <Card>
                    <CardHeader
                        title=${"📃 " + d.deliveryCode}
                        subheader=${subheader}
                    />
                    <CardContent>
                        <Grid container direction=${Column}>
                            ${d.orders.mapi(renderOrder)}
                        </Grid>

                        <Typography paragraph>總食物價錢+運費: $$${foodTotal + switch(d.deliveryFee) {
                            case null: Math.NaN;
                            case v: v;
                        }}</Typography>

                        <Typography>${d.pickupTimeSlot.print()}</Typography>
                        ${tg}
                        ${wa}
                        ${paymentMethods}
                        ${pickupLocation}
                        ${customerNote}
                    </CardContent>
                </Card>
            </Grid>
        ');
    }

    override function render() {
        var tgMe = 'https://t.me/${props.user.tg.username}';
        var content = if (state.isLoading) {
            [jsx('<Grid key=${0} item><CircularProgress /></Grid>')];
        } else {
            state.deliveries.mapi(renderDelivery);
        }

        return jsx('
            <Container>
                <Grid container justify=${Center} direction=${Column}>
                    <Grid item container justify=${Center}>
                        <Grid item>
                            <Typography>Logged in as <a href=${tgMe} target="_blank">@${props.user.tg.username}</a></Typography>
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
                                    value=${state.selectedDate}
                                    onChange=${onSelectedDateChange}
                                    disabled=${state.isLoading}
                                />
                            </MuiPickersUtilsProvider>
                        </Grid>
                    </Grid>
                    <Grid item container justify=${Center} alignItems=${Center}>
                        <Grid item>
                            <CopyButton
                                title=${state.selectedDate.format("%Y-%m-%d")}
                                text=${state.deliveries.map(DeliveryTools.print).join(hr)}
                            />
                        </Grid>
                    </Grid>
                    <Grid item container justify=${Center} alignItems=${Center}>
                        <Grid item>
                            <Grid item container direction=${Column} spacing=${Spacing_1}>
                                ${content}
                            </Grid>
                        </Grid>
                    </Grid>
                </Grid>
            </Container>
        ');
    }
}