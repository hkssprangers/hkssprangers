package hkssprangers;

import tink.CoreApi;
import tink.core.ext.Promises;
import js.npm.xlsx.Xlsx;
import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;
import hkssprangers.info.*;
import hkssprangers.info.Shop;
import hkssprangers.info.PaymentMethod;
import hkssprangers.info.ContactMethod;
import hkssprangers.info.PickupMethod;
import hkssprangers.info.OrderTools.*;
import hkssprangers.server.CockroachDb;
import hkssprangers.db.Database.DeliveryConverter;
import thx.Decimal;
using StringTools;
using Lambda;
using hkssprangers.MathTools;
using hkssprangers.ObjectTools;
using hkssprangers.db.DatabaseTools;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.info.OrderTools;
using hkssprangers.info.DeliveryTools;

class Commands {
    static function validateDelivery(d:Delivery) {
        function printDelivery() return Json.stringify(d, null, "  ");

        if (d.creationTime > d.pickupTimeSlot.end)
            throw "creationTime > pickupTimeSlot.end: \n" + printDelivery();

        for (o in d.orders)
        if (o.orderPrice == null) {
            throw "orderPrice is null: \n" + printDelivery();
        }

        final icecreamOrder = d.orders.find(o -> o.shop == HanaSoftCream);
        if (icecreamOrder != null) {
            if (icecreamOrder.orderPrice <= 0) {
                throw "unusual iceCreamPrice";
            }
            // if ((icecreamOrder.orderPrice % 26) != 0) {
            //     throw "iceCreamPrice is not multiple of 26: \n" + printDelivery();
            // }
        }

        switch (d.deliveryFee % 5) {
            case 0:
                //pass
            case v:
                throw "unusual deliveryFee: \n" + printDelivery();
        }

        if (d.couriers == null || d.couriers.length == 0) {
            throw "no couriers: \n" + printDelivery();
        }

        for (c in d.couriers)
        if (!TelegramTools.isValidUserName(c.tg.username)) {
            throw "invalid courier Tg username: \n" + printDelivery();
        }

        if (d.customer.tg != null && d.customer.tg.username != null && !TelegramTools.isValidUserName(d.customer.tg.username)) {
            throw "invalid customer Tg username: \n" + printDelivery();
        }

        if (d.customer.tel != null && !~/^\d{8}$/.match(d.customer.tel)) {
            throw "invalid customer Tel: \n" + printDelivery();
        }

        for (o in d.orders)
        if (o.wantTableware == null) {
            throw "wantTableware is null: \n" + printDelivery();
        }

        if (d.pickupTimeSlot.start == null) {
            throw "pickupTimeSlot.start is null: \n" + printDelivery();
        }

        if (d.pickupTimeSlot.end == null) {
            throw "pickupTimeSlot.end is null: \n" + printDelivery();
        }

        if (d.pickupLocation == null || d.pickupLocation == "") {
            throw "pickupLocation is null: \n" + printDelivery();
        }

        if (d.pickupMethod == null) {
            throw "pickupMethod is null: \n" + printDelivery();
        }

        for (o in d.orders) {
            if (o.orderDetails == null || o.orderDetails == "") {
                throw "orderDetails is null: \n" + printDelivery();
            }
        }

        final platformServiceChargeTotal = d.orders.map(o -> (o.platformServiceCharge:Decimal)).sum();
        final deliverySubsidy = (platformServiceChargeTotal * 0.5) / d.couriers.length;
        for (c in d.couriers) {
            if (c.deliverySubsidy != deliverySubsidy.toFloat()) {
                trace("deliverySubsidy is not half of platformServiceChargeTotal: \n" + printDelivery());
            }
        }
    }

    static function shopSummary(shop:Shop, deliveries:Array<Delivery>):WorkSheet {
        deliveries.sort((a,b) -> switch (Reflect.compare(a.pickupTimeSlot.start, b.pickupTimeSlot.start)) {
            case 0: Reflect.compare(a.deliveryCode, b.deliveryCode);
            case v: v;
        });
        final orderRows = [
            for (d in deliveries)
            for (o in d.orders)
            if (o.shop == shop)
            {
                /* A */ "日期": (d.pickupTimeSlot.start:String).substr(0, 10),
                /* B */ "時段": switch (TimeSlotType.classify(Date.fromString(d.pickupTimeSlot.start))) {
                    case Lunch: "午市";
                    case Dinner: "晚市";
                },
                /* C */ "單號": o.orderCode != null ? o.orderCode : d.deliveryCode,
                /* D */ "訂單內容": o.orderDetails,
                /* E */ "食物價錢": o.orderPrice,
                /* F */ "埗兵收費": o.platformServiceCharge,
            }
        ];
        final ws = Xlsx.utils.json_to_sheet(orderRows);

        Xlsx.utils.sheet_add_aoa(ws, [
            for (_ in 0...3)
            [for (_ in "A".code..."F".code+1) ""]
        ], {
            origin: { r: orderRows.length+1, c: 0 }
        });

        Reflect.setField(ws, 'E${orderRows.length+3}', {
            t: "s",
            v: '總訂單價',
        });
        Reflect.setField(ws, 'E${orderRows.length+4}', {
            t: "n",
            f: 'ROUND(SUM(E2:E${orderRows.length+1}), 1)',
        });

        Reflect.setField(ws, 'F${orderRows.length+3}', {
            t: "s",
            v: '總埗兵收費',
        });
        Reflect.setField(ws, 'F${orderRows.length+4}', {
            t: "n",
            f: 'ROUND(SUM(F2:F${orderRows.length+1}), 1)',
        });

        return ws;
    }

    static function courierSummary(courierTg:String, deliveries:Array<Delivery>):WorkSheet {
        deliveries.sort((a,b) -> switch (Reflect.compare(a.pickupTimeSlot.start, b.pickupTimeSlot.start)) {
            case 0: Reflect.compare(a.deliveryCode, b.deliveryCode);
            case v: v;
        });
        final orderRows = [
            for (d in deliveries.filter(d -> d.couriers.exists(c -> c.tg.username == courierTg)))
            {
                final cd = d.couriers.find(c -> c.tg.username == courierTg);
                {
                    /* A */ "日期": (d.pickupTimeSlot.start:String).substr(0, 10),
                    /* B */ "時段": switch (TimeSlotType.classify(Date.fromString(d.pickupTimeSlot.start))) {
                        case Lunch: "午市";
                        case Dinner: "晚市";
                    },
                    /* C */ "單號": d.deliveryCode,
                    /* D */ "店舖": d.orders.map(o -> o.shop.info().name).join(", "),
                    /* E */ "訂單內容": d.orders.map(o -> o.print()).join("\n\n"),
                    /* F */ "總食物價錢": d.orders.map(o -> o.orderPrice).sum(),
                    /* G */ "運費": cd.deliveryFee,
                    /* H */ "運費補貼": cd.deliverySubsidy,
                }
            }
        ];
        final ws = Xlsx.utils.json_to_sheet(orderRows);

        Xlsx.utils.sheet_add_aoa(ws, [
            for (_ in 0...3)
            [for (_ in "A".code..."H".code+1) ""]
        ], {
            origin: { r: orderRows.length+1, c: 0 }
        });

        Reflect.setField(ws, 'F${orderRows.length+3}', {
            t: "s",
            v: 'Total',
        });
        Reflect.setField(ws, 'G${orderRows.length+3}', {
            t: "n",
            f: 'ROUND(SUM(G2:G${orderRows.length+1}), 1)',
        });
        Reflect.setField(ws, 'H${orderRows.length+3}', {
            t: "n",
            f: 'ROUND(SUM(H2:H${orderRows.length+1}), 1)',
        });

        return ws;
    }

    static function calculate(start:LocalDateString, end:LocalDateString) {
        return CockroachDb.db.getDeliveries(start, end)
            .next(deliveries -> {
                deliveries.iter(validateDelivery);

                final summaryDir = "summary";
                FileSystem.createDirectory(summaryDir);

                deliveries.sort((a,b) -> switch (Reflect.compare(a.pickupTimeSlot.start, b.pickupTimeSlot.start)) {
                    case 0: Reflect.compare(a.deliveryCode, b.deliveryCode);
                    case v: v;
                });

                FileSystem.createDirectory(Path.join([summaryDir, "shop"]));
                final shops = Shop.all;
                final charges = new Map<Shop, Decimal>();
                for (shop in shops) {
                    final deliveries = deliveries.filter(d -> d.orders.exists(o -> o.shop == shop));

                    if (deliveries.length == 0) {
                        continue;
                    }

                    final wb = Xlsx.utils.book_new();
                    final ws = shopSummary(shop, deliveries);
                    Xlsx.utils.book_append_sheet(wb, ws, "orders");
                    Xlsx.writeFile(wb, Path.join([summaryDir, "shop", start.getDatePart() + "_" + end.getDatePart() + "_" + shop.info().name + ".xlsx"]));

                    final totalCharge = [
                        for (d in deliveries)
                        for (o in d.orders)
                        if (o.shop == shop)
                        (o.platformServiceCharge:Decimal)
                    ]
                        .sum()
                        .roundTo(1);
                    charges[shop] = totalCharge;
                    final shopName = shop.info().name;
                    final chinese = ~/[\u4e00-\u9fff]/g;
                    final shopNameWidth = chinese.replace(shopName, "XX").length;
                    final shopNamePadding = [for (_ in 0...(20-shopNameWidth)) " "].join("");
                    Sys.println('${shopNamePadding}${shopName}: ${totalCharge.toString().lpad(" ", 6)} (共 ${Std.string(deliveries.length).lpad(" ", 3)} 單)');
                };

                Sys.println("-----------------------------");

                final allCharge:Decimal = [for (shop => c in charges) c].sum();
                Sys.println('All charges: ${allCharge.toString()} (共 ${deliveries.length} 單)');

                Sys.println("-----------------------------");

                FileSystem.createDirectory(Path.join([summaryDir, "courier"]));
                final couriers = [
                    for (d in deliveries)
                    for (c in d.couriers)
                    c.tg.username => c.tg.username
                ].array();
                couriers.sort((a,b) -> Reflect.compare(a.toLowerCase(), b.toLowerCase()));
                final courierPayout = new Map<String, Decimal>();
                final courierNameMax = Std.int(couriers.fold((item, r) -> Math.max(item.length, r), 0));
                for (courier in couriers) {
                    final deliveries = deliveries.filter(d -> d.couriers.exists(c -> c.tg.username == courier));
                    final wb = Xlsx.utils.book_new();
                    final ws = courierSummary(courier, deliveries);
                    Xlsx.utils.book_append_sheet(wb, ws, "orders");
                    Xlsx.writeFile(wb, Path.join([summaryDir, "courier", start.getDatePart() + "_" + end.getDatePart() + "_" + courier + ".xlsx"]));

                    final subsidyTotal:Decimal = [
                            for (d in deliveries)
                            for (c in d.couriers)
                            if (c.tg.username == courier)
                            (c.deliverySubsidy:Decimal)
                        ]
                        .sum()
                        .roundTo(1);
                    courierPayout[courier] = subsidyTotal;
                    final feeTotal:Decimal = [
                        for (d in deliveries)
                        for (c in d.couriers)
                        if (c.tg.username == courier)
                        (c.deliveryFee:Decimal)
                    ]
                        .sum()
                        .roundTo(1);
                    Sys.println('${courier.lpad(" ", courierNameMax)}: ${subsidyTotal.toString().lpad(" ", 6)} + ${feeTotal.toString().lpad(" ", 6)} = ${(subsidyTotal + feeTotal).toString().lpad(" ", 6)} (共 ${Std.string(deliveries.length).lpad(" ", 2)} 單)');
                }
                Sys.println("-----------------------------");
                final allPayout:Decimal = [for (courier => v in courierPayout) v].sum();
                Sys.println('All payouts: ${allPayout.toString()}');
                Sys.println("-----------------------------");
                Sys.println('Platform income: ${(allCharge - allPayout).toString()}');

                {
                    final wb = Xlsx.utils.book_new();
                    final ws = createReport(charges, courierPayout, start.getDatePart() + " - " + end.getDatePart());
                    Xlsx.utils.book_append_sheet(wb, ws, "report");
                    Xlsx.writeFile(wb, Path.join([summaryDir, start.getDatePart() + "_" + end.getDatePart() + ".xlsx"]));
                }
                {
                    final wb = Xlsx.utils.book_new();
                    final ws = createTracking(charges);
                    Xlsx.utils.book_append_sheet(wb, ws, "tracking");
                    Xlsx.writeFile(wb, Path.join([summaryDir, "tracking " + start.getDatePart().substr(0, 7) + ".xlsx"]));
                }

                Noise;
            });
    }

    static function createReport(charges:Map<Shop, Decimal>, courierPayout:Map<String, Decimal>, details:String):WorkSheet {
        final chargesRows:Array<Dynamic> = [
            for (shop => charge in charges)
            {
                /* A */ "date": null,
                /* B */ "type": "service charge",
                /* C */ "description": shop.info().name,
                /* D */ "details": details,
                /* E */ "expense (HKD)": null,
                /* F */ "expense (EUR)": null,
                /* G */ "expense (USD)": null,
                /* H */ "expense value in HKD": null,
                /* I */ "revenue (HKD)": charge.toFloat(),
            }
        ];
        final courierPayoutRows:Array<Dynamic> = [
            for (courier => payout in courierPayout)
            {
                /* A */ "date": null,
                /* B */ "type": "Salaries",
                /* C */ "description": 'delivery subsidy ${courier}',
                /* D */ "details": details,
                /* E */ "expense (HKD)": payout.toFloat(),
                /* F */ "expense (EUR)": null,
                /* G */ "expense (USD)": null,
                /* H */ "expense value in HKD": null,
                /* I */ "revenue (HKD)": null,
            }
        ];
        final ws = Xlsx.utils.json_to_sheet(chargesRows.concat(courierPayoutRows));
        ws.__cols = [
            /* A date */                 { wch: 10 },
            /* B type */                 { wch: 15 },
            /* C description */          { wch: 25 },
            /* D details */              { wch: 25 },
            /* E expense (HKD) */        { wch: 18 },
            /* F expense (EUR) */        { wch: 18 },
            /* G expense (USD) */        { wch: 18 },
            /* H expense value in HKD */ { wch: 18 },
            /* I revenue (HKD) */        { wch: 18 },
        ];
        ws.__rows = [
            for (_ in 0...chargesRows.length + courierPayoutRows.length + 1)
            {
                hpt: 18,
            }
        ];
        return ws;
    }

    static function createTracking(charges:Map<Shop, Decimal>):WorkSheet {
        final chargesRows:Array<Dynamic> = [
            for (shop => charge in charges)
            {
                /* A */ "shop": shop.info().name,
                /* B */ "amount": charge.toFloat(),
                /* C */ "invoiced": null,
                /* D */ "received": null,
            }
        ];
        final ws = Xlsx.utils.json_to_sheet(chargesRows);
        ws.__cols = [
            /* A shop */                 { wch: 25 },
            /* B amount */               { wch: 15 },
            /* C invoiced */             { wch: 25 },
            /* D received */             { wch: 25 },
        ];
        ws.__rows = [
            for (_ in 0...chargesRows.length + 1)
            {
                hpt: 18,
            }
        ];
        return ws;
    }

    static function zeroAuLawCharges():Promise<Noise> {
        return CockroachDb.db.delivery
            .where(delivery.deliveryId.inArray(
                CockroachDb.db.deliveryOrder
                    .rightJoin(CockroachDb.db.order.where(o -> o.shopId == AuLawFarm))
                    .on((dO, o) -> dO.orderId == o.orderId)
                    .select((dO, o) -> { deliveryId: dO.deliveryId })
            ))
            .all()
            .next(ds -> Promise.inSequence(ds.map(d -> DeliveryConverter.toDelivery(d, CockroachDb.db))))
            .next(ds -> {
                final dCodes = ds.map(d -> d.pickupTimeSlot.print() + " " + d.deliveryCode);
                dCodes.sort(Reflect.compare);
                Sys.println(dCodes.join("\n"));

                for (d in ds) {
                    for (o in d.orders)
                        if (o.shop == AuLawFarm)
                            o.setPlatformServiceCharge();
                    d.setCouriersIncome();
                }

                Promise.inSequence(ds.map(d -> CockroachDb.db.saveDelivery(d)));
            })
            .next(_ -> Noise);
    }

    static function copyRegular(start:LocalDateString, end:LocalDateString):Promise<Noise> {
        final now = Date.now();
        return CockroachDb.db.delivery.where(f -> f.deliveryId == 1161).first()
            .next(sample -> DeliveryConverter.toDelivery(sample, CockroachDb.db))
            .next(sample -> {
                var date = start;
                final deliveries:Array<Delivery> = [];
                while (date <= end) {
                    if (!HkHolidays.isRedDay(date.toDate()) && !(Weekday.fromDay(date.toDate().getDay()) == Monday)) {
                        deliveries.push({
                            creationTime: now,
                            deliveryCode: sample.deliveryCode,
                            couriers: [],
                            customer: sample.customer,
                            customerPreferredContactMethod: sample.customerPreferredContactMethod,
                            customerBackupContactMethod: sample.customerBackupContactMethod,
                            paymentMethods: sample.paymentMethods,
                            pickupLocation: sample.pickupLocation,
                            pickupTimeSlot: {
                                start: (date.getDatePart() + " " + sample.pickupTimeSlot.start.getTimePart():LocalDateString).toDate(),
                                end: (date.getDatePart() + " " + sample.pickupTimeSlot.end.getTimePart():LocalDateString).toDate(),
                            },
                            pickupMethod: sample.pickupMethod,
                            deliveryFee: sample.deliveryFee,
                            customerNote: sample.customerNote,
                            deliveryId: null,
                            orders: [],
                        });
                    }
                    date = Date.fromTime(date.toDate().getTime() + DateTools.days(1));
                }
                return deliveries;
            })
            .next(deliveries -> {
                CockroachDb.db.insertDeliveries(deliveries);
            })
            .next(inserted -> {
                Sys.println('Inserted ${inserted.length}');
                return Noise;
            });
    }

    static function main():Void {
        switch (Sys.args()) {
            case ["calculate", month]:
                if (!~/[0-9][0-9][0-9][0-9]-[0-9][0-9]/.match(month)) {
                    throw 'input should be YYYY-MM';
                }
                final startDate = Date.fromString(month + "-01");
                final endDate = DateTools.delta(new Date(startDate.getFullYear(), startDate.getMonth() + 1, 1, 0, 0, 0), DateTools.seconds(-1));
                Sys.println('${(startDate:LocalDateString)} - ${(endDate:LocalDateString)}');
                calculate(startDate, endDate).handle(o -> switch o {
                    case Success(data):
                        Sys.exit(0);
                    case Failure(failure):
                        Sys.println(failure.message + "\n\n" + failure.exceptionStack);
                        Sys.exit(1);
                });
            case ["calculate", start, end]:
                if (start.length != 10 || end.length != 10)
                    throw "invalid date format";

                calculate(start + " 00:00:00", end + " 23:59:59").handle(o -> switch o {
                    case Success(data):
                        Sys.exit(0);
                    case Failure(failure):
                        Sys.println(failure.message + "\n\n" + failure.exceptionStack);
                        Sys.exit(1);
                });
            case ["zeroAuLawCharges"]:
                zeroAuLawCharges().handle(o -> switch o {
                    case Success(data):
                        Sys.exit(0);
                    case Failure(failure):
                        Sys.println(failure.message + "\n\n" + failure.exceptionStack);
                        Sys.exit(1);
                });
            case ["regular", start, end]:
                copyRegular(start, end).handle(o -> switch o {
                    case Success(data):
                        Sys.exit(0);
                    case Failure(failure):
                        Sys.println(failure.message + "\n\n" + failure.exceptionStack);
                        Sys.exit(1);
                });
            case ["holidays"]:
                HkHolidays.main();
            case ["lunar"]:
                LunarCalendar.main();
            case args:
                throw "unknown args: " + args;
        }
    }
}