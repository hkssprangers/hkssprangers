CREATE TABLE `order` (
  `orderId` int NOT NULL AUTO_INCREMENT,
  `creationTime` timestamp NOT NULL,
  `orderCode` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `shopId` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `orderDetails` varchar(2048) COLLATE utf8mb4_bin NOT NULL,
  `orderPrice` decimal(12,4) NOT NULL,
  `platformServiceCharge` decimal(12,4) NOT NULL,
  `wantTableware` tinyint(1) NOT NULL,
  `customerNote` varchar(2048) COLLATE utf8mb4_bin DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`orderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
