package hkssprangers.db;

typedef Order = {
    @:autoIncrement @:primary var orderId:Id<Order>;
    var creationTime:Timestamp;
    var orderCode:Null<VarChar<50>>;
    var shopId:VarChar<50>;
    var orderDetails:VarChar<2048>;
    var orderPrice:Float;
    var platformServiceCharge:Float;
    var wantTableware:Bool;
    var customerNote:Null<VarChar<2048>>;
}