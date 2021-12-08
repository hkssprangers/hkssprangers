package hkssprangers.server;

import tink.core.ext.Promises;
import hkssprangers.browser.forms.*;
import tink.core.Error.ErrorCode;
import js.lib.Promise;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import haxe.Json;
import hkssprangers.server.ServerMain.*;
import hkssprangers.info.TimeSlot;
import telegram_typings.User as TgUser;
using hkssprangers.db.DatabaseTools;
using hkssprangers.server.FastifyTools;
using StringTools;
using hkssprangers.ObjectTools;

typedef OrderFoodProps = {
    final tgBotName:String;
    final user:String;
    final prefill:OrderFormPrefill;
    final currentTime:LocalDateString;
}

class OrderFood extends View<OrderFoodProps> {
    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

    public var user(get, never):String;
    function get_user() return props.user;

    public var prefill(get, never):OrderFormPrefill;
    function get_prefill() return props.prefill;

    public var currentTime(get, never):LocalDateString;
    function get_currentTime() return props.currentTime;

    override public function description() return "叫外賣";
    override function canonical() return Path.join(["https://" + host, "order-food"]);
    override public function render() {
        return super.render();
    }

    override function ogMeta() return jsx('
        <Fragment>
            <meta name="twitter:card" content="summary_large_image" />
            ${super.ogMeta()}
            <meta property="og:type" content="website" />
            <meta property="og:image" content=${Path.join(["https://" + host, R("/images/ssprangers4-y.png")])} />
        </Fragment>
    ');

    override function bodyContent() {
        return jsx('
            <div>
                <div className="flex justify-center my-4">
                    <img src=${R("/images/ssprangers4-y.png")} className="rounded-full h-24 w-24" alt="埗兵" />
                </div>
                <div id="OrderView"
                    className="flex justify-center"
                    data-tg-bot-name=${tgBotName}
                    data-user=${Json.stringify(user)}
                    data-prefill=${Json.stringify(prefill)}
                    data-current-time=${currentTime}
                />
            </div>
        ');
    }

    static public function get(req:Request, reply:Reply) {
        return ensurePermission(req, reply)
            .then(ok -> {
                if (!ok) {
                    reply.redirect("/login?redirectTo=" + "/order-food".urlEncode());
                    return Promise.resolve(null);
                }
                ServerMain.tgMe.then(tgMe -> {
                    MySql.db.getPrefill(reply.getUser())
                        .toJsPromise()
                        .then(prefill -> {
                            final now = Date.now();
                            final pickupTimeSlot:JsonString<TimeSlot> = {
                                start: (now:LocalDateString),
                                end: (now:LocalDateString),
                            }
                            reply.sendView(OrderFood, {
                                tgBotName: tgMe.username,
                                user: reply.getUser(),
                                prefill: prefill.merge({
                                    pickupTimeSlot: pickupTimeSlot,
                                }),
                                currentTime: (Date.now():LocalDateString),
                            });
                        });
                });
            });
    }

    static public function post(req:Request, reply:Reply):Promise<Dynamic> {
        return ensurePermission(req, reply)
            .then(ok -> {
                if (!ok) {
                    reply.status(ErrorCode.Forbidden).send("Log in required.");
                    return Promise.resolve(null);
                }

                if (req.body == null) {
                    reply.status(ErrorCode.BadRequest).send("No request body.");
                    return Promise.resolve(null);
                }

                var user = reply.getUser();
                var formData:OrderFormData = req.body;
                var schema = OrderFormSchema.getSchema(formData, user);

                var validate = Ajv.call({
                    removeAdditional: "all",
                }).compile(schema);
                var isValid:Bool = validate.call(formData);
                if (!isValid) {
                    reply.status(ErrorCode.BadRequest).send(validate.errors.map(err -> err.message).join("\n"));
                    return Promise.resolve(null);
                }

                var now = Date.now();
                var delivery = OrderFormSchema.formDataToDelivery(formData, user);
                delivery.creationTime = now;
                delivery.deliveryCode = null;
                for (o in delivery.orders) {
                    o.creationTime = now;
                }
                var deliveries = [delivery];

                MySql.db.insertDeliveries(deliveries)
                    .toJsPromise()
                    .then(ids -> MySql.db.delivery
                        .select({
                            deliveryCode: delivery.deliveryCode,
                        })
                        .where(f -> f.deliveryId == ids[0]).first()
                        .toJsPromise()
                    )
                    .then(result -> {
                        delivery.deliveryCode = result.deliveryCode;
                        TelegramTools.notifyNewDeliveries(deliveries, ServerMain.deployStage);
                    })
                    .then(_ -> ServerMain.notifyDeliveryRequestReceived(delivery))
                    .then(_ -> null);
            });
    }

    static public function ensurePermission(req:Request, reply:Reply):Promise<Bool> {
        return ServerMain.setUser(req, reply)
            .then(_ -> {
                reply.getUser() != null;
            });
    }

    static public function setup(app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>) {
        app.get("/order-food", OrderFood.get);
        app.post("/order-food", OrderFood.post);
    }
}