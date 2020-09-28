package hkssprangers.info;

class TimeSlotTools {
    static public function print(slot:TimeSlot):String {
        var startDate = slot.start.toDate();
        var endDate = slot.end.toDate();
        return '${startDate.getMonth() + 1}月${startDate.getDate()}日 (${Weekday.fromDay(startDate.getDay()).info().name}) ${TimeSlotType.classify(slot.start).info().name} (${DateTools.format(startDate, "%H:%M")}-${DateTools.format(endDate, "%H:%M")})';
    }
}