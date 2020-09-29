package hkssprangers.info;

import hkssprangers.info.menu.EightyNineItem;

class OrderTools {
    static public function print(order:Order):String {
        var buf = new StringBuf();

        buf.add("🔸 " + order.shop.info().name + "\n");

        buf.add(order.orderDetails + "\n");

        buf.add(order.wantTableware ? "要餐具\n" : "唔要餐具\n");

        buf.add("食物價錢: $" + order.orderPrice + "\n");

        return buf.toString();
    }
}