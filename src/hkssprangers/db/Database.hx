package hkssprangers.db;

import hkssprangers.info.Tg;
import hkssprangers.info.PaymentMethod;
import hkssprangers.info.PickupMethod;
import hkssprangers.info.ContactMethod;
import tink.core.*;
import tink.core.ext.Promises;
using hkssprangers.ObjectTools;
using DateTools;

class Database extends tink.sql.Database {
    @:table("courier")
    final courier:Courier;

    @:table("delivery")
    final delivery:Delivery;

    @:table("deliveryCourier")
    final deliveryCourier:DeliveryCourier;

    @:table("deliveryOrder")
    final deliveryOrder:DeliveryOrder;

    @:table("order")
    final order:Order;

    public function getDeliveries(pickupDate:Date):Promise<Array<hkssprangers.info.Delivery>> {
        var start = Date.fromString(pickupDate.format("%Y-%m-%d"));
        var end = Date.fromTime(start.getTime() + DateTools.days(1));

        return delivery
            .where(d -> d.pickupTimeSlotStart >= start && d.pickupTimeSlotEnd < end)
            .all()
            .next(ds -> Promise.inParallel(ds.map(d -> DeliveryConverter.toDelivery(d, this))));
    }
}

class CourierConverter {
    static public function toCourier(c:Courier, db:Database):hkssprangers.info.Courier {
        return {
            courierId: c.courierId,
            tg: {
                id: c.courierTgId,
                username: c.courierTgUsername,
            }
        };
    }
}

class OrderConverter {
    static public function toOrder(o:Order, db:Database):hkssprangers.info.Order {
        return {
            orderId: o.orderId,
            creationTime: o.creationTime,
            orderCode: o.orderCode,
            shop: Shop.fromId(o.shopId),
            wantTableware: o.wantTableware,
            customerNote: o.customerNote,
            orderDetails: o.orderDetails,
            orderPrice: o.orderPrice,
            platformServiceCharge: o.platformServiceCharge,
        };
    }
}

class DeliveryConverter {
    static public function toDelivery(d:Delivery, db:Database):Promise<hkssprangers.info.Delivery> {
        var _d:hkssprangers.info.Delivery = {
            deliveryId: d.deliveryId,
            creationTime: d.creationTime,
            deliveryCode: d.deliveryCode,
            couriers: null,
            customer: {
                tg: {
                    id: d.customerTgId,
                    username: d.customerTgUsername,
                },
                tel: d.customerTel,
            },
            customerPreferredContactMethod:
                if (d.customerPreferredContactMethod != null)
                    ContactMethod.fromName(d.customerPreferredContactMethod)
                else
                    null,
            paymentMethods: {
                var pm:Array<PaymentMethod> = [];
                if (d.fpsAvailable)
                    pm.push(FPS);
                if (d.paymeAvailable)
                    pm.push(PayMe);
                pm;
            },
            pickupLocation: d.pickupLocation,
            pickupTimeSlot: {
                start: d.pickupTimeSlotStart,
                end: d.pickupTimeSlotEnd,
            },
            pickupMethod: PickupMethod.fromId(d.pickupMethod),
            deliveryFee: d.deliveryFee,
            customerNote: d.customerNote,
            orders: null
        };

        return Promises.multi({
            couriers: db.deliveryCourier
                .where(r -> r.deliveryId == d.deliveryId).all()
                .next(dCouriers -> tink.core.Promise.inParallel(dCouriers.map(
                    dCourier -> db.courier
                        .where(c -> c.courierId == dCourier.courierId).first()
                        .next(courier -> CourierConverter.toCourier(courier, db).merge({
                            deliveryFee: dCourier.deliveryFee,
                            deliverySubsidy: dCourier.deliverySubsidy,
                        }))
                ))),
            orders: db.deliveryOrder
                .where(r -> r.deliveryId == d.deliveryId)
                .all()
                .next(dOrders -> tink.core.Promise.inParallel(dOrders.map(
                    dOrder -> db.order.where(o -> o.orderId == dOrder.orderId).first()
                )))
                .next(orders -> orders.map(o -> OrderConverter.toOrder(o, db)))
                .next(orders -> {
                    // put Hana's order at the end
                    orders.sort((a,b) -> switch [a.shop, b.shop] {
                        case [_, HanaSoftCream]: -1;
                        case [HanaSoftCream, _]: 1;
                        case [a, b]: Reflect.compare(a, b);
                    });
                    orders;
                }),
        }).next(p -> _d.with(p));
    }
}