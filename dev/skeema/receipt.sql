CREATE TABLE `receipt` (
  `receiptId` int NOT NULL AUTO_INCREMENT,
  `receiptUrl` varchar(1024) COLLATE utf8mb4_bin NOT NULL,
  `orderId` int DEFAULT NULL,
  `uploaderCourierId` int DEFAULT NULL,
  PRIMARY KEY (`receiptId`),
  KEY `receipt_order_FK` (`orderId`),
  KEY `receipt_courier_FK` (`uploaderCourierId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
