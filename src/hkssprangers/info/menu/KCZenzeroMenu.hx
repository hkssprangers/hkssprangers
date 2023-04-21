package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
using hkssprangers.MathTools;
using Lambda;

enum abstract KCZenzeroItem(String) to String {
    final LimitedSpecial;
    final PoonChoiLoHei;
    final HotdogSet;
    final NoodleSet;
    final PastaSet;
    final LambPasta;
    final R6Set;
    final WontonSet;
    final LightSet;
    final HotpotSet;
    final GoldenLeg;
    final TomatoRice;
    final MincedPork;
    final YiMein;
    final TomatoSoupRice;
    final Rice;
    final Single;

    static public function all(timeSlot:TimeSlot):ReadOnlyArray<KCZenzeroItem> {
        final now:LocalDateString = Date.now();
        final limited = switch (KCZenzeroMenu.KCZenzeroLimitedSpecial(timeSlot.start, TimeSlotType.classify(timeSlot.start))) {
            case null: [];
            case _: [LimitedSpecial];
        }
        final hotpot = if (
            timeSlot != null
            &&
            TimeSlotType.classify(timeSlot.start) == Dinner
            &&
            switch timeSlot.start.getDatePart() {
                case "2022-11-04": false;
                case _: true;
            }
        ) {
            [HotpotSet];
        } else {
            [];
        }
        final poonChoiLoHei = if (
            timeSlot != null
            &&
            timeSlot.start.getDatePart() >= now.deltaDays(2).getDatePart()
        ) {
            [PoonChoiLoHei];
        } else {
            [];
        }
        return []
            .concat(limited)
            // .concat(hotpot)
            .concat([
                HotdogSet,
                MincedPork,
                YiMein,
                TomatoSoupRice,
                Rice,
                NoodleSet,
                // PastaSet,
                // LambPasta,
                R6Set,
                WontonSet,
                LightSet,
                GoldenLeg,
                // TomatoRice,
                Single,
            ]);
    }

    public function getDefinition(timeSlot:TimeSlot):Dynamic return switch (cast this:KCZenzeroItem) {
        case LimitedSpecial: KCZenzeroMenu.KCZenzeroLimitedSpecial(timeSlot.start, TimeSlotType.classify(timeSlot.start));
        case YiMein: KCZenzeroMenu.KCZenzeroYiMein;
        case TomatoSoupRice: KCZenzeroMenu.KCZenzeroTomatoSoupRice;
        case PoonChoiLoHei: KCZenzeroMenu.KCZenzeroPoonChoiLoHei;
        case HotdogSet: KCZenzeroMenu.KCZenzeroHotdogSet(TimeSlotType.classify(timeSlot.start));
        case NoodleSet: KCZenzeroMenu.KCZenzeroNoodleSet(TimeSlotType.classify(timeSlot.start));
        case PastaSet: KCZenzeroMenu.KCZenzeroPastaSet(TimeSlotType.classify(timeSlot.start));
        case LambPasta: KCZenzeroMenu.KCZenzeroLambPasta;
        case R6Set: KCZenzeroMenu.KCZenzeroR6Set;
        case WontonSet: KCZenzeroMenu.KCZenzeroWontonSet;
        case LightSet: KCZenzeroMenu.KCZenzeroLightSet;
        case GoldenLeg: KCZenzeroMenu.KCZenzeroGoldenLeg;
        case TomatoRice: KCZenzeroMenu.KCZenzeroTomatoRice;
        case MincedPork: KCZenzeroMenu.KCZenzeroMincedPork;
        case HotpotSet: KCZenzeroMenu.KCZenzeroHotpotSet;
        case Rice: KCZenzeroMenu.KCZenzeroRice;
        case Single: KCZenzeroMenu.KCZenzeroSingle;
    }
}

class KCZenzeroMenu {
    static public final box = "外賣盒 $2";
    static public final KCZenzeroFreeDrink = {
        title: "送飲品",
        type: "string",
        "enum": [
            "唔要",
            "隨機純茶/紙包茶",
        ],
    };
    static public final KCZenzeroAddDrink = {
        title: "加配飲品",
        type: "string",
        "enum": [
            "唔要",
            "隨機純茶/紙包茶 +$8",
        ],
        "default": "唔要",
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
            // "芝士茄父子(素) $25",
            // "芝士波隆納肉醬薯條 $25",
            "芝士波隆納肉醬薯格 $25",
            // "芝士波隆納肉醬ABC字母薯餅 $25",
            // "癲雞芝麻球 $25",
            // "流心奶黄牛角包 $10",
            "紫薯撻 $14",
            // "芝士撻 $12",
            // "葡撻 $8",
            // "咖喱豬皮陳皮魚蛋鵝紅 $30",
            "蒜蓉包 $28",
        ],
    };

    static function markupNewYearItem(item:String, price:Float):String {
        return item + " $" + Math.round(price / 0.85 + 2);
    }

    static public final KCZenzeroPoonChoiLoHei = {
        title: "盤菜/撈起",
        description: "⚠️ 需兩日前預訂",
        properties: {
            main: {
                title: "盤菜",
                desciption: "蝦，花膠，帶子，大蜆，鮑魚，雞",
                type: "string",
                "enum": [
                    markupNewYearItem("海鮮盤菜 1-3人", 388),
                    markupNewYearItem("海鮮盤菜 3-5人", 688),
                    markupNewYearItem("海鮮盤菜 5-8人", 1680),
                ]
            },
            extraOptions: {
                type: "array",
                title: "加配",
                items: {
                    type: "string",
                    "enum": [
                        markupNewYearItem("後生仔撈起", 268 - 10),
                    ],
                },
                uniqueItems: true,
            },
        },
        required: ["main"],
    }

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
                    "薯格趣趣熱狗",
                    // "ABC字母薯餅熱狗",
                    "芥末沙律三文魚熱狗",
                    "九龍皇帝熱狗",
                    "妙菇皇后熱狗",
                    // "雙魚巨蟹熱狗",
                    // "日式咖喱牛肉熱狗",
                ]
            },
            drink: KCZenzeroFreeDrink,
            // extraOptions: KCZenzeroSetOptions,
        },
        required: ["main", "drink"],
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
            drink: KCZenzeroFreeDrink,
        },
        required: ["main", "drink"],
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
                        // "牛舌片",
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
            drink: KCZenzeroFreeDrink,
        },
        required: ["main", "options", "drink"],
    }

    static public final KCZenzeroMincedPork = {
        title: "滷肉系列",
        properties: {
            main: {
                title: "滷肉系列",
                type: "string",
                "enum": [
                    "蠔仔滷肉飯 $68",
                    "白肉珍珠滷肉飯 $68",
                    "雙獅子頭滷肉飯 $50",
                    "火炙牛肉滷肉飯 $55",
                    "火炙牛舌滷肉飯 $55",
                    "麻辣雞翼滷肉飯 $50",
                    "香草羊架滷肉飯 $58",
                    "蒜片鮑魚滷肉飯 $68",
                    "鹽燒青魚滷肉飯 $55",
                    // "終極豐盛滷肉飯 $78",
                ],
            },
            options: {
                type: "array",
                title: "選項",
                items: {
                    type: "string",
                    "enum": [
                        "轉烏冬 +$10",
                        "多滷肉 +$10",
                    ],
                },
                uniqueItems: true,
            },
            drink: KCZenzeroFreeDrink,
        },
        required: ["main", "drink"],
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
                title: "加配",
                items: {
                    type: "string",
                    "enum": [
                        "飯 +$8",
                        "脆米 +$8",
                        "烏冬 +$10",
                    ],
                },
                uniqueItems: true,
            },
            drink: KCZenzeroFreeDrink,
        },
        required: ["main", "drink"],
    }

    static public final KCZenzeroYiMein = {
        title: "花膠蒜香炆伊麵",
        description: "⚠️ 請提早落單。每日數量有限，售完即止。",
        properties: {
            main: {
                title: "花膠蒜香炆伊麵",
                type: "string",
                "enum": [
                    "花膠蒜香炆伊麵 $45"
                ],
                "default": "花膠蒜香炆伊麵 $45"
            },
            drink: KCZenzeroFreeDrink,
        },
        required: ["main", "drink"],
    }

    static public final KCZenzeroRice = {
        title: "沙薑蒜泥白肉飯",
        properties: {
            main: {
                title: "沙薑蒜泥白肉飯",
                type: "string",
                "enum": [
                    "沙薑蒜泥白肉飯 $45"
                ],
                "default": "沙薑蒜泥白肉飯 $45"
            },
            drink: KCZenzeroFreeDrink,
        },
        required: ["main", "drink"],
    }

    static public final KCZenzeroTomatoSoupRice = {
        title: "雞樅菇雙丸濃茄湯飯",
        description: "⚠️ 請提早落單。每日數量有限，售完即止。",
        properties: {
            main: {
                title: "雞樅菇雙丸濃茄湯飯",
                type: "string",
                "enum": [
                    "雞樅菇雙丸濃茄湯飯 $50"
                ],
                "default": "雞樅菇雙丸濃茄湯飯 $50"
            },
            drink: KCZenzeroFreeDrink,
        },
        required: ["main", "drink"],
    }

    static public final limitedSpecial = {
        final limitedSpecials = [
            "七味巨蟹滷肉飯 送隨機純茶/紙包茶 $55",
        ];
        {
            dateStart: "2023-04-22",
            dateEnd: "2023-04-22",
            timeSlotTypes: [Lunch, Dinner],
            seperateBox: false,
            available: true,
            def: {
                title: limitedSpecials.length == 1 ? "限定：" + limitedSpecials[0] : "限定",
                description: "⚠️ 請提早落單。售完即止。",
                properties: {
                    special: {
                        title: "限定",
                        type: "string",
                        "enum": limitedSpecials,
                        "default": limitedSpecials.length == 1 ? limitedSpecials[0] : null,
                    }
                },
                required: ["special"],
            }
        };
    };

    static public function KCZenzeroLimitedSpecial(date:LocalDateString, timeSlotType:TimeSlotType)
        return if (
            date.getDatePart() >= limitedSpecial.dateStart
            &&
            date.getDatePart() <= limitedSpecial.dateEnd
            &&
            limitedSpecial.timeSlotTypes.has(timeSlotType)
            &&
            limitedSpecial.available
        )
            limitedSpecial.def;
        else
            null;

    static public function KCZenzeroNoodleSet(timeSlotType:TimeSlotType) return {
        title: "意式濃厚蕃茄湯車仔飯",
        description: "任選兩款主食 $48",
        properties: {
            options: {
                type: "array",
                title: "主食",
                description: "任選兩款，之後每款額外加 $8",
                items: {
                    type: "string",
                    "enum": [
                        // "牛舌片",
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
                title: "類別",
                "enum": [
                    "飯",
                    "脆米",
                    "烏冬 +$8",
                ],
            },
            drink: KCZenzeroFreeDrink
            // extraOptions: KCZenzeroSetOptions,
        },
        required: ["options", "noodle", "drink"],
    };

    static public function KCZenzeroPastaSet(timeSlotType:TimeSlotType) return {
        title: "西式飯",
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
                    // "牛舌片",
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
                title: "類別",
                "enum": [
                    "飯",
                    "脆米",
                    "烏冬 +$8",
                ],
            },
            drink: KCZenzeroFreeDrink,
            // extraOptions: KCZenzeroSetOptions,
        },
        required: ["main", "sauce", "noodle", "drink"],
    };
    
    static public final KCZenzeroLambPasta = {
        title: "香草羊架卡邦尼",
        properties: {
            main: {
                type: "string",
                title: "香草羊架卡邦尼",
                "enum": [
                    "香草羊架卡邦尼意粉 $68",
                    "香草羊架卡邦尼螺絲粉 $68",
                ],
            },
            drink: KCZenzeroFreeDrink,
        },
        required: ["main", "drink"],
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
                    "薯格",
                    // "ABC字母薯餅",
                    // "薯條",
                ],
            },
            drink: KCZenzeroFreeDrink,
            // extraOptions: KCZenzeroSetOptions,
        },
        required: ["main", "sub", "drink"],
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
            drink: KCZenzeroFreeDrink,
            // extraOptions: KCZenzeroSetOptions,
        },
        required: [
            "main",
            "salad",
            "drink",
        ]
    };

    static public final KCZenzeroHotpotSet = {
        title: "限定：串爆田雞臘米煲",
        description: "⚠️ 每日下午四點後供應。請提早落單。售完即止。",
        properties: {
            main: {
                type: "string",
                title: "口味",
                "enum": [
                    "辣 $98",
                    "唔辣 $98",
                ],
            },
        },
        required: [
            "main",
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
            case PoonChoiLoHei:
                summarizeOrderObject(orderItem.item, def, ["main", "extraOptions"], null, null, "");
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
            case LambPasta:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], null, null, "");
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
            case MincedPork:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "drink"]);
            case YiMein:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], null, null, "");
            case Rice:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], null, null, "");
            case TomatoSoupRice:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], null, null, "");
            case HotpotSet:
                summarizeOrderObject(orderItem.item, def, ["main"], [box]);
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
            case PoonChoiLoHei:
                false;
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