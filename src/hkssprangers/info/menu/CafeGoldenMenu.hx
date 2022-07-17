package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract CafeGoldenItem(String) to String {
    final Main;
    final Dessert;
    final Drink;

    static public final all:ReadOnlyArray<CafeGoldenItem> = [
        Main,
        Dessert,
        Drink,
    ];

    public function getDefinition():Dynamic return switch (cast this:CafeGoldenItem) {
        case Main: CafeGoldenMenu.CafeGoldenMain;
        case Dessert: CafeGoldenMenu.CafeGoldenDessert;
        case Drink: CafeGoldenMenu.CafeGoldenDrink;
    }
}

class CafeGoldenMenu {
    static function printNamePrice(item:{name:String, price:Int}):String {
        return item.name + " $" + item.price;
    }

    static final mains:Array<{name:String, price:Int, ?description:String}> = [
        {
            name: "黑松露雜菌意大利麵",
            price: 88
        },
        {
            name: "明太子魷魚蟹棒意大利麵",
            price: 88
        },
        {
            name: "蕃茄泡菜煙肉意大利麵🌶️",
            price: 98
        },
        {
            name: "青醬風乾火腿雜菌意大利麵",
            price: 108
        },
        {
            name: "海鮮叻沙意大利麵🌶️",
            price: 108
        },
        {
            name: "鮮蝦蟹棒海膽忌廉意大利麵",
            price: 118
        },
        {
            name: "芝士煙肉大啡菇配窩夫",
            price: 78
        },
        {
            name: "雞翼拼盤🌶️",
            price: 78
        },
        {
            name: "全份早餐",
            description: "黑松露炒蛋 田園沙律 蕃茄 直布羅陀腸 大啡菇 茄汁豆 煙肉 乳酪 吞拿魚沙律醬 窩夫",
            price: 128
        },
    ];

    static final desserts = [
        {
            name: "朱古力布朗尼杯 配伯爵茶忌廉&雲呢拿雪糕",
            price: 78,
        },
        {
            name: "黑糖蕨餅 配紅豆 小丸子 綠茶雪糕",
            price: 78,
        },
        {
            name: "什莓窩夫 配雲呢拿雪糕",
            price: 78,
        },
        {
            name: "什莓窩夫 配豆腐雪糕",
            price: 78,
        },
        {
            name: "什莓窩夫 配綠茶雪糕",
            price: 78,
        },        
    ];

    static final drinks = [
        {
            name: "短笛鮮奶咖啡",
            price: 42,
        },
        {
            name: "肥威鮮奶咖啡",
            price: 46,
        },
        {
            name: "熱美式黑咖啡",
            price: 42,
        },
        {
            name: "凍美式黑咖啡",
            price: 48,
        },
        {
            name: "熱蜜糖黑咖啡(無奶)",
            price: 46,
        },
        {
            name: "凍蜜糖黑咖啡(無奶)",
            price: 52,
        },
        {
            name: "熱意式泡沫咖啡",
            price: 46,
        },
        {
            name: "凍意式泡沫咖啡",
            price: 52,
        },
        {
            name: "熱意式鮮奶咖啡",
            price: 46,
        },
        {
            name: "凍意式鮮奶咖啡",
            price: 52,
        },
        {
            name: "熱摩卡咖啡",
            price: 48,
        },
        {
            name: "凍摩卡咖啡",
            price: 54,
        },
        {
            name: "熱榛子鮮奶咖啡",
            price: 48,
        },
        {
            name: "凍榛子鮮奶咖啡",
            price: 54,
        },
        {
            name: "熱焦糖鮮奶咖啡",
            price: 48,
        },
        {
            name: "凍焦糖鮮奶咖啡",
            price: 54,
        },
        {
            name: "Herbal Tea 蘋果山楂",
            price: 60,
        },
        {
            name: "Herbal Tea 洛神花玫瑰",
            price: 60,
        },
        {
            name: "Herbal Tea 桂花雪梨",
            price: 60,
        },
        {
            name: "Herbal Tea 桂圓百花茶",
            price: 60,
        },
        {
            name: "Herbal Tea 檸檬香茅薄荷",
            price: 60,
        },
        {
            name: "Herbal Tea 菊花杞子",
            price: 60,
        },
        {
            name: "熱鮮奶朱古力",
            price: 46,
        },
        {
            name: "凍鮮奶朱古力",
            price: 52,
        },
        {
            name: "熱伯爵茶朱古力",
            price: 50,
        },
        {
            name: "凍伯爵茶朱古力",
            price: 56,
        },
        {
            name: "梳打綠 (青瓜,青梅,薄荷葉,梳打)",
            price: 52,
        },
        {
            name: "荔枝梳打",
            price: 46,
        },
        {
            name: "柚子梳打",
            price: 46,
        },
        {
            name: "熱蜜糖青檸",
            price: 42,
        },
        {
            name: "凍蜜糖檸檬",
            price: 48,
        },
        {
            name: "熱京都宇治抹茶鮮奶",
            price: 46,
        },
        {
            name: "凍京都宇治抹茶鮮奶",
            price: 52,
        },
        {
            name: "熱竹炭黑芝麻鮮奶",
            price: 46,
        },
        {
            name: "凍竹炭黑芝麻鮮奶",
            price: 52,
        },
    ];

    static public final CafeGoldenMain = {
        title: "主食",
        type: "string",
        anyOf: mains.map(v -> {
            type: "string",
            title: switch (v.description) {
                case null: printNamePrice(v);
                case d: v.name + " (" + v.description + ") $" + v.price;
            },
            const: printNamePrice(v),
        }),
    };

    static public final CafeGoldenDessert = {
        title: "甜品",
        type: "string",
        "enum": desserts.map(printNamePrice),
    };

    static public final CafeGoldenDrink = {
        title: "飲品",
        properties: {
            drink: {
                title: "飲品",
                type: "string",
                "enum": drinks.map(printNamePrice),
            },
            options: {
                type: "array",
                title: "選項",
                items: {
                    type: "string",
                    "enum": [
                        "Coffee: Extra Shot +$4",
                        "Oat milk +$5",
                    ],
                },
                uniqueItems: true,
            },
        },
        required: [
            "drink",
        ]
    };

    static public function itemsSchema(order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: CafeGoldenItem.all.map(item -> {
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
                switch (cast item.type:CafeGoldenItem) {
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
        ?type:CafeGoldenItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case Drink:
                summarizeOrderObject(orderItem.item, def, ["drink", "options"]);
            case Main | Dessert:
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