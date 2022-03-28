package hkssprangers.info.menu;

import haxe.ds.ReadOnlyArray;
import js.lib.Object;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;
using Lambda;

enum abstract FishFranSSPItem(String) to String {
    final FishPot;
    final Pot;

    static public function all(timeSlotType:TimeSlotType):ReadOnlyArray<FishFranSSPItem> {
        return switch (timeSlotType) {
            case Lunch | Dinner:
                [
                    FishPot,
                    Pot,
                ];
            case _:
                [];
        }
    }

    public function getDefinition():Dynamic return switch (cast this:FishFranSSPItem) {
        case FishPot: FishFranSSPMenu.FishFranSSPFishPot;
        case Pot: FishFranSSPMenu.FishFranSSPPot;
    }
}

class FishFranSSPMenu {
    static function printNamePrice(item:{name:String, price:Int}):String {
        return item.name + " $" + item.price;
    }

    static public final FishFranSSPFishPot = {
        title: "特色魚鍋",
        properties: {
            style: {
                type: "string",
                title: "特色",
                "enum": [
                    "烏江魚鍋",
                    "鮮茄魚鍋",
                    "酸菜魚鍋",
                    "青椒魚鍋",
                    "水煮魚",
                ],
            },
            main: {
                type: "string",
                title: "配料",
                "enum": [
                    "桂花魚 小鍋 $258",
                    "桂花魚 大鍋 $438",
                    "鯰魚 小鍋 $158",
                    "鯰魚 大鍋 $278",
                    "鯛魚 小鍋 $158",
                    "鯛魚 大鍋 $278",
                    "白鱔 小鍋 $246",
                    "白鱔 大鍋 $426",
                    "黃鱔 小鍋 $246",
                    "黃鱔 大鍋 $426",
                    "魚頭 小鍋 $190",
                    "魚頭 大鍋 $326",
                    "雞 小鍋 $188",
                    "雞 大鍋 $298",
                    "田雞 小鍋 $192",
                    "田雞 大鍋 $298",
                ],
            },
        },
        required: [
            "style",
            "main",
        ],
    }

    static public final FishFranSSPPot = {
        title: "煲/鍋",
        type: "string",
        "enum": [
            "重慶雞煲 小鍋 $198",
            "重慶雞煲 大鍋 $308",
            "奇味雞煲(鍋) $198",
            "藥材雞煲(鍋) $198",
            "魚頭雞煲(鍋) $278",
            "魚頭鍋(鍋) $198",
            "野山菌雞煲(鍋) $198",
            "茶樹菇雞煲(鍋) $198",
            "鴨棚子(鍋) $258",
            // "鮮鍋(魚頭+羊腩)(鍋) 時價",
            // "羊腩煲(鍋) 時價",
            "蘿蔔豬骨煲(鍋) $198",
            "水煮牛肉(例) $148",
        ],
    };

    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        return if (pickupTimeSlot == null || pickupTimeSlot.start == null) {
            type: "array",
            items: {
                type: "object",
            }
        } else {
            final itemDefs = [
                for (item in FishFranSSPItem.all(TimeSlotType.classify(pickupTimeSlot.start)))
                item => item.getDefinition()
            ];
            function itemSchema():Dynamic return {
                type: "object",
                properties: {
                    type: itemDefs.count() > 0 ? {
                        title: "食物種類",
                        type: "string",
                        oneOf: [
                            for (item => def in itemDefs)
                            {
                                title: def.title,
                                const: item,
                            }
                        ],
                    } : {
                        title: "⚠️ 請移除",
                        type: "string",
                        "enum": [],
                    },
                },
                required: [
                    "type",
                ],
            };
            {
                type: "array",
                items: order.items == null || order.items.length == 0 ? itemSchema() : order.items.map(item -> {
                    var itemSchema:Dynamic = itemSchema();
                    switch (itemDefs[cast item.type]) {
                        case null:
                            // pass
                        case itemDef:
                            Object.assign(itemSchema.properties, {
                                item: itemDef,
                            });
                            itemSchema.required.push("item");
                    }
                    itemSchema;
                }),
                additionalItems: itemSchema(),
                minItems: 1,
            };
        };
    }

    static function summarizeItem(orderItem:{
        ?type:FishFranSSPItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        final def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case FishPot:
                summarizeOrderObject(orderItem.item, def, ["style","main"]);
            case Pot:
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
        final s = concatSummaries(formData.items.map(item -> summarizeItem(cast item)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}