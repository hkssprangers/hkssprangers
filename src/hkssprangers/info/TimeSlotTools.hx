package hkssprangers.info;

import hkssprangers.info.TimeSlotType;
using Lambda;

class TimeSlotTools {
    static public function print(slot:TimeSlot):String {
        var startDate = slot.start.toDate();
        var endDate = slot.end.toDate();
        return '${startDate.getMonth() + 1}月${startDate.getDate()}日 (${Weekday.fromDay(startDate.getDay()).info().name}) ${TimeSlotType.classify(slot.start).info().name} (${DateTools.format(startDate, "%H:%M")}-${DateTools.format(endDate, "%H:%M")})';
    }

    static final regularTimeSlots = [
        { start: "12:00:00", end: "13:00:00", cutoff: "10:00:00" },
        { start: "12:30:00", end: "13:30:00", cutoff: "10:00:00" },
        { start: "13:00:00", end: "14:00:00", cutoff: "10:00:00" },
        { start: "13:30:00", end: "14:30:00", cutoff: "10:00:00" },

        { start: "18:00:00", end: "19:00:00", cutoff: "17:45:00" },
        { start: "18:30:00", end: "19:30:00", cutoff: "18:15:00" },
        { start: "19:00:00", end: "20:00:00", cutoff: "18:45:00" },
        { start: "19:30:00", end: "20:30:00", cutoff: "19:00:00" },
    ];

    static public function nextTimeSlots(currentTime:Date):Array<TimeSlot> {
        // prepare slots more than we need and then filter them in the next step
        var slots = {
            var slots = [];
            for (d in 0...2) {
                var date = (Date.fromTime(currentTime.getTime() + DateTools.days(d)):LocalDateString);
                var dateStr = date.getDatePart();
                slots = slots.concat(regularTimeSlots.map(slot -> {
                    cutoff: (dateStr + " " + slot.cutoff:LocalDateString),
                    start: (dateStr + " " + slot.start:LocalDateString),
                    end: (dateStr + " " + slot.end:LocalDateString),
                }));
            }
            slots;
        }

        return slots.filter(slot -> slot.cutoff.toDate().getTime() > currentTime.getTime());
    }
}