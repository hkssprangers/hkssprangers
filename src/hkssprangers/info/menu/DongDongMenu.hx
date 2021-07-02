package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;
using Lambda;

enum abstract DongDongItem(String) to String {
    final LunchSet;
    final UsualSet;
    final DinnerDish;
    final DinnerSet;

    static public function all(timeSlotType:TimeSlotType):ReadOnlyArray<DongDongItem> return switch timeSlotType {
        case Lunch:
            [
                LunchSet,
                UsualSet,
            ];
        case Dinner:
            [
                DinnerDish,
                DinnerSet,
            ];
    };

    public function getDefinition():Dynamic return switch (cast this:DongDongItem) {
        case LunchSet: DongDongMenu.DongDongLunchSet;
        case UsualSet: DongDongMenu.DongDongUsualSet;
        case DinnerDish: DongDongMenu.DongDongDinnerDish;
        case DinnerSet: DongDongMenu.DongDongDinnerSet;
    }
}

class DongDongMenu {
    static public final box = "外賣盒 $1";

    static public final DongDongLunchDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "熱奶茶",
            "熱咖啡",
            "熱檸茶",
            "熱檸水",
            "熱好立克",
            "熱阿華田",
            "熱檸蜜 +$4",
            "凍奶茶 +$2",
            "凍咖啡 +$2",
            "凍檸茶 +$2",
            "凍檸水 +$2",
            "凍好立克 +$2",
            "凍阿華田 +$2",
            "罐裝可樂 +$3",
            "凍檸蜜 +$4",
            "檸檬可樂 +$10",
        ],
    };

    static public final DongDongLunchSet = {
        title: "午餐",
        description: "注意每份會另加" + box,
        properties: {
            main: {
                title: "午餐",
                type: "string",
                "enum": [
                    "葱油豬扒飯 $50",
                    "福建炒飯 $50",
                    "廈門炒米 $50",
                    "叉燒炒烏冬 $50",
                    "紅燒豬軟骨飯 $54",
                    "紅酒燴牛肋飯 $54",
                    "黑椒牛仔粒飯 $50",
                    "薑蔥爆雞飯 $52",
                    "凉瓜排骨飯 $50",
                    "鮮茄牛脷飯 $54",
                    "司華力腸配牛扒飯 $55",
                    "司華力腸配吉豬飯 $55",
                    "司華力腸配吉魚飯 $55",
                    "焗鮮茄芝士豬扒飯 $55",
                    "焗白汁芝士海鮮飯 $55",
                ]
            },
            drink: DongDongLunchDrink,
        },
        required: [
            "main",
            "drink",
        ]
    };
    static public final DongDongUsualSet = {
        title: "常餐",
        description: "配炒滑蛋及牛油多士。注意每份會另加" + box,
        properties: {
            main: {
                title: "款式",
                type: "string",
                "enum": [
                    "沙嗲牛肉 $45",
                    "雪菜肉絲 $45",
                    "榨菜肉絲 $45",
                    "火腿 $45",
                    "餐肉 $45",
                    "肉丁 $45",
                    "腸仔 $45",
                    "漢堡扒 $45",
                ]
            },
            noodle: {
                title: "麵類",
                type: "string",
                "enum": [
                    "米粉",
                    "通粉",
                    "公仔麵",
                ]
            },
            options: {
                type: "array",
                title: "其他",
                items: {
                    type: "string",
                    "enum": [
                        "轉茄湯 +$5",
                    ],
                },
                uniqueItems: true,
            },
            drink: DongDongLunchDrink,
        },
        required: [
            "main",
            "noodle",
            "drink",
        ]
    };

    static public final DongDongDinnerDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "熱奶茶 +$4",
            "熱咖啡 +$4",
            "熱檸茶 +$4",
            "熱檸水 +$4",
            "熱好立克 +$4",
            "熱阿華田 +$4",
            "熱檸蜜 +$6",
            "凍奶茶 +$6",
            "凍咖啡 +$6",
            "凍檸茶 +$6",
            "凍檸水 +$6",
            "凍好立克 +$6",
            "凍阿華田 +$6",
            "罐裝可樂 +$6",
            "凍檸蜜 +$8",
            "檸檬可樂 +$10",
        ],
    };

    static public final DongDongDinnerDish = {
        title: "單叫小菜",
        description: "注意每份會另加外賣盒" + box,
        properties: {
            main: {
                title: "單叫小菜",
                type: "string",
                "enum": [
                    "咖哩燴牛脷 $88",
                    "什菜鍋 $78",
                    "蓮藕炆腩仔 $88",
                    "椒鹽豬扒 $88",
                    "黑椒牛仔骨 $88",
                    "中式牛柳 $88",
                    "粟米班塊 $88",
                    "茄子班腩 $88",
                    "西蘭花班片 $88",
                    "紅酒燴牛肋 $88",
                    "馬拉盞牛肉通菜 $88",
                    "西檸雞 $88",
                    "蝦仁炒蛋 $78",
                    "涼瓜菜脯煎蛋 $78",
                    "豆豉鯪魚油麥菜 $78",
                ],
            },
            drink: DongDongDinnerDrink,
        },
        required: [
            "main",
        ]
    };

    static public final DongDongDinnerSet = {
        title: "晚飯套餐",
        description: "附送例湯。注意每份會另加" + box,
        properties: {
            main: {
                title: "晚飯套餐",
                type: "string",
                "enum": [
                    "椒鹽豬扒飯 $52",
                    "蓮藕炆腩仔飯 $52",
                    "乾炒牛河 $56",
                    "星洲炒米 $52",
                    "肉絲炒麵 $52",
                    "楊州炒飯 $52",
                    "豉椒牛仔粒飯 $54",
                    "茄子班腩飯 $52",
                    "芙蓉蛋飯 $52",

                    "馬蹄土魷蒸肉餅送油菜白飯 $64",
                    "梅菜蒸肉餅送油菜白飯 $64",
                    "咸魚蓉蒸肉餅送油菜白飯 $64",
                    "豉汁蒸排骨送油菜白飯 $64",
                    "三色肉鬆蒸水蛋送油菜白飯 $64",
                    "粉絲蝦米蒸水蛋送油菜白飯 $64",
                    "涼瓜炆䱽魚送油菜白飯 $88",
                    "茄子炆䱽魚送油菜白飯 $88",
                    "豉汁蒸䱽魚送油菜白飯 $78",
                    "煎封䱽魚送油菜白飯 $78",
                    "豉油雞脾送油菜白飯 $58",
                    "咖哩燴牛脷配白飯 $68",
                    "什菜鍋配白飯 $68",
                    "蓮藕炆腩仔配白飯 $68",
                    "椒鹽豬扒配白飯 $68",
                    "黑椒牛仔骨配白飯 $78",
                    "中式牛柳配白飯 $78",
                    "粟米班塊配白飯 $68",
                    "茄子班腩配白飯 $68",
                    "西蘭花班片配白飯 $68",
                    "紅酒燴牛肋配白飯 $78",
                    "馬拉盞牛肉通菜配白飯 $78",
                    "西檸雞配白飯 $68",
                    "蝦仁炒蛋配白飯 $68",
                    "涼瓜菜脯煎蛋配白飯 $68",
                    "豆豉鯪魚油麥菜配白飯 $68",
                ]
            },
            drink: DongDongDinnerDrink,
        },
        required: [
            "main",
        ]
    }

    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        return if (pickupTimeSlot == null) {
            type: "array",
            items: {
                type: "object",
            }
        } else {
            var timeSlotType = TimeSlotType.classify(pickupTimeSlot.start);
            var itemDefs = [
                for (item in DongDongItem.all(timeSlotType))
                item => item.getDefinition()
            ];
            function itemSchema():Dynamic return {
                type: "object",
                properties: {
                    type: {
                        title: "食物種類",
                        type: "string",
                        oneOf: [
                            for (item => def in itemDefs)
                            {
                                title: def.title,
                                const: item,
                            }
                        ],
                    },
                },
                required: [
                    "type",
                ],
            }
            {
                type: "array",
                items: order.items == null || order.items.length == 0 ? itemSchema() : order.items.map(item -> {
                    var itemSchema:Dynamic = itemSchema();
                    switch (itemDefs[cast item.type]) {
                        case null:
                            // pass
                        case itemDef:
                            Object.assign(itemSchema.properties, {
                                item: itemDef,
                            });
                            itemSchema.required.push("item");
                    }
                    itemSchema;
                }),
                additionalItems: itemSchema(),
                minItems: 1,
            };
        };
    }

    static function summarizeItem(orderItem:{
        ?type:DongDongItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case LunchSet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], [box]);
            case UsualSet:
                summarizeOrderObject(orderItem.item, def, ["main", "noodle", "options", "drink"], ["配炒滑蛋及牛油多士", box]);
            case DinnerDish:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], [box]);
            case DinnerSet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], ["附送例湯", box]);
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