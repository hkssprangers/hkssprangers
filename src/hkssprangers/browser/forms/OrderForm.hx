package hkssprangers.browser.forms;

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
import mui.core.*;
import haxe.Json;
import haxe.ds.ReadOnlyArray;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.info.OrderTools;
using Reflect;
using Lambda;
using hxLINQ.LINQ;

typedef OrderFormProps = {
    final user:LoggedinUser;
}
typedef OrderFormState = {
    final formData:OrderFormData;
}

typedef OrderFormData = {
    ?backupContactMethod:ContactMethod,
    ?backupContactValue:String,
    ?pickupTimeSlot:JsonString<TimeSlot>,
    ?pickupLocation:String,
    ?pickupMethod:PickupMethod,
    ?orders:Array<FormOrderData>,
    ?paymentMethods:Array<PaymentMethod>,
}

class OrderForm extends ReactComponentOf<OrderFormProps, OrderFormState> {
    final nextSlots = TimeSlotTools.nextTimeSlots(Date.now());
    static public function selectedPickupTimeSlot(formData:OrderFormData):TimeSlot {
        return switch (formData.pickupTimeSlot) {
            case null: null;
            case str: str.parse();
        };
    }
    public function getSchema(nextSlots:Array<TimeSlot>, formData:OrderFormData) {
        var pickupTimeSlot = selectedPickupTimeSlot(formData);
        var clusterOptions = switch (formData) {
            case null | { orders: null | [] }:
                Shop.all;
            case { orders: _.linq().select((o, _) -> o.shop).first(s -> s != null) => shop } if (shop != null):
                var cluster = ShopCluster.classify(shop);
                Shop.all.filter(s -> ShopCluster.classify(s) == cluster);
            case _:
                Shop.all;
        }
        function shopSchema(options:ReadOnlyArray<Shop>):Dynamic return switch (options) {
            case []:
                {
                    type: "null",
                    title: "店舖",
                };
            case options:
                {
                    type: "string",
                    title: "店舖",
                    oneOf: options.map(s -> {
                        type: "string",
                        title: s.info().name,
                        const: s,
                    }),
                };
        };
        function orderSchema(shopOptions:ReadOnlyArray<Shop>) return {
            type: "object",
            properties: {
                shop: shopSchema(shopOptions),
            },
            required: [
                "shop",
            ],
        };
        function customerNote(shop:Shop) return {
            type: "string",
            title: '食物備註',
            description: '留意 ${shop.info().name} 未必能完全配合, 請見諒',
        };
        var wantTableware = {
            type: "boolean",
            title: '要餐具/飲管?',
            "default": false,
        }
        var schema = {
            type: "object",
            properties: {
                pickupTimeSlot: {
                    type: "string",
                    title: "想幾時收到?",
                    oneOf: nextSlots.map(s -> {
                        title: s.print(),
                        const: Json.stringify(s),
                    }),
                },
                pickupLocation: {
                    type: "string",
                    title: "運送目的地",
                },
                pickupMethod: {
                    type: "string",
                    title: "交收方法",
                    oneOf: [
                        PickupMethod.Door,
                        PickupMethod.HangOutside,
                        PickupMethod.Street,
                    ].map(m -> {
                        title: m.info().name,
                        const: m,
                    }),
                },
                backupContactMethod: {
                    type: "string",
                    title: "後備聯絡方法",
                    oneOf: ContactMethod.all.filter(m -> switch (props.user) {
                        case null: true;
                        case {login: loginMethod}: m != loginMethod;
                    }).map(m -> {
                        title: m.info().name,
                        const: m,
                    }),
                },
                backupContactValue: (switch (formData.backupContactMethod){
                    case Telegram: 
                        {
                            type: "string",
                            title: "後備聯絡 " + Telegram.info().name,
                            pattern: "@?[A-Za-z0-9_]{5,}",
                        }
                    case WhatsApp: 
                        {
                            type: "string",
                            title: "後備聯絡 " + WhatsApp.info().name,
                            pattern: "[0-9]{8}",
                            minLength: 8,
                            maxLength: 8,
                        }
                    case Signal: 
                        {
                            type: "string",
                            title: "後備聯絡 " + Signal.info().name,
                            pattern: "[0-9]{8}",
                            minLength: 8,
                            maxLength: 8,
                        }
                    case Telephone: 
                        {
                            type: "string",
                            title: "後備聯絡" + Telephone.info().name,
                            pattern: "[0-9]{8}",
                            minLength: 8,
                            maxLength: 8,
                        }
                    case _: 
                        {
                            type: "null",
                            title: "後備聯絡",
                        }
                }:Dynamic),
                orders: {
                    type: "array",
                    items: (formData.orders == null || formData.orders.length == 0 ? orderSchema(clusterOptions) : {
                        formData.orders.linq().select((o, i) -> {
                            var orderSchema = orderSchema(o.shop != null ? [o.shop] : clusterOptions.filter(s -> !formData.orders.exists(_o -> _o.shop == s)));
                            switch (o.shop) {
                                case null:
                                    //pass
                                case shop:
                                    Object.assign(orderSchema.properties, {
                                        items: shop.itemsSchema(pickupTimeSlot, o),
                                        wantTableware: wantTableware,
                                        customerNote: customerNote(o.shop),
                                    });
                                    orderSchema.required.push("items");
                                    orderSchema.required.push("wantTableware");
                            }
                            orderSchema;
                        }).toArray();
                    }:Dynamic),
                    additionalItems: orderSchema(clusterOptions),
                    minItems: 1,
                },
                paymentMethods: {
                    type: "array",
                    title: "俾錢方法",
                    description: "本平台不接受現金付款",
                    items: {
                        type: "string",
                        oneOf: [
                            PaymentMethod.PayMe,
                            PaymentMethod.FPS,
                        ].map(m -> {
                            title: m.info().name,
                            const: m,
                        }),
                    },
                    minItems: 1,
                    uniqueItems: true,
                },
                customerNote: {
                    type: "string",
                    title: "其他運送備註",
                    description: "留意店鋪/埗兵未必能完全配合, 請見諒",
                },
            },
            required: [
                "pickupTimeSlot",
                "pickupLocation",
                "pickupMethod",
                "orders",
                "paymentMethods",
            ].concat(switch formData.backupContactMethod {
                case null: [];
                case _: ["backupContactValue"];
            }),
        };
        return schema;
    }

    function new(props, context):Void {
        super(props, context);
        state = {
            formData: {},
        };
    }

    function getUiSchema(formData:OrderFormData) {
        var pickupTimeSlot = selectedPickupTimeSlot(formData);
        return {
            pickupLocation: {
                "ui:options": {
                    multiline: true,
                },
            },
            orders: {
                "ui:ArrayFieldTemplate": OrdersTemplate,
                items:{
                    shop: {
                        "ui:widget": ShopSelectorWidget,
                        "ui:options": {
                            pickupTimeSlot: pickupTimeSlot,
                        },
                    },
                    items: {
                        "ui:ArrayFieldTemplate": OrderItemsTemplate,
                        items: {
                            "ui:FieldTemplate": OrderItemTemplate,
                            "ui:ObjectFieldTemplate": OrderItemObjectFieldTemplate,
                            item: {
                                "ui:FieldTemplate": OrderItemTemplate,
                                options: {
                                    "ui:widget": "checkboxes",
                                },
                                extraOptions: {
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

    override function render():ReactFragment {
        var schema = getSchema(nextSlots, state.formData);
        var uiSchema = getUiSchema(state.formData);

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
            // trace(e.formData);
            // Ajv.call({
            //     removeAdditional: "all"
            // }).compile(schema).call(e.formData);
            // trace(e.formData);
            setState({
                formData: e.formData,
            });
        }

        function onSubmit(e:{
            formData:OrderFormData,
        }, _) {
            var isValid:Bool = Ajv.call({
                removeAdditional: "all",
            }).compile(schema).call(e.formData);
            trace(isValid);
            trace(Json.stringify(e.formData, null, "  "));
        }

        function validate(formData:OrderFormData, errors:Dynamic):Dynamic {
            var t = selectedPickupTimeSlot(formData);
            for (i => o in formData.orders) {
                if (o.shop != null) {
                    switch o.shop.checkAvailability(t) {
                        case Available:
                            //pass
                        case Unavailable(reason):
                            errors.orders[i].addError(reason);
                    }
                }
            }
            return errors;
        }

        var contact = switch (props.user) {
            case null: null;
            case {login: Telegram, tg: tg}:
                jsx('
                    <p className="text-gray-500 mb-2"><a href=${"https://t.me/" + tg.username} target="_blank">${"@" + tg.username}</a> 你好！請輸入以下資料，我哋收到後會經 Telegram 聯絡你。</p>
                ');
            case _: null;
        }

        var orders:Array<Order> = switch (state.formData) {
            case {
                orders: orders,
                pickupTimeSlot: pickupTimeSlot,
            }
            if (orders != null && pickupTimeSlot != null):
                var summaries = [
                    for (d in orders)
                    if (d.shop != null && d.items != null)
                    d.shop => d.shop.summarize(pickupTimeSlot.parse(), d)
                ];
                [
                    for (shop => summary in summaries)
                    if (summary != null)
                    {
                        orderId: null,
                        creationTime: null,
                        orderCode: null,
                        shop: shop,
                        wantTableware: summary.wantTableware,
                        customerNote: summary.customerNote,
                        orderDetails: summary.orderDetails,
                        orderPrice: summary.orderPrice,
                        platformServiceCharge: null,
                        receipts: [],
                    }
                ];
            case _:
                [];
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
                    onChange=${onChange}
                    onSubmit=${onSubmit}
                    validate=${validate}
                    widgets=${{
                        TextWidget: TextWidget,
                        SelectWidget: SelectWidget,
                    }}
                >
                </Form>
                <pre>
                    ${orders.map(o -> o.print()).join("\n")}
                </pre>
            </div>
        ');
    }
}