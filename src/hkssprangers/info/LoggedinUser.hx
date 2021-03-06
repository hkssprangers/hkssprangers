package hkssprangers.info;

import haxe.ds.ReadOnlyArray;

@:forward
enum abstract LoginMethod(ContactMethod) to ContactMethod {
    final Telegram = ContactMethod.Telegram;
    final WhatsApp = ContactMethod.WhatsApp;

    static public final all:ReadOnlyArray<ContactMethod> = [
        Telegram,
        WhatsApp,
    ];
}

typedef LoggedinUser = {
    login:LoginMethod,
    ?tg:Tg,
    ?tel:String,
}
