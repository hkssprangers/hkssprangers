package hkssprangers.info;

typedef FormOrderData = {
    ?shop:Shop,
    ?items:Array<{
        ?type:String,
        ?item:Dynamic,
    }>,
    ?wantTableware:Bool,
    ?customerNote:String,
}
