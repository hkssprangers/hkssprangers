package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotTools;
using Reflect;
using Lambda;

enum abstract KeiHingItem(String) to String {
    final DailySpecialLunch;
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
    final ChickenSet;
    final Pot;
    final PotRice;
    final DishSet;
    final BakedRice;
    final Risotto;

    static public function all(timeSlotType:TimeSlotType):ReadOnlyArray<KeiHingItem> return switch timeSlotType {
        case Lunch:
            [
                DailySpecialLunch,
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
                ChickenSet,
                Pot,
                DishSet,
                BakedRice,
                Risotto,
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
                ChickenSet,
                Pot,
                DishSet,
                BakedRice,
                Risotto,
            ];
    };

    public function getDefinition(timeSlot:TimeSlot):Dynamic return switch (cast this:KeiHingItem) {
        case DailySpecialLunch: KeiHingMenu.KeiHingDailySpecialLunch(Weekday.fromDay(timeSlot.start.toDate().getDay()));
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
        case ChickenSet: KeiHingMenu.KeiHingChickenSet;
        case Pot: KeiHingMenu.KeiHingPot;
        case PotRice: KeiHingMenu.KeiHingPotRice;
        case DishSet: KeiHingMenu.KeiHingDishSet;
        case BakedRice: KeiHingMenu.KeiHingBakedRice;
        case Risotto: KeiHingMenu.KeiHingRisotto;
    }
}

class KeiHingMenu {
    static final noNeed = "唔要";
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
        description: "熱飲+$4, 凍飲+$8, 特飲+$9",
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
    };
    static public final KeiHingFreeHotDrink = {
        title: "跟餐飲品",
        description: "奉送熱飲, 凍飲 +$2, 檸樂 檸蜜 檸啡 鮮奶 +$4, 特飲 +$9",
        type: "string",
        "enum": [
            noNeed,
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
    static public final KeiHingFreeHotFourDollarColdDrink = {
        title: "跟餐飲品",
        description: "奉送熱飲, 凍飲 +$4",
        type: "string",
        "enum": [
            noNeed,
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

    static public function KeiHingFreeSoupOptions(num:Int = 1) {
        final opts = switch (num) {
            case 1: ["唔要", "老火靚湯"];
            case n: ["唔要", "老火靚湯×" + n];
        }
        return {
            type: "string",
            title: "湯",
            "enum": opts,
            "default": opts[1],
        }
    }
    
    static final dishes = [
        /* 鑊氣小炒 */

        "京都豬扒",
        "沙拉豬扒",
        "椒鹽豬扒",
        "泰式豬扒",
        "洋蔥豬扒",
        "柚子豬扒",
        "黃金焗豬扒",
        "涼瓜炆肉片",
        "時菜炒肉片",
        "菠蘿生炒骨",
        "冬瓜炆排骨",
        "回鍋肉片",
        "士多啤梨骨",
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
        "酥炸鯪魚球",
        "節瓜蝦米粉絲",
        "葡汁焗四蔬",

        "鮮茄牛肉煮蛋",
        "菠蘿牛肉",
        "蔥爆牛肉",
        "泡椒牛肉",
        "水煮牛肉",
        "通菜牛肉 (腐乳)",
        "通菜牛肉 (蝦醬)",
        "時菜炒牛肉",
        "蝦仁炒蛋",
        "蒜蓉炒時菜",
        "清炒時蔬",
        "羅漢上素",
        "香煎芙蓉蛋",
        "越式炒雜菜",
        "時菜炒魚鬆",
        "金銀蛋時菜",
        "銀芽炒三絲",
        "麻婆豆腐",
        "椒鹽豆腐",
        "紅燒豆腐",
        "菜脯肉鬆煎蛋",
        "北菇扒時蔬",
        "福建扒豆腐",
        "西芹腰果肉丁",
        "蝦醬通菜豬頸肉",
        "涼瓜肉碎煎蛋角",
        "北菇鮑片扒豆腐",
        "豆豉鯪魚油麥菜",
        "芝士白汁焗西蘭花",

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

        /* 美味湯羹 */

        "西湖牛肉羹",
        "粟米雞蓉羹",
        "韭黃雞絲瑤柱羹",
        "豆腐蛋花蕃茄肉碎羹",
    ];

    static final specialDishes = [
        /* 廚師精選 */
        "一品小炒王",
        "柚子蜜味雞",
        "辣子雞丁",
        "熗炒萵筍絲",
        "台式三杯雞",
        "大豆芽菜炒豬腸",
        "韭菜豬紅",
        "薑蔥炒豬雜",
        "尖椒豚肉",
        "味菜炒雜燴",
        "黑椒牛仔骨",
        "XO窩筍炒肥牛",
        "味菜牛柳絲",
        "沙嗲金菇肥牛",
        "中式牛柳",
        "蝦醬通菜鮮魷",
        "椒鹽鮮魷",
        "韭菜花炒鮮魷",
        "豉椒鮮魷",
        "醉鮑魚",
        "京蔥牛肉",
        "京蔥雞柳",
        "京蔥豬頸肉",
        "蜜椒薯仔牛柳粒",
        "燒汁薯仔牛柳粒",
        "椒鹽蝦",
        "茄汁蝦",
        "白灼蝦",
        "豆干菜脯炒肉丁(辣)",
        "豆干菜脯炒肉丁(走辣)",
    ];
    static final pots = [
        "豆腐火腩煲",
        "支竹火腩煲",
        "啫啫滑雞煲",
        "雲吞雞煲",
        "三杯雞煲",
        "魚香茄子煲",
        "啫啫排骨煲",
        "涼瓜鯇魚煲",
        "薑蔥鯇魚煲",
        "咖哩牛腩煲",
        "涼瓜魚柳煲",
        "薑蔥魚柳煲",
        "大馬站煲",
        "八珍豆腐煲",
        "海鮮雜菜煲",
        "羅漢齋煲",
        "麻婆豆腐煲",
        "南乳粗齋煲",
        "咸魚雞粒豆腐煲",
        "薑蔥支竹牛肉煲",
        "沙嗲牛肉粉絲煲",
        "沙爹金菇肥牛煲",
    ];

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
    static public final cartNoodlesPriceDescription = '雙餸 $$${cartNoodlesPrice[2]}, 三餸 $$${cartNoodlesPrice[3]}, 四餸 $$${cartNoodlesPrice[4]}, 益街坊大胃王五寶麵 $$${cartNoodlesPrice[5]}';
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
                        "鹵水雞中翼",
                        "秘製雞柳",
                        "秘製雞扒",

                        "秘製牛腩",
                        "肥牛片",
                        "秘製牛扒",
                        "五香牛筋",
                        "五香牛肚",
                        "沙爹牛肉",
                        "牛柏葉",
                        "鮮牛肉",
                        "牛丸",
                        "香菇貢丸",
                        "墨魚丸",

                        "蠔油冬菇",
                        "鮮蝦雲吞",
                        "炸醬",
                        "仿鮑片",
                        "雪菜肉絲",
                        "榨菜肉絲",
                        "豆卜",
                        "蟹柳",
                        "響鈴卷",
                        "炸豆腐",
                        "午餐肉",

                        "魚蛋",
                        "炸魚皮",
                        "魚皮餃",
                        "沙爹魷魚",
                        "魚片頭",
                        "煙肉",
                        "煙鴨胸",
                        "枝竹",
                        "紅腸",
                        "腸仔",
                        "蘿蔔",

                        "金菇菜",
                        "油麥菜",
                        "娃娃菜",
                        "白菜仔",
                        "小棠菜",
                        "通菜",
                        "韭菜",
                        "菜心",
                        "椰菜",
                        "紫菜",
                        "生菜",
                        "旺菜",
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
                        "腩汁",
                        "沙爹汁",
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

                    // "可樂",
                    // "雪碧",
                    // "忌廉",
                    "熱齋啡 +$4",
                    "熱菜蜜 +$4",
                    "熱好立克 +$4",
                    "熱阿華田 +$4",
                    "熱朱古力 +$4",
                    "熱杏仁霜 +$4",
                    "熱柚子蜜 +$4",

                    "熱檸樂 +$4",
                    "熱檸蜜 +$4",
                    "熱檸啡 +$4",
                    "熱鮮奶 +$4",


                    "可樂 +$8",
                    "雪碧 +$8",
                    "忌廉 +$8",

                    "凍齋啡 +$8",
                    "凍菜蜜 +$8",
                    "凍好立克 +$8",
                    "凍阿華田 +$8",
                    "凍朱古力 +$8",
                    "凍杏仁霜 +$8",
                    "凍柚子蜜 +$8",

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
            freeSoup: KeiHingFreeSoupOptions(),
        },
        required: ["main", "sauce", "freeSoup"],
    };

    static public function KeiHingDailySpecialLunch(weekday:Weekday) {
        final items = switch (weekday) {
            case Monday:
                [
                    "茄汁雞翼腸仔飯 $47",
                    "黑椒茄子雞扒飯 $47",
                    "滑蛋牛肉飯 $47",
                    "涼瓜排骨飯 $47",
                    "鹹蛋豉油雞飯 $47",
                    "欖菜肉碎炒飯 $47",
                    "乾炒叉燒烏冬 $47",
                    "梅菜扣肉飯 $47",
                ];
            case Tuesday:
                [
                    "洋蔥豬扒火腿飯 $47",
                    "柱侯牛腩飯 $47",
                    "叉燒炒蛋飯 $47",
                    "豆腐火腩飯 $47",
                    "蝦醬通菜牛肉飯 $47",
                    "揚州炒飯 $47",
                    "星洲炒米 $47",
                    "鹹蛋蒸肉餅 $47",
                ];
            case Wednesday:
                [
                    "茄汁斑腩飯 $47",
                    "豉椒排骨飯 $47",
                    "芙蓉蛋飯 $47",
                    "羅漢齋飯 $47",
                    "鹹蛋燒鴨飯 $47",
                    "鹹魚雞粒炒飯 $47",
                    "乾炒肉片河 $47",
                    "豉汁蒸排骨 $47",
                ];
            case Thursday:
                [
                    "黑汁薄牛扒飯 $47",
                    "咕嚕雞飯 $47",
                    "蔥花餐肉炒蛋飯 $47",
                    "紅燒豆腐飯 $47",
                    "粟米肉粒飯 $47",
                    "XO叉燒粒炒飯 $47",
                    "乾炒三絲瀨 $47",
                    "香菇蝦米蒸肉餅 $47",
                ];
            case Friday:
                [
                    "咖哩汁豬扒腸仔飯 $47",
                    "柱侯牛腩飯 $47",
                    "鮮茄炒蛋飯 $47",
                    "魚香茄子飯 $47",
                    "鹹蛋燒肉飯 $47",
                    "西式炒飯 $47",
                    "回鍋腩肉炆烏冬 $47",
                    "梅菜扣肉飯 $47",
                ];
            case Saturday:
                [
                    "粟米斑腩飯 $47",
                    "麻婆豆腐飯 $47",
                    "涼瓜煎蛋飯 $47",
                    "京都豬扒飯 $47",
                    "蔥油叉燒飯 $47",
                    "蝦醬雞絲炒飯 $47",
                    "銀芽肉絲炒河 $47",
                    "榨菜蒸肉餅 $47",
                ];
            case Sunday:
                [
                    "煎蛋黑椒雞扒飯 $47",
                    "柱侯牛腩飯 $47",
                    "菜脯煎蛋飯 $47",
                    "老乾媽西芹雞柳飯 $47",
                    "鹹蛋貴妃雞飯 $47",
                    "家鄉炒飯 $47",
                    "乾炒叉燒意粉 $47",
                    "咸魚蒸肉餅 $47",
                ];
        }
        final title = "精選午餐（星期" + weekday.info().name + "）";
        return {
            title: title,
            properties: {
                main: {
                    title: title,
                    type: "string",
                    "enum": items,
                },
                drink: KeiHingFreeHotDrink,
                freeSoup: KeiHingFreeSoupOptions(),
            },
            required: ["main", "drink", "freeSoup"],
        };
    }

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
            freeSoup: KeiHingFreeSoupOptions(),
        },
        required: ["main", "freeSoup"],
    };
    static public final KeiHingBakedRice = {
        title: "輕型西式焗飯/意粉",
        properties: {
            main: {
                title: "輕型西式焗飯/意粉",
                type: "string",
                "enum": [
                    "香草芝士火腿焗飯 $50",
                    "香草芝士火腿焗意粉 $50",
                    "夏威夷菠蘿焗豬扒飯 $50",
                    "夏威夷菠蘿焗豬扒意粉 $50",
                    "匈牙利汁焗雞扒飯 $50",
                    "匈牙利汁焗雞扒意粉 $50",
                    "芝士白汁焗雞皇飯 $50",
                    "芝士白汁焗雞皇意粉 $50",
                    "意式肉醬焗飯 $50",
                    "意式肉醬焗意粉 $50",
                    "芝士焗牛扒飯 $50",
                    "芝士焗牛扒意粉 $50",
                    "龍脷柳忌廉蘑菇芝士焗飯 $50",
                    "龍脷柳忌廉蘑菇芝士焗意粉 $50",
                    "卡邦尼白汁海鮮焗飯 $50",
                    "卡邦尼白汁海鮮焗意粉 $50",
                ],
            },
            drink: KeiHingAddDrink,
            freeSoup: KeiHingFreeSoupOptions(),
        },
        required: ["main", "freeSoup"],
    };
    static public final KeiHingRisotto = {
        title: "西廚燴飯/意粉",
        properties: {
            main: {
                title: "西廚燴飯/意粉",
                type: "string",
                "enum": [
                    "香煎猪扒 $50",
                    "香煎雞扒 $50",
                    "吉列魚柳 $50",
                    "西冷薄牛扒 $50",
                    "脆香雞中翼 $50",
                ],
            },
            sub: {
                title: "拼",
                type: "string",
                "enum": [
                    "煎蛋",
                    "腸仔",
                    "火腿",
                    "餐肉",
                ],
            },
            sauce: {
                title: "配汁",
                type: "string",
                "enum": [
                    "茄汁",
                    "白汁",
                    "黑椒汁",
                    "蒜蓉汁",
                    "葡汁",
                ],
            },
            carbo: {
                title: "飯/意粉",
                type: "string",
                "enum": [
                    "飯",
                    "意粉",
                ],
            },
            drink: KeiHingAddDrink,
            freeSoup: KeiHingFreeSoupOptions(),
        },
        required: ["main", "sub", "sauce", "carbo", "freeSoup"],
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
            freeSoup: KeiHingFreeSoupOptions(),
        },
        required: ["main", "freeSoup"],
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
            freeSoup: KeiHingFreeSoupOptions(),
        },
        required: ["main", "freeSoup"],
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
        "燒肉",
        "燒鴨",
        "叉燒",
        "貴妃雞",
        "紅腸",
        "咸蛋",
    ];
    static public final siuMeiPrice = 47;
    static public final KeiHingSiuMeiSet = {
        title: "燒味雙併飯餐",
        description: "送：白飯",
        properties: {
            siuMei1: {
                type: "string",
                title: "1",
                "enum": siuMeis.map(v -> v + " $" + siuMeiPrice),
            },
            siuMei2: {
                type: "string",
                title: "2",
                "enum": siuMeis,
            },
            drink: KeiHingFreeHotDrink,
            freeSoup: KeiHingFreeSoupOptions(),
        },
        required: ["siuMei1", "siuMei2", "drink", "freeSoup"],
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
            "蔥粒煙肉吞拿魚薄餅 $42",
            "煙三文魚薄餅手卷 $45",
            "吞拿魚餅手卷 $45",
            "蒜蓉多士 $17",
            "蒜蓉包 $17",
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
        description: "送：白飯",
        properties: {
            main: {
                title: "煲仔菜",
                type: "string",
                "enum": pots.map(v -> v + " $70"),
            },
            drink: KeiHingFreeHotFourDollarColdDrink,
            freeSoup: KeiHingFreeSoupOptions(),
        },
        required: ["main", "drink", "freeSoup"],
    };

    static public final KeiHingChickenSet = {
        title: "雞鴨小菜套餐",
        description: "送：白飯×2",
        properties: {
            main: {
                title: "雞鴨",
                type: "string",
                "enum": [
                    "沙薑雞 $168",
                    "薑蔥霸王雞 $168",
                    "上海菜膽雞 $168",
                    "鹵水鴨 $168",
                ],
            },
            dish: {
                title: "小菜",
                type: "string",
                "enum": []
                    .concat(dishes)
                    .concat(specialDishes)
                    .concat(pots)
            },
            veg: {
                title: "送",
                type: "string",
                "enum": [
                    "蒜蓉炒時菜",
                    "腐乳生菜",
                    "腐乳通菜",
                ],
            },
            drink1: KeiHingFreeHotDrink,
            drink2: KeiHingFreeHotDrink,
            freeSoup: KeiHingFreeSoupOptions(2),
        },
        required: ["main", "dish", "veg", "drink1", "drink2", "freeSoup"],
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

    static public final KeiHingDishSet = {
        title: "小菜套餐",
        description: "送：白飯",
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
            freeSoup: KeiHingFreeSoupOptions(),
        },
        required: ["main", "drink", "freeSoup"],
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
                item => item.getDefinition(pickupTimeSlot)
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

    static function summarizeItem(
        pickupTimeSlot:Null<TimeSlot>,
        orderItem:{
            ?type:KeiHingItem,
            ?item:Dynamic,
        }
    ):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition(pickupTimeSlot);
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
                summarizeOrderObject(orderItem.item, def, ["main", "drink", "freeSoup"], [], null, "");
            case CurrySet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink", "freeSoup"], []);
            case ChickenLegSet:
                summarizeOrderObject(orderItem.item, def, ["main", "sauce", "drink", "freeSoup"], []);
            case FriedInstantNoodle:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "drink", "freeSoup"], [], null, "");
            case UsualSet:
                summarizeOrderObject(orderItem.item, def, ["main", "noodle", "drink"], [KeiHingUsualSet.description]);
            case SiuMeiSet:
                summarizeOrderObject(orderItem.item, def, ["siuMei1", "siuMei2", "drink", "freeSoup"], [KeiHingSiuMeiSet.description]);
            case Chicken:
                summarizeOrderObject(orderItem.item, def, ["main"], []);
            case ChickenSet:
                summarizeOrderObject(orderItem.item, def, ["main", "dish", "veg", "drink1", "drink2", "freeSoup"], [KeiHingChickenSet.description]);
            case Pot:
                summarizeOrderObject(orderItem.item, def, ["main", "drink", "freeSoup"], [KeiHingPot.description]);
            case PotRice:
                summarizeOrderObject(orderItem.item, def, ["main", "veg", "drink"], [KeiHingPotRice.description], null, "煲仔飯");
            case DishSet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink", "freeSoup"], [KeiHingDishSet.description]);
            case BakedRice:
                summarizeOrderObject(orderItem.item, def, ["main", "drink", "freeSoup"], []);
            case Risotto:
                summarizeOrderObject(orderItem.item, def, ["main", "sub", "sauce", "carbo", "drink", "freeSoup"], []);
            case DailySpecialLunch:
                summarizeOrderObject(orderItem.item, def, ["main", "drink", "freeSoup"], []);
            case _:
                {
                    orderDetails: "",
                    orderPrice: 0,
                }
        }
    }

    static public function summarize(
        formData:FormOrderData,
        pickupTimeSlot:Null<TimeSlot>
    ):OrderSummary {
        var summaries = formData.items.map(item -> summarizeItem(pickupTimeSlot, cast item));
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