package hkssprangers;

class ValueTools {
    static public function emptyStrIfNull(v:Dynamic):Dynamic {
        return if (v != null)
            v;
        else
            "";
    }
}