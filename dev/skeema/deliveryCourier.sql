CREATE TABLE `deliveryCourier` (
  `deliveryId` int NOT NULL,
  `courierId` int NOT NULL,
  `deliveryFee` decimal(12,4) NOT NULL,
  `deliverySubsidy` decimal(12,4) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`deliveryId`,`courierId`),
  KEY `deliveryCourier_FK_courier` (`courierId`),
  CONSTRAINT `deliveryCourier_FK_courier` FOREIGN KEY (`courierId`) REFERENCES `courier` (`courierId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `deliveryCourier_FK_delivery` FOREIGN KEY (`deliveryId`) REFERENCES `delivery` (`deliveryId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
