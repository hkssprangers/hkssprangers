package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;
using Lambda;

enum abstract KeiHingItem(String) to String {
    final CartNoodles;
    final NoodleAndRice;
    final ChickenLegSet;
    final FriedInstantNoodle;
    final CurrySet;
    final UsualSet;
    final SiuMeiSet;
    final Sandwich;
    final Snack;
    final Chicken;
    final Pot;
    final PotRice;
    final DishSet;

    static public function all(timeSlotType:TimeSlotType):ReadOnlyArray<KeiHingItem> return switch timeSlotType {
        case Lunch:
            [
                CartNoodles,
                NoodleAndRice,
                ChickenLegSet,
                FriedInstantNoodle,
                CurrySet,
                UsualSet,
                SiuMeiSet,
                Sandwich,
                Snack,
                Chicken,
                Pot,
                DishSet,
            ];
        case Dinner:
            [
                // PotRice,
                NoodleAndRice,
                ChickenLegSet,
                FriedInstantNoodle,
                CurrySet,
                UsualSet,
                SiuMeiSet,
                Sandwich,
                Snack,
                Chicken,
                Pot,
                DishSet,
            ];
    };

    public function getDefinition():Dynamic return switch (cast this:KeiHingItem) {
        case CartNoodles: KeiHingMenu.KeiHingCartNoodles;
        case NoodleAndRice: KeiHingMenu.KeiHingNoodleAndRice;
        case ChickenLegSet: KeiHingMenu.KeiHingChickenLegSet;
        case FriedInstantNoodle: KeiHingMenu.KeiHingFriedInstantNoodle;
        case CurrySet: KeiHingMenu.KeiHingCurrySet;
        case UsualSet: KeiHingMenu.KeiHingUsualSet;
        case SiuMeiSet: KeiHingMenu.KeiHingSiuMeiSet;
        case Sandwich: KeiHingMenu.KeiHingSandwich;
        case Snack: KeiHingMenu.KeiHingSnack;
        case Chicken: KeiHingMenu.KeiHingChicken;
        case Pot: KeiHingMenu.KeiHingPot;
        case PotRice: KeiHingMenu.KeiHingPotRice;
        case DishSet: KeiHingMenu.KeiHingDishSet;
    }
}

class KeiHingMenu {
    static public final KeiHingEightDollarDrink = {
        title: "跟餐飲品",
        description: "+$8 可配冷熱飲品",
        type: "string",
        "enum": [
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
    static public final KeiHingAddDrink = {
        title: "跟餐飲品",
        description: "熱飲+$4, 凍飲+$8",
        type: "string",
        "enum": [
            "熱奶茶 +$4",
            "熱咖啡 +$4",
            "熱檸茶 +$4",
            "熱檸水 +$4",
            "熱好立克 +$4",
            "熱阿華田 +$4",
            "熱檸樂 +$4",
            "熱檸蜜 +$4",
            "熱檸啡 +$4",
            "熱鮮奶 +$4",
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
            "紅豆奶茶 +$12",
            "紅豆咖啡 +$12",
        ],
    };
    static public final KeiHingFreeHotDrink = {
        title: "跟餐飲品",
        description: "奉送熱飲, 凍飲 +$2, 檸樂 檸蜜 檸啡 鮮奶 +$4, 特飲 +$9",
        type: "string",
        "enum": [
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
            "紅豆奶茶 +$12",
            "紅豆咖啡 +$12",
        ],
    };
    static public final KeiHingFreeHotFourDollarColdDrink = {
        title: "跟餐飲品",
        description: "奉送熱飲, 凍飲 +$4",
        type: "string",
        "enum": [
            "熱奶茶 +$0",
            "熱咖啡 +$0",
            "熱檸茶 +$0",
            "熱檸水 +$0",
            "熱好立克 +$0",
            "熱阿華田 +$0",
            "凍奶茶 +$4",
            "凍咖啡 +$4",
            "凍檸茶 +$4",
            "凍檸水 +$4",
            "凍好立克 +$4",
            "凍阿華田 +$4",
        ],
    };
    static public final KeiHingOptions = {
        type: "array",
        title: "選項",
        items: {
            type: "string",
            "enum": [
                "老火靚湯 +$3",
            ],
        },
        uniqueItems: true,
    }

    static public final cartNoodlesPrice = [
        2 => 30,
        3 => 30 + 8,
        4 => 30 + 8 * 2,
        5 => 48,
    ];
    static public final cartNoodlesPriceDescription = '雙餸 $$${cartNoodlesPrice[2]}, 三餸 $$${cartNoodlesPrice[3]}, 四餸 $$${cartNoodlesPrice[4]}, 五餸 $$${cartNoodlesPrice[5]}';
    static public final KeiHingCartNoodles = {
        title: "車仔麵",
        description: cartNoodlesPriceDescription,
        properties: {
            options: {
                type: "array",
                title: "配料",
                items: {
                    type: "string",
                    "enum": [
                        "秘製豬頸肉",
                        "豬大腸",
                        "秘製豬扒",
                        "南乳豬手",
                        "豬皮",
                        "豬紅",
                        "腩片",
                        "肉片",

                        "咖哩魚蛋",
                        "炸魚皮",
                        "魚皮餃",
                        // "鯪魚球",
                        "沙爹魷魚",
                        // "魚肉",
                        "魚滑",
                        "魚片頭",

                        "秘製牛腩",
                        "肥牛片",
                        "秘製牛扒",
                        "五香牛筋",
                        "五香牛肚",
                        "牛仔骨",
                        "牛柏葉",
                        "鮮牛肉",
                        "沙爹牛肉",

                        "蠔油冬菇",
                        "鮮蝦雲吞",
                        "炸雲吞",
                        // "腐皮卷",
                        "仿鮑片",
                        "雪菜肉絲",
                        "榨菜肉絲",
                        "山根",

                        "香菇貢丸",
                        "墨魚丸",
                        "花枝丸",
                        "牛筋丸",
                        "獅子狗",
                        "午餐肉",
                        "火腿片",
                        "腸仔",
                        "芝士腸",
                        "蟹柳",

                        "金菇菜",
                        "娃娃菜",
                        "白菜仔",
                        "韭菜",
                        "紫菜",
                        "菜心",
                        "小棠菜",
                        "生菜",
                        "通菜",
                        "椰菜",
                        "油麥菜",
                        "旺菜",

                        "鹵水雞中翼",
                        "鹵水雞翼尖",
                        "秘製雞扒",
                        "鳳爪",
                        "煙鴨胸",

                        "豆卜",
                        "枝竹",
                        "響鈴卷",
                        "竹笙",
                        "蘿蔔",
                    ],
                },
                minItems: 2,
                maxItems: 5,
                uniqueItems: true,
            },
            noodle: {
                title: "麵底",
                type: "string",
                "enum": [
                    "油麵",
                    "幼麵",
                    "粗麵",
                    "河粉",
                    "米粉",
                    "瀨粉",
                    "烏冬",
                    "粉絲",
                    "米線",
                    "公仔麵",
                ],
            },
            extraOptions: {
                type: "array",
                title: "選項",
                items: {
                    type: "string",
                    "enum": [
                        "走蔥",
                        "多蔥",
                        "腩汁",
                        "芫茜",
                        "香辣咖哩",
                        "小辣",
                        "中辣",
                        "大辣",
                        "加底 +$5",
                        "加老火靚湯 +$3",
                    ],
                },
                uniqueItems: true,
            },
            drink: {
                title: "跟餐飲品",
                description: "熱飲+$4, 凍飲+$8",
                type: "string",
                "enum": [
                    "熱奶茶 +$4",
                    "熱咖啡 +$4",
                    "熱檸茶 +$4",
                    "熱檸水 +$4",
                    "熱好立克 +$4",
                    "熱阿華田 +$4",
                    "熱檸樂 +$4",
                    "熱檸蜜 +$4",
                    "熱檸啡 +$4",
                    "熱鮮奶 +$4",
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
                    "紅豆冰 +$9",
                    "菠蘿冰 +$9",
                ],
            },
        },
        required: ["options", "noodle"],
    }

    static public final KeiHingChickenLegSet = {
        title: "雞髀套餐",
        properties: {
            main: {
                title: "雞髀套餐",
                type: "string",
                "enum": [
                    "生炸巨型雞髀飯 $50",
                    "生炸巨型雞髀意粉 $50",
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
            drink: KeiHingAddDrink,
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
                    "梅菜扣肉飯 $50",
                    "無骨海南雞 配:雞油香飯 送:油菜 $57",

                    // 炒粉麵
                    "乾炒牛河 $50",
                    "乾炒三絲河 $50",
                    "乾炒黑椒牛肉意 $50",
                    "乾燒伊麵 $50",
                    "銀芽肉絲炒麵 $50",
                    "時菜牛肉炒河 $50",
                    "星州炒米 $50",
                    "星州炒貴刁 $50",
                    "豉椒排骨炒麵 $50",
                    "涼瓜肉片炒河 $50",
                    "羅漢齋炒麵 $50",
                    "雪菜肉絲炆米 $50",
                    "廈門炒米 $50",
                    "豉油皇炒麵 $50",
                    "沙爹牛肉炒河 $50",
                    "猪扒炒烏冬 $50",
                    "魚香茄子炆米 $50",
                    "雪菜火鴨絲炆米 $50",
                    "時菜魚柳炒河 $50",
                    "乾炒猪扒河 $50",
                    "味菜鮮魷炒河 $50",
                    "羅漢齋炆伊麵 $50",
                    "沙爹雞絲炒烏冬 $50",
                    "XO醬肉絲炆伊麵 $50",
                    "黑椒牛柳絲炒麵 $50",
                    "原汁牛腩炒河 $50",
                    "日式海鮮炒烏冬 $50",
                    "回鍋肉片炆烏冬 $50",

                    // 中式飯類
                    "火腿煎蛋飯 $50",
                    "餐肉煎蛋飯 $50",
                    "腸仔煎蛋飯 $50",
                    "叉燒煎蛋飯 $50",
                    "揚州炒飯 $50",
                    "西炒飯 $50",
                    "生炒牛肉飯 $50",
                    "咸魚雞粒炒飯 $50",
                    "鮮茄牛肉飯 $50",
                    "時菜肉片飯 $50",
                    "豉椒排骨飯 $50",
                    "豆腐魚柳飯 $50",
                    "粟米魚柳飯 $50",
                    "芙蓉煎蛋飯 $50",
                    "粟米肉粒飯 $50",
                    "羅漢齋飯 $50",
                    "滑蛋蝦仁飯 $50",
                    "魚香茄子飯 $50",
                    "菠蘿生炒骨 $50",
                    "豆腐火腩飯 $50",
                    "洋蔥猪扒飯 $50",
                    "西芹雞柳飯 $50",
                    "豉椒鮮魷飯 $50",
                    "京都猪扒飯 $50",
                    "泰式海鮮炒飯 $50",
                    "椒鹽豬扒飯 $50",
                    "福建炒飯 $50",
                    "原汁牛腩飯 $50",
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
            drink: KeiHingAddDrink,
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
                    "牛肉炒公仔麵 $50",
                    "雞絲炒公仔麵 $50",
                    "肉片炒公仔麵 $50",
                    "餐肉炒公仔麵 $50",
                    "火腿炒公仔麵 $50",
                    "腸仔炒公仔麵 $50",
                    "星洲炒公仔麵 $50",
                    "五香肉丁炒公仔麵 $50",
                    "海鮮炒公仔麵 $50",
                    "猪扒炒公仔麵 $50",
                    "雞扒炒公仔麵 $50",
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
            drink: KeiHingAddDrink,
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
                    "咖哩雞中翼 飯 $50",
                    "咖哩雞中翼 意粉 $50",
                    "咖哩牛腩飯 $50",
                    "咖哩牛腩意粉 $50",
                    "咖哩雞扒飯 $50",
                    "咖哩雞扒意粉 $50",
                    "咖哩牛扒飯 $50",
                    "咖哩牛扒意粉 $50",
                    "咖哩排骨飯 $50",
                    "咖哩排骨意粉 $50",
                    "咖哩牛肉飯 $50",
                    "咖哩牛肉意粉 $50",
                    "咖哩猪扒飯 $50",
                    "咖哩猪扒意粉 $50",
                    "咖哩魚柳飯 $50",
                    "咖哩魚柳意粉 $50",
                    "咖哩肉片飯 $50",
                    "咖哩肉片意粉 $50",
                    "咖哩雜菜飯 $50",
                    "咖哩雜菜意粉 $50",
                ],
            },
            drink: KeiHingAddDrink,
        },
        required: ["main"],
    };
    static public final KeiHingUsualSet = {
        title: "常餐",
        description: "配：牛油方包＋火腿奄列",
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
    static public final siuMeis = [
        "切雞",
        "薑蔥霸王雞",
        "上湯菜膽雞",
        "無骨海南雞",
        "貴妃雞",
        "鹵水鴨",
        "燒鴨",
        "叉燒",
        "燒肉",
        "紅腸",
        "咸蛋",
    ];
    static public final siuMeiSinglePrice = 65;
    static public final siuMeiDoubleAddCharge = 10;
    static public final KeiHingSiuMeiSet = {
        title: "燒味例牌",
        description: "送：白飯＋老火靚湯",
        properties: {
            siuMei1: {
                type: "string",
                title: "燒味例牌",
                "enum": siuMeis.map(v -> v + " $" + siuMeiSinglePrice),
            },
            siuMei2: {
                type: "string",
                title: "併",
                "enum": siuMeis.map(v -> v + " +$" + siuMeiDoubleAddCharge),
            },
            drink: KeiHingFreeHotFourDollarColdDrink,
        },
        required: ["siuMei1", "drink"],
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
        title: "雞鴨",
        properties: {
            main: {
                title: "雞鴨",
                type: "string",
                "enum": [
                    "沙薑雞(半隻) $95",
                    "沙薑雞(一隻) $180",
                    "薑蔥霸王雞(半隻) $95",
                    "薑蔥霸王雞(一隻) $180",
                    "上湯菜膽雞(半隻) $95",
                    "上湯菜膽雞(一隻) $180",
                    "無骨海南雞(半隻) $95",
                    "無骨海南雞(一隻) $180",
                    "鹵水鴨(半隻) $95",
                    "鹵水鴨(一隻) $180",
                ],
            },
        },
        required: ["main"],
    };
    static public final KeiHingPot = {
        title: "煲仔菜",
        description: "送：白飯＋老火靚湯",
        properties: {
            main: {
                title: "煲仔菜",
                type: "string",
                "enum": [
                    "豆腐火腩煲 $65",
                    "啫啫排骨煲 $65",
                    "啫啫滑雞煲 $65",
                    "雲吞雞煲 $65",
                    "三杯雞煲 $65",
                    "魚香茄子煲 $65",
                    "咸魚雞粒豆腐煲 $65",
                    "涼瓜魚柳煲 $65",
                    // "薑蔥魚腩煲 $65",
                    // "雜菇紫菜魚滑煲 $65",
                    // "生菜豆腐鯪魚球煲 $65",
                    "咖哩牛腩煲 $65",
                    "薑蔥支竹牛肉煲 $65",
                    "沙嗲牛肉粉絲煲 $65",
                    "沙爹金菇肥牛煲 $65",
                    "大馬站煲 $65",
                    "海鮮雜菜煲 $65",
                    "八珍豆腐煲 $65",
                    "麻婆豆腐煲 $65",
                    "南乳粗齋煲 $65",
                ],
            },
            drink: KeiHingFreeHotFourDollarColdDrink,
        },
        required: ["main", "drink"],
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
            drink: KeiHingEightDollarDrink,
        },
        required: ["main"],
    };
    
    static final dishes = [
        /* 鑊氣小炒 */

        "京都豬扒",
        "沙拉豬扒",
        "椒鹽豬扒",
        "泰式豬扒",
        "洋蔥豬扒",
        "黃金焗豬扒",
        "涼瓜炆肉",
        "時菜炒肉",
        "菠蘿生炒骨",
        "冬瓜炆排骨",
        "回鍋肉片",
        "士多啤梨骨",
        "涼瓜肉碎煎蛋角",
        "咕嚕雞球",
        "泰式雞扒",
        "西檸煎軟雞", 
        "蒜香雞中翼",
        "西蘭花雞柳",
        "豆豉爆雞",
        "豆豉炆雞",
        "七味雞中翼",
        "涼瓜炆鴨",
        "魚香茄子",
        "粟米炸魚柳",
        // "酥炸鯪魚球",
        "豆豉鯪魚油麥菜",
        "蝦仁炒蛋",
        "鮮茄牛肉煮蛋",
        "菠蘿牛肉",
        "蔥爆牛肉",
        "味菜牛柳絲",
        "水煮牛肉",
        "時菜炒牛肉",
        "蜜椒薯仔牛柳粒",
        "通菜牛肉 (腐乳)",
        "通菜牛肉 (蝦醬)",
        "清炒時蔬",
        "羅漢上素",
        "香煎芙蓉蛋",
        "越式炒雜菜",
        // "時菜炒魚鬆",
        "蒜蓉炒時菜",
        "金銀蛋時菜",
        "銀芽炒三絲",
        "麻婆豆腐",
        "椒鹽豆腐",
        "紅燒豆腐",
        "菜脯肉鬆煎蛋",
        "北菇扒時蔬",
        "褔建炒豆腐",
        "西芹腰果肉丁",
        "蝦醬通菜鮮魷",
        "葡汁焗四蔬",
        "北菇鮑片扒豆豉",
        "節瓜蝦米粉絲",
        "芝士白汁焗西蘭花",

        /* 時令小菜 */

        "一品小炒王",
        "尖子雞丁",
        // "豉椒味菜炒鵝腸",
        // "方魚肉碎蠔仔粥",
        "韭菜花炒鹹肉",
        "韭菜豬紅",
        "佛山燻蹄",
        "大豆芽菜炒豬腸",
        "味菜炒什會",

        /* 蒸餸 */

        "鹹蛋蒸肉餅",
        "鹹魚蒸肉餅",
        "梅菜蒸肉餅",
        "土魷蒸肉餅",
        "豉汁蒸排骨",
        "北菇蒸滑雞",
        "南乳蒸雞翼",
        "咸魚蒸腩片",
        "蝦醬蒸腩片",
        "麵醬蒸腩片",
        "南乳蒸腩片",
        "XO醬蒸腩片",
        "三色蒸水蛋",
        "瑤柱蝦仁豆腐蒸水蛋",
        "金銀蒜粉絲蒸茄子",
        "蒜蓉粉絲蒸鮮魷",

    ];

    static final specialDishes = [
        /* 特色小菜 */
        "豉椒鮮魷",
        "椒鹽鮮魷",
        "蝦醬通菜鮮魷",
        "黑椒牛仔骨",
        "沙嗲金菇肥牛",
        "中式牛柳",
    ];

    static public final KeiHingDishSet = {
        title: "小菜套餐",
        description: "送：白飯＋老火靚湯",
        properties: {
            main: {
                title: "小菜套餐",
                type: "string",
                "enum": []
                    .concat(dishes.map(item -> item + " $65"))
                    .concat(specialDishes.map(item -> item + " $68"))
                ,
            },
            drink: KeiHingFreeHotFourDollarColdDrink,
        },
        required: ["main", "drink"],
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
            case CartNoodles:
                summarizeOrderObject(orderItem.item, def, ["options", "noodle", "extraOptions", "drink"], [], (fieldName, value) -> switch fieldName {
                    case "options":
                        final price = switch cartNoodlesPrice[(value != null ? value.length : 0)] {
                            case null:
                                0;
                            case v:
                                v;
                        };
                        {
                            // value: value != null ? value.join(",") : "",
                            price: price,
                        }
                    case _: 
                        {
                            price: null,
                        };
                });
            case NoodleAndRice:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], [], null, "");
            case CurrySet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], []);
            case ChickenLegSet:
                summarizeOrderObject(orderItem.item, def, ["main", "sauce", "drink"], []);
            case FriedInstantNoodle:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "drink"], [], null, "");
            case UsualSet:
                summarizeOrderObject(orderItem.item, def, ["main", "noodle", "drink"], [KeiHingUsualSet.description]);
            case SiuMeiSet:
                summarizeOrderObject(orderItem.item, def, ["siuMei1", "siuMei2", "drink"], [KeiHingSiuMeiSet.description]);
            case Chicken:
                summarizeOrderObject(orderItem.item, def, ["main"], []);
            case Pot:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], [KeiHingPot.description]);
            case PotRice:
                summarizeOrderObject(orderItem.item, def, ["main", "veg", "drink"], [KeiHingPotRice.description], null, "煲仔飯");
            case DishSet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], [KeiHingDishSet.description]);
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