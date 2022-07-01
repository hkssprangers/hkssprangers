package hkssprangers.browser.forms;

import hkssprangers.info.TimeSlotTools;
import hkssprangers.JsonString;
import hkssprangers.browser.forms.OrderFormData;
import hkssprangers.info.Weekday;
import hkssprangers.info.TimeSlot;
import js.npm.material_ui.Pickers;
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
    static final DatePicker = Styles.styled(js.npm.material_ui.Pickers.DatePicker)({});

    static function processDateChange(date:moment.Moment):JsonString<TimeSlot> {
        if (date == null)
            return cast "";

        final date:LocalDateString = (cast date.toDate():Date);

        return {
            start: date.getDatePart(),
            end: date.getDatePart(),
        };
    };

    static function processTimeChange(value:JsonString<TimeSlot>):JsonString<TimeSlot> {
        return value;
    }

    override function render():ReactFragment {
        final now = props.formContext.currentTime;
        final today = now.getDatePart();
        final timeSlots = TimeSlotTools.getTimeSlots(props.value.parse().start);
        final menuItems = timeSlots.map(timeSlot -> {
            final timeSlotStr = TimeSlotTools.printTime(timeSlot);
            final disabledMessage = switch (timeSlot.availability) {
                case Available:
                    null;
                case Unavailable(reason):
                    jsx('
                        <span className="ml-2 text-sm text-red-500">⚠ ${reason}</span>
                    ');
            }
            jsx('
                <MenuItem key=${timeSlotStr} value=${haxe.Json.stringify(timeSlot)} disabled=${timeSlot.availability.match(Unavailable(_))}>
                    ${timeSlotStr} ${disabledMessage}
                </MenuItem>
            ');
        });

        return jsx('
            <div id=${props.id}>
                <div className="mb-5">
                    ${switch (props.label) {
                        case null: props.schema.title;
                        case v: v;
                    }}
                </div>
                <div className="mb-5">
                    <DatePicker
                        className="w-full"
                        label="交收日期"
                        value=${props.value == null ? "" : props.value.parse().start.getDatePart()}
                        minDate=${today}
                        maxDate=${(Date.fromTime(now.toDate().getTime() + DateTools.days(14)):LocalDateString).getDatePart()}
                        format="M 月 D 日"
                        required=${props.required}
                        disabled=${props.disabled || props.readonly}
                        autoOk=${true}
                        disablePast=${true}
                        onChange=${date -> props.onChange(processDateChange(date)))}
                    />
                </div>
                <div>
                    <TextField
                        className="w-full"
                        label="交收時段"
                        select
                        required=${props.required}
                        disabled=${props.disabled || props.readonly}
                        error=${props.rawErrors != null && props.rawErrors.length > 0}
                        autoFocus=${props.autofocus}
                        value=${props.value == null ? "" : props.value}
                        onChange=${(e:Event) -> props.onChange(processTimeChange(untyped e.target.value))}
                        InputLabelProps=${{
                            shrink: true,
                        }}
                    >
                        ${menuItems}
                    </TextField>
                </div>
            </div>
        ');
    }
}