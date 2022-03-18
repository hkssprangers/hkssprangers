import hkssprangers.info.menu.BlackWindowMenu;
import comments.CommentString.*;
import haxe.crypto.Sha256;
import utest.Assert;
import hkssprangers.TelegramTools;

class TestBlackWindow extends utest.Test {
    function testParseSoup() {
        final menu = BlackWindowMenu.parseMenu(comment(unindent)/**
            湯
            - 西蘭花福花果仁湯 v $20
            - expensive 西蘭花福花果仁湯* v $30 跟餐+$5
        **/);
        Assert.equals(2, menu.Soup.items.length);

        Assert.equals("西蘭花福花果仁湯 v", menu.Soup.items[0].name);
        Assert.equals(20, menu.Soup.items[0].price);
        Assert.isNull(menu.Soup.items[0].setPrice);

        Assert.equals("expensive 西蘭花福花果仁湯* v", menu.Soup.items[1].name);
        Assert.equals(30, menu.Soup.items[1].price);
        Assert.equals(5, menu.Soup.items[1].setPrice);
    }

    function testTypeDescription() {
        final menu = BlackWindowMenu.parseMenu(comment(unindent)/**
            咖啡［只供應燕麥奶咖啡］
        **/);
        Assert.equals("只供應燕麥奶咖啡", menu.Coffee.description);
    }

    function testTypeMissing() {
        final menu = BlackWindowMenu.parseMenu("");
        Assert.isNull(menu.Soup);
    }

    function testItemWithChoices() {
        Assert.raises(() -> {
            final menu = BlackWindowMenu.parseMenu(comment(unindent)/**
                咖啡
                - Black [熱/凍] $36
            **/);
        });
        Assert.raises(() -> {
            final menu = BlackWindowMenu.parseMenu(comment(unindent)/**
                咖啡
                - Black [熱／凍] $36
            **/);
        });
    }

    function testAll() {
        final menu = BlackWindowMenu.parseMenu(comment(unindent)/**
            湯
            - 西蘭花福花果仁湯 v $20

            小食
            - 蒜香龍蒿牛油配烤蘑菇 v五 $25
            - 百香果醋羽衣車厘茄焗薯沙律* v $30 跟餐+$5

            主食
            - 蕃茄白酒「海鮮」菇菌長通粉 v 五 $68
            - 花椒麻醬三絲拌上海麵 v 五 $66
            - 花椒麻醬三絲拌上海麵 v 走五 $66

            甜品
            - 橙香青豆蔻杏仁蛋糕 v $38

            飲品
            - ［是日特飲］ 薑汁可可 [熱] $40 跟主食$30
            - ［是日特飲］ 薑汁可可 [凍] $40 跟主食$30
            - 無糖麥茶 [熱] $10 跟主食+$3
            - 古法紅糖薑母梳打 [凍] $22 跟主食+$12
            - 紫蘇薄荷lemonade [熱] $22 跟主食+$12
            - 紫蘇薄荷lemonade [凍] $22 跟主食+$12
            - 紫蘇薄荷lemonade梳打 [凍] $25 跟主食+$12
            - 薑汁麥芽豆乳 [熱] $22 跟主食+$12
            - 舒敏南非國寶茶 [熱] $28 跟主食+$18
            - 疏鬱玫瑰黑杞茶 [熱][壺] $38 跟主食+$28
            - 和胃麥香桂花茶 [熱][壺] $38 跟主食+$28
            - 潤燥雪梨菊花茶 [熱][壺] $38 跟主食+$28
            - 安神杞子金盞花茶 [熱][壺] $38 跟主食+$28
            - 靜岡深煎茶 [熱][壺] $38 跟主食+$28

            咖啡［只供應燕麥奶咖啡］
            - Black [熱] $34
            - Black [凍] $36

            啤酒［本地精釀啤酒H.K Lovecraft］
            - Space Rock (Rauchbier) $66
            - Fire Bringer (Vienna Lager) $66
            - Old Blood (Dunkel) $66
            - Mother Goat (Doppelbock) $66
            - Black Wave (Baltic Porter) $66

            Cocktails
            - Molly by the Sea 海邊莫莉 (Thyme, Grapefruit, Vodka) $78
            - Half Sleep Chamomile 半眠甘菊 (Chamomile Tea, Gin) $78
            - Harutaka Mochizuki望月治孝 (桂圓, Whiskey, 斑蘭) $78
        **/);
        Assert.equals(1, menu.Soup.items.length);
        Assert.equals(2, menu.Snack.items.length);
        Assert.equals(3, menu.Main.items.length);
        Assert.equals(1, menu.Dessert.items.length);
        Assert.equals(14, menu.Drink.items.length);
        Assert.equals(2, menu.Coffee.items.length);
        Assert.equals(5, menu.Beer.items.length);
        Assert.equals(3, menu.Cocktail.items.length);
    }
}
