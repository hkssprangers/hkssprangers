package hkssprangers;

import js.lib.intl.DateTimeFormat;
import js.npm.xlsx.Xlsx;
import js.node.ChildProcess;
import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import hkssprangers.info.Info;
import thx.Decimal;
using StringTools;
using Lambda;

typedef Order = {
    creationTime:String,
    orderCode:String,
    shopId:Shop<Dynamic>,
    orderDetails:String,
    orderPrice:Int,
    iceCreamPrice:Int,
    deliveryFee:Int,
    wantTableware:Bool,
    orderNote:Null<String>,
    pickupLocation:String,
    pickupTimeSlotStart:String,
    pickupTimeSlotEnd:String,
    pickupMethod:PickupMethod,
    deliveryNote:Null<String>,
    paymentMethods:Array<PaymentMethod>,
    customerTgUsername:Null<String>,
    customerTel:String,
    courierTgUsername:String,
};

class ImportOrderDocs {
    static function textract(file:String):String {
        return ChildProcess.spawnSync("npx", ["textract", file], {
            encoding: "utf8",
        }).stdout;
    }

    static function menuResponses() {
        var responses = [];
        function processMenuResponses(path:String) {
            if (FileSystem.isDirectory(path)) {
                for (file in FileSystem.readDirectory(path)) {
                    processMenuResponses(Path.join([path, file]));
                }
            } else if (path.endsWith(".xlsx")) {
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

    static function setCreationTime(order:Order, responses:Array<{
        creationTime:String,
        timeSlotStart:String,
        tel:String,
    }>) {
        for (row in responses) {
            if (
                row.tel == order.customerTel
                &&
                (
                    row.timeSlotStart.substr(0, 13) == order.pickupTimeSlotStart.substr(0, 13)
                    ||
                    row.timeSlotStart.substr(0, 13) == order.pickupTimeSlotEnd.substr(0, 13)
                )
            ) {
                order.creationTime = row.creationTime;
                return;
            }
        }
        if (order.creationTime == null) {
            throw "cannot find creation time of " + order;
        }
    }

    static function validateOrder(order:Order) {
        function printOrder() return Json.stringify(order, null, "  ");

        if (order.creationTime > order.pickupTimeSlotStart)
            throw "order.creationTime > order.pickupTimeSlotStart: \n" + printOrder();

        if (order.orderPrice == null) {
            throw "orderPrice is null: \n" + printOrder();
        }

        switch (order.deliveryFee) {
            case null:
                throw "deliveryFee is null: \n" + printOrder();
            case 25 | 35 | 40 | 50:
                //pass
            case v:
                throw "unusual deliveryFee: \n" + printOrder();
        }

        if (!TelegramTools.isValidUserName(order.courierTgUsername)) {
            throw "invalid courierTgUsername: \n" + printOrder();
        }

        if (order.customerTgUsername != null && !TelegramTools.isValidUserName(order.customerTgUsername)) {
            throw "invalid customerTgUsername: \n" + printOrder();
        }

        if (!~/^\d{8}$/.match(order.customerTel)) {
            throw "invalid customerTel: \n" + printOrder();
        }

        if (order.wantTableware == null) {
            throw "wantTableware is null: \n" + printOrder();
        }

        if (order.pickupTimeSlotStart == null) {
            throw "pickupTimeSlotStart is null: \n" + printOrder();
        }

        if (order.pickupTimeSlotEnd == null) {
            throw "pickupTimeSlotEnd is null: \n" + printOrder();
        }

        if (order.pickupLocation == null || order.pickupLocation == "") {
            throw "pickupLocation is null: \n" + printOrder();
        }

        if (order.pickupMethod == null) {
            throw "pickupMethod is null: \n" + printOrder();
        }

        if (order.orderDetails == null || order.orderDetails == "") {
            throw "orderDetails is null: \n" + printOrder();
        }
    }

    static function importDocs():Void {
        var files = FileSystem.readDirectory("orders");
        var orders:Array<Order> = [];
        for (file in files) {
            // ignore copies for shops
            if (!~/^\d{4}-\d{2}-\d{2} 訂單\.docx$/.match(file) && !~/^\d{4}-\d{2}-\d{2} - .市訂單\.docx$/.match(file)) {
                // trace('skip $file');
                continue;
            }
            var dateStr = file.substr(0, 10);
            var file = Path.join(["orders", file]);
            var content = textract(file);
            var lines = content.split("\n");
            var order = null;
            var orderDetails:Array<String> = null;
            function addOrder(order) {
                order.orderDetails = orderDetails.join("\n").trim();
                if (order.deliveryFee == null)
                    order.deliveryFee = 25;
                orders.push(order);
            }
            for (line in lines) {
                if (line.startsWith("單號: ")) {
                    if (order != null) {
                        addOrder(order);
                    }
                    order = {
                        creationTime: null,
                        orderCode: null,
                        shopId: null,
                        orderDetails: null,
                        orderPrice: null,
                        iceCreamPrice: null,
                        deliveryFee: null,
                        wantTableware: null,
                        orderNote: null,
                        pickupLocation: null,
                        pickupTimeSlotStart: null,
                        pickupTimeSlotEnd: null,
                        pickupMethod: null,
                        deliveryNote: null,
                        paymentMethods: null,
                        customerTgUsername: null,
                        customerTel: null,
                        courierTgUsername: null,
                    };
                    orderDetails = [];

                    order.orderCode = line.substr("單號: ".length).trim();
                    order.shopId = if (line.contains("89"))
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
                    else
                        throw "unknown shop: " + line;
                    continue;
                }

                if (order != null) {
                    if (line.startsWith("@")) {
                        order.courierTgUsername = line.substr(1).trim();
                        continue;
                    }

                    if (order.courierTgUsername != null && order.wantTableware == null) {
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
                        if (orderDetails == null)
                            orderDetails = [];
                        orderDetails.push(line.trim());
                        continue;
                    }

                    var priceReg = ~/^(?:食物價錢|total):\s*\$?\s*([0-9]+)\s*$/i;
                    if (priceReg.match(line)) {
                        order.orderPrice = Std.parseInt(priceReg.matched(1));
                        continue;
                    }

                    var priceIceCreamReg = ~/^雪糕價錢:\s*\$?\s*([0-9]+)\s*$/;
                    if (priceIceCreamReg.match(line)) {
                        order.iceCreamPrice = Std.parseInt(priceIceCreamReg.matched(1));
                        continue;
                    }

                    var pricePlusReg = ~/^食物(?:\s*\+\s*雪糕)?\s*\+\s*運費:\s*\$?\s*([0-9]+)\s*$/;
                    if (pricePlusReg.match(line)) {
                        if (order.iceCreamPrice == null)
                            order.deliveryFee = Std.parseInt(pricePlusReg.matched(1)) - order.orderPrice;
                        else
                            order.deliveryFee = Std.parseInt(pricePlusReg.matched(1)) - order.orderPrice - order.iceCreamPrice;
                        continue;
                    }

                    var timeSlotReg = ~/^客人交收時段:\s*.*([0-9]{2}:[0-9]{2})\s*\-\s*([0-9]{2}:[0-9]{2})/;
                    if (timeSlotReg.match(line)) {
                        order.pickupTimeSlotStart = dateStr + " " + timeSlotReg.matched(1) + ":00";
                        order.pickupTimeSlotEnd = dateStr + " " + timeSlotReg.matched(2) + ":00";
                        continue;
                    }

                    var tgReg = ~/^tg:\s*@?\s*([A-Za-z0-9_]{5,})$/i;
                    if (tgReg.match(line)) {
                        order.customerTgUsername = tgReg.matched(1);
                        continue;
                    }
                    var tgUrlReg = ~/.*https:\/\/t\.me\/([A-Za-z0-9_]{5,})/;
                    if (tgUrlReg.match(line)) {
                        order.customerTgUsername = tgUrlReg.matched(1);
                        continue;
                    }
                    var tgInvalid = ~/^tg:/i;
                    if (tgInvalid.match(line)) {
                        // trace('invlid tg ' + line);
                        continue;
                    }

                    var telReg = ~/[0-9]{8}/;
                    if (telReg.match(line)) {
                        order.customerTel = telReg.matched(0);
                        continue;
                    }

                    if (~/payme/i.match(line) || ~/fps/i.match(line)) {
                        order.paymentMethods = ~/[,\/]/g.split(line).map(v -> switch (v.trim().toLowerCase()) {
                            case "payme": PayMe;
                            case "fps": FPS;
                            case v: throw "unregconized payment method: " + v;
                        });
                        continue;
                    }

                    var addressReg = ~/^(.+?)\s*\((..交收)/;
                    if (addressReg.match(line)) {
                        order.pickupLocation = addressReg.matched(1);
                        order.pickupMethod = switch (addressReg.matched(2)) {
                            case "上門交收": Door;
                            case "樓下交收": Street;
                            case v: throw "unknown pickup method: " + v;
                        };
                        continue;
                    }

                    var noteReg = ~/^\*?其他備註:\s*(.+)$/;
                    if (noteReg.match(line)) {
                        if (order.pickupLocation != null)
                            order.deliveryNote = noteReg.matched(1);
                        else
                            order.orderNote = noteReg.matched(1);
                        continue;
                    }

                    if (line.trim() != "")
                        trace('Not processed: $file $line');
                }
            }

            if (order != null) {
                addOrder(order);
            }
        }

        File.saveContent("orders.json", Json.stringify(orders, null, "  "));

        var menuResponses = menuResponses();
        File.saveContent("menuResponses.json", Json.stringify(menuResponses, null, "  "));

        for (order in orders) {
            setCreationTime(order, menuResponses);
            validateOrder(order);
        }

        File.saveContent("orders.json", Json.stringify(orders, null, "  "));
    }

    static final dateStart = "2020-08-05 00:00:00";
    static final dateEnd = "2020-08-31 23:59:59";

    static function filterOrder(o:Order):Bool {
        return
            o.pickupTimeSlotStart > dateStart
            &&
            o.pickupTimeSlotStart < dateEnd
            &&
            switch [o.pickupTimeSlotStart.substr(0, 10), o.orderCode] {
                case ["2020-08-05", "Years 02"]: false; // Years gave a 85% discount
                case ["2020-08-05", "Years 03"]: false; // Years gave a 85% discount
                case _: true;
            }
    }

    static function shopSummary(orders:Array<Order>):WorkSheet {
        orders.sort((a,b) -> switch (Reflect.compare(a.pickupTimeSlotStart, b.pickupTimeSlotStart)) {
            case 0: Reflect.compare(a.orderCode, b.orderCode);
            case v: v;
        });
        var ws = Xlsx.utils.json_to_sheet(orders.map(o -> {
            /* A */ "日期": o.pickupTimeSlotStart.substr(0, 10),
            /* B */ "時段": switch (TimeSlotType.classify(Date.fromString(o.pickupTimeSlotStart))) {
                case Lunch: "午市";
                case Dinner: "晚市";
            },
            /* C */ "單號": o.orderCode,
            /* D */ "訂單內容": o.orderDetails,
            /* E */ "食物價錢": o.orderPrice,
            /* F */ "埗兵收費": "",
        }));

        for (i in 0...orders.length) {
            var r = i + 2;
            Reflect.setField(ws, 'F$r', {
                t: "n",
                f: 'E$r * 0.15',
            });
        }

        Xlsx.utils.sheet_add_aoa(ws, [
            ["", "", "", "", "", ""],
            ["", "", "", "", "", ""],
        ], {
            origin: { r: orders.length+1, c: 0 }
        });

        Reflect.setField(ws, 'E${orders.length+3}', {
            t: "s",
            v: '總埗兵收費',
        });
        Reflect.setField(ws, 'F${orders.length+3}', {
            t: "n",
            f: 'ROUND(SUM(F2:F${orders.length+1}), 1)',
        });

        return ws;
    }

    static function courierSummary(orders:Array<Order>):WorkSheet {
        orders.sort((a,b) -> switch (Reflect.compare(a.pickupTimeSlotStart, b.pickupTimeSlotStart)) {
            case 0: Reflect.compare(a.orderCode, b.orderCode);
            case v: v;
        });
        var ws = Xlsx.utils.json_to_sheet(orders.map(o -> {
            /* A */ "日期": o.pickupTimeSlotStart.substr(0, 10),
            /* B */ "時段": switch (TimeSlotType.classify(Date.fromString(o.pickupTimeSlotStart))) {
                case Lunch: "午市";
                case Dinner: "晚市";
            },
            /* C */ "單號": o.orderCode,
            /* D */ "店舖": o.shopId.info().name,
            /* E */ "訂單內容": o.orderDetails,
            /* F */ "食物價錢": o.orderPrice,
            /* G */ "外賣員收入": "",
            /* H */ "運費": o.deliveryFee,
        }));

        for (i in 0...orders.length) {
            var r = i + 2;
            Reflect.setField(ws, 'G$r', {
                t: "n",
                f: 'F$r * 0.075',
            });
        }

        Xlsx.utils.sheet_add_aoa(ws, [
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "", "", "", ""],
        ], {
            origin: { r: orders.length+1, c: 0 }
        });

        Reflect.setField(ws, 'F${orders.length+3}', {
            t: "s",
            v: 'Total',
        });
        Reflect.setField(ws, 'G${orders.length+3}', {
            t: "n",
            f: 'ROUND(SUM(G2:G${orders.length+1}), 1)',
        });
        Reflect.setField(ws, 'H${orders.length+3}', {
            t: "n",
            f: 'SUM(H2:H${orders.length+1})',
        });

        return ws;
    }

    static function calculate():Void {
        var summaryDir = "summary";
        FileSystem.createDirectory(summaryDir);

        var orders:Array<Order> = Json.parse(File.getContent("orders.json"));
        orders = orders.filter(filterOrder);
        orders.sort((a,b) -> switch (Reflect.compare(a.pickupTimeSlotStart, b.pickupTimeSlotStart)) {
            case 0: Reflect.compare(a.orderCode, b.orderCode);
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
        ];
        var charges = new Map<Shop<Dynamic>, Decimal>();
        for (shop in shops) {
            var orders = orders.filter(o -> o.shopId == shop);
            var wb = Xlsx.utils.book_new();
            var ws = shopSummary(orders);

            Xlsx.utils.book_append_sheet(wb, ws, "orders");
            Xlsx.writeFile(wb, Path.join([summaryDir, "shop", dateStart.substr(0, 10) + "_" + dateEnd.substr(0, 10) + "_" + shop.info().name + ".xlsx"]));

            var totalCharge = orders
                .map(o -> (o.orderPrice:Decimal) * 0.15)
                .fold((item, result) -> result + item, Decimal.zero)
                .roundTo(1);
            charges[shop] = totalCharge;
            Sys.println('${shop.info().name}: ${totalCharge.toString()}');
        };

        Sys.println("-----------------------------");

        var allCharge:Decimal = [for (shop => c in charges) c]
            .fold((item, result) -> result + item, Decimal.zero);
        Sys.println('All charges: ${allCharge.toString()}');

        Sys.println("-----------------------------");

        FileSystem.createDirectory(Path.join([summaryDir, "courier"]));
        var couriers = [
            for (o in orders)
            o.courierTgUsername => o.courierTgUsername
        ].array();
        couriers.sort((a,b) -> Reflect.compare(a.toLowerCase(), b.toLowerCase()));
        var courierPayout = new Map<String, Decimal>();
        var courierNameMax = Std.int(couriers.fold((item, r) -> Math.max(item.length, r), 0));
        for (courier in couriers) {
            var orders = orders.filter(o -> o.courierTgUsername == courier);
            var wb = Xlsx.utils.book_new();
            var ws = courierSummary(orders);

            Xlsx.utils.book_append_sheet(wb, ws, "orders");
            Xlsx.writeFile(wb, Path.join([summaryDir, "courier", dateStart.substr(0, 10) + "_" + dateEnd.substr(0, 10) + "_" + courier + ".xlsx"]));

            var chargeTotal:Decimal = orders
                .map(o -> (o.orderPrice:Decimal) * 0.075)
                .fold((item, result) -> result + item, Decimal.zero)
                .roundTo(1);
            courierPayout[courier] = chargeTotal;
            var feeTotal:Decimal = orders
                .map(o -> (o.deliveryFee:Decimal))
                .fold((item, result) -> result + item, Decimal.zero);
            Sys.println('${courier.lpad(" ", courierNameMax)}: ${chargeTotal.toString().lpad(" ", 5)} + ${feeTotal.toString().lpad(" ", 5)} = ${(chargeTotal + feeTotal).toString().lpad(" ", 6)}');
        }
        Sys.println("-----------------------------");
        var allPayout:Decimal = [for (courier => v in courierPayout) v]
            .fold((item, result) -> result + item, Decimal.zero);
        Sys.println('All payouts: ${allPayout.toString()}');
        Sys.println("-----------------------------");
        Sys.println('Platform income: ${(allCharge - allPayout).toString()}');
    }

    static function main():Void {
        switch (Sys.args()) {
            case ["importDocs"]:
                importDocs();
            case ["calculate"]:
                calculate();
            case args:
                throw "unknown args: " + args;
        }
    }
}