package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract MGYItem(String) to String {
    final SideDish;
    final StirFriedNoodlesOrRice;
    final Rice;
    final Snack;
    final LunchSet;

    static public function all(timeSlot:Null<TimeSlot>):ReadOnlyArray<MGYItem> {
        if (timeSlot == null || timeSlot.start == null){
            return [];
        }

        final date = timeSlot.start.toDate();
        final lunchSet = switch [
            Weekday.fromDay(date.getDay()),
            HkHolidays.isRedDay(date),
            switch (LunarCalendar.lunarDate(date).day) {
                case 1 | 15: true;
                case _: false;
            },
            TimeSlotType.classify(timeSlot.start)
        ] {
            case [Tuesday | Wednesday | Thursday | Friday, false, false, Lunch]:
                [
                    LunchSet,
                ];
            case _:
                [];
        }
        return []
            .concat(lunchSet)
            .concat([
                SideDish,
                StirFriedNoodlesOrRice,
                Rice,
                Snack,
            ]);
    }

    public function getDefinition(pickupTimeSlot:Null<TimeSlot>):Dynamic return switch (cast this:MGYItem) {
        case SideDish: MGYMenu.MGYSideDish;
        case StirFriedNoodlesOrRice: MGYMenu.MGYStirFriedNoodlesOrRice;
        case Rice: MGYMenu.MGYRice;
        case Snack: MGYMenu.MGYSnack;
        case LunchSet: MGYMenu.MGYLunchSet;
    }
}

class MGYMenu {
    static function markup(price:Float):Float {
        return Math.round(price / 0.85);
    }

    static function item(name:String, price:Float):String {
        return name + " $" + markup(price);
    }

    static public final MGYSideDish = {
        title: "小菜",
        properties: {
            dish: {
                title: "小菜",
                type: "string",
                "enum": [
                    "豉汁素楊玉 $" + markup(62),
                    "咕嚕素芝球 $" + markup(62),
                    "泰式西芹花枝丸 $" + markup(62),
                    "鮮茄燜枝竹 $" + markup(62),
                    "白汁粟米蓉金磚豆卜 $" + markup(62),
                    "豪油焗素芝片 $" + markup(62),
                    "如香茄子 $" + markup(62),
                    "欖菜菇絲芸豆 $" + markup(66),
                    "瓣醬豆腐 $" + markup(62),
                    "香草焗南瓜 $" + markup(62),
                    "香草焗薯角 $" + markup(62),
                    "香椿鮮菇燜淮山 $" + markup(66),
                    "咖喱薯仔 $" + markup(62),
                    "八珍豆腐扒時菜 $" + markup(62),
                    "豉汁菇片炒涼瓜 $" + markup(62),
                    "香椿如腐雲耳炒勝瓜 $" + markup(62),
                    "黑椒菇角炒脆玉瓜 $" + markup(62),
                    "金菇絲燴娃娃菜 $" + markup(62),
                    "羅漢齋 $" + markup(62),
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
                    "香椿松子炒飯 $" + markup(50),
                    "黃薑瓜粒炒飯 $" + markup(50),
                    "黑椒蘑菇意粉 $" + markup(50),
                    "羅漢齋烏冬 $" + markup(50),
                ],
            },
        },
        required: [
            "fried",
        ]
    };

    static public final MGYLunchSetGiven = "湯、時菜、小食/糕點";
    static public final MGYLunchSet = {
        title: "午市套餐",
        description: '套餐配有${MGYLunchSetGiven}。供應日子：星期二至星期五 (初一、十五及公眾假期除外)',
        properties: {
            main: {
                type: "string",
                title: "午市套餐",
                "enum": [
                    "1. 茄汁朱排 配白飯 $" + markup(59),
                    "2. 羅漢齋 配白飯 $" + markup(59),
                    "3. 咖喱素楊玉 配白飯 $" + markup(59),
                    "4. 沙茶豆腐燜枝竹 配白飯 $" + markup(59),
                    "5. 糖醋候頭菇 配白飯 $" + markup(59),
                    "6. 醬爆候頭楊小排 配白飯 $" + markup(59),

                    "A. 咸如玉粒炒飯 $" + markup(59),
                    "B. 菠蘿芝丁炒飯 $" + markup(59),
                    "C. 黄薑菇粒炒飯 $" + markup(59),
                    "D. 什菌燴烏冬 $" + markup(59),
                    "E. 涼瓜排橘飯 $" + markup(59),
                ],
            },
            drink: {
                type: "string",
                title: "加配飲品",
                "enum": [
                    "細可樂 $" + markup(4),
                    "大Zero $" + markup(6),
                    "豆漿 $" + markup(6),
                    "酸梅湯 $" + markup(6),
                ],
            },
        },
        required: [
            "main",
        ]
    };

    static final rice = "白飯 $" + markup(8);
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
            "湯餃子(8件) $" + markup(38),
            "炸餃子(4件) $" + markup(25),
            "地瓜卷(6件) $" + markup(25),
            "炸薄脆(6件) $" + markup(25),
            "薯蛋球(4件) $" + markup(25),
            "炸饅頭(4件) $" + markup(25),
            "炸腐皮卷(4件) $" + markup(25),
            "椒鹽豆腐(8件) $" + markup(25),
            "白灼羽衣甘藍 $" + markup(32),
            "小食併盤 $" + markup(45),
        ],
    };

    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: MGYItem.all(pickupTimeSlot).map(item -> {
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
                switch (cast item.type:MGYItem) {
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

    static function summarizeItem(
        pickupTimeSlot:Null<TimeSlot>,
        orderItem:{
            ?type:MGYItem,
            ?item:Dynamic,
        }
    ):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition(pickupTimeSlot);
        return switch (orderItem.type) {
            case SideDish:
                summarizeOrderObject(orderItem.item, def, ["dish"], []);
            case StirFriedNoodlesOrRice:
                summarizeOrderObject(orderItem.item, def, ["fried"], []);
            case LunchSet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], [MGYLunchSetGiven]);
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

    static public function summarize(
        pickupTimeSlot:Null<TimeSlot>,
        formData:FormOrderData
    ):OrderSummary {
        var s = concatSummaries(formData.items.map(item -> summarizeItem(pickupTimeSlot, cast item)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}