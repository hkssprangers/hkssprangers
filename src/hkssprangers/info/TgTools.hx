package hkssprangers.info;

class TgTools {
    static public function print(tg:Tg, link = true):String {
        return if (tg.username != null)
            if (link)
                "https://t.me/" + tg.username;
            else
                "@" + tg.username;
        else if (tg.id != null)
            "" + tg.id;
        else
            "[none]";
    }
}