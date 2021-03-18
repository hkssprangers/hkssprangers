package hkssprangers.info;

import js.npm.fetch.Fetch;
import js.lib.Promise;
import haxe.*;

class HkHolidays {
    static public final icalUrl = "https://www.1823.gov.hk/common/ical/gc/tc.ics";

    static public function getHolidays():Promise<DynamicAccess<{
        type:String,
        params:Array<Dynamic>,
        datetype:String,
        start:Date,
        end:Date,
        transparency:String,
        uid:String,
        summary:String,
    }>> {
        return Fetch.fetch(icalUrl)
            .then(r -> if (r.ok) {
                r.text().then(cast NodeIcal.sync.parseICS);
            } else {
                throw 'Cannot fetch ical. ${r.status} ${r.statusText}';
            });
    }
}