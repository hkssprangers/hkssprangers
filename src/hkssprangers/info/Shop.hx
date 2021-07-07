package hkssprangers.info;

import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.Weekday;
import hkssprangers.info.menu.*;
using Lambda;

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

    static public final all:ReadOnlyArray<Shop> = [
        EightyNine,
        DragonJapaneseCuisine,
        YearsHK,
        TheParkByYears,
        LaksaStore,
        DongDong,
        BiuKeeLokYuen,
        KCZenzero,
        HanaSoftCream,
        Neighbor,
        MGY,
        FastTasteSSP,
        BlaBlaBla,
        MyRoomRoom,
        ZeppelinHotDogSKM,
        ThaiYummy,
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
                latestPickupTime: "20:30:00",
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
            }
        case MGY:
            {
                id: MGY,
                name: "梅貴緣",
                address: "深水埗基隆街188號C舖",
                courierContact: [
                    "tel:26606988",
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
            }
        case ThaiYummy:
            {
                id: ThaiYummy,
                name: "泰和味",
                address: "長沙灣營盤街159-161號金德花園地下1號舖",
                courierContact: [
                    "tel:65047678",
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
            }
    }

    public function checkAvailability(pickupTimeSlot:TimeSlot):Availability {
        var info = info();
        var date = pickupTimeSlot.start.toDate();
        var day = Weekday.fromDay(date.getDay());
        if (!info.openDays.has(day))
            return Unavailable('逢星期${day.info().name}休息');

        switch (cast this:Shop) {
            case ZeppelinHotDogSKM:
                if (date.getDate() == 21)
                    return Unavailable('逢21號罷工');
            case MyRoomRoom:
                return Unavailable('埗兵外賣不日開放');
            case _:
                //pass
        }

        switch [(cast this:Shop), pickupTimeSlot.start.getDatePart(), TimeSlotType.classify(pickupTimeSlot.start)] {
            case [_, "2021-07-11", _]:
                return Unavailable('埗兵有喜 休息一天');
            case [LaksaStore, "2021-05-18", _]:
                return Unavailable('喇沙女皇壽辰休息一天');
            case [KCZenzero, "2021-05-25" | "2021-05-26", _]:
                return Unavailable('家中有事，休息');
            case [DongDong | MGY, "2021-06-14", _]:
                return Unavailable('端午節休息一天');
            case [BlaBlaBla, "2021-06-17", _]:
                return Unavailable('暫停營業');
            case [DragonJapaneseCuisine, "2021-06-17", Dinner]:
                return Unavailable('17/6 早收');
            case [LaksaStore, "2021-06-19", _]:
                return Unavailable('休息一天');
            case [DongDong, "2021-06-28", _]:
                return Unavailable('黑雨休息一天');
            case [ZeppelinHotDogSKM, "2021-07-05", _]:
                return Unavailable('裝修 休息一天');
            case [HanaSoftCream, "2021-07-05" | "2021-07-06", Dinner]:
                return Unavailable('收早');
            case _:
                //pass
        }

        if (pickupTimeSlot.start.getTimePart() < info.earliestPickupTime)
            return Unavailable('最早 ${info.earliestPickupTime.substr(0, 5)} 時段交收');

        if (pickupTimeSlot.start.getTimePart() > info.latestPickupTime)
            return Unavailable('最遲 ${info.latestPickupTime.substr(0, 5)} 時段交收');

        return Available;
    }

    public function itemsSchema(pickupTimeSlot:Null<TimeSlot>, o:FormOrderData):Dynamic {
        return switch (cast this:Shop) {
            case EightyNine:
                EightyNineMenu.itemsSchema();
            case DragonJapaneseCuisine:
                DragonJapaneseCuisineMenu.itemsSchema(o);
            case LaksaStore:
                LaksaStoreMenu.itemsSchema(o);
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
                TheParkByYearsMenu.itemsSchema(o);
            case ZeppelinHotDogSKM:
                ZeppelinHotDogSKMMenu.itemsSchema(pickupTimeSlot, o);
            case MyRoomRoom:
                MyRoomRoomMenu.itemsSchema(o);
            case ThaiYummy:
                ThaiYummyMenu.itemsSchema(o);
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
                LaksaStoreMenu.summarize(o);
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
            case _: null;
        }
    }
}