package hkssprangers.browser.forms;

import js.html.Event;
import mui.core.*;
import js.npm.rjsf.material_ui.*;
using Reflect;
using hkssprangers.ObjectTools;

typedef ShopSelectorWidgetProps = {
    final schema:Dynamic;
    final id:String;
    final options:Dynamic;
    final label:String;
    final required:Bool;
    final disabled:Bool;
    final readonly:Bool;
    final value:String;
    final multiple:Bool;
    final autofocus:Bool;
    final onChange:Dynamic;
    final onBlur:Dynamic;
    final onFocus:Dynamic;
    @:optional final rawErrors:Array<Dynamic>;
}

class ShopSelectorWidget extends ReactComponentOf<ShopSelectorWidgetProps, Dynamic> {
    static function processValue(schema:Dynamic, value:Dynamic) {
        return value;
    };
    override function render():ReactFragment {
        var items = props.options.enumOptions.map((option:{ value:String, label:String }, i:Int) -> {
            var disabled = props.options.enumDisabled && props.options.enumDisabled.indexOf(option.value) != -1;
            return jsx('
                <MenuItem key=${i} value=${option.value} disabled=${disabled}>
                    ${option.label}
                </MenuItem>
            ');
        });
        return jsx('
            <TextField
                id=${props.id}
                label=${switch (props.label) {
                    case null: props.schema.title;
                    case v: v;
                }}
                select
                value=${props.value == null ? "" : props.value}
                required=${props.required}
                disabled=${props.disabled || props.readonly}
                autoFocus=${props.autofocus}
                error=${props.rawErrors != null && props.rawErrors.length > 0}
                onChange=${(e:Event) -> props.onChange(processValue(props.schema, untyped e.target.value))}
                onBlur=${(e:Event) -> props.onBlur(props.id, processValue(props.schema, untyped e.target.value))}
                onFocus=${(e:Event) -> props.onFocus(props.id, processValue(props.schema, untyped e.target.value))}
                InputLabelProps=${{
                    shrink: true,
                }}
            >
                ${items}
            </TextField>
        ');
    }
}