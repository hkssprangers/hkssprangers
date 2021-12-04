CREATE TABLE `deliveryOrder` (
  `deliveryId` int NOT NULL,
  `orderId` int NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`deliveryId`,`orderId`),
  KEY `deliveryOrder_FK_order` (`orderId`),
  CONSTRAINT `deliveryOrder_FK_delivery` FOREIGN KEY (`deliveryId`) REFERENCES `delivery` (`deliveryId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `deliveryOrder_FK_order` FOREIGN KEY (`orderId`) REFERENCES `order` (`orderId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
