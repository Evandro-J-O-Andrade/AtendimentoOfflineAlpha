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
-- Table structure for table `local_operacional`
--

DROP TABLE IF EXISTS `local_operacional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `local_operacional` (
  `id_local_operacional` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `id_sistema` bigint NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `tipo` enum('RECEPCAO','TRIAGEM','MEDICO_CLINICO','MEDICO_PEDIATRICO','MEDICACAO','RX','LABORATORIO','ECG','OBSERVACAO','INTERNACAO','FARMACIA','TI','MANUTENCAO','ENG_CLINICA','GASOTERAPIA','ASSIST_SOCIAL','SALA_NOTIFICACAO','ADMIN','OUTRO') NOT NULL DEFAULT 'OUTRO',
  `sala` varchar(50) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_local_operacional`),
  UNIQUE KEY `uk_localop` (`id_unidade`,`id_sistema`,`codigo`),
  KEY `idx_localop_unidade` (`id_unidade`),
  KEY `idx_localop_sistema` (`id_sistema`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `local_operacional`
--

LOCK TABLES `local_operacional` WRITE;
/*!40000 ALTER TABLE `local_operacional` DISABLE KEYS */;
INSERT INTO `local_operacional` VALUES (1,2,4,'ADM01','Administração','ADMIN',NULL,1,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(2,2,4,'REC01','Recepção','RECEPCAO',NULL,1,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(3,2,4,'TRI01','Triagem','TRIAGEM',NULL,1,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(4,2,4,'MEDC1','Médico Clínico','MEDICO_CLINICO',NULL,1,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(5,2,4,'MEDP1','Médico Pediátrico','MEDICO_PEDIATRICO',NULL,1,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(6,2,4,'TOT01','Totem','OUTRO',NULL,1,'2026-01-27 23:40:56','2026-01-27 23:40:56');
/*!40000 ALTER TABLE `local_operacional` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-31 20:04:54
