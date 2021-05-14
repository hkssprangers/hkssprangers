package hkssprangers.browser.forms;

import hkssprangers.browser.forms.OrderFormData;
import hkssprangers.info.TimeSlot;
import hkssprangers.info.ShopCluster;
import hkssprangers.info.Shop;
import hkssprangers.info.FormOrderData;
import mui.core.*;
import mui.core.styles.Styles;
import js.npm.rjsf.material_ui.*;
using Reflect;
using Lambda;

typedef OrdersTemplateProps = {
    final idSchema:Dynamic;
    final items:Array<Dynamic>;
    final formContext:OrderFormData;
    final formData:Array<FormOrderData>;
    final disabled:Bool;
    final readonly:Bool;
    final onAddClick:Dynamic;
};

class OrdersTemplate extends ReactComponentOf<OrdersTemplateProps, Dynamic> {
    static final RemoveButton = Styles.styled(mui.core.Fab)({
        color: "#EF4444",
        background: "#F3F4F6",
    });

    static function DefaultArrayItem(props, order:{?shop:Shop}, pickupTimeSlot:TimeSlot, removable:Bool) {
        var removeBtn = jsx('
            <RemoveButton
                size="small"
                disabled=${props.disabled || props.readonly}
                onClick=${props.onDropIndexClick(props.index)}
            >
                <i className="fas fa-trash text-sm"></i>
            </RemoveButton>
        ');
        var selectedShop = if (order != null && order.shop != null) {
            var shop:Shop = order.shop;
            var info = shop.info();
            var availability:Availability = if (pickupTimeSlot == null) {
                Available;
            } else {
                shop.checkAvailability(pickupTimeSlot);
            }
            var disabledMessage = switch (availability) {
                case Available:
                    null;
                case Unavailable(reason):
                    jsx('
                        <span className="ml-2 text-sm text-red-500">⚠ ${reason}</span>
                    ');
            };
            jsx('
                <div className="flex items-center my-5">🔸 ${info.name}${disabledMessage}<div className="ml-3">${removeBtn}</div></div>
            ');
        } else if (order != null && order.shop == null) {
            jsx('
                <div className="absolute top-0 right-0 z-10">
                    ${removeBtn}
                </div>
            ');
        } else {
            null;
        }
        return jsx('
            <div key=${props.key} className="relative mt-5">
                ${selectedShop}
                ${props.children}
            </div>
        ');
    }

    override function render():ReactFragment {
        var pickupTimeSlot = switch (props.formContext.pickupTimeSlot) {
            case null: null;
            case str: str.parse(); 
        };
        var items = if (props.items != null) {
            [
                for (i => p in props.items)
                DefaultArrayItem(p, props.formData[i], pickupTimeSlot, props.items.length > 1 || props.formData[i].shop != null)
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
                    <div className="my-5">
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
                    <div className="my-5">
                        <Button
                            variant=${Outlined}
                            className="array-item-add"
                            color=${Primary}
                            onClick=${props.onAddClick}
                            disabled=${props.disabled || props.readonly}
                        >
                            <i class="fas fa-store mr-1"></i>
                            揀多間同範圍店舖
                        </Button>
                    </div>
                ');
        }
        return jsx('
            <div key=${'array-item-list-${props.idSchema.field("$id")}'} className="mb-5">
                <h2>揀食咩</h2>
                <div>
                    ${items}
                </div>
                ${addButton}
            </div>
        ');
    }
}