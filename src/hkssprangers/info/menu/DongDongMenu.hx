package hkssprangers.info.menu;

import hkssprangers.browser.forms.OrderForm.OrderData;
import js.lib.Object;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;

class DongDongMenu {
    static public final DongDongLunchSet = {
        title: "午餐",
        description: "注意每份會另加外賣盒收費 $1.",
        properties: {
            main: {
                title: "午餐選擇",
                type: "string",
                "enum": [
                    "京都豬扒飯 $50",
                    "泰式炒飯 $50",
                    "菜遠排骨炒河 $50",
                    "豉油王肉絲炒麵 $50",
                    "魚香茄子飯 $50",
                    "紅酒牛肋飯 $54",
                    "薯角牛仔粒飯 $50",
                    "豉油雞脾飯 $50",
                    "韭王叉燒炒蛋飯 $50",
                    "咖哩牛脷飯 $54",
                    "司華力腸配牛扒飯 $55",
                    "司華力腸配吉豬飯 $55",
                    "司華力腸配吉魚飯 $55",
                    "焗鮮茄芝士豬扒飯 $55",
                    "焗白汁芝士海鮮飯 $55",
                    "[常餐]沙嗲牛肉麵配炒滑蛋及牛油多士 $44",
                    "[常餐]火腿通粉配炒滑蛋及牛油多士 $44",
                    "[常餐]香茅豬扒配炒滑蛋及牛油多士 $44",
                    "[常餐]香茅雞扒配炒滑蛋及牛油多士 $44",
                    "[常餐]吉烈魚柳伴德國腸配炒滑蛋及牛油多士 $44",
                ]
            },
            drink: {
                title: "跟餐飲品",
                type: "string",
                "enum": [
                    "熱奶茶",
                    "熱咖啡",
                    "熱檸茶",
                    "熱檸水",
                    "熱好立克",
                    "熱阿華田",
                    "熱檸蜜 (+$2)",
                    "凍奶茶 (+$2)",
                    "凍咖啡 (+$2)",
                    "凍檸茶 (+$2)",
                    "凍檸水 (+$2)",
                    "凍好立克 (+$2)",
                    "凍阿華田 (+$2)",
                    "罐裝可樂 (+$3)",
                    "凍檸蜜 (+$4)",
                    "檸檬可樂 (+$8)",
                ],
            },
        },
        required: [
            "main",
            "drink",
        ]
    };

    static public final DongDongDinnerDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "不需要",
            "熱奶茶 (+$4)",
            "熱咖啡 (+$4)",
            "熱檸茶 (+$4)",
            "熱檸水 (+$4)",
            "熱好立克 (+$4)",
            "熱阿華田 (+$4)",
            "熱檸蜜 (+$6)",
            "凍奶茶 (+$6)",
            "凍咖啡 (+$6)",
            "凍檸茶 (+$6)",
            "凍檸水 (+$6)",
            "凍好立克 (+$6)",
            "凍阿華田 (+$6)",
            "罐裝可樂 (+$6)",
            "凍檸蜜 (+$8)",
            "檸檬可樂 (+$10)",
        ],
    };

    static public final DongDongDinnerDish = {
        title: "晚餐 - 單叫小菜",
        description: "附送例湯. 注意每份會另加外賣盒收費 $1.",
        properties: {
            main: {
                title: "小菜",
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
                    "馬拉盞牛肉菜芯 $88",
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
            "drink",
        ]
    };

    static public final DongDongDinnerSet = {
        title: "晚餐 - 客飯/蒸飯套餐",
        description: "附送例湯. 注意每份會另加外賣盒收費 $1.",
        properties: {
            main: {
                title: "晚飯套餐",
                type: "string",
                "enum": [
                    "椒鹽豬扒飯 $50",
                    "西炒飯 $50",
                    "乾炒牛河 $52",
                    "星洲炒米 $50",
                    "肉絲炒麵 $50",
                    "秋葵牛仔粒飯 $52",
                    "茄子班腩飯 $50",
                    "芙蓉蛋飯 $50",
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
                    "馬拉盞牛肉菜芯配白飯 $78",
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
            "drink",
        ]
    }

    static public function itemsSchema(pickupTimeSlot:TimeSlot, order:OrderData):Dynamic {
        return if (pickupTimeSlot == null)
            {
                type: "array",
                items: {
                    type: "object",
                }
            };
        else switch (TimeSlotType.classify(pickupTimeSlot.start)) {
            case Lunch:
                {
                    type: "array",
                    items: DongDongLunchSet,
                    minItems: 1,
                };
            case Dinner:
                function itemSchema() return {
                    type: "object",
                    properties: {
                        type: {
                            title: "食物種類",
                            type: "string",
                            "enum": [
                                "單叫小菜",
                                "客飯/蒸飯套餐",
                            ]
                        },
                    },
                    required: [
                        "type",
                    ],
                };
                {
                    type: "array",
                    items: order.items == null ? [] : order.items.map(item -> {
                        var itemSchema = itemSchema();
                        switch (item.type) {
                            case null:
                                //pass
                            case "單叫小菜":
                                Object.assign(itemSchema.properties, {
                                    item: DongDongDinnerDish,
                                });
                                itemSchema.required.push("item");
                            case "客飯/蒸飯套餐":
                                Object.assign(itemSchema.properties, {
                                    item: DongDongDinnerSet,
                                });
                                itemSchema.required.push("item");
                            case _:
                                //pass
                        }
                        itemSchema;
                    }),
                    additionalItems: itemSchema(),
                    minItems: 1,
                };
        }
    }
}