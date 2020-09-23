package hkssprangers;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using Lambda;
#end

class ObjectTools {
    macro static public function merge(objs:Array<Expr>):Expr {
        var anonTypes = [
            for (e in objs)
            switch (Context.follow(Context.typeof(e))) {
                case TAnonymous(ref):
                    ref.get();
                case _:
                    Context.error("Should be an anonymous object.", e.pos);
            }
        ];
        var inputVars:Array<ObjectField> = [
            for (i => v in objs)
            {
                field: "v" + Std.string(i),
                expr: v,
            }
        ];
        var mappings = new Map<String, ObjectField>();
        for (i => e in objs)
        {
            var iStr = "v" + Std.string(i);
            for (field in anonTypes[i].fields.map(f -> f.name))
                mappings[field] = {
                    field: field,
                    expr: macro objs.$iStr.$field,
                }
        }
        var inputExpr = {
            expr: EObjectDecl(inputVars),
            pos: Context.currentPos(),
        };
        var outputExpr = {
            expr: EObjectDecl(mappings.array()),
            pos: Context.currentPos(),
        };
        return macro {
            var objs = ${inputExpr};
            ${outputExpr};
        };
    }
}