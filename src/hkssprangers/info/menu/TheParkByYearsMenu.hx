package hkssprangers.info.menu;

import hkssprangers.info.menu.FormOrderData;
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
            "熱⽞米茶 (+$0)",
            "凍⿊⾖茶 (+$0)",
            "熱特濃咖啡 (+$24)",
            "熱雙倍特濃咖啡 (+$24)",
            "熱迷你鮮奶咖啡 (+$24)",
            "熱⿊咖啡 (+$24)",
            "熱泡沫咖啡 (+$24)",
            "熱鮮奶咖啡 (+$24)",
            "熱朱古力咖啡 (+$24)",
            "熱抹茶鮮奶 (+$24)",
            "熱焙茶鮮奶 (+$24)",
            "熱⿊芝⿇鮮奶 (+$24)",
            "熱黃薑鮮奶 (+$24)",
            "熱朱古力 (+$24)",
            "熱玫瑰花茶 (+$42)",
            "熱菊花茶 (+$42)",
            "熱雪梨茶 (+$42)",
            "凍⿊咖啡 (+$28)",
            "凍泡沫咖啡 (+$28)",
            "凍鮮奶咖啡 (+$28)",
            "凍朱古力咖啡 (+$28)",
            "凍濃縮咖啡湯力 (+$28)",
            "凍抹茶鮮奶 (+$28)",
            "凍焙茶鮮奶 (+$28)",
            "凍朱古力 (+$28)",
            "凍香蕉火龍果燕麥奶 (+$36)",
            "凍藍莓黑提子燕麥奶 (+$36)",
            "凍奇異果羽衣甘藍富士蘋果燕麥奶 (+$36)",
            "凍紅菜頭富士蘋果檸檬燕麥奶 (+$36)",
            "凍芒果雪梨菠蘿燕麥奶 (+$36)",
            "凍⽜油果燕麥奶 (+$36)",
            "凍芫茜檸檬梳打 (+$36)",
            "可樂 (+$10)",
            "雪碧 (+$10)",
            "梳打水 (+$10)",
            "椰子水 (+$34)",
            "青檸接骨木花梳打 (+$24)",
            "西柚橙梳打 (+$24)",
            "熱情果檸檬梳打 (+$24)",
            "HEROES BEER · KUPZZY(⼩麥啤 | 7.8%) (+$58)",
            "HEROES BEER · CAPTAIN PSYKICK (冷泡酒花⽪爾森啤酒| 4.8%) (+$58)",
            "HEROES BEER · WING MAN (菠蘿味柏林⼩麥酸啤 | 3.5%) (+$58)",
        ],
    };

    static public final TheParkByYearsSet = {
        title: "套餐",
        properties: {
            main: {
                title: "主食選擇",
                type: "string",
                "enum": [
                    "⾁桂蘋果燕麥碗 (暖食) $88",
                    "泰式炒米形意粉 $88",
                    "椰菜花米形意粉 $88",
                    "越式三⽂治 $108",
                    "夏威夷沙律碗 $108",
                    "泰式不可能⽟米夾餅 $108",
                    "⽵炭野菌包 $108",
                    "不可能漢堡包 (芫茜版) $138",
                    "⻄班牙全⽇早餐 $148",
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
        title: "單叫小食/甜品",
        type: "string",
        "enum": [
            "炸薯片配秘製蛋黃醬 $58",
            "柚⼦海草沙律 $58",
            "炸香芋番薯丸 $58",
            "印度香料焗福花 $58",
            "朱古⼒香蕉冧酒撻 $58",
            "紫薯香芋撻 $58",
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
            items: order.items == null ? [] : order.items.map(item -> {
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
}