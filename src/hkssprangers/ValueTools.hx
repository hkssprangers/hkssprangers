package hkssprangers;

class ValueTools {
    static public function emptyStrIfNull(v:Dynamic):Dynamic {
        return if (v != null)
            v;
        else
            "";
    }

    static public function ifNull<T>(v:Null<T>, defaultValue:T):T {
        return if (v != null)
            v;
        else
            defaultValue;
    }
}