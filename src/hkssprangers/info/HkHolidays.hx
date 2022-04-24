package hkssprangers.info;

#if (!browser)
import sys.io.File;
#end
import CrossFetch.fetch;
import js.lib.Promise;
import haxe.*;
using Reflect;

class HkHolidays {
    static public final holidays = CompileTime.parseJsonFile("holidays.json");

    static public function isRedDay(date:Date):Bool {
        return switch (Weekday.fromDay(date.getDay())) {
            case Monday | Tuesday | Wednesday | Thursday | Friday:
                HkHolidays.holidays.hasField((date:LocalDateString).getDatePart());
            case Saturday | Sunday: true;
        }
    }

    #if (!browser)
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
        return fetch(icalUrl)
            .then(r -> if (r.ok) {
                r.text().then(cast NodeIcal.sync.parseICS);
            } else {
                throw 'Cannot fetch ical. ${r.status} ${r.statusText}';
            });
    }

    static public function main() {
        getHolidays().then(ical -> {
            final holidays:DynamicAccess<String> = {};
            for (_ => d in ical)
            switch (d.type) {
                case "VEVENT":
                    holidays[(d.start:LocalDateString).getDatePart()] = d.summary;
                case "VCALENDAR":
                    // pass
                case type:
                    trace(type);
            }
            File.saveContent("holidays.json", Json.stringify(holidays, null, "  "));
        });
    }
    #end
}