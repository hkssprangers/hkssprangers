package hkssprangers.info;

class TgTools {
    static public function print(tg:Tg):String {
        return if (tg.username != null)
            "@" + tg.username;
        else if (tg.id != null)
            "" + tg.id;
        else
            "[none]";
    }
}