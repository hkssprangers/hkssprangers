package hkssprangers.browser.forms;

import hkssprangers.info.*;

typedef OrderFormPrefill = {
    @:optional final pickupLocation:String;
    @:optional final pickupMethod:PickupMethod;
    @:optional final paymentMethods:Array<PaymentMethod>;
    @:optional final backupContactMethod:ContactMethod;
    @:optional final backupContactValue:String;
}
