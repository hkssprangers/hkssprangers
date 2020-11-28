package hkssprangers;

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
    static public final responseSheetId = [
        YearsHK => "1Jq1AuOc6pG-EuqsGkRj_DS4TWvFXa-r3pGY9DFMqhGk",
        EightyNine => "1Y-yqDQsYO4UeJa4Jxl2ZtZ56Su84cU58TVrm7QpXTHg",
        DragonJapaneseCuisine => "1A_dPdhn6jDGZU-iyDXVKkEdme2VsUZxMUgjZZPa3gMc",
        LaksaStore => "16Jw8bVcW1N87jndk6VQ99E3mBB_H9hxLckM8eIbGpcY",
        DongDong => "1IpJteF-lZ9wd0tSHPgwsVyUuhuWraAdgKnKisYalFb8",
        BiuKeeLokYuen => "1POh9Yy93iyTbm5An_NhQoVWO2QX7GCDcBrs0nZuehKg",
        KCZenzero => "1gHslFNSVO8KOoD6IEcV-mglGoGailUaHr4SbQRSzFOo",
        Neighbor => "15Mzv3r9wTbxpIiJEPbPPwF8O7oP4hQGQ5bksyMuKXHY",
        MGY => "1jbZng_nv2nx3WgY7BV6DfpGz_3AuheVH2VYNOxQCQvM",
    ];

    static public var responseSheet(get, null):Map<Shop, Promise<GoogleSpreadsheet>>;
    static function get_responseSheet() return responseSheet != null ? responseSheet : responseSheet = [
        for (shop => sheetId in responseSheetId) {
            var doc = new GoogleSpreadsheet(sheetId);
            shop => doc.useServiceAccountAuth(GoogleServiceAccount.formReaderServiceAccount)
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
    ];

    static function rowToDelivery(shop:Shop, headers:Array<String>, row:Array<String>):Delivery {
        var order:Order = {
            creationTime: null,
            shop: shop,
            wantTableware: null,
            customerNote: null,
            orderDetails: null,
            orderPrice: null,
            platformServiceCharge: null,
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
                    var dateStr = "2020-" + dateReg.matched(1).lpad("0", 2) + "-" + dateReg.matched(2).lpad("0", 2);
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
            case [_, _, v] if (v.contains("水信玄餅") || v.contains("水玄信餅")):
                iceCream.push(v);
            case [_, _, v] if (v.contains("雪糕")):
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
            case [DongDong, "午餐選擇" | "小菜 - $58" | "以下套餐奉送例湯", v]:
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
            case [_, h, v]:
                orderContent.push(h + ": " + v);
        }
        switch (shop) {
            case KCZenzero:
                extraOrderContent.push("外賣盒 (+$2)");
            case _:
                //pass
        }
        order.orderDetails = orderContent.concat(extraOrderContent).join("\n");
        order.orderPrice = parseTotalPrice(order.orderDetails);
        order.platformServiceCharge = (order.orderPrice:Decimal) * 0.15;
        if (iceCream.length > 0) {
            delivery.orders.push(order.with({
                shop: HanaSoftCream,
                orderDetails: iceCream.join("\n"),
                orderPrice: parseTotalPrice(iceCream.join("\n")),
            }));
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

    static public function getDeliveries(shop:Shop, sheet:GoogleSpreadsheetWorksheet, ?skipRow:Int, ?date:Date):Array<Delivery> {
        var dateStr = date != null ? (date.getMonth() + 1) + "月" + date.getDate() + "日" : null;
        function isInTimeSlot(value:String):Bool {
            return value.startsWith(dateStr);
        }
        var headers = [
            for (col in 0...sheet.columnCount)
            (sheet.getCell(0, col).value:Null<String>)
        ];
        var pickupTimeCol = headers.findIndex(h -> h == "想幾時收到?");
        var deliveries = [];
        for (row in (skipRow == null ? 1 : skipRow)...sheet.rowCount) {
            if (sheet.getCell(row, 0).value == null)
                break;
            if (date == null || isInTimeSlot(sheet.getCell(row, pickupTimeCol).value))
                deliveries.push(rowToDelivery(shop, headers, [for (col => _ in headers) (sheet.getCell(row, col).formattedValue:String)]));
        }
        return deliveries;
    }

    static public function getAllDeliveries(?date:Date):Promise<Array<Delivery>> {
        var now = switch (date) {
            case null: Date.now();
            case v: v;
        }
        // var now = Date.fromString("2020-08-18");
        var sheets = [
            for (shop => doc in responseSheet)
            shop => doc
                .then(doc -> doc.sheetsByIndex[0])
                .then(sheet -> sheet.loadCells().then(_ -> sheet))
        ];
        return [
            for (shop => sheet in sheets)
            sheet
                .then(sheet -> getDeliveries(shop, sheet, null, now))
                .then(deliveries -> {
                    [
                        for (t in [Lunch, Dinner])
                        deliveries
                            .filter(d -> TimeSlotType.classify(d.pickupTimeSlot.start) == t)
                            .mapi((i, d) -> {
                                d.deliveryCode = d.orders[0].shop.info().name + " " + (switch (t) {
                                    case Lunch: "L" + '${i+1}'.lpad("0", 2);
                                    case Dinner: "D" + '${i+1}'.lpad("0", 2);
                                });
                                d;
                            })
                    ].fold((item, result:Array<Delivery>) -> result.concat(item), []);
                })
        ]
            .fold((item, result:Promise<Array<Delivery>>) ->
                item.then(deliveries ->
                    result.then(all ->
                        all.concat(deliveries)
                    )
                )
            , Promise.resolve([]))
            .then(deliveries -> {
                [
                    for (t in [Lunch, Dinner])
                        deliveries.filter(d -> TimeSlotType.classify(d.pickupTimeSlot.start) == t)
                ].fold((item, result:Array<Delivery>) -> result.concat(item), []);
            });
    }
}