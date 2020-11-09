package hkssprangers;

import haxe.Json;
import hkssprangers.server.MySql;
import tink.CoreApi;
import tink.core.ext.Promises;
import hkssprangers.info.Shop;
import hkssprangers.info.Delivery;
import tink.sql.expr.Functions as F;
using Lambda;

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

    static final manualLastImportRow = [
        EightyNine => 41,
        YearsHK => 46,
        BiuKeeLokYuen => 31,
        DragonJapaneseCuisine => 30,
        Neighbor => 40,
        LaksaStore => 54,
        DongDong => 50,
        MGY => 12,
        KCZenzero => 83,
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

    static function importGoogleForms():Promise<Bool> {
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
                        var deliveries = responseSheet
                            .then(doc -> doc.sheetsByIndex[0])
                            .then(sheet -> sheet.loadCells().then(_ -> sheet))
                            .then(sheet -> GoogleForms.getDeliveries(shop, sheet, lastRow))
                            .catchError(err -> {
                                trace('Could not get deliveries of ${shop.info().name}\n' + err);
                                failed = true;
                                [];
                            });
                        Promise.ofJsPromise(deliveries)
                            .next(deliveries -> {
                                trace('New deliveries of ${shop.info().name}: ' + deliveries.length);
                                if (deliveries.length > 0)
                                    MySql.db.insertDeliveries(deliveries)
                                        .recover(err -> {
                                            trace('Could not insert deliveries of ${shop.info().name}. Deliveries:\n' + Json.stringify(deliveries));
                                            failed = true;
                                            Noise;
                                        })
                                        .next(r -> {
                                            trace("done insert of " + shop.info().name);
                                            r;
                                        });
                                else
                                    Promise.NOISE;
                            });
                    }
                ])
            )
            .next(_ -> !failed);
    }

    static function main():Void {
        // insertManualLastImportRows().handle(_ -> Sys.exit(0));
        importGoogleForms().handle(o -> switch o {
            case Success(succeeded):
                Sys.exit(succeeded ? 0 : 1);
            case Failure(failure):
                trace(failure);
                Sys.exit(1);
        });
    }
}