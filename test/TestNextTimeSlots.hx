import utest.Assert;
import hkssprangers.info.Info;

class TestNextTimeSlots extends utest.Test {
    function test20200815234900() {
        var nextSlots = DragonJapaneseCuisine.nextTimeSlots(Date.fromString("2020-08-15 23:49:00"));
        Assert.same(
            [
                "2020-08-16 12:00:00",
                "2020-08-16 13:00:00",
                "2020-08-16 19:00:00",
                "2020-08-16 20:00:00",
            ],
            nextSlots.map(slot -> DateTools.format(slot.start, "%Y-%m-%d %H:%M:%S"))
        );
    }

    function testLunchCutoff() {
        // before Lunch cutoff
        var nextSlots = DragonJapaneseCuisine.nextTimeSlots(Date.fromString("2020-08-17 09:59:59"));
        Assert.same(
            [
                "2020-08-17 12:00:00",
                "2020-08-17 13:00:00",
                "2020-08-17 19:00:00",
                "2020-08-17 20:00:00",
            ],
            nextSlots.map(slot -> DateTools.format(slot.start, "%Y-%m-%d %H:%M:%S"))
        );

        // passed Lunch cutoff
        var nextSlots = DragonJapaneseCuisine.nextTimeSlots(Date.fromString("2020-08-17 10:00:01"));
        Assert.same(
            [
                "2020-08-17 19:00:00",
                "2020-08-17 20:00:00",
                "2020-08-18 12:00:00",
                "2020-08-18 13:00:00",
            ],
            nextSlots.map(slot -> DateTools.format(slot.start, "%Y-%m-%d %H:%M:%S"))
        );
    }

    function testDinnerCutoff() {
        // before Dinner cutoff
        var nextSlots = DragonJapaneseCuisine.nextTimeSlots(Date.fromString("2020-08-17 16:59:59"));
        Assert.same(
            [
                "2020-08-17 19:00:00",
                "2020-08-17 20:00:00",
                "2020-08-18 12:00:00",
                "2020-08-18 13:00:00",
            ],
            nextSlots.map(slot -> DateTools.format(slot.start, "%Y-%m-%d %H:%M:%S"))
        );

        // passed Dinner cutoff
        var nextSlots = DragonJapaneseCuisine.nextTimeSlots(Date.fromString("2020-08-17 17:00:01"));
        Assert.same(
            [
                "2020-08-18 12:00:00",
                "2020-08-18 13:00:00",
                "2020-08-18 19:00:00",
                "2020-08-18 20:00:00",
            ],
            nextSlots.map(slot -> DateTools.format(slot.start, "%Y-%m-%d %H:%M:%S"))
        );
    }

    function testDayOff() {
        var nextSlots = DragonJapaneseCuisine.nextTimeSlots(Date.fromString("2020-08-17 16:59:59"));
        Assert.same(
            [
                false, // 2020-08-17 19:00:00
                false, // 2020-08-17 20:00:00
                true,  // 2020-08-18 12:00:00
                true,  // 2020-08-18 13:00:00
            ],
            nextSlots.map(slot -> slot.isOff)
        );
    }
}