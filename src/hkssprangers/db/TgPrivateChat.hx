package hkssprangers.db;

typedef TgPrivateChat = {
    @:primary final botId:VarChar<128>;
    @:primary final userId:VarChar<128>;
    final userUsername:Null<VarChar<128>>;
    final chatId:Null<VarChar<128>>;
    final lastUpdateData:Null<Json<Dynamic>>;
}
