-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: db0309
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `견적`
--

DROP TABLE IF EXISTS `견적`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `견적` (
  `견적번호` varchar(20) NOT NULL,
  `공급가액` int DEFAULT NULL,
  `부가세` int DEFAULT NULL,
  `총계` int DEFAULT NULL,
  `비고` varchar(50) DEFAULT NULL,
  `공급자_등록번호` varchar(20) NOT NULL,
  PRIMARY KEY (`견적번호`),
  KEY `fk_견적_공급자_idx` (`공급자_등록번호`),
  CONSTRAINT `fk_견적_공급자` FOREIGN KEY (`공급자_등록번호`) REFERENCES `공급자` (`등록번호`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `견적`
--

LOCK TABLES `견적` WRITE;
/*!40000 ALTER TABLE `견적` DISABLE KEYS */;
INSERT INTO `견적` VALUES ('1-1',NULL,NULL,NULL,'aaaaa','2023-1');
/*!40000 ALTER TABLE `견적` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `견적세부내역`
--

DROP TABLE IF EXISTS `견적세부내역`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `견적세부내역` (
  `수량` int NOT NULL,
  `금액` int NOT NULL,
  `견적_견적번호` varchar(20) NOT NULL,
  `상품_품명` varchar(20) NOT NULL,
  KEY `fk_견적세부내역_견적1_idx` (`견적_견적번호`),
  KEY `fk_견적세부내역_상품1_idx` (`상품_품명`),
  CONSTRAINT `fk_견적세부내역_견적1` FOREIGN KEY (`견적_견적번호`) REFERENCES `견적` (`견적번호`),
  CONSTRAINT `fk_견적세부내역_상품1` FOREIGN KEY (`상품_품명`) REFERENCES `상품` (`품명`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `견적세부내역`
--

LOCK TABLES `견적세부내역` WRITE;
/*!40000 ALTER TABLE `견적세부내역` DISABLE KEYS */;
INSERT INTO `견적세부내역` VALUES (2,3000,'1-1','c'),(3,1000,'1-1','a'),(1,2000,'1-1','b'),(6,4000,'1-1','d'),(4,5000,'1-1','e');
/*!40000 ALTER TABLE `견적세부내역` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `공급자`
--

DROP TABLE IF EXISTS `공급자`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `공급자` (
  `등록번호` varchar(20) NOT NULL,
  `상호` varchar(10) NOT NULL,
  `대표성명` varchar(10) DEFAULT NULL,
  `사업장주소` varchar(20) DEFAULT NULL,
  `업태` varchar(10) DEFAULT NULL,
  `종목` varchar(10) DEFAULT NULL,
  `전화번호` varchar(20) NOT NULL,
  PRIMARY KEY (`등록번호`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `공급자`
--

LOCK TABLES `공급자` WRITE;
/*!40000 ALTER TABLE `공급자` DISABLE KEYS */;
INSERT INTO `공급자` VALUES ('2023-1','aa','a','a -a -a -a','a','a','010-1111-1111'),('2023-2','bb','b','b -b -b -b','b','b','010-2222-2222');
/*!40000 ALTER TABLE `공급자` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `상품`
--

DROP TABLE IF EXISTS `상품`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `상품` (
  `품명` varchar(20) NOT NULL,
  `규격` varchar(20) DEFAULT NULL,
  `단가` int NOT NULL,
  PRIMARY KEY (`품명`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `상품`
--

LOCK TABLES `상품` WRITE;
/*!40000 ALTER TABLE `상품` DISABLE KEYS */;
INSERT INTO `상품` VALUES ('a','10',1000),('b','20',1000),('c','30',1000),('d','40',1000),('e','50',1000);
/*!40000 ALTER TABLE `상품` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'db0309'
--

--
-- Dumping routines for database 'db0309'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-03-09 17:52:52
