package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract MGYItem(String) to String {
    final SingleDish;
    final Rice;
    final Noodle;
    final Sub;

    static public final all:ReadOnlyArray<MGYItem> = [
        SingleDish,
        Rice,
        Noodle,
        Sub,
    ];

    public function getDefinition():Dynamic return switch (cast this:MGYItem) {
        case SingleDish: MGYMenu.MGYSingleDish;
        case Rice: MGYMenu.MGYRice;
        case Noodle: MGYMenu.MGYNoodle;
        case Sub: MGYMenu.MGYSub;
    }
}

class MGYMenu {
    static public final MGYSingleDish = {
        title: "小菜",
        description: "小菜 $53. 請注意每份會另加外賣盒收費 $1",
        properties: {
            dish: {
                title: "小菜",
                type: "string",
                "enum": [
                    "豉汁素楊玉",
                    "咕嚕素芝球",
                    "泰式西芹花枝片",
                    "鮮茄燜枝竹",
                    "白汁粟米蓉金磚豆卜",
                    "如香茄子",
                    "欖菜菇絲芸豆",
                    "瓣醬豆腐",
                    "香草焗薯角",
                    "香椿鮮菇燜淮山",
                    "咖哩薯仔",
                    "八珍豆腐時蔬",
                    "豉汁尖椒",
                    "豉汁菇片炒涼瓜",
                    "香椿如腐雲耳炒勝瓜",
                    "黑椒菇角炒脆玉瓜",
                    "金菇絲燴娃娃菜",
                    "羅漢齋",
                ]
            },
        },
        required: [
            "dish",
        ]
    }

    static public final MGYRice = {
        title: "客飯 / 炒粉飯 / 日式冷麵",
        description: "客飯配白飯及例湯. 請注意每份會另加外賣盒收費 $1",
        properties: {
            rice: {
                type: "string",
                title: "客飯 / 炒粉飯 / 日式冷麵",
                "enum": [
                    "豉汁素楊玉(客飯) $58",
                    "咕嚕素芝球(客飯) $58",
                    "泰式西芹花枝片(客飯) $58",
                    "鮮茄燜枝竹(客飯) $58",
                    "白汁粟米蓉金磚豆卜(客飯) $58",
                    "如香茄子(客飯) $58",
                    "欖菜菇絲芸豆(客飯) $58",
                    "瓣醬豆腐(客飯) $58",
                    "香草焗薯角(客飯) $58",
                    "香椿鮮菇燜淮山(客飯) $58",
                    "咖哩薯仔(客飯) $58",
                    "八珍豆腐時蔬(客飯) $58",
                    "豉汁尖椒(客飯) $58",
                    "豉汁菇片炒涼瓜(客飯) $58",
                    "香椿如腐雲耳炒勝瓜(客飯) $58",
                    "黑椒菇角炒脆玉瓜(客飯) $58",
                    "金菇絲燴娃娃菜(客飯) $58",
                    "羅漢齋(客飯) $58",
                    "香椿松子炒飯 $43",
                    "黃薑瓜粒炒飯 $43",
                    "黑椒蘑菇意粉 $43",
                    "羅漢齋烏冬 $43",
                    "日式冷麵-蕎麥麵配羽衣甘藍 $53",
                    "日式冷麵-抹茶麵配羽衣甘藍 $53",
                ],
            },
        },
        required: [
            "rice",
        ]
    };

    static public final MGYNoodle = {
        title: "濃湯粉麵套餐",
        description: "濃湯粉麵套餐 $43. 請注意每個餐會另加外賣盒收費 $1",
        properties: {
            main: {
                type: "string",
                title: "主食選擇",
                "enum": [
                    "時菜",
                    "楊玉",
                    "醬燒BB菇",
                    "片頭",
                    "脆珠",
                    "餃子",
                    "如寶",
                    "花枝丸",
                ],
            },
            noodle: {
                type: "string",
                title: "麵類選擇",
                "enum": [
                    "米線",
                    "蕎麥麵 (+$5)",
                    "烏冬 (+$5)",
                    "抹茶麵 (+$5)",
                ],
                "default": "米線",
            },
            sub: {
                type: "string",
                title: "小食選擇",
                "enum": [
                    "炸餃子(2件)",
                    "薯蛋球(3件)",
                    "地瓜卷(3件)",
                    "炸薄脆(3件)",
                    "炸腐皮卷(2件)",
                    "椒鹽豆腐(4件)",
                    "白灼羽衣甘藍",
                    "紫菜湯",
                ],
            },
        },
        required: [
            "main",
            "noodle",
            "sub",
        ]
    };

    static public final MGYSub = {
        title: "小食",
        type: "string",
        "enum": [
            "湯餃子(8件) $28",
            "炸餃子(4件) $15",
            "薯蛋球(6件) $15",
            "地瓜卷(6件) $15",
            "炸薄脆(6件) $15",
            "炸腐皮卷(4件) $15",
            "椒鹽豆腐(8件) $15",
            "白灼羽衣甘藍 $15",
            "紫菜湯 $10",
        ],
    };
    
    static public function itemsSchema(order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: MGYItem.all.map(item -> {
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
                switch (cast item.type:MGYItem) {
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