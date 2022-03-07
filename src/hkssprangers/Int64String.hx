package hkssprangers;

import haxe.Int64;

abstract Int64String(String) to String {
    @:from static function fromInt64(v:Int64):Int64String {
        return cast Int64.toStr(v);
    }

    #if tink_sql
    @:from static function fromBigInt(v:tink.sql.Types.BigInt):Int64String {
        return cast Int64.toStr(v);
    }
    #end

    public function parse():Int64 {
        return Int64.parseString(this);
    }
}
