package hkssprangers;

import comments.CommentString.*;
import thx.Weekday;
import hkssprangers.info.Weekday;
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
using hkssprangers.db.DatabaseTools;
using hkssprangers.info.TimeSlotTools;

class ImportGoogleForm {
    static final isMain = js.Syntax.code("require.main") == js.Node.module;

    static function sendDutyPoll(chatId:Float) {
        var tgBot = new Telegraf(TelegramConfig.tgBotToken);
        var now = Date.now();
        var nextDays = switch (Weekday.fromDay(now.getDay())) {
            case Sunday:
                [
                    Date.fromTime(now.getTime() + DateTools.days(1)),
                    Date.fromTime(now.getTime() + DateTools.days(2)),
                    Date.fromTime(now.getTime() + DateTools.days(3)),
                    Date.fromTime(now.getTime() + DateTools.days(4)),
                ];
            case Thursday:
                [
                    Date.fromTime(now.getTime() + DateTools.days(1)),
                    Date.fromTime(now.getTime() + DateTools.days(2)),
                    Date.fromTime(now.getTime() + DateTools.days(3)),
                ];
            case d:
                throw "Unknown weekday: " + d;
        }

        var slots = [
            for (d in nextDays)
            for (t in [Lunch, Dinner])
            (d.getMonth() + 1) + "月" + d.getDate() + "日 (" + Weekday.fromDay(d.getDay()).info().name + ") " + t.info().periodName
        ];

        var msg = comment(unindent)/**
            又係時候麻煩各位報一報邊個時段得閒幫手. 
            截單嘅時候我會照舊開設報到投票, 午市 10:30 晚市 17:15 截止報到投票.
            會優先派單俾預早報咗當值嘅外賣員.
            亦都希望預早報咗當值嘅外賣員會準時出現報到接單 (10:30/17:15), 唔想加罰則, 請自律~ 🙏
        **/;

        return tgBot.telegram.sendPoll(chatId, msg, slots.concat(["以上日子全部都唔得/唔肯定"]), {
            is_anonymous: false,
            allows_multiple_answers: true,
        })
            .then(msg -> {
                tgBot.telegram.pinChatMessage(chatId, msg.message_id);
            })
            .then(_ -> null);
    }

    static function sendAttendancePoll(chatId:Float) {
        var tgBot = new Telegraf(TelegramConfig.tgBotToken);
        var now = Date.now();
        var curType = TimeSlotType.classify(now);
        return MySql.db.getDeliveries(now)
            .next(ds -> ds.filter(d -> TimeSlotType.classify(d.pickupTimeSlot.start) == curType))
            .toJsPromise()
            .then(curDeliveries -> {
                var choices = [
                    "我想送 ✋",
                    "冇人就搵我送 🧘",
                    "送唔到 🙁",
                ];
                var opts = {
                    is_anonymous: false,
                    allows_multiple_answers: false,
                };
                switch (curType) {
                    case Lunch:
                        if (curDeliveries.length <= 0) {
                            tgBot.telegram.sendMessage(chatId, '今朝冇單 😔')
                                .then(msg -> {
                                    tgBot.telegram.pinChatMessage(chatId, msg.message_id);
                                })
                                .then(_ -> null);
                        } else {
                            tgBot.telegram.sendPoll(chatId, '今朝 ${curDeliveries.length} 單。邊個可以幫手送？',
                                choices,
                                opts
                            )
                            .then(_ -> null);
                        }
                    case Dinner:
                        var msg = if (curDeliveries.length <= 0) {
                            '今晚暫時未收到單。如果7點前有突發單，邊個可以幫手送？';
                        } else {
                            '今晚暫時收到 ${curDeliveries.length} 單。邊個可以幫手送？';
                        }
                        tgBot.telegram.sendPoll(chatId, msg, choices, opts)
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

    static final _existingDeliveries = new Map<String, Promise<Array<Delivery>>>();
    static function existingDeliveries(date:String, shop:Shop, t:TimeSlotType) {
        return (if (_existingDeliveries.exists(date)) {
            _existingDeliveries[date];
        } else {
            _existingDeliveries[date] = MySql.db.getDeliveries(Date.fromString(date));
        }).next(deliveries -> deliveries.filter(d -> d.orders.exists(o -> o.shop == shop) && TimeSlotType.classify(d.pickupTimeSlot.start) == t));
    }

    static function importGoogleForms():Promise<Bool> {
        var now = Date.now();
        var failed = false;
        var newDeliveries = [];
        var token = GoogleForms.getToken();
        return getLastImportRows()
            .next(lastRows ->
                Promise.inSequence([
                    for (shop => id in GoogleForms.responseSheetId)
                    Promise.lazy(function()
                    {
                        var lastRow = switch (lastRows.find(r -> r.spreadsheetId == GoogleForms.responseSheetId[shop])) {
                            case null:
                                trace("Could not find the last import row number of " + shop);
                                null;
                            case r:
                                r.lastRow;
                        }
                        var getDeliveries = GoogleForms.getResponseSheet(token, shop)
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
                                                true;
                                            case jsErr if (jsErr.message.contains("[503]")): // Service Unavailable
                                                trace(jsErr.message);
                                                true;
                                            case jsErr:
                                                trace(Json.stringify(jsErr, null, "  "));
                                                true;
                                        }
                                        if (shouldRetry) {
                                            trace("retry");
                                            (Future.delay(5000 * 3, Noise):Promise<Noise>)
                                                .toJsPromise()
                                                .then(_ -> sheet.loadCells());
                                        } else {
                                            throw err;
                                        }
                                    })
                                    .then(_ -> sheet);
                            })
                            .then(sheet -> GoogleForms.getDeliveries(shop, sheet, lastRow));
                        return Promise.ofJsPromise(getDeliveries)
                            .recover(err -> {
                                trace(err);
                                {
                                    lastRow: null,
                                    deliveries: [],
                                }
                            })
                            .next(getDeliveries -> {
                                var deliveries = getDeliveries.deliveries;
                                trace('New deliveries of ${shop.info().name}: ' + deliveries.length);
                                if (deliveries.length > 0) {
                                    var deliveriesByDate = [
                                        for (d in deliveries)
                                        (d.pickupTimeSlot.start:String).substr(0, 10) => null
                                    ];
                                    for (dateStr in deliveriesByDate.keys())
                                        deliveriesByDate[dateStr] = deliveries.filter(d -> (d.pickupTimeSlot.start:String).startsWith(dateStr));
                                    MySql.db.insertDeliveries(deliveries)
                                        .next(_ -> MySql.db.googleFormImport.insertOne({
                                            importTime: now,
                                            spreadsheetId: GoogleForms.responseSheetId[shop],
                                            lastRow: getDeliveries.lastRow,
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
                                } else {
                                    Promise.NOISE;
                                }
                            })
                            .next(_ -> Future.delay(500, Noise));
                    })
                ])
            )
            .next(_ -> Promise.ofJsPromise(TelegramTools.notifyNewDeliveries(newDeliveries, production)))
            .next(_ -> !failed);
    }

    static function main():Void {
        js.Node.exports.importGoogleForms = function(evt, context) {
            return importGoogleForms().toJsPromise()
                .then(succeeded -> {
                    statusCode: 200,
                    body: "done",
                })
                .catchError(err -> {
                    context.serverlessSdk.captureError(err);
                    {
                        statusCode: 500,
                        body: Std.string(err),
                    };
                });
        };
        js.Node.exports.sendAttendancePoll = function(evt, context) {
            return sendAttendancePoll(TelegramConfig.internalGroupChatId)
                .then(_ -> {
                    statusCode: 200,
                    body: "done",
                })
                .catchError(err -> {
                    context.serverlessSdk.captureError(err);
                    {
                        statusCode: 500,
                        body: Std.string(err),
                    };
                });
        }
        js.Node.exports.sendDutyPoll = function(evt, context) {
            return sendDutyPoll(TelegramConfig.internalGroupChatId)
                .then(_ -> {
                    statusCode: 200,
                    body: "done",
                })
                .catchError(err -> {
                    context.serverlessSdk.captureError(err);
                    {
                        statusCode: 500,
                        body: Std.string(err),
                    };
                });
        }

        if (isMain) {
            switch (Sys.args()) {
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
                case ["sendDutyPoll"]:
                    sendDutyPoll(TelegramConfig.internalGroupChatId)
                        .then(_ -> Sys.exit(0))
                        .catchError(err -> {
                            trace(err);
                            Sys.exit(1);
                        });
                case ["sendDutyPoll", "test"]:
                    sendDutyPoll(TelegramConfig.testingGroupChatId)
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