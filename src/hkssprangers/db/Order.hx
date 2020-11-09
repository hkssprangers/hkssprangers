package hkssprangers.db;

typedef Order = {
    @:autoIncrement @:primary final orderId:Id<Order>;
    final creationTime:Timestamp;
    final orderCode:Null<VarChar<50>>;
    final shopId:VarChar<50>;
    final orderDetails:VarChar<2048>;
    final orderPrice:Float;
    final platformServiceCharge:Float;
    final wantTableware:Bool;
    final customerNote:Null<VarChar<2048>>;
    final deleted:Bool;
}