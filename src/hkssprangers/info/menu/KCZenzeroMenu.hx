package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
using hkssprangers.MathTools;
using Lambda;

enum abstract KCZenzeroItem(String) to String {
    final LimitedSpecial;
    final HotDouble;
    final IceFireSet;
    final HoiSinPot;
    final HotdogSet;
    final NoodleSet;
    final PastaSet;
    final LambPasta;
    final R6Set;
    final CuredMeatRice;
    final LightSet;
    final HotpotSet;
    final GoldenLeg;
    final TomatoRice;
    final Squab;
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
                case "2023-10-27": false;
                case _: true;
            }
        ) {
            [HotpotSet];
        } else {
            [];
        }
        final hoiSinPot = if (
            timeSlot != null
            &&
            timeSlot.start.getDatePart() >= now.deltaDays(3).getDatePart()
        ) {
            [HoiSinPot];
        } else {
            [];
        }
        return []
            .concat(limited)
            // .concat(hoiSinPot)
            .concat([
                IceFireSet,
                HotDouble,
                Squab,
                // CuredMeatRice,
                HotdogSet,
                MincedPork,
                YiMein,
                // TomatoSoupRice,
                Rice,
                NoodleSet,
                // PastaSet,
                // LambPasta,
                // R6Set,
                // LightSet,
                GoldenLeg,
                // TomatoRice,
                Single,
            ]);
    }

    public function getDefinition(timeSlot:TimeSlot):Dynamic return switch (cast this:KCZenzeroItem) {
        case LimitedSpecial: KCZenzeroMenu.KCZenzeroLimitedSpecial(timeSlot.start, TimeSlotType.classify(timeSlot.start));
        case IceFireSet: KCZenzeroMenu.KCZenzeroIceFireSet;
        case HotDouble: KCZenzeroMenu.KCZenzeroHotDouble;
        case Squab: KCZenzeroMenu.KCZenzeroSquab;
        case YiMein: KCZenzeroMenu.KCZenzeroYiMein;
        case TomatoSoupRice: KCZenzeroMenu.KCZenzeroTomatoSoupRice;
        case HoiSinPot: KCZenzeroMenu.KCZenzeroHoiSinPot;
        case HotdogSet: KCZenzeroMenu.KCZenzeroHotdogSet;
        case NoodleSet: KCZenzeroMenu.KCZenzeroNoodleSet;
        case PastaSet: KCZenzeroMenu.KCZenzeroPastaSet(TimeSlotType.classify(timeSlot.start));
        case LambPasta: KCZenzeroMenu.KCZenzeroLambPasta;
        case R6Set: KCZenzeroMenu.KCZenzeroR6Set;
        case CuredMeatRice: KCZenzeroMenu.KCZenzeroCuredMeatRice;
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
    static public function box(price:Int = 2) {
        return "外賣盒 $" + price;
    }
    static public final KCZenzeroFreeDrink = {
        title: "送飲品",
        type: "string",
        "enum": [
            "唔要",
            "湯",
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
            // "芝士波隆納肉醬薯格 $25",
            "松露薯格 $25",
            // "芝士波隆納肉醬ABC字母薯餅 $25",
            // "癲雞芝麻球 $25",
            // "流心奶黄牛角包 $10",
            "紫薯撻 $14",
            // "芝士撻 $12",
            // "葡撻 $8",
            // "咖喱豬皮陳皮魚蛋鵝紅 $30",
            // "蒜蓉包 $28",
            "涼拌蠔仔 $30",
            "涼拌拼盤 (皮蛋 蠔仔 花膠) $48",
            "涼拌魚皮拼大蝦 $40",
            "涼拌萵筍 $28",
            "涼拌串串貢 $35",
        ],
    };

    static public final KCZenzeroHoiSinPot = {
        title: "海鮮盤",
        description: "材料有：海蝦，鮑魚，花膠，帶子，蜆，生蠔，香煎雞件 ⚠️ 需三日前預訂",
        properties: {
            main: {
                title: "海鮮盤",
                type: "string",
                "enum": [
                    "1-2人 $" + (128 + 10),
                    "3-5人 $" + (580 + 10),
                    "6-8人 $" + (1480 + 10),
                ]
            },
            style: {
                type: "string",
                title: "口味",
                "enum": [
                    "鮑汁",
                    "癲雞辣汁",
                ],
            },
        },
        required: ["main", "style"],
    }

    static final hotDouble = "避風塘鮑魚，香辣蝦，蒜蓉炒菜芯，滷肉飯 $158";
    static public final KCZenzeroHotDouble = {
        title: "惹火二人套餐",
        properties: {
            main: {
                title: "惹火二人套餐",
                type: "string",
                "enum": [
                    hotDouble,
                ],
                "default": hotDouble,
            },
            drink: {
                title: "送飲品",
                type: "string",
                "enum": [
                    "唔要",
                    // "隨機紙包飲品2包",
                    "湯",
                ],
            },
            extraOptions: {
                type: "array",
                title: "加配",
                items: {
                    type: "string",
                    "enum": [
                        "羊架一件 +$18",
                    ],
                },
                uniqueItems: true,
            },
        },
        required: ["main", "drink"],
    }

    static public final KCZenzeroIceFireSet = {
        title: "冰火二人餐",
        properties: {
            main: {
                title: "冰火二人餐",
                type: "string",
                "enum": [
                    "香辣煎蝦雞煲 $148",
                    "沙薑煎蝦雞煲 (唔辣) $148",
                ],
            },
            side: {
                title: "配菜",
                type: "string",
                "enum": [
                    "涼拌串串貢 + 涼拌萵荀",
                ],
                "default": "涼拌串串貢 + 涼拌萵荀",
            },
            rice: {
                title: "飯",
                type: "string",
                "enum": [
                    "2碗白飯",
                ],
                "default": "2碗白飯",
            },
            drink: {
                title: "飲品",
                type: "string",
                "enum": [
                    "唔要",
                    "2碗蕃茄湯",
                ],
                "default": "2碗蕃茄湯",
            },
        },
        required: ["main", "side", "rice", "drink"],
    }

    static public final KCZenzeroHotdogSet = {
        title: "熱狗",
        description: "$38",
        properties: {
            main: {
                title: "熱狗",
                type: "string",
                "enum": [
                    // "波隆納肉醬熱狗",
                    "芝士蛋松露熱狗",
                    "薯格趣趣熱狗",
                    // "ABC字母薯餅熱狗",
                    "芥末沙律三文魚熱狗",
                    "九龍皇帝熱狗",
                    // "妙菇皇后熱狗",
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
                        "蒜油烏冬 +$8",
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

    static public final KCZenzeroSquab = {
        title: "乳鴿",
        properties: {
            main: {
                title: "乳鴿",
                type: "string",
                "enum": [
                    "糯米釀乳鴿配柚子汁 $68",
                ],
                "default": "糯米釀乳鴿配柚子汁 $68",
            },
            drink: KCZenzeroFreeDrink,
        },
        required: ["main", "drink"],
    }

    static public final KCZenzeroMincedPork = {
        title: "滷肉系列",
        properties: {
            main: {
                title: "滷肉系列",
                type: "string",
                "enum": [
                    "蠔仔滷肉飯 $68",
                    "帶子蟹籽滷肉飯 $68",
                    "雙獅子頭滷肉飯 $50",
                    "火炙牛肉滷肉飯 $55",
                    "火炙牛舌滷肉飯 $55",
                    "麻辣雞翼滷肉飯 $50",
                    "香草羊架滷肉飯 $58",
                    "蒜片鮑魚滷肉飯 $68",
                    "鹽燒青魚滷肉飯 $55",
                    "七味巨蟹滷肉飯 $55",
                    "炸蠔蛋滷肉飯 $48",
                    "哇哈哈滷肉飯 $50",
                    "勁爆芝士帶子滷肉飯 $48",
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
            "香煎蝦配黑松露炒飯 送隨機純茶/紙包茶 $68",
        ];
        {
            dateStart: "2023-05-31",
            dateEnd: "2023-05-31",
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

    static public final KCZenzeroNoodleSet = {
        title: "雲吞烏冬",
        properties: {
            main: {
                title: "雲吞",
                type: "string",
                "enum": [
                    "牛肉雲吞 $38",
                    "羊肉雲吞 $38",
                ]
            },
            noodle: {
                type: "string",
                title: "麵類",
                "enum": [
                    "烏冬",
                ],
                "default": "烏冬",
            },
            // drink: KCZenzeroFreeDrink
            // extraOptions: KCZenzeroSetOptions,
        },
        required: ["main", "noodle"],
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

    static public final KCZenzeroCuredMeatRice = {
        title: "臘味飯",
        properties: {
            main: {
                type: "string",
                title: "臘味飯",
                "enum": [
                    "臘味蒜香糯米飯配菜心 $78",
                ],
                "default": "臘味蒜香糯米飯配菜心 $78",
            },
            drink: KCZenzeroFreeDrink,
            // extraOptions: KCZenzeroSetOptions,
        },
        required: ["main", "drink"],
    };

    static public final KCZenzeroLightSet = {
        title: "輕量餐",
        description: "主食 + 沙律 + 飲品 $40",
        properties: {
            main: {
                type: "string",
                title: "主食",
                "enum": [
                    "滷肉烏冬",
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
        title: "雞煲",
        description: "⚠️ 請提早落單。售完即止。",
        properties: {
            main: {
                type: "string",
                title: "雞煲",
                "enum": [
                    "花膠胡椒豬肚雞煲配沙薑豉油 $108",
                ],
                "default": "花膠胡椒豬肚雞煲配沙薑豉油 $108",
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
            case HoiSinPot:
                summarizeOrderObject(orderItem.item, def, ["main", "style"], [box()]);
            case HotdogSet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink", "extraOptions"], null, priceInDescription("main", def));
            case NoodleSet:
                summarizeOrderObject(orderItem.item, def, ["main", "noodle"]);
            case PastaSet:
                summarizeOrderObject(orderItem.item, def, ["main", "sauce", "noodle", "drink", "extraOptions"], null, priceInDescription("main", def));
            case LambPasta:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], null, null, "");
            case CuredMeatRice:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], [box()]);
            case LightSet:
                summarizeOrderObject(orderItem.item, def, ["main", "salad", "drink", "extraOptions"], null, priceInDescription("main", def));
            case GoldenLeg:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "drink"], null, null, "");
            case R6Set:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "drink"]);
            case TomatoRice:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "drink"]);
            case Squab:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], null, null, "");
            case MincedPork:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "drink"]);
            case YiMein:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], null, null, "");
            case Rice:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], null, null, "");
            case TomatoSoupRice:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], null, null, "");
            case HotpotSet:
                summarizeOrderObject(orderItem.item, def, ["main"], [box()]);
            case HotDouble:
                summarizeOrderObject(orderItem.item, def, ["main", "drink", "extraOptions"], [box(5)]);
            case IceFireSet:
                summarizeOrderObject(orderItem.item, def, KCZenzeroIceFireSet.required, [box(5)]);
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
            case HoiSinPot:
                false;
            case HotDouble:
                false;
            case IceFireSet:
                false;
            case HotpotSet:
                false;
            case CuredMeatRice:
                false;
            case LimitedSpecial if (limitedSpecial.seperateBox):
                false;
            case _:
                true;
        })) {
            summaries.push({
                orderDetails: box(),
                orderPrice: box().parsePrice().price,
            });
        }
        final s = concatSummaries(summaries);
        // if (s.orderPrice >= 100) {
        //     s.orderDetails += "\n滿100蚊減10蚊 -$10";
        //     s.orderPrice -= 10;
        // }
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}