package hkssprangers.info;

using hkssprangers.info.TgTools;

class LoggedinUserTools {
    static public function print(user:LoggedinUser):String {
        return switch (user.login) {
            case null:
                null;
            case Telegram:
                user.tg.print(true);
            case WhatsApp:
                'https://wa.me/852${user.tel}';
        }
    }
}
