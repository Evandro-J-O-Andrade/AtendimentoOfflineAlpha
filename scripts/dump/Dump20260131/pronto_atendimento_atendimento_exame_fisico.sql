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
-- Table structure for table `atendimento_exame_fisico`
--

DROP TABLE IF EXISTS `atendimento_exame_fisico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_exame_fisico` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `estado_geral` enum('BOM','REGULAR','GRAVE','MUITO_GRAVE') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nivel_consciencia` enum('LUCIDO','ORIENTADO','CONFUSO','SONOLENTO','TORPOROSO','COMA') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mucosas` enum('CORADAS','HIPOCORADAS','DESIDRATADAS','ICTERICAS') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `estado_nutricional` enum('EUTROFICO','CAQUETICO','OBESO') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edema` enum('AUSENTE','MEMBROS_INFERIORES','ANASARCA','FACIAL') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `observacoes_adicionais` text COLLATE utf8mb4_general_ci,
  `data_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_exame_fisico_atend` (`id_atendimento`),
  CONSTRAINT `fk_exame_fisico_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_exame_fisico`
--

LOCK TABLES `atendimento_exame_fisico` WRITE;
/*!40000 ALTER TABLE `atendimento_exame_fisico` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_exame_fisico` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-31 20:05:16
