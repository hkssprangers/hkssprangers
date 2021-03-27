package hkssprangers;

import google_auth_library.JWT;
import thx.Decimal;
import tink.CoreApi;
import js.lib.Promise;
import js.npm.google_spreadsheet.GoogleSpreadsheet;
import js.npm.google_spreadsheet.GoogleSpreadsheetWorksheet;
import hkssprangers.info.*;
import hkssprangers.info.Shop;
import hkssprangers.info.ContactMethod;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.OrderTools.*;
using Lambda;
using StringTools;
using DateTools;
using hkssprangers.MathTools;
using hkssprangers.ObjectTools;
using hkssprangers.info.DeliveryTools;

class GoogleForms {
    static public function getToken() {
        var creds = GoogleServiceAccount.formReaderServiceAccount;
        return new JWT({
            email: creds.client_email,
            key: creds.private_key,
            scopes: "https://www.googleapis.com/auth/spreadsheets",
        }).authorize().then(cred -> cred.access_token);
    }

    static public final responseSheetId = [
        YearsHK => "1Jq1AuOc6pG-EuqsGkRj_DS4TWvFXa-r3pGY9DFMqhGk",
        TheParkByYears => "1-KXKq08g0iuXAQIhSjJGeUPtdrxamvEIzmP4YBUhTHg",
        EightyNine => "1Y-yqDQsYO4UeJa4Jxl2ZtZ56Su84cU58TVrm7QpXTHg",
        DragonJapaneseCuisine => "1A_dPdhn6jDGZU-iyDXVKkEdme2VsUZxMUgjZZPa3gMc",
        LaksaStore => "16Jw8bVcW1N87jndk6VQ99E3mBB_H9hxLckM8eIbGpcY",
        DongDong => "1IpJteF-lZ9wd0tSHPgwsVyUuhuWraAdgKnKisYalFb8",
        BiuKeeLokYuen => "1VNUqFi8I6JPU1-8M2ZiUbPUolX4x4yx-praq2H2Iu-s",
        KCZenzero => "1gHslFNSVO8KOoD6IEcV-mglGoGailUaHr4SbQRSzFOo",
        Neighbor => "15Mzv3r9wTbxpIiJEPbPPwF8O7oP4hQGQ5bksyMuKXHY",
        MGY => "1jbZng_nv2nx3WgY7BV6DfpGz_3AuheVH2VYNOxQCQvM",
        FastTasteSSP => "1OeoNlkZlzj_QpZJV9UaKpXbQjdYSoXLUPbKi5YeWQdw",
        ZeppelinHotDogSKM => "1RME0bT1k1DVbJesBLc3F0aGPzpRlajsrTbPlzAqkFNg",
    ];

    static public function getResponseSheet(token:Promise<String>, shop:Shop):Promise<GoogleSpreadsheet> {
        var doc = new GoogleSpreadsheet(responseSheetId[shop]);
        return token
            .then(token -> doc.useRawAccessToken(token))
            .then(_ -> doc.loadInfo())
            .catchError(err -> {
                trace('Failed to loadInfo() for ${shop.info().name}\n' + err);
                trace('retry');
                (Future.delay(1000 * 3, Noise):tink.Promise<Noise>)
                    .toJsPromise()
                    .then(_ -> doc.loadInfo());
            })
            .then(_ -> doc);
    }

    static function rowToDelivery(shop:Shop, headers:Array<String>, row:Array<String>):Delivery {
        var order:Order = {
            creationTime: null,
            shop: shop,
            wantTableware: null,
            customerNote: null,
            orderDetails: null,
            orderPrice: null,
            platformServiceCharge: null,
            receipts: null,
        };
        var delivery:Delivery = {
            creationTime: null,
            deliveryCode: null,
            couriers: [],
            customer: {
                tg: null,
                tel: null,
            },
            customerPreferredContactMethod: null,
            paymentMethods: null,
            pickupLocation: null,
            pickupTimeSlot: null,
            pickupMethod: null,
            deliveryFee: Math.NaN,
            customerNote: null,
            orders: [order],
        };
        var iceCream = [];
        var blablabla = {
            customerNote: null,
            orderItems: [],
        };
        var orderContent = [];
        var extraOrderContent = [];
        for (col => h in headers)
        switch [shop, h, row[col]] {
            case [_, "叫多份?" | "請選擇類別" | null, _]:
                null;
            case [_, "Timestamp" | "時間戳記", v]:
                delivery.creationTime = order.creationTime = if (v.contains("年")) {
                    // 2020年9月20日 上午03:24:53
                    Date.fromTime(Moment.call(v, "LL Ahh:mm:ss", "zh-hk", true).toDate().getTime());
                } else if (v.contains("/")) {
                    // 9/2/2020 9:59:25
                    Date.fromTime(Moment.call(v, "M/D/YYYY H:m:s", true).toDate().getTime());
                } else if (v.contains("-")) {
                    Date.fromTime(Moment.call(v).toDate().getTime());
                } else {
                    throw "unknown date format: " + v;
                }
            case [_, _, null | "" | "明白了"]:
                null;
            case [_, "想幾時收到?", v]:
                var dateReg = ~/([0-9]+)月([0-9]+)日/;
                var timeSlotReg = ~/([0-9]{2}:[0-9]{2})\s*\-\s*([0-9]{2}:[0-9]{2})/;
                if (dateReg.match(v) && timeSlotReg.match(v)) {
                    var dateStr = Date.now().getFullYear() + "-" + dateReg.matched(1).lpad("0", 2) + "-" + dateReg.matched(2).lpad("0", 2);
                    delivery.pickupTimeSlot = {
                        start: dateStr + " " + timeSlotReg.matched(1) + ":00",
                        end: dateStr + " " + timeSlotReg.matched(2) + ":00",
                    };
                } else {
                    throw 'Cannot parse datetime from ' + v;
                }
            case [_, "你的地址", v]:
                delivery.pickupLocation = v;
            case [_, "你的聯絡方式 (外賣員會和你聯絡同收款)", v]:
                delivery.customerPreferredContactMethod = if (v.toLowerCase().startsWith("telegram")) {
                    Telegram;
                } else if (v.toLowerCase().startsWith("whatsapp")) {
                    WhatsApp;
                } else {
                    throw 'Unknown contact method: ' + v;
                }
            case [_, "你的電話號碼" | "你的電話號碼/Whatsapp", v]:
                delivery.customer.tel = v;
            case [_, "俾錢方法", v]:
                delivery.paymentMethods = v.split(",").map(v -> PaymentMethod.fromName(v.trim()));
            case [_, "交收方法", v]:
                delivery.pickupMethod = PickupMethod.fromName(v.split(" ")[0]);
            case [_, "需要餐具嗎?", v]:
                order.wantTableware = switch (v) {
                    case "要": true;
                    case "唔要": false;
                    case _: throw 'tableware? ' + v;
                };
            case [_, "其他備註", v]:
                delivery.customerNote = v;
            case [_, h, v] if (h.startsWith("你的tg username") || h.startsWith("你的Telegram username")):
                var r = ~/^@?([A-Za-z0-9_]{5,})$/;
                delivery.customer.tg = if (r.match(v.trim())) {
                    username: r.matched(1),
                } else null;
            case [_, h, v] if (h.contains("HANA SOFT CREAM")):
                iceCream.push(v);
            case [_, h, v = "涼拌青瓜拼木耳" | "郊外油菜"]:
                orderContent.push(h + ": " + v);
                orderContent.push("套餐附送絲苗白飯2個");
            case [LaksaStore, "湯底選擇", v]:
                orderContent.push(v);
            case [LaksaStore, "配料選擇", v]:
                orderContent[orderContent.length - 1] += " " + v;
            case [LaksaStore, "麵類選擇", v]:
                orderContent[orderContent.length - 1] += " " + v + " $50";
            case [LaksaStore, "餐飲選擇", v]:
                orderContent.push(v);
            case [KCZenzero, "車仔粉主食選擇", v]:
                orderContent.push(h + ": " + v + " $" + switch (v.split(", ").length) {
                    case 0, 1, 2: 48;
                    case n: 48 + (n - 2) * 5;
                });
            case [DongDong, "午餐選擇" | "小菜" | "以下套餐奉送例湯", v]:
                orderContent.push(h + ": " + v);
                extraOrderContent.push("外賣盒 (+$1)");
            case [BiuKeeLokYuen, "雙併配料選擇", "唔加"]:
                // pass
            case [BiuKeeLokYuen, h, v] if (h.endsWith("配料選擇")):
                orderContent.push(h.substr(0, h.length - "配料選擇".length) + ": " + v);
            case [BiuKeeLokYuen, "請選擇", v]:
                orderContent.push(v);
            case [MGY, "小菜 - $53", v]:
                orderContent.push(v + " $53");
                extraOrderContent.push("外賣盒 (+$1)");
            case [MGY, "客飯 / 炒粉飯 / 日式冷麵", v]:
                orderContent.push(v);
                extraOrderContent.push("外賣盒 (+$1)");
            case [MGY, "粉麵選擇 - $43", v]:
                orderContent.push(v + " $43");
                extraOrderContent.push("外賣盒 (+$1)");
            case [MGY, "小食選擇", v]:
                orderContent.push(v);
            case [_, h, v] if (h.startsWith("加購壺說飲品")):
                blablabla.orderItems.push(v);
            case [_, "壺說飲品備註", v]:
                blablabla.customerNote = v;
            case [FastTasteSSP, h, v] if (!(h.contains("飲品") || h.contains("配料") || h.startsWith("套餐: 跟餐選擇"))):
                if (h == "請選擇") {
                    orderContent.push(v);
                } else {
                    orderContent.push(h + ": " + v);
                }
                var multi = ~/^(\d+)份$/;
                if (multi.match(v)) {
                    for (_ in 0...Std.parseInt(multi.matched(1)))
                        extraOrderContent.push("外賣盒 (+$1)");
                } else {
                    for (_ in v.split(","))
                        extraOrderContent.push("外賣盒 (+$1)");
                }
            case [_, h, v]:
                if (h == "請選擇") {
                    orderContent.push(v);
                } else {
                    orderContent.push(h + ": " + v);
                }
        }
        switch (shop) {
            case KCZenzero:
                extraOrderContent.push("外賣盒 (+$2)");
            case _:
                //pass
        }
        order.orderDetails = orderContent.concat(extraOrderContent).join("\n");
        order.orderPrice = parseTotalPrice(order.orderDetails);
        if (iceCream.length > 0) {
            delivery.orders.push(order.with({
                shop: HanaSoftCream,
                orderDetails: iceCream.join("\n"),
                orderPrice: parseTotalPrice(iceCream.join("\n")),
            }));
        }
        if (blablabla.orderItems.length > 0) {
            delivery.orders.push(order.with({
                shop: BlaBlaBla,
                orderDetails: blablabla.orderItems.join("\n"),
                orderPrice: parseTotalPrice(blablabla.orderItems.join("\n")),
                customerNote: blablabla.customerNote,
            }));
        }
        for (order in delivery.orders) {
            order.platformServiceCharge = (order.orderPrice:Decimal) * 0.15;
        }
        delivery.deliveryFee = switch (DeliveryFee.decideDeliveryFee(delivery.orders[0].shop, delivery.pickupLocation)) {
            case null: Math.NaN;
            case fee:
                if (delivery.pickupTimeSlot.start > ("2020-11-27 00:00:00":LocalDateString) && delivery.pickupTimeSlot.start <= ("2020-11-29 23:59:59":LocalDateString))
                    // 懲罰祭減$5 https://www.facebook.com/hkssprangers/posts/169080954895475
                    fee - 5;
                else
                    fee;
        }
        return delivery;
    }

    static function duplicatedResponse(r1:Array<String>, r2:Array<String>):Bool {
        if (r1.length != r2.length)
            return false;

        for (col in 1...r1.length) // ignore first col (index 0), which is timestamp
            if (r1[col] != r2[col])
                return false;

        return true;
    }

    static public function getDeliveries(shop:Shop, sheet:GoogleSpreadsheetWorksheet, ?skipRow:Int):{
        /** 1-based **/
        final lastRow:Int;
        final deliveries:Array<Delivery>;
     } {
        var headers = [
            for (col in 0...sheet.columnCount)
            (sheet.getCell(0, col).value:Null<String>)
        ].map(h -> if (h != null) h.trim() else null);
        var pickupTimeCol = headers.findIndex(h -> h == "想幾時收到?");
        if (skipRow == null)
            skipRow = 1;
        var lastRow = null;
        var deliveries = [];
        var rows = [];
        for (rowIndex in 0...sheet.rowCount) {
            var row:Array<String> = [for (col => _ in headers) (sheet.getCell(rowIndex, col).formattedValue:String)];
            rows.push(row);

            if (rowIndex < skipRow)
                continue;

            if (sheet.getCell(rowIndex, 0).value == null)
                break;

            switch (rows.findIndex(r -> row != r && duplicatedResponse(row, r))) {
                case -1:
                    deliveries.push(rowToDelivery(shop, headers, row));
                case i:
                    trace('${shop.info().name}: Row ${rowIndex + 1} is a duplicate of row ${i + 1}.');
            }
            lastRow = rowIndex + 1;
        }

        return {
            lastRow: lastRow,
            deliveries: deliveries,
        }
    }
}