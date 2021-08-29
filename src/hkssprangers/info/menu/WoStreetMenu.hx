package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
using Lambda;

enum abstract WoStreetItem(String) to String {
    final WaffleBurger;
    final CreamWaffle;
    final JellyCup;
    final Drink;

    static public final all:ReadOnlyArray<WoStreetItem> = [
        WaffleBurger,
        CreamWaffle,
        JellyCup,
        Drink,
    ];

    public function getDefinition():Dynamic return switch (cast this:WoStreetItem) {
        case WaffleBurger: WoStreetMenu.WoStreetWaffleBurger;
        case CreamWaffle: WoStreetMenu.WoStreetCreamWaffle;
        case JellyCup: WoStreetMenu.WoStreetJellyCup;
        case Drink: WoStreetMenu.WoStreetDrink;
    }
}

class WoStreetMenu {
    static public final WoStreetWaffleBurger = {
        title: "Waffle Burger",
        type: "string",
        "enum": [
            "日式照燒雞扒窩夫 $42",
            "豚肉芝士漢堡窩夫 $42",
            "素芝士大啡菇窩夫 $38",
            "素麥樂雞窩夫 $38",
        ]
    };
    static public final WoStreetCreamWaffle = {
        title: "Cream Waffle",
        type: "string",
        "enum": [
            "意大利芝士窩夫 $32",
            "Oreo濃朱古力窩夫 $32",
            "宇治抹茶紅豆窩夫 $32",
        ]
    };
    static public final WoStreetJellyCup = {
        title: "Jelly Cup",
        type: "string",
        "enum": [
            "藍苺乳酪蝶豆花果凍杯 $20",
            "櫻花乳酪玫瑰果凍杯 $20",
            "奶蓋珍珠奶茶果凍杯 $20",
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
            "大馬士革玫瑰花茶 $20",
            "CBD少爺啤 全日愛爾 $40",
            "CBD少爺啤 淡愛爾 $40",
            "CBD少爺啤 DOUBLE $40",
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
            case WaffleBurger | CreamWaffle | JellyCup | Drink:
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