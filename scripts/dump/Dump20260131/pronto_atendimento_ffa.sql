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
-- Table structure for table `ffa`
--

DROP TABLE IF EXISTS `ffa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ffa` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `id_paciente` bigint NOT NULL,
  `gpat` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO','MEDICACAO','AGUARDANDO_MEDICACAO','AGUARDANDO_RX','EM_RX','AGUARDANDO_COLETA','EM_COLETA','AGUARDANDO_ECG','EM_ECG','ALTA','TRANSFERENCIA','INTERNACAO','FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `layout` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_usuario_criacao` bigint NOT NULL,
  `id_usuario_alteracao` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  `classificacao_manchester` enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `linha_assistencial` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_senha` bigint DEFAULT NULL,
  `classificacao_cor` enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tempo_limite` datetime DEFAULT NULL,
  `data_criacao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ffa_classificacao` (`classificacao_cor`,`status`),
  KEY `fk_ffa_atendimento` (`id_atendimento`),
  KEY `idx_ffa_status_cor` (`status`,`classificacao_cor`),
  KEY `idx_ffa_status` (`status`),
  CONSTRAINT `fk_ffa_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ffa`
--

LOCK TABLES `ffa` WRITE;
/*!40000 ALTER TABLE `ffa` DISABLE KEYS */;
INSERT INTO `ffa` VALUES (1,NULL,1,NULL,'ABERTO','CLINICO',10,NULL,'2026-01-14 03:52:41','2026-01-14 03:52:41',NULL,NULL,2,NULL,NULL,'2026-01-28 06:35:38'),(2,3,8,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:20:16',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38'),(3,4,8,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:20:42',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38'),(4,5,8,NULL,'EM_TRIAGEM',NULL,5,NULL,'2026-01-28 06:21:25',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38'),(5,6,1,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:21:57',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38'),(6,7,8,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:22:20',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38'),(7,8,1,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:22:54',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38'),(8,9,8,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:26:06',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38'),(9,10,31,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:29:42',NULL,NULL,NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38'),(10,11,17,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:30:20',NULL,NULL,NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38'),(11,12,17,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:31:19',NULL,NULL,NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38');
/*!40000 ALTER TABLE `ffa` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_auditoria_ffa_insert` AFTER INSERT ON `ffa` FOR EACH ROW BEGIN
    INSERT INTO log_auditoria(
        id_usuario, acao, tabela_afetada, id_registro, antes, depois, data_hora
    )
    VALUES (
        NEW.id_usuario_criacao,
        'INSERT',
        'ffa',
        NEW.id,
        NULL,
        CONCAT('status: ', NEW.status, ', paciente: ', NEW.id_paciente),
        NOW()
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_bloqueia_ffa_finalizada` BEFORE UPDATE ON `ffa` FOR EACH ROW BEGIN
    IF OLD.status IN ('ALTA','TRANSFERENCIA') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Não é possível alterar uma FFA finalizada';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_ffa_classificacao_tempo` BEFORE UPDATE ON `ffa` FOR EACH ROW BEGIN
    -- Só calcula se a cor foi alterada ou definida agora
    IF (OLD.classificacao_cor IS NULL AND NEW.classificacao_cor IS NOT NULL) 
       OR (OLD.classificacao_cor <> NEW.classificacao_cor) THEN
        
        SET NEW.tempo_limite = CASE 
            WHEN NEW.classificacao_cor = 'VERMELHO' THEN NOW() -- Imediato
            WHEN NEW.classificacao_cor = 'LARANJA'  THEN DATE_ADD(NOW(), INTERVAL 10 MINUTE)
            WHEN NEW.classificacao_cor = 'AMARELO'  THEN DATE_ADD(NOW(), INTERVAL 60 MINUTE)
            WHEN NEW.classificacao_cor = 'VERDE'    THEN DATE_ADD(NOW(), INTERVAL 120 MINUTE)
            WHEN NEW.classificacao_cor = 'AZUL'     THEN DATE_ADD(NOW(), INTERVAL 240 MINUTE)
            ELSE NULL
        END;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_ffa_emergencia_maxima` BEFORE UPDATE ON `ffa` FOR EACH ROW BEGIN
    -- Se o status mudar para EMERGENCIA, força a cor vermelha e tempo imediato
    IF NEW.status = 'EMERGENCIA' THEN
        SET NEW.classificacao_cor = 'VERMELHO';
        SET NEW.tempo_limite = NOW();
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_travar_alta_exame_pendente` BEFORE UPDATE ON `ffa` FOR EACH ROW BEGIN
    DECLARE v_pendentes INT;
    
    IF NEW.status = 'ALTA' THEN
        SELECT COUNT(*) INTO v_pendentes 
        FROM exame_item 
        WHERE id_atendimento = NEW.id_atendimento AND status <> 'FINALIZADO';
        
        IF v_pendentes > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Não é possível dar alta: existem exames pendentes no laboratório/RX.';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_ffa_calcula_prazo` BEFORE UPDATE ON `ffa` FOR EACH ROW BEGIN
    -- Se a cor mudar, o banco recalcula o tempo limite sozinho
    IF NEW.classificacao_cor <> OLD.classificacao_cor OR OLD.classificacao_cor IS NULL THEN
        SET NEW.tempo_limite = CASE 
            WHEN NEW.classificacao_cor = 'VERMELHO' THEN NOW()
            WHEN NEW.classificacao_cor = 'LARANJA'  THEN DATE_ADD(NOW(), INTERVAL 10 MINUTE)
            WHEN NEW.classificacao_cor = 'AMARELO'  THEN DATE_ADD(NOW(), INTERVAL 60 MINUTE)
            WHEN NEW.classificacao_cor = 'VERDE'    THEN DATE_ADD(NOW(), INTERVAL 120 MINUTE)
            ELSE DATE_ADD(NOW(), INTERVAL 240 MINUTE)
        END;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_audit_status_ffa` AFTER UPDATE ON `ffa` FOR EACH ROW BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO ffa_historico_status (id_ffa, status_anterior, status_novo, id_usuario_acao)
        VALUES (NEW.id, OLD.status, NEW.status, NEW.id_usuario_alteracao);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_audit_ffa_update` AFTER UPDATE ON `ffa` FOR EACH ROW BEGIN
    -- Só grava se houver mudança real de status ou classificação
    IF OLD.status <> NEW.status OR OLD.classificacao_cor <> NEW.classificacao_cor THEN
        INSERT INTO auditoria_mestre (
            id_sessao, 
            dominio, 
            acao, 
            tabela_afetada, 
            id_registro, 
            valor_anterior, 
            valor_novo
        )
        VALUES (
            -- Pegamos o ID da última sessão ativa do usuário que alterou
            (SELECT id FROM sessao_operacional WHERE id_usuario = NEW.id_usuario_alteracao ORDER BY id DESC LIMIT 1),
            'ASSISTENCIAL',
            'UPDATE_STATUS',
            'ffa',
            NEW.id,
            JSON_OBJECT('status', OLD.status, 'cor', OLD.classificacao_cor),
            JSON_OBJECT('status', NEW.status, 'cor', NEW.classificacao_cor)
        );
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

-- Dump completed on 2026-01-31 20:04:51
