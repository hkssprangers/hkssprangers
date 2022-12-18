package hkssprangers;

import haxe.io.Bytes;
import haxe.crypto.Hmac;
import haxe.DynamicAccess;
import js.lib.Promise;
import hkssprangers.info.*;
import telegraf.Telegraf;
import comments.CommentString.*;
using hkssprangers.info.TimeSlotTools;
using StringTools;

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

    #if (sys || nodejs)
    static public function notifyNewDelivery(delivery:Delivery, stage:DeployStage):Promise<Dynamic> {
        final tgBot = new Telegraf(TelegramConfig.tgBotToken);
        final shopNames = delivery.orders.map(o -> "🔸 " + o.shop.info().name).join("\n");
        final destinationHint = switch (DeliveryFee.getMatchedHeuristrics(delivery.pickupLocation)) {
            case [h]: '${h.place}';
            case _: "";
        }
        final deliveryStr = comment(unindent, format)/**
            📃 ${delivery.deliveryCode}
            ${shopNames}
            ${delivery.pickupTimeSlot.print()}
            ${destinationHint}
        **/;
        final msg = '啱啱收到 1 單 ✨\n\n${deliveryStr.htmlEscape(false)}';

        return PromiseRetry.call(
            function (retry, attempt) {
                return tgBot.telegram.sendMessage(
                    TelegramConfig.groupChatId(stage),
                    msg,
                    {
                        parse_mode: "HTML",
                        disable_web_page_preview: true,
                    }
                ).catchError(err -> {
                    trace(err);
                    cast retry(err);
                });
            },
            {
                retries: 3,
            }
        );
    }
    #end
}