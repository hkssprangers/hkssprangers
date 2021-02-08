package hkssprangers.browser.forms;

import js.html.Event;
import mui.core.*;
import mui.core.input.InputType;
using Reflect;
using Lambda;
using hkssprangers.ObjectTools;

typedef TextWidgetProps = {
    final id:Dynamic;
    final required:Bool;
    final readonly:Bool;
    final disabled:Bool;
    final type:Dynamic;
    final label:String;
    final value:Dynamic;
    final onChange:Dynamic;
    final onBlur:Dynamic;
    final onFocus:Dynamic;
    final autofocus:Bool;
    final options:{
        ?multiline:Bool,
    };
    final schema:Dynamic;
    final uiSchema:Dynamic;
    @:optional final rawErrors:Array<Dynamic>;
    final formContext:Dynamic;
}

class TextWidget extends ReactComponentOf<TextWidgetProps, Dynamic> {
    final inputLabelProps = {
        shrink: true,
    }

    override function render():ReactFragment {
        var inputType:InputType = switch [props.type, props.schema.type].find(t -> t != null) {
            case "string": Text;
            case type: cast type;
        };
        return jsx('
            <TextField
                id=${props.id}
                label=${switch props.label {
                    case null:
                        props.schema.title;
                    case v:
                        v;
                }}
                autoFocus=${props.autofocus}
                required=${props.required}
                disabled=${props.disabled || props.readonly}
                type=${inputType}
                multiline=${props.options.multiline}
                value=${props.value}
                error=${props.rawErrors != null && props.rawErrors.length > 0}
                onChange=${(e:Event) -> props.onChange(untyped e.target.value)}
                onBlur=${(e:Event) -> props.onBlur(props.id, untyped e.target.value)}
                onFocus=${(e:Event) -> props.onFocus(props.id, untyped e.target.value)}
                InputLabelProps=${inputLabelProps}
            />
        ');
    }
}