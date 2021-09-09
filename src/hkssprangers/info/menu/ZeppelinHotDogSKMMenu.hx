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

    public function getDefinition(?item:Dynamic):Dynamic return switch (cast this:ZeppelinHotDogSKMItem) {
        case HotdogSet:
            if (ZeppelinHotDogSKMMenu.hasFreeChok(item))
                ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMHotdogSetChok;
            else
                ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMHotdogSet;
        case Hotdog: ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMHotdog;
        case Single: ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMSingle;
    }
}

class ZeppelinHotDogSKMMenu {
    static final SmallFF = "細薯條";
    static final BigFF = "大薯條 +$5";
    static public final setOptions = [
        SmallFF,
        BigFF,
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

    static public final chokOptions = [
        "CHOK CHOK粉 芥末紫菜",
        "CHOK CHOK粉 地道椒鹽",
        // "CHOK CHOK粉 惹味麻辣",
        // "CHOK CHOK粉 香甜蕃茄",
    ];

    static public final ZeppelinHotDogSKMSingle = {
        title: "小食",
        type: "string",
        "enum": chokOptions.map(item -> item + " +$3").concat([
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

    static final setDescription = "套餐 +$12";

    static function createSet(withFreeChok:Bool) {
        var def =  {
            title: "套餐",
            description: setDescription + "。要大薯條 (或者兩個細薯條) 送 CHOK CHOK 粉。",
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
        };

        if (withFreeChok) {
            def.properties.setField("chok", {
                title: "送",
                type: "string",
                "enum": chokOptions,
            });
            def.required.push("chok");
        }

        def.properties.setField("seasoningOptions", {
            title: "加配",
            type: "array",
            items: {
                type: "string",
                "enum": chokOptions.map(item -> item + " +$3"),
            },
            uniqueItems: true,
        });

        return def;
    }

    static public function hasFreeChok(
        ?item:{
            setOption1:Null<String>,
            setOption2:Null<String>,
        }
    ):Bool {
        return switch (item) {
            case null:
                false;
            case {setOption1: BigFF, setOption2: _} | {setOption1: _, setOption2: BigFF} | {setOption1: SmallFF, setOption2: SmallFF}:
                true;
            case _:
                false;
        }
    }

    static public final ZeppelinHotDogSKMHotdogSet = createSet(false);
    static public final ZeppelinHotDogSKMHotdogSetChok = createSet(true);

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
                            item: itemType.getDefinition(item.item),
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
        var def = orderItem.type.getDefinition(orderItem.item);
        return switch (orderItem.type) {
            case HotdogSet:
                summarizeOrderObject(
                    orderItem.item,
                    def,
                    hasFreeChok(orderItem.item) ?
                        ["main", "extraOptions", "setOption1", "setOption2", "chok", "seasoningOptions"] :
                        ["main", "extraOptions", "setOption1", "setOption2", "seasoningOptions"]
                    ,
                    [setDescription]
                );
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