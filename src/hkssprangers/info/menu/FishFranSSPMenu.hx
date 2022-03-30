package hkssprangers.info.menu;

import haxe.ds.ReadOnlyArray;
import js.lib.Object;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;
using Lambda;

enum abstract FishFranSSPItem(String) to String {
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

    static public function all(timeSlotType:TimeSlotType):ReadOnlyArray<FishFranSSPItem> {
        return switch (timeSlotType) {
            case Lunch | Dinner:
                [
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
                ];
            case _:
                [];
        }
    }

    public function getDefinition():Dynamic return switch (cast this:FishFranSSPItem) {
        case FishPot: FishFranSSPMenu.FishFranSSPFishPot;
        case Pot: FishFranSSPMenu.FishFranSSPPot;
        case Dish: FishFranSSPMenu.FishFranSSPDish;
        case ColdDish: FishFranSSPMenu.FishFranSSPColdDish;
        case Rice: FishFranSSPMenu.FishFranSSPRice;
        case Noodles: FishFranSSPMenu.FishFranSSPNoodles;
        case SpicyPot: FishFranSSPMenu.FishFranSSPSpicyPot;
        case SoupPot: FishFranSSPMenu.FishFranSSPSoupPot;
        case SpicyThing: FishFranSSPMenu.FishFranSSPSpicyThing;
        case Dessert: FishFranSSPMenu.FishFranSSPDessert;
    }
}

class FishFranSSPMenu {
    static function item(name:String, price:Float):String {
        return name + " $" + Math.round(price * 1.1);
    }

    static public final FishFranSSPFishPot = {
        title: "特色魚鍋",
        properties: {
            style: {
                type: "string",
                title: "特色",
                "enum": [
                    "烏江魚鍋",
                    "鮮茄魚鍋",
                    "酸菜魚鍋",
                    "青椒魚鍋",
                    "水煮魚",
                ],
            },
            main: {
                type: "string",
                title: "配料",
                "enum": [
                    item("桂花魚 小鍋", 258),
                    item("桂花魚 大鍋", 438),
                    item("鯰魚 小鍋", 158),
                    item("鯰魚 大鍋", 278),
                    item("鯛魚 小鍋", 158),
                    item("鯛魚 大鍋", 278),
                    item("白鱔 小鍋", 246),
                    item("白鱔 大鍋", 426),
                    item("黃鱔 小鍋", 246),
                    item("黃鱔 大鍋", 426),
                    item("魚頭 小鍋", 190),
                    item("魚頭 大鍋", 326),
                    item("雞 小鍋", 188),
                    item("雞 大鍋", 298),
                    item("田雞 小鍋", 192),
                    item("田雞 大鍋", 298),
                ],
            },
        },
        required: [
            "style",
            "main",
        ],
    }

    static public final FishFranSSPPot = {
        title: "煲/鍋",
        type: "string",
        "enum": [
            item("重慶雞煲 小鍋", 198),
            item("重慶雞煲 大鍋", 308),
            item("奇味雞煲(鍋)", 198),
            item("藥材雞煲(鍋)", 198),
            item("魚頭雞煲(鍋)", 278),
            item("魚頭鍋(鍋)", 198),
            item("野山菌雞煲(鍋)", 198),
            item("茶樹菇雞煲(鍋)", 198),
            item("鴨棚子(鍋)", 258),
            // "鮮鍋(魚頭+羊腩)(鍋) 時價",
            // "羊腩煲(鍋) 時價",
            item("蘿蔔豬骨煲(鍋)", 198),
            item("水煮牛肉(例)", 148),
        ],
    };

    static public final FishFranSSPDish = {
        title: "精美小菜",
        type: "string",
        "enum": [
            item("樟茶鴨 半隻", 142),
            item("樟茶鴨 一隻", 238),
            item("砂鍋雲吞雞 半隻", 166),
            item("砂鍋雲吞雞 一隻", 278),
            item("原味焗蜆", 92),
            item("剁椒焗蜆", 92),
            item("砂鍋雲耳雞什", 98),
            item("八珍豆腐煲", 84),
            item("大豆芽炒肉碎", 62),
            item("回鍋肉", 68),
            item("豆豉鯪魚油麥菜", 68),
            item("油鹽水魚雲", 108),
            item("油鹽水魚腩", 102),
            item("油鹽水蜆", 88),
            item("魚湯米粥鍋底", 88),
            item("雞湯米粥鍋底", 88),
            item("毛血旺(例)", 148),
            // "魚鍋香辣蟹 時價 (需預定)",
            // "避風塘炒蟹 時價 (需預定)",
            // "薑蔥炒蟹 時價 (需預定)",
            item("泡椒涼瓜田雞", 108),
            item("泡椒魚腩", 102),
            item("泡椒椒魚卜", 106),
            item("野生椒魚卜", 106),
            item("炒藕片", 58),
            item("虎皮尖椒", 62),
            item("青瓜煮蝦", 112),
            item("韭菜雞紅", 68),
            item("時蔬凍豆腐煲", 78),
            item("乾煸涼瓜", 62),
            item("乾煸四季豆", 62),
            item("涼瓜炒蛋", 58),
            item("菜莆炒蛋", 58),
            item("涼瓜炒肉絲", 68),
            item("榨菜炒肉絲", 68),
            item("尖椒炒肉絲", 68),
            item("榨菜炒雞雜", 78),
            item("清炒蒜茸萵笋絲", 62),
            item("清炒土豆絲", 58),
            item("辣子土豆絲", 58),
            item("清炒時蔬", 58),
            item("蒜茸時蔬", 58),
            item("燴炒時蔬", 58),
            item("上湯時蔬", 58),
            item("豉椒炒鵝腸", 168),
            item("豉汁蒸划水(魚尾)", 96),
            item("剁椒蒸划水(魚尾)", 96),
            item("豉汁蒸魚頭(半份)", 104),
            item("剁椒蒸魚頭(半份)", 104),
            item("豉汁蒸魚腩", 102),
            item("剁椒蒸魚腩", 102),
            item("豉汁涼瓜魚腩", 102),
            item("豉汁蒸白鱔", 168),
            item("豉椒炒牛柏葉", 76),
            item("豉椒炒蜆", 86),

            item("椒鹽白鱔", 168),
            item("椒鹽豆腐粒", 58),
            item("椒鹽軟殼蟹", 172),
            item("酸豆角炒肉碎", 68),
            item("醉白鱔煲", 178),
            item("醉豬腦煲", 88),
            item("醉雞子煲", 96),
            item("醉雞煲", 95),
            item("薑蔥魚卜", 116),
            item("薑蔥魚春", 116),
            item("薑蔥魚春及魚卜", 126),
            item("薑蔥魚腩", 98),
            item("薑蔥魚頭", 115),
            item("薑蔥白鱔煲", 176),
            item("薑蔥田雞", 106),
            item("薑蔥雞", 92),
            item("薑蔥雞什", 94),
            item("薑蔥生蠔", 146),
            item("鍋仔饅頭雞", 92),
            item("鮮果生炒骨", 78),
            item("鮮菌紅燒豆腐", 72),
            item("雞汁蘿白", 72),
            item("羅定豆豉雞", 92),

            item("啫啫雞煲", 92),
            item("啫啫雞雜煲", 96),
            item("啫啫白鱔煲", 178),
            item("酥炸生蠔", 158),
            item("豉椒炒黃鱔", 92),
            item("麻婆豆腐", 58),
            item("椒鹽田雞", 108),
            item("脆皮乳鴿", 58),
        ],
    };

    static public final FishFranSSPColdDish = {
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
            item("麻醬生菜", 48),
            item("麻醬麥菜", 48),
            item("川北涼粉", 38),
            item("麻辣粉條", 38),
            item("麻辣拌麵", 35),
            item("酸辣粉條", 38),
            item("酸辣涼粉", 38),
            item("野山椒泡鳳爪", 58),
            item("蒜泥白肉", 58),
            item("麻辣鴨舌", 78),
            item("麻辣牛腩", 78),
            item("麻辣豬手", 72),
            item("夫妻肺片", 68),
            item("雞絲鵝腸", 168),
            item("麻辣皮蛋", 36),
        ],
    };

    static public final FishFranSSPRice = {
        title: "飯類",
        type: "string",
        "enum": [
            item("海鮮泡飯", 68),
            item("瓜粒肉碎泡飯", 52),
            item("芫茜魚片泡飯", 58),
            item("鮮菇魚片泡飯", 58),
            item("楊州炒飯", 58),
            item("生炒牛肉炒飯", 58),
        ],
    };

    static public final FishFranSSPNoodles = {
        title: "湯粉麵類",
        properties: {
            main: {
                type: "string",
                title: "配料",
                "enum": [
                    item("四川擔擔麵", 42),
                    item("酸辣湯粉條", 40),
                    item("酸菜魚片麵", 58),
                    item("酸菜魚腩麵", 68),
                    item("酸菜魚頭麵", 88),
                    item("麻辣魚蛋麵", 52),
                    item("麻辣牛腩麵", 68),
                    item("麻辣豬手麵", 58),
                    item("鮮茄蛋麵", 48),
                    item("鮮菇魚片麵", 58),
                    item("鮮菇麵", 46),
                    item("鮮辣魚片麵", 58),
                    item("鮮辣魚腩麵", 68),
                    item("鮮辣魚頭麵", 88),
                    item("三寶麵", 58),
                    item("小雲吞麵", 42),
                    item("香茜皮蛋魚片麵", 60),
                    item("海鮮麵", 62),
                    item("漢城海鮮辣麵", 62),
                    item("豬扒麵", 48),
                    item("雞翼麵", 48),
                ],
            },
            noodles: {
                type: "string",
                title: "麵類",
                "enum": [
                    "上海麵",
                    "粉條",
                    "刀削麵",
                    "烏冬 +$3",
                    "出前一丁 +$3",
                    "辛辣麵 +$3",
                ],
            },
        },
        required: [
            "main",
            "noodles",
        ],
    };

    static public final FishFranSSPSpicyPot = {
        title: "麻辣煲仔",
        type: "string",
        "enum": [
            item("麻辣鴛鴦雞煲", 122),
            item("麻辣田雞煲", 108),
            item("麻辣雞煲", 98),
            item("麻辣雞雜煲", 98),
            item("麻辣雞子煲", 95),
            item("麻辣雞翼尖煲", 85),
            item("麻辣魚頭煲", 115),
            item("麻辣魚腩煲", 102),
            item("麻辣魚春煲", 116),
            item("麻辣魚卜煲", 116),
            item("麻辣魚春拼魚卜煲", 128),
            item("麻辣豬腦煲", 88),
            item("麻辣白鱔煲", 176),
            item("麻辣生蠔煲", 148),
            item("麻辣黃鱔煲", 112),
            item("麻辣涷豆腐煲", 88),
        ],
    };

    static public final FishFranSSPSoupPot = {
        title: "湯類(窩)",
        type: "string",
        "enum": [
            item("煮雞酒", 136),
            item("魚頭薑湯", 182),
            item("時菜豆腐魚頭湯", 182),
            item("芫茜皮蛋魚頭湯", 182),
            item("鮮茄豬潤魚頭湯", 182),
        ],
    };

    static public final FishFranSSPSpicyThing = {
        title: "辣子/麻辣燙",
        type: "string",
        "enum": [
            item("歌樂山辣子雞", 156),
            item("辣子蝦", 168),
            item("辣子田雞", 162),
            item("辣子軟殼蟹", 178),
            item("辣子大腸", 118),
            item("金菇肥牛 (麻辣燙)", 102),
            item("金菇小肥羊 (麻辣燙)", 102),
            item("金菇牛柏葉 (麻辣燙)", 98),
            item("金菇鵝腸 (麻辣燙)", 168),
        ],
    };

    static public final FishFranSSPDessert = {
        title: "甜品/小食",
        type: "string",
        "enum": [
            item("紅油抄手", 46),
            item("酥炸雲吞", 46),
            item("麻辣魚蛋", 40),
            item("雞湯小雲吞", 46),
            item("生煎菜肉包", 42),
            item("椒鹽雞翼尖", 46),
            item("風沙蒜香雞中翼", 42),
            item("蒸饅頭 (半打)", 46),
            item("炸饅頭 (半打)", 46),
            item("三寶", 52),
            item("香煎南瓜餅", 38),
            item("擂沙湯丸", 38),
        ],
    };

    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        return if (pickupTimeSlot == null || pickupTimeSlot.start == null) {
            type: "array",
            items: {
                type: "object",
            }
        } else {
            final itemDefs = [
                for (item in FishFranSSPItem.all(TimeSlotType.classify(pickupTimeSlot.start)))
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
        ?type:FishFranSSPItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        final def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case FishPot:
                summarizeOrderObject(orderItem.item, def, ["style", "main"]);
            case Noodles:
                summarizeOrderObject(orderItem.item, def, ["main", "noodles"]);
            case Pot | Dish | ColdDish | Rice | SpicyPot | SoupPot | SpicyThing | Dessert:
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