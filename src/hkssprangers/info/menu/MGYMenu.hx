package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract MGYItem(String) to String {
    final SingleDish;
    final SetMeal;
    final FriedFood;
    final ColdNoodle;
    final Sub;

    static public final all:ReadOnlyArray<MGYItem> = [
        SingleDish,
        SetMeal,
        FriedFood,
        ColdNoodle,
        Sub,
    ];

    public function getDefinition():Dynamic return switch (cast this:MGYItem) {
        case SingleDish: MGYMenu.MGYSingleDish;
        case SetMeal: MGYMenu.MGYSetMeal;
        case FriedFood: MGYMenu.MGYFriedFood;
        case ColdNoodle: MGYMenu.MGYColdNoodle;
        case Sub: MGYMenu.MGYSub;
    }
}

class MGYMenu {
    static public final MGYSingleDish = {
        title: "小菜",
        properties: {
            dish: {
                title: "小菜",
                type: "string",
                "enum": [
                    "豉汁素楊玉 $62",
                    "咕嚕素芝球 $62",
                    "泰式西芹花枝片 $62",
                    "鮮茄燜枝竹 $62",
                    "白汁粟米蓉金磚豆卜 $62",
                    "如香茄子 $62",
                    "欖菜菇絲芸豆 $62",
                    "瓣醬豆腐 $62",
                    "香草焗薯角 $62",
                    "香椿鮮菇燜淮山 $62",
                    "咖哩薯仔 $62",
                    "八珍豆腐時蔬 $62",
                    "豉汁尖椒 $62",
                    "豉汁菇片炒涼瓜 $62",
                    "香椿如腐雲耳炒勝瓜 $62",
                    "黑椒菇角炒脆玉瓜 $62",
                    "金菇絲燴娃娃菜 $62",
                    "羅漢齋 $62",
                ]
            },
        },
        required: [
            "dish",
        ]
    }

    static public final MGYSetMeal = {
        title: "客飯",
        description: "客飯配白飯及例湯",
        properties: {
            setMeal: {
                type: "string",
                title: "客飯",
                "enum": [
                    "豉汁素楊玉(客飯) $72",
                    "咕嚕素芝球(客飯) $72",
                    "泰式西芹花枝片(客飯) $72",
                    "鮮茄燜枝竹(客飯) $72",
                    "白汁粟米蓉金磚豆卜(客飯) $72",
                    "如香茄子(客飯) $72",
                    "欖菜菇絲芸豆(客飯) $72",
                    "瓣醬豆腐(客飯) $72",
                    "香草焗薯角(客飯) $72",
                    "香椿鮮菇燜淮山(客飯) $72",
                    "咖哩薯仔(客飯) $72",
                    "八珍豆腐時蔬(客飯) $72",
                    "豉汁尖椒(客飯) $72",
                    "豉汁菇片炒涼瓜(客飯) $72",
                    "香椿如腐雲耳炒勝瓜(客飯) $72",
                    "黑椒菇角炒脆玉瓜(客飯) $72",
                    "金菇絲燴娃娃菜(客飯) $72",
                    "羅漢齋(客飯) $72",
                ],
            },
        },
        required: [
            "setMeal",
        ]
    }

    static public final MGYFriedFood = {
        title: "炒粉飯",
        properties: {
            fried: {
                type: "string",
                title: "炒粉飯",
                "enum": [
                    "香椿松子炒飯 $53",
                    "黃薑瓜粒炒飯 $53",
                    "黑椒蘑菇意粉 $53",
                    "羅漢齋烏冬 $53",
                ],
            },
        },
        required: [
            "fried",
        ]
    };

    static public final MGYColdNoodle = {
        title: "日式冷麵",
        properties: {
            coldNoodle: {
                type: "string",
                title: "日式冷麵",
                "enum": [
                    "蕎麥麵配羽衣甘藍 $70",
                    "抹茶麵配羽衣甘藍 $70",
                ],
            },
        },
        required: [
            "coldNoodle",
        ]
    };

    static public final MGYSub = {
        title: "小食",
        type: "string",
        "enum": [
            "湯餃子(8件) $36",
            "炸餃子(4件) $24",
            "薯蛋球(6件) $24",
            "地瓜卷(6件) $24",
            "炸薄脆(6件) $24",
            "炸腐皮卷(4件) $24",
            "椒鹽豆腐(8件) $24",
            "白灼羽衣甘藍 $24",
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

    static function summarizeItem(orderItem:{
        ?type:MGYItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case SingleDish:
                summarizeOrderObject(orderItem.item, def, ["dish"], []);
            case SetMeal:
                summarizeOrderObject(orderItem.item, def, ["setMeal"], []);
            case FriedFood:
                summarizeOrderObject(orderItem.item, def, ["fried"], []);
            case ColdNoodle:
                summarizeOrderObject(orderItem.item, def, ["coldNoodle"], []);
            case Sub:
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
        var s = concatSummaries(formData.items.map(item -> summarizeItem(cast item)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}