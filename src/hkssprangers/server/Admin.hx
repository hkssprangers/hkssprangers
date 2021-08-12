package hkssprangers.server;

import haxe.DynamicAccess;
import js.lib.Promise;
import tink.core.Error.ErrorCode;
import telegraf.Markup;
import tink.core.Noise;
import haxe.crypto.Sha256;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import haxe.Json;
import js.node.url.URL;
import js.node.Querystring;
import jsonwebtoken.Claims;
import hkssprangers.Token;
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
using hkssprangers.server.FastifyTools;
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

typedef AdminProps = {
    final fontSize:String;
    final tgBotName:String;
    final user:Null<Courier>;
    final token:Null<ShopAdminToken>;
}

class Admin extends View<AdminProps> {
    public var fontSize(get, never):String;
    function get_fontSize() return props.fontSize;

    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

    public var user(get, never):Null<Courier>;
    function get_user() return props.user;

    public var token(get, never):Null<ShopAdminToken>;
    function get_token() return props.token;

    override function title():String return if (token == null)
        "平台管理";
    else
        '${token.date} ${switch (token.time) { case Lunch: "午市"; case Dinner: "晚市"; }} ${token.shop.info().name} ${name}外賣單';

    override function canonical() return if (token == null)
        Path.join(["https://" + canonicalHost, "admin"]);
    else
        null;

    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${Path.join(["https://" + host, R("/images/ssprangers4-y.png")])} />
        </Fragment>
    ');

    override public function render() {
        return super.render();
    }

    override function htmlClasses() {
        return super.htmlClasses().concat(
            fontSize != null ? ["fontSize-" + fontSize] : []
        );
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

    static public function setCourier(req:Request, reply:Reply):Promise<Null<Courier>> {
        var tg = reply.getUserTg();

        if (tg == null) {
            return Promise.resolve(null);
        }

        return MySql.db.courier.where(r -> !r.deleted && (r.courierTgId == tg.id || r.courierTgUsername == tg.username)).first()
            .next(courierData -> {
                var courier:Courier = {
                    courierId: courierData.courierId,
                    tg: tg,
                    isAdmin: courierData.isAdmin,
                }

                reply.setCourier(courier);
                courier;
            })
            .tryRecover(failure -> {
                if (failure.code == 404) {
                    trace('${tg.username} (${tg.id}) is not one of the couriers.');
                } else {
                    trace(failure.message + "\n\n" + failure.exceptionStack);
                }
                tink.core.Promise.resolve(null);
            }).toJsPromise();
    }

    static public function setToken(req:Request, reply:Reply):Promise<Null<ShopAdminToken>> {
        return switch (req.query.token) {
            case null:
                Promise.resolve(null);
            case token:
                (ServerMain.jwtVerifyToken(token):tink.core.Promise<ShopAdminToken>)
                    .tryRecover(failure -> {
                        trace(failure.message + "\n\n" + failure.exceptionStack);
                        tink.core.Promise.resolve(null);
                    })
                    .next(token -> {
                        reply.setToken(token);
                        token;
                    })
                    .toJsPromise();
        }
    }

    static public function ensurePermission(req:Request, reply:Reply):Promise<Bool> {
        return ServerMain.setTg(req, reply)
            .then(_ -> setCourier(req, reply))
            .then(_ -> setToken(req, reply))
            .then(_ -> {
                if (reply.getCourier() != null) {
                    return true;
                }
                
                var tokenOk = switch (reply.getToken()) {
                    case null:
                        false;
                    case token:
                        true;
                }

                if (tokenOk) {
                    return true;
                } else {
                    return false;
                }
            });
    }

    static public function post(req:Request, reply:Reply):Promise<Dynamic> {
        return ensurePermission(req, reply).then(ok -> {
            if (!ok) {
                var url = new node.url.URL(req.raw.url, "http://example.com");
                return Promise.resolve(reply.redirect("/login?redirectTo=" + (url.pathname + url.search).urlEncode()));
            }
            var user:Courier = reply.getCourier();
            if (user == null || !user.isAdmin) {
                return Promise.resolve(reply.status(403).send('Only admins are allowed.')).then(_ -> null);
            }
            if (req.body == null) {
                return Promise.resolve(reply.status(ErrorCode.BadRequest).send("No request body.")).then(_ -> null);
            }
            switch (req.body.action:String) {
                case null:
                    Promise.resolve(reply.status(ErrorCode.BadRequest).send("No action.")).then(_ -> null);
                case "insert":
                    var delivery:Delivery = req.body.delivery;
                    MySql.db.insertDeliveries([delivery]).toJsPromise()
                        .then(dids -> MySql.db.delivery
                            .where(f -> f.deliveryId == dids[0])
                            .first()
                            .next(d -> d.toDelivery(MySql.db))
                            .toJsPromise()
                            .then(d -> {
                                reply.send(d);
                            })
                        )
                        .then(_ -> null);
                case "update":
                    var delivery:Delivery = req.body.delivery;
                    MySql.db.saveDelivery(delivery).toJsPromise()
                        .then(_ -> MySql.db.delivery
                            .where(f -> f.deliveryId == delivery.deliveryId)
                            .first()
                            .next(d -> d.toDelivery(MySql.db))
                            .toJsPromise()
                            .then(d -> {
                                reply.send(d);
                            })
                        )
                        .then(_ -> null);
                case "delete":
                    var delivery:Delivery = req.body.delivery;
                    MySql.db.deleteDelivery(delivery).toJsPromise()
                        .then(_ -> {
                            reply.send("ok");
                        })
                        .then(_ -> null);
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
                        reply.type("text");
                        reply.send("done");
                    }).catchError(err -> {
                        reply.type("text");
                        reply.status(500).send(Std.string(err));
                    })
                    .then(_ -> null);
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
                    }:ShopAdminToken));
                    ServerMain.jwtSign(payload).toJsPromise()
                        .then(token -> {
                            reply.type("text");
                            var qs:Dynamic = {
                                token: token,
                            };
                            switch (shop) {
                                case DongDong | MGY:
                                    qs.fontSize = "larger";
                                case _:
                                    //pass
                            }
                            reply.send(Path.join(["https://" + host, "admin?" + Querystring.stringify(qs)]));
                        })
                        .then(_ -> null);
                case "upload-get-signed-url":
                    var orderId:Int = req.body.orderId;
                    var contentType:String = req.body.contentType;
                    var fileName:String = req.body.fileName;
                    var ext = Path.extension(fileName);
                    new js.npm.aws_sdk.S3().getSignedUrlPromise("putObject", {
                        Bucket: "hkssprangers-uploads",
                        Key: '${user.courierId}/${orderId}/${Std.random(1000000)}.${ext}',
                        ContentType: contentType,
                    }).then(url -> {
                        reply.type("text");
                        reply.send(url);
                    }).catchError(err -> {
                        reply.type("text");
                        reply.status(500).send(Std.string(err));
                    }).then(_ -> null);
                case "upload-done":
                    var fileUrl:String = req.body.fileUrl;
                    var orderId:Int = req.body.orderId;
                    MySql.db.receipt.insertOne({
                        receiptId: null,
                        receiptUrl: fileUrl,
                        orderId: orderId,
                        uploaderCourierId: user.courierId,
                    }).toJsPromise()
                        .then(_ -> {
                            reply.type("text");
                            reply.send("done");
                        })
                        .catchError(err -> {
                            reply.type("text");
                            reply.status(500).send(Std.string(err));
                        })
                        .then(_ -> null);
                case action:
                    reply.type("text");
                    Promise.resolve(reply.status(406).send("Unknown action " + action)).then(_ -> null);
            }
        });
    }

    static public function uploadImage(img:js.node.Buffer):Promise<String> {
        var fileBytes = haxe.io.Bytes.ofData(img.buffer);
        var hash = haxe.crypto.Md5.make(fileBytes).toHex();
        var imageType = js.npm.image_type.ImageType.imageType(img);
        var fileName = hash + "." + imageType.ext;
        return new js.npm.aws_sdk.S3().upload({
            Bucket: "hkssprangers-uploads",
            Key: fileName,
            Body: img,
            ContentType: imageType.mime,
        }).promise()
            .then(_ -> "https://uploads.ssprangers.com/" + fileName);
    }

    static public function getByToken(req:Request, reply:Reply) {
        var token:ShopAdminToken = reply.getToken();
        return MySql.db.getDeliveries(token.date).toJsPromise()
            .then(deliveries -> {
                reply.send({
                    deliveries: deliveries
                        .filter(d ->
                            d.orders.exists(o -> o.shop == token.shop)
                            &&
                            TimeSlotType.classify(d.pickupTimeSlot.start) == token.time
                        )
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
            });
    }

    static public function get(req:Request, reply:Reply):Promise<Dynamic> {
        return ensurePermission(req, reply)
            .then(ok -> {
                if (!ok) {
                    var url = new node.url.URL(req.raw.url, "http://example.com");
                    return Promise.resolve(reply.redirect("/login?redirectTo=" + (url.pathname + url.search).urlEncode())).then(_ -> null);
                }
                var user = reply.getCourier();
                switch (req.accepts().type(["text/html", "application/json"])) {
                    case "text/html":
                        ServerMain.tgMe.then(tgBotInfo -> {
                            reply.sendView(Admin, {
                                tgBotName: tgBotInfo.username,
                                user: user,
                                token: reply.getToken(),
                                fontSize: req.query.fontSize,
                            });
                        }).then(_ -> null);
                    case "application/json":
                        var token = reply.getToken();
                        switch (token) {
                            case null:
                                // pass
                            case token:
                                return getByToken(req, reply);
                        }
                        var now = Date.now();
                        var date = switch (req.query.date) {
                            case null: now;
                            case date: Date.fromString(date);
                        }
                        return MySql.db.getDeliveries(date).toJsPromise()
                            .then(deliveries -> {
                                var time:TimeSlotType = req.query.time;
                                if (time != null)
                                    deliveries = deliveries.filter(d -> TimeSlotType.classify(d.pickupTimeSlot.start) == time);
                                if (user.isAdmin) {
                                    reply.send({
                                        deliveries: deliveries,
                                    });
                                } else {
                                    reply.send({
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
                            })
                            .then(_ -> null);
                    case type:
                        trace(type);
                        reply.type("text");
                        Promise.resolve(reply.status(406).send("Can only return html or json")).then(_ -> null);
                }
            });
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/admin", Admin.get);
        app.post("/admin", Admin.post);
    }
}