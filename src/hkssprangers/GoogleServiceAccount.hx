package hkssprangers;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;

class GoogleServiceAccount {
    static final formReaderServiceAccountFile = "hkssprangers-1850e37b7d98.json";
    static public final formReaderServiceAccount = switch [Sys.getEnv("FORM_READER_EMAIL"), Sys.getEnv("FORM_READER_PRIVATE_KEY")] {
        case [null, _] | [_, null]:
            if (FileSystem.exists(formReaderServiceAccountFile))
                try {
                    Json.parse(File.getContent(formReaderServiceAccountFile));
                } catch (e:Dynamic) {
                    null;
                }
            else
                null;
        case [client_email, private_key]:
            {
                client_email: client_email,
                private_key: private_key,
            };
    }
}