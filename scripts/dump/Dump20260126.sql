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
-- Table structure for table `acompanhante`
--

DROP TABLE IF EXISTS `acompanhante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `acompanhante` (
  `id_acompanhante` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `id_ffa` bigint NOT NULL,
  `tipo` enum('PAI','MAE','RESPONSAVEL_LEGAL','ACOMPANHANTE','OUTRO') COLLATE utf8mb4_general_ci NOT NULL,
  `observacao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_acompanhante`),
  UNIQUE KEY `uk_acompanhante_por_ffa` (`id_pessoa`,`id_ffa`),
  KEY `id_ffa` (`id_ffa`),
  CONSTRAINT `acompanhante_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`),
  CONSTRAINT `acompanhante_ibfk_2` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acompanhante`
--

LOCK TABLES `acompanhante` WRITE;
/*!40000 ALTER TABLE `acompanhante` DISABLE KEYS */;
/*!40000 ALTER TABLE `acompanhante` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `administracao_medicacao`
--

DROP TABLE IF EXISTS `administracao_medicacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administracao_medicacao` (
  `id_admin` bigint NOT NULL AUTO_INCREMENT,
  `id_prescricao` bigint NOT NULL,
  `id_enfermeiro` bigint NOT NULL,
  `dose` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `observacao` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id_admin`),
  KEY `id_prescricao` (`id_prescricao`),
  KEY `id_enfermeiro` (`id_enfermeiro`),
  CONSTRAINT `administracao_medicacao_ibfk_1` FOREIGN KEY (`id_prescricao`) REFERENCES `prescricao_internacao` (`id_prescricao`),
  CONSTRAINT `administracao_medicacao_ibfk_2` FOREIGN KEY (`id_enfermeiro`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administracao_medicacao`
--

LOCK TABLES `administracao_medicacao` WRITE;
/*!40000 ALTER TABLE `administracao_medicacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `administracao_medicacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agendamentos`
--

DROP TABLE IF EXISTS `agendamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agendamentos` (
  `id_agendamento` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL COMMENT 'Pessoa agendada',
  `id_especialidade` int NOT NULL COMMENT 'Especialidade',
  `data_agendada` datetime NOT NULL COMMENT 'Data agendada',
  `status` enum('AGENDADO','REALIZADO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'AGENDADO' COMMENT 'Status do agendamento',
  `id_usuario` bigint DEFAULT NULL COMMENT 'Usuário que agendou',
  `id_senha` bigint DEFAULT NULL COMMENT 'Referência à senha gerada',
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'Observações do agendamento',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  PRIMARY KEY (`id_agendamento`),
  KEY `id_pessoa` (`id_pessoa`),
  KEY `id_especialidade` (`id_especialidade`),
  KEY `id_usuario` (`id_usuario`),
  KEY `idx_id_senha` (`id_senha`),
  KEY `idx_data_agendada` (`data_agendada`),
  CONSTRAINT `agendamentos_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`) ON DELETE CASCADE,
  CONSTRAINT `agendamentos_ibfk_2` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`) ON DELETE RESTRICT,
  CONSTRAINT `agendamentos_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL,
  CONSTRAINT `fk_agendamentos_senhas` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabela de agendamentos de consultas';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agendamentos`
--

LOCK TABLES `agendamentos` WRITE;
/*!40000 ALTER TABLE `agendamentos` DISABLE KEYS */;
/*!40000 ALTER TABLE `agendamentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agendamentos_eventos`
--

DROP TABLE IF EXISTS `agendamentos_eventos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agendamentos_eventos` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_agendamento` bigint NOT NULL COMMENT 'Agendamento associado',
  `tipo_evento` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Tipo de evento',
  `descricao` text COLLATE utf8mb4_general_ci COMMENT 'Descrição do evento',
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data do evento',
  `id_usuario` bigint DEFAULT NULL COMMENT 'Usuário responsável',
  PRIMARY KEY (`id_evento`),
  KEY `id_agendamento` (`id_agendamento`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `agendamentos_eventos_ibfk_1` FOREIGN KEY (`id_agendamento`) REFERENCES `agendamentos` (`id_agendamento`) ON DELETE CASCADE,
  CONSTRAINT `agendamentos_eventos_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Eventos relacionados a agendamentos';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agendamentos_eventos`
--

LOCK TABLES `agendamentos_eventos` WRITE;
/*!40000 ALTER TABLE `agendamentos_eventos` DISABLE KEYS */;
/*!40000 ALTER TABLE `agendamentos_eventos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `almox_entrada`
--

DROP TABLE IF EXISTS `almox_entrada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `almox_entrada` (
  `id_entrada` bigint NOT NULL AUTO_INCREMENT,
  `id_estoque` bigint NOT NULL,
  `quantidade` int NOT NULL,
  `origem` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Compra, doação, transferência',
  `id_usuario` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_entrada`),
  KEY `id_estoque` (`id_estoque`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `almox_entrada_ibfk_1` FOREIGN KEY (`id_estoque`) REFERENCES `estoque_almoxarifado` (`id_estoque`),
  CONSTRAINT `almox_entrada_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Entradas no almoxarifado';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `almox_entrada`
--

LOCK TABLES `almox_entrada` WRITE;
/*!40000 ALTER TABLE `almox_entrada` DISABLE KEYS */;
/*!40000 ALTER TABLE `almox_entrada` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `almox_saida`
--

DROP TABLE IF EXISTS `almox_saida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `almox_saida` (
  `id_saida` bigint NOT NULL AUTO_INCREMENT,
  `id_estoque` bigint NOT NULL,
  `quantidade` int NOT NULL,
  `destino` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Setor, sala, manutenção',
  `id_usuario` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_saida`),
  KEY `id_estoque` (`id_estoque`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `almox_saida_ibfk_1` FOREIGN KEY (`id_estoque`) REFERENCES `estoque_almoxarifado` (`id_estoque`),
  CONSTRAINT `almox_saida_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Saídas do almoxarifado';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `almox_saida`
--

LOCK TABLES `almox_saida` WRITE;
/*!40000 ALTER TABLE `almox_saida` DISABLE KEYS */;
/*!40000 ALTER TABLE `almox_saida` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `anamnese`
--

DROP TABLE IF EXISTS `anamnese`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `anamnese` (
  `id_anamnese` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_anamnese`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `anamnese_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `anamnese_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anamnese`
--

LOCK TABLES `anamnese` WRITE;
/*!40000 ALTER TABLE `anamnese` DISABLE KEYS */;
/*!40000 ALTER TABLE `anamnese` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `anotacao_enfermagem`
--

DROP TABLE IF EXISTS `anotacao_enfermagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `anotacao_enfermagem` (
  `id_anotacao` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_anotacao`),
  KEY `id_internacao` (`id_internacao`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `anotacao_enfermagem_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `anotacao_enfermagem_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anotacao_enfermagem`
--

LOCK TABLES `anotacao_enfermagem` WRITE;
/*!40000 ALTER TABLE `anotacao_enfermagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `anotacao_enfermagem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assistencia_social_atendimento`
--

DROP TABLE IF EXISTS `assistencia_social_atendimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assistencia_social_atendimento` (
  `id_as` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `id_senha` bigint DEFAULT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `status` enum('ABERTO','EM_ATENDIMENTO','FINALIZADO','CANCELADO') NOT NULL DEFAULT 'ABERTO',
  `motivo` varchar(255) DEFAULT NULL,
  `relato` text,
  `id_usuario_abertura` bigint NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_as`),
  KEY `fk_as_unidade` (`id_unidade`),
  KEY `fk_as_user` (`id_usuario_abertura`),
  CONSTRAINT `fk_as_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
  CONSTRAINT `fk_as_user` FOREIGN KEY (`id_usuario_abertura`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assistencia_social_atendimento`
--

LOCK TABLES `assistencia_social_atendimento` WRITE;
/*!40000 ALTER TABLE `assistencia_social_atendimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencia_social_atendimento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atendimento`
--

DROP TABLE IF EXISTS `atendimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento` (
  `id_atendimento` bigint NOT NULL AUTO_INCREMENT,
  `protocolo` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_pessoa` bigint NOT NULL,
  `id_senha` bigint DEFAULT NULL,
  `status_atendimento` enum('ABERTO','EM_ATENDIMENTO','EM_OBSERVACAO','INTERNADO','FINALIZADO','NAO_ATENDIDO','RETORNO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_local_atual` bigint DEFAULT NULL,
  `id_sala_atual` int DEFAULT NULL,
  `id_especialidade` int DEFAULT NULL,
  `data_abertura` datetime DEFAULT CURRENT_TIMESTAMP,
  `data_fechamento` datetime DEFAULT NULL,
  PRIMARY KEY (`id_atendimento`),
  UNIQUE KEY `protocolo` (`protocolo`),
  KEY `id_pessoa` (`id_pessoa`),
  KEY `id_local_atual` (`id_local_atual`),
  KEY `id_sala_atual` (`id_sala_atual`),
  KEY `id_especialidade` (`id_especialidade`),
  KEY `idx_status_local` (`status_atendimento`,`id_local_atual`),
  KEY `fk_atendimento_senhas` (`id_senha`),
  CONSTRAINT `atendimento_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`),
  CONSTRAINT `atendimento_ibfk_3` FOREIGN KEY (`id_local_atual`) REFERENCES `local_atendimento` (`id_local`),
  CONSTRAINT `atendimento_ibfk_4` FOREIGN KEY (`id_sala_atual`) REFERENCES `sala` (`id_sala`),
  CONSTRAINT `atendimento_ibfk_5` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`),
  CONSTRAINT `fk_atendimento_senhas` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento`
--

LOCK TABLES `atendimento` WRITE;
/*!40000 ALTER TABLE `atendimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_auditoria_atendimento_update` AFTER UPDATE ON `atendimento` FOR EACH ROW BEGIN
    INSERT INTO log_auditoria(
        id_usuario, acao, tabela_afetada, id_registro, antes, depois, data_hora
    )
    VALUES (
        NULL,
        'UPDATE',
        'atendimento',
        OLD.id_atendimento,
        CONCAT('status: ', OLD.status_atendimento),
        CONCAT('status: ', NEW.status_atendimento),
        NOW()
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `atendimento_movimentacao`
--

DROP TABLE IF EXISTS `atendimento_movimentacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_movimentacao` (
  `id_mov` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `de_local` int DEFAULT NULL,
  `para_local` int DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `motivo` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_mov`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `atendimento_movimentacao_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `atendimento_movimentacao_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_movimentacao`
--

LOCK TABLES `atendimento_movimentacao` WRITE;
/*!40000 ALTER TABLE `atendimento_movimentacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_movimentacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atendimento_observacao`
--

DROP TABLE IF EXISTS `atendimento_observacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_observacao` (
  `id_obs` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `tipo` enum('OBSERVACAO','INTERNACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_leito` int DEFAULT NULL,
  `data_inicio` datetime DEFAULT CURRENT_TIMESTAMP,
  `data_fim` datetime DEFAULT NULL,
  `status` enum('ATIVO','ALTA','TRANSFERIDO') COLLATE utf8mb4_general_ci DEFAULT 'ATIVO',
  PRIMARY KEY (`id_obs`),
  UNIQUE KEY `uk_atendimento_obs` (`id_atendimento`),
  KEY `id_leito` (`id_leito`),
  CONSTRAINT `atendimento_observacao_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `atendimento_observacao_ibfk_2` FOREIGN KEY (`id_leito`) REFERENCES `leito` (`id_leito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_observacao`
--

LOCK TABLES `atendimento_observacao` WRITE;
/*!40000 ALTER TABLE `atendimento_observacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_observacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atendimento_recepcao`
--

DROP TABLE IF EXISTS `atendimento_recepcao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_recepcao` (
  `id_atendimento` bigint NOT NULL,
  `tipo_atendimento` enum('CLINICO','PEDIATRICO','EMERGENCIA','EXAME_EXTERNO','MEDICACAO_EXTERNA') COLLATE utf8mb4_general_ci NOT NULL,
  `chegada` enum('MEIOS_PROPRIOS','AMBULANCIA','POLICIA','OUTROS') COLLATE utf8mb4_general_ci NOT NULL,
  `prioridade` enum('AUTISTA','CRIANCA_COLO','GESTANTE','IDOSO','NORMAL') COLLATE utf8mb4_general_ci DEFAULT 'NORMAL',
  `motivo_procura` text COLLATE utf8mb4_general_ci,
  `destino_inicial` enum('TRIAGEM','MEDICO','EMERGENCIA','RX','MEDICACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_recepcionista` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_atendimento`),
  KEY `id_recepcionista` (`id_recepcionista`),
  CONSTRAINT `atendimento_recepcao_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `atendimento_recepcao_ibfk_2` FOREIGN KEY (`id_recepcionista`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_recepcao`
--

LOCK TABLES `atendimento_recepcao` WRITE;
/*!40000 ALTER TABLE `atendimento_recepcao` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_recepcao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria_almoxarifado`
--

DROP TABLE IF EXISTS `auditoria_almoxarifado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_almoxarifado` (
  `id_log` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` bigint NOT NULL,
  `id_local` bigint DEFAULT NULL,
  `acao` enum('ENTRADA','SAIDA','AJUSTE') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `quantidade` int NOT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_log`),
  KEY `id_produto` (`id_produto`),
  KEY `id_local` (`id_local`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `auditoria_almoxarifado_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produtos_almoxarifado` (`id_produto`),
  CONSTRAINT `auditoria_almoxarifado_ibfk_2` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`),
  CONSTRAINT `auditoria_almoxarifado_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Auditoria do almoxarifado';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_almoxarifado`
--

LOCK TABLES `auditoria_almoxarifado` WRITE;
/*!40000 ALTER TABLE `auditoria_almoxarifado` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_almoxarifado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria_estoque`
--

DROP TABLE IF EXISTS `auditoria_estoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_estoque` (
  `id_log` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` bigint NOT NULL,
  `id_local` int NOT NULL,
  `acao` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `quantidade` int NOT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_estoque`
--

LOCK TABLES `auditoria_estoque` WRITE;
/*!40000 ALTER TABLE `auditoria_estoque` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_estoque` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria_estoque_sanitario`
--

DROP TABLE IF EXISTS `auditoria_estoque_sanitario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_estoque_sanitario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_farmaco` bigint NOT NULL,
  `id_lote` bigint NOT NULL,
  `id_local` int NOT NULL,
  `quantidade` int NOT NULL,
  `nivel_risco` enum('OK','CRITICO','VENCIDO') COLLATE utf8mb4_general_ci NOT NULL,
  `criado_por` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_estoque_sanitario`
--

LOCK TABLES `auditoria_estoque_sanitario` WRITE;
/*!40000 ALTER TABLE `auditoria_estoque_sanitario` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_estoque_sanitario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria_evento`
--

DROP TABLE IF EXISTS `auditoria_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_evento` (
  `id_auditoria` bigint NOT NULL AUTO_INCREMENT,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `entidade` varchar(80) NOT NULL,
  `id_entidade` bigint DEFAULT NULL,
  `acao` varchar(80) NOT NULL,
  `detalhe` text,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria`),
  KEY `idx_aud_sessao` (`id_sessao_usuario`),
  KEY `idx_aud_entidade` (`entidade`,`id_entidade`),
  CONSTRAINT `fk_aud_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_evento`
--

LOCK TABLES `auditoria_evento` WRITE;
/*!40000 ALTER TABLE `auditoria_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria_excecoes`
--

DROP TABLE IF EXISTS `auditoria_excecoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_excecoes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_paciente` bigint NOT NULL,
  `motivo` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `chamado_por` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_excecoes`
--

LOCK TABLES `auditoria_excecoes` WRITE;
/*!40000 ALTER TABLE `auditoria_excecoes` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_excecoes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria_ffa`
--

DROP TABLE IF EXISTS `auditoria_ffa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_ffa` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `tipo_evento` enum('CRIACAO','STATUS','LAYOUT','CHAMADA_MEDICA','SOLICITACAO_RX','SOLICITACAO_MEDICACAO','ALTA_MEDICA','TRANSFERENCIA','INTERNACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `acao` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_auditoria_ffa_ffa` (`id_ffa`),
  CONSTRAINT `fk_auditoria_ffa_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_ffa`
--

LOCK TABLES `auditoria_ffa` WRITE;
/*!40000 ALTER TABLE `auditoria_ffa` DISABLE KEYS */;
INSERT INTO `auditoria_ffa` VALUES (1,4,1,'CRIACAO','CRIACAO: FFA aberta para paciente 8','2025-12-29 04:40:52'),(2,4,1,'CRIACAO','STATUS: ABERTO -> EM_ATENDIMENTO','2025-12-29 04:40:52'),(3,4,1,'CRIACAO','LAYOUT: TRIAGEM -> SALA_1','2025-12-29 04:40:52'),(4,5,1,'CRIACAO','CRIACAO: FFA aberta para paciente 9','2025-12-29 06:23:31'),(5,5,2,'CRIACAO','STATUS: ABERTO -> EM_TRIAGEM','2025-12-29 06:32:53'),(6,5,2,'CRIACAO','LAYOUT: TRIAGEM -> TRIAGEM_1','2025-12-29 06:32:53'),(7,5,2,'CRIACAO','INICIO TRIAGEM: FFA em TRIAGEM_1, classificacao AZUL','2025-12-29 06:32:53'),(8,5,2,'CRIACAO','STATUS: EM_TRIAGEM -> AGUARDANDO_CHAMADA_MEDICO','2025-12-29 06:35:45'),(9,5,2,'CRIACAO','LAYOUT: TRIAGEM_1 -> PAINEL_MEDICO','2025-12-29 06:35:45'),(10,5,2,'CRIACAO','FINALIZA TRIAGEM: classificacao AMARELO, encaminhado para PAINEL_MEDICO','2025-12-29 06:35:45'),(11,5,2,'CRIACAO','FINALIZA TRIAGEM: classificacao AMARELO, encaminhado para PAINEL_MEDICO','2025-12-29 06:37:09'),(12,4,1,'CRIACAO','STATUS: EM_ATENDIMENTO -> EM_ATENDIMENTO_MEDICO','2025-12-29 06:49:27'),(13,4,10,'CRIACAO','STATUS: EM_ATENDIMENTO_MEDICO -> AGUARDANDO_RX','2025-12-30 23:16:32'),(14,4,10,'CRIACAO','LAYOUT: SALA_1 -> RX','2025-12-30 23:16:32'),(15,4,10,'SOLICITACAO_RX','Paciente encaminhado para RX','2025-12-31 00:00:30'),(16,4,10,'CRIACAO','LAYOUT: RX -> PAINEL_CLINICO','2025-12-31 03:24:46');
/*!40000 ALTER TABLE `auditoria_ffa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria_fila`
--

DROP TABLE IF EXISTS `auditoria_fila`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_fila` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_fila` bigint NOT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `acao` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_fila` (`id_fila`),
  CONSTRAINT `auditoria_fila_ibfk_1` FOREIGN KEY (`id_fila`) REFERENCES `fila_senha` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_fila`
--

LOCK TABLES `auditoria_fila` WRITE;
/*!40000 ALTER TABLE `auditoria_fila` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_fila` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chamada_painel`
--

DROP TABLE IF EXISTS `chamada_painel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chamada_painel` (
  `id_chamada` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_sala` int NOT NULL,
  `status` enum('CHAMANDO','ATENDIDO','NAO_COMPARECEU') COLLATE utf8mb4_general_ci DEFAULT 'CHAMANDO',
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_chamada`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_sala` (`id_sala`),
  KEY `idx_painel_status` (`status`,`data_hora`),
  CONSTRAINT `chamada_painel_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `chamada_painel_ibfk_2` FOREIGN KEY (`id_sala`) REFERENCES `sala` (`id_sala`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chamada_painel`
--

LOCK TABLES `chamada_painel` WRITE;
/*!40000 ALTER TABLE `chamada_painel` DISABLE KEYS */;
/*!40000 ALTER TABLE `chamada_painel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chamado`
--

DROP TABLE IF EXISTS `chamado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chamado` (
  `id_chamado` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `id_sistema` bigint NOT NULL,
  `area_responsavel` enum('TI','MANUTENCAO','ENG_CLINICA','GASOTERAPIA','OUTRA') NOT NULL,
  `prioridade` enum('BAIXA','MEDIA','ALTA','CRITICA') NOT NULL DEFAULT 'MEDIA',
  `status` enum('ABERTO','ENVIADO_GLPI','EM_ATENDIMENTO','AGUARDANDO','RESOLVIDO','CANCELADO') NOT NULL DEFAULT 'ABERTO',
  `titulo` varchar(150) NOT NULL,
  `descricao` text,
  `id_usuario_abertura` bigint NOT NULL,
  `id_usuario_atribuido` bigint DEFAULT NULL,
  `glpi_ticket_id` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_chamado`),
  KEY `idx_ch_area_status` (`area_responsavel`,`status`),
  KEY `idx_ch_glpi` (`glpi_ticket_id`),
  KEY `fk_ch_unidade` (`id_unidade`),
  KEY `fk_ch_sistema` (`id_sistema`),
  KEY `fk_ch_user_abertura` (`id_usuario_abertura`),
  KEY `fk_ch_user_atr` (`id_usuario_atribuido`),
  CONSTRAINT `fk_ch_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
  CONSTRAINT `fk_ch_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
  CONSTRAINT `fk_ch_user_abertura` FOREIGN KEY (`id_usuario_abertura`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `fk_ch_user_atr` FOREIGN KEY (`id_usuario_atribuido`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chamado`
--

LOCK TABLES `chamado` WRITE;
/*!40000 ALTER TABLE `chamado` DISABLE KEYS */;
/*!40000 ALTER TABLE `chamado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chamado_evento`
--

DROP TABLE IF EXISTS `chamado_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chamado_evento` (
  `id_chamado_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_chamado` bigint NOT NULL,
  `evento` varchar(80) NOT NULL,
  `detalhe` text,
  `id_usuario` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_chamado_evento`),
  KEY `idx_chev_chamado` (`id_chamado`),
  KEY `fk_chev_user` (`id_usuario`),
  CONSTRAINT `fk_chev_chamado` FOREIGN KEY (`id_chamado`) REFERENCES `chamado` (`id_chamado`),
  CONSTRAINT `fk_chev_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chamado_evento`
--

LOCK TABLES `chamado_evento` WRITE;
/*!40000 ALTER TABLE `chamado_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `chamado_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chamado_manutencao`
--

DROP TABLE IF EXISTS `chamado_manutencao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chamado_manutencao` (
  `id_chamado` bigint NOT NULL AUTO_INCREMENT,
  `id_setor` int NOT NULL,
  `origem` enum('PA','INTERNACAO','AMBULATORIO','ADMINISTRATIVO') COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_problema` enum('ELETRICO','HIDRAULICO','AR_CONDICIONADO','EQUIPAMENTO','ESTRUTURAL','TI','OUTRO') COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `prioridade` enum('BAIXA','MEDIA','ALTA','CRITICA') COLLATE utf8mb4_general_ci DEFAULT 'MEDIA',
  `status` enum('ABERTO','EM_ATENDIMENTO','AGUARDANDO_PECA','RESOLVIDO','CANCELADO') COLLATE utf8mb4_general_ci DEFAULT 'ABERTO',
  `aberto_por` bigint NOT NULL,
  `aberto_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `fechado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_chamado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Chamados de manutenção predial, equipamentos e TI';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chamado_manutencao`
--

LOCK TABLES `chamado_manutencao` WRITE;
/*!40000 ALTER TABLE `chamado_manutencao` DISABLE KEYS */;
/*!40000 ALTER TABLE `chamado_manutencao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cidade`
--

DROP TABLE IF EXISTS `cidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cidade` (
  `id_cidade` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `uf` char(2) COLLATE utf8mb4_general_ci NOT NULL,
  `codigo_ibge` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_cidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cidade`
--

LOCK TABLES `cidade` WRITE;
/*!40000 ALTER TABLE `cidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `cidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classificacao_risco`
--

DROP TABLE IF EXISTS `classificacao_risco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `classificacao_risco` (
  `id_risco` int NOT NULL AUTO_INCREMENT,
  `cor` enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tempo_max` int DEFAULT NULL,
  `descricao` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_risco`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classificacao_risco`
--

LOCK TABLES `classificacao_risco` WRITE;
/*!40000 ALTER TABLE `classificacao_risco` DISABLE KEYS */;
INSERT INTO `classificacao_risco` VALUES (1,'VERMELHO',0,'Emergência'),(2,'AMARELO',10,'Urgência'),(3,'VERDE',120,'Pouco Urgente');
/*!40000 ALTER TABLE `classificacao_risco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuracao`
--

DROP TABLE IF EXISTS `configuracao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuracao` (
  `chave` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `valor` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`chave`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracao`
--

LOCK TABLES `configuracao` WRITE;
/*!40000 ALTER TABLE `configuracao` DISABLE KEYS */;
/*!40000 ALTER TABLE `configuracao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consumo_insumo`
--

DROP TABLE IF EXISTS `consumo_insumo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consumo_insumo` (
  `id_consumo` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `origem` enum('FARMACIA','ALMOXARIFADO','MANUTENCAO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_produto` bigint NOT NULL,
  `quantidade` decimal(10,2) NOT NULL,
  `usado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `registrado_por` bigint NOT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id_consumo`),
  KEY `idx_ffa` (`id_ffa`),
  KEY `idx_origem` (`origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Consumo real de insumos no paciente';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consumo_insumo`
--

LOCK TABLES `consumo_insumo` WRITE;
/*!40000 ALTER TABLE `consumo_insumo` DISABLE KEYS */;
/*!40000 ALTER TABLE `consumo_insumo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consumo_limpeza`
--

DROP TABLE IF EXISTS `consumo_limpeza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consumo_limpeza` (
  `id_consumo` bigint NOT NULL AUTO_INCREMENT,
  `id_setor` int NOT NULL COMMENT 'Setor onde ocorreu o consumo',
  `id_produto` bigint NOT NULL COMMENT 'Produto de limpeza',
  `quantidade` decimal(10,2) NOT NULL,
  `unidade` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'UN',
  `consumido_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `registrado_por` bigint NOT NULL COMMENT 'Usuário da limpeza',
  `motivo` enum('ROTINA','REPOSICAO','CONTAMINACAO','INTERCORRENCIA','OUTRO') COLLATE utf8mb4_general_ci DEFAULT 'ROTINA',
  `observacao` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id_consumo`),
  KEY `idx_setor` (`id_setor`),
  KEY `idx_produto` (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Consumo operacional de produtos de limpeza e higiene';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consumo_limpeza`
--

LOCK TABLES `consumo_limpeza` WRITE;
/*!40000 ALTER TABLE `consumo_limpeza` DISABLE KEYS */;
/*!40000 ALTER TABLE `consumo_limpeza` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consumo_manutencao`
--

DROP TABLE IF EXISTS `consumo_manutencao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consumo_manutencao` (
  `id_consumo` bigint NOT NULL AUTO_INCREMENT,
  `id_chamado` bigint NOT NULL,
  `id_produto` bigint NOT NULL,
  `quantidade` decimal(10,2) NOT NULL,
  `unidade` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `consumido_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `registrado_por` bigint NOT NULL,
  PRIMARY KEY (`id_consumo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Consumo de materiais em manutenção';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consumo_manutencao`
--

LOCK TABLES `consumo_manutencao` WRITE;
/*!40000 ALTER TABLE `consumo_manutencao` DISABLE KEYS */;
/*!40000 ALTER TABLE `consumo_manutencao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contexto_atendimento`
--

DROP TABLE IF EXISTS `contexto_atendimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contexto_atendimento` (
  `id_contexto` bigint NOT NULL AUTO_INCREMENT,
  `id_sistema` bigint NOT NULL,
  `nome` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('PORTA','EMERGENCIA','LEITO','EXECUCAO') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `usa_fila` tinyint(1) DEFAULT NULL,
  `usa_chamada` tinyint(1) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id_contexto`),
  KEY `id_sistema` (`id_sistema`),
  CONSTRAINT `contexto_atendimento_ibfk_1` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contexto_atendimento`
--

LOCK TABLES `contexto_atendimento` WRITE;
/*!40000 ALTER TABLE `contexto_atendimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `contexto_atendimento` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Table structure for table `enfermagem`
--

DROP TABLE IF EXISTS `enfermagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enfermagem` (
  `id_usuario` bigint NOT NULL,
  `coren` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `uf_coren` char(2) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('ENFERMEIRO','TECNICO') COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uk_coren` (`coren`,`uf_coren`),
  CONSTRAINT `enfermagem_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enfermagem`
--

LOCK TABLES `enfermagem` WRITE;
/*!40000 ALTER TABLE `enfermagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `enfermagem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entrada_estoque`
--

DROP TABLE IF EXISTS `entrada_estoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entrada_estoque` (
  `id_entrada` bigint NOT NULL AUTO_INCREMENT,
  `id_estoque` bigint NOT NULL,
  `id_produto` bigint NOT NULL,
  `id_local` bigint DEFAULT NULL,
  `quantidade` int NOT NULL,
  `lote` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `validade` date DEFAULT NULL,
  `id_usuario_entrada` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_fornecedor` bigint DEFAULT NULL,
  `numero_nota` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `valor_total` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id_entrada`),
  KEY `id_estoque` (`id_estoque`),
  KEY `id_produto` (`id_produto`),
  KEY `id_local` (`id_local`),
  CONSTRAINT `entrada_estoque_ibfk_1` FOREIGN KEY (`id_estoque`) REFERENCES `estoque_local` (`id_estoque`),
  CONSTRAINT `entrada_estoque_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produtos_farmacia` (`id_produto`),
  CONSTRAINT `entrada_estoque_ibfk_3` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entrada_estoque`
--

LOCK TABLES `entrada_estoque` WRITE;
/*!40000 ALTER TABLE `entrada_estoque` DISABLE KEYS */;
/*!40000 ALTER TABLE `entrada_estoque` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `escala_plantao`
--

DROP TABLE IF EXISTS `escala_plantao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `escala_plantao` (
  `id_escala` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `id_sistema` bigint NOT NULL,
  `data` date NOT NULL,
  `id_plantao_modelo` bigint NOT NULL,
  `observacao` varchar(255) DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_escala`),
  KEY `idx_escala_data` (`id_unidade`,`data`),
  KEY `fk_esc_sistema` (`id_sistema`),
  KEY `fk_esc_pm` (`id_plantao_modelo`),
  CONSTRAINT `fk_esc_pm` FOREIGN KEY (`id_plantao_modelo`) REFERENCES `plantao_modelo` (`id_plantao_modelo`),
  CONSTRAINT `fk_esc_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
  CONSTRAINT `fk_esc_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `escala_plantao`
--

LOCK TABLES `escala_plantao` WRITE;
/*!40000 ALTER TABLE `escala_plantao` DISABLE KEYS */;
/*!40000 ALTER TABLE `escala_plantao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `escala_profissional`
--

DROP TABLE IF EXISTS `escala_profissional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `escala_profissional` (
  `id_escala` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `funcao` enum('MEDICO','ENFERMEIRO','TECNICO','RECEPCAO','TI','OUTRA') NOT NULL,
  `inicio_real` datetime DEFAULT NULL,
  `fim_real` datetime DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_escala`,`id_usuario`),
  KEY `fk_ep_usuario` (`id_usuario`),
  CONSTRAINT `fk_ep_escala` FOREIGN KEY (`id_escala`) REFERENCES `escala_plantao` (`id_escala`),
  CONSTRAINT `fk_ep_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `escala_profissional`
--

LOCK TABLES `escala_profissional` WRITE;
/*!40000 ALTER TABLE `escala_profissional` DISABLE KEYS */;
/*!40000 ALTER TABLE `escala_profissional` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `especialidade`
--

DROP TABLE IF EXISTS `especialidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `especialidade` (
  `id_especialidade` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `ativa` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_especialidade`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `especialidade`
--

LOCK TABLES `especialidade` WRITE;
/*!40000 ALTER TABLE `especialidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `especialidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque_almoxarifado`
--

DROP TABLE IF EXISTS `estoque_almoxarifado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_almoxarifado` (
  `id_estoque` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` bigint NOT NULL,
  `id_local` bigint DEFAULT NULL,
  `quantidade_atual` int DEFAULT '0',
  `min_estoque` int DEFAULT '0',
  PRIMARY KEY (`id_estoque`),
  UNIQUE KEY `uk_produto_local` (`id_produto`,`id_local`),
  KEY `id_local` (`id_local`),
  CONSTRAINT `estoque_almoxarifado_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produtos_almoxarifado` (`id_produto`),
  CONSTRAINT `estoque_almoxarifado_ibfk_2` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Estoque do almoxarifado por local';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_almoxarifado`
--

LOCK TABLES `estoque_almoxarifado` WRITE;
/*!40000 ALTER TABLE `estoque_almoxarifado` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_almoxarifado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque_limpeza`
--

DROP TABLE IF EXISTS `estoque_limpeza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_limpeza` (
  `id_estoque` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` bigint NOT NULL COMMENT 'Produto de limpeza',
  `id_local` bigint DEFAULT NULL,
  `quantidade_atual` int DEFAULT '0' COMMENT 'Quantidade atual',
  `min_estoque` int DEFAULT '0' COMMENT 'Mínimo para alerta',
  PRIMARY KEY (`id_estoque`),
  UNIQUE KEY `uk_produto_local_limpeza` (`id_produto`,`id_local`),
  KEY `id_local` (`id_local`),
  CONSTRAINT `estoque_limpeza_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produtos_limpeza` (`id_produto`) ON DELETE CASCADE,
  CONSTRAINT `estoque_limpeza_ibfk_2` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Estoque para itens de limpeza';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_limpeza`
--

LOCK TABLES `estoque_limpeza` WRITE;
/*!40000 ALTER TABLE `estoque_limpeza` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_limpeza` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque_local`
--

DROP TABLE IF EXISTS `estoque_local`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_local` (
  `id_estoque` bigint NOT NULL AUTO_INCREMENT,
  `id_farmaco` bigint NOT NULL,
  `id_local` bigint DEFAULT NULL,
  `quantidade_atual` int NOT NULL DEFAULT '0',
  `min_estoque` int DEFAULT '0',
  PRIMARY KEY (`id_estoque`),
  UNIQUE KEY `uk_farmaco_local` (`id_farmaco`,`id_local`),
  KEY `id_local` (`id_local`),
  CONSTRAINT `estoque_local_ibfk_1` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`),
  CONSTRAINT `estoque_local_ibfk_2` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_local`
--

LOCK TABLES `estoque_local` WRITE;
/*!40000 ALTER TABLE `estoque_local` DISABLE KEYS */;
INSERT INTO `estoque_local` VALUES (2,1,1,5,20);
/*!40000 ALTER TABLE `estoque_local` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evento_ffa`
--

DROP TABLE IF EXISTS `evento_ffa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evento_ffa` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_paciente` bigint DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `origem` enum('PAINEL_TOTEM','PAINEL_RECEPCAO','PAINEL_TRIAGEM','PAINEL_MEDICO','PAINEL_PROCEDIMENTO','PAINEL_SATISFACAO','SISTEMA') COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_evento` enum('GERAR_SENHA','IMPRIMIR_SENHA','CHAMAR_SENHA','CONFIRMAR_PRESENCA','CRIAR_FFA','INICIO_TRIAGEM','FINAL_TRIAGEM','CHAMADA_MEDICA','INICIO_ATENDIMENTO_MEDICO','FINAL_ATENDIMENTO_MEDICO','CHAMADA_PROCEDIMENTO','INICIO_PROCEDIMENTO','FINAL_PROCEDIMENTO','STATUS_AUTOMATICO','NAO_COMPARECEU','TIMEOUT','AVALIACAO_ATENDIMENTO') COLLATE utf8mb4_general_ci NOT NULL,
  `status_origem` enum('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO','AGUARDANDO_MEDICACAO','MEDICACAO','AGUARDANDO_RX','EM_RX','AGUARDANDO_COLETA','EM_COLETA','AGUARDANDO_ECG','EM_ECG','ALTA','TRANSFERENCIA','INTERNACAO','FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_destino` enum('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO','AGUARDANDO_MEDICACAO','MEDICACAO','AGUARDANDO_RX','EM_RX','AGUARDANDO_COLETA','EM_COLETA','AGUARDANDO_ECG','EM_ECG','ALTA','TRANSFERENCIA','INTERNACAO','FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `payload` json DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_evento_ffa` (`id_ffa`),
  KEY `idx_evento_tipo` (`tipo_evento`),
  KEY `idx_evento_origem` (`origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evento_ffa`
--

LOCK TABLES `evento_ffa` WRITE;
/*!40000 ALTER TABLE `evento_ffa` DISABLE KEYS */;
/*!40000 ALTER TABLE `evento_ffa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evento_limpeza`
--

DROP TABLE IF EXISTS `evento_limpeza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evento_limpeza` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_setor` int NOT NULL,
  `tipo_evento` enum('LIMPEZA_ROTINA','LIMPEZA_TERMINAL','REPOSICAO_HIGIENE','INTERCORRENCIA','CONTAMINACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `registrado_por` bigint NOT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_setor` (`id_setor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Eventos operacionais da equipe de limpeza';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evento_limpeza`
--

LOCK TABLES `evento_limpeza` WRITE;
/*!40000 ALTER TABLE `evento_limpeza` DISABLE KEYS */;
/*!40000 ALTER TABLE `evento_limpeza` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eventos_fluxo`
--

DROP TABLE IF EXISTS `eventos_fluxo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventos_fluxo` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `entidade` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `entidade_id` bigint DEFAULT NULL,
  `tipo_evento` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `perfil_usuario` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `local` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventos_fluxo`
--

LOCK TABLES `eventos_fluxo` WRITE;
/*!40000 ALTER TABLE `eventos_fluxo` DISABLE KEYS */;
/*!40000 ALTER TABLE `eventos_fluxo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evolucao_enfermagem`
--

DROP TABLE IF EXISTS `evolucao_enfermagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evolucao_enfermagem` (
  `id_evolucao` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_enfermeiro` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evolucao`),
  KEY `id_internacao` (`id_internacao`),
  KEY `id_enfermeiro` (`id_enfermeiro`),
  CONSTRAINT `evolucao_enfermagem_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `evolucao_enfermagem_ibfk_2` FOREIGN KEY (`id_enfermeiro`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evolucao_enfermagem`
--

LOCK TABLES `evolucao_enfermagem` WRITE;
/*!40000 ALTER TABLE `evolucao_enfermagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `evolucao_enfermagem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evolucao_medica`
--

DROP TABLE IF EXISTS `evolucao_medica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evolucao_medica` (
  `id_evolucao` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_medico` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evolucao`),
  KEY `id_internacao` (`id_internacao`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `evolucao_medica_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `evolucao_medica_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evolucao_medica`
--

LOCK TABLES `evolucao_medica` WRITE;
/*!40000 ALTER TABLE `evolucao_medica` DISABLE KEYS */;
/*!40000 ALTER TABLE `evolucao_medica` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evolucao_multidisciplinar`
--

DROP TABLE IF EXISTS `evolucao_multidisciplinar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evolucao_multidisciplinar` (
  `id_evolucao` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `area` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evolucao`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `evolucao_multidisciplinar_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `evolucao_multidisciplinar_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evolucao_multidisciplinar`
--

LOCK TABLES `evolucao_multidisciplinar` WRITE;
/*!40000 ALTER TABLE `evolucao_multidisciplinar` DISABLE KEYS */;
/*!40000 ALTER TABLE `evolucao_multidisciplinar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exame`
--

DROP TABLE IF EXISTS `exame`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exame` (
  `id_exame` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('LAB','RX','OUTROS') COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_exame`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exame`
--

LOCK TABLES `exame` WRITE;
/*!40000 ALTER TABLE `exame` DISABLE KEYS */;
/*!40000 ALTER TABLE `exame` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exame_fisico`
--

DROP TABLE IF EXISTS `exame_fisico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exame_fisico` (
  `id_exame` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_exame`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `exame_fisico_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `exame_fisico_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exame_fisico`
--

LOCK TABLES `exame_fisico` WRITE;
/*!40000 ALTER TABLE `exame_fisico` DISABLE KEYS */;
/*!40000 ALTER TABLE `exame_fisico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmaco`
--

DROP TABLE IF EXISTS `farmaco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmaco` (
  `id_farmaco` bigint NOT NULL AUTO_INCREMENT,
  `nome_comercial` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `principio_ativo` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('CONTROLADO','PADRAO','HEMODERIVADO') COLLATE utf8mb4_general_ci NOT NULL,
  `unidade_medida` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `marca` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `generico` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id_farmaco`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmaco`
--

LOCK TABLES `farmaco` WRITE;
/*!40000 ALTER TABLE `farmaco` DISABLE KEYS */;
INSERT INTO `farmaco` VALUES (1,'Dipirona 500mg','Dipirona Sódica','PADRAO','comprimido','EMS',1);
/*!40000 ALTER TABLE `farmaco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmaco_auditoria`
--

DROP TABLE IF EXISTS `farmaco_auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmaco_auditoria` (
  `id_auditoria` bigint NOT NULL AUTO_INCREMENT,
  `tabela` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_registro` bigint DEFAULT NULL,
  `acao` enum('INSERT','UPDATE','DELETE') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dados_antes` json DEFAULT NULL,
  `dados_depois` json DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `data_evento` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmaco_auditoria`
--

LOCK TABLES `farmaco_auditoria` WRITE;
/*!40000 ALTER TABLE `farmaco_auditoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmaco_auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmaco_auditoria_bloqueio`
--

DROP TABLE IF EXISTS `farmaco_auditoria_bloqueio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmaco_auditoria_bloqueio` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_farmaco` bigint NOT NULL,
  `id_lote` bigint NOT NULL,
  `id_cidade` bigint NOT NULL,
  `quantidade` int NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `usuario` bigint NOT NULL,
  `motivo` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_bloq_farmaco` (`id_farmaco`),
  KEY `idx_bloq_lote` (`id_lote`),
  KEY `idx_bloq_cidade` (`id_cidade`),
  KEY `idx_bloq_usuario` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmaco_auditoria_bloqueio`
--

LOCK TABLES `farmaco_auditoria_bloqueio` WRITE;
/*!40000 ALTER TABLE `farmaco_auditoria_bloqueio` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmaco_auditoria_bloqueio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmaco_estoque_minimo`
--

DROP TABLE IF EXISTS `farmaco_estoque_minimo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmaco_estoque_minimo` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_farmaco` bigint NOT NULL,
  `id_cidade` bigint NOT NULL,
  `quantidade_minima` int NOT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_farmaco_cidade` (`id_farmaco`,`id_cidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmaco_estoque_minimo`
--

LOCK TABLES `farmaco_estoque_minimo` WRITE;
/*!40000 ALTER TABLE `farmaco_estoque_minimo` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmaco_estoque_minimo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmaco_lote`
--

DROP TABLE IF EXISTS `farmaco_lote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmaco_lote` (
  `id_lote` bigint NOT NULL AUTO_INCREMENT,
  `id_farmaco` bigint NOT NULL,
  `numero_lote` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `data_fabricacao` date NOT NULL,
  `data_validade` date NOT NULL,
  `criado_por` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_lote`),
  KEY `fk_lote_farmaco` (`id_farmaco`),
  CONSTRAINT `fk_lote_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmaco_lote`
--

LOCK TABLES `farmaco_lote` WRITE;
/*!40000 ALTER TABLE `farmaco_lote` DISABLE KEYS */;
INSERT INTO `farmaco_lote` VALUES (1,1,'L123456','2024-01-01','2026-01-07',1,'2026-01-12 01:01:46'),(2,1,'L123456','2024-01-01','2026-02-01',1,'2026-01-12 01:02:31');
/*!40000 ALTER TABLE `farmaco_lote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmaco_movimentacao`
--

DROP TABLE IF EXISTS `farmaco_movimentacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmaco_movimentacao` (
  `id_movimentacao` bigint NOT NULL AUTO_INCREMENT,
  `id_farmaco` bigint NOT NULL,
  `id_lote` bigint NOT NULL,
  `id_cidade` bigint NOT NULL,
  `tipo` enum('ENTRADA','SAIDA') COLLATE utf8mb4_general_ci NOT NULL,
  `quantidade` int NOT NULL,
  `origem` enum('COMPRA','TRANSFERENCIA','PACIENTE','AJUSTE') COLLATE utf8mb4_general_ci NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `observacao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `realizado_por` bigint NOT NULL,
  `data_mov` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_movimentacao`),
  KEY `fk_mov_farmaco` (`id_farmaco`),
  KEY `fk_mov_lote` (`id_lote`),
  CONSTRAINT `fk_mov_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`),
  CONSTRAINT `fk_mov_lote` FOREIGN KEY (`id_lote`) REFERENCES `farmaco_lote` (`id_lote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmaco_movimentacao`
--

LOCK TABLES `farmaco_movimentacao` WRITE;
/*!40000 ALTER TABLE `farmaco_movimentacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmaco_movimentacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmaco_unidade`
--

DROP TABLE IF EXISTS `farmaco_unidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmaco_unidade` (
  `id_farmaco` bigint NOT NULL,
  `id_cidade` bigint NOT NULL,
  `cota_minima` int NOT NULL DEFAULT '0',
  `cota_maxima` int DEFAULT NULL,
  `atualizado_por` bigint NOT NULL,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_farmaco`,`id_cidade`),
  CONSTRAINT `fk_fu_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmaco_unidade`
--

LOCK TABLES `farmaco_unidade` WRITE;
/*!40000 ALTER TABLE `farmaco_unidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmaco_unidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faturamento_conta`
--

DROP TABLE IF EXISTS `faturamento_conta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_conta` (
  `id_conta` bigint NOT NULL AUTO_INCREMENT,
  `tipo_conta` enum('FFA','INTERNACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_internacao` bigint DEFAULT NULL,
  `status` enum('ABERTA','EM_REVISAO','FECHADA') COLLATE utf8mb4_general_ci DEFAULT 'ABERTA',
  `valor_total` decimal(12,2) DEFAULT '0.00',
  `aberta_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `fechada_em` datetime DEFAULT NULL,
  `fechado_por` bigint DEFAULT NULL,
  PRIMARY KEY (`id_conta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Conta financeira consolidada por atendimento';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_conta`
--

LOCK TABLES `faturamento_conta` WRITE;
/*!40000 ALTER TABLE `faturamento_conta` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_conta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faturamento_conta_item`
--

DROP TABLE IF EXISTS `faturamento_conta_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_conta_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_conta` bigint NOT NULL,
  `id_item` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Relaciona itens faturáveis à conta';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_conta_item`
--

LOCK TABLES `faturamento_conta_item` WRITE;
/*!40000 ALTER TABLE `faturamento_conta_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_conta_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faturamento_evento`
--

DROP TABLE IF EXISTS `faturamento_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_conta` bigint NOT NULL,
  `evento` enum('ABERTURA','FECHAMENTO','REABERTURA','CANCELAMENTO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint NOT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_conta` (`id_conta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Auditoria humana do faturamento';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_evento`
--

LOCK TABLES `faturamento_evento` WRITE;
/*!40000 ALTER TABLE `faturamento_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faturamento_insumo`
--

DROP TABLE IF EXISTS `faturamento_insumo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_insumo` (
  `id_fat_insumo` bigint NOT NULL AUTO_INCREMENT,
  `id_item` bigint NOT NULL,
  `origem` enum('FARMACIA','ALMOXARIFADO','MANUTENCAO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_produto` bigint NOT NULL,
  `lote` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `validade` date DEFAULT NULL,
  PRIMARY KEY (`id_fat_insumo`),
  KEY `idx_item` (`id_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Detalhe do insumo faturado';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_insumo`
--

LOCK TABLES `faturamento_insumo` WRITE;
/*!40000 ALTER TABLE `faturamento_insumo` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_insumo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faturamento_item`
--

DROP TABLE IF EXISTS `faturamento_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_item` (
  `id_item` bigint NOT NULL AUTO_INCREMENT,
  `origem` enum('PROCEDIMENTO','EXAME','MEDICACAO','MATERIAL','TAXA','OUTRO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_origem` bigint NOT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `quantidade` decimal(10,2) DEFAULT '1.00',
  `valor_unitario` decimal(10,2) NOT NULL,
  `valor_total` decimal(10,2) NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_internacao` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `criado_por` bigint NOT NULL,
  `status` enum('ABERTO','CONSOLIDADO','CANCELADO') COLLATE utf8mb4_general_ci DEFAULT 'ABERTO',
  PRIMARY KEY (`id_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Itens faturáveis gerados a partir de eventos assistenciais';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_item`
--

LOCK TABLES `faturamento_item` WRITE;
/*!40000 ALTER TABLE `faturamento_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ffa`
--

DROP TABLE IF EXISTS `ffa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ffa` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_paciente` bigint NOT NULL,
  `gpat` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO','MEDICACAO','AGUARDANDO_MEDICACAO','AGUARDANDO_RX','EM_RX','AGUARDANDO_COLETA','EM_COLETA','AGUARDANDO_ECG','EM_ECG','ALTA','TRANSFERENCIA','INTERNACAO','FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA') COLLATE utf8mb4_general_ci NOT NULL,
  `layout` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_usuario_criacao` bigint NOT NULL,
  `id_usuario_alteracao` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  `classificacao_manchester` enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `linha_assistencial` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_senha` bigint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ffa`
--

LOCK TABLES `ffa` WRITE;
/*!40000 ALTER TABLE `ffa` DISABLE KEYS */;
INSERT INTO `ffa` VALUES (1,1,NULL,'ABERTO','CLINICO',10,NULL,'2026-01-14 03:52:41','2026-01-14 03:52:41',NULL,NULL,2);
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

--
-- Table structure for table `ffa_prioridade`
--

DROP TABLE IF EXISTS `ffa_prioridade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ffa_prioridade` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `codigo_prioridade` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ffa_prioridade`
--

LOCK TABLES `ffa_prioridade` WRITE;
/*!40000 ALTER TABLE `ffa_prioridade` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_prioridade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ffa_procedimento`
--

DROP TABLE IF EXISTS `ffa_procedimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ffa_procedimento` (
  `id_procedimento` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `tipo` enum('RX','ECG','LABORATORIO','MEDICACAO','OBSERVACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('SOLICITADO','EM_FILA','EM_EXECUCAO','CONCLUIDO','CRITICO') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'SOLICITADO',
  `prioridade` enum('NORMAL','EMERGENCIA') COLLATE utf8mb4_general_ci DEFAULT 'NORMAL',
  `id_usuario_solicitante` bigint DEFAULT NULL,
  `id_usuario_execucao` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `iniciado_em` datetime DEFAULT NULL,
  `finalizado_em` datetime DEFAULT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id_procedimento`),
  KEY `idx_ffa` (`id_ffa`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Procedimentos paralelos do PA';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ffa_procedimento`
--

LOCK TABLES `ffa_procedimento` WRITE;
/*!40000 ALTER TABLE `ffa_procedimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_procedimento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ffa_substatus`
--

DROP TABLE IF EXISTS `ffa_substatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ffa_substatus` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `categoria` enum('MEDICACAO','FARMACIA','OBSERVACAO','RX','ECG','COLETA','OUTRO') COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `finalizado_em` datetime DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  KEY `idx_ffa_categoria` (`id_ffa`,`categoria`,`ativo`),
  CONSTRAINT `ffa_substatus_ibfk_1` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ffa_substatus_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Substatus assistenciais da FFA';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ffa_substatus`
--

LOCK TABLES `ffa_substatus` WRITE;
/*!40000 ALTER TABLE `ffa_substatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_substatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fila_evento`
--

DROP TABLE IF EXISTS `fila_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fila_evento` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_fila` bigint NOT NULL,
  `evento` enum('GERADA','CHAMADA','NAO_ATENDIDO','REENTRADA','ABERTURA_FFA','ENCAMINHAMENTO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `id_local` bigint DEFAULT NULL,
  `detalhe` text COLLATE utf8mb4_general_ci,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_fila` (`id_fila`),
  CONSTRAINT `fila_evento_ibfk_1` FOREIGN KEY (`id_fila`) REFERENCES `fila_senha` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fila_evento`
--

LOCK TABLES `fila_evento` WRITE;
/*!40000 ALTER TABLE `fila_evento` DISABLE KEYS */;
INSERT INTO `fila_evento` VALUES (5,3,'ABERTURA_FFA',10,NULL,'Teste com fila válida','2026-01-14 04:31:01');
/*!40000 ALTER TABLE `fila_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fila_operacional`
--

DROP TABLE IF EXISTS `fila_operacional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fila_operacional` (
  `id_fila` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL COMMENT 'Episódio assistencial',
  `tipo` enum('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO') COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Tipo de fila',
  `substatus` enum('AGUARDANDO','EM_EXECUCAO','EM_OBSERVACAO','FINALIZADO','CRITICO') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'AGUARDANDO' COMMENT 'Substatus do paciente nesta fila',
  `prioridade` enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') COLLATE utf8mb4_general_ci DEFAULT 'AZUL' COMMENT 'Prioridade de Manchester',
  `data_entrada` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Chegada na fila',
  `data_inicio` datetime DEFAULT NULL COMMENT 'Início do atendimento/exame',
  `data_fim` datetime DEFAULT NULL COMMENT 'Término do atendimento/exame',
  `id_responsavel` bigint DEFAULT NULL COMMENT 'Usuário que está atendendo/executando',
  `observacao` text COLLATE utf8mb4_general_ci COMMENT 'Notas ou observações específicas',
  `id_local` bigint DEFAULT NULL,
  PRIMARY KEY (`id_fila`),
  KEY `id_responsavel` (`id_responsavel`),
  KEY `id_local` (`id_local`),
  KEY `idx_ffa_tipo_substatus` (`id_ffa`,`tipo`,`substatus`),
  KEY `idx_tipo_prioridade` (`tipo`,`prioridade`,`substatus`),
  CONSTRAINT `fila_operacional_ibfk_1` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fila_operacional_ibfk_2` FOREIGN KEY (`id_responsavel`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `fila_operacional_ibfk_3` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Fila operacional de todos os atendimentos, procedimentos, exames, medicação e observação';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fila_operacional`
--

LOCK TABLES `fila_operacional` WRITE;
/*!40000 ALTER TABLE `fila_operacional` DISABLE KEYS */;
/*!40000 ALTER TABLE `fila_operacional` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fila_retorno`
--

DROP TABLE IF EXISTS `fila_retorno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fila_retorno` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_fila` bigint NOT NULL,
  `retorno_em` datetime NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_fila` (`id_fila`),
  CONSTRAINT `fila_retorno_ibfk_1` FOREIGN KEY (`id_fila`) REFERENCES `fila_senha` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fila_retorno`
--

LOCK TABLES `fila_retorno` WRITE;
/*!40000 ALTER TABLE `fila_retorno` DISABLE KEYS */;
INSERT INTO `fila_retorno` VALUES (1,1,'2025-12-29 03:12:37',1,'2025-12-29 03:07:37');
/*!40000 ALTER TABLE `fila_retorno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fila_senha`
--

DROP TABLE IF EXISTS `fila_senha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fila_senha` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `senha` bigint NOT NULL,
  `id_paciente` bigint NOT NULL,
  `prioridade_recepcao` enum('PADRAO','IDOSO','CRONICO') COLLATE utf8mb4_general_ci DEFAULT 'PADRAO',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `senha` (`senha`),
  CONSTRAINT `fila_senha_ibfk_1` FOREIGN KEY (`senha`) REFERENCES `senhas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fila_senha`
--

LOCK TABLES `fila_senha` WRITE;
/*!40000 ALTER TABLE `fila_senha` DISABLE KEYS */;
INSERT INTO `fila_senha` VALUES (2,1,1,'PADRAO','2026-01-14 03:46:49'),(3,2,1,'PADRAO','2026-01-14 03:49:53');
/*!40000 ALTER TABLE `fila_senha` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fluxo_status`
--

DROP TABLE IF EXISTS `fluxo_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fluxo_status` (
  `status_origem` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `status_destino` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `origem_evento` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `permitido` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`status_origem`,`status_destino`,`origem_evento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fluxo_status`
--

LOCK TABLES `fluxo_status` WRITE;
/*!40000 ALTER TABLE `fluxo_status` DISABLE KEYS */;
INSERT INTO `fluxo_status` VALUES ('ABERTO','EM_TRIAGEM','PAINEL_TRIAGEM',1),('AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','PAINEL_MEDICO',1),('AGUARDANDO_RX','EM_RX','PAINEL_PROCEDIMENTO',1),('CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','PAINEL_MEDICO',1),('EM_ATENDIMENTO_MEDICO','AGUARDANDO_RX','PAINEL_MEDICO',1),('EM_ATENDIMENTO_MEDICO','ALTA','PAINEL_MEDICO',1),('EM_RX','AGUARDANDO_CHAMADA_MEDICO','PAINEL_PROCEDIMENTO',1),('EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','PAINEL_TRIAGEM',1);
/*!40000 ALTER TABLE `fluxo_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fornecedor`
--

DROP TABLE IF EXISTS `fornecedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fornecedor` (
  `id_fornecedor` bigint NOT NULL AUTO_INCREMENT,
  `razao_social` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `nome_fantasia` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cnpj` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `contato` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_fornecedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fornecedor`
--

LOCK TABLES `fornecedor` WRITE;
/*!40000 ALTER TABLE `fornecedor` DISABLE KEYS */;
/*!40000 ALTER TABLE `fornecedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gaso_evento`
--

DROP TABLE IF EXISTS `gaso_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gaso_evento` (
  `id_gaso_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_gaso` bigint NOT NULL,
  `evento` varchar(80) NOT NULL,
  `detalhe` text,
  `id_usuario` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_gaso_evento`),
  KEY `idx_ge_gaso` (`id_gaso`),
  KEY `fk_ge_user` (`id_usuario`),
  CONSTRAINT `fk_ge_gaso` FOREIGN KEY (`id_gaso`) REFERENCES `gaso_solicitacao` (`id_gaso`),
  CONSTRAINT `fk_ge_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gaso_evento`
--

LOCK TABLES `gaso_evento` WRITE;
/*!40000 ALTER TABLE `gaso_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `gaso_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gaso_solicitacao`
--

DROP TABLE IF EXISTS `gaso_solicitacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gaso_solicitacao` (
  `id_gaso` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `id_senha` bigint DEFAULT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `tipo` enum('CILINDRO','REDE','MANUTENCAO','OUTRO') NOT NULL DEFAULT 'OUTRO',
  `status` enum('ABERTO','EM_ATENDIMENTO','ENTREGUE','CANCELADO','FINALIZADO') NOT NULL DEFAULT 'ABERTO',
  `local_destino` varchar(150) DEFAULT NULL,
  `observacao` text,
  `id_usuario_abertura` bigint NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_gaso`),
  KEY `idx_gaso_status` (`status`),
  KEY `fk_gaso_unidade` (`id_unidade`),
  KEY `fk_gaso_user` (`id_usuario_abertura`),
  CONSTRAINT `fk_gaso_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
  CONSTRAINT `fk_gaso_user` FOREIGN KEY (`id_usuario_abertura`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gaso_solicitacao`
--

LOCK TABLES `gaso_solicitacao` WRITE;
/*!40000 ALTER TABLE `gaso_solicitacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `gaso_solicitacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hipotese_diagnostica`
--

DROP TABLE IF EXISTS `hipotese_diagnostica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hipotese_diagnostica` (
  `id_hipotese` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `cid10` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `principal` tinyint(1) DEFAULT '0',
  `id_medico` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_hipotese`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `hipotese_diagnostica_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `hipotese_diagnostica_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hipotese_diagnostica`
--

LOCK TABLES `hipotese_diagnostica` WRITE;
/*!40000 ALTER TABLE `hipotese_diagnostica` DISABLE KEYS */;
/*!40000 ALTER TABLE `hipotese_diagnostica` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interconsulta`
--

DROP TABLE IF EXISTS `interconsulta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interconsulta` (
  `id_interconsulta` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `id_especialidade` int NOT NULL,
  `motivo` text COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('SOLICITADA','RESPONDIDA') COLLATE utf8mb4_general_ci DEFAULT 'SOLICITADA',
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_interconsulta`),
  KEY `id_internacao` (`id_internacao`),
  KEY `id_especialidade` (`id_especialidade`),
  CONSTRAINT `interconsulta_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `interconsulta_ibfk_2` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interconsulta`
--

LOCK TABLES `interconsulta` WRITE;
/*!40000 ALTER TABLE `interconsulta` DISABLE KEYS */;
/*!40000 ALTER TABLE `interconsulta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `intercorrencia`
--

DROP TABLE IF EXISTS `intercorrencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `intercorrencia` (
  `id_intercorrencia` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_internacao` bigint DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `gravidade` enum('LEVE','MODERADA','GRAVE') COLLATE utf8mb4_general_ci DEFAULT 'LEVE',
  `id_usuario` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_intercorrencia`),
  KEY `id_usuario` (`id_usuario`),
  KEY `idx_intercorrencia_atendimento` (`id_atendimento`),
  KEY `idx_intercorrencia_internacao` (`id_internacao`),
  CONSTRAINT `intercorrencia_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `intercorrencia_ibfk_2` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `intercorrencia_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intercorrencia`
--

LOCK TABLES `intercorrencia` WRITE;
/*!40000 ALTER TABLE `intercorrencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `intercorrencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internacao`
--

DROP TABLE IF EXISTS `internacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao` (
  `id_internacao` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_leito` int DEFAULT NULL,
  `tipo` enum('OBSERVACAO','INTERNACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `motivo` text COLLATE utf8mb4_general_ci,
  `status` enum('ATIVA','ENCERRADA','TRANSFERIDA','OBITO') COLLATE utf8mb4_general_ci DEFAULT 'ATIVA',
  `data_entrada` datetime NOT NULL,
  `id_usuario_entrada` bigint DEFAULT NULL,
  `data_saida` datetime DEFAULT NULL,
  `id_usuario_saida` bigint DEFAULT NULL,
  `motivo_alta` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `encerrado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_internacao`),
  KEY `idx_ffa` (`id_ffa`),
  KEY `idx_status` (`status`),
  KEY `idx_leito` (`id_leito`),
  CONSTRAINT `fk_internacao_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Internação e observação clínica';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao`
--

LOCK TABLES `internacao` WRITE;
/*!40000 ALTER TABLE `internacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_unica_internacao_ativa` BEFORE INSERT ON `internacao` FOR EACH ROW BEGIN
    IF EXISTS (
        SELECT 1
        FROM internacao
        WHERE id_ffa = NEW.id_ffa
          AND status = 'ATIVA'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Já existe uma internação ativa para este FFA';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_ocupa_leito` BEFORE INSERT ON `internacao` FOR EACH ROW BEGIN
    IF NEW.status = 'ATIVA' THEN

        IF NOT EXISTS (
            SELECT 1
            FROM leito
            WHERE id_leito = NEW.id_leito
              AND status = 'LIVRE'
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Leito não está disponível';
        END IF;

        UPDATE leito
           SET status = 'OCUPADO'
         WHERE id_leito = NEW.id_leito;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_libera_leito` AFTER UPDATE ON `internacao` FOR EACH ROW BEGIN
    IF OLD.status = 'ATIVA'
       AND NEW.status = 'ENCERRADA' THEN

        UPDATE leito
           SET status = 'LIVRE'
         WHERE id_leito = OLD.id_leito;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `internacao_historico`
--

DROP TABLE IF EXISTS `internacao_historico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao_historico` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `evento` enum('ENTRADA','TROCA_LEITO','ALTA','TRANSFERENCIA','OBITO') COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_internacao` (`id_internacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Histórico imutável da internação';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao_historico`
--

LOCK TABLES `internacao_historico` WRITE;
/*!40000 ALTER TABLE `internacao_historico` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_historico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leito`
--

DROP TABLE IF EXISTS `leito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leito` (
  `id_leito` int NOT NULL AUTO_INCREMENT,
  `id_setor` int NOT NULL,
  `identificacao` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('LIVRE','OCUPADO','BLOQUEADO') COLLATE utf8mb4_general_ci DEFAULT 'LIVRE',
  PRIMARY KEY (`id_leito`),
  UNIQUE KEY `uk_setor_leito` (`id_setor`,`identificacao`),
  CONSTRAINT `leito_ibfk_1` FOREIGN KEY (`id_setor`) REFERENCES `setor` (`id_setor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leito`
--

LOCK TABLES `leito` WRITE;
/*!40000 ALTER TABLE `leito` DISABLE KEYS */;
/*!40000 ALTER TABLE `leito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `local_atendimento`
--

DROP TABLE IF EXISTS `local_atendimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `local_atendimento` (
  `id_local` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('RECEPCAO','TRIAGEM','CONSULTORIO','EMERGENCIA','OBSERVACAO','INTERNACAO','MEDICACAO','RX','LABORATORIO','ECG','NOTIFICACAO','FARMACIA','COPA','COLETA','OUTROS') COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_unidade` bigint NOT NULL,
  PRIMARY KEY (`id_local`),
  KEY `fk_local_sistema` (`id_unidade`),
  CONSTRAINT `fk_local_sistema` FOREIGN KEY (`id_unidade`) REFERENCES `sistema` (`id_sistema`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `local_atendimento`
--

LOCK TABLES `local_atendimento` WRITE;
/*!40000 ALTER TABLE `local_atendimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `local_atendimento` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `local_operacional`
--

LOCK TABLES `local_operacional` WRITE;
/*!40000 ALTER TABLE `local_operacional` DISABLE KEYS */;
/*!40000 ALTER TABLE `local_operacional` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `local_usuario`
--

DROP TABLE IF EXISTS `local_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `local_usuario` (
  `id_local_usuario` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('RECEPCAO','MEDICO','TRIAGEM','SUPORTE','ADMIN','GESTAO') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'RECEPCAO',
  `ativo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_local_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `local_usuario`
--

LOCK TABLES `local_usuario` WRITE;
/*!40000 ALTER TABLE `local_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `local_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_auditoria`
--

DROP TABLE IF EXISTS `log_auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_auditoria` (
  `id_log` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint DEFAULT NULL,
  `acao` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tabela_afetada` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_registro` bigint DEFAULT NULL,
  `antes` text COLLATE utf8mb4_general_ci,
  `depois` text COLLATE utf8mb4_general_ci,
  `justificativa` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_auditoria`
--

LOCK TABLES `log_auditoria` WRITE;
/*!40000 ALTER TABLE `log_auditoria` DISABLE KEYS */;
INSERT INTO `log_auditoria` VALUES (1,10,'INSERT','ffa',1,NULL,'status: ABERTO, paciente: 1',NULL,'2026-01-14 03:52:41');
/*!40000 ALTER TABLE `log_auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logradouro`
--

DROP TABLE IF EXISTS `logradouro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logradouro` (
  `id_logradouro` bigint NOT NULL AUTO_INCREMENT,
  `cep` varchar(9) COLLATE utf8mb4_general_ci NOT NULL,
  `logradouro` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `numero` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `complemento` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bairro` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cidade` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `uf` char(2) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_logradouro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logradouro`
--

LOCK TABLES `logradouro` WRITE;
/*!40000 ALTER TABLE `logradouro` DISABLE KEYS */;
/*!40000 ALTER TABLE `logradouro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manutencao_execucao`
--

DROP TABLE IF EXISTS `manutencao_execucao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manutencao_execucao` (
  `id_execucao` bigint NOT NULL AUTO_INCREMENT,
  `id_chamado` bigint NOT NULL,
  `tecnico` bigint NOT NULL,
  `descricao_servico` text COLLATE utf8mb4_general_ci,
  `inicio_em` datetime DEFAULT NULL,
  `fim_em` datetime DEFAULT NULL,
  `status` enum('INICIADO','PAUSADO','FINALIZADO') COLLATE utf8mb4_general_ci DEFAULT 'INICIADO',
  PRIMARY KEY (`id_execucao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Execução técnica do chamado de manutenção';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manutencao_execucao`
--

LOCK TABLES `manutencao_execucao` WRITE;
/*!40000 ALTER TABLE `manutencao_execucao` DISABLE KEYS */;
/*!40000 ALTER TABLE `manutencao_execucao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medico`
--

DROP TABLE IF EXISTS `medico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medico` (
  `id_usuario` bigint NOT NULL,
  `crm` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `uf_crm` char(2) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uk_crm` (`crm`,`uf_crm`),
  CONSTRAINT `medico_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medico`
--

LOCK TABLES `medico` WRITE;
/*!40000 ALTER TABLE `medico` DISABLE KEYS */;
/*!40000 ALTER TABLE `medico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medico_especialidade`
--

DROP TABLE IF EXISTS `medico_especialidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medico_especialidade` (
  `id_usuario` bigint NOT NULL,
  `id_especialidade` int NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_especialidade`),
  KEY `id_especialidade` (`id_especialidade`),
  CONSTRAINT `medico_especialidade_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `medico` (`id_usuario`),
  CONSTRAINT `medico_especialidade_ibfk_2` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medico_especialidade`
--

LOCK TABLES `medico_especialidade` WRITE;
/*!40000 ALTER TABLE `medico_especialidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `medico_especialidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicos`
--

DROP TABLE IF EXISTS `medicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicos` (
  `id_medico` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `nome` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `crm` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_especialidade` int DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_medico`),
  UNIQUE KEY `crm` (`crm`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_especialidade` (`id_especialidade`),
  CONSTRAINT `medicos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `medicos_ibfk_2` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicos`
--

LOCK TABLES `medicos` WRITE;
/*!40000 ALTER TABLE `medicos` DISABLE KEYS */;
/*!40000 ALTER TABLE `medicos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `observacoes_eventos`
--

DROP TABLE IF EXISTS `observacoes_eventos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `observacoes_eventos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `entidade` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'FILA_SENHA, FFA, PRESCRICAO, AGENDAMENTO',
  `id_entidade` bigint NOT NULL,
  `contexto` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'MEDICO, ENFERMAGEM, TECNICA, ADMIN',
  `tipo` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'OBSERVACAO, ALERTA, EVASAO, ORIENTACAO',
  `texto` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  KEY `idx_entidade` (`entidade`,`id_entidade`),
  CONSTRAINT `observacoes_eventos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Observações e comunicações como eventos';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `observacoes_eventos`
--

LOCK TABLES `observacoes_eventos` WRITE;
/*!40000 ALTER TABLE `observacoes_eventos` DISABLE KEYS */;
INSERT INTO `observacoes_eventos` VALUES (1,'FFA',12345,'MEDICO','ORIENTACAO','Paciente aguardar 30 minutos antes da medicação',10,'2026-01-04 00:41:46');
/*!40000 ALTER TABLE `observacoes_eventos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordem_assistencial`
--

DROP TABLE IF EXISTS `ordem_assistencial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordem_assistencial` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `tipo_ordem` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('ATIVA','SUSPENSA','ENCERRADA') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATIVA',
  `origem` enum('MEDICO','ENFERMAGEM') COLLATE utf8mb4_general_ci NOT NULL,
  `payload_clinico` json NOT NULL,
  `prioridade` int DEFAULT '0',
  `iniciado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `suspenso_em` datetime DEFAULT NULL,
  `encerrado_em` datetime DEFAULT NULL,
  `motivo_suspensao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `motivo_encerramento` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `criado_por` bigint NOT NULL,
  `atualizado_em` datetime DEFAULT NULL,
  `atualizado_por` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ordem_ffa` (`id_ffa`),
  KEY `idx_ordem_status` (`status`),
  KEY `idx_ordem_tipo` (`tipo_ordem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordem_assistencial`
--

LOCK TABLES `ordem_assistencial` WRITE;
/*!40000 ALTER TABLE `ordem_assistencial` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordem_assistencial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paciente`
--

DROP TABLE IF EXISTS `paciente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paciente` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `prontuario` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_cadastro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `prontuario` (`prontuario`),
  KEY `id_pessoa` (`id_pessoa`),
  CONSTRAINT `paciente_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paciente`
--

LOCK TABLES `paciente` WRITE;
/*!40000 ALTER TABLE `paciente` DISABLE KEYS */;
/*!40000 ALTER TABLE `paciente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perfil`
--

DROP TABLE IF EXISTS `perfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfil` (
  `id_perfil` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_perfil`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfil`
--

LOCK TABLES `perfil` WRITE;
/*!40000 ALTER TABLE `perfil` DISABLE KEYS */;
INSERT INTO `perfil` VALUES (1,'ADMIN'),(3,'ENFERMAGEM'),(6,'MASTER'),(4,'MEDICO'),(5,'PAINEL'),(2,'RECEPCAO');
/*!40000 ALTER TABLE `perfil` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perfil_permissao`
--

DROP TABLE IF EXISTS `perfil_permissao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfil_permissao` (
  `id_perfil` int NOT NULL,
  `id_permissao` int NOT NULL,
  `permissao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_perfil`,`id_permissao`),
  KEY `id_permissao` (`id_permissao`),
  CONSTRAINT `perfil_permissao_ibfk_1` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`),
  CONSTRAINT `perfil_permissao_ibfk_2` FOREIGN KEY (`id_permissao`) REFERENCES `permissao` (`id_permissao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfil_permissao`
--

LOCK TABLES `perfil_permissao` WRITE;
/*!40000 ALTER TABLE `perfil_permissao` DISABLE KEYS */;
INSERT INTO `perfil_permissao` VALUES (2,8,NULL),(4,2,NULL),(4,7,NULL),(5,3,NULL),(5,4,NULL),(5,5,NULL),(7,9,NULL);
/*!40000 ALTER TABLE `perfil_permissao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissao`
--

DROP TABLE IF EXISTS `permissao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissao` (
  `id_permissao` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_permissao`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissao`
--

LOCK TABLES `permissao` WRITE;
/*!40000 ALTER TABLE `permissao` DISABLE KEYS */;
INSERT INTO `permissao` VALUES (1,'ABRIR_ATENDIMENTO','Abrir atendimento'),(2,'REGISTRAR_TRIAGEM','Registrar triagem'),(3,'REALIZAR_ANAMNESE','Registrar anamnese'),(4,'PRESCREVER','Emitir prescrição'),(5,'FINALIZAR_ATENDIMENTO','Finalizar atendimento'),(6,'REABRIR_ATENDIMENTO','Reabrir atendimento'),(7,'ADMINISTRAR_MEDICACAO','Administrar medicação'),(8,'VER_RELATORIOS','Acessar relatórios'),(9,'VER_AUDITORIA','Visualizar auditoria');
/*!40000 ALTER TABLE `permissao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissao_procedure`
--

DROP TABLE IF EXISTS `permissao_procedure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissao_procedure` (
  `id_perfil` int NOT NULL,
  `procedure_nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_perfil`,`procedure_nome`),
  CONSTRAINT `permissao_procedure_ibfk_1` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissao_procedure`
--

LOCK TABLES `permissao_procedure` WRITE;
/*!40000 ALTER TABLE `permissao_procedure` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissao_procedure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pessoa`
--

DROP TABLE IF EXISTS `pessoa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pessoa` (
  `id_pessoa` bigint NOT NULL AUTO_INCREMENT,
  `nome_completo` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `nome_social` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cpf` varchar(14) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cns` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rg` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rg_uf` char(2) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_nascimento` date DEFAULT NULL,
  `sexo` enum('M','F','O') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nome_mae` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefone` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rg_orgao` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dt_nascimento` date DEFAULT NULL,
  PRIMARY KEY (`id_pessoa`),
  UNIQUE KEY `uk_pessoa_cpf` (`cpf`),
  UNIQUE KEY `uk_pessoa_cns` (`cns`),
  KEY `idx_pessoa_nascimento` (`data_nascimento`),
  KEY `idx_pessoa_rg` (`rg`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa`
--

LOCK TABLES `pessoa` WRITE;
/*!40000 ALTER TABLE `pessoa` DISABLE KEYS */;
INSERT INTO `pessoa` VALUES (1,'Teste Usuario',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'Yasnanakase Master','Yasnanakase',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'Yasnanakase Master','Yasnanakase',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,'Yasnanakase Master','Yasnanakase',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `pessoa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pessoa_contato`
--

DROP TABLE IF EXISTS `pessoa_contato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pessoa_contato` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `tipo` enum('EMAIL','TELEFONE','WHATSAPP') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `valor` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `principal` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_pessoa` (`id_pessoa`),
  CONSTRAINT `pessoa_contato_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa_contato`
--

LOCK TABLES `pessoa_contato` WRITE;
/*!40000 ALTER TABLE `pessoa_contato` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_contato` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pessoa_logradouro`
--

DROP TABLE IF EXISTS `pessoa_logradouro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pessoa_logradouro` (
  `id_pessoa` bigint NOT NULL,
  `id_logradouro` bigint NOT NULL,
  `principal` tinyint(1) DEFAULT '1',
  `data_inicio` date NOT NULL,
  `data_fim` date DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_pessoa`,`id_logradouro`,`data_inicio`),
  KEY `id_logradouro` (`id_logradouro`),
  KEY `idx_pessoa_logradouro_ativo` (`id_pessoa`,`ativo`),
  KEY `idx_pessoa_logradouro_principal` (`id_pessoa`,`principal`),
  CONSTRAINT `pessoa_logradouro_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`),
  CONSTRAINT `pessoa_logradouro_ibfk_2` FOREIGN KEY (`id_logradouro`) REFERENCES `logradouro` (`id_logradouro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa_logradouro`
--

LOCK TABLES `pessoa_logradouro` WRITE;
/*!40000 ALTER TABLE `pessoa_logradouro` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_logradouro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plantao`
--

DROP TABLE IF EXISTS `plantao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plantao` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_medico` bigint NOT NULL,
  `nome_medico` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_plantao` enum('CLINICO','PEDIATRIA','EMERGENCIA') COLLATE utf8mb4_general_ci NOT NULL,
  `inicio_plantao` datetime NOT NULL,
  `fim_plantao` datetime NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plantao`
--

LOCK TABLES `plantao` WRITE;
/*!40000 ALTER TABLE `plantao` DISABLE KEYS */;
/*!40000 ALTER TABLE `plantao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plantao_modelo`
--

DROP TABLE IF EXISTS `plantao_modelo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plantao_modelo` (
  `id_plantao_modelo` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `inicio` time NOT NULL,
  `fim` time NOT NULL,
  `atravessa_dia` tinyint(1) DEFAULT '0',
  `horas_previstas` decimal(5,2) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_plantao_modelo`),
  UNIQUE KEY `uk_pm_nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plantao_modelo`
--

LOCK TABLES `plantao_modelo` WRITE;
/*!40000 ALTER TABLE `plantao_modelo` DISABLE KEYS */;
/*!40000 ALTER TABLE `plantao_modelo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plantoes`
--

DROP TABLE IF EXISTS `plantoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plantoes` (
  `id_plantao` bigint NOT NULL AUTO_INCREMENT,
  `id_medico` bigint NOT NULL,
  `data` date NOT NULL,
  `turno` enum('DIA','NOITE','24H','CUSTOM') COLLATE utf8mb4_general_ci NOT NULL,
  `hora_inicio` time DEFAULT NULL,
  `hora_fim` time DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_plantao`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `plantoes_ibfk_1` FOREIGN KEY (`id_medico`) REFERENCES `medicos` (`id_medico`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plantoes`
--

LOCK TABLES `plantoes` WRITE;
/*!40000 ALTER TABLE `plantoes` DISABLE KEYS */;
/*!40000 ALTER TABLE `plantoes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescricao`
--

DROP TABLE IF EXISTS `prescricao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescricao` (
  `id_prescricao` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `tipo` enum('INTERNA','CONTROLADA','CASA') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_medico` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `bloqueada` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_prescricao`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `prescricao_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `prescricao_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescricao`
--

LOCK TABLES `prescricao` WRITE;
/*!40000 ALTER TABLE `prescricao` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescricao_continua`
--

DROP TABLE IF EXISTS `prescricao_continua`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescricao_continua` (
  `id_prescricao` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `tipo` enum('MEDICAMENTOS','CUIDADOS_GERAIS') COLLATE utf8mb4_general_ci NOT NULL,
  `id_medico` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `ativa` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_prescricao`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `prescricao_continua_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `prescricao_continua_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescricao_continua`
--

LOCK TABLES `prescricao_continua` WRITE;
/*!40000 ALTER TABLE `prescricao_continua` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_continua` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescricao_internacao`
--

DROP TABLE IF EXISTS `prescricao_internacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescricao_internacao` (
  `id_prescricao` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `tipo` enum('MEDICAMENTO','CUIDADO','DIETA','OUTROS') COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_medico` bigint NOT NULL,
  `ativa` tinyint(1) DEFAULT '1',
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_prescricao`),
  KEY `id_internacao` (`id_internacao`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `prescricao_internacao_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `prescricao_internacao_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescricao_internacao`
--

LOCK TABLES `prescricao_internacao` WRITE;
/*!40000 ALTER TABLE `prescricao_internacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_internacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescricao_item`
--

DROP TABLE IF EXISTS `prescricao_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescricao_item` (
  `id_item` bigint NOT NULL AUTO_INCREMENT,
  `id_prescricao` bigint NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `dose` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `posologia` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id_item`),
  KEY `id_prescricao` (`id_prescricao`),
  CONSTRAINT `prescricao_item_ibfk_1` FOREIGN KEY (`id_prescricao`) REFERENCES `prescricao_continua` (`id_prescricao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescricao_item`
--

LOCK TABLES `prescricao_item` WRITE;
/*!40000 ALTER TABLE `prescricao_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescricao_medicacao`
--

DROP TABLE IF EXISTS `prescricao_medicacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescricao_medicacao` (
  `id_prescricao` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_medico` bigint NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Descrição livre da prescrição',
  `controlada` tinyint(1) DEFAULT '0' COMMENT 'Se exige liberação da farmácia',
  `criada_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `ativa` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_prescricao`),
  KEY `id_medico` (`id_medico`),
  KEY `idx_ffa` (`id_ffa`),
  CONSTRAINT `prescricao_medicacao_ibfk_1` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`) ON DELETE CASCADE,
  CONSTRAINT `prescricao_medicacao_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Prescrições de medicação do PA';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescricao_medicacao`
--

LOCK TABLES `prescricao_medicacao` WRITE;
/*!40000 ALTER TABLE `prescricao_medicacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_medicacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prioridade_social`
--

DROP TABLE IF EXISTS `prioridade_social`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prioridade_social` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `peso` int NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prioridade_social`
--

LOCK TABLES `prioridade_social` WRITE;
/*!40000 ALTER TABLE `prioridade_social` DISABLE KEYS */;
INSERT INTO `prioridade_social` VALUES (1,'IDOSO','Paciente idoso',20,1),(2,'AUTISTA','Paciente com TEA',25,1),(3,'PCD','Pessoa com deficiência',20,1),(4,'GESTANTE','Gestante',15,1),(5,'CRIANCACOLO','Criança de colo',15,1);
/*!40000 ALTER TABLE `prioridade_social` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtividade_evento`
--

DROP TABLE IF EXISTS `produtividade_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtividade_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `tipo` enum('INICIO_ATENDIMENTO','FIM_ATENDIMENTO','EVOLUCAO','PRESCRICAO','ENCAMINHAMENTO','OUTRO') NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_senha` bigint DEFAULT NULL,
  `ocorrido_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `detalhe` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  KEY `idx_pe_user_time` (`id_usuario`,`ocorrido_em`),
  KEY `idx_pe_tipo_time` (`tipo`,`ocorrido_em`),
  KEY `fk_pe_unidade` (`id_unidade`),
  CONSTRAINT `fk_pe_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
  CONSTRAINT `fk_pe_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtividade_evento`
--

LOCK TABLES `produtividade_evento` WRITE;
/*!40000 ALTER TABLE `produtividade_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `produtividade_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos_almoxarifado`
--

DROP TABLE IF EXISTS `produtos_almoxarifado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos_almoxarifado` (
  `id_produto` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `categoria` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Ex: escritório, manutenção, EPI, TI',
  `unidade_medida` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Produtos do almoxarifado';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos_almoxarifado`
--

LOCK TABLES `produtos_almoxarifado` WRITE;
/*!40000 ALTER TABLE `produtos_almoxarifado` DISABLE KEYS */;
/*!40000 ALTER TABLE `produtos_almoxarifado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos_farmacia`
--

DROP TABLE IF EXISTS `produtos_farmacia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos_farmacia` (
  `id_produto` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `principio_ativo` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `unidade_medida` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('MEDICAMENTO','INSUMO','OUTRO') COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos_farmacia`
--

LOCK TABLES `produtos_farmacia` WRITE;
/*!40000 ALTER TABLE `produtos_farmacia` DISABLE KEYS */;
/*!40000 ALTER TABLE `produtos_farmacia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos_limpeza`
--

DROP TABLE IF EXISTS `produtos_limpeza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos_limpeza` (
  `id_produto` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Nome do produto',
  `tipo` enum('LIMPEZA','MANUTENCAO','OUTRO') COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Tipo de produto',
  PRIMARY KEY (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Produtos para limpeza e manutenção';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos_limpeza`
--

LOCK TABLES `produtos_limpeza` WRITE;
/*!40000 ALTER TABLE `produtos_limpeza` DISABLE KEYS */;
/*!40000 ALTER TABLE `produtos_limpeza` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `protocolo_sequencia`
--

DROP TABLE IF EXISTS `protocolo_sequencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `protocolo_sequencia` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `protocolo_sequencia`
--

LOCK TABLES `protocolo_sequencia` WRITE;
/*!40000 ALTER TABLE `protocolo_sequencia` DISABLE KEYS */;
INSERT INTO `protocolo_sequencia` VALUES (1,1,'2025-12-29 04:21:44'),(2,1,'2025-12-29 04:22:02'),(3,1,'2025-12-29 04:23:04'),(4,1,'2025-12-29 04:37:23'),(5,1,'2025-12-29 04:40:52'),(6,1,'2025-12-29 06:23:31');
/*!40000 ALTER TABLE `protocolo_sequencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reabertura_atendimento`
--

DROP TABLE IF EXISTS `reabertura_atendimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reabertura_atendimento` (
  `id_reabertura` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `motivo` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_reabertura`),
  KEY `idx_ffa` (`id_ffa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Reabertura de episódio/atendimento';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reabertura_atendimento`
--

LOCK TABLES `reabertura_atendimento` WRITE;
/*!40000 ALTER TABLE `reabertura_atendimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `reabertura_atendimento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regra_timeout`
--

DROP TABLE IF EXISTS `regra_timeout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regra_timeout` (
  `status` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `minutos` int DEFAULT NULL,
  `evento_timeout` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regra_timeout`
--

LOCK TABLES `regra_timeout` WRITE;
/*!40000 ALTER TABLE `regra_timeout` DISABLE KEYS */;
/*!40000 ALTER TABLE `regra_timeout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `remocao`
--

DROP TABLE IF EXISTS `remocao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `remocao` (
  `id_remocao` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `id_senha` bigint DEFAULT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `origem` varchar(150) DEFAULT NULL,
  `destino` varchar(150) DEFAULT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `status` enum('SOLICITADA','AUTORIZADA','EM_TRANSITO','CONCLUIDA','CANCELADA') NOT NULL DEFAULT 'SOLICITADA',
  `id_viatura` bigint DEFAULT NULL,
  `condutor_interno` varchar(150) DEFAULT NULL,
  `condutor_externo` varchar(150) DEFAULT NULL,
  `protocolo_cross` varchar(50) DEFAULT NULL,
  `id_usuario_solicitante` bigint NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_remocao`),
  KEY `idx_rem_status` (`status`),
  KEY `fk_rem_unidade` (`id_unidade`),
  KEY `fk_rem_viatura` (`id_viatura`),
  KEY `fk_rem_user` (`id_usuario_solicitante`),
  CONSTRAINT `fk_rem_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
  CONSTRAINT `fk_rem_user` FOREIGN KEY (`id_usuario_solicitante`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `fk_rem_viatura` FOREIGN KEY (`id_viatura`) REFERENCES `viatura` (`id_viatura`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `remocao`
--

LOCK TABLES `remocao` WRITE;
/*!40000 ALTER TABLE `remocao` DISABLE KEYS */;
/*!40000 ALTER TABLE `remocao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `remocao_evento`
--

DROP TABLE IF EXISTS `remocao_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `remocao_evento` (
  `id_remocao_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_remocao` bigint NOT NULL,
  `evento` varchar(80) NOT NULL,
  `detalhe` text,
  `id_usuario` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_remocao_evento`),
  KEY `idx_re_remocao` (`id_remocao`),
  KEY `fk_re_user` (`id_usuario`),
  CONSTRAINT `fk_re_remocao` FOREIGN KEY (`id_remocao`) REFERENCES `remocao` (`id_remocao`),
  CONSTRAINT `fk_re_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `remocao_evento`
--

LOCK TABLES `remocao_evento` WRITE;
/*!40000 ALTER TABLE `remocao_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `remocao_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `retorno_atendimento`
--

DROP TABLE IF EXISTS `retorno_atendimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retorno_atendimento` (
  `id_retorno` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento_origem` bigint DEFAULT NULL,
  `id_atendimento_retorno` bigint DEFAULT NULL,
  `motivo` text COLLATE utf8mb4_general_ci,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_retorno`),
  KEY `id_atendimento_origem` (`id_atendimento_origem`),
  KEY `id_atendimento_retorno` (`id_atendimento_retorno`),
  CONSTRAINT `retorno_atendimento_ibfk_1` FOREIGN KEY (`id_atendimento_origem`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `retorno_atendimento_ibfk_2` FOREIGN KEY (`id_atendimento_retorno`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `retorno_atendimento`
--

LOCK TABLES `retorno_atendimento` WRITE;
/*!40000 ALTER TABLE `retorno_atendimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `retorno_atendimento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sala`
--

DROP TABLE IF EXISTS `sala`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sala` (
  `id_sala` int NOT NULL AUTO_INCREMENT,
  `nome_exibicao` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `id_local` int NOT NULL,
  `id_especialidade` int DEFAULT NULL,
  `ativa` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sala`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Sala física de atendimento (exibição em painel e uso assistencial)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sala`
--

LOCK TABLES `sala` WRITE;
/*!40000 ALTER TABLE `sala` DISABLE KEYS */;
/*!40000 ALTER TABLE `sala` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sala_notificacao`
--

DROP TABLE IF EXISTS `sala_notificacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sala_notificacao` (
  `id_notificacao` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `id_senha` bigint DEFAULT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `tipo` enum('VIOLENCIA','AGRAVO','OUTRO') NOT NULL DEFAULT 'OUTRO',
  `status` enum('ABERTO','EM_ATENDIMENTO','FINALIZADO','CANCELADO') NOT NULL DEFAULT 'ABERTO',
  `detalhes` text,
  `id_usuario_abertura` bigint NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_notificacao`),
  KEY `fk_sn_unidade` (`id_unidade`),
  KEY `fk_sn_user` (`id_usuario_abertura`),
  CONSTRAINT `fk_sn_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
  CONSTRAINT `fk_sn_user` FOREIGN KEY (`id_usuario_abertura`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sala_notificacao`
--

LOCK TABLES `sala_notificacao` WRITE;
/*!40000 ALTER TABLE `sala_notificacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `sala_notificacao` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Table structure for table `sessao`
--

DROP TABLE IF EXISTS `sessao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessao` (
  `id_sessao` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `token` char(64) COLLATE utf8mb4_general_ci NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `expira_em` datetime DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_sessao`),
  UNIQUE KEY `token` (`token`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `sessao_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessao`
--

LOCK TABLES `sessao` WRITE;
/*!40000 ALTER TABLE `sessao` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessao_usuario`
--

DROP TABLE IF EXISTS `sessao_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessao_usuario` (
  `id_sessao_usuario` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `id_sistema` bigint NOT NULL,
  `id_unidade` bigint NOT NULL,
  `id_local_operacional` bigint NOT NULL,
  `sid_refresh` bigint DEFAULT NULL COMMENT 'Opcional: correlaciona com usuario_refresh.id_refresh',
  `ip` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `iniciado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `encerrado_em` datetime DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_sessao_usuario`),
  KEY `idx_su_usuario` (`id_usuario`),
  KEY `idx_su_contexto` (`id_sistema`,`id_unidade`,`id_local_operacional`),
  KEY `fk_su_unidade` (`id_unidade`),
  KEY `fk_su_localop` (`id_local_operacional`),
  CONSTRAINT `fk_su_localop` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
  CONSTRAINT `fk_su_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
  CONSTRAINT `fk_su_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
  CONSTRAINT `fk_su_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessao_usuario`
--

LOCK TABLES `sessao_usuario` WRITE;
/*!40000 ALTER TABLE `sessao_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessao_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `setor`
--

DROP TABLE IF EXISTS `setor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `setor` (
  `id_setor` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('OBSERVACAO','INTERNACAO','UTI') COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_setor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setor`
--

LOCK TABLES `setor` WRITE;
/*!40000 ALTER TABLE `setor` DISABLE KEYS */;
/*!40000 ALTER TABLE `setor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sigpat_procedimento`
--

DROP TABLE IF EXISTS `sigpat_procedimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sigpat_procedimento` (
  `id_sigpat` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('EXAME','PROCEDIMENTO','CONSULTA','OUTRO') COLLATE utf8mb4_general_ci NOT NULL,
  `grupo` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `subgrupo` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `setor_execucao` enum('RX','LABORATORIO','ECG','MEDICACAO','AMBULATORIO','OUTRO') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'OUTRO',
  `gera_faturamento` tinyint(1) DEFAULT '1',
  `exige_coleta` tinyint(1) DEFAULT '0',
  `criado_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sigpat`),
  UNIQUE KEY `uk_sigpat_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sigpat_procedimento`
--

LOCK TABLES `sigpat_procedimento` WRITE;
/*!40000 ALTER TABLE `sigpat_procedimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `sigpat_procedimento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema`
--

DROP TABLE IF EXISTS `sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema` (
  `id_sistema` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sistema`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema`
--

LOCK TABLES `sistema` WRITE;
/*!40000 ALTER TABLE `sistema` DISABLE KEYS */;
INSERT INTO `sistema` VALUES (1,'PA','Pronto Atendimento',1,'2026-01-17 22:59:54'),(2,'UBS','Unidade Básica de Saúde',1,'2026-01-17 22:59:54');
/*!40000 ALTER TABLE `sistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitacao_exame`
--

DROP TABLE IF EXISTS `solicitacao_exame`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitacao_exame` (
  `id_solicitacao` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `id_exame` int DEFAULT NULL,
  `id_sigpat` bigint DEFAULT NULL,
  `status` enum('SOLICITADO','COLETADO','EM_ANALISE','RESULTADO','CANCELADO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_medico` bigint DEFAULT NULL,
  `solicitado_em` datetime NOT NULL,
  PRIMARY KEY (`id_solicitacao`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_exame` (`id_exame`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `solicitacao_exame_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `solicitacao_exame_ibfk_2` FOREIGN KEY (`id_exame`) REFERENCES `exame` (`id_exame`),
  CONSTRAINT `solicitacao_exame_ibfk_3` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitacao_exame`
--

LOCK TABLES `solicitacao_exame` WRITE;
/*!40000 ALTER TABLE `solicitacao_exame` DISABLE KEYS */;
/*!40000 ALTER TABLE `solicitacao_exame` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status_timeout`
--

DROP TABLE IF EXISTS `status_timeout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_timeout` (
  `status` enum('AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','AGUARDANDO_RX','CHAMANDO_RX','AGUARDANDO_MEDICACAO','EM_MEDICACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `tempo_max_segundos` int NOT NULL,
  `status_fallback` enum('AGUARDANDO_CHAMADA_MEDICO','AGUARDANDO_RX','AGUARDANDO_MEDICACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status_timeout`
--

LOCK TABLES `status_timeout` WRITE;
/*!40000 ALTER TABLE `status_timeout` DISABLE KEYS */;
INSERT INTO `status_timeout` VALUES ('CHAMANDO_MEDICO',60,'AGUARDANDO_CHAMADA_MEDICO',1),('CHAMANDO_RX',90,'AGUARDANDO_RX',1),('EM_MEDICACAO',1800,'AGUARDANDO_MEDICACAO',1);
/*!40000 ALTER TABLE `status_timeout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `totem`
--

DROP TABLE IF EXISTS `totem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `totem` (
  `id_totem` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `descricao` varchar(150) DEFAULT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_totem`),
  UNIQUE KEY `uk_totem` (`id_unidade`,`codigo`),
  CONSTRAINT `fk_totem_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `totem`
--

LOCK TABLES `totem` WRITE;
/*!40000 ALTER TABLE `totem` DISABLE KEYS */;
/*!40000 ALTER TABLE `totem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `totem_evento`
--

DROP TABLE IF EXISTS `totem_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `totem_evento` (
  `id_totem_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_totem` bigint NOT NULL,
  `evento` enum('ONLINE','OFFLINE','EMITIU_SENHA','ERRO') NOT NULL,
  `detalhe` text,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_totem_evento`),
  KEY `idx_te_totem` (`id_totem`),
  CONSTRAINT `fk_te_totem` FOREIGN KEY (`id_totem`) REFERENCES `totem` (`id_totem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `totem_evento`
--

LOCK TABLES `totem_evento` WRITE;
/*!40000 ALTER TABLE `totem_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `totem_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `totem_feedback`
--

DROP TABLE IF EXISTS `totem_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `totem_feedback` (
  `id_feedback` bigint NOT NULL AUTO_INCREMENT,
  `id_senha` bigint DEFAULT NULL,
  `origem` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nota` int DEFAULT NULL,
  `comentario` text COLLATE utf8mb4_general_ci,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_feedback`),
  KEY `fk_totem_feedback_senhas` (`id_senha`),
  CONSTRAINT `fk_totem_feedback_senhas` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `totem_feedback`
--

LOCK TABLES `totem_feedback` WRITE;
/*!40000 ALTER TABLE `totem_feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `totem_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `triagem`
--

DROP TABLE IF EXISTS `triagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `triagem` (
  `id_triagem` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_risco` int NOT NULL,
  `queixa` text COLLATE utf8mb4_general_ci,
  `sinais_vitais` json DEFAULT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  `id_enfermeiro` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_triagem`),
  UNIQUE KEY `uk_triagem_atendimento` (`id_atendimento`),
  KEY `id_risco` (`id_risco`),
  KEY `id_enfermeiro` (`id_enfermeiro`),
  CONSTRAINT `triagem_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `triagem_ibfk_2` FOREIGN KEY (`id_risco`) REFERENCES `classificacao_risco` (`id_risco`),
  CONSTRAINT `triagem_ibfk_3` FOREIGN KEY (`id_enfermeiro`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `triagem`
--

LOCK TABLES `triagem` WRITE;
/*!40000 ALTER TABLE `triagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `triagem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unidade`
--

DROP TABLE IF EXISTS `unidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unidade` (
  `id_unidade` bigint NOT NULL AUTO_INCREMENT,
  `id_sistema` bigint DEFAULT NULL,
  `id_cidade` bigint NOT NULL,
  `nome` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('UPA','HOSPITAL','PA','CLINICA') COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_unidade`),
  KEY `id_cidade` (`id_cidade`),
  KEY `id_sistema` (`id_sistema`),
  CONSTRAINT `unidade_ibfk_1` FOREIGN KEY (`id_cidade`) REFERENCES `cidade` (`id_cidade`),
  CONSTRAINT `unidade_ibfk_2` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unidade`
--

LOCK TABLES `unidade` WRITE;
/*!40000 ALTER TABLE `unidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `unidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `login` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `senha_hash` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `seed_password` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `primeiro_login` tinyint(1) DEFAULT '1',
  `senha_expira_em` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `login` (`login`),
  KEY `id_pessoa` (`id_pessoa`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,1,'teste_user',NULL,NULL,1,1,NULL,'2026-01-12 09:10:01','2026-01-12 09:10:01'),(2,2,'yasnanakase','$2y$10$3m48kYSUVWW6bCl.yRDfKePrOJCXxHCB33O71VKXINpxs8dvkE7bG',NULL,1,0,NULL,'2026-01-18 08:46:10','2026-01-18 08:56:16');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_alocacao`
--

DROP TABLE IF EXISTS `usuario_alocacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_alocacao` (
  `id_alocacao` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `id_sala` int NOT NULL,
  `id_especialidade` int DEFAULT NULL,
  `inicio` datetime DEFAULT CURRENT_TIMESTAMP,
  `fim` datetime DEFAULT NULL,
  PRIMARY KEY (`id_alocacao`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_sala` (`id_sala`),
  KEY `id_especialidade` (`id_especialidade`),
  CONSTRAINT `usuario_alocacao_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `usuario_alocacao_ibfk_2` FOREIGN KEY (`id_sala`) REFERENCES `sala` (`id_sala`),
  CONSTRAINT `usuario_alocacao_ibfk_3` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_alocacao`
--

LOCK TABLES `usuario_alocacao` WRITE;
/*!40000 ALTER TABLE `usuario_alocacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_alocacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_contexto`
--

DROP TABLE IF EXISTS `usuario_contexto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_contexto` (
  `id_usuario` bigint NOT NULL,
  `id_sistema` bigint NOT NULL,
  `id_unidade` bigint NOT NULL,
  `id_local_operacional` bigint NOT NULL,
  `id_perfil` int DEFAULT NULL,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`,`id_sistema`),
  KEY `idx_uc_unidade_local` (`id_unidade`,`id_local_operacional`),
  KEY `idx_uc_perfil` (`id_perfil`),
  KEY `fk_uc_sistema` (`id_sistema`),
  KEY `fk_uc_localop` (`id_local_operacional`),
  CONSTRAINT `fk_uc_localop` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
  CONSTRAINT `fk_uc_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
  CONSTRAINT `fk_uc_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
  CONSTRAINT `fk_uc_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_contexto`
--

LOCK TABLES `usuario_contexto` WRITE;
/*!40000 ALTER TABLE `usuario_contexto` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_contexto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_local_operacional`
--

DROP TABLE IF EXISTS `usuario_local_operacional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_local_operacional` (
  `id_usuario` bigint NOT NULL,
  `id_local_operacional` bigint NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`,`id_local_operacional`),
  KEY `idx_ulo_local` (`id_local_operacional`),
  CONSTRAINT `fk_ulo_localop` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
  CONSTRAINT `fk_ulo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_local_operacional`
--

LOCK TABLES `usuario_local_operacional` WRITE;
/*!40000 ALTER TABLE `usuario_local_operacional` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_local_operacional` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_perfil`
--

DROP TABLE IF EXISTS `usuario_perfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_perfil` (
  `id_usuario` bigint NOT NULL,
  `id_perfil` int NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_perfil`),
  KEY `id_perfil` (`id_perfil`),
  CONSTRAINT `usuario_perfil_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `usuario_perfil_ibfk_2` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_perfil`
--

LOCK TABLES `usuario_perfil` WRITE;
/*!40000 ALTER TABLE `usuario_perfil` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_perfil` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_refresh`
--

DROP TABLE IF EXISTS `usuario_refresh`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_refresh` (
  `id_refresh` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID do refresh token',
  `id_usuario` bigint NOT NULL COMMENT 'Usuário dono do token',
  `token_hash` char(64) NOT NULL COMMENT 'Hash do refresh token',
  `expires_at` datetime NOT NULL COMMENT 'Expiração do token',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  `revoked` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Token revogado',
  `user_agent` varchar(255) DEFAULT NULL COMMENT 'User agent do dispositivo',
  `ip` varchar(45) DEFAULT NULL COMMENT 'IP de origem',
  PRIMARY KEY (`id_refresh`),
  UNIQUE KEY `uk_token_hash` (`token_hash`),
  KEY `idx_usuario` (`id_usuario`),
  CONSTRAINT `fk_usuario_refresh_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=372 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Refresh tokens de autenticação com rotação e revogação';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_refresh`
--

LOCK TABLES `usuario_refresh` WRITE;
/*!40000 ALTER TABLE `usuario_refresh` DISABLE KEYS */;
INSERT INTO `usuario_refresh` VALUES (1,1,'7558537e0f4678dc571d37461ddd4555bf280e5bcaf43edce1e638398be9be30','2026-02-03 07:47:25','2026-01-04 03:47:25',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(2,1,'038e6bddb719e4a51cc0e1a575a71db374ccfe0ff7483e4f19bd25684540cfa1','2026-02-03 07:47:54','2026-01-04 03:47:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(3,8,'0ed677b9f9c732b6970b679389ec573a7221e265976b7a7fa1e1dbeb472b1072','2026-02-03 07:49:00','2026-01-04 03:49:00',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(4,9,'8181ee9d9b37e8463f84891ac6e1107d2b03a9173600559a3a53c1106f32cde0','2026-02-03 07:49:19','2026-01-04 03:49:19',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(5,9,'6d2b06a8740ca74fdaf5198193eab9493e863f5dd89b5d91173cbd565b78bfe8','2026-02-03 07:49:26','2026-01-04 03:49:26',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(6,1,'e9368a2fa2cd9c794d113943b69e0ea15379e8ab3f392fd44ce06733683366fc','2026-02-03 07:49:36','2026-01-04 03:49:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(7,1,'3c6d3785a575a5329bbc2cbab2ac77c4e383f378a2c402f606158241a87dca3a','2026-02-03 07:56:23','2026-01-04 03:56:23',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(8,1,'aeeae656c5031a47cc723b57dce6ab2192c79c48da906185e3a997b8a7d38876','2026-02-03 07:56:35','2026-01-04 03:56:35',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(9,10,'63a9134e1f7c6212363617256966779a99347fa0d48fa5989fa2751c9138720d','2026-02-03 07:56:43','2026-01-04 03:56:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(10,10,'75ecf45da83ef65781bdaf830659747744a4171898481213b1e6927de5bc6452','2026-02-03 07:56:47','2026-01-04 03:56:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(11,1,'3b271a484feac2c3d70edbc30b0d2f0b63a943ec5181cd5f6da2cd2076a5e813','2026-02-03 07:56:54','2026-01-04 03:56:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(12,1,'a72d64a7a3f2fe19fa98374b60c0e2a0048e735e2f3caf39f0212ed89ed6acfa','2026-02-03 08:40:46','2026-01-04 04:40:46',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','192.168.1.98'),(13,1,'d9888ebd86d886a9da4450d9ed1449ce5a0919b0bf6d7a95e434b4c5c9f9654d','2026-02-03 08:55:54','2026-01-04 04:55:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(14,1,'9403ed66083c17ad2c7f184908f86b1a987c5e0a15a268f40e0dd75057246d02','2026-02-03 09:03:02','2026-01-04 05:03:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(15,1,'348ef17cab1bfecbda0958766585249ad583c689828ba3b6d64477b449639ca1','2026-02-03 09:10:33','2026-01-04 05:10:33',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(16,1,'d7b840c8101f2fb18af2b40c4a7f72f2a8e3c92c2cd7deb18ca18dd5e4a16b41','2026-02-03 09:37:58','2026-01-04 05:37:58',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','192.168.1.83'),(17,1,'52f96f976bee6753fb807d424ba46b1db9f1afc0f70f0b15c64d499020bfc111','2026-02-03 10:09:34','2026-01-04 06:09:34',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(18,1,'ea39406997ed7e387ed802ec4038830190e6f83ae6cca3c0f8059e8ee96e68f2','2026-02-03 10:59:19','2026-01-04 06:59:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(19,1,'311e38f8349d2deac3cfb8821a0135b0fb441def0d9b4f9c900c63d88b3a02fb','2026-02-03 10:59:52','2026-01-04 06:59:52',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(20,1,'dc57186ddcc023147184e19d8c446ef334cd8f8ec56211c0cee30385e9f4c9ce','2026-02-05 03:35:43','2026-01-05 23:35:43',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(21,1,'1d66ce3913a2c1679fdad13bef71dd1dea554b9ca755dea92adc5f71812ec347','2026-02-05 05:39:13','2026-01-06 01:39:13',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(22,1,'03517b7bc56313c2b8c59caf2a80368f2a391343173bbd293e16aab445fc9ac7','2026-02-05 05:39:19','2026-01-06 01:39:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(23,1,'ee256159aebaf39ef214a3283db5044c982e07c3d2e2bf2fd48273b4c7a11609','2026-02-05 06:02:20','2026-01-06 02:02:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(24,1,'a41916d0eff118e627c0f6489d72e7173855b92f53ba287ea897c621744711eb','2026-02-05 07:01:20','2026-01-06 03:01:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(25,1,'f3d363567013537917c9ab2a7aebb0c82c96a72545a74e21be24ced484b0a4e1','2026-02-05 07:45:34','2026-01-06 03:45:34',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(26,1,'8ebe10c569aa8a2976daee030c961d53a6a8c4ddfeb6f768ac855370dbd75f6d','2026-02-05 07:46:19','2026-01-06 03:46:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(27,1,'57217d8839b1be180d4e03495e9748b5e4bb6042cfdfb70fa7da6ca8165e62ca','2026-02-05 07:46:32','2026-01-06 03:46:32',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(28,1,'00c1f42e7a7d81001f5a3d952084799f33ca4e444bf35842d4a13e312f921739','2026-02-05 07:46:41','2026-01-06 03:46:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(29,1,'581cc1c545bdae9c748ea4c926319c397ae362a911bdcc23e6813fbbd7d11dd9','2026-02-05 07:47:31','2026-01-06 03:47:31',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(30,1,'7bf2b7083ecf6fcbcb950453197cc8aee6fc21d2024c6625c58e070f571bb92c','2026-02-05 08:19:14','2026-01-06 04:19:14',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(31,1,'8f393bd2e02ced0104c43ee67d5bf2b404c4f78b261df515c135bc6f968d3ccc','2026-02-05 09:18:14','2026-01-06 05:18:14',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(32,1,'f3d8913e6fbc5ddc48905ae9766aca03dfdf0fb890100be507b9c099b305ca29','2026-02-05 10:17:14','2026-01-06 06:17:14',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(33,9,'d7838e2c89646f13d3553d8f98e8db59d6e3adeac5eff1048d11957d249a1899','2026-02-05 10:17:28','2026-01-06 06:17:28',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(34,9,'be9cbb4df4cf4f0b8d7bd1b4acea368f3afdc20b899913c1cc69a5f33dfadec4','2026-02-05 10:17:34','2026-01-06 06:17:34',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(35,9,'12870eb9471c765edca5e0e4242a279642943420902372d5efb008a33d2bc0bf','2026-02-05 10:17:36','2026-01-06 06:17:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(36,9,'84a4b423e59734a4fab04cf176c58b55ee62397a104635bcc98ff0c1e9498af4','2026-02-05 10:17:37','2026-01-06 06:17:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(37,9,'b6d826e9f9ceb47d498e0dc0b0e362f72e74c8c9f81992631c4020a6aab385ce','2026-02-05 10:17:37','2026-01-06 06:17:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(38,9,'e6d8338ab872c353469dece8096c2f45cff4dd11d5b48c4ca7a6a37f824748aa','2026-02-05 10:17:37','2026-01-06 06:17:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(39,9,'1f379535720b142656c2efb4019ee650716b4f7d9af0678d66ccd573500f6d64','2026-02-05 10:17:37','2026-01-06 06:17:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(40,6,'51cb714ad7807cf99597b91abc9d87902b758b7c52a489a8185e7fca072284b4','2026-02-05 10:17:55','2026-01-06 06:17:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(41,1,'1953f070894b37241bfeafc790a7b54256463a395dbbe2bc8e9d5a2f3e833eb0','2026-02-05 10:18:22','2026-01-06 06:18:22',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(42,1,'40d2e61b2fc0bd21f4f927692c85532f2394c5a53e95780a870c2bf4c013fc3b','2026-02-05 11:01:45','2026-01-06 07:01:45',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:145.0) Gecko/20100101 Firefox/145.0','127.0.0.1'),(43,1,'8e28a51d2b913801b7aba51d402ddaf8b504702e90737b3417a657e6cba2dcd8','2026-02-09 01:19:28','2026-01-09 21:19:28',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(44,1,'906142e77b5770025a1b7db289c0409febf339f533b44e8b7335553f9003683c','2026-02-09 01:19:37','2026-01-09 21:19:37',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(45,1,'36995ed65a5c9fcac7d2d6f4da83bdc7ea2c48d94c93c4cbed56c9244479e743','2026-02-09 07:11:48','2026-01-10 03:11:48',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(46,1,'aedcf9e4bd3536423e13b8f538c19adb6f0fa7eadac665525793d23056347fe8','2026-02-09 08:10:48','2026-01-10 04:10:48',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(47,1,'feea122448a8853c3db4caed0043690004b3bfbd44283234bef804a23985f5a5','2026-02-09 09:09:48','2026-01-10 05:09:48',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(48,1,'070ec9d1a5ca9461c3c6c86afd776d08a04af12562d0fc5c96294e35dfffb27b','2026-02-09 10:08:48','2026-01-10 06:08:48',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(49,1,'72fd90b1591f9410c9e6faf2962598a58609fb1a364b0c6060874318d022e17a','2026-02-09 10:55:28','2026-01-10 06:55:28',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(50,1,'2084f9fbe0a8b537a657d1fef5446b598da103002343d1b67a20b3b5652930eb','2026-02-11 07:15:54','2026-01-12 03:15:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(51,9,'d507a83024bb63bd4b66cdff812dcb2a55307891c54ae28596ffb8d1b09d47e7','2026-02-11 08:18:22','2026-01-12 04:18:22',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(52,9,'49918ff5e246e93c0404cd17365beda6b6513859bd6ad74d0e91426620483d2a','2026-02-11 08:18:24','2026-01-12 04:18:24',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(53,9,'b462b9fd7c9e6da461c482e3a3e02d7a4864e29b432852ae0c59ecf37d0db111','2026-02-11 08:18:42','2026-01-12 04:18:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(54,9,'1a311de7e4d7ace23cd2179e7d33fbfeeb8d0a48880c330f8c4869b3d38b8b61','2026-02-11 08:18:49','2026-01-12 04:18:49',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(55,9,'38c801f4d0dd814b28eba61007e9f8bc54d494e3196b2b45ece906a1df3e311b','2026-02-11 08:18:55','2026-01-12 04:18:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(56,9,'1426ca475a9665b6c95ec239224ea01061f001407fde70963172b424c35eb61c','2026-02-11 08:19:12','2026-01-12 04:19:12',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(57,9,'bb8b4da62577c423ddef1258c27addb516004c535e534518e321fa1efbc87bfb','2026-02-11 08:19:12','2026-01-12 04:19:12',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(58,9,'37a8e64c61f6b06c521b8ec71c18bb7d2cde585e3ef0ec32ff796a735df87f70','2026-02-11 08:19:13','2026-01-12 04:19:13',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(59,6,'d1281e617a3732cba039d0e305526cbc7d86d6743b53eae22ae743808b8f3799','2026-02-11 08:19:34','2026-01-12 04:19:34',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(60,6,'e2df6880ff92e59474e535adeef8c0185f2fc9525350696328b1497168cce41d','2026-02-11 08:19:59','2026-01-12 04:19:59',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(61,6,'f1478e7695763643f54639810e75effac10a853dd79209ec4413d9243312cbac','2026-02-11 08:20:11','2026-01-12 04:20:11',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(62,6,'070dd52096fec865b813207ea38176c2b317703119c1d7c63c33e098dc2c79fd','2026-02-11 08:20:11','2026-01-12 04:20:11',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(63,6,'25720c5143280141554fb82ad680f2befad3ca659d2800bfe21b02347483fad6','2026-02-11 08:25:31','2026-01-12 04:25:31',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(64,6,'7ab9b78b2a186f5504a43ee646ea78a8d1afd6b5a777b312c83d5abbb33cd834','2026-02-11 08:25:40','2026-01-12 04:25:40',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(65,6,'3e3837880892c5a977b2d2d9904e3b17b0f41bbdfbc238eed37dac4468007404','2026-02-11 08:25:41','2026-01-12 04:25:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(66,6,'12fe977e086fd978930cb3f7db01b6a843c6afc9f0edc8e29b6230410724c590','2026-02-11 08:25:41','2026-01-12 04:25:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(67,6,'21ea13efe2335a3fbab2171beb5340ef407d88ece397495c34a83eafc0b01335','2026-02-11 08:25:41','2026-01-12 04:25:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(68,6,'ad6d37a12747acef40db7518bf06d7a3ed05f04e851a2a4907eecbad633b3614','2026-02-11 08:25:41','2026-01-12 04:25:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(69,6,'5d8180fea541cefdcdd7a7bfc5a6f95938119331e8fc989d3b2df6cad071c938','2026-02-11 08:25:42','2026-01-12 04:25:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(70,6,'6cda0c0c3dca930d87a49eab062dfd3de36b65d5af322eb3c9a8dce8fded48a2','2026-02-11 08:25:44','2026-01-12 04:25:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(71,6,'914260c29590383bc32414e4f0505082a9aadb4cada462eb2ae33a1314cda657','2026-02-11 08:25:53','2026-01-12 04:25:53',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(72,6,'c29fccda1724ddeaff7497f7b1806414d252697a3670ec6a35a134e5ad912382','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(73,6,'d1e3e0e7d80c76da1ba4f6094d570419f91e6add7b5a82c881e3b756d58256f4','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(74,6,'10e9039baf6c7c11635560b62f8610de16fbeb793e0e572681c4ba015755ac95','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(75,6,'94574135a85aac1825caab15b79e29caf43a45bff49fdee33f6da0b5e9e9f62b','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(76,6,'0c3bdf6ac5d9b1d8666c1e6e93f29f2b2b447c528b476b43b1737026432f55e9','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(77,6,'ca58bb6979d2db73325727fa66497d126551e90a9290d3f1047d94f0e6ce2ff9','2026-02-11 08:25:56','2026-01-12 04:25:56',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(78,6,'6f77471aa30e9ab7548d0d21590e2b8fc6ed6e810174b03f9595adc21ababf89','2026-02-11 08:26:01','2026-01-12 04:26:01',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(79,6,'762b0bb8cd9473c517af47679b1a07c2de403d19e09df8dad0710161e9a8d067','2026-02-11 08:26:02','2026-01-12 04:26:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(80,6,'bf4ce66a148916e36b5c6e6342dec2dfe43aac1ecad07ae6529d8b6bbc4ad143','2026-02-11 08:26:03','2026-01-12 04:26:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(81,6,'d34e00218427322962b7b8aee6fb56feef0763fe3c8212176eb707eee4b51f43','2026-02-11 08:26:03','2026-01-12 04:26:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(82,6,'f79b08173346ed0805a920de28131c574196f093d588deadec242f3c7098c67f','2026-02-11 08:26:03','2026-01-12 04:26:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(83,6,'b030c57c7410e16e3c9971bc12c25c952834c841462eff2d988f93b6433d72c6','2026-02-11 08:26:03','2026-01-12 04:26:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(84,6,'e6ce897ffd2057164509970b1a455c3da6f9922ab683f6ab71a80462ee33ffb4','2026-02-11 08:26:08','2026-01-12 04:26:08',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(85,6,'2bd06e019559ac33011f5a600eb17101a388c9dc9c7ca3d6ac387ff6b03fbb72','2026-02-11 08:26:14','2026-01-12 04:26:14',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(86,6,'ce5c36f6c9d998b54e5ceee3f98452be94a99ee2d73c24e2ea7672c3c03fc6a7','2026-02-11 08:26:15','2026-01-12 04:26:15',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(87,6,'7095f7786748fe10920f29771ede16c8a6680e4b2a46bbd80c9824555b928aaf','2026-02-11 08:29:03','2026-01-12 04:29:03',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(88,6,'57464255823e39f8dedcf796c3081b2fb94d2731d1f927d82480494f9208279e','2026-02-11 08:29:12','2026-01-12 04:29:12',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(89,6,'2fabb92c67247b5d43f4db2af5b3d81aace895413ba1e3eb491384e973809f8b','2026-02-11 08:29:14','2026-01-12 04:29:14',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(90,6,'4dd5e00ed82c9f2c81d3a61ae2f358cfcdf4764e8703bbd011f09b6bf0275eda','2026-02-11 08:30:08','2026-01-12 04:30:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(91,6,'fc1c20001b687df734b6768ee7e56b8534f0ad07f9860593dcebb2c92606bf1c','2026-02-11 08:30:10','2026-01-12 04:30:10',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(92,6,'f62b31214b4347c532f3675134d1152e1abcaf440ce216f42dcaa62d348e0c28','2026-02-11 08:30:38','2026-01-12 04:30:38',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(93,6,'15c3dc358ffbdcfe57b97c19f81f43dcf969a458547aa0a27311690988fed43a','2026-02-11 09:11:12','2026-01-12 05:11:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(94,6,'d12881cae2a46e8465bb4b8ec184a21cdbdd1eff517e83122eb5db5dcec798f8','2026-02-11 09:11:14','2026-01-12 05:11:14',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(95,5,'91cdec337f63b6e3be867efa8138ea4a639f5c278b643dfe3476f44669fca388','2026-02-11 09:11:28','2026-01-12 05:11:28',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(96,5,'324a00e210e6fd1382220309a5de756b59111e07ede519cc03a8bfed334aea4d','2026-02-11 09:11:29','2026-01-12 05:11:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(97,5,'9fdf1d8c7293933af277437a7b48b89722a73eaeffa6b46de3f1cf1832ca268c','2026-02-11 09:11:29','2026-01-12 05:11:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(98,5,'88efd5f097dd322e882a2a4099ea10462ad78e3cbed34f802268f6356e5f2dc3','2026-02-11 09:11:29','2026-01-12 05:11:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(99,5,'e52817159d23f6695aa015eb400ad4803f3508e263a7820a6c4f0309e9a19707','2026-02-11 09:11:35','2026-01-12 05:11:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(100,5,'8512d0481b97a13a55e7f8b4dd147a76360bb1590cd013d39ce06feea3fe5009','2026-02-11 09:11:35','2026-01-12 05:11:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(101,5,'51660744b4d70608b39b37f1cb415d498bc7638ed51711bf6f440bc683610d48','2026-02-11 09:11:35','2026-01-12 05:11:35',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(102,5,'73c343fc65c46782603988bbef554ce59c400342fc28fd1c1281902ffcf8d2ac','2026-02-11 09:11:39','2026-01-12 05:11:39',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(103,5,'a87b84b6d930191c1a1f402e18ce251ed0bf768f280b2334c824cd9597de7eca','2026-02-11 09:11:39','2026-01-12 05:11:39',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(104,5,'0ef31550675f02a1efa8c65661f4994b2b79c36c4b19fe77f42d747db37f28e8','2026-02-11 09:11:41','2026-01-12 05:11:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(105,5,'b9982783dd3e603787155bfb153f044023ebbaa1ea0deb1e02c00550c0ad4474','2026-02-11 09:11:41','2026-01-12 05:11:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(106,5,'8e5b3285d3b359a854404b1d5aed305f59d6ee795be2a2bf2a11aaa7d40bb153','2026-02-11 09:11:41','2026-01-12 05:11:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(107,5,'ac5827a41a266652be828c03eb6e8093c87869cfaf1296838badc1aa178416ff','2026-02-11 09:11:44','2026-01-12 05:11:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(108,5,'176ccfc22dd5034ca0f152f9a57c90d844f71122e7f14b76eef2b412dadb17e0','2026-02-11 09:11:45','2026-01-12 05:11:45',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(109,5,'afa87680b3f99d6420a782fc884145085b2fb63c2f78d14422184e4d87c058f0','2026-02-11 09:11:45','2026-01-12 05:11:45',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(110,5,'25051f2af500d1e6ffcc3fa0c55be4af8f7b2841dc3c1eacec49722105502e99','2026-02-11 09:11:45','2026-01-12 05:11:45',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(111,8,'69453c39bfcdf86bfd8e8d7de906a42eaa2cd3dbb4e2c72e4586ec22b26a4dd8','2026-02-11 09:12:02','2026-01-12 05:12:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(112,8,'0b583d4a490cb824a008c890c6f0965e559f64b2930af88352ae824200373539','2026-02-11 09:12:03','2026-01-12 05:12:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(113,8,'3f363635cf4af260a9b05428701335a2d2a69d53cb44dc97f4a1c0bcb98339f1','2026-02-11 09:12:13','2026-01-12 05:12:13',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(114,8,'3c422ef5eac5457adb9fbb86876cb7d214fccd42937e9fbc676094a3012fb1a2','2026-02-11 09:12:15','2026-01-12 05:12:15',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(115,8,'e34f3f340dad669262172749be9f943ad5ff7cf3cd8655097b93ada7cdaa402d','2026-02-11 09:12:24','2026-01-12 05:12:24',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(116,6,'d947462c7c6d2e13f53de694ceb9aef1fba103f0c0fe8f213bc010ced8719c18','2026-02-11 09:15:40','2026-01-12 05:15:40',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(117,6,'d01885bdfa50af6d665f1d49228fe83aa617216c085c8a2ae0ca6452d0fcfe30','2026-02-11 09:31:36','2026-01-12 05:31:36',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(118,6,'019f196fb8664a16f8c1ec8a7e67a8a87fb69b2da025fb7195ed953151fd8a78','2026-02-11 09:31:37','2026-01-12 05:31:37',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(119,6,'f8611b3f8d1432787af0cae33a923c9a8072a22adae68686d82bf074ccdc726b','2026-02-11 09:31:37','2026-01-12 05:31:37',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(120,6,'25ca807f66df4cd6f296fe68597b9c83a000fdccd5e566bb0e4a6b855b7d757c','2026-02-11 09:31:40','2026-01-12 05:31:40',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(121,2,'6368d62430fd7b96cc4d897cb4543c9f29bb95eb1b7714310a0aacd151fa09f8','2026-02-17 09:49:30','2026-01-18 05:49:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(122,2,'e03afcbb24745af9aa08d771f609dc99b6f960d30c5b0a4d005833660aaf1164','2026-02-17 09:49:51','2026-01-18 05:49:51',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(123,2,'9abe2b53f875daed265c8b1c5cf3038dd102555fa56f42e6e7b19271cc9c6e58','2026-02-17 09:49:54','2026-01-18 05:49:54',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(124,2,'7085f83fbdaf2eede109d8a7e516b3208fbeb1dafba89db5b1c42355586441ac','2026-02-17 09:52:05','2026-01-18 05:52:05',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(125,2,'ce083803948344c42b02d58c6e079eb7ea1105c2f1bdd08e9cf4b0fcf7176363','2026-02-17 09:52:06','2026-01-18 05:52:06',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(126,2,'359be9e79355674f676f31721fad7321ff36a25535a0dda91e169c51ac1e4e77','2026-02-17 09:52:07','2026-01-18 05:52:07',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(127,2,'cd1b3598d836023249164b4a67b4381049ada6a5862e10d62aca68be3558b889','2026-02-17 09:56:16','2026-01-18 05:56:16',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(128,2,'9b346fb80b5715879509e323fbf50fee3954de615086a7e6c4d30e6bcfe65c40','2026-02-17 09:56:17','2026-01-18 05:56:17',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(129,2,'aa9575472660784c10976134112faaef50971ed42109f7ee3deae9ecf8562c55','2026-02-17 09:56:18','2026-01-18 05:56:18',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(130,2,'42c1b4b6021a427d7d1f12130f83587cb304d62b6c2a55fc7d7fcbafe09a2df1','2026-02-17 09:56:21','2026-01-18 05:56:21',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(131,2,'3ecfe4fa17d3bf57ecd14d148d56e2631db68c7246335e413a01abb91205a338','2026-02-17 09:56:22','2026-01-18 05:56:22',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(132,2,'78042a1c483a227c751f1438f06aaa421fa03e2887c52c8222cc12844d231aa6','2026-02-17 09:56:38','2026-01-18 05:56:38',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(133,2,'8d9d893c127fef03da1556f5483b1a4037edc268e76de6f17126c58f2534fc90','2026-02-17 09:58:48','2026-01-18 05:58:48',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(134,2,'7633e743bd2cc4c92d85e024dc67e2cf41a59eef821c336efb2b1b3d23036137','2026-02-17 09:58:49','2026-01-18 05:58:49',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(135,2,'fe5710ced0240337130292f1d2902a7f1815aed23ab80d2b365244f8d55f1a96','2026-02-17 09:58:49','2026-01-18 05:58:49',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(136,2,'f54ea515d9bc10272d1d96b4e7e6cb37009a0c37da7855b2cd5c021341fbd6fa','2026-02-17 09:58:51','2026-01-18 05:58:51',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(137,2,'f85176f6c4bac73c7d131e31fef07aa25a3d1ecf224ba62ed131ee1a46667b6c','2026-02-17 09:59:01','2026-01-18 05:59:01',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(138,2,'5b454d2acd48856d734d3a00007694015c33faf4c8fb51e6bfe3a7580561ad5c','2026-02-17 10:01:15','2026-01-18 06:01:15',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(139,2,'697d0f7d56b9060c4836dcf5e91cdbf83825b2785ef25ee6fd090bf08b0f88a3','2026-02-17 10:01:16','2026-01-18 06:01:16',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(140,2,'d28dd772110d95f5c1122fbe492a4849bfdc96a9b5402a979b8105276b40df9c','2026-02-17 10:01:16','2026-01-18 06:01:16',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(141,2,'2ba1669fad7086cbb8450f84b9e17887781ce0d31c61822656eb4cf8cf19adfb','2026-02-17 10:01:17','2026-01-18 06:01:17',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(142,2,'b5fea72d3e8160f2f7f5cc72b38b8ed175219a9b6a41acb14851a9e65a61d810','2026-02-17 10:01:18','2026-01-18 06:01:18',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(143,2,'f31ea5ab67b6ccf1b5491b9341737d1d6af538ddcc53c1cbe602b3850be1ea3e','2026-02-17 10:01:26','2026-01-18 06:01:26',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(144,2,'eac87987348814886a7aac97918d78c2b34a7a4f818e64a10edbbb6023a5062e','2026-02-17 10:01:35','2026-01-18 06:01:35',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(145,2,'f8964696351c457e761e0bfd6522826e3f15f312474f6e0ea62b8612584d5ce8','2026-02-17 10:02:49','2026-01-18 06:02:49',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(146,2,'62f3cce0688999009b9d03251b65d0b34b3deed1e84b29072ceb1d7136028886','2026-02-17 10:03:02','2026-01-18 06:03:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(147,2,'b54b9ac3d72558f2252238e4b11edbdf8a7766668a4bdc8057a1e36c507cffe3','2026-02-17 10:03:03','2026-01-18 06:03:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(148,2,'499ee0f9a7a0a249d857fa96efc19057911ede6071712650151d3e30bf939a7f','2026-02-17 10:16:54','2026-01-18 06:16:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(149,2,'cb814b888a86717a346fe34cbb79b3dc38ef8f0083e3f1941ed573d1593efcb5','2026-02-17 10:16:54','2026-01-18 06:16:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(150,2,'906b9561986891560b8d4eaf3305673f5f1cbda6794b0ee38be705834ffe6d81','2026-02-17 10:16:55','2026-01-18 06:16:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(151,2,'d2ed1392dc84fda9b62c5316751c9c2a88dedd6327d83c74dbbc162e912cd4b2','2026-02-17 10:21:46','2026-01-18 06:21:46',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(152,2,'a4b48910390d5bea3f2cb3bc71c770dd56a9e58fc69985e265c338fb450a9d02','2026-02-19 09:45:16','2026-01-20 05:45:16',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(153,2,'37a32d9b86d6afb0a5692890310885a3e32a5c2065babe914dbdd801e58ded3a','2026-02-19 09:45:18','2026-01-20 05:45:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(154,2,'a113965758de45e57ebe1355a59db0ab9150ffc898217d8540e1db38620fadb3','2026-02-19 09:45:19','2026-01-20 05:45:19',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(155,2,'45c9ce3160c3ff0c7c7b25aa4aabc1de7161f84253ba77efeb562f89c1a13d1e','2026-02-19 09:45:19','2026-01-20 05:45:19',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(156,2,'7fc9e059e6b43cd40a6a0959e441ec2b83f81e4dcd27a757cfd3a48c5a11aa8a','2026-02-19 09:45:20','2026-01-20 05:45:20',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(157,2,'e54b4c49a7159462a75974639cebaaf35cd23804f96bb2d57477bcdd6ceb9a0e','2026-02-19 09:46:14','2026-01-20 05:46:14',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(158,2,'d5124f4e60954c2e5a4f1d82a764328ed93bb62ecf5ab7beb480b8f422d96b3c','2026-02-19 09:46:18','2026-01-20 05:46:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(159,2,'9b59e1cb03c23a9093ef317b1d2248e0ddca8246549e2e73feac5ac49297c3df','2026-02-19 09:55:04','2026-01-20 05:55:04',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(160,2,'2a7f802829e3fdcb6437ba2228a1614562f4a32ca8de5deef440377c80f201f0','2026-02-19 09:57:07','2026-01-20 05:57:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(161,2,'cb264c27157c0820b241e25c1a1560fdd0d72842074589000ae4756340a4cdf2','2026-02-19 09:57:08','2026-01-20 05:57:08',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(162,2,'6260c13ec2ef95e01c8e285f89c5f602edcaac9e807e6ae6530debd4a7951009','2026-02-19 09:57:08','2026-01-20 05:57:08',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(163,2,'3540b7120674443e63bb623ba571c7e00bd8d578154629c5f0d9a054342b6ee7','2026-02-19 09:57:09','2026-01-20 05:57:09',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(164,2,'aad2b9552f1b85f33cb0d5f7677f418b997606ae1962474909e0cd8a660de381','2026-02-19 09:57:27','2026-01-20 05:57:27',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(165,2,'67ced5f69f6785e44ddc4ababa9b6a8f29df785ebbe809486a3a1c57d4a721ca','2026-02-19 09:57:38','2026-01-20 05:57:38',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(166,2,'3956f7f6d9bcbefac8cad3cb437559f6c4fb41e59ec5e54e4d7d9ea3ef5cf73c','2026-02-19 09:58:36','2026-01-20 05:58:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(167,2,'2bece4e92041e671592d22ae0c6a82527d00dd0d6ee794d54dccfca9a469ddc5','2026-02-19 09:58:36','2026-01-20 05:58:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(168,2,'1f8a79d1c65faa493860c7ba95e51a8ba7492158a627c1640ae0f527ff603764','2026-02-19 09:58:36','2026-01-20 05:58:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(169,2,'59aab0e60a9f536661c2750e37b258da87b0abf4478a935899c40a7036f1df6c','2026-02-19 09:58:39','2026-01-20 05:58:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(170,2,'7cf3d0e34fed0f50e9bcfa1856a0aa94969c3a272869660875d9cdf868b33d4c','2026-02-19 09:58:39','2026-01-20 05:58:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(171,2,'3b8c05257cbaa07a28c8bdde47b6a144e743c1cdfd59cadc7377409a04980f3b','2026-02-19 09:58:44','2026-01-20 05:58:44',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(172,2,'17ef8eba37d96a560550ba6418a107bcf2916cc08f50ff181230b45b9df3c7de','2026-02-19 09:58:45','2026-01-20 05:58:45',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(173,2,'6a55c7ba48ad7dfd08824195da011948112c4ce93f855c3275112251961cc6a5','2026-02-19 09:58:45','2026-01-20 05:58:45',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(174,2,'657b968be9c49fa2c40a9b1aba7da5578df9079cab0d775dbd60467d08f84dad','2026-02-19 10:10:52','2026-01-20 06:10:52',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(175,2,'0de66d99991420a5e4b5ede1ff85944d03af30e2fccde5d9819758e323ad27b1','2026-02-19 10:11:08','2026-01-20 06:11:08',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(176,2,'0dc6d9b1fe4a38a103743abe87fa7475fbe88f7fa49c6ab38971c2c416c11d31','2026-02-19 10:14:29','2026-01-20 06:14:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(177,2,'eb87e1e59026a5b946d99d336470e1437fd82d3085d068b24dc9f60d2e56a016','2026-02-19 10:14:31','2026-01-20 06:14:31',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(178,2,'1cbe3ff5f6f8d40eeb7e3359108154b285d2781532e774f31ec79bec7dd6acf7','2026-02-19 10:14:58','2026-01-20 06:14:58',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(179,2,'51810c71741f8b8e373db566aacd788f70c22f090ddc6f1fbedab39928f70086','2026-02-19 10:15:00','2026-01-20 06:15:00',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(180,2,'ae5ab725df29265ab6022fcb3401d4aa1f367b4305eec6ba29d38cadda91691f','2026-02-19 10:16:25','2026-01-20 06:16:25',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(181,2,'fc3187ecc9e4f9ff653bb54837a961f60b1037e8ec79da2b3fdfb31e48827355','2026-02-19 10:16:26','2026-01-20 06:16:26',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(182,2,'5667f955acd512c0e5c79f6610282d43329a4a8e7d49ac455b7f72f60927b2bc','2026-02-19 10:16:26','2026-01-20 06:16:26',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(183,2,'0029f8082fc51d9d35dec1da810b8e4a35babce618d3adfc82c5812bcf037e59','2026-02-19 10:16:27','2026-01-20 06:16:27',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(184,2,'058ad6fd27cd017f3bba793e11e045cf40cd0c560e6c43efafb71b8776298083','2026-02-19 10:20:25','2026-01-20 06:20:25',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(185,2,'d19e240666ff78e4d4b87035ce5bdef26b2d0a5b33b2a71a615d7c55d7572407','2026-02-19 10:20:25','2026-01-20 06:20:25',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(186,2,'aee66802956240db2d95f7f6c098ecb2d1e6e9cb550e2aa72a0283fecfd48fbc','2026-02-19 10:20:49','2026-01-20 06:20:49',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(187,2,'eb326964921447925c22907c58887ef89226ca6a7f400e0348bc1795440ac30a','2026-02-19 10:21:04','2026-01-20 06:21:04',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(188,2,'87f9cc7410ebd959929f8ef5201488bd9b60fc72bd965cec9a0056734baa9a52','2026-02-19 10:21:27','2026-01-20 06:21:27',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(189,2,'12e7bd0d5afa3df43a2f4ebbe413633bde03984d10b2af68bf9af7e40b7ad98b','2026-02-19 10:21:37','2026-01-20 06:21:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(190,2,'0780bbcc32fe153832d47eb885c24d9fbe47738f73b8a219356b1ebcaf137edd','2026-02-19 10:22:02','2026-01-20 06:22:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(191,2,'9e70ca05b76c8f1582e15e4907fc91c44075eb68c72074ba2a0e1c56a8f46406','2026-02-19 10:23:37','2026-01-20 06:23:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(192,2,'bcccf2b311afc78fb5d573b2b36d8f677a5132e80a367e78a5dd3548e731e4fb','2026-02-19 10:23:57','2026-01-20 06:23:57',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(193,2,'28025db5072b714e59bc3a2b56e0be609a1fec43caceb2890c9f2a3c819c10f2','2026-02-19 10:29:12','2026-01-20 06:29:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(194,2,'46a2eb7b3135599eb468abbd57694dd0f758483d4b7fd1820e3ddeca865f7275','2026-02-19 10:29:13','2026-01-20 06:29:13',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(195,2,'0d2caf878cfed5bf8b65c21b8e27623341af9b5bf48491091216b03ec6f7de07','2026-02-19 10:31:18','2026-01-20 06:31:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(196,2,'4cec22ae6269fc3e61ce4a0b93efd5bdfd618fc8310b064f39638daeb1c6a2fe','2026-02-19 10:31:20','2026-01-20 06:31:20',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(197,2,'cd290b3bfad4deb73cf0c2666178d33b5b780145957417e24260f293be3923f0','2026-02-19 10:31:21','2026-01-20 06:31:21',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(198,2,'136423ec8dd4cb198a702a215c0e1b4bd155a06371bda59bbc4d4608affd28cc','2026-02-19 10:31:29','2026-01-20 06:31:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(199,2,'65f29ff22d8e95113a8e11018ac02fe4d5ec4e4ca0beb855c6491e4f00454f1f','2026-02-19 10:31:30','2026-01-20 06:31:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(200,2,'b59a37bf04f3c691e26ba5ff1d0678046884f24a482db0bd3fb8b7c97b4c3922','2026-02-19 10:31:30','2026-01-20 06:31:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(201,2,'d4df4852206200f8327b4167878fc88ace3db9894a1ebd9372d2121b47b21e20','2026-02-19 10:31:41','2026-01-20 06:31:41',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(202,2,'4da690da83a173133e9161bbc72f771715143ef8688eccd9f34975de94ff06fc','2026-02-19 10:31:43','2026-01-20 06:31:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(203,2,'fba2fd13f57e35ae51b1f77df61e9bb9778cd265a19ebe2865f63de84a12e975','2026-02-19 10:31:44','2026-01-20 06:31:44',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(204,2,'58e7cede61bf62128476e2c84e75730b7b0a877f74168812dd184e6895b35d1b','2026-02-19 10:35:17','2026-01-20 06:35:17',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(205,2,'dac52dd22b042155bc3b05cab1f8e6be9517e24009b9c944fb85b0e8153d9908','2026-02-19 10:35:20','2026-01-20 06:35:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(206,2,'0a7a5a70781b33be827df61a4f8a032038d671c3f0f14adb0e571991d0b45dcc','2026-02-19 10:35:21','2026-01-20 06:35:21',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(207,2,'246d8c56aafa537fe6f931c977e33070baa75a37e72d55a76767c40d2a9c82ea','2026-02-19 10:35:21','2026-01-20 06:35:21',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(208,2,'32db5f567491a6fdc93afe67e8427941facee75fbc20aafd283bc3a9fd16f0d7','2026-02-19 10:35:21','2026-01-20 06:35:21',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(209,2,'36f9d1e45bb3f4d930d61222ea1f04d5ee6af7b3ed8e8fbfc6fc02ea4ac46133','2026-02-19 10:35:30','2026-01-20 06:35:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(210,2,'bcfaa4bba056958f95bf88b1477869d3c97aa2af82177cc49a6e597199463224','2026-02-19 10:35:32','2026-01-20 06:35:32',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(211,2,'282454dcc807e29fb041a79c3813ef29cd467c02106fc1c66887d38fc744d9dc','2026-02-19 10:35:36','2026-01-20 06:35:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(212,2,'1dc03c233fd16b0a70afe113826f9b95910017dbe3269b3cf8ade14388f9726b','2026-02-19 10:40:08','2026-01-20 06:40:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(213,2,'92fa568c6e5ccfe7fd4dd2807f218310232569d4eb5bb1aee0a5b7ff5ee85f7f','2026-02-19 10:40:08','2026-01-20 06:40:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(214,2,'13d0bd31eea4e2c9e1f0437abc3f27aa5aa74d34a674f894898170aeab32d8e0','2026-02-19 10:40:08','2026-01-20 06:40:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(215,2,'677551e3008ed0c24b7df270b4af594b0d7f64b40aac61e18ddb8c34746e464a','2026-02-19 10:40:17','2026-01-20 06:40:17',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(216,2,'35ca5c4a22b84ceaecb8ae13ba9339df83573fea4bba104a5e6c187df882e696','2026-02-19 10:40:19','2026-01-20 06:40:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(217,2,'3addd2b4d36996317d0dc5140a6d1e13e55cf00a043928b886cfe4cc98623d7c','2026-02-19 10:40:46','2026-01-20 06:40:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(218,2,'adaa7b0c66dba030faf34d33518bf779ee03c39674527ba1be56b5ce34504aa1','2026-02-19 10:40:47','2026-01-20 06:40:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(219,2,'a80f7f1f96ddb94e4af23dbc682689fa8054abf632a81a211b632d3a14cb6145','2026-02-19 10:40:55','2026-01-20 06:40:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(220,2,'b4903d24f9f5e2ad5f6aee366c201929f3308428248208f007ffac3aed250c78','2026-02-19 10:40:56','2026-01-20 06:40:56',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(221,2,'4152c8c19be5200db0c117b680dd177121fe0e618a4e36a7a3de1f37bbe9e036','2026-02-19 10:40:56','2026-01-20 06:40:56',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(222,2,'fce0d15ea859acacc78a2c0885a6488996bfa5f7a244b595001776161e4fd2b0','2026-02-19 10:40:56','2026-01-20 06:40:56',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(223,2,'ba0906289859d1fe3c13a4ef6cfba6bfc3cc5b3e9c3a1b51fe7a5e68eb50cdcd','2026-02-19 10:41:07','2026-01-20 06:41:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(224,2,'43f4dbf46f5b9aa3b87807b911d2a00a8e7f34ce3d534a2724365bc5e7ec2479','2026-02-19 10:41:10','2026-01-20 06:41:10',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(225,2,'58360af9c4d1755012d8f8c93cf7390610932bb0d808047a756622e384f1c314','2026-02-19 10:41:14','2026-01-20 06:41:14',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(226,2,'662b4205a79f5e0e182912d07318336dacbd48570c05c458095b2c409cb77d6b','2026-02-19 10:41:29','2026-01-20 06:41:29',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(227,2,'5593c897b5c6a57ee91fc8356d5decabd7fcaeda6072b61c279c8e55fc4a320a','2026-02-19 10:41:30','2026-01-20 06:41:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(228,2,'70c71a2a80af22c47ce032d781b54ab7abbe72d2c15cbb81bf4c01aad0fe041d','2026-02-19 10:41:30','2026-01-20 06:41:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(229,2,'858fe27f2f6b2e42619a6f6d2c929c2aa3d4159b8c180ac2203dcae93996da9e','2026-02-19 10:41:37','2026-01-20 06:41:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(230,2,'402d3d280b1d8bdc4910053dcfc79a75f9730fb4d51067289b651d92e40b686a','2026-02-19 10:41:43','2026-01-20 06:41:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(231,2,'0dc638b82e3f0335781874fe867b43de8a1fef71f7092891e798812a7e4895b5','2026-02-19 10:41:45','2026-01-20 06:41:45',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(232,2,'e26376847d0ab4c0161ead9f02ad3b8baeaf1616f2b8f54efc01191604c180a7','2026-02-19 10:41:46','2026-01-20 06:41:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(233,2,'6a0d1959b06d35074052f6930b3e331722c633a6f5e5c3444b25410f6b1f4c27','2026-02-19 10:41:47','2026-01-20 06:41:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(234,2,'9d497c31bc4eec2a037e409f0dcd2b5c3f70e59c5e5c097b659e3934f81a78a0','2026-02-19 10:41:47','2026-01-20 06:41:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(235,2,'ecd107d9ff405cfbb883bed16b4315ca375aadec470e913a5f472abb93bda8fa','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(236,2,'451454265690ccaae02a8cad2a893d8dc1077fd9ce111eaeb87ca01cb167029e','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(237,2,'05a6aa46c31ab616b694172ad4d7b7137fa21d4c476deaf9eb42fd820e537666','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(238,2,'f7a80fed0149c5998ca36bfd09ff29054dcc744f266a216759c0f4961635ff6b','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(239,2,'4816f3699389816f7021b2e27dc290f55a01c461d74377a56556cf0cbb7e0dad','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(240,2,'f511b65a536e7ecc256b5429aaf67eb743f434b0be1576979339c762818d09dd','2026-02-19 10:41:51','2026-01-20 06:41:51',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(241,2,'aa1c6d8cf47a8c2cf6ca0bbe1324248b69221274b71aae6da6988fe1bcb13d2f','2026-02-19 10:42:02','2026-01-20 06:42:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(242,2,'15d1b8b2cbb2e9cea9215266a6d94dffa9e4f5773544e4ee967212a720525ce2','2026-02-19 10:42:05','2026-01-20 06:42:05',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(243,2,'78a7f3f5801afe8a177920241cae68b972fb66bb2a348d508e01d42cd70d646a','2026-02-19 10:42:44','2026-01-20 06:42:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(244,2,'a416cf5ae7fb338f24b330ac59eadae92d59780bd959df0937102ba0613c81f0','2026-02-19 10:46:18','2026-01-20 06:46:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(245,2,'7574d71bfa61bcb92fbff4459554a8708f20b646740b7a8c108e093df85b938e','2026-02-19 10:46:18','2026-01-20 06:46:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(246,2,'6f31c069a5f6ea858e14fdb34332225a4437a503e1b9c8f7bc4a5f3ef4318a9b','2026-02-19 10:46:18','2026-01-20 06:46:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(247,2,'970951462d4d9267a963698a260e58056f37169719d0367f089d30ede15dafb2','2026-02-19 10:46:28','2026-01-20 06:46:28',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(248,2,'ddc927dfaee9546e5f33a2676cd7418a039c11e044ef3ca71bb443fe60111e39','2026-02-19 10:46:32','2026-01-20 06:46:32',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(249,2,'9c4de3ab09de81a2857e5107084e391316329d98085b48cb9f7dca9ae95f3939','2026-02-19 10:46:32','2026-01-20 06:46:32',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(250,2,'2655008e1dc52f6933f7a2f4adca69a72b00da10baa33b1b72527e96919501ab','2026-02-19 10:46:32','2026-01-20 06:46:32',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(251,2,'8a2feac352f89ee8905e13f26d2e10e061e512f2c85682ff0d0d80f60ddb5b27','2026-02-19 10:48:35','2026-01-20 06:48:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(252,2,'958f509fd564506c39d4b126f08b2d66eaa9f0a1e54348a14aa4e1c357271527','2026-02-19 10:48:37','2026-01-20 06:48:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(253,2,'51cb9c1db4e84be15ac39dd7254adccc2bbbfcefca7ac1674f16b36eb6b1bc11','2026-02-19 10:48:43','2026-01-20 06:48:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(254,2,'678614a595bee34019be4b1fac596c95bfeec906700795bf03f870ee75a65b99','2026-02-19 10:48:46','2026-01-20 06:48:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(255,2,'fa409e27c795721df2b5837e807a689df742a8b7ad9064acde65ea376af2e2a8','2026-02-19 10:48:47','2026-01-20 06:48:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(256,2,'b5b3abfb650f246cbf34c47fa76a270b08474c84655424aac8a5b381427c2bb3','2026-02-19 10:48:51','2026-01-20 06:48:51',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(257,2,'90b15c644f90f474ca982f90d4453b958bc2180eb69d94690c78e5aed878f7dc','2026-02-19 10:48:52','2026-01-20 06:48:52',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(258,2,'515181143f0bbac33a401604ba3fbee14e44c19b87515b50b67d19e512f9af9c','2026-02-19 10:48:53','2026-01-20 06:48:53',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(259,2,'801901a59ec4178b9035d52f10a7e360b637908fe67183d2b0beeac0b320eb84','2026-02-19 10:48:53','2026-01-20 06:48:53',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(260,2,'78ffae89a1324ee8796ed7ccf9e45ab8f071ad4fab026423f3c6e9baff37d2b2','2026-02-19 10:48:54','2026-01-20 06:48:54',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(261,2,'3762d92ac07d8f891a8652be81bac06517c546c2cba451e2727f993940bf3acd','2026-02-19 10:48:54','2026-01-20 06:48:54',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(262,2,'0ac6d64976fb6da64263b025a8241c356872949e34ac5709f55fefa485813af1','2026-02-19 10:48:54','2026-01-20 06:48:54',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(263,2,'5c1e50bfd507deb891489ef4c06f78c5921e5069e31e1e9a410d6f5ae7a0b779','2026-02-19 10:48:54','2026-01-20 06:48:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(264,2,'18b9368c26fcd00322b938cb06a1dc7bb01ff196c77f3f554e1fffffe3efe263','2026-02-19 10:48:55','2026-01-20 06:48:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(265,2,'fb5fff63d5eabe313044eba7a9c0ea0dd92ec418ef683261c424fca32af7717d','2026-02-19 10:48:55','2026-01-20 06:48:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(266,2,'30a29807f3d77d5ad69650ec0d011aa98a498d185be5f0ddc6163c4e816f3c21','2026-02-19 10:48:55','2026-01-20 06:48:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(267,2,'ddd04295f4f5b1de86d439c72ae5e67aa28c9e393ad630a3dd30894c02dc9865','2026-02-19 10:49:10','2026-01-20 06:49:10',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(268,2,'1d7cad92ce841374999b0c9f2a1b023bbf53a0c608772b69821a7a08100d296f','2026-02-19 10:49:12','2026-01-20 06:49:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(269,2,'fd337eb7cdd67b27d5a4732b32e88a381500a3b4c62f600ae70e01665c3b898d','2026-02-19 11:00:18','2026-01-20 07:00:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(270,2,'f447e2127f897187b36206fcc057a4cee1dbc915442d29a0774e7e7428b75d6d','2026-02-19 11:00:20','2026-01-20 07:00:20',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(271,2,'4da196ee30a1378065e866b05901f41c691bbc0a6f6e7cc185b945112cad11a6','2026-02-19 11:01:52','2026-01-20 07:01:52',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(272,2,'6f577ae499ccd223980d8e91356404ebe577261552aee10bd1c3857c255a3766','2026-02-19 11:01:53','2026-01-20 07:01:53',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(273,2,'81defdb5b7d7d533e36f259c6f8fd3258d81b1b7d942454f8d4f3681dfeb56b2','2026-02-19 11:01:55','2026-01-20 07:01:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(274,2,'b8d865c28ea82810f15d3bca45765885c4d46a4ff4014186d51cf36b5bef304c','2026-02-19 11:01:55','2026-01-20 07:01:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(275,2,'2290ca59071510ef78bffafc44a5edd5bd0467e7f519df5a68c5745cc5def17e','2026-02-19 11:01:55','2026-01-20 07:01:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(276,2,'4262d01fc6e3dd0807e747ab65c2034d1866701ccad4edaab4db0bb0ec611a91','2026-02-19 11:02:09','2026-01-20 07:02:09',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(277,2,'74539220cd02d493e42ef2e98b58c83239337efe12e68ff67b7a50e5a1599062','2026-02-19 11:02:12','2026-01-20 07:02:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(278,2,'35f68ac2bffdae38c51aafbb028d90c0568025fd40df767d30279fdb26649857','2026-02-19 11:02:16','2026-01-20 07:02:16',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(279,2,'f8246ecf3cab5528526c75d67d998a7410130670190b6d012dc59c14c3462f97','2026-02-19 11:02:20','2026-01-20 07:02:20',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(280,2,'a5c79a87355018d27099404acb8537c8d0adee57bc5debb5d19a4fae095a888e','2026-02-19 11:06:44','2026-01-20 07:06:44',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(281,2,'0490d37c760c1f93f63a6d12242a587f7130693642e5fde972afec21f6bffa20','2026-02-19 11:09:07','2026-01-20 07:09:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(282,2,'25501a113f65cf3a150efb1fab4fb48fcb493a19f6ca343843474eb1826c1bbc','2026-02-19 11:09:08','2026-01-20 07:09:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(283,2,'aab966f2eef41f34481bdad0d22779e39c1e28d1cc1072fdb682302e8c3c5002','2026-02-23 05:16:03','2026-01-24 01:16:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(284,2,'6287808509c19b89eeeeb630604686c529beecf0e9a08456543b5200736d6c18','2026-02-23 05:16:03','2026-01-24 01:16:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(285,2,'a24b9a6be393bf65301a014e7ccf8db3d3f660f3fa64ee26755a3f718cc2201a','2026-02-23 05:16:03','2026-01-24 01:16:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(286,2,'90b5cf4bd69a2cafcaeacff1b0e19141a80d7f3050036d43c97d3e91dd580c35','2026-02-23 05:16:15','2026-01-24 01:16:15',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(287,2,'0a4e22bce52aa2e95d1a66607f8907306abcf36e83c771b94b1b45d4ad855062','2026-02-23 05:16:16','2026-01-24 01:16:16',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(288,2,'6bb01960c9f274a7f409dd992840990ec1c516739b8c2461d5e0b3af4213dfd2','2026-02-23 08:03:42','2026-01-24 04:03:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(289,2,'784d0e003c78162d26c7dc4e215d94a7b93ebb55b91c5c4a8671440f1237e8fa','2026-02-23 08:03:42','2026-01-24 04:03:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(290,2,'f3c86357ecfe91f2e1f00430882e204328dc1f92a702a36aa7fde08a9897a412','2026-02-23 08:03:42','2026-01-24 04:03:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(291,2,'217aa0f2adc426341655415ae37c7b23312a4ee7f04e4e326fcaef9b02fb3714','2026-02-23 08:03:53','2026-01-24 04:03:53',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(292,2,'7f92b98cb7d91b72bee1b053492d275a07942f19f97de4d95d038594ef151397','2026-02-23 08:14:19','2026-01-24 04:14:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(293,2,'e032489a41dde53b0acfb380e327ab6fd60c0f637064da1dad52003a607dedba','2026-02-23 08:14:19','2026-01-24 04:14:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(294,2,'a654f8084f18b008de2a16340fd224489fa75df49ba5d39a24b1a9845faf8ab5','2026-02-23 08:14:19','2026-01-24 04:14:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(295,2,'cbf089a6592a721c4589a212f495d71a43954d87c257360cdbe3009c3f104d28','2026-02-23 08:14:48','2026-01-24 04:14:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(296,2,'24ca911aec3f8f82a04124d778df8fbe57e13e8a9614bf90f4ef190f9e547213','2026-02-23 08:14:50','2026-01-24 04:14:50',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(297,2,'f6dd1dbc12aee6d3a04b946dbc48d1e6d3d1728e641366d923068332a1a72588','2026-02-23 08:28:36','2026-01-24 04:28:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(298,2,'206aad7be354be91706724e11f9afd960567d6bf17effbfa755765bb16c15608','2026-02-23 08:28:36','2026-01-24 04:28:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(299,2,'3177bd2f6eed3e08c9e2669a5895dc3d4e2b3d9772faa1c509a5d89ceaa0f66e','2026-02-23 08:28:36','2026-01-24 04:28:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(300,2,'9d84c74de72c1c18c75b27ff7bdb882770d7e188cc27605ee0879e0a47b3897e','2026-02-23 08:28:55','2026-01-24 04:28:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(301,2,'bb6f1657beec1a70b01ff87b7e429b3e5b7be83fcf1b85a1080ff0c9ef3774a4','2026-02-23 10:17:18','2026-01-24 06:17:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(302,2,'6d56f86fc874978890041875d724f4fc449184ac7d61b034116b701ba05badc1','2026-02-23 10:17:18','2026-01-24 06:17:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(303,2,'193d6e8f3bdbb7b9f8fc2f8e50d48b867a960740af52f6a0b6d6d90f1c0f789b','2026-02-23 10:17:18','2026-01-24 06:17:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(304,2,'8b149f5433535d8e6be3bf4d6cf7a59c24da637fe44857b2c163392d827b2506','2026-02-23 10:17:27','2026-01-24 06:17:27',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(305,2,'8e03b74fdd5d5e19715b8630c3575454956023837ebe8bdaad23418ad52dc818','2026-02-23 10:17:28','2026-01-24 06:17:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(306,2,'3c6993e44ee49fcdb90af282fb9594ccdf13006e85fb034ac1ad53d00777cf7f','2026-02-23 10:17:58','2026-01-24 06:17:58',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(307,2,'f7d4f33f56a3da337b9f8ecc7f95a91a1c36d4e577a7964ca5daabdc94f8925c','2026-02-23 10:17:58','2026-01-24 06:17:58',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(308,2,'b380b0216a90c6ef06466bd8c7f616c8c6fa4b2ec0180ad99896ae28cacc8518','2026-02-23 10:17:58','2026-01-24 06:17:58',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(309,2,'d324fd9826b9000e8c291e620067f86cd137488077e70f17735e3e0206733596','2026-02-23 10:18:06','2026-01-24 06:18:06',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(310,2,'7242ce4546ec0e8314e1b8b0aeb8e728a1dfa1957d4c2b5d777446ed0a8ea212','2026-02-23 10:18:08','2026-01-24 06:18:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(311,2,'55909c4f5c55089022400e89c8a66cdd3464e77b99600b2b6d58b1cff52139bb','2026-02-23 10:23:48','2026-01-24 06:23:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(312,2,'94b5af9c1cb20fbd882545f5d8c21ef58ac98eb163ae48b888cf65275a158ac1','2026-02-23 10:24:02','2026-01-24 06:24:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(313,2,'3f6a15616731f168638f7ba4c6cb8a9b0ffd828de17074175e4d9836abfa3a4d','2026-02-23 10:26:07','2026-01-24 06:26:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(314,2,'c8b73a7f7c277240b442b9e476b69405fe079b622748f8c920fee3a023a43f57','2026-02-23 10:26:09','2026-01-24 06:26:09',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(315,2,'53066d2c592e95c16388e28a8351638573c184bae3f129878fa96a8987149827','2026-02-23 10:26:29','2026-01-24 06:26:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(316,2,'02ec24b1cb7268c939b1c1c9eb6f134d1c97f14d14845fc119be07caa1dd8691','2026-02-23 10:27:10','2026-01-24 06:27:10',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(317,2,'4437225b207b8da218e9dfa105b76e1117a4d3c6a15fa14e78456403f8e40d4e','2026-02-23 10:34:20','2026-01-24 06:34:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(318,2,'9804dd126e7a624b87d299685138dfd92ebf14104815efddbc82181380ddb054','2026-02-23 10:34:20','2026-01-24 06:34:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(319,2,'e48a05d35d2e694635bb972860218faf84d4714e57c319143c38e339f204df2f','2026-02-23 10:34:20','2026-01-24 06:34:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(320,2,'eb26c8a8fbfe9a5e886dc53ef93fe5baa0eef221ba668dcde6c0c7679f80d3fa','2026-02-23 10:34:34','2026-01-24 06:34:34',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(321,2,'fec41786fde5ee7f09dbaa7f4128b0392a9eb6401d5ddf000ed9431c88715d34','2026-02-23 10:34:36','2026-01-24 06:34:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(322,2,'307ae4394a2f72fd81c47b9a507d3ceb825034cd8e502f74ea7ea39be23b77e0','2026-02-23 10:34:37','2026-01-24 06:34:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(323,2,'787c00ef155e5a4d068cfe4a2e5bb3b340dc609fc74a06ae370f8358123d76c0','2026-02-23 10:34:46','2026-01-24 06:34:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(324,2,'4a5260a8b49a64a22378c3ae1fbced5076e2928009a296da06092a9bac6b8cf4','2026-02-23 10:35:17','2026-01-24 06:35:17',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(325,2,'5b447c0f27cd497fedad664e7ad14c5e5017043a16ea86a6fc25bf2f41eb2519','2026-02-23 10:35:18','2026-01-24 06:35:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(326,2,'2d959210c89c419b965458af5592f187d9630b5468234c18fc22085c145571dd','2026-02-23 10:35:18','2026-01-24 06:35:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(327,2,'57a8016dd2e8dc28417a3d07969dda010e1b38a50d2a307b3f480630579a501a','2026-02-23 10:37:44','2026-01-24 06:37:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(328,2,'005bccfe783e762ef43825c054c14089daf52ce2e49ac8208b519b2f4b489b9f','2026-02-23 10:37:44','2026-01-24 06:37:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(329,2,'36fbaa72a9947fb272a1be597094bb7e21ec4063c574c2a1720bd69f216f0464','2026-02-23 10:37:44','2026-01-24 06:37:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(330,2,'fdd1c03dd95c4f979a39c9aa3b94362ea4ee189566ab2689d21a1017bc996cb1','2026-02-23 10:37:55','2026-01-24 06:37:55',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(331,2,'e7c85686ff710de5b7f210d30b6ba282805f6407928e05ffcda6a7dcad14ec72','2026-02-23 10:37:57','2026-01-24 06:37:57',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(332,2,'9849e66adbd13b76215f07c3a1c531e4d1a98362c5cedcc181124b5c814c67c6','2026-02-23 10:39:07','2026-01-24 06:39:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(333,2,'36c01e995c6fed0fbd449b5ec72da86e8c4f5a0da6058dee1dfc88149f41006e','2026-02-23 10:39:11','2026-01-24 06:39:11',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(334,2,'60349705a3ed005a37f68bb99087b13fe4ca1af46f9d7724df8171eab3ba2461','2026-02-23 10:39:29','2026-01-24 06:39:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(335,2,'3cf858640e6bc0caed5b682dde791e2ae4d68ad5e062773ef41f6f2bf36ae551','2026-02-23 10:39:29','2026-01-24 06:39:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(336,2,'5aa1c0ff4877c368cc989b8c504ee7340204a24f6f94a2f3f3251a10669a2475','2026-02-23 10:39:30','2026-01-24 06:39:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(337,2,'099f22a72d55f3a7af69cdaad8bbd38230d7c8da6b62831416fdcc59d5bfefe4','2026-02-23 10:39:35','2026-01-24 06:39:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(338,2,'f19247de589a591fa7032d28c86e8a44a32a9f245b2f5b2f7bdac2d06061e5f2','2026-02-23 10:39:39','2026-01-24 06:39:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(339,2,'1c5d5c6db888e3cf8a569ede1e5c00025b7a822cd218fe3a03703801c3301c8a','2026-02-23 10:40:41','2026-01-24 06:40:41',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(340,2,'12d9f59aadc2992988c2568ff92a31cfe3eaab216fa94cd57683c017a6a7666b','2026-02-23 10:40:42','2026-01-24 06:40:42',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(341,2,'6b621f4966bb676e5fabcd095ee7ca9186777a1e55ecab74cd57f1afd37736af','2026-02-23 10:42:13','2026-01-24 06:42:13',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(342,2,'3e8d69c90457b56125ec9d6864aade7a964690a5393c0e82819580938a6ec5f3','2026-02-23 10:42:56','2026-01-24 06:42:56',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(343,2,'9f989ba878404d217661178179f2a9ce6cb786c00814ab5dd94054812b3a1a09','2026-02-23 10:42:57','2026-01-24 06:42:57',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(344,2,'61850d796f81397fefcf9fb34d635c4bbafe44836109f1185def8692630661c1','2026-02-23 10:42:57','2026-01-24 06:42:57',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(345,2,'2eab1548f8441cdff66f4f6259003f00e919e64761b8b2bc7fecb7c1cf2a1254','2026-02-23 10:48:35','2026-01-24 06:48:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(346,2,'db605f6006b5ff32739684d38002ac43847616604bdea13fb21ba89cb48efec9','2026-02-23 10:48:37','2026-01-24 06:48:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(347,2,'9790cd6e4f72d48f87b4aa134aa5b52b7b87496ec2850a2d23a4dccfd9a611dd','2026-02-23 10:49:35','2026-01-24 06:49:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(348,2,'a22fb6d5561ec76c0daa75516056a1f2b042d2ddc3e4d790d8d4bc71e8f334ac','2026-02-23 10:50:04','2026-01-24 06:50:04',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(349,2,'b30a788fcc71004e44f55cd327d35b5f9e153a3e1a6701fb5ee0575f943209a4','2026-02-23 10:50:38','2026-01-24 06:50:38',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(350,2,'9e20d346beef513edeac61728bfd2f86faedde304b53164f567f162684f16e0f','2026-02-23 10:51:24','2026-01-24 06:51:24',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(351,2,'f13f7f10210c54eb459b11fb308926c690904d17e21f7d41bab1cb8d878b35a3','2026-02-23 11:01:13','2026-01-24 07:01:13',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(352,2,'f186aef3d3764ede8932983e3e72998412239419dc00849fd9490720b3304c4f','2026-02-23 11:01:14','2026-01-24 07:01:14',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(353,2,'7f1a8fb7a57cc3f24be4b166c76df16e6529371cde00d9b2b54eee52abd5b2bd','2026-02-23 11:03:30','2026-01-24 07:03:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(354,2,'2036cf8ef86595fac3809a0e096a367b37d1a6bbbb2e377888f7a5aac715ae23','2026-02-25 05:24:18','2026-01-26 01:24:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(355,2,'cbc3f3991c594adf6ff478ec590d549d8c1eac2fce0a0ff18be688ffadb0cfc3','2026-02-25 05:24:18','2026-01-26 01:24:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(356,2,'9a97a909534824108a07942004b0efa5d7d3b72df69b0916586e2c1f31de1e76','2026-02-25 05:24:18','2026-01-26 01:24:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(357,2,'2fcd5f6f4a850378844e00b62d3d19187ef999eebfb2da1b981d4d13d41af94d','2026-02-25 05:24:26','2026-01-26 01:24:26',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(358,2,'49947e620f546bed4e7ce3b7bb4c7c9dfc715a847c29b67cb0996defd048292e','2026-02-25 05:24:28','2026-01-26 01:24:28',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(359,2,'ef776c069aad347902b692bf41d2d8256ed20aaf25c43c0fc1c7177cd92ef3ba','2026-02-25 05:24:30','2026-01-26 01:24:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(360,2,'c3009304b3e13bc570b0a6319bbd62aab089403e2f1a649408721c5e8b78ce31','2026-02-25 05:24:30','2026-01-26 01:24:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(361,2,'00804f65131a5ccc1fcc0fe341151e8231d48b920ce4da89ae3f1afcd9292054','2026-02-25 05:24:30','2026-01-26 01:24:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(362,2,'6af5703c342ec8c741de840de271408dad486f14122f54abdebee7570511da44','2026-02-25 05:24:38','2026-01-26 01:24:38',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(363,2,'039010105b69316d147d63a2a99158e6479b7545c686368ffb100c358eba5db5','2026-02-25 05:24:39','2026-01-26 01:24:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(364,2,'906f0b4502f8b69e32d12e8d611e8cd95d91079ae2526037e5188f898dd2fde5','2026-02-25 05:26:18','2026-01-26 01:26:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(365,2,'23fd73951e5650907a640bde333d760464dcaab57ebd37c12be22ee2d07f85ad','2026-02-25 05:47:17','2026-01-26 01:47:17',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(366,2,'a17258e9b1ea8eac6d0fef6ff95a9e4a83ceda1b4e7373057f3a1ef8f5920690','2026-02-25 05:47:17','2026-01-26 01:47:17',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(367,2,'facab3b0a8365046a64e23fa24c8a18adcb4d7edbeb0c0fabe19a3908f515d14','2026-02-25 05:47:17','2026-01-26 01:47:17',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(368,2,'cc7a283975529a1eec4aa18de3f2f5c7239f7febf6152849cc98030c945d4f4f','2026-02-25 05:47:24','2026-01-26 01:47:24',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(369,2,'5447a91c7fc1b4012c14d7b4da0f658fbb76515576df3fdd2a8dcc3bbdc655e4','2026-02-25 05:49:02','2026-01-26 01:49:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(370,2,'c67c66a4fc8700a552bcbd5d69d2b6a9220552c3ae8b5cf612d9760ff04ff4d5','2026-02-25 05:49:02','2026-01-26 01:49:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(371,2,'4773b6245ac0af17de4d1bc55df1bb281c6e10d2c6116208e88ba193a57527ec','2026-02-25 05:49:02','2026-01-26 01:49:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1');
/*!40000 ALTER TABLE `usuario_refresh` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_sistema`
--

DROP TABLE IF EXISTS `usuario_sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_sistema` (
  `id_usuario` bigint NOT NULL,
  `id_sistema` bigint NOT NULL,
  `id_perfil` int NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`,`id_sistema`,`id_perfil`),
  KEY `fk_us_sistema` (`id_sistema`),
  KEY `fk_us_perfil` (`id_perfil`),
  CONSTRAINT `fk_us_perfil` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`),
  CONSTRAINT `fk_us_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
  CONSTRAINT `fk_us_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_sistema`
--

LOCK TABLES `usuario_sistema` WRITE;
/*!40000 ALTER TABLE `usuario_sistema` DISABLE KEYS */;
INSERT INTO `usuario_sistema` VALUES (1,2,1,1,'2026-01-17 23:08:32'),(2,1,6,1,'2026-01-18 05:48:17'),(2,2,6,1,'2026-01-18 05:48:17');
/*!40000 ALTER TABLE `usuario_sistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `viatura`
--

DROP TABLE IF EXISTS `viatura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `viatura` (
  `id_viatura` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `prefixo` varchar(30) NOT NULL,
  `tipo` enum('AMBULANCIA_BASICA','AMBULANCIA_AVANCADA','OUTRO') NOT NULL DEFAULT 'OUTRO',
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_viatura`),
  UNIQUE KEY `uk_viatura` (`id_unidade`,`prefixo`),
  CONSTRAINT `fk_viatura_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viatura`
--

LOCK TABLES `viatura` WRITE;
/*!40000 ALTER TABLE `viatura` DISABLE KEYS */;
/*!40000 ALTER TABLE `viatura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_farmacia_dashboard_completo`
--

DROP TABLE IF EXISTS `vw_farmacia_dashboard_completo`;
/*!50001 DROP VIEW IF EXISTS `vw_farmacia_dashboard_completo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_farmacia_dashboard_completo` AS SELECT 
 1 AS `id_farmaco`,
 1 AS `nome_comercial`,
 1 AS `principio_ativo`,
 1 AS `id_local`,
 1 AS `quantidade_atual`,
 1 AS `min_estoque`,
 1 AS `deficit`,
 1 AS `id_lote`,
 1 AS `numero_lote`,
 1 AS `data_validade`,
 1 AS `dias_para_vencer`,
 1 AS `nivel_risco`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_farmacia_dashboard_critico`
--

DROP TABLE IF EXISTS `vw_farmacia_dashboard_critico`;
/*!50001 DROP VIEW IF EXISTS `vw_farmacia_dashboard_critico`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_farmacia_dashboard_critico` AS SELECT 
 1 AS `id_farmaco`,
 1 AS `nome_comercial`,
 1 AS `principio_ativo`,
 1 AS `id_local`,
 1 AS `estoque_atual`,
 1 AS `min_estoque`,
 1 AS `deficit`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_farmaco_alerta_estoque`
--

DROP TABLE IF EXISTS `vw_farmaco_alerta_estoque`;
/*!50001 DROP VIEW IF EXISTS `vw_farmaco_alerta_estoque`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_farmaco_alerta_estoque` AS SELECT 
 1 AS `id_farmaco`,
 1 AS `nome_comercial`,
 1 AS `principio_ativo`,
 1 AS `id_local`,
 1 AS `estoque_atual`,
 1 AS `min_estoque`,
 1 AS `deficit`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_farmaco_consumo_periodo`
--

DROP TABLE IF EXISTS `vw_farmaco_consumo_periodo`;
/*!50001 DROP VIEW IF EXISTS `vw_farmaco_consumo_periodo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_farmaco_consumo_periodo` AS SELECT 
 1 AS `id_farmaco`,
 1 AS `nome_comercial`,
 1 AS `id_cidade`,
 1 AS `data_consumo`,
 1 AS `total_consumido`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_farmaco_consumo_por_ffa`
--

DROP TABLE IF EXISTS `vw_farmaco_consumo_por_ffa`;
/*!50001 DROP VIEW IF EXISTS `vw_farmaco_consumo_por_ffa`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_farmaco_consumo_por_ffa` AS SELECT 
 1 AS `id_ffa`,
 1 AS `id_farmaco`,
 1 AS `nome_comercial`,
 1 AS `quantidade`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_farmaco_estoque_lote`
--

DROP TABLE IF EXISTS `vw_farmaco_estoque_lote`;
/*!50001 DROP VIEW IF EXISTS `vw_farmaco_estoque_lote`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_farmaco_estoque_lote` AS SELECT 
 1 AS `id_farmaco`,
 1 AS `id_lote`,
 1 AS `id_cidade`,
 1 AS `estoque_lote`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_farmaco_estoque_total`
--

DROP TABLE IF EXISTS `vw_farmaco_estoque_total`;
/*!50001 DROP VIEW IF EXISTS `vw_farmaco_estoque_total`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_farmaco_estoque_total` AS SELECT 
 1 AS `id_farmaco`,
 1 AS `id_cidade`,
 1 AS `estoque_total`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_farmaco_lote_vencimento_proximo`
--

DROP TABLE IF EXISTS `vw_farmaco_lote_vencimento_proximo`;
/*!50001 DROP VIEW IF EXISTS `vw_farmaco_lote_vencimento_proximo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_farmaco_lote_vencimento_proximo` AS SELECT 
 1 AS `id_lote`,
 1 AS `id_farmaco`,
 1 AS `nome_comercial`,
 1 AS `numero_lote`,
 1 AS `data_validade`,
 1 AS `dias_para_vencer`,
 1 AS `id_cidade`,
 1 AS `estoque_lote`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_farmaco_risco_sanitario`
--

DROP TABLE IF EXISTS `vw_farmaco_risco_sanitario`;
/*!50001 DROP VIEW IF EXISTS `vw_farmaco_risco_sanitario`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_farmaco_risco_sanitario` AS SELECT 
 1 AS `id_farmaco`,
 1 AS `nome_comercial`,
 1 AS `principio_ativo`,
 1 AS `id_lote`,
 1 AS `numero_lote`,
 1 AS `data_validade`,
 1 AS `dias_para_vencer`,
 1 AS `nivel_risco`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_fila_atendimento`
--

DROP TABLE IF EXISTS `vw_fila_atendimento`;
/*!50001 DROP VIEW IF EXISTS `vw_fila_atendimento`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_fila_atendimento` AS SELECT 
 1 AS `id_atendimento`,
 1 AS `protocolo`,
 1 AS `nome_completo`,
 1 AS `status_atendimento`,
 1 AS `local`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_fila_enfermagem`
--

DROP TABLE IF EXISTS `vw_fila_enfermagem`;
/*!50001 DROP VIEW IF EXISTS `vw_fila_enfermagem`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_fila_enfermagem` AS SELECT 
 1 AS `id_ordem`,
 1 AS `id_ffa`,
 1 AS `tipo_ordem`,
 1 AS `prioridade`,
 1 AS `descricao`,
 1 AS `frequencia`,
 1 AS `iniciado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_fila_farmacia`
--

DROP TABLE IF EXISTS `vw_fila_farmacia`;
/*!50001 DROP VIEW IF EXISTS `vw_fila_farmacia`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_fila_farmacia` AS SELECT 
 1 AS `id_ordem`,
 1 AS `id_ffa`,
 1 AS `medicamento`,
 1 AS `dose`,
 1 AS `via`,
 1 AS `prioridade`,
 1 AS `iniciado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_fila_operacional_atual`
--

DROP TABLE IF EXISTS `vw_fila_operacional_atual`;
/*!50001 DROP VIEW IF EXISTS `vw_fila_operacional_atual`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_fila_operacional_atual` AS SELECT 
 1 AS `id_fila`,
 1 AS `id_ffa`,
 1 AS `tipo`,
 1 AS `substatus`,
 1 AS `prioridade`,
 1 AS `data_entrada`,
 1 AS `data_inicio`,
 1 AS `data_fim`,
 1 AS `id_responsavel`,
 1 AS `responsavel_login`,
 1 AS `id_local`,
 1 AS `local_nome`,
 1 AS `observacao`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_historico_ordens_assistenciais`
--

DROP TABLE IF EXISTS `vw_historico_ordens_assistenciais`;
/*!50001 DROP VIEW IF EXISTS `vw_historico_ordens_assistenciais`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_historico_ordens_assistenciais` AS SELECT 
 1 AS `id`,
 1 AS `id_ffa`,
 1 AS `tipo_ordem`,
 1 AS `status`,
 1 AS `criado_por`,
 1 AS `iniciado_em`,
 1 AS `encerrado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_observacoes_ffa`
--

DROP TABLE IF EXISTS `vw_observacoes_ffa`;
/*!50001 DROP VIEW IF EXISTS `vw_observacoes_ffa`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_observacoes_ffa` AS SELECT 
 1 AS `id`,
 1 AS `tipo`,
 1 AS `contexto`,
 1 AS `texto`,
 1 AS `criado_em`,
 1 AS `autor`,
 1 AS `autor_login`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_ordens_assistenciais_ativas`
--

DROP TABLE IF EXISTS `vw_ordens_assistenciais_ativas`;
/*!50001 DROP VIEW IF EXISTS `vw_ordens_assistenciais_ativas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_ordens_assistenciais_ativas` AS SELECT 
 1 AS `id_ordem`,
 1 AS `id_ffa`,
 1 AS `tipo_ordem`,
 1 AS `prioridade`,
 1 AS `status`,
 1 AS `payload_clinico`,
 1 AS `criado_por`,
 1 AS `iniciado_em`,
 1 AS `status_ffa`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_ordens_medicas`
--

DROP TABLE IF EXISTS `vw_ordens_medicas`;
/*!50001 DROP VIEW IF EXISTS `vw_ordens_medicas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_ordens_medicas` AS SELECT 
 1 AS `id_ordem`,
 1 AS `id_ffa`,
 1 AS `tipo_ordem`,
 1 AS `status`,
 1 AS `prioridade`,
 1 AS `payload_clinico`,
 1 AS `iniciado_em`,
 1 AS `encerrado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_pacientes_internados`
--

DROP TABLE IF EXISTS `vw_pacientes_internados`;
/*!50001 DROP VIEW IF EXISTS `vw_pacientes_internados`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_pacientes_internados` AS SELECT 
 1 AS `id_internacao`,
 1 AS `id_atendimento`,
 1 AS `paciente`,
 1 AS `leito`,
 1 AS `tipo`,
 1 AS `data_entrada`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_chamadas_ativas`
--

DROP TABLE IF EXISTS `vw_painel_chamadas_ativas`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_chamadas_ativas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_chamadas_ativas` AS SELECT 
 1 AS `id_senha`,
 1 AS `senha`,
 1 AS `tipo_atendimento`,
 1 AS `status`,
 1 AS `prioridade`,
 1 AS `origem`,
 1 AS `local_chamada`,
 1 AS `id_usuario_chamada`,
 1 AS `chamada_em`,
 1 AS `atendida_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_perfil_permissoes_v2`
--

DROP TABLE IF EXISTS `vw_perfil_permissoes_v2`;
/*!50001 DROP VIEW IF EXISTS `vw_perfil_permissoes_v2`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_perfil_permissoes_v2` AS SELECT 
 1 AS `id_perfil`,
 1 AS `id_permissao`,
 1 AS `permissao_codigo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_procedimentos_pendentes`
--

DROP TABLE IF EXISTS `vw_procedimentos_pendentes`;
/*!50001 DROP VIEW IF EXISTS `vw_procedimentos_pendentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_procedimentos_pendentes` AS SELECT 
 1 AS `id_procedimento`,
 1 AS `id_ffa`,
 1 AS `tipo`,
 1 AS `status`,
 1 AS `prioridade`,
 1 AS `criado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_produtividade_medica_diaria`
--

DROP TABLE IF EXISTS `vw_produtividade_medica_diaria`;
/*!50001 DROP VIEW IF EXISTS `vw_produtividade_medica_diaria`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_produtividade_medica_diaria` AS SELECT 
 1 AS `id_unidade`,
 1 AS `id_usuario`,
 1 AS `dia`,
 1 AS `atendimentos_iniciados`,
 1 AS `atendimentos_finalizados`,
 1 AS `evolucoes`,
 1 AS `prescricoes`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_solicitacoes_exame_pendentes`
--

DROP TABLE IF EXISTS `vw_solicitacoes_exame_pendentes`;
/*!50001 DROP VIEW IF EXISTS `vw_solicitacoes_exame_pendentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_solicitacoes_exame_pendentes` AS SELECT 
 1 AS `id_solicitacao`,
 1 AS `status`,
 1 AS `solicitado_em`,
 1 AS `codigo_sigpat`,
 1 AS `descricao`,
 1 AS `setor_execucao`,
 1 AS `id_ffa`,
 1 AS `paciente`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_totem_plantao_ativo`
--

DROP TABLE IF EXISTS `vw_totem_plantao_ativo`;
/*!50001 DROP VIEW IF EXISTS `vw_totem_plantao_ativo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_totem_plantao_ativo` AS SELECT 
 1 AS `id`,
 1 AS `tipo_plantao`,
 1 AS `nome_medico`,
 1 AS `inicio_plantao`,
 1 AS `fim_plantao`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_usuario_identidade`
--

DROP TABLE IF EXISTS `vw_usuario_identidade`;
/*!50001 DROP VIEW IF EXISTS `vw_usuario_identidade`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_usuario_identidade` AS SELECT 
 1 AS `id_usuario`,
 1 AS `login`,
 1 AS `nome_completo`,
 1 AS `ativo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_usuario_perfis_front`
--

DROP TABLE IF EXISTS `vw_usuario_perfis_front`;
/*!50001 DROP VIEW IF EXISTS `vw_usuario_perfis_front`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_usuario_perfis_front` AS SELECT 
 1 AS `id_usuario`,
 1 AS `perfil`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_usuario_perfis_v2`
--

DROP TABLE IF EXISTS `vw_usuario_perfis_v2`;
/*!50001 DROP VIEW IF EXISTS `vw_usuario_perfis_v2`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_usuario_perfis_v2` AS SELECT 
 1 AS `id_usuario`,
 1 AS `id_sistema`,
 1 AS `id_perfil`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_usuario_permissoes`
--

DROP TABLE IF EXISTS `vw_usuario_permissoes`;
/*!50001 DROP VIEW IF EXISTS `vw_usuario_permissoes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_usuario_permissoes` AS SELECT 
 1 AS `id_usuario`,
 1 AS `perfil`,
 1 AS `id_permissao`,
 1 AS `permissao_codigo`,
 1 AS `permissao_descricao`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_usuario_sistemas`
--

DROP TABLE IF EXISTS `vw_usuario_sistemas`;
/*!50001 DROP VIEW IF EXISTS `vw_usuario_sistemas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_usuario_sistemas` AS SELECT 
 1 AS `id_usuario`,
 1 AS `login`,
 1 AS `id_sistema`,
 1 AS `sistema`,
 1 AS `id_perfil`,
 1 AS `perfil`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'pronto_atendimento'
--

--
-- Dumping routines for database 'pronto_atendimento'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_dias_para_vencimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_dias_para_vencimento`(p_data_validade DATE) RETURNS int
    DETERMINISTIC
RETURN DATEDIFF(p_data_validade, CURDATE()) ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_farmaco_estoque_atual` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_farmaco_estoque_atual`(
    p_id_farmaco BIGINT,
    p_id_cidade BIGINT
) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_estoque INT;

    SELECT IFNULL(estoque_total,0)
    INTO v_estoque
    FROM vw_farmaco_estoque_total
    WHERE id_farmaco = p_id_farmaco
      AND id_cidade  = p_id_cidade;

    RETURN v_estoque;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_farmaco_lote_valido` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_farmaco_lote_valido`(
    p_id_lote BIGINT
) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE v_validade DATE;

    SELECT data_validade
    INTO v_validade
    FROM farmaco_lote
    WHERE id_lote = p_id_lote;

    IF v_validade < CURDATE() THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_gera_protocolo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_gera_protocolo`(p_id_usuario BIGINT) RETURNS varchar(30) CHARSET utf8mb4 COLLATE utf8mb4_general_ci
    READS SQL DATA
BEGIN
    DECLARE seq INT;
    DECLARE protocolo VARCHAR(30);

    -- Inserir na tabela de sequência com usuário e timestamp
    INSERT INTO protocolo_sequencia (id_usuario, created_at) 
    VALUES (p_id_usuario, NOW());
    
    -- Pega o ID gerado
    SET seq = LAST_INSERT_ID();

    -- Monta o protocolo GPAT no formato: ANO + GPAT + número sequencial 6 dígitos
    SET protocolo = CONCAT(
        YEAR(NOW()),
        'GPAT/',
        LPAD(seq, 6, '0')
    );

    RETURN protocolo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_idade_em_anos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_idade_em_anos`(p_data_nascimento DATE) RETURNS int
    DETERMINISTIC
RETURN TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE()) ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_linha_assistencial` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_linha_assistencial`(p_data_nascimento DATE) RETURNS varchar(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci
    DETERMINISTIC
BEGIN
    DECLARE idade INT;

    SET idade = TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());

    IF idade < 12 THEN
        RETURN 'PEDIATRICA';
    END IF;

    RETURN 'CLINICA';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_proxima_senha` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_proxima_senha`(p_tipo ENUM('CLINICO','PEDIATRICO','PRIORITARIO','EMERGENCIA','VISITA','EXAME')) RETURNS bigint
    DETERMINISTIC
BEGIN
    DECLARE proxima BIGINT;
    SELECT IFNULL(MAX(numero),0)+1 INTO proxima
    FROM senhas
    WHERE tipo_atendimento = p_tipo;
    RETURN proxima;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_score_prioridade_social` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_score_prioridade_social`(p_id_ffa BIGINT) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_score INT;

    SELECT COALESCE(SUM(ps.peso), 0)
    INTO v_score
    FROM ffa_prioridade fp
    JOIN prioridade_social ps ON ps.codigo = fp.codigo_prioridade
    WHERE fp.id_ffa = p_id_ffa
      AND fp.ativo = 1
      AND ps.ativo = 1;

    RETURN v_score;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_usuario_tem_perfil` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_usuario_tem_perfil`(p_id_usuario BIGINT, p_perfil_nome VARCHAR(50)) RETURNS tinyint(1)
    READS SQL DATA
    DETERMINISTIC
BEGIN
DECLARE v_count INT DEFAULT 0;


SELECT COUNT(*) INTO v_count
FROM usuario_sistema us
JOIN perfil p ON p.id_perfil = us.id_perfil
WHERE us.id_usuario = p_id_usuario
AND us.ativo = 1
AND p.nome = p_perfil_nome;


RETURN IF(v_count > 0, 1, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_usuario_tem_perfil_id_v2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_usuario_tem_perfil_id_v2`(
  p_id_usuario BIGINT,
  p_id_sistema BIGINT,
  p_id_perfil  INT
) RETURNS tinyint
    DETERMINISTIC
BEGIN
  DECLARE v_qtd INT DEFAULT 0;

  SELECT COUNT(*)
    INTO v_qtd
    FROM usuario_sistema us
   WHERE us.id_usuario = p_id_usuario
     AND us.id_sistema = p_id_sistema
     AND us.id_perfil  = p_id_perfil;

  RETURN IF(v_qtd > 0, 1, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_usuario_tem_permissao_v2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_usuario_tem_permissao_v2`(
  p_id_usuario BIGINT,
  p_id_sistema BIGINT,
  p_codigo_permissao VARCHAR(80)
) RETURNS tinyint
    DETERMINISTIC
BEGIN
  DECLARE v_qtd INT DEFAULT 0;

  SELECT COUNT(*)
    INTO v_qtd
    FROM usuario_sistema us
    JOIN perfil_permissao pp ON pp.id_perfil = us.id_perfil
    JOIN permissao p         ON p.id_permissao = pp.id_permissao
   WHERE us.id_usuario = p_id_usuario
     AND us.id_sistema = p_id_sistema
     AND p.codigo      = p_codigo_permissao;

  RETURN IF(v_qtd > 0, 1, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_abrir_atendimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_abrir_atendimento`(
    IN p_id_pessoa BIGINT,
    IN p_id_senha BIGINT,
    IN p_id_local INT,
    IN p_id_especialidade INT
)
BEGIN
    INSERT INTO atendimento (
        protocolo,
        id_pessoa,
        id_senha,
        status_atendimento,
        id_local_atual,
        id_especialidade
    )
    VALUES (
        fn_gera_protocolo(),
        p_id_pessoa,
        p_id_senha,
        'ABERTO',
        p_id_local,
        p_id_especialidade
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_abrir_ffa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_abrir_ffa`(
    IN p_id_fila BIGINT,
    IN p_id_pessoa BIGINT,
    IN p_layout VARCHAR(50),
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_ffa BIGINT;
    DECLARE v_gpat VARCHAR(30);
    DECLARE v_status_fila VARCHAR(20);

    /* 1. Valida a fila */
    SELECT status
      INTO v_status_fila
      FROM fila_senha
     WHERE id = p_id_fila
       AND id_ffa IS NULL
     FOR UPDATE;

    IF v_status_fila IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha inválida ou já vinculada a FFA';
    END IF;

    IF v_status_fila NOT IN ('CHAMADA') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha não está em estado válido para abertura de FFA';
    END IF;

    /* 2. Gera GPAT */
    SET v_gpat = fn_gera_protocolo();

    /* 3. Cria a FFA */
    INSERT INTO ffa (
        gpat,
        id_pessoa,
        status,
        layout,
        criado_em
    ) VALUES (
        v_gpat,
        p_id_pessoa,
        'ABERTO',
        p_layout,
        NOW()
    );

    SET v_id_ffa = LAST_INSERT_ID();

    /* 4. Vincula fila à FFA */
    UPDATE fila_senha
       SET id_ffa   = v_id_ffa,
           status   = 'EM_ATENDIMENTO',
           atualizado_em = NOW()
     WHERE id = p_id_fila;

    /* 5. Auditoria assistencial */
    INSERT INTO auditoria_eventos (
        entidade,
        id_entidade,
        evento,
        id_usuario,
        criado_em,
        detalhe
    ) VALUES (
        'FFA',
        v_id_ffa,
        'ABERTURA_FFA',
        p_id_usuario,
        NOW(),
        CONCAT('FFA aberta a partir da senha ', p_id_fila)
    );

    /* 6. Retorno */
    SELECT
        v_id_ffa AS id_ffa,
        v_gpat   AS gpat,
        'FFA_ABERTA' AS status;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_abrir_ffa_com_exames` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_abrir_ffa_com_exames`(
    IN p_id_senha BIGINT,
    IN p_id_usuario BIGINT,
    IN p_layout VARCHAR(50)
)
BEGIN
    DECLARE v_id_fila BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_ffa BIGINT;

    -- ======================================
    -- 1. Valida senha
    -- ======================================
    IF NOT EXISTS (SELECT 1 FROM senhas WHERE id = p_id_senha) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Senha inexistente';
    END IF;

    -- ======================================
    -- 2. Garante que ainda não existe FFA
    -- ======================================
    IF EXISTS (SELECT 1 FROM ffa WHERE id_senha = p_id_senha) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Já existe FFA para esta senha';
    END IF;

    -- ======================================
    -- 3. Busca fila e paciente
    -- ======================================
    SELECT id, id_paciente
      INTO v_id_fila, v_id_paciente
      FROM fila_senha
     WHERE senha = p_id_senha
     LIMIT 1;

    IF v_id_fila IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Senha não está na fila';
    END IF;

    -- ======================================
    -- 4. Cria FFA
    -- ======================================
    INSERT INTO ffa (
        id_paciente,
        status,
        layout,
        id_usuario_criacao,
        criado_em,
        atualizado_em,
        id_senha
    ) VALUES (
        v_id_paciente,
        'ABERTO',
        p_layout,
        p_id_usuario,
        NOW(),
        NOW(),
        p_id_senha
    );

    SET v_id_ffa = LAST_INSERT_ID();

    -- ======================================
    -- 5. Evento de abertura da FFA
    -- ======================================
    INSERT INTO evento_ffa (
        id_ffa,
        evento,
        id_usuario,
        criado_em
    ) VALUES (
        v_id_ffa,
        'ABERTURA_FFA',
        p_id_usuario,
        NOW()
    );

    -- ======================================
    -- 6. Atualiza status da senha
    -- ======================================
    UPDATE senhas
       SET status = 'EM_ATENDIMENTO'
     WHERE id = p_id_senha;

    -- ======================================
    -- 7. Adiciona exames/procedimentos de teste
    -- ======================================
    INSERT INTO ffa_procedimento (
        id_ffa,
        tipo_procedimento,   -- Ex: 'EXAME', 'PROCEDIMENTO'
        descricao,
        status,
        criado_em
    )
    SELECT v_id_ffa, tipo_procedimento, descricao, 'PENDENTE', NOW()
      FROM solicitacao_exame
     WHERE id_senha = p_id_senha;

    -- ======================================
    -- 8. Retorno
    -- ======================================
    SELECT
        v_id_ffa AS id_ffa,
        p_id_senha AS id_senha,
        'ABERTO' AS status,
        p_layout AS layout,
        NOW() AS criado_em;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_abrir_ffa_por_senha` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_abrir_ffa_por_senha`(
    IN p_id_senha BIGINT,
    IN p_id_usuario BIGINT,
    IN p_layout VARCHAR(50)
)
BEGIN
    DECLARE v_id_fila BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_ffa BIGINT;

    /* ===============================
       1. Valida senha
       =============================== */
    IF NOT EXISTS (
        SELECT 1 FROM senhas WHERE id = p_id_senha
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha inexistente';
    END IF;

    /* ===============================
       2. Garante que ainda não existe FFA
       =============================== */
    IF EXISTS (
        SELECT 1 FROM ffa WHERE id_senha = p_id_senha
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Já existe FFA para esta senha';
    END IF;

    /* ===============================
       3. Busca fila e paciente
       =============================== */
    SELECT id, id_paciente
      INTO v_id_fila, v_id_paciente
      FROM fila_senha
     WHERE senha = p_id_senha
     LIMIT 1;

    IF v_id_fila IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha não está na fila';
    END IF;

    /* ===============================
       4. Cria FFA
       =============================== */
    INSERT INTO ffa (
        id_paciente,
        status,
        layout,
        id_usuario_criacao,
        criado_em,
        atualizado_em,
        id_senha
    ) VALUES (
        v_id_paciente,
        'ABERTO',
        p_layout,
        p_id_usuario,
        NOW(),
        NOW(),
        p_id_senha
    );

    SET v_id_ffa = LAST_INSERT_ID();

    /* ===============================
       5. Evento de abertura da FFA
       =============================== */
    INSERT INTO evento_ffa (
        id_ffa,
        evento,
        id_usuario,
        criado_em
    ) VALUES (
        v_id_ffa,
        'ABERTURA_FFA',
        p_id_usuario,
        NOW()
    );

    /* ===============================
       6. Atualiza status da senha
       =============================== */
    UPDATE senhas
       SET status = 'EM_ATENDIMENTO'
     WHERE id = p_id_senha;

    /* ===============================
       7. Retorno
       =============================== */
    SELECT
        v_id_ffa   AS id_ffa,
        p_id_senha AS id_senha,
        'ABERTO'   AS status,
        p_layout   AS layout,
        NOW()      AS criado_em;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_alta_internacao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_internacao`(
    IN p_id_internacao BIGINT,
    IN p_observacao TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_leito INT;
    DECLARE v_id_atendimento BIGINT;

    SELECT id_leito, id_atendimento
      INTO v_id_leito, v_id_atendimento
      FROM internacao
     WHERE id_internacao = p_id_internacao;

    UPDATE internacao
       SET status = 'ENCERRADA',
           data_saida = NOW(),
           id_usuario_saida = p_id_usuario
     WHERE id_internacao = p_id_internacao;

    UPDATE leito
       SET status = 'LIVRE'
     WHERE id_leito = v_id_leito;

    UPDATE atendimento
       SET status_atendimento = 'FINALIZADO',
           data_fechamento = NOW()
     WHERE id_atendimento = v_id_atendimento;

    INSERT INTO internacao_historico
        (id_internacao, evento, descricao, id_usuario)
    VALUES
        (p_id_internacao, 'ALTA', p_observacao, p_id_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_atualizar_estoque` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_atualizar_estoque`(
    IN p_id_produto BIGINT,
    IN p_id_local INT,
    IN p_quantidade INT,
    IN p_id_usuario BIGINT
)
BEGIN
    -- Atualiza estoque
    UPDATE estoque_local SET quantidade_atual = quantidade_atual + p_quantidade
    WHERE id_produto = p_id_produto AND id_local = p_id_local;
    
    -- Auditoria
    INSERT INTO auditoria_estoque (id_produto, id_local, acao, quantidade, id_usuario)
    VALUES (p_id_produto, p_id_local, 'ENTRADA', p_quantidade, p_id_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_atualizar_fila` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_atualizar_fila`(
    IN p_id_fila BIGINT,
    IN p_substatus ENUM('AGUARDANDO','EM_EXECUCAO','EM_OBSERVACAO','FINALIZADO','CRITICO'),
    IN p_id_responsavel BIGINT,
    IN p_observacao TEXT
)
BEGIN
    UPDATE fila_operacional
    SET substatus = p_substatus,
        id_responsavel = p_id_responsavel,
        observacao = p_observacao,
        data_inicio = IF(p_substatus='EM_EXECUCAO', NOW(), data_inicio),
        data_fim = IF(p_substatus='FINALIZADO', NOW(), data_fim)
    WHERE id_fila = p_id_fila;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_atualizar_status_internacao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_atualizar_status_internacao`(
    IN p_id_internacao BIGINT,
    IN p_novo_status ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA'),
    IN p_id_usuario BIGINT,
    IN p_comentario TEXT
)
BEGIN
    DECLARE v_status_atual ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA');

    SELECT status INTO v_status_atual FROM internacao WHERE id_internacao = p_id_internacao;

    UPDATE internacao
    SET status = p_novo_status,
        atualizado_em = NOW()
    WHERE id_internacao = p_id_internacao;

    -- Insere histórico
    INSERT INTO internacao_historico (id_internacao, status_anterior, status_novo, id_usuario, comentario)
    VALUES (p_id_internacao, v_status_atual, p_novo_status, p_id_usuario, p_comentario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_auditoria_evento_registrar_v2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auditoria_evento_registrar_v2`(
  IN p_id_sessao_usuario BIGINT,
  IN p_entidade VARCHAR(80),
  IN p_id_entidade BIGINT,
  IN p_acao VARCHAR(80),
  IN p_detalhe TEXT
)
BEGIN
  INSERT INTO auditoria_evento (
    id_sessao_usuario, entidade, id_entidade, acao, detalhe, criado_em
  ) VALUES (
    p_id_sessao_usuario, p_entidade, p_id_entidade, p_acao, p_detalhe, NOW()
  );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cancelar_procedimento_rx` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cancelar_procedimento_rx`(
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT,
    IN p_motivo        TEXT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* 1. Busca RX ativo */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'RX'
       AND status IN ('SOLICITADO','EM_EXECUCAO')
     ORDER BY criado_em DESC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum RX ativo para cancelamento';
    END IF;

    /* 2. Cancela procedimento */
    UPDATE ffa_procedimento
       SET status = 'CANCELADO',
           finalizado_em = NOW(),
           resultado = p_motivo
     WHERE id_procedimento = v_id_proc;

    /* 3. Remove da fila RX */
    UPDATE fila_operacional
       SET status = 'CANCELADO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'RX';

    /* 4. Substatus */
    INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
    VALUES (p_id_ffa, 'RX_CANCELADO', NOW());

    /* 5. Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'CANCELAMENTO_RX',
        'RX',
        p_id_usuario,
        p_motivo,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_chamar_paciente_medico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_chamar_paciente_medico`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_local VARCHAR(50)
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    -- Valida status atual da FFA
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id = p_id_ffa
     FOR UPDATE;

    IF v_status_atual <> 'AGUARDANDO_CHAMADA_MEDICO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não está aguardando chamada médica';
    END IF;

    -- Atualiza status da FFA
    UPDATE ffa
       SET status = 'CHAMANDO_MEDICO',
           layout = 'MEDICO'
     WHERE id = p_id_ffa;

    -- Atualiza a senha vinculada (chamada em painel)
    UPDATE fila_senha
       SET status = 'CHAMADA',
           id_usuario_chamada = p_id_usuario,
           guiche_chamada = p_local,
           chamada_em = NOW()
     WHERE id_ffa = p_id_ffa
       AND status IN ('EM_FILA','EM_TRIAGEM');

    -- Registra evento
    INSERT INTO eventos_ffa (
        id_ffa,
        tipo_evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'CHAMADA_MEDICA',
        CONCAT('Paciente chamado para atendimento médico no local ', p_local),
        p_id_usuario,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_chamar_painel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_chamar_painel`(
    IN p_id_atendimento BIGINT,
    IN p_id_sala        INT
)
BEGIN
    INSERT INTO chamada_painel (
        id_atendimento,
        id_sala,
        status,
        data_hora
    ) VALUES (
        p_id_atendimento,
        p_id_sala,
        'CHAMANDO',
        NOW()
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_chamar_procedimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_chamar_procedimento`(
    IN p_id_ffa BIGINT,
    IN p_tipo_procedimento VARCHAR(30), -- MEDICACAO | RX | COLETA | ECG
    IN p_id_local INT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_novo_status VARCHAR(50);

    -- Determina status conforme procedimento
    SET v_novo_status =
        CASE p_tipo_procedimento
            WHEN 'MEDICACAO' THEN 'EM_MEDICACAO'
            WHEN 'RX'        THEN 'EM_RX'
            WHEN 'COLETA'    THEN 'EM_COLETA'
            WHEN 'ECG'       THEN 'EM_ECG'
            ELSE NULL
        END;

    IF v_novo_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Tipo de procedimento inválido';
    END IF;

    -- Valida estado atual
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id = p_id_ffa
     FOR UPDATE;

    IF v_status_atual NOT LIKE 'AGUARDANDO_%' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não está aguardando procedimento';
    END IF;

    -- Atualiza FFA
    UPDATE ffa
       SET status = v_novo_status,
           layout = 'PROCEDIMENTOS',
           id_local_atendimento = p_id_local,
           id_usuario_alteracao = p_id_usuario,
           atualizado_em = NOW()
     WHERE id = p_id_ffa;

    -- Evento
    INSERT INTO eventos_ffa (
        id_ffa,
        tipo_evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'CHAMADA_PROCEDIMENTO',
        CONCAT('Chamado para ', p_tipo_procedimento),
        p_id_usuario,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_chamar_senha` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_chamar_senha`(
    IN p_id_guiche INT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_fila BIGINT;
    DECLARE v_id_senha BIGINT;

    /*
      Seleciona a próxima senha válida:
      - ainda sem FFA
      - não finalizada
      - sem retorno futuro ativo
      - respeita prioridade e horário
    */
    SELECT fs.id, fs.senha
      INTO v_id_fila, v_id_senha
      FROM fila_senha fs
      LEFT JOIN fila_retorno fr 
             ON fr.id_fila = fs.id 
            AND fr.ativo = 1
            AND fr.retorno_em > NOW()
     WHERE fs.id_ffa IS NULL
       AND fs.status IN ('EM_FILA','GERADA')
       AND fr.id IS NULL
     ORDER BY
        CASE fs.prioridade_recepcao
            WHEN 'IDOSO' THEN 3
            WHEN 'CRIANCA' THEN 2
            WHEN 'ESPECIAL' THEN 1
            ELSE 0
        END DESC,
        fs.criado_em ASC
     LIMIT 1;

    -- Se não achou senha, encerra
    IF v_id_fila IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nenhuma senha disponível para chamada';
    END IF;

    -- Marca a fila como chamada
    UPDATE fila_senha
       SET status        = 'CHAMADA',
           chamado_em    = NOW(),
           id_guiche     = p_id_guiche,
           id_usuario_chamada = p_id_usuario
     WHERE id = v_id_fila;

    -- Atualiza status da senha
    UPDATE senhas
       SET status = 'CHAMADA'
     WHERE id = v_id_senha;

    -- Auditoria (se existir)
    /*
    INSERT INTO auditoria_fila (
        id_senha,
        acao,
        id_usuario,
        data_hora,
        detalhe
    ) VALUES (
        v_id_senha,
        'CHAMADA_SENHA',
        p_id_usuario,
        NOW(),
        CONCAT('Guichê ', p_id_guiche)
    );
    */

    -- Retorno
    SELECT
        v_id_senha AS id_senha,
        p_id_guiche AS guiche,
        NOW() AS chamado_em;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_classificar_manchester` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_classificar_manchester`(
    IN p_id_ffa BIGINT,
    IN p_classificacao ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_senha BIGINT;

    SELECT id_senha
    INTO v_id_senha
    FROM ffa
    WHERE id = p_id_ffa;

    IF v_id_senha IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FFA sem senha associada';
    END IF;

    UPDATE ffa
    SET classificacao_manchester = p_classificacao
    WHERE id = p_id_ffa;

    UPDATE senha
    SET prioridade = CASE p_classificacao
        WHEN 'VERMELHO' THEN 5
        WHEN 'LARANJA'  THEN 4
        WHEN 'AMARELO'  THEN 3
        WHEN 'VERDE'    THEN 2
        WHEN 'AZUL'     THEN 1
    END
    WHERE id = v_id_senha;

    INSERT INTO auditoria_eventos (
        entidade,
        id_entidade,
        evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        'FFA',
        p_id_ffa,
        'CLASSIFICACAO_MANCHESTER',
        CONCAT('Classificação: ', p_classificacao),
        p_id_usuario,
        NOW()
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_consolidar_faturamento_ffa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consolidar_faturamento_ffa`(
    IN p_id_ffa BIGINT
)
BEGIN
    SELECT
        origem,
        descricao,
        SUM(quantidade) AS total_quantidade
    FROM faturamento_item
    WHERE id_ffa = p_id_ffa
    GROUP BY origem, descricao;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_criar_agendamento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_criar_agendamento`(
    IN p_id_pessoa BIGINT,
    IN p_id_especialidade INT,
    IN p_data_agendada DATETIME,
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    INSERT INTO agendamentos (id_pessoa, id_especialidade, data_agendada, id_usuario, observacao)
    VALUES (p_id_pessoa, p_id_especialidade, p_data_agendada, p_id_usuario, p_observacao);
    
    -- Evento inicial
    INSERT INTO agendamentos_eventos (id_agendamento, tipo_evento, descricao, id_usuario)
    VALUES (LAST_INSERT_ID(), 'CRIACAO', 'Agendamento criado', p_id_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_criar_usuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_criar_usuario`(
    IN p_nome VARCHAR(150),
    IN p_login VARCHAR(50),
    IN p_senha VARCHAR(255),
    IN p_id_perfil BIGINT,
    IN p_id_local BIGINT,
    OUT p_id_usuario BIGINT
)
BEGIN
    START TRANSACTION;

    -- Inserir usuário
    INSERT INTO usuario (nome, login, senha, criado_em)
    VALUES (p_nome, p_login, p_senha, NOW());
    SET p_id_usuario = LAST_INSERT_ID();

    -- Vincular perfil
    INSERT INTO usuario_perfil (id_usuario, id_perfil)
    VALUES (p_id_usuario, p_id_perfil);

    -- Alocação em local
    INSERT INTO usuario_alocacao (id_usuario, id_local)
    VALUES (p_id_usuario, p_id_local);

    -- Log de auditoria
    INSERT INTO log_auditoria (id_usuario, tabela, acao, detalhe, criado_em)
    VALUES (p_id_usuario, 'usuario', 'INSERT', CONCAT('Usuário criado: ', p_nome), NOW());

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_decisao_pos_timeout` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_decisao_pos_timeout`(
    IN p_id_ffa BIGINT,
    IN p_acao VARCHAR(20),
    IN p_id_usuario BIGINT,
    IN p_obs TEXT
)
BEGIN
    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
    VALUES
        (p_id_ffa, CONCAT('DECISAO_TIMEOUT_', p_acao),
         'SISTEMA', p_id_usuario, p_obs, NOW());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_definir_decisao_medica_final` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_definir_decisao_medica_final`(
    IN p_id_ffa BIGINT,
    IN p_decisao VARCHAR(20),
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa
       SET decisao_final = p_decisao,
           decisao_em = NOW()
     WHERE id_ffa = p_id_ffa;

    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, criado_em)
    VALUES
        (p_id_ffa, CONCAT('DECISAO_MEDICA_', p_decisao),
         'MEDICO', p_id_usuario, NOW());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_encerrar_ordem_assistencial` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_encerrar_ordem_assistencial`(
    IN p_id_ordem   BIGINT,
    IN p_resultado  TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    SELECT id_ffa
      INTO v_id_ffa
      FROM ordem_assistencial
     WHERE id = p_id_ordem
       AND status IN ('ATIVA','SUSPENSA');

    IF v_id_ffa IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ordem inválida para encerramento';
    END IF;

    UPDATE ordem_assistencial
       SET status = 'ENCERRADA',
           encerrado_em = NOW()
     WHERE id = p_id_ordem;

    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        v_id_ffa,
        'ENCERRAMENTO_ORDEM_ASSISTENCIAL',
        'ORDEM',
        p_id_usuario,
        p_resultado,
        NOW()
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_execucao_medicacao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_execucao_medicacao`(
    IN p_id_ffa BIGINT,
    IN p_tipo ENUM('MEDICACAO','OBSERVACAO'),
    IN p_id_usuario BIGINT,
    IN p_acao ENUM('AGUARDANDO','EM_EXECUCAO','CONCLUIDO')
)
BEGIN
    DECLARE v_substatus VARCHAR(50);

    -- Define substatus
    SET v_substatus = CONCAT(p_tipo,'_',p_acao);

    -- Atualiza FFA com substatus
    UPDATE ffa
    SET substatus = v_substatus,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Insere na fila operacional para controle
    INSERT INTO fila_operacional (
        id_ffa,
        tipo_evento,
        prioridade,
        criado_em
    ) VALUES (
        p_id_ffa,
        CONCAT('EXECUCAO_',p_tipo),
        CASE WHEN p_acao='CONCLUIDO' THEN 10 ELSE 5 END,
        NOW()
    );

    -- Auditoria
    INSERT INTO auditoria_ffa (
        id_ffa,
        acao,
        descricao,
        id_usuario,
        data_hora
    ) VALUES (
        p_id_ffa,
        CONCAT('EXECUCAO_',p_tipo),
        CONCAT('Substatus atualizado: ', v_substatus),
        p_id_usuario,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_farmacia_saida_estoque` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmacia_saida_estoque`(
    IN p_id_lote BIGINT,
    IN p_quantidade INT,
    IN p_id_usuario BIGINT,
    IN p_id_local BIGINT
)
BEGIN
    DECLARE v_id_farmaco BIGINT;
    DECLARE v_validade DATE;
    DECLARE v_dias INT;
    DECLARE v_risco VARCHAR(20);
    DECLARE v_estoque INT;

    SELECT id_farmaco, data_validade
      INTO v_id_farmaco, v_validade
      FROM lote
     WHERE id_lote = p_id_lote;

    SET v_dias = fn_dias_para_vencimento(v_validade);

    SET v_risco = CASE
        WHEN v_dias < 0 THEN 'VENCIDO'
        WHEN v_dias <= 30 THEN 'CRITICO'
        ELSE 'OK'
    END;

    IF v_risco = 'VENCIDO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saída bloqueada: medicamento vencido';
    END IF;

    SELECT quantidade_atual
      INTO v_estoque
      FROM estoque_local
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local
     FOR UPDATE;

    IF v_estoque IS NULL OR v_estoque < p_quantidade THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente';
    END IF;

    UPDATE estoque_local
       SET quantidade_atual = quantidade_atual - p_quantidade
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local;

    INSERT INTO auditoria_estoque_sanitario
        (id_farmaco, id_lote, id_local, quantidade, nivel_risco, criado_por)
    VALUES
        (v_id_farmaco, p_id_lote, p_id_local, p_quantidade, v_risco, p_id_usuario);

    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, realizado_por)
    VALUES
        (v_id_farmaco, p_id_lote, p_id_local, 'SAIDA', p_quantidade, 'FARMACIA', p_id_usuario);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_farmaco_entrada` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmaco_entrada`(
    IN p_id_farmaco BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_local BIGINT,
    IN p_quantidade INT,
    IN p_origem ENUM('COMPRA','TRANSFERENCIA','AJUSTE'),
    IN p_usuario BIGINT
)
BEGIN
    DECLARE v_saldo_atual INT DEFAULT 0;

    -- 1️⃣ Validação de lote
    IF fn_farmaco_lote_valido(p_id_lote) = FALSE THEN
        INSERT INTO farmaco_auditoria_bloqueio
            (id_farmaco, id_lote, id_cidade, quantidade, usuario, motivo)
        VALUES
            (p_id_farmaco, p_id_lote, p_id_local, p_quantidade, p_usuario,
             'Tentativa de entrada com lote inválido');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lote inválido. Entrada bloqueada.';
    END IF;

    -- 2️⃣ Verifica estoque existente
    SELECT quantidade_atual
      INTO v_saldo_atual
      FROM estoque_local
     WHERE id_farmaco = p_id_farmaco
       AND id_local = p_id_local
     FOR UPDATE;

    -- 3️⃣ Atualiza ou insere estoque
    IF v_saldo_atual IS NULL THEN
        INSERT INTO estoque_local
            (id_farmaco, id_local, quantidade_atual)
        VALUES
            (p_id_farmaco, p_id_local, p_quantidade);
    ELSE
        UPDATE estoque_local
           SET quantidade_atual = quantidade_atual + p_quantidade
         WHERE id_farmaco = p_id_farmaco
           AND id_local = p_id_local;
    END IF;

    -- 4️⃣ Registra movimentação
    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, realizado_por)
    VALUES
        (p_id_farmaco, p_id_lote, p_id_local, 'ENTRADA', p_quantidade, p_origem, p_usuario);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_farmaco_saida_paciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmaco_saida_paciente`(
    IN p_id_farmaco BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_local BIGINT,
    IN p_quantidade INT,
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_cliente BIGINT
)
BEGIN
    DECLARE v_saldo_atual INT DEFAULT 0;
    DECLARE v_posologia INT DEFAULT 1;
    DECLARE v_dias INT DEFAULT 1;
    DECLARE v_total_permitido INT;

    -- 1️⃣ Bloqueio sanitário
    IF fn_farmaco_lote_valido(p_id_lote) = FALSE THEN
        INSERT INTO farmaco_auditoria_bloqueio
            (id_farmaco, id_lote, id_cidade, quantidade, id_ffa, usuario, motivo)
        VALUES
            (p_id_farmaco, p_id_lote, p_id_local, p_quantidade, p_id_ffa, p_id_usuario,
             'Tentativa de saída com lote vencido');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lote vencido. Saída bloqueada.';
    END IF;

    -- 2️⃣ Verifica saldo
    SELECT quantidade_atual
      INTO v_saldo_atual
      FROM estoque_local
     WHERE id_farmaco = p_id_farmaco
       AND id_local = p_id_local
     FOR UPDATE;

    IF v_saldo_atual IS NULL OR v_saldo_atual < p_quantidade THEN
        INSERT INTO farmaco_auditoria_bloqueio
            (id_farmaco, id_lote, id_cidade, quantidade, id_ffa, usuario, motivo)
        VALUES
            (p_id_farmaco, p_id_lote, p_id_local, p_quantidade, p_id_ffa, p_id_usuario,
             'Tentativa de saída sem saldo suficiente');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente.';
    END IF;

    -- 3️⃣ Verifica prescrição / posologia
    SELECT posologia, dias
      INTO v_posologia, v_dias
      FROM ffa_medicacao
     WHERE id_ffa = p_id_ffa
       AND id_farmaco = p_id_farmaco;

    SET v_total_permitido = v_posologia * v_dias;

    IF p_quantidade > v_total_permitido THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantidade acima da prescrição permitida.';
    END IF;

    -- 4️⃣ Debita estoque
    UPDATE estoque_local
       SET quantidade_atual = quantidade_atual - p_quantidade
     WHERE id_farmaco = p_id_farmaco
       AND id_local = p_id_local;

    -- 5️⃣ Registra movimentação
    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, id_ffa, realizado_por, id_cliente)
    VALUES
        (p_id_farmaco, p_id_lote, p_id_local, 'SAIDA', p_quantidade,
         'PACIENTE', p_id_ffa, p_id_usuario, p_id_cliente);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_farmaco_set_cota_minima` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmaco_set_cota_minima`(
    IN p_id_farmaco BIGINT,
    IN p_id_cidade BIGINT,
    IN p_cota_minima INT,
    IN p_usuario BIGINT
)
BEGIN
    INSERT INTO farmaco_unidade (id_farmaco, id_cidade, cota_minima, atualizado_por)
    VALUES (p_id_farmaco, p_id_cidade, p_cota_minima, p_usuario)
    ON DUPLICATE KEY UPDATE
        cota_minima = p_cota_minima,
        atualizado_por = p_usuario,
        atualizado_em = NOW();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_faturamento_consolidar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_faturamento_consolidar`(
    IN p_id_conta   BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE faturamento_item
       SET status = 'CONSOLIDADO'
     WHERE status = 'ABERTO'
       AND (
            id_ffa IN (SELECT id_ffa FROM faturamento_conta WHERE id_conta = p_id_conta)
         OR id_internacao IN (SELECT id_internacao FROM faturamento_conta WHERE id_conta = p_id_conta)
       );

    UPDATE faturamento_conta
       SET status = 'EM_REVISAO'
     WHERE id_conta = p_id_conta
       AND status = 'ABERTA';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_faturamento_consolidar_conta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_faturamento_consolidar_conta`(
  IN p_tipo ENUM('FFA','INTERNACAO'),
  IN p_id BIGINT,
  IN p_usuario BIGINT
)
BEGIN
  DECLARE v_id_conta BIGINT;

  INSERT INTO faturamento_conta (tipo_conta, id_ffa, id_internacao)
  VALUES (
    p_tipo,
    IF(p_tipo = 'FFA', p_id, NULL),
    IF(p_tipo = 'INTERNACAO', p_id, NULL)
  );

  SET v_id_conta = LAST_INSERT_ID();

  INSERT INTO faturamento_conta_item (id_conta, id_item)
  SELECT v_id_conta, id_item
  FROM faturamento_item
  WHERE status = 'ABERTO'
    AND (
      (p_tipo = 'FFA' AND id_ffa = p_id)
      OR
      (p_tipo = 'INTERNACAO' AND id_internacao = p_id)
    );

  UPDATE faturamento_item
  SET status = 'CONSOLIDADO'
  WHERE id_item IN (
    SELECT id_item FROM faturamento_conta_item
    WHERE id_conta = v_id_conta
  );

  UPDATE faturamento_conta
  SET valor_total = (
    SELECT SUM(valor_total)
    FROM faturamento_item fi
    JOIN faturamento_conta_item fci ON fci.id_item = fi.id_item
    WHERE fci.id_conta = v_id_conta
  );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_faturamento_fechar_conta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_faturamento_fechar_conta`(
    IN p_id_conta   BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    IF EXISTS (
        SELECT 1
          FROM faturamento_item
         WHERE status = 'ABERTO'
           AND (
                id_ffa IN (SELECT id_ffa FROM faturamento_conta WHERE id_conta = p_id_conta)
             OR id_internacao IN (SELECT id_internacao FROM faturamento_conta WHERE id_conta = p_id_conta)
           )
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Existem itens de faturamento ainda abertos';
    END IF;

    UPDATE faturamento_conta
       SET status      = 'FECHADA',
           fechada_em  = NOW(),
           fechado_por = p_id_usuario
     WHERE id_conta = p_id_conta;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_faturamento_gerar_item` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_faturamento_gerar_item`(
    IN p_origem          ENUM('PROCEDIMENTO','EXAME','MEDICACAO','MATERIAL','TAXA','OUTRO'),
    IN p_id_origem       BIGINT,
    IN p_descricao       VARCHAR(255),
    IN p_quantidade      DECIMAL(10,2),
    IN p_valor_unitario  DECIMAL(10,2),
    IN p_id_ffa          BIGINT,
    IN p_id_internacao   BIGINT,
    IN p_id_usuario      BIGINT
)
BEGIN
    DECLARE v_id_conta BIGINT;
    DECLARE v_valor_total DECIMAL(10,2);

    SET v_valor_total = p_quantidade * p_valor_unitario;

    CALL sp_faturamento_obter_conta(
        IF(p_id_internacao IS NULL, 'FFA', 'INTERNACAO'),
        p_id_ffa,
        p_id_internacao,
        p_id_usuario,
        v_id_conta
    );

    INSERT INTO faturamento_item (
        origem,
        id_origem,
        descricao,
        quantidade,
        valor_unitario,
        valor_total,
        id_ffa,
        id_internacao,
        criado_por,
        status
    ) VALUES (
        p_origem,
        p_id_origem,
        p_descricao,
        p_quantidade,
        p_valor_unitario,
        v_valor_total,
        p_id_ffa,
        p_id_internacao,
        p_id_usuario,
        'ABERTO'
    );

    UPDATE faturamento_conta
       SET valor_total = valor_total + v_valor_total
     WHERE id_conta = v_id_conta;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_faturamento_obter_conta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_faturamento_obter_conta`(
    IN  p_tipo_conta     ENUM('FFA','INTERNACAO'),
    IN  p_id_ffa         BIGINT,
    IN  p_id_internacao  BIGINT,
    IN  p_id_usuario     BIGINT,
    OUT p_id_conta       BIGINT
)
BEGIN
    SELECT id_conta
      INTO p_id_conta
      FROM faturamento_conta
     WHERE status = 'ABERTA'
       AND (
            (p_tipo_conta = 'FFA'        AND id_ffa        = p_id_ffa)
         OR (p_tipo_conta = 'INTERNACAO' AND id_internacao = p_id_internacao)
       )
     LIMIT 1;

    IF p_id_conta IS NULL THEN
        INSERT INTO faturamento_conta (
            tipo_conta,
            id_ffa,
            id_internacao,
            status,
            valor_total,
            aberta_em,
            fechado_por
        ) VALUES (
            p_tipo_conta,
            p_id_ffa,
            p_id_internacao,
            'ABERTA',
            0,
            NOW(),
            p_id_usuario
        );

        SET p_id_conta = LAST_INSERT_ID();
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_faturamento_registrar_item` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_faturamento_registrar_item`(
  IN p_origem ENUM(
      'PROCEDIMENTO','EXAME','MEDICACAO','MATERIAL','TAXA','OUTRO'
  ),
  IN p_id_origem BIGINT,
  IN p_descricao VARCHAR(255),
  IN p_quantidade DECIMAL(10,2),
  IN p_valor_unitario DECIMAL(10,2),
  IN p_id_ffa BIGINT,
  IN p_id_internacao BIGINT,
  IN p_usuario BIGINT
)
BEGIN
  INSERT INTO faturamento_item (
    origem, id_origem, descricao,
    quantidade, valor_unitario, valor_total,
    id_ffa, id_internacao, criado_por
  ) VALUES (
    p_origem, p_id_origem, p_descricao,
    p_quantidade, p_valor_unitario,
    p_quantidade * p_valor_unitario,
    p_id_ffa, p_id_internacao, p_usuario
  );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fechamento_ffa_completo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fechamento_ffa_completo`(
    IN p_horas_limite INT
)
BEGIN
    -- 1️⃣ Declara todas as variáveis e cursores primeiro
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_retorno_ativo INT;
    DECLARE v_paciente_internado INT;

    DECLARE cur CURSOR FOR
        SELECT id_ffa, status, retorno_ativo
          FROM ffa
         WHERE status IN ('ABERTO','EM_ATENDIMENTO','EM_ATENDIMENTO_RETORNO')
           AND TIMESTAMPDIFF(HOUR, atualizado_em, NOW()) >= p_horas_limite;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- 2️⃣ Define 24h como padrão se parâmetro não informado
    IF p_horas_limite IS NULL OR p_horas_limite = 0 THEN
        SET p_horas_limite = 24;
    END IF;

    -- 3️⃣ Abre cursor
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id_ffa, v_status_atual, v_retorno_ativo;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Ignora FFA já encerradas ou canceladas
        IF v_status_atual IN ('ENCERRADO','CANCELADO','ENCERRADO_AUTOMATICO') THEN
            ITERATE read_loop;
        END IF;

        -- Checa se paciente está internado
        SELECT COUNT(*)
          INTO v_paciente_internado
          FROM internacao
         WHERE id_paciente = (SELECT id_paciente FROM ffa WHERE id_ffa = v_id_ffa)
           AND status IN ('ATIVO','EM_ANDAMENTO');

        -- Se não houver retorno ativo ou paciente não internado, encerra automaticamente
        IF v_retorno_ativo = 0 OR v_paciente_internado = 0 THEN
            UPDATE ffa
               SET status = 'ENCERRADO_AUTOMATICO',
                   atualizado_em = NOW()
             WHERE id_ffa = v_id_ffa;

            -- Auditoria do fechamento
            INSERT INTO eventos_fluxo (
                id_ffa, evento, contexto, id_usuario, observacao, criado_em
            ) VALUES (
                v_id_ffa, 'FECHAMENTO_AUTOMATICO', 'SISTEMA', NULL,
                CONCAT('Fechamento automático após ', p_horas_limite, 'h sem movimentação. Status anterior: ', v_status_atual),
                NOW()
            );

            -- Chama SP complementar para criar observações e alertas
            CALL sp_ffa_complementar_alertas_permissao(v_id_ffa, NULL, 'OBSERVACAO');
            CALL sp_ffa_complementar_alertas_permissao(v_id_ffa, NULL, 'TTS');
        END IF;

    END LOOP;

    CLOSE cur;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fechamento_ffa_ultimate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fechamento_ffa_ultimate`(
    IN p_horas_limite INT
)
BEGIN
    -- Variáveis do cursor
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_retorno_ativo INT;
    DECLARE v_paciente_internado INT;

    -- Cursor para todas as FFA abertas ou em atendimento que ultrapassaram o tempo limite
    DECLARE cur CURSOR FOR
        SELECT id_ffa, status, retorno_ativo
          FROM ffa
         WHERE status IN ('ABERTO','EM_ATENDIMENTO','EM_ATENDIMENTO_RETORNO')
           AND TIMESTAMPDIFF(HOUR, atualizado_em, NOW()) >= IFNULL(p_horas_limite,24);

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Define valor padrão de 24h
    IF p_horas_limite IS NULL OR p_horas_limite = 0 THEN
        SET p_horas_limite = 24;
    END IF;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id_ffa, v_status_atual, v_retorno_ativo;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Ignora FFA já encerradas ou canceladas
        IF v_status_atual IN ('ENCERRADO','CANCELADO','ENCERRADO_AUTOMATICO') THEN
            ITERATE read_loop;
        END IF;

        -- Checa se paciente está internado
        SELECT COUNT(*) 
          INTO v_paciente_internado
          FROM internacao
         WHERE id_paciente = (SELECT id_paciente FROM ffa WHERE id_ffa = v_id_ffa)
           AND status IN ('ATIVO','EM_ANDAMENTO');

        -- Verifica pendências críticas: medicação, exames, cuidados
        -- Cria fila de observação e alerta no painel
        INSERT INTO fila_observacao (
            id_ffa,
            tipo_evento,
            local_destino,
            criado_em,
            status
        )
        SELECT
            v_id_ffa,
            tipo_pendencia,
            local_destino,
            NOW(),
            'PENDENTE'
          FROM ffa_pendencias
         WHERE id_ffa = v_id_ffa
           AND status_pendencia IN ('PENDENTE','ATRASADO');

        UPDATE ffa_pendencias
           SET alerta_painel = 1
         WHERE id_ffa = v_id_ffa
           AND status_pendencia IN ('PENDENTE','ATRASADO');

        -- Se não houver retorno ativo ou paciente não internado, encerra automaticamente
        IF v_retorno_ativo = 0 OR v_paciente_internado = 0 THEN
            UPDATE ffa
               SET status = 'ENCERRADO_AUTOMATICO',
                   atualizado_em = NOW()
             WHERE id_ffa = v_id_ffa;

            -- Auditoria do fechamento
            INSERT INTO eventos_fluxo (
                id_ffa,
                evento,
                contexto,
                id_usuario,
                observacao,
                criado_em
            ) VALUES (
                v_id_ffa,
                'FECHAMENTO_AUTOMATICO',
                'SISTEMA',
                NULL,
                CONCAT('Fechamento automático após ', p_horas_limite, 'h sem movimentação. Status anterior: ', v_status_atual),
                NOW()
            );
        END IF;

        -- Gatilho de TTS e alertas do painel para pendências
        -- Se houver função/procedure TTS, chama aqui passando id_ffa e tipo de evento
        -- Exemplo: CALL sp_tts_alerta_painel(v_id_ffa);

        -- Atualiza medicações/exames atrasados automaticamente
        UPDATE ffa_pendencias
           SET status_pendencia = 'ATRASADO'
         WHERE id_ffa = v_id_ffa
           AND status_pendencia = 'PENDENTE'
           AND tipo_pendencia IN ('MEDICACAO','EXAME','CUIDADO');

    END LOOP;

    CLOSE cur;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fechar_conta_ffa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fechar_conta_ffa`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    /* Marca itens como consolidados */
    UPDATE faturamento_item
       SET status = 'CONSOLIDADO'
     WHERE id_ffa = p_id_ffa
       AND (status IS NULL OR status <> 'CONSOLIDADO');

    /* Registra evento administrativo */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FECHAMENTO_FATURAMENTO',
        'ADMINISTRATIVO',
        p_id_usuario,
        NOW()
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fechar_ffa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fechar_ffa`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_tipo_fechamento ENUM('FECHAMENTO_NORMAL','ENCERRADO_AUTOMATICO','FECHAMENTO_CANCELADO'),
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_permite_reabrir BOOLEAN DEFAULT FALSE;
    DECLARE v_id_paciente BIGINT;

    -- 1️⃣ Bloqueia a FFA para atualização
    SELECT status, id_paciente
      INTO v_status_atual, v_id_paciente
      FROM ffa
     WHERE id_ffa = p_id_ffa
     FOR UPDATE;

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FFA inexistente';
    END IF;

    -- 2️⃣ Valida permissões
    IF p_tipo_fechamento = 'FECHAMENTO_CANCELADO' THEN
        -- Cancelamento só pode TI / usuário master
        IF NOT EXISTS (
            SELECT 1
              FROM usuario
             WHERE id_usuario = p_id_usuario
               AND perfil = 'MASTER'
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Usuário sem permissão para cancelar FFA';
        END IF;
    ELSE
        -- Fechamento normal ou automático: médico, recepção, triagem, enfermagem, técnicos
        IF NOT EXISTS (
            SELECT 1
              FROM usuario
             WHERE id_usuario = p_id_usuario
               AND perfil IN ('MEDICO','RECEPCAO','TRIAGEM','ENFERMAGEM','TECNICO')
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Usuário sem permissão para fechar FFA';
        END IF;
    END IF;

    -- 3️⃣ Determina status final
    CASE p_tipo_fechamento
        WHEN 'FECHAMENTO_NORMAL' THEN
            SET v_status_atual = 'ENCERRADO';
            SET v_permite_reabrir = TRUE;
        WHEN 'ENCERRADO_AUTOMATICO' THEN
            SET v_status_atual = 'ENCERRADO';
            SET v_permite_reabrir = TRUE;
        WHEN 'FECHAMENTO_CANCELADO' THEN
            SET v_status_atual = 'CANCELADO';
            SET v_permite_reabrir = FALSE;
    END CASE;

    -- 4️⃣ Atualiza FFA
    UPDATE ffa
       SET status = v_status_atual,
           atualizado_em = NOW()
     WHERE id_ffa = p_id_ffa;

    -- 5️⃣ Registra evento no histórico
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        CONCAT('FECHAMENTO: ', p_tipo_fechamento),
        'SISTEMA',
        p_id_usuario,
        p_motivo,
        NOW()
    );

    -- 6️⃣ Auditoria de exames/medicação pendentes
    INSERT INTO ffa_auditoria_pendencias (
        id_ffa,
        id_paciente,
        tipo_pendencia,
        criado_em
    )
    SELECT p_id_ffa, v_id_paciente, 'EXAMES/MEDICACAO', NOW()
      FROM ffa_medicacao fm
     WHERE fm.id_ffa = p_id_ffa
       AND (fm.status IS NULL OR fm.status <> 'MINISTRADO');

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fechar_ffa_automatico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fechar_ffa_automatico`()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_retorno_ativo TINYINT;
    DECLARE v_pendencias TINYINT;

    DECLARE cur CURSOR FOR 
        SELECT id_ffa, status, retorno_ativo
          FROM ffa
         WHERE status IN ('ABERTO', 'EM_ATENDIMENTO', 'EM_ATENDIMENTO_RETORNO')
           AND TIMESTAMPDIFF(HOUR, atualizado_em, NOW()) >= 24;
           
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id_ffa, v_status_atual, v_retorno_ativo;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- 1️⃣ Verifica pendências de medicação ou exames
        SELECT COUNT(*)
          INTO v_pendencias
          FROM ffa_itens
         WHERE id_ffa = v_id_ffa
           AND status IN ('PENDENTE', 'AGUARDANDO_MINISTRACAO');

        -- 2️⃣ Atualiza status da FFA
        UPDATE ffa
           SET status = CASE
                            WHEN v_retorno_ativo = 1 THEN 'EM_ATENDIMENTO_RETORNO'
                            WHEN v_pendencias > 0 THEN 'ABERTO_COM_PENDENCIAS'
                            ELSE 'ENCERRADO_AUTOMATICO'
                        END,
               atualizado_em = NOW()
         WHERE id_ffa = v_id_ffa;

        -- 3️⃣ Insere evento de auditoria
        INSERT INTO eventos_fluxo
            (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
        VALUES
            (v_id_ffa,
             CASE
                WHEN v_retorno_ativo = 1 THEN 'RETORNO_PENDENTE_24H'
                WHEN v_pendencias > 0 THEN 'FECHAMENTO_COM_PENDENCIAS'
                ELSE 'FECHAMENTO_AUTOMATICO'
             END,
             'SISTEMA',
             NULL,
             CONCAT('Fechamento automático após 24h. Pendências: ', v_pendencias, 
                    '. Retorno ativo: ', v_retorno_ativo),
             NOW());

        -- 4️⃣ Se houver pendências de medicação/exame, colocar na fila de observação/painel
        IF v_pendencias > 0 THEN
            INSERT INTO fila_observacao
                (id_ffa, tipo, status, criado_em)
            VALUES
                (v_id_ffa, 'MEDICACAO_EXAME_PENDENTE', 'PENDENTE', NOW());
        END IF;

    END LOOP;

    CLOSE cur;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fecha_ffa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fecha_ffa`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_id_senha BIGINT;

    /* ===============================
       1️⃣ Valida FFA existente
       =============================== */
    SELECT status, id_senha
      INTO v_status_atual, v_id_senha
      FROM ffa
     WHERE id_ffa = p_id_ffa
     FOR UPDATE;

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'FFA inexistente';
    END IF;

    IF v_status_atual = 'FINALIZADO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA já está finalizada';
    END IF;

    /* ===============================
       2️⃣ Fecha todos os itens em andamento
       =============================== */
    -- Itens de faturamento
    CALL sp_fechar_conta_ffa(p_id_ffa, p_id_usuario);

    -- Libera estados de execução em aberto (exames, procedimentos)
    CALL sp_liberar_estado_pos_execucao(p_id_ffa);

    /* ===============================
       3️⃣ Atualiza status da FFA
       =============================== */
    UPDATE ffa
       SET status = 'FINALIZADO',
           atualizado_em = NOW()
     WHERE id_ffa = p_id_ffa;

    /* ===============================
       4️⃣ Registra evento de fechamento
       =============================== */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FECHAMENTO_FFA',
        'SISTEMA',
        p_id_usuario,
        IFNULL(p_motivo, 'Fechamento automático'),
        NOW()
    );

    /* ===============================
       5️⃣ Atualiza status da senha associada
       =============================== */
    UPDATE senhas
       SET status = 'FINALIZADA'
     WHERE id = v_id_senha;

    /* ===============================
       6️⃣ Atualiza fila de senha (painel / guichê)
       =============================== */
    UPDATE fila_senha
       SET status = 'FINALIZADA'
     WHERE id_senha = v_id_senha;

    /* ===============================
       7️⃣ Auditoria final
       =============================== */
    INSERT INTO auditoria_ffa (
        id_ffa,
        id_usuario,
        acao,
        motivo,
        criado_em
    ) VALUES (
        p_id_ffa,
        p_id_usuario,
        'FECHAMENTO_FFA',
        IFNULL(p_motivo, 'Fechamento automático'),
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_ffa_complementar_alertas_permissao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_complementar_alertas_permissao`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_acao VARCHAR(50) -- 'REABRIR', 'CANCELAR', 'OBSERVACAO', 'TTS'
)
BEGIN
    -- 1️⃣ Declara variáveis obrigatórias
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_permissao INT DEFAULT 0;
    DECLARE v_tem_pendencia INT;

    -- 2️⃣ Pega status atual da FFA
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id_ffa = p_id_ffa
     FOR UPDATE;

    -- 3️⃣ Valida permissões de acordo com ação
    IF p_acao = 'REABRIR' THEN
        IF v_status_atual = 'CANCELADO' THEN
            -- Só TI pode reabrir FFA cancelada
            SELECT CASE WHEN EXISTS (
                SELECT 1 
                  FROM usuario_sistema 
                 WHERE id_usuario = p_id_usuario 
                   AND sistema = 'TI'
            ) THEN 1 ELSE 0 END
            INTO v_permissao;
            IF v_permissao = 0 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Somente TI pode reabrir FFA cancelada';
            END IF;
        ELSE
            -- Médicos, enfermeiros, recepção, TI podem reabrir FFA normal
            SELECT CASE WHEN EXISTS (
                SELECT 1 
                  FROM usuario_sistema 
                 WHERE id_usuario = p_id_usuario 
                   AND sistema IN ('MEDICO','ENFERMAGEM','RECEPCAO','TI')
            ) THEN 1 ELSE 0 END
            INTO v_permissao;
            IF v_permissao = 0 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Usuário não tem permissão para reabrir esta FFA';
            END IF;
        END IF;

        -- Atualiza status e auditoria
        UPDATE ffa
           SET status = 'EM_ATENDIMENTO',
               atualizado_em = NOW()
         WHERE id_ffa = p_id_ffa;

        INSERT INTO eventos_fluxo (
            id_ffa, evento, contexto, id_usuario, observacao, criado_em
        ) VALUES (
            p_id_ffa, 'REABERTURA_MANUAL', 'SISTEMA', p_id_usuario, 
            'Reabertura via SP complementar', NOW()
        );
    END IF;

    -- 4️⃣ Cancelamento
    IF p_acao = 'CANCELAR' THEN
        -- Só TI pode cancelar
        SELECT CASE WHEN EXISTS (
            SELECT 1 
              FROM usuario_sistema 
             WHERE id_usuario = p_id_usuario 
               AND sistema = 'TI'
        ) THEN 1 ELSE 0 END
        INTO v_permissao;
        IF v_permissao = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Somente TI pode cancelar FFA';
        END IF;

        -- Atualiza status e auditoria
        UPDATE ffa
           SET status = 'CANCELADO',
               atualizado_em = NOW()
         WHERE id_ffa = p_id_ffa;

        INSERT INTO eventos_fluxo (
            id_ffa, evento, contexto, id_usuario, observacao, criado_em
        ) VALUES (
            p_id_ffa, 'CANCELAMENTO_MANUAL', 'SISTEMA', p_id_usuario, 
            'Cancelamento da FFA pelo TI', NOW()
        );
    END IF;

    -- 5️⃣ Observação / Pendências
    IF p_acao = 'OBSERVACAO' THEN
        -- Cria/atualiza observações para todas as pendências abertas ou atrasadas
        INSERT INTO fila_observacao (id_ffa, tipo_evento, local_destino, criado_em, status)
        SELECT v.id_ffa, v.tipo_pendencia, v.local_destino, NOW(), 'PENDENTE'
          FROM ffa_pendencias v
         WHERE v.id_ffa = p_id_ffa
           AND v.status_pendencia IN ('PENDENTE','ATRASADO')
        ON DUPLICATE KEY UPDATE criado_em = NOW(), status = 'PENDENTE';

        -- Marca alerta visual no painel (bolinha preta)
        UPDATE ffa_pendencias
           SET alerta_painel = 1
         WHERE id_ffa = p_id_ffa
           AND status_pendencia IN ('PENDENTE','ATRASADO');

        INSERT INTO eventos_fluxo (
            id_ffa, evento, contexto, id_usuario, observacao, criado_em
        ) VALUES (
            p_id_ffa, 'OBSERVACAO_ADICIONADA', 'SISTEMA', p_id_usuario,
            'Observação/pendência adicionada na FFA', NOW()
        );
    END IF;

    -- 6️⃣ TTS / alerta do painel
    IF p_acao = 'TTS' THEN
        SELECT COUNT(*) 
          INTO v_tem_pendencia
          FROM ffa_pendencias
         WHERE id_ffa = p_id_ffa
           AND status_pendencia IN ('PENDENTE','ATRASADO');

        IF v_tem_pendencia > 0 THEN
            INSERT INTO eventos_fluxo (
                id_ffa, evento, contexto, id_usuario, observacao, criado_em
            ) VALUES (
                p_id_ffa, 'TTS_ALERTA', 'PAINEL', p_id_usuario,
                CONCAT('Alerta de pendências TTS para FFA ', p_id_ffa), NOW()
            );
        END IF;

        -- Aqui pode ser integrado com TTS externo (Google TTS ou outro) via backend
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_atendimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_atendimento`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM internacao
        WHERE id_ffa = p_id_ffa
          AND status = 'ATIVA'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Internação ativa. Use alta de internação.';
    END IF;

    UPDATE ffa
       SET status = 'FINALIZADO',
           encerrado_em = NOW()
     WHERE id = p_id_ffa;

    INSERT INTO auditoria_ffa
        (id_ffa, evento, data_evento, id_usuario)
    VALUES
        (p_id_ffa, 'FINALIZACAO', NOW(), p_id_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_atendimento_medico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_atendimento_medico`(
    IN p_id_ffa BIGINT,
    IN p_destino VARCHAR(30), -- ALTA | OBSERVACAO | MEDICACAO | RX | INTERNACAO | RETORNO
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    -- Valida estado atual
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id = p_id_ffa
     FOR UPDATE;

    IF v_status_atual <> 'EM_ATENDIMENTO_MEDICO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não está em atendimento médico';
    END IF;

    -- Atualiza FFA conforme destino
    UPDATE ffa
       SET status = 
           CASE p_destino
               WHEN 'ALTA'        THEN 'ALTA'
               WHEN 'OBSERVACAO'  THEN 'OBSERVACAO'
               WHEN 'MEDICACAO'   THEN 'AGUARDANDO_MEDICACAO'
               WHEN 'RX'          THEN 'AGUARDANDO_RX'
               WHEN 'INTERNACAO'  THEN 'INTERNACAO'
               WHEN 'RETORNO'     THEN 'AGUARDANDO_RETORNO'
               ELSE status
           END,
           layout =
           CASE p_destino
               WHEN 'ALTA'        THEN 'FINAL'
               WHEN 'OBSERVACAO'  THEN 'OBSERVACAO'
               WHEN 'MEDICACAO'   THEN 'PROCEDIMENTOS'
               WHEN 'RX'          THEN 'PROCEDIMENTOS'
               WHEN 'INTERNACAO'  THEN 'INTERNACAO'
               WHEN 'RETORNO'     THEN 'RETORNO'
               ELSE layout
           END,
           atendimento_medico_fim = NOW(),
           id_usuario_alteracao = p_id_usuario
     WHERE id = p_id_ffa;

    -- Observação clínica (opcional)
    IF p_observacao IS NOT NULL AND LENGTH(TRIM(p_observacao)) > 0 THEN
        INSERT INTO observacoes_eventos (
            entidade,
            id_entidade,
            tipo,
            contexto,
            texto,
            id_usuario,
            criado_em
        ) VALUES (
            'FFA',
            p_id_ffa,
            'CLINICA',
            'ENCERRAMENTO_ATENDIMENTO_MEDICO',
            p_observacao,
            p_id_usuario,
            NOW()
        );
    END IF;

    -- Evento de fluxo
    INSERT INTO eventos_ffa (
        id_ffa,
        tipo_evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FIM_ATENDIMENTO_MEDICO',
        CONCAT('Destino definido: ', p_destino),
        p_id_usuario,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_ecg` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_ecg`(
    IN p_id_ffa BIGINT,
    IN p_critico TINYINT(1),
    IN p_resultado TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_finalizar_exame_generico(p_id_ffa, 'ECG', p_critico, p_resultado, p_id_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_exame_generico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_exame_generico`(
    IN p_id_ffa BIGINT,
    IN p_tipo VARCHAR(10),
    IN p_critico TINYINT(1),
    IN p_resultado TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa_procedimento
       SET status = 'FINALIZADO',
           finalizado_em = NOW(),
           resultado = p_resultado
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = p_tipo
       AND status = 'EM_EXECUCAO'
     ORDER BY iniciado_em DESC
     LIMIT 1;

    UPDATE fila_operacional
       SET status = 'FINALIZADO'
     WHERE id_ffa = p_id_ffa
       AND contexto = p_tipo;

    INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
    VALUES (
        p_id_ffa,
        IF(p_critico = 1,
           CONCAT('RETORNO_', p_tipo, '_CRITICO'),
           CONCAT('RETORNO_', p_tipo, '_NORMAL')),
        NOW()
    );

    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
    VALUES
        (p_id_ffa, 'FINALIZACAO', p_tipo, p_id_usuario, p_resultado, NOW());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_execucao_assistencial` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_execucao_assistencial`(
    IN p_id_ffa BIGINT,
    IN p_tipo ENUM('MEDICACAO','OBSERVACAO'),
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_substatus VARCHAR(50);
    DECLARE v_now DATETIME DEFAULT NOW();

    IF p_tipo = 'MEDICACAO' THEN
        SET v_substatus = 'MEDICACAO_FINALIZADA';
    ELSE
        SET v_substatus = 'OBSERVACAO_CONCLUIDA';
    END IF;

    UPDATE ffa_substatus
       SET status = v_substatus,
           data_fim = v_now,
           ativo = 0
     WHERE id_ffa = p_id_ffa
       AND ativo = 1;

    INSERT INTO evento_ffa (id_ffa, evento, data_evento, id_usuario)
    VALUES (
        p_id_ffa,
        CONCAT('FIM_', v_substatus),
        v_now,
        p_id_usuario
    );

    -- Retorna automaticamente ao médico
    UPDATE ffa
       SET status = 'AGUARDANDO_MEDICO'
     WHERE id = p_id_ffa;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_internacao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_internacao`(
    IN p_id_internacao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_comentario TEXT
)
BEGIN
    DECLARE v_status_atual ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA');

    SELECT status INTO v_status_atual FROM internacao WHERE id_internacao = p_id_internacao;

    UPDATE internacao
    SET status = 'ENCERRADA',
        data_saida = NOW(),
        atualizado_em = NOW()
    WHERE id_internacao = p_id_internacao;

    -- Insere histórico
    INSERT INTO internacao_historico (id_internacao, status_anterior, status_novo, id_usuario, comentario)
    VALUES (p_id_internacao, v_status_atual, 'ENCERRADA', p_id_usuario, p_comentario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_lab` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_lab`(
    IN p_id_ffa BIGINT,
    IN p_critico TINYINT(1),
    IN p_resultado TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_finalizar_exame_generico(p_id_ffa, 'LAB', p_critico, p_resultado, p_id_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_procedimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento`(
    IN p_id_procedimento BIGINT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    SELECT id_ffa INTO v_id_ffa
      FROM ffa_procedimento
     WHERE id_procedimento = p_id_procedimento;

    UPDATE ffa_procedimento
       SET status = 'CONCLUIDO',
           finalizado_em = NOW()
     WHERE id_procedimento = p_id_procedimento;

    UPDATE ffa
       SET status = 'AGUARDANDO_RETORNO'
     WHERE id = v_id_ffa;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_procedimento_ecg` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_ecg`(
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT,
    IN p_critico       TINYINT(1),
    IN p_observacao    TEXT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* Busca ECG em execucao */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'ECG'
       AND status = 'EM_EXECUCAO'
     ORDER BY iniciado_em DESC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum ECG em execucao para finalizar';
    END IF;

    /* Finaliza ECG */
    UPDATE ffa_procedimento
       SET status = 'FINALIZADO',
           finalizado_em = NOW(),
           resultado = p_observacao
     WHERE id_procedimento = v_id_proc;

    /* Remove da fila ECG */
    UPDATE fila_operacional
       SET status = 'FINALIZADO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'ECG';

    /* Retorno ao fluxo */
    IF p_critico = 1 THEN

        CALL sp_retorno_procedimento_critico(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_ECG_CRITICO', NOW());

    ELSE

        CALL sp_retorno_procedimento_normal(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_ECG_NORMAL', NOW());

    END IF;

    /* Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FINALIZACAO_ECG',
        'ECG',
        p_id_usuario,
        p_observacao,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_procedimento_geral` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_geral`(
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT,
    IN p_critico       TINYINT(1),
    IN p_observacao    TEXT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* 1. Busca procedimento geral em execucao */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'GERAL'
       AND status = 'EM_EXECUCAO'
     ORDER BY iniciado_em DESC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum procedimento geral em execucao';
    END IF;

    /* 2. Finaliza procedimento */
    UPDATE ffa_procedimento
       SET status = 'FINALIZADO',
           finalizado_em = NOW(),
           resultado = p_observacao
     WHERE id_procedimento = v_id_proc;

    /* 3. Remove da fila */
    UPDATE fila_operacional
       SET status = 'FINALIZADO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'GERAL';

    /* 4. Retorno */
    IF p_critico = 1 THEN

        CALL sp_retorno_procedimento_critico(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_GERAL_CRITICO', NOW());

    ELSE

        CALL sp_retorno_procedimento_normal(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_GERAL_NORMAL', NOW());

    END IF;

    /* 5. Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FINALIZACAO_GERAL',
        'GERAL',
        p_id_usuario,
        p_observacao,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_procedimento_laboratorio` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_laboratorio`(
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT,
    IN p_critico       TINYINT(1),
    IN p_resultado     TEXT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* 1. Busca LAB em execucao */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'LAB'
       AND status = 'EM_EXECUCAO'
     ORDER BY iniciado_em DESC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum exame de laboratorio em execucao';
    END IF;

    /* 2. Finaliza LAB */
    UPDATE ffa_procedimento
       SET status = 'FINALIZADO',
           finalizado_em = NOW(),
           resultado = p_resultado
     WHERE id_procedimento = v_id_proc;

    /* 3. Remove da fila LAB */
    UPDATE fila_operacional
       SET status = 'FINALIZADO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'LAB';

    /* 4. Retorno ao fluxo */
    IF p_critico = 1 THEN

        CALL sp_retorno_procedimento_critico(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_LAB_CRITICO', NOW());

    ELSE

        CALL sp_retorno_procedimento_normal(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_LAB_NORMAL', NOW());

    END IF;

    /* 5. Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FINALIZACAO_LAB',
        'LAB',
        p_id_usuario,
        p_resultado,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_procedimento_rx` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_rx`(
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT,
    IN p_critico       TINYINT(1),
    IN p_observacao    TEXT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* Busca RX em execucao */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'RX'
       AND status = 'EM_EXECUCAO'
     ORDER BY iniciado_em DESC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum RX em execucao para finalizar';
    END IF;

    /* Finaliza RX */
    UPDATE ffa_procedimento
       SET status = 'FINALIZADO',
           finalizado_em = NOW(),
           resultado = p_observacao
     WHERE id_procedimento = v_id_proc;

    /* Remove da fila RX */
    UPDATE fila_operacional
       SET status = 'FINALIZADO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'RX';

    /* Retorno */
    IF p_critico = 1 THEN

        CALL sp_retorno_procedimento_critico(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_RX_CRITICO', NOW());

    ELSE

        CALL sp_retorno_procedimento_normal(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_RX_NORMAL', NOW());

    END IF;

    /* Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FINALIZACAO_RX',
        'RX',
        p_id_usuario,
        p_observacao,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_triagem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_triagem`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    SELECT status
    INTO v_status_atual
    FROM ffa
    WHERE id = p_id_ffa;

    IF v_status_atual <> 'EM_TRIAGEM' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FFA não está em triagem';
    END IF;

    UPDATE ffa
    SET status = 'AGUARDANDO_CHAMADA_MEDICO',
        fim_triagem_em = NOW()
    WHERE id = p_id_ffa;

    INSERT INTO auditoria_eventos (
        entidade,
        id_entidade,
        evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        'FFA',
        p_id_ffa,
        'FIM_TRIAGEM',
        'Triagem finalizada',
        p_id_usuario,
        NOW()
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_finalizar_usg` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_usg`(
    IN p_id_ffa BIGINT,
    IN p_critico TINYINT(1),
    IN p_resultado TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_finalizar_exame_generico(p_id_ffa, 'USG', p_critico, p_resultado, p_id_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gerar_itens_faturamento_ffa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gerar_itens_faturamento_ffa`(
    IN p_id_ffa BIGINT
)
BEGIN
    /* Procedimentos executados */
    INSERT INTO faturamento_item (
        id_ffa,
        origem,
        id_origem,
        descricao,
        quantidade,
        criado_em
    )
    SELECT
        p_id_ffa,
        'PROCEDIMENTO',
        fp.id_procedimento,
        fp.tipo_procedimento,
        1,
        NOW()
    FROM ffa_procedimento fp
    WHERE fp.id_ffa = p_id_ffa
      AND fp.status = 'FINALIZADO'
      AND NOT EXISTS (
          SELECT 1
          FROM faturamento_item fi
          WHERE fi.origem = 'PROCEDIMENTO'
            AND fi.id_origem = fp.id_procedimento
      );

    /* Medicações administradas */
    INSERT INTO faturamento_item (
        id_ffa,
        origem,
        id_origem,
        descricao,
        quantidade,
        criado_em
    )
    SELECT
        p_id_ffa,
        'MEDICACAO',
        ma.id_administracao,
        ma.medicamento,
        ma.quantidade,
        NOW()
    FROM ffa_medicacao_administrada ma
    WHERE ma.id_ffa = p_id_ffa
      AND ma.status = 'ADMINISTRADA'
      AND NOT EXISTS (
          SELECT 1
          FROM faturamento_item fi
          WHERE fi.origem = 'MEDICACAO'
            AND fi.id_origem = ma.id_administracao
      );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gerar_senha` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gerar_senha`(
    IN p_origem ENUM('TOTEM','RECEPCAO','ADMIN'),
    IN p_tipo_atendimento ENUM('CLINICO','PEDIATRICO','PRIORITARIO','EMERGENCIA','VISITA','EXAME'),
    IN p_prioridade TINYINT,
    IN p_id_paciente BIGINT,      -- pode ser NULL (totem sem cadastro)
    IN p_id_usuario BIGINT         -- NULL se totem
)
BEGIN
    DECLARE v_numero INT;
    DECLARE v_prefixo VARCHAR(5);
    DECLARE v_id_senha BIGINT;

    -- Prefixo por tipo
    SET v_prefixo = CASE p_tipo_atendimento
        WHEN 'CLINICO' THEN 'C'
        WHEN 'PEDIATRICO' THEN 'P'
        WHEN 'PRIORITARIO' THEN 'PR'
        WHEN 'EMERGENCIA' THEN 'E'
        WHEN 'EXAME' THEN 'X'
        ELSE 'G'
    END;

    -- Próximo número da senha (por tipo/dia)
    SELECT COALESCE(MAX(numero),0) + 1
      INTO v_numero
      FROM senhas
     WHERE DATE(criada_em) = CURDATE()
       AND tipo_atendimento = p_tipo_atendimento;

    -- Cria a senha
    INSERT INTO senhas (
        numero,
        prefixo,
        tipo_atendimento,
        status,
        origem,
        prioridade,
        criada_em
    ) VALUES (
        v_numero,
        v_prefixo,
        p_tipo_atendimento,
        'GERADA',
        p_origem,
        p_prioridade,
        NOW()
    );

    SET v_id_senha = LAST_INSERT_ID();

    -- Coloca na fila
    INSERT INTO fila_senha (
        senha,
        id_paciente,
        prioridade_recepcao,
        criado_em
    ) VALUES (
        v_id_senha,
        p_id_paciente,
        CASE
            WHEN p_prioridade = 1 THEN 'IDOSO'
            ELSE 'PADRAO'
        END,
        NOW()
    );

    -- Atualiza status para EM_FILA
    UPDATE senhas
       SET status = 'EM_FILA'
     WHERE id = v_id_senha;

    -- Auditoria de fila (se existir a tabela)
    /*
    INSERT INTO auditoria_fila (
        id_senha,
        acao,
        id_usuario,
        data_hora
    ) VALUES (
        v_id_senha,
        'GERACAO_SENHA',
        p_id_usuario,
        NOW()
    );
    */

    -- Retorno
    SELECT
        v_id_senha     AS id_senha,
        CONCAT(v_prefixo, v_numero) AS senha_formatada,
        p_tipo_atendimento AS tipo,
        p_origem AS origem,
        p_prioridade AS prioridade,
        NOW() AS criada_em;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_historico_fila_ffa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_historico_fila_ffa`(
    IN p_id_ffa BIGINT
)
BEGIN
    SELECT *
    FROM vw_historico_fila_operacional
    WHERE id_ffa = p_id_ffa
    ORDER BY data_entrada, data_inicio;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_iniciar_ecg` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_ecg`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_iniciar_execucao_exame(p_id_ffa, 'ECG', p_id_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_iniciar_execucao_assistencial` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_execucao_assistencial`(
    IN p_id_ffa BIGINT,
    IN p_tipo ENUM('MEDICACAO','OBSERVACAO'),
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_substatus VARCHAR(50);
    DECLARE v_now DATETIME DEFAULT NOW();

    IF p_tipo = 'MEDICACAO' THEN
        SET v_substatus = 'EM_MEDICACAO';
    ELSE
        SET v_substatus = 'EM_OBSERVACAO';
    END IF;

    -- Atualiza substatus
    UPDATE ffa_substatus
       SET status = v_substatus,
           data_inicio = v_now
     WHERE id_ffa = p_id_ffa
       AND ativo = 1;

    -- Evento
    INSERT INTO evento_ffa (id_ffa, evento, data_evento, id_usuario)
    VALUES (
        p_id_ffa,
        CONCAT('INICIO_', v_substatus),
        v_now,
        p_id_usuario
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_iniciar_execucao_exame` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_execucao_exame`(
    IN p_id_ffa BIGINT,
    IN p_tipo VARCHAR(10),
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa_procedimento
       SET status = 'EM_EXECUCAO',
           iniciado_em = NOW()
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = p_tipo
       AND status = 'AGUARDANDO'
     ORDER BY solicitado_em
     LIMIT 1;

    UPDATE fila_operacional
       SET status = 'EM_EXECUCAO'
     WHERE id_ffa = p_id_ffa
       AND contexto = p_tipo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_iniciar_execucao_procedimento_rx` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_execucao_procedimento_rx`(
    IN p_id_ffa      BIGINT,
    IN p_id_usuario  BIGINT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* 1️⃣ Busca procedimento RX pendente */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'RX'
       AND status = 'SOLICITADO'
     ORDER BY solicitado_em ASC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum procedimento RX pendente para execução';
    END IF;

    /* 2️⃣ Atualiza procedimento */
    UPDATE ffa_procedimento
       SET status = 'EM_EXECUCAO',
           iniciado_em = NOW(),
           id_usuario_executor = p_id_usuario
     WHERE id_procedimento = v_id_proc;

    /* 3️⃣ Atualiza fila RX */
    UPDATE fila_operacional
       SET status = 'EM_EXECUCAO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'RX'
       AND status = 'AGUARDANDO';

    /* 4️⃣ Substatus humano */
    INSERT INTO ffa_substatus (
        id_ffa,
        substatus,
        criado_em
    ) VALUES (
        p_id_ffa,
        'EM_EXECUCAO_RX',
        NOW()
    );

    /* 5️⃣ Evento de auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'INICIO_EXECUCAO_RX',
        'RX',
        p_id_usuario,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_iniciar_lab` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_lab`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_iniciar_execucao_exame(p_id_ffa, 'LAB', p_id_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_iniciar_medicacao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_medicacao`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    -- Segurança: só inicia se liberada
    IF NOT EXISTS (
        SELECT 1
          FROM ffa_substatus
         WHERE id_ffa = p_id_ffa
           AND categoria = 'FARMACIA'
           AND status IN ('LIBERADA','LIBERACAO_EXCEPCIONAL')
           AND ativo = 1
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Medicação não liberada pela farmácia';
    END IF;

    INSERT INTO ffa_substatus (
        id_ffa, categoria, status, id_usuario
    ) VALUES (
        p_id_ffa, 'MEDICACAO', 'EM_MEDICACAO', p_id_usuario
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_iniciar_procedimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_procedimento`(
    IN p_id_procedimento BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa_procedimento
       SET status = 'EM_EXECUCAO',
           iniciado_em = NOW(),
           id_usuario_execucao = p_id_usuario
     WHERE id_procedimento = p_id_procedimento;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_iniciar_procedimento_rx` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_procedimento_rx`(
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* 1. Busca RX solicitado */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'RX'
       AND status = 'SOLICITADO'
     ORDER BY criado_em ASC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum RX solicitado para iniciar';
    END IF;

    /* 2. Inicia execução */
    UPDATE ffa_procedimento
       SET status = 'EM_EXECUCAO',
           iniciado_em = NOW()
     WHERE id_procedimento = v_id_proc;

    /* 3. Atualiza fila RX */
    UPDATE fila_operacional
       SET status = 'EM_ATENDIMENTO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'RX';

    /* 4. Substatus assistencial */
    INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
    VALUES (p_id_ffa, 'EM_RX', NOW());

    /* 5. Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'INICIO_RX',
        'RX',
        p_id_usuario,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_iniciar_usg` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_usg`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_iniciar_execucao_exame(p_id_ffa, 'USG', p_id_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_inicio_atendimento_medico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_inicio_atendimento_medico`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    -- Valida status atual
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id = p_id_ffa
     FOR UPDATE;

    IF v_status_atual <> 'CHAMANDO_MEDICO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não está em estado de chamada médica';
    END IF;

    -- Atualiza FFA para atendimento médico
    UPDATE ffa
       SET status = 'EM_ATENDIMENTO_MEDICO',
           layout = 'MEDICO',
           atendimento_medico_inicio = NOW()
     WHERE id = p_id_ffa;

    -- Atualiza senha (controle de auditoria)
    UPDATE fila_senha
       SET status = 'EM_ATENDIMENTO'
     WHERE id_ffa = p_id_ffa
       AND status = 'CHAMADA';

    -- Evento assistencial
    INSERT INTO eventos_ffa (
        id_ffa,
        tipo_evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'INICIO_ATENDIMENTO_MEDICO',
        'Atendimento médico iniciado',
        p_id_usuario,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_inicio_triagem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_inicio_triagem`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    SELECT status
    INTO v_status_atual
    FROM ffa
    WHERE id = p_id_ffa;

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FFA não encontrada';
    END IF;

    IF v_status_atual NOT IN ('ABERTO','AGUARDANDO_TRIAGEM') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FFA não está apta para iniciar triagem';
    END IF;

    UPDATE ffa
    SET status = 'EM_TRIAGEM',
        inicio_triagem_em = NOW()
    WHERE id = p_id_ffa;

    INSERT INTO auditoria_eventos (
        entidade,
        id_entidade,
        evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        'FFA',
        p_id_ffa,
        'INICIO_TRIAGEM',
        'Triagem iniciada',
        p_id_usuario,
        NOW()
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_inserir_fila` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_inserir_fila`(
    IN p_id_ffa BIGINT,
    IN p_tipo ENUM('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO'),
    IN p_prioridade ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    IN p_id_local INT,
    IN p_observacao TEXT
)
BEGIN
    INSERT INTO fila_operacional (id_ffa, tipo, prioridade, substatus, id_local, observacao)
    VALUES (p_id_ffa, p_tipo, p_prioridade, 'AGUARDANDO', p_id_local, p_observacao);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_internar_paciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_internar_paciente`(
    IN p_id_ffa BIGINT,
    IN p_id_leito INT,
    IN p_tipo VARCHAR(20),
    IN p_motivo TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_atendimento BIGINT;

    SELECT id_atendimento INTO v_id_atendimento
      FROM atendimento
     WHERE id_senha = (SELECT id_senha FROM ffa WHERE id = p_id_ffa)
     ORDER BY data_abertura DESC
     LIMIT 1;

    INSERT INTO internacao
        (id_atendimento, id_leito, tipo, motivo, data_entrada, id_usuario_entrada)
    VALUES
        (v_id_atendimento, p_id_leito, p_tipo, p_motivo, NOW(), p_id_usuario);

    UPDATE leito
       SET status = 'OCUPADO'
     WHERE id_leito = p_id_leito;

    UPDATE ffa
       SET status = 'INTERNACAO'
     WHERE id = p_id_ffa;

    INSERT INTO internacao_historico
        (id_internacao, evento, descricao, id_usuario)
    VALUES
        (LAST_INSERT_ID(), 'ENTRADA', p_motivo, p_id_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_liberar_estado_pos_execucao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_liberar_estado_pos_execucao`(
    IN p_id_ffa BIGINT
)
BEGIN
    UPDATE ffa
       SET status = 'PRONTO_PARA_DECISAO'
     WHERE id_ffa = p_id_ffa
       AND decisao_final IS NOT NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_liberar_medicacao_farmacia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_liberar_medicacao_farmacia`(
    IN p_id_ordem BIGINT,
    IN p_id_usuario BIGINT,
    IN p_lote BIGINT,
    IN p_quantidade INT,
    IN p_id_local BIGINT,
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_id_ffa BIGINT;
    DECLARE v_id_farmaco BIGINT;
    DECLARE v_validade DATE;
    DECLARE v_saldo_atual INT DEFAULT 0;
    DECLARE v_dias INT;
    DECLARE v_risco VARCHAR(20);

    -- 1️⃣ Valida perfil do usuário
    IF NOT EXISTS (
        SELECT 1
          FROM usuario_perfil up
          JOIN perfil p ON up.id_perfil = p.id_perfil
         WHERE up.id_usuario = p_id_usuario
           AND p.nome IN ('FARMACEUTICO','FARMACIA_PA','FARMACIA_UBS','FARMACIA_RUA')
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário sem permissão para liberar medicação';
    END IF;

    -- 2️⃣ Valida ordem de medicação
    SELECT id_ffa
      INTO v_id_ffa
      FROM ordem_assistencial
     WHERE id = p_id_ordem
       AND tipo_ordem = 'MEDICACAO'
       AND status = 'ATIVA';

    IF v_id_ffa IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ordem de medicação inválida ou não ativa';
    END IF;

    -- 3️⃣ Valida lote e farmaco
    SELECT id_farmaco, data_validade
      INTO v_id_farmaco, v_validade
      FROM lote
     WHERE id_lote = p_lote;

    IF v_id_farmaco IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lote inválido';
    END IF;

    -- 4️⃣ Bloqueio sanitário
    SET v_dias = DATEDIFF(v_validade, NOW());

    SET v_risco = CASE
        WHEN v_dias < 0 THEN 'VENCIDO'
        WHEN v_dias <= 30 THEN 'CRITICO'
        ELSE 'OK'
    END;

    IF v_risco = 'VENCIDO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lote vencido. Liberação bloqueada';
    END IF;

    -- 5️⃣ Verifica estoque
    SELECT quantidade_atual
      INTO v_saldo_atual
      FROM estoque_local
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local
     FOR UPDATE;

    IF v_saldo_atual IS NULL OR v_saldo_atual < p_quantidade THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente';
    END IF;

    -- 6️⃣ Debita estoque
    UPDATE estoque_local
       SET quantidade_atual = quantidade_atual - p_quantidade
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local;

    -- 7️⃣ Registra dispensação
    INSERT INTO dispensacao_medicacao
        (id_ordem, id_ffa, lote, quantidade, liberado_por, observacao, liberado_em)
    VALUES
        (p_id_ordem, v_id_ffa, p_lote, p_quantidade, p_id_usuario, p_observacao, NOW());

    -- 8️⃣ Auditoria completa
    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
    VALUES
        (v_id_ffa, 'LIBERACAO_MEDICACAO', 'FARMACIA', p_id_usuario, p_observacao, NOW());

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_listar_fila_farmacia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_fila_farmacia`()
BEGIN
    SELECT *
    FROM vw_fila_farmacia
    ORDER BY prioridade DESC, iniciado_em ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_listar_fila_operacional` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_fila_operacional`(
    IN p_tipo ENUM('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO'),
    IN p_prioridade ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL')
)
BEGIN
    SELECT *
    FROM vw_fila_operacional_atual
    WHERE tipo = p_tipo
      AND (prioridade = p_prioridade OR p_prioridade IS NULL)
    ORDER BY 
        FIELD(prioridade,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
        data_entrada;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_marcar_nao_compareceu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_marcar_nao_compareceu`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_local BIGINT,
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_id_fila BIGINT;

    -- buscar fila (senha) vinculada à FFA
    SELECT id_senha, status
      INTO v_id_fila, v_status_atual
      FROM ffa
     WHERE id = p_id_ffa
     FOR UPDATE;

    IF v_id_fila IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não possui senha vinculada';
    END IF;

    IF v_status_atual NOT IN ('CHAMANDO_MEDICO','AGUARDANDO_CHAMADA_MEDICO') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não está em estado válido para NAO_COMPARECEU';
    END IF;

    -- atualiza status da FFA
    UPDATE ffa
       SET status = 'AGUARDANDO_RETORNO',
           atualizado_em = NOW(),
           id_usuario_alteracao = p_id_usuario
     WHERE id = p_id_ffa;

    -- evento correto de fila
    INSERT INTO fila_evento (
        id_fila,
        evento,
        id_usuario,
        id_local,
        detalhe,
        criado_em
    ) VALUES (
        v_id_fila,
        'NAO_ATENDIDO',
        p_id_usuario,
        p_id_local,
        COALESCE(p_motivo, 'Paciente não compareceu à chamada'),
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_mover_atendimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_mover_atendimento`(
    IN p_id_atendimento BIGINT,
    IN p_novo_local INT,
    IN p_nova_sala INT,
    IN p_usuario BIGINT,
    IN p_motivo TEXT
)
BEGIN
    INSERT INTO atendimento_movimentacao (
        id_atendimento,
        de_local,
        para_local,
        id_usuario,
        motivo
    )
    SELECT
        id_atendimento,
        id_local_atual,
        p_novo_local,
        p_usuario,
        p_motivo
    FROM atendimento
    WHERE id_atendimento = p_id_atendimento;

    UPDATE atendimento
    SET id_local_atual = p_novo_local,
        id_sala_atual = p_nova_sala
    WHERE id_atendimento = p_id_atendimento;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_nao_atendido` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_nao_atendido`(
    IN p_id_ffa BIGINT,
    IN p_motivo VARCHAR(255),
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa
       SET status = 'NAO_ATENDIDO',
           encerrado_em = NOW()
     WHERE id = p_id_ffa;

    INSERT INTO auditoria_ffa
        (id_ffa, evento, observacao, data_evento, id_usuario)
    VALUES
        (p_id_ffa, 'NAO_ATENDIDO', p_motivo, NOW(), p_id_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_painel_chamar_paciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_chamar_paciente`(
    IN p_id_ffa       BIGINT,
    IN p_contexto     ENUM('RECEPCAO','TRIAGEM','MEDICO','RX','LAB','ECG','MEDICACAO'),
    IN p_local        VARCHAR(50),
    IN p_id_usuario   BIGINT
)
BEGIN
    INSERT INTO chamada_painel (
        id_ffa,
        contexto,
        local_chamada,
        chamado_por,
        chamado_em,
        status
    ) VALUES (
        p_id_ffa,
        p_contexto,
        p_local,
        p_id_usuario,
        NOW(),
        'CHAMADO'
    );

    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'CHAMADA_PAINEL',
        p_contexto,
        p_id_usuario,
        NOW()
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_painel_nao_compareceu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_nao_compareceu`(
    IN p_id_chamada BIGINT,
    IN p_id_usuario BIGINT,
    IN p_motivo     VARCHAR(255)
)
BEGIN
    UPDATE chamada_painel
       SET status = 'NAO_COMPARECEU'
     WHERE id_chamada = p_id_chamada;

    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    )
    SELECT
        id_ffa,
        'NAO_COMPARECEU',
        contexto,
        p_id_usuario,
        p_motivo,
        NOW()
    FROM chamada_painel
    WHERE id_chamada = p_id_chamada;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_prescrever_medicacao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_prescrever_medicacao`(
    IN p_id_ffa BIGINT,
    IN p_id_medico BIGINT,
    IN p_descricao TEXT,
    IN p_controlada TINYINT
)
BEGIN
    DECLARE v_id_prescricao BIGINT;

    INSERT INTO prescricao_medicacao (
        id_ffa, id_medico, descricao, controlada
    ) VALUES (
        p_id_ffa, p_id_medico, p_descricao, p_controlada
    );

    SET v_id_prescricao = LAST_INSERT_ID();

    INSERT INTO ffa_substatus (
        id_ffa, categoria, status, id_usuario
    ) VALUES (
        p_id_ffa, 'MEDICACAO', 'PRESCRITA', p_id_medico
    );

    IF p_controlada = 1 THEN
        INSERT INTO ffa_substatus (
            id_ffa, categoria, status
        ) VALUES (
            p_id_ffa, 'FARMACIA', 'AGUARDANDO_ANALISE'
        );
    ELSE
        INSERT INTO ffa_substatus (
            id_ffa, categoria, status
        ) VALUES (
            p_id_ffa, 'MEDICACAO', 'AGUARDANDO_MEDICACAO'
        );
    END IF;

    -- Garante que a FFA esteja no macro correto
    UPDATE ffa
       SET status = 'EM_PROCEDIMENTO'
     WHERE id = p_id_ffa
       AND status NOT IN ('EM_OBSERVACAO','INTERNADO','ALTA','FINALIZADO');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_procedimento_critico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_procedimento_critico`(
    IN p_id_procedimento BIGINT,
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    SELECT id_ffa INTO v_id_ffa
      FROM ffa_procedimento
     WHERE id_procedimento = p_id_procedimento;

    UPDATE ffa_procedimento
       SET status = 'CRITICO',
           observacao = p_observacao,
           finalizado_em = NOW()
     WHERE id_procedimento = p_id_procedimento;

    UPDATE ffa
       SET status = 'EMERGENCIA'
     WHERE id = v_id_ffa;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reabrir_fluxo_manual` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reabrir_fluxo_manual`(
    IN p_id_ffa BIGINT,
    IN p_motivo TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa
       SET status = 'EM_ATENDIMENTO'
     WHERE id_ffa = p_id_ffa;

    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
    VALUES
        (p_id_ffa, 'REABERTURA_MANUAL', 'SISTEMA', p_id_usuario, p_motivo, NOW());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_rechamar_painel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_rechamar_painel`(
    IN p_id_ffa BIGINT,
    IN p_local VARCHAR(50),
    IN p_id_usuario BIGINT
)
BEGIN
    -- Evento exclusivo de painel
    INSERT INTO chamada_painel (
        id_ffa,
        local_chamada,
        tipo_chamada,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        p_local,
        'RECHAMADA',
        p_id_usuario,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_rechamar_procedimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_rechamar_procedimento`(
    IN p_id_ffa BIGINT,
    IN p_tipo VARCHAR(10),
    IN p_id_usuario BIGINT
)
BEGIN
    INSERT INTO fila_operacional
        (id_ffa, contexto, status, criado_em)
    VALUES
        (p_id_ffa, p_tipo, 'AGUARDANDO', NOW());

    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, criado_em)
    VALUES
        (p_id_ffa, 'RECHAMADA_MANUAL', p_tipo, p_id_usuario, NOW());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_evento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_evento`(
    IN p_id_ffa BIGINT,
    IN p_id_fila BIGINT,
    IN p_evento VARCHAR(255),
    IN p_id_usuario BIGINT,
    IN p_detalhe TEXT
)
BEGIN
    START TRANSACTION;

    -- Inserir evento na fila
    INSERT INTO fila_evento (id_fila, evento, id_usuario, detalhe, criado_em)
    VALUES (p_id_fila, p_evento, p_id_usuario, p_detalhe, NOW());

    -- Inserir evento na FFA
    INSERT INTO evento_ffa (id_ffa, evento, id_usuario, detalhe, criado_em)
    VALUES (p_id_ffa, p_evento, p_id_usuario, p_detalhe, NOW());

    -- Registrar auditoria
    INSERT INTO log_auditoria (id_usuario, tabela, acao, detalhe, criado_em)
    VALUES (p_id_usuario, 'evento', 'INSERT', CONCAT('Evento FFA/Fila: ', p_evento), NOW());

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_feedback_totem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_feedback_totem`(
    IN p_id_ffa     BIGINT,
    IN p_nota       INT,
    IN p_comentario TEXT
)
BEGIN
    INSERT INTO totem_feedback (
        id_ffa,
        nota,
        comentario,
        criado_em
    ) VALUES (
        p_id_ffa,
        p_nota,
        p_comentario,
        NOW()
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_ordem_assistencial` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_ordem_assistencial`(
    IN p_id_ffa        BIGINT,
    IN p_tipo_ordem    ENUM('MEDICACAO','CUIDADO','DIETA','OXIGENIO','PROCEDIMENTO'),
    IN p_payload       JSON,
    IN p_prioridade    INT,
    IN p_id_usuario    BIGINT
)
BEGIN
    /* Cria ordem */
    INSERT INTO ordem_assistencial (
        id_ffa,
        tipo_ordem,
        payload_clinico,
        prioridade,
        status,
        criado_por,
        iniciado_em
    ) VALUES (
        p_id_ffa,
        p_tipo_ordem,
        p_payload,
        p_prioridade,
        'ATIVA',
        p_id_usuario,
        NOW()
    );

    /* Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'REGISTRO_ORDEM_ASSISTENCIAL',
        p_tipo_ordem,
        p_id_usuario,
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.descricao')),
        NOW()
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_paciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_paciente`(
    IN p_nome_completo VARCHAR(200),
    IN p_cpf VARCHAR(14),
    IN p_data_nascimento DATE,
    IN p_id_usuario BIGINT -- Para auditoria
)
BEGIN
    -- Verifica permissão (exemplo)
    IF NOT EXISTS (SELECT 1 FROM usuario_perfil WHERE id_usuario = p_id_usuario AND id_perfil = 1) THEN -- Assumindo perfil 1 = ADMIN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Permissão negada';
    END IF;
    
    INSERT INTO pessoa (nome_completo, cpf, data_nascimento) VALUES (p_nome_completo, p_cpf, p_data_nascimento);
    INSERT INTO paciente (id_pessoa) VALUES (LAST_INSERT_ID());
    
    -- Auditoria
    INSERT INTO log_auditoria (id_usuario, acao, tabela_afetada, id_registro, comentario)
    VALUES (p_id_usuario, 'INSERT', 'paciente', LAST_INSERT_ID(), 'Novo paciente registrado');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reset_senha_usuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reset_senha_usuario`(IN p_id_usuario BIGINT)
BEGIN
    DECLARE v_login VARCHAR(150);

    -- Pega login do usuário
    SELECT login INTO v_login
    FROM usuario
    WHERE id_usuario = p_id_usuario;

    -- Atualiza senha, hash e flags
    UPDATE usuario
    SET 
        senha = v_login,
        senha_hash = SHA2(v_login, 256),
        primeiro_login = 1,
        senha_expira_em = DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
    WHERE id_usuario = p_id_usuario;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_retorno_medico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_retorno_medico`(
    IN p_id_ffa BIGINT
)
BEGIN
    UPDATE fila_operacional
       SET status = 'AGUARDANDO_MEDICO'
     WHERE id_ffa = p_id_ffa;

    UPDATE ffa
       SET status = 'AGUARDANDO_CHAMADA_MEDICO'
     WHERE id = p_id_ffa;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_retorno_procedimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_retorno_procedimento`(
    IN p_id_ffa BIGINT,
    IN p_tipo_retorno ENUM('NORMAL','EMERGENCIA'),
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_substatus VARCHAR(50);

    -- 1. Busca o status atual do paciente
    SELECT status, substatus
    INTO v_status_atual, v_substatus
    FROM ffa
    WHERE id = p_id_ffa
    LIMIT 1;

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não encontrada';
    END IF;

    -- 2. Define próximo status e substatus baseado no tipo de retorno
    IF p_tipo_retorno = 'EMERGENCIA' THEN
        SET v_status_atual = 'CHAMANDO_MEDICO';
        SET v_substatus = 'EMERGENCIA';
    ELSE
        SET v_status_atual = 'AGUARDANDO_CHAMADA_MEDICO';
        SET v_substatus = 'NORMAL';
    END IF;

    -- 3. Atualiza FFA com novo status e substatus
    UPDATE ffa
    SET status = v_status_atual,
        substatus = v_substatus,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- 4. Insere na fila_operacional
    INSERT INTO fila_operacional (
        id_ffa,
        tipo_evento,
        prioridade,
        criado_em
    ) VALUES (
        p_id_ffa,
        'RETORNO_PROCEDIMENTO',
        IF(p_tipo_retorno='EMERGENCIA', 1, 5), -- prioridade: 1 máxima, 5 normal
        NOW()
    );

    -- 5. Registra auditoria
    INSERT INTO auditoria_ffa (
        id_ffa,
        acao,
        descricao,
        id_usuario,
        data_hora
    ) VALUES (
        p_id_ffa,
        'RETORNO_PROCEDIMENTO',
        CONCAT('Tipo: ', p_tipo_retorno, '; Substatus atualizado: ', v_substatus),
        p_id_usuario,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_retorno_procedimento_critico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_retorno_procedimento_critico`(
    IN p_id_ffa BIGINT
)
BEGIN
    UPDATE ffa
    SET status = 'EMERGENCIA',
        classificacao_manchester = 'VERMELHO',
        atualizado_em = NOW()
    WHERE id = p_id_ffa;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_retorno_procedimento_normal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_retorno_procedimento_normal`(
    IN p_id_ffa BIGINT
)
BEGIN
    UPDATE ffa
    SET status = 'AGUARDANDO_CHAMADA_MEDICO',
        atualizado_em = NOW()
    WHERE id = p_id_ffa;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_sessao_usuario_abrir_v2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_usuario_abrir_v2`(
  IN  p_id_usuario BIGINT,
  IN  p_id_sistema BIGINT,
  IN  p_id_unidade BIGINT,
  IN  p_id_local_operacional BIGINT,
  IN  p_sid_refresh BIGINT,
  IN  p_ip VARCHAR(45),
  IN  p_user_agent VARCHAR(255),
  IN  p_id_perfil INT,
  OUT p_id_sessao_usuario BIGINT
)
BEGIN
  -- encerra sessões ativas antigas (mesmo usuário + mesmo contexto) para não duplicar
  UPDATE sessao_usuario
     SET encerrado_em = NOW(),
         ativo = 0
   WHERE id_usuario = p_id_usuario
     AND id_sistema = p_id_sistema
     AND id_unidade = p_id_unidade
     AND id_local_operacional = p_id_local_operacional
     AND ativo = 1
     AND encerrado_em IS NULL;

  INSERT INTO sessao_usuario (
    id_usuario, id_sistema, id_unidade, id_local_operacional,
    sid_refresh, ip, user_agent, iniciado_em, ativo
  ) VALUES (
    p_id_usuario, p_id_sistema, p_id_unidade, p_id_local_operacional,
    p_sid_refresh, p_ip, p_user_agent, NOW(), 1
  );

  SET p_id_sessao_usuario = LAST_INSERT_ID();

  -- salva "último contexto" (para o front reabrir direto)
  INSERT INTO usuario_contexto (
    id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, atualizado_em
  ) VALUES (
    p_id_usuario, p_id_sistema, p_id_unidade, p_id_local_operacional, p_id_perfil, NOW()
  )
  ON DUPLICATE KEY UPDATE
    id_unidade = VALUES(id_unidade),
    id_local_operacional = VALUES(id_local_operacional),
    id_perfil = VALUES(id_perfil),
    atualizado_em = NOW();

  -- auditoria
  INSERT INTO auditoria_evento (
    id_sessao_usuario, entidade, id_entidade, acao, detalhe, criado_em
  ) VALUES (
    p_id_sessao_usuario, 'SESSAO', p_id_sessao_usuario, 'ABRIR',
    CONCAT('Sessão aberta. sistema=',p_id_sistema,' unidade=',p_id_unidade,' local=',p_id_local_operacional),
    NOW()
  );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_sessao_usuario_encerrar_v2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_usuario_encerrar_v2`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_usuario BIGINT,
  IN p_motivo VARCHAR(120)
)
BEGIN
  UPDATE sessao_usuario
     SET encerrado_em = NOW(),
         ativo = 0
   WHERE id_sessao_usuario = p_id_sessao_usuario
     AND id_usuario = p_id_usuario
     AND ativo = 1
     AND encerrado_em IS NULL;

  INSERT INTO auditoria_evento (
    id_sessao_usuario, entidade, id_entidade, acao, detalhe, criado_em
  ) VALUES (
    p_id_sessao_usuario, 'SESSAO', p_id_sessao_usuario, 'ENCERRAR',
    IFNULL(p_motivo,'Encerramento manual'),
    NOW()
  );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setor_chamar_senha_v2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setor_chamar_senha_v2`(
  IN  p_id_sessao_usuario BIGINT,
  IN  p_id_usuario BIGINT,
  IN  p_id_fila_senha BIGINT,
  IN  p_id_local_operacional BIGINT,
  IN  p_etapa_codigo VARCHAR(50),
  OUT p_id_fila_operacional BIGINT
)
BEGIN
  -- cria ou atualiza a “entrada” da senha nesse setor
  INSERT INTO fila_operacional (
    id_fila_senha, id_local_operacional, etapa_codigo,
    status, prioridade,
    id_usuario_chamada, chamado_em
  )
  SELECT
    fs.id, p_id_local_operacional, p_etapa_codigo,
    'CHAMANDO', fs.prioridade,
    p_id_usuario, NOW()
  FROM fila_senha fs
  WHERE fs.id = p_id_fila_senha
  ON DUPLICATE KEY UPDATE
    etapa_codigo = VALUES(etapa_codigo),
    status = 'CHAMANDO',
    prioridade = VALUES(prioridade),
    id_usuario_chamada = VALUES(id_usuario_chamada),
    chamado_em = VALUES(chamado_em);

  SELECT id_fila_operacional
    INTO p_id_fila_operacional
    FROM fila_operacional
   WHERE id_fila_senha = p_id_fila_senha
     AND id_local_operacional = p_id_local_operacional
   LIMIT 1;

  INSERT INTO fila_operacional_evento (
    id_fila_operacional, id_sessao_usuario, evento, detalhe, id_usuario, criado_em
  ) VALUES (
    p_id_fila_operacional, p_id_sessao_usuario, 'CHAMADA',
    CONCAT('Chamada manual no setor. etapa=',IFNULL(p_etapa_codigo,'NULL')),
    p_id_usuario, NOW()
  );

  -- Auditoria geral
  INSERT INTO auditoria_evento (id_sessao_usuario, entidade, id_entidade, acao, detalhe, criado_em)
  VALUES (
    p_id_sessao_usuario, 'FILA_OPERACIONAL', p_id_fila_operacional, 'CHAMADA',
    CONCAT('Senha=',p_id_fila_senha,' local_operacional=',p_id_local_operacional,' etapa=',IFNULL(p_etapa_codigo,'NULL')),
    NOW()
  );

  -- (Opcional) refletir na fila_senha.status:
  -- UPDATE fila_senha SET status='CHAMANDO', atualizado_em=NOW() WHERE id=p_id_fila_senha;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setor_finalizar_atendimento_v2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setor_finalizar_atendimento_v2`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_usuario BIGINT,
  IN p_id_fila_operacional BIGINT,
  IN p_detalhe TEXT
)
BEGIN
  UPDATE fila_operacional
     SET status = 'FINALIZADO',
         id_usuario_fim = p_id_usuario,
         finalizado_em = NOW()
   WHERE id_fila_operacional = p_id_fila_operacional;

  INSERT INTO fila_operacional_evento (
    id_fila_operacional, id_sessao_usuario, evento, detalhe, id_usuario, criado_em
  ) VALUES (
    p_id_fila_operacional, p_id_sessao_usuario, 'FINALIZACAO',
    p_detalhe,
    p_id_usuario, NOW()
  );

  INSERT INTO auditoria_evento (id_sessao_usuario, entidade, id_entidade, acao, detalhe, criado_em)
  VALUES (
    p_id_sessao_usuario, 'FILA_OPERACIONAL', p_id_fila_operacional, 'FINALIZACAO',
    IFNULL(p_detalhe,'Finalização manual do setor'),
    NOW()
  );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setor_iniciar_atendimento_v2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setor_iniciar_atendimento_v2`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_usuario BIGINT,
  IN p_id_fila_operacional BIGINT
)
BEGIN
  UPDATE fila_operacional
     SET status = 'EM_EXECUCAO',
         id_usuario_inicio = p_id_usuario,
         iniciado_em = NOW()
   WHERE id_fila_operacional = p_id_fila_operacional;

  INSERT INTO fila_operacional_evento (
    id_fila_operacional, id_sessao_usuario, evento, detalhe, id_usuario, criado_em
  ) VALUES (
    p_id_fila_operacional, p_id_sessao_usuario, 'INICIO',
    'Início manual do atendimento no setor',
    p_id_usuario, NOW()
  );

  INSERT INTO auditoria_evento (id_sessao_usuario, entidade, id_entidade, acao, detalhe, criado_em)
  VALUES (
    p_id_sessao_usuario, 'FILA_OPERACIONAL', p_id_fila_operacional, 'INICIO',
    'Setor marcou INÍCIO (manual)',
    NOW()
  );

  -- (Opcional) refletir na fila_senha.status:
  -- UPDATE fila_senha fs
  --   JOIN fila_operacional fo ON fo.id_fila_senha = fs.id
  --  SET fs.status='EM_ATENDIMENTO', fs.atualizado_em=NOW()
  --  WHERE fo.id_fila_operacional = p_id_fila_operacional;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setor_nao_compareceu_v2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setor_nao_compareceu_v2`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_usuario BIGINT,
  IN p_id_fila_operacional BIGINT,
  IN p_motivo TEXT
)
BEGIN
  UPDATE fila_operacional
     SET status = 'NAO_COMPARECEU',
         id_usuario_fim = p_id_usuario,
         finalizado_em = NOW()
   WHERE id_fila_operacional = p_id_fila_operacional;

  INSERT INTO fila_operacional_evento (
    id_fila_operacional, id_sessao_usuario, evento, detalhe, id_usuario, criado_em
  ) VALUES (
    p_id_fila_operacional, p_id_sessao_usuario, 'NAO_COMPARECEU',
    p_motivo,
    p_id_usuario, NOW()
  );

  INSERT INTO auditoria_evento (id_sessao_usuario, entidade, id_entidade, acao, detalhe, criado_em)
  VALUES (
    p_id_sessao_usuario, 'FILA_OPERACIONAL', p_id_fila_operacional, 'NAO_COMPARECEU',
    IFNULL(p_motivo,'Não compareceu na chamada do setor'),
    NOW()
  );

  -- (Opcional) refletir na fila_senha.status:
  -- UPDATE fila_senha fs
  --   JOIN fila_operacional fo ON fo.id_fila_senha = fs.id
  --  SET fs.status='NAO_ATENDIDO', fs.atualizado_em=NOW()
  --  WHERE fo.id_fila_operacional = p_id_fila_operacional;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_solicitar_ecg` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_ecg`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    CALL sp_solicitar_exame_generico(p_id_ffa, 'ECG', p_id_usuario, p_observacao);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_solicitar_exame` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_exame`(
    IN p_id_atendimento BIGINT,
    IN p_id_sigpat BIGINT,
    IN p_id_medico BIGINT
)
BEGIN
    INSERT INTO solicitacao_exame (
        id_atendimento,
        id_sigpat,
        status,
        id_medico,
        solicitado_em
    ) VALUES (
        p_id_atendimento,
        p_id_sigpat,
        'SOLICITADO',
        p_id_medico,
        NOW()
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_solicitar_exame_generico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_exame_generico`(
    IN p_id_ffa BIGINT,
    IN p_tipo VARCHAR(10),
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    INSERT INTO ffa_procedimento
        (id_ffa, tipo_procedimento, status, solicitado_em)
    VALUES
        (p_id_ffa, p_tipo, 'AGUARDANDO', NOW());

    INSERT INTO fila_operacional
        (id_ffa, contexto, status, criado_em)
    VALUES
        (p_id_ffa, p_tipo, 'AGUARDANDO', NOW());

    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
    VALUES
        (p_id_ffa, 'SOLICITACAO', p_tipo, p_id_usuario, p_observacao, NOW());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_solicitar_exame_rx` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_exame_rx`(
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT,
    IN p_observacao    TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    /* 1️⃣ Validação básica */
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id_ffa = p_id_ffa
       AND ativo = 1
     LIMIT 1;

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA inválida ou encerrada';
    END IF;

    /* 2️⃣ Registra o procedimento RX */
    INSERT INTO ffa_procedimento (
        id_ffa,
        tipo_procedimento,
        status,
        solicitado_em,
        id_usuario_solicitante,
        observacao
    ) VALUES (
        p_id_ffa,
        'RX',
        'SOLICITADO',
        NOW(),
        p_id_usuario,
        p_observacao
    );

    /* 3️⃣ Atualiza status assistencial */
    UPDATE ffa
       SET status = 'EM_PROCEDIMENTO'
     WHERE id_ffa = p_id_ffa;

    /* 4️⃣ Substatus humano */
    INSERT INTO ffa_substatus (
        id_ffa,
        substatus,
        criado_em
    ) VALUES (
        p_id_ffa,
        'AGUARDANDO_RX',
        NOW()
    );

    /* 5️⃣ Insere na fila paralela (RX) */
    INSERT INTO fila_operacional (
        id_ffa,
        contexto,
        prioridade,
        status,
        criado_em
    )
    SELECT
        p_id_ffa,
        'RX',
        prioridade,
        'AGUARDANDO',
        NOW()
    FROM fila_operacional
    WHERE id_ffa = p_id_ffa
      AND contexto = 'MEDICO'
    LIMIT 1;

    /* 6️⃣ Evento de auditoria de fluxo */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'SOLICITACAO_RX',
        'RX',
        p_id_usuario,
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_solicitar_laboratorio` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_laboratorio`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    CALL sp_solicitar_exame_generico(p_id_ffa, 'LAB', p_id_usuario, p_observacao);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_solicitar_procedimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_procedimento`(
    IN p_id_ffa BIGINT,
    IN p_tipo VARCHAR(20),
    IN p_prioridade VARCHAR(20),
    IN p_id_usuario BIGINT
)
BEGIN
    INSERT INTO ffa_procedimento
        (id_ffa, tipo, prioridade, id_usuario_solicitante)
    VALUES
        (p_id_ffa, p_tipo, p_prioridade, p_id_usuario);

    UPDATE ffa
       SET status = CONCAT('AGUARDANDO_', p_tipo)
     WHERE id = p_id_ffa;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_solicitar_usg` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_usg`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    CALL sp_solicitar_exame_generico(p_id_ffa, 'USG', p_id_usuario, p_observacao);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_suspender_ordem_assistencial` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_suspender_ordem_assistencial`(
    IN p_id_ordem   BIGINT,
    IN p_motivo     TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    SELECT id_ffa
      INTO v_id_ffa
      FROM ordem_assistencial
     WHERE id = p_id_ordem
       AND status = 'ATIVA';

    IF v_id_ffa IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ordem não ativa ou inexistente';
    END IF;

    UPDATE ordem_assistencial
       SET status = 'SUSPENSA',
           encerrado_em = NOW()
     WHERE id = p_id_ordem;

    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        v_id_ffa,
        'SUSPENSAO_ORDEM_ASSISTENCIAL',
        'ORDEM',
        p_id_usuario,
        p_motivo,
        NOW()
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_timeout_ffa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_timeout_ffa`()
BEGIN
    UPDATE ffa
       SET status = 'TIMEOUT',
           encerrado_em = NOW()
     WHERE status NOT IN ('FINALIZADO','NAO_ATENDIDO','ALTA')
       AND TIMESTAMPDIFF(HOUR, criado_em, NOW()) >= 14;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_timeout_procedimento_rx` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_timeout_procedimento_rx`(
    IN p_id_ffa      BIGINT,
    IN p_id_usuario  BIGINT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* 1. RX em execução */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'RX'
       AND status = 'EM_EXECUCAO'
     ORDER BY iniciado_em DESC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum RX em execução para timeout';
    END IF;

    /* 2. Marca timeout */
    UPDATE ffa_procedimento
       SET status = 'TIMEOUT',
           finalizado_em = NOW(),
           resultado = 'Timeout de RX'
     WHERE id_procedimento = v_id_proc;

    /* 3. Remove da fila RX */
    UPDATE fila_operacional
       SET status = 'TIMEOUT'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'RX';

    /* 4. Retorno normal */
    CALL sp_retorno_procedimento_normal(p_id_ffa, p_id_usuario);

    INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
    VALUES (p_id_ffa, 'RX_TIMEOUT', NOW());

    /* 5. Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'TIMEOUT_RX',
        'RX',
        p_id_usuario,
        'RX não atendido dentro do tempo',
        NOW()
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_transferir_internacao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_transferir_internacao`(
    IN p_id_internacao BIGINT,
    IN p_novo_leito INT,
    IN p_id_usuario BIGINT,
    IN p_comentario TEXT
)
BEGIN
    DECLARE v_status_atual ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA');

    SELECT status INTO v_status_atual FROM internacao WHERE id_internacao = p_id_internacao;

    -- Atualiza leito e status para TRANSFERIDA
    UPDATE internacao
    SET id_leito = p_novo_leito,
        status = 'TRANSFERIDA',
        atualizado_em = NOW()
    WHERE id_internacao = p_id_internacao;

    -- Insere histórico
    INSERT INTO internacao_historico (id_internacao, status_anterior, status_novo, id_usuario, comentario)
    VALUES (p_id_internacao, v_status_atual, 'TRANSFERIDA', p_id_usuario, p_comentario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_trocar_senha_usuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_trocar_senha_usuario`(
    IN p_id_usuario BIGINT,
    IN p_nova_senha VARCHAR(150)
)
BEGIN
    UPDATE usuario
    SET 
        senha = p_nova_senha,
        senha_hash = SHA2(p_nova_senha, 256),
        primeiro_login = 0,
        senha_expira_em = DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
    WHERE id_usuario = p_id_usuario;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_substatus_operacional` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_substatus_operacional`(
    IN p_id_fila BIGINT,
    IN p_substatus ENUM('AGUARDANDO','EM_EXECUCAO','EM_OBSERVACAO','FINALIZADO','CRITICO'),
    IN p_id_responsavel BIGINT,
    IN p_observacao TEXT
)
BEGIN
    -- Evita quebrar fila: não permite retroceder substatus já finalizado
    IF (SELECT substatus FROM fila_operacional WHERE id_fila = p_id_fila) != 'FINALIZADO' THEN
        CALL sp_atualizar_fila(p_id_fila, p_substatus, p_id_responsavel, p_observacao);
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_validar_login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validar_login`(
    IN p_login VARCHAR(150),
    IN p_senha VARCHAR(150)
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_senha_hash VARCHAR(255);
    DECLARE v_ativo TINYINT;
    DECLARE v_primeiro_login TINYINT;
    DECLARE v_senha_expira_em DATE;

    -- Inicializa
    SET v_id_usuario = NULL;
    SET v_senha_hash = NULL;
    SET v_ativo = 0;
    SET v_primeiro_login = 0;
    SET v_senha_expira_em = NULL;

    -- Busca usuário
    SELECT id_usuario, senha_hash, ativo, primeiro_login, senha_expira_em
    INTO v_id_usuario, v_senha_hash, v_ativo, v_primeiro_login, v_senha_expira_em
    FROM usuario
    WHERE login = p_login
    LIMIT 1;

    -- Valida existência e ativo
    IF v_id_usuario IS NULL OR v_ativo = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário inválido ou inativo.';
    END IF;

    -- Valida senha
    IF v_senha_hash <> SHA2(p_senha, 256) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Senha incorreta.';
    END IF;

    -- Verifica expiração
    IF v_senha_expira_em IS NOT NULL AND CURDATE() > v_senha_expira_em THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Senha expirada. Obrigatório trocar.';
    END IF;

    -- Retorna dados
    SELECT 
        v_id_usuario AS id_usuario,
        p_login AS login,
        v_primeiro_login AS primeiro_login,
        v_senha_expira_em AS senha_expira_em;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_verificar_pendencias_assistenciais` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_verificar_pendencias_assistenciais`(
    IN p_id_ffa BIGINT,
    OUT p_pendencias INT
)
BEGIN
    SELECT COUNT(*)
      INTO p_pendencias
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND status IN ('AGUARDANDO','EM_EXECUCAO');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vw_farmacia_dashboard_completo`
--

/*!50001 DROP VIEW IF EXISTS `vw_farmacia_dashboard_completo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_farmacia_dashboard_completo` AS select `f`.`id_farmaco` AS `id_farmaco`,`f`.`nome_comercial` AS `nome_comercial`,`f`.`principio_ativo` AS `principio_ativo`,`e`.`id_local` AS `id_local`,`e`.`quantidade_atual` AS `quantidade_atual`,`e`.`min_estoque` AS `min_estoque`,(`e`.`min_estoque` - `e`.`quantidade_atual`) AS `deficit`,`fl`.`id_lote` AS `id_lote`,`fl`.`numero_lote` AS `numero_lote`,`fl`.`data_validade` AS `data_validade`,`fn_dias_para_vencimento`(`fl`.`data_validade`) AS `dias_para_vencer`,(case when (`fn_dias_para_vencimento`(`fl`.`data_validade`) < 0) then 'VENCIDO' when (`fn_dias_para_vencimento`(`fl`.`data_validade`) <= 30) then 'CRITICO' else 'OK' end) AS `nivel_risco` from ((`estoque_local` `e` join `farmaco` `f` on((`f`.`id_farmaco` = `e`.`id_farmaco`))) left join `farmaco_lote` `fl` on((`fl`.`id_farmaco` = `f`.`id_farmaco`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_farmacia_dashboard_critico`
--

/*!50001 DROP VIEW IF EXISTS `vw_farmacia_dashboard_critico`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_farmacia_dashboard_critico` AS select `f`.`id_farmaco` AS `id_farmaco`,`f`.`nome_comercial` AS `nome_comercial`,`f`.`principio_ativo` AS `principio_ativo`,`e`.`id_local` AS `id_local`,`e`.`quantidade_atual` AS `estoque_atual`,`e`.`min_estoque` AS `min_estoque`,(`e`.`min_estoque` - `e`.`quantidade_atual`) AS `deficit` from (`estoque_local` `e` join `farmaco` `f` on((`f`.`id_farmaco` = `e`.`id_farmaco`))) where ((`e`.`min_estoque` is not null) and (`e`.`quantidade_atual` < `e`.`min_estoque`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_farmaco_alerta_estoque`
--

/*!50001 DROP VIEW IF EXISTS `vw_farmaco_alerta_estoque`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_farmaco_alerta_estoque` AS select `f`.`id_farmaco` AS `id_farmaco`,`f`.`nome_comercial` AS `nome_comercial`,`f`.`principio_ativo` AS `principio_ativo`,`el`.`id_local` AS `id_local`,`el`.`quantidade_atual` AS `estoque_atual`,`el`.`min_estoque` AS `min_estoque`,(`el`.`min_estoque` - `el`.`quantidade_atual`) AS `deficit` from (`farmaco` `f` join `estoque_local` `el` on((`el`.`id_farmaco` = `f`.`id_farmaco`))) where (`el`.`quantidade_atual` < `el`.`min_estoque`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_farmaco_consumo_periodo`
--

/*!50001 DROP VIEW IF EXISTS `vw_farmaco_consumo_periodo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_farmaco_consumo_periodo` AS select `m`.`id_farmaco` AS `id_farmaco`,`f`.`nome_comercial` AS `nome_comercial`,`m`.`id_cidade` AS `id_cidade`,cast(`m`.`data_mov` as date) AS `data_consumo`,sum(`m`.`quantidade`) AS `total_consumido` from (`farmaco_movimentacao` `m` join `farmaco` `f` on((`f`.`id_farmaco` = `m`.`id_farmaco`))) where ((`m`.`tipo` = 'SAIDA') and (`m`.`origem` = 'PACIENTE')) group by `m`.`id_farmaco`,`m`.`id_cidade`,cast(`m`.`data_mov` as date) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_farmaco_consumo_por_ffa`
--

/*!50001 DROP VIEW IF EXISTS `vw_farmaco_consumo_por_ffa`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_farmaco_consumo_por_ffa` AS select `m`.`id_ffa` AS `id_ffa`,`m`.`id_farmaco` AS `id_farmaco`,`f`.`nome_comercial` AS `nome_comercial`,sum(`m`.`quantidade`) AS `quantidade` from (`farmaco_movimentacao` `m` join `farmaco` `f` on((`f`.`id_farmaco` = `m`.`id_farmaco`))) where (`m`.`origem` = 'PACIENTE') group by `m`.`id_ffa`,`m`.`id_farmaco` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_farmaco_estoque_lote`
--

/*!50001 DROP VIEW IF EXISTS `vw_farmaco_estoque_lote`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_farmaco_estoque_lote` AS select `m`.`id_farmaco` AS `id_farmaco`,`m`.`id_lote` AS `id_lote`,`m`.`id_cidade` AS `id_cidade`,sum((case when (`m`.`tipo` = 'ENTRADA') then `m`.`quantidade` else -(`m`.`quantidade`) end)) AS `estoque_lote` from `farmaco_movimentacao` `m` group by `m`.`id_farmaco`,`m`.`id_lote`,`m`.`id_cidade` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_farmaco_estoque_total`
--

/*!50001 DROP VIEW IF EXISTS `vw_farmaco_estoque_total`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_farmaco_estoque_total` AS select `vw_farmaco_estoque_lote`.`id_farmaco` AS `id_farmaco`,`vw_farmaco_estoque_lote`.`id_cidade` AS `id_cidade`,sum(`vw_farmaco_estoque_lote`.`estoque_lote`) AS `estoque_total` from `vw_farmaco_estoque_lote` group by `vw_farmaco_estoque_lote`.`id_farmaco`,`vw_farmaco_estoque_lote`.`id_cidade` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_farmaco_lote_vencimento_proximo`
--

/*!50001 DROP VIEW IF EXISTS `vw_farmaco_lote_vencimento_proximo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_farmaco_lote_vencimento_proximo` AS select `l`.`id_lote` AS `id_lote`,`l`.`id_farmaco` AS `id_farmaco`,`f`.`nome_comercial` AS `nome_comercial`,`l`.`numero_lote` AS `numero_lote`,`l`.`data_validade` AS `data_validade`,(to_days(`l`.`data_validade`) - to_days(curdate())) AS `dias_para_vencer`,`e`.`id_cidade` AS `id_cidade`,`e`.`estoque_lote` AS `estoque_lote` from ((`farmaco_lote` `l` join `vw_farmaco_estoque_lote` `e` on((`e`.`id_lote` = `l`.`id_lote`))) join `farmaco` `f` on((`f`.`id_farmaco` = `l`.`id_farmaco`))) where ((`l`.`data_validade` >= curdate()) and ((to_days(`l`.`data_validade`) - to_days(curdate())) <= 60) and (`e`.`estoque_lote` > 0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_farmaco_risco_sanitario`
--

/*!50001 DROP VIEW IF EXISTS `vw_farmaco_risco_sanitario`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_farmaco_risco_sanitario` AS select `f`.`id_farmaco` AS `id_farmaco`,`f`.`nome_comercial` AS `nome_comercial`,`f`.`principio_ativo` AS `principio_ativo`,`fl`.`id_lote` AS `id_lote`,`fl`.`numero_lote` AS `numero_lote`,`fl`.`data_validade` AS `data_validade`,`fn_dias_para_vencimento`(`fl`.`data_validade`) AS `dias_para_vencer`,(case when (`fn_dias_para_vencimento`(`fl`.`data_validade`) < 0) then 'VENCIDO' when (`fn_dias_para_vencimento`(`fl`.`data_validade`) <= 30) then 'CRITICO' when (`fn_dias_para_vencimento`(`fl`.`data_validade`) <= 90) then 'ALERTA' else 'OK' end) AS `nivel_risco` from (`farmaco_lote` `fl` join `farmaco` `f` on((`f`.`id_farmaco` = `fl`.`id_farmaco`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_fila_atendimento`
--

/*!50001 DROP VIEW IF EXISTS `vw_fila_atendimento`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_fila_atendimento` AS select `a`.`id_atendimento` AS `id_atendimento`,`a`.`protocolo` AS `protocolo`,`p`.`nome_completo` AS `nome_completo`,`a`.`status_atendimento` AS `status_atendimento`,`l`.`nome` AS `local` from ((`atendimento` `a` join `pessoa` `p` on((`p`.`id_pessoa` = `a`.`id_pessoa`))) join `local_atendimento` `l` on((`l`.`id_local` = `a`.`id_local_atual`))) where (`a`.`status_atendimento` in ('ABERTO','EM_ATENDIMENTO','EM_OBSERVACAO')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_fila_enfermagem`
--

/*!50001 DROP VIEW IF EXISTS `vw_fila_enfermagem`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_fila_enfermagem` AS select `oa`.`id` AS `id_ordem`,`oa`.`id_ffa` AS `id_ffa`,`oa`.`tipo_ordem` AS `tipo_ordem`,`oa`.`prioridade` AS `prioridade`,json_unquote(json_extract(`oa`.`payload_clinico`,'$.descricao')) AS `descricao`,json_extract(`oa`.`payload_clinico`,'$.frequencia') AS `frequencia`,`oa`.`iniciado_em` AS `iniciado_em` from `ordem_assistencial` `oa` where ((`oa`.`status` = 'ATIVA') and (`oa`.`tipo_ordem` in ('MEDICACAO','CUIDADO','DIETA','OXIGENIO'))) order by `oa`.`prioridade` desc,`oa`.`iniciado_em` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_fila_farmacia`
--

/*!50001 DROP VIEW IF EXISTS `vw_fila_farmacia`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_fila_farmacia` AS select `oa`.`id` AS `id_ordem`,`oa`.`id_ffa` AS `id_ffa`,json_unquote(json_extract(`oa`.`payload_clinico`,'$.medicamento')) AS `medicamento`,json_extract(`oa`.`payload_clinico`,'$.dose') AS `dose`,json_extract(`oa`.`payload_clinico`,'$.via') AS `via`,`oa`.`prioridade` AS `prioridade`,`oa`.`iniciado_em` AS `iniciado_em` from `ordem_assistencial` `oa` where ((`oa`.`status` = 'ATIVA') and (`oa`.`tipo_ordem` = 'MEDICACAO')) order by `oa`.`prioridade` desc,`oa`.`iniciado_em` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_fila_operacional_atual`
--

/*!50001 DROP VIEW IF EXISTS `vw_fila_operacional_atual`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_fila_operacional_atual` AS select `f`.`id_fila` AS `id_fila`,`f`.`id_ffa` AS `id_ffa`,`f`.`tipo` AS `tipo`,`f`.`substatus` AS `substatus`,`f`.`prioridade` AS `prioridade`,`f`.`data_entrada` AS `data_entrada`,`f`.`data_inicio` AS `data_inicio`,`f`.`data_fim` AS `data_fim`,`f`.`id_responsavel` AS `id_responsavel`,`u`.`login` AS `responsavel_login`,`f`.`id_local` AS `id_local`,`l`.`nome` AS `local_nome`,`f`.`observacao` AS `observacao` from ((`fila_operacional` `f` left join `usuario` `u` on((`u`.`id_usuario` = `f`.`id_responsavel`))) left join `local_atendimento` `l` on((`l`.`id_local` = `f`.`id_local`))) where (`f`.`substatus` <> 'FINALIZADO') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_historico_ordens_assistenciais`
--

/*!50001 DROP VIEW IF EXISTS `vw_historico_ordens_assistenciais`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_historico_ordens_assistenciais` AS select `oa`.`id` AS `id`,`oa`.`id_ffa` AS `id_ffa`,`oa`.`tipo_ordem` AS `tipo_ordem`,`oa`.`status` AS `status`,`oa`.`criado_por` AS `criado_por`,`oa`.`iniciado_em` AS `iniciado_em`,`oa`.`encerrado_em` AS `encerrado_em` from `ordem_assistencial` `oa` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_observacoes_ffa`
--

/*!50001 DROP VIEW IF EXISTS `vw_observacoes_ffa`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_observacoes_ffa` AS select `o`.`id` AS `id`,`o`.`tipo` AS `tipo`,`o`.`contexto` AS `contexto`,`o`.`texto` AS `texto`,`o`.`criado_em` AS `criado_em`,coalesce(`p`.`nome_social`,`p`.`nome_completo`) AS `autor`,`u`.`login` AS `autor_login` from ((`observacoes_eventos` `o` join `usuario` `u` on((`u`.`id_usuario` = `o`.`id_usuario`))) join `pessoa` `p` on((`p`.`id_pessoa` = `u`.`id_pessoa`))) where (`o`.`entidade` = 'FFA') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_ordens_assistenciais_ativas`
--

/*!50001 DROP VIEW IF EXISTS `vw_ordens_assistenciais_ativas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_ordens_assistenciais_ativas` AS select `oa`.`id` AS `id_ordem`,`oa`.`id_ffa` AS `id_ffa`,`oa`.`tipo_ordem` AS `tipo_ordem`,`oa`.`prioridade` AS `prioridade`,`oa`.`status` AS `status`,`oa`.`payload_clinico` AS `payload_clinico`,`oa`.`criado_por` AS `criado_por`,`oa`.`iniciado_em` AS `iniciado_em`,`f`.`status` AS `status_ffa` from (`ordem_assistencial` `oa` join `ffa` `f` on((`f`.`id` = `oa`.`id_ffa`))) where (`oa`.`status` = 'ATIVA') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_ordens_medicas`
--

/*!50001 DROP VIEW IF EXISTS `vw_ordens_medicas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_ordens_medicas` AS select `oa`.`id` AS `id_ordem`,`oa`.`id_ffa` AS `id_ffa`,`oa`.`tipo_ordem` AS `tipo_ordem`,`oa`.`status` AS `status`,`oa`.`prioridade` AS `prioridade`,`oa`.`payload_clinico` AS `payload_clinico`,`oa`.`iniciado_em` AS `iniciado_em`,`oa`.`encerrado_em` AS `encerrado_em` from `ordem_assistencial` `oa` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_pacientes_internados`
--

/*!50001 DROP VIEW IF EXISTS `vw_pacientes_internados`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_pacientes_internados` AS select `i`.`id_internacao` AS `id_internacao`,`a`.`id_atendimento` AS `id_atendimento`,`p`.`nome_completo` AS `paciente`,`l`.`identificacao` AS `leito`,`i`.`tipo` AS `tipo`,`i`.`data_entrada` AS `data_entrada`,`i`.`status` AS `status` from (((`internacao` `i` join `atendimento` `a` on((`a`.`id_ffa` = `i`.`id_ffa`))) join `pessoa` `p` on((`p`.`id_pessoa` = `a`.`id_pessoa`))) join `leito` `l` on((`l`.`id_leito` = `i`.`id_leito`))) where (`i`.`status` = 'ATIVA') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_chamadas_ativas`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_chamadas_ativas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `vw_painel_chamadas_ativas` AS select `s`.`id` AS `id_senha`,concat(`s`.`prefixo`,convert(lpad(`s`.`numero`,3,'0') using utf8mb4)) AS `senha`,`s`.`tipo_atendimento` AS `tipo_atendimento`,`s`.`status` AS `status`,`s`.`prioridade` AS `prioridade`,`s`.`origem` AS `origem`,`s`.`guiche_chamada` AS `local_chamada`,`s`.`id_usuario_chamada` AS `id_usuario_chamada`,`s`.`chamada_em` AS `chamada_em`,`s`.`atendida_em` AS `atendida_em` from `senhas` `s` where ((`s`.`chamada_em` is not null) and (`s`.`status` in ('CHAMADA','EM_ATENDIMENTO_RECEPCAO'))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_perfil_permissoes_v2`
--

/*!50001 DROP VIEW IF EXISTS `vw_perfil_permissoes_v2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_perfil_permissoes_v2` AS select `pp`.`id_perfil` AS `id_perfil`,`p`.`id_permissao` AS `id_permissao`,`p`.`codigo` AS `permissao_codigo` from (`perfil_permissao` `pp` join `permissao` `p` on((`p`.`id_permissao` = `pp`.`id_permissao`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_procedimentos_pendentes`
--

/*!50001 DROP VIEW IF EXISTS `vw_procedimentos_pendentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_procedimentos_pendentes` AS select `p`.`id_procedimento` AS `id_procedimento`,`p`.`id_ffa` AS `id_ffa`,`p`.`tipo` AS `tipo`,`p`.`status` AS `status`,`p`.`prioridade` AS `prioridade`,`p`.`criado_em` AS `criado_em` from `ffa_procedimento` `p` where (`p`.`status` in ('SOLICITADO','EM_FILA','EM_EXECUCAO')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_produtividade_medica_diaria`
--

/*!50001 DROP VIEW IF EXISTS `vw_produtividade_medica_diaria`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_produtividade_medica_diaria` AS select `pe`.`id_unidade` AS `id_unidade`,`pe`.`id_usuario` AS `id_usuario`,cast(`pe`.`ocorrido_em` as date) AS `dia`,sum((case when (`pe`.`tipo` = 'INICIO_ATENDIMENTO') then 1 else 0 end)) AS `atendimentos_iniciados`,sum((case when (`pe`.`tipo` = 'FIM_ATENDIMENTO') then 1 else 0 end)) AS `atendimentos_finalizados`,sum((case when (`pe`.`tipo` = 'EVOLUCAO') then 1 else 0 end)) AS `evolucoes`,sum((case when (`pe`.`tipo` = 'PRESCRICAO') then 1 else 0 end)) AS `prescricoes` from `produtividade_evento` `pe` group by `pe`.`id_unidade`,`pe`.`id_usuario`,cast(`pe`.`ocorrido_em` as date) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_solicitacoes_exame_pendentes`
--

/*!50001 DROP VIEW IF EXISTS `vw_solicitacoes_exame_pendentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_solicitacoes_exame_pendentes` AS select `se`.`id_solicitacao` AS `id_solicitacao`,`se`.`status` AS `status`,`se`.`solicitado_em` AS `solicitado_em`,`sp`.`codigo` AS `codigo_sigpat`,`sp`.`descricao` AS `descricao`,`sp`.`setor_execucao` AS `setor_execucao`,`f`.`id` AS `id_ffa`,`pe`.`nome_completo` AS `paciente` from ((((`solicitacao_exame` `se` join `sigpat_procedimento` `sp` on((`sp`.`id_sigpat` = `se`.`id_sigpat`))) join `ffa` `f` on((`f`.`id` = `se`.`id_atendimento`))) join `paciente` `pa` on((`pa`.`id` = `f`.`id_paciente`))) join `pessoa` `pe` on((`pe`.`id_pessoa` = `pa`.`id_pessoa`))) where (`se`.`status` in ('SOLICITADO','EM_ANALISE')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_totem_plantao_ativo`
--

/*!50001 DROP VIEW IF EXISTS `vw_totem_plantao_ativo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_totem_plantao_ativo` AS select `p`.`id` AS `id`,`p`.`tipo_plantao` AS `tipo_plantao`,`p`.`nome_medico` AS `nome_medico`,`p`.`inicio_plantao` AS `inicio_plantao`,`p`.`fim_plantao` AS `fim_plantao` from `plantao` `p` where ((`p`.`ativo` = 1) and (now() between `p`.`inicio_plantao` and `p`.`fim_plantao`)) order by field(`p`.`tipo_plantao`,'EMERGENCIA','PEDIATRIA','CLINICO'),`p`.`nome_medico` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_usuario_identidade`
--

/*!50001 DROP VIEW IF EXISTS `vw_usuario_identidade`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_usuario_identidade` AS select `u`.`id_usuario` AS `id_usuario`,`u`.`login` AS `login`,`p`.`nome_completo` AS `nome_completo`,`u`.`ativo` AS `ativo` from (`usuario` `u` join `pessoa` `p` on((`p`.`id_pessoa` = `u`.`id_pessoa`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_usuario_perfis_front`
--

/*!50001 DROP VIEW IF EXISTS `vw_usuario_perfis_front`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_usuario_perfis_front` AS select `us`.`id_usuario` AS `id_usuario`,(case when (`p`.`nome` = 'MASTER') then 'ADMIN_MASTER' else `p`.`nome` end) AS `perfil` from (`usuario_sistema` `us` join `perfil` `p` on((`p`.`id_perfil` = `us`.`id_perfil`))) where (`us`.`ativo` = 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_usuario_perfis_v2`
--

/*!50001 DROP VIEW IF EXISTS `vw_usuario_perfis_v2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_usuario_perfis_v2` AS select `us`.`id_usuario` AS `id_usuario`,`us`.`id_sistema` AS `id_sistema`,`us`.`id_perfil` AS `id_perfil` from `usuario_sistema` `us` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_usuario_permissoes`
--

/*!50001 DROP VIEW IF EXISTS `vw_usuario_permissoes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_usuario_permissoes` AS select `us`.`id_usuario` AS `id_usuario`,(case when (`pe`.`nome` = 'MASTER') then 'ADMIN_MASTER' else `pe`.`nome` end) AS `perfil`,`pr`.`id_permissao` AS `id_permissao`,`pr`.`codigo` AS `permissao_codigo`,`pr`.`descricao` AS `permissao_descricao` from (((`usuario_sistema` `us` join `perfil` `pe` on((`pe`.`id_perfil` = `us`.`id_perfil`))) join `perfil_permissao` `pp` on((`pp`.`id_perfil` = `pe`.`id_perfil`))) join `permissao` `pr` on((`pr`.`id_permissao` = `pp`.`id_permissao`))) where (`us`.`ativo` = 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_usuario_sistemas`
--

/*!50001 DROP VIEW IF EXISTS `vw_usuario_sistemas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_usuario_sistemas` AS select `u`.`id_usuario` AS `id_usuario`,`u`.`login` AS `login`,`s`.`id_sistema` AS `id_sistema`,`s`.`nome` AS `sistema`,`p`.`id_perfil` AS `id_perfil`,`p`.`nome` AS `perfil` from (((`usuario` `u` join `usuario_sistema` `us` on(((`us`.`id_usuario` = `u`.`id_usuario`) and (`us`.`ativo` = 1)))) join `sistema` `s` on(((`s`.`id_sistema` = `us`.`id_sistema`) and (`s`.`ativo` = 1)))) join `perfil` `p` on((`p`.`id_perfil` = `us`.`id_perfil`))) where (`u`.`ativo` = 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-26  3:31:39
