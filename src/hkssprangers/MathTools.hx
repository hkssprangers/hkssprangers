package hkssprangers;

#if thx_core
import thx.Decimal;
#end
using Lambda;

class FloatTools {
    static public function sum(values:Array<Float>):Float {
        return values.fold((item, result) -> result + item, 0.0);
    }
}

class IntTools {
    static public function sum(values:Array<Int>):Int {
        return values.fold((item, result) -> result + item, 0);
    }
}

#if thx_core
class DecimalTools {
    static public function sum(values:Array<Decimal>):Decimal {
        return values.fold((item, result:Decimal) -> result + item, Decimal.zero);
    }
}
#end