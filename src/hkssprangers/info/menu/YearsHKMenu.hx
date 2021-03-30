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
            "熱⿊⾖茶 (+$0)",
            "凍伯爵茶 (+$0)",
            "熱特濃咖啡 (+$24)",
            "熱雙倍特濃咖啡 (+$24)",
            "熱迷你鮮奶咖啡 (+$24)",
            "熱⿊咖啡 (+$24)",
            "熱泡沫咖啡 (+$24)",
            "熱鮮奶咖啡 (+$24)",
            "熱朱古力咖啡 (+$24)",
            "熱抹茶鮮奶 (+$24)",
            "熱焙茶鮮奶 (+$24)",
            "熱黃薑鮮奶 (+$24)",
            "熱朱古力 (+$24)",
            "熱玫瑰花茶 (+$42)",
            "熱菊花茶 (+$42)",
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
            "芫茜檸檬梳打 (+$36)",
            "可樂 (+$10)",
            "雪碧 (+$10)",
            "梳打水 (+$10)",
            "椰子水 (+$34)",
            "青檸接骨木花梳打 (+$24)",
            "西柚橙梳打 (+$24)",
            "熱情果檸檬梳打 (+$24)",
            "HEROES BEER · WING MAN (菠蘿味柏林⼩麥酸啤 | 3.5%) (+$58)",
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
                    "純素沙律碗 $78",
                    "香蒜芫茜意大利粉 $88",
                    "泡菜意⼤利粉 $88",
                    "不可能™⾁醬意⼤利粉 $88",
                    "胡⿇蘿蔔蓉三⾊螺絲粉 $88",
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
            "黃薑焗福花 $58",
            "黑松露蛋黃醬番薯條 $68",
            "香芋番薯波波 $58",
            "⽇式番茄漬 $58",
            "朱古⼒香蕉冧酒撻 $58",
            "綠茶⾖腐蛋糕 $58",
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
                            orderDetails: v,
                            orderPrice: v.parsePrice(),
                        }
                    case _:
                        {
                            orderDetails: "",
                            orderPrice: 0,
                        }
                }
            case _:
                {
                    orderDetails: "",
                    orderPrice: 0,
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