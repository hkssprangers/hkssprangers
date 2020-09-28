package hkssprangers.info;

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
}