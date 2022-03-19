package hkssprangers.info.menu;

import haxe.ds.ReadOnlyArray;
import js.lib.Object;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;
using Lambda;

enum abstract LonelyPaisleyItem(String) to String {
    final MakeYourOwnChoiceSet;
    final LunchSet;
    // final Brunch;
    // final Salad;
    final Snacks;
    final Dessert;
    final PastaRice;
    final Main;
    final Drink;

    static public function all(timeSlot:TimeSlot):ReadOnlyArray<LonelyPaisleyItem> {
        if (timeSlot == null || timeSlot.start == null){
            return [];
        }
        return switch [Weekday.fromDay(timeSlot.start.toDate().getDay()), TimeSlotType.classify(timeSlot.start)] {
            case [Monday | Tuesday | Wednesday | Thursday | Friday, Lunch]:
                [
                    MakeYourOwnChoiceSet,
                    LunchSet,
                    // Brunch,
                    // Salad,
                    Snacks,
                    Dessert,
                    PastaRice,
                    Main,
                    Drink,
                ];
            case [_, Lunch]:
                [
                    // Brunch,
                    // Salad,
                    Snacks,
                    Dessert,
                    PastaRice,
                    Main,
                    Drink,
                ];
            case [_, Dinner]:
                [
                    MakeYourOwnChoiceSet,
                    // Salad,
                    Snacks,
                    Dessert,
                    PastaRice,
                    Main,
                    Drink,
                ];
            case [weekday, timeSlotType]:
                trace(weekday + " " + timeSlotType);
                [];
        }
    }

    public function getDefinition():Dynamic return switch (cast this:LonelyPaisleyItem) {
        case MakeYourOwnChoiceSet: LonelyPaisleyMenu.LonelyPaisleyMakeYourOwnChoiceSet;
        case LunchSet: LonelyPaisleyMenu.LonelyPaisleyLunchSet;
        // case Brunch: LonelyPaisleyMenu.LonelyPaisleyBrunch;
        // case Salad: LonelyPaisleyMenu.LonelyPaisleySalad;
        case Snacks: LonelyPaisleyMenu.LonelyPaisleySnacks;
        case Dessert: LonelyPaisleyMenu.LonelyPaisleyDessert;
        case PastaRice: LonelyPaisleyMenu.LonelyPaisleyPastaRice;
        case Main: LonelyPaisleyMenu.LonelyPaisleyMain;
        case Drink: LonelyPaisleyMenu.LonelyPaisleyDrink;
    }
}

class LonelyPaisleyMenu {
    static final coffees = [
        {
            name: "ESPRESSO (HOT)",
            description: null,
            price: 33,
        },
        {
            name: "LONG BLACK (HOT)",
            description: null,
            price: 33,
        },
        {
            name: "AMERICANO (HOT)",
            description: null,
            price: 33,
        },
        {
            name: "AMERICANO (COLD)",
            description: null,
            price: 39,
        },
        {
            name: "WHITE (HOT)",
            description: null,
            price: 40,
        },
        {
            name: "WHITE (COLD)",
            description: null,
            price: 46,
        },
        {
            name: "PICCOLO (HOT)",
            description: null,
            price: 38,
        },
        {
            name: "DIRTY (COLD)",
            description: null,
            price: 44,
        },
        {
            name: "MOCHA (HOT)",
            description: null,
            price: 44,
        },
        {
            name: "MOCHA (COLD)",
            description: null,
            price: 50,
        },
        {
            name: "BLACK SUGAR ROSE LATTE (HOT)",
            description: null,
            price: 44,
        },
        {
            name: "TONIC COFFEE (COLD)",
            description: null,
            price: 58,
        },
        {
            name: "GINGER ALE COFFEE (COLD)",
            description: null,
            price: 58,
        },
        // {
        //     name: "TRADITIONAL VIETNAMESE FILITERED COFFEE SET",
        //     description: "served with condensed milk, ice and tea",
        //     price: 68,
        // },
    ];
    static final milks = [
        {
            name: "CHOCOLATE (HOT)",
            description: null,
            price: 44,
        },
        {
            name: "CHOCOLATE (COLD)",
            description: null,
            price: 50,
        },
        {
            name: "MATCHA (HOT)",
            description: null,
            price: 46,
        },
        {
            name: "MATCHA (COLD)",
            description: null,
            price: 52,
        },
        {
            name: "HONG KONG REAL GINGER CACAO",
            description: "local organic ginger mixed with raw cacao by Very Ginger HK",
            price: 48,
        },
    ];
    static final teas = [
        // {
        //     name: "SPANISH DESSERT TEA (CAFFEINE-FREE)",
        //     description: "rooibos / chocolate / raspberry / rose petals / cornflower flower",
        //     price: 68,
        // },
        // {
        //     name: "ALHAMBRA’S LOVE",
        //     description: "green tea / black tea / hibiscus / mallow / roses",
        //     price: 68,
        // },
        // {
        //     name: "NIGHT, ISTANBUL",
        //     description: "tropical fruit mix / cinnamon / pink rose bud / ginger / hibiscus / camomile / calendula",
        //     price: 88,
        // },
    ];
    static final mocktails = [
        // {
        //     name: "BLUE LAGOON",
        //     description: "blue curacao / lemonade / grapefruit juice / icing rim",
        //     price: 58,
        // },
        // {
        //     name: "REMEMBER ME",
        //     description: "pineapple / lime / lemon / honey / jalapeno",
        //     price: 68,
        // },
        {
            name: "SALEP (HOT)",
            description: "(TURKISH TRADITIONAL DRINK) salep / milk / cinnamon / pistachio",
            price: 68,
        },
        {
            name: "TOKHM-E SHARBATI",
            description: "(IRANIAN TRADITIONAL DRINK) basil seed / lime / rose water / mint",
            price: 58,
        },
        // {
        //     name: "DOOGH",
        //     description: "(AFGHANISTAN TRADITIONAL DRINK) yogurt / mint / cucumber / nutmeg / salt / honey",
        //     price: 58,
        // },
    ];
    static final otherDrinks = [
        {
            name: "LITHUANIAN KVAS",
            description: "rye ale",
            price: 48,
        },
        {
            name: "TURKISH POMEGRANATE SPARKLING",
            description: null,
            price: 28,
        },
    ];
    static final craftBeers = [
        {
            name: "TWILIGHT (H.K.LOVECRAFT)",
            description: "style: Salted Caramel Lager / abv: 5% / ibu: 18 | salty, sweetness, caramel",
            price: 78,
        },
        {
            name: "CHUN FA LOK 春花落 (H.K.LOVECRAFT)",
            description: "style: IPL / abv: 5.5% / ibu: 35 | light, clean, lychee, pineapple",
            price: 78,
        },
        {
            name: "SPACE ROCK (H.K. LOVECRAFT)",
            description: "style: Rauchbier / abv: 5.5% / ibu: 23 | smoky, caramel, rich maltiness",
            price: 68,
        },
        {
            name: "MOTHER GOAT (H.K.LOVECRAFT)",
            description: "style: Doppelbock / abv: 8% / ibu: 25 | rich, honey, peppery",
            price: 78,
        },
        {
            name: "OLD BLOOD (H.K.LOVECRAFT)",
            description: "style: Dunkel(Dark lager) / abv: 5% / ibu: 25 | roasty, toffee, malty bitterness",
            price: 78,
        },
        {
            name: "IT’S MANUKA (TAI WAI BEER 大圍啤)",
            description: "style: Tea Ale / abv: 5% ibu: 20 | strawberry, honey, tea, light",
            price: 68,
        },
        {
            name: "JASMINE & PASSION FRUIT (TAI WAI BEER 大圍啤)",
            description: "style: Tea Ale / abv: 3.9% ibu: 21.8 | jasmine, passion fruit, tea, light",
            price: 68,
        },
        {
            name: "CHAMOMILE (TAI WAI BEER 大圍啤)",
            description: "style: Tea Ale / abv: 5.1% ibu: 22.9 | chamomile, tea, light",
            price: 68,
        },
        // {
        //     name: "MIRROR MIRROR (DEADMAN)",
        //     description: "style: APA / abv: 5.4% / ibu: 30 | refreshing, citrus, floral, tropical fruit",
        //     price: 68,
        // },
        {
            name: "DUCHESS NIGHT OUT (DEADMAN)",
            description: "style: Flanders - Inspired Sour Red Ale / abv: 6% / ibu: 9 | oaky, cherry, berries, dark fruit",
            price: 68,
        },
        {
            name: "RAINBOW SHERBET SOUR (GWEI-LO)",
            description: "style: Sour / abv: 6% ibu: 10 | raspberry puree, lemon zest, satisfying body",
            price: 78,
        },
        {
            name: "CONGA LINES - PASSION FRUIT PINEAPPLE IMPERIAL ICE CREAM SOUR ALE (MOON DOG)",
            description: "style: Pastry sour / abv: 7.5% ibu: 0 | pastry, sour, pineapple",
            price: 78,
        },
        {
            name: "CHOC COCONUT SHAKE CHOCOLATE MILKSHAKE NEBIPA (3 RAVENS)",
            description: "style: IPA - Milkshake / abv: 6% / ibu: 0 | chocolate, coconut, creamy",
            price: 88,
        },
        {
            name: "MANGO TANGO FRUITED SOUR (DEEP CREEK)",
            description: "style: Fruited Sour / abv: 5% ibu: o | mango, sour, refreshing",
            price: 88,
        },
        {
            name: "DRAFT (EFES - TURKEY)",
            description: "style: Lager / abv: 5% / ibu: n/a | woody, maltiness, light",
            price: 48,
        },
    ];
    static final brunches = [
        // {
        //     name: "土耳其早餐．附土耳其茶",
        //     description: "3 types of cheese / jam / acuka / cream / honey / simit / egg with sausage / tomato / cucumber / Turkish tea",
        //     price: 148,
        // },
        // {
        //     name: "土耳其早餐．附土耳其茶 + extra Simit",
        //     description: "3 types of cheese / jam / acuka / cream / honey / simit / egg with sausage / tomato / cucumber / Turkish tea",
        //     price: 148 + 38,
        // },
        // {
        //     name: "挪威煙三文魚班尼迪蛋",
        //     description: "2 poached Japanese eggs / smoked-salmon / bread / garden green / avocado sauce",
        //     price: 88,
        // },
        // {
        //     name: "美式早餐",
        //     description: "avocado / sausage / scramble Japanese egg / portobello mushroom / muffin / garden green",
        //     price: 108,
        // },
        // {
        //     name: "美式早餐 + Smoked salmon",
        //     description: "avocado / sausage / scramble Japanese egg / portobello mushroom / muffin / garden green / smoked salmon",
        //     price: 108 + 20,
        // },
    ];
    static final snacks = [
        {
            name: "玫瑰蜜糖雞翼",
            description: null,
            price: 68,
        },
        // {
        //     name: "印度脆球配虎蝦冬陰公",
        //     description: null,
        //     price: 88,
        // },
        {
            name: "墨西哥三重芝士雞肉餡餅配自家制四川麻辣醬",
            description: null,
            price: 88,
        },
        {
            name: "土耳其烤雞肉卷",
            description: null,
            price: 78,
        },
        {
            name: "墨西哥玉米片配自家制牛油果醬",
            description: null,
            price: 48,
        },
        {
            name: "台式芝士肉鬆雞蛋餅配台式醬油",
            description: null,
            price: 58,
        },
        {
            name: "炸粗薯條配自家制黑蒜醬",
            description: null,
            price: 58,
        },
        {
            name: "印度薄餅",
            description: null,
            price: 20,
        },
        {
            name: "印度薄餅+黑蒜醬",
            description: null,
            price: 20 + 10,
        },
    ];
    static final desserts = [
        {
            name: "土耳其開心果千層酥 (2ps)",
            description: null,
            price: 58,
        },
        {
            name: "熱情果芒果芝士蛋糕",
            description: null,
            price: 48,
        },
        {
            name: "日本柚子芝士蛋糕",
            description: null,
            price: 48,
        },
    ];
    static final pastasRices = [
        // {
        //     name: "意大利傳統卡邦尼意粉",
        //     description: null,
        //     price: 108,
        // },
        {
            name: "阿根廷香辣青醬虎蝦海鮮扁意粉",
            description: null,
            price: 148,
        },
        {
            name: "本地手工煙燻啤酒煮牛肋條燴飯",
            description: null,
            price: 148,
        },
        {
            name: "馬來西亞藍花飯 配素菜、素森巴醬",
            description: null,
            price: 128,
        },
        {
            name: "泰式青咖哩素菜",
            description: null,
            price: 88,
        },
    ];
    static final mains = [
        {
            name: "伊朗香草燉羊",
            description: null,
            price: 168,
        },
        {
            name: "格魯吉亞蒜香牛油雞扒",
            description: null,
            price: 148,
        },
        {
            name: "地中海白酒藍青口",
            description: null,
            price: 148,
        },
        {
            name: "異國香腸拼盤配雜菌翠玉瓜",
            description: null,
            price: 108,
        },
    ];

    static function printNamePrice(item:{name:String, price:Int}):String {
        return item.name + " $" + item.price;
    }

    static function printHalfPrice(item:{ name:String, price:Int }):String {
        return item.name + " +$" + (item.price * 0.5);
    }

    static public final LonelyPaisleyMakeYourOwnChoiceSet = {
        title: "香港人有得揀套餐",
        properties: {
            riceOrPasta: {
                type: "string",
                title: "飯／意粉",
                "enum": [
                    "椰汁藍花飯 $68",
                    "扁意粉 $68",
                    "圓意粉 $68",
                ],
            },
            meatOrSeafoodOptions: {
                type: "array",
                description: "選一。額外一款+$15。",
                title: "肉類／海鮮",
                items: {
                    type: "string",
                    "enum": [
                        "雞肉",
                        "肥牛",
                        "豬腩片",
                        "魷魚",
                        "蟹肉",
                        "海蝦",
                    ],
                },
                uniqueItems: true,
                minItems: 1,
            },
            vegOptions: {
                type: "array",
                description: "選一。額外一款+$8。",
                title: "素菜",
                items: {
                    type: "string",
                    "enum": [
                        "洋蔥",
                        "雜菌",
                        "椰菜",
                        "粟米仔",
                        "彩椒",
                        "意瓜",
                        "蘆筍",
                        "車厘茄",
                    ],
                },
                uniqueItems: true,
                minItems: 1,
            },
            sauce: {
                type: "string",
                title: "醬汁",
                "enum": [
                    "自家製蕃茄汁",
                    "自家製麻辣汁",
                    "忌廉白汁",
                    "<泰國> 青咖喱",
                    "<泰國> 冬陰功",
                    "<韓國> 辣椒醬",
                    "<阿根廷> 自家製香辣青醬",
                    "<馬來西亞> 森巴醬",
                ],
            },
            drink: {
                type: "string",
                title: "飲品",
                "enum": [
                    "土耳其茶 +$0",

                    // +$8 汽水
                    '可樂 +$8',
                    '雪碧 +$8',
                ]
                    // 半價 餐牌非酒精飲品
                    .concat(coffees.map(printHalfPrice))
                    .concat(milks.map(printHalfPrice))
                    .concat(teas.map(printHalfPrice))
                    .concat(mocktails.map(printHalfPrice))
                    .concat(otherDrinks.map(printHalfPrice))
                ,
            },
        },
        required: [
            "riceOrPasta",
            "meatOrSeafoodOptions",
            "vegOptions",
            "sauce",
            "drink",
        ],
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
                    "土耳其雞肉卷 $78",
                    "墨西哥三重芝士雞肉餡餅配秘制四川麻辣醬 $88",
                    "泰式青咖哩素菜 $88",
                    "番茄雞肉意粉 $88",
                    "雞翼、香腸、溫泉蛋配藍花飯、秘制醬油 $88",
                    "意大利傳統卡邦尼意粉 $108",
                    "異國香腸拼盤配雜菌翠玉瓜 $108",
                    "馬來西亞藍花飯配素菜、本地素森巴醬 $128",
                    "本地手工煙燻䏜酒煮牛肋條䱀飯 $148",
                    "阿根廷香辣青醬虎蝦海鮮扁意粉 $148",
                    "格魯吉亞蒜香牛油雞䓻 $148",
                    "地中海白酒藍青口 $148",
                ],
            },
            drink: {
                type: "string",
                title: "飲品",
                "enum": [
                    "美式咖啡 +$0",
                    "土耳其茶 +$0",
                    '可樂 +$0',
                    '雪碧 +$0',
                    '蘇打水 +$0',
                ]
                    // 半價 非酒精飲品
                    .concat(coffees.map(printHalfPrice))
                    .concat(milks.map(printHalfPrice))
                    .concat(teas.map(printHalfPrice))
                    .concat(mocktails.map(printHalfPrice))
                    .concat(otherDrinks.map(printHalfPrice))
                ,
            },
            dessert: {
                type: "string",
                title: "甜品",
                "enum": [
                    "土耳其開心果千層酥（一件） +$25",
                    // "是日芝士蛋糕 +$30",
                ],
            },
        },
        required: [
            "starter",
            "main",
            "drink",
        ],
    }

    static public final LonelyPaisleyBrunch = {
        title: "Brunch",
        type: "string",
        "enum": brunches.map(printNamePrice),
    };

    static public final LonelyPaisleySnacks = {
        title: "Snacks",
        type: "string",
        "enum": snacks.map(printNamePrice),
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
            .concat(teas.map(printNamePrice))
            .concat(mocktails.map(printNamePrice))
            .concat(otherDrinks.map(printNamePrice))
            .concat(craftBeers.map(printNamePrice))
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
            case MakeYourOwnChoiceSet:
                summarizeOrderObject(orderItem.item, def, ["riceOrPasta","meatOrSeafoodOptions","vegOptions","sauce","drink"], null, (fieldName, value) -> switch fieldName {
                    case "meatOrSeafoodOptions":
                        final price = switch (value != null ? value.length : 0) {
                            case 0, 1:
                                0;
                            case n:
                                (n - 1) * 15;
                        };
                        {
                            value: value != null ? value.join(",") : "",
                            price: price,
                        }
                    case "vegOptions":
                        final price = switch (value != null ? value.length : 0) {
                            case 0, 1:
                                0;
                            case n:
                                (n - 1) * 8;
                        };
                        {
                            value: value != null ? value.join(",") : "",
                            price: price,
                        }
                    case _: 
                        {
                            price: null,
                        };
                });
            case LunchSet:
                summarizeOrderObject(orderItem.item, def, ["starter","main","drink","dessert"]);
            case Snacks | Dessert | PastaRice | Main | Drink:
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