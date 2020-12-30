package hkssprangers.server;

import hkssprangers.info.Courier;
import hkssprangers.info.Tg;
import fastify.FastifyReply;
import react.*;

class FastifyTools {
    static public function sendView(reply:Reply, view, ?props:Dynamic) {
        trace("sendView");

        if (props == null)
            props = {};

        return try {
            var element = React.createElement(view, props);
            var markup = ReactDOMServer.renderToStaticMarkup(element);
            trace(markup);
            reply
                .header("Content-Type", 'text/html')
                .send("<!DOCTYPE html>" + markup);
        } catch (e) {
            trace(e);
            throw e;
        }
    }

    static public function accepts(req:Request):accepts.Accepts {
        return untyped req.accepts();
    }

    static public function getCookies(req:Request):Dynamic<String> {
        return untyped req.cookies;
    }
    static public function setCookie(reply:Reply, name:String, value:String, options:Dynamic):Reply {
        return (untyped reply.setCookie)(name, value, options);
    }
    static public function clearCookie(reply:Reply, name:String, options:Dynamic):Reply {
        return (untyped reply.clearCookie)(name, options);
    }

    static public function getUserTg(reply:Reply):Null<Tg> {
        return untyped reply.tg;
    }
    static public function setUserTg(reply:Reply, tg:Null<Tg>):Void {
        untyped reply.tg = tg;
    }
    static public function getCourier(reply:Reply):Null<Courier> {
        return untyped reply.courier;
    }
    static public function setCourier(reply:Reply, courier:Null<Courier>):Void {
        untyped reply.courier = courier;
    }
    static public function getToken(reply:Reply):Null<Token> {
        return untyped reply.token;
    }
    static public function setToken(reply:Reply, token:Null<Token>):Void {
        untyped reply.token = token;
    }
}