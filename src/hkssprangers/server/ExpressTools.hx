package hkssprangers.server;

import hkssprangers.info.Courier;
import hkssprangers.info.Tg;
import js.npm.express.*;
import react.*;

class ExpressTools {
    static public function sendView(res:Response, view, ?props:Dynamic):Void {
        if (props == null)
            props = {};

        try {
            var element = React.createElement(view, props);
            var stream = ReactDOMServer.renderToStaticNodeStream(element);
            res.set("Content-Type", 'text/html');
            res.write("<!DOCTYPE html>");
            stream.pipe(res);
            stream.once("error", function(e) throw e);
            stream.once("end", function() res.end());
        } catch (e:Dynamic) {
            throw e;
        }
    }

    static public function getUserTg(res:Response):Null<Tg> {
        return res.locals.tg;
    }
    static public function setUserTg(res:Response, tg:Null<Tg>):Void {
        res.locals.tg = tg;
    }
    static public function getCourier(res:Response):Null<Courier> {
        return res.locals.courier;
    }
    static public function setCourier(res:Response, courier:Null<Courier>):Void {
        res.locals.courier = courier;
    }
}