package hkssprangers.browser.forms;

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

    final nextSlots:Array<TimeSlot>;
    
    function new(props, context):Void {
        super(props, context);

        nextSlots = TimeSlotTools.nextTimeSlots(props.currentTime.toDate());

        var initFormData:OrderFormData = {
            currentTime: props.currentTime,
        };
        switch (props.prefill.backupContactMethod) {
            case null: //pass
            case v: initFormData.backupContactMethod = v;
        }
        switch (props.prefill.backupContactValue) {
            case null: //pass
            case v: initFormData.backupContactValue = v;
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

        state = {
            formData: initFormData,
            deliveryPreview: null,
            previewOpen: false,
            isSubmitting: false,
        };
    }

    function getUiSchema(formData:OrderFormData) {
        var pickupTimeSlot = OrderFormSchema.selectedPickupTimeSlot(formData);
        return {
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
        try {
            var t = OrderFormSchema.selectedPickupTimeSlot(formData);
            for (i => o in formData.orders) {
                if (o.shop != null && t != null && t.start != null && t.end != null) {
                    switch o.shop.checkAvailability(formData.currentTime.toDate(), t) {
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
        setState({
            formData: e.formData,
        });
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

        window.fetch("/order-food", {
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

    override function render():ReactFragment {
        var schema = OrderFormSchema.getSchema(nextSlots, state.formData, props.user);
        var uiSchema = getUiSchema(state.formData);

        function onSubmit(e:{
            formData:OrderFormData,
        }, _) {
            var validate = Ajv.call({
                removeAdditional: "all",
            }).compile(schema);
            var isValid:Bool = validate.call(e.formData);
            if (isValid) {
                setState({
                    formData: e.formData,
                    deliveryPreview: OrderFormSchema.formDataToDelivery(e.formData, props.user),
                    previewOpen: true,
                });
            }
        }

        var contact = switch (props.user) {
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

        return jsx('
            <div className="container max-w-screen-md mx-4 p-4">
                <h1 className="text-center text-xl mb-2">
                    埗兵外賣表格
                </h1>
                ${contact}
                <p className="text-sm text-gray-500">*必填項目</p>
                <Form
                    key=${Json.stringify({
                        schema: schema,
                        uiSchema: uiSchema,
                    })}
                    schema=${schema}
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