package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract YearsHKItem(String) to String {
    final Set;
    final Single;

    static public final all:ReadOnlyArray<YearsHKItem> = [
        Set,
        Single,
    ];

    public function getDefinition():Dynamic return switch (cast this:YearsHKItem) {
        case Set: YearsHKMenu.YearsHKSet;
        case Single: YearsHKMenu.YearsHKSingle;
    }
}

class YearsHKMenu {
    static public final YearsHKSetDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "熱⽞⽶茶 +$0",
            "凍伯爵茶 +$0",

            // 咖啡
            "熱特濃咖啡 +$26",
            "熱雙倍特濃咖啡 +$26",
            "熱⿊咖啡 +$26",
            "熱迷你燕麥奶咖啡 +$26",
            "熱泡沫咖啡 +$26",
            "熱燕麥奶咖啡 +$26",
            "熱朱古力咖啡 +$26",
            "熱桂花燕麥奶咖啡 +$26",

            "凍⿊咖啡 +$30",
            "凍濃縮咖啡湯⼒ +$30",
            "凍美式咖啡梳打 +$30",
            "凍泡沫黑咖啡 +$30",
            // "髒髒咖啡 +$30" // 只供堂食
            "凍泡沫咖啡 +$30",
            "凍燕麥奶咖啡 +$30",
            "凍朱古力咖啡 +$30",
            "凍桂花燕麥奶咖啡 +$30",

            // 非咖啡
            "熱抹茶燕麥奶 +$26",
            "熱焙茶燕麥奶 +$26",
            "熱⿈薑燕麥奶 +$26",
            "熱朱古力 +$26",
            "熱肉桂朱古力 +$26",

            "凍抹茶燕麥奶 +$30",
            "凍焙茶燕麥奶 +$30",
            "凍朱古力 +$30",

            // 花茶
            "熱玫瑰花茶 +$36",
            "熱洋甘菊花茶 +$36",
            "熱生薑檸檬茶 +$36",

            // ⽔果特飲
            "凍香蕉火龍果燕麥奶 +$38",
            "凍奇異果⽻衣⽢藍富⼠蘋果燕麥奶 +$38",
            "凍⿈薑香蕉燕麥奶 +$38",
            "凍菠蘿薑⻘瓜⻘檸蘋果汁 +$38",

            // 梳打特飲
            "熱情果檸檬梳打 +$30",
            "柚⼦⻘瓜梳打 +$30",
            "玫瑰荔枝梳打 +$30",
            "芫茜檸檬梳打 +$30",

            // 發酵茶
            "發酵茶 茉莉綠茶 +$50",
            "發酵茶 杞子薑綠茶 +$50",
            "發酵茶 黃薑熱情果茶 +$50",

            // COCKTAILS
            "CLASSIC MOJITO (⻘檸, 薄荷) +$80",
            "CINNAMON DARK RUM COFFEE (肉桂, 黑糖) +$80",

            // ⼿⼯啤酒
            "酉⿁啤酒 · ⼤三元 XPA (百香果 · ⽔果香| 4.4%) +$60",
            "酉⿁啤酒 · 芭樂鹽⼩麥 (微酸 · 番⽯榴 · 珊瑚礁鹽 | 5.2%) +$60",
            "酉⿁啤酒 · 戀夏365⽇ SAISON (溫和辛香 · 花香 | 5.5%) +$60",
        ],
    };

    static public final YearsHKSet = {
        title: "套餐",
        description: "🧄=garlic 🌶️=spicy 🌰=nuts",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "日式定食 $98",
                    "生酮牛油果純素沙律碗 🌰 $88",
                    "白酒香蒜乾番茄意大利粉 🧄 $88",
                    "白酒香蒜乾番茄意大利粉 ⚠️走五辛 $88",
                    "川味麻辣芫荽意大利粉 🧄🌶️ $88",
                    "川味麻辣芫荽意大利粉 🧄🌶️ ⚠️走芫荽 $88",
                    "不可能™️肉醬意大利粉 🧄🌰 $98",
                    "泰式⻘咖喱意大利飯 🧄🌶️ $88",
                    "泰式⻘咖喱意大利飯 🌶️ ⚠️走五辛 $88",
                    "經典芫荽意大利飯 🧄 $88",
                    "經典芫荽意大利飯 ⚠️走五辛 $88",
                    "日式咖喱吉列豬扒意大利飯 🧄 $118",
                    "日式燒汁豆腐竹炭漢堡包 $108",
                    "夏日版不可能™️漢堡包 🧄 $138",
                ]
            },
            drink: YearsHKSetDrink,
        },
        required: [
            "main",
            "drink",
        ]
    }

    static public final YearsHKSingle = {
        title: "單叫小食／甜品",
        description: "🧄=garlic 🌶️=spicy 🌰=nuts",
        type: "string",
        "enum": [
            "牛油果醬酸忌廉冬陰墨⻄哥脆片 🧄🌶️ $58",
            "香芋番薯波波 $58",
            "黃薑焗福花配自家製乳酪 $58",
            "黑松露蛋黃醬番薯條 $68",

            "香橙合桃布朗尼 🌰 $58",
            "焦糖燒菠蘿吉士撻 🌰 $58",
            "焦糖燒香蕉吉士撻 🌰 $58",
        ],
    };

    static public function itemsSchema(order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: YearsHKItem.all.map(item -> {
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
                switch (cast item.type:YearsHKItem) {
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
        ?type:YearsHKItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case Set:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"]);
            case Single:
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