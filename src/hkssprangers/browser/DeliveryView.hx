package hkssprangers.browser;

import mui.core.*;
import hkssprangers.info.*;
using Lambda;
using hkssprangers.MathTools;
using hkssprangers.info.TimeSlotTools;

typedef DeliveryViewProps = {
    delivery:Delivery,
}

typedef DeliveryViewState = {

}

class DeliveryView extends ReactComponentOf<DeliveryViewProps, DeliveryViewState> {
    function renderOrder(key:Dynamic, o:Order) {
        var customerNote = if (o.customerNote != null && o.customerNote != "") {
            jsx('<Typography>⚠️ ${o.customerNote}</Typography>');
        } else {
            null;
        }
        return jsx('
            <Grid key=${key} item>
                <Typography>🔸 ${o.shop.info().name}</Typography>
                <Typography className="pre-wrap">${o.orderDetails}</Typography>
                ${customerNote}
                <Typography>${o.wantTableware ? "要餐具" : "唔要餐具"}</Typography>
                <Typography paragraph>食物價錢: $$${o.orderPrice}</Typography>
            </Grid>
        ');
    }

    override function render() {
        var d = props.delivery;
        var foodTotal = d.orders.fold((order:Order, result:Float) -> result + order.orderPrice.nanIfNull(), 0.0);

        var tg = if (d.customer.tg != null && d.customer.tg.username != null) {
            var tgUrl = "https://t.me/" + d.customer.tg.username;
            jsx('<Typography><a href=${tgUrl} target="_blank">${tgUrl}</a> ${d.customerPreferredContactMethod == Telegram ? " 👈" : ""}</Typography>');
        } else {
            null;
        }

        var wa = if (d.customer.tel != null) {
            var waUrl = "https://wa.me/852" + d.customer.tel;
            jsx('<Typography><a href=${waUrl} target="_blank">${waUrl}</a> ${d.customerPreferredContactMethod == WhatsApp ? " 👈" : ""}</Typography>');
        } else {
            null;
        }

        var paymentMethods = jsx('<Typography>${d.paymentMethods.map(p -> p.info().name).join(", ")}</Typography>');
        var pickupLocation = jsx('<Typography>${d.pickupLocation + " (" + d.pickupMethod.info().name + ") ($" + d.deliveryFee.nanIfNull() + ")"}</Typography>');

        var customerNote = if (d.customerNote != null && d.customerNote != "") {
            jsx('<Typography>⚠️ ${d.customerNote}</Typography>');
        } else {
            null;
        }

        var subheader = if (d.couriers == null) {
            null;
        } else {
            var couriers = d.couriers.map(c -> jsx('
                <Grid item key=${c.tg.username}><a href=${"https://t.me/" + c.tg.username} target="_blank">@${c.tg.username}</a></Grid>
            '));
            jsx('
                <Grid container wrap=${NoWrap} spacing=${Spacing_1}>${couriers}</Grid>
            ');
        }

        return jsx('
            <Card>
                <CardHeader
                    title=${"📃 " + d.deliveryCode}
                    subheader=${subheader}
                />
                <CardContent>
                    <Grid container direction=${Column}>
                        ${d.orders.mapi(renderOrder)}
                    </Grid>

                    <Typography paragraph>總食物價錢+運費: $$${foodTotal + d.deliveryFee.nanIfNull()}</Typography>

                    <Typography>${d.pickupTimeSlot.print()}</Typography>
                    ${tg}
                    ${wa}
                    ${paymentMethods}
                    ${pickupLocation}
                    ${customerNote}
                </CardContent>
            </Card>
        ');
    }
}