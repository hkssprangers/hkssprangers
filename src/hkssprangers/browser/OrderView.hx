package hkssprangers.browser;

import hkssprangers.browser.forms.*;
import js.Browser.*;
import js.lib.Promise;
import mui.core.*;
import js.npm.material_ui.Pickers;
using hkssprangers.info.LoggedinUser;
using hkssprangers.info.OrderTools;
using hkssprangers.info.TgTools;
using hkssprangers.info.TimeSlot;
using hkssprangers.info.TimeSlotType;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.MathTools;
using Lambda;
using StringTools;
using DateTools;

typedef OrderViewProps = react.router.Route.RouteRenderProps & {
    final tgBotName:String;
    final user:LoggedinUser;
    final prefill:OrderFormPrefill;
    final currentTime:LocalDateString;
}

typedef OrderViewState = {

}

@:wrap(react.router.ReactRouter.withRouter)
class OrderView extends ReactComponentOf<OrderViewProps, OrderViewState> {
    override function render() {
        return jsx('
            <MuiPickersUtilsProvider utils=${MomentUtils}>
                <OrderForm
                    user=${props.user}
                    prefill=${props.prefill}
                    currentTime=${props.currentTime}
                />
            </MuiPickersUtilsProvider>
        ');
    }
}