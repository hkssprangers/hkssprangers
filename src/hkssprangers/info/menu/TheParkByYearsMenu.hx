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
            "熱⽞米茶 +$0",
            "凍伯爵茶 +$0",

            "熱特濃咖啡 +$24",
            "熱雙倍特濃咖啡 +$24",
            "熱⿊咖啡 +$24",
            "熱迷你燕麥奶咖啡 +$24",
            "熱泡沫咖啡 +$24",
            "熱燕麥奶咖啡 +$24",
            "熱朱古力咖啡 +$24",

            "熱抹茶燕麥奶 +$24",
            "熱焙茶燕麥奶 +$24",
            "熱⿊芝⿇燕麥奶 +$24",
            "熱黃薑燕麥奶 +$24",
            "熱朱古力 +$24",

            "熱玫瑰花茶 +$36",
            "熱蘋果洛神花茶 +$36",
            "熱雪梨茶 +$36",

            "凍⿊咖啡 +$28",
            "凍泡沫咖啡 +$28",
            "凍燕麥奶咖啡 +$28",
            "凍朱古力咖啡 +$28",
            "凍濃縮咖啡湯力 +$28",
            "凍泡沫⿊咖啡 +$28",

            "凍抹茶燕麥奶 +$28",
            "凍焙茶燕麥奶 +$28",
            "凍朱古力 +$28",

            "凍香蕉火⿓果燕麥奶 +$36",
            "凍奇異果⽻衣⽢藍富⼠蘋果燕麥奶 +$36",
            "凍抹茶⽜油果燕麥奶 +$36",
            "凍紅菜頭香蕉⿊加侖⼦汁 +$36",
            "凍⻄柚鮮橙菠蘿汁 +$36",

            "芫茜檸檬梳打 +$28",
            "鮮薑⻘檸梳打 +$28",
            "⻘森蘋果熱情果梳打 +$28",
            "柚⼦⻘瓜梳打 +$28",

            "發酵茶 原味 (茉莉花) +$48",
            "發酵茶 荔枝薑味 +$48",
            "發酵茶 ⼠多啤梨花椒味 +$48",

            "雞尾酒 GIN & TONIC +$78",
            "雞尾酒 GRAPEFRUIT GIN & TONIC +$78",
            "雞尾酒 CLASSIC MOJITO +$78",
            "雞尾酒 CUBA LIBRE +$78",
            "雞尾酒 SCREWDRIVER +$78",
            "雞尾酒 VODKA LIME +$78",
            
            "酉⿁啤酒 ⼤三元 XPA (百香果 · ⽔果香 | 4.4%) +$58",
            "酉⿁啤酒 芭樂鹽⼩麥 (微酸 · 番⽯榴 · 珊瑚礁鹽 | 5.2%) +$58",
            "酉⿁啤酒 戀夏365⽇ SAISON (溫和辛香 · 花香 | 5.5%) +$58",
        ],
    };

    static public final TheParkByYearsSet = {
        title: "套餐",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "雜錦野莓燕麥碗 $88",
                    "泰式冬陰功煙⽃粉 $98",
                    "⻘醬⻘芥末煙⽃粉 $88",
                    "⽜油果⻄瓜沙律 $118",
                    "⽣酮⽇式⼤阪燒 $148",
                    "酸忌廉焗雙⾊薯 $128",
                    "照燒茄⼦烤中東包 $128",
                    "不可能芫茜芝⼠漢堡 $138",
                    "泰式鴛鴦班㦸 $148",
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
            "梅⼦苦瓜漬 $58",
            "泰式⻘芒柚⼦沙律 $68",
            "香芒⽜油果他他配多⼠條 $88",

            "雲呢拿芝⼠撻 $58",
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