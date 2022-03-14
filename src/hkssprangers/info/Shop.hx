package hkssprangers.info;

import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.Weekday;
import hkssprangers.info.menu.*;
import js.lib.Promise;
using Lambda;
using DateTools;

enum abstract Shop(String) to String {
    final EightyNine:Shop;
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

    static public final all:ReadOnlyArray<Shop> = [
        EightyNine,
        YearsHK,
        TheParkByYears,
        LaksaStore,
        BiuKeeLokYuen,
        KCZenzero,
        HanaSoftCream,
        Neighbor,
        MGY,
        FastTasteSSP,
        ZeppelinHotDogSKM,
        ThaiYummy,
        Toolss,
        KeiHing,
        PokeGo,
        WoStreet,
        Minimal,
        CafeGolden,
        AuLawFarm,
    ];

    public function info() return switch (cast this:Shop) {
        case EightyNine:
            {
                id: EightyNine,
                name: "89美食",
                address: "西九龍中心8樓美食廣場9號舖",
                lat: 22.33133,
                lng: 114.16014,
                courierContact: [
                    "tel:63899833",
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
            }
        case DragonJapaneseCuisine:
            {
                id: DragonJapaneseCuisine,
                name: "營業部",
                address: "西九龍中心8樓美食廣場8F35舖",
                lat: null,
                lng: null,
                courierContact: [
                    "https://wa.me/85265733617",
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
            }
        case YearsHK:
            {
                id: YearsHK,
                name: "Years",
                address: "深水埗福華街191-199號福隆大廈1號地舖",
                lat: 22.3326012,
                lng: 114.1607882,
                courierContact: [
                    "tel:63383719",
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
            }
        case TheParkByYears:
            {
                id: TheParkByYears,
                name: "The Park by Years",
                address: "深水埗汝州街132號地舖",
                lat: 22.3280548,
                lng: 114.1640775,
                courierContact: [
                    "tel:53364000",
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
            }
        case LaksaStore:
            {
                id: LaksaStore,
                name: "喇沙專門店",
                address: "西九龍中心8樓美食廣場",
                lat: 22.33132,
                lng: 114.16017,
                courierContact: [
                    "tel:51167518",
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
            }
        case DongDong:
            {
                id: DongDong,
                name: "噹噹茶餐廳",
                address: "深水埗福華街208號B地下",
                lat: null,
                lng: null,
                courierContact: [
                    "tel:23616691",
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
                isInService: true,
            }
        case BiuKeeLokYuen:
            {
                id: BiuKeeLokYuen,
                name: "標記樂園潮州粉麵菜館",
                address: "深水埗福華街149號地舖",
                lat: 22.3313171,
                lng: 114.1624664,
                courierContact: [
                    "tel:90691493",
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
            }
        case KCZenzero:
            {
                id: KCZenzero,
                name: "蕃廚",
                address: "深水埗欽州街37號西九龍中心8樓57號舖",
                lat: 22.33122,
                lng: 114.15968,
                courierContact: [
                    "https://wa.me/85293428231",
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
            }
        case HanaSoftCream:
            {
                id: HanaSoftCream,
                name: "HANA Soft Cream",
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
                earliestPickupTime: "12:30:00",
                latestPickupTime: "20:30:00",
                isInService: true,
            }
        case Neighbor:
            {
                id: Neighbor,
                name: "Neighbor",
                address: "長沙灣元州街162-188號天悅廣場地下A8號舖",
                lat: 22.3351073,
                lng: 114.1598897,
                courierContact: [
                    "tel:37020958",
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
                isInService: true,
            }
        case MGY:
            {
                id: MGY,
                name: "梅貴緣",
                address: "深水埗基隆街188號C舖",
                lat: 22.3281200,
                lng: 114.1630828,
                courierContact: [
                    "tel:90180189",
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
                latestPickupTime: "20:00:00",
                isInService: true,
            }
        case FastTasteSSP:
            {
                id: FastTasteSSP,
                name: "Fast Taste (SSP)",
                address: "深水埗福華街110號地下",
                lat: 22.3312402,
                lng: 114.1628927,
                courierContact: [
                    "tel:61628045",
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
            }
        case BlaBlaBla:
            {
                id: BlaBlaBla,
                name: "壺說",
                address: "深水埗福華街110號地下",
                lat: null,
                lng: null,
                courierContact: [
                    "tel:91433611",
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
            }
        case ZeppelinHotDogSKM:
            {
                id: ZeppelinHotDogSKM,
                name: "齊柏林熱狗 (石硤尾)",
                address: "白田購物中心地下82號鋪",
                lat: 22.3347417,
                lng: 114.1673818,
                courierContact: [
                    "tel:55965529",
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
            }
        case MyRoomRoom:
            {
                id: MyRoomRoom,
                name: "浮島",
                address: "深水埗褔榮街57號",
                lat: null,
                lng: null,
                courierContact: [
                    "tel:67731228",
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
            }
        case ThaiYummy:
            {
                id: ThaiYummy,
                name: "泰和味",
                address: "長沙灣營盤街159-161號金德花園地下1號舖",
                lat: 22.3356232,
                lng: 114.1612154,
                courierContact: [
                    // "tel:65047678",
                    "tel:90371992",
                    // "tel:90847852"
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
                isInService: true,
            }
        case Toolss:
            {
                id: Toolss,
                name: "Toolss",
                address: "石硤尾偉智街38號福田大廈地下2-3及37號舖",
                lat: 22.3348939,
                lng: 114.1666646,
                courierContact: [
                    "tel:39545135",
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
                isInService: true,
            }
        case KeiHing:
            {
                id: KeiHing,
                name: "琦興餐廳",
                address: "深水埗通州街294號地舖",
                lat: 22.3282303,
                lng: 114.1581067,
                courierContact: [
                    "https://wa.me/85269530591",
                    "tel:23688896",
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
            }
        case PokeGo:
            {
                id: PokeGo,
                name: "Poke Go",
                address: "深水埗大南街211號",
                lat: 22.3275716,
                lng: 114.1626558,
                courierContact: [
                    "tel:35638137",
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
            }
        case WoStreet:
            {
                id: WoStreet,
                name: "窩Street",
                address: "西九龍中心6樓蘋果商場6067號舖",
                lat: 22.3310294,
                lng: 114.1595612,
                courierContact: [
                    // "tel:51868627",
                    "https://t.me/dufuhf",
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
                earliestPickupTime: "18:00:00", //開2點
                latestPickupTime: "18:00:00", //通常6點半就閂
                isInService: true,
            }
        case AuLawFarm:
            {
                id: AuLawFarm,
                name: "歐羅有機農場",
                address: "新界錦田元朗大江埔村",
                lat: null,
                lng: null,
                courierContact: [],
                openDays: [],
                earliestPickupTime: null,
                latestPickupTime: null,
                isInService: false,
            }
        case Minimal:
            {
                id: Minimal,
                name: "Minimal",
                address: "深水埗鴨寮街121-123號",
                lat: 22.3288335,
                lng: 114.1636431,
                courierContact: [
                    "tel:69713921",
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
            }
        case CafeGolden:
            {
                id: CafeGolden,
                name: "琉金穗月",
                address: "石硤尾賽馬會創意藝術中心L1-05",
                lat: 22.3348672,
                lng: 114.1658299,
                courierContact: [
                    "tel:24088255",
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
                latestPickupTime: "18:00:00",
                isInService: true,
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
            case [ThaiYummy, _, _]:
                return Unavailable('埗兵外賣暫停');

            // https://www.facebook.com/permalink.php?story_fbid=487920659692739&id=102717031546439
            case [KCZenzero, "2022-03-14", _]:
                return Unavailable('休息一天');

            case [CafeGolden, "2022-03-15", _]:
                return Unavailable('休息一天');

            case [CafeGolden, _, Dinner]:
                return Unavailable('晚市暫停');

            case [WoStreet, _, _]:
                return Unavailable('暫停營業');

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

        var hoursToPickup = (pickupTimeSlot.start.toDate().getTime() - currentTime.getTime()) / 3.6e+6;
        switch (cast this:Shop) {
            case ThaiYummy:
                if (hoursToPickup < 1.0)
                    return Unavailable('食物製作需要最少1小時');
            case _:
                //pass
        }

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
                Promise.resolve(EightyNineMenu.itemsSchema());
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
                Promise.resolve(MGYMenu.itemsSchema(o));
            case YearsHK:
                Promise.resolve(YearsHKMenu.itemsSchema(o));
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
            case AuLawFarm:
                Promise.resolve(null);
            case Minimal:
                Promise.resolve(MinimalMenu.itemsSchema(o));
            case CafeGolden:
                Promise.resolve(CafeGoldenMenu.itemsSchema(o));
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
                Promise.resolve(KCZenzeroMenu.summarize(o, TimeSlotType.classify(pickupTimeSlot.start)));
            case LaksaStore:
                Promise.resolve(LaksaStoreMenu.summarize(pickupTimeSlot, o));
            case MGY:
                Promise.resolve(MGYMenu.summarize(o));
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
                Promise.resolve(KeiHingMenu.summarize(o));
            case PokeGo:
                Promise.resolve(PokeGoMenu.summarize(o));
            case WoStreet:
                Promise.resolve(WoStreetMenu.summarize(o));
            case AuLawFarm:
                Promise.resolve(null);
            case Minimal:
                Promise.resolve(MinimalMenu.summarize(o));
            case CafeGolden:
                Promise.resolve(CafeGoldenMenu.summarize(o));
        }
    }

    static public function fromId(shopId:String):Shop {
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
            case Minimal: Minimal;
            case CafeGolden: CafeGolden;
            case _: null;
        }
    }
}