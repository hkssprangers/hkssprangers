package hkssprangers.info;

import hkssprangers.info.menu.EightyNineItem;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.Weekday;
using Lambda;

enum abstract Shop<T>(String) to String {
    var EightyNine:Shop<EightyNineItem>;
    var DragonJapaneseCuisine:Shop<Dynamic>;
    var YearsHK:Shop<Dynamic>;
    var LaksaStore:Shop<Dynamic>;
    var DongDong:Shop<Dynamic>;
    var BiuKeeLokYuen:Shop<Dynamic>;
    var KCZenzero:Shop<Dynamic>;
    var HanaSoftCream:Shop<Dynamic>;
    var Neighbor:Shop<Dynamic>;
    var MGY:Shop<Dynamic>;

    public function info() return switch (cast this:Shop<T>) {
        case EightyNine:
            {
                id: EightyNine,
                name: "89美食",
                address: "西九龍中心8樓美食廣場9號舖",
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                timeSlots: [
                    {
                        type: Lunch,
                        start: "12:30",
                        end: "13:30"
                    },
                    {
                        type: Lunch,
                        start: "13:30",
                        end: "14:30"
                    },
                    {
                        type: Dinner,
                        start: "19:00",
                        end: "20:00"
                    },
                    {
                        type: Dinner,
                        start: "20:00",
                        end: "21:00"
                    },
                ]
            }
        case DragonJapaneseCuisine:
            {
                id: DragonJapaneseCuisine,
                name: "營業部",
                address: "西九龍中心8樓美食廣場8F35舖",
                openDays: [
                    Monday,
                    // Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                timeSlots: [
                    {
                        type: Lunch,
                        start: "12:30",
                        end: "13:30"
                    },
                    {
                        type: Lunch,
                        start: "13:30",
                        end: "14:30"
                    },
                    {
                        type: Dinner,
                        start: "19:00",
                        end: "20:00"
                    },
                    {
                        type: Dinner,
                        start: "20:00",
                        end: "21:00"
                    },
                ]
            }
        case YearsHK:
            {
                id: YearsHK,
                name: "Years",
                address: "深水埗福華街191-199號福隆大廈1號地舖",
                openDays: [
                    Monday,
                    Tuesday,
                    Wednesday,
                    Thursday,
                    Friday,
                    Saturday,
                    Sunday,
                ],
                timeSlots: [
                    {
                        type: Lunch,
                        start: "12:30",
                        end: "13:30"
                    },
                    {
                        type: Lunch,
                        start: "13:30",
                        end: "14:30"
                    },
                    {
                        type: Dinner,
                        start: "19:00",
                        end: "20:00"
                    },
                    {
                        type: Dinner,
                        start: "20:00",
                        end: "21:00"
                    },
                ]
            }
            case LaksaStore:
                {
                    id: LaksaStore,
                    name: "喇沙專門店",
                    address: "西九龍中心8樓美食廣場",
                    openDays: [
                        Monday,
                        Tuesday,
                        // Wednesday,
                        Thursday,
                        Friday,
                        Saturday,
                        Sunday,
                    ],
                    timeSlots: [
                        {
                            type: Lunch,
                            start: "12:30",
                            end: "13:30"
                        },
                        {
                            type: Lunch,
                            start: "13:30",
                            end: "14:30"
                        },
                        {
                            type: Dinner,
                            start: "19:00",
                            end: "20:00"
                        },
                        {
                            type: Dinner,
                            start: "20:00",
                            end: "21:00"
                        },
                    ]
                }
            case DongDong:
                {
                    id: DongDong,
                    name: "噹噹茶餐廳",
                    address: "深水埗福華街208號B地下",
                    openDays: [
                        Monday,
                        Tuesday,
                        Wednesday,
                        Thursday,
                        Friday,
                        Saturday,
                        // Sunday,
                    ],
                    timeSlots: [
                        {
                            type: Lunch,
                            start: "12:30",
                            end: "13:30"
                        },
                        {
                            type: Lunch,
                            start: "13:30",
                            end: "14:30"
                        },
                        {
                            type: Dinner,
                            start: "19:00",
                            end: "20:00"
                        },
                        {
                            type: Dinner,
                            start: "20:00",
                            end: "21:00"
                        },
                    ]
                }
            case BiuKeeLokYuen:
                {
                    id: BiuKeeLokYuen,
                    name: "標記樂園潮州粉麵菜館",
                    address: "深水埗福華街149號地舖",
                    openDays: [
                        Monday,
                        Tuesday,
                        Wednesday,
                        Thursday,
                        Friday,
                        Saturday,
                        Sunday,
                    ],
                    timeSlots: [
                        {
                            type: Lunch,
                            start: "12:30",
                            end: "13:30"
                        },
                        {
                            type: Lunch,
                            start: "13:30",
                            end: "14:30"
                        },
                        {
                            type: Dinner,
                            start: "19:00",
                            end: "20:00"
                        },
                        {
                            type: Dinner,
                            start: "20:00",
                            end: "21:00"
                        },
                    ]
                }
            case KCZenzero:
                {
                    id: KCZenzero,
                    name: "蕃廚",
                    address: "深水埗欽州街37號西九龍中心8樓57號舖",
                    openDays: [
                        Monday,
                        Tuesday,
                        Wednesday,
                        Thursday,
                        Friday,
                        Saturday,
                        Sunday,
                    ],
                    timeSlots: [
                        {
                            type: Lunch,
                            start: "12:30",
                            end: "13:30"
                        },
                        {
                            type: Lunch,
                            start: "13:30",
                            end: "14:30"
                        },
                        {
                            type: Dinner,
                            start: "19:00",
                            end: "20:00"
                        },
                        {
                            type: Dinner,
                            start: "20:00",
                            end: "21:00"
                        },
                    ]
                }
            case HanaSoftCream:
                {
                    id: HanaSoftCream,
                    name: "HANA Soft Cream",
                    address: "深水埗欽州街37K西九龍中心6樓628A",
                    openDays: [
                        Monday,
                        Tuesday,
                        Wednesday,
                        Thursday,
                        Friday,
                        Saturday,
                        Sunday,
                    ],
                    timeSlots: [
                        {
                            type: Lunch,
                            start: "12:30",
                            end: "13:30"
                        },
                        {
                            type: Lunch,
                            start: "13:30",
                            end: "14:30"
                        },
                        {
                            type: Dinner,
                            start: "19:00",
                            end: "20:00"
                        },
                        {
                            type: Dinner,
                            start: "20:00",
                            end: "21:00"
                        },
                    ]
                }
            case Neighbor:
                {
                    id: Neighbor,
                    name: "Neighbor",
                    address: "長沙灣元州街162-188號天悅廣場地下A8號舖",
                    openDays: [
                        Monday,
                        Tuesday,
                        Wednesday,
                        Thursday,
                        Friday,
                        Saturday,
                        Sunday,
                    ],
                    timeSlots: [
                        {
                            type: Lunch,
                            start: "13:00",
                            end: "13:30"
                        },
                        {
                            type: Lunch,
                            start: "13:30",
                            end: "14:30"
                        },
                        {
                            type: Dinner,
                            start: "19:00",
                            end: "20:00"
                        },
                        {
                            type: Dinner,
                            start: "20:00",
                            end: "21:00"
                        },
                    ]
                }
            case MGY:
                {
                    id: MGY,
                    name: "梅貴緣",
                    address: "深水埗基隆街188號C舖",
                    openDays: [
                        // Monday,
                        Tuesday,
                        Wednesday,
                        Thursday,
                        Friday,
                        Saturday,
                        Sunday,
                    ],
                    timeSlots: [
                        {
                            type: Lunch,
                            start: "12:30",
                            end: "13:30"
                        },
                        {
                            type: Lunch,
                            start: "13:30",
                            end: "14:30"
                        },
                        {
                            type: Dinner,
                            start: "19:00",
                            end: "20:00"
                        },
                        {
                            type: Dinner,
                            start: "20:00",
                            end: "21:00"
                        },
                    ]
                }
    }

    public function nextTimeSlots(currentTime:Date):Array<TimeSlot & { isOff:Bool }> {
        var info = (cast this:Shop<Dynamic>).info();
        var today = DateTools.format(currentTime, "%Y-%m-%d");
        var tmr = DateTools.format(Date.fromTime(currentTime.getTime() + DateTools.days(1)), "%Y-%m-%d");

        // prepare slots more than we need and then filter them in the next step
        var slots =
            info.timeSlots.map(slot -> {
                type: slot.type,
                cutoff: Date.fromString(today + " " + slot.type.info().cutoffTime + ":00"),
                start: Date.fromString(today + " " + slot.start + ":00"),
                end: Date.fromString(today + " " + slot.end + ":00"),
            }).concat(info.timeSlots.map(slot -> {
                type: slot.type,
                cutoff: Date.fromString(tmr + " " + slot.type.info().cutoffTime + ":00"),
                start: Date.fromString(tmr + " " + slot.start + ":00"),
                end: Date.fromString(tmr + " " + slot.end + ":00"),
            }));

        return slots
            .filter(slot -> slot.cutoff.getTime() > currentTime.getTime())
            .slice(0, 4)
            .map(slot -> {
                type: slot.type,
                start: (slot.start:LocalDateString),
                end: (slot.end:LocalDateString),
                isOff: switch [info.id, DateTools.format(slot.start, "%Y-%m-%d"), slot.type] {
                    case [EightyNine, "2020-08-17", _]:
                        true;
                    case _:
                        !info.openDays.exists(d -> d.info().day == slot.start.getDay());
                }
            });
    }
}