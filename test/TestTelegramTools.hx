import haxe.crypto.Sha256;
import utest.Assert;
import hkssprangers.TelegramTools;

class TestTelegramTools extends utest.Test {
    function testVerifyLoginResponse() {
        var tgBotTokenSha256 = Sha256.encode("THISISJUSTATEST");
        var response:Dynamic = {
            id: 2038510,
            auth_date: '1518786225',
            first_name: 'HappyBoi',
            photo_url: 'https://t.me/i/userpic/392/HappyBoi.jpg',
            username: 'HappyBoi',
            hash: '4e701ce359ca4395b7d9fc67a1dba0c46bb6fa76f0cbf4097c22fe6c0e42ad59',
        }
        Assert.isTrue(TelegramTools.verifyLoginResponse(tgBotTokenSha256, response));
    }
}
