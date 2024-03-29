package hkssprangers.browser;

import haxe.io.Path;
import js.html.File;
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
import hkssprangers.AvailabilityTools;
import hkssprangers.info.TimeSlot;
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
    final isAnnouncing:Bool;
    final openAnnounceModal:Bool;
    final isTimeSlotsLoading:Bool;
    final openTimeSlotsModal:Bool;
    final timeSlots:Array<TimeSlotChoice>;
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

    function getToken(?search:String) return new URLSearchParams(search != null ? search : props.location.search).get("token");

    override function componentDidUpdate(prevProps:AdminViewProps, prevState:AdminViewState) {
        final currentSelectedDate = getSelectedDate();
        if (getSelectedDate(prevProps.location.search).getTime() != currentSelectedDate.getTime())
            loadOrders();
    }

    public function new(props):Void {
        super(props);
        state = {
            isLoading: true,
            isAnnouncing: false,
            openAnnounceModal: false,
            isTimeSlotsLoading: false,
            openTimeSlotsModal: false,
            timeSlots: [],
            deliveries: [],
        };

        loadOrders(false);
    }

    function loadOrders(shouldSetState = true):Promise<Void> {
        final token = getToken();
        if (shouldSetState)
            setState({
                isLoading: true,
            });
        final qs = new URLSearchParams(
            if (token == null) {
                format: "json",
                date: DateTools.format(getSelectedDate(), "%Y-%m-%d"),
            } else {
                format: "json",
                token: token,
            }
        );
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
                    Promise.resolve({
                        deliveries: [],
                    });
                } else if (!r.ok) {
                    r.text().then(text -> window.alert(text));
                    Promise.resolve({
                        deliveries: [],
                    });
                } else {
                    r.json();
                }
            )
            .then(json -> {
                var deliveries:Array<Delivery> = json.deliveries;
                if (props.user != null)
                deliveries.sort((a, b) -> {
                    switch [a.couriers.exists(c -> c.courierId == props.user.courierId), b.couriers.exists(c -> c.courierId == props.user.courierId)] {
                        case [true, false]: -1;
                        case [false, true]: 1;
                        case _: 0;
                    }
                });
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
        final token = getToken();
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
        final viewMode:hkssprangers.browser.DeliveryView.DeliveryViewMode = if (token != null) {
            ShopView;
        } else switch (props.user) {
            case null:
                ShopView;
            case { isAdmin: true }:
                AdminView;
            case { isAdmin: false } if (d.couriers.exists(c -> c.courierId == props.user.courierId)):
                AssignedCourierView;
            case { isAdmin: false }:
                CourierView;
        }
        function onAddReceipt(o:Order, file:File):Promise<Dynamic> {
            setState({
                isLoading: true,
            });
            return window.fetch("/admin", {
                method: "post",
                headers: {
                    'Content-Type': 'application/json'
                },
                body: Json.stringify({
                    action: "upload-get-signed-url",
                    orderId: o.orderId,
                    contentType: file.type,
                    fileName: file.name,
                }),
            })
                .then(r -> {
                    if (!r.ok) {
                        r.text().then(Promise.reject);
                    } else {
                        r.text();
                    }
                })
                .then(url -> {
                    trace(url);
                    window.fetch(url, {
                        method: "PUT",
                        mode: CORS,
                        body: file,
                        headers: {
                            'Content-Type': file.type,
                        },
                    }).then(r -> {
                        if (!r.ok) {
                            r.text().then(Promise.reject);
                        } else {
                            Promise.resolve(url);
                        }
                    });
                })
                .then(url -> {
                    var readUrl = {
                        var url = new URL(url);
                        Path.join([url.origin, url.pathname]);
                    }
                    window.fetch("/admin", {
                        method: "post",
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: Json.stringify({
                            action: "upload-done",
                            orderId: o.orderId,
                            fileUrl: readUrl,
                        }),
                    }).then(r -> {
                        if (!r.ok) {
                            r.text().then(Promise.reject);
                        } else {
                            r.text();
                        }
                    });
                })
                .then(_ -> {
                    loadOrders();
                })
                .catchError(err -> {
                    trace(err);
                    window.alert(err);
                });
        }
        function courierLinkClasses(c:Courier):String {
            if (props.user != null && props.user.courierId == c.courierId)
                return 'myDelivery ${badge()} px-2 text-blue-600';
            else
                return "text-blue-600";
        }
        return jsx('
            <div key=${key} className="mb-3">
                <DeliveryView
                    delivery=${d}
                    onChange=${onChange}
                    onAddReceipt=${onAddReceipt}
                    canEdit=${viewMode == AdminView}
                    needEdit=${d.deliveryCode == null}
                    viewMode=${viewMode}
                    courierLinkClasses=${courierLinkClasses}
                />
            </div>
        ');
    }

    function announceToCouriers(deliveries:Array<Delivery>) {
        setState({
            isAnnouncing: true,
        });
        window.fetch("/admin", {
            method: "post",
            headers: {
                'Content-Type': 'application/json'
            },
            body: Json.stringify({
                action: "announce",
                deliveries: deliveries,
            }),
        })
            .then(r -> {
                if (!r.ok) {
                    r.text().then(text -> window.alert(text));
                    null;
                }
                setState({
                    isAnnouncing: false,
                });
            });
    }

    override function render() {
        final token = getToken();
        final selectedTimeSlotType = getSelectedTimeSlotType();
        final filteredDeliveries = if (token == null) {
            state.deliveries.filter(d -> {
                if (d.d.pickupTimeSlot != null && d.d.pickupTimeSlot.start != null)
                    TimeSlotType.classify(d.d.pickupTimeSlot.start) == selectedTimeSlotType;
                else
                    true;
            });
        } else {
            state.deliveries;
        }
        final content = if (state.isLoading) {
            [jsx('<div key=${0} item><CircularProgress /></div>')];
        } else {
            filteredDeliveries.map(d -> renderDelivery(d.key, d.d));
        }
        final now = Date.now();

        function addDelivery() {
            final now = Date.now();
            setState({
                deliveries: state.deliveries.concat([{
                    d: {
                        creationTime: now,
                        deliveryCode: null,
                        couriers: [],
                        customer: {
                            tg: null,
                            tel: null,
                            whatsApp: null,
                            signal: null,
                        },
                        customerPreferredContactMethod: null,
                        customerBackupContactMethod: null,
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
                            receipts: null,
                        }],
                    },
                    key: random(),
                }]),
            });
        }

        final addDeliveryButton = if (state.isLoading || props.user == null || !props.user.isAdmin || token != null) {
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

        final selectedDate = getSelectedDate();

        final timeSlotTypeRadios = [Lunch, Dinner].map(t -> {
            final count = if (!state.isLoading)
                Std.string(state.deliveries.filter(d -> d.d.pickupTimeSlot == null || d.d.pickupTimeSlot.start == null || TimeSlotType.classify(d.d.pickupTimeSlot.start) == t).length);
            else
                "?";
            final badgeColor = switch (count) {
                case "0", "?": "bg-gray-100";
                case _: "bg-green-500 text-white";
            }
            final label = jsx('
                <div className="flex flex-row items-center">
                    <span>${t.info().name}</span>
                    <span className=${'${badge()} ${badgeColor} text-xs font-bold mx-1 px-1.5'}>${count}</span>
                </div>
            ');
            jsx('
                <FormControlLabel
                    key=${t}
                    value=${t}
                    control=${jsx('<Radio />')}
                    label=${label}
                    className=${badge() + " bg-gray-100 mx-1 px-2"}
                />
            ');
        });

        final announceBtnRef = React.createRef();
        final announceBtn = if (props.user != null && props.user.isAdmin) {
            function onClickAnnounce():Void {
                setState({
                    openAnnounceModal: true,
                });
            }
            jsx('
                <IconButton ref=${announceBtnRef} onClick=${onClickAnnounce} disabled=${selectedTimeSlotType == null}>
                    <i className="fas fa-bullhorn"></i>
                </IconButton>
            ');
        } else {
            null;
        }

        function handleAnnounceModalClose() {
            setState({
                openAnnounceModal: false,
            });
        }

        final linksForShop = [
            for (d in filteredDeliveries)
            for (o in d.d.orders)
            o.shop => null
        ];
        if (state.openAnnounceModal) {
            for (shop in linksForShop.keys()) {
                function getLink() {
                    return window.fetch("/admin", {
                        method: "post",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: Json.stringify({
                            action: "share",
                            date: (selectedDate:LocalDateString),
                            time: selectedTimeSlotType,
                            shop: shop,
                        }),
                    })
                        .then(r ->
                            if (r.redirected && new URL(r.url).pathname.startsWith("/login")) {
                                location.assign("/login?" + new URLSearchParams({
                                    redirectTo: location.pathname + location.search,
                                }));
                                Promise.resolve(null);
                            } else if (!r.ok) {
                                r.text().then(text -> window.alert(text));
                                Promise.resolve(null);
                            } else {
                                r.text().then(link -> {
                                    trace(link);
                                    link;
                                });
                            }
                        );
                }
                linksForShop[shop] = jsx('
                    <Grid key=${shop} item>
                        Copy link for ${shop.info().name}
                        <CopyButton
                            text=${getLink}
                        />
                    </Grid>
                ');
            }
        }

        final timeSlotsBtnRef = React.createRef();
        final timeSlotsBtn = if (props.user != null && props.user.isAdmin) {
            function onClickTimeSlots():Void {
                setState({
                    isTimeSlotsLoading: true,
                });
                TimeSlotTools.getTimeSlots(selectedDate)
                    .then(timeSlots -> {
                        setState({
                            timeSlots: timeSlots.filter(s ->
                                TimeSlotType.classify(s.start) == selectedTimeSlotType
                                &&
                                switch (s.availability) {
                                    case Unavailable("已截單"): false;
                                    case _: true;
                                }
                            ),
                            isTimeSlotsLoading: false,
                            openTimeSlotsModal: true,
                        });
                    })
                    .catchError(err -> {
                        alert(err);
                        setState({
                            isTimeSlotsLoading: false,
                        });
                    });
            }
            jsx('
                <IconButton ref=${timeSlotsBtnRef} onClick=${onClickTimeSlots} disabled=${state.isTimeSlotsLoading || selectedTimeSlotType == null}>
                    <i className="fa-regular fa-clock"></i>
                </IconButton>
            ');
        } else {
            null;
        }

        function handleTimeSlotsModalClose() {
            setState({
                openTimeSlotsModal: false,
            });
        }

        final timeSlotControls = switch (state.timeSlots.length) {
            case 0:
                jsx('<Grid item>沒有可開放時段</Grid>');
            case _:
                final controls = state.timeSlots.map(slot -> {
                    final disabled = switch (slot.availability) {
                        case Unavailable(AvailabilityTools.disableMessage): true;
                        case Unavailable(r):
                            trace(r);
                            true;
                        case _: false;
                    }
                    jsx('
                        <Grid key=${slot.start} item>
                            ${slot.print()}
                            <TimeSlotDisableButton
                                timeSlot=${slot}
                                initDisabled=${disabled}
                            />
                        </Grid>
                    ');
                });
                jsx('<Fragment>${controls}</Fragment>');
        }

        final header = if (token != null) {
            if (!state.isLoading) {
                final countWords = '共 ${filteredDeliveries.length} 單';
                jsx('
                    <Grid item container justify=${Center} className="py-2">
                        <Grid item>${countWords}</Grid>
                    </Grid>
                ');
            } else {
                jsx('
                    <Grid item container justify=${Center} className="py-2">
                        <Grid item>Loading</Grid>
                    </Grid>
                ');
            }
        } else {
            final loggedInAs = if (props.user != null) {
                final admin = if (props.user.isAdmin) {
                    " (admin)";
                } else {
                    null;
                }
                jsx('<Typography>Logged in as <a href=${"https://t.me/" + props.user.tg.username} target="_blank" rel="noopener" className="text-blue-600">@${props.user.tg.username}</a>${admin}</Typography>');
            } else {
                null;
            }
            jsx('
                <Fragment>
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
                                className="mb-1 relative left-3"
                                row
                                value=${getSelectedTimeSlotType()}
                                onChange=${(evt:Event) -> setSelectedTimeSlotType((cast evt.target).value)}
                            >
                                ${timeSlotTypeRadios}
                            </RadioGroup>
                        </Grid>
                    </Grid>
                    <Grid item container justify=${Center} alignItems=${Center} className="pb-2">
                        <Grid item>
                            ${timeSlotsBtn}
                            ${announceBtn}
                        </Grid>
                    </Grid>
                </Fragment>
            ');
        }

        final annouceToCouriersDisabled =
            state.isAnnouncing || state.isLoading
            ||
            (selectedDate:LocalDateString).getDatePart() != (now:LocalDateString).getDatePart()
            ||
            filteredDeliveries.length == 0
            ||
            filteredDeliveries.exists(d -> d.d.couriers == null || d.d.couriers.length == 0 || d.d.deliveryFee == null || Math.isNaN(d.d.deliveryFee));

        return jsx('
            <Container>
                <Grid container justify=${Center} direction=${Column}>
                    ${header}
                    <Grid item container justify=${Center} alignItems=${Center}>
                        <Grid item>
                            ${content}
                            ${addDeliveryButton}
                        </Grid>
                    </Grid>
                </Grid>
                <Popover
                    open=${state.openAnnounceModal}
                    onClose=${handleAnnounceModalClose}
                    anchorEl=${() -> announceBtnRef.current}
                    anchorOrigin=${{
                        vertical: Center,
                        horizontal: Center,
                    }}
                    transformOrigin=${{
                        vertical: Center,
                        horizontal: Center,
                    }}
                >
                    <Grid container direction=${Column} alignItems=${FlexEnd}
                        className="px-3 py-2"
                    >
                        <Grid item>
                            Announce to couriers
                            <IconButton
                                onClick=${() -> announceToCouriers(filteredDeliveries.map(d -> d.d))}
                                disabled=${annouceToCouriersDisabled}
                            >
                                <i className="fab fa-telegram"></i>
                            </IconButton>
                        </Grid>
                        ${linksForShop.array()}
                    </Grid>
                </Popover>

                <Popover
                    open=${state.openTimeSlotsModal}
                    onClose=${handleTimeSlotsModalClose}
                    anchorEl=${() -> timeSlotsBtnRef.current}
                    anchorOrigin=${{
                        vertical: Center,
                        horizontal: Center,
                    }}
                    transformOrigin=${{
                        vertical: Center,
                        horizontal: Center,
                    }}
                >
                    <Grid container direction=${Column} alignItems=${FlexEnd}
                        className="px-3 py-2"
                    >
                        ${timeSlotControls}
                    </Grid>
                </Popover>
            </Container>
        ');
    }
}