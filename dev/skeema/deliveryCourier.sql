CREATE TABLE `deliveryCourier` (
  `deliveryId` int NOT NULL,
  `courierId` int NOT NULL,
  `deliveryFee` decimal(12,4) NOT NULL,
  `deliverySubsidy` decimal(12,4) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`deliveryId`,`courierId`),
  KEY `deliveryCourier_FK_courier` (`courierId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
