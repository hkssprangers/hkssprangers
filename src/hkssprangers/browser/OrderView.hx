package hkssprangers.browser;

import hkssprangers.browser.forms.*;
import js.Browser.*;
import js.lib.Promise;
using hkssprangers.info.OrderTools;
using hkssprangers.info.TgTools;
using hkssprangers.info.TimeSlotType;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.MathTools;
using Lambda;
using StringTools;
using DateTools;

typedef OrderViewProps = react.router.Route.RouteRenderProps & {
    final tgBotName:String;
}

typedef OrderViewState = {

}

@:wrap(react.router.ReactRouter.withRouter)
class OrderView extends ReactComponentOf<OrderViewProps, OrderViewState> {
    override function render() {
        return jsx('
            <OrderForm
             />
        ');
    }
}