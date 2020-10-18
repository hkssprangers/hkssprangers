package hkssprangers.info;

using Lambda;

enum abstract ContactMethod(String) to String {
    var Telegram;
    var WhatsApp;

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
    }

    static public function fromName(name:String) {
        name = name.toLowerCase();
        return [Telegram, WhatsApp].find(m -> m.info().name.toLowerCase() == name);
    }
}