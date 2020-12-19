package hkssprangers;

import hkssprangers.info.Shop;
using Lambda;
using StringTools;

enum abstract ShopCluster(String) {
    var DragonCentreCluster;
    var YearsCluster;
    var BiuKeeCluster;
    var NeighborCluster;
    var MGYCluster;

    static public function classify(shop:Shop):ShopCluster {
        return switch shop {
            case EightyNine: DragonCentreCluster;
            case DragonJapaneseCuisine: DragonCentreCluster;
            case YearsHK: YearsCluster;
            case LaksaStore: DragonCentreCluster;
            case DongDong: YearsCluster;
            case BiuKeeLokYuen: BiuKeeCluster;
            case KCZenzero: DragonCentreCluster;
            case HanaSoftCream: DragonCentreCluster;
            case Neighbor: NeighborCluster;
            case MGY: MGYCluster;
            case FastTasteSSP: BiuKeeCluster;
        }
    }
}

typedef DeliveryFeeHeuristric = {
    place:String,
    match:(address:String) -> Bool,
    deliveryFee:(cluster:ShopCluster) -> Float,
}

class DeliveryFee {
    static final heuristics:Array<DeliveryFeeHeuristric> = [
        {
            place: "深水埗站",
            match: address -> address.contains("深水埗站") || address.contains("深水埗地鐵站") || address.contains("深水埗港鐵站"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "長沙灣站",
            match: address -> address.contains("長沙灣站") || address.contains("長沙灣地鐵站") || address.contains("長沙灣港鐵站"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 35;
            }
        },
        {
            place: "石硤尾站",
            match: address -> address.contains("石硤尾站") || address.contains("石硤尾地鐵站") || address.contains("石硤尾港鐵站"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case YearsCluster: 35;
                case BiuKeeCluster: 35;
                case NeighborCluster: 35;
                case MGYCluster: 35;
            }
        },
        {
            place: "麗閣邨",
            match: address -> address.contains("麗閣邨") || address.contains("麗閣村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "南昌邨",
            match: address -> address.contains("南昌邨") || address.contains("南昌村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 35;
                case MGYCluster: 25;
            }
        },
        {
            place: "匯璽",
            match: address -> address.contains("匯璽") || address.toLowerCase().contains("cullinan west"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 40;
                case MGYCluster: 25;
            }
        },
        {
            place: "富昌邨",
            match: address -> address.contains("富昌邨") || address.contains("富昌村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 35;
                case MGYCluster: 25;
            }
        },
        {
            place: "榮昌邨",
            match: address -> address.contains("榮昌邨") || address.contains("榮昌村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 35;
                case MGYCluster: 25;
            }
        },
        {
            place: "港灣豪庭",
            match: address -> address.contains("港灣豪庭"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 35;
                case BiuKeeCluster: 35;
                case NeighborCluster: 40;
                case MGYCluster: 25;
            }
        },
        {
            place: "元洲邨",
            match: address -> address.contains("元洲邨") || address.contains("元洲村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 35;
            }
        },
        {
            place: "長沙灣邨",
            match: address -> address.contains("長沙灣邨") || address.contains("長沙灣村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "幸福邨",
            match: address -> address.contains("幸福邨") || address.contains("幸福村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 35;
            }
        },
        {
            place: "李鄭屋邨",
            match: address -> address.contains("李鄭屋邨") || address.contains("李鄭屋村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case YearsCluster: 25;
                case BiuKeeCluster: 35;
                case NeighborCluster: 25;
                case MGYCluster: 40;
            }
        },
        {
            place: "蘇屋邨",
            match: address -> address.contains("蘇屋邨") || address.contains("李鄭屋村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case YearsCluster: 35;
                case BiuKeeCluster: 35;
                case NeighborCluster: 25;
                case MGYCluster: 40;
            }
        },
        {
            place: "石硤尾邨 (新區)",
            match: address ->
                ((address.contains("石硤尾邨") || address.contains("石硤尾村")) && ~/(?:19|20|21|22|23|24) *座/.match(address)) ||
                address.contains("美山樓") || address.contains("美虹樓") || address.contains("美彩樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "石硤尾邨 (第3期)",
            match: address -> address.contains("美葵樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "石硤尾邨 (第5期)",
            match: address -> address.contains("美益樓") || address.contains("美賢樓") || address.contains("美笙樓") || address.contains("美盛樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "石硤尾邨 (第6期)",
            match: address -> address.contains("美禧樓") || address.contains("美柏樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "石硤尾邨 (第7期)",
            match: address -> address.contains("美菖樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "石硤尾邨 (第1期)",
            match: address -> address.contains("美如樓") || address.contains("美映樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case YearsCluster: 35;
                case BiuKeeCluster: 35;
                case NeighborCluster: 35;
                case MGYCluster: 35;
            }
        },
        {
            place: "石硤尾邨 (第2期)",
            match: address -> address.contains("美亮樓") || address.contains("美薈樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case YearsCluster: 35;
                case BiuKeeCluster: 35;
                case NeighborCluster: 35;
                case MGYCluster: 35;
            }
        },
        {
            place: "美荷樓",
            match: address -> address.contains("美荷樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "白田邨",
            match: address -> address.contains("白田邨") || address.contains("白田村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case YearsCluster: 40;
                case BiuKeeCluster: 40;
                case NeighborCluster: 40;
                case MGYCluster: 40;
            }
        },
        {
            place: "南山邨",
            match: address -> address.contains("南山邨") || address.contains("南山村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case YearsCluster: 40;
                case BiuKeeCluster: 40;
                case NeighborCluster: 40;
                case MGYCluster: 40;
            }
        },
        {
            place: "大坑東",
            match: address -> address.contains("大坑東"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case YearsCluster: 40;
                case BiuKeeCluster: 40;
                case NeighborCluster: 40;
                case MGYCluster: 40;
            }
        },
        {
            place: "大坑西",
            match: address -> address.contains("大坑西"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case YearsCluster: 40;
                case BiuKeeCluster: 40;
                case NeighborCluster: 40;
                case MGYCluster: 40;
            }
        },
        {
            place: "海麗邨",
            match: address -> address.contains("海麗邨"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case YearsCluster: 40;
                case BiuKeeCluster: 40;
                case NeighborCluster: 40;
                case MGYCluster: 40;
            }
        },
        {
            place: "金碧閣",
            match: address -> address.contains("金碧閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case YearsCluster: 35;
                case BiuKeeCluster: 35;
                case NeighborCluster: 25;
                case MGYCluster: 40;
            }
        },
        {
            place: "景怡峯",
            match: address -> address.contains("景怡峯") || address.contains("景怡峰"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "置輝閣",
            match: address -> address.contains("置輝閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "麗翠苑",
            match: address -> address.contains("麗翠苑"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 35;
            }
        },
        {
            place: "丰匯",
            match: address -> address.contains("丰匯") || address.toLowerCase().contains("trinity towers"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "時尚華庭",
            match: address -> address.contains("時尚華庭"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "麗安邨",
            match: address -> address.contains("麗安邨") || address.contains("麗安村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "南昌一號",
            match: address -> address.contains("南昌一號") || address.toLowerCase().contains("park one"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 35;
                case MGYCluster: 25;
            }
        },
        {
            place: "曉盈",
            match: address -> address.contains("曉盈") || address.toLowerCase().contains("high one grand"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "保安道寶華閣", // 有另一個寶華閣喺元州街
            match: address -> address.contains("寶華閣") && address.contains("保安道"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 35;
                case NeighborCluster: 25;
                case MGYCluster: 35;
            }
        },
        {
            place: "永隆大廈",
            match: address -> address.contains("永隆大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 35;
            }
        },
        {
            place: "喜韻",
            match: address -> address.contains("喜韻"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case YearsCluster: 25;
                case BiuKeeCluster: 35;
                case NeighborCluster: 25;
                case MGYCluster: 40;
            }
        },
        {
            place: "麗群閣",
            match: address -> address.contains("麗群閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case YearsCluster: 35;
                case BiuKeeCluster: 35;
                case NeighborCluster: 25;
                case MGYCluster: 35;
            }
        },
        {
            place: "新寶大廈",
            match: address -> address.contains("新寶大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 35;
            }
        },
        {
            place: "五聯大廈",
            match: address -> address.contains("五聯大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "福榮街33-120號",
            match: address -> {
                var r = ~/福榮街\s*([0-9]+)/;
                r.match(address) && switch (Std.parseInt(r.matched(1))) {
                    case n if (n >= 33 && n <= 120):
                        true;
                    case n:
                        false;
                }
            },
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "JCCAC",
            match: address ->
                address.contains("賽馬會創意藝術中心") ||
                address.toLowerCase().contains("jockey club creative arts centre") ||
                address.toLowerCase().contains("jockey club creative arts center") ||
                address.toLowerCase().contains("jccac"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 40;
                case BiuKeeCluster: 25;
                case NeighborCluster: 40;
                case MGYCluster: 35;
            }
        },
        {
            place: "東廬大樓",
            match: address -> address.contains("東廬大樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "元州街龍寶酒家",
            match: address -> address.contains("元州街") && (address.contains("龍寶酒樓") || address.contains("龍寶酒家")),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 35;
            }
        },
        {
            place: "怡閣苑, 怡靖苑",
            match: address -> address.contains("怡閣苑") || address.contains("怡靖苑"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "金玉大廈",
            match: address -> address.contains("金玉大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case YearsCluster: 40;
                case BiuKeeCluster: 35;
                case NeighborCluster: 40;
                case MGYCluster: 40;
            }
        },
        {
            place: "豐溢閣",
            match: address -> address.contains("豐溢閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 35;
            }
        },
        {
            place: "元州邨",
            match: address -> address.contains("元州邨") || address.contains("元州村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 35;
                case NeighborCluster: 25;
                case MGYCluster: 40;
            }
        },
        {
            place: "威信大廈",
            match: address -> address.contains("威信大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "深崇閣",
            match: address -> address.contains("深崇閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "金必多大廈",
            match: address -> address.contains("金必多大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "金濤閣",
            match: address -> address.contains("金濤閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "黃金閣",
            match: address -> address.contains("黃金閣") || address.toLowerCase().contains("golden court"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
        {
            place: "翠雲大廈",
            match: address -> address.contains("翠雲大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case YearsCluster: 25;
                case BiuKeeCluster: 25;
                case NeighborCluster: 25;
                case MGYCluster: 25;
            }
        },
    ];

    static public function decideDeliveryFee(shop:Shop, address:String):Null<Float> {
        var matched:Array<{
            place:String,
            fee:Float,
        }> = [];

        var cluster = ShopCluster.classify(shop);

        for (h in heuristics) {
            if (h.match(address)) {
                matched.push({
                    place: h.place,
                    fee: h.deliveryFee(cluster),
                });
            }
        }

        if (matched.length <= 0) {
            return null;
        }

        var fee = matched[0].fee;
        if (matched.foreach(h -> h.fee == fee)) {
            return fee;
        }

        return null;
    }
}