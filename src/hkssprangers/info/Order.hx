package hkssprangers.info;

typedef OrderMeta = {
    creationTime:LocalDateString,
    ?orderCode:String,
    shop:Shop,
    wantTableware:Bool,
    customerNote:Null<String>,
}

typedef Order = OrderMeta & {
    ?orderId:Int64String,
    orderDetails:String,
    orderPrice:Float,
    platformServiceCharge:Float,
    receipts:Null<Array<{
        receiptId:Int64String,
        receiptUrl:String,
    }>>,
}