package hkssprangers.browser.forms;

import hkssprangers.LocalDateString;
import hkssprangers.info.*;

typedef OrderFormData = {
    currentTime:LocalDateString,
    ?backupContactMethod:ContactMethod,
    ?backupContactValue:String,
    ?pickupTimeSlot:JsonString<TimeSlot>,
    ?pickupLocation:String,
    ?pickupMethod:PickupMethod,
    ?orders:Array<FormOrderData>,
    ?paymentMethods:Array<PaymentMethod>,
    ?customerNote:String,
}