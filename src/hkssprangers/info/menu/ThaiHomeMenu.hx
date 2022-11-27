package hkssprangers.info.menu;

import haxe.ds.ReadOnlyArray;
import js.lib.Object;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.MathTools;
using Reflect;
using Lambda;

enum abstract ThaiHomeItem(String) to String {
    final MainCourse;
    final Skewer;
    final Snack;
    final Salad;
    final RiceAndNoodle;

    static public function all(timeSlotType:TimeSlotType):ReadOnlyArray<ThaiHomeItem> {
        return [
            MainCourse,
            Skewer,
            Snack,
            Salad,
            RiceAndNoodle,
        ];
    }

    public function getDefinition():Dynamic return switch (cast this:ThaiHomeItem) {
        case MainCourse: ThaiHomeMenu.ThaiHomeMainCourse;
        case Skewer: ThaiHomeMenu.ThaiHomeSkewer;
        case Snack: ThaiHomeMenu.ThaiHomeSnack;
        case Salad: ThaiHomeMenu.ThaiHomeSalad;
        case RiceAndNoodle: ThaiHomeMenu.ThaiHomeRiceAndNoodle;
    }
}

class ThaiHomeMenu {
    static function item(name:String, price:Float):String {
        return name + " $" + Math.round(price / 0.85);
    }

    static public final ThaiHomeMainCourse = {
        title: "主菜",
        type: "string",
        "enum": [
            item("香茅燒豬頸肉", 48),
            item("馬拉盞 炒通菜", 38),
            item("蒜茸 炒通菜", 38),
            item("馬拉盞 炒芥蘭", 38),
            item("蒜茸 炒芥蘭", 38),
            item("辣椒膏炒墨魚仔拼蝦", 68),
            item("辣椒膏炒蜆", 68),
            item("冬陰功湯", 55),
            item("泰家去骨海南雞 例", 42),
            item("泰家去骨海南雞 半隻", 75),
            item("泰家去骨海南雞 一隻", 138),
            item("泰式去骨豬髀 例", 45),
            item("泰式去骨豬髀 一隻", 80),
        ],
    };

    static public final ThaiHomeSkewer = {
        title: "串燒沙嗲",
        description: "最少2串",
        type: "array",
        items: {
            type: "string",
            "enum": [
                item("雞", 13),
                item("豬", 13),
                item("牛", 15),
            ],
        },
        minItems: 2,
    };

    static public final ThaiHomeSnack = {
        title: "小食",
        type: "string",
        "enum": [
            item("月亮炸蝦餅", 45),
            item("泰式生菜包", 40),
            item("泰式炸魚餅", 35),
            item("油飯", 8),
            item("白飯", 8),
        ],
    };

    static public final ThaiHomeSalad = {
        title: "沙律",
        type: "string",
        "enum": [
            item("墨魚仔沙律", 58),
            item("青木瓜絲沙律", 48),
            item("大蝦粉絲沙律", 48),
            item("醃豬頸肉沙律", 48),
            item("醃脆腩沙律", 48),
            item("秘製酸辣鳳爪", 48),
        ],
    };

    static public final ThaiHomeRiceAndNoodle = {
        title: "飯麵",
        properties: {
            main: {
                type: "string",
                title: "飯麵",
                "enum": [
                    item("泰家蟹肉炒飯 跟湯", 55),
                    item("冬陰雞 配飯", 55),
                    item("冬陰雞 配金邊粉", 55),
                    item("冬陰公 配飯", 60),
                    item("冬陰公 配金邊粉", 60),
                    item("香葉辣椒脆腩煎蛋飯 跟湯", 49),
                    item("蝦頭膏鮮蝦炒飯", 52),
                    item("泰式肉碎妙粉絲", 52),

                    item("泰色炒金邊粉 豬扒", 45),
                    item("泰色炒金邊粉 鮮蝦", 48),
                    item("泰色炒金邊粉 豬頸肉", 48),
                    item("黃金咖哩飯 雞", 48),
                    item("黃金咖哩飯 豬扒", 48),
                    item("黃金咖哩飯 牛", 52),
                    item("黃金咖哩飯 鮮蝦", 52),
                    item("椰汁紅咖哩飯 雞", 45),
                    item("椰汁紅咖哩飯 豬扒", 45),
                    item("椰汁紅咖哩飯 牛", 48),
                    item("椰汁紅咖哩飯 鮮蝦", 48),
                    item("香葉青咖哩飯 雞", 45),
                    item("香葉青咖哩飯 豬扒", 45),
                    item("香葉青咖哩飯 牛", 48),
                    item("香葉青咖哩飯 鮮蝦", 48),
                    item("菠蘿鲜蝦炒飯", 45),
                    item("香茅燒豬頸肉飯", 46),
                    item("泰式去骨豬髀飯", 46),
                    item("辣椒膏鮮蝦炒飯", 45),
                    item("泰家去骨海南雞飯", 40),
                    item("香葉辣椒肉碎煎蛋飯", 42),
                ],
            },
            drink: {
                type: "string",
                title: "加配飲品",
                "enum": [
                    item("汽水(隨機)", 5),
                ],
            },
        },
        required: [
            "main",
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
                for (item in ThaiHomeItem.all(TimeSlotType.classify(pickupTimeSlot.start)))
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
        ?type:ThaiHomeItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        final def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case RiceAndNoodle:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"]);
            case Skewer:
                final orderDetails = [];
                final orderPrices = [];
                for (item in (orderItem.item:Array<String>)) {
                    final p = parsePrice(item);
                    orderDetails.push(fullWidthDot + ThaiHomeSkewer.title + "：" + item);
                    orderPrices.push(p.price);
                }
                {
                    orderDetails: orderDetails.join("\n"),
                    orderPrice: orderPrices.sum(),
                };
            case MainCourse | Snack | Salad:
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