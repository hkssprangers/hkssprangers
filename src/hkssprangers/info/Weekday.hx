package hkssprangers.info;

enum abstract Weekday(String) {
    var Monday;
    var Tuesday;
    var Wednesday;
    var Thursday;
    var Friday;
    var Saturday;
    var Sunday;

    static public function fromDay(day:Int) return switch (day % 7) {
        case 1: Monday;
        case 2: Tuesday;
        case 3: Wednesday;
        case 4: Thursday;
        case 5: Friday;
        case 6: Saturday;
        case 0: Sunday;
        case _: throw "unknown day";
    }

    public function info() return switch (cast this:Weekday) {
        case Monday:
            {
                id: Monday,
                name: "一",
                day: 1,
            }
        case Tuesday:
            {
                id: Tuesday,
                name: "二",
                day: 2,
            }
        case Wednesday:
            {
                id: Wednesday,
                name: "三",
                day: 3,
            }
        case Thursday:
            {
                id: Thursday,
                name: "四",
                day: 4,
            }
        case Friday:
            {
                id: Friday,
                name: "五",
                day: 5,
            }
        case Saturday:
            {
                id: Saturday,
                name: "六",
                day: 6,
            }
        case Sunday:
            {
                id: Sunday,
                name: "日",
                day: 0,
            }
    }
}