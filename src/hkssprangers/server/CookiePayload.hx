package hkssprangers.server;

import hkssprangers.info.*;
import jsonwebtoken.Claims;

typedef CookiePayload = {
    iss:String,
    iat:EpochTimeSeconds,
	exp:EpochTimeSeconds,
    sub:JsonString<Subject>,
}

enum abstract LoginMethod(String) to String {
    var Telegram;
    var WhatsApp;
}

typedef Subject = {
    login:LoginMethod,
    ?tg:Tg,
    ?tel:String,
}
