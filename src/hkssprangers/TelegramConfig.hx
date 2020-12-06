package hkssprangers;

class TelegramConfig {
    static public final tgBotToken = Sys.getEnv("TGBOT_TOKEN");
    static public final testingGroupChatId:Float = -455974080;
    static public final internalGroupChatId:Float = -1001444088795;
    static public function groupChatId(stage:DeployStage) return switch stage {
        case dev | master: testingGroupChatId;
        case production: internalGroupChatId;
    }
}