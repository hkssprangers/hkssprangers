package hkssprangers;

abstract LocalDateString(String) to String {
    public function getDatePart():String return this.substr(0, 10);
    public function getTimePart():String return this.substr(11);

    @:to
    static public function toDate(dateString:String) return dateString != null ? Date.fromString(dateString) : null;

    @:from
    static public function fromString(str:String):LocalDateString return str != null ? fromDate(Date.fromString(str)) : null;

    @:from
    static public function fromDate(d:Date):LocalDateString return d != null ? cast DateTools.format(d, "%Y-%m-%d %H:%M:%S") : null;

    @:op(A > B)
    static function gt(a:LocalDateString, b:LocalDateString):Bool return (a:String) > (b:String);

    @:op(A >= B)
    static function gte(a:LocalDateString, b:LocalDateString):Bool return (a:String) >= (b:String);

    @:op(A < B)
    static function lt(a:LocalDateString, b:LocalDateString):Bool return (a:String) < (b:String);

    @:op(A <= B)
    static function lte(a:LocalDateString, b:LocalDateString):Bool return (a:String) <= (b:String);

    public function is2021GoldenWeek():Bool {
        var date = getDatePart();
        return date >= "2021-05-01" && date <= "2021-05-09";
    }
}