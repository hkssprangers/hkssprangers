package hkssprangers.info;

typedef Order<Item> = {
    shop:Shop<Item>,
    code:String,
    timestamp:Int,
    items: Array<{
        id: Item,
        data: Dynamic,
    }>,
    wantTableware:Bool,
    customerNote:Null<String>,
}