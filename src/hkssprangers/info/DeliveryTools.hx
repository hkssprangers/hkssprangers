package hkssprangers.info;

using hkssprangers.info.OrderTools;
using hkssprangers.info.TgTools;
using hkssprangers.info.TimeSlotTools;
using Lambda;

class DeliveryTools {
    static public function print(d:Delivery):String {
        var buf = new StringBuf();

        buf.add("外賣員: " + d.courier.tg.print() + "\n");

        for (order in d.orders) {
            buf.add(order.print());
        }

        buf.add("\n");
        var foodTotal = d.orders.fold((order:Order, result:Float) -> result + order.orderPrice, 0.0);
        buf.add("食物價錢: " + foodTotal + "\n");
        buf.add("食物+運費: " + (foodTotal + d.deliveryFee) + "\n");

        buf.add("\n");
        buf.add("客人交收時段: " + d.pickupTimeSlot.print() + "\n");
        buf.add("tg: " + d.customer.tg.print() + "\n");
        buf.add(d.customer.tel + "\n");
        buf.add(d.paymentMethods.map(p -> p.info().name).join(", ") + "\n");
        buf.add(d.pickupLocation + " (" + d.pickupMethod.info().name + ")\n");

        return buf.toString();
    }
}