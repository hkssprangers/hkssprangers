package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
using Lambda;

enum abstract WoStreetItem(String) to String {
    final ClassicWaffle;
    final Cake;
    final Drink;

    static public final all:ReadOnlyArray<WoStreetItem> = [
        ClassicWaffle,
        Cake,
        Drink,
    ];

    public function getDefinition():Dynamic return switch (cast this:WoStreetItem) {
        case ClassicWaffle: WoStreetMenu.WoStreetClassicWaffle;
        case Cake: WoStreetMenu.WoStreetCake;
        case Drink: WoStreetMenu.WoStreetDrink;
    }
}

class WoStreetMenu {
    static public final WoStreetClassicWaffle = {
        title: "窩夫",
        type: "string",
        "enum": [
            "意大利芝士窩夫 $48",
            "Oreo濃朱古力窩夫 $48",
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