package hkssprangers.browser.forms;

import hkssprangers.info.TimeSlotTools;
import hkssprangers.JsonString;
import hkssprangers.browser.forms.OrderFormData;
import hkssprangers.info.Weekday;
import hkssprangers.info.TimeSlot;
import js.html.Event;
import mui.core.*;
import mui.core.styles.Styles;
import js.npm.rjsf.material_ui.*;
using Reflect;
using Lambda;
using hkssprangers.ObjectTools;
using hxLINQ.LINQ;

typedef TimeSlotSelectorWidgetProps = {
    final schema:Dynamic;
    final id:String;
    final formContext:OrderFormData;
    final options:{
        enumOptions:Array<{schema:Dynamic, label:String, value:JsonString<TimeSlot>}>,
        enumDisabled:Dynamic,
        pickupTimeSlot:Null<TimeSlot>,
    };
    final label:String;
    final required:Bool;
    final disabled:Bool;
    final readonly:Bool;
    final value:JsonString<TimeSlot>;
    final multiple:Bool;
    final autofocus:Bool;
    final onChange:Dynamic;
    final onBlur:Dynamic;
    final onFocus:Dynamic;
    @:optional final rawErrors:Array<Dynamic>;
}

class TimeSlotSelectorWidget extends ReactComponentOf<TimeSlotSelectorWidgetProps, Dynamic> {
    static final TextField = Styles.styled(mui.core.TextField)({});

    static function processValue(schema:Dynamic, value:Dynamic) {
        return value;
    };
    override function render():ReactFragment {
        var now = Date.now();
        var today = (now:LocalDateString).getDatePart();
        var tmr = (Date.fromTime(now.getTime() + DateTools.days(1)):LocalDateString).getDatePart();
        var timeSlots:Array<TimeSlot> = props.options.enumOptions.map(o -> o.value.parse());
        var items = timeSlots.linq()
            .groupBy(ts -> ts.start.getDatePart())
            .selectMany((group, i) -> {
                var items = group.linq().select((timeSlot, _) -> {
                    var timeSlotStr = TimeSlotTools.print(timeSlot);
                    jsx('
                        <MenuItem key=${timeSlotStr} value=${haxe.Json.stringify(timeSlot)}>
                            ${timeSlotStr}
                        </MenuItem>
                    ');
                }).toArray();
                var header = if (group.key == today) {
                    "今日";
                } else if (group.key == tmr) {
                    "聽日";
                } else {
                    group.key;
                };
                [
                    jsx('
                        <ListSubheader>
                            <div className="bg-white">
                                <span className=${badge() + " bg-yellow-200 px-2 leading-normal"}>
                                    ${header}
                                </span>
                            </div>
                        </ListSubheader>
                    ')
                ].concat(items);
            })
            .toArray();
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