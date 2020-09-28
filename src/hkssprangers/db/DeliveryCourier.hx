package hkssprangers.db;

typedef DeliveryCourier = {
    var deliveryId:Id<Delivery>;
    var courierId:Id<Courier>;
    var deliveryFee:Float;
    var deliverySubsidy:Float;
}