-- MariaDB dump 10.19  Distrib 10.5.10-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: first.cjqctxdxmaiu.ap-southeast-1.rds.amazonaws.com    Database: hkssprangers
-- ------------------------------------------------------
-- Server version	8.0.23

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
-- Current Database: `hkssprangers`
--

/*!40000 DROP DATABASE IF EXISTS `hkssprangers`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `hkssprangers` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `hkssprangers`;

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
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `isAdmin` tinyint(1) NOT NULL DEFAULT '0',
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
  `deliveryCode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `pickupLocation` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `deliveryFee` decimal(12,4) DEFAULT NULL,
  `pickupTimeSlotStart` timestamp NOT NULL,
  `pickupTimeSlotEnd` timestamp NOT NULL,
  `pickupMethod` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `paymeAvailable` tinyint(1) NOT NULL,
  `fpsAvailable` tinyint(1) NOT NULL,
  `customerTgUsername` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `customerTgId` int DEFAULT NULL,
  `customerTel` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `customerWhatsApp` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `customerSignal` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `customerPreferredContactMethod` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `customerBackupContactMethod` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `customerNote` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
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
  `deliveryFee` decimal(12,4) NOT NULL,
  `deliverySubsidy` decimal(12,4) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
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
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`deliveryId`,`orderId`),
  KEY `deliveryOrder_FK_order` (`orderId`),
  CONSTRAINT `deliveryOrder_FK_delivery` FOREIGN KEY (`deliveryId`) REFERENCES `delivery` (`deliveryId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `deliveryOrder_FK_order` FOREIGN KEY (`orderId`) REFERENCES `order` (`orderId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `flyway_schema_history`
--

DROP TABLE IF EXISTS `flyway_schema_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flyway_schema_history` (
  `installed_rank` int NOT NULL,
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `script` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `checksum` int DEFAULT NULL,
  `installed_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `execution_time` int NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`),
  KEY `flyway_schema_history_s_idx` (`success`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `googleFormImport`
--

DROP TABLE IF EXISTS `googleFormImport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `googleFormImport` (
  `importTime` timestamp NOT NULL,
  `spreadsheetId` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `lastRow` int unsigned NOT NULL,
  PRIMARY KEY (`importTime`,`spreadsheetId`)
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
  `orderCode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `shopId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `orderDetails` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `orderPrice` decimal(12,4) NOT NULL,
  `platformServiceCharge` decimal(12,4) NOT NULL,
  `wantTableware` tinyint(1) NOT NULL,
  `customerNote` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`orderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `receipt`
--

DROP TABLE IF EXISTS `receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `receipt` (
  `receiptId` int NOT NULL AUTO_INCREMENT,
  `receiptUrl` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `orderId` int DEFAULT NULL,
  `uploaderCourierId` int DEFAULT NULL,
  PRIMARY KEY (`receiptId`),
  KEY `receipt_order_FK` (`orderId`),
  KEY `receipt_courier_FK` (`uploaderCourierId`),
  CONSTRAINT `receipt_courier_FK` FOREIGN KEY (`uploaderCourierId`) REFERENCES `courier` (`courierId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `receipt_order_FK` FOREIGN KEY (`orderId`) REFERENCES `order` (`orderId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tgMessage`
--

DROP TABLE IF EXISTS `tgMessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tgMessage` (
  `tgMessageId` int NOT NULL AUTO_INCREMENT,
  `receiverId` int NOT NULL,
  `messageData` json DEFAULT NULL,
  `updateType` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `updateData` json DEFAULT NULL,
  PRIMARY KEY (`tgMessageId`),
  KEY `receiverId` (`receiverId`),
  KEY `updateId` ((json_value(`updateData`, _utf8mb4'$.update_id' returning signed))),
  KEY `messageId` ((json_value(`updateData`, _utf8mb4'$.message.message_id' returning signed))),
  KEY `messageDate` ((json_value(`updateData`, _utf8mb4'$.message.date' returning signed))),
  KEY `messageChatId` ((json_value(`updateData`, _utf8mb4'$.message.chat.id' returning signed))),
  KEY `messageFromId` ((json_value(`updateData`, _utf8mb4'$.message.from.id' returning signed)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `twilioMessage`
--

DROP TABLE IF EXISTS `twilioMessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `twilioMessage` (
  `twilioMessageId` int NOT NULL AUTO_INCREMENT,
  `creationTime` timestamp NOT NULL,
  `data` json NOT NULL,
  PRIMARY KEY (`twilioMessageId`),
  KEY `_To` ((json_value(`data`, _utf8mb4'$.To' returning char(512)))),
  KEY `_From` ((json_value(`data`, _utf8mb4'$.From' returning char(512)))),
  KEY `_AccountSid` ((json_value(`data`, _utf8mb4'$.AccountSid' returning char(512)))),
  KEY `_MessageSid` ((json_value(`data`, _utf8mb4'$.MessageSid' returning char(512))))
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

-- Dump completed on 2021-06-14 19:08:42
