package hkssprangers;

import haxe.io.Bytes;
import haxe.crypto.Hmac;
import haxe.DynamicAccess;

class TelegramTools {
    static public function verifyLoginResponse(tgBotTokenSha256:String, response:Null<DynamicAccess<Dynamic>>):Bool {
        if (response == null) return false;

        var dataCheckString = ({
            var kv = [
                for (k => v in response)
                if (k != "hash")
                k + "=" + v
            ];
            kv.sort(Reflect.compare);
            kv;
        }).join("\n");
        var expectedHash = new Hmac(SHA256).make(Bytes.ofHex(tgBotTokenSha256), Bytes.ofString(dataCheckString)).toHex();
        return expectedHash == response["hash"];
    }

    static public function isValidUserName(username:String):Bool {
        return ~/^[A-Za-z0-9_]{5,}$/.match(username);
    }
}