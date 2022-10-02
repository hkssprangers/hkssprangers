package hkssprangers.server;

import hkssprangers.info.TimeSlotTools;
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
import hkssprangers.info.LoggedinUser;
import typegram.User as TgUser;
import comments.CommentString.comment;
import comments.CommentString.format;
import comments.CommentString.unindent;
using hkssprangers.db.DatabaseTools;
using hkssprangers.server.FastifyTools;
using StringTools;
using hkssprangers.ObjectTools;
using hkssprangers.info.LoggedinUserTools;

typedef OrderFoodProps = {
    final tgBotName:String;
    final user:LoggedinUser;
    final prefill:OrderFormPrefill;
    final currentTime:LocalDateString;
}

class OrderFood extends View<OrderFoodProps> {
    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

    public var user(get, never):LoggedinUser;
    function get_user() return props.user;

    public var prefill(get, never):OrderFormPrefill;
    function get_prefill() return props.prefill;

    public var currentTime(get, never):LocalDateString;
    function get_currentTime() return props.currentTime;

    override public function description() return "叫外賣";
    override function canonical() return Path.join(["https://" + canonicalHost, "order-food"]);
    override public function render() {
        return super.render();
    }

    function fsIdentify() {
        final userId = Json.stringify(LoggedinUserTools.print(user));
        final content = {
            __html: comment(unindent, format)/**
                FS.identify($userId);
            **/
        };
        return jsx('
            <Fragment>
                <script dangerouslySetInnerHTML=${content}></script>
            </Fragment>
        ');
    }

    override function fullstory() return jsx('
        <Fragment>
            ${super.fullstory()}
            ${fsIdentify()}
        </Fragment>
    ');

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
                final now:LocalDateString = Date.now();
                final today = now.getDatePart();
                ServerMain.tgMe.then(tgMe -> {
                    CockroachDb.db.getPrefill(reply.getUser())
                        .toJsPromise()
                        .then(prefill -> {
                            final pickupTimeSlot:JsonString<TimeSlot> = {
                                start: today + " 00:00:00",
                                end: today + " 00:00:00",
                            }
                            reply.sendView(OrderFood, {
                                tgBotName: tgMe.username,
                                user: reply.getUser(),
                                prefill: prefill.merge({
                                    pickupTimeSlot: pickupTimeSlot,
                                }),
                                currentTime: now,
                            });
                        });
                });
            });
    }

    static public function getTimeSlotChoices(req:Request, reply:Reply):Promise<Dynamic> {
        final date:LocalDateString = switch (req.query.date) {
            case null:
                final now:LocalDateString = Date.now();
                Date.fromString(now.getDatePart() + " 09:00:00");
            case date if (~/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/.match(date)):
                Date.fromString(date + " 09:00:00");
            case date:
                throw "Invalid date: " + date;
        }
        return switch (req.query.now) {
            case null:
                final now = Date.now();
                TimeSlotTools.getTimeSlots(date, now)
                    .then(timeSlots -> reply
                        .code(200)
                        .header("Cache-Control", "no-store")
                        .header('Content-Type', 'application/json; charset=utf-8')
                        .send(tink.Json.stringify(timeSlots))
                    );
            case date:
                final now = Date.fromString(date);
                TimeSlotTools.getTimeSlots(date, now)
                    .then(timeSlots -> reply
                        .code(200)
                        .header("Cache-Control", "public, max-age=30, stale-while-revalidate=60") // max-age: 0.5 minute, stale-while-revalidate: 1 minutes
                        .header('Content-Type', 'application/json; charset=utf-8')
                        .send(tink.Json.stringify(timeSlots))
                    );
        }
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

                final user = reply.getUser();
                final formData:OrderFormData = req.body;
                return OrderFormSchema.getSchema(formData, user)
                    .then(schema -> {
                        final validate = Ajv.call({
                            removeAdditional: "all",
                        }).compile(schema);
                        final isValid:Bool = validate.call(formData);
                        if (!isValid) {
                            reply.status(ErrorCode.BadRequest).send(validate.errors.map(err -> err.message).join("\n"));
                            return Promise.resolve(null);
                        }

                        final now = Date.now();
                        return OrderFormSchema
                            .formDataToDelivery(formData, user)
                            .then(delivery -> {
                                delivery.creationTime = now;
                                delivery.deliveryCode = null;
                                for (o in delivery.orders) {
                                    o.creationTime = now;
                                }
                                final deliveries = [delivery];

                                CockroachDb.db.insertDeliveries(deliveries)
                                    .toJsPromise()
                                    .then(ids -> CockroachDb.db.delivery
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
                    });
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

        app.get('/time-slot-choices', OrderFood.getTimeSlotChoices);
    }
}