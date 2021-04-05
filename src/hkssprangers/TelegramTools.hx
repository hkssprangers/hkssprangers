package hkssprangers;

import haxe.io.Bytes;
import haxe.crypto.Hmac;
import haxe.DynamicAccess;
import js.lib.Promise;
import hkssprangers.info.*;
import telegraf.Telegraf;
using hkssprangers.info.TimeSlotTools;

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

    static public function notifyNewDeliveries(deliveries:Array<Delivery>) {
        if (deliveries.length <= 0)
            return Promise.resolve(null);

        var tgBot = new Telegraf(TelegramConfig.tgBotToken);
        var deliveryStrs = deliveries
            .map(d ->
                "📃 " + d.orders.map(o -> o.shop.info().name).join(", ") + "\n " + d.pickupTimeSlot.print()
            )
            .map(str -> StringTools.htmlEscape(str, false));
        var msg = '啱啱收到 ${deliveries.length} 單';
        if (deliveries.length > 0) {
            msg += " ✨\n\n";
            msg += deliveryStrs.join("\n\n");
        }
        return tgBot.telegram.sendMessage(
            TelegramConfig.internalGroupChatId,
            msg,
            {
                parse_mode: "HTML",
                disable_web_page_preview: true,
            }
        );
    }
}