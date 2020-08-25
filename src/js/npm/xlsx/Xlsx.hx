package js.npm.xlsx;

import haxe.DynamicAccess;

typedef WorkBook = {
    /**
     * A dictionary of the worksheets in the workbook.
     * Use SheetNames to reference these.
     */
    var Sheets:DynamicAccess<WorkSheet>;

    /** Ordered list of the sheet names in the workbook */
    var SheetNames:Array<String>;

    /** Standard workbook Properties */
    var Props:Dynamic;

    /** Custom workbook Properties */
    @:optional var Custprops:Dynamic;

    @:optional var Workbook:Dynamic;

    @:optional var vbaraw:Dynamic;
}

extern class WorkSheet implements Dynamic<Cell> {
    /** Sheet type */
    @:native('!type')
    @:optional
    var __type:Dynamic;

    /** Sheet Range */
    @:native('!ref')
    @:optional
    var __ref:String;

    /** Page Margins */
    @:native('!margins')
    @:optional
    var __margins:Dynamic;

    /** Column Info */
    @:native('!cols')
    @:optional
    var __cols:Array<Dynamic>;

    /** Row Info */
    @:native('!rows')
    @:optional
    var __rows:Array<Dynamic>;

    /** Merge Ranges */
    @:native('!merges')
    @:optional
    var __merges:Array<Dynamic>;

    /** Worksheet Protection info */
    @:native('!protect')
    @:optional
    var __protect:Dynamic;

    /** AutoFilter info */
    @:native('!autofilter')
    @:optional
    var __autofilter:Dynamic;
}

typedef Cell = {
    /** raw value **/
    var v:Dynamic;

    /** formatted text **/
    var w:String;

    /** type **/
    var t:String;
}

@:jsRequire("xlsx")
extern class Xlsx {
    static public function read(data:Dynamic, ?opts:Dynamic):WorkBook;
    static public function readFile(filename:Dynamic, ?opts:Dynamic):WorkBook;

    static final utils:{
        function sheet_to_json(ws:WorkSheet, ?opts:Dynamic):Dynamic;
    }
}