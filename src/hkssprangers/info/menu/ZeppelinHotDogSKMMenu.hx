package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract ZeppelinHotDogSKMItem(String) to String {
    final HotdogSet;
    final Hotdog;
    final Single;

    static public final all:ReadOnlyArray<ZeppelinHotDogSKMItem> = [
        HotdogSet,
        Hotdog,
        Single,
    ];

    public function getDefinition():Dynamic return switch (cast this:ZeppelinHotDogSKMItem) {
        case HotdogSet: ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMHotdogSet;
        case Hotdog: ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMHotdog;
        case Single: ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMSingle;
    }
}

class ZeppelinHotDogSKMMenu {
    static public final ZeppelinHotDogSKMSetOptions = {
        title: "跟餐",
        description: "任選2樣 $12",
        type: "array",
        items: {
            type: "string",
            "enum": [
                "細薯條",
                "大薯條 (+$5)",
                "牛油粟米杯",
                "冰菠蘿",
                "可樂",
                "忌廉",
                "芬達",
                "雪碧",
                "C.C. Lemon",
                "Coke Zero",
            ],
        },
        uniqueItems: true,
        minItems: 2,
        maxItems: 2,
    };

    static public final ZeppelinHotDogSKMSingle = {
        title: "小食",
        type: "string",
        "enum": [
            "洋蔥圈(6件) $15",
            "洋蔥圈(9件) $20",
            "雞塊(6件) $15",
            "雞塊(9件) $20",
            "植系炸雞塊(4塊) $18",
            "細薯格 $15",
            "大薯格 $22",
            "魚手指(4件) $18",
            "飛船小食杯(洋蔥圈, 雞塊, 薯格) $26",
            "粒粒香腸杯 $28",
            "細薯條 $10",
            "大薯條 $15",
            "芝士大薯條 $22",
            "芝士煙肉薯條 $26",
            "芝士辣肉醬薯條 $26",
            "炸魚薯條 $28",
            "牛油粟米杯 $10",
            "冰菠蘿 $8",
        ],
    };

    static public final hotdogs:ReadOnlyArray<String> = [
        "火灸芝士辣肉醬熱狗 $42",
        "田園風味熱狗 $30",
        "士林原味熱狗 $32",
        "美國洋蔥圈熱狗 $36",
        "芝味熱狗 $38",
        "澳式風情熱狗 $38",
        "德國酸菜熱狗 $38",
    ];

    static public final ZeppelinHotDogSKMHotdogSet = {
        title: "套餐",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": hotdogs,
            },
            extraOptions: {
                title: "升級",
                type: "array",
                items: {
                    type: "string",
                    "enum": [
                        "加熱溶芝士 +$10",
                        "轉素腸 +$15",
                    ],
                },
                uniqueItems: true,
            },
            options: ZeppelinHotDogSKMSetOptions,
        },
        required: [
            "main",
            "options",
        ]
    }

    static public final ZeppelinHotDogSKMHotdog = {
        title: "單叫",
        properties: {
            main: {
                title: "單叫",
                type: "string",
                "enum": hotdogs,
            },
            extraOptions: {
                title: "升級",
                type: "array",
                items: {
                    type: "string",
                    "enum": [
                        "加熱溶芝士 +$10",
                        "轉素腸 +$15",
                    ],
                },
                uniqueItems: true,
            },
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
                    oneOf: ZeppelinHotDogSKMItem.all.map(item -> {
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
                switch (cast item.type:ZeppelinHotDogSKMItem) {
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
        ?type:ZeppelinHotDogSKMItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case HotdogSet:
                summarizeOrderObject(orderItem.item, def, ["main", "extraOptions", "options"], null, (fieldName, value) -> switch fieldName {
                    case "options":
                        var sum = 0.0;
                        for (opt in (value:Array<String>)) {
                            sum += opt.parsePrice();
                        }
                        sum += (def.properties.options.description:String).parsePrice();
                        sum;
                    case _:
                        0;
                });
            case Hotdog:
                summarizeOrderObject(orderItem.item, def, ["main", "extraOptions"]);
            case Single:
                switch (orderItem.item:Null<String>) {
                    case v if (Std.isOfType(v, String)):
                        {
                            orderDetails: v,
                            orderPrice: v.parsePrice(),
                        }
                    case _:
                        {
                            orderDetails: "",
                            orderPrice: 0,
                        }
                }
            case _:
                {
                    orderDetails: "",
                    orderPrice: 0,
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