package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
using hkssprangers.MathTools;
using Lambda;

enum abstract KCZenzeroItem(String) to String {
    final LimitedSpecial;
    final HotdogSet;
    final NoodleSet;
    final PastaSet;
    final R6Set;
    final WontonSet;
    final LightSet;
    final HotpotSet;
    final GoldenLeg;
    final TomatoRice;
    final Single;

    static public function all(timeSlot:TimeSlot):ReadOnlyArray<KCZenzeroItem> {
        return (switch (KCZenzeroMenu.KCZenzeroLimitedSpecial(timeSlot.start, TimeSlotType.classify(timeSlot.start))) {
            case null: [];
            case _: [LimitedSpecial];
        }).concat(
            [
                HotdogSet,
                NoodleSet,
                PastaSet,
                R6Set,
                WontonSet,
                LightSet,
                GoldenLeg,
                TomatoRice,
                Single,
            ]
        );
    }

    public function getDefinition(timeSlot:TimeSlot):Dynamic return switch (cast this:KCZenzeroItem) {
        case LimitedSpecial: KCZenzeroMenu.KCZenzeroLimitedSpecial(timeSlot.start, TimeSlotType.classify(timeSlot.start));
        case HotdogSet: KCZenzeroMenu.KCZenzeroHotdogSet(TimeSlotType.classify(timeSlot.start));
        case NoodleSet: KCZenzeroMenu.KCZenzeroNoodleSet(TimeSlotType.classify(timeSlot.start));
        case PastaSet: KCZenzeroMenu.KCZenzeroPastaSet(TimeSlotType.classify(timeSlot.start));
        case R6Set: KCZenzeroMenu.KCZenzeroR6Set;
        case WontonSet: KCZenzeroMenu.KCZenzeroWontonSet;
        case LightSet: KCZenzeroMenu.KCZenzeroLightSet;
        case GoldenLeg: KCZenzeroMenu.KCZenzeroGoldenLeg;
        case TomatoRice: KCZenzeroMenu.KCZenzeroTomatoRice;
        case HotpotSet: KCZenzeroMenu.KCZenzeroHotpotSet;
        case Single: KCZenzeroMenu.KCZenzeroSingle;
    }
}

class KCZenzeroMenu {
    static public final box = "外賣盒 $2";
    static public function KCZenzeroSetDrink(price:Float) return {
        title: "飲品",
        type: "string",
        "enum": [
            "可口可樂" + (price > 0 ? ' +$$0' : ""),
            "維他氣泡桃橙茶" + (price > 0 ? ' +$$0' : ""),
            "維他氣泡檸檬茶" + (price > 0 ? ' +$$0' : ""),
            // "自家沖洛神花冷泡茶" + (price > 0 ? ' +$$$price' : ""),
            // "自家沖玫瑰烏龍冷泡茶" + (price > 0 ? ' +$$$price' : ""),
            // "自家沖桂花烏龍冷泡茶" + (price > 0 ? ' +$$$price' : ""),
            // "自家沖玄米冷泡茶" + (price > 0 ? ' +$$$price' : ""),
            // "自家沖玄米綠茶" + (price > 0 ? ' +$$$price' : ""),
            // "自家沖水蜜桃烏龍茶" + (price > 0 ? ' +$$$price' : ""),
        ],
    };
    static public final KCZenzeroFreePaperBoxDrink = {
        title: "飲品",
        type: "string",
        "enum": [
            // "檸檬茶紙包飲品 +$0",
            // "菊花茶紙包飲品 +$0",
            "可口可樂 +$0",
            "維他氣泡桃橙茶 +$0",
            "維他氣泡檸檬茶 +$0",
            // "自家沖洛神花冷泡茶 +$5",
            // "自家沖玫瑰烏龍冷泡茶 +$5",
            // "自家沖桂花烏龍冷泡茶 +$5",
            // "自家沖玄米冷泡茶 +$5",
            // "自家沖玄米綠茶 +$5",
            // "自家沖水蜜桃烏龍茶 +$5",
        ],
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
            // "蔥油刀切麵 $25",
            "邪惡西蘭花 $28",
            "辣茄醬蝦多士 $30",
            "水牛城雞翼 $30",
            "椒鹽雞翼尖 $25",
            // "芝士肉醬燒大菇(辣) $25",
            // "芝士肉醬燒大菇(唔辣) $25",
            "芝士茄父子(素) $25",
            // "芝士波隆納肉醬薯條 $25",
            // "芝士波隆納肉醬薯格 $25",
            // "癲雞芝麻球 $25",
            // "流心奶黄牛角包 $10",
            // "紫薯撻 $14",
            // "芝士撻 $12",
            // "葡撻 $8",
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
                    "日式咖喱牛肉熱狗",
                ]
            },
            drink: KCZenzeroSetDrink(5),
            // extraOptions: KCZenzeroSetOptions,
        },
        required: ["main"],
    }

    static public final KCZenzeroGoldenLeg = {
        title: "金沙美腿",
        properties: {
            main: {
                title: "金沙美腿",
                type: "string",
                "enum": [
                    "金沙美腿 $35",
                ],
                "default": "金沙美腿 $35",
            },
            options: {
                type: "array",
                title: "選項",
                items: {
                    type: "string",
                    "enum": [
                        "葱油冷麵 +$8",
                    ],
                },
                uniqueItems: true,
            },
            drink: KCZenzeroFreePaperBoxDrink,
        },
        required: ["main"],
    }

    static public final KCZenzeroTomatoRice = {
        title: "濃茄脆米",
        properties: {
            main: {
                title: "濃茄脆米",
                type: "string",
                "enum": [
                    "濃茄脆米 $40",
                ],
                "default": "濃茄脆米 $40",
            },
            options: {
                type: "array",
                title: "主食",
                description: "任選兩款",
                items: {
                    type: "string",
                    "enum": [
                        "牛舌片",
                        "雞扒",
                        "煙鴨胸",
                        "蟹棒",
                        "司華力腸",
                    ],
                },
                uniqueItems: true,
                minItems: 2,
                maxItems: 2,
            },
            drink: KCZenzeroFreePaperBoxDrink,
        },
        required: ["main", "options"],
    }

    static public final KCZenzeroR6Set = {
        title: "R6(歐陸)套餐",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "雞扒 $38",
                    "松露餐肉 $38",
                ],
            },
            options: {
                type: "array",
                title: "選項",
                items: {
                    type: "string",
                    "enum": [
                        "迷你蕃茄湯粉 +$8",
                    ],
                },
                uniqueItems: true,
            },
            drink: KCZenzeroFreePaperBoxDrink,
        },
        required: ["main"],
    }

    static public final limitedSpecial = {
        final limitedSpecial = "鮑你蝦蝦笑炒飯/咖喱豬皮魚蛋";
        {
            date: "2022-07-29",
            timeSlotTypes: [Dinner],
            seperateBox: false,
            available: true,
            def: {
                title: "限定：" + limitedSpecial,
                description: "⚠️ 請提早落單。售完即止。",
                properties: {
                    special: {
                        title: "限定",
                        type: "string",
                        "enum": [
                            "鮑你蝦蝦笑炒飯 $60",
                            "咖喱豬皮魚蛋+蘿蔔 $25",
                        ],
                        // "default": limitedSpecial
                    }
                },
                required: ["special"],
            }
        };
    };

    static public function KCZenzeroLimitedSpecial(date:LocalDateString, timeSlotType:TimeSlotType)
        return if (limitedSpecial.date == date.getDatePart() && limitedSpecial.timeSlotTypes.has(timeSlotType) && limitedSpecial.available)
            limitedSpecial.def;
        else
            null;

    static public function KCZenzeroNoodleSet(timeSlotType:TimeSlotType) return {
        title: "意式濃厚蕃茄湯車仔粉",
        description: "蕃茄湯底車仔粉任選兩款主食 $48",
        properties: {
            options: {
                type: "array",
                title: "主食",
                description: "任選兩款，之後每款額外加 $8",
                items: {
                    type: "string",
                    "enum": [
                        "牛舌片",
                        "雞扒",
                        "煙鴨胸",
                        "蟹棒",
                        "司華力腸",
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
            drink: KCZenzeroSetDrink(5),
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
                    // "炸芝士海鮮條",
                    // "蝦條",
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
            drink: KCZenzeroSetDrink(5),
            // extraOptions: KCZenzeroSetOptions,
        },
        required: ["main", "sauce", "noodle"],
    };

    static public final KCZenzeroWontonSet = {
        title: "小雲呑",
        properties: {
            main: {
                type: "string",
                title: "小雲呑",
                "enum": [
                    "台灣小雲呑 $45",
                ],
                "default": "台灣小雲呑 $45",
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
                    // "薯格",
                    // "薯條",
                ],
            },
            drink: KCZenzeroSetDrink(5),
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
                    "煙三文魚沙律",
                ],
            },
            drink: KCZenzeroSetDrink(0),
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
                    oneOf: KCZenzeroItem.all(pickupTimeSlot).map(item -> {
                        title: item.getDefinition(pickupTimeSlot).title,
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
                            item: itemType.getDefinition(pickupTimeSlot),
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
    }, timeSlot:TimeSlot):{
        orderDetails:String,
        orderPrice:Float,
    } {
        final def:Dynamic = orderItem.type.getDefinition(timeSlot);
        return switch (orderItem.type) {
            case LimitedSpecial:
                final orderDetails = [fullWidthDot + "限定：" + orderItem.item.special];
                if (limitedSpecial.seperateBox) {
                    orderDetails.push(fullWidthSpace + box);
                }
                final orderPrice = orderDetails.map(line -> parsePrice(line).price).sum();
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
            case GoldenLeg:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "drink"], null, null, "");
            case R6Set:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "drink"]);
            case TomatoRice:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "drink"]);
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

    static public function summarize(formData:FormOrderData, timeSlot:TimeSlot):OrderSummary {
        final summaries = formData.items.map(item -> summarizeItem(cast item, timeSlot));
        // don't charge for boxes if there are only hotpots, which charges for their own boxes already
        if (formData.items.exists(item -> switch (cast item.type:KCZenzeroItem) {
            case HotpotSet:
                false;
            case LimitedSpecial if (limitedSpecial.seperateBox):
                false;
            case _:
                true;
        })) {
            summaries.push({
                orderDetails: box,
                orderPrice: box.parsePrice().price,
            });
        }
        final s = concatSummaries(summaries);
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}