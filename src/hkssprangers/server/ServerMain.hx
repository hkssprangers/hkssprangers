package hkssprangers.server;

import haxe.crypto.Sha256;
import js.lib.Promise;
import telegraf.typings.markup.InlineKeyboardButton;
import haxe.Json;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import telegraf.Telegraf;
import telegraf.Context;
import telegraf.Extra;
import telegraf.Markup;
import js.npm.express.*;
import js.Node.*;
import comments.CommentString.*;
import hkssprangers.info.*;
import hkssprangers.info.menu.EightyNineItem;
using StringTools;
using Lambda;
using hkssprangers.info.DeliveryTools;
using hkssprangers.server.ExpressTools;

class ServerMain {
    static final isMain = js.Syntax.code("require.main") == module;
    static public final tgBotToken = Sys.getEnv("TGBOT_TOKEN");
    static public var app:Application;
    static public var tgBot:Telegraf<Dynamic>;

    static function allowCors(req:Request, res:Response, next):Void {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        next();
    }

    static function index(req:Request, res:Response) {
        tgBot.telegram.getMe()
            .then(me -> res.sendView(Index, {
                tgBotName: me.username,
            }))
            .catchError(err -> res.status(500).json(err));
    }

    static function main() {
        var tgBotWebHook = '/tgBot/${tgBotToken}';
        tgBot = new Telegraf(tgBotToken);
        tgBot.catch_((err, ctx:Context) -> {
            console.error(err);
        });

        var kbd = Markup.inlineKeyboard_(cast ([
            Markup.callbackButton_("delete", "delete"),
        ]:Array<Dynamic>));

        function counterMsg(ctx:Context) {
            var fromLink = 'tg://user?id=${ctx.from.id}';
            var name = switch (ctx.from) {
                case {first_name: null, last_name: null}:
                    'anonymous';
                case {first_name: null, last_name: last_name}:
                    '${last_name}';
                case {first_name: first_name, last_name: null}:
                    '${first_name}';
                case {first_name: first_name, last_name: last_name}:
                    '${first_name} ${last_name}';
            }
            var counter = Std.random(100);
            return comment(unindent, format)/**
                Hello, <a href="${fromLink.htmlEscape()}">${name.htmlEscape()}</a>!
                Counter: ${counter}
            **/;
        }

        tgBot.start((ctx:Context) -> {
            ctx.reply("started", new Extra({}).HTML(true).markup(kbd));
        });
        tgBot.action("delete", (ctx:Context) -> ctx.deleteMessage());

        app = new Application();
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
                    res.setHeader("Cache-Control", "public, max-age=604800"); // 7 days
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
        app.get("/login", LogIn.middleware);
        app.get("/admin", Admin.ensureAdmin, Admin.get);
        app.post("/admin", Admin.ensureAdmin, Admin.post);
        app.use(tgBot.webhookCallback(tgBotWebHook));
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

                    ngrokUrl.then((url:String) ->
                        certs.then(certs ->
                            js.Node.require("httpolyglot").createServer(certs, app)
                                .listen(port, function(){
                                    Sys.println('https://127.0.0.1');
                                    Sys.println(url);
                                    var hook = Path.join([url, tgBotWebHook]);
                                    tgBot.telegram.setWebhook(hook)
                                        .then(_ -> tgBot.telegram.getMe())
                                        .then(me -> {
                                            Sys.println('https://t.me/${me.username}');
                                        });
                                })
                        )
                    );
                case ["setTgWebhook"]:
                    var hook = Path.join([domain, tgBotWebHook]);
                    tgBot.telegram.setWebhook(hook);
                case ["setTgWebhook", var domain]:
                    var hook = Path.join([domain, tgBotWebHook]);
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
