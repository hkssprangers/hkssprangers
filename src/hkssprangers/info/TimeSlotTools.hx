package hkssprangers.info;

import hkssprangers.info.TimeSlotType;
using Lambda;

class TimeSlotTools {
    static public function print(slot:TimeSlot):String {
        var startDate = slot.start.toDate();
        var endDate = slot.end.toDate();
        return '${startDate.getMonth() + 1}月${startDate.getDate()}日 (${Weekday.fromDay(startDate.getDay()).info().name}) ${TimeSlotType.classify(slot.start).info().name} (${DateTools.format(startDate, "%H:%M")}-${DateTools.format(endDate, "%H:%M")})';
    }

    static public function printTime(slot:TimeSlot):String {
        var startDate = slot.start.toDate();
        var endDate = slot.end.toDate();
        return '${DateTools.format(startDate, "%H:%M")}-${DateTools.format(endDate, "%H:%M")} (${TimeSlotType.classify(slot.start).info().name})';
    }

    static public final regularTimeSlots = [
        { cutoff: "11:45:00", start: "12:00:00", end: "13:00:00" },
        { cutoff: "12:00:00", start: "12:30:00", end: "13:30:00" },
        { cutoff: "12:00:00", start: "13:00:00", end: "14:00:00" },
        { cutoff: "12:00:00", start: "13:30:00", end: "14:30:00" },

        { cutoff: "17:45:00", start: "18:00:00", end: "19:00:00" },
        { cutoff: "18:15:00", start: "18:30:00", end: "19:30:00" },
        { cutoff: "18:45:00", start: "19:00:00", end: "20:00:00" },
        { cutoff: "19:00:00", start: "19:30:00", end: "20:30:00" },
    ];

    static public function getTimeSlots(date:LocalDateString):Array<TimeSlot & { enabled: Bool }> {
        final dateStr = date.getDatePart();
        final timeNow = Date.now().getTime();
        return regularTimeSlots
            .map(slot -> {
                enabled: (dateStr + " " + slot.cutoff:LocalDateString).toDate().getTime() >= timeNow,
                start: (dateStr + " " + slot.start:LocalDateString),
                end: (dateStr + " " + slot.end:LocalDateString),
            });
    }
}