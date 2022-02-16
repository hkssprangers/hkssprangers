package hkssprangers.info;

import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.Weekday;
import hkssprangers.info.menu.*;
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
    ];

    public function info() return switch (cast this:Shop) {
        case EightyNine:
            {
                id: EightyNine,
                name: "89美食",
                address: "西九龍中心8樓美食廣場9號舖",
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
                courierContact: [
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
                earliestPickupTime: "18:00:00",
                latestPickupTime: "20:00:00",
                isInService: true,
            }
    }

    public function checkAvailability(currentTime:Date, pickupTimeSlot:TimeSlot):Availability {
        var info = info();
        var date = pickupTimeSlot.start.toDate();
        var day = Weekday.fromDay(date.getDay());

        switch [(cast this:Shop), pickupTimeSlot.start.getDatePart(), TimeSlotType.classify(pickupTimeSlot.start)] {
            case [DongDong, _, _] if (pickupTimeSlot.start.getDatePart() > "2021-08-26"):
                return Unavailable('已結業 😥');
            case [BlaBlaBla, _, _] if (pickupTimeSlot.start.getDatePart() > "2021-08-29"):
                return Unavailable('已結業 😥');
            case [DragonJapaneseCuisine, _, _] if (pickupTimeSlot.start.getDatePart() > "2021-12-09"):
                return Unavailable('已結業 😥');
            case [ThaiYummy, _, _]:
                return Unavailable('埗兵外賣暫停');

            case [FastTasteSSP, "2022-02-14", _]:
                return Unavailable('暫停接單');

            case [FastTasteSSP, _, Dinner]:
                return Unavailable('晚市暫停');

            // https://www.facebook.com/LaksaStore/posts/3133143530277470
            case [LaksaStore, _, _]:
                return Unavailable('傷了腿, 暫定休息一星期');

            // https://www.facebook.com/permalink.php?story_fbid=472154921269313&id=102717031546439
            case [KCZenzero, "2022-02-17", _]:
                return Unavailable('休息一天');

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

    public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, o:FormOrderData):Dynamic {
        return switch (cast this:Shop) {
            case EightyNine:
                EightyNineMenu.itemsSchema();
            case DragonJapaneseCuisine:
                DragonJapaneseCuisineMenu.itemsSchema(o);
            case LaksaStore:
                LaksaStoreMenu.itemsSchema(pickupTimeSlot, o);
            case KCZenzero:
                KCZenzeroMenu.itemsSchema(pickupTimeSlot, o);
            case HanaSoftCream:
                HanaSoftCreamMenu.itemsSchema();
            case DongDong:
                DongDongMenu.itemsSchema(pickupTimeSlot, o);
            case FastTasteSSP:
                FastTasteSSPMenu.itemsSchema(pickupTimeSlot, o);
            case BiuKeeLokYuen:
                BiuKeeLokYuenMenu.itemsSchema(o);
            case BlaBlaBla:
                BlaBlaBlaMenu.itemsSchema(o);
            case Neighbor:
                NeighborMenu.itemsSchema(o);
            case MGY:
                MGYMenu.itemsSchema(o);
            case YearsHK:
                YearsHKMenu.itemsSchema(o);
            case TheParkByYears:
                TheParkByYearsMenu.itemsSchema(pickupTimeSlot, o);
            case ZeppelinHotDogSKM:
                ZeppelinHotDogSKMMenu.itemsSchema(pickupTimeSlot, o);
            case MyRoomRoom:
                MyRoomRoomMenu.itemsSchema(o);
            case ThaiYummy:
                ThaiYummyMenu.itemsSchema(o);
            case Toolss:
                ToolssMenu.itemsSchema(o);
            case KeiHing:
                KeiHingMenu.itemsSchema(pickupTimeSlot, o);
            case PokeGo:
                PokeGoMenu.itemsSchema(o);
            case WoStreet:
                WoStreetMenu.itemsSchema(o);
        }
    }

    public function summarize(pickupTimeSlot:TimeSlot, o:FormOrderData):OrderSummary {
        return switch (cast this:Shop) {
            case BiuKeeLokYuen:
                BiuKeeLokYuenMenu.summarize(o);
            case BlaBlaBla:
                BlaBlaBlaMenu.summarize(o);
            case DongDong:
                DongDongMenu.summarize(o);
            case DragonJapaneseCuisine:
                DragonJapaneseCuisineMenu.summarize(o);
            case EightyNine:
                EightyNineMenu.summarize(o);
            case FastTasteSSP:
                FastTasteSSPMenu.summarize(o, TimeSlotType.classify(pickupTimeSlot.start), HkHolidays.isRedDay(pickupTimeSlot.start));
            case HanaSoftCream:
                HanaSoftCreamMenu.summarize(o);
            case KCZenzero:
                KCZenzeroMenu.summarize(o, TimeSlotType.classify(pickupTimeSlot.start));
            case LaksaStore:
                LaksaStoreMenu.summarize(pickupTimeSlot, o);
            case MGY:
                MGYMenu.summarize(o);
            case Neighbor:
                NeighborMenu.summarize(o);
            case TheParkByYears:
                TheParkByYearsMenu.summarize(o);
            case YearsHK:
                YearsHKMenu.summarize(o);
            case ZeppelinHotDogSKM:
                ZeppelinHotDogSKMMenu.summarize(o, pickupTimeSlot);
            case MyRoomRoom:
                MyRoomRoomMenu.summarize(o);
            case ThaiYummy:
                ThaiYummyMenu.summarize(o);
            case Toolss:
                ToolssMenu.summarize(o);
            case KeiHing:
                KeiHingMenu.summarize(o);
            case PokeGo:
                PokeGoMenu.summarize(o);
            case WoStreet:
                WoStreetMenu.summarize(o);
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
            case _: null;
        }
    }
}