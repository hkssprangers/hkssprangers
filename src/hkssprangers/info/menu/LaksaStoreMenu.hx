package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
using hkssprangers.MathTools;

enum abstract LaksaStoreItem(String) to String {
    final NoodleSet;
    final RiceSet;
    final BakKutTeh;
    final Hotpot;

    static public final all:ReadOnlyArray<LaksaStoreItem> = [
        Hotpot,
        NoodleSet,
        // RiceSet,
        // BakKutTeh,
    ];

    public function getDefinition(pickupTimeSlot:Null<TimeSlot>):Dynamic return switch (cast this:LaksaStoreItem) {
        case Hotpot: LaksaStoreMenu.LaksaStoreHotpot(pickupTimeSlot);
        case NoodleSet: LaksaStoreMenu.LaksaStoreNoodleSet;
        case RiceSet: LaksaStoreMenu.LaksaStoreRiceSet;
        case BakKutTeh: LaksaStoreMenu.LaksaStoreBakKutTeh;
    }
}

class LaksaStoreMenu {
    static public final LaksaStoreSetDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "唔要飲品",
            "道地解茶紙包飲品",
            "道地檸檬紅茶紙包飲品",
            "道地蜂蜜綠茶紙包飲品",
            "支裝水",
            "罐裝可樂 +$2",
            "罐裝可樂 zero +$2",
            "罐裝雪碧 +$2",
            "罐裝忌廉 +$2",
        ],
    };

    static public function LaksaStoreHotpot(pickupTimeSlot:Null<TimeSlot>) {
        final now:LocalDateString = Date.now();
        final earlyOrder = pickupTimeSlot != null && now.getDatePart() < pickupTimeSlot.start.getDatePart();
        final hotpots = if (earlyOrder) {
            ["喇沙二人火鍋套餐 (提前一天預訂) $268"];
        } else {
            [];
        }
        final meatOptions = [
            "薄切牛肩肉150g",
            "美國肥牛200g",
            "黑豚肉150g",
            "腩片200g",
        ];
        return {
            title: "喇沙二人火鍋套餐 (提前一天預訂)",
            description: "需提前一天預訂 $268\n包括：喇沙湯底 牛/豚四選二 雞件 蜆 越南虎蝦四隻 銀芽 鮮什菌 娃娃菜 咸蛋流心丸 豆腐卜 甜不辣 米粉 油麵",
            properties: {
                main: {
                    title: "喇沙二人火鍋套餐",
                    type: "string",
                    "enum": hotpots,
                    "default": hotpots[0],
                },
                meat1: {
                    title: "肉（一）",
                    type: "string",
                    "enum": meatOptions,
                },
                meat2: {
                    title: "肉（二）",
                    type: "string",
                    "enum": meatOptions,
                }
            },
            required: ["main", "meat1", "meat2"],
        }
    }

    static public final LaksaStoreNoodleSet = {
        title: "喇沙",
        description: "套餐: 湯麵 + 飲品 $55",
        properties: {
            soup: {
                title: "湯底",
                type: "string",
                "enum": [
                    "喇沙",
                    // "冬蔭公",
                ],
                "default": "喇沙",
            },
            ingredient: {
                type: "string",
                title: "配料",
                description: "「新」四寶 = 霸王卷(魚), 甜不辣(魚), 蝦卷(雜菜,蝦), 哈哈笑丸(咸蛋流心丸)",
                "enum": [
                    "雞扒",
                    "豬扒",
                    "大蝦",
                    // "巨蝦 (10月5日限定) +$8",
                    "野菌肥牛",
                    "牛舌",
                    "「新」四寶",
                    // "椰菜炒腩片",
                ],
            },
            noodle: {
                type: "string",
                title: "麵類",
                "enum": [
                    "上海幼麵",
                    "米線",
                    "米粉",
                    "油麵",
                ],
            },
            drink: LaksaStoreSetDrink,
        },
        required: [
            "soup",
            "ingredient",
            "noodle",
            "drink",
        ]
    };

    static public final LaksaStoreRiceSet = {
        title: "飯類",
        properties: {
            main: {
                title: "飯類",
                type: "string",
                "enum": [
                    "芝茄肉醬飯 $45",
                ]
            },
            drink: LaksaStoreSetDrink,
        },
        required: [
            "main",
            "drink",
        ]
    }

    static public final LaksaStoreBakKutTeh = {
        title: "肉骨茶",
        properties: {
            main: {
                title: "肉骨茶",
                type: "string",
                "enum": [
                    "暖胃肉骨茶 配飯 $55",
                    "暖胃肉骨茶 配米線 $55",
                ]
            },
            drink: LaksaStoreSetDrink,
        },
        required: [
            "main",
            "drink",
        ]
    }
    
    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: LaksaStoreItem.all.map(item -> {
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
                switch (cast item.type:LaksaStoreItem) {
                    case null:
                        //pass
                    case NoodleSet:
                        Object.assign(itemSchema.properties, {
                            item: NoodleSet.getDefinition(pickupTimeSlot),
                        });
                    case RiceSet:
                        Object.assign(itemSchema.properties, {
                            item: RiceSet.getDefinition(pickupTimeSlot),
                        });
                    case BakKutTeh:
                        Object.assign(itemSchema.properties, {
                            item: BakKutTeh.getDefinition(pickupTimeSlot),
                        });
                    case Hotpot:
                        Object.assign(itemSchema.properties, {
                            item: Hotpot.getDefinition(pickupTimeSlot),
                        });
                }
                itemSchema;
            }),
            additionalItems: itemSchema(),
            minItems: 1,
        };
    }

    static function summarizeItem(
        pickupTimeSlot:Null<TimeSlot>,
        orderItem:{
            ?type:LaksaStoreItem,
            ?item:Dynamic,
        }
    ):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition(pickupTimeSlot);
        return switch (orderItem.type) {
            case NoodleSet:
                final noodlePrice = parsePrice(LaksaStoreNoodleSet.description).price;
                {
                    orderDetails:
                        fullWidthDot + orderItem.item.soup + " " + orderItem.item.ingredient + " " + orderItem.item.noodle + " $" + noodlePrice + "\n" +
                        fullWidthSpace + orderItem.item.drink,
                    orderPrice: noodlePrice + [
                        orderItem.item.soup,
                        orderItem.item.ingredient,
                        orderItem.item.noodle,
                        orderItem.item.drink,
                    ].map(item -> parsePrice(item).price).sum(),
                };
            case RiceSet | BakKutTeh:
                {
                    orderDetails:
                        fullWidthDot + orderItem.item.main + "\n" +
                        fullWidthSpace + orderItem.item.drink,
                    orderPrice: parsePrice(orderItem.item.main).price + parsePrice(orderItem.item.drink).price,
                };
            case Hotpot:
                {
                    orderDetails:
                        fullWidthDot + orderItem.item.main + "\n" +
                        fullWidthSpace + "肉（一）：" + orderItem.item.meat1 + "\n" +
                        fullWidthSpace + "肉（二）：" + orderItem.item.meat2
                    ,
                    orderPrice: parsePrice(orderItem.item.main).price,
                };
            case _:
                {
                    orderDetails: "",
                    orderPrice: 0,
                }
        }
    }

    static public function summarize(
        pickupTimeSlot:Null<TimeSlot>,
        formData:FormOrderData
    ):OrderSummary {
        var s = concatSummaries(formData.items.map(item -> summarizeItem(pickupTimeSlot, cast item)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}