package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
using hkssprangers.MathTools;
using Lambda;

enum abstract KCZenzeroItem(String) to String {
    final LimitedSpecial;
    final HotdogSet;
    final NoodleSet;
    final PastaSet;
    final WontonSet;
    final LightSet;
    final HotpotSet;
    final Single;

    static public final all:ReadOnlyArray<KCZenzeroItem> = [
        LimitedSpecial,
        HotdogSet,
        NoodleSet,
        PastaSet,
        WontonSet,
        LightSet,
        // HotpotSet, //not in /menu/KCZenzero
        Single,
    ];

    public function getDefinition(timeSlotType:TimeSlotType):Dynamic return switch (cast this:KCZenzeroItem) {
        case LimitedSpecial: KCZenzeroMenu.KCZenzeroLimitedSpecial;
        case HotdogSet: KCZenzeroMenu.KCZenzeroHotdogSet(timeSlotType);
        case NoodleSet: KCZenzeroMenu.KCZenzeroNoodleSet(timeSlotType);
        case PastaSet: KCZenzeroMenu.KCZenzeroPastaSet(timeSlotType);
        case WontonSet: KCZenzeroMenu.KCZenzeroWontonSet;
        case LightSet: KCZenzeroMenu.KCZenzeroLightSet;
        case HotpotSet: KCZenzeroMenu.KCZenzeroHotpotSet;
        case Single: KCZenzeroMenu.KCZenzeroSingle;
    }
}

class KCZenzeroMenu {
    static public final box = "外賣盒 $2";
    static public function KCZenzeroSetDrink(price:Float, freeCans:Bool) return {
        title: "飲品",
        type: "string",
        "enum": (
            freeCans ? [
                "可口可樂" + (price > 0 ? ' +$$0' : ""),
                "可口可樂 Zero" + (price > 0 ? ' +$$0' : ""),
            ] : []
        ).concat([ 
            "自家沖洛神花冷泡茶" + (price > 0 ? ' +$$$price' : ""),
            "自家沖玫瑰烏龍冷泡茶" + (price > 0 ? ' +$$$price' : ""),
            "自家沖桂花烏龍冷泡茶" + (price > 0 ? ' +$$$price' : ""),
            "自家沖玄米冷泡茶" + (price > 0 ? ' +$$$price' : ""),
            "自家沖玄米綠茶" + (price > 0 ? ' +$$$price' : ""),
            // "自家沖水蜜桃烏龍茶" + (price > 0 ? ' +$$$price' : ""),
        ]),
    };

    static public final KCZenzeroSetOptions = {
        type: "array",
        title: "跟餐加配",
        items: {
            type: "string",
            "enum": [
                "香煎菠蘿包 $15",
            ],
        },
        uniqueItems: true,
    };

    static public final KCZenzeroSingle = {
        title: "小食",
        type: "string",
        "enum": [
            // "香煎菠蘿包 $20",
            "邪惡西蘭花 $28",
            "辣茄醬蝦多士 $30",
            "水牛城雞翼 $30",
            "椒鹽雞翼尖 $25",
            "芝士肉醬燒大菇(辣) $25",
            "芝士肉醬燒大菇(唔辣) $25",
            "芝士茄父子(素) $25",
            "芝士波隆納肉醬薯條 $25",
            // "癲雞芝麻球 $25",
            "流心奶黄牛角包 $10",
            "紫薯撻 $12",
            "芝士撻 $12",
            "葡撻 $8",
        ],
    };

    static public function KCZenzeroHotdogSet(timeSlotType:TimeSlotType) return {
        title: "熱狗",
        description: "$38",
        properties: {
            main: {
                title: "熱狗",
                type: "string",
                "enum": [
                    "波隆納肉醬熱狗",
                    "芝士蛋松露熱狗",
                    // "薯格趣趣熱狗",
                    "芥末沙律三文魚熱狗",
                    "九龍皇帝熱狗",
                    "妙菇皇后熱狗",
                    // "雙魚巨蟹熱狗",
                    // "意式肉丸熱狗",
                ]
            },
            drink: KCZenzeroSetDrink(5, false),
            // extraOptions: KCZenzeroSetOptions,
        },
        required: ["main"],
    }

    static final limitedSpecial = "香辣螺";
    static final limitedSpecialSeperateBox = false;
    static public final KCZenzeroLimitedSpecial = {
        title: "限定：" + limitedSpecial,
        description: "⚠️ 請提早落單。售完即止。",
        properties: {
            special: {
                title: "限定",
                type: "string",
                "enum": [
                    "香辣螺意粉 $55",
                    "香辣螺螺絲粉 $55",
                    "香辣螺烏冬 $55",
                ],
                // "default": limitedSpecial
            }
        },
        required: ["special"],
    }

    static public function KCZenzeroNoodleSet(timeSlotType:TimeSlotType) return {
        title: "意式濃厚蕃茄湯車仔粉",
        description: "蕃茄湯底車仔粉任選兩款主食 $48",
        properties: {
            options: {
                type: "array",
                title: "主食",
                description: "任選兩款，之後每款額外加 $5",
                items: {
                    type: "string",
                    "enum": [
                        "牛舌片",
                        "雞扒",
                        "煙鴨胸",
                        "蟹棒",
                        "司華力腸",
                        // "意式肉丸",
                    ],
                },
                uniqueItems: true,
                minItems: 2,
            },
            noodle: {
                type: "string",
                title: "麵類",
                "enum": [
                    "意粉",
                    "螺絲粉",
                ],
            },
            drink: KCZenzeroSetDrink(5, false),
            // extraOptions: KCZenzeroSetOptions,
        },
        required: ["options", "noodle"],
    };

    static public function KCZenzeroPastaSet(timeSlotType:TimeSlotType) return {
        title: "意粉",
        description: "任選醬汁／主食 $55",
        properties: {
            main: {
                type: "string",
                title: "主食",
                "enum": [
                    "芝士流心漢堡",
                    "炸芝士海鮮條",
                    "香草雞扒",
                    "牛舌片",
                ],
            },
            sauce: {
                type: "string",
                title: "醬汁",
                "enum": [
                    "肉醬(豬)",
                    "鮮茄蘑菇",
                    "意式卡邦尼",
                ],
            },
            noodle: {
                type: "string",
                title: "麵類",
                "enum": [
                    "意粉",
                    "螺絲粉",
                ],
            },
            drink: KCZenzeroSetDrink(5, false),
            // extraOptions: KCZenzeroSetOptions,
        },
        required: ["main", "sauce", "noodle"],
    };

    static public final KCZenzeroWontonSet = {
        title: "一口雲吞",
        properties: {
            main: {
                type: "string",
                title: "一口雲吞",
                "enum": [
                    "特濃茄湯一口雲吞(羊) $38",
                    "特濃茄湯一口雲吞(牛) $38",
                ],
            },
            options: {
                type: "array",
                title: "選項",
                items: {
                    type: "string",
                    "enum": [
                        "加芝士 +$3",
                    ],
                },
                uniqueItems: true,
            },
            sub: {
                type: "string",
                title: "小食",
                "enum": [
                    "炸雞翼",
                    "薯條",
                    // "意式肉丸",
                ],
            },
            drink: KCZenzeroSetDrink(5, true),
            // extraOptions: KCZenzeroSetOptions,
        },
        required: ["main", "sub"],
    };

    static public final KCZenzeroLightSet = {
        title: "輕量餐",
        description: "主食 + 沙律 + 飲品 $40",
        properties: {
            main: {
                type: "string",
                title: "主食",
                "enum": [
                    "迷你肉醬烏冬",
                    "迷你熱狗",
                ],
            },
            salad: {
                type: "string",
                title: "沙律",
                "enum": [
                    "蟹柳吞拿魚沙律",
                    "雞串吞拿魚沙律",
                ],
            },
            drink: KCZenzeroSetDrink(0, true),
            // extraOptions: KCZenzeroSetOptions,
        },
        required: [
            "main",
            "salad",
            "drink",
        ]
    };

    static public final KCZenzeroHotpotSet = {
        title: "一人癲雞煲",
        description: "有半隻春雞，跟發熱包 $68。 ⚠️ 請提前一日預訂。",
        properties: {
            soup: {
                type: "string",
                title: "湯底",
                "enum": [
                    "蕃茄湯底",
                    "癲雞辣湯底",
                ],
            },
            options: {
                type: "array",
                title: "配料",
                items: {
                    type: "string",
                    "enum": [
                        "響鈴、娃娃菜、烏冬 +$15",
                    ],
                },
                uniqueItems: true,
            },
        },
        required: [
            "soup",
        ]
    };
    
    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        var timeSlotType = pickupTimeSlot != null ? TimeSlotType.classify(pickupTimeSlot.start) : null;
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: KCZenzeroItem.all.map(item -> {
                        title: item.getDefinition(timeSlotType).title,
                        const: item,
                    }),
                },
            },
            required: [
                "type",
            ],
        };
        return {
            type: "array",
            items: order.items == null || order.items.length == 0 ? itemSchema() : order.items.map(item -> {
                var itemSchema:Dynamic = itemSchema();
                switch (cast item.type:KCZenzeroItem) {
                    case null:
                        //pass
                    case itemType:
                        Object.assign(itemSchema.properties, {
                            item: itemType.getDefinition(timeSlotType),
                        });
                        itemSchema.required.push("item");
                }
                itemSchema;
            }),
            additionalItems: itemSchema(),
            minItems: 1,
        };
    }

    static function summarizeItem(orderItem:{
        ?type:KCZenzeroItem,
        ?item:Dynamic,
    }, timeSlotType:TimeSlotType):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def:Dynamic = orderItem.type.getDefinition(timeSlotType);
        return switch (orderItem.type) {
            case LimitedSpecial:
                var orderDetails = [fullWidthDot + "限定：" + orderItem.item.special];
                if (limitedSpecialSeperateBox) {
                    orderDetails.push(fullWidthSpace + box);
                }
                var orderPrice = orderDetails.map(line -> parsePrice(line).price).sum();
                {
                    orderDetails: orderDetails.join("\n"),
                    orderPrice: orderPrice,
                };
            case HotdogSet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink", "extraOptions"], null, priceInDescription("main", def));
            case NoodleSet:
                summarizeOrderObject(orderItem.item, def, ["options", "noodle", "drink", "extraOptions"], null, (fieldName, value) -> switch fieldName {
                    case "options":
                        var price = switch (value != null ? value.length : 0) {
                            case 0, 1, 2:
                                (def.description:String).parsePrice().price;
                            case n:
                                (def.description:String).parsePrice().price + (n - 2) * (def.properties.options.description:String).parsePrice().price;
                        };
                        {
                            price: price,
                        }
                    case _: 
                        {
                            price: null,
                        };
                });
            case PastaSet:
                summarizeOrderObject(orderItem.item, def, ["main", "sauce", "noodle", "drink", "extraOptions"], null, priceInDescription("main", def));
            case WontonSet:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "sub", "drink", "extraOptions"]);
            case LightSet:
                summarizeOrderObject(orderItem.item, def, ["main", "salad", "drink", "extraOptions"], null, priceInDescription("main", def));
            case HotpotSet:
                summarizeOrderObject(orderItem.item, def, ["soup", "options"], [box], priceInDescription("soup", def));
            case Single:
                switch (orderItem.item:Null<String>) {
                    case v if (Std.isOfType(v, String)):
                        {
                            orderDetails: fullWidthDot + v,
                            orderPrice: v.parsePrice().price,
                        };
                    case _:
                        {
                            orderDetails: "",
                            orderPrice: 0.0,
                        };
                }
            case _:
                {
                    orderDetails: "",
                    orderPrice: 0.0,
                };
        }
    }

    static public function summarize(formData:FormOrderData, timeSlotType:TimeSlotType):OrderSummary {
        var summaries = formData.items.map(item -> summarizeItem(cast item, timeSlotType));
        // don't charge for boxes if there are only hotpots, which charges for their own boxes already
        if (formData.items.exists(item -> switch (cast item.type:KCZenzeroItem) {
            case HotpotSet:
                false;
            case LimitedSpecial if (limitedSpecialSeperateBox):
                false;
            case _:
                true;
        })) {
            summaries.push({
                orderDetails: box,
                orderPrice: box.parsePrice().price,
            });
        }
        var s = concatSummaries(summaries);
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}