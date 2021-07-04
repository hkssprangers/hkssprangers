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

    public function getDefinition(timeSlot:TimeSlot):Dynamic return switch (cast this:ZeppelinHotDogSKMItem) {
        case HotdogSet: ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMHotdogSet;
        case Hotdog: ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMHotdog;
        case Single: ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMSingle(timeSlot);
    }
}

class ZeppelinHotDogSKMMenu {
    static public final setOptions = [
        "細薯條",
        "大薯條 (+$5)",
        "薯餅",
        "牛油粟米杯",
        "冰菠蘿",
        "可樂",
        "忌廉",
        "芬達",
        "雪碧",
        "C.C. Lemon",
        "Coke Zero",
    ];

    static public function ZeppelinHotDogSKMSingle(timeSlot:TimeSlot) {
        var sixYearItems = (timeSlot != null && timeSlot.start != null ? switch (timeSlot.start.getDatePart()) {
            case "2021-05-17":
                ["⭐六周年驚喜優惠: 十件雞塊 $10"];
            case "2021-05-18":
                ["⭐六周年驚喜優惠: 十件洋蔥圈 $10"];
            case "2021-05-19":
                ["⭐六周年驚喜優惠: 惹味香辣難 $10"];
            case _:
                [];
        } : []);

        return {
            title: "小食",
            type: "string",
            "enum": sixYearItems.concat([
                "洋蔥圈(6件) $15",
                "洋蔥圈(9件) $20",
                "雞塊(6件) $15",
                "雞塊(9件) $20",
                // "植系炸雞塊(4塊) $18",
                "細薯格 $15",
                "大薯格 $22",
                "薯餅 $8",
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
                "惹味香辣難 $18",
            ]),
        };
    }

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
        description: "套餐 +$12",
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
            setOption1: {
                title: "跟餐 1",
                type: "string",
                "enum": setOptions,
            },
            setOption2: {
                title: "跟餐 2",
                type: "string",
                "enum": setOptions,
            },
        },
        required: [
            "main",
            "setOption1",
            "setOption2",
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

    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: ZeppelinHotDogSKMItem.all.map(item -> {
                        title: item.getDefinition(pickupTimeSlot).title,
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
                            item: itemType.getDefinition(pickupTimeSlot),
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
    }, pickupTimeSlot:Null<TimeSlot>):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition(pickupTimeSlot);
        return switch (orderItem.type) {
            case HotdogSet:
                summarizeOrderObject(orderItem.item, def, ["main", "extraOptions", "setOption1", "setOption2"], [ZeppelinHotDogSKMHotdogSet.description]);
            case Hotdog:
                summarizeOrderObject(orderItem.item, def, ["main", "extraOptions"]);
            case Single:
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

    static public function summarize(formData:FormOrderData, timeSlot:TimeSlot):OrderSummary {
        var s = concatSummaries(formData.items.map(item -> summarizeItem(cast item, timeSlot)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}