package hkssprangers.info.menu;


import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract BiuKeeLokYuenItem(String) to String {
    final NoodleSet;
    final LoMeinSet;
    final SingleDish;

    static public final all:ReadOnlyArray<BiuKeeLokYuenItem> = [
        NoodleSet,
        LoMeinSet,
        SingleDish,
    ];

    public function getDefinition():Dynamic return switch (cast this:BiuKeeLokYuenItem) {
        case NoodleSet: BiuKeeLokYuenMenu.BiuKeeLokYuenNoodleSet;
        case LoMeinSet: BiuKeeLokYuenMenu.BiuKeeLokYuenLoMeinSet;
        case SingleDish: BiuKeeLokYuenMenu.BiuKeeLokYuenSingleDish;
    }
}

class BiuKeeLokYuenMenu {
    static public final BiuKeeLokYuenSetDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "罐裝可樂 (+$8)",
        ],
    };
    static public final BiuKeeLokYuenNoodleSet = {
        title: "粉麵",
        properties: {
            main1: {
                type: "string",
                title: "配料",
                "enum": [
                    "標記新鮮牛雜 $48",
                    "秘製新鮮牛腩 $48",
                    "秘製牛肚 $48",
                    "秘製牛筋 $48",
                    "標記新鮮牛三寶(牛腩牛肚牛筋) $64",
                    "秘製南乳豬手 $44",
                    "潮州四寶丸 $44",
                    "自家製鮮蝦雲吞 $38",
                    "標記雙丸(牛丸+魚蛋) $38",
                    "手打魚蛋 $38",
                    "爽滑墨魚丸 $38",
                    "彈牙牛丸 $38",
                    "彈牙牛筋丸 $38",
                    "彈牙黑椒牛筋丸 $38",
                    "彈牙豬肉丸 $38",
                    "香口炸魚片頭 $38",
                    "香口魚片 $38",
                ],
            },
            main2: {
                type: "string",
                title: "雙併",
                "enum": [
                    "自家製鮮蝦雲吞 (+$10)",
                    "手打魚蛋 (+$10)",
                    "爽滑墨魚丸 (+$10)",
                    "彈牙牛丸 (+$10)",
                    "彈牙牛筋丸 (+$10)",
                    "彈牙黑椒牛筋丸 (+$10)",
                    "彈牙豬肉丸 (+$10)",
                    "香口炸魚片頭 (+$10)",
                    "香口魚片 (+$10)",
                ],
            },
            noodle: {
                type: "string",
                title: "麵類",
                "enum": [
                    "河粉",
                    "麵",
                    "粗麵",
                    "米粉",
                    "米線",
                ],
            },
            options: {
                type: "array",
                title: "其他",
                description: "不設另上",
                items: {
                    type: "string",
                    "enum": [
                        "加底 (+$10)",
                        "加紫菜 (+$8)",
                        "加生菜 (+$8)",
                    ],
                },
                uniqueItems: true,
            },
            drink: BiuKeeLokYuenSetDrink,
        },
        required: [
            "main1",
            "noodle",
        ]
    };

    static public final BiuKeeLokYuenLoMeinSet = {
        title: "撈麵",
        description: "撈麵配上湯及自家秘製撈麵醬",
        properties: {
            main1: {
                type: "string",
                title: "配料",
                "enum": [
                    "標記新鮮牛雜 $59",
                    "秘製新鮮牛腩 $59",
                    "秘製牛肚 $59",
                    "秘製牛筋 $59",
                    "標記新鮮牛三寶(牛腩牛肚牛筋) $76",
                    "秘製南乳豬手 $59",
                    "自家製鮮蝦雲吞 $50",
                    "手打魚蛋 $50",
                    "爽滑墨魚丸 $50",
                    "彈牙牛丸 $50",
                    "彈牙牛筋丸 $50",
                    "彈牙黑椒牛筋丸 $50",
                    "彈牙豬肉丸 $50",
                    "香口炸魚片頭 $50",
                    "香口魚片 $50",
                ],
            },
            main2: {
                type: "string",
                title: "雙併",
                "enum": [
                    "自家製鮮蝦雲吞 (+$10)",
                    "手打魚蛋 (+$10)",
                    "爽滑墨魚丸 (+$10)",
                    "彈牙牛丸 (+$10)",
                    "彈牙牛筋丸 (+$10)",
                    "彈牙黑椒牛筋丸 (+$10)",
                    "彈牙豬肉丸 (+$10)",
                    "香口炸魚片頭 (+$10)",
                    "香口魚片 (+$10)",
                ],
            },
            options: {
                type: "array",
                title: "其他",
                description: "不設另上",
                items: {
                    type: "string",
                    "enum": [
                        "加底 (+$10)",
                    ],
                },
                uniqueItems: true,
            },
            drink: BiuKeeLokYuenSetDrink,
        },
        required: [
            "main1",
        ]
    };

    static public final BiuKeeLokYuenSingleDish = {
        title: "淨食牛腩/牛雜/小食",
        description: "請留意外賣消費最低 $30。限量食品售完即止，外賣員當日會確認食物供應。",
        type: "string",
        "enum": [
            "淨食新鮮牛雜 例 $92",
            "淨食新鮮牛雜 大 $130",
            "淨食新鮮牛腩 例 $92",
            "淨食新鮮牛腩 大 $130",
            "淨食秘製香牛肚 例 $92",
            "淨食秘製香牛肚 大 $130",
            "淨食秘製牛筋 例 $92",
            "淨食秘製牛筋 大 $130",
            "限量自家製鮮炸魚皮(跟上湯) $25",
            "西生菜 $18",
            "通菜 $18",
            "菜心 $18",
            "芥蘭 $18",
            "淨食潮州紫菜湯 $18",
            "淨雲吞 $38",
        ],
    };
    
    static public function itemsSchema(order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: BiuKeeLokYuenItem.all.map(item -> {
                        title: item.getDefinition().title,
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
                switch (cast item.type:BiuKeeLokYuenItem) {
                    case null:
                        //pass
                    case itemType:
                        Object.assign(itemSchema.properties, {
                            item: itemType.getDefinition(),
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
        ?type:BiuKeeLokYuenItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case NoodleSet:
                summarizeOrderObject(orderItem.item, def, ["main1", "main2", "noodle", "options", "drink"]);
            case LoMeinSet:
                summarizeOrderObject(orderItem.item, def, ["main1", "main2", "options", "drink"]);
            case SingleDish:
                switch (orderItem.item:Null<String>) {
                    case v if (Std.isOfType(v, String)):
                        {
                            orderDetails: v,
                            orderPrice: v.parsePrice().price,
                        }
                    case _:
                        {
                            orderDetails: "",
                            orderPrice: 0.0,
                        }
                }
            case _:
                {
                    orderDetails: "",
                    orderPrice: 0.0,
                }
        }
    }

    static public function summarize(formData:FormOrderData):OrderSummary {
        var s = concatSummaries(formData.items.map(item -> summarizeItem(cast item)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}