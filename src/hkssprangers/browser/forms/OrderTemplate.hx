package hkssprangers.browser.forms;

import mui.core.*;
import js.npm.rjsf.material_ui.*;
using Reflect;

typedef OrderTemplateProps = {
    final id:String;
    final classNames:String;
    final label:String;
    final help:String;
    final required:String;
    final description:String;
    final errors:String;
    final children:String;
};

class OrderTemplate extends ReactComponentOf<OrderTemplateProps, Dynamic> {
    override function render():ReactFragment {
        return jsx('
            <div
                id=${props.id}
            >
                <pre>${Std.string(props)}</pre>
                ${props.children}
            </div>
        ');
    }
}