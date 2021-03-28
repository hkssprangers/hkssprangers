package hkssprangers.browser.forms;

import hkssprangers.info.ShopCluster;
import hkssprangers.info.Shop;
import hkssprangers.info.FormOrderData;
import mui.core.*;
import js.npm.rjsf.material_ui.*;
using Reflect;
using Lambda;

typedef OrdersTemplateProps = {
    final idSchema:Dynamic;
    final items:Array<Dynamic>;
    final formData:Array<FormOrderData>;
    final disabled:Bool;
    final readonly:Bool;
    final onAddClick:Dynamic;
};

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
                for (i => p in props.items)
                DefaultArrayItem(p, props.formData[i], props.items.length > 1 || props.formData[i].shop != null)
            ];
        } else {
            null;
        }
        var cluster = if (props.formData != null && props.formData.length > 0 && props.formData[0].shop != null) {
            ShopCluster.classify(props.formData[0].shop);
        } else {
            null;
        }
        var clusterOptions = if (cluster != null) {
            Shop.all.filter(s -> ShopCluster.classify(s) == cluster);
        } else {
            Shop.all;
        }
        var addButton = switch (props.formData) {
            case null | []:
                jsx('
                    <div>
                        <Button
                            className="array-item-add"
                            color=${Primary}
                            onClick=${props.onAddClick}
                            disabled=${props.disabled || props.readonly}
                        >
                            揀店舖
                        </Button>
                    </div>
                ');
            case orders if (orders.length >= clusterOptions.length || orders.exists(o -> o.shop == null)):
                null;
            case _:
                jsx('
                    <div>
                        <Button
                            className="array-item-add"
                            color=${Primary}
                            onClick=${props.onAddClick}
                            disabled=${props.disabled || props.readonly}
                        >
                            揀多間同範圍店舖
                        </Button>
                    </div>
                ');
        }
        return jsx('
            <div key=${'array-item-list-${props.idSchema.field("$id")}'}>
                <h2>揀食咩</h2>
                <div>
                    ${items}
                </div>
                ${addButton}
            </div>
        ');
    }
}