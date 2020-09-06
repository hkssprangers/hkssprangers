-- MariaDB dump 10.17  Distrib 10.5.5-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: mysql    Database: hkssprangers
-- ------------------------------------------------------
-- Server version	8.0.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `courier`
--

DROP TABLE IF EXISTS `courier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courier` (
  `courierId` int NOT NULL AUTO_INCREMENT,
  `courierTgUsername` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `courierTgId` int DEFAULT NULL,
  `paymeAvailable` tinyint(1) NOT NULL,
  `fpsAvailable` tinyint(1) NOT NULL,
  PRIMARY KEY (`courierId`),
  UNIQUE KEY `courier_UN_tgUsername` (`courierTgUsername`),
  UNIQUE KEY `courier_UN_tgId` (`courierTgId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `delivery`
--

DROP TABLE IF EXISTS `delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delivery` (
  `deliveryId` int NOT NULL AUTO_INCREMENT,
  `creationTime` timestamp NOT NULL,
  `pickupLocation` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pickupTimeSlotStart` timestamp NOT NULL,
  `pickupTimeSlotEnd` timestamp NOT NULL,
  `pickupMethod` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `paymeAvailable` tinyint(1) NOT NULL,
  `fpsAvailable` tinyint(1) NOT NULL,
  `customerTgUsername` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `customerTgId` int DEFAULT NULL,
  `customerTel` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `customerNote` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`deliveryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `deliveryCourier`
--

DROP TABLE IF EXISTS `deliveryCourier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deliveryCourier` (
  `deliveryId` int NOT NULL,
  `courierId` int NOT NULL,
  `deliveryFee` decimal(5,2) NOT NULL,
  PRIMARY KEY (`deliveryId`,`courierId`),
  KEY `deliveryCourier_FK_courier` (`courierId`),
  CONSTRAINT `deliveryCourier_FK_courier` FOREIGN KEY (`courierId`) REFERENCES `courier` (`courierId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `deliveryCourier_FK_delivery` FOREIGN KEY (`deliveryId`) REFERENCES `delivery` (`deliveryId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `deliveryOrder`
--

DROP TABLE IF EXISTS `deliveryOrder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deliveryOrder` (
  `deliveryId` int NOT NULL,
  `orderId` int NOT NULL,
  PRIMARY KEY (`deliveryId`,`orderId`),
  KEY `deliveryOrder_FK_order` (`orderId`),
  CONSTRAINT `deliveryOrder_FK_delivery` FOREIGN KEY (`deliveryId`) REFERENCES `delivery` (`deliveryId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `deliveryOrder_FK_order` FOREIGN KEY (`orderId`) REFERENCES `order` (`orderId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order` (
  `orderId` int NOT NULL AUTO_INCREMENT,
  `creationTime` timestamp NOT NULL,
  `orderCode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `shopId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `orderDetails` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `orderPrice` decimal(5,2) NOT NULL,
  `wantTableware` tinyint(1) NOT NULL,
  `customerNote` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`orderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-09-06  5:05:15
