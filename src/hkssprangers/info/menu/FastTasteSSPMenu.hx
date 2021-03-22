package hkssprangers.info.menu;

import haxe.ds.ReadOnlyArray;
import hkssprangers.browser.forms.OrderForm.OrderData;
import js.lib.Object;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;

enum abstract FastTasteSSPItem(String) to String {
    final BurgerSet;
    final Burger;
    final Seafood;
    final Meat;
    final Italian;
    final Veg;
    final Salad;
    final Misc;

    static public function all(timeSlotType:TimeSlotType):ReadOnlyArray<FastTasteSSPItem> return switch timeSlotType {
        case Lunch:
            [
                BurgerSet,
                Burger,
                Seafood,
                Italian,
                Veg,
                Salad,
                Misc,
            ];
        case Dinner:
            [
                BurgerSet,
                Burger,
                Seafood,
                Meat,
                Italian,
                Veg,
                Salad,
                Misc,
            ];
    }

    public function getDefinition(timeSlotType:TimeSlotType, isRedDay:Bool):Dynamic return switch (cast this:FastTasteSSPItem) {
        case BurgerSet: FastTasteSSPMenu.FastTasteSSPBurgerSet(timeSlotType, isRedDay);
        case Burger: FastTasteSSPMenu.FastTasteSSPBurger(timeSlotType);
        case Seafood: FastTasteSSPMenu.FastTasteSSPSeafood(timeSlotType);
        case Meat: FastTasteSSPMenu.FastTasteSSPMeat(timeSlotType);
        case Italian: FastTasteSSPMenu.FastTasteSSPItalian(timeSlotType);
        case Veg: FastTasteSSPMenu.FastTasteSSPVeg();
        case Salad: FastTasteSSPMenu.FastTasteSSPSalad();
        case Misc: FastTasteSSPMenu.FastTasteSSPMisc();
    }
}

class FastTasteSSPMenu {
    static public function FastTasteSSPBurgerSetDrink(basePrice:Float) return {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            '凍柑橘檸檬 (+$$${0 + basePrice})',
            '凍⾹芒橙汁 (+$$${0 + basePrice})',
            '熱檸檬⽔ (+$$${0 + basePrice})',
            '熱柑橘檸檬 (+$$${0 + basePrice})',
            '熱朱古⼒ (+$$${0 + basePrice})',
            '可樂 (+$$${0 + basePrice})',
            '無糖可樂 (+$$${0 + basePrice})',
            '忌廉 (+$$${0 + basePrice})',
            '雪碧 (+$$${0 + basePrice})',
            '凍朱古⼒ (+$$${9 + basePrice})',
            '熱即磨咖啡 (+$$${10 + basePrice})',
            '凍即磨咖啡 (+$$${13 + basePrice})',
            '凍蘋果汁 (+$$${8 + basePrice})',
            '凍檸檬⽔ (+$$${9 + basePrice})',
            '凍鮮檸利賓納 (+$$${9 + basePrice})',
            '凍檸檬紅茶 (+$$${9 + basePrice})',
            '凍青檸梳打 (+$$${13 + basePrice})',
            '凍雜果賓治 (+$$${13 + basePrice})',
        ],
    };
    static public function FastTasteSSPDrink(priceScale:Float) return {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            '可樂 (+$$${10 * priceScale})',
            '無糖可樂 (+$$${10 * priceScale})',
            '忌廉 (+$$${10 * priceScale})',
            '雪碧 (+$$${10 * priceScale})',
            '凍⾹芒橙汁 (+$$${16 * priceScale})',
            '凍蘋果汁 (+$$${16 * priceScale})',
            '熱柑橘檸檬 (+$$${16 * priceScale})',
            '凍柑橘檸檬 (+$$${16 * priceScale})',
            '熱檸檬⽔ (+$$${16 * priceScale})',
            '凍檸檬⽔ (+$$${18 * priceScale})',
            '熱朱古⼒ (+$$${16 * priceScale})',
            '凍朱古⼒ (+$$${18 * priceScale})',
            '熱即磨咖啡 (+$$${20 * priceScale})',
            '凍即磨咖啡 (+$$${26 * priceScale})',
            '凍鮮檸利賓納 (+$$${18 * priceScale})',
            '凍檸檬紅茶 (+$$${18 * priceScale})',
            '凍青檸梳打 (+$$${26 * priceScale})',
            '凍雜果賓治 (+$$${26 * priceScale})',
        ],
    };
    static public function FastTasteSSPBurgerSet(timeSlotType:TimeSlotType, isRedDay:Bool) {
        return {
            title: "漢堡套餐",
            properties: {
                burger: {
                    type: "string",
                    title: "漢堡選擇",
                    "enum": [
                        "經典牛魔堡 $57",
                        "公司漢堡 $99",
                        "極上和牛堡 $85",
                        "焦糖鵝肝牛肉漢堡 $99",
                        "橫行脆蟹堡 $78",
                        "芝士雙菇漢堡 $52",
                        "菠蘿炸雞堡 $55",
                        "深海鱈魚堡 $57",
                    ],
                },
                options: {
                    type: "array",
                    title: "加配料",
                    items: {
                        type: "string",
                        "enum": [
                            "自制牛漢堡 (+$30)",
                            "菠特菇 (+$15)",
                            "菠蘿 (+$8)",
                            "煙肉 (+$8)",
                            "煎蛋 (+$8)",
                            "烤洋蔥 (+$8)",
                            "生洋蔥碎 (+$8)",
                            "車打芝士 (+$8)",
                            "酸瓜 (+$8)",
                        ],
                    },
                    uniqueItems: true,
                },
                setItem: {
                    type: "string",
                    title: "跟餐選擇",
                    "enum": [
                        "薯條",
                        "薯格",
                        "蕃薯條",
                        "洋蔥圈",
                        "芝⼠條",
                        "原味雞翼",
                    ],
                },
                drink: FastTasteSSPBurgerSetDrink(switch [timeSlotType, isRedDay] {
                    case [Lunch, false]: 10;
                    case [Lunch, true]: 18;
                    case [Dinner, false]: 18;
                    case [Dinner, true]: 18;
                }),
            },
            required: [
                "burger",
                "setItem",
                "drink",
            ]
        };
    }
    static public function FastTasteSSPBurger(timeSlotType:TimeSlotType) {
        return {
            title: "單叫漢堡",
            properties: {

            },
            required: [

            ]
        };
    }
    static public function FastTasteSSPSeafood(timeSlotType:TimeSlotType) {
        return {
            title: "海鮮",
            properties: {

            },
            required: [

            ]
        };
    }
    static public function FastTasteSSPMeat(timeSlotType:TimeSlotType) {
        return {
            title: "肉類",
            properties: {

            },
            required: [

            ]
        };
    }
    static public function FastTasteSSPItalian(timeSlotType:TimeSlotType) {
        return {
            title: "意大利麵/意大利飯",
            properties: {

            },
            required: [

            ]
        };
    }
    static public function FastTasteSSPVeg() {
        return {
            title: "素食精選",
            properties: {

            },
            required: [

            ]
        };
    }
    static public function FastTasteSSPSalad() {
        return {
            title: "沙律",
            properties: {

            },
            required: [

            ]
        };
    }
    static public function FastTasteSSPMisc() {
        return {
            title: "自制湯類 / 配菜 / 甜品",
            properties: {

            },
            required: [

            ]
        };
    }

    static public function itemsSchema(pickupTimeSlot:TimeSlot, order:OrderData):Dynamic {
        return if (pickupTimeSlot == null) {
            type: "array",
            items: {
                type: "object",
            }
        } else {
            var timeSlotType = TimeSlotType.classify(pickupTimeSlot.start);
            var isRedDay = switch (Weekday.fromDay(pickupTimeSlot.start.toDate().getDay()) {
                case Monday | Tuesday | Wednesday | Thursday | Friday:
                    HkHolidays.holidays.hasField(pickupTimeSlot.start.getDatePart());
                case Saturday | Sunday: true;
            }
            var itemDefs = [
                for (item in FastTasteSSPItem.all(timeSlotType))
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
                items: order.items == null ? [] : order.items.map(item -> {
                    var itemSchema:Dynamic = itemSchema();
                    switch (cast item.type:FastTasteSSPItem) {
                        case null:
                            //pass
                        case itemType:
                            Object.assign(itemSchema.properties, {
                                item: itemDefs[itemType],
                            });
                    }
                    itemSchema;
                }),
                additionalItems: itemSchema(),
                minItems: 1,
            };
        };
    }
}