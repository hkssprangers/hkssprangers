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
        "大薯條 +$5",
        "牛油粟米杯",
        "薯餅",
        "冰菠蘿",
        "可樂",
        "可樂Zero",
        "忌廉",
        "芬達",
        "雪碧",
        "C.C. Lemon",
    ];

    static public function ZeppelinHotDogSKMSingle(timeSlot:TimeSlot) {
        var sixYearItems = (timeSlot != null && timeSlot.start != null ? switch (timeSlot.start.getDatePart()) {
            case "2021-05-17":
                ["⭐六周年驚喜優惠: 十件雞塊 $10"];
            case "2021-05-18":
                ["⭐六周年驚喜優惠: 十件洋蔥圈 $10"];
            case "2021-05-19":
                ["⭐六周年驚喜優惠: 惹味香辣雞 $10"];
            case _:
                [];
        } : []);

        return {
            title: "小食",
            type: "string",
            "enum": sixYearItems.concat([
                "洋蔥圈(6件) $15",
                "洋蔥圈(9件) $20",
                "魚手指(4件) $20",
                "細薯格 $15",
                "大薯格 $22",
                "雞塊(6件) $15",
                "飛船小食杯(洋蔥圈, 雞塊, 薯格) $28",
                "炸魚薯條 $30",
                "細薯條 $10",
                "大薯條 $18",
                "芝士大薯條 $25",
                "芝士煙肉薯條 $28",
                "芝士辣肉醬薯條 $28",
                "惹味香辣雞 (1件) $15",
                "惹味香辣雞 (2件) $24",
                "薯餅 $8",
                "牛油粟米杯 $10",
                "冰菠蘿 $8",
            ]),
        };
    }

    static public final hotdogs:ReadOnlyArray<String> = [
        "LZ120 火灸芝士辣肉醬熱狗 $42",
        "LZ123 田園風味熱狗 $34",
        "LZ124 士林原味熱狗 $32",
        "LZ125 美國洋蔥圈熱狗 $36",
        "LZ127 芝味熱狗 $38",
        "LZ129 澳式風情熱狗 $38",
        "LZ131 紐約辣味熱狗 $38",
        "LZ133 德國酸菜熱狗 $40",
        "LZ135 墨西哥勁辣雞堡 $40",
        "LZ136 9件雞 (燒烤汁) $20",
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
                        "轉未來熱狗腸 +$15",
                        "轉豬肉香腸 +$0",
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
                        "轉未來熱狗腸 +$15",
                        "轉豬肉香腸 +$0",
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