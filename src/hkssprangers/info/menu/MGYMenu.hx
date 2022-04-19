package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract MGYItem(String) to String {
    final SideDish;
    final StirFriedNoodlesOrRice;
    final Rice;
    final Snack;
    final Delight;

    static public final all:ReadOnlyArray<MGYItem> = [
        SideDish,
        StirFriedNoodlesOrRice,
        Rice,
        Snack,
        Delight,
    ];

    public function getDefinition():Dynamic return switch (cast this:MGYItem) {
        case SideDish: MGYMenu.MGYSideDish;
        case StirFriedNoodlesOrRice: MGYMenu.MGYStirFriedNoodlesOrRice;
        case Rice: MGYMenu.MGYRice;
        case Snack: MGYMenu.MGYSnack;
        case Delight: MGYMenu.MGYDelight;
    }
}

class MGYMenu {
    static function markup(price:Float):Float {
        return Math.round(price / 0.85);
    }

    static public final MGYSideDish = {
        title: "小菜",
        properties: {
            dish: {
                title: "小菜",
                type: "string",
                "enum": [
                    "豉汁素楊玉 $" + markup(58),
                    "咕嚕素芝球 $" + markup(58),
                    "泰式西芹花枝丸 $" + markup(58),
                    "鮮茄燜枝竹 $" + markup(58),
                    "白汁粟米蓉金磚豆卜 $" + markup(58),
                    "豪油焗素芝片 $" + markup(58),
                    "如香茄子 $" + markup(58),
                    "瓣醬豆腐 $" + markup(58),
                    "香草焗南瓜 $" + markup(58),
                    "香草焗薯角 $" + markup(58),
                    "香椿鮮菇燜淮山 $" + markup(62),
                    "咖喱薯仔 $" + markup(58),
                    "八珍豆腐扒時菜 $" + markup(58),
                    "豉汁菇片炒涼瓜 $" + markup(58),
                    "香椿如腐雲耳炒勝瓜 $" + markup(58),
                    "黑椒菇角炒脆玉瓜 $" + markup(58),
                    "金菇絲燴娃娃菜 $" + markup(58),
                    "羅漢齋 $" + markup(58),

                    "XO醬炒菜心苗 $" + markup(38),
                    "高湯浸菠菜 $" + markup(38),
                    "咸酸菜炒芽葉 $" + markup(58),

                    // "七彩孜然排骨 $" + markup(58),
                    "欖菜豆腐 $" + markup(58),
                    "蟠龍如 $" + markup(98),

                    "糖醋候頭菇 $" + markup(78),
                    "咖喱雜菜 $" + markup(78),
                    "韓式泡菜年糕 $" + markup(58),
                    "冰鎮秋葵 $" + markup(38),
                    "素大碗 $" + markup(108),
                    "山珍池蓮會 $" + markup(88),
                    "日式雪裏紅 $" + markup(58)

                ]
            },
        },
        required: [
            "dish",
        ]
    }

    static public final MGYStirFriedNoodlesOrRice = {
        title: "炒粉飯",
        properties: {
            fried: {
                type: "string",
                title: "炒粉飯",
                "enum": [
                    "香椿松子炒飯 $" + markup(48),
                    "黃薑瓜粒炒飯 $" + markup(48),
                    "黑椒蘑菇意粉 $" + markup(48),
                    "羅漢齋烏冬 $" + markup(48),
                ],
            },
        },
        required: [
            "fried",
        ]
    };

    static final rice = "白飯 $7";
    static public final MGYRice = {
        title: "白飯",
        type: "string",
        "enum": [
            rice,
        ],
        "default": rice,
    };

    static public final MGYSnack = {
        title: "小食",
        type: "string",
        "enum": [
            "湯餃子(8件) $" + markup(35),
            "炸餃子(4件) $" + markup(23),
            "薯蛋球(6件) $" + markup(23),
            "地瓜卷(6件) $" + markup(23),
            "炸薄脆(6件) $" + markup(23),
            "炸饅頭(4件) $" + markup(23),
            "炸腐皮卷(4件) $" + markup(23),
            "椒鹽豆腐(8件) $" + markup(23),
        ],
    };

    static public final MGYDelight = {
        title: "滋味輕食",
        properties: {
            delight: {
                type: "string",
                title: "滋味輕食",
                "enum": [
                    "蓮蓉小籠包 $" + markup(20),
                    "叉燒包 $" + markup(30),
                    "豆沙窩餅 $" + markup(30),
                    "地瓜拉餅 $" + markup(32),
                    "香椿抓餅 $" + markup(30),
                    "咖喱雜丸 $" + markup(40),
                    "黑椒排荷葉包 $" + markup(50),                    
                ],
            },
        },
        required: [
            "delight",
        ]
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
            case SideDish:
                summarizeOrderObject(orderItem.item, def, ["dish"], []);
            case StirFriedNoodlesOrRice:
                summarizeOrderObject(orderItem.item, def, ["fried"], []);
            case Delight:
                summarizeOrderObject(orderItem.item, def, ["delight"], []);
            case Snack | Rice:
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