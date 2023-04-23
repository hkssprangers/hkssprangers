package hkssprangers;

// Keep the browser script small
#if browser
#error
#end

import hkssprangers.info.Delivery;
import hkssprangers.info.TimeSlot;
import hkssprangers.info.Shop;
import hkssprangers.info.ShopCluster;
import tink.CoreApi;
import sys.io.File;
import haxe.ds.*;
import Math.*;
using Lambda;
using StringTools;
using hxLINQ.LINQ;
import comments.CommentString.*;

#if server
import fastify.*;
import hkssprangers.server.*;
using hkssprangers.server.FastifyTools;
#end

typedef DeliveryFeeHeuristric = {
    place:String,
    osm:Array<{
        url:String,
    }>,
    match:(address:String) -> Bool,
    deliveryFee:(cluster:ShopCluster) -> Float,
}

class DeliveryFee {
    static public final heuristics:Array<DeliveryFeeHeuristric> = [
        {
            place: "深水埗站",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/389315494",
                },
            ],
            match: address -> address.contains("深水埗站") || address.contains("深水埗地鐵站") || address.contains("深水埗港鐵站") || address.contains("福華街155號"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "海峯",
            osm: [
                {
                    url: "https://www.openstreetmap.org/relation/10692715",
                }
            ],
            match: address -> address.contains("海峯") || address.toLowerCase().contains("vista"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "南昌大廈",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1028434031",
                }
            ],
            match: address -> address.contains("南昌大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/node/2544686378"
                }
            ],
            match: address -> address.contains("長沙灣站") || address.contains("長沙灣地鐵站") || address.contains("長沙灣港鐵站"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/816466449"
                }
            ],
            match: address -> address.contains("石硤尾站") || address.contains("石硤尾地鐵站") || address.contains("石硤尾港鐵站") || address.contains("銘賢書院"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/151705875"
                }
            ],
            match: address -> address.contains("麗閣邨") || address.contains("麗閣村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/26379935"
                }
            ],
            match: address -> address.contains("南昌邨") || address.contains("南昌村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/215655179"
                }
            ],
            match: address -> address.contains("匯璽") || address.contains("滙璽") || address.toLowerCase().contains("cullinan west"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/628515212"
                }
            ],
            match: address -> ~/V.?Walk/i.match(address),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/node/6605772868"
                }
            ],
            match: address -> address.contains("南昌站") || address.contains("南昌地鐵站") || address.contains("南昌港鐵站"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/26379979",
                }
            ],
            match: address -> address.contains("富昌邨") || address.contains("富昌村") || address.toLowerCase().contains("fu cheong estate"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "西九龍法院大樓",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/198993628",
                }
            ],
            match: address -> address.contains("西九龍法院大樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 35;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "榮昌邨",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/183471947",
                }
            ],
            match: address -> address.contains("榮昌邨") || address.contains("榮昌村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/180933343"
                }
            ],
            match: address -> address.contains("港灣豪庭") || address.contains("港灣豪廷"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "福昌工廠大廈 (大角咀)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450598043"
                }
            ],
            match: address -> address.contains("福昌工廠大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "頌賢花園",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/700342420"
                }
            ],
            match: address -> address.contains("頌賢花園"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "君匯港 (大角咀)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/143984531"
                }
            ],
            match: address -> address.contains("君匯港"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 35;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "凱帆軒 (大角咀)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/384976981",
                }
            ],
            match: address -> address.contains("凱帆軒") || address.toLowerCase().contains("hampton place"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "奧海城",
            osm: [
                {
                    url: "https://www.openstreetmap.org/relation/12937309",
                }
            ],
            match: address -> address.contains("帝柏海灣") || address.contains("奧海城"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "海富苑",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/26379367",
                }
            ],
            match: address -> address.contains("海富苑"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "維港灣",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/26379750",
                }
            ],
            match: address -> address.contains("維港灣") || address.toLowerCase().contains("island harbourview"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "元洲邨",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/215634461",
                }
            ],
            match: address -> address.contains("元洲邨") || address.contains("元洲村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/215630618",
                }
            ],
            match: address -> address.contains("長沙灣邨") || address.contains("長沙灣村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/151705858",
                }
            ],
            match: address -> address.contains("幸福邨") || address.contains("幸福村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/relation/11534244",
                }
            ],
            match: address -> address.contains("李鄭屋邨") || address.contains("李鄭屋村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/184158924",
                }
            ],
            match: address -> address.contains("蘇屋邨") || address.contains("蘇屋村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
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
            osm: [
                {
                    // 21, 22, 23, 24, 美山, 美虹, 美彩
                    url: "https://www.openstreetmap.org/way/839863998"
                },
                {
                    // 19, 20
                    url: "https://www.openstreetmap.org/way/839864000"
                }
            ],
            match: address ->
                ((address.contains("石硤尾邨") || address.contains("石硤尾村")) && ~/(?:19|20|21|22|23|24) *座/.match(address)) ||
                address.contains("美山樓") || address.contains("美虹樓") || address.contains("美彩樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "漫頭屋",
            osm: [
                {
                    url: "https://www.openstreetmap.org/node/10109206643"
                }
            ],
            match: address -> ~/(71|72|73)(?:-[0-9]+)? Berwick Street/i.match(address) || address.contains("漫頭屋"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/741901291",
                }
            ],
            match: address -> address.contains("美葵樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/839864004"
                }
            ],
            match: address -> address.contains("美益樓") || address.contains("美賢樓") || address.contains("美笙樓") || address.contains("美盛樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/296167636"
                }
            ],
            match: address -> address.contains("美禧樓") || address.contains("美柏樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/839864006"
                }
            ],
            match: address -> address.contains("美菖樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/839864003"
                }
            ],
            match: address -> address.contains("美如樓") || address.contains("美映樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/925221234"
                }
            ],
            match: address -> address.contains("美亮樓") || address.contains("美薈樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/151356145"
                }
            ],
            match: address -> address.contains("美荷樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/185090452"
                }
            ],
            match: address -> ~/白田[上下]?[邨村]/.match(address),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "賽馬會新生精神康復學院 (白田)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/189786893"
                }
            ],
            match: address -> address.contains("南昌街332"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "公共衛生檢測中心 (白田)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/189786657"
                }
            ],
            match: address -> address.contains("南昌街382") || address.contains("公共衛生檢測中心") || address.contains("公共衞生檢測中心"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/122268230"
                }
            ],
            match: address -> address.contains("南山邨") || address.contains("南山村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/relation/2817891"
                }
            ],
            match: address -> address.contains("城市大學") || address.contains("城大") || address.toLowerCase().contains("cityu"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "仁寶大廈 (石硤尾)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/444076329"
                }
            ],
            match: address -> address.contains("仁寶大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/relation/11306722"
                }
            ],
            match: address -> address.contains("大坑東"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/120493501"
                }
            ],
            match: address -> address.contains("大坑西"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "又一村",
            osm: [
                {
                    url: "https://www.openstreetmap.org/node/4446869476"
                }
            ],
            match: address -> address.contains("又一村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "又一居",
            osm: [
                {
                    url: "https://www.openstreetmap.org/relation/6394284"
                }
            ],
            match: address -> address.contains("又一居"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "海麗邨",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/26405835"
                }
            ],
            match: address -> address.contains("海麗邨"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "聖公會聖安德烈小學 (海麗邨)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/99713446"
                }
            ],
            match: address -> address.contains("聖公會聖安德烈小學"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "金碧閣 (長沙灣)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/753291637"
                }
            ],
            match: address -> address.contains("金碧閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450195905"
                }
            ],
            match: address -> address.contains("景怡峯") || address.contains("景怡峰"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "景翠苑 (大埔道)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1104745330"
                }
            ],
            match: address -> address.contains("景翠苑"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "楓華樓 (楓樹街)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1104746399"
                }
            ],
            match: address -> address.contains("楓華樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "置輝閣 (大埔道)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/666770059"
                }
            ],
            match: address -> address.contains("置輝閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "崇德大廈 (黃竹街)", //黃竹街39號
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/666770062"
                }
            ],
            match: address -> address.contains("崇德大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/448047567"
                }
            ],
            match: address -> address.contains("麗翠苑") || address.contains("麗翠宛") || address.toLowerCase().contains("lai tsui court"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/relation/6679304"
                }
            ],
            match: address -> address.contains("丰匯") || address.contains("丰滙") || address.toLowerCase().contains("trinity towers"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "弦雅 (醫局街)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/782116575"
                }
            ],
            match: address -> address.contains("弦雅") || address.contains("弦雅") || address.toLowerCase().contains("the concerto"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450190864"
                }
            ],
            match: address -> address.contains("時尚華庭"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "金海大廈 (海壇街)", //海壇街241-245號
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450190865"
                }
            ],
            match: address -> address.contains("金海大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "豐盛大廈 (海壇街)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/494472460"
                }
            ],
            match: address -> address.contains("豐盛大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/151705876"
                }
            ],
            match: address -> address.contains("麗安邨") || address.contains("麗安村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/781684615"
                }
            ],
            match: address -> address.contains("南昌一號") || address.toLowerCase().contains("park one"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "為群公寓",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/746329338"
                }
            ],
            match: address -> address.contains("為群公寓") || address.contains("南昌街14號"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/770846606"
                }
            ],
            match: address -> address.contains("曉盈") || address.toLowerCase().contains("high one grand"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "The Campton",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/770848691"
                }
            ],
            match: address -> address.toLowerCase().contains("the campton"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "寶華閣 (保安道，近李鄭屋邨)", // 有另一個寶華閣喺元州街
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/757863399"
                }
            ],
            match: address -> address.contains("寶華閣") && address.contains("保安道"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "永隆大廈", // Wing Loong Building
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/757606061"
                }
            ],
            match: address -> address.contains("永隆大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "順寧苑",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450182356"
                }
            ],
            match: address -> address.contains("順寧苑"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450181044"
                }
            ],
            match: address -> address.contains("興隆大廈") && address.contains("青山道"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "麗群閣 (長沙灣)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/457374950"
                }
            ],
            match: address -> address.contains("麗群閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "新寶大廈 (近樂年花園)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/705218342"
                }
            ],
            match: address -> address.contains("新寶大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "樂年花園",
            osm: [
                {
                    url: "https://www.openstreetmap.org/relation/6679087"
                }
            ],
            match: address -> address.contains("樂年花園") || address.toLowerCase().contains("cronin garden"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "喜雅",
            osm: [
                {
                    url: "https://www.openstreetmap.org/relation/6679096"
                }
            ],
            match: address -> address.contains("喜雅") || address.toLowerCase().contains("heya green"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/827588229"
                }
            ],
            match: address -> address.contains("五聯大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "AVA 61",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/827851787"
                }
            ],
            match: address -> ~/AVA\s*61/i.match(address),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/827588228"
                }
            ],
            match: address -> address.contains("曉尚") || address.contains("High Point"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/103372420"
                },
                {
                    url: "https://www.openstreetmap.org/way/494735017"
                },
                {
                    url: "https://www.openstreetmap.org/way/103372426"
                }
            ],
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
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/184922636"
                }
            ],
            match: address ->
                address.contains("賽馬會創意藝術中心") ||
                address.toLowerCase().contains("jockey club creative arts centre") ||
                address.toLowerCase().contains("jockey club creative arts center") ||
                address.toLowerCase().contains("jccac"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "寶田大廈 (白田)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/296167516"
                }
            ],
            match: address -> address.contains("寶田大廈") || ~/偉智街\s*39\s*號/.match(address),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "福田大廈 (白田)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/296167506"
                }
            ],
            match: address -> address.contains("福田大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450195200"
                }
            ],
            match: address -> address.contains("東廬大樓") || address.contains("東廬大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "華麗商場",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1028582204"
                }
            ],
            match: address -> address.contains("華麗商場") || address.contains("華麗廣場"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "元州街龍寶酒家",
            osm: [
                {
                    url: "https://www.openstreetmap.org/node/10109684652"
                }
            ],
            match: address -> address.contains("龍寶酒樓") || address.contains("龍寶酒家"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "怡閣苑",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/151705958"
                },
            ],
            match: address ->
                address.contains("怡閣苑") || address.toLowerCase().contains("yee kok court")
            ,
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "怡靖苑",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/151705957"
                }
            ],
            match: address ->
                address.contains("怡靖苑") || address.toLowerCase().contains("yee ching court")
            ,
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "金玉大廈 (白田)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/296167637"
                }
            ],
            match: address -> address.contains("金玉大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "豐溢閣 (近樂年花園)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/770851563"
                }
            ],
            match: address -> address.contains("豐溢閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/215634461"
                }
            ],
            match: address -> address.contains("元州邨") || address.contains("元州村") || address.toLowerCase().contains("un chau est"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "悅雅",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/686299249"
                }
            ],
            match: address -> address.contains("悅雅") || address.toLowerCase().contains("the astro"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "寓弍捌",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450172301"
                }
            ],
            match: address -> address.contains("寓弍捌"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "海旭閣 (長沙灣)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/494506616"
                }
            ],
            match: address -> address.contains("海旭閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "威信大廈 (大埔道)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/827851791"
                }
            ],
            match: address -> address.contains("威信大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "深崇閣 (黃竹街)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1104768707"
                }
            ],
            match: address -> address.contains("深崇閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "金必多大廈 (深水埗)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450215821"
                }
            ],
            match: address -> address.contains("金必多大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "金濤閣 (近琦興)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/782116567"
                }
            ],
            match: address -> address.contains("金濤閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "北河街永富大廈",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/703400329"
                }
            ],
            match: address -> address.contains("永富大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "翠雲大廈 (近步陞)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/770846621"
                }
            ],
            match: address -> address.contains("翠雲大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "福昇大廈 (近楓樹街)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1104771523"
                }
            ],
            match: address -> address.contains("福昇大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "順景閣 (近樂年花園)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/770819285"
                }
            ],
            match: address -> address.contains("順景閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "大興大廈 (近寶血醫院)", //元州街132號
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/770830209"
                }
            ],
            match: address -> address.contains("大興大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "薈悅 (近樂年花園)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/770819290"
                }
            ],
            match: address -> address.contains("薈悅"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "美居中心",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450176346"
                }
            ],
            match: address -> address.contains("美居中心"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "福榮大樓",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1028367461"
                }
            ],
            match: address -> address.contains("福榮街226號") || address.contains("福榮大樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "嘉美中心 (醫局街)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450190050"
                }
            ],
            match: address -> address.contains("嘉美中心"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "金盟大廈 (近寶血醫院)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/770819287"
                }
            ],
            match: address -> address.contains("金盟大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/151705860"
                },
                {
                    url: "https://www.openstreetmap.org/way/151705862"
                },
                {
                    url: "https://www.openstreetmap.org/way/775745662"
                }
            ],
            match: address ->
                address.contains("黃金電腦商場") || address.contains("黃金商場") ||
                address.contains("高登電腦中心") ||
                address.contains("黃金大廈") ||
                address.contains("黃金閣") || address.toLowerCase().contains("golden court"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "祥賢大廈 (深水埗)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/783317898"
                }
            ],
            match: address -> address.contains("祥賢大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "友來大廈 (近楓樹街遊樂場)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1089876447"
                }
            ],
            match: address -> address.contains("友來大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450184819"
                }
            ],
            match: address -> address.contains("喜韻") || address.toLowerCase().contains("heya star"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 25;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "海華麗軒 (長沙灣)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450184469"
                }
            ],
            match: address -> address.contains("海華麗軒") || address.toLowerCase().contains("hing wah apartments"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 25;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "順寧道順發大廈 (長沙灣)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450184799"
                }
            ],
            match: address -> address.contains("順發大廈") && (address.contains("順寧道") || address.contains("長沙灣")),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 25;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "喜盈/喜漾/喜薈",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450185041"
                },
                {
                    url: "https://www.openstreetmap.org/way/448053952"
                },
                {
                    url: "https://www.openstreetmap.org/way/448053951"
                }
            ],
            match: address ->
                address.contains("喜盈") || address.toLowerCase().contains("heya delight")
                ||
                address.contains("喜漾") || address.toLowerCase().contains("heya aqua")
                ||
                address.contains("喜薈") || address.toLowerCase().contains("heya crystal")
            ,
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "富華廣場",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/753291646"
                }
            ],
            match: address ->
                address.contains("富華廣場") || address.toLowerCase().contains("florence plaza")
            ,
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "一號九龍道 (近寶血醫院)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/677639737"
                }
            ],
            match: address -> address.contains("一號九龍道") || address.toLowerCase().contains("madison park"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/524429753"
                }
            ],
            match: address -> address.contains("海達邨") || address.contains("海達村"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "晉嶺 (近東廬大樓)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450195336"
                }
            ],
            match: address -> address.contains("晉嶺") || address.toLowerCase().contains("sevilla crest"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "東寶閣 (近樂年花園)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/705218347"
                }
            ],
            match: address -> address.contains("東寶閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "One New York (綠在長沙灣)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/457373571"
                }
            ],
            match: address -> address.toLowerCase().contains("one new york"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 35;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "中國船舶大廈 (長沙灣添褔)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/448053953"
                }
            ],
            match: address -> address.contains("中國船舶大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/384838107"
                }
            ],
            match: address -> address.contains("明愛醫院"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 35;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "百美工廠大廈 (長沙灣四喜)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/753522406"
                }
            ],
            match: address -> address.contains("百美工廠大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 35;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "香港中心 (長沙灣工業區)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/384658846"
                }
            ],
            match: address -> address.contains("香港中心"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "永康工廠大廈 (長沙灣工業區)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/450188190"
                }
            ],
            match: address -> address.contains("永康工廠大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "永華西藥行",
            osm: [
                {
                    url: "https://www.openstreetmap.org/node/9883453496"
                }
            ],
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
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "仁順大廈 (近宇宙商場)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/758132178"
                }
            ],
            match: address -> address.contains("仁順大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "置榮閣 (近寶血醫院)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/770851562"
                }
            ],
            match: address -> address.contains("置榮閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "傲凱 (海壇街)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/783542161"
                }
            ],
            match: address -> address.contains("傲凱") || address.toLowerCase().contains("astoria crest"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "順康居 (近香港人冰室)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/705218349"
                }
            ],
            match: address -> address.contains("順康居"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "昌隆工業大廈 (荔枝角)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/384621632"
                }
            ],
            match: address -> address.contains("昌隆工業大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "荔枝角站",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/387293149"
                }
            ],
            match: address -> address.contains("荔枝角站") || address.contains("荔枝角地鐵站") || address.contains("荔枝角港鐵站"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "W668 (荔枝角)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1104774299"
                }
            ],
            match: address -> address.contains("W668"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "南都大廈 (大埔道)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/494451423"
                }
            ],
            match: address -> address.contains("南都大廈") || address.toLowerCase().contains("rondall building"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "建和閣 (深水埗)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/815616904"
                }
            ],
            match: address -> address.contains("建和閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "大埔道236號金安大廈",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/827570076"
                }
            ],
            match: address -> address.contains("大埔道236號") && address.contains("金安大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "康美樓 (Wontonmeen)", //荔枝角道135號
            osm: [
                {
                    url: "https://www.openstreetmap.org/node/4496526267"
                }
            ],
            match: address -> address.contains("荔枝角道135號") ||  address.contains("康美樓") || address.toLowerCase().contains("wontonmeen"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "置豐閣 (醫局街)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/783303081"
                }
            ],
            match: address -> address.contains("置豐閣"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/node/9446135454"
                }
            ],
            match: address -> address.contains("長沙灣道28號"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/173944660"
                }
            ],
            match: address -> address.contains("福華街215號"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/151705864"
                }
            ],
            match: address -> address.contains("幸俊苑"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 35;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "福華街1-31號",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/85988274"
                }
            ],
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
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/26405816"
                }
            ],
            match: address -> address.contains("泓景台") || address.contains("泓景臺"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/466861748"
                }
            ],
            match: address -> address.contains("凱樂苑"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/26405812"
                }
            ],
            match: address -> address.contains("碧海藍天"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/102240941"
                }
            ],
            match: address -> address.contains("宇晴軒"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/386590356"
                }
            ],
            match: address -> address.contains("星匯居"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/26405821"
                }
            ],
            match: address -> address.contains("昇悅居"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "順輝大廈 (長沙灣)", //長發街22號
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/757325703"
                }
            ],
            match: address -> address.contains("順輝大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 25;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "耀中國際小學 (九龍塘)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/429629508"
                }
            ],
            match: address -> address.contains("耀中國際小學"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/node/4415212186"
                }
            ],
            match: address -> address.contains("畢架山"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1104776244"
                }
            ],
            match: address -> address.contains("曉珀"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "Garden Heights (太子)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/746151993"
                }
            ],
            match: address -> address.toLowerCase().contains("garden heights"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 35;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "太子站",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/355109678"
                }
            ],
            match: address -> address.contains("太子站") || address.contains("太子地鐵站") || address.contains("太子港鐵站"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 35;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "花墟公園",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/204880275"
                }
            ],
            match: address -> address.contains("花墟公園"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "西洋菜北街恒安樓",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/746151944"
                }
            ],
            match: address -> address.contains("恒安樓") && address.contains("西洋菜北街"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
                case CLPCluster: 35;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 35;
            }
        },
        {
            place: "宏創方",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/777658280"
                }
            ],
            match: address -> address.contains("宏創方") || address.toLowerCase().contains("khora"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 35;
                case PeiHoStreetMarketCluster: 35;
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
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1104777141"
                }
            ],
            match: address -> address.contains("朝南樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "大南街198號",
            osm: [
                {
                    url: "https://www.openstreetmap.org/node/9438486337" // openground
                }
            ],
            match: address -> address.contains("大南街198號"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "尚山岩舘 (大南街)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/node/9883215571"
                }
            ],
            match: address ->
                address.contains("大南街234號") || address.contains("尚山岩舘")
                ||
                (address.toLowerCase().contains("tai nan st") && address.contains("尚山")),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "愛海頌",
            osm: [
                {
                    url: "https://www.openstreetmap.org/relation/10088267"
                }
            ],
            match: address -> address.contains("愛海頌") || address.toLowerCase().contains("seaside sonata"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "荔香大廈 (近 SO Coffee & Gin)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/node/9882298921"
                }
            ],
            match: address -> address.contains("荔香大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "亮賢居",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/102368457"
                }
            ],
            match: address -> address.contains("亮賢居") || address.contains("柳樹街18號"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 35;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "福華街62至64號",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1028585163"
                }
            ],
            match: address -> address.contains("福華街62至64號") || address.contains("福華街62-64號"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "楓樹街球場",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/173944655"
                }
            ],
            match: address -> address.contains("楓樹街球場") || address.contains("楓樹街2H號"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "基隆街131號",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/103239090"
                }
            ],
            match: address -> {
                var r = ~/基隆街\s*([0-9]+)/;
                r.match(address) && switch (Std.parseInt(r.matched(1))) {
                    case n if (n >= 123 && n <= 155):
                        true;
                    case n:
                        false;
                }
            },
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "長沙大樓", //長沙灣道120號（石硤尾街19號）
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1028643855"
                }
            ],
            match: address -> address.contains("長沙大樓"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "長明大廈 (近楓樹街遊樂場)",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1104793344"
                }
            ],
            match: address -> address.contains("長明大廈"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "大南街104號",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/746198168"
                }
            ],
            match: address -> address.contains("大南街104號"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 35;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 35;
                case ParkCluster: 25;
                case PakTinCluster: 35;
                case TungChauStreetParkCluster: 25;
            }
        },
        {
            place: "美孚",
            osm: [
                {
                    url: "https://www.openstreetmap.org/relation/10671235"
                }
            ],
            match: address -> address.contains("美孚") || address.toLowerCase().contains("mei foo"),
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 40;
                case PeiHoStreetMarketCluster: 40;
                case CLPCluster: 40;
                case GoldenCluster: 40;
                case SmilingPlazaCluster: 40;
                case ParkCluster: 40;
                case PakTinCluster: 40;
                case TungChauStreetParkCluster: 40;
            }
        },
        {
            place: "南昌街170號",
            osm: [
                {
                    url: "https://www.openstreetmap.org/way/1028585181"
                }
            ],
            match: address -> {
                var r = ~/南昌街\s*([0-9]+)/;
                r.match(address) && switch (Std.parseInt(r.matched(1))) {
                    case n if (n >= 164 && n <= 181):
                        true;
                    case n:
                        false;
                }
            },
            deliveryFee: cluster -> switch cluster {
                case DragonCentreCluster: 25;
                case PeiHoStreetMarketCluster: 25;
                case CLPCluster: 25;
                case GoldenCluster: 25;
                case SmilingPlazaCluster: 25;
                case ParkCluster: 25;
                case PakTinCluster: 25;
                case TungChauStreetParkCluster: 25;
            }
        },
    ];

    static public function getMatchedHeuristrics(address:String):Array<DeliveryFeeHeuristric> {
        final matched:Array<DeliveryFeeHeuristric> = [];
        for (h in heuristics) {
            if (h.match(address)) {
                matched.push(h);
            }
        }
        return matched;
    }

    static public function decideDeliveryFee(delivery:Delivery):Promise<Float> {
        final matched = getMatchedHeuristrics(delivery.pickupLocation);
        if (matched.length <= 0) {
            return Promise.reject(new Error(InternalError, "No matching heuristics"));
        }

        final clusters = {
            final shopClusters = delivery.orders.map(o -> ShopCluster.classify(o.shop));
            shopClusters[0].filter(c -> shopClusters.foreach(cs -> cs.has(c)));
        }

        final fees = [
            for (c in clusters)
            {
                final fees = matched.map(h -> h.deliveryFee(c));
                if (fees.exists(f -> f != fees[0])) {
                    return Promise.reject(new Error(InternalError, "Not all matching heuristics agree"));
                }
                fees[0];
            }
        ];
        final fee = fees.linq().min();
        return Promise.resolve(fee);
    }

    #if server
    static public function get(req:Request, reply:Reply):js.lib.Promise<Dynamic> {
        final delivery:Delivery = Json.parse(req.query.delivery);
        return decideDeliveryFee(delivery)
            .toJsPromise()
            .catchError(err -> {
                trace(err);
                null;
            })
            .then(deliveryFee -> {
                reply.send({
                    deliveryFee: deliveryFee,
                });
            });
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/decide-delivery-fee", DeliveryFee.get);
    }
    #end

    static function main():Void {
        final osmRefs = heuristics.linq()
            .selectMany((h,i) -> h.osm.map(o -> o.url))
            .select((url,i) -> Osm.parseUrl(url))
            .select((ref,i) -> Osm.printRef(ref))
            .toArray();
        final union = "(" + osmRefs.map(r -> r + ";").join("") + ")";

        Osm.overpass(comment(unindent,format)/**
            [out:json];
            $union;
            out center;
        **/).then(text -> {
            final json = Json.parse(text);
            final pretty = Json.stringify(json, null, "  ");
            File.saveContent("deliveryLocations.json", pretty);
        });
    }
}