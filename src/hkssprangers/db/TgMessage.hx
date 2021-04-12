package hkssprangers.db;

typedef TgMessage = {
    @:autoIncrement @:primary final tgMessageId:Id<TgMessage>;
    final receiverId:Int;
    final updateType:Text;
    final updateData:Json;
}