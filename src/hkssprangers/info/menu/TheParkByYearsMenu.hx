package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract TheParkByYearsItem(String) to String {
    final WeekdayLunchSet;
    final DinnerHolidaySet;
    final Single;

    static public function all(timeSlot:TimeSlot):ReadOnlyArray<TheParkByYearsItem> {
        if (timeSlot == null || timeSlot.start == null){
            return [];
        }
        return switch [Weekday.fromDay(timeSlot.start.toDate().getDay()), HkHolidays.isRedDay(timeSlot.start.toDate()), TimeSlotType.classify(timeSlot.start)] {
            case [Monday | Tuesday | Wednesday | Thursday | Friday, false, Lunch]:
                [
                    WeekdayLunchSet,
                    Single,
                ];
            case _:
                [
                    DinnerHolidaySet,
                    Single,
                ];
        }
    }

    public function getDefinition():Dynamic return switch (cast this:TheParkByYearsItem) {
        case WeekdayLunchSet: TheParkByYearsMenu.TheParkByYearsWeekdayLunchSet;
        case DinnerHolidaySet: TheParkByYearsMenu.TheParkByYearsDinnerHolidaySet;
        case Single: TheParkByYearsMenu.TheParkByYearsSingle;
    }
}

class TheParkByYearsMenu {
    static public final TheParkByYearsSetDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "唔要",

            "熱⽞米茶 +$0",
            "凍伯爵茶 +$0",

            // 咖啡
            "熱雙倍特濃咖啡 +$26",
            "熱瑪琪朵濃縮咖啡 +$26",
            "熱⿊咖啡 +$26",
            "熱迷你燕麥奶咖啡 +$26",
            "熱泡沫咖啡 +$26",
            "熱燕麥奶咖啡 +$26",
            "熱檸檬咖啡 +$26",
            "熱肉桂咖啡 +$26",
            "熱朱古力咖啡 +$26",
            "熱薄荷朱古力咖啡 +$26",

            "凍⿊咖啡 +$30",
            "凍泡沫咖啡 +$30",
            "凍燕麥奶咖啡 +$30",
            "凍朱古力咖啡 +$30",
            "凍薄荷朱古力咖啡 +$30",
            // "髒髒咖啡 +$30" // 只供堂食
            "凍香橙濃縮湯⼒ +$30",
            "凍泡沫⿊咖啡 +$30",
            "凍美式咖啡梳打 +$30",
            "凍泰式鴛鴦 +$30",

            // 非咖啡
            "熱泰式燕麥奶茶 +$26",
            "熱抹茶燕麥奶 +$26",
            "熱焙茶燕麥奶 +$26",
            "熱⿊芝⿇燕麥奶 +$26",
            "熱黑糖薑汁燕麥奶 +$26",
            "熱朱古力 +$26",
            "熱薄荷朱古力 +$26",
            "熱⾁桂可可 +$26",

            "凍泰式燕麥奶茶 +$30",
            "凍抹茶燕麥奶 +$30",
            "凍焙茶燕麥奶 +$30",
            "凍朱古力 +$30",
            "凍薄荷朱古力 +$30",

            // 養⽣特飲
            "熱⽣薑紫蘇葉茶 +$36",
            "熱玫瑰花茶 +$36",
            "熱蘋果洛神花茶 +$36",
            "熱檸檬茉莉花茶 +$36",
            "熱香橙桑⼦茶 +$36",
            "熱⽣薑柚⼦茶 +$36",
            "⿊糖⿈薑紅南棗⿈酒釀 +$36",

            // ⽔果特飲
            "凍香蕉火⿓果燕麥奶 +$38",
            "凍奇異果⽻衣⽢藍蘋果燕麥奶 +$38",
            "凍香蕉合桃焙茶燕麥奶 +$38",
            "凍紅菜頭香蕉⿊加侖⼦汁 +$38",
            "凍⽣薑菠蘿蘋果汁 +$38",

            // 梳打特飲
            "芫茜檸檬梳打 +$30",
            "鮮薑⻘檸梳打 +$30",
            "⻘森蘋果熱情果梳打 +$30",
            "柚⼦⻘瓜梳打 +$30",
            "薄荷雙檸梳打 +$30",
            "生酮⻘檸梳打 +$30",

            // 發酵茶
            "發酵茶 ⻄瓜紫蘇綠茶 +$50",
            "發酵茶 鹹檸綠茶 +$50",
            "發酵茶 ⿈薑熱情果綠茶 +$50",

            // 雞尾酒
            "雞尾酒 IRISH COFFEE +$68",
            "雞尾酒 GIN & TONIC +$80",
            "雞尾酒 VODKA LIME +$80",
            "雞尾酒 CLASSIC MOJITO +$80",
            
            // ⼿⼯啤酒
            "HEROES · PILSNER (花香, 檸檬, 麥芽 | 4.8%) +$60",
            "HEROES · 茉莉香⽚⼩麥啤 (茉莉, 柑橘 | 6.7%) +$60",
            "HEROES · CEREUSLY (雙倍IPA | 6.2%) +$60",
            "酉⿁啤酒 · 戀夏365⽇ SAISON (溫和辛香 · 花香 | 5.5%) +$60",
        ],
    };

    static public final TheParkByYearsAddons = {
        title: "加配",
        type: "array",
        items: {
            type: "string",
            "enum": [
                "炸香芋番薯丸 (3粒) +$24",
                "泰式炸蝦配酸辣醬 (2隻) +$30",
                "腰果中華沙律腐皮壽司 (2件) 🌰 +$32",
                "炸旋風薯⽚ +$36",
                "炸番薯條 +$36",
            ],
        },
        uniqueItems: true,
    };

    static public final TheParkByYearsWeekdayLunchSet = {
        title: "平日午市套餐",
        description: "🧄=garlic 🌶️=spicy 🌰=nuts",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "泰式秘製冬陰意⼤利粉 🌶️ $88",
                    "香辣⽩酒香蒜乾番茄意大利粉 🧄🌶️ $88",
                    "香辣⽩酒香蒜乾番茄意大利粉 ⚠️走五辛 🌶️ $88",

                    "煙燻天⾙鮮菠蘿漢堡包 +炸旋風薯⽚ 🌶️ $128",
                    "煙燻天⾙鮮菠蘿漢堡包 +炸旋風薯⽚ ⚠️走辣 $128",
                    "素年經典不可能芝士漢堡包 +炸旋風薯⽚ 🧄 $138",
                    "雙層芫荽不可能芝士漢堡包 +炸旋風薯⽚ 🧄 $138",

                    "夏威夷三文⿂香芒沙律碗 $98",
                    "夏威夷三文⿂香芒沙律碗 升級蓋飯碗 $108",
                    "夏威夷野莓豆腐沙律碗 (⽣酮) $98",
                    "泰式⻘咖喱椰香野菜⾖腐伴藜麥飯 🌶️ $98",
                    "泰式⻘咖喱椰香野菜⾖腐伴藜麥飯 追加⼿抓餅 🌶️ $118",
                    "⽇式照燒豆腐串燒三⽂⿂刺身定食 $98",
                    "⽇式照燒豆腐串燒三⽂⿂刺身定食 升級茶漬飯 $108",
                    "台式醬帶⼦烤⿂腐豆腐定食 $108",

                    "聖誕版日式照燒豆腐串燒三文⿂刺⾝定食 $148",
                    "聖誕版日式照燒豆腐串燒三文⿂刺⾝定食 升級茶漬飯 $158",
                    "聖誕版台式鹽酥杏鮑菇醬帶子定食 $148",
                    "酸種⾙果焦糖香蕉牛油果全日早餐 +炸旋風薯⽚ $148",
                ],
            },
            drink: TheParkByYearsSetDrink,
            extraOptions: TheParkByYearsAddons,
        },
        required: [
            "main",
            "drink",
        ]
    }

    static public final TheParkByYearsDinnerHolidaySet = {
        title: "平日晚市／假日套餐",
        description: "🧄=garlic 🌶️=spicy 🌰=nuts",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "泰式冬陰意大利粉 🌶️ $88",
                    "香辣⽩酒香蒜乾番茄意大利粉 🧄🌶️ $88",
                    "香辣⽩酒香蒜乾番茄意大利粉 ⚠️走五辛 🌶️ $88",

                    "煙燻天⾙鮮菠蘿漢堡包 +炸旋風薯⽚ 🌶️ $128",
                    "煙燻天⾙鮮菠蘿漢堡包 +炸旋風薯⽚ ⚠️走辣 $128",
                    "素年經典不可能芝士漢堡包 +炸旋風薯⽚ 🧄 $138",
                    "雙層芫荽不可能芝士漢堡包 +炸旋風薯⽚ 🧄 $138",

                    "夏威夷三文⿂香芒沙律碗 $98",
                    "夏威夷三文⿂香芒沙律碗 升級蓋飯碗 $108",
                    "夏威夷野莓豆腐沙律碗 (⽣酮) $98",
                    "泰式⻘咖喱椰香野菜⾖腐伴藜麥飯 🌶️ $98",
                    "泰式⻘咖喱椰香野菜⾖腐伴藜麥飯 追加⼿抓餅 🌶️ $118",

                    "聖誕版日式照燒豆腐串燒三文⿂刺⾝定食 $148",
                    "聖誕版日式照燒豆腐串燒三文⿂刺⾝定食 升級茶漬飯 $158",
                    "聖誕版台式鹽酥杏鮑菇醬帶子定食 $148",
                    "酸種⾙果焦糖香蕉牛油果全日早餐 +炸旋風薯⽚ $148",
                ],
            },
            drink: TheParkByYearsSetDrink,
            extraOptions: TheParkByYearsAddons,
        },
        required: [
            "main",
            "drink",
        ]
    }

    static public final TheParkByYearsSingle = {
        title: "單叫小食／甜品",
        description: "🧄=garlic 🌶️=spicy 🌰=nuts",
        type: "string",
        "enum": [
            "香芋番薯波波 (6粒) $48",
            "泰式炸蝦配酸辣醬 (4隻) $58",
            "⽜油果酸忌廉冬陰墨⻄哥脆⽚ $58",
            "炸旋風薯⽚ $58",
            "台式甘梅炸番薯條 $58",

            "抹茶紅⾖麻糬奇亞籽布甸 $58",
            "海鹽焦糖朱古⼒伯爵茶撻 🌰 $58",
            // "鴛鴦特濃咖啡雪糕 $58",
            "香蕉蛋糕配焦糖香蕉 🌰 $68",
        ],
    };

    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: TheParkByYearsItem.all(pickupTimeSlot).map(item -> {
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
            case WeekdayLunchSet | DinnerHolidaySet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink", "extraOptions"]);
            case Single:
                switch (orderItem.item:Null<String>) {
                    case v if (Std.isOfType(v, String)):
                        {
                            orderDetails: fullWidthDot + "單叫" + fullWidthColon + v,
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