package hkssprangers.server;

import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import telegraf.Telegraf;
import telegraf.Context;
import js.npm.express.*;
import js.Node.*;
using hkssprangers.server.ExpressTools;
using StringTools;
using Lambda;

class ServerMain {
    static final isMain = js.Syntax.code("require.main") == module;
    static final mysqlEndpoint = Sys.getEnv("MYSQL_ENDPOINT");
    static final mysqlUser = Sys.getEnv("MYSQL_USER");
    static final mysqlPassword = Sys.getEnv("MYSQL_PASSWORD");
    static final tgBotToken = Sys.getEnv("TGBOT_TOKEN");
    static public var app:Application;
    static public var tgBot:Telegraf<Dynamic>;

    static function allowCors(req:Request, res:Response, next):Void {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        next();
    }

    static function index(req:Request, res:Response) {
        res.sendView(Index);
    }

    static function main() {
        var tgBotWebHook = '/tgBot/${tgBotToken}';
        tgBot = new Telegraf(tgBotToken);
        tgBot.on("text", (ctx:Context) -> {
            // var fromLink = 'tg://user?id=${ctx.from.id}';
            // var e = jsx('
            //     <Fragment>
            //         Hello, <a href=${fromLink}>${ctx.from.first_name} ${ctx.from.last_name}</a>!
            //         Your msg: ${ctx.message}
            //     </Fragment>
            // ');
            // ctx.replyWithHTML(ReactDOMServer.renderToString(e));
            ctx.reply('Hello, ${ctx.from.first_name} ${ctx.from.last_name}!');
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
        app.use(tgBot.webhookCallback(tgBotWebHook));

        if (isMain) {
            switch (Sys.args()) {
                case []:
                    var port = 3000;
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
