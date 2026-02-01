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
-- Table structure for table `dispensacao_medicacao`
--

DROP TABLE IF EXISTS `dispensacao_medicacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dispensacao_medicacao` (
  `id_dispensacao` bigint NOT NULL AUTO_INCREMENT,
  `id_ordem` bigint NOT NULL,
  `id_farmaco` bigint NOT NULL,
  `id_lote` bigint NOT NULL,
  `quantidade` decimal(10,2) NOT NULL,
  `id_usuario_dispensador` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('ENTREGUE','ESTORNADO') DEFAULT 'ENTREGUE',
  PRIMARY KEY (`id_dispensacao`),
  KEY `fk_disp_ordem` (`id_ordem`),
  KEY `fk_disp_lote` (`id_lote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dispensacao_medicacao`
--

LOCK TABLES `dispensacao_medicacao` WRITE;
/*!40000 ALTER TABLE `dispensacao_medicacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispensacao_medicacao` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_pos_dispensacao_processo` AFTER INSERT ON `dispensacao_medicacao` FOR EACH ROW BEGIN
    DECLARE v_id_ffa BIGINT;
    DECLARE v_valor_unitario DECIMAL(10,2);
    DECLARE v_nome_medicamento VARCHAR(200);

    -- 1. Baixa automática no estoque local (pelo lote selecionado)
    UPDATE estoque_local el
    JOIN farmaco_lote fl ON fl.id_farmaco = el.id_farmaco
    SET el.quantidade_atual = el.quantidade_atual - NEW.quantidade
    WHERE fl.id_lote = NEW.id_lote;

    -- 2. Busca dados para o faturamento
    SELECT id_ffa INTO v_id_ffa FROM ordem_assistencial WHERE id = NEW.id_ordem;
    SELECT nome_comercial, preco_venda INTO v_nome_medicamento, v_valor_unitario 
    FROM farmaco WHERE id_farmaco = NEW.id_farmaco;

    -- 3. Lançamento automático no faturamento (Garante que o hospital não perca dinheiro)
    INSERT INTO faturamento_item (origem, id_origem, descricao, quantidade, valor_unitario, valor_total, id_ffa, criado_por, status)
    VALUES ('MEDICACAO', NEW.id_dispensacao, v_nome_medicamento, NEW.quantidade, v_valor_unitario, (NEW.quantidade * v_valor_unitario), v_id_ffa, NEW.id_usuario_dispensador, 'ABERTO');

    -- 4. Registro na Auditoria Central
    INSERT INTO log_auditoria (id_usuario, acao, tabela_afetada, id_registro, comentario)
    VALUES (NEW.id_usuario_dispensador, 'DISPENSACAO', 'estoque_local', NEW.id_lote, CONCAT('Baixa automática via dispensação ID: ', NEW.id_dispensacao));

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

-- Dump completed on 2026-01-31 20:05:17
