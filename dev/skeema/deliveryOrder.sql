CREATE TABLE `deliveryOrder` (
  `deliveryId` int NOT NULL,
  `orderId` int NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`deliveryId`,`orderId`),
  KEY `deliveryOrder_FK_order` (`orderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
