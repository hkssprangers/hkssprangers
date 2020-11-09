package hkssprangers.db;

typedef GoogleFormImport = {
    @:primary final importTime:Timestamp;
    @:primary final spreadsheetId:VarChar<100>;
    final lastRow:Int;
}