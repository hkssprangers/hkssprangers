package hkssprangers.info;

import hkssprangers.info.menu.EightyNineItem;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.Weekday;
using Lambda;

enum abstract Shop(String) to String {
    var EightyNine:Shop;
    var DragonJapaneseCuisine:Shop;
    var YearsHK:Shop;
    var LaksaStore:Shop;
    var DongDong:Shop;
    var BiuKeeLokYuen:Shop;
    var KCZenzero:Shop;
    var HanaSoftCream:Shop;
    var Neighbor:Shop;
    var MGY:Shop;
    var FastTasteSSP:Shop;
    var BlaBlaBla:Shop;

    static public final all = [
        EightyNine,
        DragonJapaneseCuisine,
        YearsHK,
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
                    // Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
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
                }
    }

    static public function fromId(shopId:String):Shop {
        return switch (shopId) {
            case EightyNine: EightyNine;
            case DragonJapaneseCuisine: DragonJapaneseCuisine;
            case YearsHK: YearsHK;
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