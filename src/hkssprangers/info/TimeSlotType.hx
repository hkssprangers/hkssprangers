package hkssprangers.info;

enum abstract TimeSlotType(String) to String {
    var Lunch;
    var Dinner;

    public function info() return switch (cast this:TimeSlotType) {
        case Lunch:
            {
                id: Lunch,
                name: "午餐",
                cutoffTime: "10:00",
            }
        case Dinner:
            {
                id: Dinner,
                name: "晚餐",
                cutoffTime: "17:00",
            }
    }

    static public function classify(date:Date):TimeSlotType {
        var hour = date.getHours();
        return if (hour < 15)
            Lunch;
        else
            Dinner;
    }

    static public function fromId(id:String) return switch (cast id:TimeSlotType) {
        case Lunch: Lunch;
        case Dinner: Dinner;
        case _: null;
    }
}
