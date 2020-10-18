package hkssprangers.info;

using hkssprangers.info.OrderTools;
using hkssprangers.info.TgTools;
using hkssprangers.info.TimeSlotTools;
using Lambda;
using StringTools;

class DeliveryTools {
    static public function print(d:Delivery):String {
        var buf = new StringBuf();

        buf.add("📃 " + d.deliveryCode + "\n");

        if (d.couriers != null && d.couriers.length > 0)
            buf.add(d.couriers.map(c -> c.tg.print(false)).join(" ") + "\n");

        buf.add("\n");

        buf.add(d.orders.map(o -> o.print()).join("\n\n"));

        buf.add("\n\n");
        var foodTotal = d.orders.fold((order:Order, result:Float) -> result + order.orderPrice, 0.0);
        buf.add("總食物價錢+運費: $" + (foodTotal + d.deliveryFee) + "\n");

        buf.add("\n");
        buf.add(d.pickupTimeSlot.print() + "\n");
        if (d.customer.tg != null)
            buf.add(d.customer.tg.print() + (d.customerPreferredContactMethod == Telegram ? " 👈" : "") + "\n");
        if (d.customer.tel != null)
            buf.add(d.customer.tel + (d.customerPreferredContactMethod == WhatsApp ? " 👈" : "") + "\n");
        buf.add(d.paymentMethods.map(p -> p.info().name).join(", ") + "\n");
        buf.add(d.pickupLocation + " (" + d.pickupMethod.info().name + ") ($" + d.deliveryFee + ")\n");

        if (d.customerNote != null)
            buf.add("⚠️ " + d.customerNote + "\n");

        return buf.toString().trim();
    }
}