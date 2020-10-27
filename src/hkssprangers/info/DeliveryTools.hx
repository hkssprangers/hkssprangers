package hkssprangers.info;

using hkssprangers.info.OrderTools;
using hkssprangers.info.TgTools;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.MathTools;
using hkssprangers.ObjectTools;
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
        var foodTotal = d.orders.fold((order:Order, result:Float) -> result + order.orderPrice.nanIfNull(), 0.0);
        buf.add("總食物價錢+運費: $" + (foodTotal + d.deliveryFee.nanIfNull()) + "\n");

        buf.add("\n");
        if (d.pickupTimeSlot != null && d.pickupTimeSlot.start != null && d.pickupTimeSlot.end != null)
            buf.add(d.pickupTimeSlot.print() + "\n");
        if (d.customer.tg != null && d.customer.tg.username != null)
            buf.add(d.customer.tg.print() + (d.customerPreferredContactMethod == Telegram ? " 👈" : "") + "\n");
        if (d.customer.tel != null)
            buf.add('https://wa.me/852${d.customer.tel}' + (d.customerPreferredContactMethod == WhatsApp ? " 👈" : "") + "\n");
        buf.add(d.paymentMethods.map(p -> p.info().name).join(", ") + "\n");
        buf.add(d.pickupLocation + " (" + (d.pickupMethod != null ? d.pickupMethod.info().name : "null") + ") ($" + d.deliveryFee.nanIfNull() + ")\n");

        if (d.customerNote != null)
            buf.add("⚠️ " + d.customerNote + "\n");

        return buf.toString().trim();
    }

    static public function deepClone(delivery:Delivery):Delivery {
        return delivery.copy().with({
            couriers: delivery.couriers != null ? delivery.couriers.map(c -> c.copy().with({
                tg: c.tg.copy(),
            })) : null,
            customer: delivery.customer.copy().with({
                tg: delivery.customer.tg != null ? delivery.customer.tg.copy() : null,
            }),
            orders: delivery.orders.map(o -> o.copy()),
            paymentMethods: delivery.paymentMethods.copy(),
            pickupTimeSlot: delivery.pickupTimeSlot.copy(),
        });
    }
}