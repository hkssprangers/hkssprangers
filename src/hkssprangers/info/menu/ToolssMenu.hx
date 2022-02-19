package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;
using Lambda;

enum abstract ToolssItem(String) to String {
    final AllDay;
    final Bento;
    final Pasta;
    final Bread;
    final Salad;
    final Snack;
    final Cake;
    final HotDrink;
    final IcedDrink;

    static public final all:ReadOnlyArray<ToolssItem> = [
        AllDay,
        Bento,
        Pasta,
        Bread,
        Salad,
        Snack,
        Cake,
        HotDrink,
        IcedDrink,
    ];

    public function getDefinition():Dynamic return switch (cast this:ToolssItem) {
        case AllDay: ToolssMenu.ToolssAllDay;
        case Bento: ToolssMenu.ToolssBento;
        case Pasta: ToolssMenu.ToolssPasta;
        case Bread: ToolssMenu.ToolssBread;
        case Salad: ToolssMenu.ToolssSalad;
        case Snack: ToolssMenu.ToolssSnack;
        case Cake: ToolssMenu.ToolssCake;
        case HotDrink: ToolssMenu.ToolssHotDrink;
        case IcedDrink: ToolssMenu.ToolssIcedDrink;
    }
}

class ToolssMenu {
    static function markup(price:Float):Float {
        return Math.round(price * 1.1);
    }
    static public final ToolssAllDay = {
        title: "全日早餐",
        description: "$" + markup(108),
        properties: {
            a: {
                title: "A",
                description: "自選一款",
                type: "string",
                "enum": [
                    "德國香腸",
                    "香烤雞翼",
                    // "煙三文魚",
                    "香烤茄子",
                    "芝士漢堡扒",
                    "烤波特菇",
                ],
            },
            b: {
                title: "B",
                description: "自選一款",
                type: "string",
                "enum": [
                    "蒜蓉多士",
                    "新鮮麵包",
                ],
            },
            cOptions: {
                title: "C",
                description: "自選兩款",
                type: "array",
                items: {
                    type: "string",
                    "enum": [
                        "凱撒沙律",
                        "田園沙律",
                        "香烤蕃茄",
                        "蒜香雜菌",
                        "鹽焗秋葵",
                    ],
                },
                minItems: 2,
                maxItems: 2,
                uniqueItems: true,
            },
            dOptions: {
                title: "D",
                description: "自選兩款",
                type: "array",
                items: {
                    type: "string",
                    "enum": [
                        "煎蛋",
                        "炒蛋",
                        "香脆薯餅",
                        "香烤煙肉",
                    ],
                },
                minItems: 2,
                maxItems: 2,
                uniqueItems: true,
            },
        },
        required: ["a", "b", "cOptions", "dOptions"],
    }
    static public final ToolssBento = {
        title: "便當",
        type: "string",
        "enum": [
            // 紙 menu
            "鹽燒鯖魚青醬忌廉便當 $" + markup(68),
            // "日式咖哩牛肋肉便當 $" + markup(68),
            "手打鲜鱿豚肉餅便當 $" + markup(75),

            // 手寫牌
            "日式咖喱牛肋肉飯 $" + markup(75),
            "手打鮮魷豚肉餅飯 $" + markup(75),
            // "日式咖喱唐揚雞便當 $" + markup(68),
            // "手撕雞醉雞翼蕎麥冷麵 $" + markup(88),
            // "鹽烤鯖魚青醬飯 $" + markup(68),
        ],
    };
    static public final ToolssPasta = {
        title: "意大利麵",
        type: "string",
        "enum": [
            // 手寫牌
            // "鮮茄蓉辣肉腸意粉 $" + markup(68),
            "南瓜汁芝士釀雞卷意粉 $" + markup(88),

            // 紙 menu
            // "忌廉汁煙三文魚意大利麵 $" + markup(98),
            // "羅勒醬蜆肉忌廉意大利麵 $" + markup(68),
            "黑松露忌廉雜菌意大利麵 $" + markup(98),
            "羅勒忌廉蟹肉意大利麵 $" + markup(88),
            "香草汁忌廉鴨胸意大利麵 $" + markup(68),
        ],
    };
    static public final ToolssBread = {
        title: "包類",
        type: "string",
        "enum": [
            "漢堡 (和牛) $" + markup(98),
            "漢堡 (波特菇) $" + markup(68),
            "芝士德國熱狗 $" + markup(58),
        ],
    };
    static public final ToolssSalad = {
        title: "沙律",
        type: "string",
        "enum": [
            "蜜糖凱撒沙律 $" + markup(60),
            "特選田園沙律 $" + markup(60),
        ],
    };
    static public final ToolssSnack = {
        title: "輕食",
        type: "string",
        "enum": [
            "流心蛋釀芝士波特菇 $" + markup(58),
            "蜜糖烤雞翼 $" + markup(50),
            "蜜糖牛油薯粒 $" + markup(60),
            "焗芝士煙肉碎薯條 $" + markup(50),
            "北海道南瓜芝士薯餅(兩件) $" + markup(55),
        ],
    };
    static public final ToolssCake = {
        title: "蛋糕",
        type: "string",
        "enum": [
            "紐約芝士蛋糕 $" + markup(45),
            "紐約芒果芝士蛋糕 $" + markup(45),
        ],
    };
    static public final ToolssHotDrink = {
        title: "熱飲",
        type: "string",
        "enum": [
            "濃縮咖啡 (single) $" + markup(22),
            "濃縮咖啡 (double) $" + markup(30),
            "瑪琪雅朵 (single) $" + markup(28),
            "瑪琪雅朵 (double) $" + markup(35),
            "美式咖啡 (single) $" + markup(32),
            "美式咖啡 (double) $" + markup(38),
            "黑咖啡 $" + markup(32),
            "拿鐵 (single) $" + markup(40),
            "拿鐵 (double) $" + markup(45),
            "迷你鮮奶咖啡 $" + markup(28),
            "鮮奶咖啡 (single) $" + markup(40),
            "鮮奶咖啡 (double) $" + markup(45),
            "蜜糖鲜奶咖啡 (single) $" + markup(45),
            "蜜糖鲜奶咖啡 (double) $" + markup(50),
            "卡布奇諾 (single) $" + markup(38),
            "卡布奇諾 (double) $" + markup(42),
            "摩卡 (single) $" + markup(42),
            "摩卡 (double) $" + markup(48),
            "焦糖咖啡 (single) $" + markup(40),
            "焦糖咖啡 (double) $" + markup(45),
            "榛子咖啡 (single) $" + markup(40),
            "榛子咖啡 (double) $" + markup(45),
            "荔枝咖啡 (single) $" + markup(40),
            "荔枝咖啡 (double) $" + markup(45),
            "薑味咖啡 (single) $" + markup(40),
            "薑味咖啡 (double) $" + markup(45),
            "椰子咖啡 (single) $" + markup(40),
            "椰子咖啡 (double) $" + markup(45),
            "香濃朱古力 (single) $" + markup(38),
            "香濃朱古力 (double) $" + markup(42),
            "椰子朱古力 (single) $" + markup(42),
            "椰子朱古力 (double) $" + markup(48),
            "紫薯鮮奶 (single) $" + markup(40),
            "紫薯鮮奶 (double) $" + markup(45),
            "蘋果伯爵茶 (single) $" + markup(38),
            "蘋果伯爵茶 (double) $" + markup(42),
            "蜜糖伯爵茶 (single) $" + markup(38),
            "蜜糖伯爵茶 (double) $" + markup(42),
            "日本茗広焙茶鮮奶 $" + markup(58),
            "日本西村抹茶鮮奶 $" + markup(58),
        ],
    };
    static public final ToolssIcedDrink = {
        title: "凍飲",
        type: "string",
        "enum": [
            "冰美式咖啡 $" + markup(42),
            "冰咖啡梳打 $" + markup(48),
            "髒髒咖啡 $" + markup(48),
            "冰拿鐵 $" + markup(45),
            "冰摩卡 $" + markup(48),
            "冰焦糖咖啡 $" + markup(48),
            "冰榛子咖啡 $" + markup(48),
            "冰荔枝咖啡 $" + markup(48),
            "冰蘋果伯爵茶 $" + markup(48),
            "冰蜜糖伯爵茶 $" + markup(48),
            "蜜桃梳打 $" + markup(45),
            "菠蘿梳打 $" + markup(45),
            "檸檬梳打 $" + markup(45),
            "芒果梳打 $" + markup(45),
            "青蘋果梳打 $" + markup(45),
            "鲜果沙冰 $" + markup(55),
        ],
    };

    static public function itemsSchema(order:FormOrderData):Dynamic {
        var itemDefs = [
            for (item in ToolssItem.all)
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
        ?type:ToolssItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case AllDay:
                summarizeOrderObject(orderItem.item, def, ["a", "b", "cOptions", "dOptions"], [ToolssAllDay.description]);
            case Bento | Bread | Cake | Pasta | Salad | Snack | HotDrink | IcedDrink:
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