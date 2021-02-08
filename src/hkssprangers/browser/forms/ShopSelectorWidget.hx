package hkssprangers.browser.forms;

import hkssprangers.info.Weekday;
import hkssprangers.info.TimeSlot;
import hkssprangers.info.Shop;
import js.html.Event;
import mui.core.*;
import js.npm.rjsf.material_ui.*;
using Reflect;
using Lambda;
using hkssprangers.ObjectTools;

typedef ShopSelectorWidgetProps = {
    final schema:Dynamic;
    final id:String;
    final options:{
        enumOptions:Dynamic,
        enumDisabled:Dynamic,
        pickupTimeSlot:Null<TimeSlot>,
    };
    final label:String;
    final required:Bool;
    final disabled:Bool;
    final readonly:Bool;
    final value:Shop;
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
        var pickupTimeSlot = props.options.pickupTimeSlot;
        var items = props.options.enumOptions.map((option:{ value:Shop, label:String }, i:Int) -> {
            var info = option.value.info();
            var availability:Availability = if (pickupTimeSlot == null) {
                Available;
            } else {
                option.value.checkAvailability(pickupTimeSlot);
            }
            var disabledMessage = switch (availability) {
                case Available:
                    null;
                case Unavailable(reason):
                    jsx('
                        <span className="ml-2 text-sm text-red-500">${reason}</span>
                    ');
            };
            return jsx('
                <MenuItem key=${option.value} value=${option.value} disabled=${availability.match(Unavailable(_))}>
                    ${option.label}${disabledMessage}
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
                value=${props.value == null ? "" : (props.value:String)}
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