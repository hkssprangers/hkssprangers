package hkssprangers.info;

import thx.Decimal;
import hkssprangers.info.Delivery;
using hkssprangers.info.OrderTools;
using hkssprangers.info.TgTools;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.MathTools;
using hkssprangers.ObjectTools;
using Lambda;
using StringTools;

class DeliveryTools {
    static function printCustomerContact(customer:Customer, contactMethod:ContactMethod, noLink = false) {
        return switch (contactMethod) {
            case null:
                null;
            case Telegram:
                customer.tg.print(!noLink);
            case WhatsApp:
                switch (customer) {
                    case { whatsApp: tel} if (tel != null):
                        if (!noLink)
                            'https://wa.me/852${tel}';
                        else
                            'WhatsApp:${tel}';
                    case { tel: tel} if (tel != null):
                        if (!noLink)
                            'https://wa.me/852${tel}';
                        else
                            'WhatsApp:${tel}';
                    case _:
                        null;
                }
            case Signal:
                'Signal:${customer.signal}';
            case Telephone:
                'tel:${customer.tel}';
        }
    }
    static public function print(d:Delivery, ?opts:{
        ?noLink:Bool,
    }):String {
        var buf = new StringBuf();

        buf.add("📃 " + d.deliveryCode + "\n");

        if (d.couriers != null && d.couriers.length > 0)
            buf.add("外賣員: " + d.couriers.map(c -> c.tg.print(false)).join(" ") + "\n");

        buf.add("\n");

        buf.add(d.orders.map(o -> o.print()).join("\n\n"));

        buf.add("\n\n");
        var foodTotal = d.orders.fold((order:Order, result:Float) -> result + order.orderPrice.nanIfNull(), 0.0);
        if (d.deliveryFee != null && !Math.isNaN(d.deliveryFee)) {
            var allTotal = foodTotal + d.deliveryFee.nanIfNull();
            if (!Math.isNaN(allTotal)) {
                buf.add("總食物價錢+運費: $" + allTotal + "\n");
                buf.add("\n");
            }
        } else {
            buf.add("總食物價錢+運費: $" + foodTotal + " + 運費\n");
            buf.add("\n");
        }

        if (d.pickupTimeSlot != null && d.pickupTimeSlot.start != null && d.pickupTimeSlot.end != null)
            buf.add(d.pickupTimeSlot.print() + "\n");

        switch (d.customerPreferredContactMethod) {
            case null:
                //pass
            case m:
                buf.add(printCustomerContact(d.customer, m, opts == null ? false : opts.noLink) + " 👈\n");
        }
        switch (d.customerBackupContactMethod) {
            case null:
                //pass
            case m:
                buf.add(printCustomerContact(d.customer, m, opts == null ? false : opts.noLink) + "\n");
        }
        if (d.paymentMethods != null && d.paymentMethods.length > 0)
            buf.add(d.paymentMethods.map(p -> p.info().name).join(", ") + "\n");
        if (d.pickupLocation != null)
            buf.add(d.pickupLocation + " (" + (d.pickupMethod != null ? d.pickupMethod.info().name : "null") + ")" + (d.deliveryFee != null && !Math.isNaN(d.deliveryFee) ? " (運費 $" + d.deliveryFee + ")" : "") + "\n");

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
            paymentMethods: delivery.paymentMethods != null ? delivery.paymentMethods.copy() : null,
            pickupTimeSlot: delivery.pickupTimeSlot.copy(),
        });
    }

    static public function setCouriersIncome(d:Delivery):Void {
        if (d.couriers == null)
            return;
        var platformServiceChargeTotal:Decimal = d.orders.map(o -> o.platformServiceCharge).sum();
        for (c in d.couriers) {
            c.deliveryFee = ((d.deliveryFee:Decimal) / d.couriers.length).roundTo(4).toFloat();
            c.deliverySubsidy = ((platformServiceChargeTotal * 0.5 + (d.pickupTimeSlot.start.is2021GoldenWeek() ? 5 : 0)) / d.couriers.length).roundTo(4).toFloat();
        }
    }

    static public function getMinInfo(d:Delivery):Delivery {
        return {
            creationTime: d.creationTime,
            deliveryCode: d.deliveryCode,
            couriers: d.couriers,
            customer: {
                tg: {},
                tel: null,
                whatsApp: null,
                signal: null,
            },
            customerPreferredContactMethod: d.customerPreferredContactMethod,
            customerBackupContactMethod: d.customerBackupContactMethod,
            paymentMethods: null,
            pickupLocation: null,
            pickupTimeSlot: d.pickupTimeSlot,
            pickupMethod: d.pickupMethod,
            deliveryFee: Math.NaN,
            customerNote: null,
            deliveryId: d.deliveryId,
            orders: d.orders.map(o -> {
                var minInfo:Order = {
                    creationTime: o.creationTime,
                    orderCode: o.orderCode,
                    shop: o.shop,
                    wantTableware: null,
                    customerNote: null,
                    orderId: o.orderId,
                    orderDetails: null,
                    orderPrice: Math.NaN,
                    platformServiceCharge: Math.NaN,
                    receipts: null,
                }
                minInfo;
            }),
        }
    }
}