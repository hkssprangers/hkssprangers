package hkssprangers.db;

typedef TwilioMessage = {
    @:autoIncrement @:primary final twilioMessageId:Id<TwilioMessage>;
    final creationTime:Timestamp;
    final data:Json<Dynamic>;
}