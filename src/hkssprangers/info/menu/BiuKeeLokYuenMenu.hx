package hkssprangers.info.menu;


import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract BiuKeeLokYuenItem(String) to String {
    final NoodleSet;
    final LoMeinSet;
    final SingleDish;
    final Pot;

    static public final all:ReadOnlyArray<BiuKeeLokYuenItem> = [
        Pot,
        NoodleSet,
        LoMeinSet,
        SingleDish,
    ];

    public function getDefinition():Dynamic return switch (cast this:BiuKeeLokYuenItem) {
        case NoodleSet: BiuKeeLokYuenMenu.BiuKeeLokYuenNoodleSet;
        case LoMeinSet: BiuKeeLokYuenMenu.BiuKeeLokYuenLoMeinSet;
        case SingleDish: BiuKeeLokYuenMenu.BiuKeeLokYuenSingleDish;
        case Pot: BiuKeeLokYuenMenu.BiuKeeLokYuenPot;
    }
}

class BiuKeeLokYuenMenu {
    static public final BiuKeeLokYuenSetDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "罐裝可樂 +$8",
        ],
    };
    static public final BiuKeeLokYuenNoodleSet = {
        title: "粉麵",
        properties: {
            main1: {
                type: "string",
                title: "配料",
                "enum": [
                    "標記新鮮牛雜 $52",
                    "秘製新鮮牛腩 $52",
                    "秘製牛肚 $52",
                    "秘製牛筋 $52",
                    "標記新鮮牛三寶(牛腩牛肚牛筋) $68",
                    "秘製南乳豬手 $48",
                    "潮州四寶丸 $48",
                    "自家製鮮蝦雲吞 $42",
                    "標記雙丸(牛丸+魚蛋) $42",
                    "手打魚蛋 $42",
                    "爽滑墨魚丸 $42",
                    "彈牙牛丸 $42",
                    "彈牙牛筋丸 $42",
                    "彈牙黑椒牛筋丸 $42",
                    "彈牙豬肉丸 $42",
                    "香口炸魚片頭 $42",
                    "香口魚片 $42",
                ],
            },
            main2: {
                type: "string",
                title: "雙併",
                "enum": [
                    "自家製鮮蝦雲吞 +$10",
                    "手打魚蛋 +$10",
                    "爽滑墨魚丸 +$10",
                    "彈牙牛丸 +$10",
                    "彈牙牛筋丸 +$10",
                    "彈牙黑椒牛筋丸 +$10",
                    "彈牙豬肉丸 +$10",
                    "香口炸魚片頭 +$10",
                    "香口魚片 +$10",
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
                        "加底 +$10",
                        "加紫菜 +$8",
                        "加生菜 +$8",
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
                    "標記新鮮牛雜 $63",
                    "秘製新鮮牛腩 $63",
                    "秘製牛肚 $63",
                    "秘製牛筋 $63",
                    "標記新鮮牛三寶(牛腩牛肚牛筋) $80",
                    "秘製南乳豬手 $63",
                    "自家製鮮蝦雲吞 $54",
                    "手打魚蛋 $54",
                    "爽滑墨魚丸 $54",
                    "彈牙牛丸 $54",
                    "彈牙牛筋丸 $54",
                    "彈牙黑椒牛筋丸 $54",
                    "彈牙豬肉丸 $54",
                    "香口炸魚片頭 $54",
                    "香口魚片 $54",
                ],
            },
            main2: {
                type: "string",
                title: "雙併",
                "enum": [
                    "自家製鮮蝦雲吞 +$10",
                    "手打魚蛋 +$10",
                    "爽滑墨魚丸 +$10",
                    "彈牙牛丸 +$10",
                    "彈牙牛筋丸 +$10",
                    "彈牙黑椒牛筋丸 +$10",
                    "彈牙豬肉丸 +$10",
                    "香口炸魚片頭 +$10",
                    "香口魚片 +$10",
                ],
            },
            options: {
                type: "array",
                title: "其他",
                description: "不設另上",
                items: {
                    type: "string",
                    "enum": [
                        "加底 +$10",
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
        title: "淨食牛腩／牛雜／小食",
        description: "限量食品售完即止，外賣員當日會確認食物供應。",
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
            "唐生菜 $22",
            "通菜 $22",
            "菜心 $22",
            "芥蘭 $22",
            "淨食潮州紫菜湯 $18",
            "淨雲吞 $38",
        ],
    };

    static public final BiuKeeLokYuenPot = {
        title: "秋冬牛羊煲",
        description: "附送唐生菜一份",
        type: "string",
        "enum": [
            "秘製古法羊腩煲 例 $342",
            "秘製古法羊腩煲 大 $400",
            "秘製古法羊腩煲 特大 $506",

            "標記招牌牛腩煲 例 $310",
            "標記招牌牛腩煲 大 $400",

            "標記招牌新鮮牛雜煲 例 $310",
            "標記招牌新鮮牛雜煲 大 $400",
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
            case Pot:
                switch (orderItem.item:Null<String>) {
                    case v if (Std.isOfType(v, String)):
                        {
                            orderDetails: fullWidthDot + v + "\n" + fullWidthSpace + BiuKeeLokYuenPot.description,
                            orderPrice: v.parsePrice().price,
                        }
                    case _:
                        {
                            orderDetails: "",
                            orderPrice: 0.0,
                        }
                }
            case SingleDish:
                switch (orderItem.item:Null<String>) {
                    case v if (Std.isOfType(v, String)):
                        {
                            orderDetails: fullWidthDot + v,
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