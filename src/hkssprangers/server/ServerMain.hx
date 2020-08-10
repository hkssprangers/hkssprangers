package hkssprangers.server;

import js.npm.telegraf_session_mysql.MySQLSession;
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
import hkssprangers.info.Info;
using StringTools;
using Lambda;
using hkssprangers.info.Info.DeliveryTools;
using hkssprangers.server.ExpressTools;

extern class SessionedContext extends Context {
    public var session:Dynamic;
}

class ServerMain {
    static function __init__() {
        require('dotenv').config();
    }

    static final delivery:Delivery = {
        courier: {
            tg: {
                username: "fghgjghjghmf"
            }
        },
        orders: [
            {
                shop: EightyNine,
                code: "01",
                timestamp: 1596965006,
                items: [
                    {
                        id: EightyNineSet,
                        data: {
                            main: EightyNineSetMain5,
                            sub: EightyNineSetSub1,
                            given: EightyNineSetGiven1,
                        }
                    },
                ],
                wantTableware: false,
                customerNote: null,
            }
        ],
        customer: {
            tg: {
                username: "asdfsdfasdfasdfsgdsggd",
            },
            tel: "12345648",
        },
        paymentMethods: [
            PayMe,
            FPS,
        ],
        pickupLocation: "長沙灣地鐵站C1地面",
        pickupDate: "2020-08-10",
        pickupTime: "19:00 - 20:00",
        pickupMethod: Street,
        deliveryFeeCents: 2500,
        customerNote: "如可以七點三至七半",
    }
    static final isMain = js.Syntax.code("require.main") == module;
    static final mysqlEndpoint = Sys.getEnv("MYSQL_ENDPOINT");
    static final mysqlUser = Sys.getEnv("MYSQL_USER");
    static final mysqlPassword = Sys.getEnv("MYSQL_PASSWORD");
    static final tgBotToken = Sys.getEnv("TGBOT_TOKEN");
    static public var app:Application;
    static public var tgBot:Telegraf<Dynamic>;
    static public var tgSession:MySQLSession;

    static function allowCors(req:Request, res:Response, next):Void {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        next();
    }

    static function index(req:Request, res:Response) {
        res.sendView(Index);
    }

    static function main() {
        trace(mysqlEndpoint);

        var tgBotWebHook = '/tgBot/${tgBotToken}';
        tgBot = new Telegraf(tgBotToken);

        tgSession = new MySQLSession({
            host: mysqlEndpoint,
            user: mysqlUser,
            password: mysqlPassword,
            database: "telegraf_sessions"
        });
        tgBot.use(tgSession.middleware());

        var kbd = Markup.inlineKeyboard_(cast ([
            Markup.callbackButton_("+1", "plusone"),
        ]:Array<Dynamic>));

        function counterMsg(ctx:SessionedContext) {
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
            var counter = switch (ctx.session.counter) {
                case null: 0;
                case v: v;
            };
            return comment(unindent, format)/**
                Hello, <a href="${fromLink.htmlEscape()}">${name.htmlEscape()}</a>!
                Counter: ${counter}
            **/;
        }

        tgBot.start((ctx:SessionedContext) -> {
            ctx.reply(delivery.print(), new Extra({}).HTML(true).markup(kbd));
        });
        tgBot.action('plusone', (ctx:SessionedContext) -> {
            var counter = switch (ctx.session.counter) {
                case null: 0;
                case v: v;
            };
            ctx.session.counter = counter + 1;
            ctx.editMessageText(counterMsg(ctx), new Extra({}).HTML(true).markup(kbd));
        });

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

        app.get("/", index);
        app.get("/test", function(req:Request, res:Response) {
            var connection = Mysql.createConnection({
                host: mysqlEndpoint,
                user: mysqlUser,
                password: mysqlPassword,
                database: "telegraf_sessions"
            });

            connection.connect();

            connection.query('SELECT 1 + 1 AS solution', function (error, results, fields) {
                if (error) throw error;
                console.log('The solution is: ', results[0].solution);
                res.end('The solution is: ' + results[0].solution);
            });

            connection.end();
        });
        app.use(tgBot.webhookCallback(tgBotWebHook));

        if (isMain) {
            switch (Sys.args()) {
                case []:
                    var port = 3000;
                    tgBot.launch()
                        .then(_ -> tgBot.telegram.getMe())
                        .then(me -> {
                            Sys.println('https://t.me/${me.username}');
                        });
                    require("https-localhost")().getCerts().then(certs ->
                        js.Node.require("httpolyglot").createServer(certs, app)
                            .listen(port, function(){
                                Sys.println('https://127.0.0.1:$port');
                            })
                    );
                case ["setTgWebhook"]:
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
