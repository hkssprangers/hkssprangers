package hkssprangers.db;

typedef MenuItem = {
    @:autoIncrement @:primary final menuItemId:BigInt;
    final creationTime:Timestamp;
    final startTime:Timestamp;
    final endTime:Timestamp;
    final shopId:VarChar<50>;
    final items:Json<Dynamic>;
    final deleted:Bool;
}