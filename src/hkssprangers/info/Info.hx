package hkssprangers.info;

using hkssprangers.info.Info.TgTools;
using hkssprangers.info.Info.OrderTools;
using Lambda;

abstract Cents(Int) from Int to Int {
    public function print() {
        return "$" + (this * 0.01);
    }

    @:op(A + B)
    static function add(a:Cents, b:Cents):Cents return (a:Int) + (b:Int);

    @:op(A - B)
    static function minus(a:Cents, b:Cents):Cents return (a:Int) + (b:Int);
}

enum abstract Shop<T>(String) {
    var EightyNine:Shop<EightyNineItem>;
    var DragonJapaneseCuisine:Shop<Dynamic>;
    var YearsHK:Shop<Dynamic>;

    public function info() return switch (cast this:Shop<T>) {
        case EightyNine:
            {
                id: EightyNine,
                name: "89美食",
                address: "西九龍中心8樓美食廣場9號舖",
            }
        case DragonJapaneseCuisine:
            {
                id: DragonJapaneseCuisine,
                name: "營業部",
                address: "西九龍中心8樓美食廣場8F35舖",
            }
        case YearsHK:
            {
                id: YearsHK,
                name: "YearsHK",
                address: "深水埗福華街191-199號福隆大廈1號地舖",
            }
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
                        dataInfo.given.name,
                    ].join("\n"),
                priceCents: {
                    switch (dataInfo) {
                        case {main: main, sub: sub, given: given} if (main != null && sub != null && given != null):
                            main.priceCents;
                        case _:
                            0;
                    }
                }
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
                name: "套餐附送絲苗白飯2個",
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
    pickupDate: String,
    pickupTime: String,
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
        buf.add("客人交收時段: " + d.pickupDate + " " + d.pickupTime + "\n");
        buf.add("tg: " + d.customer.tg.print() + "\n");
        buf.add(d.customer.tel + "\n");
        buf.add(d.paymentMethods.map(p -> p.info().name).join(", ") + "\n");
        buf.add(d.pickupLocation + " (" + d.pickupMethod.info().name + ")\n");

        return buf.toString();
    }
}