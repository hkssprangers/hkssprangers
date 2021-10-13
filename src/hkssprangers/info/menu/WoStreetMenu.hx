package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
using Lambda;

enum abstract WoStreetItem(String) to String {
    final WaffleBurger;
    final ClassicWaffle;
    final Cake;
    final Drink;

    static public final all:ReadOnlyArray<WoStreetItem> = [
        WaffleBurger,
        ClassicWaffle,
        Cake,
        Drink,
    ];

    public function getDefinition():Dynamic return switch (cast this:WoStreetItem) {
        case WaffleBurger: WoStreetMenu.WoStreetWaffleBurger;
        case ClassicWaffle: WoStreetMenu.WoStreetClassicWaffle;
        case Cake: WoStreetMenu.WoStreetCake;
        case Drink: WoStreetMenu.WoStreetDrink;
    }
}

class WoStreetMenu {
    static public final WoStreetWaffleBurger = {
        title: "窩堡",
        type: "string",
        "enum": [
            "照燒雞扒窩堡 (標準) $42",
            "照燒雞扒窩堡 (珍寶) $65",
            "豚肉芝士窩堡 (標準) $42",
            "豚肉芝士窩堡 (珍寶) $65",
            "厚切午餐肉窩堡 (標準) $42",
            "厚切午餐肉窩堡 (珍寶) $65",
        ]
    };
    static public final WoStreetClassicWaffle = {
        title: "經典窩夫",
        type: "string",
        "enum": [
            "意大利芝士窩夫 $32",
            "Oreo濃朱古力窩夫 $32",
            "宇治抹茶紅豆窩夫 $32",
        ]
    };
    static public final WoStreetCake = {
        title: "手作蛋糕",
        type: "string",
        "enum": [
            "東京第一芝士餅 一件 $28",
            // "東京第一芝士餅 4\" $128",
            // "東京第一芝士餅 6\" $160",
            "巴斯克芝士餅 一件 $28",
            // "巴斯克芝士餅 4\" $128",
            // "巴斯克芝士餅 6\" $160",
            "真毛巾蛋糕 4.5\" $78",
        ]
    };
    static public final WoStreetDrink = {
        title: "Drink",
        type: "string",
        "enum": [
            "罐裝可樂 $6",
            "罐裝芬達 $6",
            "罐裝雪碧 $6",
            "支裝津路烏龍茶 $10",
            "CBD少爺啤 全日愛爾 $40",
            "CBD少爺啤 淡愛爾 $40",
            "CBD少爺啤 DOUBLE $40",
            "冷泡玫瑰花茶 $20",
            "肉桂蘋果茶 $25",
            "雜莓果凍梳打特飲 $38",
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
            case WaffleBurger | ClassicWaffle | Cake | Drink:
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