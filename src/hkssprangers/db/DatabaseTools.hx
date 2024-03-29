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
import hkssprangers.db.Database;
using hkssprangers.ObjectTools;
using hkssprangers.ValueTools;
using hkssprangers.info.DeliveryTools;
using DateTools;
using Lambda;
using StringTools;

class DatabaseTools {
    static public function getPrefill(db:Database, user:LoggedinUser):Promise<{
        ?pickupLocation:String,
        ?pickupMethod:PickupMethod,
        ?paymentMethods:Array<PaymentMethod>,
        ?backupContactMethod:ContactMethod,
        ?backupContactValue:String,
    }> {
        return (switch user.login {
            case Telegram:
                db.delivery.where(d -> !d.deleted && (d.customerPreferredContactMethod == Telegram) && ((user.tg.id == d.customerTgId) || (user.tg.username != null && d.customerTgUsername == user.tg.username)));
            case WhatsApp:
                db.delivery.where(d -> !d.deleted && (d.customerPreferredContactMethod == WhatsApp) && (d.customerWhatsApp == user.tel));
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

    static public function getDeliveries(db:Database, pickupTimeSlotStart:LocalDateString, ?pickupTimeSlotEnd:LocalDateString):Promise<Array<hkssprangers.info.Delivery>> {
        if (pickupTimeSlotEnd == null)
            pickupTimeSlotEnd = Date.fromTime(pickupTimeSlotStart.toDate().getTime() + DateTools.days(1));

        return db.delivery
            .where(d -> d.pickupTimeSlotStart >= pickupTimeSlotStart.toDate() && d.pickupTimeSlotEnd < pickupTimeSlotEnd.toDate() && !d.deleted)
            .all()
            .next(ds -> Promise.inSequence(ds.map(d -> DeliveryConverter.toDelivery(d, db))))
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

    static public function getCouriersOfDelivery(db:Database, deliveryId:Int64String) {
        return db.deliveryCourier
            .where(r -> r.deliveryId == deliveryId.parse() && !r.deleted).all()
            .next(dCouriers -> tink.core.Promise.inSequence(dCouriers.map(
                dCourier -> db.courier
                    .where(c -> c.courierId == dCourier.courierId).first()
                    .next(courier -> CourierConverter.toCourier(courier, db).merge({
                        deliveryFee: dCourier.deliveryFee,
                        deliverySubsidy: dCourier.deliverySubsidy,
                    }))
            )));
    }

    static public function getOrdersOfDelivery(db:Database, deliveryId:Int64String) {
        return db.deliveryOrder
            .where(r -> r.deliveryId == deliveryId.parse() && !r.deleted)
            .orderBy(r -> [{
                field: r.orderId, order: Asc,
            }])
            .all()
            .next(dOrders -> tink.core.Promise.inSequence(dOrders.map(
                dOrder -> db.order.where(o -> o.orderId == dOrder.orderId).first()
            )))
            .next(orders -> Promise.inSequence(orders.map(o -> OrderConverter.toOrder(o, db))));
    }

    static public function saveOrder(db:Database, o:hkssprangers.info.Order) {
        return db.order.update(f -> [
            f.orderCode.set(o.orderCode),
            f.shopId.set(o.shop),
            f.orderDetails.set(o.orderDetails),
            f.orderPrice.set(o.orderPrice),
            f.platformServiceCharge.set(o.platformServiceCharge),
            f.wantTableware.set(o.wantTableware),
            f.customerNote.set(o.customerNote),
        ], {
            where: f -> f.orderId == o.orderId.parse(),
            max: 1,
        }).noise();
    }

    static public function deleteOrder(db:Database, o:hkssprangers.info.Order) {
        return db.order.update(f -> [
            f.deleted.set(true),
        ], {
            where: f -> f.orderId == o.orderId.parse(),
            max: 1
        }).noise();
    }

    static public function saveDelivery(db:Database, d:hkssprangers.info.Delivery) {
        var dUpdate = db.delivery.update(f -> [
            f.deliveryCode.set(d.deliveryCode),
            f.pickupLocation.set(d.pickupLocation),
            f.deliveryFee.set(d.deliveryFee),
            f.pickupTimeSlotStart.set(d.pickupTimeSlot.start.toDate()),
            f.pickupTimeSlotEnd.set(d.pickupTimeSlot.end.toDate()),
            f.pickupMethod.set(d.pickupMethod),
            f.paymeAvailable.set(d.paymentMethods.has(PayMe)),
            f.fpsAvailable.set(d.paymentMethods.has(FPS)),
            f.customerTgUsername.set(d.customer.tg != null ? d.customer.tg.username : null),
            f.customerTgId.set(null), // do not save tg id for now, because it can overflow int, should use int64
            f.customerTel.set(d.customer.tel),
            f.customerWhatsApp.set(d.customer.whatsApp),
            f.customerSignal.set(d.customer.signal),
            f.customerPreferredContactMethod.set(d.customerPreferredContactMethod),
            f.customerBackupContactMethod.set(d.customerBackupContactMethod),
            f.customerNote.set(d.customerNote),
        ], {
            where: f -> f.deliveryId == d.deliveryId.parse(),
            max: 1,
        });

        var newCouriers = Promise.inSequence(
            d.couriers.map(c ->
                db.courier
                    .where(f -> f.courierTgUsername == c.tg.username)
                    .first()
                    .mapError(err -> {
                        if (err.code == NotFound)
                            new Error(ErrorCode.NotFound, 'Could not find courier with TG ${c.tg.username}');
                        else
                            err;
                    })
                    .next(courier -> CourierConverter.toCourier(courier, db).merge({
                        deliveryFee: c.deliveryFee,
                        deliverySubsidy: c.deliverySubsidy,
                    }))
            )
        );

        var cUpdate = Promises.multi({
            newCouriers: newCouriers,
            currentCouriers: getCouriersOfDelivery(db, d.deliveryId),
        })
            .next(r ->
                Promise.inSequence(r.currentCouriers.map(cur -> {
                    switch (r.newCouriers.find(c -> c.courierId == cur.courierId)) {
                        case null: // removed
                            db.deliveryCourier.delete({
                                where: f -> f.deliveryId == d.deliveryId.parse() && f.courierId == cur.courierId.parse(),
                                max: 1,
                            }).noise();
                        case newCourier: // maybe updated
                            db.deliveryCourier.update(f -> [
                                f.deliveryFee.set(newCourier.deliveryFee),
                                f.deliverySubsidy.set(newCourier.deliverySubsidy),
                            ], {
                                where: f -> f.deliveryId == d.deliveryId.parse() && f.courierId == cur.courierId.parse(),
                                max: 1,
                            }).noise();
                    }
                })).next(_ -> {
                    var added = r.newCouriers
                        .filter(c -> !r.currentCouriers.exists(cur -> cur.courierId == c.courierId));
                    db.deliveryCourier.insertMany([
                        for (c in added)
                        {
                            deliveryId: d.deliveryId.parse(),
                            courierId: c.courierId.parse(),
                            deliveryFee: c.deliveryFee,
                            deliverySubsidy: c.deliverySubsidy,
                            deleted: false,
                        }
                    ]).noise();
                })
            );

        var oUpdate = getOrdersOfDelivery(db, d.deliveryId)
            .next(currentOrders -> {
                var updateExisting = Promise.inSequence(
                    d.orders
                        .filter(o -> currentOrders.exists(cur -> cur.orderId == o.orderId))
                        .map(o -> saveOrder(db, o))
                );
                var addNew = insertOrders(db, d.orders.filter(o -> o.orderId == null))
                    .next(oids -> {
                        db.deliveryOrder.insertMany([
                            for (oid in oids)
                            {
                                deliveryId: d.deliveryId.parse(),
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
                            db.deliveryOrder.delete({
                                where: f -> f.deliveryId == d.deliveryId.parse() && f.orderId == o.orderId.parse(),
                                max: 1,
                            }).next(_ -> deleteOrder(db, o))
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

    static public function deleteDelivery(db:Database, d:hkssprangers.info.Delivery) {
        var dcDelete = getCouriersOfDelivery(db, d.deliveryId)
            .next(couriers ->
                Promise.inSequence(couriers.map(c ->
                    db.deliveryCourier.update(f -> [
                        f.deleted.set(true),
                    ], {
                        where: f -> f.deliveryId == d.deliveryId.parse() && f.courierId == c.courierId.parse(),
                        max: 1,
                    })
                ))
            );
        return Promises.multi({
            oDelete: Promise.inSequence(d.orders.map(o -> deleteOrder(db, o))),
            doDelete: Promise.inSequence(d.orders.map(o -> db.deliveryOrder.update(f -> [
                f.deleted.set(true),
            ], {
                where: f -> f.deliveryId == d.deliveryId.parse() && f.orderId == o.orderId.parse(),
                max: 1,
            }))),
            dcDelete: dcDelete,
        }).next(_ -> db.delivery.update(f -> [
            f.deleted.set(true),
        ], {
            where: f -> f.deliveryId == d.deliveryId.parse(),
            max: 1,
        })).noise();
    }

    static public function insertOrders(db:Database, orders:Array<hkssprangers.info.Order>):Promise<Array<Int64>> {
        return Promise.inSequence([
            for (o in orders)
            db.order.insertOne({
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
            })
        ]);
    }

    static public function insertDeliveries(db:Database, deliveries:Array<hkssprangers.info.Delivery>):Promise<Array<Int64>> {
        return Promise.inSequence(deliveries.map(d -> {
            final orderIds = insertOrders(db, d.orders).mapError(err -> {
                trace("Failed to write orders:\n" + err);
                err;
            });
            Promise.lazy(() -> {
                switch (d.deliveryCode) {
                    case null:
                        final t = TimeSlotType.classify(d.pickupTimeSlot.start);
                        final date = (d.pickupTimeSlot.start:LocalDateString).getDatePart();
                        final start = (date + " " + t.info().pickupStart:LocalDateString).toDate();
                        final end = (date + " " + t.info().pickupEnd:LocalDateString).toDate();
                        final codePrefix = switch t {
                            case Lunch: "L";
                            case Dinner: "D";
                        }
                        db.delivery
                            .where(d -> d.pickupTimeSlotStart >= start && d.pickupTimeSlotStart < end && d.deliveryCode.like(codePrefix + "%"))
                            .all()
                            .next(deliveries -> {
                                final codeParse = ~/^[LD]([0-9]+)$/;
                                final codeNums = deliveries.map(d -> codeParse.match(d.deliveryCode) ? Std.parseInt(codeParse.matched(1)) : 0);
                                codeNums.fold((n, max) -> n > max ? n : max, 0);
                            })
                            .next(num -> codePrefix + Std.string(num + 1).lpad("0", 2));
                    case deliveryCode:
                        Promise.resolve(deliveryCode);
                }
            }).next(deliveryCode -> {
                final deliveryId = db.delivery.insertOne({
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
                    customerTgId: null, // do not save tg id for now, because it can overflow int, should use int64
                    customerTel: d.customer.tel,
                    customerWhatsApp: d.customer.whatsApp,
                    customerSignal: d.customer.signal,
                    customerNote: d.customerNote,
                    deleted: false,
                }).mapError(err -> {
                    trace("Failed to write delivery\n" + err);
                    err;
                });
                final couriers = Promise.inSequence(d.couriers == null ? [] : d.couriers.map(c -> {
                    final tgUserName = c.tg.username;
                    db.courier
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
                        final insertDeliveryOrder = db.deliveryOrder.insertMany([
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
                        final insertDeliveryCouriers = db.deliveryCourier.insertMany([
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