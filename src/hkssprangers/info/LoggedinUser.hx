package hkssprangers.info;

enum abstract LoginMethod(String) to String {
    var Telegram;
    var WhatsApp;
}

typedef LoggedinUser = {
    login:LoginMethod,
    ?tg:Tg,
    ?tel:String,
}
