package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract MyRoomRoomItem(String) to String {
    final PastaRiceSet;
    final Snacks;
    final Cake;

    static public final all:ReadOnlyArray<MyRoomRoomItem> = [
        PastaRiceSet,
        Snacks,
        Cake,
    ];

    public function getDefinition():Dynamic return switch (cast this:MyRoomRoomItem) {
        case PastaRiceSet: MyRoomRoomMenu.MyRoomRoomPastaRiceSet;
        case Snacks: MyRoomRoomMenu.MyRoomRoomSnacks;
        case Cake: MyRoomRoomMenu.MyRoomRoomCake;
    }
}

class MyRoomRoomMenu {
    static final drinks = [
        {
            id: "L43",
            name: "檸檬茶",
            setPrice: 0,
            variants: ["凍", "熱"],
        },
        {
            id: "L42",
            name: "檸檬水",
            setPrice: 0,
            variants: ["凍", "熱"],
        },
        {
            id: "L45",
            name: "茉莉綠茶 (無糖)",
            setPrice: 0,
            variants: ["凍", "熱"],
        },
        {
            id: "L46",
            name: "阿薩姆紅茶 (無糖)",
            setPrice: 0,
            variants: ["凍", "熱"],
        },
        {
            id: "L47",
            name: "美式咖啡",
            setPrice: 13,
            variants: ["凍", "熱"],
        },
        {
            id: "L48",
            name: "鮮奶咖啡",
            setPrice: 13,
            variants: ["凍", "熱"],
        },
        {
            id: "L49",
            name: "泡沫咖啡",
            setPrice: 13,
            variants: ["凍", "熱"],
        },
        {
            id: "L50",
            name: "椰香牛奶咖啡",
            setPrice: 13,
            variants: ["凍", "熱"],
        },
        {
            id: "L51",
            name: "焦糖牛奶咖啡",
            setPrice: 13,
            variants: ["凍", "熱"],
        },
        {
            id: "L52",
            name: "榛子牛奶咖啡",
            setPrice: 13,
            variants: ["凍", "熱"],
        },
        {
            id: "L53",
            name: "雲呢拿牛奶咖啡",
            setPrice: 13,
            variants: ["凍", "熱"],
        },
        {
            id: "L54",
            name: "薑汁牛奶咖啡",
            setPrice: 13,
            variants: ["凍", "熱"],
        },
        {
            id: "L55",
            name: "香烤杏仁牛奶咖啡",
            setPrice: 13,
            variants: ["凍", "熱"],
        },
        {
            id: "L56",
            name: "冰川薄荷牛奶咖啡",
            setPrice: 13,
            variants: ["凍", "熱"],
        },
        {
            id: "L57",
            name: "玫瑰牛奶咖啡",
            setPrice: 13,
            variants: ["凍", "熱"],
        },
        {
            id: "L58",
            name: "莫卡朱古力咖啡",
            setPrice: 13,
            variants: ["凍", "熱"],
        },
        {
            id: "L01",
            name: "台式奶茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L02",
            name: "珍珠奶茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L04",
            name: "玫瑰奶茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L05",
            name: "椰香奶茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L06",
            name: "薑汁奶茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L07",
            name: "芋香奶茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L08",
            name: "桂圓紅棗奶茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L64",
            name: "黑糖奶茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L09",
            name: "薄荷梳打",
            setPrice: 9,
            variants: ["凍"],
        },
        {
            id: "L10",
            name: "荔枝梳打",
            setPrice: 9,
            variants: ["凍"],
        },
        {
            id: "L11",
            name: "香橙梳打",
            setPrice: 9,
            variants: ["凍"],
        },
        {
            id: "L12",
            name: "鳳梨梳打",
            setPrice: 9,
            variants: ["凍"],
        },
        {
            id: "L13",
            name: "芒果梳打",
            setPrice: 9,
            variants: ["凍"],
        },
        {
            id: "L14",
            name: "青檸梳打",
            setPrice: 9,
            variants: ["凍"],
        },
        {
            id: "L15",
            name: "提子梳打",
            setPrice: 9,
            variants: ["凍"],
        },
        {
            id: "L16",
            name: "水蜜桃梳打",
            setPrice: 9,
            variants: ["凍"],
        },
        {
            id: "L17",
            name: "青蘋果梳打",
            setPrice: 9,
            variants: ["凍"],
        },
        {
            id: "L18",
            name: "蘋果綠薄荷梳打",
            setPrice: 9,
            variants: ["凍"],
        },
        {
            id: "L19",
            name: "蜂蜜柚子梳打",
            setPrice: 9,
            variants: ["凍"],
        },
        {
            id: "L28",
            name: "芒果紅茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L28",
            name: "芒果綠茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L29",
            name: "百香果紅茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L29",
            name: "百香果綠茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L31",
            name: "荔枝紅茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L31",
            name: "荔枝綠茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L32",
            name: "香橙紅茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L32",
            name: "香橙綠茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L33",
            name: "鳳梨紅茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L33",
            name: "鳳梨綠茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L34",
            name: "蘋果紅茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L34",
            name: "蘋果綠茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L35",
            name: "蜂蜜紅茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L35",
            name: "蜂蜜綠茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L36",
            name: "鮮奶紅茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L36",
            name: "鮮奶綠茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L37",
            name: "薄荷紅茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L37",
            name: "薄荷綠茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L38",
            name: "玫瑰紅茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L38",
            name: "玫瑰綠茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L39",
            name: "水蜜桃紅茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L39",
            name: "水蜜桃綠茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L40",
            name: "玫瑰荔枝紅茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L40",
            name: "玫瑰荔枝綠茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L41",
            name: "薄荷鮮奶紅茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L41",
            name: "薄荷鮮奶綠茶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L44",
            name: "阿華田牛奶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L20",
            name: "玫瑰牛奶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L21",
            name: "椰子牛奶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L22",
            name: "抹茶牛奶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L23",
            name: "薑汁牛奶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L24",
            name: "珍珠牛奶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L25",
            name: "手工芋頭牛奶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L26",
            name: "抹茶紅豆牛奶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L27",
            name: "蜂蜜蝶豆花牛奶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L63",
            name: "黑糖牛奶",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L59",
            name: "朱古力",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L60",
            name: "雲呢拿朱古力",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L61",
            name: "玫瑰朱古力",
            setPrice: 9,
            variants: ["凍", "熱"],
        },
        {
            id: "L62",
            name: "薄荷朱古力",
            setPrice: 9,
            variants: ["凍", "熱"],
        }
    ];

    static public final MyRoomRoomSetDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            for (d in drinks)
            for (v in d.variants)
            '${d.id} ${d.name} (${v}) +$$${d.setPrice}'
        ],
    };

    static public final MyRoomRoomPastaRiceSet = {
        title: "套餐",
        properties: {
            main: {
                title: "主食",
                type: "string",
                "enum": [
                    "M1 蒜香雜菌意粉 $58",
                    "M2 忌廉煙肉意粉 $58",
                    "M3 煙鴨胸香草醬意粉 $58",
                    "M4 蒜蓉蜆肉意粉 $58",
                    // "M5 彩椒牛肉意粉 $58",
                    "M6 香辣海鮮意粉 $63",
                    // "M7 蕃茄洋蔥汁腸仔意粉 $58",
                    // "M7 蕃茄洋蔥汁腸仔飯 $58",
                    "M8 粟米吞拿魚意粉 $58",
                    "M8 粟米吞拿魚飯 $58",
                    // "M9 粟米肉粒意粉 $58",
                    // "M9 粟米肉粒飯 $58",
                ]
            },
            drink: MyRoomRoomSetDrink,
        },
        required: [
            "main",
            "drink",
        ]
    }

    static public final MyRoomRoomSnacks = {
        title: "小食",
        type: "string",
        "enum": [
            "S1 薯餅 (1塊) $12",
            "S2 薯角 $28",
            "S3 薯格 $28",
            "S4 吉列魚柳 $16",
            "S5 粟米墨魚餅 (3件) $24",
            "S6 炸燒賣 (5粒) $15",
            "S7 吉列蝦餅 (3件) $28",
            "S8 咖喱酥 (2件) $22",
            "S9 鹽酥雞粒 $24",
            "S10 麥樂雞 (4件) $18",
            "S11 迷你脆雞翼 (4件) $24",
            "S12 脆香雞肉條 (5件) $24",
            "S13 香脆雞肉圈 (5件) $24",
        ],
    };

    static public final MyRoomRoomCake = {
        title: "蛋糕",
        type: "string",
        "enum": [
            "美式芝士餅 $30",
            "Oreo朱古力芝士餅 $30",
            "香蕉芝士餅 $30",
            "黑芝麻芝士餅 $30",
            "巴斯克蛋糕 $30",
            "藍莓芝士凍餅 $30",
            "Oreo芝士凍餅 $30",
            "益力多慕斯凍餅 $30",
            "豆腐多多慕斯凍餅 $30",
        ],
    };

    static public function itemsSchema(order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: MyRoomRoomItem.all.map(item -> {
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
                switch (cast item.type:MyRoomRoomItem) {
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
        ?type:MyRoomRoomItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case PastaRiceSet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"]);
            case Snacks | Cake:
                switch (orderItem.item:Null<String>) {
                    case v if (Std.isOfType(v, String)):
                        {
                            orderDetails: v,
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
        var s = concatSummaries(formData.items.map(item -> summarizeItem(cast item)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}