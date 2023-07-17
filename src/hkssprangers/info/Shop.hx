package hkssprangers.info;

import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.Weekday;
import hkssprangers.info.menu.*;
import hkssprangers.info.ShopType;
import js.lib.Promise;
using Lambda;
using DateTools;

enum abstract Shop(String) to String {
    final EightyNine:Shop;
    final ThaiHome:Shop;
    final DragonJapaneseCuisine:Shop;
    final YearsHK:Shop;
    final TheParkByYears:Shop;
    final LaksaStore:Shop;
    final DongDong:Shop;
    final BiuKeeLokYuen:Shop;
    final KCZenzero:Shop;
    final HanaSoftCream:Shop;
    final Neighbor:Shop;
    final MGY:Shop;
    final FastTasteSSP:Shop;
    final BlaBlaBla:Shop;
    final MyRoomRoom:Shop;
    final ZeppelinHotDogSKM:Shop;
    final ThaiYummy:Shop;
    final Toolss:Shop;
    final KeiHing:Shop;
    final PokeGo:Shop;
    final WoStreet:Shop;
    final AuLawFarm:Shop;
    final Minimal:Shop;
    final CafeGolden:Shop;
    final BlackWindow:Shop;
    final LonelyPaisley:Shop;
    final FishFranSSP:Shop;
    final MxMWorkshop:Shop;
    final HowDrunk:Shop;
    final LoudTeaSSP:Shop;
    final NEVeg:Shop;

    static public final all:ReadOnlyArray<Shop> = [
        EightyNine,
        LaksaStore,
        KCZenzero,
        ThaiHome,
        HanaSoftCream,
        WoStreet,

        FishFranSSP,

        YearsHK,
        LonelyPaisley,

        BiuKeeLokYuen,
        BlackWindow,
        LoudTeaSSP,
        
        TheParkByYears,
        MGY,
        PokeGo,
        Minimal,

        ZeppelinHotDogSKM,
        CafeGolden,
        HowDrunk,

        AuLawFarm,
        MxMWorkshop,
        NEVeg,
    ];

    public function info() return switch (cast this:Shop) {
        case EightyNine:
            {
                id: EightyNine,
                name: "89美食",
                type: Restaurant,
                address: "西九龍中心8樓美食廣場9號舖",
                lat: 22.33133,
                lng: 114.16014,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85263899833" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    // Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:30:00",
                latestPickupTime: "20:30:00",
                isInService: true,
                facebook: "https://www.facebook.com/89food89",
                instagram: null,
                availablity: "提供午餐及晚餐",
                restDay: "逢星期三休息",
                recommendation: "招牌口水雞"
            }
        case ThaiHome:
            {
                id: ThaiHome,
                name: "泰家",
                type: Restaurant,
                address: "西九龍中心8樓59號鋪",
                lat: 22.3311552,
                lng: 114.1596601,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85292919515" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    // Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "13:00:00",
                latestPickupTime: "20:30:00",
                isInService: true,
                facebook: "https://www.facebook.com/ThaiHomeSSP/",
                instagram: null,
                availablity: "提供午餐及晚餐",
                restDay: "逢星期三休息",
                recommendation: null,
            }
        case DragonJapaneseCuisine:
            {
                id: DragonJapaneseCuisine,
                name: "營業部",
                type: Restaurant,
                address: "西九龍中心8樓美食廣場8F35舖",
                lat: null,
                lng: null,
                courierContact: [
                    { name: "店舖WhatsApp", url: "https://wa.me/85265733617" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:30:00",
                latestPickupTime: "20:30:00",
                isInService: false,
                facebook: "https://www.facebook.com/DragonJapaneseCuisine/",
                instagram: "https://www.instagram.com/ramen_department/",
                availablity: "已結業",
                restDay: null,
                recommendation: null
            }
        case YearsHK:
            {
                id: YearsHK,
                name: "Years",
                type: Restaurant,
                address: "深水埗福華街191-199號福隆大廈1號地舖",
                lat: 22.3326012,
                lng: 114.1607882,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85263383719" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:30:00",
                latestPickupTime: "20:30:00",
                isInService: true,
                facebook: "https://www.facebook.com/yearshk",
                instagram: "https://www.instagram.com/years.hk/",
                availablity: "提供午餐及晚餐",
                restDay: null,
                recommendation: "⽇式咖喱吉列豬扒意⼤利飯"
            }
        case TheParkByYears:
            {
                id: TheParkByYears,
                name: "The Park by Years",
                type: Restaurant,
                address: "深水埗汝州街132號地舖",
                lat: 22.3280548,
                lng: 114.1640775,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85253364000" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:30:00",
                latestPickupTime: "20:30:00",
                isInService: true,
                facebook: "https://www.facebook.com/yearshk",
                instagram: "https://www.instagram.com/years.hk/",
                availablity: "提供午餐及晚餐",
                restDay: null,
                recommendation: null
            }
        case LaksaStore:
            {
                id: LaksaStore,
                name: "喇沙專門店",
                type: Restaurant,
                address: "西九龍中心8樓美食廣場",
                lat: 22.33132,
                lng: 114.16017,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85251167518" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    // Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:30:00",
                latestPickupTime: "20:30:00",
                isInService: true,
                facebook: "https://www.facebook.com/LaksaStore",
                instagram: "https://www.instagram.com/dc_laksastore/",
                availablity: "提供午餐及晚餐",
                restDay: "逢星期三休息",
                recommendation: "喇沙雞扒油麵 / 喇沙牛舌油麵"
            }
        case DongDong:
            {
                id: DongDong,
                name: "噹噹茶餐廳",
                type: Restaurant,
                address: "深水埗福華街208號B地下",
                lat: null,
                lng: null,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85223616691" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    // Sunday,
                ],
                earliestPickupTime: "12:00:00",
                latestPickupTime: "18:30:00",
                isInService: false,
                facebook: "https://www.facebook.com/502547383451978",
                instagram: null,
                availablity: "已結業",
                restDay: "逢星期日休息",
                recommendation: null
            }
        case BiuKeeLokYuen:
            {
                id: BiuKeeLokYuen,
                name: "標記樂園潮州粉麵菜館",
                type: Restaurant,
                address: "深水埗福華街149號地舖",
                lat: 22.3313171,
                lng: 114.1624664,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85290691493" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:00:00",
                latestPickupTime: "20:00:00", // https://www.facebook.com/BiuKeeLokYuen/posts/294653269350441
                isInService: true,
                facebook: "https://www.facebook.com/BiuKeeLokYuen",
                instagram: null,
                availablity: "提供午餐及晚餐",
                restDay: null,
                recommendation: "秘製新鮮牛腩 / 彈牙牛丸"
            }
        case KCZenzero:
            {
                id: KCZenzero,
                name: "蕃廚",
                type: Restaurant,
                address: "深水埗欽州街37號西九龍中心8樓57號舖",
                lat: 22.33122,
                lng: 114.15968,
                courierContact: [
                    { name: "店舖WhatsApp", url: "https://wa.me/85268493436" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:30:00",
                latestPickupTime: "20:30:00",
                isInService: true,
                facebook: "https://www.facebook.com/%E8%95%83%E5%BB%9A-KC-Zenzero-102717031546439",
                instagram: "https://www.instagram.com/kc_zenzero0530/",
                availablity: "提供午餐及晚餐",
                restDay: null,
                recommendation: "九龍皇帝熱狗"
            }
        case HanaSoftCream:
            {
                id: HanaSoftCream,
                name: "HANA Soft Cream",
                type: IceCreamShop,
                address: "深水埗欽州街37K西九龍中心6樓628A",
                lat: 22.3309339,
                lng: 114.1597422,
                courierContact: [],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "13:00:00",
                latestPickupTime: "20:30:00",
                isInService: true,
                facebook: "https://www.facebook.com/hanasoftcream",
                instagram: "https://www.instagram.com/hanasoftcream/",
                availablity: "提供午餐及晚餐",
                restDay: null,
                recommendation: "北海道8.0牛奶雪糕"
            }
        case Neighbor:
            {
                id: Neighbor,
                name: "Neighbor",
                type: Restaurant,
                address: "長沙灣元州街162-188號天悅廣場地下A8號舖",
                lat: 22.3351073,
                lng: 114.1598897,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85237020958" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "13:00:00",
                latestPickupTime: "20:30:00",
                isInService: false,
                facebook: "https://www.facebook.com/Neighbor-141971742913793",
                instagram: "https://www.instagram.com/neighbor_csw/",
                availablity: "已結業",
                restDay: null,
                recommendation: "美式牛肉漢堡 / 椰漿脆雞翼"
            }
        case MGY:
            {
                id: MGY,
                name: "梅貴緣",
                type: Restaurant,
                address: "深水埗基隆街188號C舖",
                lat: 22.3281200,
                lng: 114.1630828,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85226606988" },
                    { name: "梅姐電話", url: "tel:+85290180189" },
                ],
                openDays: [
                    // Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:30:00",
                latestPickupTime: "18:30:00",
                isInService: true,
                facebook: "https://www.facebook.com/MGYVEG",
                instagram: "https://www.instagram.com/mgyvegan/",
                availablity: "提供午餐及晚餐",
                restDay: "逢星期一休息",
                recommendation: "羅漢齋烏冬"
            }
        case FastTasteSSP:
            {
                id: FastTasteSSP,
                name: "Fast Taste",
                type: Restaurant,
                address: "深水埗福華街110號地下",
                lat: 22.3312402,
                lng: 114.1628927,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85261628045" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:30:00",
                latestPickupTime: "20:30:00",
                isInService: false,
                facebook: "https://www.facebook.com/fasttastehk",
                instagram: "https://www.instagram.com/fasttaste/",
                availablity: "已結業",
                restDay: null,
                recommendation: "經典牛魔堡 / 德國鹹豬手"
            }
        case BlaBlaBla:
            {
                id: BlaBlaBla,
                name: "壺說",
                type: Restaurant,
                address: "深水埗福華街110號地下",
                lat: null,
                lng: null,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85291433611" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:30:00",
                latestPickupTime: "20:30:00",
                isInService: false,
                facebook: "https://www.facebook.com/blablablatea/",
                instagram: "https://www.instagram.com/blablabla_tea",
                availablity: "已結業",
                restDay: null,
                recommendation: null
            }
        case ZeppelinHotDogSKM:
            {
                id: ZeppelinHotDogSKM,
                name: "齊柏林熱狗 (石硤尾)",
                type: FastFoodRestaurant,
                address: "白田購物中心地下82號鋪",
                lat: 22.3347417,
                lng: 114.1673818,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85255965529" },
                    { name: "店舖WhatsApp", url: "https://wa.me/85255965529" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:30:00",
                latestPickupTime: "20:30:00",
                isInService: false,
                facebook: "https://www.facebook.com/Zeppelin-Hot-Dog-SKM-105039071392745",
                instagram: "https://www.instagram.com/zeppelinhotdogskm",
                availablity: "已結業",
                restDay: "逢21號罷工",
                recommendation: "火炙芝士辣肉醬熱狗"
            }
        case MyRoomRoom:
            {
                id: MyRoomRoom,
                name: "浮島",
                type: Restaurant,
                address: "深水埗褔榮街57號",
                lat: null,
                lng: null,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85267731228" },
                ],
                openDays: [
                    Monday,
                    // Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:30:00",
                latestPickupTime: "20:30:00",
                isInService: false,
                facebook: "https://www.facebook.com/myroomroom",
                instagram: "https://www.instagram.com/myroomroom/",
                availablity: "已結業",
                restDay: "逢星期二休息",
                recommendation: null
            }
        case ThaiYummy:
            {
                id: ThaiYummy,
                name: "泰和味",
                type: Restaurant,
                address: "長沙灣營盤街159-161號金德花園地下1號舖",
                lat: 22.3356232,
                lng: 114.1612154,
                courierContact: [
                    // "tel:+85265047678",
                    { name: "店舖電話", url: "tel:+85290371992" },
                    // "tel:+85290847852"
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "18:30:00",
                latestPickupTime: "20:30:00",
                isInService: false,
                facebook: "https://www.facebook.com/thaiyummyshop/",
                instagram: null,
                availablity: null,
                restDay: null,
                recommendation: null
            }
        case Toolss:
            {
                id: Toolss,
                name: "Toolss",
                type: Restaurant,
                address: "石硤尾偉智街38號福田大廈地下2-3及37號舖",
                lat: 22.3348939,
                lng: 114.1666646,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85239545135" },
                ],
                openDays: [
                    // Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:00:00",
                latestPickupTime: "20:30:00",
                isInService: false,
                facebook: "https://www.facebook.com/toolsshk",
                instagram: "https://www.instagram.com/toolsshk/",
                availablity: "埗兵外賣暫停",
                restDay: "逢星期一休息",
                recommendation: "日式咖喱牛肋肉飯"
            }
        case KeiHing:
            {
                id: KeiHing,
                name: "琦興餐廳",
                type: Restaurant,
                address: "深水埗通州街294號地舖",
                lat: 22.3282303,
                lng: 114.1581067,
                courierContact: [
                    { name: "店舖WhatsApp", url: "https://wa.me/85269530591" },
                    { name: "店舖電話", url: "tel:+85223688896" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:00:00",
                latestPickupTime: "20:30:00",
                isInService: false,
                facebook: "https://www.facebook.com/%E7%90%A6%E8%88%88%E9%A4%90%E5%BB%B3-277683322927183",
                instagram: null,
                availablity: "埗兵外賣暫停",
                restDay: null,
                recommendation: "薑蔥霸王雞 / 琦興雞煲 / 鍋塌豆腐"
            }
        case PokeGo:
            {
                id: PokeGo,
                name: "Poke Go",
                type: Restaurant,
                address: "深水埗大南街211號",
                lat: 22.3275716,
                lng: 114.1626558,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85235638137" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:00:00",
                latestPickupTime: "20:30:00",
                isInService: true,
                facebook: "https://www.facebook.com/PokeGo_hk-103422998663025",
                instagram: "https://www.instagram.com/poke.go_hk/",
                availablity: "提供午餐及晚餐",
                restDay: null,
                recommendation: "Signature Bowl 808"
            }
        case WoStreet:
            {
                id: WoStreet,
                name: "窩Street",
                type: Restaurant,
                address: "西九龍中心6樓蘋果商場6067號舖",
                lat: 22.3310294,
                lng: 114.1595612,
                courierContact: [
                    // "tel:+85251868627",
                    { name: "店員Telegram", url: "https://t.me/dufuhf" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:30:00", //正式開2點, 但店員可提早返去
                latestPickupTime: "18:00:00", //通常6點半就閂
                isInService: false,
                facebook: "https://www.facebook.com/wostreethk/",
                instagram: "https://www.instagram.com/wostreet.hk/",
                availablity: "埗兵外賣暫停",
                restDay: null,
                recommendation: null,
            }
        case AuLawFarm:
            {
                id: AuLawFarm,
                name: "歐羅有機農場",
                type: LocalBusiness,
                address: "新界錦田元朗大江埔村",
                lat: null,
                lng: null,
                courierContact: [],
                openDays: [],
                earliestPickupTime: null,
                latestPickupTime: null,
                isInService: false,
                facebook: "https://www.facebook.com/aulawfarm",
                instagram: "https://www.instagram.com/aulawfarm/",
                availablity: null,
                restDay: null,
                recommendation: null
            }
        case MxMWorkshop:
            {
                id: MxMWorkshop,
                name: "孖陳記",
                type: LocalBusiness,
                address: null,
                lat: null,
                lng: null,
                courierContact: [],
                openDays: [],
                earliestPickupTime: null,
                latestPickupTime: null,
                isInService: false,
                facebook: "https://www.facebook.com/olivemoonbigman",
                instagram: null,
                availablity: null,
                restDay: null,
                recommendation: null
            }
        case NEVeg:
            {
                id: NEVeg,
                name: "東北菜檔",
                type: LocalBusiness,
                address: null,
                lat: null,
                lng: null,
                courierContact: [],
                openDays: [],
                earliestPickupTime: null,
                latestPickupTime: null,
                isInService: false,
                facebook: null,
                instagram: null,
                availablity: null,
                restDay: null,
                recommendation: null
            }
        case Minimal:
            {
                id: Minimal,
                name: "Minimal",
                type: Restaurant,
                address: "深水埗鴨寮街121-123號",
                lat: 22.3288335,
                lng: 114.1636431,
                courierContact: [
                    { name: "店員電話", url: "tel:+85269713921" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:00:00",
                latestPickupTime: "20:00:00", // 晚上8：00 last order
                isInService: true,
                facebook: "https://www.facebook.com/minimalcafehk/",
                instagram: "https://www.instagram.com/minimal_cafehk/",
                availablity: "提供午餐及晚餐",
                restDay: null,
                recommendation: null
            }
        case CafeGolden:
            {
                id: CafeGolden,
                name: "琉金穗月",
                type: Restaurant,
                address: "石硤尾賽馬會創意藝術中心L1-05",
                lat: 22.3348672,
                lng: 114.1658299,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85224088255" },
                ],
                openDays: [
                    Monday,
                    // Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:00:00",
                latestPickupTime: "18:00:00",
                isInService: true,
                facebook: "https://www.facebook.com/%E7%90%89%E9%87%91%E7%A9%97%E6%9C%88-Cafe-Golden-191971954164436",
                instagram: "https://www.instagram.com/cafegoldenhk/",
                availablity: "提供午餐",
                restDay: "逢星期二休息",
                recommendation: "明太子魷魚蟹棒意大利麵"
            }
        case BlackWindow:
            {
                id: BlackWindow,
                name: "黑窗里",
                type: Restaurant,
                address: "深水埗大埔道83號",
                lat: 22.3323587,
                lng: 114.1640008,
                courierContact: [
                    { name: "店舖WhatsApp", url: "https://wa.me/85297478914" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    // Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "13:00:00",
                latestPickupTime: "20:30:00",
                isInService: true,
                facebook: "https://www.facebook.com/openblackwindow",
                instagram: "https://www.instagram.com/blackwindow___/",
                availablity: "提供午餐及晚餐",
                restDay: "逢星期二不提供埗兵外賣, 逢星期三休息",
                recommendation: null
            }
        case LonelyPaisley:
            {
                id: LonelyPaisley,
                name: "Lonely Paisley",
                type: Restaurant,
                address: "深水埗福華街182-186號怡華閣地下A號舖",
                lat: 22.3326258,
                lng: 114.1611061,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85298890250" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:00:00",
                latestPickupTime: "20:30:00",
                isInService: true,
                facebook: "https://www.facebook.com/lonelypaisley",
                instagram: "https://www.instagram.com/lonelypaisley/",
                availablity: "提供午餐及晚餐",
                restDay: null,
                recommendation: null
            }
        case FishFranSSP:
            {
                id: FishFranSSP,
                name: "魚鈁 (深水埗)",
                type: Restaurant,
                address: "深水埗欽洲街58號米蘭軒1樓",
                lat: 22.3306967, 
                lng: 114.1603114,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85229676768" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:00:00",
                latestPickupTime: "20:30:00",
                isInService: true,
                facebook: "https://www.facebook.com/fishfranhk",
                instagram: "https://www.instagram.com/fishfranhk/",
                availablity: "提供午餐及晚餐",
                restDay: null,
                recommendation: null
            }
        case HowDrunk:
            {
                id: HowDrunk,
                name: "杞醉",
                type: Restaurant,
                address: "石硤尾白田商場LG3樓街市MK07號舖",
                lat: 22.3363989,
                lng: 114.1666779,
                courierContact: [
                    { name: "店舖WhatsApp", url: "https://wa.me/85266283190" },
                    // { name: "店舖電話", url: "tel:+85292280274" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:00:00",
                latestPickupTime: "20:00:00",
                isInService: true,
                facebook: "https://www.facebook.com/HowDrunk",
                instagram: "https://www.instagram.com/howdrunk_hongkong/",
                availablity: "提供午餐及晚餐",
                restDay: null,
                recommendation: null
            }
        case LoudTeaSSP:
            {
                id: LoudTeaSSP,
                name: "響茶 (深水埗)",
                type: Restaurant,
                address: "深水埗長沙灣道262號萬利大廈地下B2號舖",
                lat: 22.3318298,
                lng: 114.1612489,
                courierContact: [
                    { name: "店舖電話", url: "tel:+85254489263" },
                ],
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                earliestPickupTime: "12:00:00",
                latestPickupTime: "20:00:00",
                isInService: true,
                facebook: "https://www.facebook.com/profile.php?id=100085657165887",
                instagram: "https://www.instagram.com/loudtea_ssp/",
                availablity: "提供午餐及晚餐",
                restDay: null,
                recommendation: null
            }
    }

    public function checkAvailability(currentTime:Date, pickupTimeSlot:TimeSlot):Availability {
        final info = info();
        final date = pickupTimeSlot.start.toDate();
        final day = Weekday.fromDay(date.getDay());

        switch [(cast this:Shop), pickupTimeSlot.start.getDatePart(), TimeSlotType.classify(pickupTimeSlot.start)] {
            case [DongDong, _, _] if (pickupTimeSlot.start.getDatePart() > "2021-08-26"):
                return Unavailable('已結業 😥');
            case [BlaBlaBla, _, _] if (pickupTimeSlot.start.getDatePart() > "2021-08-29"):
                return Unavailable('已結業 😥');
            case [DragonJapaneseCuisine, _, _] if (pickupTimeSlot.start.getDatePart() > "2021-12-09"):
                return Unavailable('已結業 😥');
            case [FastTasteSSP, _, _] if (pickupTimeSlot.start.getDatePart() > "2022-06-18"):
                return Unavailable('已結業 😥');
            case [Neighbor, _, _] if (pickupTimeSlot.start.getDatePart() > "2022-06-30"):
                return Unavailable('已結業 😥');
            case [ZeppelinHotDogSKM, _, _] if (pickupTimeSlot.start.getDatePart() > "2022-12-31"):
                return Unavailable('已結業 😥');
            case [MGY, _, _] if (pickupTimeSlot.start.getDatePart() > "2023-05-19"):
                return Unavailable('已結業 😥');
            case [ThaiYummy, _, _]:
                return Unavailable('埗兵外賣暫停');

            case [EightyNine, "2023-06-22", _]:
                return Unavailable('休息一天');
            case [ThaiHome, "2023-06-22", _]:
                return Unavailable('休息一天');

            // https://www.facebook.com/LaksaStore/posts/pfbid02uUBW1uzHv397dpGMWw6k4Hu5JFtfmBbevjXMC7mYt2gwdc3SxMGq8c2LE66Vi8rGl
            case [LaksaStore, "2023-05-16", _]:
                return Unavailable('休息一天');

            // https://www.facebook.com/permalink.php?story_fbid=pfbid02MgWi3Qrs5i7LewBwYRJszAvZSvsxUvTrijEQMBCbW1GgQZHnmkPycgy1ZzGzMQ6Gl&id=100064143817671
            case [KCZenzero, "2023-06-15", _]:
                return Unavailable('休息一天');

            // https://www.facebook.com/hanasoftcream/posts/pfbid0MbcNbdRnZqcvEGG8UfN4oozAcK5XB4hR77SESxYqVHMA1STEw3WWjvB3FMBf268Jl
            case [HanaSoftCream, "2023-07-06", Dinner]:
                return Unavailable('晚市暫停一天');

            case [BlackWindow | Minimal | CafeGolden | LaksaStore | KCZenzero, "2023-07-17", Dinner]:
                return Unavailable('天氣關係休息一天');

            case [BlackWindow, _, Dinner] if (pickupTimeSlot.start.getTimePart() < "19:00:00"):
                return Unavailable('晚市最早 19:00 時段交收');

            case [CafeGolden, _, Dinner]:
                return Unavailable('晚市暫停');

            case [WoStreet, _, _]:
                return Unavailable('埗兵外賣暫停');

            case [Toolss, _, _]:
                return Unavailable('埗兵外賣暫停');

            case [KeiHing, _, _]:
                return Unavailable('埗兵外賣暫停');

            case _:
                //pass
        }

        switch [(cast this:Shop), info.openDays.has(day), HkHolidays.isRedDay(date)] {
            case [Toolss, false, false]:
                return Unavailable('逢星期${day.info().name}休息');
            case [Toolss, false, true]: // 紅日+例休 -> 開工, 第二日休息
                //pass
            case [Toolss, true, _] if ((!info.openDays.has(Weekday.fromDay(date.delta(-DateTools.days(1)).getDay()))) && HkHolidays.isRedDay(date.delta(-DateTools.days(1)))):
                return Unavailable('休息一天');
            case [_, false, _]:
                return Unavailable('逢星期${day.info().name}休息');
            case [ZeppelinHotDogSKM, _, _] if (date.getDate() == 21):
                return Unavailable('逢21號罷工');
            case _:
                //pass
        }

        if (pickupTimeSlot.start.getTimePart() < info.earliestPickupTime)
            return Unavailable('最早 ${info.earliestPickupTime.substr(0, 5)} 時段交收');

        if (pickupTimeSlot.start.getTimePart() > info.latestPickupTime)
            return Unavailable('最遲 ${info.latestPickupTime.substr(0, 5)} 時段交收');

        return Available;
    }

    // static public function allItemsSchema(pickupTimeSlot:Null<TimeSlot>, o:FormOrderData):Promise<DynamicAccess<Dynamic>> {
    //     final schemas:Promise<Array<{
    //         shop:Shop,
    //         items:Dynamic,
    //     }>> = cast Promise.all(Shop.all.map(shop -> {
    //         shop:shop,
    //         items: shop.itemsSchema(pickupTimeSlot, o)
    //     }));
    //     return schemas.then(schemas -> {
    //         final all:DynamicAccess<Dynamic> = {};
    //         for (s in schemas)
    //             all[s.shop] = s.items;
    //         all;
    //     });
    // }

    public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, o:FormOrderData):Promise<Dynamic> {
        return switch (cast this:Shop) {
            case EightyNine:
                Promise.resolve(EightyNineMenu.itemsSchema(pickupTimeSlot, o));
            case DragonJapaneseCuisine:
                Promise.resolve(DragonJapaneseCuisineMenu.itemsSchema(o));
            case LaksaStore:
                Promise.resolve(LaksaStoreMenu.itemsSchema(pickupTimeSlot, o));
            case KCZenzero:
                Promise.resolve(KCZenzeroMenu.itemsSchema(pickupTimeSlot, o));
            case HanaSoftCream:
                Promise.resolve(HanaSoftCreamMenu.itemsSchema());
            case DongDong:
                Promise.resolve(DongDongMenu.itemsSchema(pickupTimeSlot, o));
            case FastTasteSSP:
                Promise.resolve(FastTasteSSPMenu.itemsSchema(pickupTimeSlot, o));
            case BiuKeeLokYuen:
                Promise.resolve(BiuKeeLokYuenMenu.itemsSchema(o));
            case BlaBlaBla:
                Promise.resolve(BlaBlaBlaMenu.itemsSchema(o));
            case Neighbor:
                Promise.resolve(NeighborMenu.itemsSchema(o));
            case MGY:
                Promise.resolve(MGYMenu.itemsSchema(pickupTimeSlot, o));
            case YearsHK:
                Promise.resolve(YearsHKMenu.itemsSchema(pickupTimeSlot, o));
            case TheParkByYears:
                Promise.resolve(TheParkByYearsMenu.itemsSchema(pickupTimeSlot, o));
            case ZeppelinHotDogSKM:
                Promise.resolve(ZeppelinHotDogSKMMenu.itemsSchema(pickupTimeSlot, o));
            case MyRoomRoom:
                Promise.resolve(MyRoomRoomMenu.itemsSchema(o));
            case ThaiYummy:
                Promise.resolve(ThaiYummyMenu.itemsSchema(o));
            case Toolss:
                Promise.resolve(ToolssMenu.itemsSchema(o));
            case KeiHing:
                Promise.resolve(KeiHingMenu.itemsSchema(pickupTimeSlot, o));
            case PokeGo:
                Promise.resolve(PokeGoMenu.itemsSchema(o));
            case WoStreet:
                Promise.resolve(WoStreetMenu.itemsSchema(o));
            case Minimal:
                Promise.resolve(MinimalMenu.itemsSchema(o));
            case CafeGolden:
                Promise.resolve(CafeGoldenMenu.itemsSchema(o));
            case BlackWindow:
                BlackWindowMenu.itemsSchema(pickupTimeSlot, o);
            case LonelyPaisley:
                Promise.resolve(LonelyPaisleyMenu.itemsSchema(pickupTimeSlot, o));
            case FishFranSSP:
                Promise.resolve(FishFranSSPMenu.itemsSchema(pickupTimeSlot, o));
            case HowDrunk:
                Promise.resolve(HowDrunkMenu.itemsSchema(pickupTimeSlot, o));
            case LoudTeaSSP:
                Promise.resolve(LoudTeaSSPMenu.itemsSchema(pickupTimeSlot, o));
            case ThaiHome:
                Promise.resolve(ThaiHomeMenu.itemsSchema(pickupTimeSlot, o));
            case AuLawFarm | MxMWorkshop | NEVeg:
                Promise.resolve(null);
        }
    }

    public function summarize(pickupTimeSlot:TimeSlot, o:FormOrderData):Promise<OrderSummary> {
        return switch (cast this:Shop) {
            case BiuKeeLokYuen:
                Promise.resolve(BiuKeeLokYuenMenu.summarize(o));
            case BlaBlaBla:
                Promise.resolve(BlaBlaBlaMenu.summarize(o));
            case DongDong:
                Promise.resolve(DongDongMenu.summarize(o));
            case DragonJapaneseCuisine:
                Promise.resolve(DragonJapaneseCuisineMenu.summarize(o));
            case EightyNine:
                Promise.resolve(EightyNineMenu.summarize(o));
            case FastTasteSSP:
                Promise.resolve(FastTasteSSPMenu.summarize(o, TimeSlotType.classify(pickupTimeSlot.start), HkHolidays.isRedDay(pickupTimeSlot.start)));
            case HanaSoftCream:
                Promise.resolve(HanaSoftCreamMenu.summarize(o));
            case KCZenzero:
                Promise.resolve(KCZenzeroMenu.summarize(o, pickupTimeSlot));
            case LaksaStore:
                Promise.resolve(LaksaStoreMenu.summarize(pickupTimeSlot, o));
            case MGY:
                Promise.resolve(MGYMenu.summarize(pickupTimeSlot, o));
            case Neighbor:
                Promise.resolve(NeighborMenu.summarize(o));
            case TheParkByYears:
                Promise.resolve(TheParkByYearsMenu.summarize(o));
            case YearsHK:
                Promise.resolve(YearsHKMenu.summarize(o));
            case ZeppelinHotDogSKM:
                Promise.resolve(ZeppelinHotDogSKMMenu.summarize(o, pickupTimeSlot));
            case MyRoomRoom:
                Promise.resolve(MyRoomRoomMenu.summarize(o));
            case ThaiYummy:
                Promise.resolve(ThaiYummyMenu.summarize(o));
            case Toolss:
                Promise.resolve(ToolssMenu.summarize(o));
            case KeiHing:
                Promise.resolve(KeiHingMenu.summarize(o, pickupTimeSlot));
            case PokeGo:
                Promise.resolve(PokeGoMenu.summarize(o));
            case WoStreet:
                Promise.resolve(WoStreetMenu.summarize(o));
            case Minimal:
                Promise.resolve(MinimalMenu.summarize(o));
            case CafeGolden:
                Promise.resolve(CafeGoldenMenu.summarize(o));
            case BlackWindow:
                BlackWindowMenu.summarize(o, pickupTimeSlot);
            case LonelyPaisley:
                Promise.resolve(LonelyPaisleyMenu.summarize(o));
            case FishFranSSP:
                Promise.resolve(FishFranSSPMenu.summarize(o));
            case HowDrunk:
                Promise.resolve(HowDrunkMenu.summarize(o, pickupTimeSlot));
            case LoudTeaSSP:
                Promise.resolve(LoudTeaSSPMenu.summarize(pickupTimeSlot, o));
            case ThaiHome:
                Promise.resolve(ThaiHomeMenu.summarize(o));
            case AuLawFarm | MxMWorkshop | NEVeg:
                Promise.resolve(null);
        }
    }

    static public function fromId(shopId:String):Null<Shop> {
        return switch (shopId) {
            case EightyNine: EightyNine;
            case DragonJapaneseCuisine: DragonJapaneseCuisine;
            case YearsHK: YearsHK;
            case TheParkByYears: TheParkByYears;
            case LaksaStore: LaksaStore;
            case DongDong: DongDong;
            case BiuKeeLokYuen: BiuKeeLokYuen;
            case KCZenzero: KCZenzero;
            case HanaSoftCream: HanaSoftCream;
            case Neighbor: Neighbor;
            case MGY: MGY;
            case FastTasteSSP: FastTasteSSP;
            case BlaBlaBla: BlaBlaBla;
            case ZeppelinHotDogSKM: ZeppelinHotDogSKM;
            case MyRoomRoom: MyRoomRoom;
            case ThaiYummy: ThaiYummy;
            case Toolss: Toolss;
            case KeiHing: KeiHing;
            case PokeGo: PokeGo;
            case WoStreet: WoStreet;
            case AuLawFarm: AuLawFarm;
            case MxMWorkshop: MxMWorkshop;
            case NEVeg: NEVeg;
            case Minimal: Minimal;
            case CafeGolden: CafeGolden;
            case BlackWindow: BlackWindow;
            case LonelyPaisley: LonelyPaisley;
            case FishFranSSP: FishFranSSP;
            case HowDrunk: HowDrunk;
            case LoudTeaSSP: LoudTeaSSP;
            case ThaiHome: ThaiHome;
            case _: null;
        }
    }
}