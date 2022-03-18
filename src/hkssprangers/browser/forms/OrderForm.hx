package hkssprangers.browser.forms;

import js.Browser;
import js.html.URLSearchParams;
import mui.core.styles.Styles;
import hkssprangers.info.Delivery;
import haxe.DynamicAccess;
import hkssprangers.info.Order;
import hkssprangers.info.ShopCluster;
import hkssprangers.info.ContactMethod;
import hkssprangers.info.LoggedinUser;
import hkssprangers.info.PaymentMethod;
import hkssprangers.info.PickupMethod;
import hkssprangers.info.TimeSlot;
import hkssprangers.info.Shop;
import hkssprangers.info.FormOrderData;
import hkssprangers.info.menu.*;
import js.npm.rjsf.material_ui.*;
import js.lib.Object;
import js.Browser.*;
import mui.core.*;
import haxe.Json;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.info.OrderTools;
using hkssprangers.info.DeliveryTools;
using hkssprangers.ValueTools;
using Reflect;
using Lambda;
using hxLINQ.LINQ;

typedef OrderFormProps = {
    final user:LoggedinUser;
    final prefill:OrderFormPrefill;
    final currentTime:LocalDateString;
}
typedef OrderFormState = {
    final schema:Dynamic;
    final formData:OrderFormData;
    final deliveryPreview:Delivery;
    final previewOpen:Bool;
    final isSubmitting:Bool;
}

class OrderForm extends ReactComponentOf<OrderFormProps, OrderFormState> {
    static final ClosePreviewButton = Styles.styled(mui.core.IconButton)({
        position: Absolute,
        top: 5,
        right: 5,
    });
    
    function new(props, context):Void {
        super(props, context);

        state = {
            schema: null,
            formData: null,
            deliveryPreview: null,
            previewOpen: false,
            isSubmitting: false,
        };
    }

    override function componentDidMount() {
        final initFormData:OrderFormData = {
            currentTime: props.currentTime,
            orders: [],
        };
        switch (props.prefill.backupContactMethod) {
            case null: //pass
            case v: initFormData.backupContactMethod = v;
        }
        switch (props.prefill.backupContactValue) {
            case null: //pass
            case v: initFormData.backupContactValue = v;
        }
        switch (props.prefill.pickupTimeSlot) {
            case null: //pass
            case v: initFormData.pickupTimeSlot = v;
        }
        switch (props.prefill.pickupMethod) {
            case null: //pass
            case v: initFormData.pickupMethod = v;
        }
        switch (props.prefill.pickupLocation) {
            case null: //pass
            case v: initFormData.pickupLocation = v;
        }
        switch (props.prefill.paymentMethods) {
            case null: //pass
            case v: initFormData.paymentMethods = v;
        }
        setFormData(initFormData);
    }

    function setFormData(formData:OrderFormData) {
        setState({
            formData: formData,
        }, () -> {
            OrderFormSchema.getSchema(formData, props.user)
                .then(schema -> {
                    if (formData == state.formData) {
                        setState({
                            schema: schema,
                        });
                    } else {
                        // outdated, probably there is a new setFormData() running
                        trace("outdated schema");
                    }
                });
        });
    }

    function getUiSchema(formData:OrderFormData) {
        return {
            currentTime: { "ui:widget": "hidden" },
            pickupTimeSlot: {
                "ui:widget": TimeSlotSelectorWidget,
            },
            pickupLocation: {
                "ui:options": {
                    multiline: true,
                },
            },
            backupContactValue: {
                "ui:options": switch formData.backupContactMethod {
                    case null:
                        {
                            inputType: "text",
                        };
                    case Telegram:
                        {
                            inputType: "text",
                            startAdornment: "@",
                        };
                    case WhatsApp:
                        {
                            inputType: "tel",
                        };
                    case Signal:
                        {
                            inputType: "tel",
                        };
                    case Telephone:
                        {
                            inputType: "tel",
                        };
                }
            },
            orders: {
                "ui:ArrayFieldTemplate": OrdersTemplate,
                items:{
                    "ui:ObjectFieldTemplate": OrderObjectFieldTemplate,
                    shop: {
                        "ui:widget": ShopSelectorWidget,
                    },
                    items: {
                        "ui:ArrayFieldTemplate": OrderItemsTemplate,
                        items: {
                            "ui:FieldTemplate": OrderItemTemplate,
                            "ui:ObjectFieldTemplate": OrderItemObjectFieldTemplate,
                            item: {
                                "ui:FieldTemplate": OrderItemTemplate,
                                "ui:ArrayFieldTemplate": OrderItemArrayFieldTemplate,
                                addons: {
                                    "ui:ArrayFieldTemplate": OrderItemArrayFieldTemplate,
                                },
                                options: {
                                    "ui:widget": "checkboxes",
                                },
                                extraOptions: {
                                    "ui:widget": "checkboxes",
                                },
                                cOptions: {
                                    "ui:widget": "checkboxes",
                                },
                                dOptions: {
                                    "ui:widget": "checkboxes",
                                },
                                baseOptions: {
                                    "ui:widget": "checkboxes",
                                },
                                toppingOptions: {
                                    "ui:widget": "checkboxes",
                                },
                                topupOptions: {
                                    "ui:widget": "checkboxes",
                                },
                                seasoningOptions: {
                                    "ui:widget": "checkboxes",
                                },
                            },
                        },
                    }
                }
            },
            paymentMethods: {
                "ui:widget": "checkboxes",
            },
            customerNote: {
                "ui:options": {
                    multiline: true,
                },
            },
        };
    }

    static function validate(formData:OrderFormData, errors:Dynamic):Dynamic {
        // make sure shops are available
        try {
            final t = OrderFormSchema.selectedPickupTimeSlot(formData);
            final currentTime = formData.currentTime.toDate();
            for (i => o in formData.orders) {
                if (o.shop != null && t != null && t.start != null && t.end != null && currentTime != null) {
                    switch o.shop.checkAvailability(currentTime, t) {
                        case Available:
                            //pass
                        case Unavailable(reason):
                            errors.orders[i].addError(reason);
                    }
                }
            }
        } catch (err) {
            trace(err);
        }

        // make sure the timeslot is valid
        try {
            final timeSlots = TimeSlotTools.getTimeSlots(formData.pickupTimeSlot.parse().start);
            switch (timeSlots.find(ts -> haxe.Json.stringify(ts) == formData.pickupTimeSlot)) {
                case null | { enabled: false }:
                    errors.pickupTimeSlot.addError("交收時段不正確");
                case _:
                    // pass
            }
        } catch (err) {
            trace(err);
        }

        return errors;
    }

    function onChange(e:{
        edit:Bool,
        formData:OrderFormData,
        errors:Array<Dynamic>,
        errorSchema:Dynamic,
        idSchema:Dynamic,
        schema:Dynamic,
        uiSchema:Dynamic,
        ?status:String,
    }) {
        setFormData(e.formData);
    }

    function closePreview() {
        setState({
            previewOpen: false,
        });
    }

    function sendForm() {
        setState({
            isSubmitting: true,
        });

        var url = switch (BrowserMain.auth) {
            case null:
                "/order-food";
            case auth:
                "/order-food?" + new URLSearchParams({
                    auth: auth,
                });
        };

        window.fetch(url, {
            method: "post",
            headers: {
                'Content-Type': 'application/json'
            },
            body: Json.stringify(state.formData),
        })
        .then(r -> {
            if (r.ok) {
                r.json().then(delivery -> {
                    alert("成功發送");
                });
            } else {
                setState({
                    isSubmitting: false,
                });
                r.text().then(text -> alert(text));
            }
        });
    }

    function onError(errors:Array<{
        stack: String,
    }>) {
        trace(errors);
        alert("表格有錯誤/漏填");
    }

    function onSubmit(e:{
        formData:OrderFormData,
    }, _) {
        final validate = Ajv.call({
            removeAdditional: "all",
        }).compile(state.schema);
        final isValid:Bool = validate.call(e.formData);
        if (isValid) {
            OrderFormSchema.formDataToDelivery(e.formData, props.user)
                .then(deliveryPreview -> {
                    setState({
                        formData: e.formData,
                        deliveryPreview: deliveryPreview,
                        previewOpen: true,
                    });
                });
        }
    }

    override function render():ReactFragment {
        final contact = switch (props.user) {
            case null: null;
            case {login: Telegram, tg: tg}:
                jsx('
                    <p className="text-gray-500 mb-2"><a href=${"https://t.me/" + tg.username} target="_blank" rel="noopener">${"@" + tg.username}</a> 你好！請輸入以下資料，我哋收到後會經 Telegram 聯絡你。</p>
                ');
            case {login: WhatsApp, tel: tel}:
                jsx('
                    <p className="text-gray-500 mb-2"><a href=${"https://wa.me/852" + tel} target="_blank" rel="noopener">${tel}</a> 你好！請輸入以下資料，我哋收到後會經 WhatsApp 聯絡你。</p>
                ');
            case _: null;
        }

        final form = if (state.schema == null) {
            jsx('<div>Loading</div>');
        } else {
            final uiSchema = getUiSchema(state.formData);
            jsx('
                <Form
                    key=${Json.stringify({
                        schema: state.schema,
                        uiSchema: uiSchema,
                    })}
                    schema=${state.schema}
                    uiSchema=${uiSchema}
                    formData=${state.formData}
                    formContext=${state.formData}
                    onChange=${onChange}
                    onSubmit=${onSubmit}
                    onError=${onError}
                    validate=${validate}
                    noHtml5Validate=${true}
                    showErrorList=${false}
                    widgets=${{
                        TextWidget: TextWidget,
                        SelectWidget: SelectWidget,
                    }}
                >
                    <div className="my-5">
                        <Button variant=${Contained} color=${Primary} type=${Submit}>
                            下一步
                        </Button>
                    </div>
                </Form>
            ');
        }

        return jsx('
            <div className="container max-w-screen-md mx-4 p-4">
                <h1 className="text-center text-xl mb-2">
                    埗兵外賣表格
                </h1>
                ${contact}
                <p className="text-sm text-gray-500">*必填項目</p>
                ${form}
                <Dialog
                    open=${state.previewOpen}
                    onClose=${closePreview}
                >
                    <ClosePreviewButton
                        aria-label="close"
                        onClick=${closePreview}
                    >
                        <i className="fas fa-times"></i>
                    </ClosePreviewButton>
                    <DialogContent className="whitespace-pre-wrap mt-4">
                        ${state.deliveryPreview != null ? state.deliveryPreview.print() : null}
                    </DialogContent>
                    <DialogActions>
                        <Button onClick=${sendForm} variant=${Contained} color=${Primary} disabled=${state.isSubmitting}>
                            發送訂單
                        </Button>
                    </DialogActions>
                </Dialog>
            </div>
        ');
    }
}