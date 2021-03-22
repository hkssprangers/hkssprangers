package hkssprangers.info;

#if (!browser)
import sys.io.File;
import js.npm.fetch.Fetch;
#end
import js.lib.Promise;
import haxe.*;

class HkHolidays {
    static public final holidays = CompileTime.parseJsonFile("holidays.json");

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
        return Fetch.fetch(icalUrl)
            .then(r -> if (r.ok) {
                r.text().then(cast NodeIcal.sync.parseICS);
            } else {
                throw 'Cannot fetch ical. ${r.status} ${r.statusText}';
            });
    }

    static public function main() {
        getHolidays().then(ical -> {
            var holidays:DynamicAccess<String> = {};
            for (_ => d in ical)
                holidays[(d.start:LocalDateString).getDatePart()] = d.summary;
            File.saveContent("holidays.json", Json.stringify(holidays, null, "  "));
        });
    }
    #end
}