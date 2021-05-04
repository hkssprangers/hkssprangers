package hkssprangers.info;

import thx.Decimal;
using StringTools;
using hkssprangers.MathTools;

class OrderTools {
    static public function print(order:Order):String {
        var buf = new StringBuf();

        buf.add("🔸 " + (order.shop != null ? order.shop.info().name : "null") + "\n");

        if (order.orderDetails != null)
            buf.add(order.orderDetails + "\n");

        if (order.customerNote != null)
            buf.add("⚠️ " + order.customerNote + "\n");

        if (order.wantTableware != null) {
            var t = switch (order.shop) {
                case BlaBlaBla:
                    order.wantTableware ? "要飲管" : "唔要飲管";
                case _:
                    order.wantTableware ? "要餐具" : "唔要餐具";
            }
            buf.add(t + "\n");
        }

        if (order.orderPrice != null && !Math.isNaN(order.orderPrice)) {
            var label = switch (order.shop) {
                case BlaBlaBla:
                    "飲品價錢";
                case _:
                    "食物價錢";
            }
            buf.add(label + ": $" + order.orderPrice + "\n");
        }

        return buf.toString().trim();
    }

    static public function parsePrice(str:String):Null<Int> {
        var r = ~/\$(\d+)/;
        if (!r.match(str))
            return null;

        return Std.parseInt(r.matched(1));
    }

    static public function parseTotalPrice(orderStr:String):Int {
        var multi = ~/^.+: (\d+)份$/;
        return orderStr.split("\n").map(line -> {
            if (multi.match(line)) {
                var n = Std.parseInt(multi.matched(1));
                var each = parsePrice(line);
                each * n;
            } else {
                line.split(", ").map(parsePrice).sum();
            }
        }).sum();
    }

    static public function setPlatformServiceCharge(order:Order):Void {
        order.platformServiceCharge = (order.orderPrice:Decimal) * 0.15;
    }
}