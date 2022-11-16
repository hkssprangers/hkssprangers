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
            "唔要",

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
            "熱黑糖黃薑燕麥奶 +$26",
            "熱朱古力 +$26",
            "熱肉桂朱古力 +$26",
            "熱海鹽焦糖朱古力 +$26",

            "凍抹茶燕麥奶 +$30",
            "凍焙茶燕麥奶 +$30",
            "凍朱古力 +$30",

            // 養生特飲
            "熱玫瑰花茶 +$36",
            "熱洋甘菊菊花茶 +$36",
            "熱生薑柚子紫蘇茶 +$36",
            "熱黑糖黃薑紅南棗黃酒釀 +$36",

            // ⽔果特飲
            "凍木瓜紅棗燕麥奶 +$38",
            "凍奇異果羽衣甘藍蘋果燕麥奶 +$38",
            "凍香蕉血橙紅菜頭燕麥奶 +$38",
            "凍黑芝麻香蕉燕麥奶 +$38",
            "凍生薑菠蘿蘋果汁 +$38",

            // 梳打特飲
            "熱情果檸檬梳打 +$30",
            "芫茜檸檬梳打 +$30",
            "蝶豆花接骨木花⻘檸梳打 +$30",

            // 發酵茶
            "發酵茶 ⻄瓜紫蘇綠茶 +$50",
            "發酵茶 鹹檸綠茶 +$50",
            "發酵茶 黃薑熱情果綠茶 +$50",

            // COCKTAILS
            "IRISH COFFEE +$68",
            "ESPRESSO MARTINI +$68",
            "THE DAVID MARTINEZ +$68",

            // ⼿⼯啤酒
            "HEROES · PILSNER (花香,檸檬,麥芽|4.8%) +$60",
            "HEROES · 茉莉香片小麥啤 (茉莉,柑橘|6.7%) +$60",
            "HEROES · CEREUSLY (雙倍IPA|6.2%) +$60",
            "酉鬼啤酒 · 戀夏365日 SAISON (溫和辛香·花香|5.5%) +$60",
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
                    "日式精選定食 $98",
                    "生酮牛油果豆腐純素沙律碗 🌰 $88",
                    "泰式香辣意大利粉 🧄🌶️🌰 $88",
                    "泰式香辣意大利粉 ⚠️走五辛 🌶️🌰 $88",
                    "四川擔擔意大利粉 🧄🌶️🌰 $98",
                    "四川擔擔意大利粉 ⚠️走五辛 🌶️🌰 $98",
                    "不可能™️肉醬意大利粉 🧄🌰 $98",
                    "泰式冬陰意大利飯 🧄🌶️ $88",
                    "紅菜頭香橙意大利飯 🧄 $88",
                    "日式咖喱吉列豬扒意大利飯 🧄 $118",
                    "照燒茄子配秘製冬陰醬漢堡包 🧄🌶️ $108",
                    "照燒茄子配秘製冬陰醬漢堡包 ⚠️走五辛 🌶️ $108",
                    "素年經典不可能™️芝士漢堡包 🧄 $138",
                    "雙層芫荽不可能™️芝士漢堡包 🧄 $138",
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
            "香芋番薯波波 $58",
            "黃薑焗福花配自家製乳酪 $58",
            "泰式炸蝦配酸辣醬 🧄 $68",
            "黑松露蛋黃醬番薯條 $68",

            "絹豆腐豆乳忌廉柚子蛋糕 🌰 $58",
            "海鹽焦糖朱古力伯爵茶撻 🌰 $58",
            "雪山士多啤梨撻(限量供應) 🌰 $58",
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