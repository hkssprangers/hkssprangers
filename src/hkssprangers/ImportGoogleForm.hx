package hkssprangers;

import hkssprangers.info.TimeSlot;
import hkssprangers.info.TimeSlotType;
import haxe.Json;
import hkssprangers.server.MySql;
import tink.CoreApi;
import tink.core.ext.Promises;
import hkssprangers.info.Shop;
import hkssprangers.info.Delivery;
import tink.sql.expr.Functions as F;
using Lambda;
using StringTools;

class ImportGoogleForm {
    static function getLastImportRows():Promise<Array<{
        final spreadsheetId:String;
        final lastRow:Int;
    }>> {
        return MySql.db.googleFormImport
            .select({
                spreadsheetId: googleFormImport.spreadsheetId,
                lastRow: F.max(googleFormImport.lastRow),
            })
            .where(row -> row.spreadsheetId.inArray(GoogleForms.responseSheetId.array()))
            .groupBy(row -> [row.spreadsheetId])
            .all();
    }

    // assuming 2020-11-10 has been imported
    static final manualLastImportRow = [
        EightyNine => 41,
        YearsHK => 48,
        BiuKeeLokYuen => 31,
        DragonJapaneseCuisine => 31,
        Neighbor => 40,
        LaksaStore => 55,
        DongDong => 51,
        MGY => 12,
        KCZenzero => 84,
    ];

    static function insertManualLastImportRows() {
        var now = Date.now();
        return MySql.db.googleFormImport.insertMany([
            for (shop => lastRow in manualLastImportRow)
            {
                importTime: now,
                spreadsheetId: GoogleForms.responseSheetId[shop],
                lastRow: lastRow,
            }
        ]).noise();
    }

    static final _existingDeliveries = new Map<String, Promise<Array<Delivery>>>();
    static function existingDeliveries(date:String, shop:Shop, t:TimeSlotType) {
        return (if (_existingDeliveries.exists(date)) {
            _existingDeliveries[date];
        } else {
            _existingDeliveries[date] = MySql.db.getDeliveries(Date.fromString(date));
        }).next(deliveries -> deliveries.filter(d -> d.orders[0].shop == shop && TimeSlotType.classify(d.pickupTimeSlot.start) == t));
    }

    static function importGoogleForms():Promise<Bool> {
        var now = Date.now();
        var failed = false;
        return getLastImportRows()
            .next(lastRows ->
                Promise.inSequence([
                    for (shop => responseSheet in GoogleForms.responseSheet)
                    {
                        var lastRow = switch (lastRows.find(r -> r.spreadsheetId == GoogleForms.responseSheetId[shop])) {
                            case null:
                                trace("Could not find the last import row number of " + shop);
                                null;
                            case r:
                                r.lastRow;
                        }
                        var deliveries:js.lib.Promise<Array<Delivery>> = responseSheet
                            .then(doc -> doc.sheetsByIndex[0])
                            .then(sheet -> {
                                sheet.loadCells()
                                    .catchError(err -> {
                                        trace('Failed to loadCells() for ${shop.info().name}');
                                        var shouldRetry = switch (Std.downcast(err, js.lib.Error)) {
                                            case null:
                                                trace(Json.stringify(err, null, "  "));
                                                true;
                                            case jsErr if (jsErr.message.contains("[429]")): // Quota exceeded
                                                trace(jsErr.message);
                                                false;
                                            case jsErr if (jsErr.message.contains("[503]")): // Service Unavailable
                                                trace(jsErr.message);
                                                true;
                                            case jsErr:
                                                trace(Json.stringify(jsErr, null, "  "));
                                                true;
                                        }
                                        if (shouldRetry) {
                                            trace("retry");
                                            (Future.delay(1000 * 3, Noise):Promise<Noise>)
                                                .toJsPromise()
                                                .then(_ -> sheet.loadCells());
                                        } else {
                                            throw err;
                                        }
                                    })
                                    .then(_ -> sheet);
                            })
                            .then(sheet -> GoogleForms.getDeliveries(shop, sheet, lastRow))
                            .catchError(err -> {
                                trace('Could not get deliveries of ${shop.info().name}');
                                switch (Std.downcast(err, js.lib.Error)) {
                                    case null:
                                        trace(Json.stringify(err, null, "  "));
                                        failed = true;
                                    case jsErr if (jsErr.message.contains("[429]")): // Quota exceeded
                                        trace(jsErr.message);
                                    case jsErr if (jsErr.message.contains("[503]")): // Service Unavailable
                                        trace(jsErr.message);
                                    case jsErr:
                                        trace(Json.stringify(jsErr, null, "  "));
                                        failed = true;
                                }
                                [];
                            });
                        Promise.ofJsPromise(deliveries)
                            .next(deliveries -> {
                                trace('New deliveries of ${shop.info().name}: ' + deliveries.length);
                                if (deliveries.length > 0) {
                                    var deliveriesByDate = [
                                        for (d in deliveries)
                                        (d.pickupTimeSlot.start:String).substr(0, 10) => null
                                    ];
                                    for (dateStr in deliveriesByDate.keys())
                                        deliveriesByDate[dateStr] = deliveries.filter(d -> (d.pickupTimeSlot.start:String).startsWith(dateStr));
                                    Promise.inSequence([
                                        for (dateStr => deliveries in deliveriesByDate)
                                        for (t in [Lunch, Dinner])
                                        existingDeliveries(dateStr, shop, t)
                                            .next(existings -> {
                                                for (i => d in deliveries.filter(d -> TimeSlotType.classify(d.pickupTimeSlot.start) == t))
                                                    d.deliveryCode = d.orders[0].shop.info().name + " " + (switch t {
                                                        case Lunch: "L";
                                                        case Dinner: "D";
                                                    }) + Std.string(i+1+existings.length).lpad("0", 2);
                                                Noise;
                                            })
                                    ]).next(_ -> 
                                        MySql.db.insertDeliveries(deliveries)
                                            .next(_ -> MySql.db.googleFormImport.insertOne({
                                                importTime: now,
                                                spreadsheetId: GoogleForms.responseSheetId[shop],
                                                lastRow: lastRow + deliveries.length,
                                            }))
                                            .noise()
                                            .recover(err -> {
                                                trace('Could not insert deliveries of ${shop.info().name}.\n' + err);
                                                failed = true;
                                                Noise;
                                            })
                                            .next(r -> {
                                                trace("done insert of " + shop.info().name);
                                                r;
                                            })
                                    );
                                } else {
                                    Promise.NOISE;
                                }
                            });
                    }
                ])
            )
            .next(_ -> !failed);
    }

    static function main():Void {
        switch (Sys.args()) {
            case ["init"]:
                insertManualLastImportRows().handle(_ -> Sys.exit(0));
            case ["import"]:
                importGoogleForms().handle(o -> switch o {
                    case Success(succeeded):
                        Sys.exit(succeeded ? 0 : 1);
                    case Failure(failure):
                        trace(failure);
                        Sys.exit(1);
                });
            case args:
                throw "unknown args: " + Json.stringify(args);
        }
    }
}