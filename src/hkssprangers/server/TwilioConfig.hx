package hkssprangers.server;

class TwilioConfig {
    static public final sid = Sys.getEnv("TWILIO_SID");
    static public final authToken = Sys.getEnv("TWILIO_AUTH_TOKEN");
}
