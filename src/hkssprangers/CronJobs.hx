package hkssprangers;

import tink.sql.expr.Functions;
import comments.CommentString.*;
import thx.Weekday;
import hkssprangers.info.Weekday;
import hkssprangers.info.OrderTools;
import telegraf.Extra;
import telegraf.Telegraf;
import hkssprangers.info.TimeSlot;
import hkssprangers.info.TimeSlotType;
import haxe.Json;
import hkssprangers.server.CockroachDb;
import tink.CoreApi;
import tink.core.ext.Promises;
import hkssprangers.info.Shop;
import hkssprangers.info.Delivery;
import tink.sql.expr.Functions as F;
import hkssprangers.Availability;
import hkssprangers.AvailabilityTools;
using Lambda;
using StringTools;
using hkssprangers.db.DatabaseTools;
using hkssprangers.info.TimeSlotTools;

class CronJobs {
    static final isMain = js.Syntax.code("require.main") == js.Node.module;

    static function sendDutyPoll(chatId:String) {
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

        final msg = comment(unindent)/**
            又係時候麻煩各位報一報邊個時段得閒幫手. 
            會喺開市前一小時開設報到投票 (午市 11:00 晚市 17:00).
            會優先派單俾預早報咗當值嘅外賣員.
            亦都希望預早報咗當值嘅外賣員會準時出現報到接單 (15分鐘內), 唔想加罰則, 請自律 🙏
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

    static function setTimeSlots(startDate:LocalDateString, endDate:LocalDateString, setAvailability:TimeSlot->Null<Availability>) {
        final dateStart = startDate.getDatePart();
        final dateEnd = endDate.getDatePart();
        var date = dateStart;
        var slots:Array<TimeSlot> = [];
        while (date <= dateEnd) {
            for (slot in TimeSlotTools.regularTimeSlots) {
                slots.push({
                    start: date + " " + slot.start,
                    end: date + " " + slot.end,
                });
            }
            date = (date + " 00:00:00":LocalDateString).deltaDays(1).getDatePart();
        }

        return CockroachDb.db.timeSlotRule.insertMany([
            for (timeSlot in slots)
            if (setAvailability(timeSlot) != null)
            {
                startTime: timeSlot.start.toDate(),
                endTime: timeSlot.end.toDate(),
                availability: haxe.Json.parse(tink.Json.stringify(setAvailability(timeSlot))),
            }
        ], {
            update: u -> [u.availability.set(Functions.values(u.availability))],
        })
            .toJsPromise()
            .then(_ -> null);
    }

    static function sendAttendancePoll(chatId:String) {
        var tgBot = new Telegraf(TelegramConfig.tgBotToken);
        var now = Date.now();
        var curType = TimeSlotType.classify(now);
        return CockroachDb.db.getDeliveries(now)
            .next(ds -> ds.filter(d -> TimeSlotType.classify(d.pickupTimeSlot.start) == curType))
            .toJsPromise()
            .then(curDeliveries -> {
                final choices = [
                    "我想送 (如有難處，請留言可接單時間) ✋",
                    "冇人就搵我送 (如有難處，請留言可接單時間) 🧘",
                    "送唔到 🙁",
                ];
                final opts = {
                    is_anonymous: false,
                    allows_multiple_answers: false,
                };
                switch (curType) {
                    case Lunch:
                        final msg = if (curDeliveries.length <= 0) {
                            '今朝暫時未收到單。如果12點前有突發單，邊個可以幫手送？';
                        } else {
                            '今朝暫時收到 ${curDeliveries.length} 單。邊個可以幫手送？';
                        }
                        tgBot.telegram.sendPoll(chatId, msg, choices, opts)
                            .then(_ -> null);
                    case Dinner:
                        final msg = if (curDeliveries.length <= 0) {
                            '今晚暫時未收到單。如果7點前有突發單，邊個可以幫手送？';
                        } else {
                            '今晚暫時收到 ${curDeliveries.length} 單。邊個可以幫手送？';
                        }
                        tgBot.telegram.sendPoll(chatId, msg, choices, opts)
                            .then(_ -> null);
                }
            });
    }

    static function main():Void {
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
        js.Node.exports.disableLunch = function(evt, context) {
            final now:LocalDateString = Date.now();
            // user can pre-order in the future 14 days, see TimeSlotSelectorWidget
            final date = now.deltaDays(14);
            return setTimeSlots(date, date, slot -> {
                switch TimeSlotType.classify(slot.start) {
                    case Lunch: Unavailable(AvailabilityTools.disableMessage);
                    case Dinner: null;
                }
            })
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
                case ["disableLunch", startDate, endDate]:
                    setTimeSlots(startDate + " 00:00:00", endDate + " 00:00:00", slot -> {
                        switch (TimeSlotType.classify(slot.start)) {
                            case Lunch: Unavailable(AvailabilityTools.disableMessage);
                            case Dinner: null;
                        }
                    })
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