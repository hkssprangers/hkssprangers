package hkssprangers;

import google_auth_library.JWT;
import thx.Decimal;
import tink.CoreApi;
import js.lib.Promise;
import js.npm.google_spreadsheet.GoogleSpreadsheet;
import js.npm.google_spreadsheet.GoogleSpreadsheetWorksheet;
import hkssprangers.info.*;
import hkssprangers.info.Shop;
import hkssprangers.info.ContactMethod;
import hkssprangers.info.TimeSlotType;
import hkssprangers.info.OrderTools.*;
using Lambda;
using StringTools;
using DateTools;
using hkssprangers.MathTools;
using hkssprangers.ObjectTools;
using hkssprangers.info.DeliveryTools;

class GoogleForms {
    static public function getToken() {
        var creds = GoogleServiceAccount.formReaderServiceAccount;
        return new JWT({
            email: creds.client_email,
            key: creds.private_key,
            scopes: "https://www.googleapis.com/auth/spreadsheets",
        }).authorize().then(cred -> cred.access_token);
    }
}