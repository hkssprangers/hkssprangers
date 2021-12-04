CREATE TABLE `receipt` (
  `receiptId` int NOT NULL AUTO_INCREMENT,
  `receiptUrl` varchar(1024) COLLATE utf8mb4_bin NOT NULL,
  `orderId` int DEFAULT NULL,
  `uploaderCourierId` int DEFAULT NULL,
  PRIMARY KEY (`receiptId`),
  KEY `receipt_order_FK` (`orderId`),
  KEY `receipt_courier_FK` (`uploaderCourierId`),
  CONSTRAINT `receipt_courier_FK` FOREIGN KEY (`uploaderCourierId`) REFERENCES `courier` (`courierId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `receipt_order_FK` FOREIGN KEY (`orderId`) REFERENCES `order` (`orderId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
