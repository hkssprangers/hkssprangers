package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract PokeGoItem(String) to String {
    final SignatureBowl;
    final BuildYourOwnBowl;
    final Drink;
    final Snack;

    static public final all:ReadOnlyArray<PokeGoItem> = [
        SignatureBowl,
        BuildYourOwnBowl,
        Drink,
        Snack,
    ];

    public function getDefinition():Dynamic return switch (cast this:PokeGoItem) {
        case SignatureBowl: PokeGoMenu.PokeGoSignatureBowl;
        case BuildYourOwnBowl: PokeGoMenu.PokeGoBuildYourOwnBowl;
        case Drink: PokeGoMenu.PokeGoDrink;
        case Snack: PokeGoMenu.PokeGoSnack;
    }
}

class PokeGoMenu {
    static function markup(price:Float):Float {
        return Math.round(price * 1.2);
    }

    static public final PokeGoDrink = {
        title: "Drink",
        type: "string",
        "enum": [
            "玄米茶 $" + markup(38),
            "麥茶 $" + markup(38),
            "蜂蜜綠茶 $" + markup(38),
            "檸檬薑蜜 $" + markup(38),
            "桂圓紅棗茶 $" + markup(38),
            "檸檬柚子蜜 $" + markup(38),
            "桂花烏龍茶 $" + markup(38),
            "玫瑰茉莉茶 $" + markup(38),
            "四季春果茶 $" + markup(38),
            "檸檬香茅蜜 $" + markup(38),
            
            "冷壓鮮橙汁 $" + markup(38),
            "冷壓蘋果汁 $" + markup(38),
            "冷壓菠蘿汁 $" + markup(38),
            "紅火龍果汁 $" + markup(38),
            "100%椰青水 $" + markup(38),
            "柚子薄荷沙冰 $" + markup(38),
            "夏威夷賓治 $" + markup(48),
            "菠椰菠蘿ME $" + markup(48),
            "牛油果奶昔 $" + markup(48),
        ],
    };

    static public final PokeGoSignatureBowl = {
        title: "Signature Bowl",
        properties: {
            main: {
                title: "Signature Bowl",
                type: "string",
                oneOf: [
                    {
                        const: "808 $" + markup(108),
                        title: "808 (吞拿魚 壽司飯 沙律菜 和式青蔥 枝仁豆 三文魚籽 雜菌香菇 山葵乳酪醬 芝麻 木魚絲) $" + markup(108),
                    },
                    {
                        const: "OHANA $" + markup(98),
                        title: "OHANA (三文魚 沙律菜 樱桃蕃茄 温室青瓜 甜粟米 蜜糖芥末醬 芝麻 果仁) $" + markup(98),
                    },
                    {
                        const: "NALU $" + markup(98),
                        title: "NALU (八爪魚 壽司飯 樱桃蕃茄 和式青蔥 甜粟米 皇帝蟹棒 辛味蛋黃醬 芝麻 辣椒碎) $" + markup(98),
                    },
                    {
                        const: "SHOYU AHI $" + markup(98),
                        title: "SHOYU AHI (吞拿魚 壽司飯 芝麻海帶 和式青蔥 紫洋蔥 鰹魚醬油 芝麻 木魚絲) $" + markup(98),
                    },
                    {
                        const: "ONO $" + markup(98),
                        title: "ONO (三文魚 壽司飯 溫室青瓜 雞蛋絲 皇帝蟹棒 果仁醬 芝麻) $" + markup(98),
                    },
                ]
            },
            topupOptions: {
                type: "array",
                title: "Top-up",
                items: {
                    type: "string",
                    "enum": [
                        "酸蘿蔔 +$" + markup(8),
                        "枝仁豆 +$" + markup(8),
                        "紫洋蔥 +$" + markup(8),
                        "雞蛋絲 +$" + markup(8),
                        "溫室青瓜 +$" + markup(8),
                        "和式青蔥 +$" + markup(8),
                        "櫻桃蕃茄 +$" + markup(8),
                        "芝麻海帶 +$" + markup(8),
                        "蟹籽 +$" + markup(8),
                        "醃酸薑 +$" + markup(8),
                        "甜粟米 +$" + markup(8),
                        "麻醬豆腐 +$" + markup(8),
                        "牛油果 +$" + markup(12),
                        "雜菌香菇 +$" + markup(12),
                        "温泉蛋 +$" + markup(12),
                        "鮮蟹肉 +$" + markup(12),
                        "三文魚籽 +$" + markup(16),
                        "蟹棒沙律 +$" + markup(12),
                    ],
                },
                uniqueItems: true,
            },
        },
        required: [
            "main",
        ]
    };

    static public final PokeGoBuildYourOwnBowl = {
        title: "Build Your Own Bowl",
        properties: {
            main: {
                title: "Main Protein",
                type: "string",
                "enum": [
                    "三文魚 $" + markup(98),
                    "三文魚 w/extra 80g $" + markup(98 + 38),
                    "吞拿魚 $" + markup(98),
                    "吞拿魚 w/extra 80g $" + markup(98 + 38),
                    "八爪魚 $" + markup(98),
                    "八爪魚 w/extra 80g $" + markup(98 + 38),
                    "雜菌香菇 $" + markup(98),
                ]
            },
            baseOptions: {
                type: "array",
                title: "Base",
                description: "可揀一或兩款",
                items: {
                    type: "string",
                    "enum": [
                        "壽司飯",
                        "珍珠糙飯",
                        "沙律菜",
                    ],
                },
                minItems: 1,
                maxItems: 2,
                uniqueItems: true,
            },
            toppingOptions: {
                type: "array",
                title: "Toppings",
                description: "可揀三款，第四款起 $8/款",
                items: {
                    type: "string",
                    "enum": [
                        "酸蘿蔔",
                        "枝仁豆",
                        "紫洋蔥",
                        "雞蛋絲",
                        "溫室青瓜",
                        "和式青蔥",
                        "櫻桃蕃茄",
                        "芝麻海帶",
                        "蟹籽",
                        "醃酸薑",
                        "甜粟米",
                        "麻醬豆腐",
                    ],
                },
                minItems: 1,
                uniqueItems: true,
            },
            topupOptions: {
                type: "array",
                title: "Top-up",
                items: {
                    type: "string",
                    "enum": [
                        "牛油果 $" + markup(12),
                        "雜菌香菇 $" + markup(12),
                        "温泉蛋 $" + markup(12),
                        "鮮蟹肉 $" + markup(12),
                        "三文魚籽 $" + markup(16),
                        "蟹棒沙律 $" + markup(12),
                    ],
                },
                uniqueItems: true,
            },
            dressings: {
                title: "Dressings",
                type: "string",
                "enum": [
                    "鰹魚醬油",
                    "蜜糖芥末醬",
                    "辛味蛋黃醬",
                    "果仁醬",
                    "山葵乳酪醬",
                ]
            },
            seasoningOptions: {
                type: "array",
                title: "Seasoning",
                description: "可任選。預設有芝麻。",
                items: {
                    type: "string",
                    "enum": [
                        "果仁",
                        "木魚絲",
                        "辣椒碎",
                        "脆蒜",
                        "岩鹽",
                        "紫菜絲",
                        "不要芝麻",
                    ],
                },
                uniqueItems: true,
            }
        },
        required: [
            "main",
            "baseOptions",
            "toppingOptions",
            "dressings",
        ]
    };

    static public final PokeGoSnack = {
        title: "Snack",
        type: "string",
        "enum": [
            "冷凍豆腐 $" + markup(38),
            "炸蓮藕片 $" + markup(48),
            "梅凍蕃茄 $" + markup(38),
            "火山炸雞 $" + markup(68),
            "麻醬秋葵 $" + markup(38),
            "和風炸雞 $" + markup(68),
            "蟹肉沙律 $" + markup(68),
            "黃金蟹卷 $" + markup(68),
        ]
    }

    static public function itemsSchema(order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: PokeGoItem.all.map(item -> {
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
                switch (cast item.type:PokeGoItem) {
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
        ?type:PokeGoItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case SignatureBowl:
                summarizeOrderObject(orderItem.item, def, ["main", "topupOptions"], null, (fieldName, value:Dynamic) -> switch fieldName {
                    case "main":
                        {
                            title: "",
                        }
                    case "topupOptions":
                        var options:Array<String> = value;
                        {
                            value: options.join(", "),
                        };
                    case _: 
                        {};
                }, "");
            case BuildYourOwnBowl:
                summarizeOrderObject(orderItem.item, def, ["main", "baseOptions", "toppingOptions", "topupOptions", "dressings", "seasoningOptions"], null, (fieldName, value) -> switch fieldName {
                    case "baseOptions", "topupOptions", "seasoningOptions":
                        var options:Array<String> = value;
                        {
                            value: options.join(", "),
                        };
                    case "toppingOptions":
                        var options:Array<String> = value;
                        var price = switch (options != null ? options.length : 0) {
                            case 0, 1, 2, 3:
                                0.0;
                            case n:
                                (n - 3) * (def.properties.toppingOptions.description:String).parsePrice().price;
                        };
                        {
                            value: options.join(", "),
                            price: price,
                        };
                    case _: 
                        {
                            price: null,
                        };
                }, "");
            case Snack | Drink:
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