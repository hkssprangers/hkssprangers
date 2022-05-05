package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
using Lambda;

enum abstract WoStreetItem(String) to String {
    final ClassicWaffle;
    final Cake;
    final CustomCake;
    final Drink;

    static public final all:ReadOnlyArray<WoStreetItem> = [
        ClassicWaffle,
        Cake,
        Drink,
        CustomCake,
    ];

    public function getDefinition():Dynamic return switch (cast this:WoStreetItem) {
        case ClassicWaffle: WoStreetMenu.WoStreetClassicWaffle;
        case Cake: WoStreetMenu.WoStreetCake;
        case CustomCake: WoStreetMenu.WoStreetCustomCake;
        case Drink: WoStreetMenu.WoStreetDrink;
    }
}

class WoStreetMenu {
    static public final WoStreetClassicWaffle = {
        title: "窩夫",
        type: "string",
        "enum": [
            "濃朱古力雪糕窩夫 $48",
            "白桃雪糕窩夫 $48",
            "荔枝雪糕窩夫 $48",
            "豆腐雪糕窩夫 $48",
            "薄荷曲奇雪糕窩夫 $48",
            "菠蘿雪糕窩夫 $48",
            "百香果雪糕窩夫 $48",
        ]
    };
    static public final WoStreetCake = {
        title: "芝士餅 (6吋切件)",
        type: "string",
        "enum": [
            "焦香巴斯克芝士餅 一件 $38", 
            "東京No1芝士餅 一件 $38",
            "紐約芝士餅 一件 $38",
            "藍莓芝士餅 一件 $38",
            "檸檬芝士餅 一件 $38",
        ]
    };
    static public final WoStreetCustomCake = {
        title: "手工蛋糕",
        description: "⚠️請於至少3日前預訂",
        properties: {
            main: {
                type: "string",
                title: "手工蛋糕",
                "enum": [
                    "真毛巾蛋糕半磅 [祝君安好] $98",
                    "真毛巾蛋糕半磅 [生辰快樂] $98",
                    "真毛巾蛋糕半磅 [生日快樂] $98",
                    "真毛巾蛋糕半磅 [Good Morning] $98",

                    "真毛巾蛋糕一磅 [生辰快樂 祝君安好] $196",
                    "真毛巾蛋糕一磅 [Good Morning 祝君安好] $196",

                    "東京第一芝士蛋糕4吋 $128",
                    "東京第一芝士蛋糕6吋 $160",

                    "巴斯克焦香芝士蛋糕4吋 $128",
                    "巴斯克焦香芝士蛋糕6吋 $168",

                    "紐約芝士餅4吋 $168",
                    "紐約芝士餅6吋 $188",

                    "小王子蛋糕 $188",
                    "特濃朱古力蛋糕 $298",
                    "芒果乳酪流心戚風蛋糕 $198",

                    "星空朱古力慕斯蛋糕6吋 $218",
                    "星空朱古力慕斯蛋糕8吋 $288",
                ],
            },
        },
        required: [
            "main",
        ],
    };
    static public final WoStreetDrink = {
        title: "飲品",
        type: "string",
        "enum": [
            "濃朱古力雪糕梳打 $38",
            "白桃雪糕梳打 $38",
            "荔枝雪糕梳打 $38",
            "豆腐雪糕梳打 $38",
            "薄荷曲奇雪糕梳打 $38",
            "菠蘿雪糕梳打 $38",
            "百香果雪糕梳打 $38",
            "冷泡玫瑰花茶 $20",
            "雜莓果凍梳打特飲 $38",
            "CBD少爺啤 全日愛爾 $40",
            "CBD少爺啤 淡愛爾 $40",
            "CBD少爺啤 DOUBLE $40",
            "支裝津路烏龍茶 $10",
            "罐裝可樂 $6",
            "罐裝芬達 $6",
            "罐裝雪碧 $6",
        ]
    };

    static public function itemsSchema(order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: WoStreetItem.all.map(item -> {
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
                switch (cast item.type:WoStreetItem) {
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
        ?type:WoStreetItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case ClassicWaffle | Cake | Drink:
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
            case CustomCake:
                summarizeOrderObject(orderItem.item, def, ["main"]);
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