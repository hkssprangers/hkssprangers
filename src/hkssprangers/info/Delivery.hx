package hkssprangers.info;

import hkssprangers.info.ContactMethod;

typedef Customer = {
    tg: Tg,
    tel: String,
    whatsApp: String,
    signal: String,
}

typedef DeliveryMeta = {
    creationTime:LocalDateString,
    deliveryCode:String,
    couriers: Array<Courier & {
        deliveryFee:Float,
        deliverySubsidy:Float,
    }>,
    customer: Customer,
    customerPreferredContactMethod:ContactMethod,
    customerBackupContactMethod:ContactMethod,
    paymentMethods: Array<PaymentMethod>,
    pickupLocation: String,
    pickupTimeSlot: TimeSlot,
    pickupMethod: PickupMethod,
    deliveryFee: Float,
    customerNote: String,
}

typedef Delivery = DeliveryMeta & {
    ?deliveryId:Int64String,
    orders:Array<Order>,
}