package hkssprangers.info.menu;

import haxe.ds.ReadOnlyArray;
import js.lib.Object;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.MathTools;
using Reflect;
using Lambda;

enum abstract EightyNineItem(String) to String {
    final LimitedSpecial;
    final MainCourse;
    final Snack;
    final RiceAndNoodle;

    static public function all(timeSlot:TimeSlot):ReadOnlyArray<EightyNineItem> {
        final limited = if (
            timeSlot.start.getDatePart() >= EightyNineMenu.EightyNineLimitedSpecial.dateStart
            &&
            timeSlot.start.getDatePart() <= EightyNineMenu.EightyNineLimitedSpecial.dateEnd
            &&
            EightyNineMenu.EightyNineLimitedSpecial.timeSlotTypes.has(TimeSlotType.classify(timeSlot.start))
            &&
            EightyNineMenu.EightyNineLimitedSpecial.available
        )
            [LimitedSpecial];
        else
            [];

        return limited.concat([
            MainCourse,
            Snack,
            RiceAndNoodle,
        ]);
    }

    public function getDefinition():Dynamic return switch (cast this:EightyNineItem) {
        case MainCourse: EightyNineMenu.EightyNineMainCourse;
        case Snack: EightyNineMenu.EightyNineSnack;
        case RiceAndNoodle: EightyNineMenu.EightyNineRiceAndNoodle;
        case LimitedSpecial: EightyNineMenu.EightyNineLimitedSpecial.def;
    }
}

class EightyNineMenu {
    static function item(name:String, price:Float):String {
        return name + " $" + Math.round(price / 0.85);
    }

    static public final EightyNineLimitedSpecial = {
        final items = [
            item("秘製潮式韮菜豬紅", 28),
        ];

        {
            dateStart: "2022-12-15",
            dateEnd: "2022-12-15",
            timeSlotTypes: [Lunch, Dinner],
            available: true,
            def: {
                title: items.length == 1 ? "限定：" + items[0] : "期間限定",
                description: "⚠️ 請提早落單。售完即止。",
                properties: {
                    special: {
                        title: "限定",
                        type: "string",
                        "enum": items,
                        "default": items[0],
                    }
                },
                required: ["special"],
            }
        };
    };

    static public final EightyNineMainCourse = {
        title: "主菜",
        type: "string",
        "enum": [
            item("招牌口水雞(例)", 42),
            item("招牌口水雞(半)", 75),
            item("招牌口水雞(隻)", 138),
            item("去骨海南雞(例)", 42),
            item("去骨海南雞(半)", 75),
            item("去骨海南雞(隻)", 138),
            item("自家酸辣雞(例)", 42),
            item("自家酸辣雞(半)", 75),
            item("自家酸辣雞(隻)", 138),
            item("香茅燒豬頸肉(例)", 48),
            item("泰式去骨豬髀(例)", 48),
            item("柱侯牛腩牛肚(例)", 50),
        ],
    };

    static public final EightyNineRiceAndNoodle = {
        title: "飯麵",
        properties: {
            main: {
                type: "string",
                title: "飯麵",
                "enum": [
                    item("招牌口水雞飯", 40),
                    item("去骨海南雞飯", 40),
                    item("自家酸辣雞飯", 40),
                    item("上湯雲吞雞配飯", 55),
                    item("香茅燒豬頸肉飯", 46),
                    item("泰式去骨豬髀飯", 46),
                    item("瑞士汁雞翼飯", 40),
                    item("泰式豬扒飯", 38),
                    item("柱侯蘿蔔牛腩飯", 38),
                    item("泰式豬軟骨飯", 45),
                ],
            },
            drink: {
                type: "string",
                title: "送飲品",
                "enum": [
                    "唔要",
                    "汽水(隨機)",
                ],
            },
        },
        required: [
            "main",
            "drink",
        ],
    };

    static public final EightyNineSnack = {
        title: "小食",
        type: "string",
        "enum": [
            item("紅油抄手", 20),
            item("瑞士汁雞翼", 25),
            item("涼拌青瓜拼木耳", 22),
            item("涼拌花枝拼青瓜木耳", 30),
            item("郊外油菜", 12),
            item("白飯", 6),
            item("油飯", 6),
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
                for (item in EightyNineItem.all(pickupTimeSlot))
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
        ?type:EightyNineItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        final def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case LimitedSpecial:
                final orderDetails = [fullWidthDot + "限定：" + orderItem.item.special];
                final orderPrice = orderDetails.map(line -> parsePrice(line).price).sum();
                {
                    orderDetails: orderDetails.join("\n"),
                    orderPrice: orderPrice,
                };
            case RiceAndNoodle:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"]);
            case MainCourse | Snack:
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