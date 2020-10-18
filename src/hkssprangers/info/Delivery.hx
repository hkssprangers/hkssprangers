package hkssprangers.info;

typedef DeliveryMeta = {
    creationTime:LocalDateString,
    deliveryCode:String,
    couriers: Array<Courier & {
        deliveryFee:Float,
        deliverySubsidy:Float,
    }>,
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
    ?deliveryId:Int,
    orders:Array<Order>,
}