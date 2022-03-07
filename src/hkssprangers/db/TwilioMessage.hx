package hkssprangers.db;

typedef TwilioMessage = {
    @:autoIncrement @:primary final twilioMessageId:BigInt;
    final creationTime:Timestamp;
    final data:Json<Dynamic>;
}