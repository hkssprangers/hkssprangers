package hkssprangers.info.menu;

import haxe.ds.ReadOnlyArray;
import js.lib.Object;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;
using Lambda;

enum abstract LonelyPaisleyItem(String) to String {
    final LunchSet;
    final SaladSnacks;
    final Dessert;
    final PastaRice;
    final Main;
    final Drink;

    static public function all(timeSlot:TimeSlot):ReadOnlyArray<LonelyPaisleyItem> {
        if (timeSlot == null || timeSlot.start == null){
            return [];
        }
        return switch [Weekday.fromDay(timeSlot.start.toDate().getDay()), HkHolidays.isRedDay(timeSlot.start.toDate()), TimeSlotType.classify(timeSlot.start)] {
            case [Monday | Tuesday | Wednesday | Thursday | Friday, false, Lunch]:
                [
                    LunchSet,
                    SaladSnacks,
                    Dessert,
                    PastaRice,
                    Main,
                    Drink,
                ];
            case [_, _, Lunch]:
                [
                    SaladSnacks,
                    Dessert,
                    PastaRice,
                    Main,
                    Drink,
                ];
            case [_, _, Dinner]:
                [
                    SaladSnacks,
                    Dessert,
                    PastaRice,
                    Main,
                    Drink,
                ];
            case [weekday, isRedDay, timeSlotType]:
                trace(weekday + " " + timeSlotType);
                [];
        }
    }

    public function getDefinition():Dynamic return switch (cast this:LonelyPaisleyItem) {
        case LunchSet: LonelyPaisleyMenu.LonelyPaisleyLunchSet;
        case SaladSnacks: LonelyPaisleyMenu.LonelyPaisleySaladSnacks;
        case Dessert: LonelyPaisleyMenu.LonelyPaisleyDessert;
        case PastaRice: LonelyPaisleyMenu.LonelyPaisleyPastaRice;
        case Main: LonelyPaisleyMenu.LonelyPaisleyMain;
        case Drink: LonelyPaisleyMenu.LonelyPaisleyDrink;
    }
}

class LonelyPaisleyMenu {
    static final coffees = [
        {
            name: "Espresso (HOT)",
            price: 36,
        },
        {
            name: "Americano (HOT)",
            price: 36,
        },
        {
            name: "Americano (COLD)",
            price: 42,
        },
        {
            name: "White (HOT)",
            price: 44,
        },
        {
            name: "White (COLD)",
            price: 50,
        },
        {
            name: "Piccolo (HOT)",
            price: 42,
        },
        // {
        //     name: "Dirty (COLD)",
        //     price: 48,
        // },
        {
            name: "Mocha (HOT)",
            price: 48,
        },
        {
            name: "Mocha (COLD)",
            price: 54,
        },
        {
            name: "Rose Latte With Dark Brown Sugar (HOT)",
            price: 48,
        },
        {
            name: "Homemade Salty Plum Espresso Tonic (COLD)",
            price: 62,
        },
    ];
    static final milks = [
        {
            name: "Chocolate (HOT)",
            description: null,
            price: 44,
        },
        {
            name: "Chocolate (COLD)",
            description: null,
            price: 50,
        },
        {
            name: "HK Real Ginger Cacao",
            description: "local organic ginger mixed with raw cacao by Very Ginger HK",
            price: 48,
        },
    ];
    static final mocktails = [
        // {
        //     name: "Blue Lagoon",
        //     description: "blue curacao | fresh lemon juice | grapefruit juice | icing rim",
        //     price: 58,
        // },
        // {
        //     name: "Tropical Romance",
        //     description: "coconut milk | fresh orange juice | homemade pineapple syrip | cheese",
        //     price: 58,
        // },
        // {
        //     name: "Tokhm-e Sharbati",
        //     description: "(Iranian traditional drink) Iranian natural rose water | fresh lemon juice | fresh mint | basil seed",
        //     price: 58,
        // },
        {
            name: "Salep (HOT)",
            description: "(turkish traditional drink) serve with Turkish hand-painted ceramic mug. Turkish salep | milk | cinnamon | pistachio",
            price: 68,
        },
    ];
    static final otherDrinks = [
        {
            name: "Lithuanian Kvas",
            description: null,
            price: 48,
        },
        {
            name: "Turkish Pomegranate Sparkling",
            description: null,
            price: 28,
        },
    ];
    static final saladSnacks = [
        {
            name: "玫瑰蜜糖雞翼",
            price: 68
        },
        {
            name: "土耳其烤雞肉卷",
            price: 78
        },
        {
            name: "墨西哥三重芝士雞肉餡餅配秘制四川麻辣醬",
            price: 88
        },
        // {
        //     name: "自家製三款鷹嘴豆泥配芝麻包",
        //     price: 88
        // },
        {
            name: "牛油果素菜卷",
            price: 78
        },
        {
            name: "炸粗薯條配自家制黑蒜醬",
            price: 58
        },
    ];
    static final desserts = [
        {
            name: "土耳其開心果千層酥(2ps)",
            price: 58,
        },
        {
            name: "熱情果芒果芝士蛋糕",
            price: 48,
        },
        {
            name: "日本柚子芝士蛋糕",
            price: 48,
        },
    ];
    static final pastasRices = [
        {
            name: "自家製阿根廷香辣青醬虎蝦海鮮扁意粉",
            price: 148,
        },
        {
            name: "印度Masala慢煮牛肋條燴飯",
            price: 148,
        },
        {
            name: "斯里蘭卡香辣菠蘿大蝦配長米飯",
            price: 138,
        },
        {
            name: "土耳其芝麻包素漢堡配薯條",
            price: 98,
        },
    ];
    static final mains = [
        {
            name: "伊朗香草燉羊",
            price: 178,
        },
        {
            name: "格魯吉亞蒜香牛油雞扒",
            price: 148,
        },
        {
            name: "蜜糖芥末豬串骨配薯菜",
            price: 148,
        },
        {
            name: "辣酒煮蜆",
            price: 138,
        },
    ];

    static function printNamePrice(item:{name:String, price:Int}):String {
        return item.name + " $" + item.price;
    }

    static function printHalfPrice(item:{ name:String, price:Int }):String {
        return item.name + " +$" + (item.price * 0.5);
    }

    static public final LonelyPaisleyLunchSet = {
        title: "午市套餐",
        properties: {
            starter: {
                type: "string",
                title: "頭盤",
                "enum": [
                    "希臘哈洛米芝士沙律",
                ],
                "default": "希臘哈洛米芝士沙律",
            },
            main: {
                type: "string",
                title: "主菜",
                "enum": [
                    "土耳其烤雞肉卷 $78",
                    "墨西哥三重芝士雞肉餡餅配秘制四川麻辣醬 $88",
                    "番茄烤雞肉扁意粉 $88",
                    "白酒蒜香蜆肉扁意粉 $88",
                    "冬陰功海蝦、魷魚扁意粉 $98",
                    // "日式雞肉多利亞 - 雞肉、薯仔、芝士、長米飯 $98",
                    "全日早餐 - 煙肉、香腸、前蛋、煙三文魚、英式鬆餅 $108",
                    "斯里蘭卡香辣菠蘿大蝦配長米飯 $138",
                    "格魯吉亞蒜香牛油雞扒 $148",
                    "印度Masala慢煮牛肋條燴飯 $148",
                    "自家製阿根廷香辣青醬虎蝦海鮮扁意粉 $148",
                    "<素> 牛油果素菜卷 $78",
                    "<素> 墨西哥三重芝士餡餅配秘制四川麻辣醬 $88",
                    "<素> 土耳其芝麻包素漢堡配薯條 $98",
                    "<素> 全日早餐 純乳酪、牛油果、大啡菇、茄汁豆、煎蛋、英式鬆餅 $108",
                ],
            },
            drink: {
                type: "string",
                title: "飲品",
                "enum": [
                    "唔要",
                    "士耳其紅茶 +$0",
                    "蘋果茶(熱) +$0",
                    "檸檬蘇打水 +$0",
                ]
                    // 咖啡/奶類飲品半價
                    .concat(coffees.map(printHalfPrice))
                    .concat(milks.map(printHalfPrice))
                ,
            },
            dessert: {
                type: "string",
                title: "甜品",
                "enum": [
                    "土耳其開心果千層酥（一件） +$25",
                    "是日芝士蛋糕 +$30",
                ],
            },
        },
        required: [
            "starter",
            "main",
            "drink",
        ],
    }

    static public final LonelyPaisleySaladSnacks = {
        title: "Snacks",
        type: "string",
        "enum": saladSnacks.map(printNamePrice),
    };

    static public final LonelyPaisleyDessert = {
        title: "Dessert",
        type: "string",
        "enum": desserts.map(printNamePrice),
    };

    static public final LonelyPaisleyPastaRice = {
        title: "Pasta/Rice",
        type: "string",
        "enum": pastasRices.map(printNamePrice),
    };

    static public final LonelyPaisleyMain = {
        title: "Main",
        type: "string",
        "enum": mains.map(printNamePrice),
    };

    static public final LonelyPaisleyDrink = {
        title: "Drinks",
        type: "string",
        "enum": []
            .concat(coffees.map(printNamePrice))
            .concat(milks.map(printNamePrice))
            .concat(mocktails.map(printNamePrice))
            .concat(otherDrinks.map(printNamePrice))
        ,
    };

    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        return if (pickupTimeSlot == null || pickupTimeSlot.start == null) {
            type: "array",
            items: {
                type: "object",
            }
        } else {
            final itemDefs = [
                for (item in LonelyPaisleyItem.all(pickupTimeSlot))
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
        ?type:LonelyPaisleyItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        final def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case LunchSet:
                summarizeOrderObject(orderItem.item, def, ["starter","main","drink","dessert"]);
            case SaladSnacks | Dessert | PastaRice | Main | Drink:
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