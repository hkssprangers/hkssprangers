package hkssprangers;

abstract LocalDateString(String) to String {
    @:to
    static public function toDate(dateString:String) return Date.fromString(dateString);

    @:from
    static public function fromString(str:String):LocalDateString return fromDate(Date.fromString(str));

    @:from
    static public function fromDate(d:Date):LocalDateString return cast DateTools.format(d, "%Y-%m-%d %H:%M:%S");

    @:op(A > B)
    static function gt(a:LocalDateString, b:LocalDateString):Bool return (a:String) > (b:String);

    @:op(A >= B)
    static function gte(a:LocalDateString, b:LocalDateString):Bool return (a:String) >= (b:String);

    @:op(A < B)
    static function lt(a:LocalDateString, b:LocalDateString):Bool return (a:String) < (b:String);

    @:op(A <= B)
    static function lte(a:LocalDateString, b:LocalDateString):Bool return (a:String) <= (b:String);
}