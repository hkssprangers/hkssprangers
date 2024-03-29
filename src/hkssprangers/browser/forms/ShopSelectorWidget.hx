package hkssprangers.browser.forms;

import hkssprangers.LocalDateString;
import hkssprangers.browser.forms.OrderFormData;
import hkssprangers.info.ShopCluster;
import hkssprangers.info.Weekday;
import hkssprangers.info.TimeSlot;
import hkssprangers.info.Shop;
import js.html.Event;
import mui.core.*;
import mui.core.styles.Styles;
import js.npm.rjsf.material_ui.*;
using Reflect;
using Lambda;
using hkssprangers.ObjectTools;
using hxLINQ.LINQ;

typedef ShopSelectorWidgetProps = {
    final schema:Dynamic;
    final id:String;
    final formContext:OrderFormData;
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
    static final TextField = Styles.styled(mui.core.TextField)({
        marginRight: 50,
    });

    static function processValue(schema:Dynamic, value:Dynamic) {
        return value;
    };
    override function render():ReactFragment {
        final pickupTimeSlot = switch (props.formContext.pickupTimeSlot) {
            case null: null;
            case str: str.parse();
        };
        final currentTime = props.formContext.currentTime.toDate();
        if (props.value != null) {
            final shop:Shop = props.value;
            final availability:Availability = if (currentTime == null || pickupTimeSlot == null) {
                Available;
            } else {
                shop.checkAvailability(currentTime, pickupTimeSlot);
            }
            final disabledMessage = switch (availability) {
                case Available:
                    null;
                case Unavailable(reason):
                    jsx('
                        <span className="ml-2 text-sm text-red-500">⚠ ${reason}</span>
                    ');
            };
            // return jsx('<div>🔸 ${info.name}${disabledMessage}</div>');
            return null;
        }
        final shops:Array<Shop> = props.options.enumOptions
            .map((option:{ value:Shop, label:String }, i:Int) -> option.value)
            .filter((shop:Shop) -> shop.info().isInService);

        switch (shops) {
            case []:
                return null;
            case shops:
                final items = ShopCluster.all.linq()
                    .selectMany((c,i) -> {
                        final clusterShops = shops.filter(s -> ShopCluster.classify(s).has(c));
                        if (clusterShops.length <= 0) {
                            [];
                        } else {
                            final items = clusterShops.map(shop -> {
                                final info = shop.info();
                                final availability:Availability = if (currentTime == null || pickupTimeSlot == null) {
                                    Available;
                                } else {
                                    shop.checkAvailability(currentTime, pickupTimeSlot);
                                }
                                final disabledMessage = switch (availability) {
                                    case Available:
                                        null;
                                    case Unavailable(reason):
                                        jsx('
                                            <span className="ml-2 text-sm text-red-500">⚠ ${reason}</span>
                                        ');
                                };
                                jsx('
                                    <MenuItem key=${c + "-" + shop} value=${shop} disabled=${availability.match(Unavailable(_))}>
                                        ${info.name}${disabledMessage}
                                    </MenuItem>
                                ');
                            });
                            [
                                jsx('
                                    <ListSubheader key=${c}>
                                        <div className="bg-white">
                                            <span className=${badge() + " bg-yellow-200 px-2 leading-normal"}>
                                                <i className="fas fa-map-marker mr-1"></i>${c.info().name}
                                            </span>
                                        </div>
                                    </ListSubheader>
                                ')
                            ].concat(items);
                        }
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
}