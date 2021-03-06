package hkssprangers.info;

import haxe.ds.ReadOnlyArray;
using Lambda;

enum abstract ContactMethod(String) to String {
    var Telegram;
    var WhatsApp;
    var Telephone;

    public function info() return switch (cast this:ContactMethod) {
        case Telegram:
            {
                id: Telegram,
                name: "Telegram",
            }
        case WhatsApp:
            {
                id: WhatsApp,
                name: "WhatsApp",
            }
        case Telephone:
            {
                id: Telephone,
                name: "電話",
            }
    }

    static public final all:ReadOnlyArray<ContactMethod> = [
        Telegram,
        WhatsApp,
        Telephone,
    ];

    static public function fromName(name:String) {
        name = name.toLowerCase();
        return all.find(m -> m.info().name.toLowerCase() == name);
    }

    static public function fromId(id:String) {
        return all.find(m -> (m:String) == id);
    }
}