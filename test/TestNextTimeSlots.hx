import utest.Assert;
import hkssprangers.info.Shop;

class TestNextTimeSlots extends utest.Test {
    function test20200815234900() {
        var nextSlots = DragonJapaneseCuisine.nextTimeSlots(Date.fromString("2020-08-15 23:49:00"));
        Assert.same(
            [
                "2020-08-16 12:30:00",
                "2020-08-16 13:30:00",
                "2020-08-16 18:30:00",
                "2020-08-16 19:30:00",
            ],
            nextSlots.map(slot -> DateTools.format(slot.start, "%Y-%m-%d %H:%M:%S"))
        );
    }

    function testLunchCutoff() {
        // before Lunch cutoff
        var nextSlots = DragonJapaneseCuisine.nextTimeSlots(Date.fromString("2020-08-17 09:59:59"));
        Assert.same(
            [
                "2020-08-17 12:30:00",
                "2020-08-17 13:30:00",
                "2020-08-17 18:30:00",
                "2020-08-17 19:30:00",
            ],
            nextSlots.map(slot -> DateTools.format(slot.start, "%Y-%m-%d %H:%M:%S"))
        );

        // passed Lunch cutoff
        var nextSlots = DragonJapaneseCuisine.nextTimeSlots(Date.fromString("2020-08-17 10:00:01"));
        Assert.same(
            [
                "2020-08-17 18:30:00",
                "2020-08-17 19:30:00",
                "2020-08-18 12:30:00",
                "2020-08-18 13:30:00",
            ],
            nextSlots.map(slot -> DateTools.format(slot.start, "%Y-%m-%d %H:%M:%S"))
        );
    }

    function testDinnerCutoff() {
        // before Dinner cutoff
        var nextSlots = DragonJapaneseCuisine.nextTimeSlots(Date.fromString("2020-08-17 16:59:59"));
        Assert.same(
            [
                "2020-08-17 18:30:00",
                "2020-08-17 19:30:00",
                "2020-08-18 12:30:00",
                "2020-08-18 13:30:00",
            ],
            nextSlots.map(slot -> DateTools.format(slot.start, "%Y-%m-%d %H:%M:%S"))
        );

        // passed Dinner cutoff
        var nextSlots = DragonJapaneseCuisine.nextTimeSlots(Date.fromString("2020-08-17 17:00:01"));
        Assert.same(
            [
                "2020-08-18 12:30:00",
                "2020-08-18 13:30:00",
                "2020-08-18 18:30:00",
                "2020-08-18 19:30:00",
            ],
            nextSlots.map(slot -> DateTools.format(slot.start, "%Y-%m-%d %H:%M:%S"))
        );
    }

    function testDayOff() {
        var nextSlots = DragonJapaneseCuisine.nextTimeSlots(Date.fromString("2020-08-17 16:59:59"));
        Assert.same(
            [
                false, // 2020-08-17 18:30:00
                false, // 2020-08-17 19:30:00
                true,  // 2020-08-18 12:30:00
                true,  // 2020-08-18 13:30:00
            ],
            nextSlots.map(slot -> slot.isOff)
        );
    }
}