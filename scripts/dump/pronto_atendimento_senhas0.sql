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
-- Table structure for table `senhas`
--

DROP TABLE IF EXISTS `senhas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `senhas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `numero` int NOT NULL,
  `prefixo` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_atendimento` enum('CLINICO','PEDIATRICO','PRIORITARIO','EMERGENCIA','VISITA','EXAME') COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('GERADA','EM_FILA','CHAMADA','EM_ATENDIMENTO_RECEPCAO','ATENDIDA','NAO_COMPARECEU','CANCELADA','EXPIRADA') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'GERADA',
  `origem` enum('TOTEM','RECEPCAO','ADMIN') COLLATE utf8mb4_general_ci NOT NULL,
  `guiche_chamada` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_usuario_chamada` bigint DEFAULT NULL,
  `prioridade` tinyint(1) DEFAULT '0',
  `criada_em` datetime NOT NULL,
  `chamada_em` datetime DEFAULT NULL,
  `atendida_em` datetime DEFAULT NULL,
  `cancelada_em` datetime DEFAULT NULL,
  `observacao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_tipo` (`tipo_atendimento`),
  KEY `idx_criada_em` (`criada_em`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `senhas`
--

LOCK TABLES `senhas` WRITE;
/*!40000 ALTER TABLE `senhas` DISABLE KEYS */;
INSERT INTO `senhas` VALUES (1,1,'C','CLINICO','EM_FILA','RECEPCAO',NULL,NULL,0,'2026-01-14 03:46:49',NULL,NULL,NULL,NULL),(2,2,'C','CLINICO','EM_FILA','RECEPCAO',NULL,NULL,0,'2026-01-14 03:49:53',NULL,NULL,NULL,NULL),(3,9999,'TST','CLINICO','GERADA','ADMIN',NULL,NULL,1,'2026-01-14 05:03:05',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `senhas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-25 23:10:34
