package hkssprangers.info;

#if (!browser)
import sys.io.File;
#end
import CrossFetch.fetch;
import js.lib.Promise;
import haxe.*;
using Reflect;
using StringTools;

typedef LunarDate = {
    month:Int, //1-12
    day:Int, //1-30
}

class LunarCalendar {
    static public final lunarCalendar:DynamicAccess<LunarDate> = CompileTime.parseJsonFile("lunarCalendar.json");

    static public function lunarDate(date:Date):LunarDate {
        return lunarCalendar[(date:LocalDateString).getDatePart()];
    }

    #if (!browser)
    static public final icalUrl = "https://www.1823.gov.hk/common/ical/gc/tc.ics";

    static public function getLunar():Promise<DynamicAccess<LunarDate>> {
        final currentYear = Date.now().getFullYear();
        final lineParse = ~/^([0-9]{4})\/([0-9]{1,2})\/([0-9]{1,2})\s+(.+ Lunar Month|[0-9]+)\s/i;
        return Promise.all(
            [currentYear-1, currentYear, currentYear+1].map(year -> 
                fetch('https://www.hko.gov.hk/en/gts/time/calendar/text/files/T${year}e.txt')
                    .then(r -> if (!r.ok) {
                        throw 'Cannot fetch ${year}. ${r.status} ${r.statusText}';
                    } else {
                        r.text();
                    })
            )
        )
            .then(texts -> texts.join("\n"))
            .then(text -> {
                var lunarMonth = 0;
                var lunarDay = 0;
                final lunar = new DynamicAccess();
                for (line in text.split("\n")) {
                    if (
                        line.startsWith("Gregorian-Lunar Calendar Conversion Table")
                        ||
                        line.startsWith("Gregorian date")
                        ||
                        line == ""
                    ) continue;

                    if (!lineParse.match(line)) {
                        throw "Cannot parse " + line;
                    }

                    final date = lineParse.matched(1) + "-" + lineParse.matched(2).lpad("0", 2) + "-" + lineParse.matched(3).lpad("0", 2);
                    final lunarDate = lineParse.matched(4);
                    if (lunarDate.toLowerCase().endsWith(" lunar month")) {
                        lunarMonth = Std.parseInt(lunarDate);
                        lunarDay = 1;
                    } else {
                        lunarDay = Std.parseInt(lunarDate);
                    }
                    if (lunarMonth > 0) {
                        lunar[date] = {
                            month: lunarMonth,
                            day: lunarDay,
                        };
                    }
                }
                lunar;
            });
    }

    static public function main() {
        getLunar().then(lunar -> {
            File.saveContent("lunarCalendar.json", Json.stringify(lunar, null, "  "));
        });
    }
    #end
}