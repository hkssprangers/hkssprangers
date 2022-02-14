package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract TheParkByYearsItem(String) to String {
    final Set;
    final DinnerSet;
    final Single;
    final DinnerSingle;

    static public function all(timeSlotType:TimeSlotType):ReadOnlyArray<TheParkByYearsItem> return
        [
            Set,
            Single,
        ];

    public function getDefinition():Dynamic return switch (cast this:TheParkByYearsItem) {
        case Set: TheParkByYearsMenu.TheParkByYearsSet;
        case DinnerSet: TheParkByYearsMenu.TheParkByYearsDinnerSet;
        case Single: TheParkByYearsMenu.TheParkByYearsSingle;
        case DinnerSingle: TheParkByYearsMenu.TheParkByYearsDinnerSingle;
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
            "熱特濃咖啡 +$24",
            "熱雙倍特濃咖啡 +$24",
            "熱⿊咖啡 +$24",
            "熱迷你燕麥奶咖啡 +$24",
            "熱泡沫咖啡 +$24",
            "熱燕麥奶咖啡 +$24",
            "熱肉桂咖啡 +$24",
            "熱朱古力咖啡 +$24",

            "凍⿊咖啡 +$28",
            "凍泡沫咖啡 +$28",
            "凍燕麥奶咖啡 +$28",
            "凍朱古力咖啡 +$28",
            // "髒髒咖啡 +$28" // 只供堂食
            "凍濃縮咖啡湯力 +$28",
            "凍泡沫⿊咖啡 +$28",
            "凍美式咖啡梳打 +$28",

            // 非咖啡
            "熱泰式燕麥奶茶 +$24",
            "熱抹茶燕麥奶 +$24",
            "熱焙茶燕麥奶 +$24",
            "熱⿊芝⿇燕麥奶 +$24",
            "熱黑糖薑汁燕麥奶 +$24",
            "熱朱古力 +$24",
            "熱薄荷朱古力 +$24",

            "凍泰式燕麥奶茶 +$28",
            "凍抹茶燕麥奶 +$28",
            "凍焙茶燕麥奶 +$28",
            "凍朱古力 +$28",
            "凍薄荷朱古力 +$28",

            // 無糖花茶
            "熱⽣薑紫蘇葉茶 +$30",
            "熱玫瑰花茶 +$30",
            "熱蘋果洛神花茶 +$30",
            "熱檸檬茉莉花茶 +$30",
            "熱香橙桑⼦茶 +$30",

            // ⽔果特飲
            "凍香蕉火⿓果燕麥奶 +$36",
            "凍奇異果⽻衣⽢藍富⼠蘋果燕麥奶 +$36",
            "凍香蕉合桃焙茶燕麥奶 +$36",
            "凍紅菜頭香蕉⿊加侖⼦汁 +$36",
            "凍⻄柚鮮橙菠蘿汁 +$36",

            // 梳打特飲
            "芫茜檸檬梳打 +$28",
            "鮮薑⻘檸梳打 +$28",
            "⻘森蘋果熱情果梳打 +$28",
            "柚⼦⻘瓜梳打 +$28",

            // 發酵茶
            "發酵茶 茉莉綠茶 +$48",
            "發酵茶 杞子薑綠茶 +$48",
            "發酵茶 黃薑熱情果茶 +$48",

            // 雞尾酒
            "雞尾酒 GIN & TONIC +$78",
            "雞尾酒 VODKA LIME +$78",
            "雞尾酒 CLASSIC MOJITO +$78",
            "雞尾酒 CUBA LIBRE +$78",
            "雞尾酒 SCREWDRIVER +$78",
            "雞尾酒 STRAWBERRY RED WINE PUNCH +$78",
            
            // ⼿⼯啤酒
            "HEROES · 洛神花小麥 (洛神花| 5.1%) +$58",
            "HEROES · 是L但 (印度淡色艾爾啤酒 | 6.7%) +$58",
            "HEROES · KUPZZY (雙倍IPA | 7.8%) +$58",
        ],
    };

    static public final TheParkByYearsSet = {
        title: "套餐",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "牛油果紅菜頭蘋果沙律 $98",
                    "白酒香辣蒜片乾蕃茄意粉 $88",
                    "葡汁南瓜意粉 $88",
                    "香辣泰式意粉 $88",
                    "不可能™️肉醬意大利粉 $98",
                    "冬陰功意大利飯 $88",
                    "魚香茄子意大利飯 $98",
                    "麻辣芝士金磚多士 $118",
                    "不可能芫茜芝士漢堡 $138",
                    "節日特別版不可能漢堡 $148",
                ]
            },
            drink: TheParkByYearsSetDrink,
        },
        required: [
            "main",
            "drink",
        ]
    }

    static public final TheParkByYearsDinnerSet = {
        title: "晚市套餐",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "白酒香辣蒜片乾蕃茄意粉 $88",
                    "葡汁南瓜意粉 $88",
                    "香辣泰式意粉 $88",
                    "不可能™️肉醬意大利粉 $98",
                    "魚香茄子意大利飯 $98",
                    "冬陰功意大利飯 $88",
                    "牛油果紅菜頭蘋果沙律 $98",
                    "麻辣芝士金磚多士 $118",
                    "不可能芫茜芝士漢堡 $138",
                    "節日特別版不可能漢堡 $148",
                    "生酮日式大阪燒 $148",
                    "泰式珍珠奶茶班㦸 $148",
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
        title: "小食／甜品",
        type: "string",
        "enum": [
            "炸香芋番薯丸 $48",
            "炸蕃薯條 $58",
            "⽜油果醬酸忌廉冬陰墨⻄哥脆⽚ $58",
            "本地柚子菠菜白蘿蔔漬 $58",

            "焦糖脆脆檸檬撻 $58",
            "雲呢拿芝⼠撻 $58",
        ],
    };

    static public final TheParkByYearsDinnerSingle = {
        title: "晚市小食／甜品",
        type: "string",
        "enum": [
            "炸香芋番薯丸 $48",
            "炸蕃薯條 $58",
            "⽜油果醬酸忌廉冬陰墨⻄哥脆⽚ $58",
            "本地柚子菠菜白蘿蔔漬 $58",

            "焦糖脆脆檸檬撻 $58",
            // "朱古⼒香蕉冧酒撻 $58", //未返貨
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
            case Set | DinnerSet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"]);
            case Single | DinnerSingle:
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