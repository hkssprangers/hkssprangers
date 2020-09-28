package hkssprangers.db;

typedef Courier = {
    @:autoIncrement @:primary var courierId:Id<Courier>;
    @:unique var courierTgUsername:VarChar<128>;
    @:unique var courierTgId:Null<Int>;
    var paymeAvailable:Bool;
    var fpsAvailable:Bool;
}