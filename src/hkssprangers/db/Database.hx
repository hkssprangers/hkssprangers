package hkssprangers.db;

import tink.sql.Types;

class Database extends tink.sql.Database {
    @:table("courier")
    var courier:Courier;

    @:table("delivery")
    var delivery:Delivery;

    @:table("deliveryCourier")
    var deliveryCourier:DeliveryCourier;

    @:table("deliveryOrder")
    var deliveryOrder:DeliveryOrder;

    @:table("order")
    var order:Order;
}

typedef Courier = {
    @:autoIncrement @:primary var courierId:Id<Courier>;
    @:unique var courierTgUsername:VarChar<128>;
    @:unique var courierTgId:Null<Int>;
    var paymeAvailable:Bool;
    var fpsAvailable:Bool;
}

typedef Delivery = {
    @:autoIncrement @:primary var deliveryId:Id<Delivery>;
    var creationTime:Timestamp;
    var pickupLocation:VarChar<1024>;
    var pickupTimeSlotStart:Timestamp;
    var pickupTimeSlotEnd:Timestamp;
    var pickupMethod:VarChar<64>;
    var paymeAvailable:Bool;
    var fpsAvailable:Bool;
    var customerTgUsername:Null<VarChar<128>>;
    var customerTgId:Null<Int>;
    var customerTel:Null<VarChar<64>>;
    var customerPreferredContactMethod:VarChar<64>;
    var customerNote:Null<VarChar<2048>>;
}

typedef DeliveryCourier = {
    var deliveryId:Id<Delivery>;
    var courierId:Id<Courier>;
    var deliveryFee:Float;
    var deliverySubsidy:Float;
}

typedef Order = {
    @:autoIncrement @:primary var orderId:Id<Order>;
    var creationTime:Timestamp;
    var orderCode:VarChar<50>;
    var shopId:VarChar<50>;
    var orderDetails:VarChar<2048>;
    var orderPrice:Float;
    var platformServiceCharge:Float;
    var wantTableware:Bool;
    var customerNote:Null<VarChar<2048>>;
}

typedef DeliveryOrder = {
    var deliveryId:Id<Delivery>;
    var orderId:Id<Order>;
}