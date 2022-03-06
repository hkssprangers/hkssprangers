package hkssprangers.db;

typedef Delivery = {
    @:autoIncrement @:primary final deliveryId:Id<Delivery>;
    final deliveryCode:VarChar<50>;
    final creationTime:Timestamp;
    final pickupLocation:VarChar<1024>;
    final deliveryFee:Float;
    final pickupTimeSlotStart:Timestamp;
    final pickupTimeSlotEnd:Timestamp;
    final pickupMethod:VarChar<64>;
    final paymeAvailable:Bool;
    final fpsAvailable:Bool;
    final customerTgUsername:Null<VarChar<128>>;
    final customerTgId:Null<VarChar<64>>;
    final customerTel:Null<VarChar<64>>;
    final customerWhatsApp:Null<VarChar<64>>;
    final customerSignal:Null<VarChar<64>>;
    final customerPreferredContactMethod:VarChar<64>;
    final customerBackupContactMethod:VarChar<64>;
    final customerNote:Null<VarChar<2048>>;
    final deleted:Bool;
}