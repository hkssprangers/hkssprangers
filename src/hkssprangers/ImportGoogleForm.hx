package hkssprangers;

import hkssprangers.info.OrderTools;
import telegraf.Extra;
import telegraf.Telegraf;
import hkssprangers.info.TimeSlot;
import hkssprangers.info.TimeSlotType;
import haxe.Json;
import hkssprangers.server.MySql;
import tink.CoreApi;
import tink.core.ext.Promises;
import hkssprangers.info.Shop;
import hkssprangers.info.Delivery;
import tink.sql.expr.Functions as F;
using Lambda;
using StringTools;
using hkssprangers.info.TimeSlotTools;

class ImportGoogleForm {
    static final isMain = js.Syntax.code("require.main") == js.Node.module;

    static function sendAttendancePoll(chatId:Float) {
        var tgBot = new Telegraf(TelegramConfig.tgBotToken);
        var now = Date.now();
        var curType = TimeSlotType.classify(now);
        return MySql.db.getDeliveries(now)
            .next(ds -> ds.filter(d -> TimeSlotType.classify(d.pickupTimeSlot.start) == curType))
            .toJsPromise()
            .then(curDeliveries -> {
                var time = switch (curType) {
                    case Lunch: "今朝";
                    case Dinner: "今晚";
                }
                if (curDeliveries.length <= 0) {
                    tgBot.telegram.sendMessage(chatId, '${time}冇單 😔')
                        .then(msg -> {
                            tgBot.telegram.pinChatMessage(chatId, msg.message_id);
                        })
                        .then(_ -> null);
                } else {
                    tgBot.telegram.sendPoll(chatId, '${time} ${curDeliveries.length} 單。邊個可以幫手送？',
                        [
                            "我想送 ✋",
                            "冇人就搵我送 🧘",
                            "送唔到 🙁",
                        ],
                        {
                            is_anonymous: false,
                            allows_multiple_answers: false,
                        }
                    )
                    .then(_ -> null);
                }
            });
    }

    static function getLastImportRows():Promise<Array<{
        final spreadsheetId:String;
        final lastRow:Int;
    }>> {
        return MySql.db.googleFormImport
            .select({
                spreadsheetId: googleFormImport.spreadsheetId,
                lastRow: F.max(googleFormImport.lastRow),
            })
            .where(row -> row.spreadsheetId.inArray(GoogleForms.responseSheetId.array()))
            .groupBy(row -> [row.spreadsheetId])
            .all();
    }

    // assuming 2020-11-10 has been imported
    static final manualLastImportRow = [
        EightyNine => 41,
        YearsHK => 48,
        BiuKeeLokYuen => 31,
        DragonJapaneseCuisine => 31,
        Neighbor => 40,
        LaksaStore => 55,
        DongDong => 51,
        MGY => 12,
        KCZenzero => 84,
    ];

    static function insertManualLastImportRows() {
        var now = Date.now();
        return MySql.db.googleFormImport.insertMany([
            for (shop => lastRow in manualLastImportRow)
            {
                importTime: now,
                spreadsheetId: GoogleForms.responseSheetId[shop],
                lastRow: lastRow,
            }
        ]).noise();
    }

    static final _existingDeliveries = new Map<String, Promise<Array<Delivery>>>();
    static function existingDeliveries(date:String, shop:Shop, t:TimeSlotType) {
        return (if (_existingDeliveries.exists(date)) {
            _existingDeliveries[date];
        } else {
            _existingDeliveries[date] = MySql.db.getDeliveries(Date.fromString(date));
        }).next(deliveries -> deliveries.filter(d -> d.orders[0].shop == shop && TimeSlotType.classify(d.pickupTimeSlot.start) == t));
    }

    static function notifyNewDeliveries(deliveries:Array<Delivery>) {
        if (deliveries.length <= 0)
            return Promise.resolve(null);

        var tgBot = new Telegraf(TelegramConfig.tgBotToken);
        var deliveryStrs = deliveries
            .map(d ->
                "📃 " + d.orders.map(o -> o.shop.info().name).join(", ") + "\n " + d.pickupTimeSlot.print()
            )
            .map(str -> StringTools.htmlEscape(str, false));
        var msg = '啱啱收到 ${deliveries.length} 單';
        if (deliveries.length > 0) {
            msg += " ✨\n\n";
            msg += deliveryStrs.join("\n\n");
        }
        return tgBot.telegram.sendMessage(
            TelegramConfig.internalGroupChatId,
            msg,
            {
                parse_mode: "HTML",
                disable_web_page_preview: true,
            }
        );
    }

    static function isDuplicated(d1:Delivery, d2:Delivery):Bool {
        return
            (d1.customer.tg == null ? "" : d1.customer.tg.username) == (d2.customer.tg == null ? "" : d2.customer.tg.username) &&
            d1.customer.tel == d2.customer.tel &&
            d1.customerPreferredContactMethod == d2.customerPreferredContactMethod &&
            d1.paymentMethods.join(",") == d2.paymentMethods.join(",") &&
            d1.pickupLocation == d2.pickupLocation &&
            d1.pickupTimeSlot.start == d2.pickupTimeSlot.start &&
            d1.pickupTimeSlot.end == d2.pickupTimeSlot.end &&
            d1.pickupMethod == d2.pickupMethod &&
            d1.customerNote == d2.customerNote &&
            d1.orders.map(OrderTools.print).join("\n") == d2.orders.map(OrderTools.print).join("\n");
    }

    static function importGoogleForms():Promise<Bool> {
        var now = Date.now();
        var failed = false;
        var newDeliveries = [];
        return getLastImportRows()
            .next(lastRows ->
                Promise.inSequence([
                    for (shop => responseSheet in GoogleForms.responseSheet)
                    {
                        var lastRow = switch (lastRows.find(r -> r.spreadsheetId == GoogleForms.responseSheetId[shop])) {
                            case null:
                                trace("Could not find the last import row number of " + shop);
                                null;
                            case r:
                                r.lastRow;
                        }
                        var deliveries:js.lib.Promise<Array<Delivery>> = responseSheet
                            .then(doc -> doc.sheetsByIndex[0])
                            .then(sheet -> {
                                sheet.loadCells()
                                    .catchError(err -> {
                                        trace('Failed to loadCells() for ${shop.info().name}');
                                        var shouldRetry = switch (Std.downcast(err, js.lib.Error)) {
                                            case null:
                                                trace(Json.stringify(err, null, "  "));
                                                true;
                                            case jsErr if (jsErr.message.contains("[429]")): // Quota exceeded
                                                trace(jsErr.message);
                                                false;
                                            case jsErr if (jsErr.message.contains("[503]")): // Service Unavailable
                                                trace(jsErr.message);
                                                true;
                                            case jsErr:
                                                trace(Json.stringify(jsErr, null, "  "));
                                                true;
                                        }
                                        if (shouldRetry) {
                                            trace("retry");
                                            (Future.delay(1000 * 3, Noise):Promise<Noise>)
                                                .toJsPromise()
                                                .then(_ -> sheet.loadCells());
                                        } else {
                                            throw err;
                                        }
                                    })
                                    .then(_ -> sheet);
                            })
                            .then(sheet -> GoogleForms.getDeliveries(shop, sheet, lastRow))
                            .catchError(err -> {
                                trace('Could not get deliveries of ${shop.info().name}');
                                switch (Std.downcast(err, js.lib.Error)) {
                                    case null:
                                        trace(Json.stringify(err, null, "  "));
                                        failed = true;
                                    case jsErr if (jsErr.message.contains("[429]")): // Quota exceeded
                                        trace(jsErr.message);
                                    case jsErr if (jsErr.message.contains("[503]")): // Service Unavailable
                                        trace(jsErr.message);
                                    case jsErr:
                                        trace(Json.stringify(jsErr, null, "  "));
                                        failed = true;
                                }
                                [];
                            });
                        Promise.ofJsPromise(deliveries)
                            .next(deliveries -> {
                                trace('New deliveries of ${shop.info().name}: ' + deliveries.length);
                                if (deliveries.length > 0) {
                                    var deliveriesByDate = [
                                        for (d in deliveries)
                                        (d.pickupTimeSlot.start:String).substr(0, 10) => null
                                    ];
                                    for (dateStr in deliveriesByDate.keys())
                                        deliveriesByDate[dateStr] = deliveries.filter(d -> (d.pickupTimeSlot.start:String).startsWith(dateStr));
                                    Promise.inSequence([
                                        for (dateStr => deliveries in deliveriesByDate)
                                        for (t in [Lunch, Dinner])
                                        existingDeliveries(dateStr, shop, t)
                                            .next(existings -> {
                                                for (d in deliveries.filter(d -> TimeSlotType.classify(d.pickupTimeSlot.start) == t)) {
                                                    if (existings.exists(e -> isDuplicated(e, d))) {
                                                        trace("duplicated Google Form response");
                                                        continue;
                                                    }
                                                    d.deliveryCode = d.orders[0].shop.info().name + " " + (switch t {
                                                        case Lunch: "L";
                                                        case Dinner: "D";
                                                    }) + Std.string(existings.length + 1).lpad("0", 2);
                                                    existings.push(d);
                                                }
                                                Noise;
                                            })
                                    ]).next(_ -> {
                                        var deliveries = deliveries.filter(d -> d.deliveryCode != null);
                                        MySql.db.insertDeliveries(deliveries)
                                            .next(_ -> MySql.db.googleFormImport.insertOne({
                                                importTime: now,
                                                spreadsheetId: GoogleForms.responseSheetId[shop],
                                                lastRow: lastRow + deliveries.length,
                                            }))
                                            .next(_ -> {
                                                trace("done insert of " + shop.info().name);
                                                for (d in deliveries)
                                                    newDeliveries.push(d);
                                                Noise;
                                            })
                                            .recover(err -> {
                                                trace('Could not insert deliveries of ${shop.info().name}.\n' + err);
                                                failed = true;
                                                Noise;
                                            });
                                    });
                                } else {
                                    Promise.NOISE;
                                }
                            });
                    }
                ])
            )
            .next(_ -> Promise.ofJsPromise(notifyNewDeliveries(newDeliveries)))
            .next(_ -> !failed);
    }

    static function main():Void {
        if (isMain) {
            switch (Sys.args()) {
                case ["init"]:
                    insertManualLastImportRows().handle(_ -> Sys.exit(0));
                case ["import"]:
                    importGoogleForms().handle(o -> switch o {
                        case Success(succeeded):
                            Sys.exit(succeeded ? 0 : 1);
                        case Failure(failure):
                            trace(failure);
                            Sys.exit(1);
                    });
                case ["sendAttendancePoll"]:
                    sendAttendancePoll(TelegramConfig.internalGroupChatId)
                        .then(_ -> Sys.exit(0))
                        .catchError(err -> {
                            trace(err);
                            Sys.exit(1);
                        });
                case ["sendAttendancePoll", "test"]:
                    sendAttendancePoll(TelegramConfig.testingGroupChatId)
                        .then(_ -> Sys.exit(0))
                        .catchError(err -> {
                            trace(err);
                            Sys.exit(1);
                        });
                case args:
                    throw "unknown args: " + Json.stringify(args);
            }
        }
    }
}