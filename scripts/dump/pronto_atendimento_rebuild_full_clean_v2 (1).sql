-- HIS/PA - REBUILD FULL (GENERATED)
-- Source: AtendimentoOfflineAlpha.zip (scripts/dump/pronto_atendimento.sql)
-- Generated: 2026-01-26 07:30:11

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';

DROP DATABASE IF EXISTS `pronto_atendimento`;
CREATE DATABASE `pronto_atendimento` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
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


--
-- Table structure for table `fila_senha`
--

DROP TABLE IF EXISTS `fila_senha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fila_senha` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `senha` bigint NOT NULL,
  `id_paciente` bigint DEFAULT NULL,
  `prioridade_recepcao` enum('PADRAO','IDOSO','CRONICO') COLLATE utf8mb4_general_ci DEFAULT 'PADRAO',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `senha` (`senha`),
  KEY `idx_fila_senha_paciente` (`id_paciente`),
  CONSTRAINT `fila_senha_ibfk_1` FOREIGN KEY (`senha`) REFERENCES `senhas` (`id`),
  CONSTRAINT `fila_senha_ibfk_2` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fila_senha`
--


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
  PRIMARY KEY (`id_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa`
--


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
) ENGINE=InnoDB AUTO_INCREMENT=354 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Refresh tokens de autenticação com rotação e revogação';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_refresh`
--


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

    UPDATE senhas
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
    INSERT INTO usuario (nome, login, senha_hash, criado_em)
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

-- Dump completed on 2026-01-26  0:09:36


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- END OF REBUILD SCRIPT
