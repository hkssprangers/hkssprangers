package hkssprangers.info;

typedef DiscountResult = {
    deliveryFeeDeduction:Float,
    deliverySubsidyAddition:Float,
};

class Discounts {
    static public final discounts:Array<{
        detail: String,
        isApplicable: (delivery:Delivery) -> Bool,
        apply: (delivery:Delivery) -> DiscountResult,
    }> = [
        {
            detail: "賀張家朗奪奧運男子花劍金牌，7月27日運費減 $5",
            isApplicable: delivery -> delivery.pickupTimeSlot.start.getDatePart() == "2021-07-27",
            apply: delivery -> {
                deliveryFeeDeduction: 5,
                deliverySubsidyAddition: 2.5,
            }
        },
        {
            detail: "賀何詩蓓奪奧運女子200米自由泳銀牌，7月28日運費減 $5",
            isApplicable: delivery -> delivery.pickupTimeSlot.start.getDatePart() == "2021-07-28",
            apply: delivery -> {
                deliveryFeeDeduction: 5,
                deliverySubsidyAddition: 2.5,
            }
        },
        {
            detail: "賀何詩蓓再奪奧運銀牌，7月30日運費減 $5",
            isApplicable: delivery -> delivery.pickupTimeSlot.start.getDatePart() == "2021-07-30",
            apply: delivery -> {
                deliveryFeeDeduction: 5,
                deliverySubsidyAddition: 2.5,
            }
        },
        {
            detail: "賀香港乒乓隊女團及空手道港隊代表劉慕裳各奪奧運銅牌，8月5-6日運費減 $5",
            isApplicable: delivery -> switch (delivery.pickupTimeSlot.start.getDatePart()) {
                case "2021-08-05" | "2021-08-06": true;
                case _: false;
            },
            apply: delivery -> {
                deliveryFeeDeduction: 5,
                deliverySubsidyAddition: 2.5,
            }
        },
    ];

    static public function bestDiscountResult(delivery:Delivery):Null<DiscountResult> {
        var discounts = [
            for (discount in Discounts.discounts)
            if (discount.isApplicable(delivery))
            discount.apply(delivery)
        ];
        discounts.sort((d1, d2) -> -Reflect.compare(d1, d2));
        return discounts[0];
    }
}