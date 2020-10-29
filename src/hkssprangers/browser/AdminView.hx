package hkssprangers.browser;

import js.html.URL;
import js.html.Event;
import moment.Moment;
import js.html.URLSearchParams;
import mui.core.*;
import js.npm.material_ui.Pickers;
import hkssprangers.info.*;
import js.Browser.*;
import js.lib.Promise;
using hkssprangers.info.OrderTools;
using hkssprangers.info.TgTools;
using hkssprangers.info.TimeSlotType;
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

    function getSelectedTimeSlotType(?search:String) return switch (new URLSearchParams(search != null ? search : props.location.search).get("time")) {
        case null: TimeSlotType.classify(Date.now());
        case v: TimeSlotType.fromId(v);
    }
    function setSelectedTimeSlotType(v:TimeSlotType) {
        var query = new URLSearchParams(props.location.search);
        query.set("time", (v:String));
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

    function renderDelivery(key:Dynamic, d:Delivery) {
        return jsx('
            <div key=${key} className="mb-3">
                <DeliveryView
                    delivery=${d}
                    onChange=${(changed) -> {
                        setState({
                            deliveries:
                                if (changed != null) {
                                    state.deliveries.map(_d -> _d == d ? changed : _d);
                                } else {
                                    state.deliveries.filter(_d -> _d != d);
                                },
                        });
                    }}
                />
            </div>
        ');
    }

    override function render() {
        var loggedInAs = if (props.user != null)
            jsx('<Typography>Logged in as <a href=${"https://t.me/" + props.user.tg.username} target="_blank">@${props.user.tg.username}</a></Typography>');
        else
            null;
        var selectedTimeSlotType = getSelectedTimeSlotType();
        var filteredDeliveries = state.deliveries.filter(d -> {
            if (d.pickupTimeSlot != null && d.pickupTimeSlot.start != null)
                TimeSlotType.classify(d.pickupTimeSlot.start) == selectedTimeSlotType;
            else
                true;
        });
        var content = if (state.isLoading) {
            [jsx('<div key=${0} item><CircularProgress /></div>')];
        } else {
            filteredDeliveries.mapi(renderDelivery);
        }

        function addDelivery() {
            var now = Date.now();
            setState({
                deliveries: state.deliveries.concat([{
                    creationTime: now,
                    deliveryCode: null,
                    couriers: null,
                    customer: {
                        tg: null,
                        tel: null
                    },
                    customerPreferredContactMethod: null,
                    paymentMethods: [],
                    pickupLocation: null,
                    pickupTimeSlot: {
                        start: null,
                        end: null
                    },
                    pickupMethod: null,
                    deliveryFee: null,
                    customerNote: null,
                    orders: [{
                        creationTime: now,
                        orderCode: null,
                        shop: null,
                        wantTableware: null,
                        customerNote: null,
                        orderDetails: null,
                        orderPrice: null,
                        platformServiceCharge: null,
                    }],
                }]),
            });
        }

        var addDeliveryButton = if (state.isLoading) {
            null;
        } else {
            jsx('
                <Button
                    className="mb-2"
                    size=${Small}
                    onClick=${evt -> addDelivery()}
                >
                    Add delivery
                </Button>
            ');
        }

        var selectedDate = getSelectedDate();

        var timeSlotTypeRadios = [Lunch, Dinner].map(t -> {
            var count = if (!state.isLoading)
                Std.string(state.deliveries.filter(d -> TimeSlotType.classify(d.pickupTimeSlot.start) == t).length);
            else
                "?";
            var label = jsx('
                <div className="d-flex flex-row align-items-center">
                    <span>${t.info().name}</span>
                    <span className="badge badge-pill badge-info ml-1">${count}</span>
                </div>
            ');
            jsx('
                <FormControlLabel key=${t} value=${t} control=${jsx('<Radio />')} label=${label} />
            ');
        });

        return jsx('
            <Container>
                <Grid container justify=${Center} direction=${Column}>
                    <Grid item container justify=${Center}>
                        <Grid item>
                            ${loggedInAs}
                        </Grid>
                    </Grid>
                    <Grid item container justify=${Center} spacing=${Spacing_2}>
                        <Grid item>
                            <MuiPickersUtilsProvider utils=${MomentUtils}>
                                <DatePicker
                                    className="date-picker"
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
                        <Grid item>
                            <RadioGroup
                                className="d-flex flex-row"
                                value=${getSelectedTimeSlotType()}
                                onChange=${(evt:Event) -> setSelectedTimeSlotType((cast evt.target).value)}
                            >
                                ${timeSlotTypeRadios}
                            </RadioGroup>
                        </Grid>
                    </Grid>
                    <Grid item container justify=${Center} alignItems=${Center}>
                        <Grid item>
                            <CopyButton
                                title=${selectedDate.format("%Y-%m-%d")}
                                text=${filteredDeliveries.map(DeliveryTools.print).join(hr)}
                            />
                        </Grid>
                    </Grid>
                    <Grid item container justify=${Center} alignItems=${Center}>
                        <Grid item>
                            ${content}
                            ${addDeliveryButton}
                        </Grid>
                    </Grid>
                </Grid>
            </Container>
        ');
    }
}