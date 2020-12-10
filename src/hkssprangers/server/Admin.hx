package hkssprangers.server;

import tink.core.Error.ErrorCode;
import telegraf.Markup;
import tink.core.Noise;
import haxe.crypto.Sha256;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import haxe.Json;
import js.npm.express.*;
import js.node.Querystring;
import jsonwebtoken.Claims;
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

    public var token(get, never):Null<Token>;
    function get_token() return props.token;

    override function title():String return if (token == null)
        "平台管理";
    else
        '${token.date} ${switch (token.time) { case Lunch: "午市"; case Dinner: "晚市"; }} ${token.shop.info().name} ${name}外賣單';

    override function description() return title();
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

    static public function setTg(req:Request, res:Response, next) {
        var tg:Dynamic = if (req.cookies != null && req.cookies.tg != null) try {
            Json.parse(req.cookies.tg);
        } catch(err) {
            trace('Error parsing Telegram login response.\n\n' + err.details());
            null;
        } else null;

        if (tg != null && !TelegramTools.verifyLoginResponse(Sha256.encode(TelegramConfig.tgBotToken), tg)) {
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

    static public function ensurePermission(req:Request, res:Response, next) {
        var courier = res.getCourier();

        if (courier != null) {
            next();
            return;
        }

        ServerMain.jwtVerifyToken(req.query.token).handle(o -> switch o {
            case Success(data):
                res.setToken(data);
                next();
                return;
            case Failure(failure):
                res.redirect("/login?redirectTo=" + req.originalUrl.urlEncode());
                return;
        });
    }

    static public function post(req:Request, res:Response) {
        var user:Courier = res.getCourier();
        if (user == null || !user.isAdmin) {
            res.status(403).end('Only admins are allowed.');
            return;
        }
        if (req.body == null) {
            res.status(ErrorCode.BadRequest).end("No request body.");
            return;
        }
        switch (req.body.action:String) {
            case null:
                res.status(ErrorCode.BadRequest).end("No action.");
                return;
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
            case "share":
                var date:LocalDateString = req.body.date;
                var time:TimeSlotType = req.body.time;
                var shop:Shop = req.body.shop;
                var payload:Dynamic = ({
                    exp: Date.fromTime(date.toDate().getTime() + DateTools.days(50)),
                }:Claims).merge(({
                    date: date.getDatePart(),
                    time: time,
                    shop: shop,
                }:Token));
                ServerMain.jwtSign(payload)
                    .handle(o -> switch(o) {
                        case Success(token):
                            res.type("text");
                            res.end(Path.join(["https://" + host, "admin?" + Querystring.stringify({
                                token: token,
                            })]));
                        case Failure(failure):
                            res.type("text");
                            res.status(failure.code).end(failure.message + "\n\n" + failure.exceptionStack);
                    });
                return;
            case action:
                res.type("text");
                res.status(406).end("Unknown action " + action);
                return;
        }
    }

    static public function getByToken(req:Request, res:Response) {
        var token = res.getToken();
        MySql.db.getDeliveries(token.date)
            .handle(o -> switch (o) {
                case Success(deliveries):
                    res.json({
                        deliveries: deliveries
                            .filter(d -> TimeSlotType.classify(d.pickupTimeSlot.start) == token.time)
                            .map(d -> d.with({
                                orders: d.orders.filter(o -> o.shop == token.shop),
                                pickupLocation: null,
                                paymentMethods: null,
                                deliveryFee: null,
                                customerNote: null,
                            })),
                        date: token.date,
                        time: token.time,
                        shop: token.shop,
                    });
                    return;
                case Failure(failure):
                    res.type("text");
                    res.status(500).end(Std.string(failure));
                    return;
            });
        return;
    }

    static public function get(req:Request, res:Response) {
        var user = res.getCourier();
        switch (req.accepts(["text/html", "application/json"])) {
            case "text/html":
                var tgBotInfo = tgBot.telegram.getMe();
                tgBotInfo.then(tgBotInfo ->
                    res.sendView(Admin, {
                        tgBotName: tgBotInfo.username,
                        user: user,
                        token: res.getToken(),
                    }))
                    .catchError(err -> res.status(500).json(err));
                return;
            case "application/json":
                switch (res.getToken()) {
                    case null:
                        // pass
                    case token:
                        getByToken(req, res);
                        return;
                }
                var now = Date.now();
                var date = switch (req.query.date) {
                    case null: now;
                    case date: Date.fromString(date);
                }
                MySql.db.getDeliveries(date)
                    .handle(o -> switch (o) {
                        case Success(deliveries):
                            var time:TimeSlotType = req.query.time;
                            if (time != null)
                                deliveries = deliveries.filter(d -> TimeSlotType.classify(d.pickupTimeSlot.start) == time);
                            if (user.isAdmin) {
                                res.json({
                                    deliveries: deliveries,
                                });
                            } else {
                                res.json({
                                    deliveries: deliveries.map(d -> {
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
                                    }),
                                });
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
                res.status(406).end("Can only return html or json");
                return;
        }
    }

    static public function setup(app:Application) {
        app.get("/admin", Admin.setTg, Admin.setCourier, Admin.ensurePermission, Admin.get);
        app.post("/admin", Admin.setTg, Admin.setCourier, Admin.ensurePermission, Admin.post);
    }
}