package hkssprangers.info.menu;

import haxe.ds.ReadOnlyArray;
import js.lib.Object;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;
using Lambda;
using hxLINQ.LINQ;

enum abstract LittleFishFranItem(String) to String {
    final LunchSet;
    final FishPot;
    final Pot;
    final Dish;
    final ColdDish;
    final Rice;
    final Noodles;
    final SpicyPot;
    final SoupPot;
    final SpicyThing;
    final Dessert;
    final Drink;

    static public function all(timeSlotType:TimeSlotType):ReadOnlyArray<LittleFishFranItem> {
        return
            (switch (timeSlotType) {
                case Lunch:
                    [LunchSet];
                case _:
                    [];
            }).concat([
                FishPot,
                Pot,
                Dish,
                ColdDish,
                Rice,
                Noodles,
                SpicyPot,
                SoupPot,
                SpicyThing,
                Dessert,
                Drink,
            ]);
    }

    public function getDefinition():Dynamic return switch (cast this:LittleFishFranItem) {
        case LunchSet: LittleFishFranMenu.LittleFishFranLunchSet;
        case FishPot: LittleFishFranMenu.LittleFishFranFishPot;
        case Pot: LittleFishFranMenu.LittleFishFranPot;
        case Dish: LittleFishFranMenu.LittleFishFranDish;
        case ColdDish: LittleFishFranMenu.LittleFishFranColdDish;
        case Rice: LittleFishFranMenu.LittleFishFranRice;
        case Noodles: LittleFishFranMenu.LittleFishFranNoodles;
        case SpicyPot: LittleFishFranMenu.LittleFishFranSpicyPot;
        case SoupPot: LittleFishFranMenu.LittleFishFranSoupPot;
        case SpicyThing: LittleFishFranMenu.LittleFishFranSpicyThing;
        case Dessert: LittleFishFranMenu.LittleFishFranDessert;
        case Drink: LittleFishFranMenu.LittleFishFranDrink;
    }
}

class LittleFishFranMenu {
    static function item(name:String, price:Float, plusSign:Bool = false):String {
        return name + (plusSign ? " +$" : " $") + Math.ceil(price * 1.11);
    }

    static function lunchNoodle(main:String, options:Array<String>, price:Float):Array<String> {
        return options.map(type -> item(main + " " + type, price));
    }

    static public final LittleFishFranLunchSet = {
        title: "午市套餐",
        properties: {
            main: {
                type: "string",
                title: "午市套餐",
                "enum": [
                    lunchNoodle("水煮牛肉", ["上海麵","粉條","米線","飯"], 58),
                    lunchNoodle("水煮魚片", ["上海麵","粉條","米線","飯"], 58),
                    lunchNoodle("酸菜魚片", ["上海麵","粉條","米線","飯"], 58),
                    lunchNoodle("鮮茄香菇魚片", ["上海麵","粉條","米線","飯"], 58),
                    [
                        item("重慶雞飯", 55),
                        item("口水雞飯", 52),
                        item("梅菜扣肉飯", 52),
                        item("法式牛尾飯", 61),
                        item("泰式豬頸肉飯", 61),
                        item("乾炒牛河", 52),
                        item("星州炒米", 52),
                        item("楊州炒飯", 52),
                        item("香菜豬潤麵", 52),
                        item("地道雲吞麵", 52),
                        item("回鍋肉飯", 55),
                        item("生炒骨飯", 55),
                        item("麻婆豆腐飯", 52),
                    ]
                ].linq().selectMany((v,i) -> v).toArray(),
            },
            drink: {
                type: "string",
                title: "飲品",
                description: "奉送：" + [
                    "老火湯(送完即止)",
                    "熱咖啡或茶",
                    item("凍飲", 3, true),
                    item("菜蜜檸蜜", 3, true),
                    item("罐裝飲品", 5, true),
                    item("特飲", 8, true),
                    item("珍寶沙冰", 16, true),
                ].join(" / "),
                "enum": [
                    "唔要",
                    item("老火湯", 0, true),
                    item("珍寶青檸樹", 16, true),
                    item("珍寶菠蘿雪山(菠蘿+椰汁)", 16, true),
                    item("珍寶莎莎冰(蕃茄+青檸)", 16, true),
                    item("珍寶玉龍冰(火龍果)", 16, true),
                    item("珍寶紅豆沙冰", 16, true),
                    item("珍寶巨峰沙冰", 16, true),
                    item("荔枝梳打", 8, true),
                    item("巨峰梳打", 8, true),
                    item("咸檸七", 8, true),
                    item("咸檸梳打", 8, true),
                    item("青檸梳打", 8, true),
                    item("果醋飲料", 5, true),
                    item("王老吉", 5, true),
                    item("蜂蜜綠茶", 5, true),
                    item("梳打水(罐裝)", 5, true),
                    item("罐裝汽水 可口可樂", 5, true),
                    item("罐裝汽水 無糖可樂", 5, true),
                    item("罐裝汽水 七喜", 5, true),
                    item("罐裝汽水 芬達橙汁", 5, true),
                    item("罐裝汽水 忌廉", 5, true),
                    item("熱檸茶", 0, true),
                    item("熱檸水", 0, true),
                    item("熱菜蜜", 3, true),
                    item("熱咖啡", 0, true),
                    item("熱奶茶", 0, true),
                    item("熱鴛鴦", 0, true),
                    item("熱華田", 0, true),
                    item("熱好立克", 0, true),
                    item("熱杏仁霜", 0, true),
                    item("熱利賓納", 0, true),
                    item("熱檸蜜", 3, true),
                    item("熱檸樂", 8, true),
                    item("熱可樂煲薑", 8, true),
                    item("熱檸樂煲薑", 8, true),
                    item("凍華田", 3, true),
                    item("凍好立克", 3, true),
                    item("凍杏仁霜", 3, true),
                    item("凍利賓納", 3, true),
                    item("凍菜蜜", 6, true),
                    item("凍檸蜜", 6, true),
                    item("凍檸樂", 8, true),
                    item("紅豆冰", 8, true),
                    item("什果冰", 8, true),
                    item("菠蘿冰", 8, true),
                ],
            },
            veg: {
                type: "string",
                title: "加餐菜",
                "enum": [
                    item("菜芯", 13, true),
                    item("生菜", 13, true),
                ],
            },
        },
        required: [
            "main",
            "drink",
        ],
    }

    static public final LittleFishFranFishPot = {
        title: "特色魚鍋",
        properties: {
            style: {
                type: "string",
                title: "湯底",
                "enum": [
                    "烏江魚鍋🌶",
                    "鮮茄魚鍋",
                    "青椒魚鍋🌶",
                    "酸菜魚鍋",
                    "水煮魚(跟粉條)🌶",
                ],
            },
            main: {
                type: "string",
                title: "配料",
                "enum": [
                    item("桂花魚 小鍋", 265),
                    item("桂花魚 大鍋", 445),
                    item("鱸魚 小鍋", 265),
                    item("鱸魚 大鍋", 445),
                    item("鯇魚 小鍋", 164),
                    item("鯇魚 大鍋", 286),
                    item("鯛魚 小鍋", 164),
                    item("鯛魚 大鍋", 286),
                    item("白鱔 小鍋", 256),
                    item("白鱔 大鍋", 438),
                    item("黃鱔 小鍋", 256),
                    item("黃鱔 大鍋", 438),
                    item("魚頭 小鍋", 195),
                    item("魚頭 大鍋", 335),
                    item("雞 小鍋", 190),
                    item("雞 大鍋", 302),
                    item("田雞 小鍋", 198),
                    item("田雞 大鍋", 306),
                ],
            },
            options: {
                type: "array",
                title: "額外加配",
                items: {
                    type: "string",
                    "enum": [
                        "粉條 $42",
                    ],
                },
                uniqueItems: true,
            },
        },
        required: [
            "style",
            "main",
        ],
    }

    static public final LittleFishFranPot = {
        title: "煲/鍋",
        type: "string",
        "enum": [
            item("重慶雞煲🌶 小鍋", 205),
            item("重慶雞煲🌶 大鍋", 318),
            item("藥材雞煲(鍋)", 205),
            item("茶樹菇雞煲(鍋)", 205),
            item("魚頭鍋(鍋)", 208),
            item("奇味雞煲(鍋)", 208),
            item("魚湯米粥鍋底(鍋)", 88),
            item("雞湯米粥鍋底(鍋)", 88),
        ],
    };

    static public final LittleFishFranDish = {
        title: "精美小菜",
        type: "string",
        "enum": [
            item("毛血旺🌶(例)", 155),
            item("水煮牛肉🌶(例)", 155),
            // "避風塘炒蟹🌶 時價 (需預定)",
            // "薑蔥炒蟹 時價 (需預定)",
            // "魚鍋香辣蟹🌶 時價 (需預定)",

            item("樟茶鴨 半隻", 142),
            item("樟茶鴨 一隻", 238),
            item("砂鍋雲吞雞 半隻", 166),
            item("砂鍋雲吞雞 一隻", 278),
            item("原味焗蜆", 92),
            item("剁椒焗蜆", 92),
            item("八珍豆腐煲", 84),
            item("回鍋肉", 68),
            item("豆豉鯪魚油麥菜", 68),
            item("油鹽水魚雲", 108),
            item("油鹽水魚腩", 102),
            item("油鹽水蜆", 88),
            item("炒藕片", 58),
            item("虎皮尖椒", 68),
            item("韭菜雞紅", 68),
            item("時蔬涷豆腐煲", 78),
            item("榨菜炒雞雜", 88),
            item("乾煸四季豆", 68),
            item("清炒時蔬", 62),
            item("蒜茸時蔬", 62),
            item("燴炒時蔬", 62),
            item("上湯時蔬", 62),
            item("菜莆炒蛋", 58),
            item("榨菜炒肉絲", 78),
            item("尖椒炒肉絲", 78),
            item("清炒萵笋絲", 62),
            item("蒜茸萵笋絲", 62),
            item("清炒土豆絲", 58),
            item("辣子土豆絲", 58),
            item("豉汁蒸划水(魚尾)", 96),
            item("剁椒蒸划水(魚尾)", 96),
            item("豉汁蒸魚頭(半個)", 104),
            item("剁椒蒸魚頭(半個)", 104),
            item("豉汁蒸魚腩", 102),
            item("剁椒蒸魚腩", 102),
            item("豉汁涼瓜魚腩", 102),
            item("豉汁涼瓜田雞", 108),
            item("豉汁蒸白鱔", 168),
            item("豉椒炒牛柏葉", 76),
            item("豉椒炒黃鱔", 92),
            item("豉椒炒蜆", 86),
            item("麻婆豆腐", 58),
            item("椒鹽田雞", 108),
            item("椒鹽魚腩", 102),
            item("椒鹽白鱔", 168),
            item("椒鹽軟殼蟹", 172),
            item("椒鹽豬扒", 82),
            item("椒鹽豆腐粒", 58),
            item("醉白鱔煲", 186),
            item("醉豬腦煲", 88),
            item("醉雞子煲", 106),
            item("醉雞煲", 95),
            item("薑蔥魚春", 122),
            item("薑蔥魚春及魚卜", 132),
            item("薑蔥魚腩", 108),
            item("薑蔥魚頭", 125),
            item("薑蔥白鱔煲", 186),
            item("薑蔥田雞", 116),
            item("薑蔥生蠔", 156),
            item("鮮菌紅燒豆腐", 72),
            item("鮮果生炒骨", 82),
            item("酥炸生蠔", 168),
            item("啫啫白鱔煲", 188),
            item("啫啫雞煲", 98),
            item("啫啫雞雜煲", 102),
            item("脆皮乳鴿", 58),
        ],
    };

    static public final LittleFishFranColdDish = {
        title: "涼菜",
        type: "string",
        "enum": [
            item("口水雞 例", 80),
            item("口水雞 半隻", 132),
            item("口水雞 一隻", 222),
            item("拍青瓜", 38),
            item("芥末青瓜", 38),
            item("麻辣青瓜", 38),
            item("皮蛋酸薑", 36),
            item("皮蛋青椒", 36),
            item("涼拌皮蛋豆腐", 36),
            item("麻辣皮蛋", 36),
            item("酸辣粉條", 38),
            item("麻辣粉條", 38),
            item("麻辣拌麵", 38),
            item("野山椒泡鳳爪", 62),
            item("蒜泥白肉", 58),
            item("夫妻肺片", 72),
        ],
    };

    static public final LittleFishFranRice = {
        title: "飯類",
        type: "string",
        "enum": [
            item("海鮮泡飯", 72),
            item("瓜粒肉碎泡飯", 56),
            item("芫茜魚片泡飯", 62),
            item("鮮菇魚片泡飯", 62),
            item("楊州炒飯", 60),
            item("生炒牛肉炒飯", 60),
            item("白飯(碗)", 12),
            item("白粥(碗)", 12),
        ],
    };

    static public final LittleFishFranNoodles = {
        title: "湯粉麵類",
        properties: {
            main: {
                type: "string",
                title: "配料",
                "enum": [
                    // item("酸辣湯粉條", 40),
                    item("酸菜魚片麵", 62),
                    item("酸菜魚腩麵", 72),
                    item("酸菜魚頭麵", 94),
                    item("麻辣魚蛋麵", 52),
                    item("鮮茄蛋麵", 48),
                    item("鮮菇魚片麵", 62),
                    item("鮮菇麵", 46),
                    item("鮮辣魚片麵", 62),
                    item("鮮辣魚腩麵", 72),
                    item("鮮辣魚頭麵", 94),
                    item("香茜皮蛋魚片麵", 65),
                    item("海鮮麵", 68),
                    item("漢城海鮮辣麵", 68),
                    item("豬扒麵", 48),
                    item("雞翼麵", 48),
                ],
            },
            noodles: {
                type: "string",
                title: "麵類",
                "enum": [
                    "擔擔麵",
                    "上海麵",
                    "粉條",
                    "刀削麵",
                    item("烏冬", 3, true),
                    item("出前一丁", 3, true),
                    item("辛辣麵", 3, true),
                ],
            },
        },
        required: [
            "main",
            "noodles",
        ],
    };

    static public final LittleFishFranSpicyPot = {
        title: "麻辣煲仔",
        type: "string",
        "enum": [
            item("麻辣鴛鴦雞煲", 128),
            item("麻辣田雞煲", 116),
            item("麻辣雞煲", 98),
            item("麻辣雞雜煲", 106),
            item("麻辣雞子煲", 105),
            item("麻辣魚春拼魚卜煲", 132),
            item("麻辣魚春煲", 132),
            // item("麻辣魚卜煲", 122),
            item("麻辣魚頭煲", 128),
            item("麻辣魚腩煲", 108),
            item("麻辣黃鱔煲", 116),
            item("麻辣白鱔煲", 186),
            item("麻辣生蠔煲", 154),
            item("麻辣豬腦煲", 88),
            item("麻辣涷豆腐煲", 88),
            item("麻辣大腸煲", 92),
        ],
    };

    static public final LittleFishFranSoupPot = {
        title: "湯類(窩)",
        type: "string",
        "enum": [
            item("煮雞酒", 142),
            item("魚頭薑湯", 192),
            item("時菜豆腐魚頭湯", 192),
            item("芫茜皮蛋魚頭湯", 192),
            item("鮮茄豬潤魚頭湯", 192),
        ],
    };

    static public final LittleFishFranSpicyThing = {
        title: "辣子/麻辣燙",
        type: "string",
        "enum": [
            item("歌樂山辣子雞", 162),
            item("辣子田雞", 168),
            item("辣子軟殼蟹", 178),
            item("辣子大腸", 128),
            item("金菇肥牛 (麻辣燙)", 108),
            item("金菇小肥羊 (麻辣燙)", 116),
            item("金菇牛柏葉 (麻辣燙)", 104),
        ],
    };

    static public final LittleFishFranDessert = {
        title: "甜品/小食",
        type: "string",
        "enum": [
            item("擂沙湯丸", 42),
            item("香煎南瓜餅", 42),
            // item("酒釀桂花小丸子", 32),
            item("薑汁湯丸", 38),
            item("椒鹽雞翼尖", 46),
            item("風沙蒜香雞中翼", 46),
            item("麻辣三寶(雞紅/蘿蔔/魚蛋)", 52),
            item("紅油抄手", 46),
            item("酥炸雲吞", 46),
            item("蒸饅頭 (半打)", 46),
            item("炸饅頭 (半打)", 46),
            item("生煎菜肉包", 42),
            item("雞湯魚皮餃", 46),
            item("雞湯韮菜餃", 52),
            "糍粑 配紅糖 $42",
        ],
    };

    static public final LittleFishFranDrink = {
        title: "飲品",
        type: "string",
        "enum": [
            item("珍寶青檸樹", 35),
            item("珍寶菠蘿雪山(菠蘿+椰汁)", 35),
            item("珍寶莎莎冰(蕃茄+青檸)", 35),
            item("珍寶玉龍冰(火龍果)", 35),
            item("珍寶紅豆沙冰 ", 35),
            item("珍寶巨峰沙冰", 35),
            // item("珍寶白桃沙冰", 35),
            // item("珍寶芒果乳酸沙冰", 35),
            item("荔枝梳打", 23),
            item("巨峰梳打", 23),
            // item("百香果梳打", 23),
            item("咸檸七", 21),
            item("咸檸梳打", 21),
            item("青檸梳打", 21),
            // item("蜜桃冰紅茶", 20),
            // item("西瓜汁(凍)", 24),
            item("果醋飲料", 15),
            item("王老吉", 15),
            item("蜂蜜綠茶", 15),
            item("梳打水(罐裝)", 15),
            // item("梳打水(杯裝)", 6),
            item("罐裝汽水 可口可樂", 12),
            item("罐裝汽水 無糖可樂", 12),
            item("罐裝汽水 七喜", 12),
            item("罐裝汽水 芬達橙汁", 12),
            item("罐裝汽水 忌廉", 12),
            item("熱檸茶", 16),
            item("熱檸水", 16),
            item("熱菜蜜", 16),
            item("熱咖啡", 16),
            item("熱奶茶", 16),
            item("熱鴛鴦", 16),
            item("熱華田", 16),
            item("熱好立克", 16),
            item("熱杏仁霜", 16),
            item("熱利賓納", 16),
            item("熱檸蜜", 18),
            item("熱檸樂", 23),
            item("熱可樂煲薑", 23),
            item("熱檸樂煲薑", 23),
            item("凍華田", 19),
            item("凍好立克", 19),
            item("凍杏仁霜", 19),
            item("凍利賓納", 19),
            item("凍檸蜜", 21),
            item("凍檸樂", 21),
            item("紅豆冰", 22),
            item("菠蘿冰", 22),
        ],
    };

    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        return if (pickupTimeSlot == null || pickupTimeSlot.start == null) {
            type: "array",
            items: {
                type: "object",
            }
        } else {
            final itemDefs:Map<LittleFishFranItem, Dynamic> = [
                for (item in LittleFishFranItem.all(TimeSlotType.classify(pickupTimeSlot.start)))
                item => item.getDefinition()
            ];
            function itemSchema():Dynamic return {
                type: "object",
                properties: {
                    type: itemDefs.count() > 0 ? {
                        title: "食物種類",
                        type: "string",
                        oneOf: [
                            for (item => def in itemDefs)
                            {
                                title: def.title,
                                const: item,
                            }
                        ],
                    } : {
                        title: "⚠️ 請移除",
                        type: "string",
                        "enum": [],
                    },
                },
                required: [
                    "type",
                ],
            };
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
        ?type:LittleFishFranItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        final def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case LunchSet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink", "veg"]);
            case FishPot:
                summarizeOrderObject(orderItem.item, def, ["style", "main", "options"]);
            case Noodles:
                summarizeOrderObject(orderItem.item, def, ["main", "noodles"]);
            case Pot | Dish | ColdDish | Rice | SpicyPot | SoupPot | SpicyThing | Dessert | Drink:
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

    static public function summarize(formData:FormOrderData):OrderSummary {
        final s = concatSummaries(formData.items.map(item -> summarizeItem(cast item)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}