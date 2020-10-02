package hkssprangers.info;

typedef OrderMeta = {
    creationTime:LocalDateString,
    ?orderCode:String,
    shop:Shop,
    wantTableware:Bool,
    customerNote:Null<String>,
}

typedef Order = OrderMeta & {
    orderDetails:String,
    orderPrice:Float,
    platformServiceCharge:Float,
}