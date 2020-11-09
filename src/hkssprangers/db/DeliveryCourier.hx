package hkssprangers.db;

typedef DeliveryCourier = {
    final deliveryId:Id<Delivery>;
    final courierId:Id<Courier>;
    final deliveryFee:Float;
    final deliverySubsidy:Float;
    final deleted:Bool;
}