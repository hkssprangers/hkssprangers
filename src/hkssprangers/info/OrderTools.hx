package hkssprangers.info;

using StringTools;
using hkssprangers.MathTools;

class OrderTools {
    static public function print(order:Order):String {
        var buf = new StringBuf();

        buf.add("🔸 " + order.shop.info().name + "\n");

        buf.add(order.orderDetails + "\n");

        buf.add(order.wantTableware ? "要餐具\n" : "唔要餐具\n");

        buf.add("食物價錢: $" + order.orderPrice + "\n");

        if (order.customerNote != null)
            buf.add("⚠️ " + order.customerNote + "\n");

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
}