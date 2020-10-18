package hkssprangers.db;

typedef Courier = {
    @:autoIncrement @:primary final courierId:Id<Courier>;
    @:unique final courierTgUsername:VarChar<128>;
    @:unique final courierTgId:Null<Int>;
    final paymeAvailable:Bool;
    final fpsAvailable:Bool;
}