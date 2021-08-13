package hkssprangers;

import hkssprangers.info.*;
import jsonwebtoken.Claims;

typedef CookiePayload = {
    iss:String,
    iat:EpochTimeSeconds,
    exp:EpochTimeSeconds,
    sub:JsonString<LoggedinUser>,
}