package hkssprangers.db;

typedef TimeSlotRule = {
    @:primary final startTime:Timestamp;
    @:primary final endTime:Timestamp;
    final availability:Json<Dynamic>;
}
