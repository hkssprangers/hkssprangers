package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract TheParkByYearsItem(String) to String {
    final Set;
    final Single;

    static public final all:ReadOnlyArray<TheParkByYearsItem> = [
        Set,
        Single,
    ];

    public function getDefinition():Dynamic return switch (cast this:TheParkByYearsItem) {
        case Set: TheParkByYearsMenu.TheParkByYearsSet;
        case Single: TheParkByYearsMenu.TheParkByYearsSingle;
    }
}

class TheParkByYearsMenu {
    static public final TheParkByYearsSetDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "熱⽞⽶茶 (+$0)",
            "凍伯爵茶 (+$0)",

            "熱特濃咖啡 (+$24)",
            "熱雙倍特濃咖啡 (+$24)",
            "熱⿊咖啡 (+$24)",
            "熱迷你鮮奶咖啡 (+$24)",
            "熱泡沫咖啡 (+$24)",
            "熱鮮奶咖啡 (+$24)",
            "熱朱古力咖啡 (+$24)",

            "熱抹茶鮮奶 (+$24)",
            "熱焙茶鮮奶 (+$24)",
            "熱⿊芝⿇鮮奶 (+$24)",
            "熱黃薑鮮奶 (+$24)",
            "熱朱古力 (+$24)",

            "熱玫瑰花茶 (+$42)",
            "熱蘋果洛神花茶 (+$42)",
            "熱雪梨茶 (+$42)",

            "凍⿊咖啡 (+$28)",
            "凍泡沫咖啡 (+$28)",
            "凍鮮奶咖啡 (+$28)",
            "凍朱古力咖啡 (+$28)",
            "凍濃縮咖啡湯力 (+$28)",
            "凍泡沫⿊咖啡 (+$28)",

            "凍抹茶鮮奶 (+$28)",
            "凍焙茶鮮奶 (+$28)",
            "凍朱古力 (+$28)",

            "凍香蕉火⿓果燕麥奶 (+$36)",
            "凍⽊瓜⾁桂燕麥奶 (+$36)",
            "凍抹茶⽜油果燕麥奶 (+$36)",
            "凍奇異果蘋果菠菜汁 (+$36)",
            "凍⻄柚鮮橙菠蘿汁 (+$36)",

            "芫茜檸檬梳打 (+$28)",
            "鮮薑⻘檸梳打 (+$28)",
            "藍莓薰衣草梳打 (+$28)",
            "柚⼦⻘瓜梳打 (+$28)",

            "DEADMAN · 5000 YEARS (德國⽪爾森 | 5.2% | ⻘瓜) (+$58)",
            "DEADMAN · SEVEN SEAS (酸⻄柚 IPA | 7% | ⻄柚) (+$58)",
            "DEADMAN · HOP ROBBER (雙倍 IPA | 5.4% | 松⽊香味) (+$58)",

            "可樂 (+$10)",
            "雪碧 (+$10)",
            "梳打水 (+$10)",
        ],
    };

    static public final TheParkByYearsSet = {
        title: "套餐",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "⾁桂蘋果燕麥碗 (凍) $88",
                    "泰式香辣意⼤利粉 $88",
                    "四川擔擔意⼤利粉 $98",
                    "福建炒⽶形意粉 $88",
                    "⽜油果啤梨春⽇沙律 $108",
                    "⽣酮薑⿈椰菜花扒 $138",
                    "天婦羅⽶漢堡 $118",
                    "不可能芫茜芝⼠漢堡 $138",
                    "麻辣芫茜不可能漢堡 $138",
                    "⽵炭⿊芝麻班㦸 $148",
                ]
            },
            drink: TheParkByYearsSetDrink,
        },
        required: [
            "main",
            "drink",
        ]
    }

    static public final TheParkByYearsSingle = {
        title: "單叫小食／甜品",
        type: "string",
        "enum": [
            "炸香芋番薯丸 $48",
            "炸薯⽚配秘製蛋⿈醬 $58",
            "椒鹽椰菜花粒 $58",
            "香辣不可能⾁醬薯⽪ $58",
            "柚⼦海草沙律 $58",

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
                    oneOf: TheParkByYearsItem.all.map(item -> {
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
                switch (cast item.type:TheParkByYearsItem) {
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
        ?type:TheParkByYearsItem,
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