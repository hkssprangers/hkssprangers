package hkssprangers.server;

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
import js.npm.express.*;
import js.Node.*;
import hkssprangers.TelegramConfig;
import hkssprangers.info.*;
using StringTools;
using Lambda;
using hkssprangers.info.DeliveryTools;
using hkssprangers.server.ExpressTools;

class ServerMain {
    static final isMain = js.Syntax.code("require.main") == js.Node.module;
    static public final deployStage:DeployStage = Sys.getEnv("DEPLOY_STAGE");
    static public var host(default, null) = Sys.getEnv("SERVER_HOST");
    static public var app:Application;
    static public var tgBot:Telegraf<Dynamic>;
    static public var tgMe:Promise<TgUser>;

    static function allowCors(req:Request, res:Response, next):Void {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        next();
    }

    static function index(req:Request, res:Response) {
        res.redirect("https://www.facebook.com/hkssprangers");
    }

    static function tgAuth(req:Request, res:Response) {
        // expires 7 day from now
        var expires = Date.fromTime(Date.now().getTime() + DateTools.days(7));

        res.cookie("tg", Json.stringify({
            var tg:DynamicAccess<String> = {};
            for (k => v in (req.query:DynamicAccess<String>))
                if (k != "redirectTo")
                    tg[k] = v;
            tg;
        }), {
            secure: true,
            sameSite: 'strict',
            expires: expires,
        });

        switch (req.query.redirectTo:String) {
            case null:
                res.redirect("/");
                return;
            case redirectTo:
                res.redirect(redirectTo);
                return;
        }
    }

    static function main() {
        var tgBotWebHook = '/tgBot/${TelegramConfig.tgBotToken}';
        tgBot = new Telegraf(TelegramConfig.tgBotToken);
        tgMe = tgBot.telegram.getMe();
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
        tgBot.start((ctx:Context) -> {
            trace("/start");
            MySql.db.courier.where(r -> r.courierTgId == (cast ctx.from.id:Int) || r.courierTgUsername == ctx.from.username).first().handle(o -> switch o {
                case Success(courierData):
                    ctx.reply('你好!', {
                        reply_markup: Markup.inlineKeyboard_([
                            Markup.loginButton_("登入", Path.join(["https://" + host, "tgAuth?redirectTo=%2Fadmin"]), {
                                request_write_access: true,
                            }),
                        ]),
                    });
                case Failure(failure):
                    if (failure.code == 404) {
                        ctx.reply('你好!');
                    } else {
                        trace(failure.message + "\n\n" + failure.exceptionStack);
                        ctx.reply(failure.message);
                    }
            });
        });
        tgBot.catch_((err, ctx:Context) -> {
            console.error(err);
        });

        app = new Application();

        // let telegraf process things before using any middleware like body-parser that may mess up
        app.use(tgBot.webhookCallback(tgBotWebHook));

        app.set('json spaces', 2);
        app.use(function(req:Request, res:Response, next):Void {
            res.locals = {
                req: req,
            };
            next();
        });
        app.use(Express.Static(StaticResource.resourcesDir, {
            setHeaders: function(res:Response, path:String, stat:js.node.fs.Stats) {
                var req:Request = res.locals.req;
                var md5:Null<String> = req.query.md5;
                if (md5 == null)
                    return;

                var actual = StaticResource.hash(path);
                if (md5 == actual) {
                    res.setHeader("Cache-Control", "public, max-age=604800, immutable"); // 7 days
                } else {
                    res.setHeader("Cache-Control", "no-cache");
                }
            },
        }));
        app.use(function(req:Request, res:Response, next) {
            if (req.path.endsWith('/') && req.path.length > 1) {
                var query = req.url.substr(req.path.length);
                res.redirect(301, req.path.substr(0, req.path.length-1) + query);
            } else {
                next();
            }
        });
        app.use(allowCors);
        app.use(require("cookie-parser")());
        app.use(require("body-parser").json());

        app.get("/", index);
        app.get("/tgAuth", tgAuth);
        app.get("/login", LogIn.middleware);
        app.get("/admin", Admin.ensureCourier, Admin.get);
        app.post("/admin", Admin.ensureCourier, Admin.post);
        app.get("/server-time", function(req:Request, res:Response) {
            res.end(DateTools.format(Date.now(), "%Y-%m-%d_%H:%M:%S"));
        });
        // app.get("/admin/orders.json", )

        if (isMain) {
            switch (Sys.args()) {
                case []:
                    var port = 3000;
                    var ngrokUrl:Promise<String> = require("ngrok").connect(port);
                    var certs:Promise<Dynamic> = require("https-localhost")().getCerts();

                    ngrokUrl.then((url:String) -> {
                        host = new URL(url).host;
                        certs.then(certs ->
                            js.Node.require("httpolyglot").createServer(certs, app)
                                .listen(port, function(){
                                    Sys.println('https://127.0.0.1');
                                    Sys.println(url);
                                    var hook = Path.join([url, tgBotWebHook]);
                                    tgBot.telegram.setWebhook(hook)
                                        .then(_ -> tgMe)
                                        .then(me -> {
                                            Sys.println('https://t.me/${me.username}');
                                        });
                                })
                        );
                    });
                case ["setTgWebhook"]:
                    var hook = Path.join(["https://" + host, tgBotWebHook]);
                    tgBot.telegram.setWebhook(hook);
                case args:
                    throw "Unknown args: " + args;
            }
        } else {
            var serverless = require('serverless-http');
            js.Node.exports.handler = serverless(app, {
                binary: [
                    'image/*'
                ],
            });
        }
    }
}
