package hkssprangers.browser.forms;

import hkssprangers.LocalDateString;
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
using StringTools;

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

    static function DefaultArrayItem(props, order:{?shop:Shop}, currentTime:LocalDateString, pickupTimeSlot:TimeSlot, removable:Bool) {
        final removeBtn = jsx('
            <RemoveButton
                size="small"
                disabled=${props.disabled || props.readonly}
                onClick=${props.onDropIndexClick(props.index)}
            >
                <i className="fas fa-trash text-sm"></i>
            </RemoveButton>
        ');
        final selectedShop = if (order != null && order.shop != null) {
            final shop:Shop = order.shop;
            final info = shop.info();
            final availability:Availability = if (currentTime == null || pickupTimeSlot == null) {
                Available;
            } else {
                shop.checkAvailability(currentTime.toDate(), pickupTimeSlot);
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
        final pickupTimeSlot = switch (props.formContext.pickupTimeSlot) {
            case null: null;
            case str: str.parse(); 
        };
        final pickupTimeSlotSelected = (
            pickupTimeSlot != null
            &&
            !(
                (pickupTimeSlot.start:String).endsWith(" 00:00:00")
                &&
                (pickupTimeSlot.start == pickupTimeSlot.end)
            )
        );
        final items = if (props.items != null) {
            [
                for (i => p in props.items)
                DefaultArrayItem(p, props.formData[i], props.formContext.currentTime, pickupTimeSlot, props.items.length > 1 || props.formData[i].shop != null)
            ];
        } else {
            null;
        }
        final cluster = if (props.formData != null && props.formData.length > 0 && props.formData[0].shop != null) {
            ShopCluster.classify(props.formData[0].shop);
        } else {
            null;
        }
        final clusterOptions = if (cluster != null) {
            Shop.all.filter(s -> ShopCluster.classify(s) == cluster);
        } else {
            Shop.all;
        }
        final addButton = switch (props.formData) {
            case null | []:
                final disabled = !pickupTimeSlotSelected;
                final warnMsg = pickupTimeSlotSelected ? null : jsx('
                    <div className="my-2 text-red-500">⚠ 請先選擇交收日期和時間</div>
                ');
                jsx('
                    <div className="my-5">
                        <Button
                            variant=${Outlined}
                            className="array-item-add"
                            color=${Primary}
                            onClick=${props.onAddClick}
                            disabled=${props.disabled || props.readonly || disabled}
                        >
                            <i className="fas fa-store mr-1"></i>
                            揀店舖
                        </Button>
                        ${warnMsg}
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
                            <i className="fas fa-store mr-1"></i>
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