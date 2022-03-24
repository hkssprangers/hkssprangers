package hkssprangers;

import haxe.macro.Expr;
import haxe.macro.*;

class NodeModules {
    #if macro
    static public var lock(get, null):Dynamic;
    static function get_lock() return lock != null ? lock : lock = Json.parse(sys.io.File.getContent("package-lock.json"));
    #end

    macro static public function lockedVersion(moduleName:String):ExprOf<String> {
        final moduleInfo = Reflect.field(lock.dependencies, moduleName);
        if (moduleInfo == null) {
            Context.error('Cannot find ${moduleName} in package-lock.json', Context.currentPos());
        }
        final version:String = moduleInfo.version;
        return macro $v{version};
    }
}
