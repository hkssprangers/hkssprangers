package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract LaksaStoreItem(String) to String {
    final NoodleSet;
    final RiceSet;
    final BakKutTeh;
    final Hotpot;

    static public final all:ReadOnlyArray<LaksaStoreItem> = [
        Hotpot,
        NoodleSet,
        // RiceSet,
        BakKutTeh,
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
            "烏龍茶紙包飲品",
            "蜂蜜綠茶紙包飲品",
            "柑桔檸檬紙包飲品",
            "支裝水",
            "罐裝可樂",
            "罐裝可樂 zero",
            "罐裝雪碧",
            "罐裝忌廉",
        ],
    };

    static public function LaksaStoreHotpot(pickupTimeSlot:Null<TimeSlot>) {
        final now:LocalDateString = Date.now();
        final earlyOrder = pickupTimeSlot != null && now.getDatePart() < pickupTimeSlot.start.getDatePart();
        final hotpot = if (earlyOrder) {
            "喇沙二人火鍋套餐 (提前一天預訂) $268";
        } else {
            "喇沙二人火鍋套餐 (即日) $288";
        }
        final meatOptions = [
            "薄切牛肩肉150g",
            "美國肥牛200g",
            "黑豚肉150g",
            "腩片200g",
        ];
        return {
            title: "喇沙二人火鍋套餐",
            description: "提前一天預訂 $268，即日落單 $288。\n包括：喇沙湯底 牛/豚四選二 雞件 蜆 越南虎蝦四隻 銀芽 鮮什菌 娃娃菜 咸蛋流心丸 豆腐卜 甜不辣 米粉 油麵",
            properties: {
                main: {
                    title: "喇沙二人火鍋套餐",
                    type: "string",
                    "enum": [
                        hotpot,
                    ],
                    "default": hotpot,
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
        title: "喇沙／冬蔭公",
        description: "套餐: 湯麵 + 飲品 $50",
        properties: {
            soup: {
                title: "湯底",
                type: "string",
                "enum": [
                    "喇沙",
                    "冬蔭公",
                ]
            },
            ingredient: {
                type: "string",
                title: "配料",
                description: "「新」四寶 = 霸王卷(魚), 甜不辣(魚), 蝦卷(雜菜,蝦), 哈哈笑丸(咸蛋流心丸)",
                "enum": [
                    "雞扒",
                    "豬扒",
                    "大蝦",
                    "野菌肥牛",
                    "牛舌",
                    "「新」四寶",
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
                    "芝茄肉醬飯 $40",
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
                    "暖胃肉骨茶 配飯 $50",
                    "暖胃肉骨茶 配米線 $50",
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
                var price = parsePrice(LaksaStoreNoodleSet.description).price;
                {
                    orderDetails:
                        fullWidthDot + orderItem.item.soup + " " + orderItem.item.ingredient + " " + orderItem.item.noodle + " $" + price + "\n" +
                        fullWidthSpace + orderItem.item.drink,
                    orderPrice: price,
                };
            case RiceSet | BakKutTeh:
                {
                    orderDetails:
                        fullWidthDot + orderItem.item.main + "\n" +
                        fullWidthSpace + orderItem.item.drink,
                    orderPrice: parsePrice(orderItem.item.main).price,
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