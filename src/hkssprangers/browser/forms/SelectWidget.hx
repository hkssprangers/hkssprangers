package hkssprangers.browser.forms;

import js.html.Event;
import mui.core.*;
import mui.core.input.InputType;
using Reflect;
using Lambda;
using hkssprangers.ObjectTools;

typedef SelectWidgetProps = {
    final schema:Dynamic;
    final id:String;
    final options:{
        enumOptions:Array<{
            value:Dynamic,
            label:String,
        }>,
        enumDisabled:Bool,
    };
    final label:String;
    final required:Bool;
    final disabled:Bool;
    final readonly:Bool;
    final value:Dynamic;
    final multiple:Bool;
    final autofocus:Bool;
    final onChange:Dynamic;
    final onBlur:Dynamic;
    final onFocus:Dynamic;
    final rawErrors:Dynamic;
}

class SelectWidget extends ReactComponentOf<SelectWidgetProps, Dynamic> {
    final noneKey = "SelectWidgetItemNone";
    final inputLabelProps = {
        shrink: true,
    }

    function processValue(v:Dynamic) {
        return switch (props.schema.type:Null<String>) {
            case null: v;
            case "string" if (v == ""): js.Lib.undefined;
            case _: v;
        }
    }

    override function render():ReactFragment {
        var items = props.options.enumOptions.map(opt -> {
            jsx('
                <MenuItem key=${opt.value} value=${opt.value}>
                    ${opt.label}
                </MenuItem>
            ');
        });

        if (!props.required) {
            items.unshift(jsx('
                <MenuItem key=${noneKey} value=${""}>
                    無
                </MenuItem>
            '));
        }

        return jsx('
            <TextField
                id=${props.id}
                label=${switch props.label {
                    case null:
                        props.schema.title;
                    case v:
                        v;
                }}
                select
                autoFocus=${props.autofocus}
                required=${props.required}
                disabled=${props.disabled || props.readonly}
                value=${props.value != null ? props.value : ""}
                error=${props.rawErrors != null && props.rawErrors.length > 0}
                onChange=${(e:Event) -> props.onChange(processValue(untyped e.target.value))}
                onBlur=${(e:Event) -> props.onBlur(props.id, processValue(untyped e.target.value))}
                onFocus=${(e:Event) -> props.onFocus(props.id, processValue(untyped e.target.value))}
                InputLabelProps=${inputLabelProps}
            >
                ${items}
            </TextField>
        ');
    }
}