package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;
using Lambda;

enum abstract KeiHingItem(String) to String {
    final NoodleAndRice;
    final ChickenLegSet;
    final FriedInstantNoodle;
    final CurrySet;
    final UsualSet;
    final SiuMeiSet;
    final Sandwich;
    final Snack;
    final Chicken;
    final SideDish;
    final Pot;
    final ChickenPot;
    final PotRice;

    final DishSet;
    // final FishSet;
    // final DishFishSet;
    final ChickenSet;
    // final FishChickenSet;

    static public function all(timeSlotType:TimeSlotType):ReadOnlyArray<KeiHingItem> return switch timeSlotType {
        case Lunch:
            [
                NoodleAndRice,
                ChickenLegSet,
                FriedInstantNoodle,
                CurrySet,
                UsualSet,
                SiuMeiSet,
                Sandwich,
                Snack,
                Chicken,
                SideDish,
                Pot,
                DishSet,
                // FishSet,
                // DishFishSet,
                ChickenSet,
                // FishChickenSet,
            ];
        case Dinner:
            [
                // PotRice,
                NoodleAndRice,
                ChickenLegSet,
                FriedInstantNoodle,
                CurrySet,
                UsualSet,
                Sandwich,
                Snack,
                Chicken,
                SideDish,
                Pot,
                ChickenPot,
                DishSet,
                // FishSet,
                // DishFishSet,
                ChickenSet,
                // FishChickenSet,
            ];
    };

    public function getDefinition():Dynamic return switch (cast this:KeiHingItem) {
        case NoodleAndRice: KeiHingMenu.KeiHingNoodleAndRice;
        case ChickenLegSet: KeiHingMenu.KeiHingChickenLegSet;
        case FriedInstantNoodle: KeiHingMenu.KeiHingFriedInstantNoodle;
        case CurrySet: KeiHingMenu.KeiHingCurrySet;
        case UsualSet: KeiHingMenu.KeiHingUsualSet;
        case SiuMeiSet: KeiHingMenu.KeiHingSiuMeiSet;
        case Sandwich: KeiHingMenu.KeiHingSandwich;
        case Snack: KeiHingMenu.KeiHingSnack;
        case Chicken: KeiHingMenu.KeiHingChicken;
        case SideDish: KeiHingMenu.KeiHingSideDish;
        case Pot: KeiHingMenu.KeiHingPot;
        case ChickenPot: KeiHingMenu.KeiHingChickenPot;
        case PotRice: KeiHingMenu.KeiHingPotRice;
        case DishSet: KeiHingMenu.KeiHingDishSet;
        // case FishSet: KeiHingMenu.KeiHingFishSet;
        // case DishFishSet: KeiHingMenu.KeiHingDishFishSet;
        case ChickenSet: KeiHingMenu.KeiHingChickenSet;
        // case FishChickenSet: KeiHingMenu.KeiHingFishChickenSet;
    }
}

class KeiHingMenu {
    static public final KeiHingDrink = {
        title: "跟餐飲品",
        description: "+$8 可配冷熱飲品",
        type: "string",
        "enum": [
            // TODO to be confirmed
            "熱奶茶 +$8",
            "熱咖啡 +$8",
            "熱檸茶 +$8",
            "熱檸水 +$8",
            "熱好立克 +$8",
            "熱阿華田 +$8",
            "熱檸樂 +$8",
            "熱檸蜜 +$8",
            "熱檸啡 +$8",
            "熱鮮奶 +$8",
            "可樂 +$8",
            "可樂Zero +$8",
            "凍奶茶 +$8",
            "凍咖啡 +$8",
            "凍檸茶 +$8",
            "凍檸水 +$8",
            "凍好立克 +$8",
            "凍阿華田 +$8",
            "凍檸樂 +$8",
            "凍檸蜜 +$8",
            "凍檸啡 +$8",
            "凍鮮奶 +$8",
        ],
    };
    static public final KeiHingFreeHotDrink = {
        title: "跟餐飲品",
        description: "奉送熱飲, 凍飲 +$2, 檸樂 檸蜜 檸啡 鮮奶 +$4, 特飲 +$9",
        type: "string",
        "enum": [
            // TODO to be confirmed
            "熱奶茶 +$0",
            "熱咖啡 +$0",
            "熱檸茶 +$0",
            "熱檸水 +$0",
            "熱好立克 +$0",
            "熱阿華田 +$0",
            "熱檸樂 +$4",
            "熱檸蜜 +$4",
            "熱檸啡 +$4",
            "熱鮮奶 +$4",
            "可樂 +$2",
            "可樂Zero +$2",
            "凍奶茶 +$2",
            "凍咖啡 +$2",
            "凍檸茶 +$2",
            "凍檸水 +$2",
            "凍好立克 +$2",
            "凍阿華田 +$2",
            "凍檸樂 +$4",
            "凍檸蜜 +$4",
            "凍檸啡 +$4",
            "凍鮮奶 +$4",
            "紅豆冰 +$9",
            "菠蘿冰 +$9",
        ],
    };
    static public final KeiHingRiceAndSoup = {
        type: "array",
        title: "選項",
        items: {
            type: "string",
            "enum": [
                "跟白飯及例湯 +$8",
            ],
        },
        uniqueItems: true,
    }

    static public final KeiHingChickenLegSet = {
        title: "雞髀套餐",
        description: "送：是日例湯",
        properties: {
            main: {
                title: "雞髀套餐",
                type: "string",
                "enum": [
                    "生炸巨型雞髀飯 $51",
                    "生炸巨型雞髀意粉 $51",
                ],
            },
            sauce: {
                title: "配汁",
                type: "string",
                "enum": [
                    "茄汁",
                    "白汁",
                    "黑椒汁",
                ],
            },
            drink: KeiHingDrink,
        },
        required: ["main", "sauce"],
    };

    static public final KeiHingNoodleAndRice = {
        title: "粉麵飯",
        properties: {
            main: {
                title: "粉麵飯",
                type: "string",
                "enum": [
                    // 推介
                    "梅菜扣肉飯 送:是日例湯 $51",
                    "無骨海南雞 配:雞油香飯 送:油菜+是日例湯 $55",

                    // 炒粉麵
                    "乾炒牛河 $49",
                    "乾炒三絲河 $49",
                    "乾炒黑椒牛肉意 $49",
                    "乾燒伊麵 $49",
                    "銀芽肉絲炒麵 $49",
                    "時菜牛肉炒河 $49",
                    "星州炒米 $49",
                    "星州炒貴刁 $49",
                    "豉椒排骨炒麵 $49",
                    "涼瓜肉片炒河 $49",
                    "羅漢齋炒麵 $49",
                    "雪菜肉絲炆米 $49",
                    "廈門炒米 $49",
                    "豉油皇炒麵 $49",
                    "沙爹牛肉炒河 $49",
                    "猪扒炒烏冬 $51",
                    "魚香茄子炆米 $51",
                    "雪菜火鴨絲炆米 $51",
                    "時菜魚柳炒河 $51",
                    "乾炒猪扒河 $51",
                    "味菜鮮魷炒河 $51",
                    "羅漢齋炆伊麵 $51",
                    "沙爹雞絲炒烏冬 $51",
                    "XO醬肉絲炆伊麵 $51",
                    "黑椒牛柳絲炒麵 $55",
                    "原汁牛腩炒河 $55",
                    "日式海鮮炒烏冬 $55",
                    "回鍋肉片炆烏冬 $55",

                    // 中式飯類
                    "火腿煎蛋飯 $44",
                    "餐肉煎蛋飯 $44",
                    "腸仔煎蛋飯 $44",
                    "叉燒煎蛋飯 $44",
                    "揚州炒飯 $46",
                    "西炒飯 $46",
                    "生炒牛肉飯 $46",
                    "咸魚雞粒炒飯 $46",
                    "鮮茄牛肉飯 $46",
                    "時菜肉片飯 $46",
                    "豉椒排骨飯 $46",
                    "豆腐魚柳飯 $46",
                    "粟米魚柳飯 $46",
                    "芙蓉煎蛋飯 $46",
                    "粟米肉粒飯 $46",
                    "羅漢齋飯 $46",
                    "滑蛋蝦仁飯 $46",
                    "魚香茄子飯 $46",
                    "菠蘿生炒骨 $49",
                    "豆腐火腩飯 $49",
                    "洋蔥猪扒飯 $49",
                    "西芹雞柳飯 $49",
                    "豉椒鮮魷飯 $49",
                    "京都猪扒飯 $49",
                    "泰式海鮮炒飯 $49",
                    "椒鹽豬扒飯 $49",
                    "福建炒飯 $49",
                    "原汁牛腩飯 $52",
                    "琦興什扒飯 $58",

                    // 粉麵類
                    "鮮蝦雲吞麵 $31",
                    "爽滑魚蛋麵 $31",
                    "手打牛丸麵 $31",
                    "台灣貢丸麵 $31",
                    "新鮮墨丸麵 $31",
                    "京都炸醬麵 $31",
                    "原汁牛腩麵 $33",
                    "淨牛腩 $73",
                    "郊外油菜 (菜心) $22",
                    "郊外油菜 (生菜) $22",
                    "郊外油菜 (白菜仔) $22",
                    // 1510 各式淨麵 $22
                ],
            },
            drink: KeiHingDrink,
        },
        required: ["main"],
    };
    static public final KeiHingFriedInstantNoodle = {
        title: "乾炒公仔麵",
        properties: {
            main: {
                title: "乾炒公仔麵",
                type: "string",
                "enum": [
                    "牛肉炒公仔麵 $49",
                    "雞絲炒公仔麵 $49",
                    "肉片炒公仔麵 $49",
                    "餐肉炒公仔麵 $49",
                    "火腿炒公仔麵 $49",
                    "腸仔炒公仔麵 $49",
                    "星洲炒公仔麵 $49",
                    "五香肉丁炒公仔麵 $51",
                    "海鮮炒公仔麵 $51",
                    "猪扒炒公仔麵 $51",
                    "雞扒炒公仔麵 $51",
                ],
            },
            options: {
                type: "array",
                title: "選項",
                items: {
                    type: "string",
                    "enum": [
                        "改出前一丁 +$5",
                        "改福字麵 +$5",
                    ],
                },
                maxItems: 1,
                uniqueItems: true,
            },
            drink: KeiHingDrink,
        },
        required: ["main"],
    };
    static public final KeiHingCurrySet = {
        title: "馬來咖哩",
        properties: {
            main: {
                title: "馬來咖哩",
                type: "string",
                "enum": [
                    "咖哩雜扒(猪扒+雞扒+腸仔+火腿+煎蛋) 飯 $58",
                    "咖哩雜扒(猪扒+雞扒+腸仔+火腿+煎蛋) 意粉 $58",
                    "咖哩牛三寶(牛扒,牛肉,牛脷) 飯 $68",
                    "咖哩牛三寶(牛扒,牛肉,牛脷) 意粉 $68",
                    "咖哩牛腩飯 $55",
                    "咖哩牛腩意粉 $55",
                    "咖哩牛扒飯 $55",
                    "咖哩牛扒意粉 $55",
                    "咖哩牛脷飯 $55",
                    "咖哩牛脷意粉 $55",
                    "咖哩猪扒飯 $51",
                    "咖哩猪扒意粉 $51",
                    "咖哩雞扒飯 $51",
                    "咖哩雞扒意粉 $51",
                    "咖哩魚柳飯 $51",
                    "咖哩魚柳意粉 $51",
                    "咖哩牛肉飯 $49",
                    "咖哩牛肉意粉 $49",
                    "咖哩肉片飯 $49",
                    "咖哩肉片意粉 $49",
                    "咖哩雜菜飯 $49",
                    "咖哩雜菜意粉 $49",
                ],
            },
            drink: KeiHingDrink,
        },
        required: ["main"],
    };
    static public final KeiHingUsualSet = {
        title: "常餐",
        description: "配：牛油方包＋火腿奄列＋熱飲",
        properties: {
            main: {
                title: "配料",
                type: "string",
                "enum": [
                    "沙爹牛肉 $37",
                    "雪菜肉絲 $37",
                    "炸菜肉絲 $37",
                    "香煎猪扒 $37",
                    "香煎雞扒 $37",
                    "炸雞中翼 $37",
                    "五香肉丁 $39",
                ],
            },
            noodle: {
                title: "麵類",
                type: "string",
                "enum": [
                    "公仔麵",
                    "米粉",
                    "通粉",
                    "意粉",
                    "米線",
                    "出前一丁 +$4",
                    "福字麵 +$4",
                ],
            },
            drink: KeiHingFreeHotDrink,
        },
        required: ["main", "noodle", "drink"],
    };
    static public final KeiHingSiuMeiSet = {
        title: "燒味飯餐",
        description: "六點前供應。配：飯＋是日例湯＋熱飲",
        properties: {
            options: {
                type: "array",
                title: "燒味",
                description: "$48 任揀兩款",
                items: {
                    type: "string",
                    "enum": [
                        "燒肉",
                        "燒鴨",
                        "叉燒",
                        "切雞",
                        "紅腸",
                        "咸蛋",
                    ],
                },
                uniqueItems: true,
                minItems: 2,
                maxItems: 2,
            },
            drink: KeiHingFreeHotDrink,
        },
        required: ["options", "drink"],
    };
    static public final KeiHingSnack = {
        title: "⼩食",
        type: "string",
        "enum": [
            "煉奶多士 $15",
            "牛油多士 $15",
            "果醬多士 $15",
            "花生醬多士 $15",
            "奶油豬 $17",
            "炸薯條 $22",
            "熱狗 $22",
            "沙爹牛肉包 $22",
            "西多士 $24",
            "雞扒包 $26",
            "豬扒包 $26",
            "炸雞中翼(3隻) $26",
        ],
    };
    static public final KeiHingSandwich = {
        title: "三文治",
        type: "string",
        "enum": [
            "咸牛肉三文治 $22", // duplicated id?
            "芝士三文治 $22",
            "雞蛋三文治 $22",
            "火腿三文治 $22",
            "餐肉三文治 $22",
            "茄蛋三文治 $24",
            "火腿蛋三文治 $24",
            "鮮茄芝士三文治 $24",
            "公司三文治 $38",
        ],
    };
    static public final KeiHingChicken = {
        title: "招牌雞",
        properties: {
            main: {
                title: "招牌雞",
                type: "string",
                "enum": [
                    "沙薑雞(半隻) $92",
                    "沙薑雞(一隻) $172",
                    "薑蔥霸王雞(半隻) $92",
                    "薑蔥霸王雞(一隻) $172",
                    "上湯菜膽雞(半隻) $92",
                    "上湯菜膽雞(一隻) $172",
                    "無骨海南雞(半隻) $92",
                    "無骨海南雞(一隻) $172",
                ],
            },
            options: KeiHingRiceAndSoup,
        },
        required: ["main"],
    };
    static public final KeiHingSideDish = {
        title: "小菜",
        properties: {
            main: {
                title: "小菜",
                type: "string",
                "enum": [
                    "清炒時蔬 $52",
                    "時菜炒肉片 $58",
                    "鮮茄牛肉煮蛋 $58",
                    "羅漢上素 $58",
                    "香煎芙蓉蛋 $58",
                    "京都豬扒 $60",
                    "菠蘿生炒骨 $60",
                    "越式炒雜菜 $58",
                    // "時菜炒魚鬆 $58",
                    "咕嚕雞球 $58",
                    "金銀蛋時菜 $58",
                    "西蘭花雞柳 $58",
                    "銀芽炒三絲 $58",
                    "椒鹽豆腐 $58",
                    "紅燒豆腐 $58",
                    "菜脯肉鬆煎蛋 $58",
                    "沙拉豬扒 $60",
                    "椒鹽豬扒 $60",
                    // "酥炸鯪魚球 $60",
                    "蔥爆牛肉 $60",
                    "北菇扒時蔬 $60",
                    "泰式豬扒 $60",
                    "泰式雞扒 $60",
                    "涼瓜炆排骨 $60",
                    "福建扒豆腐 $60",
                    "水煮牛肉 $60",
                    "西檸煎軟雞 $60",
                    "蒜香雞中翼 $60",
                    "中式牛柳 $65",
                    "西芹腰果肉丁 $65",
                    "蝦醬通菜鮮魷 $68",
                    "葡汁焗四蔬 $65",
                    "味菜牛柳絲 $65",
                    "豉椒鮮魷 $68",
                    "豆豉爆雞 $65",
                    "豆豉鯪魚油麥菜 $65",
                    "椒鹽鮮魷 $81",
                    // "黑椒牛仔骨 $78", // 年尾無入牛仔骨
                    "北菇鮑片扒豆豉 $72",
                    "蜜椒薯仔牛柳粒 $72",

                    // 時令小菜
                    "鹵水拼盤 (鹵水蛋,腩肉,豬大腸,雞翼,紅腸) $90",
                    // "鹵水雙拼 $70",
                    "潮式鹵水鴨(半隻) $90",
                    "味菜炒什會 $62",
                    // "鹹酸菜煮魚 $62",
                    "韭菜豬紅 $60",
                    // "豉椒味菜炒鵝腸 $62",
                    // "方魚肉碎蠔仔粥 $60",
                    "大豆芽菜炒豬腸 $62",
                    "鍋塌豆腐 $68",
                    "尖椒雞丁 $78",
                    // "松子鮮魚 $78",
                    "韭菜花炒鹹肉 $78",
                    "一品小炒王 $88",
                    "佛山燻蹄 $78",
                    "七味一字骨 $78",
                    "京都一字骨 $78",
                    "涼瓜炒田雞 $88",
                    "孜然三寸骨 $78",
                    "香辣土豆絲 $78",
                    "泰式蝦餅拼扎肉 $78",
                    "香茅豬扒拼扎肉 $78",
                    "紅燒乳鴿 $78",
                    "鹵水炸大腸 $78",
                    "豉椒炒蜆 $78",
                    "琦興海鮮泡飯 $88",
                    "水煮田雞 $88",
                ],
            },
            options: KeiHingRiceAndSoup,
        },
        required: ["main"],
    };
    static public final KeiHingPot = {
        title: "煲仔菜",
        properties: {
            main: {
                title: "煲仔菜",
                type: "string",
                "enum": [
                    "啫啫滑雞煲 $63",
                    "啫啫排骨煲 $63",
                    "南乳粗齋煲 $63",
                    "魚香茄子煲 $63",
                    "沙嗲牛肉粉絲煲 $63",
                    "咸魚雞粒豆腐煲 $63",
                    "海鮮雜菜煲 $63",
                    "咖哩牛腩煲 $71",
                    "豆腐火腩煲 $71",
                    // "薑蔥魚頭煲 $71",
                    // "薑蔥魚腩煲 $71",
                    "沙爹金菇肥牛煲 $71",
                    "雲吞雞煲 $71",
                    // "生菜豆腐鯪魚球煲 $71",
                    // "雜菇紫菜魚滑煲 $71",
                    "八珍豆腐煲 $71",
                    "薑蔥支竹牛肉煲 $71",
                    "涼瓜魚柳堡 $71",
                    "麻婆豆腐煲 $71",
                ],
            },
            options: KeiHingRiceAndSoup,
        },
        required: ["main"],
    };

    static public final KeiHingChickenPot = {
        title: "琦興雞煲",
        properties: {
            main: {
                title: "琦興雞煲",
                type: "string",
                "enum": [
                    "琦興雞煲 (半隻雞) $192",
                    "琦興雞煲 (一隻雞) $252",
                ],
            },
            rice: {
                title: "跟白飯",
                type: "string",
                "enum": [
                    "一個 $8",
                    "兩個 $16",
                    "三個 $24",
                    "四個 $32",
                ],
            }
        },
        required: ["main"],
    };

    static public final KeiHingPotRice = {
        title: "時令煲仔飯",
        description: "按煲 $10",
        properties: {
            main: {
                title: "時令煲仔飯",
                type: "string",
                "enum": [
                    "北菇滑雞 $63",
                    "薑蔥爆牛肉 $63",
                    "臘味飯 $63",
                    "油鴨肶飯 $63",
                    "臘腸排骨 $63",
                    "臘腸滑雞 $63",
                    // "豉汁魚腩 $63",
                    "蒜蓉鮮魷 $63",
                    "薑蔥豆豉鯪魚 $63",
                    
                    "啫啫排骨 $73",
                    "啫啫滑雞 $73",
                    "薑蔥田雞 $73",
                    "梅菜扣肉 $73",
                    
                    "琦興一品煲仔飯 (乾瑤柱 蠔豉 冬菇 臘腸 臘肉) $95",
                ],
            },
            veg: {
                title: "加配郊外油菜",
                type: "string",
                "enum": [
                    "菜心 +$10",
                    "生菜 +$10",
                    "白菜仔 +$10",
                ],
            },
            drink: KeiHingDrink,
        },
        required: ["main"],
    };

    static public final KeiHingDish = [
        "京都豬扒",
        "粟米炸魚柳",
        "紅燒豆腐",
        "菜心炒牛肉",
        "菠蘿生炒骨",
        "香煎芙蓉蛋",
        "涼瓜炒肉片",
        "麻婆豆腐",
        "蒜香雞中翼",
        "回鍋肉片",
        "羅漢上素",
        "通菜牛肉 (腐乳)",
        "通菜牛肉 (蝦醬)",
        "椒鹽豬扒",
        "豆豉炆雞",
        "咕嚕雞球",
        // "時菜炒魚鬆",
        "黃金焗豬扒",
        "魚香茄子",
        "蝦仁炒蛋",
        // "酥炸鯪魚球",
        "越式炒雜菜",
        "沙爹金菇牛肉",
        "節瓜蝦米粉絲",
        "洋蔥豬扒",
        "七味雞中翼",
        "菠蘿牛肉",
        "泰式雞扒",
        "咸魚雞粒豆腐",
        "銀芽炒三絲",
        "冬瓜炆排骨",
        "涼瓜肉碎煎蛋角",
        "士多啤梨骨",
        "西蘭花雞柳",
        "北菇扒時菜",
        "涼瓜炆鴨",
        "金銀蛋時菜",
    ];

    static public final KeiHingDishSet = {
        title: "小菜套餐",
        description: "配：例湯＋白飯＋熱飲",
        properties: {
            main: {
                title: "小菜",
                type: "string",
                "enum": KeiHingDish.map(item -> item + " $61"),
            },
            drink: KeiHingFreeHotDrink,
        },
        required: ["main", "drink"],
    };

    // static public final KeiHingFishSet = {
    //     title: "鮮魚套餐",
    //     description: "配：例湯+白飯+熱飲。 $71",
    //     properties: {
    //         style: {
    //             title: "製法",
    //             type: "string",
    //             "enum": [
    //                 "清蒸",
    //                 "古法",
    //                 "豉汁",
    //                 "薑葱",
    //                 "煎封",
    //                 "涼瓜炆 +$10",
    //             ],
    //         },
    //         fish: {}
    //         drink: KeiHingFreeHotDrink,
    //     },
    //     required: ["main"],
    // };

    static public final KeiHingChickenSet = {
        title: "雞鴨套餐",
        description: "配：小菜＋例湯＋白飯2碗＋熱飲",
        properties: {
            main: {
                title: "雞鴨",
                type: "string",
                "enum": [
                    "沙薑雞半隻 $166",
                    "薑葱霸王雞半隻 $166",
                    "上湯菜膽雞半隻 $166",
                    "鹵水鴨半隻 $166",
                    "乳鴿 $166",
                ],
            },
            dish: {
                title: "小菜",
                type: "string",
                "enum": KeiHingDish,
            },
            vege: {
                title: "送",
                type: "string",
                "enum": [
                    "蒜蓉炒時菜",
                    "芝士白汁焗西蘭花",
                ],
            },
            drink1: KeiHingFreeHotDrink,
            drink2: KeiHingFreeHotDrink,
        },
        required: ["main", "dish", "vege", "drink1", "drink2"],
    };

    static public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, order:FormOrderData):Dynamic {
        return if (pickupTimeSlot == null) {
            type: "array",
            items: {
                type: "object",
            }
        } else {
            var timeSlotType = TimeSlotType.classify(pickupTimeSlot.start);
            var itemDefs = [
                for (item in KeiHingItem.all(timeSlotType))
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
        ?type:KeiHingItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case Sandwich | Snack:
                switch (orderItem.item:Null<String>) {
                    case v if (Std.isOfType(v, String)):
                        {
                            orderDetails: fullWidthDot + v,
                            orderPrice: v.parsePrice().price,
                        };
                    case _:
                        {
                            orderDetails: "",
                            orderPrice: 0.0,
                        };
                }
            case NoodleAndRice:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], [], null, "");
            case CurrySet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], []);
            case ChickenLegSet:
                summarizeOrderObject(orderItem.item, def, ["main", "sauce", "drink"], ["送：是日例湯"]);
            case FriedInstantNoodle:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "drink"], [], null, "");
            case UsualSet:
                summarizeOrderObject(orderItem.item, def, ["main", "noodle", "drink"], ["配：牛油方包＋火腿奄列"]);
            case SiuMeiSet:
                summarizeOrderObject(orderItem.item, def, ["options", "drink"], ["配：是日例湯"], (fieldName, value) -> switch(fieldName) {
                    case "options": 
                        var options:Array<String> = value;
                        {
                            title: "",
                            value: options.join(", "),
                            price: 48,
                        }
                    case _:
                        {};
                });
            case Chicken | SideDish | Pot:
                summarizeOrderObject(orderItem.item, def, ["main", "options"], []);
            case ChickenPot:
                summarizeOrderObject(orderItem.item, def, ["main", "rice"], [], null, "");
            case PotRice:
                summarizeOrderObject(orderItem.item, def, ["main", "veg", "drink"], [KeiHingPotRice.description], null, "煲仔飯");
            case DishSet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], ["配：例湯＋白飯"]);
            case ChickenSet:
                summarizeOrderObject(orderItem.item, def, ["main", "dish", "vege", "drink1", "drink2"], ["配：例湯＋白飯2碗"]);
            case _:
                {
                    orderDetails: "",
                    orderPrice: 0,
                }
        }
    }

    static public function summarize(formData:FormOrderData):OrderSummary {
        var summaries = formData.items.map(item -> summarizeItem(cast item));
        var boxTotalPrice = formData.items.length * 2;
        summaries.push({
            orderDetails: "外賣 $2 × " + formData.items.length,
            orderPrice: boxTotalPrice,
        });
        var s = concatSummaries(summaries);
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}