package hkssprangers.info;

using hkssprangers.info.Info.TgTools;
using hkssprangers.info.Info.OrderTools;
using hkssprangers.info.Info.TimeSlotTools;
using Lambda;

enum abstract Weekday(String) {
    var Monday;
    var Tuesday;
    var Wednesday;
    var Thursday;
    var Friday;
    var Saturday;
    var Sunday;

    static public function fromDay(day:Int) return switch (day % 7) {
        case 1: Monday;
        case 2: Tuesday;
        case 3: Wednesday;
        case 4: Thursday;
        case 5: Friday;
        case 6: Saturday;
        case 0: Sunday;
        case _: throw "unknown day";
    }

    public function info() return switch (cast this:Weekday) {
        case Monday:
            {
                id: Monday,
                name: "一",
                day: 1,
            }
        case Tuesday:
            {
                id: Tuesday,
                name: "二",
                day: 2,
            }
        case Wednesday:
            {
                id: Wednesday,
                name: "三",
                day: 3,
            }
        case Thursday:
            {
                id: Thursday,
                name: "四",
                day: 4,
            }
        case Friday:
            {
                id: Friday,
                name: "五",
                day: 5,
            }
        case Saturday:
            {
                id: Saturday,
                name: "六",
                day: 6,
            }
        case Sunday:
            {
                id: Sunday,
                name: "日",
                day: 0,
            }
    }
}

abstract LocalDateString(String) to String {
    @:to
    static public function toDate(dateString:String) return Date.fromString(dateString);

    @:from
    static public function fromString(str:String):LocalDateString return fromDate(Date.fromString(str));

    @:from
    static public function fromDate(d:Date):LocalDateString return cast DateTools.format(d, "%Y-%m-%d %H:%M:%S");
}

typedef TimeSlot = {
    type: TimeSlotType,
    start: LocalDateString,
    end: LocalDateString,
}

class TimeSlotTools {
    static public function print(slot:TimeSlot):String {
        var startDate = slot.start.toDate();
        var endDate = slot.end.toDate();
        return '${startDate.getMonth() + 1}月${startDate.getDate()}日 (${Weekday.fromDay(startDate.getDay()).info().name}) ${slot.type.info().name} ${DateTools.format(startDate, "%H:%M")} - ${DateTools.format(endDate, "%H:%M")}';
    }
}

enum abstract TimeSlotType(String) {
    var Lunch;
    var Dinner;

    public function info() return switch (cast this:TimeSlotType) {
        case Lunch:
            {
                id: Lunch,
                name: "午餐",
                cutoffTime: "10:00",
            }
        case Dinner:
            {
                id: Dinner,
                name: "晚餐",
                cutoffTime: "17:00",
            }
    }

    static public function classify(date:Date):TimeSlotType {
        var hour = date.getHours();
        return if (hour < 15)
            Lunch;
        else
            Dinner;
    }
}

abstract Cents(Int) from Int to Int {
    public function print() {
        return "$" + (this * 0.01);
    }

    @:op(A + B)
    static function add(a:Cents, b:Cents):Cents return (a:Int) + (b:Int);

    @:op(A - B)
    static function minus(a:Cents, b:Cents):Cents return (a:Int) + (b:Int);

    @:op(A > B)
    static function gt(a:Cents, b:Cents):Bool return (a:Int) > (b:Int);

    @:op(A >= B)
    static function gte(a:Cents, b:Cents):Bool return (a:Int) >= (b:Int);

    @:op(A < B)
    static function lt(a:Cents, b:Cents):Bool return (a:Int) < (b:Int);

    @:op(A <= B)
    static function lte(a:Cents, b:Cents):Bool return (a:Int) <= (b:Int);
}

enum abstract Shop<T>(String) to String {
    var EightyNine:Shop<EightyNineItem>;
    var DragonJapaneseCuisine:Shop<Dynamic>;
    var YearsHK:Shop<Dynamic>;
    var LaksaStore:Shop<Dynamic>;
    var DongDong:Shop<Dynamic>;
    var BiuKeeLokYuen:Shop<Dynamic>;
    var KCZenzero:Shop<Dynamic>;
    var HanaSoftCream:Shop<Dynamic>;

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

enum abstract EightyNineItem(String) {
    var EightyNineSet;

    public function info(data:Dynamic) return switch (cast this:EightyNineItem) {
        case EightyNineSet:
            var dataInfo = {
                main: (data.main:EightyNineSetMain).info(),
                sub: (data.sub:EightyNineSetSub).info(),
                given: (data.given:EightyNineSetGiven).info(),
            };
            {
                id: EightyNineSet,
                name: "套餐",
                description: "主菜 + 配菜 + 絲苗白飯2個",
                detail:
                    [
                        dataInfo.main != null ? dataInfo.main.name + " " + dataInfo.main.priceCents.print() : "未選取主菜",
                        dataInfo.sub != null ? dataInfo.sub.name : "未選取配菜",
                        dataInfo.given != null ? dataInfo.given.name: "未選取套餐附送食物",
                    ].join("\n"),
                priceCents: {
                    switch (dataInfo) {
                        case {main: main} if (main != null):
                            main.priceCents;
                        case _:
                            0;
                    }
                },
                isValid:
                    data.main != null && data.sub != null && data.given != null,
            }
    }
}

enum abstract EightyNineSetMain(String) {
    var EightyNineSetMain1;
    var EightyNineSetMain2;
    var EightyNineSetMain3;
    var EightyNineSetMain4;
    var EightyNineSetMain5;

    public function info():{
        id: EightyNineSetMain,
        name: String,
        priceCents: Cents,
    } return switch (cast this:EightyNineSetMain) {
        case EightyNineSetMain1:
            {
                id: EightyNineSetMain1,
                name: "香茅豬頸肉",
                priceCents: 8500,
            }
        case EightyNineSetMain2:
            {
                id: EightyNineSetMain2,
                name: "招牌口水雞 (例)",
                priceCents: 8500,
            }
        case EightyNineSetMain3:
            {
                id: EightyNineSetMain3,
                name: "去骨海南雞 (例)",
                priceCents: 8500,
            }
        case EightyNineSetMain4:
            {
                id: EightyNineSetMain4,
                name: "招牌口水雞 (例) 拼香茅豬頸肉",
                priceCents: 9800,
            }
        case EightyNineSetMain5:
            {
                id: EightyNineSetMain5,
                name: "去骨海南雞 (例) 拼香茅豬頸肉",
                priceCents: 9800,
            }
    }
}

enum abstract EightyNineSetSub(String) {
    var EightyNineSetSub1;
    var EightyNineSetSub2;

    public function info() return switch (cast this:EightyNineSetSub) {
        case EightyNineSetSub1:
            {
                id: EightyNineSetSub1,
                name: "涼拌青瓜拼木耳",
            }
        case EightyNineSetSub2:
            {
                id: EightyNineSetSub2,
                name: "郊外油菜",
            }
    }
}

enum abstract EightyNineSetGiven(String) {
    var EightyNineSetGiven1;

    public function info() return switch (cast this:EightyNineSetGiven) {
        case EightyNineSetGiven1:
            {
                id: EightyNineSetGiven1,
                name: "絲苗白飯2個",
            }
    }
}

enum abstract PaymentMethod(String) to String {
    var PayMe;
    var FPS;

    public function info() return switch (cast this:PaymentMethod) {
        case PayMe:
            {
                id: PayMe,
                name: "PayMe",
            }
        case FPS:
            {
                id: FPS,
                name: "FPS",
            }
    }
}

enum abstract PickupMethod(String) to String {
    var Door;
    var Street;

    public function info() return switch (cast this:PickupMethod) {
        case Door:
            {
                id: Door,
                name: "上門交收",
            }
        case Street:
            {
                id: Street,
                name: "樓下交收",
            }
    }
}

typedef OrderItem = {
    type: String,
}

typedef Order<Item> = {
    shop:Shop<Item>,
    code:String,
    timestamp:Int,
    items: Array<{
        id: Item,
        data: Dynamic,
    }>,
    wantTableware:Bool,
    customerNote:Null<String>,
}

typedef Tg = {
    ?id: Int,
    ?username: String,
}

typedef Delivery = {
    courier: {
        tg: Tg
    },
    orders:Array<Order<Dynamic>>,
    customer: {
        tg: Tg,
        tel: String,
    },
    paymentMethods: Array<PaymentMethod>,
    pickupLocation: String,
    pickupTimeSlot: TimeSlot,
    pickupMethod: PickupMethod,
    deliveryFeeCents: Cents,
    customerNote: String,
}

class TgTools {
    static public function print(tg:Tg):String {
        return if (tg.username != null)
            "@" + tg.username;
        else if (tg.id != null)
            "" + tg.id;
        else
            "[none]";
    }
}

class OrderTools {
    static public function totalCents<T>(order:Order<T>):Cents {
        var total:Cents = 0;

        for (item in order.items) {
            switch (order.shop) {
                case EightyNine:
                    switch (item.id:EightyNineItem) {
                        case itemId = EightyNineSet:
                            var info = itemId.info(item.data);
                            total += info.priceCents;
                    }
                case DragonJapaneseCuisine:

                case YearsHK:

                case LaksaStore:

                case DongDong:

                case BiuKeeLokYuen:

                case KCZenzero:

                case HanaSoftCream:
            }
        }

        return total;
    }

    static public function print<T>(order:Order<T>):String {
        var buf = new StringBuf();

        buf.add("📃 " + order.shop.info().name + " " + order.code + " (" + totalCents(order).print() + ")\n");

        for (item in order.items) {
            switch (order.shop) {
                case EightyNine:
                    switch (item.id:EightyNineItem) {
                        case itemId = EightyNineSet:
                            var info = itemId.info(item.data);
                            buf.add(info.detail);
                    }
                case DragonJapaneseCuisine:

                case YearsHK:

                case LaksaStore:

                case DongDong:

                case BiuKeeLokYuen:

                case KCZenzero:

                case HanaSoftCream:
            }
        }

        buf.add(order.wantTableware ? "要餐具\n" : "唔要餐具\n");

        return buf.toString();
    }
}

class DeliveryTools {
    static public function print(d:Delivery):String {
        var buf = new StringBuf();

        buf.add("外賣員: " + d.courier.tg.print() + "\n");

        for (order in d.orders) {
            buf.add(order.print());
        }

        buf.add("\n");
        var foodTotal = d.orders.fold((order:Order<Dynamic>, result:Cents) -> result + order.totalCents(), 0);
        buf.add("食物價錢: " + foodTotal.print() + "\n");
        buf.add("食物+運費: " + (foodTotal + d.deliveryFeeCents).print() + "\n");

        buf.add("\n");
        buf.add("客人交收時段: " + d.pickupTimeSlot.print() + "\n");
        buf.add("tg: " + d.customer.tg.print() + "\n");
        buf.add(d.customer.tel + "\n");
        buf.add(d.paymentMethods.map(p -> p.info().name).join(", ") + "\n");
        buf.add(d.pickupLocation + " (" + d.pickupMethod.info().name + ")\n");

        return buf.toString();
    }
}