package hkssprangers;

import jsonwebtoken.Claims;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.Shop;

typedef ShopAdminToken = Claims & {
    final date:String;
    final time:TimeSlotType;
    final shop:Shop;
}