package hkssprangers.db;

typedef Courier = {
    @:autoIncrement @:primary final courierId:BigInt;
    @:unique final courierTgUsername:VarChar<128>;
    @:unique final courierTgId:Null<VarChar<128>>;
    final paymeAvailable:Bool;
    final fpsAvailable:Bool;
    final deleted:Bool;
    final isAdmin:Bool;
}