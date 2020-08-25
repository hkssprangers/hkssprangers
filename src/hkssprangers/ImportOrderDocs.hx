package hkssprangers;

import js.node.ChildProcess;
import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import hkssprangers.info.Info;
using StringTools;

class ImportOrderDocs {
    static function textract(file:String):String {
        return ChildProcess.spawnSync("npx", ["textract", file], {
            encoding: "utf8",
        }).stdout;
    }

    static function main():Void {
        var files = FileSystem.readDirectory("orders");
        files.sort(Reflect.compare);
        // for (file in files) {
        for (file in files.slice(0, 1)) {
            var dateStr = file.substr(0, 10);
            var file = Path.join(["orders", file]);
            var content = textract(file);
            var lines = content.split("\n");
            var orders = [];
            var order = null;
            for (line in lines) {
                if (line.startsWith("單號: ")) {
                    if (order != null) {
                        orders.push(order);
                    }
                    order = {
                        creationTime: null,
                        orderCode: null,
                        shopId: null,
                        orderDetails: null,
                        orderPrice: null,
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
                        if (order.orderDetails == null)
                            order.orderDetails = [];
                        order.orderDetails.push(line.trim());
                        continue;
                    }

                    var priceReg = ~/^(?:食物價錢|total):\s*\$?\s*([0-9]+)$/i;
                    if (priceReg.match(line)) {
                        order.orderPrice = Std.parseInt(priceReg.matched(1));
                        continue;
                    }

                    var pricePlusReg = ~/^食物\s*\+\s*運費:\s*\$?\s*([0-9]+)$/;
                    if (pricePlusReg.match(line)) {
                        order.deliveryFee = order.orderPrice - Std.parseInt(pricePlusReg.matched(1));
                        continue;
                    }

                    var timeSlotReg = ~/^客人交收時段:\s*.*([0-9]{2}:[0-9]{2})\s*\-\s*([0-9]{2}:[0-9]{2})/;
                    if (timeSlotReg.match(line)) {
                        order.pickupTimeSlotStart = Date.fromString(dateStr + " " + timeSlotReg.matched(1) + ":00");
                        order.pickupTimeSlotEnd = Date.fromString(dateStr + " " + timeSlotReg.matched(2) + ":00");
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

                    var telReg = ~/^[0-9]{8}$/;
                    if (telReg.match(line)) {
                        order.customerTel = line.trim();
                        continue;
                    }

                    if (~/payme/i.match(line) || ~/fps/i.match(line)) {
                        order.paymentMethods = line.split(",").map(v -> switch (v.trim().toLowerCase()) {
                            case "payme": PayMe;
                            case "fps": FPS;
                            case v: throw "unregconized payment method: " + v;
                        }).join(",");
                        continue;
                    }

                    var addressReg = ~/^(.+?)\s*\((.+交收)\).*$/;
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
                }
            }

            if (order != null)
                orders.push(order);
            trace(Json.stringify(orders, null, "  "));
        }
    }
}