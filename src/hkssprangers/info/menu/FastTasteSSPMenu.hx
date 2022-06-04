package hkssprangers.info.menu;

import haxe.ds.ReadOnlyArray;
import js.lib.Object;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;

enum abstract FastTasteSSPItem(String) to String {
    final DinnerSet;
    final BurgerSet;
    final Burger;
    final Italian;
    final Seafood;
    final Meat;
    final Salad;
    final Misc;

    static public function all(timeSlot:TimeSlot):ReadOnlyArray<FastTasteSSPItem> {
        final types = switch TimeSlotType.classify(timeSlot.start) {
            case Lunch:
                [
                    BurgerSet,
                    Burger,
                    Italian,
                    Seafood,
                    Salad,
                    Misc,
                ];
            case Dinner:
                [
                    DinnerSet,
                    BurgerSet,
                    Burger,
                    Italian,
                    Seafood,
                    Meat,
                    Salad,
                    Misc,
                ];
        }
        if (types == null || timeSlot.start == null){
            return [];
        }

        return types;
    }

    public function getDefinition(timeSlotType:TimeSlotType, isRedDay:Bool):Dynamic return switch (cast this:FastTasteSSPItem) {
        case DinnerSet: FastTasteSSPMenu.FastTasteSSPDinnerSet;
        case BurgerSet: FastTasteSSPMenu.FastTasteSSPBurgerSet(timeSlotType, isRedDay);
        case Burger: FastTasteSSPMenu.FastTasteSSPBurger(timeSlotType);
        case Seafood: FastTasteSSPMenu.FastTasteSSPSeafood(timeSlotType);
        case Meat: FastTasteSSPMenu.FastTasteSSPMeat(timeSlotType);
        case Italian: FastTasteSSPMenu.FastTasteSSPItalian(timeSlotType);
        case Salad: FastTasteSSPMenu.FastTasteSSPSalad();
        case Misc: FastTasteSSPMenu.FastTasteSSPMisc();
    }
}

class FastTasteSSPMenu {
    static public final box = "外賣盒 $1";
    static public function FastTasteSSPBurgerSetDrink(basePrice:Float) return {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            '凍柑橘檸檬 +$$${0 + basePrice}',
            '凍香芒橙汁 +$$${0 + basePrice}',
            '熱檸檬⽔ +$$${0 + basePrice}',
            '熱柑橘檸檬 +$$${0 + basePrice}',
            '熱朱古⼒ +$$${0 + basePrice}',
            '可樂 +$$${0 + basePrice}',
            '無糖可樂 +$$${0 + basePrice}',
            '忌廉 +$$${0 + basePrice}',
            '雪碧 +$$${0 + basePrice}',
            '凍朱古⼒ +$$${9 + basePrice}',
            '熱即磨咖啡 +$$${10 + basePrice}',
            '凍即磨咖啡 +$$${13 + basePrice}',
            '凍蘋果汁 +$$${8 + basePrice}',
            '凍檸檬⽔ +$$${9 + basePrice}',
            '凍鮮檸利賓納 +$$${9 + basePrice}',
            '凍檸檬紅茶 +$$${9 + basePrice}',
            '凍青檸梳打 +$$${13 + basePrice}',
            '凍雜果賓治 +$$${13 + basePrice}',
        ],
    };
    static public function FastTasteSSPDrink(priceScale:Float) return {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            '可樂 +$$${10 * priceScale}',
            '無糖可樂 +$$${10 * priceScale}',
            '忌廉 +$$${10 * priceScale}',
            '雪碧 +$$${10 * priceScale}',
            '凍香芒橙汁 +$$${16 * priceScale}',
            '凍蘋果汁 +$$${16 * priceScale}',
            '熱柑橘檸檬 +$$${16 * priceScale}',
            '凍柑橘檸檬 +$$${16 * priceScale}',
            '熱檸檬⽔ +$$${16 * priceScale}',
            '凍檸檬⽔ +$$${18 * priceScale}',
            '熱朱古⼒ +$$${16 * priceScale}',
            '凍朱古⼒ +$$${18 * priceScale}',
            '熱即磨咖啡 +$$${20 * priceScale}',
            '凍即磨咖啡 +$$${26 * priceScale}',
            '凍鮮檸利賓納 +$$${18 * priceScale}',
            '凍檸檬紅茶 +$$${18 * priceScale}',
            '凍青檸梳打 +$$${26 * priceScale}',
            '凍雜果賓治 +$$${26 * priceScale}',
        ],
    };
    static public final FastTasteSSPBurgers:ReadOnlyArray<String> = [
        "經典牛魔堡 $57",
        "公司漢堡 $99",
        "極上和牛堡 $85",
        "焦糖鵝肝牛肉漢堡 $99",
        "橫行脆蟹堡 $78",
        // "芝士雙菇漢堡 $52",
        "菠蘿炸雞堡 $55",
        "深海鱈魚堡 $57",
    ];
    static public final FastTasteSSPBurgerOptions:ReadOnlyArray<String> = [
        "自制牛漢堡 +$30",
        "菠特菇 +$15",
        "菠蘿 +$8",
        "煙肉 +$8",
        "煎蛋 +$8",
        // "烤洋蔥 +$8",
        // "生洋蔥碎 +$8",
        "車打芝士 +$8",
        "酸瓜 +$8",
    ];
    static public function FastTasteSSPBurgerSet(timeSlotType:TimeSlotType, isRedDay:Bool) {
        var title = '漢堡套餐';
        return {
            title: title,
            properties: {
                burger: {
                    type: "string",
                    title: title,
                    "enum": FastTasteSSPBurgers,
                },
                options: {
                    type: "array",
                    title: "加配料",
                    items: {
                        type: "string",
                        "enum": FastTasteSSPBurgerOptions,
                    },
                    uniqueItems: true,
                },
                setItem: {
                    type: "string",
                    title: "跟餐小食",
                    "enum": [
                        "薯條",
                        "薯格",
                        // "蕃薯條",
                        "洋蔥圈",
                        "芝⼠條",
                        "原味雞翼",
                    ],
                },
                drink: FastTasteSSPBurgerSetDrink(18),
            },
            required: [
                "burger",
                "setItem",
                "drink",
            ]
        };
    }
    static public function FastTasteSSPBurger(timeSlotType:TimeSlotType) {
        var title = '單叫漢堡';
        return {
            title: title,
            properties: {
                burger: {
                    type: "string",
                    title: "漢堡",
                    "enum": FastTasteSSPBurgers,
                },
                options: {
                    type: "array",
                    title: "加配料",
                    items: {
                        type: "string",
                        "enum": FastTasteSSPBurgerOptions,
                    },
                    uniqueItems: true,
                },
                drink: FastTasteSSPDrink(1),
            },
            required: [
                "burger",
            ]
        };
    }

    static public final FastTasteSSPDinnerSet = {
        title: "超值晚市套餐",
        properties: {
            main: {
                type: "string",
                title: "超值晚市套餐",
                "enum": [
                    "A 蟹籽煙三文魚忌廉汁意粉 $88",
                    "B 龍蝦汁海鮮意大利飯 $98",
                    "C 招牌公司漢堡配薯條 $108",
                    "D 紐西蘭西冷扒配薯條 $118",
                    "E 串燒三兄弟(豬,牛,雞)配薯格 $138",
                    "F 德國鹹豬手配薯條 $148",
                    "G 法式香草烤羊架拼豬扒配薯條 $158",
                    "H 紐西蘭肉眼扒(10安士)配薯條 $168",
                ],
            },
            sub: {
                type: "string",
                title: "跟餐",
                "enum": [
                    "是日餐湯",
                    "是日沙律",
                ]
            },
            options: {
                type: "array",
                title: "加配",
                items: {
                    type: "string",
                    "enum": [
                        "薯條 +$10",
                        "薯格 +$10",
                        "洋蔥圈 +$10",
                        "芝士條(2條) +$10",
                        "原味雞翼(2隻) +$10",
                    ],
                },
                uniqueItems: true,
            },
            drink: {
                title: "跟餐飲品",
                type: "string",
                "enum": [
                    '香芒橙汁',
                    '蘋果汁',
                    '可樂',
                    '無糖可樂',
                    '忌廉',
                    '雪碧',
                    '熱柑橘檸檬',
                    '凍柑橘檸檬',
                    '熱檸檬⽔',
                    '熱朱古⼒',
                ]
            },
        },
        required: [
            "main",
            "sub",
            "drink",
        ]
    };

    static public function FastTasteSSPSeafood(timeSlotType:TimeSlotType) {
        var title = '海鮮';
        return {
            title: title,
            properties: {
                seafood: {
                    title: title,
                    type: "string",
                    "enum": [
                        "炸魚薯條 $70",
                        // "酥炸魷魚鬚 $45",
                        "脆炸軟殼蟹 $48",
                        // "炸海鮮拼盤(軟殼蟹，魷魚鬚，大蝦，鱈魚柳) $98",
                        "香辣茄蓉煮青口 $50",
                        "白酒忌廉汁煮大蜆 $50",
                    ],
                },
                drink: FastTasteSSPDrink(1),
            },
            required: [
                "seafood",
            ]
        };
    }
    static public function FastTasteSSPMeat(timeSlotType:TimeSlotType) {
        return {
            title: "肉類",
            properties: {
                meat: {
                    type: "string",
                    title: "肉類",
                    "enum": [
                        "紐西蘭肉眼(10安士)配薯條 $158",
                        "(自制)鮮士多啤梨汁燒豬仔骨配薯條 $128",
                        "烤紐西蘭羊架配薯條 $148",
                        "德國鹹豬手配酸椰菜及薯條 $138",
                    ],
                },
                drink: FastTasteSSPDrink(1),
            },
            required: [
                "meat",
            ]
        };
    }
    static public function FastTasteSSPItalian(timeSlotType:TimeSlotType) {
        var title = '意大利麵／意大利飯';
        return {
            title: title,
            properties: {
                italian: {
                    type: "string",
                    title: title,
                    "enum": [
                        "意式鮮茄海鮮墨魚麵 $78",
                        "卡邦尼意大利麵 $62",
                        "拿破崙肉醬意大利麵 $68",
                        "蒜香大蜆意大利麵 $68",
                        "鵝肝牛柳粒黑松露意大利飯 $108",
                        "煙三文魚意大利飯 $82",
                        // "海鮮龍蝦汁意大利飯 $98",
                        // "蟹肉南瓜意大利飯 $98",
                    ],
                },
                drink: FastTasteSSPDrink(1),
            },
            required: [
                "italian",
            ]
        };
    }
    static public function FastTasteSSPSalad() {
        return {
            title: "沙律",
            properties: {
                salad: {
                    type: "string",
                    title: "沙律",
                    "enum": [
                        "田園沙律(芝麻汁) $35",
                        "田園沙律(黑醋汁) $35",
                        "凱撒沙律 $35",
                    ],
                },
                options: {
                    type: "array",
                    title: "加配料",
                    items: {
                        type: "string",
                        "enum": [
                            "煙三文魚 +$15",
                            "烤雞 +$15",
                            "鮮蝦 +$15",
                        ],
                    },
                    uniqueItems: true,
                },
            },
            required: [
                "salad",
            ]
        };
    }
    static public function FastTasteSSPMisc() {
        return {
            title: "自制湯類／配菜／甜品",
            type: "string",
            "enum": [
                // "黑松露忌廉磨菇湯 $30",
                "龍蝦湯 $35",
                "薯條 $28",
                "薯格 $28",
                "芝士條(4條) $32",
                // "蕃薯條 $32",
                "洋蔥圈 $32",
                "原味雞翼(5隻) $40",
                "墨西哥煙辣椒雞翼(5隻) $45",
                "小食拼盤(薯條，薯格，芝士條，洋蔥圈) $70",
            ],
        };
    }

    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        return if (pickupTimeSlot == null) {
            type: "array",
            items: {
                type: "object",
            }
        } else {
            var timeSlotType = TimeSlotType.classify(pickupTimeSlot.start);
            var isRedDay = HkHolidays.isRedDay(pickupTimeSlot.start.toDate());
            var itemDefs = [
                for (item in FastTasteSSPItem.all(pickupTimeSlot))
                item => item.getDefinition(timeSlotType, isRedDay)
            ];
            function itemSchema():Dynamic return {
                type: "object",
                properties: {
                    type: {
                        title: "食物種類",
                        type: "string",
                        oneOf: [
                            for (item => def in itemDefs)
                            {
                                title: def.title,
                                const: item,
                            }
                        ],
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
        ?type:FastTasteSSPItem,
        ?item:Dynamic,
    }, timeSlotType:TimeSlotType, isRedDay:Bool):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition(timeSlotType, isRedDay);
        return switch (orderItem.type) {
            case DinnerSet:
                final numBoxes = if (orderItem.item != null && orderItem.item.options != null) {
                    orderItem.item.options.length + 2;
                } else {
                    2;
                };
                summarizeOrderObject(orderItem.item, def, ["main", "sub", "options", "drink"], ["外賣盒 $" + numBoxes]);
            case BurgerSet:
                summarizeOrderObject(orderItem.item, def, ["burger", "options", "setItem", "drink"], [box]);
            case Burger:
                summarizeOrderObject(orderItem.item, def, ["burger", "options", "drink"], [box]);
            case Italian:
                summarizeOrderObject(orderItem.item, def, ["italian", "drink"], [box]);
            case Seafood:
                summarizeOrderObject(orderItem.item, def, ["seafood", "drink"], [box]);
            case Meat:
                summarizeOrderObject(orderItem.item, def, ["meat", "drink"], [box]);
            case Salad:
                summarizeOrderObject(orderItem.item, def, ["salad", "options"], [box]);
            case Misc:
                switch (orderItem.item:Null<String>) {
                    case v if (Std.isOfType(v, String)):
                        {
                            orderDetails: fullWidthDot + v + "\n" + fullWidthSpace + box,
                            orderPrice: v.parsePrice().price + box.parsePrice().price,
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

    static public function summarize(formData:FormOrderData, timeSlotType:TimeSlotType, isRedDay:Bool):OrderSummary {
        var s = concatSummaries(formData.items.map(item -> summarizeItem(cast item, timeSlotType, isRedDay)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}