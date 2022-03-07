package hkssprangers.db;

typedef TgMessage = {
    @:autoIncrement @:primary final tgMessageId:BigInt;
    final receiverId:VarChar<128>;
    final updateType:Text;
    final updateData:Json<Dynamic>;
}