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
import hkssprangers.server.MySql;
import hkssprangers.db.Database.DeliveryConverter;
import thx.Decimal;
using StringTools;
using Lambda;
using hkssprangers.MathTools;
using hkssprangers.ObjectTools;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.info.OrderTools;
using hkssprangers.info.DeliveryTools;

class ImportOrderDocs {
    static function validateDelivery(d:Delivery) {
        function printDelivery() return Json.stringify(d, null, "  ");

        if (d.creationTime > d.pickupTimeSlot.end)
            throw "creationTime > pickupTimeSlot.end: \n" + printDelivery();

        for (o in d.orders)
        if (o.orderPrice == null) {
            throw "orderPrice is null: \n" + printDelivery();
        }

        var icecreamOrder = d.orders.find(o -> o.shop == HanaSoftCream);
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

            if (o.platformServiceCharge != ((o.orderPrice:Decimal) * 0.15).roundTo(4)) {
                throw "platformServiceCharge is not 15% of orderPrice: \n" + printDelivery();
            }
        }

        var platformServiceChargeTotal = d.orders.map(o -> (o.platformServiceCharge:Decimal)).sum();
        var deliverySubsidy = (platformServiceChargeTotal * 0.5) / d.couriers.length;
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
        var orderRows = [
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
        var ws = Xlsx.utils.json_to_sheet(orderRows);

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
        var orderRows = [
            for (d in deliveries.filter(d -> d.couriers.exists(c -> c.tg.username == courierTg)))
            {
                var cd = d.couriers.find(c -> c.tg.username == courierTg);
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
        var ws = Xlsx.utils.json_to_sheet(orderRows);

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
        return MySql.db.getDeliveries(start, end)
            .next(deliveries -> {
                deliveries.iter(validateDelivery);

                var summaryDir = "summary";
                FileSystem.createDirectory(summaryDir);

                deliveries.sort((a,b) -> switch (Reflect.compare(a.pickupTimeSlot.start, b.pickupTimeSlot.start)) {
                    case 0: Reflect.compare(a.deliveryCode, b.deliveryCode);
                    case v: v;
                });

                FileSystem.createDirectory(Path.join([summaryDir, "shop"]));
                var shops = Shop.all;
                var charges = new Map<Shop, Decimal>();
                for (shop in shops) {
                    var deliveries = deliveries.filter(d -> d.orders.exists(o -> o.shop == shop));

                    if (deliveries.length == 0) {
                        continue;
                    }

                    var wb = Xlsx.utils.book_new();
                    var ws = shopSummary(shop, deliveries);

                    Xlsx.utils.book_append_sheet(wb, ws, "orders");
                    Xlsx.writeFile(wb, Path.join([summaryDir, "shop", start.getDatePart() + "_" + end.getDatePart() + "_" + shop.info().name + ".xlsx"]));

                    var totalCharge = [
                        for (d in deliveries)
                        for (o in d.orders)
                        if (o.shop == shop)
                        (o.platformServiceCharge:Decimal)
                    ]
                        .sum()
                        .roundTo(1);
                    charges[shop] = totalCharge;
                    var shopName = shop.info().name;
                    var chinese = ~/[\u4e00-\u9fff]/g;
                    var shopNameWidth = chinese.replace(shopName, "XX").length;
                    var shopNamePadding = [for (_ in 0...(20-shopNameWidth)) " "].join("");
                    Sys.println('${shopNamePadding}${shopName}: ${totalCharge.toString().lpad(" ", 6)} (共 ${Std.string(deliveries.length).lpad(" ", 3)} 單)');
                };

                Sys.println("-----------------------------");

                var allCharge:Decimal = [for (shop => c in charges) c].sum();
                Sys.println('All charges: ${allCharge.toString()} (共 ${deliveries.length} 單)');

                Sys.println("-----------------------------");

                FileSystem.createDirectory(Path.join([summaryDir, "courier"]));
                var couriers = [
                    for (d in deliveries)
                    for (c in d.couriers)
                    c.tg.username => c.tg.username
                ].array();
                couriers.sort((a,b) -> Reflect.compare(a.toLowerCase(), b.toLowerCase()));
                var courierPayout = new Map<String, Decimal>();
                var courierNameMax = Std.int(couriers.fold((item, r) -> Math.max(item.length, r), 0));
                for (courier in couriers) {
                    var deliveries = deliveries.filter(d -> d.couriers.exists(c -> c.tg.username == courier));
                    var wb = Xlsx.utils.book_new();
                    var ws = courierSummary(courier, deliveries);

                    Xlsx.utils.book_append_sheet(wb, ws, "orders");
                    Xlsx.writeFile(wb, Path.join([summaryDir, "courier", start.getDatePart() + "_" + end.getDatePart() + "_" + courier + ".xlsx"]));

                    var subsidyTotal:Decimal = [
                            for (d in deliveries)
                            for (c in d.couriers)
                            if (c.tg.username == courier)
                            (c.deliverySubsidy:Decimal)
                        ]
                        .sum()
                        .roundTo(1);
                    courierPayout[courier] = subsidyTotal;
                    var feeTotal:Decimal = [
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
                var allPayout:Decimal = [for (courier => v in courierPayout) v].sum();
                Sys.println('All payouts: ${allPayout.toString()}');
                Sys.println("-----------------------------");
                Sys.println('Platform income: ${(allCharge - allPayout).toString()}');

                Noise;
            });
    }

    static function copyRegular(start:LocalDateString, end:LocalDateString):Promise<Noise> {
        var now = Date.now();
        return MySql.db.delivery.where(f -> f.deliveryId == 1161).first()
            .next(sample -> DeliveryConverter.toDelivery(sample, MySql.db))
            .next(sample -> {
                var date = start;
                var deliveries:Array<Delivery> = [];
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
                MySql.db.insertDeliveries(deliveries);
            })
            .next(inserted -> {
                Sys.println('Inserted ${inserted.length}');
                return Noise;
            });
    }

    static function main():Void {
        switch (Sys.args()) {
            case ["calculate", start, end]:
                calculate(start, end).handle(o -> switch o {
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
            case args:
                throw "unknown args: " + args;
        }
    }
}