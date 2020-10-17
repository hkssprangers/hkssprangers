package hkssprangers.db;

typedef Delivery = {
    @:autoIncrement @:primary var deliveryId:Id<Delivery>;
    var deliveryCode:VarChar<50>;
    var creationTime:Timestamp;
    var pickupLocation:VarChar<1024>;
    var deliveryFee:Float;
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