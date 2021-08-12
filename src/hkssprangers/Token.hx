package hkssprangers;

import jsonwebtoken.Claims;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.Shop;

typedef ShopAdminToken = Claims & {
    // order date
    final date:String;

    // order timeslot
    final time:TimeSlotType;

    final shop:Shop;
}
    final date:String;
    final time:TimeSlotType;
    final shop:Shop;
}