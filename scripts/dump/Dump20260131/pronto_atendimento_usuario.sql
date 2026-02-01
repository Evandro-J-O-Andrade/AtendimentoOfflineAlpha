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
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `login` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_conselho` int DEFAULT NULL,
  `registro_profissional` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `senha_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `seed_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `primeiro_login` tinyint(1) DEFAULT '1',
  `senha_expira_em` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `forcar_troca_senha` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `login` (`login`),
  KEY `id_pessoa` (`id_pessoa`),
  KEY `fk_usuario_conselho` (`id_conselho`),
  CONSTRAINT `fk_usuario_conselho` FOREIGN KEY (`id_conselho`) REFERENCES `conselho_profissional` (`id_conselho`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,1,'teste_user',NULL,NULL,NULL,NULL,1,1,NULL,'2026-01-12 09:10:01','2026-01-12 09:10:01',0),(2,2,'yasnanakase',NULL,NULL,'$2y$10$3m48kYSUVWW6bCl.yRDfKePrOJCXxHCB33O71VKXINpxs8dvkE7bG',NULL,1,0,NULL,'2026-01-18 08:46:10','2026-01-18 08:56:16',0),(5,5,'admin',NULL,NULL,'240be518fab243c511a34155145c0468e10ef9c1d94538d684457e3f60d7f396',NULL,1,1,NULL,'2026-01-28 02:40:56','2026-01-28 09:35:35',0),(6,6,'totem',NULL,NULL,NULL,'totem',1,0,NULL,'2026-01-28 02:40:56','2026-01-28 02:40:56',0),(9,11,'recep01',NULL,NULL,'240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',NULL,1,1,NULL,'2026-01-28 09:03:48','2026-01-28 09:03:48',0),(10,12,'enfe01',NULL,NULL,'240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',NULL,1,1,NULL,'2026-01-28 09:03:48','2026-01-28 09:03:48',0),(11,13,'med01',NULL,NULL,'240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',NULL,1,1,NULL,'2026-01-28 09:03:48','2026-01-28 09:03:48',0);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-31 20:05:19
