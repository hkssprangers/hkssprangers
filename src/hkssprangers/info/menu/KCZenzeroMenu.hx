package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract KCZenzeroItem(String) to String {
    final HotdogSet;
    final NoodleSet;
    final PastaSet;
    final LightSet;
    final HotpotSet;
    final RiceSet;
    final Single;

    static public final all:ReadOnlyArray<KCZenzeroItem> = [
        HotdogSet,
        NoodleSet,
        PastaSet,
        LightSet,
        HotpotSet,
        RiceSet,
        Single,
    ];

    public function getDefinition():Dynamic return switch (cast this:KCZenzeroItem) {
        case HotdogSet: KCZenzeroMenu.KCZenzeroHotdogSet;
        case NoodleSet: KCZenzeroMenu.KCZenzeroNoodleSet;
        case PastaSet: KCZenzeroMenu.KCZenzeroPastaSet;
        case LightSet: KCZenzeroMenu.KCZenzeroLightSet;
        case HotpotSet: KCZenzeroMenu.KCZenzeroHotpotSet;
        case RiceSet: KCZenzeroMenu.KCZenzeroRiceSet;
        case Single: KCZenzeroMenu.KCZenzeroSingle;
    }
}

class KCZenzeroMenu {
    static public function KCZenzeroSetDrink(price:Float) return {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "自家沖洛神花冷泡茶" + (price > 0 ? ' (+$$$price)' : ""),
            "自家沖玫瑰烏龍冷泡茶" + (price > 0 ? ' (+$$$price)' : ""),
            "自家沖桂花烏龍冷泡茶" + (price > 0 ? ' (+$$$price)' : ""),
            "自家沖玄米冷泡茶" + (price > 0 ? ' (+$$$price)' : ""),
            "自家沖玄米綠茶" + (price > 0 ? ' (+$$$price)' : ""),
            "自家沖玫瑰百寶茶" + (price > 0 ? ' (+$$$price)' : ""),
        ],
    };

    static public final KCZenzeroSingle = {
        title: "小食",
        type: "string",
        "enum": [
            "辣茄醬蝦多士 $30",
            "水牛城雞翼 $30",
            "芝士肉醬燒大菇(辣) $25",
            "芝士肉醬燒大菇(唔辣) $25",
            "芝士茄父子(素) $25",
            "芝士波隆納肉醬薯格 $25",
            "流心奶黄牛角包 $10",
            "紫薯撻 $12",
            "芝士撻$12",
            "葡撻 $8",
        ],
    };

    static public final KCZenzeroHotdogSet = {
        title: "熱狗",
        properties: {
            main: {
                title: "熱狗 $38",
                type: "string",
                "enum": [
                    "波隆納肉醬熱狗",
                    "芝士蛋松露熱狗",
                    "薯格趣趣熱狗",
                    "芥末沙律三文魚熱狗",
                    "九龍皇帝熱狗",
                    "妙菇皇后熱狗",
                    "雙魚巨蟹熱狗",
                    "意式肉丸熱狗",
                ]
            },
            drink: KCZenzeroSetDrink(10),
        },
        required: [
            "main",
        ]
    }

    static public final KCZenzeroNoodleSet = {
        title: "意式濃厚蕃茄湯車仔粉",
        description: "蕃茄湯底車仔粉任選兩款主食 $48",
        properties: {
            options: {
                type: "array",
                title: "車仔粉主食選擇",
                description: "任選兩款，之後每款額外加 $5",
                items: {
                    type: "string",
                    "enum": [
                        "牛舌片",
                        "雞扒",
                        "煙鴨胸",
                        "蟹棒",
                        "司華力腸",
                        "意式肉丸",
                    ],
                },
                uniqueItems: true,
                minItems: 2,
            },
            noodle: {
                type: "string",
                title: "麵類選擇",
                "enum": [
                    "意粉",
                    "螺絲粉",
                ],
            },
            drink: KCZenzeroSetDrink(10),
        },
        required: [
            "options",
            "noodle",
        ]
    };

    static public final KCZenzeroPastaSet = {
        title: "意式Pasta",
        description: "任選醬汁/主食 $55",
        properties: {
            main: {
                type: "string",
                title: "Pasta主食選擇",
                "enum": [
                    "芝士流心漢堡",
                    "炸芝士海鮮條",
                    "香草雞扒",
                    "牛舌片",
                ],
            },
            sauce: {
                type: "string",
                title: "醬汁選擇",
                "enum": [
                    "肉醬(豬)",
                    "鮮茄蘑菇",
                    "意式卡邦尼",
                ],
            },
            noodle: {
                type: "string",
                title: "麵類選擇",
                "enum": [
                    "意粉",
                    "螺絲粉",
                ],
            },
            drink: KCZenzeroSetDrink(10),
        },
        required: [
            "main",
            "sauce",
            "noodle",
        ]
    };

    static public final KCZenzeroLightSet = {
        title: "輕量餐",
        description: "主食 + 沙律 + 飲品 $40",
        properties: {
            main: {
                type: "string",
                title: "主食選擇",
                "enum": [
                    "迷你肉醬烏冬",
                    "迷你熱狗",
                ],
            },
            salad: {
                type: "string",
                title: "沙律選擇",
                "enum": [
                    "蟹柳吞拿魚沙律",
                    "雞串吞拿魚沙律",
                ],
            },
            drink: KCZenzeroSetDrink(0),
        },
        required: [
            "main",
            "salad",
            "drink",
        ]
    };

    static public final KCZenzeroHotpotSet = {
        title: "一人癲雞煲 (要早一日預訂)",
        description: "有半隻春雞，跟發熱包 $68",
        properties: {
            soup: {
                type: "string",
                title: "湯底選擇",
                "enum": [
                    "蕃茄湯底",
                    "癲雞辣湯底",
                ],
            },
            options: {
                type: "array",
                title: "配料",
                items: {
                    type: "string",
                    "enum": [
                        "響鈴、娃娃菜、烏冬 (+$15)",
                    ],
                },
                uniqueItems: true,
            },
        },
        required: [
            "soup",
        ]
    };

    static public final KCZenzeroRiceSet = {
        title: "飯類",
        properties: {
            main: {
                title: "飯類",
                type: "string",
                "enum": [
                    "紅酒肉醬翠蛋飯 $48",
                ]
            },
            drink: KCZenzeroSetDrink(10),
        },
        required: [
            "main",
        ]
    }
    
    static public function itemsSchema(order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: KCZenzeroItem.all.map(item -> {
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
            items: order.items == null ? [] : order.items.map(item -> {
                var itemSchema:Dynamic = itemSchema();
                switch (cast item.type:KCZenzeroItem) {
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
}