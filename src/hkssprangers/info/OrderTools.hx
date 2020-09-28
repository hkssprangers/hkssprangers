package hkssprangers.info;

import hkssprangers.info.menu.EightyNineItem;

class OrderTools {
    static public function print(order:Order):String {
        var buf = new StringBuf();

        buf.add("📃 " + order.shop.info().name + " " + order.orderCode + " (" + order.orderPrice + ")\n");

        buf.add(order.orderDetails + "\n");

        buf.add(order.wantTableware ? "要餐具\n" : "唔要餐具\n");

        return buf.toString();
    }
}