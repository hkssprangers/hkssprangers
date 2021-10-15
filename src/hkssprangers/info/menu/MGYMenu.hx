package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract MGYItem(String) to String {
    final SideDish;
    final StirFriedNoodlesOrRice;
    final ColdNoodles;
    final Snack;
    final Delight;
    final Icecream;

    static public final all:ReadOnlyArray<MGYItem> = [
        SideDish,
        StirFriedNoodlesOrRice,
        ColdNoodles,
        Snack,
        Delight,
        Icecream,
    ];

    public function getDefinition():Dynamic return switch (cast this:MGYItem) {
        case SideDish: MGYMenu.MGYSideDish;
        case StirFriedNoodlesOrRice: MGYMenu.MGYStirFriedNoodlesOrRice;
        case ColdNoodles: MGYMenu.MGYColdNoodles;
        case Snack: MGYMenu.MGYSnack;
        case Delight: MGYMenu.MGYDelight;
        case Icecream: MGYMenu.MGYIcecream;
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
                    "欖菜菇絲芸豆 $" + markup(62),
                    "瓣醬豆腐 $" + markup(58),
                    "香草焗南瓜 $" + markup(58),
                    "香草焗薯角 $" + markup(58),
                    "香椿鮮菇燜淮山 $" + markup(62),
                    "咖喱薯仔 $" + markup(58),
                    "八珍豆腐扒時菜 $" + markup(58),
                    "豉汁尖椒 $" + markup(58),
                    "豉汁菇片炒涼瓜 $" + markup(58),
                    "香椿如腐雲耳炒勝瓜 $" + markup(58),
                    "黑椒菇角炒脆玉瓜 $" + markup(58),
                    "金菇絲燴娃娃菜 $" + markup(58),
                    "羅漢齋 $" + markup(58),

                    "XO醬炒菜心苗 $" + markup(38),
                    "高湯浸菠菜 $" + markup(38),
                    "咸酸菜炒芽葉 $" + markup(58),
                    "白灼羽衣甘藍 $" + markup(28),

                    "七彩孜然排骨 $" + markup(58),
                    "欖菜豆腐 $" + markup(58),
                    "蟠龍如 $" + markup(98),
                    "叉燒炒三絲 $" + markup(62),

                    "糖醋候頭菇 $" + markup(78),
                    "沙茶柚子皮 $" + markup(68),
                    "咖喱雜菜 $" + markup(78),
                    "韓式泡菜年糕 $" + markup(58),
                    "冰鎮秋葵 $" + markup(38),
                    "沙拉燒烤菇 $" + markup(38),
                    "香煎素玉餃 $" + markup(35),
                    "純菜沙拉 $" + markup(50),
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

    static public final MGYColdNoodles = {
        title: "日式冷麵",
        properties: {
            coldNoodles: {
                type: "string",
                title: "日式冷麵",
                "enum": [
                    "蕎麥麵 配羽衣甘藍 $" + markup(60),
                    "抹茶麵 配羽衣甘藍 $" + markup(60),
                ],
            },
        },
        required: [
            "coldNoodles",
        ]
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
            "白灼羽衣甘藍 $" + markup(23),
        ],
    };

    static public final MGYIcecream = {
        title: "Happy Cow Ice cream",
        type: "string",
        "enum": [
            "Chocolate 朱古力 125ml $" + markup(37),
            "Chocolate 朱古力 475ml $" + markup(85),
            "Pure coconut 純椰子 125ml $" + markup(37),
            "Pure coconut 純椰子 475ml $" + markup(85),
            "Vanilla bean 雲呢拿 125ml $" + markup(37),
            "Vanilla bean 雲呢拿 475ml $" + markup(85),
            "Mint chocolate chip 薄荷朱古力 125ml $" + markup(37),
            "Mint chocolate chip 薄荷朱古力 475ml $" + markup(85),
            "Salted caramel swirl 岩鹽焦糖旋風 125ml $" + markup(37),
            "Salted caramel swirl 岩鹽焦糖旋風 475ml $" + markup(85),
            "Mango 芒果 125ml $" + markup(37),
            "Mango 芒果 475ml $" + markup(85),
            "Strawberry 士多啤梨 125ml $" + markup(37),
            "Strawberry 士多啤梨 475ml $" + markup(85),
            "Dragon berry 火龍果雜莓 125ml $" + markup(37),
            "Dragon berry 火龍果雜莓 475ml $" + markup(85),
            "Green tea 綠茶 125ml $" + markup(37),
            "Green tea 綠茶 475ml $" + markup(85),
            "Ying yang seasame 陰陽芝麻 125ml $" + markup(37),
            "Ying yang seasame 陰陽芝麻 475ml $" + markup(85),
            "Ginger 薑 125ml $" + markup(37),
            "Ginger 薑 475ml $" + markup(85),
            "Banana caramel swirl 香蕉焦糖旋風 125ml $" + markup(37),
            "Banana caramel swirl 香蕉焦糖旋風 475ml $" + markup(85),
            "Choc choc Cookie 雙重朱古力曲奇 125ml $" + markup(37),
            "Choc choc Cookie 雙重朱古力曲奇 475ml $" + markup(85),
            "Pineapple coconut 菠蘿椰子 125ml $" + markup(37),
            "Pineapple coconut 菠蘿椰子 475ml $" + markup(85),
        ],
    };

    static public final MGYDelight = {
        title: "滋味輕食",
        properties: {
            delight: {
                type: "string",
                title: "滋味輕食",
                "enum": [
                    "漢堡包 $" + markup(40),
                    "蓮蓉小籠包 $" + markup(20),
                    "叉燒包 $" + markup(30),
                    "豆沙窩餅 $" + markup(30),
                    "地瓜拉餅 $" + markup(32),
                    "香椿抓餅 $" + markup(30),
                    "玉排沙拉 $" + markup(40),
                    "珠排沙拉 $" + markup(40),
                    "純菜沙拉 $" + markup(40),
                    "熱九培根沙拉 $" + markup(40),
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
            case ColdNoodles:
                summarizeOrderObject(orderItem.item, def, ["coldNoodles"], []);
            case Delight:
                summarizeOrderObject(orderItem.item, def, ["delight"], []);
            case Snack:
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
            case Icecream:
                switch (orderItem.item:Null<String>) {
                    case v if (Std.isOfType(v, String)):
                        {
                            orderDetails: fullWidthDot + MGYIcecream.title + fullWidthColon + "\n" + fullWidthSpace + v,
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