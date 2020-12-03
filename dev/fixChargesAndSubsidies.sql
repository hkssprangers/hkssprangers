UPDATE `order` o
SET platformServiceCharge = o.orderPrice * 0.15
WHERE o.platformServiceCharge != o.orderPrice * 0.15 AND creationTime >= "2020-11-01";

UPDATE
(
	SELECT subsidy.deliveryId, courierCount, deliverySubsidyTotal, orderCount, platformServiceChargeTotal
	FROM
	(
		SELECT d.deliveryId, COUNT(*) AS courierCount, SUM(dc.deliverySubsidy) AS deliverySubsidyTotal
		FROM delivery d
		INNER JOIN deliveryCourier dc ON d.deliveryId = dc.deliveryId
		INNER JOIN courier c ON dc.courierId = c.courierId
		WHERE d.pickupTimeSlotStart >= "2020-11-01" AND NOT d.deleted
		GROUP BY d.deliveryId
	) AS subsidy
	INNER JOIN
	(
		SELECT d.deliveryId, COUNT(*) AS orderCount, SUM(o.orderPrice) AS orderPriceTotal, SUM(o.platformServiceCharge) AS platformServiceChargeTotal
		FROM delivery d
		INNER JOIN deliveryOrder do ON d.deliveryId = do.deliveryId
		INNER JOIN `order` o ON do.orderId = o.orderId
		WHERE d.pickupTimeSlotStart >= "2020-11-01" AND NOT d.deleted
		GROUP BY d.deliveryId
	) AS charge ON subsidy.deliveryId = charge.deliveryId
	WHERE subsidy.deliverySubsidyTotal != charge.platformServiceChargeTotal * 0.5
) totals
LEFT JOIN deliveryCourier dc
ON dc.deliveryId = totals.deliveryId
SET dc.deliverySubsidy = totals.platformServiceChargeTotal * 0.5;
