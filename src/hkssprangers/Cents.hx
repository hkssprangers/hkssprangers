package hkssprangers;

abstract Cents(Int) from Int to Int {
    public function print() {
        return "$" + (this * 0.01);
    }

    @:op(A + B)
    static function add(a:Cents, b:Cents):Cents return (a:Int) + (b:Int);

    @:op(A - B)
    static function minus(a:Cents, b:Cents):Cents return (a:Int) + (b:Int);

    @:op(A > B)
    static function gt(a:Cents, b:Cents):Bool return (a:Int) > (b:Int);

    @:op(A >= B)
    static function gte(a:Cents, b:Cents):Bool return (a:Int) >= (b:Int);

    @:op(A < B)
    static function lt(a:Cents, b:Cents):Bool return (a:Int) < (b:Int);

    @:op(A <= B)
    static function lte(a:Cents, b:Cents):Bool return (a:Int) <= (b:Int);
}