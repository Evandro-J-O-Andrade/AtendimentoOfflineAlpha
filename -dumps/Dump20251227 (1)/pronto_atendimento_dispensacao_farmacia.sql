CREATE DATABASE  IF NOT EXISTS `pronto_atendimento` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `pronto_atendimento`;
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
-- Table structure for table `dispensacao_farmacia`
--

DROP TABLE IF EXISTS `dispensacao_farmacia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dispensacao_farmacia` (
  `id_dispensacao` bigint NOT NULL AUTO_INCREMENT,
  `id_prescricao` bigint NOT NULL,
  `id_prescricao_item` bigint NOT NULL,
  `id_farmaco` bigint NOT NULL,
  `id_estoque` bigint NOT NULL,
  `quantidade_dispensada` decimal(10,2) NOT NULL,
  `id_usuario_farmaceutico` bigint NOT NULL,
  `data_hora_dispensacao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_dispensacao`),
  KEY `id_prescricao` (`id_prescricao`),
  KEY `id_prescricao_item` (`id_prescricao_item`),
  KEY `id_farmaco` (`id_farmaco`),
  KEY `id_estoque` (`id_estoque`),
  KEY `id_usuario_farmaceutico` (`id_usuario_farmaceutico`),
  CONSTRAINT `dispensacao_farmacia_ibfk_1` FOREIGN KEY (`id_prescricao`) REFERENCES `prescricao` (`id_prescricao`),
  CONSTRAINT `dispensacao_farmacia_ibfk_2` FOREIGN KEY (`id_prescricao_item`) REFERENCES `prescricao_item` (`id_item`),
  CONSTRAINT `dispensacao_farmacia_ibfk_3` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`),
  CONSTRAINT `dispensacao_farmacia_ibfk_4` FOREIGN KEY (`id_estoque`) REFERENCES `estoque_local` (`id_estoque`),
  CONSTRAINT `dispensacao_farmacia_ibfk_5` FOREIGN KEY (`id_usuario_farmaceutico`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dispensacao_farmacia`
--

LOCK TABLES `dispensacao_farmacia` WRITE;
/*!40000 ALTER TABLE `dispensacao_farmacia` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispensacao_farmacia` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_baixa_estoque_dispensacao` AFTER INSERT ON `dispensacao_farmacia` FOR EACH ROW BEGIN
    -- Subtrai a quantidade dispensada do estoque
    UPDATE estoque_local
    SET quantidade_atual = quantidade_atual - NEW.quantidade_dispensada
    WHERE id_estoque = NEW.id_estoque;
    
    -- Opcional: Adicionar lógica para alerta de estoque mínimo
    -- Se a quantidade_atual < min_estoque, insira um alerta em uma tabela de log/alerta.
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-27  2:29:35
