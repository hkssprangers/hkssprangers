package hkssprangers.db;

typedef DeliveryCourier = {
    final deliveryId:BigInt;
    final courierId:BigInt;
    final deliveryFee:Float;
    final deliverySubsidy:Float;
    final deleted:Bool;
}