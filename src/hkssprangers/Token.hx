package hkssprangers;

import jsonwebtoken.Claims;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.Shop;

typedef Token = Claims & {
    final date:String;
    final time:TimeSlotType;
    final shop:Shop;
}