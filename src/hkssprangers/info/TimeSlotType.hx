package hkssprangers.info;

enum abstract TimeSlotType(String) to String {
    final Lunch;
    final Dinner;

    public function info() return switch (cast this:TimeSlotType) {
        case Lunch:
            {
                id: Lunch,
                name: "午餐",
                periodName: "午市",
                cutoffTime: "12:00:00",
                pickupStart: "10:00:00",
                pickupEnd: "15:00:00",
            }
        case Dinner:
            {
                id: Dinner,
                name: "晚餐",
                periodName: "晚市",
                cutoffTime: "17:00:00",
                pickupStart: "17:00:00",
                pickupEnd: "22:00:00",
            }
    }

    static public function classify(date:Date):TimeSlotType {
        var time = (date:LocalDateString).getTimePart();

        for (t in [Lunch, Dinner])
            if (t.info().pickupStart <= time && time < t.info().pickupEnd)
                return t;

        return null;
    }

    static public function fromId(id:String) return switch (cast id:TimeSlotType) {
        case Lunch: Lunch;
        case Dinner: Dinner;
        case _: null;
    }
}
