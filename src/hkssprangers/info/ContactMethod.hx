package hkssprangers.info;

import haxe.ds.ReadOnlyArray;
using Lambda;

enum abstract ContactMethod(String) to String {
    final Telegram;
    final WhatsApp;
    final Signal;
    final Telephone;

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
        case Signal:
            {
                id: Signal,
                name: "Signal",
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
        Signal,
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