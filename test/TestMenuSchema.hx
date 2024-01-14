import hkssprangers.info.menu.LoudTeaSSPMenu;
import hkssprangers.info.menu.LonelyPaisleyMenu;
import hkssprangers.info.menu.CafeGoldenMenu;
import hkssprangers.info.menu.MinimalMenu.MinimalItem;
import hkssprangers.info.menu.PokeGoMenu.PokeGoItem;
import hkssprangers.info.menu.HanaSoftCreamMenu;
import hkssprangers.info.menu.KCZenzeroMenu;
import hkssprangers.info.menu.BiuKeeLokYuenMenu;
import hkssprangers.info.menu.LaksaStoreMenu;
import hkssprangers.info.menu.TheParkByYearsMenu;
import hkssprangers.info.menu.YearsHKMenu;
import hkssprangers.info.menu.ThaiHomeMenu;
import hkssprangers.info.menu.EightyNineMenu;
import hkssprangers.info.menu.FishFranSSPMenu;
import hkssprangers.info.TimeSlotType;
import utest.Assert;

class TestMenuSchema extends utest.Test {
    static function assertCompilable(schema:Dynamic, ?pos:haxe.PosInfos) {
        final ajv = Ajv.call({
            removeAdditional: "all",
        });
        try {
            ajv.compile(schema);
            Assert.pass(null, pos);
        } catch (err) {
            Assert.fail('Failed to compile schema (' + schema.title + "): " + err, pos);
        }
    }

    function testInvalidSchema() {
        final ajv = Ajv.call({
            removeAdditional: "all",
        });
        Assert.raises(() -> ajv.compile({
            title: "煲/鍋",
            type: "string",
            "enum": [
                // duplicated items is not allowed
                "羊腩煲(鍋) $405",
                "羊腩煲(鍋) $405",
                "鮮鍋(魚頭+羊腩)(鍋) $537",
            ],
        }));
    }

    function testEightyNine() {
        for (item in [
            EightyNineItem.LimitedSpecial,
            EightyNineItem.MainCourse,
            EightyNineItem.Snack,
            EightyNineItem.RiceAndNoodle,
        ])
            assertCompilable(item.getDefinition());
    }

    function testThaiHome() {
        for (slotType in [Lunch, Dinner])
        for (item in ThaiHomeItem.all(slotType))
            assertCompilable(item.getDefinition());
    }

    function testYearsHK() {
        for (item in [
            // YearsHKItem.Set,
            YearsHKItem.WeekdayLunchSet,
            YearsHKItem.DinnerHolidaySet,
            YearsHKItem.Single,
        ])
            assertCompilable(item.getDefinition());
    }

    function testTheParkByYears() {
        for (item in [
            TheParkByYearsItem.Set,
            TheParkByYearsItem.WeekdayLunchSet,
            TheParkByYearsItem.DinnerHolidaySet,
            TheParkByYearsItem.Single,
        ])
            assertCompilable(item.getDefinition());
    }

    function testLaksaStore() {
        final dayAfterTmr = DateTools.delta(Date.now(), DateTools.days(2));
        for (item in LaksaStoreItem.all)
            assertCompilable(item.getDefinition({
                start: dayAfterTmr,
                end: dayAfterTmr
            }));
    }

    function testBiuKeeLokYuen() {
        for (item in BiuKeeLokYuenItem.all)
            assertCompilable(item.getDefinition());
    }

    function testKCZenzero() {
        for (def in ([
            KCZenzeroMenu.KCZenzeroHotDouble,
            KCZenzeroMenu.KCZenzeroYiMein,
            KCZenzeroMenu.KCZenzeroTomatoSoupRice,
            KCZenzeroMenu.KCZenzeroHoiSinPot,
            KCZenzeroMenu.KCZenzeroHotdogSet,
            KCZenzeroMenu.KCZenzeroLambPasta,
            KCZenzeroMenu.KCZenzeroR6Set,
            KCZenzeroMenu.KCZenzeroCuredMeatRice,
            KCZenzeroMenu.KCZenzeroLightSet,
            KCZenzeroMenu.KCZenzeroGoldenLeg,
            KCZenzeroMenu.KCZenzeroTomatoRice,
            KCZenzeroMenu.KCZenzeroMincedPork,
            KCZenzeroMenu.KCZenzeroHotpotSet,
            KCZenzeroMenu.KCZenzeroRice,
            KCZenzeroMenu.KCZenzeroSingle,
        ]:Array<Dynamic>))
            assertCompilable(def);
    }

    function testHanaSoftCream() {
        for (def in ([
            HanaSoftCreamMenu.HanaSoftCreamItem
        ]:Array<Dynamic>))
            assertCompilable(def);
    }

    function testPokeGo() {
        for (item in PokeGoItem.all)
            assertCompilable(item.getDefinition());
    }

    function testMinimal() {
        for (item in MinimalItem.all)
            assertCompilable(item.getDefinition());
    }

    function testCafeGolden() {
        for (item in CafeGoldenItem.all)
            assertCompilable(item.getDefinition());
    }

    function testLonelyPaisley() {
        for (item in [
            LonelyPaisleyItem.LunchSet,
            LonelyPaisleyItem.SaladSnacks,
            LonelyPaisleyItem.Dessert,
            LonelyPaisleyItem.PastaRice,
            LonelyPaisleyItem.Main,
            LonelyPaisleyItem.Drink,
        ])
            assertCompilable(item.getDefinition());
    }

    function testFishFran() {
        for (slotType in [Lunch, Dinner])
        for (item in FishFranSSPItem.all(slotType))
            assertCompilable(item.getDefinition());
    }
}