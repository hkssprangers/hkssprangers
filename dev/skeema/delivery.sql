CREATE TABLE `delivery` (
  `deliveryId` int unsigned NOT NULL AUTO_INCREMENT,
  `creationTime` timestamp NOT NULL,
  `deliveryCode` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `pickupLocation` varchar(1024) COLLATE utf8mb4_bin NOT NULL,
  `deliveryFee` decimal(12,4) DEFAULT NULL,
  `pickupTimeSlotStart` timestamp NOT NULL,
  `pickupTimeSlotEnd` timestamp NOT NULL,
  `pickupMethod` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `paymeAvailable` tinyint(1) NOT NULL,
  `fpsAvailable` tinyint(1) NOT NULL,
  `customerTgUsername` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `customerTgId` int DEFAULT NULL,
  `customerTel` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `customerWhatsApp` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `customerSignal` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `customerPreferredContactMethod` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `customerBackupContactMethod` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `customerNote` varchar(2048) COLLATE utf8mb4_bin DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`deliveryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
