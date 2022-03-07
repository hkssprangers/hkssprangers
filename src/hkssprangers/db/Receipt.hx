package hkssprangers.db;

typedef Receipt = {
    @:autoIncrement @:primary final receiptId:BigInt;
    final receiptUrl:VarChar<1024>;
    final orderId:BigInt;
    final uploaderCourierId:BigInt;
}