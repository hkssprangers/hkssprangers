package hkssprangers.server;

import telegraf.Markup;
import tink.core.Noise;
import js.npm.google_spreadsheet.GoogleSpreadsheet;
import haxe.crypto.Sha256;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import haxe.Json;
import js.npm.express.*;
import hkssprangers.TelegramConfig;
import hkssprangers.info.*;
import hkssprangers.info.Shop;
import hkssprangers.info.ContactMethod;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.OrderTools.*;
import hkssprangers.server.ServerMain.*;
using Lambda;
using StringTools;
using DateTools;
using hkssprangers.server.ExpressTools;
using hkssprangers.MathTools;
using hkssprangers.ObjectTools;
using hkssprangers.info.DeliveryTools;
using hkssprangers.db.Database;

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

    public var user(get, never):Null<Courier>;
    function get_user() return props.user;

    override function title():String return "平台管理";
    override function description() return "平台管理";
    override function canonical() return Path.join(["https://" + canonicalHost, "admin"]);
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
                                    order.tel = v;
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

    static public function setTg(req:Request, res:Response, next) {
        var tg:Dynamic = if (req.cookies != null && req.cookies.tg != null) try {
            Json.parse(req.cookies.tg);
        } catch(err) {
            trace('Error parsing Telegram login response.\n\n' + err.details());
            null;
        } else null;

        if (!TelegramTools.verifyLoginResponse(Sha256.encode(TelegramConfig.tgBotToken), tg)) {
            trace('Invalid Telegram login response.');
            tg = null;
        }

        res.setUserTg(tg);
        next();
    }

    static public function setCourier(req:Request, res:Response, next) {
        var tg = res.getUserTg();

        if (tg == null) {
            next();
            return;
        }

        MySql.db.courier.where(r -> r.courierTgId == tg.id || r.courierTgUsername == tg.username).first().handle(o -> switch o {
            case Success(courierData):
                var courier:Courier = {
                    courierId: courierData.courierId,
                    tg: tg,
                    isAdmin: courierData.isAdmin,
                }

                res.setCourier(courier);
                next();
                return;
            case Failure(failure):
                if (failure.code == 404) {
                    trace('${tg.username} (${tg.id}) is not one of the couriers.');
                    next();
                    return;
                } else {
                    trace(failure.message + "\n\n" + failure.exceptionStack);
                    next();
                    return;
                }
        });
    }

    static public function ensureCourier(req:Request, res:Response, next) {
        var courier = res.getCourier();

        if (courier == null) {
            res.redirect("/login?redirectTo=" + req.originalUrl.urlEncode());
            return;
        }

        next();
    }

    static public function post(req:Request, res:Response) {
        var user:Courier = res.getCourier();
        if (user == null || !user.isAdmin) {
            res.status(403).end('Only admins are allowed.');
            return;
        }
        if (req.body != null) switch (req.body.action:String) {
            case null:
                // pass
            case "insert":
                var delivery:Delivery = req.body.delivery;
                MySql.db.insertDeliveries([delivery])
                    .next(dids -> MySql.db.delivery
                        .where(f -> f.deliveryId == dids[0])
                        .first()
                        .next(d -> d.toDelivery(MySql.db))
                        .next(d -> {
                            res.json(d);
                            Noise;
                        })
                    )
                    .recover(err -> {
                        res.type("text");
                        res.status(500).end(Std.string(err));
                        Noise;
                    });
                return;
            case "update":
                var delivery:Delivery = req.body.delivery;
                MySql.db.saveDelivery(delivery)
                    .next(_ -> MySql.db.delivery
                        .where(f -> f.deliveryId == delivery.deliveryId)
                        .first()
                        .next(d -> d.toDelivery(MySql.db))
                        .next(d -> {
                            res.json(d);
                            Noise;
                        })
                    )
                    .recover(err -> {
                        res.type("text");
                        res.status(500).end(Std.string(err));
                        Noise;
                    });
                return;
            case "delete":
                var delivery:Delivery = req.body.delivery;
                MySql.db.deleteDelivery(delivery)
                    .handle(o -> switch o {
                        case Success(data):
                            res.end("ok");
                        case Failure(failure):
                            res.type("text");
                            res.status(500).end(Std.string(failure));
                    });
                return;
            case "announce":
                var deliveries:Array<Delivery> = req.body.deliveries;
                var couriers = [
                    for (d in deliveries)
                    for (c in d.couriers)
                    c.tg.username => c.tg.username
                ].array();
                var you = if (couriers.length == 1) {
                    "你";
                } else {
                    "你哋";
                }
                var time = switch (TimeSlotType.classify(deliveries[0].pickupTimeSlot.start)) {
                    case Lunch: "今朝";
                    case Dinner: "今晚";
                }

                tgBot.telegram.sendMessage(TelegramConfig.groupChatId(deployStage), couriers.map(c -> "@" + c).join(" ") + "\n" + '${time}嘅 ${deliveries.length} 單交俾${you}啦 🙇', {
                    reply_markup: Markup.inlineKeyboard_([
                        Markup.loginButton_("登入睇單", Path.join(["https://" + host, "tgAuth?redirectTo=%2Fadmin"]), {
                            request_write_access: true,
                        }),
                    ]),
                }).then(msg -> {
                    tgBot.telegram.pinChatMessage(TelegramConfig.groupChatId(deployStage), msg.message_id);
                }).then(_ -> {
                    res.type("text");
                    res.end("done");
                }).catchError(err -> {
                    res.type("text");
                    res.status(500).end(Std.string(err));
                });
                return;
            case action:
                res.type("text");
                res.status(406).end("Unknown action " + action);
                return;
        }
    }

    static public function get(req:Request, res:Response) {
        var user:Courier = res.getCourier();
        switch (req.query.date:String) {
            case null:
                // pass
            case dateStr:
                switch (req.accepts(["text", "json"])) {
                    case "text":
                        // pass
                    case "json":
                        var date = Date.fromString(dateStr);
                        var now = Date.now();
                        MySql.db.getDeliveries(date)
                            .handle(o -> switch (o) {
                                case Success(deliveries):
                                    if (user.isAdmin) {
                                        res.json(deliveries);
                                    } else {
                                        res.json(deliveries.map(d -> {
                                            if (
                                                d.couriers.exists(c -> c.courierId == user.courierId)
                                                ||
                                                (
                                                    // today
                                                    (date:LocalDateString).getDatePart() == (now:LocalDateString).getDatePart()
                                                    &&
                                                    // time pass order cut-off
                                                    switch (TimeSlotType.classify(d.pickupTimeSlot.start)) {
                                                        case Lunch:
                                                            now.getHours() >= 10;
                                                        case Dinner:
                                                            now.getHours() >= 17;
                                                    }
                                                )
                                            ) {
                                                d;
                                            } else {
                                                d.getMinInfo();
                                            }
                                        }));
                                    }
                                    return;
                                case Failure(failure):
                                    res.type("text");
                                    res.status(500).end(Std.string(failure));
                                    return;
                            });
                        return;
                    case _:
                        res.type("text");
                        res.status(406).end("Can only return text or json");
                        return;
                }
        }
        var tgBotInfo = tgBot.telegram.getMe();
        tgBotInfo.then(tgBotInfo ->
            res.sendView(Admin, {
                tgBotName: tgBotInfo.username,
                user: user,
            }))
            .catchError(err -> res.status(500).json(err));
    }
}