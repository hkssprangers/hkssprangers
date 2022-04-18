package hkssprangers.server;

import twilio.lib.twiml.MessagingResponse;
import tink.sql.Expr.Functions;
import haxe.crypto.Sha256;
import tink.core.Error;
import jsonwebtoken.verifier.BasicVerifier;
import jsonwebtoken.Claims;
import jsonwebtoken.signer.BasicSigner;
import jsonwebtoken.crypto.NodeCrypto;
import js.node.url.URL;
import haxe.DynamicAccess;
import js.lib.Promise;
import node.url.URLSearchParams;
import haxe.Json;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import telegraf.Telegraf;
import telegraf.Context;
import telegraf.Extra;
import telegraf.Markup;
import typegram.User as TgUser;
import Fastify;
import fastify.*;
import js.Node.*;
import hkssprangers.TelegramConfig;
import hkssprangers.info.*;
import hkssprangers.info.Shop;
import hkssprangers.info.menu.*;
import comments.CommentString.*;
using StringTools;
using Lambda;
using hkssprangers.info.DeliveryTools;
using hkssprangers.server.FastifyTools;
using hkssprangers.info.TimeSlotTools;

class ServerMain {
    static final isMain = js.Syntax.code("require.main") == js.Node.module;
    static public final deployStage:DeployStage = Sys.getEnv("DEPLOY_STAGE");
    static public var protocal = "https://";
    static public var host = switch (Sys.getEnv("SERVER_HOST")) {
        case null: "127.0.0.1";
        case v: v;
    }
    static public var app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>;
    static public var tgBot:Telegraf<Dynamic>;
    static public var tgMe:Promise<TgUser>;
    static public final tgBotWebHook = '/tgBot/${TelegramConfig.tgBotToken}';

    static public var twilio:twilio.Twilio;

    static public final authCookieName = "auth";

    static final jwtIssuer = host;
    static final jstSecret = switch (Sys.getEnv("JWT_SECRET")) {
        case null: Std.string(Std.random(10000000));
        case v: v;
    }
    static final jwtCrypto = new NodeCrypto();
    static public final jwtSigner = new BasicSigner(HS256(jstSecret), jwtCrypto);
    static public final jwtVerifier = new BasicVerifier(HS256(jstSecret), jwtCrypto, { iss: jwtIssuer });
    static public function jwtSign(payload:Claims) {
        if (payload.iss == null)
            payload.iss = jwtIssuer;
        if (payload.iat == null)
            payload.iat = Date.now();
        return jwtSigner.sign(payload);
    }
    static public function jwtVerifyToken<T:Claims>(token:String):tink.core.Promise<T> {
        return if (token == null)
            tink.core.Promise.reject(new Error(ErrorCode.Unauthorized, "no token"));
        else
            jwtVerifier.verify(token);
    }

    static function index(req:Request, reply:Reply):Promise<Dynamic> {
        reply.redirect("https://www.facebook.com/hkssprangers");
        return Promise.resolve();
    }

    static function twilioWebhook(req:Request, reply:Reply):Promise<Dynamic> {
        var now = Date.now();
        var twilioSignature = (req.headers:DynamicAccess<String>)["x-twilio-signature"];
        var reqBody:{
            SmsMessageSid:String,
            NumMedia:String,
            ProfileName:String,
            SmsSid:String,
            WaId:String, // 852xxxxxxxx
            SmsStatus:String, // "received"
            Body:String,
            To:String, // "whatsapp:+852xxxxxxxx"
            NumSegments:String,
            MessageSid:String,
            AccountSid:String,
            From:String, // "whatsapp:+852xxxxxxxx"
            ApiVersion:String, // "2010-04-01"
        } = req.body;
        if (reqBody.AccountSid != TwilioConfig.sid) {
            trace("Wrong Twilio account sid.");
            reply.status(ErrorCode.Unauthorized).send("Wrong Twilio account sid.");
            return Promise.resolve();
        }
        if (!Twilio.validateRequest(TwilioConfig.authToken, twilioSignature, Path.join([protocal + host, "twilio"]), cast reqBody)) {
            trace("Request validation failed.");
            reply.status(ErrorCode.Unauthorized).send("Request validation failed.");
            return Promise.resolve();
        }
        // trace(haxe.Json.stringify(reqBody, null, "  "));

        var promises:Array<Promise<Dynamic>> = [];
        promises.push(CockroachDb.db.twilioMessage.insertOne({
            twilioMessageId: null,
            creationTime: now,
            data: reqBody,
        }).toJsPromise());

        if (reqBody.Body.trim() == "登入落單") {
            var validDays = 90;
            var expires = Date.fromTime(now.getTime() + DateTools.days(validDays));
            
            var r = ~/^whatsapp:\+852([0-9]{8})$/;
            if (!r.match(reqBody.From)) {
                throw "Cannot parse from whatsapp number";
            }
            var tel = r.matched(1);

            var payload:CookiePayload = {
                iss: jwtIssuer,
                iat: now,
                exp: expires,
                sub: {
                    login: WhatsApp,
                    tel: tel,
                }
            }
            promises.push(
                jwtSigner.sign(cast payload)
                .toJsPromise()
                .then(signed -> {
                    var link = Path.join([protocal + host, "jwtAuth?redirectTo=%2Forder-food&jwt=" + signed]);
                    var twiml = new MessagingResponse();
                    twiml.message(comment(unindent, format)/**
                        你好！以下登入連結 ${validDays} 日內有效。你可以隨時再同我講「登入落單」拎個新嘅登入連結。
                        ${link}
                    **/);
                    reply.type("text/xml").send(twiml.toString());
                })
            );
        } else {
            var twiml = new MessagingResponse();
            twiml.message(comment(unindent, format)/**
                唔好意思。我唔係好識「登入落單」以外嘅嘢...
                如果有問題，麻煩你聯絡返我哋 Facebook，會有真人回答你 🙇‍
                https://m.me/hkssprangers
            **/);
            reply.type("text/xml").send(twiml.toString());
        }
        return Promise.all(promises);
    }

    static function jwtAuth(req:Request, reply:Reply):Promise<Dynamic> {
        var redirectTo = switch (req.query.redirectTo:String) {
            case null:
                "/";
            case redirectTo:
                redirectTo;
        }
        var jwt = switch (req.query.jwt:String) {
            case null:
                reply.status(400).send("Missing jwt");
                return Promise.resolve();
            case jwt:
                jwt;
        }

        return ServerMain.jwtVerifier.verify(jwt)
            .toJsPromise()
            .then(token -> {
                var payload:CookiePayload = cast token;
                var p = new URLSearchParams();
                p.set(authCookieName, jwt);
                reply.setCookie(authCookieName, jwt, {
                    secure: true,
                    sameSite: 'strict',
                    expires: payload.exp.toDate(),
                    httpOnly: true,
                })
                .redirect(redirectTo + "?" + p);
            })
            .catchError(err -> {
                reply.status(400).send('Token failed validation.\n\n' + err);
                return Promise.resolve();
            });
    }

    static function tgAuth(req:Request, reply:Reply):Promise<Dynamic> {
        // expires 7 day from now
        final now = Date.now();
        final expires = Date.fromTime(now.getTime() + DateTools.days(7));

        final redirectTo = switch (req.query.redirectTo:String) {
            case null:
                "/";
            case redirectTo:
                redirectTo;
        }

        if (redirectTo.startsWith("https://")) {
            final redirectUrl = new URL(redirectTo);
            if (redirectUrl.host != host) {
                return Promise.resolve(reply.redirect(Path.join([redirectUrl.origin, "tgAuth?" + new URLSearchParams(req.query)])));
            }
        }

        final tg:Dynamic = {
            var tg:DynamicAccess<String> = {};
            for (k => v in (req.query:DynamicAccess<String>))
                if (k != "redirectTo")
                    tg[k] = v;
            tg;
        };

        if (!TelegramTools.verifyLoginResponse(Sha256.encode(TelegramConfig.tgBotToken), tg)) {
            reply.status(400).send("Cannot verify Telegram login.");
            return Promise.resolve();
        }

        final payload:CookiePayload = {
            iss: jwtIssuer,
            iat: now,
            exp: expires,
            sub: {
                login: Telegram,
                tg: tg,
            }
        }
        return jwtSigner.sign(cast payload)
            .toJsPromise()
            .then(signed -> {
                final p = new URLSearchParams();
                p.set(authCookieName, signed);
                reply.setCookie(authCookieName, signed, {
                    secure: true,
                    sameSite: 'strict',
                    expires: expires,
                    httpOnly: true,
                })
                .redirect(redirectTo + "?" + p);
            });
    }

    static function noTrailingSlash(req:Request, reply:Reply):Promise<Any> {
        var url = new node.url.URL(req.raw.url, "http://example.com");
        if (url.pathname.endsWith('/') && url.pathname.length > 1) {
            var redirectTo = url.pathname.substr(0, url.pathname.length-1) + url.search;
            reply.redirect(redirectTo);
        }
        return Promise.resolve();
    }

    static public function setUser(req:Request, reply:Reply):Promise<Void> {
        var cookie:JsonString<CookiePayload> = Reflect.field(req.query, ServerMain.authCookieName);

        if (cookie == null) {
            cookie = Reflect.field(req.getCookies(), ServerMain.authCookieName);
        }

        if (cookie == null) {
            return Promise.resolve();
        }

        return ServerMain.jwtVerifier.verify(cookie)
            .toJsPromise()
            .then(token -> {
                var payload:CookiePayload = cast token;
                reply.setUser(payload.sub.parse());
            })
            .catchError(err -> {
                trace('Error parsing auth cookie.\n\n' + err);
                return Promise.resolve();
            });
    }

    static function initServer(?opts:Dynamic) {
        if (opts == null)
            opts = {}

        opts.rewriteUrl = function(req:Request):String {
            return StaticResource.rewriteUrl(req.url);
        }

        var app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic> = Fastify.fastify(opts);

        app.setErrorHandler(function(error, request, reply):Promise<Dynamic> {
            trace(error);
            reply.status(500).send(error);
            return Promise.resolve();
        });

        // var p:Promise<Dynamic> = cast app.register(require('fastify-express'));
        // p.then(_ -> {
        //     // let telegraf process things before using any middleware like body-parser that may mess up
        //     (untyped app.use)(tgBot.webhookCallback(tgBotWebHook));
        // });
        app.register(require('fastify-telegraf'), { bot: tgBot, path: tgBotWebHook });
        // app.post(tgBotWebHook, function(req:Request, reply:Reply):Promise<Dynamic> {
        //     return tgBot.handleUpdate(req.body, reply.raw);
        // });

        app.register(require('fastify-formbody'));
        app.register(require('fastify-cookie'));
        app.register(require('fastify-accepts'));

        app.register(require('fastify-static'), {
            root: sys.FileSystem.absolutePath(StaticResource.resourcesDir),
            wildcard: false,
        });
        app.addHook("onSend", function(req:Request, reply:Reply, payload):Promise<Dynamic>{
            if (payload != null) switch (untyped payload.filename:String) {
                case null:
                    // pass
                case filename if (filename.endsWith(".pmtiles")):
                    reply.header("Cache-Control", "public, max-age=86400, stale-while-revalidate=604800"); // max-age: 1 day, stale-while-revalidate: 7 days
                    return Promise.resolve(payload);
                case filename:
                    var hash:Null<String> = req.query.md5;    
                    var actual = StaticResource.hash(filename);
                    if (hash == actual) {
                        reply.header("Cache-Control", "public, max-age=31536000, immutable"); // 1 year
                        return Promise.resolve(payload);
                    } else {
                        reply.header("Cache-Control", "no-cache");
                        var redirectUrl = new URL(req.url, "http://example.com");
                        redirectUrl.searchParams.delete("md5");
                        reply.redirect(StaticResource.fingerprint(redirectUrl.pathname, actual) + redirectUrl.search);
                        return Promise.resolve(null);
                    }
            }
            return Promise.resolve(payload);
        });

        app.addHook("onRequest", noTrailingSlash);

        app.get("/tgAuth", tgAuth);
        app.get("/jwtAuth", jwtAuth);
        app.post("/twilio", twilioWebhook);
        app.get("/login", LogIn.middleware);
        Index.setup(app);
        Menu.setup(app);
        OrderFood.setup(app);
        Admin.setup(app);
        PlumWineDIY.setup(app);
        FoodWasteRecycle.setup(app);
        app.get("/server-time", function(req:Request, reply:Reply):Promise<Dynamic> {
            return Promise.resolve(reply.send(DateTools.format(Date.now(), "%Y-%m-%d_%H:%M:%S")));
        });

        return Promise.resolve(app);
    }

    static public function notifyDeliveryRequestReceived(delivery:Delivery) {
        trace("notifyDeliveryRequestReceived");
        final msg = delivery.printReceivedMsg();
        switch (delivery.customerPreferredContactMethod) {
            case Telegram:
                tgMe.then(tgMe -> {
                    CockroachDb.db.tgPrivateChat
                        .where(r ->
                            r.botId == Std.string(tgMe.id)
                            &&
                            r.userId == delivery.customer.tg.id
                        )
                        .first()
                        .toJsPromise()
                        .then(chat -> chat.chatId)
                        .catchError(err -> {
                            trace(err);
                            delivery.customer.tg.id; // tg private chat's chat id should be the same as the user id
                        })
                        .then(chatId -> {
                            trace("telegram.sendMessage");

                            PromiseRetry.call(
                                function (retry, attempt) {
                                    return tgBot.telegram.sendMessage(
                                        chatId,
                                        msg,
                                        {
                                            disable_web_page_preview: true,
                                        }
                                    ).catchError(err -> {
                                        trace(err);
                                        cast retry(err);
                                    });
                                },
                                {
                                    retries: 3,
                                }
                            );
                        });
                });
            case WhatsApp:
                trace("twilio.messages.create");
                PromiseRetry.call(
                    function (retry, attempt) {
                        return twilio.messages.create({
                            from: "whatsapp:+85264507612",
                            to: 'whatsapp:+852' + delivery.customer.whatsApp,
                            body: msg,
                        }).catchError(err -> {
                            trace(err);
                            cast retry(err);
                        });
                    },
                    {
                        retries: 3,
                    }
                )
                    .then(msg -> {
                        trace(msg);
                        null;
                    });
            case _:
                throw "Unsupported";
        }
    }

    static function blackWindowSetMenu(ctx:Context):Promise<Dynamic> {
        final msg:String = ctx.message.text;
        final lines = msg.split("\n");
        final dateParser = ~/[0-9]{4}-[0-9]{2}-[0-9]{2}/;
        if (!dateParser.match(lines[0])) {
            return Promise.resolve(ctx.reply('喺第一行 /setmenu 後面搵唔到日期 (YYYY-MM-DD)'));
        }
        final dateStart:LocalDateString = dateParser.matched(0) + " 00:00:00";
        final dateEnd:LocalDateString = dateParser.matched(0) + " 23:59:59";
        final menu = try {
            BlackWindowMenu.parseMenu(lines.slice(1).join("\n"));
        } catch (err) {
            return Promise.resolve(ctx.reply(Std.string(err)));
        }
        return CockroachDb.db.menuItem
            .insertOne({
                menuItemId: null,
                creationTime: Date.now(),
                startTime: dateStart,
                endTime: dateEnd,
                shopId: BlackWindow,
                items: menu,
                deleted: false,
            })
            .toJsPromise()
            .then(_ -> ctx.reply(
                comment(unindent, format)/**
                    成功設定 ${dateStart.getDatePart()} 嘅餐牌。
                    網頁緩存關系，可能五分鐘後先會喺網頁見到最新資料。

                    ${Path.join([protocal + host, "menu", BlackWindow]) + "?date=" + dateStart.getDatePart()}
                **/,
                {
                    disable_web_page_preview: true,
                }
            ));
    }

    static function main() {
        tgBot = new Telegraf(TelegramConfig.tgBotToken);
        tgBot.catch_((err, ctx:Context) -> {
            console.error(err);
        });
        tgMe = PromiseRetry.call((retry, attempt) -> tgBot.telegram.getMe().catchError(err -> {
            trace(err);
            cast retry(err);
        }), {
            minTimeout: 1000 * 3, // 3 seconds
        });
        tgBot.use((ctx:Context, next:()->Promise<Dynamic>) -> {
            tgMe.then(me ->
                tink.core.Promise.inSequence([
                    CockroachDb.db.tgMessage.insertOne({
                        tgMessageId: null,
                        receiverId: Std.string(me.id),
                        updateType: ctx.updateType,
                        updateData: ctx.update,
                    }).noise(),
                    try {
                        if (ctx.update.message.chat.type != "private")
                            throw "not private chat";
                        final userId = Std.string(ctx.update.message.from.id);
                        final userUsername = ctx.update.message.from.username;
                        final chatId = Std.string(ctx.update.message.chat.id);
                        CockroachDb.db.tgPrivateChat.insertOne({
                            botId: Std.string(me.id),
                            userId: userId,
                            userUsername: userUsername,
                            chatId: chatId,
                            lastUpdateData: ctx.update,
                        }, {
                            update: u -> [
                                u.userUsername.set(Functions.values(u.userUsername)),
                                u.chatId.set(Functions.values(u.chatId)),
                                u.lastUpdateData.set(Functions.values(u.lastUpdateData)),
                            ]
                        }).noise();
                    } catch (err) {
                        tink.core.Promise.NOISE;
                    }
                ])
                    .toJsPromise()
                    .catchError(err -> {
                        trace("Failed to log tg message to db.\n" + err);
                        trace(haxe.Json.stringify(ctx.update));
                        null;
                    })
            )
                .then(_ -> next());
        });
        tgBot.start(function(ctx:Context):Promise<Dynamic> {
            trace("/start");
            switch (untyped ctx.chat.type) {
                case "private":
                        if (ctx.from.username == null) {
                            return ctx.reply(comment(unindent)/**
                                唔好意思。我留意到你未設定 Telegram username。咁嘅話我哋嘅外賣員唔可以直接聯絡到你。

                                麻煩你去設定返先，之後同我講 /start

                                關於 Telegram username: https://telegram.org/faq#q-what-are-usernames-how-do-i-get-one
                            **/);
                        }
                        final params = new URLSearchParams();
                        params.set("redirectTo", Path.join([protocal + host, "order-food"]));
                        final serverOrigin = switch (host) {
                            case Constants.canonicalHost: protocal + host;
                            case _: "https://master.ssprangers.com";
                        }
                        final loginUrl = Path.join([serverOrigin, "tgAuth?" + params]);
                        trace(loginUrl);
                        return ctx.reply('你好！請㩒「登入落單」制。', {
                            reply_markup: Markup.inlineKeyboard_([
                                Markup.loginButton_("登入落單", loginUrl, {
                                    request_write_access: true,
                                }),
                            ]),
                        })
                        .catchError(failure -> {
                            trace(failure.message + "\n\n" + failure.exceptionStack);
                            ctx.reply(failure.message);
                        });
                case _:
                    return Promise.resolve(null);
            }
        });
        tgBot.command("setmenu", (ctx:Context) -> {
            switch (Std.string(ctx.message.chat.id)) {
                case TelegramConfig.blackWindowGroupChatId:
                    blackWindowSetMenu(ctx);
                case _:
                    // blackWindowSetMenu(ctx);
                    ctx.reply(comment(unindent, format)/**
                        「/setmenu」唔可以喺度用。
                    **/);
            }
        });
        tgBot.on("text", function(ctx:Context):Promise<Dynamic> {
            switch (untyped ctx.chat.type) {
                case "private":
                    return ctx.reply(comment(unindent, format)/**
                        唔好意思。我唔係好識「/start」以外嘅嘢...
                        如果有問題，麻煩你聯絡返我哋 Facebook，會有真人回答你 🙇‍
                        https://m.me/hkssprangers
                    **/);
                case _:
                    return Promise.resolve(null);
            }
        });

        switch [TwilioConfig.sid, TwilioConfig.authToken] {
            case [null, null]:
                trace("No TWILIO_SID and TWILIO_AUTH_TOKEN, Twilio is not configured");
            case _:
                twilio = Twilio.call(TwilioConfig.sid, TwilioConfig.authToken);
        }

        if (isMain) {
            switch (Sys.args()) {
                case []:
                    initServer()
                        .then(app -> {
                            app.listen(80, "0.0.0.0");
                            ServerMain.protocal = "http://";
                            Sys.println(protocal + host);
                            Cloudflared.getHostname("http://cloudflared:44871/metrics");
                        })
                        .then(hostname -> {
                            Sys.println(hostname);
                            final url = new URL(hostname);
                            ServerMain.protocal = url.protocol + "//";
                            ServerMain.host = url.hostname;
                            var hook = Path.join([hostname, tgBotWebHook]);
                            tgBot.telegram.setWebhook(hook)
                                .then(_ -> tgMe)
                                .then(me -> {
                                    Sys.println('https://t.me/${me.username}');
                                });
                        })
                        .catchError(err -> {
                            trace(err);
                            Sys.exit(1);
                        });
                case ["holidays"]:
                    HkHolidays.main();
                case ["setTgWebhook"]:
                    var hook = Path.join([protocal + host, tgBotWebHook]);
                    trace(hook);
                    tgBot.telegram.setWebhook(hook);
                case args:
                    throw "Unknown args: " + args;
            }
        } else {
            js.Node.exports.handler = function(event, context) {
                return initServer().then(a -> {
                    AwsServerlessFastify.proxy(app = a, event, context, [
                        "image/png",
                        "image/jpeg",
                        "image/gif",
                        "image/bmp",
                        "image/webp",
                        "image/x-icon",
                    ]);
                });
            }
        }
    }
}
