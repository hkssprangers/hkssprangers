package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract TheParkByYearsItem(String) to String {
    final Set;
    final Single;

    static public function all(timeSlotType:TimeSlotType):ReadOnlyArray<TheParkByYearsItem> return
        [
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

            // 咖啡
            "熱特濃咖啡 +$26",
            "熱雙倍特濃咖啡 +$26",
            "熱⿊咖啡 +$26",
            "熱迷你燕麥奶咖啡 +$26",
            "熱泡沫咖啡 +$26",
            "熱燕麥奶咖啡 +$26",
            "熱肉桂咖啡 +$26",
            "熱朱古力咖啡 +$26",

            "凍⿊咖啡 +$30",
            "凍泡沫咖啡 +$30",
            "凍燕麥奶咖啡 +$30",
            "凍朱古力咖啡 +$30",
            // "髒髒咖啡 +$30" // 只供堂食
            "凍濃縮咖啡湯力 +$30",
            "凍泡沫⿊咖啡 +$30",
            "凍美式咖啡梳打 +$30",

            // 非咖啡
            "熱泰式燕麥奶茶 +$26",
            "熱抹茶燕麥奶 +$26",
            "熱焙茶燕麥奶 +$26",
            "熱⿊芝⿇燕麥奶 +$26",
            "熱黑糖薑汁燕麥奶 +$26",
            "熱朱古力 +$26",
            "熱薄荷朱古力 +$26",

            "凍泰式燕麥奶茶 +$30",
            "凍抹茶燕麥奶 +$30",
            "凍焙茶燕麥奶 +$30",
            "凍朱古力 +$30",
            "凍薄荷朱古力 +$30",

            // 無糖花茶
            "熱⽣薑紫蘇葉茶 +$36",
            "熱玫瑰花茶 +$36",
            "熱蘋果洛神花茶 +$36",
            "熱檸檬茉莉花茶 +$36",
            "熱香橙桑⼦茶 +$36",

            // ⽔果特飲
            "凍香蕉火⿓果燕麥奶 +$38",
            "凍奇異果⽻衣⽢藍富⼠蘋果燕麥奶 +$38",
            "凍香蕉合桃焙茶燕麥奶 +$38",
            "凍紅菜頭香蕉⿊加侖⼦汁 +$38",
            "凍⻄柚鮮橙菠蘿汁 +$38",

            // 梳打特飲
            "芫茜檸檬梳打 +$30",
            "鮮薑⻘檸梳打 +$30",
            "⻘森蘋果熱情果梳打 +$30",
            "柚⼦⻘瓜梳打 +$30",
            "生酮⻘檸梳打 +$30",

            // 發酵茶
            "發酵茶 茉莉綠茶 +$50",
            "發酵茶 杞子薑綠茶 +$50",
            "發酵茶 黃薑熱情果茶 +$50",

            // 雞尾酒
            "雞尾酒 GIN & TONIC +$80",
            "雞尾酒 VODKA LIME +$80",
            "雞尾酒 CLASSIC MOJITO +$80",
            "雞尾酒 CUBA LIBRE +$80",
            "雞尾酒 SCREWDRIVER +$80",
            "雞尾酒 STRAWBERRY RED WINE PUNCH +$80",
            
            // ⼿⼯啤酒
            "HEROES · 洛神花小麥 (洛神花| 5.1%) +$60",
            "HEROES · 是L但 (印度淡色艾爾啤酒 | 6.7%) +$60",
            "HEROES · KUPZZY (雙倍IPA | 7.8%) +$60",
        ],
    };

    static public final TheParkByYearsSet = {
        title: "套餐",
        description: "🧄=garlic 🌶️=spicy 🌰=nuts GF=gluten-free",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "⽜油果⻄瓜藜麥沙律 🌰GF $98",
                    "忌廉蘑菇⽩汁菠菜長通粉 🌰🧄 $88",
                    "忌廉蘑菇⽩汁菠菜長通粉 🌰 ⚠️走五辛 $88",
                    "墨⻄哥煙燻不可能辣⾁長通粉 🧄🌶️ $98",
                    "墨⻄哥煙燻不可能辣⾁長通粉 🧄 ⚠️走辣 $98",
                    "泰式⻘咖喱椰香野菜⾖腐伴藜麥飯 🌶️GF $98",
                    "泰式⻘咖喱椰香野菜⾖腐伴藜麥飯 加⼿抓餅  🌶️GF $118",
                    "夏威夷三⽂⿂香芒蓋飯碗 GF (暖食) $108",
                    "夏威夷野莓⾖腐沙律碗 GF (暖食, ⽣酮) $108",
                    "夏⽇煙燻天⾙鮮菠蘿⽵炭漢堡 🌶️ $128",
                    "夏⽇煙燻天⾙鮮菠蘿⽵炭漢堡 ⚠️走辣 $128",
                    "素年經典不可能芝⼠漢堡 🧄 $138",
                    "⾃家製芫荽⻘醬不可能漢堡 🌰🧄 $148",
                    "⽣酮⽇式⼤阪燒 GF $148",
                ],
            },
            drink: TheParkByYearsSetDrink,
        },
        required: [
            "main",
            "drink",
        ]
    }

    static public final TheParkByYearsSingle = {
        title: "小食／甜品",
        description: "🧄=garlic 🌶️=spicy 🌰=nuts GF=gluten-free",
        type: "string",
        "enum": [
            "炸香芋番薯丸 (6粒) $48",
            "台式⽢梅炸蕃薯條 GF $58",
            "泰式泡椒珊瑚草沙律 🌶️GF $58",
            "⽜油果醬墨⻄哥芝⼠夾餅(2件) 🌶️ $68",
            "⽜油果醬墨⻄哥芝⼠夾餅(2件) ⚠️走辣 $68",
            "法式香草野菜蒜蓉多⼠(3件) 🧄 $68",
            "法式香草野菜蒜蓉多⼠(3件) ⚠️走五辛 $68",
            "法式香草野菜蒜蓉⽣菜包(⽣酮) 🧄 $68",
            "法式香草野菜蒜蓉⽣菜包(⽣酮) ⚠️走五辛 $68",

            "生酮小山園抹茶奇亞籽布甸 GF $58",
            "香蕉蛋糕配焦糖香蕉 🌰 $68",
            "香橙合桃布朗尼 🌰GF $58",
        ],
    };

    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: TheParkByYearsItem.all(TimeSlotType.classify(pickupTimeSlot.start)).map(item -> {
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