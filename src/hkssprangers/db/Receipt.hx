package hkssprangers.db;

typedef Receipt = {
    @:autoIncrement @:primary final receiptId:Id<Receipt>;
    final receiptUrl:VarChar<1024>;
    final orderId:Id<Order>;
    final uploaderCourierId:Id<Courier>;
}