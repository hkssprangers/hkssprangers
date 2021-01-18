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

typedef IndexViewProps = react.router.Route.RouteRenderProps & {
    final tgBotName:String;
}

typedef IndexViewState = {

}

@:wrap(react.router.ReactRouter.withRouter)
class IndexView extends ReactComponentOf<IndexViewProps, IndexViewState> {
    override function render() {
        return jsx('
            <EightyNineForm />
        ');
    }
}