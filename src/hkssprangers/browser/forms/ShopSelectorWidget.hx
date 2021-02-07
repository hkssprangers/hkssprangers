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
            var disabledReason:Null<String> = (() -> {
                if (pickupTimeSlot == null)
                    return null;

                if (!info.openDays.has(Weekday.fromDay(pickupTimeSlot.start.toDate().getDay())))
                    return '休息';

                if (pickupTimeSlot.start.getTimePart() < info.earliestPickupTime)
                    return '最早 ${info.earliestPickupTime.substr(0, 5)} 時段交收';

                if (pickupTimeSlot.start.getTimePart() > info.latestPickupTime)
                    return '最遲 ${info.latestPickupTime.substr(0, 5)} 時段交收';

                return null;
            })();
            var disabledMessage = if (disabledReason != null) jsx('
                <span className="ml-2 text-sm text-red-500">${disabledReason}</span>
            ') else {
                null;
            };
            return jsx('
                <MenuItem key=${option.value} value=${option.value} disabled=${disabledReason != null}>
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