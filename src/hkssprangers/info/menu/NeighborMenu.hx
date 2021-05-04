package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract NeighborItem(String) to String {
    final Set;
    final Single;
    final Salad;
    final Sub;

    static public final all:ReadOnlyArray<NeighborItem> = [
        Set,
        Single,
        Salad,
        Sub,
    ];

    public function getDefinition():Dynamic return switch (cast this:NeighborItem) {
        case Set: NeighborMenu.NeighborSet;
        case Single: NeighborMenu.NeighborSingle;
        case Salad: NeighborMenu.NeighborSalad;
        case Sub: NeighborMenu.NeighborSub;
    }
}

class NeighborMenu {
    static public final burgerOrHotdog = "漢堡／熱狗";
    static public final NeighborSetDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "可樂 +$22",
            "無糖可樂 +$22",
            "雪碧 +$22",
            "忌廉 +$22",
            "Lemon+C +$22",
            "Snapple 桃茶 +$33",
            "Snapple 檸檬茶 +$33",
            "棉花糖熱朱古力 +$40",
            "凍朱古力 +$40",
            "1664 Blanc +$40",
            "Apple Cider +$40",
        ],
    };
    static public final NeighborBurgers:ReadOnlyArray<String> = [
        "美式牛肉漢堡 $50",
        "Double Cheese雙重芝士牛肉漢堡 $62",
        "大烤菇牛肉漢堡 $73",
        "黑松露醬蘑菇牛肉漢堡 $71",
        "鄰居漢堡 $73",
        "Double Beef雙層牛肉芝士漢堡 $83",
        "(素)雙蘑菇黑松露醬芝士漢堡 $64",
        "特大香草雞扒菠蘿漢堡 $69",
        "意大利黑松露醬滑蛋熱狗 $52",
    ];
    static public final NeighborOpts:ReadOnlyArray<String> = [
        "煙肉 +$10",
        "芝士 +$10",
        "洋蔥蘑菇 +$10",
        "菠蘿 +$10",
        "牛肉扒 +$24",
        "雞扒 +$24",
        "portobello mushroom +$24",
    ];
    static public final NeighborSet = {
        title: burgerOrHotdog + "套餐",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": NeighborBurgers,
            },
            options: {
                type: "array",
                title: "配料",
                items: {
                    type: "string",
                    "enum": NeighborOpts,
                },
                uniqueItems: true,
            },
            sub: {
                type: "string",
                title: "跟餐",
                "enum": [
                    "雙色薯條",
                    "新鮮沙律菜",
                ]
            },
            drink: NeighborSetDrink,
        },
        required: [
            "main",
            "sub",
            "drink",
        ]
    }

    static public final NeighborSingle = {
        title: "單叫" + burgerOrHotdog,
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": NeighborBurgers,
            },
            options: {
                type: "array",
                title: "配料",
                items: {
                    type: "string",
                    "enum": NeighborOpts,
                },
                uniqueItems: true,
            },
        },
        required: [
            "main",
        ]
    };

    static public final NeighborSalad = {
        title: "沙律",
        properties: {
            salad: {
                type: "string",
                title: "沙律",
                "enum": [
                    "新鮮沙律菜 $31",
                    "大烤菇沙律 $52",
                ],
            },
            options: {
                type: "array",
                title: "配料",
                items: {
                    type: "string",
                    "enum": NeighborOpts,
                },
                uniqueItems: true,
            },
        },
        required: [
            "salad",
        ]
    };

    static public final NeighborSub = {
        title: "小食",
        type: "string",
        "enum": [
            "魚手指 $31",
            "鄰居雙色薯條 $33",
            "洋蔥圈 $31",
            "Mozzarella芝士脆條 $31",
            "椰漿脆雞翼 (4隻) $38",
            "椰漿脆雞翼 (6隻) $52",
            "水牛城雞翼 (4隻) $38",
            "水牛城雞翼 (6隻) $52",
            "薯絲蝦 $36",
            "黑松露醬芝士薯條 $45",
            "鄰居拼盤 $80",
        ],
    };
    
    static public function itemsSchema(order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: NeighborItem.all.map(item -> {
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
                switch (cast item.type:NeighborItem) {
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
        ?type:NeighborItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case Set:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "sub", "drink"]);
            case Single:
                summarizeOrderObject(orderItem.item, def, ["main", "options"]);
            case Salad:
                summarizeOrderObject(orderItem.item, def, ["salad", "options"]);
            case Sub:
                switch (orderItem.item:Null<String>) {
                    case v if (Std.isOfType(v, String)):
                        {
                            orderDetails: v,
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