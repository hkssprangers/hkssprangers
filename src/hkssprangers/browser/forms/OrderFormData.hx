package hkssprangers.browser.forms;

import hkssprangers.info.*;

typedef OrderFormData = {
    ?backupContactMethod:ContactMethod,
    ?backupContactValue:String,
    ?pickupTimeSlot:JsonString<TimeSlot>,
    ?pickupLocation:String,
    ?pickupMethod:PickupMethod,
    ?orders:Array<FormOrderData>,
    ?paymentMethods:Array<PaymentMethod>,
    ?customerNote:String,
}