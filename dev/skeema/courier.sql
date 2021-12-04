CREATE TABLE `courier` (
  `courierId` int NOT NULL AUTO_INCREMENT,
  `courierTgUsername` varchar(128) COLLATE utf8mb4_bin NOT NULL,
  `courierTgId` int DEFAULT NULL,
  `paymeAvailable` tinyint(1) NOT NULL,
  `fpsAvailable` tinyint(1) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `isAdmin` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`courierId`),
  UNIQUE KEY `courier_UN_tgUsername` (`courierTgUsername`),
  UNIQUE KEY `courier_UN_tgId` (`courierTgId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
