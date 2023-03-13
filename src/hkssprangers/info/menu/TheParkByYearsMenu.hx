package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
using Lambda;

enum abstract TheParkByYearsItem(String) to String {
    final Set;
    final WeekdayLunchSet;
    final DinnerHolidaySet;
    final Single;

    static public function all(timeSlot:TimeSlot):ReadOnlyArray<TheParkByYearsItem> {
        if (timeSlot == null || timeSlot.start == null){
            return [];
        }

        // return [Set, Single];

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
        case Set: null;
        case WeekdayLunchSet: TheParkByYearsMenu.TheParkByYearsWeekdayLunchSet;
        case DinnerHolidaySet: TheParkByYearsMenu.TheParkByYearsDinnerHolidaySet;
        case Single: TheParkByYearsMenu.TheParkByYearsSingle;
    }
}

class TheParkByYearsMenu {
    static function setDrinkItem(drink:String, price:Int):String {
        return drink + " +$" + Math.max(price - 12, 0);
    }

    static public final TheParkByYearsSetDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "唔要",

            "熱⽞米茶 +$0",
            "凍伯爵茶 +$0",

            // 咖啡
            setDrinkItem("熱雙倍特濃咖啡", 28),
            setDrinkItem("熱瑪琪朵濃縮咖啡", 32),
            setDrinkItem("熱⿊咖啡", 32),
            setDrinkItem("熱迷你燕麥奶咖啡", 34),
            setDrinkItem("熱泡沫咖啡", 36),
            setDrinkItem("熱燕麥奶咖啡", 36),
            setDrinkItem("熱檸檬咖啡", 34),
            setDrinkItem("熱肉桂咖啡", 38),
            setDrinkItem("熱朱古力咖啡", 42),
            setDrinkItem("熱薄荷朱古力咖啡", 46),

            setDrinkItem("凍⿊咖啡", 36),
            setDrinkItem("凍泡沫咖啡", 40),
            setDrinkItem("凍燕麥奶咖啡", 40),
            setDrinkItem("凍朱古力咖啡", 46),
            setDrinkItem("凍薄荷朱古力咖啡", 50),
            // 髒髒咖啡 只供堂食
            setDrinkItem("凍香橙濃縮湯⼒", 40),
            setDrinkItem("凍泡沫⿊咖啡", 42),
            setDrinkItem("凍美式咖啡梳打", 42),
            setDrinkItem("凍泰式鴛鴦", 46),

            // 非咖啡
            setDrinkItem("熱泰式燕麥奶茶", 40),
            setDrinkItem("熱抹茶燕麥奶", 40),
            setDrinkItem("熱焙茶燕麥奶", 40),
            setDrinkItem("熱⿊芝⿇燕麥奶", 40),
            setDrinkItem("熱黑糖薑汁燕麥奶", 42),
            setDrinkItem("熱朱古力", 42),
            setDrinkItem("熱薄荷朱古力", 22),
            setDrinkItem("熱⾁桂可可", 46),

            setDrinkItem("凍泰式燕麥奶茶", 44),
            setDrinkItem("凍抹茶燕麥奶", 44),
            setDrinkItem("凍焙茶燕麥奶", 44),
            setDrinkItem("凍⿊芝⿇燕麥奶", 44),
            setDrinkItem("凍朱古力", 46),
            setDrinkItem("凍薄荷朱古力", 48),

            // 養⽣特飲
            setDrinkItem("熱⽣薑紫蘇葉茶", 48),
            setDrinkItem("熱玫瑰花茶", 48),
            setDrinkItem("熱蘋果洛神花茶", 48),
            setDrinkItem("熱檸檬茉莉花茶", 48),
            setDrinkItem("熱香橙桑⼦茶", 48),
            setDrinkItem("熱⽣薑柚⼦茶", 48),
            setDrinkItem("⿊糖⿈薑紅南棗⿈酒釀", 48),

            // ⽔果特飲
            setDrinkItem("凍香蕉火⿓果燕麥奶", 50),
            setDrinkItem("凍奇異果⽻衣⽢藍蘋果燕麥奶", 50),
            setDrinkItem("凍香蕉合桃焙茶燕麥奶", 50),
            setDrinkItem("凍奇異果血橙汁", 50),
            setDrinkItem("凍⽣薑菠蘿蘋果汁", 50),

            // 梳打特飲
            setDrinkItem("芫茜檸檬梳打", 42),
            setDrinkItem("鮮薑⻘檸梳打", 42),
            setDrinkItem("⻘森蘋果熱情果梳打", 42),
            setDrinkItem("奇異果血梳打", 42),
            setDrinkItem("柚⼦⻘瓜梳打", 42),
            setDrinkItem("薄荷雙檸梳打", 42),
            setDrinkItem("生酮⻘檸梳打", 42),
        ],
    };

    static public final TheParkByYearsAddons = {
        title: "加配",
        type: "array",
        items: {
            type: "string",
            "enum": [
                "沙律 +$28",
            ],
        },
        uniqueItems: true,
    };

    static public final TheParkByYearsWeekdayLunchSet = {
        title: "平日午市套餐",
        description: "🧄=五辛 🌶️=辛辣 🌰=果仁",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "麻辣荳包手撕雞髀菇飯 🌰🌶️ $88",
                    "日式照燒汁天貝飯 $88",
                    "椰香咖喱蕃薯野菜飯 $98",
                    "椰香咖喱蕃薯野菜飯 +手抓餅 $118",
                    "日式照燒汁不可能漢堡扒飯 🧄 $118",

                    "泰式秘製冬陰意⼤利粉 🌶️ $98",
                    "不可能肉醬意大利粉 🧄 $98",

                    "越式炸蝦魚腐豆腐撈檬 🌰🧄 $128",
                    "越式炸蝦魚腐豆腐撈檬 ⚠️走五辛 🌰 $128",
                    "泰式不可能生菜包 🌶️🧄 $128",

                    "日式照燒汁天貝漢堡 $118",
                    "日式照燒汁不可能漢堡 🧄 $138",
                    "素年經典不可能芝士漢堡 🧄 $138",
                    "雙層芫荽不可能芝士漢堡 🧄 $138",

                    "牛油果香橙三文魚南瓜沙律 $98",
                    "⽣酮牛油果野莓豆腐沙律 $98",

                    "日式三文⿂漬照燒豆腐定食 $158",
                    "日式三文⿂漬照燒豆腐定食 升級茶漬飯 $168",
                    "台式鹽酥杏鮑菇醬帶子定食 $158",
                    "台式鹽酥杏鮑菇醬帶子定食 升級茶漬飯 $168",
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
        description: "🧄=五辛 🌶️=辛辣 🌰=果仁",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "椰香咖喱蕃薯野菜飯 $98",
                    "椰香咖喱蕃薯野菜飯 +手抓餅 $118",
                    "日式照燒汁天貝黃金猴頭菇飯 $118",
                    "日式照燒汁不可能漢堡扒飯 🧄 $118",

                    "不可能肉醬意大利粉 🧄 $98",
                    "泰式秘製冬陰炸蝦意⼤利粉 🌶️ $118",

                    "越式炸蝦魚腐豆腐撈檬 🌰🧄 $128",
                    "越式炸蝦魚腐豆腐撈檬 ⚠️走五辛 🌰 $128",
                    "泰式不可能生菜包 🌶️🧄 $128",

                    "日式照燒汁天貝漢堡 $118",
                    "日式照燒汁不可能漢堡 🧄 $138",
                    "素年經典不可能芝士漢堡 🧄 $138",
                    "雙層芫荽不可能芝士漢堡 🧄 $138",

                    "牛油果香橙三文魚南瓜沙律 $98",
                    "⽣酮牛油果野莓豆腐沙律 $98",

                    "日式三文⿂漬照燒豆腐定食 $158",
                    "日式三文⿂漬照燒豆腐定食 升級茶漬飯 $168",
                    "台式鹽酥杏鮑菇醬帶子定食 $158",
                    "台式鹽酥杏鮑菇醬帶子定食 升級茶漬飯 $168",
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
        description: "🧄=五辛 🌶️=辛辣 🌰=果仁",
        type: "string",
        "enum": [
            "香芋番薯波波 (6粒) $48",
            "不可能黃金脆雞塊配自家製甜酸醬(6件) $58",
            "台式甘梅炸番薯條 $58",
            "炸旋風薯⽚ $58",
            "⽜油果冬陰醬墨⻄哥脆⽚ $58",

            "海鹽焦糖朱古⼒伯爵茶撻 🌰 $58",
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
        final def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case Set | WeekdayLunchSet | DinnerHolidaySet:
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
        final s = concatSummaries(formData.items.map(item -> summarizeItem(cast item)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}