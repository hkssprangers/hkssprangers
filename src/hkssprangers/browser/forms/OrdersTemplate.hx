package hkssprangers.browser.forms;

import hkssprangers.info.Shop;
import mui.core.*;
import js.npm.rjsf.material_ui.*;
using Reflect;

typedef OrdersTemplateProps = Dynamic;

class OrdersTemplate extends ReactComponentOf<OrdersTemplateProps, Dynamic> {
    static function DefaultArrayItem(props, order:{?shop:Shop}, removable:Bool) {
        var removeBtn = if (removable) {
            jsx('
                <Button
                    className="array-item-add"
                    color=${Secondary}
                    disabled=${props.disabled || props.readonly}
                    onClick=${props.onDropIndexClick(props.index)}
                >
                    ${order != null && order.shop != null ? "移除" + order.shop.info().name : "移除"}
                </Button>
            ');
        } else {
            null;
        }
        return jsx('
            <div key=${props.key} className="my-2">
                ${props.children}
                <div>
                    ${removeBtn}
                </div>
            </div>
        ');
    }

    override function render():ReactFragment {
        var items = if (props.items != null) {
            [
                for (i => p in (props.items:Array<Dynamic>))
                DefaultArrayItem(p, props.formData[i], props.items.length > 1)
            ];
        } else {
            null;
        }
        return jsx('
            <div key=${'array-item-list-${props.idSchema.field("$id")}'}>
                <h2>揀食咩</h2>
                <div>
                    ${items}
                </div>
                <div>
                    <Button
                        className="array-item-add"
                        color=${Primary}
                        onClick=${props.onAddClick}
                        disabled=${props.disabled || props.readonly}
                    >
                        叫多間店舖
                    </Button>
                </div>
            </div>
        ');
    }
}