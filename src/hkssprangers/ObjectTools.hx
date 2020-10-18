package hkssprangers;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using Lambda;
#end

class ObjectTools {
    macro static public function copy(obj:Expr):Expr {
        var objType = switch (Context.follow(Context.typeof(obj))) {
            case TAnonymous(ref):
                ref.get();
            case _:
                Context.error("Should be an anonymous object.", obj.pos);
        }
        
        var mappings = new Map<String, ObjectField>();
        
        for (f in objType.fields) {
            var field = f.name;
            mappings[field] = {
                field: field,
                expr: macro _input.$field,
            }
        }

        var outputExpr = {
            expr: EObjectDecl(mappings.array()),
            pos: Context.currentPos(),
        };
        return macro {
            var _input = ${obj};
            ${outputExpr};
        };
    }

    macro static public function with(obj:Expr, changes:Expr):Expr {
        var objType = switch (Context.follow(Context.typeof(obj))) {
            case TAnonymous(ref):
                ref.get();
            case _:
                Context.error("Should be an anonymous object.", obj.pos);
        }
        var changesType = switch (Context.follow(Context.typeof(changes))) {
            case TAnonymous(ref):
                ref.get();
            case _:
                Context.error("Should be an anonymous object.", changes.pos);
        }
        
        var mappings = new Map<String, ObjectField>();
        
        for (f in objType.fields) {
            var field = f.name;
            mappings[field] = {
                field: field,
                expr: macro _input.obj.$field,
            }
        }
        
        for (f in changesType.fields) {
            var field = f.name;
            if (!objType.fields.exists(f -> f.name == field)) {
                Context.error('$field doesn\'t exist in the original structure', f.pos);
                continue;
            }
            mappings[field] = {
                field: field,
                expr: macro _input.changes.$field,
            }
        }

        var inputExpr = {
            expr: EObjectDecl([
                {
                    field: "obj",
                    expr: obj,
                },
                {
                    field: "changes",
                    expr: changes,
                },
            ]),
            pos: Context.currentPos(),
        };
        var outputExpr = {
            expr: EObjectDecl(mappings.array()),
            pos: Context.currentPos(),
        };
        return macro {
            var _input = ${inputExpr};
            ${outputExpr};
        };
    }

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