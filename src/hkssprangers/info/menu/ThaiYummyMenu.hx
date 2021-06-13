package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;
using Lambda;

enum abstract ThaiYummyItem(String) to String {
    final Snack;
    final Salad;
    final Grill;
    final Skewer;
    final Fried;
    final Vegetable;
    final Soup;
    final Seafood;
    final NoodleAndRice;
    final Drink;
    final CustomDrink;

    static public final all:ReadOnlyArray<ThaiYummyItem> = [
        Snack,
        Grill,
        Skewer,
        Salad,
        Fried,
        Vegetable,
        Soup,
        Seafood,
        NoodleAndRice,
        Drink,
        CustomDrink,
    ];

    public function getDefinition():Dynamic return switch (cast this:ThaiYummyItem) {
        case Snack: ThaiYummyMenu.ThaiYummySnack;
        case Grill: ThaiYummyMenu.ThaiYummyGrill;
        case Skewer: ThaiYummyMenu.ThaiYummySkewer;
        case Salad: ThaiYummyMenu.ThaiYummySalad;
        case Fried: ThaiYummyMenu.ThaiYummyFried;
        case Vegetable: ThaiYummyMenu.ThaiYummyVegetable;
        case Soup: ThaiYummyMenu.ThaiYummySoup;
        case Seafood: ThaiYummyMenu.ThaiYummySeafood;
        case NoodleAndRice: ThaiYummyMenu.ThaiYummyNoodleAndRice;
        case Drink: ThaiYummyMenu.ThaiYummyDrink;
        case CustomDrink: ThaiYummyMenu.ThaiYummyCustomDrink;
    }
}

class ThaiYummyMenu {
    static public final ThaiYummySnack = {
        title: "⼩吃",
        type: "string",
        "enum": [
            "01 泰式⽣蝦 $70",
            "02 泰式獅蚶 $70",
            "03 泰式酸辣無骨鳳爪🌶️ $50",
            "04 泰式豬⾁⽣菜包🌶️ $60",
            "05 豬頸⾁⽣菜包🌶️ $70",
        ],
    };
    static public final ThaiYummyGrill = {
        title: "燒物",
        type: "string",
        "enum": [
            "06 泰式燒豬頸肉 $70",
            "07 泰式燒墨魚 $70",
            // "08 泰式鹽燒鰂⿂ $100",
            // "08 泰式鹽燒烏頭 $100",
            // "08 泰式鹽燒盲曹 $100",
        ],
    };
    static public final ThaiYummySkewer = {
        title: "泰式串燒",
        description: "最少3串/不設剪開",
        type: "array",
        items: {
            type: "string",
            "enum": [
                "09A 豬⾁ $12",
                "09B ⽜⾁ $12",
                "09C 雞⾁ $12",
                "09D 雞腎 $12",
                "09D 燒雞全翼 $15",
                "09E 雞軟骨 $15",
            ],
        },
        minItems: 3,
    };
    static public final ThaiYummySalad = {
        title: "沙律",
        type: "string",
        "enum": [
            "10 泰式⽊瓜沙律(甜)🌶️ $50",
            "10 泰式⽊瓜沙律(咸)🌶️ $50",
            "11 泰式鮮蝦沙律🌶️ $70",
            "12 泰式海鮮粉絲沙律🌶️ $60",
            "13 泰式扎⾁粉絲沙律🌶️ $60",
        ],
    };
    static public final ThaiYummyFried = {
        title: "炸物",
        type: "string",
        "enum": [
            "14 泰式特⾊春卷 $50",
            "15 泰式炸雞⾁丸 $50",
            "16 泰式炸⽪蛋蝦餅 8件 $70",
            "16 泰式炸⽪蛋蝦餅 4件 $50",
            "17 泰式炸蝦餅 8件 $70",
            "17 泰式炸蝦餅 4件 $50",
            "18 泰式炸併盤 (蝦餅x3 扎⾁x3 雞⾁丸x3) $70",
        ],
    };
    static public final ThaiYummyVegetable = {
        title: "炒菜",
        properties: {
            style: {
                title: "風味",
                type: "string",
                "enum": [
                    "A 泰式",
                    "B 鹹⿂",
                    "C 蒜蓉",
                ],
            },
            vege: {
                title: "菜",
                type: "string",
                "enum": [
                    "71 通菜 $50",
                    "72 芥蘭 $50",
                    "73 雜菜 $50",
                    "74 泰國椰菜苗 $60",
                ],
            },
        },
        required: ["style", "vege"],
    }
    static public final ThaiYummySoup = {
        title: "湯",
        properties: {
            soup: {
                title: "湯",
                type: "string",
                "enum": [
                    "61 泰式椰汁雞湯🌶️ $60",
                    "62 泰式冬功湯🌶️ $70",
                ],
            },
            options: {
                type: "array",
                title: "選項",
                items: {
                    type: "string",
                    "enum": [
                        "加河粉 $10",
                        "加⾦邊粉 $10",
                    ],
                },
                uniqueItems: true,
            },
        },
        required: ["soup"],
    };
    static public final ThaiYummySeafood = {
        title: "炒海鮮",
        properties: {
            seafood: {
                title: "炒海鮮",
                type: "string",
                "enum": [
                    "51 泰式炒蜆🌶️ $70",
                    "52 泰式炒蝦🌶️ $150",
                    "53 泰式炒蟹🌶️ $180",
                ],
            },
            style: {
                title: "風味",
                type: "string",
                "enum": [
                    "咖哩",
                    "香辣",
                ],
            },
        },
        required: ["seafood", "style"],
    }
    static public final ThaiYummyNoodleAndRice = {
        title: "炒粉飯",
        type: "string",
        "enum": [
            "21 泰式炒⾦邊粉 $60",
            "22 香葉辣肉碎炒河🌶️ $60",
            "23 泰式乾炒豬肉河 $60",
            "24 泰式乾炒雞肉河 $60",
            "25 泰式乾炒海鮮河 $60",
            "26 泰式海鮮炒粉絲 $60",

            // 繁忙時間不設濕炒
            // "27 泰式濕炒豬肉河 $70",
            // "28 泰式濕炒雞肉河 $70",
            // "29 泰式濕炒海鮮河 $80",

            "31 香葉辣肉碎炒飯🌶️ $60",
            "32 泰式豬肉炒飯 $60",
            "33 泰式雞肉炒飯 $60",
            "34 泰式蟹肉炒飯 $60",
            "35 泰式豬頸肉炒飯 $60",
            "36 泰式海鮮炒飯 $60",
            "37 泰式蝦醬炒飯 $60",
            "38 泰式菠蘿炒飯 $60",
        ],
    };
    static public final ThaiYummyDrink = {
        title: "飲品",
        type: "string",
        "enum": [
            // "41 汽⽔ $8",
            "42 ⽀裝⽔ $6",
            // "43 紙包飲品 $5",
            "44 泰國鮮椰青 $40",
            "45 泰玫瑰梳打 1杯 $15",
            "45 泰玫瑰梳打 2杯 $28",
        ],
    };
    static public final ThaiYummyCustomDrink = {
        title: "自家製飲品",
        description: "1枝 $15, 2枝 $28",
        properties: {
            drink1: {
                title: "自家製飲品",
                type: "string",
                "enum": [
                    "46A 蝶豆花水 $15",
                    "46B 木墩果水 $15",
                    "46C 泰芫茜茶 $15",
                    "46D 龍眼水 $15",
                    "46E 香茅水 $15",
                ],
            },
            drink2: {
                title: "自家製飲品",
                type: "string",
                "enum": [
                    "46A 蝶豆花水 (第二枝) $13",
                    "46B 木墩果水 (第二枝) $13",
                    "46C 泰芫茜茶 (第二枝) $13",
                    "46D 龍眼水 (第二枝) $13",
                    "46E 香茅水 (第二枝) $13",
                ],
            },
        },
        required: ["drink1"],
    };

    static public function itemsSchema(order:FormOrderData):Dynamic {
        var itemDefs = [
            for (item in ThaiYummyItem.all)
            item => item.getDefinition()
        ];
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: [
                        for (item => def in itemDefs)
                        {
                            title: def.title,
                            const: item,
                        }
                    ],
                },
            },
            required: [
                "type",
            ],
        }
        return {
            type: "array",
            items: order.items == null || order.items.length == 0 ? itemSchema() : order.items.map(item -> {
                var itemSchema:Dynamic = itemSchema();
                switch (itemDefs[cast item.type]) {
                    case null:
                        // pass
                    case itemDef:
                        Object.assign(itemSchema.properties, {
                            item: itemDef,
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
        ?type:ThaiYummyItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case Snack | Grill | Salad | Fried | NoodleAndRice | Drink:
                switch (orderItem.item:Null<String>) {
                    case v if (Std.isOfType(v, String)):
                        {
                            orderDetails: v,
                            orderPrice: v.parsePrice().price,
                        };
                    case _:
                        {
                            orderDetails: "",
                            orderPrice: 0.0,
                        };
                }
            case Skewer:
                var orderDetails = [];
                var orderPrice = 0.0;
                for (item in (orderItem.item:Array<String>)) {
                    var p = parsePrice(item);
                    orderDetails.push(ThaiYummySkewer.title + "：" + item);
                    orderPrice += p.price;
                }
                {
                    orderDetails: orderDetails.join("\n"),
                    orderPrice: orderPrice,
                };
            case Vegetable:
                summarizeOrderObject(orderItem.item, def, ["style", "vege"], []);
            case Soup:
                summarizeOrderObject(orderItem.item, def, ["soup", "options"], []);
            case Seafood:
                summarizeOrderObject(orderItem.item, def, ["seafood", "style"], []);
            case CustomDrink:
                summarizeOrderObject(orderItem.item, def, ["drink1", "drink2"], []);
            case _:
                {
                    orderDetails: "",
                    orderPrice: 0,
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