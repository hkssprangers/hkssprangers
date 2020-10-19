package hkssprangers;

import tink.CoreApi;
import tink.core.ext.Promises;
import js.npm.xlsx.Xlsx;
import js.node.ChildProcess;
import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import hkssprangers.info.*;
import hkssprangers.info.Shop;
import hkssprangers.info.PaymentMethod;
import hkssprangers.info.ContactMethod;
import hkssprangers.info.PickupMethod;
import hkssprangers.info.OrderTools.*;
import hkssprangers.server.MySql;
import thx.Decimal;
using StringTools;
using Lambda;
using hkssprangers.MathTools;
using hkssprangers.ObjectTools;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.info.OrderTools;
using hkssprangers.info.DeliveryTools;

class ImportOrderDocs {
    static final deliveriesJsonFile = "deliveries.json";

    static final courierTgRename = [
        "amabap" => "mabpa"
    ];

    static function docx2txt(file:String) {
        var r = ChildProcess.spawnSync("docx2txt", [file], {
            encoding: "utf8",
        });

        if (r.status != 0)
            throw "docx2txt error processing " + file + "\n" + r.stderr;

        return (r.stdout:String);
    }
    
    static function menuResponses() {
        var responses = [];
        function processMenuResponses(path:String) {
            if (FileSystem.isDirectory(path)) {
                for (file in FileSystem.readDirectory(path)) {
                    processMenuResponses(Path.join([path, file]));
                }
            } else if (path.endsWith(".xlsx") && !path.contains("團購")) {
                var workbook = Xlsx.readFile(path, {
                    cellDates: true,
                });
                var sheet = workbook.Sheets[workbook.SheetNames[0]];
                var rows:Array<Array<String>> = Xlsx.utils.sheet_to_json(sheet, {
                    header: 1,
                    raw: false,
                });
                for (r in 1...rows.length) { // skip header row
                    var row = rows[r];
                    if (row.length == 0 || row[0] == null)
                        continue;

                    var timestampReg = ~/^([0-9]+)\/([0-9]+)\/([0-9]{4}) ([0-9]+):([0-9]+):([0-9]+)$/;
                    if (!timestampReg.match(row[0])) {
                        throw "no date in " + row;
                    }
                    var creationTime = timestampReg.matched(3) + "-" + timestampReg.matched(1).lpad("0", 2) + "-" + timestampReg.matched(2).lpad("0", 2) + " " + timestampReg.matched(4).lpad("0", 2) + ":" + timestampReg.matched(5).lpad("0", 2) + ":" + timestampReg.matched(6).lpad("0", 2);
                    var dateReg = ~/([0-9]+)月([0-9]+)日/;
                    var timeSlotReg = ~/([0-9]{2}:[0-9]{2})\s*\-\s*([0-9]{2}:[0-9]{2})/;
                    var timeSlotStr = row.find(v -> timeSlotReg.match(v));
                    if (timeSlotStr == null) {
                        trace("Cannot find timeslot field in " + path + " " + row);
                        continue;
                    }
                    var timeSlotStart = if (dateReg.match(timeSlotStr) || dateReg.match(path)) {
                        "2020-" + dateReg.matched(1).lpad("0", 2) + "-" + dateReg.matched(2).lpad("0", 2) + " " + timeSlotReg.matched(1) + ":00";
                    } else {
                        var dateReg = ~/^([0-9]+)\/([0-9]+)\/2020/;
                        if (!dateReg.match(row[0])) {
                            throw "no date in " + row;
                        }
                        "2020-" + dateReg.matched(1).lpad("0", 2) + "-" + (Std.parseInt(dateReg.matched(2)) + 1 + "").lpad("0", 2) + " " + timeSlotReg.matched(1) + ":00";
                    }
                    responses.push({
                        creationTime: creationTime,
                        timeSlotStart: timeSlotStart,
                        tel: row.find(v -> ~/^[0-9]{8}$/.match(v)),
                    });
                }
            }
        }
        processMenuResponses("menu");
        return responses;
    }

    static function setCreationTime(d:Delivery, responses:Array<{
        creationTime:String,
        timeSlotStart:String,
        tel:String,
    }>) {
        for (row in responses) {
            if (
                row.tel == d.customer.tel
                &&
                (
                    row.timeSlotStart.substr(0, 13) == (d.pickupTimeSlot.start:String).substr(0, 13)
                    ||
                    row.timeSlotStart.substr(0, 13) == (d.pickupTimeSlot.end:String).substr(0, 13)
                )
            ) {
                d.creationTime = row.creationTime;
                for (o in d.orders)
                    o.creationTime = row.creationTime;
                return;
            }
        }
        throw "cannot find creation time of " + d.deliveryCode + " " + d.pickupTimeSlot.print();
    }

    static function validateDelivery(d:Delivery) {
        function printDelivery() return Json.stringify(d, null, "  ");

        if (d.creationTime > d.pickupTimeSlot.start)
            throw "order.creationTime > order.pickupTimeSlotStart: \n" + printDelivery();

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

        switch (d.deliveryFee) {
            case null:
                throw "deliveryFee is null: \n" + printDelivery();
            case 15 | 20 | 25 | 35 | 40 | 50 | 100:
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

        for (o in d.orders)
        if (o.orderDetails == null || o.orderDetails == "") {
            throw "orderDetails is null: \n" + printDelivery();
        }
    }

    static function importGroupPurchasing(xlsxFile:String) {
        var deliveries:Array<Delivery> = [];
        var workbook = Xlsx.readFile(xlsxFile, {
            cellDates: true,
        });
        var sheet = workbook.Sheets[workbook.SheetNames[0]];
        var rows:Array<Array<String>> = Xlsx.utils.sheet_to_json(sheet, {
            header: 1,
            raw: false,
        });

        var dateReg = ~/([0-9]+)月([0-9]+)日/;
        var date = if (dateReg.match(rows[0][1]))
            "2020-" + dateReg.matched(1).lpad("0", 2) + "-" + dateReg.matched(2).lpad("0", 2);
        else
            throw "cannot parse date from " + rows[0][1];

        for (r in 1...rows.length) { // skip header row
            var row = rows[r];
            if (row.length == 0 || row[0] == null)
                continue;

            var timeSlotReg = ~/([0-9]{2}:[0-9]{2})\s*\-\s*([0-9]{2}:[0-9]{2})/;
            var timeSlotStr = row.find(v -> timeSlotReg.match(v));
            if (timeSlotStr == null) {
                trace("Cannot find timeslot field in " + xlsxFile + " " + row);
                continue;
            }

            var d:Delivery = {
                creationTime: row[0],
                deliveryCode: "團購",
                couriers: [
                    {
                        tg: {
                            username: "littlepine",
                        },
                        deliveryFee: null,
                        deliverySubsidy: null,
                    },
                    {
                        tg: {
                            username: "mabpa",
                        },
                        deliveryFee: null,
                        deliverySubsidy: null,
                    }
                ],
                customer: {
                    tg: null,
                    tel: null
                },
                customerPreferredContactMethod: null,
                paymentMethods: null,
                pickupLocation: null,
                pickupTimeSlot: {
                    start: date + " " + timeSlotReg.matched(1) + ":00",
                    end: date + " " + timeSlotReg.matched(2) + ":00"
                },
                pickupMethod: Street,
                deliveryFee: 15,
                customerNote: null,
                orders: [],
            };

            var orderDetails:Map<Shop, Array<String>> = [
                EightyNine => [],
                LaksaStore => [],
                HanaSoftCream => [],
            ];

            var wantTableware = null;

            for (i => h in rows[0]) {
                switch [h, row[i]] {
                    case ["Timestamp", _]:
                        // pass
                    case [h, v] if (h.startsWith("想幾時收到?")):
                        if (v.endsWith("美孚交收")) {
                            d.pickupLocation = "美孚";
                        } else if (v.endsWith("荔枝角交收")) {
                            d.pickupLocation = "荔枝角";
                        } else {
                            throw "unknown pickup location " + v;
                        }
                    case ["你的聯絡方式 (外賣員會和你聯絡同收款)", v]:
                        d.customerPreferredContactMethod = if (v.toLowerCase().contains("whatsapp"))
                            WhatsApp;
                        else if (v.toLowerCase().contains("telegram"))
                            Telegram;
                        else
                            throw "unknown contact method " + v;
                    case ["你的Telegram username, 非顯示名稱 e.g. @ssprangers", v]:
                        if (v != null)
                            d.customer.tg = {
                                username: v.charAt(0) == "@" ? v.substr(1) : v,
                            };
                    case ["你的電話號碼/Whatsapp", v]:
                        d.customer.tel = v;
                    case ["俾錢方法", v]:
                        d.paymentMethods = v.split(",").map(v -> PaymentMethod.fromName(v.trim()));
                    case ["需要餐具嗎?", "唔要"]:
                        wantTableware = false;
                    case ["需要餐具嗎?", "要"]:
                        wantTableware = true;
                    case ["其他備註", v]:
                        d.customerNote = v;
                    case [h, v] if (h.startsWith("喇沙專門店")):
                        if (v != null)
                            orderDetails[LaksaStore].push(h + ": " + v + "份");
                    case [h, v] if (h.startsWith("89美食")):
                        if (v != null)
                            orderDetails[EightyNine].push(h + ": " + v + "份");
                    case [h, v] if (h.startsWith("日本蕨餅")):
                        if (v != null)
                            orderDetails[HanaSoftCream].push(h + ": " + v + "份");
                    case [h, v]:
                        throw "unknown col " + h + " " + v;
                }
            }

            for (shop in [EightyNine, LaksaStore, HanaSoftCream]) {
                var orderDetails = orderDetails[shop].join("\n");
                var orderPrice = parseTotalPrice(orderDetails);
                if (orderDetails.length > 0) {
                    d.orders.push({
                        creationTime: d.creationTime,
                        orderCode: null,
                        shop: shop,
                        wantTableware: wantTableware,
                        customerNote: null,
                        orderDetails: orderDetails,
                        orderPrice: orderPrice,
                        platformServiceCharge: ((orderPrice:Decimal) * 0.15).roundTo(4).toFloat(),
                    });
                }
            }

            var foodPrice = d.orders.map(o -> (o.platformServiceCharge:Decimal)).sum();
            var deliveryFeePerCourier = ((d.deliveryFee:Decimal) / d.couriers.length).roundTo(4).toFloat();
            var deliverySubsidyPerCourier = ((foodPrice * 0.5) / d.couriers.length).roundTo(4).toFloat();
            for (c in d.couriers) {
                c.deliveryFee = deliveryFeePerCourier;
                c.deliverySubsidy = deliverySubsidyPerCourier;
            }

            deliveries.push(d);
        }

        return deliveries;
    }

    static function importDocs():Void {
        var files = FileSystem.readDirectory("orders");
        var deliveries:Array<Delivery> = [];

        for (file in files)
        // ignore copies for shops
        if (~/^\d{4}-\d{2}-\d{2} 訂單\.docx$/.match(file) || ~/^\d{4}-\d{2}-\d{2} - .市訂單\.docx$/.match(file))
        {
            var dateStr = file.substr(0, 10);
            var file = Path.join(["orders", file]);
            var content = docx2txt(file);
            var lines = content.split("\n");
            var delivery:Delivery = null;
            var order:Order = null;
            var orderDetails:Map<Shop, Array<String>> = null;
            function addDelivery(d:Delivery) {
                for (o in d.orders) {
                    o.orderDetails = orderDetails[o.shop].join("\n").trim();
                    o.platformServiceCharge = switch [dateStr, d.deliveryCode] {
                        case ["2020-08-05", "Years 02"]: 0; // Years gave a 85% discount
                        case ["2020-08-05", "Years 03"]: 0; // Years gave a 85% discount
                        case _: ((o.orderPrice:Decimal) * 0.15).roundTo(4).toFloat();
                    };
                }
                if (d.deliveryFee == null)
                    d.deliveryFee = 25;
                var platformServiceChargeTotal:Decimal = d.orders.map(o -> o.platformServiceCharge).sum();
                for (c in d.couriers) {
                    c.deliveryFee = ((d.deliveryFee:Decimal) / d.couriers.length).roundTo(4).toFloat();
                    c.deliverySubsidy = ((platformServiceChargeTotal * 0.5) / d.couriers.length).roundTo(4).toFloat();
                }
                deliveries.push(d);
            }
            for (line in lines) {
                if (line == "")
                    continue;

                var codeReg = ~/^(?:單號: |📃 )(.+)$/;
                if (codeReg.match(line)) {
                    if (delivery != null) {
                        addDelivery(delivery);
                    }
                    order = {
                        creationTime: null,
                        orderCode: null,
                        shop: null,
                        wantTableware: null,
                        customerNote: null,
                        orderDetails: null,
                        orderPrice: null,
                        platformServiceCharge: null,
                    }
                    delivery = {
                        creationTime: null,
                        deliveryCode: null,
                        couriers: null,
                        customer: {
                            tg: null,
                            tel: null,
                        },
                        customerPreferredContactMethod: null,
                        paymentMethods: null,
                        pickupLocation: null,
                        pickupTimeSlot: null,
                        pickupMethod: null,
                        deliveryFee: null,
                        customerNote: null,
                        orders: [order],
                    }
                    orderDetails = new Map();

                    delivery.deliveryCode = codeReg.matched(1).trim();
                    order.shop = if (line.contains("89"))
                        EightyNine;
                    else if (line.contains("營業部"))
                        DragonJapaneseCuisine;
                    else if (line.toLowerCase().contains("years"))
                        YearsHK;
                    else if (line.contains("喇沙"))
                        LaksaStore;
                    else if (line.contains("噹噹"))
                        DongDong;
                    else if (line.contains("標記"))
                        BiuKeeLokYuen;
                    else if (line.contains("蕃廚"))
                        KCZenzero;
                    else if (line.toLowerCase().contains("neighbor"))
                        Neighbor;
                    else if (line.contains("梅貴緣"))
                        MGY;
                    else
                        throw "unknown shop: " + line;
                    orderDetails[order.shop] = [];
                    continue;
                }

                if (order != null) {
                    if (line.startsWith("@")) {
                        var courierTgs = line.trim().split(" ").map(s -> s.trim().substr(1));
                        delivery.couriers = [
                            for (c in courierTgs)
                            {
                                tg: {
                                    username: c
                                },
                                deliveryFee: null,
                                deliverySubsidy: null,
                            }
                        ];
                        continue;
                    }

                    if (line.startsWith("🔸 ")) {
                        var shopName = line.substr("🔸 ".length);
                        if (shopName == "HANA Soft Cream") {
                            order = order.with({
                                shop: HanaSoftCream,
                                orderDetails: null,
                                orderPrice: null,
                                wantTableware: null,
                                customerNote: null,
                            });
                            orderDetails[HanaSoftCream] = [];
                            delivery.orders.push(order);
                        }
                        continue;
                    }

                    var noteReg = ~/^(?:.*備註[:：]\s*|⚠️\s*)(.+)$/;
                    if (noteReg.match(line)) {
                        if (delivery.pickupLocation != null)
                            delivery.customerNote = noteReg.matched(1);
                        else
                            order.customerNote = noteReg.matched(1);
                        continue;
                    }

                    if (delivery.couriers != null && order.wantTableware == null) {
                        switch (line.trim()) {
                            case "要餐具":
                                order.wantTableware = true;
                                continue;
                            case "唔要餐具":
                                order.wantTableware = false;
                                continue;
                            case _:
                                // pass
                        }
                        if (line.contains("雪糕")) {
                            if (~/^加購HANA雪糕:?$/.match(line.trim()))
                                continue;
                            if (orderDetails[HanaSoftCream] == null)
                                orderDetails[HanaSoftCream] = [];
                            orderDetails[HanaSoftCream].push(line.trim());
                        } else {
                            orderDetails[order.shop].push(line.trim());
                        }
                        continue;
                    }

                    var priceReg = ~/^(?:食物價?錢|total):\s*\$?\s*([0-9]+)\s*$/i;
                    if (priceReg.match(line)) {
                        order.orderPrice = Std.parseInt(priceReg.matched(1));
                        continue;
                    }

                    var priceIceCreamReg = ~/^雪糕價錢:\s*\$?\s*([0-9]+)\s*$/;
                    if (priceIceCreamReg.match(line)) {
                        // handle at the end
                        // order.iceCreamPrice = Std.parseInt(priceIceCreamReg.matched(1));
                        continue;
                    }

                    var pricePlusReg = ~/^食物(?:\s*\+\s*雪糕)?\s*\+\s*運費:\s*\$?\s*([0-9]+)\s*$/;
                    if (pricePlusReg.match(line)) {
                        if (orderDetails[HanaSoftCream] == null) {
                            delivery.deliveryFee = Std.parseInt(pricePlusReg.matched(1)) - order.orderPrice;
                        } else {
                            var iceCreamPrice = orderDetails[HanaSoftCream].map(line -> line.parsePrice()).sum();
                            if (iceCreamPrice == 0)
                                iceCreamPrice = orderDetails[HanaSoftCream].length * 26;
                            delivery.orders.push(order.with({
                                shop: HanaSoftCream,
                                orderDetails: orderDetails[HanaSoftCream].join("\n"),
                                orderPrice: iceCreamPrice,
                                customerNote: null,
                            }));
                            delivery.deliveryFee = Std.parseInt(pricePlusReg.matched(1)) - order.orderPrice - iceCreamPrice;
                        }
                        continue;
                    }

                    var pricePlusReg = ~/^總食物價錢\+運費:\s*\$?\s*([0-9]+)\s*$/;
                    if (pricePlusReg.match(line)) {
                        delivery.deliveryFee = Std.parseInt(pricePlusReg.matched(1)) - delivery.orders.map(o -> o.orderPrice).sum();
                        continue;
                    }

                    var timeSlotReg = ~/([0-9]{2}:[0-9]{2})\s*\-\s*([0-9]{2}:[0-9]{2})/;
                    if (timeSlotReg.match(line)) {
                        delivery.pickupTimeSlot = {
                            start: dateStr + " " + timeSlotReg.matched(1) + ":00",
                            end: dateStr + " " + timeSlotReg.matched(2) + ":00",
                        }
                        continue;
                    }

                    var tgReg = ~/^tg:\s*@?\s*([A-Za-z0-9_]{5,})$/i;
                    if (tgReg.match(line)) {
                        delivery.customer.tg = {
                            username: tgReg.matched(1),
                        };
                        continue;
                    }
                    var tgUrlReg = ~/.*https:\/\/t\.me\/([A-Za-z0-9_]{5,})\s*(?:👈)?/;
                    if (tgUrlReg.match(line)) {
                        delivery.customer.tg = {
                            username: tgUrlReg.matched(1),
                        };
                        if (line.contains("👈") || line.contains("客人首選")) {
                            delivery.customerPreferredContactMethod = Telegram;
                        }
                        continue;
                    }
                    var tgInvalid = ~/^tg:/i;
                    if (tgInvalid.match(line)) {
                        // trace('invlid tg ' + line);
                        continue;
                    }

                    var wtsappReg = ~/^wtsapp(?:\s*\(客人首選\))?\s*:\s*(.+)$/;
                    if (wtsappReg.match(line)) {
                        if (line.contains("客人首選")) {
                            delivery.customerPreferredContactMethod = WhatsApp;
                        }
                        var waUrlReg = ~/^https:\/\/wa\.me\/852([0-9]{8})$/;
                        if (waUrlReg.match(wtsappReg.matched(1))) {
                            delivery.customer.tel = waUrlReg.matched(1);
                        }
                        continue;
                    }

                    var telReg = ~/([0-9]{8})\s*(?:👈)?$/;
                    if (telReg.match(line)) {
                        delivery.customer.tel = telReg.matched(1);
                        if (line.contains("👈")) {
                            delivery.customerPreferredContactMethod = WhatsApp;
                        }
                        continue;
                    }

                    if (!line.contains("備註") && (~/payme/i.match(line) || ~/fps/i.match(line))) {
                        delivery.paymentMethods = ~/[,\/]/g.split(line).map(v -> switch (v.trim().toLowerCase()) {
                            case "payme": PayMe;
                            case "fps": FPS;
                            case v: throw "unregconized payment method: " + v;
                        });
                        continue;
                    }

                    var addressReg = ~/^(.+?)\s*\((..交收|食物外掛)/;
                    if (addressReg.match(line)) {
                        delivery.pickupLocation = addressReg.matched(1);
                        delivery.pickupMethod = PickupMethod.fromName(addressReg.matched(2));
                        continue;
                    }

                    if (order.customerNote != null && order.orderPrice == null) {
                        order.customerNote += "\n" + line;
                        continue;
                    }

                    if (line.trim() != "")
                        trace('Not processed: $file $line');
                }
            }

            if (delivery != null) {
                addDelivery(delivery);
            }
        }

        File.saveContent(deliveriesJsonFile, Json.stringify(deliveries, null, "  "));

        var menuResponses = menuResponses();
        File.saveContent("menuResponses.json", Json.stringify(menuResponses, null, "  "));

        for (d in deliveries) {
            setCreationTime(d, menuResponses);
        }

        var gpDeliveries = importGroupPurchasing("menu/埗兵團購外賣預訂單 (Responses).xlsx");
        deliveries = deliveries.concat(gpDeliveries);

        for (d in deliveries) {
            try {
                validateDelivery(d);
            } catch(err) {
                trace(err);
            }
        }

        for (oldTg => newTg in courierTgRename) {
            for (d in deliveries)
            for (c in d.couriers)
            if (c.tg.username == oldTg)
                c.tg.username = newTg;
        }

        deliveries.sort((a,b) -> Reflect.compare(a.creationTime, b.creationTime));

        File.saveContent(deliveriesJsonFile, Json.stringify(deliveries, null, "  "));
    }

    static function insertIntoDb():Promise<Noise> {
        var deliveries:Array<Delivery> = Json.parse(File.getContent(deliveriesJsonFile));
        deliveries.sort((a,b) -> Reflect.compare(a.creationTime, b.creationTime));

        return Promise.inSequence([for (d in deliveries) {
            var insertOrders = [
                for (o in d.orders)
                MySql.db.order.insertOne({
                    orderId: null,
                    creationTime: Date.fromString(o.creationTime),
                    orderCode: o.orderCode,
                    shopId: o.shop,
                    orderDetails: o.orderDetails,
                    orderPrice: o.orderPrice,
                    platformServiceCharge: o.platformServiceCharge,
                    wantTableware: o.wantTableware,
                    customerNote: o.customerNote,
                }).mapError(err -> {
                    trace("Failed to write\n" + Json.stringify(o, null, "  ") + "\n" + err);
                    err;
                })
            ];
            var deliveryId = MySql.db.delivery.insertOne({
                deliveryId: null,
                deliveryCode: d.deliveryCode,
                creationTime: Date.fromString(d.creationTime),
                pickupLocation: d.pickupLocation,
                deliveryFee: d.deliveryFee,
                pickupTimeSlotStart: d.pickupTimeSlot.start.toDate(),
                pickupTimeSlotEnd: d.pickupTimeSlot.end.toDate(),
                pickupMethod: d.pickupMethod,
                paymeAvailable: d.paymentMethods.has(PayMe),
                fpsAvailable: d.paymentMethods.has(FPS),
                customerPreferredContactMethod: d.customerPreferredContactMethod,
                customerTgUsername: d.customer.tg != null ? d.customer.tg.username : null,
                customerTgId: d.customer.tg != null ? d.customer.tg.id : null,
                customerTel: d.customer.tel,
                customerNote: d.customerNote,
            });
            var couriers = Promise.inSequence(d.couriers.map(c -> {
                var tgUserName = c.tg.username;
                MySql.db.courier
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
                        id: r.courierId,
                    }));
            }));
            
            Promises.multi({
                couriers: couriers,
                deliveryId: deliveryId,
                orderIds: Promise.inSequence(insertOrders),
            }).next(r -> {
                var insertDeliveryOrder = MySql.db.deliveryOrder.insertMany([
                    for (orderId in r.orderIds)
                    {
                        deliveryId: r.deliveryId,
                        orderId: orderId,
                    }
                ]);
                var insertDeliveryCouriers = [
                    for (c in r.couriers)
                    MySql.db.deliveryCourier.insertOne({
                        deliveryId: r.deliveryId,
                        courierId: c.id,
                        deliveryFee: c.deliveryFee,
                        deliverySubsidy: c.deliverySubsidy,
                    })
                ];
                Promise.inSequence(
                    [insertDeliveryOrder.noise()].concat(
                        insertDeliveryCouriers.map(c -> c.noise())
                    )
                );
            }).mapError(err -> {
                trace("Failed to write\n" + d.print());
                err;
            });
        }]).noise();
    }

    static final dateStart = "2020-09-01 00:00:00";
    static final dateEnd = "2020-09-30 23:59:59";

    static function filterDelivery(d:Delivery):Bool {
        return
            d.pickupTimeSlot.start > dateStart
            &&
            d.pickupTimeSlot.start < dateEnd
            &&
            switch [(d.pickupTimeSlot.start:String).substr(0, 10), d.deliveryCode] {
                case ["2020-08-05", "Years 02"]: false; // Years gave a 85% discount
                case ["2020-08-05", "Years 03"]: false; // Years gave a 85% discount
                case _: true;
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

    static function calculate():Void {
        var summaryDir = "summary";
        FileSystem.createDirectory(summaryDir);

        var deliveries:Array<Delivery> = Json.parse(File.getContent(deliveriesJsonFile));
        deliveries = deliveries.filter(filterDelivery);
        deliveries.sort((a,b) -> switch (Reflect.compare(a.pickupTimeSlot.start, b.pickupTimeSlot.start)) {
            case 0: Reflect.compare(a.deliveryCode, b.deliveryCode);
            case v: v;
        });

        FileSystem.createDirectory(Path.join([summaryDir, "shop"]));
        var shops = [
            EightyNine,
            DragonJapaneseCuisine,
            YearsHK,
            LaksaStore,
            DongDong,
            BiuKeeLokYuen,
            KCZenzero,
            HanaSoftCream,
            Neighbor,
            MGY,
        ];
        var charges = new Map<Shop, Decimal>();
        for (shop in shops) {
            var deliveries = deliveries.filter(d -> d.orders.exists(o -> o.shop == shop));

            if (deliveries.length == 0) {
                continue;
            }

            var wb = Xlsx.utils.book_new();
            var ws = shopSummary(shop, deliveries);

            Xlsx.utils.book_append_sheet(wb, ws, "orders");
            Xlsx.writeFile(wb, Path.join([summaryDir, "shop", dateStart.substr(0, 10) + "_" + dateEnd.substr(0, 10) + "_" + shop.info().name + ".xlsx"]));

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
            Xlsx.writeFile(wb, Path.join([summaryDir, "courier", dateStart.substr(0, 10) + "_" + dateEnd.substr(0, 10) + "_" + courier + ".xlsx"]));

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
    }

    static function main():Void {
        switch (Sys.args()) {
            case ["importDocs"]:
                importDocs();
            case ["insertIntoDb"]:
                insertIntoDb().handle(o -> switch(o) {
                    case Success(_):
                        Sys.exit(0);
                    case Failure(e):
                        Sys.println(e);
                        Sys.exit(1);
                });
            case ["calculate"]:
                calculate();
            case args:
                throw "unknown args: " + args;
        }
    }
}