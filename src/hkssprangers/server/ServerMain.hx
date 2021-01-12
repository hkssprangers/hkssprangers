package hkssprangers.server;

import tink.core.Error;
import jsonwebtoken.verifier.BasicVerifier;
import jsonwebtoken.Claims;
import jsonwebtoken.signer.BasicSigner;
import jsonwebtoken.crypto.NodeCrypto;
import js.node.url.URL;
import haxe.DynamicAccess;
import js.lib.Promise;
import haxe.Json;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import telegraf.Telegraf;
import telegraf.Context;
import telegraf.Extra;
import telegraf.Markup;
import telegram_typings.User as TgUser;
import Fastify;
import fastify.*;
import js.Node.*;
import hkssprangers.TelegramConfig;
import hkssprangers.info.*;
using StringTools;
using Lambda;
using hkssprangers.info.DeliveryTools;
using hkssprangers.server.FastifyTools;

class ServerMain {
    static final isMain = js.Syntax.code("require.main") == js.Node.module;
    static public final deployStage:DeployStage = Sys.getEnv("DEPLOY_STAGE");
    static public final host = switch (Sys.getEnv("SERVER_HOST")) {
        case null: "127.0.0.1";
        case v: v;
    }
    static public var app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic>;
    static public var tgBot:Telegraf<Dynamic>;
    static public var tgMe:Promise<TgUser>;
    static public final tgBotWebHook = '/tgBot/${TelegramConfig.tgBotToken}';

    static final jwtIssuer = host;
    static final jstSecret = switch (Sys.getEnv("JWT_SECRET")) {
        case null: Std.string(Std.random(10000000));
        case v: v;
    }
    static final jwtCrypto = new NodeCrypto();
    static final jwtSigner = new BasicSigner(HS256(jstSecret), jwtCrypto);
    static final jwtVerifier = new BasicVerifier(HS256(jstSecret), jwtCrypto, { iss: jwtIssuer });
    static public function jwtSign(payload:Claims) {
        if (payload.iss == null)
            payload.iss = jwtIssuer;
        if (payload.iat == null)
            payload.iat = Date.now();
        return jwtSigner.sign(payload);
    }
    static public function jwtVerifyToken(token:String):tink.core.Promise<Token> {
        return if (token == null)
            tink.core.Promise.reject(new Error(ErrorCode.Unauthorized, "no token"));
        else
            jwtVerifier.verify(token);
    }

    static function index(req:Request, reply:Reply):Promise<Dynamic> {
        reply.redirect("https://www.facebook.com/hkssprangers");
        return Promise.resolve();
    }

    static function tgAuth(req:Request, reply:Reply):Promise<Dynamic> {
        // expires 7 day from now
        var expires = Date.fromTime(Date.now().getTime() + DateTools.days(7));

        var redirectTo = switch (req.query.redirectTo:String) {
            case null:
                "/";
            case redirectTo:
                redirectTo;
        }

        reply
            .setCookie("tg", Json.stringify({
                var tg:DynamicAccess<String> = {};
                for (k => v in (req.query:DynamicAccess<String>))
                    if (k != "redirectTo")
                        tg[k] = v;
                tg;
            }), {
                secure: true,
                sameSite: 'strict',
                expires: expires,
            })
            .redirect(redirectTo);

        return Promise.resolve();
    }

    static function noTrailingSlash(req:Request, reply:Reply):Promise<Any> {
        var url = new node.url.URL(req.raw.url, "http://example.com");
        if (url.pathname.endsWith('/') && url.pathname.length > 1) {
            var redirectTo = url.pathname.substr(0, url.pathname.length-1) + url.search;
            reply.redirect(redirectTo);
        }
        return Promise.resolve();
    }

    static function initServer(?opts:Dynamic) {
        var app:FastifyInstance<Dynamic, Dynamic, Dynamic, Dynamic> = Fastify.fastify(opts);

        // var p:Promise<Dynamic> = cast app.register(require('fastify-express'));
        // p.then(_ -> {
        //     // let telegraf process things before using any middleware like body-parser that may mess up
        //     (untyped app.use)(tgBot.webhookCallback(tgBotWebHook));
        // });
        app.register(require('fastify-telegraf'), { bot: tgBot, path: tgBotWebHook });
        // app.post(tgBotWebHook, function(req:Request, reply:Reply):Promise<Dynamic> {
        //     return tgBot.handleUpdate(req.body, reply.raw);
        // });

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
                case filename:
                    var md5:Null<String> = req.query.md5;
                    if (md5 == null) {
                        return Promise.resolve(payload);
                    }
    
                    var actual = StaticResource.hash(filename);
                    if (md5 == actual) {
                        reply.header("Cache-Control", "public, max-age=604800"); // 7 days
                        return Promise.resolve(payload);
                    } else {
                        reply.header("Cache-Control", "no-cache");
                        var redirectUrl = new URL(req.url, "http://example.com");
                        redirectUrl.searchParams.set("md5", actual);
                        reply.redirect(redirectUrl.pathname + redirectUrl.search);
                        return Promise.resolve(null);
                    }
            }
            return Promise.resolve(payload);
        });

        app.addHook("onRequest", noTrailingSlash);

        app.get("/", index);
        app.get("/tgAuth", tgAuth);
        app.get("/login", LogIn.middleware);
        Admin.setup(app);
        app.get("/server-time", function(req:Request, reply:Reply):Promise<Dynamic> {
            return Promise.resolve(reply.send(DateTools.format(Date.now(), "%Y-%m-%d_%H:%M:%S")));
        });

        return Promise.resolve(app);
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
                MySql.db.tgMessage.insertOne({
                    tgMessageId: null,
                    receiverId: cast me.id,
                    updateType: ctx.updateType,
                    updateData: Json.stringify(ctx.update),
                })
                    .toJsPromise()
                    .then(v -> {
                        null;
                    })
                    .catchError(err -> {
                        trace("Failed to log tg message to db.\n" + err);
                        trace(ctx.update);
                        null;
                    })
            )
                .then(_ -> next());
        });
        tgBot.start(function(ctx:Context):Promise<Dynamic> {
            trace("/start");
            return switch (ctx.chat.type) {
                case "private":
                    MySql.db.courier.where(r -> r.courierTgId == (cast ctx.from.id:Int) || r.courierTgUsername == ctx.from.username).first()
                        .toJsPromise()
                        .then(courierData -> {
                            trace("send button to log in " + host);
                            ctx.reply('你好!', {
                                reply_markup: Markup.inlineKeyboard_([
                                    Markup.loginButton_("登入", Path.join(["https://" + host, "tgAuth?redirectTo=%2Fadmin"]), {
                                        request_write_access: true,
                                    }),
                                ]),
                            });
                        })
                        .catchError(failure -> {
                            trace(failure);
                            if (failure.code == 404) {
                                ctx.reply('你好!');
                            } else {
                                trace(failure.message + "\n\n" + failure.exceptionStack);
                                ctx.reply(failure.message);
                            }
                        });
                case _:
                    Promise.resolve(null);
            }
        });

        if (isMain) {
            switch (Sys.args()) {
                case []:
                    var port = 3000;
                    var ngrokUrl:Promise<String> = require("ngrok").connect(port);
                    var certs:Promise<Dynamic> = require("https-localhost")().getCerts();

                    ngrokUrl.then((url:String) -> {
                        certs.then(certs -> {
                            initServer({
                                serverFactory: (handler, opts) -> {
                                    require('@httptoolkit/httpolyglot').createServer(certs, handler);
                                },
                            });
                        }).then(a -> {
                            app = a;
                            app.listen(port, "0.0.0.0");
                        }).then(_ -> {
                            Sys.println('https://' + host);
                            Sys.println(url);
                            var hook = Path.join([url, tgBotWebHook]);
                            tgBot.telegram.setWebhook(hook)
                                .then(_ -> tgMe)
                                .then(me -> {
                                    Sys.println('https://t.me/${me.username}');
                                });
                        });
                    }).catchError(err -> {
                        trace(err);
                        Sys.exit(1);
                    });
                case ["setTgWebhook"]:
                    var hook = Path.join(["https://" + host, tgBotWebHook]);
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
