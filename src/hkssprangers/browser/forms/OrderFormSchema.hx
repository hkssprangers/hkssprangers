package hkssprangers.browser.forms;

import thx.Decimal;
import js.lib.Object;
import hkssprangers.info.ContactMethod;
import haxe.ds.ReadOnlyArray;
import haxe.Json;
import hkssprangers.info.*;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.info.OrderTools;
using hkssprangers.info.DeliveryTools;
using Reflect;
using Lambda;
using hxLINQ.LINQ;

class OrderFormSchema {
    static public function selectedPickupTimeSlot(formData:OrderFormData):TimeSlot {
        return switch (formData.pickupTimeSlot) {
            case null: null;
            case str: str.parse();
        };
    }
    static public function getSchema(nextSlots:Array<TimeSlot>, formData:OrderFormData, user:LoggedinUser) {
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
                    oneOf: ContactMethod.all.filter(m -> switch (user) {
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
                            pattern: "[A-Za-z0-9_]{5,}",
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

    static public function formDataToDelivery(formData:OrderFormData, user:LoggedinUser):Delivery {
        var orders:Array<Order> = switch (formData) {
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
                        platformServiceCharge: (summary.orderPrice:Decimal) * 0.15,
                        receipts: [],
                    }
                ];
            case _:
                [];
        }

        var delivery:Delivery = {
            creationTime: null,
            deliveryCode: "訂單預覽",
            couriers: null,
            customer: {
                tg: null,
                tel:null,
                whatsApp: null,
                signal: null,
            },
            customerPreferredContactMethod: null,
            customerBackupContactMethod: null,
            paymentMethods: formData.paymentMethods,
            pickupLocation: formData.pickupLocation,
            pickupTimeSlot: switch (formData.pickupTimeSlot) {
                case null: null;
                case str: str.parse();
            },
            pickupMethod: formData.pickupMethod,
            deliveryFee: null,
            customerNote: formData.customerNote,
            deliveryId: null,
            orders: orders
        };

        switch (user) {
            case null: null;
            case {login: Telegram, tg: tg}:
                delivery.customerPreferredContactMethod = Telegram;
                delivery.customer.tg = tg;
            case {login: WhatsApp, tel: tel}:
                delivery.customerPreferredContactMethod = WhatsApp;
                delivery.customer.whatsApp = tel;
            case _:
                throw "Unknown login: " + user;
        }

        switch formData.backupContactMethod {
            case null:
                // pass
            case Telegram:
                delivery.customerBackupContactMethod = Telegram;
                delivery.customer.tg = {
                    username: formData.backupContactValue,
                }
            case WhatsApp:
                delivery.customerBackupContactMethod = WhatsApp;
                delivery.customer.whatsApp = formData.backupContactValue;
            case Signal:
                delivery.customerBackupContactMethod = Signal;
                delivery.customer.signal = formData.backupContactValue;
            case Telephone:
                delivery.customerBackupContactMethod = Telephone;
                delivery.customer.tel = formData.backupContactValue;
        }

        return delivery;
    }
}