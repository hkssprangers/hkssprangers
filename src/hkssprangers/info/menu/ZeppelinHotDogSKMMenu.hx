package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract ZeppelinHotDogSKMItem(String) to String {
    final HotdogSet;
    final Hotdog;
    final Single;
    final Drink;
    final Special;

    static public function all(pickupTimeSlot:Null<TimeSlot>):ReadOnlyArray<ZeppelinHotDogSKMItem> {
        final items = [
            HotdogSet,
            Hotdog,
            Single,
            Drink,
        ];

        // https://www.facebook.com/zeppelinhotdog/posts/2143580862472113
        if (pickupTimeSlot != null && pickupTimeSlot.start != null) switch (pickupTimeSlot.start.getDatePart()) {
            case "2022-05-23" | "2022-05-24" | "2022-05-25" | "2022-05-26" | "2022-05-27":
                items.unshift(Special);
            case _:
                // pass
        }

        return items;
    }

    public function getDefinition(pickupTimeSlot:Null<TimeSlot>, ?item:Dynamic):Dynamic return switch (cast this:ZeppelinHotDogSKMItem) {
        case HotdogSet:
            final freeChok = ZeppelinHotDogSKMMenu.hasFreeChok(item);
            if (freeChok)
                ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMHotdogSetChok;
            else
                ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMHotdogSet;
        case Hotdog: ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMHotdog;
        case Single: ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMSingle;
        case Drink: ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMDrink;
        case Special: ZeppelinHotDogSKMMenu.ZeppelinHotDogSKMSpecial(pickupTimeSlot);
    }
}

class ZeppelinHotDogSKMMenu {
    static final SmallFF = "細薯條";
    static final BigFF = "大薯條 +$5";
    static public final setSnacks = [
        SmallFF,
        BigFF,
        "薯蓉波波",
        "薯仔寶寶",
        "牛油粟米杯",
        "薯餅",
        "冰菠蘿",
    ];
    static public final setDrinks = [
        "可樂",
        "可樂Zero",
        "雪碧",
        "忌廉",
        "有汽檸檬茶",
        "無糖冷泡茶 +$2",
        "OOHA 荔枝乳酸味汽水 +$2",
        "OOHA 柚子海鹽味汽水 +$2",
        "OOHA 白桃烏龍茶味汽水 +$2",
        "菊9汽 銀菊露味汽水 +$8",
        "奶茶 (回憶) +$10",
        "奶茶 (英女王) +$12",
    ];
    static public final chokOptions = [
        "CHOK CHOK粉 紫菜風味",
        "CHOK CHOK粉 惹味麻辣",
    ];

    static public final ZeppelinHotDogSKMDrink = {
        title: "飲品",
        type: "string",
        "enum": [
            "可樂 $8",
            "可樂Zero $8",
            "雪碧 $8",
            "忌廉 $8",
            "有汽檸檬茶 $8",
            "無糖冷泡茶 $10",
            "OOHA 荔枝乳酸味汽水 $10",
            "OOHA 柚子海鹽味汽水 $10",
            "OOHA 白桃烏龍茶味汽水 $10",
            "菊9汽 銀菊露味汽水 $18",
            "奶茶 (回憶) $20",
            "奶茶 (英女王) $25",
        ],
    };

    static public final ZeppelinHotDogSKMSingle = {
        title: "小食",
        type: "string",
        "enum": [
            "洋蔥圈(6件) $18",
            "洋蔥圈(9件) $22",
            "魚手指(4件) $20",
            "魚手指(6件) $27",
            // "細薯格 $18",
            // "大薯格 $24",
            "香脆雞塊(6件) $15",
            "香脆雞塊(9件) $20",
            // "飛船小食杯(洋蔥圈,雞塊,薯格) $30",
            "炸魚薯條 $30",
            "細薯條 $12",
            "大薯條 $20",
            "芝士大薯條 $27",
            "芝士煙肉薯條 $30",
            "芝士辣肉醬薯條 $30",
            "薯蓉波波 $12",
            "薯仔寶寶 $12",
            "辣雞扒 (1件) $15",
            "辣雞扒 (2件) $24",
            "薯餅 $8",
            "牛油粟米杯 $10",
            "冰菠蘿 $8",
            // "燒賣杯 (6件) $18",
            "額外醬汁-茄汁 $3",
            "額外醬汁-千島醬 $3",
            "額外醬汁-蛋黃醬 $3",
            "額外醬汁-bbq醬 $3",
            "額外醬汁-黃芥末 $3",
            "額外醬汁-mix醬 (茄汁加千島) $3",
        ].concat(chokOptions.map(item -> item + " $3")),
    };
    
    static public function ZeppelinHotDogSKMSpecial(pickupTimeSlot:TimeSlot) {
        final item = (pickupTimeSlot != null && pickupTimeSlot.start != null) ? switch (pickupTimeSlot.start.getDatePart()) {
            case "2022-05-23":
                "香脆雞塊10件 $10";
            case "2022-05-24":
                "洋蔥圈8件 $10";
            case "2022-05-25":
                "辣雞扒 (1件) $10";
            case "2022-05-26":
                "LZ124士林原味熱狗🌶️+菊9汽 $40";
            case "2022-05-27":
                "脆香單骨雞翼4隻 $15";
            case _:
                null;
        } : null;
        return {
            title: "七周年優惠: " + item,
            type: "string",
            "enum": item == null ? [] : [item],
            "default": item,
        };
    }

    static public final hotdogs:ReadOnlyArray<String> = [
        "LZ120 火灸芝士辣肉醬熱狗🌶️🌶️ $42",
        "LZ123 田園風味熱狗 $38",
        "LZ124 士林原味熱狗🌶️ $32",
        "LZ125 美國洋蔥圈熱狗 $36",
        "LZ127 芝味熱狗 $38",
        "LZ129 澳式風情熱狗 $38",
        "LZ131 紐約辣味熱狗🌶️🌶️ $38",
        "LZ133 德國酸菜熱狗 $40",
        "LZ135 墨西哥勁辣雞堡🌶️🌶️🌶️ $40",
        "LZ136 香脆雞塊 (9件, 燒烤汁) $20",
        // "LZ137 燒賣熱狗🌶️ $36",
        "LZ138V 新炸魚堡 $42",
    ];

    static final setDescription = "套餐 +$15";

    static function createSet(withFreeChok:Bool) {
        final def =  {
            title: "套餐",
            description: setDescription + "。要大薯條 送 CHOK CHOK 粉。",
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
                            "加辣肉醬 +$10",
                            // "轉未來素腸 +$15",
                            "轉豬肉紐堡腸 +$0",
                        ],
                    },
                    uniqueItems: true,
                },
                setOption1: {
                    title: "跟餐小食",
                    type: "string",
                    "enum": setSnacks,
                },
                setOption2: {
                    title: "跟餐飲品",
                    type: "string",
                    "enum": setDrinks,
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
            case {setOption1: BigFF, setOption2: _} | {setOption1: _, setOption2: BigFF}:
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
                    oneOf: ZeppelinHotDogSKMItem.all(pickupTimeSlot).map(item -> {
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
                            item: itemType.getDefinition(pickupTimeSlot, item.item),
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
        final def = orderItem.type.getDefinition(pickupTimeSlot, orderItem.item);
        return switch (orderItem.type) {
            case HotdogSet:
                final freeChok = hasFreeChok(orderItem.item);
                summarizeOrderObject(
                    orderItem.item,
                    def,
                    freeChok ?
                        ["main", "extraOptions", "setOption1", "setOption2", "chok", "seasoningOptions"] :
                        ["main", "extraOptions", "setOption1", "setOption2", "seasoningOptions"]
                    ,
                    [setDescription]
                );
            case Hotdog:
                summarizeOrderObject(orderItem.item, def, ["main", "extraOptions"]);
            case Single | Drink | Special:
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