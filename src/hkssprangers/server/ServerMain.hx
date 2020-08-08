package hkssprangers.server;

import js.npm.express.*;
import js.Node.*;
using hkssprangers.server.ExpressTools;
using StringTools;
using Lambda;

class ServerMain {
    static final isMain = js.Syntax.code("require.main") == module;
    static public var app:Application;

    static function allowCors(req:Request, res:Response, next):Void {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        next();
    }

    static function index(req:Request, res:Response) {
        res.sendView(Index);
    }

    static function main() {
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

        if (isMain) {
            var port = 3000;
            require("https-localhost")().getCerts().then(certs ->
                js.Node.require("httpolyglot").createServer(certs, app)
                    .listen(port, function(){
                        Sys.println('https://127.0.0.1:$port');
                    })
            );
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
