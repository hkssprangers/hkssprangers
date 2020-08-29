package hkssprangers;

import js.lib.intl.DateTimeFormat;
import js.npm.xlsx.Xlsx;
import js.node.ChildProcess;
import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import hkssprangers.info.Info;
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
        if (order.creationTime > order.pickupTimeSlotStart)
            throw "order.creationTime > order.pickupTimeSlotStart: " + order;
    }

    static function main():Void {
        var files = FileSystem.readDirectory("orders");
        files.sort(Reflect.compare);
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
            for (line in lines) {
                if (line.startsWith("單號: ")) {
                    if (order != null) {
                        order.orderDetails = orderDetails.join("\n").trim();
                        orders.push(order);
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
                    var tgInvalid = ~/^tg:/;
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
                order.orderDetails = orderDetails.join("\n").trim();
                orders.push(order);
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
}