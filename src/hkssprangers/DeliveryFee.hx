package hkssprangers;

import hkssprangers.info.Delivery;
import hkssprangers.info.TimeSlot;
import hkssprangers.info.Shop;
import hkssprangers.info.ShopCluster;
import hkssprangers.info.Discounts;
import Math.*;
using Lambda;
using StringTools;

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
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "長沙灣站",
            match: address -> address.contains("長沙灣站") || address.contains("長沙灣地鐵站") || address.contains("長沙灣港鐵站"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "石硤尾站",
            match: address -> address.contains("石硤尾站") || address.contains("石硤尾地鐵站") || address.contains("石硤尾港鐵站"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "麗閣邨",
            match: address -> address.contains("麗閣邨") || address.contains("麗閣村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "南昌邨",
            match: address -> address.contains("南昌邨") || address.contains("南昌村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "匯璽",
            match: address -> address.contains("匯璽") || address.contains("滙璽") || address.toLowerCase().contains("cullinan west"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "V·Walk",
            match: address -> ~/V.?Walk/i.match(address),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "南昌站",
            match: address -> address.contains("南昌站") || address.contains("南昌地鐵站") || address.contains("南昌港鐵站"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "富昌邨",
            match: address -> address.contains("富昌邨") || address.contains("富昌村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "榮昌邨",
            match: address -> address.contains("榮昌邨") || address.contains("榮昌村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "港灣豪庭",
            match: address -> address.contains("港灣豪庭") || address.contains("港灣豪廷"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "元洲邨",
            match: address -> address.contains("元洲邨") || address.contains("元洲村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "長沙灣邨",
            match: address -> address.contains("長沙灣邨") || address.contains("長沙灣村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "幸福邨",
            match: address -> address.contains("幸福邨") || address.contains("幸福村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "李鄭屋邨",
            match: address -> address.contains("李鄭屋邨") || address.contains("李鄭屋村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 25;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "蘇屋邨",
            match: address -> address.contains("蘇屋邨") || address.contains("蘇屋村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "石硤尾邨 (新區)",
            match: address ->
                ((address.contains("石硤尾邨") || address.contains("石硤尾村")) && ~/(?:19|20|21|22|23|24) *座/.match(address)) ||
                address.contains("美山樓") || address.contains("美虹樓") || address.contains("美彩樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "石硤尾邨 (第3期)",
            match: address -> address.contains("美葵樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "石硤尾邨 (第5期)",
            match: address -> address.contains("美益樓") || address.contains("美賢樓") || address.contains("美笙樓") || address.contains("美盛樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "石硤尾邨 (第6期)",
            match: address -> address.contains("美禧樓") || address.contains("美柏樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "石硤尾邨 (第7期)",
            match: address -> address.contains("美菖樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "石硤尾邨 (第1期)",
            match: address -> address.contains("美如樓") || address.contains("美映樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "石硤尾邨 (第2期)",
            match: address -> address.contains("美亮樓") || address.contains("美薈樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "美荷樓",
            match: address -> address.contains("美荷樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "白田邨",
            match: address -> ~/白田[上下]?[邨村]/.match(address),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "南昌街332",
            match: address -> address.contains("南昌街332"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "南山邨",
            match: address -> address.contains("南山邨") || address.contains("南山村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "城市大學",
            match: address -> address.contains("城市大學") || address.contains("城大") || address.toLowerCase().contains("cityu"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "仁寶大廈",
            match: address -> address.contains("仁寶大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "大坑東",
            match: address -> address.contains("大坑東"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "大坑西",
            match: address -> address.contains("大坑西"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "海麗邨",
            match: address -> address.contains("海麗邨"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "金碧閣",
            match: address -> address.contains("金碧閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "景怡峯",
            match: address -> address.contains("景怡峯") || address.contains("景怡峰"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "景翠苑",
            match: address -> address.contains("景翠苑"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "楓華樓",
            match: address -> address.contains("楓華樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "置輝閣",
            match: address -> address.contains("置輝閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "麗翠苑",
            match: address -> address.contains("麗翠苑") || address.toLowerCase().contains("lai tsui court"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "丰匯",
            match: address -> address.contains("丰匯") || address.contains("丰滙") || address.toLowerCase().contains("trinity towers"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "時尚華庭",
            match: address -> address.contains("時尚華庭"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "麗安邨",
            match: address -> address.contains("麗安邨") || address.contains("麗安村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "南昌一號",
            match: address -> address.contains("南昌一號") || address.toLowerCase().contains("park one"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "曉盈",
            match: address -> address.contains("曉盈") || address.toLowerCase().contains("high one grand"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "保安道寶華閣", // 有另一個寶華閣喺元州街
            match: address -> address.contains("寶華閣") && address.contains("保安道"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "永隆大廈",
            match: address -> address.contains("永隆大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "青山道興隆大廈",
            match: address -> address.contains("興隆大廈") && address.contains("青山道"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "麗群閣",
            match: address -> address.contains("麗群閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "新寶大廈",
            match: address -> address.contains("新寶大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "五聯大廈",
            match: address -> address.contains("五聯大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "曉尚",
            match: address -> address.contains("曉尚") || address.contains("High Point"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
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
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
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
                case CLPCluster: 40;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "福田大廈",
            match: address -> address.contains("福田大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "東廬大樓",
            match: address -> address.contains("東廬大樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "元州街龍寶酒家",
            match: address -> address.contains("龍寶酒樓") || address.contains("龍寶酒家"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "怡閣苑, 怡靖苑",
            match: address -> address.contains("怡閣苑") || address.contains("怡靖苑"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "金玉大廈",
            match: address -> address.contains("金玉大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "豐溢閣",
            match: address -> address.contains("豐溢閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "元州邨",
            match: address -> address.contains("元州邨") || address.contains("元州村") || address.toLowerCase().contains("un chau est"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "威信大廈",
            match: address -> address.contains("威信大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "深崇閣",
            match: address -> address.contains("深崇閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "金必多大廈",
            match: address -> address.contains("金必多大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "金濤閣",
            match: address -> address.contains("金濤閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "翠雲大廈",
            match: address -> address.contains("翠雲大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "福昇大廈",
            match: address -> address.contains("福昇大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "順景閣",
            match: address -> address.contains("順景閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "薈悅",
            match: address -> address.contains("薈悅"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "嘉美中心",
            match: address -> address.contains("嘉美中心"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "金盟大廈",
            match: address -> address.contains("金盟大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "黃金/高登",
            match: address ->
                address.contains("黃金電腦商場") || address.contains("黃金商場") ||
                address.contains("高登電腦中心") ||
                address.contains("黃金大廈") ||
                address.contains("黃金閣") || address.toLowerCase().contains("golden court"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "友來大廈",
            match: address -> address.contains("友來大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "喜韻",
            match: address -> address.contains("喜韻"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 25;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "喜盈/喜漾/喜薈",
            match: address -> address.contains("喜盈") || address.contains("喜漾") || address.contains("喜薈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "一號九龍道",
            match: address -> address.contains("一號九龍道") || address.toLowerCase().contains("madison park"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "海達邨",
            match: address -> address.contains("海達邨") || address.contains("海達村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "晉嶺",
            match: address -> address.contains("晉嶺") || address.toLowerCase().contains("sevilla crest"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "東寶閣",
            match: address -> address.contains("東寶閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "One New York",
            match: address -> address.toLowerCase().contains("one new york"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 35;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "明愛醫院",
            match: address -> address.contains("明愛醫院"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 35;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "香港中心",
            match: address -> address.contains("香港中心"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "永華西藥行",
            match: address -> {
                var r = ~/青山道\s*([0-9]+)/;
                r.match(address) && switch (Std.parseInt(r.matched(1))) {
                    case 277:
                        true;
                    case n:
                        false;
                }
            },
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "仁順大廈",
            match: address -> address.contains("仁順大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "置榮閣",
            match: address -> address.contains("置榮閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "傲凱",
            match: address -> address.contains("傲凱") || address.toLowerCase().contains("astoria crest"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "順康居",
            match: address -> address.contains("順康居"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "昌隆工業大廈",
            match: address -> address.contains("昌隆工業大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "南都大廈",
            match: address -> address.contains("南都大廈") || address.toLowerCase().contains("rondall building"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "建和閣",
            match: address -> address.contains("建和閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "金安大廈",
            match: address -> address.contains("金安大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "置豐閣",
            match: address -> address.contains("置豐閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "Foodmen",
            match: address -> address.contains("長沙灣道28號"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "中電",
            match: address -> address.contains("福華街215號"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "幸俊苑",
            match: address -> address.contains("幸俊苑"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "福華街1-31號",
            match: address -> {
                var r = ~/福華街\s*([0-9]+)/;
                r.match(address) && switch (Std.parseInt(r.matched(1))) {
                    case n if (n >= 1 && n <= 31):
                        true;
                    case n:
                        false;
                }
            },
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "泓景台",
            match: address -> address.contains("泓景台") || address.contains("泓景臺"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "凱樂苑",
            match: address -> address.contains("凱樂苑"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "碧海藍天",
            match: address -> address.contains("碧海藍天"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "宇晴軒",
            match: address -> address.contains("宇晴軒"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "星匯居",
            match: address -> address.contains("星匯居"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "昇悅居",
            match: address -> address.contains("昇悅居"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "順輝大廈", //長發街22號
            match: address -> address.contains("順輝大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 25;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "耀中國際小學",
            match: address -> address.contains("耀中國際小學"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "畢架山",
            match: address -> address.contains("畢架山"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "曉珀",
            match: address -> address.contains("曉珀"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "宏創方",
            match: address -> address.contains("宏創方") || address.toLowerCase().contains("khora"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "大南街朝南樓",
            match: address -> address.contains("朝南樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
    ];

    static public function decideDeliveryFee(delivery:Delivery):Null<Float> {
        var matched:Array<{
            place:String,
            fee:Float,
        }> = [];

        var cluster = ShopCluster.classify(delivery.orders[0].shop);

        for (h in heuristics) {
            if (h.match(delivery.pickupLocation)) {
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
        if (!matched.foreach(h -> h.fee == fee)) {
            return null;
        }

        var discount = Discounts.bestDiscountResult(delivery);
        if (discount != null) {
            fee -= discount.deliveryFeeDeduction;
        }

        return fee;
    }
}