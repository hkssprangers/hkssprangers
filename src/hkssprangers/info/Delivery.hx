package hkssprangers.info;

typedef DeliveryMeta = {
    creationTime:LocalDateString,
    deliveryCode:String,
    courier: {
        tg: Tg
    },
    customer: {
        tg: Tg,
        tel: String,
    },
    customerPreferredContactMethod:ContactMethod,
    paymentMethods: Array<PaymentMethod>,
    pickupLocation: String,
    pickupTimeSlot: TimeSlot,
    pickupMethod: PickupMethod,
    deliveryFee: Float,
    customerNote: String,
}

typedef Delivery = DeliveryMeta & {
    orders:Array<Order>,
}