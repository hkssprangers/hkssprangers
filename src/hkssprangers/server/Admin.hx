package hkssprangers.server;

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

    static public function ensureCourier(req:Request, res:Response, next) {
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

        if (!TelegramTools.verifyLoginResponse(Sha256.encode(TelegramConfig.tgBotToken), cast tg)) {
            res.status(403).end('Invalid Telegram login response.');
            return;
        }

        MySql.db.courier.where(r -> r.courierTgId == tg.id || r.courierTgUsername == tg.username).first().handle(o -> switch o {
            case Success(null):
                res.status(403).end('${tg.username} (${tg.id}) is not one of the couriers.');
                return;
            case Success(courierData):
                var user:Courier = {
                    courierId: courierData.courierId,
                    tg: tg,
                    isAdmin: courierData.isAdmin,
                }
        
                res.locals.user = user;
                next();
            case Failure(failure):
                res.status(500).end(failure.message);
        });
    }

    static public function post(req:Request, res:Response) {
        var user:Courier = res.locals.user;
        if (!user.isAdmin) {
            res.status(403).end('${user.tg.username} (${user.tg.id}) is not one of the admins.');
            return;
        }
        if (req.body != null) switch [(req.body.action:String), (req.body.delivery:Delivery)] {
            case [null, _]:
                // pass
            case ["insert", delivery]:
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
            case ["update", delivery]:
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
            case ["delete", delivery]:
                MySql.db.deleteDelivery(delivery)
                    .handle(o -> switch o {
                        case Success(data):
                            res.end("ok");
                        case Failure(failure):
                            res.type("text");
                            res.status(500).end(Std.string(failure));
                    });
                return;
            case [action, _]:
                res.type("text");
                res.status(406).end("Unknown action " + action);
                return;
        }
    }

    static public function get(req:Request, res:Response) {
        var user:Courier = res.locals.user;
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