package hkssprangers.browser;

import haxe.Json;
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
    final user:Null<Courier>;
}

typedef AdminViewState = {
    final isLoading:Bool;
    final deliveries:Array<{
        var d:Delivery;
        var key:Float;
    }>;
}

@:wrap(react.router.ReactRouter.withRouter)
class AdminView extends ReactComponentOf<AdminViewProps, AdminViewState> {
    static final hr = "\n--------------------------------------------------------------------------------\n";

    function random() return Math.random();

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

    function getUseDb(?search:String) return switch (new URLSearchParams(search != null ? search : props.location.search).get("useDb")) {
        case null: true;
        case "false" | "0": false;
        case v: true;
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
            useDb: getUseDb() ? "true" : "false",
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
                    Promise.resolve([]);
                } else if (!r.ok) {
                    r.text().then(text -> window.alert(text));
                    Promise.resolve([]);
                } else {
                    r.json();
                }
            )
            .then(json -> {
                var deliveries:Array<Delivery> = json;
                setState({
                    isLoading: false,
                    deliveries: deliveries.map(d -> {
                        d: d,
                        key: random(),
                    }),
                });
            });
    }

    function onSelectedDateChange(date:Moment) {
        var nativeDate:Date = cast date.toDate();
        setSelectedDate(nativeDate);
    }

    function renderDelivery(key:Dynamic, d:Delivery) {
        function onChange(changed:Null<Delivery>):Promise<Delivery> {
            return if (changed != null) {
                window.fetch("/admin", {
                    method: "post",
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: Json.stringify({
                        action: d.deliveryId != null ? "update" : "insert",
                        delivery: changed,
                    }),
                })
                    .then(r -> {
                        if (r.ok) {
                            r.json().then(delivery -> {
                                setState({
                                    deliveries: state.deliveries.map(_d -> _d.d == d ? { d: delivery, key: random() } : _d),
                                });
                                delivery;
                            });
                        } else {
                            r.text().then(text -> window.alert(text));
                            null;
                        }
                    });
            } else {
                window.fetch("/admin", {
                    method: "post",
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: Json.stringify({
                        action: "delete",
                        delivery: d,
                    }),
                })
                    .then(r -> {
                        if (r.ok) {
                            setState({
                                deliveries: state.deliveries.filter(_d -> _d.d != d),
                            });
                            d;
                        } else {
                            r.text().then(text -> window.alert(text));
                            null;
                        }
                    });
            }
        }
        return jsx('
            <div key=${key} className="mb-3">
                <DeliveryView
                    delivery=${d}
                    onChange=${onChange}
                    canEdit=${props.user.isAdmin}
                    needEdit=${d.deliveryCode == null}
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
            if (d.d.pickupTimeSlot != null && d.d.pickupTimeSlot.start != null)
                TimeSlotType.classify(d.d.pickupTimeSlot.start) == selectedTimeSlotType;
            else
                true;
        });
        var content = if (state.isLoading) {
            [jsx('<div key=${0} item><CircularProgress /></div>')];
        } else {
            filteredDeliveries.map(d -> renderDelivery(d.key, d.d));
        }

        function addDelivery() {
            var now = Date.now();
            setState({
                deliveries: state.deliveries.concat([{
                    d: {
                        creationTime: now,
                        deliveryCode: null,
                        couriers: [],
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
                    },
                    key: random(),
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
                Std.string(state.deliveries.filter(d -> d.d.pickupTimeSlot == null || d.d.pickupTimeSlot.start == null || TimeSlotType.classify(d.d.pickupTimeSlot.start) == t).length);
            else
                "?";
            var badgeColor = switch (count) {
                case "0", "?": "badge-light";
                case _: "badge-info";
            }
            var label = jsx('
                <div className="d-flex flex-row align-items-center">
                    <span>${t.info().name}</span>
                    <span className=${'badge badge-pill ${badgeColor} mx-1'}>${count}</span>
                </div>
            ');
            jsx('
                <FormControlLabel
                    key=${t}
                    value=${t}
                    control=${jsx('<Radio />')}
                    label=${label}
                    className="badge badge-pill badge-light mx-1"
                />
            ');
        });

        return jsx('
            <Container>
                <Grid container justify=${Center} direction=${Column}>
                    <Grid item container justify=${Center} className="py-2">
                        <Grid item>
                            ${loggedInAs}
                        </Grid>
                    </Grid>
                    <Grid item container justify=${Center} alignItems=${Center} spacing=${Spacing_2}>
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
                    <Grid item container justify=${Center} alignItems=${Center} className="pb-2">
                        <Grid item>
                            <CopyButton
                                title=${selectedDate.format("%Y-%m-%d")}
                                text=${filteredDeliveries.map(d -> DeliveryTools.print(d.d)).join(hr)}
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