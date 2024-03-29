package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract MinimalItem(String) to String {
    // 窩夫 冇得外賣
    final SetFor2;
    final SetFor4;
    final Tacos;
    final Salad;
    final Main;
    final SousVide;
    final Dessert;

    static public final all:ReadOnlyArray<MinimalItem> = [
        // SetFor2,
        // SetFor4,
        Tacos,
        Salad,
        Main,
        SousVide,
        Dessert,
    ];

    public function getDefinition():Dynamic return switch (cast this:MinimalItem) {
        case SetFor2: MinimalMenu.MinimalSetFor2;
        case SetFor4: MinimalMenu.MinimalSetFor4;
        case Tacos: MinimalMenu.MinimalTacos;
        case Salad: MinimalMenu.MinimalSalad;
        case Main: MinimalMenu.MinimalMain;
        case SousVide: MinimalMenu.MinimalSousVide;
        case Dessert: MinimalMenu.MinimalDessert;
    }
}

class MinimalMenu {
    static function printNamePrice(item:{name:String, price:Int}):String {
        return item.name + " $" + item.price;
    }

    static public final legends = "(v.) = Vegetarian, (h.) = Hot & Spicy";

    static final drinks = [
        { name: "美式咖啡(熱)", price: 38 },
        { name: "美式咖啡(凍)", price: 42 },
        { name: "拿鐵咖啡(熱)", price: 40 },
        { name: "拿鐵咖啡(凍)", price: 44 },
        { name: "卡布奇諾(熱)", price: 40 },
        { name: "玫瑰咖啡(熱)", price: 42 },
        { name: "玫瑰咖啡(凍)", price: 46 },
        { name: "焦糖拿鐵(熱)", price: 42 },
        { name: "焦糖拿鐵(凍)", price: 46 },
        { name: "焦糖卡布奇諾(熱)", price: 42 },
        { name: "朱古力咖啡(熱)", price: 42 },
        { name: "朱古力咖啡(凍)", price: 46 },
        { name: "薄荷朱古力咖啡(熱)", price: 44 },
        { name: "薄荷朱古力咖啡(凍)", price: 48 },
        { name: "Baileys latte(熱)", price: 44 },
        { name: "Baileys latte(凍)", price: 48 },
        { name: "Espresso Tonic(凍)", price: 48 },
        // { name: "Dirty(凍)", price: 44 },
        { name: "紅豆牛奶咖啡(凍)", price: 48 },
        { name: "焦糖朱古力咖啡(熱)", price: 44 },
        { name: "焦糖朱古力咖啡(凍)", price: 48 },
        { name: "榛子咖啡(熱)", price: 42 },
        { name: "榛子咖啡(凍)", price: 46 },

        { name: "朱古力鮮奶(熱)", price: 40 },
        { name: "朱古力鮮奶(凍)", price: 44 },
        { name: "薄荷朱古力(熱)", price: 42 },
        { name: "薄荷朱古力(凍)", price: 46 },
        { name: "抹茶鮮奶(熱)", price: 46 },
        { name: "抹茶鮮奶(凍)", price: 50 },
        { name: "焙茶鮮奶(熱)", price: 44 },
        { name: "焙茶鮮奶(凍)", price: 46 },
        { name: "焙茶燕麥朱古力(熱)", price: 46 },
        { name: "焙茶燕麥朱古力(凍)", price: 50 },
        { name: "Baileys朱古力(熱)", price: 42 },
        { name: "Baileys朱古力(凍)", price: 46 },
        { name: "草莓朱古力(凍)", price: 48 },

        { name: "火龍果乳酪", price: 48 },
        { name: "芒果乳酪", price: 48 },
        { name: "士多啤梨乳酪", price: 52 },

        { name: "蝶豆花柚子梳打", price: 46 },
        { name: "洛神花蜂蜜青檸梳打", price: 46 },
        { name: "青梳打(青檸青蘋果梳打)", price: 46 },
        { name: "黑加倫子檸檬梳打", price: 46 },
        { name: "繽紛梳打(香橙桃梳打)", price: 46 },
        // { name: "雪糕波子汽水", price: 50 },

        { name: "茶包-英式早餐茶", price: 36 },
        { name: "茶包-有機大吉嶺", price: 36 },
        { name: "茶包-洋甘菊", price: 36 },
        { name: "茶包-綠茶", price: 36 },
    ];
    
    static final drinksForFood = drinks.map(v -> { name: v.name, price: v.price - 10 });

    static final tacos = [
        { name: "牛油果雞胸肉配芒果醬夾餅配薯角", price: 105 },
        { name: "洋蔥壽喜燒牛肉夾餅配薯角", price: 110 },
    ];
    static public final MinimalTacos = {
        title: "夾餅",
        // description: legends,
        properties: {
            main: {
                title: "夾餅",
                type: "string",
                "enum": tacos.map(printNamePrice),
            },
            drink: {
                title: "飲品",
                type: "string",
                "enum": drinksForFood.map(printNamePrice),
            },
        },
        required: [
            "main",
        ],
    };

    static final salads = [
        { name: "無花果雞胸肉凱撒沙律", price: 90 },
        // { name: "雞胸肉蕃茄沙律", price: 85 },
    ];

    static public final MinimalSalad = {
        title: "沙律",
        // description: legends,
        properties: {
            main: {
                title: "沙律",
                type: "string",
                "enum": salads.map(printNamePrice),
            },
            drink: {
                title: "飲品",
                type: "string",
                "enum": drinksForFood.map(printNamePrice),
            },
        },
        required: [
            "main",
        ],
    };

    static final mains = [
        { name: "芫茜苗香辣大蝦扁意粉(h.)", price: 105 },
        { name: "溫泉蛋什菌牛肝菌汁貓耳朵粉(v.)", price: 105 },
        { name: "生煎鴨胸配煙花女汁辣肉腸燴飯(h.)", price: 115},
        { name: "煎琵琶蝦海鮮牛油果米型粉", price: 138},
        { name: "自家製意式雜菜湯配青醬芝士雲吞(v.)", price: 105 },
        { name: "鮮刨松露白肉醬意粉", price: 115 },
    ];

    static public final MinimalMain = {
        title: "主食",
        description: legends,
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": mains.map(printNamePrice),
            },
            drink: {
                title: "飲品",
                type: "string",
                "enum": drinksForFood.map(printNamePrice),
            },
        },
        required: [
            "main",
        ],
    };

    static final sousVides = [
        { name: "鮮刨松露西班牙豬扒", price: 138 },
        { name: "安格斯牛肉眼(6oz)", price: 168 },
    ];

    static public final MinimalSousVide = {
        title: "慢煮/肉類",
        // description: legends,
        properties: {
            main: {
                title: "慢煮/肉類",
                type: "string",
                "enum": sousVides.map(printNamePrice),
            },
            drink: {
                title: "飲品",
                type: "string",
                "enum": drinksForFood.map(printNamePrice),
            },
        },
        required: [
            "main",
        ],
    };

    static public final MinimalDrinks = {
        title: "跟餐飲品",
        properties: {
            drink: {
                title: "飲品",
                type: "string",
                "enum": drinksForFood.map(printNamePrice),
            },
            milkOption: {
                title: "選項",
                type: "string",
                "enum": [
                    "Oat milk +$5",
                    "Soy milk +$3",
                ],
            },
        },
        required: [
            "drink",
        ]
    };

    static public final MinimalDessert = {
        title: "甜品",
        description: "(A) = with Alcoho",
        properties: {
            main: {
                title: "甜品",
                type: "string",
                // 甜品只有拿破崙同蘋果可以外賣
                "enum": [
                    // "意大利芝士蛋糕(A) $80",
                    // "法式多士 $84",
                    "薄脆拿破崙 $80",
                    "蘋果酥盒(A) $84",
                    // "鐵觀音伊予柑慕思 $80",
                    // "椰子奶蓋芒果蛋白脆(A) $80",
                ],
            },
            drink: {
                title: "飲品",
                type: "string",
                "enum": drinksForFood.map(printNamePrice),
            },
        },
        required: [
            "main",
        ], 
    };

    static public final MinimalSetFor2 = {
        title: "二人套餐",
        description: "二人套餐 $302",
        properties: {
            salad: {
                title: "沙律",
                type: "string",
                "enum": salads.map(v -> v.name),
            },
            main1: {
                title: "主食一",
                type: "string",
                "enum": mains.concat(tacos).map(v -> v.name + (v.price <= 100 ? "" : " +$" + (v.price - 100))),
            },
            main2: {
                title: "主食二",
                type: "string",
                "enum": mains.concat(tacos).map(v -> v.name + (v.price <= 100 ? "" : " +$" + (v.price - 100))),
            },
            drink1: {
                title: "飲品一",
                type: "string",
                "enum": ["唔要"].concat(drinks.map(v -> v.name)),
            },
            drink2: {
                title: "飲品二",
                type: "string",
                "enum": ["唔要"].concat(drinks.map(v -> v.name)),
            },
        },
        required: [
            "salad",
            "main1",
            "main2",
            "drink1",
            "drink2",
        ]
    };

    static public final MinimalSetFor4 = {
        title: "四人套餐",
        description: "四人套餐 $628",
        properties: {
            salad1: {
                title: "沙律一",
                type: "string",
                "enum": salads.map(v -> v.name),
            },
            salad2: {
                title: "沙律二",
                type: "string",
                "enum": salads.map(v -> v.name),
            },
            main1: {
                title: "主食一",
                type: "string",
                "enum": mains.concat(tacos).map(v -> v.name + (v.price <= 100 ? "" : " +$" + (v.price - 100))),
            },
            main2: {
                title: "主食二",
                type: "string",
                "enum": mains.concat(tacos).map(v -> v.name + (v.price <= 100 ? "" : " +$" + (v.price - 100))),
            },
            sousVides: {
                title: "慢煮/肉類",
                type: "string",
                "enum": [sousVides[0].name + " + " + sousVides[1].name],
                "default": sousVides[0].name + " + " + sousVides[1].name,
            },
            drink1: {
                title: "飲品一",
                type: "string",
                "enum": ["唔要"].concat(drinks.map(v -> v.name)),
            },
            drink2: {
                title: "飲品二",
                type: "string",
                "enum": ["唔要"].concat(drinks.map(v -> v.name)),
            },
            drink3: {
                title: "飲品三",
                type: "string",
                "enum": ["唔要"].concat(drinks.map(v -> v.name)),
            },
            drink4: {
                title: "飲品四",
                type: "string",
                "enum": ["唔要"].concat(drinks.map(v -> v.name)),
            },
        },
        required: [
            "salad1",
            "salad2",
            "main1",
            "main2",
            "sousVides",
            "drink1",
            "drink2",
            "drink3",
            "drink4",
        ]
    };
    
    static public function itemsSchema(order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: MinimalItem.all.map(item -> {
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
                switch (cast item.type:MinimalItem) {
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
        ?type:MinimalItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case SetFor2:
                summarizeOrderObject(orderItem.item, def, MinimalSetFor2.required, [MinimalSetFor2.description]);
            case SetFor4:
                summarizeOrderObject(orderItem.item, def, MinimalSetFor4.required, [MinimalSetFor4.description]);
            case Tacos | Salad | Main | SousVide | Dessert:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"]);
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