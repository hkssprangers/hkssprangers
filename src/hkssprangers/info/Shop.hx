package hkssprangers.info;

import haxe.ds.ReadOnlyArray;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.Weekday;
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
                latestPickupTime: "20:30:00",
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
    }

    public function checkAvailability(pickupTimeSlot:TimeSlot):Availability {
        var info = info();

        if (!info.openDays.has(Weekday.fromDay(pickupTimeSlot.start.toDate().getDay())))
            return Unavailable('休息');

        if (pickupTimeSlot.start.getTimePart() < info.earliestPickupTime)
            return Unavailable('最早 ${info.earliestPickupTime.substr(0, 5)} 時段交收');

        if (pickupTimeSlot.start.getTimePart() > info.latestPickupTime)
            return Unavailable('最遲 ${info.latestPickupTime.substr(0, 5)} 時段交收');

        return Available;
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
            case _: null;
        }
    }
}