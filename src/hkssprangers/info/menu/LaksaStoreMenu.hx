package hkssprangers.info.menu;

import hkssprangers.browser.forms.OrderForm.OrderData;
import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract LaksaStoreItem(String) to String {
    final NoodleSet;
    final RiceSet;

    static public final all:ReadOnlyArray<LaksaStoreItem> = [
        NoodleSet,
        RiceSet,
    ];

    public function getDefinition():Dynamic return switch (cast this:LaksaStoreItem) {
        case NoodleSet: LaksaStoreMenu.LaksaStoreNoodleSet;
        case RiceSet: LaksaStoreMenu.LaksaStoreRiceSet;
    }
}

class LaksaStoreMenu {
    static public final LaksaStoreSetDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "烏龍茶紙包飲品",
            "蜂蜜綠茶紙包飲品",
            "柑桔檸檬紙包飲品",
            "支裝水",
            "罐裝可樂",
            "罐裝可樂 zero",
            "罐裝雪碧",
            "罐裝忌廉",
        ],
    };

    static public final LaksaStoreNoodleSet = {
        title: "喇沙 / 冬蔭公",
        description: "套餐: 湯麵 + 飲品 ($50)",
        properties: {
            soup: {
                title: "湯底選擇",
                type: "string",
                "enum": [
                    "喇沙",
                    "冬蔭公",
                ]
            },
            ingredient: {
                type: "string",
                title: "配料選擇",
                description: "「新」四寶 = 霸王卷(魚), 甜不辣(魚), 蝦卷(雜菜,蝦), 哈哈笑丸(咸蛋流心丸)",
                "enum": [
                    "雞扒",
                    "豬扒",
                    "大蝦",
                    "野菌肥牛",
                    "牛舌",
                    "「新」四寶",
                ],
            },
            noodle: {
                type: "string",
                title: "麵類選擇",
                "enum": [
                    "上海幼麵",
                    "米線",
                    "米粉",
                    "油麵",
                ],
            },
            drink: LaksaStoreSetDrink,
        },
        required: [
            "soup",
            "ingredient",
            "noodle",
            "drink",
        ]
    };

    static public final LaksaStoreRiceSet = {
        title: "飯類",
        properties: {
            main: {
                title: "飯類",
                type: "string",
                "enum": [
                    "芝茄肉醬飯 $40",
                ]
            },
            drink: LaksaStoreSetDrink,
        },
        required: [
            "main",
            "drink",
        ]
    }
    
    static public function itemsSchema(order:OrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: LaksaStoreItem.all.map(item -> {
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
                switch (cast item.type:LaksaStoreItem) {
                    case null:
                        //pass
                    case NoodleSet:
                        Object.assign(itemSchema.properties, {
                            item: NoodleSet.getDefinition(),
                        });
                    case RiceSet:
                        Object.assign(itemSchema.properties, {
                            item: RiceSet.getDefinition(),
                        });
                }
                itemSchema;
            }),
            additionalItems: itemSchema(),
            minItems: 1,
        };
    }
}