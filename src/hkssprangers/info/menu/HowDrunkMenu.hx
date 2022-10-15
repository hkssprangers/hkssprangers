package hkssprangers.info.menu;

import haxe.ds.ReadOnlyArray;
import js.lib.Object;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;
using Lambda;

enum abstract HowDrunkItem(String) to String {
    final Spicy;
    final Drunk;
    final FermentedBeanCurd;
    final NoodlesAndRice;
    final Drink;

    static public function all(timeSlot:TimeSlot):ReadOnlyArray<HowDrunkItem> {
        return [
            Spicy,
            Drunk,
            FermentedBeanCurd,
            NoodlesAndRice,
            Drink,
        ];
    }

    public function getDefinition(timeSlot:TimeSlot):Dynamic {
        return switch (cast this:HowDrunkItem) {
            case Spicy: HowDrunkMenu.HowDrunkSpicy;
            case Drunk:
                final now:LocalDateString = Date.now();
                final pickupDate = if (timeSlot != null) {
                    timeSlot.start;
                } else {
                    now;
                }
                final preOrderCutoff = (pickupDate.getDatePart() + " 20:00:00":LocalDateString).deltaDays(-1);
                if (now < preOrderCutoff)
                    HowDrunkMenu.HowDrunkDrunkPreOrder;
                else
                    HowDrunkMenu.HowDrunkDrunkToday;
            case FermentedBeanCurd: HowDrunkMenu.HowDrunkFermentedBeanCurd;
            case NoodlesAndRice: HowDrunkMenu.HowDrunkNoodlesAndRice;
            case Drink: HowDrunkMenu.HowDrunkDrink;
        }
    }
}

class HowDrunkMenu {
    static function item(name:String, price:Float):String {
        return name + " $" + Math.round(price/0.85);
    }

    static public final HowDrunkSpicy = {
        title: "有杞辣",
        type: "string",
        "enum": [
            item("杞辣撈雞", 55),
            item("杞辣牛舌", 48),
            item("杞辣邪惡鵝腸", 38),
            item("杞辣爆雞皮(期間限定)", 38),
            item("杞辣雞腎", 38),
            item("杞辣黄金皮蛋(溏心)", 25),
            item("杞辣腐竹(樹記)", 25),
            item("杞辣爽萵筍", 25),
            item("杞辣蓮藕", 25),
            // item("杞辣脆青瓜", 25),
            item("杞辣雲耳", 25),
            item("杞辣魚蛋", 10),
        ],
    };

    static public final HowDrunkDrunkToday = {
        title: "有杞醉",
        type: "string",
        "enum": [
            item("杞醉無骨雞", 55),
            item("杞醉慢煮牛舌", 48),
            item("杞醉蘭王蛋(日本) 1隻", 15),
            item("杞醉蘭王蛋(日本) 2隻", 25),
            item("杞醉鵪鶉蛋", 38),
            item("杞醉滷肉(膠原增量)", 20),
        ],
    };

    static public final HowDrunkDrunkPreOrder = {
        title: "有杞醉",
        type: "string",
        "enum": [
            item("杞醉無骨雞", 55),
            item("杞醉慢煮牛舌", 48),
            item("杞醉鵝肝(1天前預訂)", 98),
            item("杞醉蝦(1天前預訂)", 88),
            item("杞醉花甲(1天前預訂)", 68),
            item("杞醉蘭王蛋(日本) 1隻", 15),
            item("杞醉蘭王蛋(日本) 2隻", 25),
            item("杞醉鵪鶉蛋", 38),
            item("杞醉滷肉(膠原增量)", 20),
        ],
    };

    static public final HowDrunkFermentedBeanCurd = {
        title: "有杞腐",
        type: "string",
        "enum": [
            item("杞腐雞翼尖", 25),
            item("杞腐雞中翼(多汁)", 32),
        ],
    };

    static public final HowDrunkNoodlesAndRice = {
        title: "有杞粉麵飯",
        type: "string",
        "enum": [
            item("杞珍珠米飯", 12),
            item("杞辣撈米線", 15),
            item("胡麻撈麵", 15),
        ],
    };

    static public final HowDrunkDrink = {
        title: "有得解飲品",
        type: "string",
        "enum": [
            item("仙草清涼爽", 8),
            item("菊花茶", 8),
            item("甘蔗馬蹄汁", 8),
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
                for (item in HowDrunkItem.all(pickupTimeSlot))
                item => item.getDefinition(pickupTimeSlot)
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
        ?type:HowDrunkItem,
        ?item:Dynamic,
    }, pickupTimeSlot:TimeSlot):{
        orderDetails:String,
        orderPrice:Float,
    } {
        final def = orderItem.type.getDefinition(pickupTimeSlot);
        return switch (orderItem.type) {
            case Spicy | Drunk | FermentedBeanCurd | NoodlesAndRice | Drink:
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

    static public function summarize(formData:FormOrderData, timeSlot:TimeSlot):OrderSummary {
        final s = concatSummaries(formData.items.map(item -> summarizeItem(cast item, timeSlot)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}