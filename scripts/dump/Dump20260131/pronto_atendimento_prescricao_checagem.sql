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
-- Table structure for table `prescricao_checagem`
--

DROP TABLE IF EXISTS `prescricao_checagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescricao_checagem` (
  `id_checagem` bigint NOT NULL AUTO_INCREMENT,
  `id_prescricao_item` bigint NOT NULL,
  `id_usuario_enfermeiro` bigint NOT NULL,
  `data_hora_checagem` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('ADMINISTRADO','RECUSADO','PACIENTE_AUSENTE','JEJUM') DEFAULT 'ADMINISTRADO',
  `observacao` text,
  PRIMARY KEY (`id_checagem`),
  KEY `fk_checagem_item` (`id_prescricao_item`),
  KEY `fk_checagem_usuario` (`id_usuario_enfermeiro`),
  CONSTRAINT `fk_checagem_item` FOREIGN KEY (`id_prescricao_item`) REFERENCES `prescricao_item` (`id_item`),
  CONSTRAINT `fk_checagem_usuario` FOREIGN KEY (`id_usuario_enfermeiro`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescricao_checagem`
--

LOCK TABLES `prescricao_checagem` WRITE;
/*!40000 ALTER TABLE `prescricao_checagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_checagem` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_pos_checagem_integrada` AFTER INSERT ON `prescricao_checagem` FOR EACH ROW BEGIN
    -- 1. Só integra se o status for 'ADMINISTRADO'
    IF NEW.status = 'ADMINISTRADO' THEN
        
        -- A) LANÇAR NO FATURAMENTO (Gera receita para o Hospital)
        -- Busca o id_atendimento através da hierarquia de tabelas
        INSERT INTO conta_paciente_itens (id_atendimento, descricao, valor, data_lancamento)
        SELECT pr.id_atendimento, pi.descricao, 0.00, NOW() -- Valor 0.00 para ser precificado pelo faturamento
        FROM prescricao_item pi
        JOIN prescricao_continua pr ON pi.id_prescricao = pr.id_prescricao
        WHERE pi.id_item = NEW.id_prescricao_item;

        -- B) REGISTRAR PARA A FARMÁCIA (Histórico de consumo)
        -- Aqui você pode inserir na sua tabela de 'ffa_medicacao_administrada' se preferir
        INSERT INTO log_auditoria (id_usuario, acao, tabela_afetada, id_registro, comentario)
        VALUES (NEW.id_usuario_enfermeiro, 'MEDICACAO_ADMINISTRADA', 'prescricao_item', NEW.id_prescricao_item, 'Baixa automática via checagem beira-leito');

    END IF;
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

-- Dump completed on 2026-01-31 20:05:22
