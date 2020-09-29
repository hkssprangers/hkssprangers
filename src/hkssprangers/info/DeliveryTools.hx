package hkssprangers.info;

using hkssprangers.info.OrderTools;
using hkssprangers.info.TgTools;
using hkssprangers.info.TimeSlotTools;
using Lambda;

class DeliveryTools {
    static public function print(d:Delivery):String {
        var buf = new StringBuf();

        buf.add("📃 " + d.deliveryCode + "\n\n");

        if (d.courier != null)
            buf.add("外賣員: " + d.courier.tg.print() + "\n");

        buf.add(d.orders.map(o -> o.print()).join("\n"));

        buf.add("\n");
        var foodTotal = d.orders.fold((order:Order, result:Float) -> result + order.orderPrice, 0.0);
        buf.add("總食物價錢+運費: $" + (foodTotal + d.deliveryFee) + "\n");

        buf.add("\n");
        buf.add(d.pickupTimeSlot.print() + "\n");
        if (d.customer.tg != null)
            buf.add((d.customerPreferredContactMethod == Telegram ? "☑ " : "☐ ") + d.customer.tg.print() + "\n");
        if (d.customer.tel != null)
            buf.add((d.customerPreferredContactMethod == WhatsApp ? "☑ " : "☐ ") + d.customer.tel + "\n");
        buf.add(d.paymentMethods.map(p -> p.info().name).join(", ") + "\n");
        buf.add(d.pickupLocation + " (" + d.pickupMethod.info().name + ") ($" + d.deliveryFee + ")");

        return buf.toString();
    }
}