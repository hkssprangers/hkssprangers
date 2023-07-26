package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract YearsHKItem(String) to String {
    final Set;
    final WeekdayLunchSet;
    final DinnerHolidaySet;
    final Single;

    static public function all(timeSlot:TimeSlot):ReadOnlyArray<YearsHKItem> {
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

    public function getDefinition():Dynamic return switch (cast this:YearsHKItem) {
        case Set: null;
        case WeekdayLunchSet: YearsHKMenu.YearsHKWeekdayLunchSet;
        case DinnerHolidaySet: YearsHKMenu.YearsHKDinnerHolidaySet;
        case Single: YearsHKMenu.YearsHKSingle;
    }
}

class YearsHKMenu {
    static function setDrinkItem(drink:String, price:Int):String {
        return drink + " +$" + Math.max(price - 12, 0);
    }

    static public final YearsHKSetDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "唔要",

            "熱⽞米茶 +$0",
            "凍伯爵茶 +$0",

            // 咖啡
            setDrinkItem("熱雙倍特濃咖啡", 28),
            setDrinkItem("熱⿊咖啡", 32),
            setDrinkItem("熱迷你燕麥奶咖啡", 34),
            setDrinkItem("熱泡沫咖啡", 36),
            setDrinkItem("熱燕麥奶咖啡", 36),
            setDrinkItem("熱朱古力咖啡", 42),

            setDrinkItem("凍⿊咖啡", 36),
            setDrinkItem("凍濃縮咖啡湯⼒", 40),
            setDrinkItem("凍美式咖啡梳打", 42),
            setDrinkItem("凍泡沫黑咖啡", 42),
            // 髒髒咖啡 只供堂食
            setDrinkItem("凍泡沫咖啡", 40),
            setDrinkItem("凍燕麥奶咖啡", 40),
            setDrinkItem("凍朱古力咖啡", 46),

            // 非咖啡
            setDrinkItem("熱抹茶燕麥奶", 40),
            setDrinkItem("熱焙茶燕麥奶", 40),
            setDrinkItem("熱黑糖黃薑燕麥奶", 40),
            setDrinkItem("熱朱古力", 42),
            setDrinkItem("熱海鹽焦糖朱古力", 44),

            setDrinkItem("凍抹茶燕麥奶", 44),
            setDrinkItem("凍焙茶燕麥奶", 44),
            setDrinkItem("凍朱古力", 46),

            // 養生特飲
            setDrinkItem("熱紅棗桂圓杞子玫瑰花茶", 48),
            setDrinkItem("熱洋甘菊杞子甘草茉莉花茶", 48),
            setDrinkItem("熱生薑紅棗桂圓柚子紫蘇茶", 48),
            setDrinkItem("熱黑糖黃薑紅南棗黃酒釀", 50),

            // ⽔果特飲
            setDrinkItem("凍藍莓黑提燕麥奶", 50),
            setDrinkItem("凍奇異果羽衣甘藍蘋果燕麥奶", 50),
            setDrinkItem("凍香蕉火龍果燕麥奶", 50),
            setDrinkItem("凍香橙芒果奇異果汁", 50),

            // 梳打特飲
            setDrinkItem("熱情果檸檬梳打", 42),
            setDrinkItem("芫茜檸檬梳打", 42),
            setDrinkItem("黑加侖子荔枝梳打", 42),
        ],
    };

    static public final YearsHKAddons = {
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

    static public final YearsHKWeekdayLunchSet = {
        title: "平日午市套餐",
        description: "🧄=五辛 🌶️=辛辣 🌰=果仁",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "夏日牛油果藍莓西瓜沙律 $88",
                    "四川麻辣春卷魚腐豆腐撈檬 🧄🌶️ $118",
                    "四川麻辣春卷魚腐豆腐撈檬 🧄🌶️ ⚠️走芫茜 $118",
                    "不可能肉醬意大利粉 🧄 $98",
                    "魚香茄子意大利粉 🌶️ $98",
                    "黑松露帶子意大利飯 $88",
                    "泰式香辣冬蔭意大利飯 🧄🌶️ $88",
                    "日式吉列豬扒咖喱意大利飯 🧄 $118",
                    "柚子青芒辣味吉列豬扒漢堡 🌶️ $138",
                    "柚子青芒辣味吉列豬扒漢堡 ⚠️走辣 $138",
                    "素年經典不可能芝士漢堡 🧄 $138",
                    "雙層芫荽不可能芝士漢堡 🧄 $138",
                ]
            },
            drink: YearsHKSetDrink,
            extraOptions: YearsHKAddons,
        },
        required: [
            "main",
            "drink",
        ]
    }

    static public final YearsHKDinnerHolidaySet = {
        title: "平日晚市／假日套餐",
        description: "🧄=五辛 🌶️=辛辣 🌰=果仁",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "夏日牛油果藍莓西瓜沙律 $88",
                    "四川麻辣春卷魚腐豆腐撈檬 🧄🌶️ $118",
                    "四川麻辣春卷魚腐豆腐撈檬 🧄🌶️ ⚠️走芫茜 $118",
                    "不可能肉醬意大利粉 🧄 $98",
                    "魚香茄子意大利粉 🌶️ $98",
                    "黑松露炸蝦帶子意大利飯 $128",
                    "泰式炸蝦香辣冬蔭意大利飯 🧄🌶️ $128",
                    "日式吉列豬扒咖喱意大利飯 🧄 $118",
                    "柚子青芒辣味吉列豬扒漢堡 🌶️ $138",
                    "柚子青芒辣味吉列豬扒漢堡 ⚠️走辣 $138",
                    "素年經典不可能芝士漢堡 🧄 $138",
                    "雙層芫荽不可能芝士漢堡 🧄 $138",
                ]
            },
            drink: YearsHKSetDrink,
            extraOptions: YearsHKAddons,
        },
        required: [
            "main",
            "drink",
        ]
    }

    static public final YearsHKSingle = {
        title: "單叫小食／甜品",
        description: "🧄=五辛 🌶️=辛辣 🌰=果仁",
        type: "string",
        "enum": [
            "泰式春卷配甜酸醬(4件) $48",
            "香芋番薯波波(8粒) $58",
            "黃金炸蝦配甜酸醬(4件) $58",
            "黃薑焗福花配自家製乳酪 $58",
            "番薯條配自家製黑松露蛋黃醬 $68",

            "檸檬熱情果撻 🌰 $58",
            "伯爵茶朱古力芝士蛋糕 🌰 $58",
        ],
    };

    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: YearsHKItem.all(pickupTimeSlot).map(item -> {
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
        var s = concatSummaries(formData.items.map(item -> summarizeItem(cast item)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}