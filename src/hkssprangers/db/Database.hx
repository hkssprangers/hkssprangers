package hkssprangers.db;

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
