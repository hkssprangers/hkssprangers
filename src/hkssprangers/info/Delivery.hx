package hkssprangers.info;

typedef Delivery = {
    courier: {
        tg: Tg
    },
    orders:Array<Order<Dynamic>>,
    customer: {
        tg: Tg,
        tel: String,
    },
    paymentMethods: Array<PaymentMethod>,
    pickupLocation: String,
    pickupTimeSlot: TimeSlot,
    pickupMethod: PickupMethod,
    deliveryFeeCents: Cents,
    customerNote: String,
}