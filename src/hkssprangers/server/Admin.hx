package hkssprangers.server;

import haxe.ds.ReadOnlyArray;
import js.lib.Promise;
import js.npm.google_spreadsheet.GoogleSpreadsheet;
import js.npm.google_spreadsheet.GoogleSpreadsheetWorksheet;
import haxe.crypto.Sha256;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import haxe.Json;
import js.npm.express.*;
import hkssprangers.info.*;
import hkssprangers.info.Shop;
import hkssprangers.info.ContactMethod;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.OrderTools.*;
import hkssprangers.server.ServerMain.*;
import hkssprangers.ObjectTools.*;
using Lambda;
using StringTools;
using DateTools;
using hkssprangers.server.ExpressTools;
using hkssprangers.MathTools;
using hkssprangers.ObjectTools;
using hkssprangers.info.DeliveryTools;

typedef User = {
    tg: {
        id:Int,
        username:String,
    },
    isAdmin:Bool,
};

typedef FormOrder = {
    creationTime:Date,
    shop:Shop,
    content: String,
    iceCream: Array<String>,
    wantTableware: Bool,
    time: TimeSlot,
    contactMethod: ContactMethod,
    tg: String,
    tel: String,
    paymentMethod: Array<PaymentMethod>,
    address: String,
    pickupMethod: PickupMethod,
    note: Null<String>,
};

class Admin extends View {
    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

    public var user(get, never):Null<{
        tg: {
            id:Int,
            username:String,
        }
    }>;
    function get_user() return props.user;

    override function title():String return "平台管理";
    override function description() return "平台管理";
    override function canonical() return Path.join([domain, "admin"]);
    override public function render() {
        return super.render();
    }

    override function bodyContent() {
        return jsx('
            <div>
                <div id="AdminView"
                    data-tg-bot-name=${tgBotName}
                    data-user=${Json.stringify(user)}
                />
            </div>
        ');
    }

    static var menuForm(get, null):Map<Shop, Promise<GoogleSpreadsheet>>;
    static function get_menuForm() return menuForm != null ? menuForm : menuForm = [
        for (shop => sheetId in [
            YearsHK => "1Jq1AuOc6pG-EuqsGkRj_DS4TWvFXa-r3pGY9DFMqhGk",
            EightyNine => "1Y-yqDQsYO4UeJa4Jxl2ZtZ56Su84cU58TVrm7QpXTHg",
            DragonJapaneseCuisine => "1A_dPdhn6jDGZU-iyDXVKkEdme2VsUZxMUgjZZPa3gMc",
            LaksaStore => "16Jw8bVcW1N87jndk6VQ99E3mBB_H9hxLckM8eIbGpcY",
            DongDong => "1IpJteF-lZ9wd0tSHPgwsVyUuhuWraAdgKnKisYalFb8",
            BiuKeeLokYuen => "1POh9Yy93iyTbm5An_NhQoVWO2QX7GCDcBrs0nZuehKg",
            KCZenzero => "1gHslFNSVO8KOoD6IEcV-mglGoGailUaHr4SbQRSzFOo",
            Neighbor => "15Mzv3r9wTbxpIiJEPbPPwF8O7oP4hQGQ5bksyMuKXHY",
            MGY => "1jbZng_nv2nx3WgY7BV6DfpGz_3AuheVH2VYNOxQCQvM",
        ]) {
            var doc = new GoogleSpreadsheet(sheetId);
            shop => doc.useServiceAccountAuth(GoogleServiceAccount.formReaderServiceAccount)
                .then(_ -> doc.loadInfo())
                .then(_ -> doc);
        }
    ];

    static final hr = "\n--------------------------------------------------------------------------------\n";

    static function getGroupOrders() {
        var doc = new GoogleSpreadsheet("1xcwF-OucoIneLjaajM6b6MOf_waeAE9oeCyTOpzoAJA");
        return doc.useServiceAccountAuth(GoogleServiceAccount.formReaderServiceAccount)
            .then(_ -> doc.loadInfo())
            .then(_ -> doc.sheetsByIndex[0])
            .then(sheet -> {
                sheet.loadCells().then(_ -> {
                    var headers = [
                        for (col in 0...sheet.columnCount)
                        (sheet.getCell(0, col).value:Null<String>)
                    ];
                    var orders = [];
                    for (row in 1...sheet.rowCount)
                    if (sheet.getCell(row, 0).value != null)
                    {
                        var order = {
                            creationTime: null,
                            content: "",
                            wantTableware: null,
                            time: null,
                            contactMethod: null,
                            tg: null,
                            tel: null,
                            paymentMethod: null,
                            address: null,
                            pickupMethod: null,
                            note: null,
                        };
                        var orderContent = [];
                        for (col => h in headers)
                            switch [h, (sheet.getCell(row, col).formattedValue:String)] {
                                case [null, _]:
                                    continue;
                                case ["Timestamp" | "時間戳記", v]:
                                    order.creationTime = v;
                                case [_, null | ""]:
                                    continue;
                                case ["你的地址", v]:
                                    order.address = v;
                                case ["你的聯絡方式 (外賣員會和你聯絡同收款)", v]:
                                    order.contactMethod = if (v.toLowerCase().startsWith("telegram")) {
                                        Telegram;
                                    } else if (v.toLowerCase().startsWith("whatsapp")) {
                                        WhatsApp;
                                    } else {
                                        throw 'Unknown contact method: ' + v;
                                    }
                                case ["你的電話號碼" | "你的電話號碼/Whatsapp", v]:
                                    order.tel = "https://wa.me/852" + v;
                                case ["俾錢方法", v]:
                                    order.paymentMethod = v;
                                case ["交收方法", v]:
                                    order.pickupMethod = v;
                                case ["需要餐具嗎?", v]:
                                    order.wantTableware = v + "餐具";
                                case ["其他備註", v]:
                                    order.note = v;
                                case [h, v] if (h.startsWith("你的Telegram username")):
                                    var r = ~/^@?([A-Za-z0-9_]{5,})$/;
                                    order.tg = if (r.match(v.trim()))
                                        "https://t.me/" + r.matched(1);
                                    else
                                        v;
                                case [h, v] if (h.startsWith("想幾時收到?")):
                                    order.time = v;
                                case [h, v]:
                                    orderContent.push(h + ": " + v);
                            }
                        order.content = orderContent.join("\n");
                        orders.push(order);
                    }
                    orders;
                });
            });
    }

    static function getDeliveries(shop:Shop, sheet:GoogleSpreadsheetWorksheet, date:Date):Array<Delivery> {
        var dateStr = (date.getMonth() + 1) + "月" + date.getDate() + "日";
        function isInTimeSlot(value:String):Bool {
            return value.startsWith(dateStr);
        }
        var headers = [
            for (col in 0...sheet.columnCount)
            (sheet.getCell(0, col).value:Null<String>)
        ];
        return [
            for (row in 1...sheet.rowCount)
            if (sheet.getCell(row, 0).value != null)
            if (isInTimeSlot(sheet.getCell(row, headers.findIndex(h -> h == "想幾時收到?")).value))
            {
                var order:Order = {
                    creationTime: null,
                    shop: shop,
                    wantTableware: null,
                    customerNote: null,
                    orderDetails: null,
                    orderPrice: null,
                    platformServiceCharge: null,
                };
                var delivery:Delivery = {
                    creationTime: null,
                    deliveryCode: null,
                    couriers: null,
                    customer: {
                        tg: null,
                        tel: null,
                    },
                    customerPreferredContactMethod: null,
                    paymentMethods: null,
                    pickupLocation: null,
                    pickupTimeSlot: null,
                    pickupMethod: null,
                    deliveryFee: Math.NaN,
                    customerNote: null,
                    orders: [order],
                };
                var iceCream = [];
                var orderContent = [];
                var extraOrderContent = [];
                for (col => h in headers)
                switch [shop, h, (sheet.getCell(row, col).formattedValue:String)] {
                    case [_, "叫多份?" | "請選擇類別" | null, _]:
                        null;
                    case [_, "Timestamp" | "時間戳記", v]:
                        delivery.creationTime = order.creationTime = if (v.contains("年")) {
                            // 2020年9月20日 上午03:24:53
                            Date.fromTime(Moment.call(v, "LL Ahh:mm:ss", "zh-hk", true).toDate().getTime());
                        } else if (v.contains("/")) {
                            // 9/2/2020 9:59:25
                            Date.fromTime(Moment.call(v, "M/D/YYYY H:m:s", true).toDate().getTime());
                        } else if (v.contains("-")) {
                            Date.fromTime(Moment.call(v).toDate().getTime());
                        } else {
                            throw "unknown date format: " + v;
                        }
                    case [_, _, null | "" | "明白了"]:
                        null;
                    case [_, "想幾時收到?", v]:
                        var dateReg = ~/([0-9]+)月([0-9]+)日/;
                        var timeSlotReg = ~/([0-9]{2}:[0-9]{2})\s*\-\s*([0-9]{2}:[0-9]{2})/;
                        if (dateReg.match(v) && timeSlotReg.match(v)) {
                            var dateStr = "2020-" + dateReg.matched(1).lpad("0", 2) + "-" + dateReg.matched(2).lpad("0", 2);
                            delivery.pickupTimeSlot = {
                                start: dateStr + " " + timeSlotReg.matched(1) + ":00",
                                end: dateStr + " " + timeSlotReg.matched(2) + ":00",
                            };
                        } else {
                            throw 'Cannot parse datetime from ' + v;
                        }
                    case [_, "你的地址", v]:
                        delivery.pickupLocation = v;
                    case [_, "你的聯絡方式 (外賣員會和你聯絡同收款)", v]:
                        delivery.customerPreferredContactMethod = if (v.toLowerCase().startsWith("telegram")) {
                            Telegram;
                        } else if (v.toLowerCase().startsWith("whatsapp")) {
                            WhatsApp;
                        } else {
                            throw 'Unknown contact method: ' + v;
                        }
                    case [_, "你的電話號碼" | "你的電話號碼/Whatsapp", v]:
                        delivery.customer.tel = "https://wa.me/852" + v;
                    case [_, "俾錢方法", v]:
                        delivery.paymentMethods = v.split(",").map(v -> PaymentMethod.fromName(v.trim()));
                    case [_, "交收方法", v]:
                        delivery.pickupMethod = PickupMethod.fromName(v);
                    case [_, "需要餐具嗎?", v]:
                        order.wantTableware = switch (v) {
                            case "要": true;
                            case "唔要": false;
                            case _: throw 'tableware? ' + v;
                        };
                    case [_, "其他備註", v]:
                        delivery.customerNote = v;
                    case [_, h, v] if (h.startsWith("你的tg username") || h.startsWith("你的Telegram username")):
                        var r = ~/^@?([A-Za-z0-9_]{5,})$/;
                        delivery.customer.tg = if (r.match(v.trim())) {
                            username: r.matched(1),
                        } else null;
                    case [_, _, v] if (v.contains("雪糕")):
                        iceCream.push(v);
                    case [_, h, v = "涼拌青瓜拼木耳" | "郊外油菜"]:
                        orderContent.push(h + ": " + v);
                        orderContent.push("套餐附送絲苗白飯2個");
                    case [LaksaStore, "湯底選擇", v]:
                        orderContent.push(v);
                    case [LaksaStore, "配料選擇", v]:
                        orderContent[orderContent.length - 1] += " " + v;
                    case [LaksaStore, "麵類選擇", v]:
                        orderContent[orderContent.length - 1] += " " + v + " $50";
                    case [LaksaStore, "餐飲選擇", v]:
                        orderContent.push(v);
                    case [KCZenzero, "車仔粉主食選擇", v]:
                        orderContent.push(h + ": " + v + " $" + switch (v.split(", ").length) {
                            case 0, 1, 2: 48;
                            case n: 48 + (n - 2) * 5;
                        });
                    case [DongDong, "午餐選擇" | "小菜 - $58" | "以下套餐奉送例湯", v]:
                        orderContent.push(h + ": " + v);
                        extraOrderContent.push("外賣盒 (+$1)");
                    case [BiuKeeLokYuen, "雙併配料選擇", "唔加"]:
                        // pass
                    case [BiuKeeLokYuen, h, v] if (h.endsWith("配料選擇")):
                        orderContent.push(h.substr(0, h.length - "配料選擇".length) + ": " + v);
                    case [BiuKeeLokYuen, "請選擇", v]:
                        orderContent.push(v);
                    case [MGY, "小菜 - $53", v]:
                        orderContent.push(v + " $53");
                        extraOrderContent.push("外賣盒 (+$1)");
                    case [MGY, "客飯 / 炒粉飯 / 日式冷麵", v]:
                        orderContent.push(v);
                        extraOrderContent.push("外賣盒 (+$1)");
                    case [MGY, "粉麵選擇 - $43", v]:
                        orderContent.push(v + " $43");
                        extraOrderContent.push("外賣盒 (+$1)");
                    case [MGY, "小食選擇", v]:
                        orderContent.push(v);
                    case [_, h, v]:
                        orderContent.push(h + ": " + v);
                }
                switch (shop) {
                    case KCZenzero:
                        extraOrderContent.push("外賣盒 (+$2)");
                    case _:
                        //pass
                }
                order.orderDetails = orderContent.concat(extraOrderContent).join("\n");
                order.orderPrice = parseTotalPrice(order.orderDetails);
                if (iceCream.length > 0) {
                    delivery.orders.push(order.with({
                        shop: HanaSoftCream,
                        orderDetails: iceCream.join("\n"),
                        orderPrice: parseTotalPrice(iceCream.join("\n")),
                    }));
                }
                delivery;
            }
        ];
    }

    static final admins:ReadOnlyArray<String> = [
        "andyonthewings",
        "Arbuuuuuuu",
    ];

    static public function ensureAdmin(req:Request, res:Response, next) {
        var tg:Null<{
            id:Int,
            username:String,
        }> = if (req.cookies != null && req.cookies.tg != null) try {
            Json.parse(req.cookies.tg);
        } catch(err) {
            res.status(403).end('Error parsing Telegram login response.\n\n' + err.details());
            return;
        } else null;

        if (tg == null) {
            res.redirect("/login?redirectTo=" + req.originalUrl.urlEncode());
            return;
        }

        if (!TelegramTools.verifyLoginResponse(Sha256.encode(tgBotToken), cast tg)) {
            res.status(403).end('Invalid Telegram login response.');
            return;
        }

        if (
            !admins.exists(adminUsername -> adminUsername.toLowerCase() == tg.username.toLowerCase())
        ) {
            res.status(403).end('${tg.username} (${tg.id}) is not one of the admins.');
            return;
        }

        var user:User = {
            tg: tg,
            isAdmin: true,
        }

        res.locals.user = user;
        next();
    }

    static public function middleware(req:Request, res:Response) {
        var user:User = res.locals.user;
        switch (req.query.group:String) {
            case null:
                // pass
            case groupStr:
                switch (req.accepts(["text", "json"])) {
                    case "text":
                        getGroupOrders()
                            .then(orders -> {
                                [
                                    for (i => o in orders)
                                    {
                                        var totalPrice = parseTotalPrice(o.content);
                                        [
                                            "單號: " + '${i+1}'.lpad("0", 2),
                                            "",
                                            o.content,
                                            o.wantTableware,
                                            o.note != null ? "*其他備註: " + o.note : null,
                                            "",
                                            "食物價錢: $" + totalPrice,
                                            "食物+運費: $" + (totalPrice + 15),
                                            "",
                                            "客人交收時段: " + o.time,
                                            (o.contactMethod == Telegram ? "tg (客人首選):" : "tg: ") + o.tg,
                                            (o.contactMethod == WhatsApp ? "wtsapp (客人首選):" : "wtsapp: ") + o.tel,
                                            o.paymentMethod,
                                        ].filter(l -> l != null).join("\n");
                                    }
                                ].join(hr);
                            })
                            .then(orderStr -> {
                                res.type("text");
                                res.end(orderStr);
                            })
                            .catchError(err -> {
                                res.type("text");
                                res.status(500).end(Std.string(err));
                            });
                        return;
                    case "json":
                        getGroupOrders()
                            .then(orders -> res.json(orders));
                        return;
                    case _:
                        res.type("text");
                        res.status(406).send("Can only return text or json");
                        return;
                }
        }
        switch (req.query.date:String) {
            case null:
                // pass
            case dateStr:
                switch (req.accepts(["text", "json"])) {
                    case "text":
                        getAllDeliveries(Date.fromString(dateStr))
                            .then(deliveries -> {
                                // var str = Json.stringify(deliveries, null, "  ");
                                var str = deliveries.map(d -> d.print()).join(hr);
                                res.type("text");
                                res.end(str);
                            })
                            .catchError(err -> {
                                res.type("text");
                                res.status(500).end(Std.string(err));
                            });
                    case "json":
                        getAllDeliveries(Date.fromString(dateStr))
                            .then(deliveries -> res.json(deliveries));
                        return;
                    case _:
                        res.type("text");
                        res.status(406).send("Can only return text or json");
                        return;
                }
                return;
        }
        var tgBotInfo = tgBot.telegram.getMe();
        tgBotInfo.then(tgBotInfo ->
            res.sendView(Admin, {
                tgBotName: tgBotInfo.username,
                user: user,
            }))
            .catchError(err -> res.status(500).json(err));
    }

    static public function getAllDeliveries(?date:Date):Promise<Array<Delivery>> {
        var now = switch (date) {
            case null: Date.now();
            case v: v;
        }
        // var now = Date.fromString("2020-08-18");
        return MySql.db.getDeliveries(now)
            .next(deliveries -> if (deliveries.length > 0) {
                deliveries;
            } else {
                var sheets = [
                    for (shop => doc in menuForm)
                    shop => doc
                        .then(doc -> doc.sheetsByIndex[0])
                        .then(sheet -> sheet.loadCells().then(_ -> sheet))
                ];
                [
                    for (shop => sheet in sheets)
                    sheet
                        .then(sheet -> getDeliveries(shop, sheet, now))
                        .then(deliveries -> {
                            [
                                for (t in [Lunch, Dinner])
                                deliveries
                                    .filter(d -> TimeSlotType.classify(d.pickupTimeSlot.start) == t)
                                    .mapi((i, d) -> {
                                        d.deliveryCode = d.orders[0].shop.info().name + " " + (switch (t) {
                                            case Lunch: "L" + '${i+1}'.lpad("0", 2);
                                            case Dinner: "D" + '${i+1}'.lpad("0", 2);
                                        });
                                        d;
                                    })
                            ].fold((item, result:Array<Delivery>) -> result.concat(item), []);
                        })
                ]
                    .fold((item, result:Promise<Array<Delivery>>) ->
                        item.then(deliveries ->
                            result.then(all ->
                                all.concat(deliveries)
                            )
                        )
                    , Promise.resolve([]))
                    .then(deliveries -> {
                        [
                            for (t in [Lunch, Dinner])
                                deliveries.filter(d -> TimeSlotType.classify(d.pickupTimeSlot.start) == t)
                        ].fold((item, result:Array<Delivery>) -> result.concat(item), []);
                    });
            });
        
    }
}