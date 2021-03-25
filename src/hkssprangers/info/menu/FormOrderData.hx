package hkssprangers.info.menu;

typedef FormOrderData = {
    ?shop:Shop,
    ?items:Array<{
        ?type:String,
        ?item:Dynamic,
    }>,
}
