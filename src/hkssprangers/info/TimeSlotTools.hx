package hkssprangers.info;

import js.lib.Promise;
import hkssprangers.Availability;
import hkssprangers.info.TimeSlot;
import hkssprangers.info.TimeSlotType;
using Lambda;

class TimeSlotTools {
    static public function print(slot:TimeSlot):String {
        final startDate = slot.start.toDate();
        final endDate = slot.end.toDate();
        return '${slot.start.toReadable()} ${TimeSlotType.classify(slot.start).info().name} (${DateTools.format(startDate, "%H:%M")}-${DateTools.format(endDate, "%H:%M")})';
    }

    static public function printTime(slot:TimeSlot):String {
        final startDate = slot.start.toDate();
        final endDate = slot.end.toDate();
        return '${DateTools.format(startDate, "%H:%M")}-${DateTools.format(endDate, "%H:%M")} (${TimeSlotType.classify(slot.start).info().name})';
    }

    static public final regularTimeSlots = [
        { cutoff: "11:20:00", start: "12:00:00", end: "13:00:00" },
        { cutoff: "11:50:00", start: "12:30:00", end: "13:30:00" },
        { cutoff: "12:00:00", start: "13:00:00", end: "14:00:00" },
        { cutoff: "12:00:00", start: "13:30:00", end: "14:30:00" },

        { cutoff: "17:20:00", start: "18:00:00", end: "19:00:00" },
        { cutoff: "17:50:00", start: "18:30:00", end: "19:30:00" },
        { cutoff: "18:20:00", start: "19:00:00", end: "20:00:00" },
        { cutoff: "18:50:00", start: "19:30:00", end: "20:30:00" },
        { cutoff: "19:00:00", start: "19:45:00", end: "20:30:00" },
    ];

    static public function getTimeSlots(date:LocalDateString, ?now:LocalDateString):Promise<Array<TimeSlotChoice>> {
        final dateStr = date.getDatePart();
        final now = now != null ? now : (Date.now():LocalDateString);
        final timeNow = now.toDate().getTime();
        #if (!browser)
            return Promise.resolve(
                regularTimeSlots
                    .map(slot -> {
                        availability: switch (dateStr) {
                            case "2022-09-19" if (slot.start <= "16:00:00"):
                                Unavailable("人手不足，提早截單");
                            case _:
                                if ((dateStr + " " + slot.cutoff:LocalDateString).toDate().getTime() >= timeNow) {
                                    Available;
                                } else {
                                    Unavailable("已截單");
                                }
                        },
                        start: (dateStr + " " + slot.start:LocalDateString),
                        end: (dateStr + " " + slot.end:LocalDateString),
                    })
            );
        #else
            final query = new js.html.URLSearchParams({
                date: dateStr,
                now: now,
            });
            return js.Browser.window.fetch('/time-slot-choices?' + query)
                .then(r -> if (r.ok) r.text() else throw r.status)
                .then(r -> (tink.Json.parse(r):Array<TimeSlotChoice>));
        #end
    }
}