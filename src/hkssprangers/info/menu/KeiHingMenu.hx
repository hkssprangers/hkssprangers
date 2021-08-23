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
        case DishSet: KeiHingMenu.KeiHingDishSet;
        // case FishSet: KeiHingMenu.KeiHingFishSet;
        // case DishFishSet: KeiHingMenu.KeiHingDishFishSet;
        case ChickenSet: KeiHingMenu.KeiHingChickenSet;
        // case FishChickenSet: KeiHingMenu.KeiHingFishChickenSet;
    }
}

class KeiHingMenu {
    static public final box = "外賣盒 $2";
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
            "凍檸樂 +$4", //凍?
            "凍檸蜜 +$4", //凍?
            "凍檸啡 +$4", //凍?
            "凍鮮奶 +$4", //凍?
            // 特飲?
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
                    "1000 梅菜扣肉飯 送:是日例湯 $51",
                    "1002 無骨海南雞 配:雞油香飯 送:油菜+是日例湯 $55",

                    // 炒粉麵
                    "1300 乾炒牛河 $49",
                    "1301 乾炒三絲河 $49",
                    "1302 乾炒黑椒牛肉意 $49",
                    "1303 乾燒伊麵 $49",
                    "1304 銀芽肉絲炒麵 $49",
                    "1305 時菜牛肉炒河 $49",
                    "1306 星州炒米 $49",
                    "1307 星州炒貴刁 $49",
                    "1308 豉椒排骨炒麵 $49",
                    "1309 涼瓜肉片炒河 $49",
                    "1310 羅漢齋炒麵 $49",
                    "1311 雪菜肉絲炆米 $49",
                    "1312 廈門炒米 $49",
                    "1313 豉油皇炒麵 $49",
                    "1314 沙爹牛肉炒河 $49",
                    "1315 猪扒炒烏冬 $51",
                    "1316 魚香茄子炆米 $51",
                    "1317 雪菜火鴨絲炆米 $51",
                    "1318 時菜魚柳炒河 $51",
                    "1319 乾炒猪扒河 $51",
                    "1320 味菜鮮魷炒河 $51",
                    "1321 羅漢齋炆伊麵 $51",
                    "1322 沙爹雞絲炒烏冬 $51",
                    "1323 XO醬肉絲炆伊麵 $51",
                    "1324 黑椒牛柳絲炒麵 $55",
                    "1325 原汁牛腩炒河 $55",
                    "1326 日式海鮮炒烏冬 $55",
                    "1327 回鍋肉片炆烏冬 $55",

                    // 中式飯類
                    "1200 火腿煎蛋飯 $44",
                    "1201 餐肉煎蛋飯 $44",
                    "1202 腸仔煎蛋飯 $44",
                    "1203 叉燒煎蛋飯 $44",
                    "1204 揚州炒飯 $46",
                    "1205 西炒飯 $46",
                    "1206 生炒牛肉飯 $46",
                    "1207 咸魚雞粒炒飯 $46",
                    "1208 鮮茄牛肉飯 $46",
                    "1209 時菜肉片飯 $46",
                    "1210 豉椒排骨飯 $46",
                    "1211 豆腐魚柳飯 $46",
                    "1212 粟米魚柳飯 $46",
                    "1213 芙蓉煎蛋飯 $46",
                    "1214 粟米肉粒飯 $46",
                    "1215 羅漢齋飯 $46",
                    "1216 滑蛋蝦仁飯 $46",
                    "1217 魚香茄子飯 $46",
                    "1218 菠蘿生炒骨 $49",
                    "1219 豆腐火腩飯 $49",
                    "1220 洋蔥猪扒飯 $49",
                    "1221 西芹雞柳飯 $49",
                    "1222 豉椒鮮魷飯 $49",
                    "1223 京都猪扒飯 $49",
                    "1224 泰式海鮮炒飯 $49",
                    "1225 椒鹽豬扒飯 $49",
                    "1226 福建炒飯 $49",
                    "1227 原汁牛腩飯 $52",
                    "1228 琦興什扒飯 $58",

                    // 粉麵類
                    "1501 鮮蝦雲吞麵 $31",
                    "1502 爽滑魚蛋麵 $31",
                    "1503 手打牛丸麵 $31",
                    "1504 台灣貢丸麵 $31",
                    "1505 新鮮墨丸麵 $31",
                    "1506 京都炸醬麵 $31",
                    "1507 原汁牛腩麵 $33",
                    "1508 淨牛腩 $73",
                    "1509 郊外油菜 $22",
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
                    "1400 牛肉炒公仔麵 $49",
                    "1401 雞絲炒公仔麵 $49",
                    "1402 肉片炒公仔麵 $49",
                    "1403 餐肉炒公仔麵 $49",
                    "1404 火腿炒公仔麵 $49",
                    "1405 腸仔炒公仔麵 $49",
                    "1406 星洲炒公仔麵 $49",
                    "1407 五香肉丁炒公仔麵 $51",
                    "1408 海鮮炒公仔麵 $51",
                    "1409 猪扒炒公仔麵 $51",
                    "1410 雞扒炒公仔麵 $51",
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
                    "1100 咖哩雜扒(猪扒+雞扒+腸仔+火腿+煎蛋) 飯 $58",
                    "1100 咖哩雜扒(猪扒+雞扒+腸仔+火腿+煎蛋) 意粉 $58",
                    "1101 咖哩牛三寶(牛扒,牛肉,牛脷) 飯 $68",
                    "1101 咖哩牛三寶(牛扒,牛肉,牛脷) 意粉 $68",
                    "1102 咖哩牛腩飯 $55",
                    "1102 咖哩牛腩意粉 $55",
                    "1103 咖哩牛扒飯 $55",
                    "1103 咖哩牛扒意粉 $55",
                    "1104 咖哩牛脷飯 $55",
                    "1104 咖哩牛脷意粉 $55",
                    "1105 咖哩猪扒飯 $51",
                    "1105 咖哩猪扒意粉 $51",
                    "1106 咖哩雞扒飯 $51",
                    "1106 咖哩雞扒意粉 $51",
                    "1107 咖哩魚柳飯 $51",
                    "1107 咖哩魚柳意粉 $51",
                    "1108 咖哩牛肉飯 $49",
                    "1108 咖哩牛肉意粉 $49",
                    "1109 咖哩肉片飯 $49",
                    "1109 咖哩肉片意粉 $49",
                    "1110 咖哩雜菜飯 $49",
                    "1110 咖哩雜菜意粉 $49",
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
            "1511 各式多士 $15",
            "1512 奶油豬 $17",
            "1513 炸薯條 $22",
            "1514 熱狗 $22",
            "1515 沙爹牛肉包 $22",
            "1516 西多士 $24",
            "1517 雞扒包 $26",
            "1518 豬扒包 $26",
            "1519 炸雞中翼(3隻) $26",
        ],
    };
    static public final KeiHingSandwich = {
        title: "三文治",
        type: "string",
        "enum": [
            "1519 咸牛肉三文治 $22", // duplicated id?
            "1520 芝士三文治 $22",
            "1521 雞蛋三文治 $22",
            "1522 火腿三文治 $22",
            "1523 餐肉三文治 $22",
            "1524 茄蛋三文治 $24",
            "1525 火腿蛋三文治 $24",
            "1526 鮮茄芝士三文治 $24",
            "1527 公司三文治 $38",
        ],
    };
    static public final KeiHingChicken = {
        title: "招牌雞",
        properties: {
            main: {
                title: "招牌雞",
                type: "string",
                "enum": [
                    "1600 沙薑雞(半隻) $92",
                    "1604 沙薑雞(一隻) $172",
                    "1601 薑蔥霸王雞(半隻) $92",
                    "1605 薑蔥霸王雞(一隻) $172",
                    "1602 上湯菜膽雞(半隻) $92",
                    "1606 上湯菜膽雞(一隻) $172",
                    "1603 無骨海南雞(半隻) $92",
                    "1607 無骨海南雞(一隻) $172",
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
                    "1900 清炒時蔬 $52",
                    "1901 時菜炒肉片 $58",
                    "1902 鮮茄牛肉煮蛋 $58",
                    "1903 羅漢上素 $58",
                    "1904 香煎芙蓉蛋 $58",
                    "1905 京都豬扒 $60",
                    "1906 菠蘿生炒骨 $60",
                    "1907 越式炒雜菜 $58",
                    "1908 時菜炒魚鬆 $58",
                    "1909 咕嚕雞球 $58",
                    "1910 金銀蛋時菜 $58",
                    "1911 西蘭花雞柳 $58",
                    "1912 銀芽炒三絲 $58",
                    "1913 椒鹽豆腐 $58",
                    "1914 紅燒豆腐 $58",
                    "1915 菜脯肉鬆煎蛋 $58",
                    "1916 沙拉豬扒 $60",
                    "1917 椒鹽豬扒 $60",
                    "1918 酥炸鯪魚球 $60",
                    "1919 蔥爆牛肉 $60",
                    "1920 北菇扒時蔬 $60",
                    "1921 泰式豬扒 $60",
                    "1922 泰式雞扒 $60",
                    "1923 涼瓜炆排骨 $60",
                    "1924 福建扒豆腐 $60",
                    "1925 水煮牛肉 $60",
                    "1926 西檸煎軟雞 $60",
                    "1927 蒜香雞中翼 $60",
                    "1928 中式牛柳 $65",
                    "1929 西芹腰果肉丁 $65",
                    "1930 蝦醬通菜鮮魷 $68",
                    "1931 葡汁焗四蔬 $65",
                    "1932 味菜牛柳絲 $65",
                    "1933 豉椒鮮魷 $68",
                    "1934 豆豉爆雞 $65",
                    "1935 豆豉鯪魚油麥菜 $65",
                    "1936 椒鹽鮮魷 $81",
                    "1937 黑椒牛仔骨 $78",
                    "1938 北菇鮑片扒豆豉 $72",
                    "1939 蜜椒薯仔牛柳粒 $72",

                    // 時令小菜
                    "鹵水拼盤 (鹵水蛋,腩肉,豬大腸,雞翼,紅腸) $90",
                    // "鹵水雙拼 $70",
                    "潮式鹵水鴨(半隻) $90",
                    "味菜炒什會 $62",
                    "鹹酸菜煮魚 $62",
                    "韭菜豬紅 $60",
                    "豉椒味菜炒鵝腸 $62",
                    "方魚肉碎蠔仔粥 $60",
                    "大豆芽菜炒豬腸 $62",
                    "鍋塌豆腐 $68",
                    "尖椒雞丁 $78",
                    "松子鮮魚 $78",
                    "韭菜花炒鹹肉 $78",
                    "一品小炒王 $88",
                    "佛山燻蹄 $78",
                    "七味一字骨 $78",
                    "京都一字骨 $78",
                    "涼瓜炒田雞 $88",
                    "子然三寸骨 $78",
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
                    "1800 啫啫滑雞煲 $63",
                    "1801 啫啫排骨煲 $63",
                    "1802 南乳粗齋煲 $63",
                    "1803 魚香茄子煲 $63",
                    "1804 沙嗲牛肉粉絲煲 $63",
                    "1805 咸魚雞粒豆腐煲 $63",
                    "1806 海鮮雜菜煲 $63",
                    "1807 咖哩牛腩煲 $71",
                    "1808 豆腐火腩煲 $71",
                    "1809 薑蔥魚頭煲 $71",
                    "1810 薑蔥魚腩煲 $71",
                    "1811 沙爹金菇肥牛煲 $71",
                    "1812 雲吞雞煲 $71",
                    "1813 生菜豆腐鯪魚球煲 $71",
                    "1814 雜菇紫菜魚滑煲 $71",
                    "1815 八珍豆腐煲 $71",
                    "1816 薑蔥支竹牛肉煲 $71",
                    "1817 涼瓜魚柳堡 $71",
                    "1818 麻婆豆腐煲 $71",
                ],
            },
            options: KeiHingRiceAndSoup,
        },
        required: ["main"],
    };

    static public final KeiHingDishSet = {
        title: "小菜套餐",
        description: "配：例湯＋白飯＋熱飲",
        properties: {
            main: {
                title: "小菜",
                type: "string",
                "enum": [
                    "京都豬扒 $61",
                    "粟米炸魚柳 $61",
                    "紅燒豆腐 $61",
                    "菜心炒牛肉 $61",
                    "菠蘿生炒骨 $61",
                    "香煎芙蓉蛋 $61",
                    "涼瓜炒肉片 $61",
                    "麻婆豆腐 $61",
                    "蒜香雞中翼 $61",
                    "回鍋肉片 $61",
                    "羅漢上素 $61",
                    "通菜牛肉 (腐乳) $61",
                    "通菜牛肉 (蝦醬) $61",
                    "椒鹽豬扒 $61",
                    "豆豉炆雞 $61",
                    "咕嚕雞球 $61",
                    "時菜炒魚鬆 $61",
                    "黃金焗豬扒 $61",
                    "魚香茄子 $61",
                    "蝦仁炒蛋 $61",
                    "酥炸鯪魚球 $61",
                    "越式炒雜菜 $61",
                    "沙爹金菇牛肉 $61",
                    "節瓜蝦米粉絲 $61",
                    "洋蔥豬扒 $61",
                    "七味雞中翼 $61",
                    "菠蘿牛肉 $61",
                    "泰式雞扒 $61",
                    "咸魚雞粒豆腐 $61",
                    "銀芽炒三絲 $61",
                    "冬瓜炆排骨 $61",
                    "涼瓜肉碎煎蛋角 $61",
                    "士多啤梨骨 $61",
                    "西蘭花雞柳 $61",
                    "北菇扒時菜 $61",
                    "涼瓜炆鴨 $61",
                    "金銀蛋時菜 $61",
                ],
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
        description: "配：例湯＋白飯2碗＋熱飲",
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
            vege: {
                title: "小菜",
                type: "string",
                "enum": [
                    "蒜蓉炒時菜",
                    "芝士白汁焗西蘭花",
                ],
            },
            drink: KeiHingFreeHotDrink,
        },
        required: ["main", "vege", "drink"],
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
            case NoodleAndRice | CurrySet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], []);
            case ChickenLegSet:
                summarizeOrderObject(orderItem.item, def, ["main", "sauce", "drink"], ["送：是日例湯"]);
            case FriedInstantNoodle:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "drink"], []);
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
            case DishSet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"], ["配：例湯＋白飯"]);
            case ChickenSet:
                summarizeOrderObject(orderItem.item, def, ["main", "vege", "drink"], ["配：例湯＋白飯2碗"]);
            case _:
                {
                    orderDetails: "",
                    orderPrice: 0,
                }
        }
    }

    static public function summarize(formData:FormOrderData):OrderSummary {
        var summaries = formData.items.map(item -> summarizeItem(cast item));
        summaries.push({
            orderDetails: box,
            orderPrice: box.parsePrice().price,
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