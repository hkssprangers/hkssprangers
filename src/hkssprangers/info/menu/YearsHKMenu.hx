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

            "熱特濃咖啡 +$24",
            "熱雙倍特濃咖啡 +$24",
            "熱迷你燕麥奶咖啡 +$24",
            "熱⿊咖啡 +$24",
            "熱泡沫咖啡 +$24",
            "燕麥奶咖啡 +$24",
            "熱朱古力咖啡 +$24",

            "熱抹茶燕麥奶 +$24",
            "熱焙茶燕麥奶 +$24",
            "熱⿈薑燕麥奶 +$24",
            "熱朱古力 +$24",

            "熱玫瑰花茶 +$36",
            "熱菊花茶 +$36",

            "凍⿊咖啡 +$28",
            "凍濃縮咖啡湯⼒ +$28",
            "凍泡沫咖啡 +$28",
            "凍燕麥奶咖啡 +$28",
            "凍⻘瓜燕麥奶咖啡 +$28",
            "凍朱古力咖啡 +$28",

            "凍抹茶燕麥奶 +$28",
            "凍焙茶燕麥奶 +$28",
            "凍朱古力 +$28",

            "凍香蕉火龍果燕麥奶 +$36",
            "凍奇異果⽻衣⽢藍富⼠蘋果燕麥奶 +$36",
            "凍⿈薑香蕉燕麥奶 +$36",
            "凍菠蘿薑⻘瓜⻘檸蘋果汁 +$36",

            "熱情果檸檬梳打 +$24",
            "柚⼦⻘瓜梳打 +$24",
            "香茅薄荷⻘檸梳打 +$24",
            "芫茜檸檬梳打 +$24",

            "發酵茶 原味 (茉莉花) +$48",
            "發酵茶 荔枝薑味 +$48",
            "發酵茶 ⼠多啤梨花椒味 +$48",

            "燒酎雞尾酒 SALTED SUMMER MADNESS (雪碧, 橙汁, 迷迭香) +$68",
            "燒酎雞尾酒 CREAMY COFFEE LOVER (榛⼦, ⿊糖) +$68",

            "酉⿁啤酒 · ⼤三元 XPA (百香果 · ⽔果香| 4.4%) +$58",
            "酉⿁啤酒 · 芭樂鹽⼩麥 (微酸 · 番⽯榴 · 珊瑚礁鹽 | 5.2%) +$58",
            "酉⿁啤酒 · 戀夏365⽇ SAISON (溫和辛香 · 花香 | 5.5%) +$58",

            "可樂 +$10",
            "雪碧 +$10",
            "梳打水 +$10",
            "椰子水 +$34",
        ],
    };

    static public final YearsHKSet = {
        title: "套餐",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "日式定食 $88",
                    "⽣酮純素沙律碗 $88",
                    "腐乳意⼤利粉 $88",
                    "香茅意⼤利粉 $88",
                    "⾁燥米形意粉 $98",
                    "芫茜意⼤利飯 $88",
                    "冬陰意⼤利飯 $88",
                    "⽇式咖喱吉列豬扒意⼤利飯 $108",
                    "⾖腐⽵炭漢堡包 $98",
                    "不可能™️漢堡包 $128",
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
        type: "string",
        "enum": [
            "芥籽香蒜烤⼤啡菇 $48",
            "香芋番薯波波 $58",
            "⿈薑焗福花 $58",
            "⿊松露蛋黃醬番薯條 $68",

            "朱古⼒香蕉冧酒撻 $58",
            "焦糖脆脆檸檬撻 $58",
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