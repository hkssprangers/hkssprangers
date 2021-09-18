package hkssprangers.browser;

import js.html.File;
import js.lib.Promise;
import js.lib.Object;
import moment.Moment;
import js.html.Event;
import js.npm.material_ui.Pickers;
import mui.core.*;
import hkssprangers.info.*;
import hkssprangers.info.ContactMethod;
import hkssprangers.info.PaymentMethod;
import hkssprangers.info.PickupMethod;
import hkssprangers.info.Delivery;
import thx.Decimal;
using Lambda;
using DateTools;
using StringTools;
using hkssprangers.TelegramTools;
using hkssprangers.MathTools;
using hkssprangers.ObjectTools;
using hkssprangers.ValueTools;
using hkssprangers.info.DeliveryTools;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.info.TgTools;

enum abstract DeliveryViewMode(String) {
    var AdminView;
    var AssignedCourierView;
    var CourierView;
    var ShopView;
    var CustomerView;
} 

typedef DeliveryViewProps = {
    final delivery:Delivery;
    final onChange:Null<Delivery>->Promise<Delivery>;
    final onAddReceipt:(order:Order, file:File)->Promise<Dynamic>;
    final canEdit:Bool;
    @:optional final needEdit:Bool;
    final viewMode:DeliveryViewMode;
    final courierLinkClasses:(c:Courier)->String;
}

typedef DeliveryViewState = {
    final isEditing:Bool;
    final isSaving:Bool;
    final isDeleting:Bool;
    final editingDelivery:Delivery;
    final addedNewCourier:Bool;
}

class DeliveryView extends ReactComponentOf<DeliveryViewProps, DeliveryViewState> {
    function new(props):Void {
        super(props);
        state = {
            isEditing: props.canEdit && props.needEdit,
            isSaving: false,
            isDeleting: false,
            editingDelivery: props.delivery.deepClone(),
            addedNewCourier: false,
        }
    }

    function updateOrder(old:Order, updated:Order) {
        var newDelivery = state.editingDelivery.deepClone().with({
            orders: state.editingDelivery.orders.map(o -> o != old ? o : updated),
        });
        newDelivery.setCouriersIncome();
        setState({
            editingDelivery: newDelivery,
        });
    }

    final inputProps = {
        disableUnderline: true,
    }

    final inputLabelProps = {
        shrink: true,
    }

    function renderOrder(key:Dynamic, o:Order) {
        if (state.isEditing) {
            function orderDetailsOnChange(evt:Event) {
                updateOrder(o, o.with({
                    orderDetails: (cast evt.target).value,
                }));
            }
            function customerNoteOnChange(evt:Event) {
                updateOrder(o, o.with({
                    customerNote: switch ((cast evt.target).value:String) {
                        case "": null;
                        case v: v;
                    },
                }));
            }
            function wantTablewareOnChange(evt:Event) {
                updateOrder(o, o.with({
                    wantTableware: (cast evt.target).value,
                }));
            }
            function orderPriceOnChange(evt:Event) {
                switch ((cast evt.target).value) {
                    case "":
                        updateOrder(o, o.with({
                            orderPrice: Math.NaN,
                            platformServiceCharge: Math.NaN,
                        }));
                    case str:
                        var newPrice = Std.parseFloat(str);
                        var newOrder = o.copy();
                        newOrder.orderPrice = newPrice;
                        OrderTools.setPlatformServiceCharge(newOrder);
                        updateOrder(o, newOrder);
                }
            }
            function shopOnChange(evt:Event) {
                updateOrder(o, o.with({
                    shop: (cast evt.target).value,
                }));
            }
            function onDelete(evt:Event) {
                var newDelivery = state.editingDelivery.deepClone().with({
                    orders: state.editingDelivery.orders.filter(_o -> _o != o),
                });
                newDelivery.setCouriersIncome();
                setState({
                    editingDelivery: newDelivery,
                });
            }
            var shops = Shop.all.map(shop -> {
                jsx('<MenuItem key=${shop} value=${shop}>${shop.info().name}</MenuItem>');
            });
            var product = switch (o.shop) {
                case BlaBlaBla:
                    "飲品";
                case _:
                    "食物";
            }
            return jsx('
                <div key=${key} className="mb-3">
                    <div className="flex items-center">
                        <TextField
                            className="flex-grow mr-1"
                            select
                            label="店舖"
                            variant=${Filled}
                            InputProps=${inputProps}
                            InputLabelProps=${inputLabelProps}
                            value=${o.shop.emptyStrIfNull()}
                            onChange=${shopOnChange}
                        >
                            ${shops}
                        </TextField>
                        <IconButton
                            onClick=${onDelete}
                        >
                            <i className="fas fa-trash"></i>
                        </IconButton>
                    </div>
                    <TextField
                        label="食物內容"
                        variant=${Filled}
                        InputProps=${inputProps}
                        InputLabelProps=${inputLabelProps}
                        multiline
                        rowsMax=${cast Math.POSITIVE_INFINITY}
                        value=${o.orderDetails.emptyStrIfNull()}
                        onChange=${orderDetailsOnChange} />
                    <TextField
                        label="食物備註"
                        variant=${Filled}
                        InputProps=${inputProps}
                        InputLabelProps=${inputLabelProps}
                        multiline
                        rowsMax=${cast Math.POSITIVE_INFINITY}
                        value=${o.customerNote.emptyStrIfNull()}
                        placeholder="無"
                        onChange=${customerNoteOnChange} />
                    <TextField
                        select
                        label="餐具"
                        variant=${Filled}
                        InputProps=${inputProps}
                        InputLabelProps=${inputLabelProps}
                        value=${o.wantTableware.emptyStrIfNull()}
                        onChange=${wantTablewareOnChange}
                    >
                        <MenuItem value=${true}>要餐具</MenuItem>
                        <MenuItem value=${false}>唔要餐具</MenuItem>
                    </TextField>
                    <TextField
                        label=${product + "價錢"}
                        variant=${Filled}
                        type=${Number}
                        InputProps=${inputProps.merge({
                            startAdornment: jsx('<InputAdornment position=${Start}>$$</InputAdornment>'),
                        })}
                        InputLabelProps=${inputLabelProps}
                        value=${o.orderPrice.emptyStrIfNull()}
                        onChange=${orderPriceOnChange} />
                </div>
            ');
        } else {
            var customerNote = if (o.customerNote != null && o.customerNote != "") {
                jsx('<Typography className="whitespace-pre-wrap text-red-600">⚠️ ${o.customerNote}</Typography>');
            } else {
                null;
            }
            var orderDetails = if (o.orderDetails != null && o.orderDetails != "") {
                jsx('<Typography className="whitespace-pre-wrap">${o.orderDetails}</Typography>');
            } else {
                null;
            }
            var tableware = if (o.wantTableware != null) {
                var t = switch (o.shop) {
                    case BlaBlaBla:
                        o.wantTableware ? "要飲管" : "唔要飲管";
                    case _:
                        o.wantTableware ? "要餐具" : "唔要餐具";
                }
                jsx('<Typography>${t}</Typography>');
            } else {
                null;
            }

            var product = switch (o.shop) {
                case BlaBlaBla:
                    "飲品";
                case _:
                    "食物";
            }
            
            var orderPrice = if (o.orderPrice != null && !Math.isNaN(o.orderPrice)) {
                jsx('<Typography>${product}價錢: $$${o.orderPrice}</Typography>');
            } else {
                null;
            }
            var shopContact = if ((switch (props.viewMode) {
                case AdminView | AssignedCourierView | CourierView: true;
                case CustomerView | ShopView: false;
            }) && o.orderDetails != null) {
                o.shop.info().courierContact.map(contact -> {
                    var label = if (contact.startsWith("tel:")) {
                        jsx('<Fragment><i className="fas fa-phone mr-1"></i> telephone</Fragment>');
                    } else if (contact.startsWith("https://wa.me/")) {
                        jsx('<Fragment><i className="fab fa-whatsapp mr-1"></i> WhatsApp</Fragment>');
                    } else if (contact.startsWith("https://t.me/")) {
                        jsx('<Fragment><i className="fab fa-telegram mr-1"></i> Telegram</Fragment>');
                    } else {
                        jsx('<Fragment><i className="fas fa-store mr-1"></i> contact</Fragment>');
                    }
                    jsx('
                        <a key=${contact} href=${contact} target="_blank" rel="noopener" className=${badge() + " bg-gray-100 hover:bg-gray-200 hover:no-underline ml-1 select-none text-xs px-2 py-1 text-gray-800 font-bold"}>
                            ${label}
                        </a>
                    ');
                });
            } else {
                null;
            }
            var receipts = switch (props.viewMode) {
                case AdminView | AssignedCourierView:
                    function onAddRecept(evt) {
                        var file:js.html.File = evt.currentTarget.files[0];
                        props.onAddReceipt(o, file);
                    }
                    var addReceiptBtn = if (props.viewMode == AdminView) {
                        jsx('
                            <Button
                                color=${Primary}
                                component="label"
                            >
                                上傳收據
                                <input
                                    accept="image/*"
                                    type="file"
                                    onChange=${onAddRecept}
                                    hidden
                                />
                            </Button>
                        ');
                    } else {
                        null;
                    }
                    var receiptImages = if (o.receipts != null) {
                        o.receipts.mapi((i,r) -> {
                            jsx('
                                <li key=${r.receiptId}>
                                    <a className="receipt" href=${r.receiptUrl} target="_blank" rel="noopener">
                                        <i className="fas fa-receipt"></i> 收據圖片 ${i+1}
                                    </a>
                                </li>
                            ');
                        });
                    } else {
                        null;
                    }
                    jsx('
                        <div className="receipt mb-2">
                            <ol>
                                ${receiptImages}
                            </ol>
                            ${addReceiptBtn}
                        </div>
                    ');
                case CourierView | CustomerView | ShopView:
                    null;
            }
            return jsx('
                <div key=${key}>
                    <Typography>🔸 ${o.shop != null ? o.shop.info().name : "null"} ${shopContact}</Typography>
                    ${orderDetails}
                    ${customerNote}
                    ${tableware}
                    ${orderPrice}
                    ${receipts}
                </div>
            ');
        }
    }

    function onSave() {
        setState({
            isSaving: true,
        });
        props.onChange(state.editingDelivery.deepClone())
            .then(delivery -> {
                setState({
                    isSaving: false,
                });
                if (delivery != null) {
                    setState({
                        isEditing: false,
                        editingDelivery: delivery,
                    });
                }
            });
    }

    function onCancel() {
        setState({
            isEditing: false,
            editingDelivery: props.delivery.deepClone(),
        });
    }

    function onDelete() {
        setState({
            isDeleting: true,
        });
        props.onChange(null)
            .then(delivery -> {
                setState({
                    isDeleting: false,
                });
            });
    }

    function onEdit() {
        setState({
            isEditing: true,
        });
    }

    override function componentDidUpdate(prevProps:DeliveryViewProps, prevState:DeliveryViewState) {
        if (prevProps.delivery != props.delivery) {
            setState({
                editingDelivery: props.delivery.deepClone(),
            });
        }
    }

    static function renderContact(customer:Customer, contact:ContactMethod) {
        return switch (contact) {
            case null:
                null;
            case Telegram:
                var tgUrl = customer.tg.print();
                jsx('<a href=${tgUrl} target="_blank" rel="noopener">${tgUrl}</a>');
            case WhatsApp:
                var waUrl = switch (customer) {
                    case { whatsApp: tel} if (tel != null):
                        'https://wa.me/852${tel}';
                    case { tel: tel} if (tel != null):
                        'https://wa.me/852${tel}';
                    case _:
                        null;
                }
                jsx('<a href=${waUrl} target="_blank" rel="noopener">${waUrl}</a>');
            case Signal:
                var signalUrl = 'https://signal.me/#p/+852${customer.signal}';
                jsx('<a href=${signalUrl} target="_blank" rel="noopener">${signalUrl}</a>');
            case Telephone:
                var url = 'tel:${customer.tel}';
                jsx('<a href=${url} target="_blank" rel="noopener">${url}</a>');
        }
    }

    function renderContactEditor(contact:ContactMethod) {
        if (contact == null)
            return null;

        var d = state.editingDelivery;
        var value = switch (contact) {
            case null:
                "";
            case Telegram:
                d.customer.tg != null && d.customer.tg.username != null ? d.customer.tg.username : "";
            case WhatsApp:
                d.customer.whatsApp != null ? d.customer.whatsApp : "";
            case Signal:
                d.customer.signal != null ? d.customer.signal : "";
            case Telephone:
                d.customer.tel != null ? d.customer.tel : "";
        } 
        function onChange(evt:Event) {
            var value = switch ((cast evt.target).value) {
                case null | "": null;
                case v: v;
            }
            setState({
                editingDelivery: state.editingDelivery.with({
                    customer: cast Object.assign({}, state.editingDelivery.customer, switch(contact) {
                        case Telegram:
                            {
                                tg: switch (state.editingDelivery.customer.tg) {
                                    case null:
                                        ({
                                            username: value,
                                        }:Tg);
                                    case tg:
                                        tg.with({
                                            username: value,
                                        });
                                }
                            };
                        case WhatsApp:
                            {
                                whatsApp: value,
                            };
                        case Signal:
                            {
                                signal: value,
                            };
                        case Telephone:
                            {
                                tel: value,
                            };
                    }),
                }),
            });
        }
        var inputProps = switch (contact) {
            case Telegram:
                inputProps.merge({
                    startAdornment: jsx('<InputAdornment position=${Start}>@</InputAdornment>'),
                });
            case _:
                inputProps;
        };
        return jsx('
            <TextField
                label=${"客人" + contact.info().name}
                variant=${Filled}
                InputProps=${inputProps}
                InputLabelProps=${inputLabelProps}
                value=${value}
                onChange=${onChange} />
        ');
    }

    override function render() {
        var d = if (!state.isEditing) {
            props.delivery;
        } else {
            state.editingDelivery;
        }
        var foodTotal = d.orders.fold((order:Order, result:Float) -> result + order.orderPrice.nanIfNull(), 0.0);

        var pickupTimeSlot = if (!state.isEditing) {
            jsx('<Typography>${d.pickupTimeSlot != null && d.pickupTimeSlot.start != null && d.pickupTimeSlot.end != null ? d.pickupTimeSlot.print() : "null"}</Typography>');
        } else {
            function onStartTimeChange(date:Moment) {
                var nativeDate:Date = cast date.toDate();
                setState({
                    editingDelivery: state.editingDelivery.with({
                        pickupTimeSlot: state.editingDelivery.pickupTimeSlot.with({
                            start: (nativeDate:LocalDateString),
                        })
                    })
                });
            }
            function onEndTimeChange(date:Moment) {
                var nativeDate:Date = cast date.toDate();
                setState({
                    editingDelivery: state.editingDelivery.with({
                        pickupTimeSlot: state.editingDelivery.pickupTimeSlot.with({
                            end: (nativeDate:LocalDateString),
                        })
                    })
                });
            }
            jsx('
                <div className="flex flex-wrap sm:flex-nowrap justify-between">
                    <MuiPickersUtilsProvider utils=${MomentUtils}>
                        <DateTimePicker
                            className="sm:flex-grow sm:mr-1"
                            label="交收時段開始"
                            inputVariant="filled"
                            InputProps=${inputProps}
                            InputLabelProps=${inputLabelProps}
                            fullWidth
                            ampm=${false}
                            format="YYYY-MM-DD HH:mm"
                            openTo="hours"
                            value=${d.pickupTimeSlot.start.toDate().emptyStrIfNull()}
                            onChange=${onStartTimeChange}
                        />
                        <DateTimePicker
                            className="sm:flex-grow"
                            label="交收時段完結"
                            inputVariant="filled"
                            InputProps=${inputProps}
                            InputLabelProps=${inputLabelProps}
                            fullWidth
                            ampm=${false}
                            format="YYYY-MM-DD HH:mm"
                            openTo="hours"
                            value=${d.pickupTimeSlot.end.toDate().emptyStrIfNull()}
                            onChange=${onEndTimeChange}
                        />
                    </MuiPickersUtilsProvider>
                </div>
            ');
        }

        var customerPreferredContactMethod = if (!state.isEditing) {
            null;
        } else {
            var contactMethods = ContactMethod.all.map(m -> {
                jsx('<MenuItem key=${m} value=${m}>${m.info().name}</MenuItem>');
            });
            function customerPreferredContactMethodOnChange(evt:Event) {
                var v:String = (cast evt.target).value;
                var m = ContactMethod.fromId(v);
                setState({
                    editingDelivery: state.editingDelivery.with({
                        customerPreferredContactMethod: m,
                    }),
                });
            }
            jsx('
                <TextField
                    select
                    label="聯絡方法"
                    variant=${Filled}
                    InputProps=${inputProps}
                    InputLabelProps=${inputLabelProps}
                    value=${d.customerPreferredContactMethod.emptyStrIfNull()}
                    onChange=${customerPreferredContactMethodOnChange}
                >
                    ${contactMethods}
                </TextField>
            ');
        }

        var preferredContact = if (!state.isEditing) {
            jsx('
                <Typography>
                    ${renderContact(d.customer, d.customerPreferredContactMethod)} 👈
                </Typography>
            ');
        } else {
            renderContactEditor(d.customerPreferredContactMethod);
        }
        

        var customerBackupContactMethod = if (!state.isEditing) {
            null;
        } else {
            var contactMethods = ContactMethod.all.map(m -> {
                jsx('<MenuItem key=${m} value=${m}>${m.info().name}</MenuItem>');
            });
            function customerBackupContactMethodOnChange(evt:Event) {
                var v:String = (cast evt.target).value;
                var m = ContactMethod.fromId(v);
                setState({
                    editingDelivery: state.editingDelivery.with({
                        customerBackupContactMethod: m,
                    }),
                });
            }
            jsx('
                <TextField
                    select
                    label="後備聯絡方法"
                    variant=${Filled}
                    InputProps=${inputProps}
                    InputLabelProps=${inputLabelProps}
                    value=${d.customerBackupContactMethod.emptyStrIfNull()}
                    onChange=${customerBackupContactMethodOnChange}
                >
                    <MenuItem value="">無</MenuItem>
                    ${contactMethods}
                </TextField>
            ');
        }

        var backupContact = if (!state.isEditing) {
            jsx('
                <Typography>
                    ${renderContact(d.customer, d.customerBackupContactMethod)}
                </Typography>
            ');
        } else {
            renderContactEditor(d.customerBackupContactMethod);
        }

        var wa = if (!state.isEditing) {
            if (d.customer.tel != null) {
                var waUrl = "https://wa.me/852" + d.customer.tel;
                jsx('<Typography><a href=${waUrl} target="_blank" rel="noopener">${waUrl}</a> ${d.customerPreferredContactMethod == WhatsApp ? " 👈" : ""}</Typography>');
            } else {
                null;
            }
        } else {
            function telOnChange(evt:Event) {
                var v:String = (cast evt.target).value;
                var tel = v != "" ? v : null;
                setState({
                    editingDelivery: state.editingDelivery.with({
                        customer: state.editingDelivery.customer.with({
                            tel: tel,
                        }),
                    }),
                });
            }
            jsx('
                <TextField
                    label="客人WhatsApp"
                    variant=${Filled}
                    InputProps=${inputProps.merge({
                        startAdornment: jsx('<InputAdornment position=${Start}>+852</InputAdornment>'),
                    })}
                    InputLabelProps=${inputLabelProps}
                    value=${d.customer.tel.emptyStrIfNull()}
                    onChange=${telOnChange} />
            ');
        }

        var paymentMethods = if (!state.isEditing) {
            if (d.paymentMethods != null)
                jsx('<Typography>${d.paymentMethods.map(p -> p.info().name).join(", ")}</Typography>');
            else
                null;
        } else {
            var items = [PayMe, FPS].map(m -> {
                function onChange(evt) {
                    var checked:Bool = (cast evt.target).checked;
                    setState({
                        editingDelivery: state.editingDelivery.with({
                            paymentMethods:
                                if (checked) {
                                    state.editingDelivery.paymentMethods.concat([m]);
                                } else {
                                    state.editingDelivery.paymentMethods.filter(_m -> _m != m);
                                },
                        }),
                    });
                }
                var checkbox = jsx('
                    <Checkbox
                        checked=${d.paymentMethods.has(m)}
                        onChange=${onChange}
                    />
                ');
                jsx('
                    <FormControlLabel
                        key=${m}
                        control=${checkbox}
                        label=${m.info().name}
                    />
                ');
            });
            jsx('
                <FormControl component="fieldset" className="mt-2">
                    <FormLabel component="legend" className="mb-0">付款方法</FormLabel>
                    <FormGroup row>
                        ${items}
                    </FormGroup>
                </FormControl>
            ');
        }

        var pickupLocation = if (!state.isEditing) {
            if (d.pickupLocation != null)
                jsx('<Typography>${d.pickupLocation + " (" + (d.pickupMethod != null ? d.pickupMethod.info().name : "null") + ")" + (d.deliveryFee != null && !Math.isNaN(d.deliveryFee) ? " (運費 $" + d.deliveryFee + ")" : "")}</Typography>');
            else
                null;
        } else {
            function locOnChange(evt:Event) {
                var v:String = (cast evt.target).value;
                var loc = v != "" ? v : null;
                setState({
                    editingDelivery: state.editingDelivery.with({
                        pickupLocation: loc,
                    }),
                });
            }
            function pickupMethodOnChange(evt:Event) {
                var v:String = (cast evt.target).value;
                var m = PickupMethod.fromId(v);
                setState({
                    editingDelivery: state.editingDelivery.with({
                        pickupMethod: m,
                    }),
                });
            }
            function deliveryFeeOnChange(evt:Event) {
                var v:String = (cast evt.target).value;
                var deliveryFee = Std.parseFloat(v);
                var newDelivery = state.editingDelivery.deepClone();
                newDelivery.deliveryFee = deliveryFee;
                newDelivery.setCouriersIncome();
                setState({
                    editingDelivery: newDelivery,
                });
            }
            var pickupMethods = [Door, HangOutside, Street].map(m -> {
                jsx('<MenuItem key=${m} value=${m}>${m.info().name}</MenuItem>');
            });
            jsx('
                <Fragment>
                    <TextField
                        label="交收地點"
                        variant=${Filled}
                        InputProps=${inputProps}
                        InputLabelProps=${inputLabelProps}
                        value=${d.pickupLocation.emptyStrIfNull()}
                        onChange=${locOnChange} />
                    <TextField
                        select
                        label="交收方法"
                        variant=${Filled}
                        InputProps=${inputProps}
                        InputLabelProps=${inputLabelProps}
                        value=${d.pickupMethod.emptyStrIfNull()}
                        onChange=${pickupMethodOnChange}
                    >
                        ${pickupMethods}
                    </TextField>
                    <TextField
                        label="運費"
                        variant=${Filled}
                        type=${Number}
                        InputProps=${inputProps.merge({
                            startAdornment: jsx('<InputAdornment position=${Start}>$$</InputAdornment>'),
                        })}
                        InputLabelProps=${inputLabelProps}
                        value=${d.deliveryFee.emptyStrIfNull()}
                        onChange=${deliveryFeeOnChange} />
                </Fragment>
            ');
        }

        var customerNote = if (!state.isEditing) {
            if (d.customerNote != null && d.customerNote != "") {
                jsx('<Typography className="whitespace-pre-wrap text-red-600">⚠️ ${d.customerNote}</Typography>');
            } else {
                null;
            }
        } else {
            function customerNoteOnChange(evt:Event) {
                var v:String = (cast evt.target).value;
                var customerNote = v != "" ? v : null;
                setState({
                    editingDelivery: state.editingDelivery.with({
                        customerNote: customerNote,
                    }),
                });
            }
            jsx('
                <TextField
                    label="運送備註"
                    variant=${Filled}
                    InputProps=${inputProps}
                    InputLabelProps=${inputLabelProps}
                    multiline
                    rowsMax=${cast Math.POSITIVE_INFINITY}
                    value=${d.customerNote.emptyStrIfNull()}
                    placeholder="無"
                    onChange=${customerNoteOnChange}
                />
            ');
        }

        var subheader = if (d.couriers == null || d.couriers.length == 0) {
            null;
        } else {
            var couriers = d.couriers.map(c -> jsx('
                <Grid item key=${c.tg.username}>
                    <a className=${props.courierLinkClasses(c)} href=${"https://t.me/" + c.tg.username} target="_blank" rel="noopener">
                        @${c.tg.username}
                    </a>
                </Grid>
            '));
            jsx('
                <Grid container wrap=${NoWrap} spacing=${Spacing_1} alignItems=${Center}>
                    <Grid item>外賣員:</Grid>${couriers}
                </Grid>
            ');
        }

        function addOrder() {
            var newDelivery = state.editingDelivery.deepClone();
            newDelivery.orders.push({
                creationTime: Date.now(),
                shop: null,
                wantTableware: null,
                customerNote: null,
                orderDetails: null,
                orderPrice: null,
                platformServiceCharge: null,
                receipts: null,
            });
            newDelivery.setCouriersIncome();
            setState({
                editingDelivery: newDelivery,
            });
        }

        var addOrderButton = if (!state.isEditing) {
            null;
        } else {
            jsx('
                <Button
                    className="mb-2"
                    size=${Small}
                    onClick=${evt -> addOrder()}
                >
                    Add order
                </Button>
            ');
        }

        var actions = if (state.isEditing) {
            jsx('
                <CardActions className="flex">
                    <Button
                        variant=${Contained}
                        color=${Primary}
                        size=${Small}
                        onClick=${evt -> onSave()}
                        disabled=${state.isSaving}
                    >
                        Save
                    </Button>
                    <Button
                        size=${Small}
                        onClick=${evt -> onCancel()}
                    >
                        Cancel
                    </Button>
                    <Button
                        className="ml-auto"
                        size=${Small}
                        color=${Secondary}
                        onClick=${evt -> onDelete()}
                        disabled=${state.isDeleting}
                    >
                        Delete
                    </Button>
                </CardActions>
            ');
        } else if (props.canEdit) {
            jsx('
                <CardActions>
                    <Button size=${Small} onClick=${evt -> onEdit()}>Edit</Button>
                </CardActions>
            ');
        } else {
            null;
        }

        var copyBtn = if (d.orders.foreach(o -> o.orderDetails != null)) {
            jsx('
                <CopyButton
                    text=${() -> Promise.resolve(DeliveryTools.print(d))}
                />
            ');
        } else {
            null;
        }

        var cardHeader = if (!state.isEditing) {
            jsx('
                <CardHeader
                    title=${"📃 " + d.deliveryCode}
                    subheader=${subheader}
                    action=${copyBtn}
                />
            ');
        } else {
            function deliveryCodeOnChange(evt:Event) {
                var v:String = (cast evt.target).value;
                var deliveryCode = v != "" ? v : null;
                setState({
                    editingDelivery: state.editingDelivery.with({
                        deliveryCode: deliveryCode,
                    }),
                });
            }
            function addCourier() {
                var newCouriers = state.editingDelivery.couriers.ifNull([]).concat([{
                    tg: {
                        username: "",
                    },
                    isAdmin: null,
                    deliveryFee: null,
                    deliverySubsidy: null,
                }]);
                var newDelivery = state.editingDelivery.with({
                    couriers: newCouriers,
                });
                newDelivery.setCouriersIncome();
                setState({
                    addedNewCourier: true,
                    editingDelivery: newDelivery,
                });
            }
            var couriers = d.couriers == null ? [] : d.couriers.mapi((i, c) -> {
                function onChange(evt) {
                    setState({
                        editingDelivery: state.editingDelivery.with({
                            couriers: state.editingDelivery.couriers.map(_c -> _c != c ? _c : _c.with({
                                tg: _c.tg.with({
                                    username: ((cast evt.target).value:String).trim().replace("@", ""),
                                }),
                            })),
                        }),
                    });
                }
                function onDelete(evt) {
                    var newDelivery = state.editingDelivery.with({
                        couriers: state.editingDelivery.couriers.filter(_c -> _c != c),
                    });
                    newDelivery.setCouriersIncome();
                    setState({
                        editingDelivery: newDelivery,
                    });
                }
                function inputRef(input:js.html.InputElement) {
                    if (input != null && input.value == "" && i == d.couriers.length - 1 && state.addedNewCourier) {
                        input.focus();
                        setState({
                            addedNewCourier: false,
                        });
                    }
                }
                jsx('
                    <div key=${i} className=${badge() + " flex flex-row items-center bg-gray-100 mr-1 my-1 px-2"}>
                        <Input
                            className="courierTgInuput pl-2"
                            startAdornment=${jsx('<InputAdornment position=${Start}>@</InputAdornment>')}
                            value=${c.tg.username.emptyStrIfNull()}
                            onChange=${onChange}
                            inputRef=${cast inputRef}
                            {...inputProps}
                        />
                        <IconButton
                            className="deleteBtn"
                            onClick=${onDelete}
                        >
                            <i className="fas fa-times"></i>
                        </IconButton>
                    </div>
                ');
            });
            jsx('
                <Fragment>
                    <TextField
                        label="運送編號"
                        variant=${Filled}
                        InputProps=${inputProps}
                        InputLabelProps=${inputLabelProps}
                        value=${d.deliveryCode.emptyStrIfNull()}
                        onChange=${deliveryCodeOnChange}
                    />
                    <div className="flex flex-wrap px-3">
                        ${couriers}
                    </div>
                    <div className="flex items-center px-3">
                        <Button
                            size=${Small}
                            onClick=${evt -> addCourier()}
                        >
                            Add Courier
                        </Button>
                    </div>
                </Fragment>
            ');
        }

        var customerTotal = {
            var total = foodTotal + d.deliveryFee.nanIfNull();
            var text = if (Math.isNaN(total)) {
                "";
            } else {
                '總食物價錢+運費: $$${total}';
            }
            jsx('<Typography paragraph className="py-2">${text}</Typography>');
        }

        return jsx('
            <Card className="delivery-card" elevation=${state.isEditing ? 5 : 1}>
                ${cardHeader}
                <CardContent>
                    ${d.orders.mapi(renderOrder)}
                    ${addOrderButton}

                    ${customerTotal}

                    ${pickupTimeSlot}
                    ${customerPreferredContactMethod}
                    ${preferredContact}
                    ${customerBackupContactMethod}
                    ${backupContact}
                    ${paymentMethods}
                    ${pickupLocation}
                    ${customerNote}
                </CardContent>
                ${actions}
            </Card>
        ');
    }
}