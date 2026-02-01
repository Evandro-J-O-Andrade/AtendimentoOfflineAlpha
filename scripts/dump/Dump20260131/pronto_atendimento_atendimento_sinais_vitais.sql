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
-- Table structure for table `atendimento_sinais_vitais`
--

DROP TABLE IF EXISTS `atendimento_sinais_vitais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_sinais_vitais` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_usuario_registro` bigint NOT NULL,
  `pa_sistolica` int DEFAULT NULL,
  `pa_diastolica` int DEFAULT NULL,
  `frequencia_cardiaca` int DEFAULT NULL,
  `frequencia_respiratoria` int DEFAULT NULL,
  `temperatura` decimal(4,1) DEFAULT NULL,
  `saturacao_o2` int DEFAULT NULL,
  `hgt` int DEFAULT NULL,
  `data_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_sv_atendimento` (`id_atendimento`),
  CONSTRAINT `fk_sv_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_sinais_vitais`
--

LOCK TABLES `atendimento_sinais_vitais` WRITE;
/*!40000 ALTER TABLE `atendimento_sinais_vitais` DISABLE KEYS */;
INSERT INTO `atendimento_sinais_vitais` VALUES (2,3,5,120,80,NULL,NULL,36.5,98,NULL,'2026-01-28 06:20:16'),(3,4,5,120,80,NULL,NULL,36.5,98,NULL,'2026-01-28 06:20:42'),(4,5,5,120,80,NULL,NULL,36.5,98,NULL,'2026-01-28 06:21:25'),(5,6,5,120,80,NULL,NULL,36.5,98,NULL,'2026-01-28 06:21:57');
/*!40000 ALTER TABLE `atendimento_sinais_vitais` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-31 20:05:49
