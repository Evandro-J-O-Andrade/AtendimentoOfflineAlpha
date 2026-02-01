-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: pronto_atendimento
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `prescricao_kit_itens`
--

DROP TABLE IF EXISTS `prescricao_kit_itens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescricao_kit_itens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_kit` int NOT NULL,
  `item_nome` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `dose` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `frequencia` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_kit_master_link` (`id_kit`),
  CONSTRAINT `fk_kit_master_link` FOREIGN KEY (`id_kit`) REFERENCES `prescricao_kit_master` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescricao_kit_itens`
--

LOCK TABLES `prescricao_kit_itens` WRITE;
/*!40000 ALTER TABLE `prescricao_kit_itens` DISABLE KEYS */;
INSERT INTO `prescricao_kit_itens` VALUES (1,1,'SORO FISIOLOGICO 0,9%','500ML','EV','AGORA'),(2,1,'DIPIRONA 1G','2ML','EV','SE DOR/FEBRE'),(3,2,'CEFTRIAXONA 1G','2G','EV','AGORA'),(4,2,'SORO FISIOLOGICO 0,9%','1000ML','EV','IMEDIATO'),(5,2,'COLETA DE HEMOCULTURA','2 AMOSTRAS','LAB','AGORA');
/*!40000 ALTER TABLE `prescricao_kit_itens` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-31 20:04:32
