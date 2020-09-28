package hkssprangers.info;

typedef Delivery = {
    courier: {
        tg: Tg
    },
    orders:Array<Order>,
    customer: {
        tg: Tg,
        tel: String,
    },
    paymentMethods: Array<PaymentMethod>,
    pickupLocation: String,
    pickupTimeSlot: TimeSlot,
    pickupMethod: PickupMethod,
    deliveryFee: Float,
    customerNote: String,
}