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
using hkssprangers.info.DeliveryTools;
using DateTools;
using Lambda;
using StringTools;

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

    @:table("receipt")
    final receipt:Receipt;

    @:table("googleFormImport")
    final googleFormImport:GoogleFormImport;

    @:table("tgMessage")
    final tgMessage:TgMessage;

    @:table("twilioMessage")
    final twilioMessage:TwilioMessage;

    public function getPrefill(user:LoggedinUser):Promise<{
        ?pickupLocation:String,
        ?pickupMethod:PickupMethod,
        ?paymentMethods:Array<PaymentMethod>,
        ?backupContactMethod:ContactMethod,
        ?backupContactValue:String,
    }> {
        return (switch user.login {
            case Telegram:
                delivery.where(d -> !d.deleted && (d.customerPreferredContactMethod == Telegram) && ((user.tg.id == d.customerTgId) || (user.tg.username != null && d.customerTgUsername == user.tg.username)));
            case WhatsApp:
                delivery.where(d -> !d.deleted && (d.customerPreferredContactMethod == WhatsApp) && (d.customerWhatsApp == user.tel));
        })
            .orderBy(d -> [
                { field: d.pickupTimeSlotStart, order: Desc },
            ])
            .first()
            .flatMap(r -> switch r {
                case Success(d):
                    {
                        pickupLocation: d.pickupLocation,
                        pickupMethod: PickupMethod.fromId(d.pickupMethod),
                        paymentMethods: {
                            var m = [];
                            if (d.paymeAvailable)
                                m.push(PayMe);
                            if (d.fpsAvailable)
                                m.push(FPS);
                            m;
                        },
                        backupContactMethod: ContactMethod.fromId(d.customerBackupContactMethod),
                        backupContactValue: switch ContactMethod.fromId(d.customerBackupContactMethod) {
                            case null: null;
                            case Telegram: d.customerTgUsername;
                            case WhatsApp: d.customerWhatsApp;
                            case Signal: d.customerSignal;
                            case Telephone: d.customerTel;
                        }
                    };
                case Failure(failure):
                    {
                        pickupLocation: null,
                        pickupMethod: null,
                        paymentMethods: null,
                        backupContactMethod: null,
                        backupContactValue: null,
                    };
            });
    }

    public function getDeliveries(pickupTimeSlotStart:LocalDateString, ?pickupTimeSlotEnd:LocalDateString):Promise<Array<hkssprangers.info.Delivery>> {
        if (pickupTimeSlotEnd == null)
            pickupTimeSlotEnd = Date.fromTime(pickupTimeSlotStart.toDate().getTime() + DateTools.days(1));

        return delivery
            .where(d -> d.pickupTimeSlotStart >= pickupTimeSlotStart.toDate() && d.pickupTimeSlotEnd < pickupTimeSlotEnd.toDate() && !d.deleted)
            .all()
            .next(ds -> Promise.inSequence(ds.map(d -> DeliveryConverter.toDelivery(d, this))))
            .next(ds -> {
                ds.sort((a,b) ->
                    switch [TimeSlotType.classify(a.pickupTimeSlot.start), TimeSlotType.classify(b.pickupTimeSlot.start)] {
                        case [Lunch, Dinner]: -1;
                        case [Dinner, Lunch]: 1;
                        case [Lunch, Lunch], [Dinner, Dinner]:
                            Reflect.compare(a.deliveryCode, b.deliveryCode);
                    }
                );
                ds;
            });
    }

    public function getCouriersOfDelivery(deliveryId:Int) {
        return deliveryCourier
            .where(r -> r.deliveryId == deliveryId && !r.deleted).all()
            .next(dCouriers -> tink.core.Promise.inSequence(dCouriers.map(
                dCourier -> courier
                    .where(c -> c.courierId == dCourier.courierId).first()
                    .next(courier -> CourierConverter.toCourier(courier, this).merge({
                        deliveryFee: dCourier.deliveryFee,
                        deliverySubsidy: dCourier.deliverySubsidy,
                    }))
            )));
    }

    public function getOrdersOfDelivery(deliveryId:Int) {
        return deliveryOrder
            .where(r -> r.deliveryId == deliveryId && !r.deleted)
            .orderBy(r -> [{
                field: r.orderId, order: Asc,
            }])
            .all()
            .next(dOrders -> tink.core.Promise.inSequence(dOrders.map(
                dOrder -> order.where(o -> o.orderId == dOrder.orderId).first()
            )))
            .next(orders -> Promise.inSequence(orders.map(o -> OrderConverter.toOrder(o, this))));
    }

    public function saveOrder(o:hkssprangers.info.Order) {
        return order.update(f -> [
            f.orderCode.set(o.orderCode),
            f.shopId.set(o.shop),
            f.orderDetails.set(o.orderDetails),
            f.orderPrice.set(o.orderPrice),
            f.platformServiceCharge.set(o.platformServiceCharge),
            f.wantTableware.set(o.wantTableware),
            f.customerNote.set(o.customerNote),
        ], {
            where: f -> f.orderId == o.orderId,
            max: 1,
        }).noise();
    }

    public function deleteOrder(o:hkssprangers.info.Order) {
        return order.update(f -> [
            f.deleted.set(true),
        ], {
            where: f -> f.orderId == o.orderId,
            max: 1
        }).noise();
    }

    public function saveDelivery(d:hkssprangers.info.Delivery) {
        var dUpdate = delivery.update(f -> [
            f.deliveryCode.set(d.deliveryCode),
            f.pickupLocation.set(d.pickupLocation),
            f.deliveryFee.set(d.deliveryFee),
            f.pickupTimeSlotStart.set(d.pickupTimeSlot.start.toDate()),
            f.pickupTimeSlotEnd.set(d.pickupTimeSlot.end.toDate()),
            f.pickupMethod.set(d.pickupMethod),
            f.paymeAvailable.set(d.paymentMethods.has(PayMe)),
            f.fpsAvailable.set(d.paymentMethods.has(FPS)),
            f.customerTgUsername.set(d.customer.tg != null ? d.customer.tg.username : null),
            f.customerTgId.set(d.customer.tg != null ? d.customer.tg.id : null),
            f.customerTel.set(d.customer.tel),
            f.customerWhatsApp.set(d.customer.whatsApp),
            f.customerSignal.set(d.customer.signal),
            f.customerPreferredContactMethod.set(d.customerPreferredContactMethod),
            f.customerBackupContactMethod.set(d.customerBackupContactMethod),
            f.customerNote.set(d.customerNote),
        ], {
            where: f -> f.deliveryId == d.deliveryId,
            max: 1,
        });

        var newCouriers = Promise.inSequence(
            d.couriers.map(c ->
                courier
                    .where(f -> f.courierTgUsername == c.tg.username)
                    .first()
                    .mapError(err -> {
                        if (err.code == NotFound)
                            new Error(ErrorCode.NotFound, 'Could not find courier with TG ${c.tg.username}');
                        else
                            err;
                    })
                    .next(courier -> CourierConverter.toCourier(courier, this).merge({
                        deliveryFee: c.deliveryFee,
                        deliverySubsidy: c.deliverySubsidy,
                    }))
            )
        );

        var cUpdate = Promises.multi({
            newCouriers: newCouriers,
            currentCouriers: getCouriersOfDelivery(d.deliveryId),
        })
            .next(r ->
                Promise.inSequence(r.currentCouriers.map(cur -> {
                    switch (r.newCouriers.find(c -> c.courierId == cur.courierId)) {
                        case null: // removed
                            deliveryCourier.delete({
                                where: f -> f.deliveryId == d.deliveryId && f.courierId == cur.courierId,
                                max: 1,
                            }).noise();
                        case newCourier: // maybe updated
                            deliveryCourier.update(f -> [
                                f.deliveryFee.set(newCourier.deliveryFee),
                                f.deliverySubsidy.set(newCourier.deliverySubsidy),
                            ], {
                                where: f -> f.deliveryId == d.deliveryId && f.courierId == cur.courierId,
                                max: 1,
                            }).noise();
                    }
                })).next(_ -> {
                    var added = r.newCouriers
                        .filter(c -> !r.currentCouriers.exists(cur -> cur.courierId == c.courierId));
                    deliveryCourier.insertMany([
                        for (c in added)
                        {
                            deliveryId: d.deliveryId,
                            courierId: c.courierId,
                            deliveryFee: c.deliveryFee,
                            deliverySubsidy: c.deliverySubsidy,
                            deleted: false,
                        }
                    ]).noise();
                })
            );

        var oUpdate = getOrdersOfDelivery(d.deliveryId)
            .next(currentOrders -> {
                var updateExisting = Promise.inSequence(
                    d.orders
                        .filter(o -> currentOrders.exists(cur -> cur.orderId == o.orderId))
                        .map(saveOrder)
                );
                var addNew = insertOrders(d.orders.filter(o -> o.orderId == null))
                    .next(oids -> {
                        deliveryOrder.insertMany([
                            for (oid in oids)
                            {
                                deliveryId: d.deliveryId,
                                orderId: oid,
                                deleted: false,
                            }
                        ]);
                    })
                    .mapError(err -> {
                        trace('Failed to insert deliveryOrder\n' + err);
                        err;
                    });
                var remove = Promise.inSequence(
                    currentOrders
                        .filter(cur -> !d.orders.exists(o -> o.orderId == cur.orderId))
                        .map(o ->
                            deliveryOrder.delete({
                                where: f -> f.deliveryId == d.deliveryId && f.orderId == o.orderId,
                                max: 1,
                            }).next(_ -> deleteOrder(o))
                        )
                );
                Promises.multi({
                    updateExisting: updateExisting,
                    addNew: addNew,
                    remove: remove,
                });
            });

        return Promises.multi({
            oUpdate: oUpdate,
            dUpdate: dUpdate,
            cUpdate: cUpdate,
        }).noise();
    }

    public function deleteDelivery(d:hkssprangers.info.Delivery) {
        var dcDelete = getCouriersOfDelivery(d.deliveryId)
            .next(couriers ->
                Promise.inSequence(couriers.map(c ->
                    deliveryCourier.update(f -> [
                        f.deleted.set(true),
                    ], {
                        where: f -> f.deliveryId == d.deliveryId && f.courierId == c.courierId,
                        max: 1,
                    })
                ))
            );
        return Promises.multi({
            oDelete: Promise.inSequence(d.orders.map(deleteOrder)),
            doDelete: Promise.inSequence(d.orders.map(o -> deliveryOrder.update(f -> [
                f.deleted.set(true),
            ], {
                where: f -> f.deliveryId == d.deliveryId && f.orderId == o.orderId,
                max: 1,
            }))),
            dcDelete: dcDelete,
        }).next(_ -> delivery.update(f -> [
            f.deleted.set(true),
        ], {
            where: f -> f.deliveryId == d.deliveryId,
            max: 1,
        })).noise();
    }

    public function insertOrders(orders:Array<hkssprangers.info.Order>):Promise<Array<Id<Order>>> {
        return order.insertMany([
            for (o in orders)
            {
                orderId: null,
                creationTime: Date.fromString(o.creationTime),
                orderCode: o.orderCode,
                shopId: (o.shop:String),
                orderDetails: o.orderDetails,
                orderPrice: o.orderPrice,
                platformServiceCharge: o.platformServiceCharge,
                wantTableware: o.wantTableware,
                customerNote: o.customerNote,
                deleted: false,
            }
        ]).next(id0 -> {
            var ids = [for (id in id0...(id0 + orders.length)) (id:Id<Order>)];
            ids;
        });
    }

    public function insertDeliveries(deliveries:Array<hkssprangers.info.Delivery>):Promise<Array<Id<Delivery>>> {
        return Promise.inSequence(deliveries.map(d -> {
            var orderIds = insertOrders(d.orders).mapError(err -> {
                trace("Failed to write orders:\n" + err);
                err;
            });
            Promise.lazy(() -> {
                switch (d.deliveryCode) {
                    case null:
                        var t = TimeSlotType.classify(d.pickupTimeSlot.start);
                        var date = (d.pickupTimeSlot.start:LocalDateString).getDatePart();
                        var start = (date + " " + t.info().pickupStart:LocalDateString).toDate();
                        var end = (date + " " + t.info().pickupEnd:LocalDateString).toDate();
                        var codePrefix = switch t {
                            case Lunch: "L";
                            case Dinner: "D";
                        }
                        delivery.where(d -> d.pickupTimeSlotStart >= start && d.pickupTimeSlotStart < end && d.deliveryCode.like(codePrefix + "%") && !d.deleted)
                            .count()
                            .next(count -> {
                                codePrefix + Std.string(count + 1).lpad("0", 2);
                            });
                    case deliveryCode:
                        Promise.resolve(deliveryCode);
                }
            }).next(deliveryCode -> {
                    var deliveryId = delivery.insertOne({
                        deliveryId: null,
                        deliveryCode: deliveryCode,
                        creationTime: Date.fromString(d.creationTime),
                        pickupLocation: d.pickupLocation,
                        deliveryFee: Math.isNaN(d.deliveryFee) ? null : d.deliveryFee,
                        pickupTimeSlotStart: d.pickupTimeSlot.start.toDate(),
                        pickupTimeSlotEnd: d.pickupTimeSlot.end.toDate(),
                        pickupMethod: d.pickupMethod,
                        paymeAvailable: d.paymentMethods.has(PayMe),
                        fpsAvailable: d.paymentMethods.has(FPS),
                        customerPreferredContactMethod: d.customerPreferredContactMethod,
                        customerBackupContactMethod: d.customerBackupContactMethod,
                        customerTgUsername: d.customer.tg != null ? d.customer.tg.username : null,
                        customerTgId: d.customer.tg != null ? d.customer.tg.id : null,
                        customerTel: d.customer.tel,
                        customerWhatsApp: d.customer.whatsApp,
                        customerSignal: d.customer.signal,
                        customerNote: d.customerNote,
                        deleted: false,
                    }).mapError(err -> {
                        trace("Failed to write delivery\n" + err);
                        err;
                    });
                    var couriers = Promise.inSequence(d.couriers == null ? [] : d.couriers.map(c -> {
                        var tgUserName = c.tg.username;
                        courier
                            .select({
                                courierId: courier.courierId,
                            })
                            .where(courier.courierTgUsername == tgUserName)
                            .first()
                            .mapError(err -> {
                                trace("Couldn't find courier with tg " + tgUserName + "\n" + err);
                                err;
                            })
                            .next(r -> c.merge({
                                courierId: r.courierId,
                            }));
                    })).mapError(err -> {
                        trace("Failed to find couriers in db\n" + err);
                        err;
                    });

                    Promises.multi({
                        couriers: couriers,
                        deliveryId: deliveryId,
                        orderIds: orderIds,
                    })
                        .next(r -> {
                            var insertDeliveryOrder = deliveryOrder.insertMany([
                                for (orderId in r.orderIds)
                                {
                                    deliveryId: r.deliveryId,
                                    orderId: orderId,
                                    deleted: false,
                                }
                            ]).mapError(err -> {
                                trace("Failed to write deliveryOrder\n" + err);
                                err;
                            });
                            var insertDeliveryCouriers = deliveryCourier.insertMany([
                                for (c in r.couriers)
                                {
                                    deliveryId: r.deliveryId,
                                    courierId: c.courierId,
                                    deliveryFee: c.deliveryFee,
                                    deliverySubsidy: c.deliverySubsidy,
                                    deleted: false,
                                }
                            ]).mapError(err -> {
                                trace("Failed to write deliveryCourier\n" + err);
                                err;
                            });
                            Promise.inSequence([
                                insertDeliveryOrder.noise(),
                                insertDeliveryCouriers.noise(),
                            ]).next(_ -> deliveryId);
                        })
                        .mapError(err -> {
                            trace("Failed to write\n" + err + "\n" + d.print());
                            err;
                        });
                });
        }));
    }
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
                    orderId: o.orderId,
                    creationTime: (o.creationTime:LocalDateString),
                    orderCode: o.orderCode,
                    shop: Shop.fromId(o.shopId),
                    wantTableware: o.wantTableware,
                    customerNote: o.customerNote,
                    orderDetails: o.orderDetails,
                    orderPrice: o.orderPrice,
                    platformServiceCharge: o.platformServiceCharge,
                    receipts: receipts.map(r -> {
                        receiptId: r.receiptId,
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