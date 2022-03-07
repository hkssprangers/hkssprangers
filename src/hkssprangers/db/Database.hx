package hkssprangers.db;

import hkssprangers.info.LoggedinUser;
import hkssprangers.info.Shop;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.Tg;
import hkssprangers.info.PaymentMethod;
import hkssprangers.info.PickupMethod;
import hkssprangers.info.ContactMethod;
import tink.core.*;
import tink.core.Error.ErrorCode;
import tink.core.ext.Promises;
import tink.sql.expr.Functions as F;
using hkssprangers.ObjectTools;
using hkssprangers.ValueTools;
using hkssprangers.db.DatabaseTools;
using hkssprangers.info.DeliveryTools;
using DateTools;
using Lambda;
using StringTools;

typedef Database = tink.sql.Database<Def>;
interface Def extends tink.sql.DatabaseDefinition {
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

    @:table("receipt")
    final receipt:Receipt;

    @:table("googleFormImport")
    final googleFormImport:GoogleFormImport;

    @:table("tgMessage")
    final tgMessage:TgMessage;

    @:table("twilioMessage")
    final twilioMessage:TwilioMessage;
}

class CourierConverter {
    static public function toCourier(c:Courier, db:Database):hkssprangers.info.Courier {
        return {
            courierId: c.courierId,
            tg: {
                id: c.courierTgId,
                username: c.courierTgUsername,
            },
            isAdmin: c.isAdmin,
        };
    }
}

class OrderConverter {
    static public function toOrder(o:Order, db:Database):Promise<hkssprangers.info.Order> {
        return db.receipt.where(r -> r.orderId == o.orderId).all()
            .next(receipts -> {
                {
                    orderId: (o.orderId:Int64String),
                    creationTime: (o.creationTime:LocalDateString),
                    orderCode: o.orderCode,
                    shop: Shop.fromId(o.shopId),
                    wantTableware: o.wantTableware,
                    customerNote: o.customerNote,
                    orderDetails: o.orderDetails,
                    orderPrice: o.orderPrice,
                    platformServiceCharge: o.platformServiceCharge,
                    receipts: receipts.map(r -> {
                        receiptId: (r.receiptId:Int64String),
                        receiptUrl: r.receiptUrl,
                    }),
                };
            });
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
                whatsApp: d.customerWhatsApp,
                signal: d.customerSignal,
            },
            customerPreferredContactMethod:
                if (d.customerPreferredContactMethod != null)
                    ContactMethod.fromName(d.customerPreferredContactMethod)
                else
                    null,
            customerBackupContactMethod:
                if (d.customerBackupContactMethod != null)
                    ContactMethod.fromName(d.customerBackupContactMethod)
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
            couriers: db.getCouriersOfDelivery(d.deliveryId),
            orders: db.getOrdersOfDelivery(d.deliveryId),
        }).next(p -> _d.with(p));
    }
}