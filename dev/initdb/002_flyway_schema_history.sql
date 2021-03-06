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
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `flyway_schema_history`
--

LOCK TABLES `flyway_schema_history` WRITE;
/*!40000 ALTER TABLE `flyway_schema_history` DISABLE KEYS */;
INSERT INTO `flyway_schema_history` VALUES (1,'1','<< Flyway Baseline >>','BASELINE','<< Flyway Baseline >>',NULL,'root','2020-11-03 10:09:13',0,1);
INSERT INTO `flyway_schema_history` VALUES (2,'2','googleFormImport','SQL','V2__googleFormImport.sql',1238516856,'root','2020-11-07 13:33:33',18,1);
INSERT INTO `flyway_schema_history` VALUES (3,'3','relaxDeliveryTable','SQL','V3__relaxDeliveryTable.sql',981322026,'root','2020-11-08 09:50:56',107,1);
INSERT INTO `flyway_schema_history` VALUES (4,'4','addDeletedFields','SQL','V4__addDeletedFields.sql',-1967513684,'root','2020-11-09 09:34:47',102,1);
INSERT INTO `flyway_schema_history` VALUES (5,'5','tgMessage','SQL','V5__tgMessage.sql',-849229782,'ssp','2020-11-16 04:05:36',832,1);
INSERT INTO `flyway_schema_history` VALUES (6,'6','tgMessage updateData','SQL','V6__tgMessage_updateData.sql',-348417920,'ssp','2020-11-17 08:32:37',1449,1);
INSERT INTO `flyway_schema_history` VALUES (7,'7','isAdmin','SQL','V7__isAdmin.sql',-684888593,'ssp','2020-11-28 05:03:45',861,1);
INSERT INTO `flyway_schema_history` VALUES (8,'8','receiptTable','SQL','V8__receiptTable.sql',-1443645347,'ssp','2020-12-16 17:40:23',445,1);
INSERT INTO `flyway_schema_history` VALUES (9,'9','contacts','SQL','V9__contacts.sql',1097319996,'ssp','2021-04-03 17:03:56',1559,1);
INSERT INTO `flyway_schema_history` VALUES (10,'10','tgMessage indexes','SQL','V10__tgMessage_indexes.sql',2096343071,'ssp','2021-04-12 19:38:02',2860,1);
INSERT INTO `flyway_schema_history` VALUES (11,'11','twilioMessage','SQL','V11__twilioMessage.sql',1635964122,'ssp','2021-04-20 17:49:43',1094,1);
/*!40000 ALTER TABLE `flyway_schema_history` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-06-14 19:08:43
