CREATE DATABASE  IF NOT EXISTS `pronto_atendimento` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `pronto_atendimento`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: pronto_atendimento
-- ------------------------------------------------------
-- Server version	8.0.45

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
  `tipo` enum('PAI','MAE','RESPONSAVEL_LEGAL','ACOMPANHANTE','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `observacao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `dose` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
-- Table structure for table `administracao_medicacao_ordem`
--

DROP TABLE IF EXISTS `administracao_medicacao_ordem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administracao_medicacao_ordem` (
  `id_administracao` bigint NOT NULL AUTO_INCREMENT,
  `id_item` bigint NOT NULL,
  `quantidade` decimal(10,2) NOT NULL,
  `realizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` bigint NOT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `id_aprazamento` bigint DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `status` enum('ADMINISTRADO','NAO_ADMINISTRADO','ESTORNADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ADMINISTRADO',
  PRIMARY KEY (`id_administracao`),
  KEY `idx_admin_item` (`id_item`),
  KEY `idx_admin_user` (`id_usuario`),
  CONSTRAINT `fk_admin_item` FOREIGN KEY (`id_item`) REFERENCES `ordem_assistencial_item` (`id_item`),
  CONSTRAINT `fk_admin_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administracao_medicacao_ordem`
--

LOCK TABLES `administracao_medicacao_ordem` WRITE;
/*!40000 ALTER TABLE `administracao_medicacao_ordem` DISABLE KEYS */;
/*!40000 ALTER TABLE `administracao_medicacao_ordem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agenda_disponibilidade`
--

DROP TABLE IF EXISTS `agenda_disponibilidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agenda_disponibilidade` (
  `id_disponibilidade` bigint NOT NULL AUTO_INCREMENT,
  `id_sistema` bigint NOT NULL,
  `id_unidade` bigint NOT NULL,
  `id_profissional` bigint NOT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `tipo` enum('ATENDIMENTO','BLOQUEIO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `inicio_em` datetime NOT NULL,
  `fim_em` datetime NOT NULL,
  `recorrente` tinyint(1) NOT NULL DEFAULT '0',
  `dia_semana` tinyint DEFAULT NULL COMMENT '0=Dom .. 6=Sab (quando recorrente=1)',
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario_criador` bigint NOT NULL,
  `id_sessao_criador` bigint DEFAULT NULL,
  PRIMARY KEY (`id_disponibilidade`),
  KEY `ix_disp_prof` (`id_profissional`,`inicio_em`,`fim_em`),
  KEY `ix_disp_ctx` (`id_sistema`,`id_unidade`,`inicio_em`),
  KEY `ix_disp_local` (`id_local_operacional`,`inicio_em`),
  KEY `fk_disp_unidade` (`id_unidade`),
  KEY `fk_disp_user` (`id_usuario_criador`),
  KEY `fk_disp_sessao` (`id_sessao_criador`),
  CONSTRAINT `fk_disp_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
  CONSTRAINT `fk_disp_prof` FOREIGN KEY (`id_profissional`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `fk_disp_sessao` FOREIGN KEY (`id_sessao_criador`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_disp_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
  CONSTRAINT `fk_disp_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
  CONSTRAINT `fk_disp_user` FOREIGN KEY (`id_usuario_criador`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agenda_disponibilidade`
--

LOCK TABLES `agenda_disponibilidade` WRITE;
/*!40000 ALTER TABLE `agenda_disponibilidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `agenda_disponibilidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agendamentos`
--

DROP TABLE IF EXISTS `agendamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agendamentos` (
  `id_agendamento` bigint NOT NULL AUTO_INCREMENT,
  `id_sistema` bigint NOT NULL,
  `id_unidade` bigint NOT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `id_profissional` bigint DEFAULT NULL,
  `id_paciente` bigint DEFAULT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_senha` bigint DEFAULT NULL,
  `id_servico` bigint NOT NULL,
  `inicio_em` datetime NOT NULL,
  `fim_em` datetime NOT NULL,
  `status` enum('MARCADO','CHECKIN','EM_ATENDIMENTO','CONCLUIDO','CANCELADO','NAO_COMPARECEU') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'MARCADO',
  `origem` enum('RECEPCAO','TELEFONE','INTERNET','RETORNO','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'RECEPCAO',
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `criado_por` bigint NOT NULL,
  `id_sessao_criacao` bigint DEFAULT NULL,
  PRIMARY KEY (`id_agendamento`),
  KEY `ix_ag_prof` (`id_profissional`,`inicio_em`),
  KEY `ix_ag_local` (`id_local_operacional`,`inicio_em`),
  KEY `ix_ag_paciente` (`id_paciente`,`inicio_em`),
  KEY `ix_ag_ffa` (`id_ffa`,`inicio_em`),
  KEY `ix_ag_senha` (`id_senha`),
  KEY `ix_ag_ctx_inicio` (`id_sistema`,`id_unidade`,`inicio_em`),
  KEY `fk_ag_unidade` (`id_unidade`),
  KEY `fk_ag_servico` (`id_servico`),
  KEY `fk_ag_criado_por` (`criado_por`),
  KEY `fk_ag_sessao` (`id_sessao_criacao`),
  CONSTRAINT `fk_ag_criado_por` FOREIGN KEY (`criado_por`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `fk_ag_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_ag_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
  CONSTRAINT `fk_ag_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`),
  CONSTRAINT `fk_ag_prof` FOREIGN KEY (`id_profissional`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `fk_ag_senha` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`),
  CONSTRAINT `fk_ag_servico` FOREIGN KEY (`id_servico`) REFERENCES `servico_agendamento` (`id_servico`),
  CONSTRAINT `fk_ag_sessao` FOREIGN KEY (`id_sessao_criacao`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_ag_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
  CONSTRAINT `fk_ag_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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
  `id_agendamento` bigint NOT NULL,
  `tipo` enum('CRIADO','REAGENDADO','CANCELADO','CHECKIN','INICIADO','CONCLUIDO','NAO_COMPARECEU','OBSERVACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `detalhe` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `de_status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `para_status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` bigint NOT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  KEY `ix_agev_agendamento` (`id_agendamento`,`criado_em`),
  KEY `fk_agev_usuario` (`id_usuario`),
  KEY `fk_agev_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_agev_agendamento` FOREIGN KEY (`id_agendamento`) REFERENCES `agendamentos` (`id_agendamento`),
  CONSTRAINT `fk_agev_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_agev_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agendamentos_eventos`
--

LOCK TABLES `agendamentos_eventos` WRITE;
/*!40000 ALTER TABLE `agendamentos_eventos` DISABLE KEYS */;
/*!40000 ALTER TABLE `agendamentos_eventos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alerta`
--

DROP TABLE IF EXISTS `alerta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerta` (
  `id_alerta` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `titulo` varchar(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `mensagem` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `gpat` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_paciente` bigint DEFAULT NULL,
  `id_unidade` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `severidade` enum('INFO','ATENCAO','ALTA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATENCAO',
  `status` enum('ABERTO','LIDO','EM_ATENDIMENTO','RESOLVIDO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ABERTO',
  `entidade_origem` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_origem` bigint DEFAULT NULL,
  `id_sessao_usuario_origem` bigint DEFAULT NULL,
  `id_usuario_origem` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_alerta`),
  KEY `idx_alerta_codigo_status` (`codigo`,`status`),
  KEY `idx_alerta_unidade_local` (`id_unidade`,`id_local_operacional`,`status`),
  KEY `idx_alerta_gpat` (`gpat`),
  KEY `idx_alerta_paciente` (`id_paciente`),
  KEY `idx_alerta_ffa` (`id_ffa`),
  KEY `fk_alerta_sessao` (`id_sessao_usuario_origem`),
  KEY `fk_alerta_usuario` (`id_usuario_origem`),
  CONSTRAINT `fk_alerta_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_alerta_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`),
  CONSTRAINT `fk_alerta_sessao` FOREIGN KEY (`id_sessao_usuario_origem`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_alerta_usuario` FOREIGN KEY (`id_usuario_origem`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerta`
--

LOCK TABLES `alerta` WRITE;
/*!40000 ALTER TABLE `alerta` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alerta_consumo`
--

DROP TABLE IF EXISTS `alerta_consumo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerta_consumo` (
  `id_alerta_consumo` bigint NOT NULL AUTO_INCREMENT,
  `id_alerta` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `acao` enum('LIDO','ASSUMIDO','RESOLVIDO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'LIDO',
  `observacao` varchar(240) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_alerta_consumo`),
  UNIQUE KEY `ux_alerta_consumo` (`id_alerta`,`id_usuario`),
  KEY `idx_alerta_consumo_alerta` (`id_alerta`),
  KEY `idx_alerta_consumo_usuario` (`id_usuario`),
  KEY `idx_alerta_consumo_acao` (`acao`),
  KEY `fk_alerta_consumo_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_alerta_consumo_alerta` FOREIGN KEY (`id_alerta`) REFERENCES `alerta` (`id_alerta`) ON DELETE CASCADE,
  CONSTRAINT `fk_alerta_consumo_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_alerta_consumo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerta_consumo`
--

LOCK TABLES `alerta_consumo` WRITE;
/*!40000 ALTER TABLE `alerta_consumo` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerta_consumo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alerta_destinatario`
--

DROP TABLE IF EXISTS `alerta_destinatario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerta_destinatario` (
  `id_alerta_destinatario` bigint NOT NULL AUTO_INCREMENT,
  `id_alerta` bigint NOT NULL,
  `tipo_destino` enum('USUARIO','PERFIL','PAINEL','LOCAL','UNIDADE','SISTEMA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `codigo_destino` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_destino` bigint DEFAULT NULL,
  `status` enum('NOVO','LIDO','EM_ATENDIMENTO','RESOLVIDO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'NOVO',
  `lido_em` datetime DEFAULT NULL,
  `id_sessao_usuario_acao` bigint DEFAULT NULL,
  `id_usuario_acao` bigint DEFAULT NULL,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_alerta_destinatario`),
  KEY `idx_ad_alerta` (`id_alerta`),
  KEY `idx_ad_tipo_codigo_status` (`tipo_destino`,`codigo_destino`,`status`),
  KEY `idx_ad_tipo_id_status` (`tipo_destino`,`id_destino`,`status`),
  KEY `idx_ad_lido_em` (`lido_em`),
  KEY `fk_ad_sessao` (`id_sessao_usuario_acao`),
  KEY `fk_ad_usuario` (`id_usuario_acao`),
  CONSTRAINT `fk_ad_alerta` FOREIGN KEY (`id_alerta`) REFERENCES `alerta` (`id_alerta`) ON DELETE CASCADE,
  CONSTRAINT `fk_ad_sessao` FOREIGN KEY (`id_sessao_usuario_acao`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_ad_usuario` FOREIGN KEY (`id_usuario_acao`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerta_destinatario`
--

LOCK TABLES `alerta_destinatario` WRITE;
/*!40000 ALTER TABLE `alerta_destinatario` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerta_destinatario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alerta_regra`
--

DROP TABLE IF EXISTS `alerta_regra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerta_regra` (
  `id_alerta_regra` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_sistema_destino` bigint NOT NULL,
  `id_perfil_destino` int NOT NULL,
  `id_unidade` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `observacao` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_alerta_regra`),
  UNIQUE KEY `ux_alerta_regra_codigo_dest` (`codigo`,`id_sistema_destino`,`id_perfil_destino`,`id_unidade`,`id_local_operacional`),
  KEY `idx_alerta_regra_codigo` (`codigo`),
  KEY `idx_alerta_regra_dest` (`id_sistema_destino`,`id_perfil_destino`,`ativo`),
  KEY `fk_alerta_regra_perfil` (`id_perfil_destino`),
  KEY `fk_alerta_regra_unidade` (`id_unidade`),
  KEY `fk_alerta_regra_local` (`id_local_operacional`),
  CONSTRAINT `fk_alerta_regra_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
  CONSTRAINT `fk_alerta_regra_perfil` FOREIGN KEY (`id_perfil_destino`) REFERENCES `perfil` (`id_perfil`),
  CONSTRAINT `fk_alerta_regra_sistema` FOREIGN KEY (`id_sistema_destino`) REFERENCES `sistema` (`id_sistema`),
  CONSTRAINT `fk_alerta_regra_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerta_regra`
--

LOCK TABLES `alerta_regra` WRITE;
/*!40000 ALTER TABLE `alerta_regra` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerta_regra` ENABLE KEYS */;
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
  `origem` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Compra, doação, transferência',
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
  `destino` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Setor, sala, manutenção',
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
-- Table structure for table `almoxarifado_central`
--

DROP TABLE IF EXISTS `almoxarifado_central`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `almoxarifado_central` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` int NOT NULL,
  `lote` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `validade` date DEFAULT NULL,
  `quantidade_atual` int NOT NULL,
  `quantidade_minima` int DEFAULT '100',
  `nfe_chave_acesso` varchar(44) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_unidade` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_validade` (`validade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `almoxarifado_central`
--

LOCK TABLES `almoxarifado_central` WRITE;
/*!40000 ALTER TABLE `almoxarifado_central` DISABLE KEYS */;
/*!40000 ALTER TABLE `almoxarifado_central` ENABLE KEYS */;
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
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
-- Table structure for table `assinatura_digital_documentos`
--

DROP TABLE IF EXISTS `assinatura_digital_documentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assinatura_digital_documentos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_registro_clinico` bigint NOT NULL,
  `tipo_documento` enum('EVOLUCAO','RECEITA','LAUDO','ALTA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hash_assinatura` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `certificado_serial` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_assinatura` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assinatura_digital_documentos`
--

LOCK TABLES `assinatura_digital_documentos` WRITE;
/*!40000 ALTER TABLE `assinatura_digital_documentos` DISABLE KEYS */;
/*!40000 ALTER TABLE `assinatura_digital_documentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assinatura_digital_prontuario`
--

DROP TABLE IF EXISTS `assinatura_digital_prontuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assinatura_digital_prontuario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa_evolucao` bigint NOT NULL COMMENT 'FK para atendimento_evolucao',
  `hash_assinatura` text NOT NULL,
  `certificado_serial` varchar(255) DEFAULT NULL,
  `data_assinatura` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ass_evolucao` (`id_ffa_evolucao`),
  KEY `idx_ass_usuario` (`id_usuario`),
  CONSTRAINT `fk_ass_digital_evolucao` FOREIGN KEY (`id_ffa_evolucao`) REFERENCES `atendimento_evolucao` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ass_digital_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assinatura_digital_prontuario`
--

LOCK TABLES `assinatura_digital_prontuario` WRITE;
/*!40000 ALTER TABLE `assinatura_digital_prontuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `assinatura_digital_prontuario` ENABLE KEYS */;
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
-- Table structure for table `assistencia_social_evento`
--

DROP TABLE IF EXISTS `assistencia_social_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assistencia_social_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_as` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `tipo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `detalhe` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_usuario` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_as_evento_as` (`id_as`,`criado_em`),
  KEY `idx_as_evento_sessao` (`id_sessao_usuario`,`criado_em`),
  KEY `idx_as_evento_usuario` (`id_usuario`,`criado_em`),
  CONSTRAINT `fk_as_evento_as` FOREIGN KEY (`id_as`) REFERENCES `assistencia_social_atendimento` (`id_as`),
  CONSTRAINT `fk_as_evento_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_as_evento_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assistencia_social_evento`
--

LOCK TABLES `assistencia_social_evento` WRITE;
/*!40000 ALTER TABLE `assistencia_social_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencia_social_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atendimento`
--

DROP TABLE IF EXISTS `atendimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento` (
  `id_atendimento` bigint NOT NULL AUTO_INCREMENT,
  `protocolo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_pessoa` bigint NOT NULL,
  `id_unidade` int DEFAULT NULL,
  `id_senha` bigint DEFAULT NULL,
  `status_atendimento` enum('ABERTO','EM_ATENDIMENTO','EM_OBSERVACAO','INTERNADO','FINALIZADO','NAO_ATENDIDO','RETORNO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_local_atual` bigint DEFAULT NULL,
  `id_sala_atual` int DEFAULT NULL,
  `id_especialidade` int DEFAULT NULL,
  `data_abertura` datetime DEFAULT CURRENT_TIMESTAMP,
  `data_fechamento` datetime DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ABERTO',
  PRIMARY KEY (`id_atendimento`),
  UNIQUE KEY `protocolo` (`protocolo`),
  KEY `id_pessoa` (`id_pessoa`),
  KEY `id_local_atual` (`id_local_atual`),
  KEY `id_sala_atual` (`id_sala_atual`),
  KEY `id_especialidade` (`id_especialidade`),
  KEY `idx_status_local` (`status_atendimento`,`id_local_atual`),
  KEY `fk_atendimento_senhas` (`id_senha`),
  KEY `idx_atendimento_datas` (`data_abertura`,`data_fechamento`),
  KEY `idx_atend_pessoa` (`id_pessoa`),
  CONSTRAINT `atendimento_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`),
  CONSTRAINT `atendimento_ibfk_3` FOREIGN KEY (`id_local_atual`) REFERENCES `local_atendimento` (`id_local`),
  CONSTRAINT `atendimento_ibfk_4` FOREIGN KEY (`id_sala_atual`) REFERENCES `sala` (`id_sala`),
  CONSTRAINT `atendimento_ibfk_5` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`),
  CONSTRAINT `fk_atendimento_senhas` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento`
--

LOCK TABLES `atendimento` WRITE;
/*!40000 ALTER TABLE `atendimento` DISABLE KEYS */;
INSERT INTO `atendimento` VALUES (1,'20260128061710',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:17:10',NULL,'ABERTO'),(2,'20260128061737',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:17:37',NULL,'ABERTO'),(3,'20260128062016',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:20:16',NULL,'ABERTO'),(4,'20260128062042',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:20:42',NULL,'ABERTO'),(5,'20260128062125',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:21:25',NULL,'ABERTO'),(6,'20260128062157',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:21:57',NULL,'ABERTO'),(7,'20260128062220',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:22:20',NULL,'ABERTO'),(8,'20260128062254',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:22:54',NULL,'ABERTO'),(9,'20260128062606',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:26:06',NULL,'ABERTO'),(10,'20249999',NULL,31,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:29:42',NULL,'ABERTO'),(11,'20260128063019',NULL,33,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:30:20',NULL,'ABERTO'),(12,'20260128063119',NULL,33,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:31:19',NULL,'ABERTO'),(13,'GPAT-20260215-0000000001',12,34,2,1,'ABERTO',NULL,NULL,NULL,'2026-02-15 04:31:10',NULL,'ABERTO');
/*!40000 ALTER TABLE `atendimento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atendimento_balanco_hidrico`
--

DROP TABLE IF EXISTS `atendimento_balanco_hidrico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_balanco_hidrico` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `tipo_movimentacao` enum('ENTRADA','SAIDA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `volume_ml` int NOT NULL,
  `id_usuario_registro` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_balanco_hidrico`
--

LOCK TABLES `atendimento_balanco_hidrico` WRITE;
/*!40000 ALTER TABLE `atendimento_balanco_hidrico` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_balanco_hidrico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atendimento_checagem`
--

DROP TABLE IF EXISTS `atendimento_checagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_checagem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_prescricao` bigint NOT NULL,
  `horario_planejado` datetime NOT NULL,
  `horario_executado` datetime DEFAULT NULL,
  `id_enfermeiro` bigint DEFAULT NULL,
  `status` enum('PENDENTE','REALIZADO','RECUSADO','ATRASADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDENTE',
  `motivo_recusa` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_chec_presc` (`id_prescricao`),
  KEY `idx_checagem_horarios` (`horario_planejado`,`status`),
  CONSTRAINT `fk_chec_presc` FOREIGN KEY (`id_prescricao`) REFERENCES `atendimento_prescricao` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_checagem`
--

LOCK TABLES `atendimento_checagem` WRITE;
/*!40000 ALTER TABLE `atendimento_checagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_checagem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atendimento_desfecho`
--

DROP TABLE IF EXISTS `atendimento_desfecho`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_desfecho` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `tipo_desfecho` enum('ALTA_MEDICA','ALTA_A_PEDIDO','TRANSFERENCIA','OBITO','EVASAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_usuario_alta` bigint NOT NULL,
  `sumario_alta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `data_alta` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_desfecho_atend` (`id_atendimento`),
  CONSTRAINT `fk_desfecho_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_desfecho`
--

LOCK TABLES `atendimento_desfecho` WRITE;
/*!40000 ALTER TABLE `atendimento_desfecho` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_desfecho` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atendimento_diagnosticos`
--

DROP TABLE IF EXISTS `atendimento_diagnosticos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_diagnosticos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `codigo_cid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('PRINCIPAL','SECUNDARIO','HIPOTESE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_diag_atend` (`id_atendimento`),
  CONSTRAINT `fk_diag_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_diagnosticos`
--

LOCK TABLES `atendimento_diagnosticos` WRITE;
/*!40000 ALTER TABLE `atendimento_diagnosticos` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_diagnosticos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atendimento_escalas_risco`
--

DROP TABLE IF EXISTS `atendimento_escalas_risco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_escalas_risco` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `escala_tipo` enum('MORSE_QUEDA','BRADEN_LESÃO_PELE','GLASGOW') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pontuacao_total` int NOT NULL,
  `classificacao_resultado` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_avaliacao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_escala_atend` (`id_atendimento`),
  CONSTRAINT `fk_escala_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_escalas_risco`
--

LOCK TABLES `atendimento_escalas_risco` WRITE;
/*!40000 ALTER TABLE `atendimento_escalas_risco` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_escalas_risco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atendimento_evolucao`
--

DROP TABLE IF EXISTS `atendimento_evolucao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_evolucao` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `tipo_profissional` enum('MEDICO','ENFERMEIRO','TECNICO','OUTROS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `texto_evolucao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `hash_seguranca` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_evol_atend` (`id_atendimento`),
  CONSTRAINT `fk_evol_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_evolucao`
--

LOCK TABLES `atendimento_evolucao` WRITE;
/*!40000 ALTER TABLE `atendimento_evolucao` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_evolucao` ENABLE KEYS */;
UNLOCK TABLES;

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
  `estado_geral` enum('BOM','REGULAR','GRAVE','MUITO_GRAVE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nivel_consciencia` enum('LUCIDO','ORIENTADO','CONFUSO','SONOLENTO','TORPOROSO','COMA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mucosas` enum('CORADAS','HIPOCORADAS','DESIDRATADAS','ICTERICAS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `estado_nutricional` enum('EUTROFICO','CAQUETICO','OBESO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edema` enum('AUSENTE','MEMBROS_INFERIORES','ANASARCA','FACIAL') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `observacoes_adicionais` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
  `motivo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `tipo` enum('OBSERVACAO','INTERNACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_leito` int DEFAULT NULL,
  `data_inicio` datetime DEFAULT CURRENT_TIMESTAMP,
  `data_fim` datetime DEFAULT NULL,
  `status` enum('ATIVO','ALTA','TRANSFERIDO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ATIVO',
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
-- Table structure for table `atendimento_pedidos_exame`
--

DROP TABLE IF EXISTS `atendimento_pedidos_exame`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_pedidos_exame` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_medico_solicitante` bigint NOT NULL,
  `id_exame_tuss` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status_exame` enum('SOLICITADO','COLETADO','EM_ANALISE','LAUDADO','ENTREGUE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'SOLICITADO',
  `prioridade` enum('ELETIVO','URGENTE','EMERGENCIA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ELETIVO',
  `data_solicitacao` datetime DEFAULT CURRENT_TIMESTAMP,
  `url_laudo_pacs` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pedido_tuss` (`id_exame_tuss`),
  CONSTRAINT `fk_pedido_tuss` FOREIGN KEY (`id_exame_tuss`) REFERENCES `tabela_tuss` (`codigo_tuss`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_pedidos_exame`
--

LOCK TABLES `atendimento_pedidos_exame` WRITE;
/*!40000 ALTER TABLE `atendimento_pedidos_exame` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_pedidos_exame` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atendimento_prescricao`
--

DROP TABLE IF EXISTS `atendimento_prescricao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_prescricao` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_medico` bigint NOT NULL,
  `medicamento` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dose` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `frequencia` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `data_prescricao` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('ATIVO','SUSPENSO','CONCLUIDO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ATIVO',
  PRIMARY KEY (`id`),
  KEY `fk_presc_atend` (`id_atendimento`),
  KEY `idx_prescricao_status` (`status`),
  CONSTRAINT `fk_presc_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_prescricao`
--

LOCK TABLES `atendimento_prescricao` WRITE;
/*!40000 ALTER TABLE `atendimento_prescricao` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_prescricao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atendimento_recepcao`
--

DROP TABLE IF EXISTS `atendimento_recepcao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_recepcao` (
  `id_atendimento` bigint NOT NULL,
  `tipo_atendimento` enum('CLINICO','PEDIATRICO','EMERGENCIA','EXAME_EXTERNO','MEDICACAO_EXTERNA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `chegada` enum('MEIOS_PROPRIOS','AMBULANCIA','POLICIA','OUTROS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `prioridade` enum('AUTISTA','CRIANCA_COLO','GESTANTE','IDOSO','NORMAL') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'NORMAL',
  `motivo_procura` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `destino_inicial` enum('TRIAGEM','MEDICO','EMERGENCIA','RX','MEDICACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
-- Table structure for table `atendimento_sinais_vitais`
--

DROP TABLE IF EXISTS `atendimento_sinais_vitais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_sinais_vitais` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_usuario_registro` bigint NOT NULL,
  `pa_sistolica` int DEFAULT NULL,
  `pa_diastolica` int DEFAULT NULL,
  `frequencia_cardiaca` int DEFAULT NULL,
  `frequencia_respiratoria` int DEFAULT NULL,
  `temperatura` decimal(4,1) DEFAULT NULL,
  `saturacao_o2` int DEFAULT NULL,
  `hgt` int DEFAULT NULL,
  `data_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_sv_atendimento` (`id_atendimento`),
  CONSTRAINT `fk_sv_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_sinais_vitais`
--

LOCK TABLES `atendimento_sinais_vitais` WRITE;
/*!40000 ALTER TABLE `atendimento_sinais_vitais` DISABLE KEYS */;
INSERT INTO `atendimento_sinais_vitais` VALUES (2,3,5,120,80,NULL,NULL,36.5,98,NULL,'2026-01-28 06:20:16'),(3,4,5,120,80,NULL,NULL,36.5,98,NULL,'2026-01-28 06:20:42'),(4,5,5,120,80,NULL,NULL,36.5,98,NULL,'2026-01-28 06:21:25'),(5,6,5,120,80,NULL,NULL,36.5,98,NULL,'2026-01-28 06:21:57');
/*!40000 ALTER TABLE `atendimento_sinais_vitais` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atendimento_sumario_alta`
--

DROP TABLE IF EXISTS `atendimento_sumario_alta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atendimento_sumario_alta` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_medico_alta` bigint NOT NULL,
  `motivo_internacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `resumo_clinico` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `procedimentos_realizados` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `orientacoes_pos_alta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `medicamentos_receitados` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `data_alta` datetime DEFAULT CURRENT_TIMESTAMP,
  `assinatura_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sumario_atend` (`id_atendimento`),
  CONSTRAINT `fk_sumario_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento_sumario_alta`
--

LOCK TABLES `atendimento_sumario_alta` WRITE;
/*!40000 ALTER TABLE `atendimento_sumario_alta` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_sumario_alta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria_acesso`
--

DROP TABLE IF EXISTS `auditoria_acesso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_acesso` (
  `id_auditoria_acesso` bigint NOT NULL AUTO_INCREMENT,
  `id_sessao_usuario` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `recurso` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `acao` enum('READ','SEARCH','EXPORT','PRINT','DOWNLOAD','VIEW') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'READ',
  `detalhe` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `ip` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria_acesso`),
  KEY `idx_aud_acesso_sessao` (`id_sessao_usuario`),
  KEY `idx_aud_acesso_usuario` (`id_usuario`),
  KEY `idx_aud_acesso_recurso` (`recurso`),
  KEY `idx_aud_acesso_data` (`criado_em`),
  CONSTRAINT `fk_aud_acesso_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_acesso`
--

LOCK TABLES `auditoria_acesso` WRITE;
/*!40000 ALTER TABLE `auditoria_acesso` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_acesso` ENABLE KEYS */;
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
  `acao` enum('ENTRADA','SAIDA','AJUSTE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
-- Table structure for table `auditoria_erro`
--

DROP TABLE IF EXISTS `auditoria_erro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_erro` (
  `id_auditoria_erro` bigint NOT NULL AUTO_INCREMENT,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `rotina` varchar(128) DEFAULT NULL,
  `sqlstate` varchar(10) DEFAULT NULL,
  `errno` int DEFAULT NULL,
  `mensagem` text,
  `contexto` text,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria_erro`),
  KEY `idx_aud_erro_criado` (`criado_em`),
  KEY `idx_aud_erro_rotina` (`rotina`),
  KEY `idx_aud_erro_sessao` (`id_sessao_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_erro`
--

LOCK TABLES `auditoria_erro` WRITE;
/*!40000 ALTER TABLE `auditoria_erro` DISABLE KEYS */;
INSERT INTO `auditoria_erro` VALUES (1,2,'sp_senha_emitir','42000',1305,'PROCEDURE pronto_atendimento.sp_assert_true does not exist','Falha ao emitir senha','2026-02-13 06:08:14'),(2,2,'sp_senha_emitir','42000',1305,'PROCEDURE pronto_atendimento.sp_assert_true does not exist','Falha ao emitir senha','2026-02-13 06:15:18'),(3,3,'sp_recepcao_iniciar_complementacao','42S22',1054,'Unknown column \'inicio_complementacao_em\' in \'field list\'','Falha ao iniciar complementação','2026-02-13 06:37:56'),(4,3,'sp_recepcao_complementar_e_abrir_ffa','42S22',1054,'Unknown column \'s.tipo\' in \'field list\'','Falha ao complementar e abrir FFA','2026-02-13 06:38:13'),(5,3,'sp_operacao_encaminhar','45000',1644,'[NOT_FOUND] Falha de asserção.','Falha ao encaminhar (fila_operacional)','2026-02-13 06:38:31'),(6,123,'sp_recepcao_iniciar_complementacao','45000',1644,'[SESSAO] Sessão inválida/inativa/expirada.','Falha ao iniciar complementação','2026-02-15 03:13:12'),(7,3,'sp_recepcao_complementar_e_abrir_ffa','42S22',1054,'Unknown column \'criado_em\' in \'field list\'','Falha ao complementar e abrir FFA','2026-02-15 03:58:23'),(8,3,'sp_recepcao_iniciar_complementacao','42S22',1054,'Unknown column \'atualizado_em\' in \'field list\'','Falha ao iniciar complementação','2026-02-15 04:11:00'),(9,3,'sp_recepcao_iniciar_complementacao','42S22',1054,'Unknown column \'atualizado_em\' in \'field list\'','Falha ao iniciar complementação','2026-02-15 04:11:21'),(10,3,'sp_operacao_encaminhar','42S22',1054,'Unknown column \'fo.status\' in \'where clause\'','Falha ao encaminhar','2026-02-15 04:56:44'),(11,3,'sp_painel_filtro_locais_seed','(n/a)',0,'(n/a)','Falha ao seedar filtro de locais do painel','2026-02-15 05:49:12'),(12,3,'sp_painel_filtro_locais_seed','(n/a)',0,'(n/a)','Falha ao seedar filtro de locais do painel','2026-02-15 05:49:20');
/*!40000 ALTER TABLE `auditoria_erro` ENABLE KEYS */;
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
  `acao` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `nivel_risco` enum('OK','CRITICO','VENCIDO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `id_usuario` bigint DEFAULT NULL,
  `tabela` varchar(50) DEFAULT NULL,
  `id_usuario_espelho` bigint DEFAULT NULL COMMENT 'Denormalização para performance',
  PRIMARY KEY (`id_auditoria`),
  KEY `idx_aud_sessao` (`id_sessao_usuario`),
  KEY `idx_aud_entidade` (`entidade`,`id_entidade`),
  KEY `idx_auditoria_sessao_data` (`id_sessao_usuario`,`criado_em`),
  KEY `idx_auditoria_entidade` (`entidade`,`id_entidade`,`criado_em`),
  CONSTRAINT `fk_aud_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_evento`
--

LOCK TABLES `auditoria_evento` WRITE;
/*!40000 ALTER TABLE `auditoria_evento` DISABLE KEYS */;
INSERT INTO `auditoria_evento` VALUES (5,NULL,'sessao_usuario',123,'SESSAO_REVOGADA','Logout forçado via SQL (sem sessão ativa)','2026-02-13 04:23:51',7,'sessao_usuario',7),(6,2,'sessao_usuario',2,'SESSAO_ABERTA','Sessão aberta para usuario=5 sistema=1 unidade=2 local=1','2026-02-13 05:10:01',5,'sessao_usuario',5),(7,2,'sql',NULL,'ERRO_SQL','ROTINA=sp_senha_emitir | SQLSTATE=(n/a) | ERRNO=(n/a) | MSG=(n/a) | CTX=Falha ao emitir senha','2026-02-13 05:34:23',5,'auditoria_evento',5),(8,2,'SQL',NULL,'ERRO_SQL','ROTINA=sp_senha_emitir | SQLSTATE=42000 | ERRNO=1305 | MSG=PROCEDURE pronto_atendimento.sp_assert_true does not exist | CTX=Falha ao emitir senha','2026-02-13 06:08:14',NULL,NULL,NULL),(9,2,'SQL',NULL,'ERRO_SQL','ROTINA=sp_senha_emitir | SQLSTATE=42000 | ERRNO=1305 | MSG=PROCEDURE pronto_atendimento.sp_assert_true does not exist | CTX=Falha ao emitir senha','2026-02-13 06:15:18',NULL,NULL,NULL),(10,2,'SENHA',3,'EMITIR','codigo=A001 | origem=TOTEM | tipo=CLINICO | lane=ADULTO | local=1','2026-02-13 06:17:42',5,'senhas',5),(11,3,'sessao_usuario',3,'SESSAO_ABERTA','Sessão aberta para usuario=5 sistema=1 unidade=2 local=1','2026-02-13 06:19:13',5,'sessao_usuario',5),(12,3,'SENHA',4,'EMITIR','codigo=A002 | origem=TOTEM | tipo=CLINICO | lane=ADULTO | local=1','2026-02-13 06:19:25',5,'senhas',5),(13,3,'SENHA',3,'CHAMAR','codigo=A001 | local=1 | lane=ADULTO','2026-02-13 06:19:40',5,'senhas',5),(14,3,'SQL',NULL,'ERRO_SQL','ROTINA=sp_recepcao_iniciar_complementacao | SQLSTATE=42S22 | ERRNO=1054 | MSG=Unknown column \'inicio_complementacao_em\' in \'field list\' | CTX=Falha ao iniciar complementação','2026-02-13 06:37:56',NULL,NULL,NULL),(15,3,'SQL',NULL,'ERRO_SQL','ROTINA=sp_recepcao_complementar_e_abrir_ffa | SQLSTATE=42S22 | ERRNO=1054 | MSG=Unknown column \'s.tipo\' in \'field list\' | CTX=Falha ao complementar e abrir FFA','2026-02-13 06:38:13',NULL,NULL,NULL),(16,3,'SQL',NULL,'ERRO_SQL','ROTINA=sp_operacao_encaminhar | SQLSTATE=45000 | ERRNO=1644 | MSG=[NOT_FOUND] Falha de asserção. | CTX=Falha ao encaminhar (fila_operacional)','2026-02-13 06:38:31',NULL,NULL,NULL),(18,3,'SENHA',4,'INICIAR_COMPLEMENTACAO','codigo=A002 | local_operacional=1','2026-02-15 03:36:47',5,'senhas',5),(19,3,'SENHA',3,'INICIAR_COMPLEMENTACAO','codigo=A001 | local_operacional=1','2026-02-15 03:38:24',5,'senhas',5),(20,3,'SQL',NULL,'ERRO_SQL','ROTINA=sp_recepcao_complementar_e_abrir_ffa | SQLSTATE=42S22 | ERRNO=1054 | MSG=Unknown column \'criado_em\' in \'field list\' | CTX=Falha ao complementar e abrir FFA','2026-02-15 03:58:23',NULL,NULL,NULL),(21,3,'SQL',NULL,'ERRO_SQL','ROTINA=sp_recepcao_iniciar_complementacao | SQLSTATE=42S22 | ERRNO=1054 | MSG=Unknown column \'atualizado_em\' in \'field list\' | CTX=Falha ao iniciar complementação','2026-02-15 04:11:00',NULL,NULL,NULL),(22,3,'SQL',NULL,'ERRO_SQL','ROTINA=sp_recepcao_iniciar_complementacao | SQLSTATE=42S22 | ERRNO=1054 | MSG=Unknown column \'atualizado_em\' in \'field list\' | CTX=Falha ao iniciar complementação','2026-02-15 04:11:21',NULL,NULL,NULL),(23,3,'SENHA',1,'INICIAR_COMPLEMENTACAO','codigo=A001 | local_operacional=1','2026-02-15 04:24:39',5,'senhas',5),(24,3,'SENHA',1,'INICIAR_COMPLEMENTACAO','codigo=A001 | local_operacional=1','2026-02-15 04:27:57',5,'senhas',5),(25,3,'SENHA',1,'INICIAR_COMPLEMENTACAO','codigo=A001 | local_operacional=1','2026-02-15 04:30:13',5,'senhas',5),(26,3,'SENHA',1,'INICIAR_COMPLEMENTACAO','codigo=A001 | local_operacional=1','2026-02-15 04:31:10',5,'senhas',5),(27,3,'PESSOA',34,'CRIAR','nome=PACIENTE TESTE','2026-02-15 04:31:10',5,'pessoa',5),(28,3,'ATENDIMENTO',13,'ABRIR','protocolo=GPAT-20260215-0000000001|id_pessoa=34|id_senha=1','2026-02-15 04:31:10',5,'atendimento',5),(29,3,'FFA',12,'ABRIR','gpat=GPAT-20260215-0000000001|id_paciente=8|id_senha=1','2026-02-15 04:31:10',5,'ffa',5),(30,3,'SENHA',1,'COMPLEMENTAR_E_ABRIR_FFA','codigo=A001|id_ffa=12|id_paciente=8','2026-02-15 04:31:10',5,'senhas',5),(31,3,'SQL',NULL,'ERRO_SQL','ROTINA=sp_operacao_encaminhar | SQLSTATE=42S22 | ERRNO=1054 | MSG=Unknown column \'fo.status\' in \'where clause\' | CTX=Falha ao encaminhar','2026-02-15 04:56:44',NULL,NULL,NULL),(32,3,'SQL',NULL,'ERRO_SQL','ROTINA=sp_painel_filtro_locais_seed | SQLSTATE=(n/a) | ERRNO=0 | MSG=(n/a) | CTX=Falha ao seedar filtro de locais do painel','2026-02-15 05:49:12',NULL,NULL,NULL),(33,3,'SQL',NULL,'ERRO_SQL','ROTINA=sp_painel_filtro_locais_seed | SQLSTATE=(n/a) | ERRNO=0 | MSG=(n/a) | CTX=Falha ao seedar filtro de locais do painel','2026-02-15 05:49:20',NULL,NULL,NULL),(34,3,'PAINEL',1,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:06:19',5,'painel_config',5),(35,3,'PAINEL',2,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:06:19',5,'painel_config',5),(36,3,'PAINEL',78,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:06:19',5,'painel_config',5),(37,3,'PAINEL',150,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:06:19',5,'painel_config',5),(38,3,'PAINEL',1,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:26:42',5,'painel_config',5),(39,3,'PAINEL',2,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:26:42',5,'painel_config',5),(40,3,'PAINEL',23,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:26:42',5,'painel_config',5),(41,3,'PAINEL',247,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:26:42',5,'painel_config',5),(42,3,'PAINEL',24,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:26:42',5,'painel_config',5),(43,3,'PAINEL',7,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:26:42',5,'painel_config',5),(44,3,'PAINEL',221,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:26:42',5,'painel_config',5),(45,3,'PAINEL',78,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:26:42',5,'painel_config',5),(46,3,'PAINEL',79,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:26:42',5,'painel_config',5),(47,3,'PAINEL',150,'CONFIG_SET','chave=FILTRO_LOCAIS_CODIGOS_JSON | tipo=JSON','2026-02-15 06:26:42',5,'painel_config',5);
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
  `motivo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `chamado_por` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `tipo_evento` enum('CRIACAO','STATUS','LAYOUT','CHAMADA_MEDICA','SOLICITACAO_RX','SOLICITACAO_MEDICACAO','ALTA_MEDICA','TRANSFERENCIA','INTERNACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `acao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `acao` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
-- Table structure for table `auditoria_mestre`
--

DROP TABLE IF EXISTS `auditoria_mestre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_mestre` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_sessao_usuario` bigint NOT NULL,
  `dominio` enum('FILA','ASSISTENCIAL','FINANCEIRO','ESTOQUE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `acao` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tabela_afetada` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_registro` bigint DEFAULT NULL,
  `valor_anterior` json DEFAULT NULL,
  `valor_novo` json DEFAULT NULL,
  `motivo_alteracao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `data_evento` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_audit_sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_audit_sessao_usuario` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_mestre`
--

LOCK TABLES `auditoria_mestre` WRITE;
/*!40000 ALTER TABLE `auditoria_mestre` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_mestre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria_visualizacao_prontuario`
--

DROP TABLE IF EXISTS `auditoria_visualizacao_prontuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_visualizacao_prontuario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `id_atendimento` bigint NOT NULL,
  `ip_acesso` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `contexto` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_visualizacao_prontuario`
--

LOCK TABLES `auditoria_visualizacao_prontuario` WRITE;
/*!40000 ALTER TABLE `auditoria_visualizacao_prontuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_visualizacao_prontuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `caixa`
--

DROP TABLE IF EXISTS `caixa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `caixa` (
  `id_caixa` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `id_local_operacional` bigint NOT NULL,
  `status` enum('ABERTO','FECHADO') NOT NULL DEFAULT 'FECHADO',
  `aberto_em` datetime DEFAULT NULL,
  `fechado_em` datetime DEFAULT NULL,
  `aberto_por` bigint DEFAULT NULL,
  `fechado_por` bigint DEFAULT NULL,
  PRIMARY KEY (`id_caixa`),
  KEY `idx_caixa_status` (`status`),
  KEY `fk_caixa_unidade` (`id_unidade`),
  KEY `fk_caixa_localop` (`id_local_operacional`),
  KEY `fk_caixa_aberto_por` (`aberto_por`),
  KEY `fk_caixa_fechado_por` (`fechado_por`),
  CONSTRAINT `fk_caixa_aberto_por` FOREIGN KEY (`aberto_por`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `fk_caixa_fechado_por` FOREIGN KEY (`fechado_por`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `fk_caixa_localop` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
  CONSTRAINT `fk_caixa_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `caixa`
--

LOCK TABLES `caixa` WRITE;
/*!40000 ALTER TABLE `caixa` DISABLE KEYS */;
/*!40000 ALTER TABLE `caixa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `caixa_evento`
--

DROP TABLE IF EXISTS `caixa_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `caixa_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_caixa` bigint NOT NULL,
  `tipo` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` bigint DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  KEY `idx_ce_caixa` (`id_caixa`,`criado_em`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `caixa_evento`
--

LOCK TABLES `caixa_evento` WRITE;
/*!40000 ALTER TABLE `caixa_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `caixa_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_acidente_trabalho`
--

DROP TABLE IF EXISTS `cat_acidente_trabalho`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_acidente_trabalho` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_pessoa_trabalhador` bigint NOT NULL,
  `data_acidente` datetime NOT NULL,
  `tipo_acidente` enum('TIPICO','TRAJETO','DOENCA_OCUPACIONAL','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao_acidente` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `agente_causador` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `parte_corpo` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cid10_relacionado` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_cat` enum('ABERTA','EMITIDA','ENVIADA','ARQUIVADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ABERTA',
  `numero_cat` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `id_usuario_criador` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_cat_atendimento` (`id_atendimento`),
  KEY `idx_cat_trabalhador` (`id_pessoa_trabalhador`),
  KEY `idx_cat_status` (`status_cat`),
  KEY `fk_cat_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_cat_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `fk_cat_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_cat_trabalhador` FOREIGN KEY (`id_pessoa_trabalhador`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_acidente_trabalho`
--

LOCK TABLES `cat_acidente_trabalho` WRITE;
/*!40000 ALTER TABLE `cat_acidente_trabalho` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_acidente_trabalho` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_acidente_trabalho_evento`
--

DROP TABLE IF EXISTS `cat_acidente_trabalho_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_acidente_trabalho_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_cat` bigint NOT NULL,
  `tipo_evento` enum('CRIACAO','ALTERACAO','MUDANCA_STATUS','EXPORTACAO','ERRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status_anterior` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_novo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `detalhes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_sessao_usuario` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_cate_cat` (`id_cat`),
  KEY `fk_cate_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_cate_cat` FOREIGN KEY (`id_cat`) REFERENCES `cat_acidente_trabalho` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cate_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_acidente_trabalho_evento`
--

LOCK TABLES `cat_acidente_trabalho_evento` WRITE;
/*!40000 ALTER TABLE `cat_acidente_trabalho_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_acidente_trabalho_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_evento`
--

DROP TABLE IF EXISTS `cat_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_evento` (
  `id_cat_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_cat` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `evento` varchar(50) NOT NULL,
  `payload_json` json DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cat_evento`),
  KEY `ix_cat_evento_cat` (`id_cat`),
  KEY `ix_cat_evento_evt` (`evento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_evento`
--

LOCK TABLES `cat_evento` WRITE;
/*!40000 ALTER TABLE `cat_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_notificacao`
--

DROP TABLE IF EXISTS `cat_notificacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_notificacao` (
  `id_cat` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_gpat` bigint NOT NULL,
  `id_pedido_item` bigint DEFAULT NULL,
  `id_usuario_responsavel` bigint NOT NULL,
  `status` enum('ABERTA','EM_PREENCHIMENTO','ENVIADA','CANCELADA','CONCLUIDA') NOT NULL DEFAULT 'ABERTA',
  `data_evento` datetime DEFAULT NULL,
  `local_evento` varchar(255) DEFAULT NULL,
  `ocupacao` varchar(120) DEFAULT NULL,
  `empresa` varchar(255) DEFAULT NULL,
  `cnpj` varchar(20) DEFAULT NULL,
  `detalhes` text,
  `protocolo_interno` varchar(50) DEFAULT NULL,
  `protocolo_externo` varchar(80) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_cat`),
  KEY `ix_cat_ffa` (`id_ffa`),
  KEY `ix_cat_gpat` (`id_gpat`),
  KEY `ix_cat_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_notificacao`
--

LOCK TABLES `cat_notificacao` WRITE;
/*!40000 ALTER TABLE `cat_notificacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_notificacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_regra_item`
--

DROP TABLE IF EXISTS `cat_regra_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_regra_item` (
  `id_cat_regra` bigint NOT NULL AUTO_INCREMENT,
  `codigo_sigtap` varchar(30) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cat_regra`),
  UNIQUE KEY `uk_cat_regra_sigtap` (`codigo_sigtap`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_regra_item`
--

LOCK TABLES `cat_regra_item` WRITE;
/*!40000 ALTER TABLE `cat_regra_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_regra_item` ENABLE KEYS */;
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
  `origem` enum('PA','INTERNACAO','AMBULATORIO','ADMINISTRATIVO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_problema` enum('ELETRICO','HIDRAULICO','AR_CONDICIONADO','EQUIPAMENTO','ESTRUTURAL','TI','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `prioridade` enum('BAIXA','MEDIA','ALTA','CRITICA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'MEDIA',
  `status` enum('ABERTO','EM_ATENDIMENTO','AGUARDANDO_PECA','RESOLVIDO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ABERTO',
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
  `nome` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `uf` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `codigo_ibge` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_cidade`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cidade`
--

LOCK TABLES `cidade` WRITE;
/*!40000 ALTER TABLE `cidade` DISABLE KEYS */;
INSERT INTO `cidade` VALUES (2,'São Paulo','SP',NULL,1),(3,'Poá','SP',NULL,1);
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
  `cor` enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tempo_max` int DEFAULT NULL,
  `descricao` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `id_cliente` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `documento` varchar(30) DEFAULT NULL,
  `telefone` varchar(30) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `uk_cliente_doc` (`documento`),
  KEY `idx_cliente_nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `codigo_externo_map`
--

DROP TABLE IF EXISTS `codigo_externo_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `codigo_externo_map` (
  `id_map` bigint NOT NULL AUTO_INCREMENT,
  `id_codigo` bigint NOT NULL,
  `dominio` enum('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO') COLLATE utf8mb4_general_ci NOT NULL,
  `sistema_externo` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `codigo_externo` varchar(80) COLLATE utf8mb4_general_ci NOT NULL,
  `modo_cadastro` enum('AUTO','MANUAL') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'MANUAL',
  `observacao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `payload` json DEFAULT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_map`),
  UNIQUE KEY `uk_externo` (`dominio`,`sistema_externo`,`codigo_externo`),
  KEY `idx_map_codigo` (`id_codigo`),
  KEY `idx_map_lookup` (`dominio`,`sistema_externo`),
  KEY `fk_map_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_map_codigo` FOREIGN KEY (`id_codigo`) REFERENCES `codigo_universal` (`id_codigo`),
  CONSTRAINT `fk_map_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `codigo_externo_map`
--

LOCK TABLES `codigo_externo_map` WRITE;
/*!40000 ALTER TABLE `codigo_externo_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `codigo_externo_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `codigo_externo_vinculo`
--

DROP TABLE IF EXISTS `codigo_externo_vinculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `codigo_externo_vinculo` (
  `id_vinculo` bigint NOT NULL AUTO_INCREMENT,
  `tipo` varchar(30) NOT NULL,
  `sistema_externo` varchar(50) NOT NULL,
  `codigo_externo` varchar(80) NOT NULL,
  `id_codigo_universal` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `observacao` varchar(255) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_vinculo`),
  UNIQUE KEY `uk_vinculo` (`tipo`,`sistema_externo`,`codigo_externo`),
  KEY `ix_vinculo_codigo` (`id_codigo_universal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `codigo_externo_vinculo`
--

LOCK TABLES `codigo_externo_vinculo` WRITE;
/*!40000 ALTER TABLE `codigo_externo_vinculo` DISABLE KEYS */;
/*!40000 ALTER TABLE `codigo_externo_vinculo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `codigo_prefixo_config`
--

DROP TABLE IF EXISTS `codigo_prefixo_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `codigo_prefixo_config` (
  `id_prefixo` bigint NOT NULL AUTO_INCREMENT,
  `dominio` enum('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO') COLLATE utf8mb4_general_ci NOT NULL,
  `prefixo_5` char(5) COLLATE utf8mb4_general_ci NOT NULL,
  `id_unidade` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `id_laboratorio` bigint DEFAULT NULL,
  `ativo` tinyint NOT NULL DEFAULT '1',
  `observacao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_prefixo`),
  UNIQUE KEY `uk_prefixo_escopo` (`dominio`,`prefixo_5`,`id_unidade`,`id_local_operacional`,`id_laboratorio`),
  KEY `idx_prefixo_lookup` (`dominio`,`ativo`,`id_unidade`,`id_local_operacional`,`id_laboratorio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `codigo_prefixo_config`
--

LOCK TABLES `codigo_prefixo_config` WRITE;
/*!40000 ALTER TABLE `codigo_prefixo_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `codigo_prefixo_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `codigo_prefixo_regra`
--

DROP TABLE IF EXISTS `codigo_prefixo_regra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `codigo_prefixo_regra` (
  `id_regra` bigint NOT NULL AUTO_INCREMENT,
  `tipo` varchar(30) NOT NULL,
  `id_unidade` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `prefixo5` char(5) NOT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `observacao` varchar(255) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_regra`),
  UNIQUE KEY `uk_prefixo_tipo_ctx` (`tipo`,`id_unidade`,`id_local_operacional`),
  KEY `ix_prefixo_tipo` (`tipo`),
  KEY `ix_prefixo_prefixo` (`prefixo5`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `codigo_prefixo_regra`
--

LOCK TABLES `codigo_prefixo_regra` WRITE;
/*!40000 ALTER TABLE `codigo_prefixo_regra` DISABLE KEYS */;
INSERT INTO `codigo_prefixo_regra` VALUES (1,'GPAT',NULL,NULL,'10000',1,'Prefixo padrão GPAT (ajuste por unidade/local)','2026-02-16 07:20:27',NULL),(2,'LAB',NULL,NULL,'30000',1,'Prefixo padrão LAB (ajuste por unidade/local)','2026-02-16 07:20:27',NULL),(3,'FARM_PRODUTO',NULL,NULL,'40000',1,'Prefixo padrão produto','2026-02-16 07:50:28',NULL),(4,'PDV',NULL,NULL,'41000',1,'Prefixo padrão venda PDV','2026-02-16 07:50:28',NULL),(5,'INVENTARIO',NULL,NULL,'42000',1,'Prefixo padrão inventário','2026-02-16 07:50:28',NULL),(6,'FAT',NULL,NULL,'43000',1,'Prefixo padrão faturamento','2026-02-16 07:50:28',NULL),(7,'GPAT',NULL,NULL,'10000',1,'Prefixo padrão GPAT (ajuste por unidade/local)','2026-02-17 10:32:12',NULL),(8,'LAB',NULL,NULL,'30000',1,'Prefixo padrão LAB (ajuste por unidade/local)','2026-02-17 10:32:12',NULL);
/*!40000 ALTER TABLE `codigo_prefixo_regra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `codigo_universal`
--

DROP TABLE IF EXISTS `codigo_universal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `codigo_universal` (
  `id_codigo` bigint NOT NULL AUTO_INCREMENT,
  `dominio` enum('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO') COLLATE utf8mb4_general_ci NOT NULL,
  `prefixo_5` char(5) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sequencia` int DEFAULT NULL,
  `codigo_interno` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `barcode` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `origem_interno` enum('AUTO','MANUAL') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'AUTO',
  `id_ffa` bigint DEFAULT NULL,
  `id_senha` bigint DEFAULT NULL,
  `id_paciente` bigint DEFAULT NULL,
  `id_produto` int DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `id_cliente` bigint DEFAULT NULL,
  `status` enum('ATIVO','CANCELADO','SUBSTITUIDO') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATIVO',
  `payload` json DEFAULT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_codigo`),
  UNIQUE KEY `uk_codigo_interno` (`codigo_interno`),
  UNIQUE KEY `uk_barcode` (`barcode`),
  UNIQUE KEY `uk_prefixo_seq` (`dominio`,`prefixo_5`,`sequencia`),
  KEY `idx_codigo_dom_status` (`dominio`,`status`,`criado_em`),
  KEY `idx_codigo_ffa` (`id_ffa`),
  KEY `idx_codigo_produto` (`id_produto`),
  KEY `idx_codigo_usuario` (`id_usuario`),
  KEY `fk_codigo_senha` (`id_senha`),
  KEY `fk_codigo_paciente` (`id_paciente`),
  KEY `fk_codigo_cliente` (`id_cliente`),
  KEY `fk_codigo_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_codigo_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  CONSTRAINT `fk_codigo_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_codigo_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`),
  CONSTRAINT `fk_codigo_produto` FOREIGN KEY (`id_produto`) REFERENCES `estoque_produtos` (`id`),
  CONSTRAINT `fk_codigo_senha` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`),
  CONSTRAINT `fk_codigo_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_codigo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `codigo_universal`
--

LOCK TABLES `codigo_universal` WRITE;
/*!40000 ALTER TABLE `codigo_universal` DISABLE KEYS */;
/*!40000 ALTER TABLE `codigo_universal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config_leitos`
--

DROP TABLE IF EXISTS `config_leitos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_leitos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `identificacao` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('OBSERVACAO','EMERGENCIA','INTERNACAO','ISOLAMENTO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_ocupacao` enum('LIVRE','OCUPADO','RESERVADO','HIGIENIZACAO','MANUTENCAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'LIVRE',
  `id_atendimento_atual` bigint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_leitos`
--

LOCK TABLES `config_leitos` WRITE;
/*!40000 ALTER TABLE `config_leitos` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_leitos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config_locais`
--

DROP TABLE IF EXISTS `config_locais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_locais` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('RECEPCAO','TRIAGEM','CONSULTORIO','EXAME','MEDICACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_locais`
--

LOCK TABLES `config_locais` WRITE;
/*!40000 ALTER TABLE `config_locais` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_locais` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config_sistema`
--

DROP TABLE IF EXISTS `config_sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_sistema` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `parametro` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `valor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_config_unid` (`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_sistema`
--

LOCK TABLES `config_sistema` WRITE;
/*!40000 ALTER TABLE `config_sistema` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_sistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuracao`
--

DROP TABLE IF EXISTS `configuracao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuracao` (
  `chave` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `valor` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
-- Table structure for table `conselho_profissional`
--

DROP TABLE IF EXISTS `conselho_profissional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conselho_profissional` (
  `id_conselho` int NOT NULL AUTO_INCREMENT,
  `sigla` varchar(10) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `uf` char(2) DEFAULT 'SP',
  PRIMARY KEY (`id_conselho`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conselho_profissional`
--

LOCK TABLES `conselho_profissional` WRITE;
/*!40000 ALTER TABLE `conselho_profissional` DISABLE KEYS */;
INSERT INTO `conselho_profissional` VALUES (1,'CRM','Conselho Regional de Medicina','SP'),(2,'COREM','Conselho Regional de Enfermagem','SP'),(3,'CREFITO','Conselho Regional de Fisioterapia','SP'),(4,'CRF','Conselho Regional de Farmácia','SP'),(5,'CRN','Conselho Regional de Nutrição','SP'),(6,'CRP','Conselho Regional de Psicologia','SP'),(7,'CRESS','Conselho Regional de Serviço Social','SP');
/*!40000 ALTER TABLE `conselho_profissional` ENABLE KEYS */;
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
  `origem` enum('FARMACIA','ALMOXARIFADO','MANUTENCAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_produto` bigint NOT NULL,
  `quantidade` decimal(10,2) NOT NULL,
  `usado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `registrado_por` bigint NOT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
  `unidade` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'UN',
  `consumido_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `registrado_por` bigint NOT NULL COMMENT 'Usuário da limpeza',
  `motivo` enum('ROTINA','REPOSICAO','CONTAMINACAO','INTERCORRENCIA','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ROTINA',
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
  `unidade` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('PORTA','EMERGENCIA','LEITO','EXECUCAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
-- Table structure for table `dispensacao_medicacao`
--

DROP TABLE IF EXISTS `dispensacao_medicacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dispensacao_medicacao` (
  `id_dispensacao` bigint NOT NULL AUTO_INCREMENT,
  `id_ordem` bigint NOT NULL,
  `id_item` bigint DEFAULT NULL,
  `id_farmaco` bigint NOT NULL,
  `id_lote` bigint NOT NULL,
  `quantidade` decimal(10,2) NOT NULL,
  `id_usuario_dispensador` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('ENTREGUE','ESTORNADO') DEFAULT 'ENTREGUE',
  `observacao` text,
  PRIMARY KEY (`id_dispensacao`),
  KEY `fk_disp_ordem` (`id_ordem`),
  KEY `fk_disp_lote` (`id_lote`),
  KEY `idx_disp_item` (`id_item`),
  CONSTRAINT `fk_disp_item` FOREIGN KEY (`id_item`) REFERENCES `ordem_assistencial_item` (`id_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dispensacao_medicacao`
--

LOCK TABLES `dispensacao_medicacao` WRITE;
/*!40000 ALTER TABLE `dispensacao_medicacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispensacao_medicacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documento_arquivo`
--

DROP TABLE IF EXISTS `documento_arquivo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documento_arquivo` (
  `id_documento` bigint NOT NULL,
  `formato` enum('PDF','XML','OUTRO') NOT NULL DEFAULT 'PDF',
  `mime_type` varchar(120) DEFAULT NULL,
  `nome_arquivo` varchar(200) DEFAULT NULL,
  `tamanho_bytes` bigint DEFAULT NULL,
  `sha256` char(64) DEFAULT NULL,
  `storage_uri` varchar(255) DEFAULT NULL,
  `conteudo_blob` longblob,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_documento`,`formato`),
  KEY `idx_doc_arq_sha` (`sha256`),
  CONSTRAINT `fk_doc_arq_documento` FOREIGN KEY (`id_documento`) REFERENCES `documento_emissao` (`id_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documento_arquivo`
--

LOCK TABLES `documento_arquivo` WRITE;
/*!40000 ALTER TABLE `documento_arquivo` DISABLE KEYS */;
/*!40000 ALTER TABLE `documento_arquivo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documento_emissao`
--

DROP TABLE IF EXISTS `documento_emissao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documento_emissao` (
  `id_documento` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint DEFAULT NULL,
  `id_paciente` bigint DEFAULT NULL,
  `id_senha` bigint DEFAULT NULL,
  `gpat` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo_documento` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `entidade_ref` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_ref` bigint DEFAULT NULL,
  `numero_documento` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hash_documento` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('GERADO','IMPRESSO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'GERADO',
  `id_sessao_usuario` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `id_unidade` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_documento`),
  UNIQUE KEY `ux_doc_tipo_ref` (`tipo_documento`,`entidade_ref`,`id_ref`),
  KEY `idx_doc_ffa` (`id_ffa`),
  KEY `idx_doc_paciente` (`id_paciente`),
  KEY `idx_doc_tipo` (`tipo_documento`),
  KEY `idx_doc_status` (`status`),
  KEY `idx_doc_gpat` (`gpat`),
  KEY `idx_doc_data` (`criado_em`),
  KEY `fk_doc_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_doc_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documento_emissao`
--

LOCK TABLES `documento_emissao` WRITE;
/*!40000 ALTER TABLE `documento_emissao` DISABLE KEYS */;
/*!40000 ALTER TABLE `documento_emissao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documento_emissao_evento`
--

DROP TABLE IF EXISTS `documento_emissao_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documento_emissao_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_documento` bigint NOT NULL,
  `tipo` enum('GERAR','IMPRIMIR','REIMPRIMIR','CANCELAR') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `detalhe` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_sessao_usuario` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_doc_ev_doc` (`id_documento`),
  KEY `idx_doc_ev_data` (`criado_em`),
  KEY `fk_doc_ev_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_doc_ev_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documento_emissao_evento`
--

LOCK TABLES `documento_emissao_evento` WRITE;
/*!40000 ALTER TABLE `documento_emissao_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `documento_emissao_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documento_tipo_config`
--

DROP TABLE IF EXISTS `documento_tipo_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documento_tipo_config` (
  `codigo` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `destino` enum('PACIENTE','FARMACIA','ENFERMAGEM','ADMIN','ARQUIVO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PACIENTE',
  `exige_farmaceutico` tinyint(1) NOT NULL DEFAULT '0',
  `template_codigo` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documento_tipo_config`
--

LOCK TABLES `documento_tipo_config` WRITE;
/*!40000 ALTER TABLE `documento_tipo_config` DISABLE KEYS */;
INSERT INTO `documento_tipo_config` VALUES ('ATESTADO','Atestado','PACIENTE',0,'ATEST',1,'2026-02-06 04:18:02'),('ENCAMINHAMENTO','Encaminhamento/Referência','PACIENTE',0,'ENC',1,'2026-02-06 04:18:02'),('MEDICACAO_INTERNA','Prescrição/Ordem de Medicação Interna (Enfermagem)','ENFERMAGEM',0,'MED_INT',1,'2026-02-06 04:18:02'),('RECEITA_CONTROLADO','Receita de Medicamento Controlado (exige farmacêutico)','FARMACIA',1,'RX_CTRL',1,'2026-02-06 04:18:02'),('RECEITUARIO_CASA','Receituário para Uso Domiciliar','PACIENTE',0,'RX_CASA',1,'2026-02-06 04:18:02'),('REGISTRO_ATENDIMENTO','Registro de Atendimento (dados paciente + médico + resumo)','PACIENTE',0,'REG_ATEND',1,'2026-02-06 04:18:02'),('SOLIC_EXAME','Solicitação de Exame','PACIENTE',0,'SOL_EX',1,'2026-02-06 04:18:02');
/*!40000 ALTER TABLE `documento_tipo_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enfermagem`
--

DROP TABLE IF EXISTS `enfermagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enfermagem` (
  `id_usuario` bigint NOT NULL,
  `coren` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `uf_coren` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('ENFERMEIRO','TECNICO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
-- Table structure for table `enfermagem_aprazamento`
--

DROP TABLE IF EXISTS `enfermagem_aprazamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enfermagem_aprazamento` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `medicamento` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `via_administracao` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `frequencia` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `horario_previsto` datetime NOT NULL,
  `horario_executado` datetime DEFAULT NULL,
  `id_usuario_execucao` bigint DEFAULT NULL,
  `status` enum('AGUARDANDO','REALIZADO','ATRASADO','SUSPENSO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'AGUARDANDO',
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`),
  KEY `idx_apraz_atend` (`id_atendimento`),
  KEY `idx_apraz_hora` (`horario_previsto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enfermagem_aprazamento`
--

LOCK TABLES `enfermagem_aprazamento` WRITE;
/*!40000 ALTER TABLE `enfermagem_aprazamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `enfermagem_aprazamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enfermagem_diagnosticos`
--

DROP TABLE IF EXISTS `enfermagem_diagnosticos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enfermagem_diagnosticos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `diagnostico_selecionado` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('HISTORICO','EXAME_FISICO','DIAGNOSTICO','PRESCRICAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_usuario` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ffa_diagnostico` (`id_ffa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enfermagem_diagnosticos`
--

LOCK TABLES `enfermagem_diagnosticos` WRITE;
/*!40000 ALTER TABLE `enfermagem_diagnosticos` DISABLE KEYS */;
/*!40000 ALTER TABLE `enfermagem_diagnosticos` ENABLE KEYS */;
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
  `lote` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `validade` date DEFAULT NULL,
  `id_usuario_entrada` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_fornecedor` bigint DEFAULT NULL,
  `numero_nota` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
-- Table structure for table `erro_catalogo`
--

DROP TABLE IF EXISTS `erro_catalogo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `erro_catalogo` (
  `code` varchar(80) NOT NULL,
  `severidade` enum('ERRO','AVISO') NOT NULL DEFAULT 'ERRO',
  `http_status` smallint NOT NULL DEFAULT '400',
  `mensagem_pt` varchar(255) NOT NULL,
  `ativo` tinyint NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `erro_catalogo`
--

LOCK TABLES `erro_catalogo` WRITE;
/*!40000 ALTER TABLE `erro_catalogo` DISABLE KEYS */;
INSERT INTO `erro_catalogo` VALUES ('ERRO_INTERNO','ERRO',500,'Erro interno do sistema.',1,'2026-02-01 06:30:30','2026-02-01 06:34:59'),('ERRO_LOCAL_DESTINO_INVALIDO','ERRO',400,'Local de destino inválido.',1,'2026-02-01 06:30:30','2026-02-01 06:34:59'),('ERRO_SENHA_FORA_CONTEXTO','ERRO',403,'Senha fora do contexto atual (sistema/unidade).',1,'2026-02-01 06:30:30','2026-02-01 06:34:59'),('ERRO_SENHA_FORA_LOCAL','ERRO',403,'Senha não pertence a este local/fila.',1,'2026-02-01 06:30:30','2026-02-01 06:34:59'),('ERRO_SENHA_NAO_ENCONTRADA','ERRO',404,'Senha não encontrada.',1,'2026-02-01 06:30:30','2026-02-01 06:34:59'),('ERRO_SENHA_SEM_VINCULO_FFA','ERRO',409,'Senha ainda não possui FFA vinculada.',1,'2026-02-01 06:30:30','2026-02-01 06:34:59'),('ERRO_SENHA_SEM_VINCULO_PACIENTE','ERRO',409,'Senha ainda não foi complementada na recepção (sem paciente).',1,'2026-02-01 06:30:30','2026-02-01 06:34:59'),('ERRO_SENHA_STATUS_INVALIDO','ERRO',409,'Ação não permitida para o status atual.',1,'2026-02-01 06:30:30','2026-02-01 06:34:59'),('ERRO_SESSAO_INVALIDA','ERRO',401,'Sessão inválida ou expirada.',1,'2026-02-01 06:30:30','2026-02-01 06:34:59'),('ERRO_SESSAO_LOCAL_INVALIDO','ERRO',400,'Local operacional inválido ou inativo.',1,'2026-02-01 06:30:30','2026-02-01 06:34:59'),('ERRO_SESSAO_SISTEMA_INVALIDO','ERRO',400,'Sistema inválido ou inativo.',1,'2026-02-01 06:30:30','2026-02-01 06:34:59'),('ERRO_SESSAO_UNIDADE_INVALIDA','ERRO',400,'Unidade inválida ou inativa.',1,'2026-02-01 06:30:30','2026-02-01 06:34:59'),('ERRO_SESSAO_USUARIO_INVALIDO','ERRO',403,'Usuário inválido ou inativo.',1,'2026-02-01 06:30:30','2026-02-01 06:34:59'),('ERRO_SQL','ERRO',500,'Erro interno do sistema.',1,'2026-02-01 06:30:30','2026-02-01 06:34:59');
/*!40000 ALTER TABLE `erro_catalogo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `escala_medica`
--

DROP TABLE IF EXISTS `escala_medica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `escala_medica` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario_medico` bigint NOT NULL,
  `id_unidade` bigint NOT NULL,
  `data_plantao` date NOT NULL,
  `turno` enum('MANHA','TARDE','NOITE','24H') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status_presenca` enum('PREVISTO','CONFIRMADO','FALTOU','SUBSTITUIDO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PREVISTO',
  `id_substituto` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_escala_dia` (`data_plantao`,`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `escala_medica`
--

LOCK TABLES `escala_medica` WRITE;
/*!40000 ALTER TABLE `escala_medica` DISABLE KEYS */;
/*!40000 ALTER TABLE `escala_medica` ENABLE KEYS */;
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
-- Table structure for table `escala_plantao_atual`
--

DROP TABLE IF EXISTS `escala_plantao_atual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `escala_plantao_atual` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `id_unidade` bigint NOT NULL,
  `id_setor` int DEFAULT NULL,
  `registro_profissional` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_inicio` datetime DEFAULT NULL,
  `data_fim` datetime DEFAULT NULL,
  `status_plantao` enum('ATIVO','ENCERRADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ATIVO',
  PRIMARY KEY (`id`),
  KEY `idx_plantao_ativo` (`id_usuario`,`status_plantao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `escala_plantao_atual`
--

LOCK TABLES `escala_plantao_atual` WRITE;
/*!40000 ALTER TABLE `escala_plantao_atual` DISABLE KEYS */;
/*!40000 ALTER TABLE `escala_plantao_atual` ENABLE KEYS */;
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
  `nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
-- Table structure for table `estoque_almoxarifado_central`
--

DROP TABLE IF EXISTS `estoque_almoxarifado_central`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_almoxarifado_central` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` int NOT NULL,
  `lote` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `validade` date NOT NULL,
  `quantidade_atual` decimal(12,4) NOT NULL,
  `valor_unitario_compra` decimal(12,4) DEFAULT NULL,
  `id_fornecedor` int DEFAULT NULL,
  `nota_fiscal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_entrada` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_almoxarifado_central`
--

LOCK TABLES `estoque_almoxarifado_central` WRITE;
/*!40000 ALTER TABLE `estoque_almoxarifado_central` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_almoxarifado_central` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque_inventario`
--

DROP TABLE IF EXISTS `estoque_inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_inventario` (
  `id_inventario` bigint NOT NULL AUTO_INCREMENT,
  `id_estoque_local` bigint NOT NULL,
  `id_codigo_universal` bigint DEFAULT NULL,
  `codigo` varchar(60) DEFAULT NULL,
  `barcode` varchar(60) DEFAULT NULL,
  `status` enum('ABERTO','EM_CONTAGEM','FECHADO','CANCELADO') NOT NULL DEFAULT 'ABERTO',
  `id_sessao_usuario_abertura` bigint NOT NULL,
  `aberto_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fechado_em` datetime DEFAULT NULL,
  `observacao` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_inventario`),
  KEY `ix_inv_local` (`id_estoque_local`),
  KEY `ix_inv_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_inventario`
--

LOCK TABLES `estoque_inventario` WRITE;
/*!40000 ALTER TABLE `estoque_inventario` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque_inventario_item`
--

DROP TABLE IF EXISTS `estoque_inventario_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_inventario_item` (
  `id_item` bigint NOT NULL AUTO_INCREMENT,
  `id_inventario` bigint NOT NULL,
  `id_produto` bigint NOT NULL,
  `id_lote` bigint DEFAULT NULL,
  `qtd_sistema` decimal(14,3) NOT NULL DEFAULT '0.000',
  `qtd_contada` decimal(14,3) DEFAULT NULL,
  `divergencia` decimal(14,3) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_item`),
  KEY `ix_inv_item_inv` (`id_inventario`),
  KEY `ix_inv_item_prod` (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_inventario_item`
--

LOCK TABLES `estoque_inventario_item` WRITE;
/*!40000 ALTER TABLE `estoque_inventario_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_inventario_item` ENABLE KEYS */;
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
-- Table structure for table `estoque_lote`
--

DROP TABLE IF EXISTS `estoque_lote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_lote` (
  `id_lote` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` bigint NOT NULL,
  `id_estoque_local` bigint NOT NULL,
  `id_codigo_universal` bigint DEFAULT NULL,
  `lote` varchar(60) DEFAULT NULL,
  `validade` date DEFAULT NULL,
  `quantidade` decimal(14,3) NOT NULL DEFAULT '0.000',
  `custo_unitario` decimal(14,4) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_lote`),
  KEY `ix_lote_prod` (`id_produto`),
  KEY `ix_lote_local` (`id_estoque_local`),
  KEY `ix_lote_validade` (`validade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_lote`
--

LOCK TABLES `estoque_lote` WRITE;
/*!40000 ALTER TABLE `estoque_lote` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_lote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque_movimentacao_itens`
--

DROP TABLE IF EXISTS `estoque_movimentacao_itens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_movimentacao_itens` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_produto` int NOT NULL,
  `quantidade_saida` decimal(12,4) NOT NULL,
  `id_usuario_quem_deu_baixa` bigint NOT NULL,
  `data_movimento` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_mov_atendimento` (`id_atendimento`),
  CONSTRAINT `fk_mov_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_movimentacao_itens`
--

LOCK TABLES `estoque_movimentacao_itens` WRITE;
/*!40000 ALTER TABLE `estoque_movimentacao_itens` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_movimentacao_itens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque_movimento`
--

DROP TABLE IF EXISTS `estoque_movimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_movimento` (
  `id_movimento` bigint NOT NULL AUTO_INCREMENT,
  `id_estoque_local` bigint NOT NULL,
  `tipo` enum('ENTRADA','SAIDA','AJUSTE','TRANSFERENCIA','INVENTARIO') NOT NULL,
  `origem` varchar(40) DEFAULT NULL,
  `destino` varchar(40) DEFAULT NULL,
  `id_documento` bigint DEFAULT NULL,
  `observacao` varchar(255) DEFAULT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_movimento`),
  KEY `ix_mov_local` (`id_estoque_local`),
  KEY `ix_mov_tipo` (`tipo`),
  KEY `ix_mov_doc` (`id_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_movimento`
--

LOCK TABLES `estoque_movimento` WRITE;
/*!40000 ALTER TABLE `estoque_movimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_movimento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque_movimento_item`
--

DROP TABLE IF EXISTS `estoque_movimento_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_movimento_item` (
  `id_mov_item` bigint NOT NULL AUTO_INCREMENT,
  `id_movimento` bigint NOT NULL,
  `id_produto` bigint NOT NULL,
  `id_lote` bigint DEFAULT NULL,
  `quantidade` decimal(14,3) NOT NULL,
  `valor_unitario` decimal(14,4) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_mov_item`),
  KEY `ix_mov_item_mov` (`id_movimento`),
  KEY `ix_mov_item_prod` (`id_produto`),
  KEY `ix_mov_item_lote` (`id_lote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_movimento_item`
--

LOCK TABLES `estoque_movimento_item` WRITE;
/*!40000 ALTER TABLE `estoque_movimento_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_movimento_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque_produto`
--

DROP TABLE IF EXISTS `estoque_produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_produto` (
  `id_produto` bigint NOT NULL AUTO_INCREMENT,
  `id_codigo_universal` bigint DEFAULT NULL,
  `sku_interno` varchar(60) DEFAULT NULL,
  `barcode` varchar(60) DEFAULT NULL,
  `nome` varchar(255) NOT NULL,
  `descricao` text,
  `categoria` varchar(120) DEFAULT NULL,
  `subcategoria` varchar(120) DEFAULT NULL,
  `marca` varchar(120) DEFAULT NULL,
  `unidade_medida` varchar(20) DEFAULT NULL,
  `controlado` tinyint(1) NOT NULL DEFAULT '0',
  `exige_receita` tinyint(1) NOT NULL DEFAULT '0',
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_produto`),
  UNIQUE KEY `uk_prod_sku` (`sku_interno`),
  KEY `ix_prod_nome` (`nome`),
  KEY `ix_prod_ativo` (`ativo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_produto`
--

LOCK TABLES `estoque_produto` WRITE;
/*!40000 ALTER TABLE `estoque_produto` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque_produto_codigo_externo`
--

DROP TABLE IF EXISTS `estoque_produto_codigo_externo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_produto_codigo_externo` (
  `id_codigo_ext` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` bigint NOT NULL,
  `sistema_externo` varchar(50) NOT NULL,
  `codigo_externo` varchar(80) NOT NULL,
  `preferencial` tinyint(1) NOT NULL DEFAULT '0',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_codigo_ext`),
  UNIQUE KEY `uk_prod_codigo_ext` (`id_produto`,`sistema_externo`,`codigo_externo`),
  KEY `ix_codigo_ext_lookup` (`sistema_externo`,`codigo_externo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_produto_codigo_externo`
--

LOCK TABLES `estoque_produto_codigo_externo` WRITE;
/*!40000 ALTER TABLE `estoque_produto_codigo_externo` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_produto_codigo_externo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque_produtos`
--

DROP TABLE IF EXISTS `estoque_produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_produtos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `codigo_ean` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `quantidade_estoque` decimal(10,2) DEFAULT '0.00',
  `estoque_minimo` decimal(10,2) DEFAULT '10.00',
  `unidade_medida` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_produtos`
--

LOCK TABLES `estoque_produtos` WRITE;
/*!40000 ALTER TABLE `estoque_produtos` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_produtos` ENABLE KEYS */;
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
  `origem` enum('PAINEL_TOTEM','PAINEL_RECEPCAO','PAINEL_TRIAGEM','PAINEL_MEDICO','PAINEL_PROCEDIMENTO','PAINEL_SATISFACAO','SISTEMA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_evento` enum('GERAR_SENHA','IMPRIMIR_SENHA','CHAMAR_SENHA','CONFIRMAR_PRESENCA','CRIAR_FFA','INICIO_TRIAGEM','FINAL_TRIAGEM','CHAMADA_MEDICA','INICIO_ATENDIMENTO_MEDICO','FINAL_ATENDIMENTO_MEDICO','CHAMADA_PROCEDIMENTO','INICIO_PROCEDIMENTO','FINAL_PROCEDIMENTO','STATUS_AUTOMATICO','NAO_COMPARECEU','TIMEOUT','AVALIACAO_ATENDIMENTO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status_origem` enum('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO','AGUARDANDO_MEDICACAO','MEDICACAO','AGUARDANDO_RX','EM_RX','AGUARDANDO_COLETA','EM_COLETA','AGUARDANDO_ECG','EM_ECG','ALTA','TRANSFERENCIA','INTERNACAO','FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_destino` enum('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO','AGUARDANDO_MEDICACAO','MEDICACAO','AGUARDANDO_RX','EM_RX','AGUARDANDO_COLETA','EM_COLETA','AGUARDANDO_ECG','EM_ECG','ALTA','TRANSFERENCIA','INTERNACAO','FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `tipo_evento` enum('LIMPEZA_ROTINA','LIMPEZA_TERMINAL','REPOSICAO_HIGIENE','INTERCORRENCIA','CONTAMINACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `registrado_por` bigint NOT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
  `entidade` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `entidade_id` bigint DEFAULT NULL,
  `tipo_evento` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `perfil_usuario` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `local` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `area` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `codigo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('LAB','RX','OUTROS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
-- Table structure for table `exame_historico`
--

DROP TABLE IF EXISTS `exame_historico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exame_historico` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_pedido` bigint NOT NULL,
  `evento` enum('SOLICITACAO','COLETA','RECEBIMENTO','LAUDO','CANCELAMENTO') NOT NULL,
  `descricao` text,
  `id_usuario` bigint NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pedido_hist` (`id_pedido`),
  CONSTRAINT `fk_hist_exame_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `exame_pedido` (`id_pedido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exame_historico`
--

LOCK TABLES `exame_historico` WRITE;
/*!40000 ALTER TABLE `exame_historico` DISABLE KEYS */;
/*!40000 ALTER TABLE `exame_historico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exame_pedido`
--

DROP TABLE IF EXISTS `exame_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exame_pedido` (
  `id_pedido` bigint NOT NULL AUTO_INCREMENT,
  `codigo_interno` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_senha` bigint NOT NULL,
  `id_ffa` bigint NOT NULL,
  `id_atendimento` bigint NOT NULL,
  `status` enum('SOLICITADO','COLETADO','EM_LABORATORIO','FINALIZADO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'SOLICITADO',
  `id_usuario_solicitante` bigint NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pedido`),
  UNIQUE KEY `codigo_interno` (`codigo_interno`),
  KEY `fk_exame_senha` (`id_senha`),
  KEY `fk_exame_ffa` (`id_ffa`),
  KEY `fk_exame_atendimento` (`id_atendimento`),
  CONSTRAINT `fk_exame_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `fk_exame_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_exame_senha` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Pedido de exame com herança completa';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exame_pedido`
--

LOCK TABLES `exame_pedido` WRITE;
/*!40000 ALTER TABLE `exame_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `exame_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exame_pedido_item`
--

DROP TABLE IF EXISTS `exame_pedido_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exame_pedido_item` (
  `id_item` bigint NOT NULL AUTO_INCREMENT,
  `id_pedido` bigint NOT NULL,
  `codigo_procedimento` varchar(20) DEFAULT NULL,
  `nome_exame` varchar(150) DEFAULT NULL,
  `material` varchar(50) DEFAULT NULL,
  `valor_custo` decimal(10,2) DEFAULT '0.00',
  `valor_venda` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id_item`),
  KEY `fk_item_pedido` (`id_pedido`),
  CONSTRAINT `fk_item_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `exame_pedido` (`id_pedido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exame_pedido_item`
--

LOCK TABLES `exame_pedido_item` WRITE;
/*!40000 ALTER TABLE `exame_pedido_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `exame_pedido_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farm_atendimento_externo`
--

DROP TABLE IF EXISTS `farm_atendimento_externo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farm_atendimento_externo` (
  `id_atendimento_ext` bigint NOT NULL AUTO_INCREMENT,
  `id_gpat` bigint NOT NULL,
  `origem` varchar(120) NOT NULL,
  `nome_paciente` varchar(255) NOT NULL,
  `nome_medico` varchar(255) NOT NULL,
  `conselho_medico` varchar(10) DEFAULT NULL,
  `numero_conselho` varchar(30) DEFAULT NULL,
  `uf_conselho` char(2) DEFAULT NULL,
  `data_receita` date DEFAULT NULL,
  `dias_tratamento` int DEFAULT NULL,
  `status` enum('ABERTO','FINALIZADO','CANCELADO') NOT NULL DEFAULT 'ABERTO',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_atendimento_ext`),
  KEY `ix_fext_gpat` (`id_gpat`),
  KEY `ix_fext_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farm_atendimento_externo`
--

LOCK TABLES `farm_atendimento_externo` WRITE;
/*!40000 ALTER TABLE `farm_atendimento_externo` DISABLE KEYS */;
/*!40000 ALTER TABLE `farm_atendimento_externo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farm_dispensacao`
--

DROP TABLE IF EXISTS `farm_dispensacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farm_dispensacao` (
  `id_dispensacao` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_gpat` bigint NOT NULL,
  `id_estoque_local` bigint NOT NULL,
  `tipo` enum('MEDICACAO','MATERIAL','OUTRO') NOT NULL DEFAULT 'MEDICACAO',
  `status` enum('ABERTA','DISPENSADA','CANCELADA') NOT NULL DEFAULT 'ABERTA',
  `id_usuario_farmacia` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_dispensacao`),
  KEY `ix_disp_ffa` (`id_ffa`),
  KEY `ix_disp_gpat` (`id_gpat`),
  KEY `ix_disp_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farm_dispensacao`
--

LOCK TABLES `farm_dispensacao` WRITE;
/*!40000 ALTER TABLE `farm_dispensacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `farm_dispensacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farm_dispensacao_item`
--

DROP TABLE IF EXISTS `farm_dispensacao_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farm_dispensacao_item` (
  `id_item` bigint NOT NULL AUTO_INCREMENT,
  `id_dispensacao` bigint NOT NULL,
  `id_produto` bigint NOT NULL,
  `id_lote` bigint DEFAULT NULL,
  `quantidade` decimal(14,3) NOT NULL,
  `posologia` varchar(255) DEFAULT NULL,
  `via` varchar(60) DEFAULT NULL,
  `observacao` varchar(255) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_item`),
  KEY `ix_disp_item_disp` (`id_dispensacao`),
  KEY `ix_disp_item_prod` (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farm_dispensacao_item`
--

LOCK TABLES `farm_dispensacao_item` WRITE;
/*!40000 ALTER TABLE `farm_dispensacao_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `farm_dispensacao_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmacia_atendimento_externo`
--

DROP TABLE IF EXISTS `farmacia_atendimento_externo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmacia_atendimento_externo` (
  `id_atendimento` bigint NOT NULL AUTO_INCREMENT,
  `protocolo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_cliente` bigint DEFAULT NULL,
  `origem_nome` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `medico_nome` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `medico_documento` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_receita` date DEFAULT NULL,
  `status` enum('ABERTO','EM_DISPENSACAO','FECHADO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ABERTO',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `criado_por` bigint NOT NULL,
  `atualizado_em` datetime DEFAULT NULL,
  `fechado_em` datetime DEFAULT NULL,
  `fechado_por` bigint DEFAULT NULL,
  `cancelado_em` datetime DEFAULT NULL,
  `cancelado_por` bigint DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id_atendimento`),
  UNIQUE KEY `uk_fae_protocolo` (`protocolo`),
  KEY `idx_fae_status` (`status`,`criado_em`),
  KEY `idx_fae_cliente` (`id_cliente`),
  CONSTRAINT `fk_fae_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmacia_atendimento_externo`
--

LOCK TABLES `farmacia_atendimento_externo` WRITE;
/*!40000 ALTER TABLE `farmacia_atendimento_externo` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmacia_atendimento_externo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmacia_atendimento_externo_dispensacao`
--

DROP TABLE IF EXISTS `farmacia_atendimento_externo_dispensacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmacia_atendimento_externo_dispensacao` (
  `id_dispensacao` bigint NOT NULL AUTO_INCREMENT,
  `id_item` bigint NOT NULL,
  `id_lote` bigint NOT NULL,
  `id_local_estoque` bigint NOT NULL,
  `quantidade` decimal(10,2) NOT NULL,
  `status` enum('ENTREGUE','CANCELADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ENTREGUE',
  `dispensado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dispensado_por` bigint NOT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id_dispensacao`),
  KEY `idx_faed` (`id_item`,`status`),
  KEY `fk_faed_lote` (`id_lote`),
  KEY `fk_faed_local` (`id_local_estoque`),
  CONSTRAINT `fk_faed_item` FOREIGN KEY (`id_item`) REFERENCES `farmacia_atendimento_externo_item` (`id_item`),
  CONSTRAINT `fk_faed_local` FOREIGN KEY (`id_local_estoque`) REFERENCES `local_atendimento` (`id_local`),
  CONSTRAINT `fk_faed_lote` FOREIGN KEY (`id_lote`) REFERENCES `farmaco_lote` (`id_lote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmacia_atendimento_externo_dispensacao`
--

LOCK TABLES `farmacia_atendimento_externo_dispensacao` WRITE;
/*!40000 ALTER TABLE `farmacia_atendimento_externo_dispensacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmacia_atendimento_externo_dispensacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmacia_atendimento_externo_item`
--

DROP TABLE IF EXISTS `farmacia_atendimento_externo_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmacia_atendimento_externo_item` (
  `id_item` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_farmaco` bigint NOT NULL,
  `quantidade_total` decimal(10,2) NOT NULL,
  `posologia` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `dias` int DEFAULT NULL,
  `status` enum('ATIVO','SUSPENSO','CONCLUIDO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATIVO',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `criado_por` bigint NOT NULL,
  `atualizado_em` datetime DEFAULT NULL,
  `atualizado_por` bigint DEFAULT NULL,
  `id_lote` bigint NOT NULL,
  `id_local_estoque` bigint NOT NULL,
  PRIMARY KEY (`id_item`),
  KEY `idx_faei` (`id_atendimento`,`status`),
  KEY `fk_faei_farmaco` (`id_farmaco`),
  CONSTRAINT `fk_faei_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `farmacia_atendimento_externo` (`id_atendimento`),
  CONSTRAINT `fk_faei_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmacia_atendimento_externo_item`
--

LOCK TABLES `farmacia_atendimento_externo_item` WRITE;
/*!40000 ALTER TABLE `farmacia_atendimento_externo_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmacia_atendimento_externo_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmacia_externo_evento`
--

DROP TABLE IF EXISTS `farmacia_externo_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmacia_externo_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `tipo` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` bigint DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  KEY `idx_fee` (`id_atendimento`,`criado_em`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmacia_externo_evento`
--

LOCK TABLES `farmacia_externo_evento` WRITE;
/*!40000 ALTER TABLE `farmacia_externo_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmacia_externo_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmacia_venda`
--

DROP TABLE IF EXISTS `farmacia_venda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmacia_venda` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `id_usuario_caixa` bigint NOT NULL,
  `cliente_nome` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cliente_cpf` varchar(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `valor_bruto` decimal(12,2) DEFAULT '0.00',
  `valor_desconto` decimal(12,2) DEFAULT '0.00',
  `valor_liquido` decimal(12,2) DEFAULT '0.00',
  `forma_pagamento` enum('DINHEIRO','CARTAO_DEBITO','CARTAO_CREDITO','PIX') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_venda` enum('ABERTA','FINALIZADA','CANCELADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'FINALIZADA',
  `data_venda` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmacia_venda`
--

LOCK TABLES `farmacia_venda` WRITE;
/*!40000 ALTER TABLE `farmacia_venda` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmacia_venda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmacia_venda_itens`
--

DROP TABLE IF EXISTS `farmacia_venda_itens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmacia_venda_itens` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_venda` bigint NOT NULL,
  `id_produto` int NOT NULL,
  `quantidade` decimal(10,2) NOT NULL,
  `valor_unitario` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_venda_item` (`id_venda`),
  CONSTRAINT `fk_venda_item` FOREIGN KEY (`id_venda`) REFERENCES `farmacia_venda` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmacia_venda_itens`
--

LOCK TABLES `farmacia_venda_itens` WRITE;
/*!40000 ALTER TABLE `farmacia_venda_itens` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmacia_venda_itens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmaco`
--

DROP TABLE IF EXISTS `farmaco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmaco` (
  `id_farmaco` bigint NOT NULL AUTO_INCREMENT,
  `nome_comercial` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `principio_ativo` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('CONTROLADO','PADRAO','HEMODERIVADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `unidade_medida` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `marca` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `tabela` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_registro` bigint DEFAULT NULL,
  `acao` enum('INSERT','UPDATE','DELETE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `motivo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `numero_lote` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `tipo` enum('ENTRADA','SAIDA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `quantidade` int NOT NULL,
  `origem` enum('COMPRA','TRANSFERENCIA','PACIENTE','AJUSTE','PDV') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `observacao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
-- Table structure for table `faturamento_codigo`
--

DROP TABLE IF EXISTS `faturamento_codigo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_codigo` (
  `id_codigo` bigint NOT NULL AUTO_INCREMENT,
  `sistema` enum('SIGTAP','TUSS','CBHPM','INTERNO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'INTERNO',
  `codigo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('PROCEDIMENTO','MATERIAL','MEDICAMENTO','TAXA','DIARIA','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'OUTRO',
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `unidade_medida` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_codigo`),
  UNIQUE KEY `uq_faturamento_codigo` (`sistema`,`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_codigo`
--

LOCK TABLES `faturamento_codigo` WRITE;
/*!40000 ALTER TABLE `faturamento_codigo` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_codigo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faturamento_conta`
--

DROP TABLE IF EXISTS `faturamento_conta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_conta` (
  `id_conta` bigint NOT NULL AUTO_INCREMENT,
  `tipo_conta` enum('FFA','INTERNACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_internacao` bigint DEFAULT NULL,
  `status` enum('ABERTA','EM_REVISAO','EM_AUDITORIA','FECHADA','CANCELADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ABERTA',
  `valor_total` decimal(12,2) DEFAULT '0.00',
  `aberta_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `fechada_em` datetime DEFAULT NULL,
  `fechado_por` bigint DEFAULT NULL,
  `numero_conta` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `competencia` char(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_senha` bigint DEFAULT NULL,
  `id_unidade` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `total_bruto` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_desconto` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_liquido` decimal(10,2) NOT NULL DEFAULT '0.00',
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_sessao_usuario_criacao` bigint DEFAULT NULL,
  `criado_por` bigint DEFAULT NULL,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cancelado_em` datetime DEFAULT NULL,
  `cancelado_por` bigint DEFAULT NULL,
  PRIMARY KEY (`id_conta`),
  KEY `fk_fat_conta_ffa` (`id_ffa`),
  KEY `idx_fat_conta_numero` (`numero_conta`),
  KEY `idx_fat_conta_comp` (`competencia`),
  KEY `idx_fat_conta_senha` (`id_senha`),
  KEY `idx_fat_conta_unidade` (`id_unidade`),
  KEY `idx_fat_conta_local` (`id_local_operacional`),
  KEY `idx_fat_conta_sessao_criacao` (`id_sessao_usuario_criacao`),
  KEY `idx_fat_conta_criado_por` (`criado_por`),
  KEY `idx_fat_conta_cancelado_por` (`cancelado_por`),
  CONSTRAINT `fk_fat_conta_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_fat_conta_sessao_criacao` FOREIGN KEY (`id_sessao_usuario_criacao`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
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
-- Table structure for table `faturamento_conta_paciente`
--

DROP TABLE IF EXISTS `faturamento_conta_paciente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_conta_paciente` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_convenio` int NOT NULL,
  `status_conta` enum('ABERTA','FECHADA','FATURADA','PAGA','GLOSADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ABERTA',
  `valor_total` decimal(12,2) DEFAULT '0.00',
  `numero_guia_principal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_fechamento` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_conta_atend` (`id_atendimento`),
  CONSTRAINT `fk_conta_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_conta_paciente`
--

LOCK TABLES `faturamento_conta_paciente` WRITE;
/*!40000 ALTER TABLE `faturamento_conta_paciente` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_conta_paciente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faturamento_conta_seq`
--

DROP TABLE IF EXISTS `faturamento_conta_seq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_conta_seq` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_conta_seq`
--

LOCK TABLES `faturamento_conta_seq` WRITE;
/*!40000 ALTER TABLE `faturamento_conta_seq` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_conta_seq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faturamento_convenio`
--

DROP TABLE IF EXISTS `faturamento_convenio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_convenio` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_convenio` int NOT NULL,
  `numero_guia` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `valor_total` decimal(12,2) DEFAULT NULL,
  `status_guia` enum('ABERTA','ENVIADA','PAGA','GLOSADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ABERTA',
  `xml_gerado` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `data_emissao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_convenio`
--

LOCK TABLES `faturamento_convenio` WRITE;
/*!40000 ALTER TABLE `faturamento_convenio` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_convenio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faturamento_convenios`
--

DROP TABLE IF EXISTS `faturamento_convenios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_convenios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome_fantasia` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `registro_ans` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_tabela_precos` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_convenios`
--

LOCK TABLES `faturamento_convenios` WRITE;
/*!40000 ALTER TABLE `faturamento_convenios` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_convenios` ENABLE KEYS */;
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
  `evento` enum('ABERTURA','FECHAMENTO','REABERTURA','CANCELAMENTO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint NOT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `tipo` enum('ABRIR','ADICIONAR_ITEM','CANCELAR_ITEM','FECHAR','REABRIR','CANCELAR_CONTA','OBS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `detalhe` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id_evento`),
  KEY `idx_conta` (`id_conta`),
  KEY `idx_fat_evt_sessao` (`id_sessao_usuario`),
  KEY `idx_fat_evt_tipo` (`tipo`),
  CONSTRAINT `fk_fat_evt_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
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
  `origem` enum('FARMACIA','ALMOXARIFADO','MANUTENCAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_produto` bigint NOT NULL,
  `lote` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `origem` enum('PROCEDIMENTO','EXAME','MEDICACAO','MATERIAL','TAXA','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_origem` bigint NOT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `quantidade` decimal(10,2) DEFAULT '1.00',
  `valor_unitario` decimal(10,2) NOT NULL,
  `valor_total` decimal(10,2) NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_internacao` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `criado_por` bigint NOT NULL,
  `status` enum('ABERTO','CONSOLIDADO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ABERTO',
  `id_conta` bigint DEFAULT NULL,
  `id_codigo` bigint DEFAULT NULL,
  `sistema_codigo` enum('SUS','TUSS','PROPRIO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PROPRIO',
  `codigo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('PROCEDIMENTO','EXAME','MEDICACAO','DIARIA','HONORARIO','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'OUTRO',
  `desconto` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_linha` decimal(10,2) NOT NULL DEFAULT '0.00',
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_item`),
  KEY `idx_fat_item_conta` (`id_conta`),
  KEY `idx_fat_item_codigo` (`id_codigo`),
  KEY `idx_fat_item_codigo_txt` (`codigo`),
  CONSTRAINT `fk_fat_item_codigo` FOREIGN KEY (`id_codigo`) REFERENCES `faturamento_codigo` (`id_codigo`),
  CONSTRAINT `fk_fat_item_conta` FOREIGN KEY (`id_conta`) REFERENCES `faturamento_conta` (`id_conta`)
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
-- Table structure for table `faturamento_producao`
--

DROP TABLE IF EXISTS `faturamento_producao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_producao` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `codigo_procedimento` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cbo_profissional` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_faturamento` enum('PENDENTE','PROCESSADO','GLOSADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDENTE',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_producao`
--

LOCK TABLES `faturamento_producao` WRITE;
/*!40000 ALTER TABLE `faturamento_producao` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_producao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faturamento_producao_sus`
--

DROP TABLE IF EXISTS `faturamento_producao_sus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_producao_sus` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_sigtap` int NOT NULL,
  `cbo_profissional` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cns_paciente` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_producao` date DEFAULT NULL,
  `status_remessa` enum('PENDENTE','ENVIADO','REJEITADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDENTE',
  PRIMARY KEY (`id`),
  KEY `fk_sus_atend` (`id_atendimento`),
  CONSTRAINT `fk_sus_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_producao_sus`
--

LOCK TABLES `faturamento_producao_sus` WRITE;
/*!40000 ALTER TABLE `faturamento_producao_sus` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_producao_sus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faturamento_regras_validacao`
--

DROP TABLE IF EXISTS `faturamento_regras_validacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_regras_validacao` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `possui_cid` tinyint(1) DEFAULT '0',
  `possui_cbo` tinyint(1) DEFAULT '0',
  `possui_prescricao` tinyint(1) DEFAULT '0',
  `apto_para_faturar` tinyint(1) GENERATED ALWAYS AS (((0 <> `possui_cid`) and (0 <> `possui_cbo`))) STORED,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_fatura_atend` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_regras_validacao`
--

LOCK TABLES `faturamento_regras_validacao` WRITE;
/*!40000 ALTER TABLE `faturamento_regras_validacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_regras_validacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faturamento_sigtap`
--

DROP TABLE IF EXISTS `faturamento_sigtap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_sigtap` (
  `id` int NOT NULL AUTO_INCREMENT,
  `codigo_procedimento` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome_procedimento` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `valor_sh` decimal(10,2) DEFAULT NULL,
  `valor_sa` decimal(10,2) DEFAULT NULL,
  `complexidade` enum('BASICA','MEDIA','ALTA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sigtap_cod` (`codigo_procedimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_sigtap`
--

LOCK TABLES `faturamento_sigtap` WRITE;
/*!40000 ALTER TABLE `faturamento_sigtap` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_sigtap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faturamento_sus_config`
--

DROP TABLE IF EXISTS `faturamento_sus_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faturamento_sus_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_unidade` int NOT NULL,
  `cnes_unidade` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `gestao_municipal_estadual` enum('M','E') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faturamento_sus_config`
--

LOCK TABLES `faturamento_sus_config` WRITE;
/*!40000 ALTER TABLE `faturamento_sus_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_sus_config` ENABLE KEYS */;
UNLOCK TABLES;

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
  `classificacao_cor` enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tempo_limite` datetime DEFAULT NULL,
  `data_criacao` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_gpat` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ffa_classificacao` (`classificacao_cor`,`status`),
  KEY `fk_ffa_atendimento` (`id_atendimento`),
  KEY `idx_ffa_status_cor` (`status`,`classificacao_cor`),
  KEY `idx_ffa_status` (`status`),
  KEY `ix_ffa_id_gpat` (`id_gpat`),
  CONSTRAINT `fk_ffa_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ffa`
--

LOCK TABLES `ffa` WRITE;
/*!40000 ALTER TABLE `ffa` DISABLE KEYS */;
INSERT INTO `ffa` VALUES (1,NULL,1,NULL,'ABERTO','CLINICO',10,NULL,'2026-01-14 03:52:41','2026-01-14 03:52:41',NULL,NULL,2,NULL,NULL,'2026-01-28 06:35:38',NULL),(2,3,8,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:20:16',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38',NULL),(3,4,8,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:20:42',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38',NULL),(4,5,8,NULL,'EM_TRIAGEM',NULL,5,NULL,'2026-01-28 06:21:25',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38',NULL),(5,6,1,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:21:57',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38',NULL),(6,7,8,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:22:20',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38',NULL),(7,8,1,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:22:54',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38',NULL),(8,9,8,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:26:06',NULL,'VERDE',NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38',NULL),(9,10,31,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:29:42',NULL,NULL,NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38',NULL),(10,11,17,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:30:20',NULL,NULL,NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38',NULL),(11,12,17,NULL,'ABERTO',NULL,5,NULL,'2026-01-28 06:31:19',NULL,NULL,NULL,NULL,'VERDE',NULL,'2026-01-28 06:35:38',NULL),(12,13,8,'GPAT-20260215-0000000001','ABERTO',NULL,5,NULL,'2026-02-15 04:31:10','2026-02-15 04:31:10',NULL,NULL,1,NULL,NULL,'2026-02-15 04:31:10',NULL);
/*!40000 ALTER TABLE `ffa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ffa_demandas_externas`
--

DROP TABLE IF EXISTS `ffa_demandas_externas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ffa_demandas_externas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `tipo_demanda` enum('RX_EXTERNO','MEDICACAO_EXTERNA','EXAME_EXTERNO','OUTROS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `profissional_externo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('PENDENTE','REALIZADO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDENTE',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_demanda_atendimento` (`id_atendimento`),
  CONSTRAINT `fk_demanda_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ffa_demandas_externas`
--

LOCK TABLES `ffa_demandas_externas` WRITE;
/*!40000 ALTER TABLE `ffa_demandas_externas` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_demandas_externas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ffa_diagnostico`
--

DROP TABLE IF EXISTS `ffa_diagnostico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ffa_diagnostico` (
  `id_diagnostico` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `cid10` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('PRINCIPAL','SECUNDARIO','SUSPEITA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PRINCIPAL',
  `confirmado` tinyint NOT NULL DEFAULT '0',
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_diagnostico`),
  UNIQUE KEY `ux_diag_ffa_cid_tipo` (`id_ffa`,`cid10`,`tipo`),
  KEY `idx_diag_ffa` (`id_ffa`),
  KEY `idx_diag_sessao` (`id_sessao_usuario`),
  KEY `fk_diag_usuario` (`id_usuario`),
  CONSTRAINT `fk_diag_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_diag_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_diag_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ffa_diagnostico`
--

LOCK TABLES `ffa_diagnostico` WRITE;
/*!40000 ALTER TABLE `ffa_diagnostico` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_diagnostico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ffa_evolucao`
--

DROP TABLE IF EXISTS `ffa_evolucao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ffa_evolucao` (
  `id_evolucao` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `texto` longtext NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `tipo` varchar(30) NOT NULL DEFAULT 'EVOLUCAO',
  `modulo` varchar(60) DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `ip` varchar(60) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `hash_integridade` varchar(64) DEFAULT NULL,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_evolucao`),
  KEY `idx_evo_ffa` (`id_ffa`),
  KEY `idx_evo_sessao` (`id_sessao_usuario`),
  KEY `idx_evo_usuario` (`id_usuario`),
  CONSTRAINT `fk_evo_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_evo_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_evo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ffa_evolucao`
--

LOCK TABLES `ffa_evolucao` WRITE;
/*!40000 ALTER TABLE `ffa_evolucao` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_evolucao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ffa_extra`
--

DROP TABLE IF EXISTS `ffa_extra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ffa_extra` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `tipo_extra` enum('MEDICACAO_EXTERNA','RX_EXTERNO','EXAME_EXTERNO','PROCEDIMENTO_AVULSO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `status` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDENTE',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ffa_extra`
--

LOCK TABLES `ffa_extra` WRITE;
/*!40000 ALTER TABLE `ffa_extra` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_extra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ffa_historico_status`
--

DROP TABLE IF EXISTS `ffa_historico_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ffa_historico_status` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `status_anterior` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_novo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_mudanca` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_usuario_acao` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_hist_ffa` (`id_ffa`),
  CONSTRAINT `fk_hist_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ffa_historico_status`
--

LOCK TABLES `ffa_historico_status` WRITE;
/*!40000 ALTER TABLE `ffa_historico_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_historico_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ffa_prioridade`
--

DROP TABLE IF EXISTS `ffa_prioridade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ffa_prioridade` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `codigo_prioridade` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `tipo` enum('RX','ECG','LABORATORIO','MEDICACAO','OBSERVACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('SOLICITADO','EM_FILA','EM_EXECUCAO','CONCLUIDO','CRITICO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'SOLICITADO',
  `prioridade` enum('NORMAL','EMERGENCIA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'NORMAL',
  `id_usuario_solicitante` bigint DEFAULT NULL,
  `id_usuario_execucao` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `iniciado_em` datetime DEFAULT NULL,
  `finalizado_em` datetime DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
-- Table structure for table `ffa_sinais_vitais`
--

DROP TABLE IF EXISTS `ffa_sinais_vitais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ffa_sinais_vitais` (
  `id_sinais` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_fila` bigint DEFAULT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `id_usuario` bigint NOT NULL,
  `data_coleta` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pressao_sistolica` int DEFAULT NULL,
  `pressao_diastolica` int DEFAULT NULL,
  `freq_cardiaca` int DEFAULT NULL,
  `freq_respiratoria` int DEFAULT NULL,
  `temperatura` decimal(4,1) DEFAULT NULL,
  `saturacao` int DEFAULT NULL,
  `glicemia` int DEFAULT NULL,
  `escala_dor` tinyint DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sinais`),
  KEY `idx_ffa_sinais_ffa` (`id_ffa`,`data_coleta`),
  KEY `idx_ffa_sinais_sessao` (`id_sessao_usuario`),
  KEY `idx_ffa_sinais_usuario` (`id_usuario`,`data_coleta`),
  KEY `fk_ffa_sinais_local` (`id_local_operacional`),
  CONSTRAINT `fk_ffa_sinais_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_ffa_sinais_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
  CONSTRAINT `fk_ffa_sinais_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_ffa_sinais_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ffa_sinais_vitais`
--

LOCK TABLES `ffa_sinais_vitais` WRITE;
/*!40000 ALTER TABLE `ffa_sinais_vitais` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_sinais_vitais` ENABLE KEYS */;
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
  `categoria` enum('MEDICACAO','FARMACIA','OBSERVACAO','RX','ECG','COLETA','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `finalizado_em` datetime DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
  `evento` enum('GERADA','CHAMADA','NAO_ATENDIDO','REENTRADA','ABERTURA_FFA','ENCAMINHAMENTO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `id_local` bigint DEFAULT NULL,
  `detalhe` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
  `tipo` enum('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Tipo de fila',
  `substatus` enum('AGUARDANDO','EM_EXECUCAO','REAVALIAR','FINALIZADO','CANCELADO','NAO_COMPARECEU','ENCAMINHADO','RETORNO','EM_OBSERVACAO','CRITICO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'AGUARDANDO',
  `prioridade` enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'AZUL' COMMENT 'Prioridade de Manchester',
  `data_entrada` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Chegada na fila',
  `entrada_original_em` datetime DEFAULT NULL,
  `nao_compareceu_em` datetime DEFAULT NULL,
  `retorno_permitido_ate` datetime DEFAULT NULL,
  `retorno_utilizado` tinyint(1) NOT NULL DEFAULT '0',
  `retorno_em` datetime DEFAULT NULL,
  `data_inicio` datetime DEFAULT NULL COMMENT 'Início do atendimento/exame',
  `reavaliar_em` datetime DEFAULT NULL,
  `data_fim` datetime DEFAULT NULL COMMENT 'Término do atendimento/exame',
  `id_responsavel` bigint DEFAULT NULL COMMENT 'Usuário que está atendendo/executando',
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'Notas ou observações específicas',
  `id_local` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  PRIMARY KEY (`id_fila`),
  KEY `id_responsavel` (`id_responsavel`),
  KEY `id_local` (`id_local`),
  KEY `idx_ffa_tipo_substatus` (`id_ffa`,`tipo`,`substatus`),
  KEY `idx_tipo_prioridade` (`tipo`,`prioridade`,`substatus`),
  KEY `idx_filaop_ordem` (`tipo`,`substatus`,`prioridade`,`data_entrada`,`id_local_operacional`),
  KEY `idx_reavaliar_em` (`tipo`,`substatus`,`reavaliar_em`),
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
-- Table structure for table `fila_operacional_evento`
--

DROP TABLE IF EXISTS `fila_operacional_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fila_operacional_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_fila` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `tipo_evento` varchar(64) NOT NULL,
  `detalhe` text,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_filaop_evt_fila` (`id_fila`),
  KEY `idx_filaop_evt_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_filaop_evt_fila` FOREIGN KEY (`id_fila`) REFERENCES `fila_operacional` (`id_fila`),
  CONSTRAINT `fk_filaop_evt_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fila_operacional_evento`
--

LOCK TABLES `fila_operacional_evento` WRITE;
/*!40000 ALTER TABLE `fila_operacional_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `fila_operacional_evento` ENABLE KEYS */;
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
  `id_senha` bigint NOT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'AGUARDANDO',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_fila_senha_id_senha` (`id_senha`),
  KEY `idx_fs_senha` (`id_senha`),
  CONSTRAINT `fk_fs_senhas` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fila_senha`
--

LOCK TABLES `fila_senha` WRITE;
/*!40000 ALTER TABLE `fila_senha` DISABLE KEYS */;
INSERT INTO `fila_senha` VALUES (1,3,'EM_COMPLEMENTACAO','2026-02-13 06:17:42'),(2,4,'EM_COMPLEMENTACAO','2026-02-13 06:19:25');
/*!40000 ALTER TABLE `fila_senha` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `financeiro_repasse_medico`
--

DROP TABLE IF EXISTS `financeiro_repasse_medico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `financeiro_repasse_medico` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario_medico` bigint NOT NULL,
  `id_atendimento` bigint NOT NULL,
  `valor_procedimento` decimal(10,2) DEFAULT NULL,
  `percentual_repasse` decimal(5,2) DEFAULT '100.00',
  `valor_final_medico` decimal(10,2) DEFAULT NULL,
  `status_pagamento` enum('PREVIA','APROVADO','PAGO','GLOSADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PREVIA',
  `data_competencia` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_repasse_medico` (`id_usuario_medico`,`data_competencia`),
  KEY `idx_financeiro_competencia` (`data_competencia`,`status_pagamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `financeiro_repasse_medico`
--

LOCK TABLES `financeiro_repasse_medico` WRITE;
/*!40000 ALTER TABLE `financeiro_repasse_medico` DISABLE KEYS */;
/*!40000 ALTER TABLE `financeiro_repasse_medico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fluxo_status`
--

DROP TABLE IF EXISTS `fluxo_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fluxo_status` (
  `status_origem` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status_destino` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `origem_evento` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
-- Table structure for table `forma_pagamento`
--

DROP TABLE IF EXISTS `forma_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forma_pagamento` (
  `id_forma_pagamento` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(30) NOT NULL,
  `descricao` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id_forma_pagamento`),
  UNIQUE KEY `uk_fp_codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forma_pagamento`
--

LOCK TABLES `forma_pagamento` WRITE;
/*!40000 ALTER TABLE `forma_pagamento` DISABLE KEYS */;
INSERT INTO `forma_pagamento` VALUES (1,'DINHEIRO','Dinheiro'),(2,'PIX','PIX'),(3,'DEBITO','Cartão de débito'),(4,'CREDITO','Cartão de crédito'),(5,'CARTAO_DEBITO','Cartão Débito'),(6,'CARTAO_CREDITO','Cartão Crédito'),(7,'CONVENIO','Convênio'),(8,'OUTRO','Outro');
/*!40000 ALTER TABLE `forma_pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fornecedor`
--

DROP TABLE IF EXISTS `fornecedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fornecedor` (
  `id_fornecedor` bigint NOT NULL AUTO_INCREMENT,
  `razao_social` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome_fantasia` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cnpj` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `contato` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `id_sessao_usuario` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_gaso_evento`),
  KEY `idx_ge_gaso` (`id_gaso`),
  KEY `fk_ge_user` (`id_usuario`),
  KEY `idx_ge_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_ge_gaso` FOREIGN KEY (`id_gaso`) REFERENCES `gaso_solicitacao` (`id_gaso`),
  CONSTRAINT `fk_ge_sessao_usuario` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
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
-- Table structure for table `gasoterapia_consumo`
--

DROP TABLE IF EXISTS `gasoterapia_consumo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gasoterapia_consumo` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_leito` int NOT NULL,
  `tipo_gas` enum('OXIGENIO','AR_COMPRIMIDO','VACUO','MISTURA_N2O') NOT NULL,
  `litros_por_minuto` decimal(10,2) NOT NULL DEFAULT '0.00',
  `data_inicio` datetime NOT NULL,
  `data_fim` datetime DEFAULT NULL,
  `status` enum('EM_USO','ENCERRADO','CANCELADO') DEFAULT 'EM_USO',
  `id_usuario_registro` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_gaso_atendimento` (`id_atendimento`),
  KEY `fk_gaso_leito` (`id_leito`),
  CONSTRAINT `fk_gaso_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `fk_gaso_leito` FOREIGN KEY (`id_leito`) REFERENCES `leito` (`id_leito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gasoterapia_consumo`
--

LOCK TABLES `gasoterapia_consumo` WRITE;
/*!40000 ALTER TABLE `gasoterapia_consumo` DISABLE KEYS */;
/*!40000 ALTER TABLE `gasoterapia_consumo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gasoterapia_consumo_evento`
--

DROP TABLE IF EXISTS `gasoterapia_consumo_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gasoterapia_consumo_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_consumo` bigint NOT NULL,
  `evento` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `detalhe` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_gce_consumo` (`id_consumo`),
  KEY `idx_gce_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_gce_consumo` FOREIGN KEY (`id_consumo`) REFERENCES `gasoterapia_consumo` (`id`),
  CONSTRAINT `fk_gce_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gasoterapia_consumo_evento`
--

LOCK TABLES `gasoterapia_consumo_evento` WRITE;
/*!40000 ALTER TABLE `gasoterapia_consumo_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `gasoterapia_consumo_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gpat`
--

DROP TABLE IF EXISTS `gpat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gpat` (
  `id_gpat` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_codigo_universal` bigint NOT NULL,
  `codigo_gpat` varchar(50) NOT NULL,
  `barcode_gpat` varchar(60) NOT NULL,
  `origem` enum('AUTO','MANUAL') NOT NULL DEFAULT 'AUTO',
  `observacao` varchar(255) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_gpat`),
  UNIQUE KEY `uk_gpat_ffa` (`id_ffa`),
  UNIQUE KEY `uk_gpat_codigo` (`codigo_gpat`),
  UNIQUE KEY `uk_gpat_codigo_universal` (`id_codigo_universal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gpat`
--

LOCK TABLES `gpat` WRITE;
/*!40000 ALTER TABLE `gpat` DISABLE KEYS */;
/*!40000 ALTER TABLE `gpat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gpat_atendimento`
--

DROP TABLE IF EXISTS `gpat_atendimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gpat_atendimento` (
  `id_gpat` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('ABERTO','EM_ATENDIMENTO','FINALIZADO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ABERTO',
  `id_cliente` bigint NOT NULL,
  `tipo_prescritor` enum('INTERNO','EXTERNO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'EXTERNO',
  `id_usuario_medico` bigint DEFAULT NULL,
  `id_prescritor_externo` bigint DEFAULT NULL,
  `data_emissao` date DEFAULT NULL,
  `data_validade` date DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_sessao_abertura` bigint DEFAULT NULL,
  `id_sessao_fechamento` bigint DEFAULT NULL,
  `id_usuario_abertura` bigint DEFAULT NULL,
  `id_usuario_fechamento` bigint DEFAULT NULL,
  PRIMARY KEY (`id_gpat`),
  UNIQUE KEY `uk_gpat_codigo` (`codigo`),
  KEY `idx_gpat_status` (`status`),
  KEY `idx_gpat_cliente` (`id_cliente`),
  KEY `idx_gpat_prescritor` (`id_prescritor_externo`),
  KEY `fk_gpat_usuario_medico` (`id_usuario_medico`),
  KEY `fk_gpat_sessao_abertura` (`id_sessao_abertura`),
  KEY `fk_gpat_sessao_fechamento` (`id_sessao_fechamento`),
  CONSTRAINT `fk_gpat_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  CONSTRAINT `fk_gpat_prescritor_ext` FOREIGN KEY (`id_prescritor_externo`) REFERENCES `prescritor_externo` (`id_prescritor_externo`),
  CONSTRAINT `fk_gpat_sessao_abertura` FOREIGN KEY (`id_sessao_abertura`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_gpat_sessao_fechamento` FOREIGN KEY (`id_sessao_fechamento`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_gpat_usuario_medico` FOREIGN KEY (`id_usuario_medico`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gpat_atendimento`
--

LOCK TABLES `gpat_atendimento` WRITE;
/*!40000 ALTER TABLE `gpat_atendimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `gpat_atendimento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gpat_dispensacao`
--

DROP TABLE IF EXISTS `gpat_dispensacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gpat_dispensacao` (
  `id_gpat_dispensacao` bigint NOT NULL AUTO_INCREMENT,
  `id_gpat_item` bigint NOT NULL,
  `id_lote` bigint NOT NULL,
  `quantidade` decimal(10,2) NOT NULL,
  `id_local_estoque` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `status` enum('ENTREGUE','ESTORNADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ENTREGUE',
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `entregue_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estornado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_gpat_dispensacao`),
  KEY `idx_gpat_disp_item` (`id_gpat_item`),
  KEY `idx_gpat_disp_lote` (`id_lote`),
  KEY `idx_gpat_disp_status` (`status`),
  KEY `fk_gpat_disp_usuario` (`id_usuario`),
  KEY `fk_gpat_disp_sessao` (`id_sessao_usuario`),
  KEY `fk_gpat_disp_local` (`id_local_estoque`),
  CONSTRAINT `fk_gpat_disp_item` FOREIGN KEY (`id_gpat_item`) REFERENCES `gpat_item` (`id_gpat_item`) ON DELETE CASCADE,
  CONSTRAINT `fk_gpat_disp_local` FOREIGN KEY (`id_local_estoque`) REFERENCES `local_atendimento` (`id_local`),
  CONSTRAINT `fk_gpat_disp_lote` FOREIGN KEY (`id_lote`) REFERENCES `farmaco_lote` (`id_lote`),
  CONSTRAINT `fk_gpat_disp_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_gpat_disp_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gpat_dispensacao`
--

LOCK TABLES `gpat_dispensacao` WRITE;
/*!40000 ALTER TABLE `gpat_dispensacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `gpat_dispensacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gpat_evento`
--

DROP TABLE IF EXISTS `gpat_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gpat_evento` (
  `id_gpat_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_gpat` bigint NOT NULL,
  `tipo_evento` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `detalhes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_gpat_evento`),
  KEY `idx_gpat_evento_gpat` (`id_gpat`),
  KEY `idx_gpat_evento_tipo` (`tipo_evento`),
  KEY `fk_gpat_evento_usuario` (`id_usuario`),
  KEY `fk_gpat_evento_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_gpat_evento_gpat` FOREIGN KEY (`id_gpat`) REFERENCES `gpat_atendimento` (`id_gpat`) ON DELETE CASCADE,
  CONSTRAINT `fk_gpat_evento_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_gpat_evento_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gpat_evento`
--

LOCK TABLES `gpat_evento` WRITE;
/*!40000 ALTER TABLE `gpat_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `gpat_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gpat_item`
--

DROP TABLE IF EXISTS `gpat_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gpat_item` (
  `id_gpat_item` bigint NOT NULL AUTO_INCREMENT,
  `id_gpat` bigint NOT NULL,
  `id_farmaco` bigint NOT NULL,
  `quantidade_total` decimal(10,2) NOT NULL,
  `unidade_medida` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `posologia` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `dias` int DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `status` enum('ATIVO','SUSPENSO','ENCERRADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATIVO',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_gpat_item`),
  KEY `idx_gpat_item_gpat` (`id_gpat`),
  KEY `idx_gpat_item_farmaco` (`id_farmaco`),
  CONSTRAINT `fk_gpat_item_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`),
  CONSTRAINT `fk_gpat_item_gpat` FOREIGN KEY (`id_gpat`) REFERENCES `gpat_atendimento` (`id_gpat`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gpat_item`
--

LOCK TABLES `gpat_item` WRITE;
/*!40000 ALTER TABLE `gpat_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `gpat_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hardening_sp_excecao`
--

DROP TABLE IF EXISTS `hardening_sp_excecao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hardening_sp_excecao` (
  `sp_nome` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `motivo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`sp_nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hardening_sp_excecao`
--

LOCK TABLES `hardening_sp_excecao` WRITE;
/*!40000 ALTER TABLE `hardening_sp_excecao` DISABLE KEYS */;
/*!40000 ALTER TABLE `hardening_sp_excecao` ENABLE KEYS */;
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
  `cid10` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
-- Table structure for table `hospital_leitos`
--

DROP TABLE IF EXISTS `hospital_leitos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hospital_leitos` (
  `id_leito` int NOT NULL AUTO_INCREMENT,
  `id_unidade` int NOT NULL,
  `nome_leito` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_leito` enum('OBSERVACAO','EMERGENCIA','INTERNACAO','ISOLAMENTO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('LIVRE','OCUPADO','RESERVADO','LIMPEZA','MANUTENCAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'LIVRE',
  `id_atendimento_atual` bigint DEFAULT NULL,
  PRIMARY KEY (`id_leito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hospital_leitos`
--

LOCK TABLES `hospital_leitos` WRITE;
/*!40000 ALTER TABLE `hospital_leitos` DISABLE KEYS */;
/*!40000 ALTER TABLE `hospital_leitos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `integracao_mensageria_externa`
--

DROP TABLE IF EXISTS `integracao_mensageria_externa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `integracao_mensageria_externa` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `provedor_externo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo_mensagem` enum('HL7_ORU','HL7_ADT','FHIR_JSON') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `conteudo_raw` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `status_processamento` enum('PENDENTE','PROCESSADO','ERRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_recebimento` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `integracao_mensageria_externa`
--

LOCK TABLES `integracao_mensageria_externa` WRITE;
/*!40000 ALTER TABLE `integracao_mensageria_externa` DISABLE KEYS */;
/*!40000 ALTER TABLE `integracao_mensageria_externa` ENABLE KEYS */;
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
  `motivo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('SOLICITADA','RESPONDIDA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'SOLICITADA',
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
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `gravidade` enum('LEVE','MODERADA','GRAVE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'LEVE',
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
  `tipo` enum('OBSERVACAO','INTERNACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `motivo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `status` enum('ATIVA','ENCERRADA','TRANSFERIDA','OBITO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ATIVA',
  `data_entrada` datetime NOT NULL,
  `id_usuario_entrada` bigint DEFAULT NULL,
  `data_saida` datetime DEFAULT NULL,
  `id_usuario_saida` bigint DEFAULT NULL,
  `motivo_alta` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `encerrado_em` datetime DEFAULT NULL,
  `precaucao` enum('PADRAO','CONTATO','GOTICULAS','AEROSSOIS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PADRAO',
  `previsao_alta` datetime DEFAULT NULL,
  `id_medico_responsavel` bigint DEFAULT NULL,
  `id_sessao_usuario_entrada` bigint DEFAULT NULL,
  `id_sessao_usuario_saida` bigint DEFAULT NULL,
  `id_local_operacional_entrada` bigint DEFAULT NULL,
  `id_local_operacional_saida` bigint DEFAULT NULL,
  `id_unidade_entrada` bigint DEFAULT NULL,
  `id_unidade_saida` bigint DEFAULT NULL,
  PRIMARY KEY (`id_internacao`),
  KEY `idx_ffa` (`id_ffa`),
  KEY `idx_status` (`status`),
  KEY `idx_leito` (`id_leito`),
  KEY `idx_internacao_ffa_status` (`id_ffa`,`status`),
  KEY `idx_internacao_leito_status` (`id_leito`,`status`),
  KEY `idx_internacao_datas` (`data_entrada`,`data_saida`),
  KEY `idx_internacao_status_data` (`status`,`data_entrada`,`data_saida`),
  CONSTRAINT `fk_internacao_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_internacao_leito` FOREIGN KEY (`id_leito`) REFERENCES `leito` (`id_leito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Internação e observação clínica';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao`
--

LOCK TABLES `internacao` WRITE;
/*!40000 ALTER TABLE `internacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internacao_braden_avaliacao`
--

DROP TABLE IF EXISTS `internacao_braden_avaliacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao_braden_avaliacao` (
  `id_internacao_braden_avaliacao` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `data_hora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `percepcao_sensorial` tinyint NOT NULL,
  `umidade` tinyint NOT NULL,
  `atividade` tinyint NOT NULL,
  `mobilidade` tinyint NOT NULL,
  `nutricao` tinyint NOT NULL,
  `friccao_cisalhamento` tinyint NOT NULL,
  `score_total` tinyint NOT NULL,
  `risco` enum('SEM_RISCO','LEVE','MODERADO','ALTO','MUITO_ALTO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `observacoes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_documento` bigint DEFAULT NULL,
  `id_usuario_responsavel` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_internacao_braden_avaliacao`),
  KEY `idx_iba_internacao` (`id_internacao`),
  KEY `idx_iba_data_hora` (`data_hora`),
  KEY `idx_iba_usuario` (`id_usuario_responsavel`),
  KEY `idx_iba_sessao` (`id_sessao_usuario`),
  KEY `idx_iba_documento` (`id_documento`),
  CONSTRAINT `fk_iba_documento` FOREIGN KEY (`id_documento`) REFERENCES `documento_emissao` (`id_documento`),
  CONSTRAINT `fk_iba_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `fk_iba_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_iba_usuario` FOREIGN KEY (`id_usuario_responsavel`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `chk_iba_at` CHECK ((`atividade` between 1 and 4)),
  CONSTRAINT `chk_iba_fc` CHECK ((`friccao_cisalhamento` between 1 and 3)),
  CONSTRAINT `chk_iba_mo` CHECK ((`mobilidade` between 1 and 4)),
  CONSTRAINT `chk_iba_nu` CHECK ((`nutricao` between 1 and 4)),
  CONSTRAINT `chk_iba_ps` CHECK ((`percepcao_sensorial` between 1 and 4)),
  CONSTRAINT `chk_iba_total` CHECK ((`score_total` between 6 and 23)),
  CONSTRAINT `chk_iba_um` CHECK ((`umidade` between 1 and 4))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao_braden_avaliacao`
--

LOCK TABLES `internacao_braden_avaliacao` WRITE;
/*!40000 ALTER TABLE `internacao_braden_avaliacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_braden_avaliacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internacao_cuidados`
--

DROP TABLE IF EXISTS `internacao_cuidados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao_cuidados` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_prescricao_item` bigint NOT NULL,
  `tipo_cuidado` enum('DECUBITO','CURATIVO','DRENO','SONDA','OXIGENIO','SINAIS_VITAIS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `posicionamento` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `frequencia_checagem` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cuidado_presc` (`id_prescricao_item`),
  CONSTRAINT `fk_cuidado_presc` FOREIGN KEY (`id_prescricao_item`) REFERENCES `prescricao_itens` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao_cuidados`
--

LOCK TABLES `internacao_cuidados` WRITE;
/*!40000 ALTER TABLE `internacao_cuidados` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_cuidados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internacao_dietas`
--

DROP TABLE IF EXISTS `internacao_dietas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao_dietas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_prescricao_item` bigint NOT NULL,
  `consistencia` enum('LIVRE','BRANDAS','PASTOSA','LIQUIDA','ZERO','ENTERAL','PARENTERAL') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `restricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `volume_total_dia` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_dieta_presc` (`id_prescricao_item`),
  CONSTRAINT `fk_dieta_presc` FOREIGN KEY (`id_prescricao_item`) REFERENCES `prescricao_itens` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao_dietas`
--

LOCK TABLES `internacao_dietas` WRITE;
/*!40000 ALTER TABLE `internacao_dietas` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_dietas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internacao_dispositivos`
--

DROP TABLE IF EXISTS `internacao_dispositivos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao_dispositivos` (
  `id_dispositivo` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `tipo` enum('CVC','SVD','SNG','SNE','DRENO','CATETER_PERIFERICO','CANULA_TRAQUEO') NOT NULL,
  `localizacao` varchar(100) DEFAULT NULL,
  `data_insercao` datetime DEFAULT CURRENT_TIMESTAMP,
  `prazo_troca_dias` int DEFAULT '7',
  `data_prevista_troca` datetime DEFAULT NULL,
  `id_usuario_insercao` bigint NOT NULL,
  `status` enum('ATIVO','REMOVIDO','SUBSTITUIDO') DEFAULT 'ATIVO',
  PRIMARY KEY (`id_dispositivo`),
  KEY `fk_disp_internacao` (`id_internacao`),
  CONSTRAINT `fk_disp_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao_dispositivos`
--

LOCK TABLES `internacao_dispositivos` WRITE;
/*!40000 ALTER TABLE `internacao_dispositivos` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_dispositivos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internacao_ferida_avaliacao`
--

DROP TABLE IF EXISTS `internacao_ferida_avaliacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao_ferida_avaliacao` (
  `id_internacao_ferida_avaliacao` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `data_hora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tipo` enum('FERIDA','LPP','CIRURGICA','OUTRA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'FERIDA',
  `local_anatomico` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `estagio_lpp` enum('I','II','III','IV','NAO_CLASSIFICAVEL','TECIDO_PROFUNDO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tamanho_cm` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `aspecto` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `exsudato` enum('AUSENTE','POUCO','MODERADO','ABUNDANTE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `odor` enum('NAO','SIM') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dor` enum('NAO','SIM') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `curativo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `observacoes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_documento` bigint DEFAULT NULL,
  `id_usuario_responsavel` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_internacao_ferida_avaliacao`),
  KEY `idx_ifa_internacao` (`id_internacao`),
  KEY `idx_ifa_data_hora` (`data_hora`),
  KEY `idx_ifa_usuario` (`id_usuario_responsavel`),
  KEY `idx_ifa_sessao` (`id_sessao_usuario`),
  KEY `idx_ifa_documento` (`id_documento`),
  CONSTRAINT `fk_ifa_documento` FOREIGN KEY (`id_documento`) REFERENCES `documento_emissao` (`id_documento`),
  CONSTRAINT `fk_ifa_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `fk_ifa_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_ifa_usuario` FOREIGN KEY (`id_usuario_responsavel`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao_ferida_avaliacao`
--

LOCK TABLES `internacao_ferida_avaliacao` WRITE;
/*!40000 ALTER TABLE `internacao_ferida_avaliacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_ferida_avaliacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internacao_historico`
--

DROP TABLE IF EXISTS `internacao_historico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao_historico` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `evento` enum('ENTRADA','TROCA_LEITO','ALTA','TRANSFERENCIA','OBITO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_internacao` (`id_internacao`),
  KEY `idx_intern_hist_internacao_data` (`id_internacao`,`criado_em`)
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
-- Table structure for table `internacao_medicacao_administracao`
--

DROP TABLE IF EXISTS `internacao_medicacao_administracao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao_medicacao_administracao` (
  `id_internacao_medicacao_administracao` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `id_internacao_prescricao_item` bigint NOT NULL,
  `data_hora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('ADMINISTRADO','RECUSADO','SUSPENSO','NAO_DISPONIVEL') NOT NULL DEFAULT 'ADMINISTRADO',
  `dose_aplicada` varchar(60) DEFAULT NULL,
  `via_administracao` varchar(60) DEFAULT NULL,
  `observacoes` text,
  `id_usuario_responsavel` bigint NOT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_internacao_medicacao_administracao`),
  KEY `idx_ima_internacao` (`id_internacao`),
  KEY `idx_ima_item` (`id_internacao_prescricao_item`),
  KEY `idx_ima_data_hora` (`data_hora`),
  KEY `idx_ima_usuario` (`id_usuario_responsavel`),
  KEY `idx_ima_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_ima_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `fk_ima_item` FOREIGN KEY (`id_internacao_prescricao_item`) REFERENCES `internacao_prescricao_item` (`id_internacao_prescricao_item`),
  CONSTRAINT `fk_ima_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_ima_usuario` FOREIGN KEY (`id_usuario_responsavel`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao_medicacao_administracao`
--

LOCK TABLES `internacao_medicacao_administracao` WRITE;
/*!40000 ALTER TABLE `internacao_medicacao_administracao` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_medicacao_administracao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internacao_movimentacao`
--

DROP TABLE IF EXISTS `internacao_movimentacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao_movimentacao` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `id_leito_origem` bigint DEFAULT NULL,
  `id_leito_destino` bigint NOT NULL,
  `id_usuario_transferencia` bigint NOT NULL,
  `data_movimentacao` datetime DEFAULT CURRENT_TIMESTAMP,
  `motivo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `id_unidade` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_mov_internacao` (`id_internacao`),
  KEY `idx_intern_mov_internacao_data` (`id_internacao`,`data_movimentacao`),
  KEY `idx_mov_sessao_data` (`id_sessao_usuario`,`data_movimentacao`),
  CONSTRAINT `fk_mov_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao_movimentacao`
--

LOCK TABLES `internacao_movimentacao` WRITE;
/*!40000 ALTER TABLE `internacao_movimentacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_movimentacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internacao_prescricao`
--

DROP TABLE IF EXISTS `internacao_prescricao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao_prescricao` (
  `id_internacao_prescricao` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `data_prescricao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('ATIVA','SUSPENSA','ENCERRADA') NOT NULL DEFAULT 'ATIVA',
  `observacoes` text,
  `id_usuario_prescritor` bigint NOT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_internacao_prescricao`),
  KEY `idx_ip_internacao` (`id_internacao`),
  KEY `idx_ip_data` (`data_prescricao`),
  KEY `idx_ip_status` (`status`),
  KEY `idx_ip_usuario` (`id_usuario_prescritor`),
  KEY `idx_ip_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_ip_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `fk_ip_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_ip_usuario` FOREIGN KEY (`id_usuario_prescritor`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao_prescricao`
--

LOCK TABLES `internacao_prescricao` WRITE;
/*!40000 ALTER TABLE `internacao_prescricao` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_prescricao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internacao_prescricao_item`
--

DROP TABLE IF EXISTS `internacao_prescricao_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao_prescricao_item` (
  `id_internacao_prescricao_item` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao_prescricao` bigint NOT NULL,
  `tipo` enum('MEDICAMENTO','DIETA','CUIDADO','OUTRO') NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `dosagem` varchar(60) DEFAULT NULL,
  `frequencia` varchar(60) DEFAULT NULL,
  `via_administracao` varchar(60) DEFAULT NULL,
  `inicio_em` datetime DEFAULT NULL,
  `fim_em` datetime DEFAULT NULL,
  `status` enum('ATIVO','SUSPENSO','ENCERRADO') NOT NULL DEFAULT 'ATIVO',
  `observacoes` text,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_internacao_prescricao_item`),
  KEY `idx_ipi_prescricao` (`id_internacao_prescricao`),
  KEY `idx_ipi_tipo` (`tipo`),
  KEY `idx_ipi_status` (`status`),
  CONSTRAINT `fk_ipi_prescricao` FOREIGN KEY (`id_internacao_prescricao`) REFERENCES `internacao_prescricao` (`id_internacao_prescricao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao_prescricao_item`
--

LOCK TABLES `internacao_prescricao_item` WRITE;
/*!40000 ALTER TABLE `internacao_prescricao_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_prescricao_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internacao_registro_enfermagem`
--

DROP TABLE IF EXISTS `internacao_registro_enfermagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao_registro_enfermagem` (
  `id_internacao_registro_enfermagem` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `data_hora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `turno` enum('MANHA','TARDE','NOITE','INDEFINIDO') NOT NULL DEFAULT 'INDEFINIDO',
  `periodicidade` enum('2H','4H','6H','TURNO','EVENTUAL') NOT NULL DEFAULT 'EVENTUAL',
  `pressao_arterial` varchar(10) DEFAULT NULL,
  `temperatura` decimal(4,1) DEFAULT NULL,
  `frequencia_cardiaca` int DEFAULT NULL,
  `frequencia_respiratoria` int DEFAULT NULL,
  `saturacao_o2` int DEFAULT NULL,
  `glicemia` int DEFAULT NULL,
  `entradas_ml` int DEFAULT NULL,
  `saidas_ml` int DEFAULT NULL,
  `diurese_evacuacao` text,
  `observacoes` text,
  `id_usuario_responsavel` bigint NOT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_internacao_registro_enfermagem`),
  KEY `idx_ire_internacao` (`id_internacao`),
  KEY `idx_ire_data_hora` (`data_hora`),
  KEY `idx_ire_usuario` (`id_usuario_responsavel`),
  KEY `idx_ire_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_ire_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `fk_ire_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_ire_usuario` FOREIGN KEY (`id_usuario_responsavel`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao_registro_enfermagem`
--

LOCK TABLES `internacao_registro_enfermagem` WRITE;
/*!40000 ALTER TABLE `internacao_registro_enfermagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_registro_enfermagem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internacao_turno_registro`
--

DROP TABLE IF EXISTS `internacao_turno_registro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacao_turno_registro` (
  `id_internacao_turno_registro` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `data_referencia` date NOT NULL,
  `turno` enum('MANHA','TARDE','NOITE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `observacoes_gerais` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_usuario_responsavel` bigint NOT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_internacao_turno_registro`),
  KEY `idx_itr_internacao` (`id_internacao`),
  KEY `idx_itr_data_turno` (`data_referencia`,`turno`),
  KEY `idx_itr_criado_em` (`criado_em`),
  KEY `idx_itr_usuario` (`id_usuario_responsavel`),
  KEY `fk_itr_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_itr_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `fk_itr_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_itr_usuario` FOREIGN KEY (`id_usuario_responsavel`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacao_turno_registro`
--

LOCK TABLES `internacao_turno_registro` WRITE;
/*!40000 ALTER TABLE `internacao_turno_registro` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_turno_registro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lab_amostra`
--

DROP TABLE IF EXISTS `lab_amostra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lab_amostra` (
  `id_amostra` bigint NOT NULL AUTO_INCREMENT,
  `id_protocolo` bigint NOT NULL,
  `codigo_amostra` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_material` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('GERADO','COLETADO','EM_TRANSPORTE','NA_BANCADA','CONCLUIDO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'GERADO',
  `impresso` tinyint(1) NOT NULL DEFAULT '0',
  `coletado_em` datetime DEFAULT NULL,
  `id_sessao_coleta` bigint DEFAULT NULL,
  `id_usuario_coleta` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_amostra`),
  UNIQUE KEY `uk_lab_codigo` (`codigo_amostra`),
  UNIQUE KEY `uk_lab_proto` (`id_protocolo`),
  KEY `idx_lab_status` (`status`,`criado_em`),
  KEY `fk_lab_sessao_col` (`id_sessao_coleta`),
  KEY `fk_lab_user_col` (`id_usuario_coleta`),
  CONSTRAINT `fk_lab_proto` FOREIGN KEY (`id_protocolo`) REFERENCES `procedimento_protocolo` (`id_protocolo`),
  CONSTRAINT `fk_lab_sessao_col` FOREIGN KEY (`id_sessao_coleta`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_lab_user_col` FOREIGN KEY (`id_usuario_coleta`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lab_amostra`
--

LOCK TABLES `lab_amostra` WRITE;
/*!40000 ALTER TABLE `lab_amostra` DISABLE KEYS */;
/*!40000 ALTER TABLE `lab_amostra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lab_evento`
--

DROP TABLE IF EXISTS `lab_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lab_evento` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_pedido` bigint NOT NULL,
  `status_novo` varchar(50) DEFAULT NULL,
  `id_usuario` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `payload_auditoria` text,
  PRIMARY KEY (`id`),
  KEY `fk_evento_lab_pedido` (`id_pedido`),
  CONSTRAINT `fk_evento_lab_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `lab_pedido` (`id_pedido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lab_evento`
--

LOCK TABLES `lab_evento` WRITE;
/*!40000 ALTER TABLE `lab_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `lab_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lab_pedido`
--

DROP TABLE IF EXISTS `lab_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lab_pedido` (
  `id_pedido` bigint NOT NULL AUTO_INCREMENT,
  `protocolo_interno` varchar(30) NOT NULL,
  `id_senha` bigint NOT NULL,
  `id_ffa` bigint NOT NULL,
  `id_atendimento` bigint DEFAULT NULL,
  `id_laboratorio` int NOT NULL,
  `status` enum('SOLICITADO','COLETADO','ENVIADO','RECEBIDO_LAB','FINALIZADO','CANCELADO') DEFAULT 'SOLICITADO',
  `impresso` tinyint(1) DEFAULT '0',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pedido`),
  UNIQUE KEY `protocolo_interno` (`protocolo_interno`),
  KEY `fk_lab_senha` (`id_senha`),
  KEY `fk_lab_ffa` (`id_ffa`),
  CONSTRAINT `fk_lab_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_lab_senha` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=300004458 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lab_pedido`
--

LOCK TABLES `lab_pedido` WRITE;
/*!40000 ALTER TABLE `lab_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `lab_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lab_protocolo_interno`
--

DROP TABLE IF EXISTS `lab_protocolo_interno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lab_protocolo_interno` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `codigo_amostra` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo_material` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_laboratorial` enum('COLETADO','EM_TRANSPORTE','NA_BANCADA','CONCLUIDO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `impresso` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_amostra` (`codigo_amostra`),
  KEY `fk_lab_protocolo_ffa_v1` (`id_ffa`),
  CONSTRAINT `fk_lab_protocolo_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lab_protocolo_interno`
--

LOCK TABLES `lab_protocolo_interno` WRITE;
/*!40000 ALTER TABLE `lab_protocolo_interno` DISABLE KEYS */;
/*!40000 ALTER TABLE `lab_protocolo_interno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lab_resultado`
--

DROP TABLE IF EXISTS `lab_resultado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lab_resultado` (
  `id_resultado` bigint NOT NULL AUTO_INCREMENT,
  `protocolo_interno` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_ffa` bigint NOT NULL,
  `resultado_link` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `resultado_texto` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `critico` tinyint(1) NOT NULL DEFAULT '0',
  `recebido_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  PRIMARY KEY (`id_resultado`),
  KEY `idx_lab_res_protocolo` (`protocolo_interno`),
  KEY `idx_lab_res_ffa` (`id_ffa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lab_resultado`
--

LOCK TABLES `lab_resultado` WRITE;
/*!40000 ALTER TABLE `lab_resultado` DISABLE KEYS */;
/*!40000 ALTER TABLE `lab_resultado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `laboratorio_protocolo`
--

DROP TABLE IF EXISTS `laboratorio_protocolo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `laboratorio_protocolo` (
  `id_laboratorio_protocolo` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_gpat` bigint NOT NULL,
  `id_pedido_item` bigint NOT NULL,
  `id_codigo_universal` bigint NOT NULL,
  `codigo` varchar(60) NOT NULL,
  `barcode` varchar(60) NOT NULL,
  `status` enum('GERADO','COLETADO','ENVIADO','RECEBIDO','RESULTADO','CANCELADO') NOT NULL DEFAULT 'GERADO',
  `sistema_externo` varchar(50) DEFAULT NULL,
  `codigo_externo` varchar(80) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_laboratorio_protocolo`),
  UNIQUE KEY `uk_lab_codigo` (`codigo`),
  UNIQUE KEY `uk_lab_item` (`id_pedido_item`),
  KEY `ix_lab_ffa` (`id_ffa`),
  KEY `ix_lab_gpat` (`id_gpat`),
  KEY `ix_lab_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `laboratorio_protocolo`
--

LOCK TABLES `laboratorio_protocolo` WRITE;
/*!40000 ALTER TABLE `laboratorio_protocolo` DISABLE KEYS */;
/*!40000 ALTER TABLE `laboratorio_protocolo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `laboratorio_protocolo_evento`
--

DROP TABLE IF EXISTS `laboratorio_protocolo_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `laboratorio_protocolo_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_laboratorio_protocolo` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `evento` varchar(40) NOT NULL,
  `detalhe` varchar(255) DEFAULT NULL,
  `payload_json` json DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `ix_lab_evt_proto` (`id_laboratorio_protocolo`),
  KEY `ix_lab_evt_evt` (`evento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `laboratorio_protocolo_evento`
--

LOCK TABLES `laboratorio_protocolo_evento` WRITE;
/*!40000 ALTER TABLE `laboratorio_protocolo_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `laboratorio_protocolo_evento` ENABLE KEYS */;
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
  `identificacao` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('DISPONIVEL','OCUPADO','RESERVADO','LIMPEZA','MANUTENCAO','INTERDITADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'DISPONIVEL',
  PRIMARY KEY (`id_leito`),
  UNIQUE KEY `uk_setor_leito` (`id_setor`,`identificacao`),
  KEY `idx_leito_setor_status` (`id_setor`,`status`),
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
  `nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('RECEPCAO','TRIAGEM','CONSULTORIO','EMERGENCIA','OBSERVACAO','INTERNACAO','MEDICACAO','RX','LABORATORIO','ECG','NOTIFICACAO','FARMACIA','COPA','COLETA','OUTROS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_unidade` bigint NOT NULL,
  PRIMARY KEY (`id_local`),
  KEY `fk_local_sistema` (`id_unidade`),
  CONSTRAINT `fk_local_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
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
  `id_local_estoque` bigint DEFAULT NULL,
  `sala` varchar(50) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `exibe_em_painel_publico` tinyint(1) NOT NULL DEFAULT '1',
  `gera_tts_publico` tinyint(1) NOT NULL DEFAULT '1',
  `eh_nao_definida` tinyint(1) NOT NULL DEFAULT '0',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_local_operacional`),
  UNIQUE KEY `uk_localop` (`id_unidade`,`id_sistema`,`codigo`),
  KEY `idx_localop_unidade` (`id_unidade`),
  KEY `idx_localop_sistema` (`id_sistema`),
  KEY `idx_localop_estoque` (`id_local_estoque`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `local_operacional`
--

LOCK TABLES `local_operacional` WRITE;
/*!40000 ALTER TABLE `local_operacional` DISABLE KEYS */;
INSERT INTO `local_operacional` VALUES (1,2,4,'ADM01','Administração','ADMIN',NULL,NULL,1,1,1,0,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(2,2,4,'REC01','Recepção','RECEPCAO',NULL,NULL,1,1,1,0,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(3,2,4,'TRI01','Triagem','TRIAGEM',NULL,NULL,1,1,1,0,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(4,2,4,'MEDC1','Médico Clínico','MEDICO_CLINICO',NULL,NULL,1,1,1,0,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(5,2,4,'MEDP1','Médico Pediátrico','MEDICO_PEDIATRICO',NULL,NULL,1,1,1,0,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(6,2,4,'TOT01','Totem','OUTRO',NULL,NULL,1,1,1,0,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(8,2,4,'RECEPCAO_ND','[NAO DEFINIDA] RECEPCAO','RECEPCAO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:15'),(9,2,4,'TRIAGEM_ND','[NAO DEFINIDA] TRIAGEM','TRIAGEM',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:15'),(10,2,4,'MEDICO_CLINICO_ND','[NAO DEFINIDA] MEDICO_CLINICO','MEDICO_CLINICO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:15'),(11,2,4,'MEDICO_PEDIATRICO_ND','[NAO DEFINIDA] MEDICO_PEDIATRICO','MEDICO_PEDIATRICO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:15'),(12,2,4,'MEDICACAO_ND','[NAO DEFINIDA] MEDICACAO','MEDICACAO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:16'),(13,2,4,'RX_ND','[NAO DEFINIDA] RX','RX',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:16'),(14,2,4,'LABORATORIO_ND','[NAO DEFINIDA] LABORATORIO','LABORATORIO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:16'),(15,2,4,'ECG_ND','[NAO DEFINIDA] ECG','ECG',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:17'),(16,2,4,'OBSERVACAO_ND','[NAO DEFINIDA] OBSERVACAO','OBSERVACAO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:17'),(17,2,4,'INTERNACAO_ND','[NAO DEFINIDA] INTERNACAO','INTERNACAO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:17'),(18,2,4,'FARMACIA_ND','[NAO DEFINIDA] FARMACIA','FARMACIA',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:18'),(19,2,4,'TI_ND','[NAO DEFINIDA] TI','TI',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:18'),(20,2,4,'MANUTENCAO_ND','[NAO DEFINIDA] MANUTENCAO','MANUTENCAO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:18'),(21,2,4,'ENG_CLINICA_ND','[NAO DEFINIDA] ENG_CLINICA','ENG_CLINICA',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:18'),(22,2,4,'GASOTERAPIA_ND','[NAO DEFINIDA] GASOTERAPIA','GASOTERAPIA',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:18'),(23,2,4,'ASSIST_SOCIAL_ND','[NAO DEFINIDA] ASSIST_SOCIAL','ASSIST_SOCIAL',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:18'),(24,2,4,'SALA_NOTIFICACAO_ND','[NAO DEFINIDA] SALA_NOTIFICACAO','SALA_NOTIFICACAO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:19'),(25,2,4,'ADMIN_ND','[NAO DEFINIDA] ADMIN','ADMIN',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:19'),(26,2,4,'OUTRO_ND','[NAO DEFINIDA] OUTRO','OUTRO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 05:50:01','2026-02-10 15:47:19'),(27,3,5,'RECEPCAO_ND','[NAO DEFINIDA] RECEPCAO','RECEPCAO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:17:32','2026-02-10 15:47:19'),(28,3,5,'TRIAGEM_ND','[NAO DEFINIDA] TRIAGEM','TRIAGEM',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:17:32','2026-02-10 15:47:19'),(29,3,5,'MEDICO_CLINICO_ND','[NAO DEFINIDA] MEDICO CLINICO','MEDICO_CLINICO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:17:32','2026-02-10 15:47:20'),(30,3,5,'MEDICO_PEDIATRICO_ND','[NAO DEFINIDA] MEDICO PEDIATRICO','MEDICO_PEDIATRICO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:17:32','2026-02-10 15:47:20'),(31,3,5,'MEDICACAO_ND','[NAO DEFINIDA] MEDICACAO','MEDICACAO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:17:32','2026-02-10 15:47:20'),(32,3,5,'RX_ND','[NAO DEFINIDA] RX','RX',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:17:32','2026-02-10 15:47:20'),(33,3,5,'LABORATORIO_ND','[NAO DEFINIDA] LABORATORIO','LABORATORIO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:17:32','2026-02-10 15:47:20'),(34,3,5,'OBSERVACAO_ND','[NAO DEFINIDA] OBSERVACAO','OBSERVACAO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:17:32','2026-02-10 15:47:21'),(35,3,5,'INTERNACAO_ND','[NAO DEFINIDA] INTERNACAO','INTERNACAO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:17:32','2026-02-10 15:47:21'),(36,3,5,'FARMACIA_ND','[NAO DEFINIDA] FARMACIA','FARMACIA',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:17:32','2026-02-10 15:47:21'),(37,3,5,'ADMIN_ND','[NAO DEFINIDA] ADMIN','ADMIN',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:17:32','2026-02-10 15:47:23'),(38,3,5,'ECG_ND','[NAO DEFINIDA] ECG','ECG',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:38:40','2026-02-10 15:47:20'),(39,3,5,'TI_ND','[NAO DEFINIDA] TI','TI',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:38:40','2026-02-10 15:47:21'),(40,3,5,'MANUTENCAO_ND','[NAO DEFINIDA] MANUTENCAO','MANUTENCAO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:38:40','2026-02-10 15:47:22'),(41,3,5,'ENG_CLINICA_ND','[NAO DEFINIDA] ENG_CLINICA','ENG_CLINICA',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:38:40','2026-02-10 15:47:22'),(42,3,5,'GASOTERAPIA_ND','[NAO DEFINIDA] GASOTERAPIA','GASOTERAPIA',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:38:40','2026-02-10 15:47:22'),(43,3,5,'ASSIST_SOCIAL_ND','[NAO DEFINIDA] ASSIST_SOCIAL','ASSIST_SOCIAL',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:38:40','2026-02-10 15:47:22'),(44,3,5,'SALA_NOTIFICACAO_ND','[NAO DEFINIDA] SALA_NOTIFICACAO','SALA_NOTIFICACAO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:38:40','2026-02-10 15:47:23'),(45,3,5,'OUTRO_ND','[NAO DEFINIDA] OUTRO','OUTRO',NULL,'NAO DEFINIDA',1,0,0,1,'2026-02-09 06:38:40','2026-02-10 15:47:24');
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
  `nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('RECEPCAO','MEDICO','TRIAGEM','SUPORTE','ADMIN','GESTAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'RECEPCAO',
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
-- Table structure for table `log_acesso_prontuario`
--

DROP TABLE IF EXISTS `log_acesso_prontuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_acesso_prontuario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `id_atendimento` bigint NOT NULL,
  `ip_maquina` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_hora_acesso` datetime DEFAULT CURRENT_TIMESTAMP,
  `modulo_acessado` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_lgpd_paciente` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_acesso_prontuario`
--

LOCK TABLES `log_acesso_prontuario` WRITE;
/*!40000 ALTER TABLE `log_acesso_prontuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_acesso_prontuario` ENABLE KEYS */;
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
  `acao` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tabela_afetada` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_registro` bigint DEFAULT NULL,
  `antes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `depois` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `justificativa` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_auditoria`
--

LOCK TABLES `log_auditoria` WRITE;
/*!40000 ALTER TABLE `log_auditoria` DISABLE KEYS */;
INSERT INTO `log_auditoria` VALUES (1,10,'INSERT','ffa',1,NULL,'status: ABERTO, paciente: 1',NULL,'2026-01-14 03:52:41'),(2,5,'INSERT','ffa',2,NULL,'status: ABERTO, paciente: 8',NULL,'2026-01-28 06:20:16'),(3,5,'INSERT','ffa',3,NULL,'status: ABERTO, paciente: 8',NULL,'2026-01-28 06:20:42'),(4,5,'INSERT','ffa',4,NULL,'status: EM_TRIAGEM, paciente: 8',NULL,'2026-01-28 06:21:25'),(5,5,'INSERT','ffa',5,NULL,'status: ABERTO, paciente: 1',NULL,'2026-01-28 06:21:57'),(6,5,'INSERT','ffa',6,NULL,'status: ABERTO, paciente: 8',NULL,'2026-01-28 06:22:20'),(7,5,'INSERT','ffa',7,NULL,'status: ABERTO, paciente: 1',NULL,'2026-01-28 06:22:54'),(8,5,'INSERT','ffa',8,NULL,'status: ABERTO, paciente: 8',NULL,'2026-01-28 06:26:06'),(9,5,'INSERT','ffa',9,NULL,'status: ABERTO, paciente: 31',NULL,'2026-01-28 06:29:42'),(10,5,'INSERT','ffa',10,NULL,'status: ABERTO, paciente: 17',NULL,'2026-01-28 06:30:20'),(11,5,'INSERT','ffa',11,NULL,'status: ABERTO, paciente: 17',NULL,'2026-01-28 06:31:19');
/*!40000 ALTER TABLE `log_auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_leitura_prontuario`
--

DROP TABLE IF EXISTS `log_leitura_prontuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_leitura_prontuario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `motivo_acesso` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_leitura_prontuario`
--

LOCK TABLES `log_leitura_prontuario` WRITE;
/*!40000 ALTER TABLE `log_leitura_prontuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_leitura_prontuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logradouro`
--

DROP TABLE IF EXISTS `logradouro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logradouro` (
  `id_logradouro` bigint NOT NULL AUTO_INCREMENT,
  `cep` varchar(9) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `logradouro` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `numero` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `complemento` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bairro` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cidade` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `uf` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `descricao_servico` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `inicio_em` datetime DEFAULT NULL,
  `fim_em` datetime DEFAULT NULL,
  `status` enum('INICIADO','PAUSADO','FINALIZADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'INICIADO',
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
-- Table structure for table `md_arquivo_fonte`
--

DROP TABLE IF EXISTS `md_arquivo_fonte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `md_arquivo_fonte` (
  `id_md_arquivo_fonte` bigint NOT NULL AUTO_INCREMENT,
  `tipo` enum('CID10','CNES','SIGTAP','SIGPAT','OUTRO') NOT NULL,
  `competencia` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `origem` varchar(120) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `url_origem` varchar(255) DEFAULT NULL,
  `nome_arquivo` varchar(200) DEFAULT NULL,
  `tamanho_bytes` bigint DEFAULT NULL,
  `sha256` char(64) DEFAULT NULL,
  `baixado_em` datetime DEFAULT NULL,
  `processado_em` datetime DEFAULT NULL,
  `status` enum('PENDENTE','BAIXADO','PROCESSADO','ERRO') NOT NULL DEFAULT 'PENDENTE',
  `mensagem_erro` varchar(500) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_md_arquivo_fonte`),
  KEY `idx_md_fonte_tipo_comp` (`tipo`,`competencia`),
  KEY `idx_md_fonte_status` (`status`),
  KEY `idx_md_fonte_sha` (`sha256`),
  KEY `fk_md_fonte_competencia` (`competencia`),
  CONSTRAINT `fk_md_fonte_competencia` FOREIGN KEY (`competencia`) REFERENCES `md_competencia` (`competencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_arquivo_fonte`
--

LOCK TABLES `md_arquivo_fonte` WRITE;
/*!40000 ALTER TABLE `md_arquivo_fonte` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_arquivo_fonte` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_arquivo_fonte_evento`
--

DROP TABLE IF EXISTS `md_arquivo_fonte_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `md_arquivo_fonte_evento` (
  `id_md_arquivo_fonte_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_md_arquivo_fonte` bigint NOT NULL,
  `ocorrido_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `acao` enum('CRIADO','BAIXADO','PROCESSADO','ERRO','REPROCESSAR') NOT NULL,
  `detalhes` varchar(500) DEFAULT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  PRIMARY KEY (`id_md_arquivo_fonte_evento`),
  KEY `idx_md_fonte_evt_fonte` (`id_md_arquivo_fonte`),
  KEY `idx_md_fonte_evt_dt` (`ocorrido_em`),
  KEY `fk_md_fonte_evt_sessao` (`id_sessao_usuario`),
  KEY `fk_md_fonte_evt_usuario` (`id_usuario`),
  CONSTRAINT `fk_md_fonte_evt_fonte` FOREIGN KEY (`id_md_arquivo_fonte`) REFERENCES `md_arquivo_fonte` (`id_md_arquivo_fonte`),
  CONSTRAINT `fk_md_fonte_evt_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_md_fonte_evt_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_arquivo_fonte_evento`
--

LOCK TABLES `md_arquivo_fonte_evento` WRITE;
/*!40000 ALTER TABLE `md_arquivo_fonte_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_arquivo_fonte_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_cid10`
--

DROP TABLE IF EXISTS `md_cid10`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `md_cid10` (
  `competencia` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `codigo` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `categoria` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `subcategoria` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `capitulo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sexo_restricao` enum('A','M','F') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'A',
  `idade_min_meses` int DEFAULT NULL,
  `idade_max_meses` int DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`competencia`,`codigo`),
  KEY `idx_cid10_codigo` (`codigo`),
  KEY `idx_cid10_comp` (`competencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_cid10`
--

LOCK TABLES `md_cid10` WRITE;
/*!40000 ALTER TABLE `md_cid10` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_cid10` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_cnes_estabelecimento`
--

DROP TABLE IF EXISTS `md_cnes_estabelecimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `md_cnes_estabelecimento` (
  `cnes` char(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `competencia` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nome_fantasia` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `razao_social` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cnpj` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `uf` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `municipio_ibge` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `logradouro` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `numero` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bairro` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cep` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo_gestao` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `esfera_adm` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cnes`),
  KEY `idx_cnes_comp` (`competencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_cnes_estabelecimento`
--

LOCK TABLES `md_cnes_estabelecimento` WRITE;
/*!40000 ALTER TABLE `md_cnes_estabelecimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_cnes_estabelecimento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_competencia`
--

DROP TABLE IF EXISTS `md_competencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `md_competencia` (
  `competencia` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dt_inicio` date DEFAULT NULL,
  `dt_fim` date DEFAULT NULL,
  `ativa` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`competencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_competencia`
--

LOCK TABLES `md_competencia` WRITE;
/*!40000 ALTER TABLE `md_competencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_competencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_sigpat_medicamento`
--

DROP TABLE IF EXISTS `md_sigpat_medicamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `md_sigpat_medicamento` (
  `competencia` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `codigo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `apresentacao` varchar(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `forma_farmaceutica` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `concentracao` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `unidade_medida` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via_administracao` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`competencia`,`codigo`),
  KEY `idx_sigpat_codigo` (`codigo`),
  KEY `idx_sigpat_comp` (`competencia`),
  KEY `idx_sigpat_desc` (`descricao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_sigpat_medicamento`
--

LOCK TABLES `md_sigpat_medicamento` WRITE;
/*!40000 ALTER TABLE `md_sigpat_medicamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_sigpat_medicamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_sigtap_procedimento`
--

DROP TABLE IF EXISTS `md_sigtap_procedimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `md_sigtap_procedimento` (
  `competencia` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `codigo` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `complexidade` enum('BASICA','MEDIA','ALTA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sexo_restricao` enum('A','M','F') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'A',
  `idade_min_meses` int DEFAULT NULL,
  `idade_max_meses` int DEFAULT NULL,
  `valor_sa` decimal(10,2) DEFAULT NULL,
  `valor_sh` decimal(10,2) DEFAULT NULL,
  `valor_sus` decimal(10,2) DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`competencia`,`codigo`),
  KEY `idx_sigtap_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_sigtap_procedimento`
--

LOCK TABLES `md_sigtap_procedimento` WRITE;
/*!40000 ALTER TABLE `md_sigtap_procedimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_sigtap_procedimento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicacao_reavaliacao`
--

DROP TABLE IF EXISTS `medicacao_reavaliacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicacao_reavaliacao` (
  `id_reavaliacao` bigint NOT NULL AUTO_INCREMENT,
  `id_fila_medicacao` bigint NOT NULL,
  `id_ffa` bigint NOT NULL,
  `previsto_em` datetime NOT NULL,
  `executado_em` datetime DEFAULT NULL,
  `status` enum('PENDENTE','EM_EXECUCAO','CONCLUIDO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PENDENTE',
  `id_sessao_usuario` bigint NOT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `id_usuario_criador` bigint NOT NULL,
  `id_usuario_executor` bigint DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_reavaliacao`),
  KEY `idx_reav_fila` (`id_fila_medicacao`,`status`,`previsto_em`),
  KEY `idx_reav_ffa` (`id_ffa`,`status`,`previsto_em`),
  KEY `fk_reav_sessao` (`id_sessao_usuario`),
  KEY `fk_reav_local` (`id_local_operacional`),
  KEY `fk_reav_usr_criador` (`id_usuario_criador`),
  KEY `fk_reav_usr_exec` (`id_usuario_executor`),
  CONSTRAINT `fk_reav_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_reav_fila` FOREIGN KEY (`id_fila_medicacao`) REFERENCES `fila_operacional` (`id_fila`),
  CONSTRAINT `fk_reav_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
  CONSTRAINT `fk_reav_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_reav_usr_criador` FOREIGN KEY (`id_usuario_criador`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `fk_reav_usr_exec` FOREIGN KEY (`id_usuario_executor`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicacao_reavaliacao`
--

LOCK TABLES `medicacao_reavaliacao` WRITE;
/*!40000 ALTER TABLE `medicacao_reavaliacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `medicacao_reavaliacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medico`
--

DROP TABLE IF EXISTS `medico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medico` (
  `id_usuario` bigint NOT NULL,
  `crm` varchar(20) NOT NULL,
  `uf_crm` char(2) NOT NULL,
  `id_especialidade` int DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uk_medico_crm_uf` (`crm`,`uf_crm`),
  KEY `idx_medico_especialidade` (`id_especialidade`),
  CONSTRAINT `fk_medico_especialidade` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`),
  CONSTRAINT `fk_medico_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
-- Table structure for table `notificacao_epidemiologica`
--

DROP TABLE IF EXISTS `notificacao_epidemiologica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificacao_epidemiologica` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `cid_10` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `doenca_suspeita` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_notificacao` enum('PENDENTE','ENVIADO_MS','ARQUIVADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDENTE',
  `data_evento` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_usuario_criador` bigint DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `protocolo_ms` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_notif_epid_sessao` (`id_sessao_usuario`),
  KEY `idx_notif_epid_usuario` (`id_usuario_criador`),
  CONSTRAINT `fk_notif_epid_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacao_epidemiologica`
--

LOCK TABLES `notificacao_epidemiologica` WRITE;
/*!40000 ALTER TABLE `notificacao_epidemiologica` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificacao_epidemiologica` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificacao_epidemiologica_evento`
--

DROP TABLE IF EXISTS `notificacao_epidemiologica_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificacao_epidemiologica_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_notificacao` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `tipo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `detalhe` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_usuario` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_ne_evento_notif` (`id_notificacao`,`criado_em`),
  KEY `idx_ne_evento_sessao` (`id_sessao_usuario`,`criado_em`),
  KEY `idx_ne_evento_usuario` (`id_usuario`,`criado_em`),
  CONSTRAINT `fk_ne_evento_notif` FOREIGN KEY (`id_notificacao`) REFERENCES `notificacao_epidemiologica` (`id`),
  CONSTRAINT `fk_ne_evento_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_ne_evento_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacao_epidemiologica_evento`
--

LOCK TABLES `notificacao_epidemiologica_evento` WRITE;
/*!40000 ALTER TABLE `notificacao_epidemiologica_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificacao_epidemiologica_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificacao_violencia`
--

DROP TABLE IF EXISTS `notificacao_violencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificacao_violencia` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `categoria` enum('VIOLENCIA','AGRESSAO','ABUSO','TRANSITO','OUTRA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_ocorrencia` datetime DEFAULT NULL,
  `local_ocorrencia` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `suspeito_relacao` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cid10_relacionado` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_notificacao` enum('ABERTA','EM_INVESTIGACAO','ENVIADA','ARQUIVADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ABERTA',
  `id_sessao_usuario` bigint NOT NULL,
  `id_usuario_criador` bigint NOT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `protocolo_externo` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_nv_atendimento` (`id_atendimento`),
  KEY `idx_nv_status` (`status_notificacao`),
  KEY `idx_nv_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_nv_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `fk_nv_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacao_violencia`
--

LOCK TABLES `notificacao_violencia` WRITE;
/*!40000 ALTER TABLE `notificacao_violencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificacao_violencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificacao_violencia_evento`
--

DROP TABLE IF EXISTS `notificacao_violencia_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificacao_violencia_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_notificacao` bigint NOT NULL,
  `tipo_evento` enum('CRIACAO','ALTERACAO','MUDANCA_STATUS','ANEXO','EXPORTACAO','ERRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status_anterior` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_novo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `detalhes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_sessao_usuario` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_nve_notif` (`id_notificacao`),
  KEY `idx_nve_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_nve_notif` FOREIGN KEY (`id_notificacao`) REFERENCES `notificacao_violencia` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_nve_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacao_violencia_evento`
--

LOCK TABLES `notificacao_violencia_evento` WRITE;
/*!40000 ALTER TABLE `notificacao_violencia_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificacao_violencia_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `obito`
--

DROP TABLE IF EXISTS `obito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `obito` (
  `id_obito` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `data_hora_obito` datetime NOT NULL,
  `id_usuario_responsavel` bigint NOT NULL,
  `evolucao_inicial` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `evolucao_final` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `status` enum('REGISTRADO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'REGISTRADO',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  `cancelado_em` datetime DEFAULT NULL,
  `cancelado_por` bigint DEFAULT NULL,
  PRIMARY KEY (`id_obito`),
  UNIQUE KEY `uk_obito_ffa` (`id_ffa`),
  KEY `idx_obito_data` (`data_hora_obito`),
  KEY `idx_obito_status` (`status`),
  KEY `idx_obito_sessao` (`id_sessao_usuario`),
  KEY `idx_obito_ffa_status` (`id_ffa`,`status`),
  CONSTRAINT `fk_obito_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_obito_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `obito`
--

LOCK TABLES `obito` WRITE;
/*!40000 ALTER TABLE `obito` DISABLE KEYS */;
/*!40000 ALTER TABLE `obito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `obito_evento`
--

DROP TABLE IF EXISTS `obito_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `obito_evento` (
  `id_obito_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_obito` bigint NOT NULL,
  `tipo_evento` enum('REGISTRADO','ATUALIZADO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_obito_evento`),
  KEY `idx_ob_evt_obito` (`id_obito`),
  KEY `idx_ob_evt_tipo` (`tipo_evento`,`criado_em`),
  KEY `idx_ob_evt_obito_data` (`id_obito`,`criado_em`),
  CONSTRAINT `fk_ob_evt_obito` FOREIGN KEY (`id_obito`) REFERENCES `obito` (`id_obito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `obito_evento`
--

LOCK TABLES `obito_evento` WRITE;
/*!40000 ALTER TABLE `obito_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `obito_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `observacoes_eventos`
--

DROP TABLE IF EXISTS `observacoes_eventos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `observacoes_eventos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `entidade` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'FILA_SENHA, FFA, PRESCRICAO, AGENDAMENTO',
  `id_entidade` bigint NOT NULL,
  `contexto` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'MEDICO, ENFERMAGEM, TECNICA, ADMIN',
  `tipo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'OBSERVACAO, ALERTA, EVASAO, ORIENTACAO',
  `texto` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `tipo_ordem` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('ATIVA','SUSPENSA','ENCERRADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATIVA',
  `origem` enum('MEDICO','ENFERMAGEM') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `payload_clinico` json NOT NULL,
  `prioridade` int DEFAULT '0',
  `iniciado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `suspenso_em` datetime DEFAULT NULL,
  `encerrado_em` datetime DEFAULT NULL,
  `motivo_suspensao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `motivo_encerramento` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
-- Table structure for table `ordem_assistencial_aprazamento`
--

DROP TABLE IF EXISTS `ordem_assistencial_aprazamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordem_assistencial_aprazamento` (
  `id_aprazamento` bigint NOT NULL AUTO_INCREMENT,
  `id_item` bigint NOT NULL,
  `previsto_em` datetime NOT NULL,
  `status` enum('PENDENTE','REALIZADO','NAO_REALIZADO','ESTORNADO','SUSPENSO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PENDENTE',
  `executado_em` datetime DEFAULT NULL,
  `id_usuario_execucao` bigint DEFAULT NULL,
  `id_sessao_usuario_execucao` bigint DEFAULT NULL,
  `id_local_operacional_execucao` bigint DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `criado_por` bigint DEFAULT NULL,
  `id_sessao_usuario_criado` bigint DEFAULT NULL,
  PRIMARY KEY (`id_aprazamento`),
  UNIQUE KEY `uk_apraz_item_previsto` (`id_item`,`previsto_em`),
  KEY `idx_apraz_status_previsto` (`status`,`previsto_em`),
  KEY `fk_apraz_exec_user` (`id_usuario_execucao`),
  KEY `fk_apraz_exec_sessao` (`id_sessao_usuario_execucao`),
  KEY `fk_apraz_exec_local` (`id_local_operacional_execucao`),
  CONSTRAINT `fk_apraz_exec_local` FOREIGN KEY (`id_local_operacional_execucao`) REFERENCES `local_operacional` (`id_local_operacional`),
  CONSTRAINT `fk_apraz_exec_sessao` FOREIGN KEY (`id_sessao_usuario_execucao`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_apraz_exec_user` FOREIGN KEY (`id_usuario_execucao`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `fk_apraz_item` FOREIGN KEY (`id_item`) REFERENCES `ordem_assistencial_item` (`id_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordem_assistencial_aprazamento`
--

LOCK TABLES `ordem_assistencial_aprazamento` WRITE;
/*!40000 ALTER TABLE `ordem_assistencial_aprazamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordem_assistencial_aprazamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordem_assistencial_execucao`
--

DROP TABLE IF EXISTS `ordem_assistencial_execucao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordem_assistencial_execucao` (
  `id_execucao` bigint NOT NULL AUTO_INCREMENT,
  `id_item` bigint NOT NULL,
  `id_aprazamento` bigint DEFAULT NULL,
  `acao` enum('REALIZADO','NAO_REALIZADO','ESTORNADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `quantidade` decimal(10,2) DEFAULT NULL,
  `realizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `payload` json DEFAULT NULL,
  PRIMARY KEY (`id_execucao`),
  KEY `idx_exec_item_data` (`id_item`,`realizado_em`),
  KEY `idx_exec_apraz` (`id_aprazamento`),
  CONSTRAINT `fk_exec_apraz` FOREIGN KEY (`id_aprazamento`) REFERENCES `ordem_assistencial_aprazamento` (`id_aprazamento`),
  CONSTRAINT `fk_exec_item` FOREIGN KEY (`id_item`) REFERENCES `ordem_assistencial_item` (`id_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordem_assistencial_execucao`
--

LOCK TABLES `ordem_assistencial_execucao` WRITE;
/*!40000 ALTER TABLE `ordem_assistencial_execucao` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordem_assistencial_execucao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordem_assistencial_item`
--

DROP TABLE IF EXISTS `ordem_assistencial_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordem_assistencial_item` (
  `id_item` bigint NOT NULL AUTO_INCREMENT,
  `id_ordem` bigint NOT NULL,
  `tipo_item` enum('FARMACO','CUIDADO','DIETA','OXIGENIO','PROCEDIMENTO','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'FARMACO',
  `id_farmaco` bigint DEFAULT NULL,
  `descricao_item` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dose` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `posologia` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dias` int DEFAULT NULL,
  `quantidade` decimal(10,2) DEFAULT NULL,
  `unidade` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `frequencia_min` int DEFAULT NULL,
  `frequencia_txt` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `horarios_json` json DEFAULT NULL,
  `inicio_em` datetime DEFAULT NULL,
  `fim_em` datetime DEFAULT NULL,
  `quantidade_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` enum('ATIVO','SUSPENSO','ENCERRADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATIVO',
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_por` bigint NOT NULL,
  `id_sessao_usuario_criado` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_por` bigint DEFAULT NULL,
  `id_sessao_usuario_atualizado` bigint DEFAULT NULL,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_item`),
  KEY `idx_item_ordem` (`id_ordem`),
  KEY `idx_item_farmaco` (`id_farmaco`),
  KEY `idx_item_tipo_status` (`tipo_item`,`status`),
  KEY `idx_item_ordem_status` (`id_ordem`,`status`),
  CONSTRAINT `fk_item_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`),
  CONSTRAINT `fk_item_ordem` FOREIGN KEY (`id_ordem`) REFERENCES `ordem_assistencial` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordem_assistencial_item`
--

LOCK TABLES `ordem_assistencial_item` WRITE;
/*!40000 ALTER TABLE `ordem_assistencial_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordem_assistencial_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordem_tipo_documento_config`
--

DROP TABLE IF EXISTS `ordem_tipo_documento_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordem_tipo_documento_config` (
  `tipo_ordem` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_documento` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `somente_controlado` tinyint(1) NOT NULL DEFAULT '0',
  `somente_nao_controlado` tinyint(1) NOT NULL DEFAULT '0',
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`tipo_ordem`,`tipo_documento`),
  KEY `fk_ordem_doc_tipo` (`tipo_documento`),
  CONSTRAINT `fk_ordem_doc_tipo` FOREIGN KEY (`tipo_documento`) REFERENCES `documento_tipo_config` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordem_tipo_documento_config`
--

LOCK TABLES `ordem_tipo_documento_config` WRITE;
/*!40000 ALTER TABLE `ordem_tipo_documento_config` DISABLE KEYS */;
INSERT INTO `ordem_tipo_documento_config` VALUES ('ATESTADO','ATESTADO',0,0,1),('ENCAMINHAMENTO','ENCAMINHAMENTO',0,0,1),('EXAME','SOLIC_EXAME',0,0,1),('MEDICACAO','MEDICACAO_INTERNA',0,0,1),('RECEITA','RECEITA_CONTROLADO',1,0,1),('RECEITA','RECEITUARIO_CASA',0,0,1);
/*!40000 ALTER TABLE `ordem_tipo_documento_config` ENABLE KEYS */;
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
  `prontuario` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_cadastro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `prontuario` (`prontuario`),
  KEY `id_pessoa` (`id_pessoa`),
  CONSTRAINT `paciente_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paciente`
--

LOCK TABLES `paciente` WRITE;
/*!40000 ALTER TABLE `paciente` DISABLE KEYS */;
INSERT INTO `paciente` VALUES (1,8,NULL,'2026-01-28 06:00:49'),(2,8,NULL,'2026-01-28 06:01:27'),(3,8,NULL,'2026-01-28 06:07:06'),(4,8,NULL,'2026-01-28 06:09:09'),(5,8,NULL,'2026-01-28 06:16:01'),(6,8,NULL,'2026-01-28 06:17:10'),(7,8,NULL,'2026-01-28 06:17:37'),(8,8,NULL,'2026-01-28 06:19:55'),(9,8,NULL,'2026-01-28 06:20:16'),(10,8,NULL,'2026-01-28 06:20:42'),(11,8,NULL,'2026-01-28 06:21:25'),(12,8,NULL,'2026-01-28 06:21:35'),(13,8,NULL,'2026-01-28 06:21:57'),(14,8,NULL,'2026-01-28 06:22:20'),(15,8,NULL,'2026-01-28 06:22:54'),(16,8,NULL,'2026-01-28 06:26:06'),(17,33,NULL,'2026-01-28 06:30:19'),(18,33,NULL,'2026-01-28 06:31:19');
/*!40000 ALTER TABLE `paciente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paciente_alertas`
--

DROP TABLE IF EXISTS `paciente_alertas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paciente_alertas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `tipo_alerta` enum('ALERGIA','COMORBIDADE','RISCO_INFECCAO','PRECAUCAO_CONTATO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `grau_severidade` enum('BAIXO','MODERADO','ALTO','CRITICO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paciente_alertas`
--

LOCK TABLES `paciente_alertas` WRITE;
/*!40000 ALTER TABLE `paciente_alertas` DISABLE KEYS */;
/*!40000 ALTER TABLE `paciente_alertas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paciente_cns`
--

DROP TABLE IF EXISTS `paciente_cns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paciente_cns` (
  `id_paciente_cns` bigint NOT NULL AUTO_INCREMENT,
  `id_paciente` bigint NOT NULL,
  `cns` varchar(20) NOT NULL,
  `status` enum('ATIVO','INATIVO') NOT NULL DEFAULT 'ATIVO',
  `validado` tinyint(1) NOT NULL DEFAULT '0',
  `origem` enum('MANUAL','IMPORTADO','SUS','INTEGRACAO') NOT NULL DEFAULT 'MANUAL',
  `data_validacao` datetime DEFAULT NULL,
  `observacao` varchar(255) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_paciente_cns`),
  UNIQUE KEY `uk_paciente_cns_ativo` (`id_paciente`,`cns`,`status`),
  KEY `ix_paciente_cns_paciente` (`id_paciente`),
  KEY `ix_paciente_cns_cns` (`cns`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paciente_cns`
--

LOCK TABLES `paciente_cns` WRITE;
/*!40000 ALTER TABLE `paciente_cns` DISABLE KEYS */;
/*!40000 ALTER TABLE `paciente_cns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paciente_cns_evento`
--

DROP TABLE IF EXISTS `paciente_cns_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paciente_cns_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_paciente_cns` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `evento` varchar(40) NOT NULL,
  `detalhe` varchar(255) DEFAULT NULL,
  `payload_json` json DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `ix_pcns_evt` (`id_paciente_cns`),
  KEY `ix_pcns_evt_tipo` (`evento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paciente_cns_evento`
--

LOCK TABLES `paciente_cns_evento` WRITE;
/*!40000 ALTER TABLE `paciente_cns_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `paciente_cns_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painel`
--

DROP TABLE IF EXISTS `painel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel` (
  `id_painel` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `tipo` enum('PAINEL','TOTEM','TV') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PAINEL',
  `nome` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `id_unidade` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `tts_habilitado` tinyint(1) NOT NULL DEFAULT '0',
  `piscada_seg` int NOT NULL DEFAULT '20',
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  `intervalo_segundos` int NOT NULL DEFAULT '120',
  `id_sistema` bigint DEFAULT NULL,
  PRIMARY KEY (`id_painel`),
  UNIQUE KEY `uk_painel_codigo` (`codigo`),
  KEY `idx_painel_unidade` (`id_unidade`),
  KEY `idx_painel_local` (`id_local_operacional`)
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel`
--

LOCK TABLES `painel` WRITE;
/*!40000 ALTER TABLE `painel` DISABLE KEYS */;
INSERT INTO `painel` VALUES (1,'RECEPCAO','PAINEL','Painel Recepção','Fila de senha (chamada manual) + últimos chamados',2,NULL,1,20,1,'2026-02-03 05:52:46','2026-02-15 06:22:13',120,4),(2,'TRIAGEM','PAINEL','Painel Triagem','Fila setorial TRIAGEM (somente leitura)',2,NULL,1,20,1,'2026-02-03 05:52:46','2026-02-15 06:22:13',120,4),(3,'CLINICO','PAINEL','Painel Clínico','Fila do médico clínico (adulto)',2,NULL,1,20,1,'2026-02-03 05:52:46','2026-02-15 06:22:13',120,4),(4,'PEDIATRICO','PAINEL','Painel Pediátrico','Fila do médico pediátrico',2,NULL,1,20,1,'2026-02-03 05:52:46','2026-02-15 06:22:13',120,4),(5,'MEDICACAO','PAINEL','Painel Medicação','Fila setorial MEDICACAO',2,NULL,1,20,1,'2026-02-03 05:52:46','2026-02-15 06:22:13',120,4),(6,'COLETA','PAINEL','Painel Coleta','Fila setorial EXAME/COLETA',2,NULL,1,20,1,'2026-02-03 05:52:46','2026-02-15 06:22:13',120,4),(7,'RX','PAINEL','Painel RX','Fila setorial RX',2,NULL,1,20,1,'2026-02-03 05:52:46','2026-02-15 06:22:13',120,4),(8,'CONFORTO','PAINEL','Painel Conforto','Resumo de espera e últimas chamadas (sala de espera)',2,NULL,1,20,1,'2026-02-03 05:52:46','2026-02-15 06:22:13',120,4),(9,'TOTEM_SENHA','TOTEM','Totem Senha','Geração de senha + banner plantão do dia',2,NULL,0,0,1,'2026-02-03 05:52:46','2026-02-15 06:22:13',120,4),(10,'TOTEM_SATISFACAO','TOTEM','Totem Satisfação','Coleta de feedback do paciente',2,NULL,0,0,1,'2026-02-03 05:52:46','2026-02-15 06:22:13',120,4),(11,'TV_ROTATIVO','TV','TV Rotativo','TV única rotativa (2 min por tela)',2,NULL,1,20,1,'2026-02-03 05:52:46','2026-02-15 06:22:13',120,4),(23,'MEDICO_CLINICO','PAINEL','Painel Médico Clínico',NULL,2,NULL,0,20,1,'2026-02-03 06:19:42','2026-02-15 06:22:13',0,4),(24,'MEDICO_PEDI','PAINEL','Painel Médico Pediátrico',NULL,2,NULL,0,20,1,'2026-02-03 06:19:42','2026-02-15 06:22:13',0,4),(78,'MEDICACAO_ADULTO','PAINEL','Painel Medicação Adulto',NULL,2,NULL,1,20,1,'2026-02-03 23:59:51','2026-02-15 06:22:13',0,4),(79,'MEDICACAO_PEDI','PAINEL','Painel Medicação Pediátrica',NULL,2,NULL,1,20,1,'2026-02-03 23:59:51','2026-02-15 06:22:13',0,4),(150,'MEDICACAO_INF','PAINEL','Painel Medicação Infantil',NULL,2,NULL,1,20,1,'2026-02-04 00:02:19','2026-02-15 06:22:13',0,4),(221,'RX_2','PAINEL','Painel RX 2',NULL,1,123,1,20,1,'2026-02-04 00:05:17','2026-02-15 06:22:13',0,4),(247,'MEDICO_CLINICO_SALA3','PAINEL','Painel Médico Clínico - Sala 3',NULL,1,123,0,20,1,'2026-02-04 01:43:20','2026-02-15 06:22:13',0,4),(249,'TV_CLINICO','TV','TV Rotativa - Clínico',NULL,2,NULL,0,20,1,'2026-02-04 04:03:41','2026-02-15 06:22:13',120,4),(250,'MONITOR_MEDICOS','PAINEL','Painel Monitoramento Médicos','Mosaico/KPIs por especialidade/local',2,NULL,1,20,1,'2026-02-04 07:01:23','2026-02-15 06:22:13',15,4);
/*!40000 ALTER TABLE `painel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painel_alertas_tempo`
--

DROP TABLE IF EXISTS `painel_alertas_tempo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel_alertas_tempo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_senha` bigint DEFAULT NULL,
  `mensagem` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nivel` enum('AVISO','CRITICO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_alerta` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel_alertas_tempo`
--

LOCK TABLES `painel_alertas_tempo` WRITE;
/*!40000 ALTER TABLE `painel_alertas_tempo` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_alertas_tempo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painel_config`
--

DROP TABLE IF EXISTS `painel_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel_config` (
  `id_painel_config` bigint NOT NULL AUTO_INCREMENT,
  `id_painel` bigint DEFAULT NULL,
  `chave` varchar(80) NOT NULL,
  `valor_bool` tinyint(1) DEFAULT NULL,
  `valor_int` int DEFAULT NULL,
  `valor_decimal` decimal(12,4) DEFAULT NULL,
  `valor_text` text,
  `valor_json` json DEFAULT NULL,
  `valor_enum` varchar(80) DEFAULT NULL,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  PRIMARY KEY (`id_painel_config`),
  UNIQUE KEY `uk_painel_config_painel_chave` (`id_painel`,`chave`),
  KEY `idx_painel_config_chave` (`chave`),
  KEY `idx_painel_config_painel` (`id_painel`),
  KEY `idx_painel_config_atualizado_em` (`atualizado_em`),
  CONSTRAINT `fk_painel_config_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel_config`
--

LOCK TABLES `painel_config` WRITE;
/*!40000 ALTER TABLE `painel_config` DISABLE KEYS */;
INSERT INTO `painel_config` VALUES (1,1,'FILTRO_LOCAIS_CODIGOS_JSON',NULL,NULL,NULL,NULL,'[\"REC01\"]',NULL,'2026-02-15 06:26:42',3,5),(2,2,'FILTRO_LOCAIS_CODIGOS_JSON',NULL,NULL,NULL,NULL,'[\"TRI01\"]',NULL,'2026-02-15 06:26:42',3,5),(3,78,'FILTRO_LOCAIS_CODIGOS_JSON',NULL,NULL,NULL,NULL,'[]',NULL,'2026-02-15 06:26:42',3,5),(4,150,'FILTRO_LOCAIS_CODIGOS_JSON',NULL,NULL,NULL,NULL,'[]',NULL,'2026-02-15 06:26:42',3,5),(7,23,'FILTRO_LOCAIS_CODIGOS_JSON',NULL,NULL,NULL,NULL,'[]',NULL,'2026-02-15 06:26:42',3,5),(8,247,'FILTRO_LOCAIS_CODIGOS_JSON',NULL,NULL,NULL,NULL,'[]',NULL,'2026-02-15 06:26:42',3,5),(9,24,'FILTRO_LOCAIS_CODIGOS_JSON',NULL,NULL,NULL,NULL,'[]',NULL,'2026-02-15 06:26:42',3,5),(10,7,'FILTRO_LOCAIS_CODIGOS_JSON',NULL,NULL,NULL,NULL,'[]',NULL,'2026-02-15 06:26:42',3,5),(11,221,'FILTRO_LOCAIS_CODIGOS_JSON',NULL,NULL,NULL,NULL,'[]',NULL,'2026-02-15 06:26:42',3,5),(13,79,'FILTRO_LOCAIS_CODIGOS_JSON',NULL,NULL,NULL,NULL,'[]',NULL,'2026-02-15 06:26:42',3,5);
/*!40000 ALTER TABLE `painel_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painel_config_def`
--

DROP TABLE IF EXISTS `painel_config_def`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel_config_def` (
  `id_painel_config_def` bigint NOT NULL AUTO_INCREMENT,
  `chave` varchar(80) NOT NULL,
  `aplica_em` enum('PAINEL','TOTEM','TV','TODOS') NOT NULL DEFAULT 'TODOS',
  `tipo_valor` enum('BOOL','INT','DECIMAL','TEXT','JSON','ENUM') NOT NULL,
  `default_bool` tinyint(1) DEFAULT NULL,
  `default_int` int DEFAULT NULL,
  `default_decimal` decimal(12,4) DEFAULT NULL,
  `default_text` text,
  `default_json` json DEFAULT NULL,
  `default_enum` varchar(80) DEFAULT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `enum_opcoes_json` json DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_painel_config_def`),
  UNIQUE KEY `uk_painel_config_def_chave` (`chave`),
  UNIQUE KEY `uk_painel_cfgdef_aplica_chave` (`aplica_em`,`chave`),
  KEY `idx_painel_config_def_categoria` (`categoria`),
  KEY `idx_painel_config_def_ativo` (`ativo`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel_config_def`
--

LOCK TABLES `painel_config_def` WRITE;
/*!40000 ALTER TABLE `painel_config_def` DISABLE KEYS */;
INSERT INTO `painel_config_def` VALUES (1,'BANNER_PLANTAO_HABILITADO','TODOS','BOOL',1,NULL,NULL,NULL,NULL,NULL,'TOTEM','Totem de senha: exibir banner superior com plantão.',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(2,'EXIBIR_NOME_PACIENTE','TODOS','BOOL',0,NULL,NULL,NULL,NULL,NULL,'PAINEL_PUBLICO','Painel público: exibir nome do paciente (padrão: NÃO).',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(3,'EXIBIR_NOME_SOCIAL','TODOS','BOOL',1,NULL,NULL,NULL,NULL,NULL,'PAINEL_PUBLICO','Se exibir nome, preferir nome social quando existir.',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(4,'EXIBIR_TEMPO_ESPERA','TODOS','BOOL',1,NULL,NULL,NULL,NULL,NULL,'PAINEL_PUBLICO','Exibir tempo de espera no painel.',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(5,'EXIBIR_TEMPO_ATENDIMENTO','TODOS','BOOL',1,NULL,NULL,NULL,NULL,NULL,'PAINEL_PUBLICO','Exibir tempo em atendimento (quando aplicável).',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(6,'EXIBIR_ULTIMA_CHAMADA','TODOS','BOOL',1,NULL,NULL,NULL,NULL,NULL,'PAINEL_PUBLICO','Exibir última senha chamada.',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(7,'EXIBIR_NAO_COMPARECEU','TODOS','BOOL',1,NULL,NULL,NULL,NULL,NULL,'PAINEL_PUBLICO','Exibir indicador/lista de não compareceu.',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(8,'TTS_VOZ','TODOS','TEXT',NULL,NULL,NULL,'pt-BR',NULL,NULL,'TTS','Nome/código da voz do TTS.',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(9,'TTS_REPETICOES','TODOS','INT',NULL,1,NULL,NULL,NULL,NULL,'TTS','Qtd de repetições por chamada.',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(10,'TTS_VELOCIDADE','TODOS','DECIMAL',NULL,NULL,1.0000,NULL,NULL,NULL,'TTS','Velocidade do TTS (1.00 = normal).',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(11,'PISCAR_CHAMADA','TODOS','BOOL',1,NULL,NULL,NULL,NULL,NULL,'PAINEL_PUBLICO','Ativa efeito de piscada ao chamar.',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(12,'PISCAR_CHAMADA_SEG','TODOS','INT',NULL,8,NULL,NULL,NULL,NULL,'PAINEL_PUBLICO','Duração da piscada (segundos).',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(13,'TV_ROTATIVO_HABILITADO','TODOS','BOOL',1,NULL,NULL,NULL,NULL,NULL,'TV','TV rotativo: habilitar rotação de telas.',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(14,'TV_ROTATIVO_INTERVALO_SEG','TODOS','INT',NULL,10,NULL,NULL,NULL,NULL,'TV','Intervalo padrão de rotação (seg), se tela não definir.',NULL,1,'2026-02-13 09:23:33','2026-02-13 09:23:33'),(15,'FILTRO_LOCAIS_CODIGOS_JSON','PAINEL','JSON',NULL,NULL,NULL,NULL,'[]',NULL,'FILTRO','Lista (JSON array) de códigos de local_operacional que este painel deve exibir. Ex.: [\"MEDP01\",\"MEDP02\"]',NULL,1,'2026-02-15 05:02:55','2026-02-15 05:02:55');
/*!40000 ALTER TABLE `painel_config_def` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painel_consumo_evento`
--

DROP TABLE IF EXISTS `painel_consumo_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel_consumo_evento` (
  `id_consumo` bigint NOT NULL AUTO_INCREMENT,
  `origem` enum('SENHA_EVENTOS','FILA_OPERACIONAL_EVENTO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_evento` bigint NOT NULL,
  `painel_tipo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `consumido_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_consumo`),
  UNIQUE KEY `uk_painel_consumo` (`origem`,`id_evento`,`painel_tipo`),
  KEY `idx_painel_local` (`id_local_operacional`,`consumido_em`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel_consumo_evento`
--

LOCK TABLES `painel_consumo_evento` WRITE;
/*!40000 ALTER TABLE `painel_consumo_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_consumo_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painel_fila_tipo`
--

DROP TABLE IF EXISTS `painel_fila_tipo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel_fila_tipo` (
  `id_painel` bigint NOT NULL,
  `tipo_fila` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_painel`,`tipo_fila`),
  CONSTRAINT `fk_painel_fila_tipo_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel_fila_tipo`
--

LOCK TABLES `painel_fila_tipo` WRITE;
/*!40000 ALTER TABLE `painel_fila_tipo` DISABLE KEYS */;
INSERT INTO `painel_fila_tipo` VALUES (1,'RECEPCAO'),(2,'TRIAGEM'),(5,'MEDICACAO'),(6,'EXAME'),(7,'RX'),(23,'MEDICO'),(24,'MEDICO'),(150,'MEDICACAO'),(247,'MEDICO_CLINICO');
/*!40000 ALTER TABLE `painel_fila_tipo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painel_grupo`
--

DROP TABLE IF EXISTS `painel_grupo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel_grupo` (
  `id_grupo` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_grupo`),
  UNIQUE KEY `uk_grupo_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel_grupo`
--

LOCK TABLES `painel_grupo` WRITE;
/*!40000 ALTER TABLE `painel_grupo` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_grupo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painel_grupo_local`
--

DROP TABLE IF EXISTS `painel_grupo_local`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel_grupo_local` (
  `id_grupo` bigint NOT NULL,
  `id_local_operacional` bigint NOT NULL,
  PRIMARY KEY (`id_grupo`,`id_local_operacional`),
  KEY `idx_pgl_local` (`id_local_operacional`),
  CONSTRAINT `fk_pgl_grupo` FOREIGN KEY (`id_grupo`) REFERENCES `painel_grupo` (`id_grupo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel_grupo_local`
--

LOCK TABLES `painel_grupo_local` WRITE;
/*!40000 ALTER TABLE `painel_grupo_local` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_grupo_local` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painel_lane`
--

DROP TABLE IF EXISTS `painel_lane`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel_lane` (
  `id_painel` bigint NOT NULL,
  `lane` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_painel`,`lane`),
  CONSTRAINT `fk_painel_lane_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel_lane`
--

LOCK TABLES `painel_lane` WRITE;
/*!40000 ALTER TABLE `painel_lane` DISABLE KEYS */;
INSERT INTO `painel_lane` VALUES (23,'ADULTO'),(24,'PEDIATRICO'),(150,'PEDIATRICO'),(247,'CLINICO');
/*!40000 ALTER TABLE `painel_lane` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painel_local`
--

DROP TABLE IF EXISTS `painel_local`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel_local` (
  `id_painel` bigint NOT NULL,
  `id_local_operacional` bigint NOT NULL,
  PRIMARY KEY (`id_painel`,`id_local_operacional`),
  KEY `idx_painel_local_local` (`id_local_operacional`),
  CONSTRAINT `fk_painel_local_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
  CONSTRAINT `fk_painel_local_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel_local`
--

LOCK TABLES `painel_local` WRITE;
/*!40000 ALTER TABLE `painel_local` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_local` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painel_mensagem`
--

DROP TABLE IF EXISTS `painel_mensagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel_mensagem` (
  `id_mensagem` bigint NOT NULL AUTO_INCREMENT,
  `id_painel` bigint NOT NULL,
  `tipo` enum('ALERTA','CHAMAR_MEDICO','INFO','URGENTE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ALERTA',
  `titulo` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `texto` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `prioridade` int NOT NULL DEFAULT '0',
  `expira_em` datetime DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `criado_por` bigint DEFAULT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  PRIMARY KEY (`id_mensagem`),
  KEY `idx_msg_painel` (`id_painel`,`ativo`,`criado_em`),
  KEY `idx_msg_expira` (`expira_em`),
  CONSTRAINT `fk_msg_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel_mensagem`
--

LOCK TABLES `painel_mensagem` WRITE;
/*!40000 ALTER TABLE `painel_mensagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_mensagem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painel_mensagem_consumo`
--

DROP TABLE IF EXISTS `painel_mensagem_consumo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel_mensagem_consumo` (
  `id_consumo` bigint NOT NULL AUTO_INCREMENT,
  `id_mensagem` bigint NOT NULL,
  `id_painel` bigint NOT NULL,
  `consumido_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `consumido_por` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_consumo`),
  UNIQUE KEY `uk_msg_consumo` (`id_mensagem`,`id_painel`),
  KEY `idx_consumo_painel` (`id_painel`,`consumido_em`),
  CONSTRAINT `fk_consumo_msg` FOREIGN KEY (`id_mensagem`) REFERENCES `painel_mensagem` (`id_mensagem`),
  CONSTRAINT `fk_consumo_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel_mensagem_consumo`
--

LOCK TABLES `painel_mensagem_consumo` WRITE;
/*!40000 ALTER TABLE `painel_mensagem_consumo` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_mensagem_consumo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painel_monitoramento_especialidade`
--

DROP TABLE IF EXISTS `painel_monitoramento_especialidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel_monitoramento_especialidade` (
  `id_cfg` bigint NOT NULL AUTO_INCREMENT,
  `id_painel` bigint NOT NULL,
  `id_especialidade` bigint NOT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `ordem` int NOT NULL DEFAULT '1',
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_cfg`),
  KEY `idx_cfg_painel` (`id_painel`),
  KEY `idx_cfg_local_operacional` (`id_local_operacional`),
  CONSTRAINT `fk_cfg_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel_monitoramento_especialidade`
--

LOCK TABLES `painel_monitoramento_especialidade` WRITE;
/*!40000 ALTER TABLE `painel_monitoramento_especialidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_monitoramento_especialidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pdv_cliente`
--

DROP TABLE IF EXISTS `pdv_cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pdv_cliente` (
  `id_cliente` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `documento` varchar(30) DEFAULT NULL,
  `telefone` varchar(40) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cliente`),
  KEY `ix_cliente_doc` (`documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pdv_cliente`
--

LOCK TABLES `pdv_cliente` WRITE;
/*!40000 ALTER TABLE `pdv_cliente` DISABLE KEYS */;
/*!40000 ALTER TABLE `pdv_cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pdv_pagamento`
--

DROP TABLE IF EXISTS `pdv_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pdv_pagamento` (
  `id_pagamento` bigint NOT NULL AUTO_INCREMENT,
  `id_venda` bigint NOT NULL,
  `forma` enum('DINHEIRO','DEBITO','CREDITO','PIX','CONVENIO','OUTRO') NOT NULL,
  `valor` decimal(14,2) NOT NULL,
  `nsu` varchar(80) DEFAULT NULL,
  `autorizacao` varchar(80) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pagamento`),
  KEY `ix_pag_venda` (`id_venda`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pdv_pagamento`
--

LOCK TABLES `pdv_pagamento` WRITE;
/*!40000 ALTER TABLE `pdv_pagamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `pdv_pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pdv_venda`
--

DROP TABLE IF EXISTS `pdv_venda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pdv_venda` (
  `id_venda` bigint NOT NULL AUTO_INCREMENT,
  `id_estoque_local` bigint NOT NULL,
  `id_cliente` bigint DEFAULT NULL,
  `id_codigo_universal` bigint DEFAULT NULL,
  `codigo` varchar(60) DEFAULT NULL,
  `barcode` varchar(60) DEFAULT NULL,
  `status` enum('ABERTA','PAGA','CANCELADA') NOT NULL DEFAULT 'ABERTA',
  `total_bruto` decimal(14,2) NOT NULL DEFAULT '0.00',
  `desconto` decimal(14,2) NOT NULL DEFAULT '0.00',
  `total_liquido` decimal(14,2) NOT NULL DEFAULT '0.00',
  `id_sessao_usuario` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pago_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_venda`),
  KEY `ix_venda_status` (`status`),
  KEY `ix_venda_cliente` (`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pdv_venda`
--

LOCK TABLES `pdv_venda` WRITE;
/*!40000 ALTER TABLE `pdv_venda` DISABLE KEYS */;
/*!40000 ALTER TABLE `pdv_venda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pdv_venda_item`
--

DROP TABLE IF EXISTS `pdv_venda_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pdv_venda_item` (
  `id_item` bigint NOT NULL AUTO_INCREMENT,
  `id_venda` bigint NOT NULL,
  `id_produto` bigint NOT NULL,
  `id_lote` bigint DEFAULT NULL,
  `quantidade` decimal(14,3) NOT NULL,
  `valor_unitario` decimal(14,4) NOT NULL,
  `valor_total` decimal(14,2) NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_item`),
  KEY `ix_venda_item_venda` (`id_venda`),
  KEY `ix_venda_item_prod` (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pdv_venda_item`
--

LOCK TABLES `pdv_venda_item` WRITE;
/*!40000 ALTER TABLE `pdv_venda_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `pdv_venda_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_medico`
--

DROP TABLE IF EXISTS `pedido_medico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_medico` (
  `id_pedido_medico` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_gpat` bigint NOT NULL,
  `id_usuario_solicitante` bigint NOT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `status` enum('ABERTO','EM_EXECUCAO','CONCLUIDO','CANCELADO') NOT NULL DEFAULT 'ABERTO',
  `justificativa` varchar(500) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_pedido_medico`),
  KEY `ix_pedido_medico_ffa` (`id_ffa`),
  KEY `ix_pedido_medico_status` (`status`),
  KEY `ix_pedido_medico_gpat` (`id_gpat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_medico`
--

LOCK TABLES `pedido_medico` WRITE;
/*!40000 ALTER TABLE `pedido_medico` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedido_medico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_medico_item`
--

DROP TABLE IF EXISTS `pedido_medico_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_medico_item` (
  `id_pedido_item` bigint NOT NULL AUTO_INCREMENT,
  `id_pedido_medico` bigint NOT NULL,
  `tipo_item` enum('PROCEDIMENTO','EXAME','MEDICACAO','ENCAMINHAMENTO','OUTRO') NOT NULL,
  `status` enum('PENDENTE','EM_EXECUCAO','CONCLUIDO','CANCELADO','SUSPENSO') NOT NULL DEFAULT 'PENDENTE',
  `codigo_sigtap` varchar(30) DEFAULT NULL,
  `competencia_sigtap` char(6) DEFAULT NULL,
  `cid10_principal` varchar(10) DEFAULT NULL,
  `cnes_executante` varchar(20) DEFAULT NULL,
  `id_codigo_universal` bigint DEFAULT NULL,
  `sistema_externo` varchar(50) DEFAULT NULL,
  `codigo_externo` varchar(80) DEFAULT NULL,
  `descricao` varchar(500) DEFAULT NULL,
  `prioridade` tinyint DEFAULT NULL,
  `observacao` text,
  `exige_cat` tinyint(1) NOT NULL DEFAULT '0',
  `exige_sinan` tinyint(1) NOT NULL DEFAULT '0',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_pedido_item`),
  UNIQUE KEY `uk_pedido_item_externo` (`sistema_externo`,`codigo_externo`),
  KEY `ix_pedido_item_pedido` (`id_pedido_medico`),
  KEY `ix_pedido_item_tipo` (`tipo_item`),
  KEY `ix_pedido_item_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_medico_item`
--

LOCK TABLES `pedido_medico_item` WRITE;
/*!40000 ALTER TABLE `pedido_medico_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedido_medico_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pep_assinatura_digital`
--

DROP TABLE IF EXISTS `pep_assinatura_digital`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pep_assinatura_digital` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `hash_conteudo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `assinatura_base64` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `data_assinatura` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pep_assinatura` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pep_assinatura_digital`
--

LOCK TABLES `pep_assinatura_digital` WRITE;
/*!40000 ALTER TABLE `pep_assinatura_digital` DISABLE KEYS */;
/*!40000 ALTER TABLE `pep_assinatura_digital` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pep_registro`
--

DROP TABLE IF EXISTS `pep_registro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pep_registro` (
  `id_pep_registro` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_gpat` bigint NOT NULL,
  `id_usuario_autor` bigint NOT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `tipo_registro` enum('EVOLUCAO','ANAMNESE','EXAME_FISICO','HIPOTESE','DIAGNOSTICO','PRESCRICAO','SOLICITACAO','RESULTADO','ALTA','TRANSFERENCIA','OUTRO') NOT NULL,
  `texto` mediumtext,
  `payload_json` json DEFAULT NULL,
  `assinado` tinyint(1) NOT NULL DEFAULT '0',
  `assinado_em` datetime DEFAULT NULL,
  `hash_assinatura` varchar(128) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_pep_registro`),
  KEY `ix_pep_ffa` (`id_ffa`),
  KEY `ix_pep_gpat` (`id_gpat`),
  KEY `ix_pep_tipo` (`tipo_registro`),
  KEY `ix_pep_autor` (`id_usuario_autor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pep_registro`
--

LOCK TABLES `pep_registro` WRITE;
/*!40000 ALTER TABLE `pep_registro` DISABLE KEYS */;
/*!40000 ALTER TABLE `pep_registro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perfil`
--

DROP TABLE IF EXISTS `perfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfil` (
  `id_perfil` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_perfil`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfil`
--

LOCK TABLES `perfil` WRITE;
/*!40000 ALTER TABLE `perfil` DISABLE KEYS */;
INSERT INTO `perfil` VALUES (1,'ADMIN'),(7,'ADMIN_MASTER'),(3,'ENFERMAGEM'),(13,'FARMACEUTICO'),(14,'FARMACIA_PA'),(16,'FARMACIA_RUA'),(15,'FARMACIA_UBS'),(6,'MASTER'),(4,'MEDICO'),(5,'PAINEL'),(2,'RECEPCAO'),(8,'TRIAGEM');
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
  `permissao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
INSERT INTO `perfil_permissao` VALUES (1,20,NULL),(1,21,NULL),(1,22,NULL),(1,23,NULL),(1,24,NULL),(1,35,'MEDICO_INICIAR'),(1,36,'MEDICO_ENCAMINHAR'),(1,37,'MEDICO_DESFECHO'),(1,38,'PAINEL_MENSAGEM_CONSUMIR'),(1,39,'INTERNACAO_TRANSFERIR_LEITO'),(1,125,NULL),(1,126,NULL),(1,127,NULL),(2,8,NULL),(2,21,NULL),(2,22,NULL),(2,23,NULL),(2,24,NULL),(2,127,NULL),(3,21,NULL),(3,22,NULL),(3,23,NULL),(3,24,NULL),(3,39,'INTERNACAO_TRANSFERIR_LEITO'),(3,127,NULL),(4,2,NULL),(4,7,NULL),(4,21,NULL),(4,22,NULL),(4,23,NULL),(4,35,'MEDICO_INICIAR'),(4,36,'MEDICO_ENCAMINHAR'),(4,37,'MEDICO_DESFECHO'),(4,39,'INTERNACAO_TRANSFERIR_LEITO'),(4,125,NULL),(4,126,NULL),(4,127,NULL),(5,3,NULL),(5,4,NULL),(5,5,NULL),(5,38,'PAINEL_MENSAGEM_CONSUMIR'),(6,20,NULL),(6,21,NULL),(6,22,NULL),(6,23,NULL),(6,24,NULL),(6,35,'MEDICO_INICIAR'),(6,36,'MEDICO_ENCAMINHAR'),(6,37,'MEDICO_DESFECHO'),(6,38,'PAINEL_MENSAGEM_CONSUMIR'),(6,39,'INTERNACAO_TRANSFERIR_LEITO'),(6,125,NULL),(6,126,NULL),(6,127,NULL),(7,9,NULL),(7,15,'ACESSO_TOTAL'),(7,16,'SELECIONAR_CONTEXTO'),(7,17,'OPERAR_FILA'),(7,18,'ADMIN_USUARIOS'),(7,20,NULL),(7,21,NULL),(7,22,NULL),(7,23,NULL),(7,24,NULL),(7,35,'MEDICO_INICIAR'),(7,36,'MEDICO_ENCAMINHAR'),(7,37,'MEDICO_DESFECHO'),(7,38,'PAINEL_MENSAGEM_CONSUMIR'),(7,39,'INTERNACAO_TRANSFERIR_LEITO'),(7,125,NULL),(7,126,NULL),(7,127,NULL),(8,21,NULL),(8,22,NULL),(8,23,NULL);
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
  `codigo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_permissao`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=171 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissao`
--

LOCK TABLES `permissao` WRITE;
/*!40000 ALTER TABLE `permissao` DISABLE KEYS */;
INSERT INTO `permissao` VALUES (1,'ABRIR_ATENDIMENTO','Abrir atendimento'),(2,'REGISTRAR_TRIAGEM','Registrar triagem'),(3,'REALIZAR_ANAMNESE','Registrar anamnese'),(4,'PRESCREVER','Emitir prescrição'),(5,'FINALIZAR_ATENDIMENTO','Finalizar atendimento'),(6,'REABRIR_ATENDIMENTO','Reabrir atendimento'),(7,'ADMINISTRAR_MEDICACAO','Administrar medicação'),(8,'VER_RELATORIOS','Acessar relatórios'),(9,'VER_AUDITORIA','Visualizar auditoria'),(15,'ACESSO_TOTAL','Acesso total ao sistema'),(16,'SELECIONAR_CONTEXTO','Selecionar contexto operacional (sistema/unidade/local)'),(17,'OPERAR_FILA','Operar fila (chamar/iniciar/finalizar/não atendeu/encaminhar)'),(18,'ADMIN_USUARIOS','Administrar usuários (criar/ativar/inativar/vincular perfil)'),(20,'ADMIN_PERMISSOES','Admin: gerenciar permissões por perfil'),(21,'PRONTUARIO_LER','Ler prontuário / abrir FFA / ver evolução'),(22,'DOCUMENTO_LISTAR_PENDENTES','Listar documentos pendentes de impressão no contexto'),(23,'DOCUMENTO_MARCAR_IMPRESSO','Marcar documento como impresso (log IMPRIMIR)'),(24,'DOCUMENTO_REIMPRIMIR','Reimprimir documento (log REIMPRIMIR)'),(35,'MEDICO_INICIAR','Médico: iniciar atendimento/execução'),(36,'MEDICO_ENCAMINHAR','Médico: encaminhar paciente/fluxo'),(37,'MEDICO_DESFECHO','Médico: definir desfecho/alta/óbito/transferência'),(38,'PAINEL_MENSAGEM_CONSUMIR','Painel/TTS: consumir mensagem'),(39,'INTERNACAO_TRANSFERIR_LEITO','Internação: transferir leito'),(45,'ORDEM_ASSISTENCIAL_REGISTRAR','Criar ordem assistencial (medicação/cuidado/dieta/etc)'),(46,'ORDEM_ASSISTENCIAL_SUSPENDER','Suspender ordem assistencial'),(47,'ORDEM_ASSISTENCIAL_ENCERRAR','Encerrar ordem assistencial'),(48,'FILA_SUBSTATUS_ATUALIZAR','Atualizar substatus operacional (fila_operacional)'),(49,'EXAME_SOLICITAR','Solicitar exame genérico'),(50,'EXAME_INICIAR','Iniciar execução de exame genérico'),(51,'EXAME_FINALIZAR','Finalizar exame genérico'),(52,'RX_SOLICITAR','Solicitar RX'),(53,'RX_INICIAR','Iniciar RX'),(54,'RX_FINALIZAR','Finalizar RX'),(55,'RX_CANCELAR','Cancelar RX'),(56,'LAB_SOLICITAR','Solicitar laboratório'),(57,'LAB_INICIAR','Iniciar laboratório'),(58,'LAB_FINALIZAR','Finalizar laboratório'),(59,'LAB_RESULTADO_RECEBER','Receber resultado do laboratório'),(60,'ECG_SOLICITAR','Solicitar ECG'),(61,'ECG_INICIAR','Iniciar ECG'),(62,'ECG_FINALIZAR','Finalizar ECG'),(63,'MEDICACAO_INICIAR','Iniciar execução em Medicação'),(125,'DIAGNOSTICO_EDITAR','Prontuário: registrar/editar diagnóstico CID10'),(126,'DIAGNOSTICO_LER','Prontuário: listar diagnósticos'),(127,'DOCUMENTO_EMITIR','Gerar documento (emissão idempotente por referência)'),(129,'ORDEM_ITEM_ADICIONAR','Adicionar item em ordem assistencial'),(130,'ORDEM_ITEM_ATUALIZAR','Atualizar item em ordem assistencial'),(131,'ORDEM_ITEM_SUSPENDER','Suspender item em ordem assistencial'),(132,'ORDEM_ITEM_ENCERRAR','Encerrar item em ordem assistencial'),(133,'ORDEM_APRAZAMENTO_GERAR','Gerar aprazamento (tarefas/horários)'),(134,'ORDEM_APRAZAMENTO_EXECUTAR','Executar tarefa/aprazamento (realizar/nao realizar)'),(135,'ORDEM_APRAZAMENTO_ESTORNAR','Estornar execução registrada'),(136,'MEDICACAO_ADMINISTRAR','Registrar administração de medicação (enfermagem)'),(137,'CUIDADO_EXECUTAR','Registrar execução de cuidado'),(138,'DIETA_EXECUTAR','Registrar execução de dieta/ingestão'),(159,'INTERNACAO_ABRIR','Abrir internação/observação'),(160,'INTERNACAO_TROCAR_LEITO','Transferir paciente de leito (troca leito)'),(161,'INTERNACAO_TRANSFERIR','Marcar transferência/remoção (internação)'),(162,'INTERNACAO_ALTA','Dar alta/encerrar internação'),(163,'INTERNACAO_ATUALIZAR','Atualizar dados da internação (precaução/previsão/responsável)'),(164,'INTERNACAO_VER','Ler dados de internação (read-only)'),(165,'ADMIN_TRIGGERS','Admin: manutenção de triggers (apenas DEV/DBA)'),(166,'PAINEL_CONFIGURAR','Configurar painel/TV rotativo'),(167,'USUARIO_RESET','Reset de usuário/senha (suporte)');
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
  `procedure_nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `nome_completo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome_social` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cpf` varchar(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cns` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rg` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rg_uf` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_nascimento` date DEFAULT NULL,
  `sexo` enum('M','F','O') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nome_mae` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rg_orgao` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dt_nascimento` date DEFAULT NULL,
  PRIMARY KEY (`id_pessoa`),
  UNIQUE KEY `uk_pessoa_cpf` (`cpf`),
  UNIQUE KEY `uk_pessoa_cns` (`cns`),
  KEY `idx_pessoa_nascimento` (`data_nascimento`),
  KEY `idx_pessoa_rg` (`rg`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa`
--

LOCK TABLES `pessoa` WRITE;
/*!40000 ALTER TABLE `pessoa` DISABLE KEYS */;
INSERT INTO `pessoa` VALUES (1,'Teste Usuario',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'Yasnanakase Master','Yasnanakase',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'Yasnanakase Master','Yasnanakase',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,'Yasnanakase Master','Yasnanakase',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,'Administrador do Sistema',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,'TOTEM (Sistema)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,'GESTOR EINSTEIN','ADMIN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,'PACIENTE TESTE EINSTEIN',NULL,'12345678901',NULL,NULL,NULL,'1990-01-01',NULL,NULL,NULL,NULL,NULL,NULL),(9,'ADMINISTRADOR ALPHA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,'PACIENTE TESTE EINSTEIN',NULL,'999.999.999-99',NULL,NULL,NULL,'1990-05-20',NULL,NULL,NULL,NULL,NULL,NULL),(11,'MARIA RECEPCAO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(12,'JOAO ENFERMEIRO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(13,'DR EINSTEIN MEDICO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(14,'MARIA RECEPCAO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(15,'JOAO ENFERMEIRO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(16,'DR EINSTEIN MEDICO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(17,'PACIENTE TESTE EINSTEIN',NULL,'123.456.789-00',NULL,NULL,NULL,'1990-01-01',NULL,NULL,NULL,NULL,NULL,NULL),(31,'PACIENTE REAL V2',NULL,'000.000.000-00',NULL,NULL,NULL,'1995-05-05',NULL,NULL,NULL,NULL,NULL,NULL),(33,'PACIENTE TESTE EINSTEIN',NULL,'853.965.365-00',NULL,NULL,NULL,'1990-01-01',NULL,NULL,NULL,NULL,NULL,NULL),(34,'PACIENTE TESTE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `pessoa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pessoa_alergias`
--

DROP TABLE IF EXISTS `pessoa_alergias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pessoa_alergias` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `substancia` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `gravidade` enum('LEVE','MODERADA','GRAVE/CHOQUE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `registrado_por` bigint DEFAULT NULL,
  `data_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_alergia_pessoa` (`id_pessoa`),
  CONSTRAINT `fk_alergia_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa_alergias`
--

LOCK TABLES `pessoa_alergias` WRITE;
/*!40000 ALTER TABLE `pessoa_alergias` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_alergias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pessoa_conselho_registro`
--

DROP TABLE IF EXISTS `pessoa_conselho_registro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pessoa_conselho_registro` (
  `id_pessoa_conselho` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `id_conselho` int NOT NULL,
  `uf_registro` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `registro` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `eh_principal` tinyint(1) NOT NULL DEFAULT '0',
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pessoa_conselho`),
  UNIQUE KEY `uk_pessoa_conselho` (`id_pessoa`,`id_conselho`,`uf_registro`,`registro`),
  KEY `idx_pessoa_principal` (`id_pessoa`,`eh_principal`,`ativo`),
  KEY `idx_conselho_registro` (`id_conselho`,`uf_registro`,`registro`),
  CONSTRAINT `fk_pcr_conselho` FOREIGN KEY (`id_conselho`) REFERENCES `conselho_profissional` (`id_conselho`),
  CONSTRAINT `fk_pcr_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa_conselho_registro`
--

LOCK TABLES `pessoa_conselho_registro` WRITE;
/*!40000 ALTER TABLE `pessoa_conselho_registro` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_conselho_registro` ENABLE KEYS */;
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
  `tipo` enum('EMAIL','TELEFONE','WHATSAPP') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `valor` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
-- Table structure for table `pessoa_documento`
--

DROP TABLE IF EXISTS `pessoa_documento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pessoa_documento` (
  `id_pessoa_documento` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `tipo` enum('RG','CNH','PASSAPORTE','CTPS','TITULO_ELEITOR','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'RG',
  `numero` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `orgao_emissor` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `uf_emissor` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_emissao` date DEFAULT NULL,
  `data_validade` date DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pessoa_documento`),
  UNIQUE KEY `uk_pd_tipo_numero` (`tipo`,`numero`),
  KEY `idx_pd_pessoa` (`id_pessoa`),
  CONSTRAINT `fk_pessoa_documento_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa_documento`
--

LOCK TABLES `pessoa_documento` WRITE;
/*!40000 ALTER TABLE `pessoa_documento` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_documento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pessoa_endereco`
--

DROP TABLE IF EXISTS `pessoa_endereco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pessoa_endereco` (
  `id_pessoa_endereco` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `tipo` enum('RESIDENCIAL','COMERCIAL','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'RESIDENCIAL',
  `principal` tinyint(1) NOT NULL DEFAULT '0',
  `cep` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `logradouro` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `numero` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `complemento` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bairro` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cidade` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `uf` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `referencia` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pessoa_endereco`),
  KEY `idx_pe_pessoa` (`id_pessoa`),
  KEY `idx_pe_principal` (`id_pessoa`,`principal`),
  KEY `idx_pe_cep` (`cep`),
  CONSTRAINT `fk_pessoa_endereco_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa_endereco`
--

LOCK TABLES `pessoa_endereco` WRITE;
/*!40000 ALTER TABLE `pessoa_endereco` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_endereco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pessoa_identificador`
--

DROP TABLE IF EXISTS `pessoa_identificador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pessoa_identificador` (
  `id_identificador` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `tipo` enum('CPF','CNS','RG','GPAT','PASSAPORTE','OUTRO') NOT NULL,
  `valor_bruto` varchar(60) DEFAULT NULL,
  `valor_normalizado` varchar(60) NOT NULL,
  `uf` char(2) DEFAULT NULL,
  `orgao` varchar(30) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_identificador`),
  UNIQUE KEY `uk_pessoa_ident_tipo_val` (`tipo`,`valor_normalizado`),
  KEY `idx_pessoa_ident_pessoa` (`id_pessoa`),
  KEY `idx_pessoa_ident_val` (`valor_normalizado`),
  CONSTRAINT `fk_pessoa_ident_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa_identificador`
--

LOCK TABLES `pessoa_identificador` WRITE;
/*!40000 ALTER TABLE `pessoa_identificador` DISABLE KEYS */;
INSERT INTO `pessoa_identificador` VALUES (1,31,'CPF','000.000.000-00','00000000000',NULL,NULL,'2026-02-13 03:42:48'),(2,17,'CPF','123.456.789-00','12345678900',NULL,NULL,'2026-02-13 03:42:48'),(3,8,'CPF','12345678901','12345678901',NULL,NULL,'2026-02-13 03:42:48'),(4,33,'CPF','853.965.365-00','85396536500',NULL,NULL,'2026-02-13 03:42:48'),(5,10,'CPF','999.999.999-99','99999999999',NULL,NULL,'2026-02-13 03:42:48');
/*!40000 ALTER TABLE `pessoa_identificador` ENABLE KEYS */;
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
  `id_plantao` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `id_local` bigint DEFAULT NULL,
  `id_usuario_medico` bigint NOT NULL,
  `tipo_plantao` enum('CLINICO','PEDIATRIA','EMERGENCIA') NOT NULL,
  `inicio_plantao` datetime NOT NULL,
  `fim_plantao` datetime NOT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_plantao`),
  KEY `idx_plantao_unidade_ativo_periodo` (`id_unidade`,`ativo`,`inicio_plantao`,`fim_plantao`),
  KEY `idx_plantao_medico` (`id_usuario_medico`),
  KEY `idx_plantao_local` (`id_local`),
  CONSTRAINT `fk_plantao_local` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`),
  CONSTRAINT `fk_plantao_medico` FOREIGN KEY (`id_usuario_medico`) REFERENCES `medico` (`id_usuario`),
  CONSTRAINT `fk_plantao_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plantao`
--

LOCK TABLES `plantao` WRITE;
/*!40000 ALTER TABLE `plantao` DISABLE KEYS */;
/*!40000 ALTER TABLE `plantao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plantao_escala`
--

DROP TABLE IF EXISTS `plantao_escala`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plantao_escala` (
  `id_plantao_escala` bigint NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `id_usuario_medico` bigint NOT NULL,
  `data` date NOT NULL,
  `turno` enum('DIA','NOITE','24H','CUSTOM') NOT NULL,
  `hora_inicio` time DEFAULT NULL,
  `hora_fim` time DEFAULT NULL,
  `tipo_plantao` enum('CLINICO','PEDIATRIA','EMERGENCIA') DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_plantao_escala`),
  UNIQUE KEY `uk_plantao_escala_un_med_data_turno` (`id_unidade`,`id_usuario_medico`,`data`,`turno`),
  KEY `idx_plantao_escala_unidade_data` (`id_unidade`,`data`),
  KEY `idx_plantao_escala_medico_data` (`id_usuario_medico`,`data`),
  CONSTRAINT `fk_plantao_escala_medico` FOREIGN KEY (`id_usuario_medico`) REFERENCES `medico` (`id_usuario`),
  CONSTRAINT `fk_plantao_escala_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plantao_escala`
--

LOCK TABLES `plantao_escala` WRITE;
/*!40000 ALTER TABLE `plantao_escala` DISABLE KEYS */;
/*!40000 ALTER TABLE `plantao_escala` ENABLE KEYS */;
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
-- Table structure for table `prescricao`
--

DROP TABLE IF EXISTS `prescricao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescricao` (
  `id_prescricao` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `tipo` enum('INTERNA','CONTROLADA','CASA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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

--
-- Table structure for table `prescricao_checagem_dupla`
--

DROP TABLE IF EXISTS `prescricao_checagem_dupla`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescricao_checagem_dupla` (
  `id_dupla_checagem` bigint NOT NULL AUTO_INCREMENT,
  `id_checagem_principal` bigint NOT NULL,
  `id_usuario_testemunha` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_dupla_checagem`),
  KEY `fk_dupla_principal` (`id_checagem_principal`),
  KEY `fk_dupla_testemunha` (`id_usuario_testemunha`),
  CONSTRAINT `fk_dupla_principal` FOREIGN KEY (`id_checagem_principal`) REFERENCES `prescricao_checagem` (`id_checagem`),
  CONSTRAINT `fk_dupla_testemunha` FOREIGN KEY (`id_usuario_testemunha`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescricao_checagem_dupla`
--

LOCK TABLES `prescricao_checagem_dupla` WRITE;
/*!40000 ALTER TABLE `prescricao_checagem_dupla` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_checagem_dupla` ENABLE KEYS */;
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
  `tipo` enum('MEDICAMENTOS','CUIDADOS_GERAIS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `tipo` enum('MEDICAMENTO','CUIDADO','DIETA','OUTROS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dose` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `posologia` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
-- Table structure for table `prescricao_itens`
--

DROP TABLE IF EXISTS `prescricao_itens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescricao_itens` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_usuario_prescritor` bigint NOT NULL,
  `tipo_item` enum('MEDICAMENTO','DIETA','CUIDADO','OXIGENOTERAPIA','SOLUCAO_EV') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `posologia_detalhada` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `frequencia_horario` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via_administracao` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `observacao_enfermagem` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `data_inicio` datetime DEFAULT CURRENT_TIMESTAMP,
  `data_suspensao` datetime DEFAULT NULL,
  `status` enum('ATIVO','SUSPENSO','CONCLUIDO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ATIVO',
  PRIMARY KEY (`id`),
  KEY `idx_presc_tipo` (`id_atendimento`,`tipo_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescricao_itens`
--

LOCK TABLES `prescricao_itens` WRITE;
/*!40000 ALTER TABLE `prescricao_itens` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_itens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescricao_kit_itens`
--

DROP TABLE IF EXISTS `prescricao_kit_itens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescricao_kit_itens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_kit` int NOT NULL,
  `item_nome` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dose` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `frequencia` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_kit_master_link` (`id_kit`),
  CONSTRAINT `fk_kit_master_link` FOREIGN KEY (`id_kit`) REFERENCES `prescricao_kit_master` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescricao_kit_itens`
--

LOCK TABLES `prescricao_kit_itens` WRITE;
/*!40000 ALTER TABLE `prescricao_kit_itens` DISABLE KEYS */;
INSERT INTO `prescricao_kit_itens` VALUES (1,1,'SORO FISIOLOGICO 0,9%','500ML','EV','AGORA'),(2,1,'DIPIRONA 1G','2ML','EV','SE DOR/FEBRE'),(3,2,'CEFTRIAXONA 1G','2G','EV','AGORA'),(4,2,'SORO FISIOLOGICO 0,9%','1000ML','EV','IMEDIATO'),(5,2,'COLETA DE HEMOCULTURA','2 AMOSTRAS','LAB','AGORA');
/*!40000 ALTER TABLE `prescricao_kit_itens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescricao_kit_master`
--

DROP TABLE IF EXISTS `prescricao_kit_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescricao_kit_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome_kit` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescricao_kit_master`
--

LOCK TABLES `prescricao_kit_master` WRITE;
/*!40000 ALTER TABLE `prescricao_kit_master` DISABLE KEYS */;
INSERT INTO `prescricao_kit_master` VALUES (1,'PROTOCOLO DENGUE','Hidratação e sintomáticos para suspeita de arboviroses',1),(2,'PROTOCOLO SEPSE','Ação rápida para infecção generalizada (Antibiótico + Expansão)',1);
/*!40000 ALTER TABLE `prescricao_kit_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescricao_medica`
--

DROP TABLE IF EXISTS `prescricao_medica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescricao_medica` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_usuario_medico` bigint NOT NULL,
  `item_nome` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dose` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via` enum('EV','IM','VO','SC','TOPICA','INALATORIA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `frequencia` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('ATIVA','SUSPENSA','CONCLUIDA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ATIVA',
  `data_prescricao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescricao_medica`
--

LOCK TABLES `prescricao_medica` WRITE;
/*!40000 ALTER TABLE `prescricao_medica` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_medica` ENABLE KEYS */;
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
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Descrição livre da prescrição',
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
-- Table structure for table `prescritor_externo`
--

DROP TABLE IF EXISTS `prescritor_externo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescritor_externo` (
  `id_prescritor_externo` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `conselho` enum('CRM','CRO','COREN','CRF','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'CRM',
  `numero_conselho` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `uf` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `documento` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_prescritor_externo`),
  UNIQUE KEY `uk_prescritor_conselho` (`conselho`,`numero_conselho`,`uf`),
  KEY `idx_prescritor_nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescritor_externo`
--

LOCK TABLES `prescritor_externo` WRITE;
/*!40000 ALTER TABLE `prescritor_externo` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescritor_externo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prioridade_social`
--

DROP TABLE IF EXISTS `prioridade_social`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prioridade_social` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
-- Table structure for table `procedimento_protocolo`
--

DROP TABLE IF EXISTS `procedimento_protocolo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `procedimento_protocolo` (
  `id_protocolo` bigint NOT NULL AUTO_INCREMENT,
  `tipo` enum('EXAME','RX') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `codigo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `barcode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('CRIADO','EM_EXECUCAO','FINALIZADO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'CRIADO',
  `id_ffa` bigint NOT NULL,
  `id_fila` bigint NOT NULL,
  `id_sessao_criacao` bigint NOT NULL,
  `id_usuario_criacao` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_protocolo`),
  UNIQUE KEY `uk_protocolo_codigo` (`codigo`),
  UNIQUE KEY `uk_protocolo_fila` (`id_fila`,`tipo`),
  KEY `idx_prot_ffa` (`id_ffa`),
  KEY `idx_prot_status` (`tipo`,`status`,`criado_em`),
  KEY `fk_prot_sessao` (`id_sessao_criacao`),
  KEY `fk_prot_usuario` (`id_usuario_criacao`),
  CONSTRAINT `fk_prot_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_prot_fila` FOREIGN KEY (`id_fila`) REFERENCES `fila_operacional` (`id_fila`),
  CONSTRAINT `fk_prot_sessao` FOREIGN KEY (`id_sessao_criacao`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_prot_usuario` FOREIGN KEY (`id_usuario_criacao`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procedimento_protocolo`
--

LOCK TABLES `procedimento_protocolo` WRITE;
/*!40000 ALTER TABLE `procedimento_protocolo` DISABLE KEYS */;
/*!40000 ALTER TABLE `procedimento_protocolo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procedimento_protocolo_evento`
--

DROP TABLE IF EXISTS `procedimento_protocolo_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `procedimento_protocolo_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_protocolo` bigint NOT NULL,
  `tipo_evento` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `detalhe` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  KEY `idx_evt_proto` (`id_protocolo`,`criado_em`),
  KEY `idx_evt_tipo` (`tipo_evento`,`criado_em`),
  KEY `idx_evt_sessao` (`id_sessao_usuario`,`criado_em`),
  KEY `fk_pp_evt_user` (`id_usuario`),
  CONSTRAINT `fk_pp_evt_proto` FOREIGN KEY (`id_protocolo`) REFERENCES `procedimento_protocolo` (`id_protocolo`),
  CONSTRAINT `fk_pp_evt_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_pp_evt_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procedimento_protocolo_evento`
--

LOCK TABLES `procedimento_protocolo_evento` WRITE;
/*!40000 ALTER TABLE `procedimento_protocolo_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `procedimento_protocolo_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procedimento_protocolo_resultado`
--

DROP TABLE IF EXISTS `procedimento_protocolo_resultado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `procedimento_protocolo_resultado` (
  `id_resultado` bigint NOT NULL AUTO_INCREMENT,
  `id_protocolo` bigint NOT NULL,
  `categoria` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `conteudo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `versao` int NOT NULL DEFAULT '1',
  `id_resultado_anterior` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  PRIMARY KEY (`id_resultado`),
  UNIQUE KEY `uk_pp_res` (`id_protocolo`,`categoria`,`versao`),
  KEY `idx_pp_res_proto` (`id_protocolo`,`criado_em`),
  KEY `idx_pp_res_cat` (`categoria`,`criado_em`),
  KEY `fk_pp_res_prev` (`id_resultado_anterior`),
  KEY `fk_pp_res_sessao` (`id_sessao_usuario`),
  KEY `fk_pp_res_user` (`id_usuario`),
  CONSTRAINT `fk_pp_res_prev` FOREIGN KEY (`id_resultado_anterior`) REFERENCES `procedimento_protocolo_resultado` (`id_resultado`),
  CONSTRAINT `fk_pp_res_proto` FOREIGN KEY (`id_protocolo`) REFERENCES `procedimento_protocolo` (`id_protocolo`),
  CONSTRAINT `fk_pp_res_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_pp_res_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procedimento_protocolo_resultado`
--

LOCK TABLES `procedimento_protocolo_resultado` WRITE;
/*!40000 ALTER TABLE `procedimento_protocolo_resultado` DISABLE KEYS */;
/*!40000 ALTER TABLE `procedimento_protocolo_resultado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procedimentos_sigtap`
--

DROP TABLE IF EXISTS `procedimentos_sigtap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `procedimentos_sigtap` (
  `codigo_procedimento` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome_procedimento` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `valor_sus` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`codigo_procedimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procedimentos_sigtap`
--

LOCK TABLES `procedimentos_sigtap` WRITE;
/*!40000 ALTER TABLE `procedimentos_sigtap` DISABLE KEYS */;
/*!40000 ALTER TABLE `procedimentos_sigtap` ENABLE KEYS */;
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
  `nome` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `categoria` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Ex: escritório, manutenção, EPI, TI',
  `unidade_medida` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `nome` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `principio_ativo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `unidade_medida` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('MEDICAMENTO','INSUMO','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `nome` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Nome do produto',
  `tipo` enum('LIMPEZA','MANUTENCAO','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Tipo de produto',
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
-- Table structure for table `prontuario_evolucao`
--

DROP TABLE IF EXISTS `prontuario_evolucao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prontuario_evolucao` (
  `id_evolucao` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `texto_evolucao` longtext NOT NULL,
  `status` enum('ATIVO','REVISADO','CANCELADO') DEFAULT 'ATIVO',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `alterado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evolucao`),
  KEY `fk_evolucao_atendimento` (`id_atendimento`),
  KEY `fk_evolucao_usuario` (`id_usuario`),
  CONSTRAINT `fk_evolucao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `fk_evolucao_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prontuario_evolucao`
--

LOCK TABLES `prontuario_evolucao` WRITE;
/*!40000 ALTER TABLE `prontuario_evolucao` DISABLE KEYS */;
/*!40000 ALTER TABLE `prontuario_evolucao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `protocolo_emissao`
--

DROP TABLE IF EXISTS `protocolo_emissao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `protocolo_emissao` (
  `id_emissao` bigint NOT NULL AUTO_INCREMENT,
  `tipo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `chave` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `codigo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ano` int DEFAULT NULL,
  `data_ref` date DEFAULT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `id_paciente` bigint DEFAULT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_senha` bigint DEFAULT NULL,
  `id_cliente` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_emissao`),
  UNIQUE KEY `uk_protocolo_emissao_codigo` (`codigo`),
  KEY `idx_prot_tipo_data` (`tipo`,`ano`,`data_ref`,`criado_em`),
  KEY `idx_prot_paciente` (`id_paciente`),
  KEY `idx_prot_ffa` (`id_ffa`),
  KEY `idx_prot_senha` (`id_senha`),
  KEY `idx_prot_cliente` (`id_cliente`),
  KEY `idx_prot_sessao` (`id_sessao_usuario`),
  KEY `fk_prot_em_usuario` (`id_usuario`),
  CONSTRAINT `fk_prot_em_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  CONSTRAINT `fk_prot_em_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fk_prot_em_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`),
  CONSTRAINT `fk_prot_em_senha` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`),
  CONSTRAINT `fk_prot_em_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_prot_em_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `protocolo_emissao`
--

LOCK TABLES `protocolo_emissao` WRITE;
/*!40000 ALTER TABLE `protocolo_emissao` DISABLE KEYS */;
/*!40000 ALTER TABLE `protocolo_emissao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `protocolo_sequencia`
--

DROP TABLE IF EXISTS `protocolo_sequencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `protocolo_sequencia` (
  `chave` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ultimo_numero` int NOT NULL DEFAULT '0',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`chave`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `protocolo_sequencia`
--

LOCK TABLES `protocolo_sequencia` WRITE;
/*!40000 ALTER TABLE `protocolo_sequencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `protocolo_sequencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qualidade_eventos_adversos`
--

DROP TABLE IF EXISTS `qualidade_eventos_adversos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qualidade_eventos_adversos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `tipo_evento` enum('QUEDA','ERRO_MEDICACAO','INFECCAO_SITIO','LESÃO_PRESSAO','OUTROS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `gravidade` enum('LEVE','MODERADA','GRAVE','SENTINELA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `data_evento` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qualidade_eventos_adversos`
--

LOCK TABLES `qualidade_eventos_adversos` WRITE;
/*!40000 ALTER TABLE `qualidade_eventos_adversos` DISABLE KEYS */;
/*!40000 ALTER TABLE `qualidade_eventos_adversos` ENABLE KEYS */;
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
  `motivo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
-- Table structure for table `reg_anexo`
--

DROP TABLE IF EXISTS `reg_anexo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reg_anexo` (
  `id_anexo` bigint NOT NULL AUTO_INCREMENT,
  `entidade_ref` varchar(80) NOT NULL,
  `id_ref` bigint NOT NULL,
  `categoria` enum('SINAN','CAT','DOCUMENTO','PRONTUARIO','OUTRO') NOT NULL DEFAULT 'OUTRO',
  `nome_arquivo` varchar(200) NOT NULL,
  `mime_type` varchar(120) DEFAULT NULL,
  `tamanho_bytes` bigint DEFAULT NULL,
  `sha256` char(64) DEFAULT NULL,
  `storage_uri` varchar(255) DEFAULT NULL,
  `conteudo_blob` longblob,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_anexo`),
  KEY `idx_reg_anexo_ref` (`entidade_ref`,`id_ref`),
  KEY `idx_reg_anexo_sha` (`sha256`),
  KEY `idx_reg_anexo_sessao` (`id_sessao_usuario`),
  KEY `idx_reg_anexo_usuario` (`id_usuario`),
  CONSTRAINT `fk_reg_anexo_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_reg_anexo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reg_anexo`
--

LOCK TABLES `reg_anexo` WRITE;
/*!40000 ALTER TABLE `reg_anexo` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_anexo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reg_auditoria_acesso_sensivel`
--

DROP TABLE IF EXISTS `reg_auditoria_acesso_sensivel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reg_auditoria_acesso_sensivel` (
  `id_acesso` bigint NOT NULL AUTO_INCREMENT,
  `ocorrido_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `entidade_ref` varchar(80) NOT NULL,
  `id_ref` bigint NOT NULL,
  `acao` enum('VISUALIZAR','EXPORTAR','IMPRIMIR','ANEXAR','ALTERAR') NOT NULL DEFAULT 'VISUALIZAR',
  `motivo` varchar(255) DEFAULT NULL,
  `ip_origem` varchar(60) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_acesso`),
  KEY `idx_reg_acesso_dt` (`ocorrido_em`),
  KEY `idx_reg_acesso_ref` (`entidade_ref`,`id_ref`),
  KEY `idx_reg_acesso_usuario` (`id_usuario`),
  KEY `idx_reg_acesso_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_reg_acesso_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_reg_acesso_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reg_auditoria_acesso_sensivel`
--

LOCK TABLES `reg_auditoria_acesso_sensivel` WRITE;
/*!40000 ALTER TABLE `reg_auditoria_acesso_sensivel` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_auditoria_acesso_sensivel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reg_export_arquivo`
--

DROP TABLE IF EXISTS `reg_export_arquivo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reg_export_arquivo` (
  `id_export_arquivo` bigint NOT NULL AUTO_INCREMENT,
  `id_export_lote` bigint NOT NULL,
  `formato` enum('XML','PDF','JSON','CSV','ZIP','OUTRO') NOT NULL,
  `mime_type` varchar(120) DEFAULT NULL,
  `nome_arquivo` varchar(200) NOT NULL,
  `tamanho_bytes` bigint DEFAULT NULL,
  `sha256` char(64) DEFAULT NULL,
  `storage_uri` varchar(255) DEFAULT NULL,
  `conteudo_blob` longblob,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_export_arquivo`),
  KEY `idx_reg_arq_lote` (`id_export_lote`),
  KEY `idx_reg_arq_sha` (`sha256`),
  CONSTRAINT `fk_reg_arq_lote` FOREIGN KEY (`id_export_lote`) REFERENCES `reg_export_lote` (`id_export_lote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reg_export_arquivo`
--

LOCK TABLES `reg_export_arquivo` WRITE;
/*!40000 ALTER TABLE `reg_export_arquivo` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_export_arquivo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reg_export_erro_validacao`
--

DROP TABLE IF EXISTS `reg_export_erro_validacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reg_export_erro_validacao` (
  `id_export_erro` bigint NOT NULL AUTO_INCREMENT,
  `id_export_item` bigint DEFAULT NULL,
  `id_export_arquivo` bigint DEFAULT NULL,
  `severidade` enum('INFO','WARN','ERRO','FATAL') NOT NULL DEFAULT 'ERRO',
  `codigo` varchar(60) DEFAULT NULL,
  `campo` varchar(120) DEFAULT NULL,
  `mensagem` varchar(500) NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_export_erro`),
  KEY `idx_reg_erro_item` (`id_export_item`),
  KEY `idx_reg_erro_arquivo` (`id_export_arquivo`),
  KEY `idx_reg_erro_data` (`criado_em`),
  CONSTRAINT `fk_reg_erro_arquivo` FOREIGN KEY (`id_export_arquivo`) REFERENCES `reg_export_arquivo` (`id_export_arquivo`),
  CONSTRAINT `fk_reg_erro_item` FOREIGN KEY (`id_export_item`) REFERENCES `reg_export_item` (`id_export_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reg_export_erro_validacao`
--

LOCK TABLES `reg_export_erro_validacao` WRITE;
/*!40000 ALTER TABLE `reg_export_erro_validacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_export_erro_validacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reg_export_item`
--

DROP TABLE IF EXISTS `reg_export_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reg_export_item` (
  `id_export_item` bigint NOT NULL AUTO_INCREMENT,
  `id_export_lote` bigint NOT NULL,
  `entidade_ref` varchar(80) NOT NULL,
  `id_ref` bigint NOT NULL,
  `status` enum('PENDENTE','GERADO','ENVIADO','ERRO','CONFIRMADO','CANCELADO') NOT NULL DEFAULT 'PENDENTE',
  `payload_hash` char(64) DEFAULT NULL,
  `protocolo_externo` varchar(80) DEFAULT NULL,
  `tentativas` int NOT NULL DEFAULT '0',
  `ultima_tentativa_em` datetime DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_export_item`),
  UNIQUE KEY `uk_reg_item_lote_ref` (`id_export_lote`,`entidade_ref`,`id_ref`),
  KEY `idx_reg_item_status` (`status`),
  KEY `idx_reg_item_ref` (`entidade_ref`,`id_ref`),
  CONSTRAINT `fk_reg_item_lote` FOREIGN KEY (`id_export_lote`) REFERENCES `reg_export_lote` (`id_export_lote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reg_export_item`
--

LOCK TABLES `reg_export_item` WRITE;
/*!40000 ALTER TABLE `reg_export_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_export_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reg_export_lote`
--

DROP TABLE IF EXISTS `reg_export_lote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reg_export_lote` (
  `id_export_lote` bigint NOT NULL AUTO_INCREMENT,
  `tipo` enum('SINAN_EPIDEMIOLOGICA','SINAN_VIOLENCIA','CAT','PRODUCAO_SUS','FATURAMENTO','OUTRO') NOT NULL,
  `competencia` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_usuario_criador` bigint DEFAULT NULL,
  `id_unidade` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `status` enum('ABERTO','GERADO','ENVIADO','ERRO','CONFIRMADO','CANCELADO') NOT NULL DEFAULT 'ABERTO',
  `protocolo_externo` varchar(80) DEFAULT NULL,
  `observacao` text,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_export_lote`),
  KEY `idx_reg_lote_tipo_status` (`tipo`,`status`),
  KEY `idx_reg_lote_competencia` (`competencia`),
  KEY `idx_reg_lote_data` (`criado_em`),
  KEY `idx_reg_lote_sessao` (`id_sessao_usuario`),
  KEY `idx_reg_lote_usuario` (`id_usuario_criador`),
  KEY `idx_reg_lote_unidade_local` (`id_unidade`,`id_local_operacional`),
  KEY `fk_reg_lote_local` (`id_local_operacional`),
  CONSTRAINT `fk_reg_lote_competencia` FOREIGN KEY (`competencia`) REFERENCES `md_competencia` (`competencia`),
  CONSTRAINT `fk_reg_lote_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_atendimento` (`id_local`),
  CONSTRAINT `fk_reg_lote_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_reg_lote_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
  CONSTRAINT `fk_reg_lote_usuario` FOREIGN KEY (`id_usuario_criador`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reg_export_lote`
--

LOCK TABLES `reg_export_lote` WRITE;
/*!40000 ALTER TABLE `reg_export_lote` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_export_lote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reg_formulario_snapshot`
--

DROP TABLE IF EXISTS `reg_formulario_snapshot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reg_formulario_snapshot` (
  `id_snapshot` bigint NOT NULL AUTO_INCREMENT,
  `entidade_ref` varchar(80) NOT NULL,
  `id_ref` bigint NOT NULL,
  `tipo_formulario` varchar(80) NOT NULL,
  `versao_layout` varchar(40) DEFAULT NULL,
  `competencia` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `payload_json` json NOT NULL,
  `payload_hash` char(64) NOT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_usuario_criador` bigint DEFAULT NULL,
  `sigilo_nivel` enum('NORMAL','SENSIVEL','MUITO_SENSIVEL') NOT NULL DEFAULT 'SENSIVEL',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_snapshot`),
  UNIQUE KEY `uk_reg_snapshot_ref` (`entidade_ref`,`id_ref`,`tipo_formulario`,`versao_layout`),
  KEY `idx_reg_snapshot_hash` (`payload_hash`),
  KEY `idx_reg_snapshot_competencia` (`competencia`),
  KEY `idx_reg_snapshot_sessao` (`id_sessao_usuario`),
  KEY `idx_reg_snapshot_usuario` (`id_usuario_criador`),
  CONSTRAINT `fk_reg_snapshot_competencia` FOREIGN KEY (`competencia`) REFERENCES `md_competencia` (`competencia`),
  CONSTRAINT `fk_reg_snapshot_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_reg_snapshot_usuario` FOREIGN KEY (`id_usuario_criador`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reg_formulario_snapshot`
--

LOCK TABLES `reg_formulario_snapshot` WRITE;
/*!40000 ALTER TABLE `reg_formulario_snapshot` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_formulario_snapshot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regra_timeout`
--

DROP TABLE IF EXISTS `regra_timeout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regra_timeout` (
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `minutos` int DEFAULT NULL,
  `evento_timeout` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
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
-- Table structure for table `remocao_logistica`
--

DROP TABLE IF EXISTS `remocao_logistica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `remocao_logistica` (
  `id_remocao` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_atendimento` bigint NOT NULL,
  `motorista_nome` varchar(100) DEFAULT NULL,
  `tecnico_nome` varchar(100) DEFAULT NULL,
  `destino` varchar(255) NOT NULL,
  `status` enum('PENDENTE','EM_REMOCAO','CONCLUIDO') DEFAULT 'PENDENTE',
  `data_saida` datetime DEFAULT NULL,
  PRIMARY KEY (`id_remocao`),
  KEY `fk_rem_ffa_heranca` (`id_ffa`),
  KEY `fk_rem_atend_heranca` (`id_atendimento`),
  CONSTRAINT `fk_rem_atend_heranca` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `fk_rem_ffa_heranca` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `remocao_logistica`
--

LOCK TABLES `remocao_logistica` WRITE;
/*!40000 ALTER TABLE `remocao_logistica` DISABLE KEYS */;
/*!40000 ALTER TABLE `remocao_logistica` ENABLE KEYS */;
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
  `motivo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
-- Table structure for table `rh_evento`
--

DROP TABLE IF EXISTS `rh_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rh_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_rh_vinculo` bigint DEFAULT NULL,
  `id_registro` bigint DEFAULT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `evento` varchar(50) NOT NULL,
  `detalhe` varchar(255) DEFAULT NULL,
  `payload_json` json DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `ix_rh_evt_vinc` (`id_rh_vinculo`),
  KEY `ix_rh_evt_reg` (`id_registro`),
  KEY `ix_rh_evt_evt` (`evento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rh_evento`
--

LOCK TABLES `rh_evento` WRITE;
/*!40000 ALTER TABLE `rh_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `rh_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rh_pessoa_vinculo`
--

DROP TABLE IF EXISTS `rh_pessoa_vinculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rh_pessoa_vinculo` (
  `id_rh_vinculo` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `tipo_vinculo` enum('FUNCIONARIO','TERCEIRO','ESTAGIARIO','PRESTADOR','VOLUNTARIO') NOT NULL DEFAULT 'FUNCIONARIO',
  `matricula` varchar(40) DEFAULT NULL,
  `cpf` varchar(14) DEFAULT NULL,
  `rg` varchar(30) DEFAULT NULL,
  `orgao_emissor` varchar(20) DEFAULT NULL,
  `pis_pasep` varchar(20) DEFAULT NULL,
  `data_admissao` date DEFAULT NULL,
  `data_demissao` date DEFAULT NULL,
  `status` enum('ATIVO','INATIVO','AFASTADO') NOT NULL DEFAULT 'ATIVO',
  `id_unidade_lotacao` bigint DEFAULT NULL,
  `id_local_lotacao` bigint DEFAULT NULL,
  `cargo` varchar(120) DEFAULT NULL,
  `setor` varchar(120) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `telefone` varchar(40) DEFAULT NULL,
  `endereco` varchar(255) DEFAULT NULL,
  `observacao` text,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_rh_vinculo`),
  UNIQUE KEY `uk_rh_matricula` (`matricula`),
  KEY `ix_rh_pessoa` (`id_pessoa`),
  KEY `ix_rh_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rh_pessoa_vinculo`
--

LOCK TABLES `rh_pessoa_vinculo` WRITE;
/*!40000 ALTER TABLE `rh_pessoa_vinculo` DISABLE KEYS */;
/*!40000 ALTER TABLE `rh_pessoa_vinculo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rh_registro_profissional`
--

DROP TABLE IF EXISTS `rh_registro_profissional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rh_registro_profissional` (
  `id_registro` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `conselho` enum('CRM','COREN','CRF','CRO','CREFITO','CRP','CRN','OUTRO') NOT NULL DEFAULT 'OUTRO',
  `numero` varchar(30) NOT NULL,
  `uf` char(2) DEFAULT NULL,
  `uf_norm` char(2) GENERATED ALWAYS AS (ifnull(`uf`,_utf8mb4'--')) STORED,
  `especialidade` varchar(120) DEFAULT NULL,
  `validade` date DEFAULT NULL,
  `status` enum('ATIVO','INATIVO','SUSPENSO') NOT NULL DEFAULT 'ATIVO',
  `origem` enum('MANUAL','RH','IMPORTADO','INTEGRACAO') NOT NULL DEFAULT 'MANUAL',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_registro`),
  UNIQUE KEY `uk_registro` (`conselho`,`numero`,`uf_norm`),
  KEY `ix_registro_pessoa` (`id_pessoa`),
  KEY `ix_registro_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rh_registro_profissional`
--

LOCK TABLES `rh_registro_profissional` WRITE;
/*!40000 ALTER TABLE `rh_registro_profissional` DISABLE KEYS */;
/*!40000 ALTER TABLE `rh_registro_profissional` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sala`
--

DROP TABLE IF EXISTS `sala`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sala` (
  `id_sala` int NOT NULL AUTO_INCREMENT,
  `nome_exibicao` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
-- Table structure for table `sala_notificacao_evento`
--

DROP TABLE IF EXISTS `sala_notificacao_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sala_notificacao_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_notificacao` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `tipo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `detalhe` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_usuario` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_sn_evento_notif` (`id_notificacao`,`criado_em`),
  KEY `idx_sn_evento_sessao` (`id_sessao_usuario`,`criado_em`),
  KEY `idx_sn_evento_usuario` (`id_usuario`,`criado_em`),
  CONSTRAINT `fk_sn_evento_notif` FOREIGN KEY (`id_notificacao`) REFERENCES `sala_notificacao` (`id_notificacao`),
  CONSTRAINT `fk_sn_evento_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_sn_evento_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sala_notificacao_evento`
--

LOCK TABLES `sala_notificacao_evento` WRITE;
/*!40000 ALTER TABLE `sala_notificacao_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `sala_notificacao_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `senha_eventos`
--

DROP TABLE IF EXISTS `senha_eventos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `senha_eventos` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_senha` bigint NOT NULL,
  `tipo_evento` varchar(60) NOT NULL,
  `detalhe` text,
  `status_de` varchar(50) DEFAULT NULL,
  `status_para` varchar(50) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_se_senha_criado` (`id_senha`,`criado_em`),
  KEY `idx_se_sessao_criado` (`id_sessao_usuario`,`criado_em`),
  KEY `idx_se_tipo_criado` (`tipo_evento`,`criado_em`),
  CONSTRAINT `fk_senha_eventos_senha` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`),
  CONSTRAINT `fk_senha_eventos_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `senha_eventos`
--

LOCK TABLES `senha_eventos` WRITE;
/*!40000 ALTER TABLE `senha_eventos` DISABLE KEYS */;
INSERT INTO `senha_eventos` VALUES (1,3,4,'INICIAR_COMPLEMENTACAO','local_operacional=1','AGUARDANDO','EM_COMPLEMENTACAO','2026-02-15 03:36:47'),(2,3,3,'INICIAR_COMPLEMENTACAO','local_operacional=1','CHAMANDO','EM_COMPLEMENTACAO','2026-02-15 03:38:24'),(3,3,1,'INICIAR_COMPLEMENTACAO','local_operacional=1','AGUARDANDO','EM_COMPLEMENTACAO','2026-02-15 04:24:39'),(4,3,1,'INICIAR_COMPLEMENTACAO','local_operacional=1','EM_COMPLEMENTACAO','EM_COMPLEMENTACAO','2026-02-15 04:27:57'),(5,3,1,'INICIAR_COMPLEMENTACAO','local_operacional=1','EM_COMPLEMENTACAO','EM_COMPLEMENTACAO','2026-02-15 04:30:13'),(6,3,1,'INICIAR_COMPLEMENTACAO','local_operacional=1','EM_COMPLEMENTACAO','EM_COMPLEMENTACAO','2026-02-15 04:31:10'),(7,3,1,'COMPLEMENTAR_E_ABRIR_FFA','id_pessoa=34|id_paciente=8|id_ffa=12|gpat=GPAT-20260215-0000000001','EM_COMPLEMENTACAO','ENCAMINHADO','2026-02-15 04:31:10');
/*!40000 ALTER TABLE `senha_eventos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `senha_sequencia`
--

DROP TABLE IF EXISTS `senha_sequencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `senha_sequencia` (
  `id_sistema` bigint NOT NULL,
  `id_unidade` bigint NOT NULL,
  `data_ref` date NOT NULL,
  `prefixo` varchar(5) NOT NULL,
  `ultimo_numero` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_sistema`,`id_unidade`,`data_ref`,`prefixo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `senha_sequencia`
--

LOCK TABLES `senha_sequencia` WRITE;
/*!40000 ALTER TABLE `senha_sequencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `senha_sequencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `senhas`
--

DROP TABLE IF EXISTS `senhas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `senhas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_sistema` bigint NOT NULL,
  `id_servico` int DEFAULT NULL,
  `id_unidade` bigint NOT NULL,
  `numero` int NOT NULL,
  `prefixo` varchar(5) NOT NULL,
  `codigo` varchar(10) NOT NULL,
  `data_ref` date NOT NULL,
  `tipo_atendimento` enum('CLINICO','PEDIATRICO','PRIORITARIO','EMERGENCIA','VISITA','EXAME') NOT NULL,
  `lane` enum('ADULTO','PEDIATRICO','PRIORITARIO') NOT NULL DEFAULT 'ADULTO',
  `origem` enum('TOTEM','RECEPCAO','ADMIN','SAMU') NOT NULL DEFAULT 'RECEPCAO',
  `status` enum('GERADA','AGUARDANDO','CHAMANDO','EM_COMPLEMENTACAO','ENCAMINHADO','EM_ATENDIMENTO','NAO_COMPARECEU','FINALIZADO','CANCELADO') NOT NULL DEFAULT 'GERADA',
  `prioridade` tinyint DEFAULT '0',
  `id_paciente` bigint DEFAULT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `id_usuario_operador` bigint DEFAULT NULL,
  `id_usuario_chamada` bigint DEFAULT NULL,
  `id_usuario_complementacao` bigint DEFAULT NULL,
  `id_usuario_complementacao_fim` bigint DEFAULT NULL,
  `criada_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `posicionado_em` datetime DEFAULT NULL,
  `chamada_em` datetime DEFAULT NULL,
  `inicio_complementacao_em` datetime DEFAULT NULL,
  `fim_complementacao_em` datetime DEFAULT NULL,
  `inicio_atendimento_em` datetime DEFAULT NULL,
  `finalizada_em` datetime DEFAULT NULL,
  `nao_compareceu_em` datetime DEFAULT NULL,
  `retorno_permitido_ate` datetime DEFAULT NULL,
  `retorno_utilizado` tinyint(1) NOT NULL DEFAULT '0',
  `retorno_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_senha_dia_canonico` (`id_sistema`,`id_unidade`,`data_ref`,`codigo`),
  KEY `fk_senhas_paciente` (`id_paciente`),
  KEY `fk_senhas_usuario` (`id_usuario_operador`),
  KEY `fk_senhas_unidade` (`id_unidade`),
  KEY `idx_fila_painel` (`id_local_operacional`,`status`,`prioridade`,`criada_em`),
  KEY `idx_senha_codigo` (`id_sistema`,`id_unidade`,`codigo`),
  KEY `idx_senha_usuario_chamada` (`id_usuario_chamada`),
  KEY `idx_fila_painel_pos` (`id_local_operacional`,`status`,`prioridade`,`posicionado_em`),
  KEY `idx_senhas_fila_ordem` (`tipo_atendimento`,`status`,`lane`,`prioridade`,`posicionado_em`),
  CONSTRAINT `fk_senhas_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`),
  CONSTRAINT `fk_senhas_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
  CONSTRAINT `fk_senhas_usuario` FOREIGN KEY (`id_usuario_operador`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `fk_senhas_usuario_chamada` FOREIGN KEY (`id_usuario_chamada`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `senhas`
--

LOCK TABLES `senhas` WRITE;
/*!40000 ALTER TABLE `senhas` DISABLE KEYS */;
INSERT INTO `senhas` VALUES (1,1,NULL,2,1,'A','A001','2026-01-28','CLINICO','ADULTO','RECEPCAO','ENCAMINHADO',0,8,12,NULL,5,NULL,5,5,'2026-01-28 06:01:27','2026-01-28 06:01:27',NULL,'2026-02-15 04:24:39','2026-02-15 04:31:10',NULL,NULL,NULL,NULL,0,NULL),(3,1,NULL,2,1,'A','A001','2026-02-13','CLINICO','ADULTO','TOTEM','EM_COMPLEMENTACAO',0,NULL,NULL,1,5,5,5,NULL,'2026-02-13 06:17:42','2026-02-13 06:17:42','2026-02-13 06:19:40','2026-02-15 03:38:24',NULL,NULL,NULL,NULL,NULL,0,NULL),(4,1,NULL,2,2,'A','A002','2026-02-13','CLINICO','ADULTO','TOTEM','EM_COMPLEMENTACAO',0,NULL,NULL,1,5,NULL,5,NULL,'2026-02-13 06:19:25','2026-02-13 06:19:25',NULL,'2026-02-15 03:36:47',NULL,NULL,NULL,NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `senhas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servico_agendamento`
--

DROP TABLE IF EXISTS `servico_agendamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servico_agendamento` (
  `id_servico` bigint NOT NULL AUTO_INCREMENT,
  `id_sistema` bigint NOT NULL,
  `id_unidade` bigint NOT NULL,
  `codigo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `duracao_minutos` int NOT NULL DEFAULT '15',
  `categoria` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('CONSULTA','PROCEDIMENTO','EXAME','RETORNO','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'CONSULTA',
  `exige_profissional` tinyint(1) NOT NULL DEFAULT '1',
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_servico`),
  UNIQUE KEY `uk_servico_ctx_codigo` (`id_sistema`,`id_unidade`,`codigo`),
  KEY `ix_servico_ctx` (`id_sistema`,`id_unidade`),
  KEY `fk_servico_unidade` (`id_unidade`),
  CONSTRAINT `fk_servico_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
  CONSTRAINT `fk_servico_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servico_agendamento`
--

LOCK TABLES `servico_agendamento` WRITE;
/*!40000 ALTER TABLE `servico_agendamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `servico_agendamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessao_ativa`
--

DROP TABLE IF EXISTS `sessao_ativa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessao_ativa` (
  `id_usuario` bigint NOT NULL,
  `token_sessao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ip_origem` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ultimo_clique` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uk_token` (`token_sessao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessao_ativa`
--

LOCK TABLES `sessao_ativa` WRITE;
/*!40000 ALTER TABLE `sessao_ativa` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessao_ativa` ENABLE KEYS */;
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
  `token` text,
  `ip_acesso` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `iniciado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `expira_em` datetime DEFAULT NULL,
  `encerrado_em` datetime DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_sessao_usuario`),
  KEY `idx_su_usuario` (`id_usuario`),
  KEY `idx_su_contexto` (`id_sistema`,`id_unidade`,`id_local_operacional`),
  KEY `fk_su_unidade` (`id_unidade`),
  KEY `fk_su_localop` (`id_local_operacional`),
  KEY `idx_sessao_token` (`token`(255)),
  KEY `idx_sessao_ativa` (`ativo`,`expira_em`),
  CONSTRAINT `fk_su_localop` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
  CONSTRAINT `fk_su_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
  CONSTRAINT `fk_su_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
  CONSTRAINT `fk_su_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessao_usuario`
--

LOCK TABLES `sessao_usuario` WRITE;
/*!40000 ALTER TABLE `sessao_usuario` DISABLE KEYS */;
INSERT INTO `sessao_usuario` VALUES (2,5,1,2,1,NULL,'DEV','127.0.0.1','Workbench','2026-02-13 05:10:01',NULL,NULL,1),(3,5,1,2,1,NULL,'DEV','127.0.0.1','Workbench','2026-02-13 06:19:13',NULL,NULL,1);
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
  `id_unidade` bigint NOT NULL,
  `nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('PRONTO_SOCORRO','OBSERVACAO','INTERNACAO','UTI_ADULTO','UTI_PEDIATRICA','CENTRO_CIRURGICO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ramal` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `responsavel_id` bigint DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_setor`),
  KEY `fk_setor_unidade` (`id_unidade`),
  CONSTRAINT `fk_setor_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
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
  `codigo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('EXAME','PROCEDIMENTO','CONSULTA','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `grupo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `subgrupo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `setor_execucao` enum('RX','LABORATORIO','ECG','MEDICACAO','AMBULATORIO','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'OUTRO',
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
-- Table structure for table `sinais_vitais`
--

DROP TABLE IF EXISTS `sinais_vitais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sinais_vitais` (
  `id_sinal` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `frequencia_cardiaca` int DEFAULT NULL,
  `pressao_sistolica` int DEFAULT NULL,
  `pressao_diastolica` int DEFAULT NULL,
  `temperatura` decimal(4,2) DEFAULT NULL,
  `saturacao_o2` int DEFAULT NULL,
  `dor` int DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sinal`),
  KEY `fk_sinais_atendimento` (`id_atendimento`),
  CONSTRAINT `fk_sinais_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sinais_vitais`
--

LOCK TABLES `sinais_vitais` WRITE;
/*!40000 ALTER TABLE `sinais_vitais` DISABLE KEYS */;
/*!40000 ALTER TABLE `sinais_vitais` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sinan_evento`
--

DROP TABLE IF EXISTS `sinan_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sinan_evento` (
  `id_sinan_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_sinan` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `evento` varchar(50) NOT NULL,
  `payload_json` json DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sinan_evento`),
  KEY `ix_sinan_evento_sinan` (`id_sinan`),
  KEY `ix_sinan_evento_evt` (`evento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sinan_evento`
--

LOCK TABLES `sinan_evento` WRITE;
/*!40000 ALTER TABLE `sinan_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `sinan_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sinan_notificacao`
--

DROP TABLE IF EXISTS `sinan_notificacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sinan_notificacao` (
  `id_sinan` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_gpat` bigint NOT NULL,
  `id_usuario_responsavel` bigint NOT NULL,
  `tipo_notificacao` varchar(80) NOT NULL,
  `status` enum('ABERTA','EM_PREENCHIMENTO','ENVIADA','CANCELADA','CONCLUIDA') NOT NULL DEFAULT 'ABERTA',
  `payload_json` json DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_sinan`),
  KEY `ix_sinan_ffa` (`id_ffa`),
  KEY `ix_sinan_gpat` (`id_gpat`),
  KEY `ix_sinan_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sinan_notificacao`
--

LOCK TABLES `sinan_notificacao` WRITE;
/*!40000 ALTER TABLE `sinan_notificacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `sinan_notificacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema`
--

DROP TABLE IF EXISTS `sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema` (
  `id_sistema` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sistema`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema`
--

LOCK TABLES `sistema` WRITE;
/*!40000 ALTER TABLE `sistema` DISABLE KEYS */;
INSERT INTO `sistema` VALUES (1,'','PA','Pronto Atendimento',1,'2026-01-17 22:59:54'),(2,'','UBS','Unidade Básica de Saúde',1,'2026-01-17 22:59:54'),(4,'PA','Pronto Atendimento','Contexto operacional do PA',1,'2026-01-27 23:40:56'),(5,'ATENDE_ALPHA','Atende-Alpha','Sistema principal (HIS/PA/UBS/UPA/Prefeitura)',1,'2026-02-09 06:17:32');
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
  `status` enum('SOLICITADO','COLETADO','EM_ANALISE','RESULTADO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `status` enum('AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','AGUARDANDO_RX','CHAMANDO_RX','AGUARDANDO_MEDICACAO','EM_MEDICACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tempo_max_segundos` int NOT NULL,
  `status_fallback` enum('AGUARDANDO_CHAMADA_MEDICO','AGUARDANDO_RX','AGUARDANDO_MEDICACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
-- Table structure for table `sus_cid10_competencia`
--

DROP TABLE IF EXISTS `sus_cid10_competencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sus_cid10_competencia` (
  `id_cid10c` bigint NOT NULL AUTO_INCREMENT,
  `competencia` char(6) NOT NULL,
  `cid10` varchar(10) NOT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cid10c`),
  UNIQUE KEY `uk_cid10c_comp` (`competencia`,`cid10`),
  KEY `ix_cid10c_cid` (`cid10`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sus_cid10_competencia`
--

LOCK TABLES `sus_cid10_competencia` WRITE;
/*!40000 ALTER TABLE `sus_cid10_competencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `sus_cid10_competencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sus_cnes_estabelecimento`
--

DROP TABLE IF EXISTS `sus_cnes_estabelecimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sus_cnes_estabelecimento` (
  `id_cnes` bigint NOT NULL AUTO_INCREMENT,
  `competencia` char(6) NOT NULL,
  `cnes` varchar(20) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `municipio` varchar(120) DEFAULT NULL,
  `uf` char(2) DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_cnes`),
  UNIQUE KEY `uk_cnes_comp_cnes` (`competencia`,`cnes`),
  KEY `ix_cnes_cnes` (`cnes`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sus_cnes_estabelecimento`
--

LOCK TABLES `sus_cnes_estabelecimento` WRITE;
/*!40000 ALTER TABLE `sus_cnes_estabelecimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `sus_cnes_estabelecimento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sus_competencia`
--

DROP TABLE IF EXISTS `sus_competencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sus_competencia` (
  `id_competencia` bigint NOT NULL AUTO_INCREMENT,
  `competencia` char(6) NOT NULL,
  `descricao` varchar(120) DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_competencia`),
  UNIQUE KEY `uk_sus_competencia` (`competencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sus_competencia`
--

LOCK TABLES `sus_competencia` WRITE;
/*!40000 ALTER TABLE `sus_competencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `sus_competencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sus_sigtap_procedimento`
--

DROP TABLE IF EXISTS `sus_sigtap_procedimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sus_sigtap_procedimento` (
  `id_sigtap` bigint NOT NULL AUTO_INCREMENT,
  `competencia` char(6) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `descricao_completa` text,
  `grupo` varchar(80) DEFAULT NULL,
  `subgrupo` varchar(80) DEFAULT NULL,
  `forma_organizacao` varchar(80) DEFAULT NULL,
  `complexidade` varchar(40) DEFAULT NULL,
  `sexo` enum('I','M','F') NOT NULL DEFAULT 'I',
  `idade_min` int DEFAULT NULL,
  `idade_max` int DEFAULT NULL,
  `exige_cat_default` tinyint(1) NOT NULL DEFAULT '0',
  `exige_sinan_default` tinyint(1) NOT NULL DEFAULT '0',
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_sigtap`),
  UNIQUE KEY `uk_sigtap_comp_cod` (`competencia`,`codigo`),
  KEY `ix_sigtap_codigo` (`codigo`),
  KEY `ix_sigtap_comp` (`competencia`),
  KEY `ix_sigtap_exige_cat` (`exige_cat_default`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sus_sigtap_procedimento`
--

LOCK TABLES `sus_sigtap_procedimento` WRITE;
/*!40000 ALTER TABLE `sus_sigtap_procedimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `sus_sigtap_procedimento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tabela_tuss`
--

DROP TABLE IF EXISTS `tabela_tuss`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabela_tuss` (
  `codigo_tuss` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `valor_honorario` decimal(10,2) DEFAULT NULL,
  `valor_custo_operacional` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`codigo_tuss`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tabela_tuss`
--

LOCK TABLES `tabela_tuss` WRITE;
/*!40000 ALTER TABLE `tabela_tuss` DISABLE KEYS */;
/*!40000 ALTER TABLE `tabela_tuss` ENABLE KEYS */;
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
  `origem` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nota` int DEFAULT NULL,
  `comentario` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
-- Table structure for table `totem_senha_opcao`
--

DROP TABLE IF EXISTS `totem_senha_opcao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `totem_senha_opcao` (
  `id_opcao` bigint NOT NULL AUTO_INCREMENT,
  `id_painel` bigint NOT NULL,
  `codigo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `label` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `lane` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_atendimento` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `prefixo` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ordem` int NOT NULL DEFAULT '1',
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_opcao`),
  UNIQUE KEY `uk_totem_opcao` (`id_painel`,`codigo`),
  KEY `idx_totem_opcao_painel` (`id_painel`),
  CONSTRAINT `fk_totem_opcao_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `totem_senha_opcao`
--

LOCK TABLES `totem_senha_opcao` WRITE;
/*!40000 ALTER TABLE `totem_senha_opcao` DISABLE KEYS */;
INSERT INTO `totem_senha_opcao` VALUES (1,9,'CLINICO','Clínico','ADULTO','CLINICO',NULL,1,1,'2026-02-03 23:59:52'),(2,9,'PEDIATRICO','Pediátrico','PEDIATRICO','PEDIATRICO',NULL,2,1,'2026-02-03 23:59:52'),(3,9,'PRIORITARIO','Prioritário','PRIORITARIO','PRIORITARIO',NULL,3,1,'2026-02-03 23:59:52');
/*!40000 ALTER TABLE `totem_senha_opcao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transporte_ambulancia`
--

DROP TABLE IF EXISTS `transporte_ambulancia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transporte_ambulancia` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_senha` bigint NOT NULL,
  `placa_veiculo` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `condutor_nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo_equipe` enum('BASICA','AVANCADA','AEREA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `km_saida` int DEFAULT NULL,
  `km_chegada` int DEFAULT NULL,
  `data_hora_acionamento` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_samu_senha` (`id_senha`),
  CONSTRAINT `fk_samu_senha` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transporte_ambulancia`
--

LOCK TABLES `transporte_ambulancia` WRITE;
/*!40000 ALTER TABLE `transporte_ambulancia` DISABLE KEYS */;
/*!40000 ALTER TABLE `transporte_ambulancia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transporte_ambulancia_evento`
--

DROP TABLE IF EXISTS `transporte_ambulancia_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transporte_ambulancia_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_transporte` bigint NOT NULL,
  `evento` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `detalhe` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_tae_transporte` (`id_transporte`),
  KEY `idx_tae_sessao` (`id_sessao_usuario`),
  CONSTRAINT `fk_tae_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_tae_transporte` FOREIGN KEY (`id_transporte`) REFERENCES `transporte_ambulancia` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transporte_ambulancia_evento`
--

LOCK TABLES `transporte_ambulancia_evento` WRITE;
/*!40000 ALTER TABLE `transporte_ambulancia_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `transporte_ambulancia_evento` ENABLE KEYS */;
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
  `queixa` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `sinais_vitais` json DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
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
-- Table structure for table `tv_rotativo`
--

DROP TABLE IF EXISTS `tv_rotativo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tv_rotativo` (
  `id_tv_rotativo` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_unidade` bigint DEFAULT NULL,
  `intervalo_seg` int NOT NULL DEFAULT '120',
  `ativo` tinyint NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `criado_por` bigint DEFAULT NULL,
  `atualizado_em` datetime DEFAULT NULL,
  `atualizado_por` bigint DEFAULT NULL,
  PRIMARY KEY (`id_tv_rotativo`),
  UNIQUE KEY `uk_tv_rotativo_nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tv_rotativo`
--

LOCK TABLES `tv_rotativo` WRITE;
/*!40000 ALTER TABLE `tv_rotativo` DISABLE KEYS */;
/*!40000 ALTER TABLE `tv_rotativo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tv_rotativo_tela`
--

DROP TABLE IF EXISTS `tv_rotativo_tela`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tv_rotativo_tela` (
  `id_tela` bigint NOT NULL AUTO_INCREMENT,
  `id_painel` bigint NOT NULL,
  `codigo_tela` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ordem` int NOT NULL,
  `duracao_seg` int NOT NULL DEFAULT '120',
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_tela`),
  UNIQUE KEY `uk_tv_rotativo` (`id_painel`,`ordem`),
  KEY `idx_tv_painel` (`id_painel`),
  CONSTRAINT `fk_tv_rotativo_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tv_rotativo_tela`
--

LOCK TABLES `tv_rotativo_tela` WRITE;
/*!40000 ALTER TABLE `tv_rotativo_tela` DISABLE KEYS */;
INSERT INTO `tv_rotativo_tela` VALUES (1,11,'MEDICO_CLINICO',1,120,1,'2026-02-04 00:03:36',NULL),(2,11,'MEDICACAO',2,120,1,'2026-02-04 00:03:36',NULL),(3,11,'COLETA',3,120,1,'2026-02-04 00:03:36',NULL),(4,11,'MEDICO_CLINICO',4,120,1,'2026-02-04 00:03:36',NULL),(5,11,'RX',5,120,1,'2026-02-04 00:03:36',NULL),(6,11,'TRIAGEM',6,120,1,'2026-02-04 00:03:36',NULL),(7,11,'RECEPCAO',7,120,1,'2026-02-04 00:03:36',NULL),(8,11,'MEDICO_PEDI',8,120,1,'2026-02-04 00:03:36',NULL),(16,11,'MEDICO_CLINICO_SALA3',9,120,1,'2026-02-04 00:03:49','2026-02-04 04:24:21'),(26,249,'MEDICO_CLINICO',1,120,1,'2026-02-04 04:03:41',NULL),(27,249,'MEDICACAO',2,120,1,'2026-02-04 04:03:41',NULL),(28,249,'COLETA',3,120,1,'2026-02-04 04:03:41',NULL),(29,249,'RX',4,120,1,'2026-02-04 04:03:41',NULL);
/*!40000 ALTER TABLE `tv_rotativo_tela` ENABLE KEYS */;
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
  `nome` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cnes` char(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('UPA','HOSPITAL','PA','CLINICA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_unidade`),
  KEY `id_cidade` (`id_cidade`),
  KEY `id_sistema` (`id_sistema`),
  KEY `idx_unidade_cnes` (`cnes`),
  CONSTRAINT `fk_unidade_cnes` FOREIGN KEY (`cnes`) REFERENCES `md_cnes_estabelecimento` (`cnes`),
  CONSTRAINT `unidade_ibfk_1` FOREIGN KEY (`id_cidade`) REFERENCES `cidade` (`id_cidade`),
  CONSTRAINT `unidade_ibfk_2` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unidade`
--

LOCK TABLES `unidade` WRITE;
/*!40000 ALTER TABLE `unidade` DISABLE KEYS */;
INSERT INTO `unidade` VALUES (2,4,2,'Unidade Principal',NULL,'PA',1),(3,5,3,'Guido Guida',NULL,'HOSPITAL',1);
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
  `login` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_conselho` int DEFAULT NULL,
  `registro_profissional` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `senha_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `primeiro_login` tinyint(1) DEFAULT '1',
  `senha_expira_em` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `forcar_troca_senha` tinyint(1) DEFAULT '0',
  `senha_atualizada_em` datetime DEFAULT NULL,
  `senha_resetada_em` datetime DEFAULT NULL,
  `senha_resetada_por` bigint DEFAULT NULL,
  `bloqueado_ate` datetime DEFAULT NULL,
  `tentativas_login` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `login` (`login`),
  KEY `id_pessoa` (`id_pessoa`),
  KEY `fk_usuario_conselho` (`id_conselho`),
  KEY `fk_usuario_resetado_por` (`senha_resetada_por`),
  CONSTRAINT `fk_usuario_conselho` FOREIGN KEY (`id_conselho`) REFERENCES `conselho_profissional` (`id_conselho`),
  CONSTRAINT `fk_usuario_resetado_por` FOREIGN KEY (`senha_resetada_por`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,1,'teste_user',NULL,NULL,NULL,1,1,NULL,'2026-01-12 09:10:01','2026-01-12 09:10:01',0,NULL,NULL,NULL,NULL,0),(2,2,'yasnanakase',NULL,NULL,'$2y$10$3m48kYSUVWW6bCl.yRDfKePrOJCXxHCB33O71VKXINpxs8dvkE7bG',1,0,NULL,'2026-01-18 08:46:10','2026-01-18 08:56:16',0,NULL,NULL,NULL,NULL,0),(5,5,'admin',NULL,NULL,'240be518fab243c511a34155145c0468e10ef9c1d94538d684457e3f60d7f396',1,1,NULL,'2026-01-28 02:40:56','2026-01-28 09:35:35',0,NULL,NULL,NULL,NULL,0),(6,6,'totem',NULL,NULL,NULL,1,0,NULL,'2026-01-28 02:40:56','2026-01-28 02:40:56',0,NULL,NULL,NULL,NULL,0),(9,11,'recep01',NULL,NULL,'240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',1,1,NULL,'2026-01-28 09:03:48','2026-01-28 09:03:48',0,NULL,NULL,NULL,NULL,0),(10,12,'enfe01',NULL,NULL,'240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',1,1,NULL,'2026-01-28 09:03:48','2026-01-28 09:03:48',0,NULL,NULL,NULL,NULL,0),(11,13,'med01',NULL,NULL,'240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',1,1,NULL,'2026-01-28 09:03:48','2026-01-28 09:03:48',0,NULL,NULL,NULL,NULL,0);
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
INSERT INTO `usuario_local_operacional` VALUES (5,1,1,'2026-01-27 23:40:56'),(5,2,1,'2026-01-27 23:40:56'),(5,3,1,'2026-01-27 23:40:56'),(5,4,1,'2026-01-27 23:40:56'),(5,5,1,'2026-01-27 23:40:56'),(5,6,1,'2026-01-27 23:40:56'),(6,6,1,'2026-01-27 23:40:56');
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
) ENGINE=InnoDB AUTO_INCREMENT=396 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Refresh tokens de autenticação com rotação e revogação';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_refresh`
--

LOCK TABLES `usuario_refresh` WRITE;
/*!40000 ALTER TABLE `usuario_refresh` DISABLE KEYS */;
INSERT INTO `usuario_refresh` VALUES (1,1,'7558537e0f4678dc571d37461ddd4555bf280e5bcaf43edce1e638398be9be30','2026-02-03 07:47:25','2026-01-04 03:47:25',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(2,1,'038e6bddb719e4a51cc0e1a575a71db374ccfe0ff7483e4f19bd25684540cfa1','2026-02-03 07:47:54','2026-01-04 03:47:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(3,8,'0ed677b9f9c732b6970b679389ec573a7221e265976b7a7fa1e1dbeb472b1072','2026-02-03 07:49:00','2026-01-04 03:49:00',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(4,9,'8181ee9d9b37e8463f84891ac6e1107d2b03a9173600559a3a53c1106f32cde0','2026-02-03 07:49:19','2026-01-04 03:49:19',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(5,9,'6d2b06a8740ca74fdaf5198193eab9493e863f5dd89b5d91173cbd565b78bfe8','2026-02-03 07:49:26','2026-01-04 03:49:26',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(6,1,'e9368a2fa2cd9c794d113943b69e0ea15379e8ab3f392fd44ce06733683366fc','2026-02-03 07:49:36','2026-01-04 03:49:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(7,1,'3c6d3785a575a5329bbc2cbab2ac77c4e383f378a2c402f606158241a87dca3a','2026-02-03 07:56:23','2026-01-04 03:56:23',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(8,1,'aeeae656c5031a47cc723b57dce6ab2192c79c48da906185e3a997b8a7d38876','2026-02-03 07:56:35','2026-01-04 03:56:35',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(9,10,'63a9134e1f7c6212363617256966779a99347fa0d48fa5989fa2751c9138720d','2026-02-03 07:56:43','2026-01-04 03:56:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(10,10,'75ecf45da83ef65781bdaf830659747744a4171898481213b1e6927de5bc6452','2026-02-03 07:56:47','2026-01-04 03:56:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(11,1,'3b271a484feac2c3d70edbc30b0d2f0b63a943ec5181cd5f6da2cd2076a5e813','2026-02-03 07:56:54','2026-01-04 03:56:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(12,1,'a72d64a7a3f2fe19fa98374b60c0e2a0048e735e2f3caf39f0212ed89ed6acfa','2026-02-03 08:40:46','2026-01-04 04:40:46',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','192.168.1.98'),(13,1,'d9888ebd86d886a9da4450d9ed1449ce5a0919b0bf6d7a95e434b4c5c9f9654d','2026-02-03 08:55:54','2026-01-04 04:55:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(14,1,'9403ed66083c17ad2c7f184908f86b1a987c5e0a15a268f40e0dd75057246d02','2026-02-03 09:03:02','2026-01-04 05:03:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(15,1,'348ef17cab1bfecbda0958766585249ad583c689828ba3b6d64477b449639ca1','2026-02-03 09:10:33','2026-01-04 05:10:33',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(16,1,'d7b840c8101f2fb18af2b40c4a7f72f2a8e3c92c2cd7deb18ca18dd5e4a16b41','2026-02-03 09:37:58','2026-01-04 05:37:58',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','192.168.1.83'),(17,1,'52f96f976bee6753fb807d424ba46b1db9f1afc0f70f0b15c64d499020bfc111','2026-02-03 10:09:34','2026-01-04 06:09:34',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(18,1,'ea39406997ed7e387ed802ec4038830190e6f83ae6cca3c0f8059e8ee96e68f2','2026-02-03 10:59:19','2026-01-04 06:59:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(19,1,'311e38f8349d2deac3cfb8821a0135b0fb441def0d9b4f9c900c63d88b3a02fb','2026-02-03 10:59:52','2026-01-04 06:59:52',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(20,1,'dc57186ddcc023147184e19d8c446ef334cd8f8ec56211c0cee30385e9f4c9ce','2026-02-05 03:35:43','2026-01-05 23:35:43',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(21,1,'1d66ce3913a2c1679fdad13bef71dd1dea554b9ca755dea92adc5f71812ec347','2026-02-05 05:39:13','2026-01-06 01:39:13',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(22,1,'03517b7bc56313c2b8c59caf2a80368f2a391343173bbd293e16aab445fc9ac7','2026-02-05 05:39:19','2026-01-06 01:39:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(23,1,'ee256159aebaf39ef214a3283db5044c982e07c3d2e2bf2fd48273b4c7a11609','2026-02-05 06:02:20','2026-01-06 02:02:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(24,1,'a41916d0eff118e627c0f6489d72e7173855b92f53ba287ea897c621744711eb','2026-02-05 07:01:20','2026-01-06 03:01:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(25,1,'f3d363567013537917c9ab2a7aebb0c82c96a72545a74e21be24ced484b0a4e1','2026-02-05 07:45:34','2026-01-06 03:45:34',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(26,1,'8ebe10c569aa8a2976daee030c961d53a6a8c4ddfeb6f768ac855370dbd75f6d','2026-02-05 07:46:19','2026-01-06 03:46:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(27,1,'57217d8839b1be180d4e03495e9748b5e4bb6042cfdfb70fa7da6ca8165e62ca','2026-02-05 07:46:32','2026-01-06 03:46:32',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(28,1,'00c1f42e7a7d81001f5a3d952084799f33ca4e444bf35842d4a13e312f921739','2026-02-05 07:46:41','2026-01-06 03:46:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(29,1,'581cc1c545bdae9c748ea4c926319c397ae362a911bdcc23e6813fbbd7d11dd9','2026-02-05 07:47:31','2026-01-06 03:47:31',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(30,1,'7bf2b7083ecf6fcbcb950453197cc8aee6fc21d2024c6625c58e070f571bb92c','2026-02-05 08:19:14','2026-01-06 04:19:14',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(31,1,'8f393bd2e02ced0104c43ee67d5bf2b404c4f78b261df515c135bc6f968d3ccc','2026-02-05 09:18:14','2026-01-06 05:18:14',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(32,1,'f3d8913e6fbc5ddc48905ae9766aca03dfdf0fb890100be507b9c099b305ca29','2026-02-05 10:17:14','2026-01-06 06:17:14',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(33,9,'d7838e2c89646f13d3553d8f98e8db59d6e3adeac5eff1048d11957d249a1899','2026-02-05 10:17:28','2026-01-06 06:17:28',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(34,9,'be9cbb4df4cf4f0b8d7bd1b4acea368f3afdc20b899913c1cc69a5f33dfadec4','2026-02-05 10:17:34','2026-01-06 06:17:34',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(35,9,'12870eb9471c765edca5e0e4242a279642943420902372d5efb008a33d2bc0bf','2026-02-05 10:17:36','2026-01-06 06:17:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(36,9,'84a4b423e59734a4fab04cf176c58b55ee62397a104635bcc98ff0c1e9498af4','2026-02-05 10:17:37','2026-01-06 06:17:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(37,9,'b6d826e9f9ceb47d498e0dc0b0e362f72e74c8c9f81992631c4020a6aab385ce','2026-02-05 10:17:37','2026-01-06 06:17:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(38,9,'e6d8338ab872c353469dece8096c2f45cff4dd11d5b48c4ca7a6a37f824748aa','2026-02-05 10:17:37','2026-01-06 06:17:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(39,9,'1f379535720b142656c2efb4019ee650716b4f7d9af0678d66ccd573500f6d64','2026-02-05 10:17:37','2026-01-06 06:17:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(40,6,'51cb714ad7807cf99597b91abc9d87902b758b7c52a489a8185e7fca072284b4','2026-02-05 10:17:55','2026-01-06 06:17:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(41,1,'1953f070894b37241bfeafc790a7b54256463a395dbbe2bc8e9d5a2f3e833eb0','2026-02-05 10:18:22','2026-01-06 06:18:22',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(42,1,'40d2e61b2fc0bd21f4f927692c85532f2394c5a53e95780a870c2bf4c013fc3b','2026-02-05 11:01:45','2026-01-06 07:01:45',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:145.0) Gecko/20100101 Firefox/145.0','127.0.0.1'),(43,1,'8e28a51d2b913801b7aba51d402ddaf8b504702e90737b3417a657e6cba2dcd8','2026-02-09 01:19:28','2026-01-09 21:19:28',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(44,1,'906142e77b5770025a1b7db289c0409febf339f533b44e8b7335553f9003683c','2026-02-09 01:19:37','2026-01-09 21:19:37',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(45,1,'36995ed65a5c9fcac7d2d6f4da83bdc7ea2c48d94c93c4cbed56c9244479e743','2026-02-09 07:11:48','2026-01-10 03:11:48',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(46,1,'aedcf9e4bd3536423e13b8f538c19adb6f0fa7eadac665525793d23056347fe8','2026-02-09 08:10:48','2026-01-10 04:10:48',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(47,1,'feea122448a8853c3db4caed0043690004b3bfbd44283234bef804a23985f5a5','2026-02-09 09:09:48','2026-01-10 05:09:48',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(48,1,'070ec9d1a5ca9461c3c6c86afd776d08a04af12562d0fc5c96294e35dfffb27b','2026-02-09 10:08:48','2026-01-10 06:08:48',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(49,1,'72fd90b1591f9410c9e6faf2962598a58609fb1a364b0c6060874318d022e17a','2026-02-09 10:55:28','2026-01-10 06:55:28',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(50,1,'2084f9fbe0a8b537a657d1fef5446b598da103002343d1b67a20b3b5652930eb','2026-02-11 07:15:54','2026-01-12 03:15:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(51,9,'d507a83024bb63bd4b66cdff812dcb2a55307891c54ae28596ffb8d1b09d47e7','2026-02-11 08:18:22','2026-01-12 04:18:22',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(52,9,'49918ff5e246e93c0404cd17365beda6b6513859bd6ad74d0e91426620483d2a','2026-02-11 08:18:24','2026-01-12 04:18:24',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(53,9,'b462b9fd7c9e6da461c482e3a3e02d7a4864e29b432852ae0c59ecf37d0db111','2026-02-11 08:18:42','2026-01-12 04:18:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(54,9,'1a311de7e4d7ace23cd2179e7d33fbfeeb8d0a48880c330f8c4869b3d38b8b61','2026-02-11 08:18:49','2026-01-12 04:18:49',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(55,9,'38c801f4d0dd814b28eba61007e9f8bc54d494e3196b2b45ece906a1df3e311b','2026-02-11 08:18:55','2026-01-12 04:18:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(56,9,'1426ca475a9665b6c95ec239224ea01061f001407fde70963172b424c35eb61c','2026-02-11 08:19:12','2026-01-12 04:19:12',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(57,9,'bb8b4da62577c423ddef1258c27addb516004c535e534518e321fa1efbc87bfb','2026-02-11 08:19:12','2026-01-12 04:19:12',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(58,9,'37a8e64c61f6b06c521b8ec71c18bb7d2cde585e3ef0ec32ff796a735df87f70','2026-02-11 08:19:13','2026-01-12 04:19:13',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(59,6,'d1281e617a3732cba039d0e305526cbc7d86d6743b53eae22ae743808b8f3799','2026-02-11 08:19:34','2026-01-12 04:19:34',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(60,6,'e2df6880ff92e59474e535adeef8c0185f2fc9525350696328b1497168cce41d','2026-02-11 08:19:59','2026-01-12 04:19:59',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(61,6,'f1478e7695763643f54639810e75effac10a853dd79209ec4413d9243312cbac','2026-02-11 08:20:11','2026-01-12 04:20:11',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(62,6,'070dd52096fec865b813207ea38176c2b317703119c1d7c63c33e098dc2c79fd','2026-02-11 08:20:11','2026-01-12 04:20:11',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(63,6,'25720c5143280141554fb82ad680f2befad3ca659d2800bfe21b02347483fad6','2026-02-11 08:25:31','2026-01-12 04:25:31',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(64,6,'7ab9b78b2a186f5504a43ee646ea78a8d1afd6b5a777b312c83d5abbb33cd834','2026-02-11 08:25:40','2026-01-12 04:25:40',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(65,6,'3e3837880892c5a977b2d2d9904e3b17b0f41bbdfbc238eed37dac4468007404','2026-02-11 08:25:41','2026-01-12 04:25:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(66,6,'12fe977e086fd978930cb3f7db01b6a843c6afc9f0edc8e29b6230410724c590','2026-02-11 08:25:41','2026-01-12 04:25:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(67,6,'21ea13efe2335a3fbab2171beb5340ef407d88ece397495c34a83eafc0b01335','2026-02-11 08:25:41','2026-01-12 04:25:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(68,6,'ad6d37a12747acef40db7518bf06d7a3ed05f04e851a2a4907eecbad633b3614','2026-02-11 08:25:41','2026-01-12 04:25:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(69,6,'5d8180fea541cefdcdd7a7bfc5a6f95938119331e8fc989d3b2df6cad071c938','2026-02-11 08:25:42','2026-01-12 04:25:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(70,6,'6cda0c0c3dca930d87a49eab062dfd3de36b65d5af322eb3c9a8dce8fded48a2','2026-02-11 08:25:44','2026-01-12 04:25:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(71,6,'914260c29590383bc32414e4f0505082a9aadb4cada462eb2ae33a1314cda657','2026-02-11 08:25:53','2026-01-12 04:25:53',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(72,6,'c29fccda1724ddeaff7497f7b1806414d252697a3670ec6a35a134e5ad912382','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(73,6,'d1e3e0e7d80c76da1ba4f6094d570419f91e6add7b5a82c881e3b756d58256f4','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(74,6,'10e9039baf6c7c11635560b62f8610de16fbeb793e0e572681c4ba015755ac95','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(75,6,'94574135a85aac1825caab15b79e29caf43a45bff49fdee33f6da0b5e9e9f62b','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(76,6,'0c3bdf6ac5d9b1d8666c1e6e93f29f2b2b447c528b476b43b1737026432f55e9','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(77,6,'ca58bb6979d2db73325727fa66497d126551e90a9290d3f1047d94f0e6ce2ff9','2026-02-11 08:25:56','2026-01-12 04:25:56',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(78,6,'6f77471aa30e9ab7548d0d21590e2b8fc6ed6e810174b03f9595adc21ababf89','2026-02-11 08:26:01','2026-01-12 04:26:01',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(79,6,'762b0bb8cd9473c517af47679b1a07c2de403d19e09df8dad0710161e9a8d067','2026-02-11 08:26:02','2026-01-12 04:26:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(80,6,'bf4ce66a148916e36b5c6e6342dec2dfe43aac1ecad07ae6529d8b6bbc4ad143','2026-02-11 08:26:03','2026-01-12 04:26:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(81,6,'d34e00218427322962b7b8aee6fb56feef0763fe3c8212176eb707eee4b51f43','2026-02-11 08:26:03','2026-01-12 04:26:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(82,6,'f79b08173346ed0805a920de28131c574196f093d588deadec242f3c7098c67f','2026-02-11 08:26:03','2026-01-12 04:26:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(83,6,'b030c57c7410e16e3c9971bc12c25c952834c841462eff2d988f93b6433d72c6','2026-02-11 08:26:03','2026-01-12 04:26:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(84,6,'e6ce897ffd2057164509970b1a455c3da6f9922ab683f6ab71a80462ee33ffb4','2026-02-11 08:26:08','2026-01-12 04:26:08',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(85,6,'2bd06e019559ac33011f5a600eb17101a388c9dc9c7ca3d6ac387ff6b03fbb72','2026-02-11 08:26:14','2026-01-12 04:26:14',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(86,6,'ce5c36f6c9d998b54e5ceee3f98452be94a99ee2d73c24e2ea7672c3c03fc6a7','2026-02-11 08:26:15','2026-01-12 04:26:15',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(87,6,'7095f7786748fe10920f29771ede16c8a6680e4b2a46bbd80c9824555b928aaf','2026-02-11 08:29:03','2026-01-12 04:29:03',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(88,6,'57464255823e39f8dedcf796c3081b2fb94d2731d1f927d82480494f9208279e','2026-02-11 08:29:12','2026-01-12 04:29:12',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(89,6,'2fabb92c67247b5d43f4db2af5b3d81aace895413ba1e3eb491384e973809f8b','2026-02-11 08:29:14','2026-01-12 04:29:14',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(90,6,'4dd5e00ed82c9f2c81d3a61ae2f358cfcdf4764e8703bbd011f09b6bf0275eda','2026-02-11 08:30:08','2026-01-12 04:30:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(91,6,'fc1c20001b687df734b6768ee7e56b8534f0ad07f9860593dcebb2c92606bf1c','2026-02-11 08:30:10','2026-01-12 04:30:10',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(92,6,'f62b31214b4347c532f3675134d1152e1abcaf440ce216f42dcaa62d348e0c28','2026-02-11 08:30:38','2026-01-12 04:30:38',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(93,6,'15c3dc358ffbdcfe57b97c19f81f43dcf969a458547aa0a27311690988fed43a','2026-02-11 09:11:12','2026-01-12 05:11:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(94,6,'d12881cae2a46e8465bb4b8ec184a21cdbdd1eff517e83122eb5db5dcec798f8','2026-02-11 09:11:14','2026-01-12 05:11:14',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(95,5,'91cdec337f63b6e3be867efa8138ea4a639f5c278b643dfe3476f44669fca388','2026-02-11 09:11:28','2026-01-12 05:11:28',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(96,5,'324a00e210e6fd1382220309a5de756b59111e07ede519cc03a8bfed334aea4d','2026-02-11 09:11:29','2026-01-12 05:11:29',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(97,5,'9fdf1d8c7293933af277437a7b48b89722a73eaeffa6b46de3f1cf1832ca268c','2026-02-11 09:11:29','2026-01-12 05:11:29',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(98,5,'88efd5f097dd322e882a2a4099ea10462ad78e3cbed34f802268f6356e5f2dc3','2026-02-11 09:11:29','2026-01-12 05:11:29',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(99,5,'e52817159d23f6695aa015eb400ad4803f3508e263a7820a6c4f0309e9a19707','2026-02-11 09:11:35','2026-01-12 05:11:35',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(100,5,'8512d0481b97a13a55e7f8b4dd147a76360bb1590cd013d39ce06feea3fe5009','2026-02-11 09:11:35','2026-01-12 05:11:35',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(101,5,'51660744b4d70608b39b37f1cb415d498bc7638ed51711bf6f440bc683610d48','2026-02-11 09:11:35','2026-01-12 05:11:35',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(102,5,'73c343fc65c46782603988bbef554ce59c400342fc28fd1c1281902ffcf8d2ac','2026-02-11 09:11:39','2026-01-12 05:11:39',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(103,5,'a87b84b6d930191c1a1f402e18ce251ed0bf768f280b2334c824cd9597de7eca','2026-02-11 09:11:39','2026-01-12 05:11:39',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(104,5,'0ef31550675f02a1efa8c65661f4994b2b79c36c4b19fe77f42d747db37f28e8','2026-02-11 09:11:41','2026-01-12 05:11:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(105,5,'b9982783dd3e603787155bfb153f044023ebbaa1ea0deb1e02c00550c0ad4474','2026-02-11 09:11:41','2026-01-12 05:11:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(106,5,'8e5b3285d3b359a854404b1d5aed305f59d6ee795be2a2bf2a11aaa7d40bb153','2026-02-11 09:11:41','2026-01-12 05:11:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(107,5,'ac5827a41a266652be828c03eb6e8093c87869cfaf1296838badc1aa178416ff','2026-02-11 09:11:44','2026-01-12 05:11:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(108,5,'176ccfc22dd5034ca0f152f9a57c90d844f71122e7f14b76eef2b412dadb17e0','2026-02-11 09:11:45','2026-01-12 05:11:45',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(109,5,'afa87680b3f99d6420a782fc884145085b2fb63c2f78d14422184e4d87c058f0','2026-02-11 09:11:45','2026-01-12 05:11:45',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(110,5,'25051f2af500d1e6ffcc3fa0c55be4af8f7b2841dc3c1eacec49722105502e99','2026-02-11 09:11:45','2026-01-12 05:11:45',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(111,8,'69453c39bfcdf86bfd8e8d7de906a42eaa2cd3dbb4e2c72e4586ec22b26a4dd8','2026-02-11 09:12:02','2026-01-12 05:12:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(112,8,'0b583d4a490cb824a008c890c6f0965e559f64b2930af88352ae824200373539','2026-02-11 09:12:03','2026-01-12 05:12:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(113,8,'3f363635cf4af260a9b05428701335a2d2a69d53cb44dc97f4a1c0bcb98339f1','2026-02-11 09:12:13','2026-01-12 05:12:13',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(114,8,'3c422ef5eac5457adb9fbb86876cb7d214fccd42937e9fbc676094a3012fb1a2','2026-02-11 09:12:15','2026-01-12 05:12:15',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(115,8,'e34f3f340dad669262172749be9f943ad5ff7cf3cd8655097b93ada7cdaa402d','2026-02-11 09:12:24','2026-01-12 05:12:24',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(116,6,'d947462c7c6d2e13f53de694ceb9aef1fba103f0c0fe8f213bc010ced8719c18','2026-02-11 09:15:40','2026-01-12 05:15:40',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(117,6,'d01885bdfa50af6d665f1d49228fe83aa617216c085c8a2ae0ca6452d0fcfe30','2026-02-11 09:31:36','2026-01-12 05:31:36',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(118,6,'019f196fb8664a16f8c1ec8a7e67a8a87fb69b2da025fb7195ed953151fd8a78','2026-02-11 09:31:37','2026-01-12 05:31:37',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(119,6,'f8611b3f8d1432787af0cae33a923c9a8072a22adae68686d82bf074ccdc726b','2026-02-11 09:31:37','2026-01-12 05:31:37',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(120,6,'25ca807f66df4cd6f296fe68597b9c83a000fdccd5e566bb0e4a6b855b7d757c','2026-02-11 09:31:40','2026-01-12 05:31:40',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(121,2,'6368d62430fd7b96cc4d897cb4543c9f29bb95eb1b7714310a0aacd151fa09f8','2026-02-17 09:49:30','2026-01-18 05:49:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(122,2,'e03afcbb24745af9aa08d771f609dc99b6f960d30c5b0a4d005833660aaf1164','2026-02-17 09:49:51','2026-01-18 05:49:51',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(123,2,'9abe2b53f875daed265c8b1c5cf3038dd102555fa56f42e6e7b19271cc9c6e58','2026-02-17 09:49:54','2026-01-18 05:49:54',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(124,2,'7085f83fbdaf2eede109d8a7e516b3208fbeb1dafba89db5b1c42355586441ac','2026-02-17 09:52:05','2026-01-18 05:52:05',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(125,2,'ce083803948344c42b02d58c6e079eb7ea1105c2f1bdd08e9cf4b0fcf7176363','2026-02-17 09:52:06','2026-01-18 05:52:06',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(126,2,'359be9e79355674f676f31721fad7321ff36a25535a0dda91e169c51ac1e4e77','2026-02-17 09:52:07','2026-01-18 05:52:07',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(127,2,'cd1b3598d836023249164b4a67b4381049ada6a5862e10d62aca68be3558b889','2026-02-17 09:56:16','2026-01-18 05:56:16',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(128,2,'9b346fb80b5715879509e323fbf50fee3954de615086a7e6c4d30e6bcfe65c40','2026-02-17 09:56:17','2026-01-18 05:56:17',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(129,2,'aa9575472660784c10976134112faaef50971ed42109f7ee3deae9ecf8562c55','2026-02-17 09:56:18','2026-01-18 05:56:18',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(130,2,'42c1b4b6021a427d7d1f12130f83587cb304d62b6c2a55fc7d7fcbafe09a2df1','2026-02-17 09:56:21','2026-01-18 05:56:21',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(131,2,'3ecfe4fa17d3bf57ecd14d148d56e2631db68c7246335e413a01abb91205a338','2026-02-17 09:56:22','2026-01-18 05:56:22',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(132,2,'78042a1c483a227c751f1438f06aaa421fa03e2887c52c8222cc12844d231aa6','2026-02-17 09:56:38','2026-01-18 05:56:38',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(133,2,'8d9d893c127fef03da1556f5483b1a4037edc268e76de6f17126c58f2534fc90','2026-02-17 09:58:48','2026-01-18 05:58:48',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(134,2,'7633e743bd2cc4c92d85e024dc67e2cf41a59eef821c336efb2b1b3d23036137','2026-02-17 09:58:49','2026-01-18 05:58:49',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(135,2,'fe5710ced0240337130292f1d2902a7f1815aed23ab80d2b365244f8d55f1a96','2026-02-17 09:58:49','2026-01-18 05:58:49',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(136,2,'f54ea515d9bc10272d1d96b4e7e6cb37009a0c37da7855b2cd5c021341fbd6fa','2026-02-17 09:58:51','2026-01-18 05:58:51',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(137,2,'f85176f6c4bac73c7d131e31fef07aa25a3d1ecf224ba62ed131ee1a46667b6c','2026-02-17 09:59:01','2026-01-18 05:59:01',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(138,2,'5b454d2acd48856d734d3a00007694015c33faf4c8fb51e6bfe3a7580561ad5c','2026-02-17 10:01:15','2026-01-18 06:01:15',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(139,2,'697d0f7d56b9060c4836dcf5e91cdbf83825b2785ef25ee6fd090bf08b0f88a3','2026-02-17 10:01:16','2026-01-18 06:01:16',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(140,2,'d28dd772110d95f5c1122fbe492a4849bfdc96a9b5402a979b8105276b40df9c','2026-02-17 10:01:16','2026-01-18 06:01:16',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(141,2,'2ba1669fad7086cbb8450f84b9e17887781ce0d31c61822656eb4cf8cf19adfb','2026-02-17 10:01:17','2026-01-18 06:01:17',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(142,2,'b5fea72d3e8160f2f7f5cc72b38b8ed175219a9b6a41acb14851a9e65a61d810','2026-02-17 10:01:18','2026-01-18 06:01:18',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(143,2,'f31ea5ab67b6ccf1b5491b9341737d1d6af538ddcc53c1cbe602b3850be1ea3e','2026-02-17 10:01:26','2026-01-18 06:01:26',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(144,2,'eac87987348814886a7aac97918d78c2b34a7a4f818e64a10edbbb6023a5062e','2026-02-17 10:01:35','2026-01-18 06:01:35',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(145,2,'f8964696351c457e761e0bfd6522826e3f15f312474f6e0ea62b8612584d5ce8','2026-02-17 10:02:49','2026-01-18 06:02:49',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(146,2,'62f3cce0688999009b9d03251b65d0b34b3deed1e84b29072ceb1d7136028886','2026-02-17 10:03:02','2026-01-18 06:03:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(147,2,'b54b9ac3d72558f2252238e4b11edbdf8a7766668a4bdc8057a1e36c507cffe3','2026-02-17 10:03:03','2026-01-18 06:03:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(148,2,'499ee0f9a7a0a249d857fa96efc19057911ede6071712650151d3e30bf939a7f','2026-02-17 10:16:54','2026-01-18 06:16:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(149,2,'cb814b888a86717a346fe34cbb79b3dc38ef8f0083e3f1941ed573d1593efcb5','2026-02-17 10:16:54','2026-01-18 06:16:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(150,2,'906b9561986891560b8d4eaf3305673f5f1cbda6794b0ee38be705834ffe6d81','2026-02-17 10:16:55','2026-01-18 06:16:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(151,2,'d2ed1392dc84fda9b62c5316751c9c2a88dedd6327d83c74dbbc162e912cd4b2','2026-02-17 10:21:46','2026-01-18 06:21:46',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(152,2,'a4b48910390d5bea3f2cb3bc71c770dd56a9e58fc69985e265c338fb450a9d02','2026-02-19 09:45:16','2026-01-20 05:45:16',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(153,2,'37a32d9b86d6afb0a5692890310885a3e32a5c2065babe914dbdd801e58ded3a','2026-02-19 09:45:18','2026-01-20 05:45:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(154,2,'a113965758de45e57ebe1355a59db0ab9150ffc898217d8540e1db38620fadb3','2026-02-19 09:45:19','2026-01-20 05:45:19',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(155,2,'45c9ce3160c3ff0c7c7b25aa4aabc1de7161f84253ba77efeb562f89c1a13d1e','2026-02-19 09:45:19','2026-01-20 05:45:19',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(156,2,'7fc9e059e6b43cd40a6a0959e441ec2b83f81e4dcd27a757cfd3a48c5a11aa8a','2026-02-19 09:45:20','2026-01-20 05:45:20',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(157,2,'e54b4c49a7159462a75974639cebaaf35cd23804f96bb2d57477bcdd6ceb9a0e','2026-02-19 09:46:14','2026-01-20 05:46:14',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(158,2,'d5124f4e60954c2e5a4f1d82a764328ed93bb62ecf5ab7beb480b8f422d96b3c','2026-02-19 09:46:18','2026-01-20 05:46:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(159,2,'9b59e1cb03c23a9093ef317b1d2248e0ddca8246549e2e73feac5ac49297c3df','2026-02-19 09:55:04','2026-01-20 05:55:04',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(160,2,'2a7f802829e3fdcb6437ba2228a1614562f4a32ca8de5deef440377c80f201f0','2026-02-19 09:57:07','2026-01-20 05:57:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(161,2,'cb264c27157c0820b241e25c1a1560fdd0d72842074589000ae4756340a4cdf2','2026-02-19 09:57:08','2026-01-20 05:57:08',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(162,2,'6260c13ec2ef95e01c8e285f89c5f602edcaac9e807e6ae6530debd4a7951009','2026-02-19 09:57:08','2026-01-20 05:57:08',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(163,2,'3540b7120674443e63bb623ba571c7e00bd8d578154629c5f0d9a054342b6ee7','2026-02-19 09:57:09','2026-01-20 05:57:09',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(164,2,'aad2b9552f1b85f33cb0d5f7677f418b997606ae1962474909e0cd8a660de381','2026-02-19 09:57:27','2026-01-20 05:57:27',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(165,2,'67ced5f69f6785e44ddc4ababa9b6a8f29df785ebbe809486a3a1c57d4a721ca','2026-02-19 09:57:38','2026-01-20 05:57:38',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(166,2,'3956f7f6d9bcbefac8cad3cb437559f6c4fb41e59ec5e54e4d7d9ea3ef5cf73c','2026-02-19 09:58:36','2026-01-20 05:58:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(167,2,'2bece4e92041e671592d22ae0c6a82527d00dd0d6ee794d54dccfca9a469ddc5','2026-02-19 09:58:36','2026-01-20 05:58:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(168,2,'1f8a79d1c65faa493860c7ba95e51a8ba7492158a627c1640ae0f527ff603764','2026-02-19 09:58:36','2026-01-20 05:58:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(169,2,'59aab0e60a9f536661c2750e37b258da87b0abf4478a935899c40a7036f1df6c','2026-02-19 09:58:39','2026-01-20 05:58:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(170,2,'7cf3d0e34fed0f50e9bcfa1856a0aa94969c3a272869660875d9cdf868b33d4c','2026-02-19 09:58:39','2026-01-20 05:58:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(171,2,'3b8c05257cbaa07a28c8bdde47b6a144e743c1cdfd59cadc7377409a04980f3b','2026-02-19 09:58:44','2026-01-20 05:58:44',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(172,2,'17ef8eba37d96a560550ba6418a107bcf2916cc08f50ff181230b45b9df3c7de','2026-02-19 09:58:45','2026-01-20 05:58:45',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(173,2,'6a55c7ba48ad7dfd08824195da011948112c4ce93f855c3275112251961cc6a5','2026-02-19 09:58:45','2026-01-20 05:58:45',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(174,2,'657b968be9c49fa2c40a9b1aba7da5578df9079cab0d775dbd60467d08f84dad','2026-02-19 10:10:52','2026-01-20 06:10:52',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(175,2,'0de66d99991420a5e4b5ede1ff85944d03af30e2fccde5d9819758e323ad27b1','2026-02-19 10:11:08','2026-01-20 06:11:08',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(176,2,'0dc6d9b1fe4a38a103743abe87fa7475fbe88f7fa49c6ab38971c2c416c11d31','2026-02-19 10:14:29','2026-01-20 06:14:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(177,2,'eb87e1e59026a5b946d99d336470e1437fd82d3085d068b24dc9f60d2e56a016','2026-02-19 10:14:31','2026-01-20 06:14:31',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(178,2,'1cbe3ff5f6f8d40eeb7e3359108154b285d2781532e774f31ec79bec7dd6acf7','2026-02-19 10:14:58','2026-01-20 06:14:58',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(179,2,'51810c71741f8b8e373db566aacd788f70c22f090ddc6f1fbedab39928f70086','2026-02-19 10:15:00','2026-01-20 06:15:00',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(180,2,'ae5ab725df29265ab6022fcb3401d4aa1f367b4305eec6ba29d38cadda91691f','2026-02-19 10:16:25','2026-01-20 06:16:25',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(181,2,'fc3187ecc9e4f9ff653bb54837a961f60b1037e8ec79da2b3fdfb31e48827355','2026-02-19 10:16:26','2026-01-20 06:16:26',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(182,2,'5667f955acd512c0e5c79f6610282d43329a4a8e7d49ac455b7f72f60927b2bc','2026-02-19 10:16:26','2026-01-20 06:16:26',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(183,2,'0029f8082fc51d9d35dec1da810b8e4a35babce618d3adfc82c5812bcf037e59','2026-02-19 10:16:27','2026-01-20 06:16:27',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(184,2,'058ad6fd27cd017f3bba793e11e045cf40cd0c560e6c43efafb71b8776298083','2026-02-19 10:20:25','2026-01-20 06:20:25',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(185,2,'d19e240666ff78e4d4b87035ce5bdef26b2d0a5b33b2a71a615d7c55d7572407','2026-02-19 10:20:25','2026-01-20 06:20:25',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(186,2,'aee66802956240db2d95f7f6c098ecb2d1e6e9cb550e2aa72a0283fecfd48fbc','2026-02-19 10:20:49','2026-01-20 06:20:49',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(187,2,'eb326964921447925c22907c58887ef89226ca6a7f400e0348bc1795440ac30a','2026-02-19 10:21:04','2026-01-20 06:21:04',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(188,2,'87f9cc7410ebd959929f8ef5201488bd9b60fc72bd965cec9a0056734baa9a52','2026-02-19 10:21:27','2026-01-20 06:21:27',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(189,2,'12e7bd0d5afa3df43a2f4ebbe413633bde03984d10b2af68bf9af7e40b7ad98b','2026-02-19 10:21:37','2026-01-20 06:21:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(190,2,'0780bbcc32fe153832d47eb885c24d9fbe47738f73b8a219356b1ebcaf137edd','2026-02-19 10:22:02','2026-01-20 06:22:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(191,2,'9e70ca05b76c8f1582e15e4907fc91c44075eb68c72074ba2a0e1c56a8f46406','2026-02-19 10:23:37','2026-01-20 06:23:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(192,2,'bcccf2b311afc78fb5d573b2b36d8f677a5132e80a367e78a5dd3548e731e4fb','2026-02-19 10:23:57','2026-01-20 06:23:57',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(193,2,'28025db5072b714e59bc3a2b56e0be609a1fec43caceb2890c9f2a3c819c10f2','2026-02-19 10:29:12','2026-01-20 06:29:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(194,2,'46a2eb7b3135599eb468abbd57694dd0f758483d4b7fd1820e3ddeca865f7275','2026-02-19 10:29:13','2026-01-20 06:29:13',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(195,2,'0d2caf878cfed5bf8b65c21b8e27623341af9b5bf48491091216b03ec6f7de07','2026-02-19 10:31:18','2026-01-20 06:31:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(196,2,'4cec22ae6269fc3e61ce4a0b93efd5bdfd618fc8310b064f39638daeb1c6a2fe','2026-02-19 10:31:20','2026-01-20 06:31:20',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(197,2,'cd290b3bfad4deb73cf0c2666178d33b5b780145957417e24260f293be3923f0','2026-02-19 10:31:21','2026-01-20 06:31:21',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(198,2,'136423ec8dd4cb198a702a215c0e1b4bd155a06371bda59bbc4d4608affd28cc','2026-02-19 10:31:29','2026-01-20 06:31:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(199,2,'65f29ff22d8e95113a8e11018ac02fe4d5ec4e4ca0beb855c6491e4f00454f1f','2026-02-19 10:31:30','2026-01-20 06:31:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(200,2,'b59a37bf04f3c691e26ba5ff1d0678046884f24a482db0bd3fb8b7c97b4c3922','2026-02-19 10:31:30','2026-01-20 06:31:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(201,2,'d4df4852206200f8327b4167878fc88ace3db9894a1ebd9372d2121b47b21e20','2026-02-19 10:31:41','2026-01-20 06:31:41',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(202,2,'4da690da83a173133e9161bbc72f771715143ef8688eccd9f34975de94ff06fc','2026-02-19 10:31:43','2026-01-20 06:31:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(203,2,'fba2fd13f57e35ae51b1f77df61e9bb9778cd265a19ebe2865f63de84a12e975','2026-02-19 10:31:44','2026-01-20 06:31:44',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(204,2,'58e7cede61bf62128476e2c84e75730b7b0a877f74168812dd184e6895b35d1b','2026-02-19 10:35:17','2026-01-20 06:35:17',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(205,2,'dac52dd22b042155bc3b05cab1f8e6be9517e24009b9c944fb85b0e8153d9908','2026-02-19 10:35:20','2026-01-20 06:35:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(206,2,'0a7a5a70781b33be827df61a4f8a032038d671c3f0f14adb0e571991d0b45dcc','2026-02-19 10:35:21','2026-01-20 06:35:21',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(207,2,'246d8c56aafa537fe6f931c977e33070baa75a37e72d55a76767c40d2a9c82ea','2026-02-19 10:35:21','2026-01-20 06:35:21',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(208,2,'32db5f567491a6fdc93afe67e8427941facee75fbc20aafd283bc3a9fd16f0d7','2026-02-19 10:35:21','2026-01-20 06:35:21',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(209,2,'36f9d1e45bb3f4d930d61222ea1f04d5ee6af7b3ed8e8fbfc6fc02ea4ac46133','2026-02-19 10:35:30','2026-01-20 06:35:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(210,2,'bcfaa4bba056958f95bf88b1477869d3c97aa2af82177cc49a6e597199463224','2026-02-19 10:35:32','2026-01-20 06:35:32',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(211,2,'282454dcc807e29fb041a79c3813ef29cd467c02106fc1c66887d38fc744d9dc','2026-02-19 10:35:36','2026-01-20 06:35:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(212,2,'1dc03c233fd16b0a70afe113826f9b95910017dbe3269b3cf8ade14388f9726b','2026-02-19 10:40:08','2026-01-20 06:40:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(213,2,'92fa568c6e5ccfe7fd4dd2807f218310232569d4eb5bb1aee0a5b7ff5ee85f7f','2026-02-19 10:40:08','2026-01-20 06:40:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(214,2,'13d0bd31eea4e2c9e1f0437abc3f27aa5aa74d34a674f894898170aeab32d8e0','2026-02-19 10:40:08','2026-01-20 06:40:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(215,2,'677551e3008ed0c24b7df270b4af594b0d7f64b40aac61e18ddb8c34746e464a','2026-02-19 10:40:17','2026-01-20 06:40:17',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(216,2,'35ca5c4a22b84ceaecb8ae13ba9339df83573fea4bba104a5e6c187df882e696','2026-02-19 10:40:19','2026-01-20 06:40:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(217,2,'3addd2b4d36996317d0dc5140a6d1e13e55cf00a043928b886cfe4cc98623d7c','2026-02-19 10:40:46','2026-01-20 06:40:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(218,2,'adaa7b0c66dba030faf34d33518bf779ee03c39674527ba1be56b5ce34504aa1','2026-02-19 10:40:47','2026-01-20 06:40:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(219,2,'a80f7f1f96ddb94e4af23dbc682689fa8054abf632a81a211b632d3a14cb6145','2026-02-19 10:40:55','2026-01-20 06:40:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(220,2,'b4903d24f9f5e2ad5f6aee366c201929f3308428248208f007ffac3aed250c78','2026-02-19 10:40:56','2026-01-20 06:40:56',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(221,2,'4152c8c19be5200db0c117b680dd177121fe0e618a4e36a7a3de1f37bbe9e036','2026-02-19 10:40:56','2026-01-20 06:40:56',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(222,2,'fce0d15ea859acacc78a2c0885a6488996bfa5f7a244b595001776161e4fd2b0','2026-02-19 10:40:56','2026-01-20 06:40:56',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(223,2,'ba0906289859d1fe3c13a4ef6cfba6bfc3cc5b3e9c3a1b51fe7a5e68eb50cdcd','2026-02-19 10:41:07','2026-01-20 06:41:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(224,2,'43f4dbf46f5b9aa3b87807b911d2a00a8e7f34ce3d534a2724365bc5e7ec2479','2026-02-19 10:41:10','2026-01-20 06:41:10',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(225,2,'58360af9c4d1755012d8f8c93cf7390610932bb0d808047a756622e384f1c314','2026-02-19 10:41:14','2026-01-20 06:41:14',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(226,2,'662b4205a79f5e0e182912d07318336dacbd48570c05c458095b2c409cb77d6b','2026-02-19 10:41:29','2026-01-20 06:41:29',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(227,2,'5593c897b5c6a57ee91fc8356d5decabd7fcaeda6072b61c279c8e55fc4a320a','2026-02-19 10:41:30','2026-01-20 06:41:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(228,2,'70c71a2a80af22c47ce032d781b54ab7abbe72d2c15cbb81bf4c01aad0fe041d','2026-02-19 10:41:30','2026-01-20 06:41:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(229,2,'858fe27f2f6b2e42619a6f6d2c929c2aa3d4159b8c180ac2203dcae93996da9e','2026-02-19 10:41:37','2026-01-20 06:41:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(230,2,'402d3d280b1d8bdc4910053dcfc79a75f9730fb4d51067289b651d92e40b686a','2026-02-19 10:41:43','2026-01-20 06:41:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(231,2,'0dc638b82e3f0335781874fe867b43de8a1fef71f7092891e798812a7e4895b5','2026-02-19 10:41:45','2026-01-20 06:41:45',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(232,2,'e26376847d0ab4c0161ead9f02ad3b8baeaf1616f2b8f54efc01191604c180a7','2026-02-19 10:41:46','2026-01-20 06:41:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(233,2,'6a0d1959b06d35074052f6930b3e331722c633a6f5e5c3444b25410f6b1f4c27','2026-02-19 10:41:47','2026-01-20 06:41:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(234,2,'9d497c31bc4eec2a037e409f0dcd2b5c3f70e59c5e5c097b659e3934f81a78a0','2026-02-19 10:41:47','2026-01-20 06:41:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(235,2,'ecd107d9ff405cfbb883bed16b4315ca375aadec470e913a5f472abb93bda8fa','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(236,2,'451454265690ccaae02a8cad2a893d8dc1077fd9ce111eaeb87ca01cb167029e','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(237,2,'05a6aa46c31ab616b694172ad4d7b7137fa21d4c476deaf9eb42fd820e537666','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(238,2,'f7a80fed0149c5998ca36bfd09ff29054dcc744f266a216759c0f4961635ff6b','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(239,2,'4816f3699389816f7021b2e27dc290f55a01c461d74377a56556cf0cbb7e0dad','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(240,2,'f511b65a536e7ecc256b5429aaf67eb743f434b0be1576979339c762818d09dd','2026-02-19 10:41:51','2026-01-20 06:41:51',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(241,2,'aa1c6d8cf47a8c2cf6ca0bbe1324248b69221274b71aae6da6988fe1bcb13d2f','2026-02-19 10:42:02','2026-01-20 06:42:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(242,2,'15d1b8b2cbb2e9cea9215266a6d94dffa9e4f5773544e4ee967212a720525ce2','2026-02-19 10:42:05','2026-01-20 06:42:05',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(243,2,'78a7f3f5801afe8a177920241cae68b972fb66bb2a348d508e01d42cd70d646a','2026-02-19 10:42:44','2026-01-20 06:42:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(244,2,'a416cf5ae7fb338f24b330ac59eadae92d59780bd959df0937102ba0613c81f0','2026-02-19 10:46:18','2026-01-20 06:46:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(245,2,'7574d71bfa61bcb92fbff4459554a8708f20b646740b7a8c108e093df85b938e','2026-02-19 10:46:18','2026-01-20 06:46:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(246,2,'6f31c069a5f6ea858e14fdb34332225a4437a503e1b9c8f7bc4a5f3ef4318a9b','2026-02-19 10:46:18','2026-01-20 06:46:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(247,2,'970951462d4d9267a963698a260e58056f37169719d0367f089d30ede15dafb2','2026-02-19 10:46:28','2026-01-20 06:46:28',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(248,2,'ddc927dfaee9546e5f33a2676cd7418a039c11e044ef3ca71bb443fe60111e39','2026-02-19 10:46:32','2026-01-20 06:46:32',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(249,2,'9c4de3ab09de81a2857e5107084e391316329d98085b48cb9f7dca9ae95f3939','2026-02-19 10:46:32','2026-01-20 06:46:32',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(250,2,'2655008e1dc52f6933f7a2f4adca69a72b00da10baa33b1b72527e96919501ab','2026-02-19 10:46:32','2026-01-20 06:46:32',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(251,2,'8a2feac352f89ee8905e13f26d2e10e061e512f2c85682ff0d0d80f60ddb5b27','2026-02-19 10:48:35','2026-01-20 06:48:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(252,2,'958f509fd564506c39d4b126f08b2d66eaa9f0a1e54348a14aa4e1c357271527','2026-02-19 10:48:37','2026-01-20 06:48:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(253,2,'51cb9c1db4e84be15ac39dd7254adccc2bbbfcefca7ac1674f16b36eb6b1bc11','2026-02-19 10:48:43','2026-01-20 06:48:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(254,2,'678614a595bee34019be4b1fac596c95bfeec906700795bf03f870ee75a65b99','2026-02-19 10:48:46','2026-01-20 06:48:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(255,2,'fa409e27c795721df2b5837e807a689df742a8b7ad9064acde65ea376af2e2a8','2026-02-19 10:48:47','2026-01-20 06:48:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(256,2,'b5b3abfb650f246cbf34c47fa76a270b08474c84655424aac8a5b381427c2bb3','2026-02-19 10:48:51','2026-01-20 06:48:51',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(257,2,'90b15c644f90f474ca982f90d4453b958bc2180eb69d94690c78e5aed878f7dc','2026-02-19 10:48:52','2026-01-20 06:48:52',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(258,2,'515181143f0bbac33a401604ba3fbee14e44c19b87515b50b67d19e512f9af9c','2026-02-19 10:48:53','2026-01-20 06:48:53',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(259,2,'801901a59ec4178b9035d52f10a7e360b637908fe67183d2b0beeac0b320eb84','2026-02-19 10:48:53','2026-01-20 06:48:53',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(260,2,'78ffae89a1324ee8796ed7ccf9e45ab8f071ad4fab026423f3c6e9baff37d2b2','2026-02-19 10:48:54','2026-01-20 06:48:54',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(261,2,'3762d92ac07d8f891a8652be81bac06517c546c2cba451e2727f993940bf3acd','2026-02-19 10:48:54','2026-01-20 06:48:54',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(262,2,'0ac6d64976fb6da64263b025a8241c356872949e34ac5709f55fefa485813af1','2026-02-19 10:48:54','2026-01-20 06:48:54',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(263,2,'5c1e50bfd507deb891489ef4c06f78c5921e5069e31e1e9a410d6f5ae7a0b779','2026-02-19 10:48:54','2026-01-20 06:48:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(264,2,'18b9368c26fcd00322b938cb06a1dc7bb01ff196c77f3f554e1fffffe3efe263','2026-02-19 10:48:55','2026-01-20 06:48:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(265,2,'fb5fff63d5eabe313044eba7a9c0ea0dd92ec418ef683261c424fca32af7717d','2026-02-19 10:48:55','2026-01-20 06:48:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(266,2,'30a29807f3d77d5ad69650ec0d011aa98a498d185be5f0ddc6163c4e816f3c21','2026-02-19 10:48:55','2026-01-20 06:48:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(267,2,'ddd04295f4f5b1de86d439c72ae5e67aa28c9e393ad630a3dd30894c02dc9865','2026-02-19 10:49:10','2026-01-20 06:49:10',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(268,2,'1d7cad92ce841374999b0c9f2a1b023bbf53a0c608772b69821a7a08100d296f','2026-02-19 10:49:12','2026-01-20 06:49:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(269,2,'fd337eb7cdd67b27d5a4732b32e88a381500a3b4c62f600ae70e01665c3b898d','2026-02-19 11:00:18','2026-01-20 07:00:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(270,2,'f447e2127f897187b36206fcc057a4cee1dbc915442d29a0774e7e7428b75d6d','2026-02-19 11:00:20','2026-01-20 07:00:20',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(271,2,'4da196ee30a1378065e866b05901f41c691bbc0a6f6e7cc185b945112cad11a6','2026-02-19 11:01:52','2026-01-20 07:01:52',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(272,2,'6f577ae499ccd223980d8e91356404ebe577261552aee10bd1c3857c255a3766','2026-02-19 11:01:53','2026-01-20 07:01:53',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(273,2,'81defdb5b7d7d533e36f259c6f8fd3258d81b1b7d942454f8d4f3681dfeb56b2','2026-02-19 11:01:55','2026-01-20 07:01:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(274,2,'b8d865c28ea82810f15d3bca45765885c4d46a4ff4014186d51cf36b5bef304c','2026-02-19 11:01:55','2026-01-20 07:01:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(275,2,'2290ca59071510ef78bffafc44a5edd5bd0467e7f519df5a68c5745cc5def17e','2026-02-19 11:01:55','2026-01-20 07:01:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(276,2,'4262d01fc6e3dd0807e747ab65c2034d1866701ccad4edaab4db0bb0ec611a91','2026-02-19 11:02:09','2026-01-20 07:02:09',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(277,2,'74539220cd02d493e42ef2e98b58c83239337efe12e68ff67b7a50e5a1599062','2026-02-19 11:02:12','2026-01-20 07:02:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(278,2,'35f68ac2bffdae38c51aafbb028d90c0568025fd40df767d30279fdb26649857','2026-02-19 11:02:16','2026-01-20 07:02:16',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(279,2,'f8246ecf3cab5528526c75d67d998a7410130670190b6d012dc59c14c3462f97','2026-02-19 11:02:20','2026-01-20 07:02:20',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(280,2,'a5c79a87355018d27099404acb8537c8d0adee57bc5debb5d19a4fae095a888e','2026-02-19 11:06:44','2026-01-20 07:06:44',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(281,2,'0490d37c760c1f93f63a6d12242a587f7130693642e5fde972afec21f6bffa20','2026-02-19 11:09:07','2026-01-20 07:09:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(282,2,'25501a113f65cf3a150efb1fab4fb48fcb493a19f6ca343843474eb1826c1bbc','2026-02-19 11:09:08','2026-01-20 07:09:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(283,2,'aab966f2eef41f34481bdad0d22779e39c1e28d1cc1072fdb682302e8c3c5002','2026-02-23 05:16:03','2026-01-24 01:16:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(284,2,'6287808509c19b89eeeeb630604686c529beecf0e9a08456543b5200736d6c18','2026-02-23 05:16:03','2026-01-24 01:16:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(285,2,'a24b9a6be393bf65301a014e7ccf8db3d3f660f3fa64ee26755a3f718cc2201a','2026-02-23 05:16:03','2026-01-24 01:16:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(286,2,'90b5cf4bd69a2cafcaeacff1b0e19141a80d7f3050036d43c97d3e91dd580c35','2026-02-23 05:16:15','2026-01-24 01:16:15',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(287,2,'0a4e22bce52aa2e95d1a66607f8907306abcf36e83c771b94b1b45d4ad855062','2026-02-23 05:16:16','2026-01-24 01:16:16',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(288,2,'6bb01960c9f274a7f409dd992840990ec1c516739b8c2461d5e0b3af4213dfd2','2026-02-23 08:03:42','2026-01-24 04:03:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(289,2,'784d0e003c78162d26c7dc4e215d94a7b93ebb55b91c5c4a8671440f1237e8fa','2026-02-23 08:03:42','2026-01-24 04:03:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(290,2,'f3c86357ecfe91f2e1f00430882e204328dc1f92a702a36aa7fde08a9897a412','2026-02-23 08:03:42','2026-01-24 04:03:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(291,2,'217aa0f2adc426341655415ae37c7b23312a4ee7f04e4e326fcaef9b02fb3714','2026-02-23 08:03:53','2026-01-24 04:03:53',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(292,2,'7f92b98cb7d91b72bee1b053492d275a07942f19f97de4d95d038594ef151397','2026-02-23 08:14:19','2026-01-24 04:14:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(293,2,'e032489a41dde53b0acfb380e327ab6fd60c0f637064da1dad52003a607dedba','2026-02-23 08:14:19','2026-01-24 04:14:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(294,2,'a654f8084f18b008de2a16340fd224489fa75df49ba5d39a24b1a9845faf8ab5','2026-02-23 08:14:19','2026-01-24 04:14:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(295,2,'cbf089a6592a721c4589a212f495d71a43954d87c257360cdbe3009c3f104d28','2026-02-23 08:14:48','2026-01-24 04:14:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(296,2,'24ca911aec3f8f82a04124d778df8fbe57e13e8a9614bf90f4ef190f9e547213','2026-02-23 08:14:50','2026-01-24 04:14:50',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(297,2,'f6dd1dbc12aee6d3a04b946dbc48d1e6d3d1728e641366d923068332a1a72588','2026-02-23 08:28:36','2026-01-24 04:28:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(298,2,'206aad7be354be91706724e11f9afd960567d6bf17effbfa755765bb16c15608','2026-02-23 08:28:36','2026-01-24 04:28:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(299,2,'3177bd2f6eed3e08c9e2669a5895dc3d4e2b3d9772faa1c509a5d89ceaa0f66e','2026-02-23 08:28:36','2026-01-24 04:28:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(300,2,'9d84c74de72c1c18c75b27ff7bdb882770d7e188cc27605ee0879e0a47b3897e','2026-02-23 08:28:55','2026-01-24 04:28:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(301,2,'bb6f1657beec1a70b01ff87b7e429b3e5b7be83fcf1b85a1080ff0c9ef3774a4','2026-02-23 10:17:18','2026-01-24 06:17:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(302,2,'6d56f86fc874978890041875d724f4fc449184ac7d61b034116b701ba05badc1','2026-02-23 10:17:18','2026-01-24 06:17:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(303,2,'193d6e8f3bdbb7b9f8fc2f8e50d48b867a960740af52f6a0b6d6d90f1c0f789b','2026-02-23 10:17:18','2026-01-24 06:17:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(304,2,'8b149f5433535d8e6be3bf4d6cf7a59c24da637fe44857b2c163392d827b2506','2026-02-23 10:17:27','2026-01-24 06:17:27',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(305,2,'8e03b74fdd5d5e19715b8630c3575454956023837ebe8bdaad23418ad52dc818','2026-02-23 10:17:28','2026-01-24 06:17:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(306,2,'3c6993e44ee49fcdb90af282fb9594ccdf13006e85fb034ac1ad53d00777cf7f','2026-02-23 10:17:58','2026-01-24 06:17:58',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(307,2,'f7d4f33f56a3da337b9f8ecc7f95a91a1c36d4e577a7964ca5daabdc94f8925c','2026-02-23 10:17:58','2026-01-24 06:17:58',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(308,2,'b380b0216a90c6ef06466bd8c7f616c8c6fa4b2ec0180ad99896ae28cacc8518','2026-02-23 10:17:58','2026-01-24 06:17:58',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(309,2,'d324fd9826b9000e8c291e620067f86cd137488077e70f17735e3e0206733596','2026-02-23 10:18:06','2026-01-24 06:18:06',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(310,2,'7242ce4546ec0e8314e1b8b0aeb8e728a1dfa1957d4c2b5d777446ed0a8ea212','2026-02-23 10:18:08','2026-01-24 06:18:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(311,2,'55909c4f5c55089022400e89c8a66cdd3464e77b99600b2b6d58b1cff52139bb','2026-02-23 10:23:48','2026-01-24 06:23:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(312,2,'94b5af9c1cb20fbd882545f5d8c21ef58ac98eb163ae48b888cf65275a158ac1','2026-02-23 10:24:02','2026-01-24 06:24:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(313,2,'3f6a15616731f168638f7ba4c6cb8a9b0ffd828de17074175e4d9836abfa3a4d','2026-02-23 10:26:07','2026-01-24 06:26:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(314,2,'c8b73a7f7c277240b442b9e476b69405fe079b622748f8c920fee3a023a43f57','2026-02-23 10:26:09','2026-01-24 06:26:09',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(315,2,'53066d2c592e95c16388e28a8351638573c184bae3f129878fa96a8987149827','2026-02-23 10:26:29','2026-01-24 06:26:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(316,2,'02ec24b1cb7268c939b1c1c9eb6f134d1c97f14d14845fc119be07caa1dd8691','2026-02-23 10:27:10','2026-01-24 06:27:10',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(317,2,'4437225b207b8da218e9dfa105b76e1117a4d3c6a15fa14e78456403f8e40d4e','2026-02-23 10:34:20','2026-01-24 06:34:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(318,2,'9804dd126e7a624b87d299685138dfd92ebf14104815efddbc82181380ddb054','2026-02-23 10:34:20','2026-01-24 06:34:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(319,2,'e48a05d35d2e694635bb972860218faf84d4714e57c319143c38e339f204df2f','2026-02-23 10:34:20','2026-01-24 06:34:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(320,2,'eb26c8a8fbfe9a5e886dc53ef93fe5baa0eef221ba668dcde6c0c7679f80d3fa','2026-02-23 10:34:34','2026-01-24 06:34:34',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(321,2,'fec41786fde5ee7f09dbaa7f4128b0392a9eb6401d5ddf000ed9431c88715d34','2026-02-23 10:34:36','2026-01-24 06:34:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(322,2,'307ae4394a2f72fd81c47b9a507d3ceb825034cd8e502f74ea7ea39be23b77e0','2026-02-23 10:34:37','2026-01-24 06:34:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(323,2,'787c00ef155e5a4d068cfe4a2e5bb3b340dc609fc74a06ae370f8358123d76c0','2026-02-23 10:34:46','2026-01-24 06:34:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(324,2,'4a5260a8b49a64a22378c3ae1fbced5076e2928009a296da06092a9bac6b8cf4','2026-02-23 10:35:17','2026-01-24 06:35:17',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(325,2,'5b447c0f27cd497fedad664e7ad14c5e5017043a16ea86a6fc25bf2f41eb2519','2026-02-23 10:35:18','2026-01-24 06:35:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(326,2,'2d959210c89c419b965458af5592f187d9630b5468234c18fc22085c145571dd','2026-02-23 10:35:18','2026-01-24 06:35:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(327,2,'57a8016dd2e8dc28417a3d07969dda010e1b38a50d2a307b3f480630579a501a','2026-02-23 10:37:44','2026-01-24 06:37:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(328,2,'005bccfe783e762ef43825c054c14089daf52ce2e49ac8208b519b2f4b489b9f','2026-02-23 10:37:44','2026-01-24 06:37:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(329,2,'36fbaa72a9947fb272a1be597094bb7e21ec4063c574c2a1720bd69f216f0464','2026-02-23 10:37:44','2026-01-24 06:37:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(330,2,'fdd1c03dd95c4f979a39c9aa3b94362ea4ee189566ab2689d21a1017bc996cb1','2026-02-23 10:37:55','2026-01-24 06:37:55',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(331,2,'e7c85686ff710de5b7f210d30b6ba282805f6407928e05ffcda6a7dcad14ec72','2026-02-23 10:37:57','2026-01-24 06:37:57',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(332,2,'9849e66adbd13b76215f07c3a1c531e4d1a98362c5cedcc181124b5c814c67c6','2026-02-23 10:39:07','2026-01-24 06:39:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(333,2,'36c01e995c6fed0fbd449b5ec72da86e8c4f5a0da6058dee1dfc88149f41006e','2026-02-23 10:39:11','2026-01-24 06:39:11',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(334,2,'60349705a3ed005a37f68bb99087b13fe4ca1af46f9d7724df8171eab3ba2461','2026-02-23 10:39:29','2026-01-24 06:39:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(335,2,'3cf858640e6bc0caed5b682dde791e2ae4d68ad5e062773ef41f6f2bf36ae551','2026-02-23 10:39:29','2026-01-24 06:39:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(336,2,'5aa1c0ff4877c368cc989b8c504ee7340204a24f6f94a2f3f3251a10669a2475','2026-02-23 10:39:30','2026-01-24 06:39:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(337,2,'099f22a72d55f3a7af69cdaad8bbd38230d7c8da6b62831416fdcc59d5bfefe4','2026-02-23 10:39:35','2026-01-24 06:39:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(338,2,'f19247de589a591fa7032d28c86e8a44a32a9f245b2f5b2f7bdac2d06061e5f2','2026-02-23 10:39:39','2026-01-24 06:39:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(339,2,'1c5d5c6db888e3cf8a569ede1e5c00025b7a822cd218fe3a03703801c3301c8a','2026-02-23 10:40:41','2026-01-24 06:40:41',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(340,2,'12d9f59aadc2992988c2568ff92a31cfe3eaab216fa94cd57683c017a6a7666b','2026-02-23 10:40:42','2026-01-24 06:40:42',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(341,2,'6b621f4966bb676e5fabcd095ee7ca9186777a1e55ecab74cd57f1afd37736af','2026-02-23 10:42:13','2026-01-24 06:42:13',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(342,2,'3e8d69c90457b56125ec9d6864aade7a964690a5393c0e82819580938a6ec5f3','2026-02-23 10:42:56','2026-01-24 06:42:56',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(343,2,'9f989ba878404d217661178179f2a9ce6cb786c00814ab5dd94054812b3a1a09','2026-02-23 10:42:57','2026-01-24 06:42:57',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(344,2,'61850d796f81397fefcf9fb34d635c4bbafe44836109f1185def8692630661c1','2026-02-23 10:42:57','2026-01-24 06:42:57',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(345,2,'2eab1548f8441cdff66f4f6259003f00e919e64761b8b2bc7fecb7c1cf2a1254','2026-02-23 10:48:35','2026-01-24 06:48:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(346,2,'db605f6006b5ff32739684d38002ac43847616604bdea13fb21ba89cb48efec9','2026-02-23 10:48:37','2026-01-24 06:48:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(347,2,'9790cd6e4f72d48f87b4aa134aa5b52b7b87496ec2850a2d23a4dccfd9a611dd','2026-02-23 10:49:35','2026-01-24 06:49:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(348,2,'a22fb6d5561ec76c0daa75516056a1f2b042d2ddc3e4d790d8d4bc71e8f334ac','2026-02-23 10:50:04','2026-01-24 06:50:04',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(349,2,'b30a788fcc71004e44f55cd327d35b5f9e153a3e1a6701fb5ee0575f943209a4','2026-02-23 10:50:38','2026-01-24 06:50:38',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(350,2,'9e20d346beef513edeac61728bfd2f86faedde304b53164f567f162684f16e0f','2026-02-23 10:51:24','2026-01-24 06:51:24',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(351,2,'f13f7f10210c54eb459b11fb308926c690904d17e21f7d41bab1cb8d878b35a3','2026-02-23 11:01:13','2026-01-24 07:01:13',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(352,2,'f186aef3d3764ede8932983e3e72998412239419dc00849fd9490720b3304c4f','2026-02-23 11:01:14','2026-01-24 07:01:14',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(353,2,'7f1a8fb7a57cc3f24be4b166c76df16e6529371cde00d9b2b54eee52abd5b2bd','2026-02-23 11:03:30','2026-01-24 07:03:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(354,2,'2036cf8ef86595fac3809a0e096a367b37d1a6bbbb2e377888f7a5aac715ae23','2026-02-25 05:24:18','2026-01-26 01:24:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(355,2,'cbc3f3991c594adf6ff478ec590d549d8c1eac2fce0a0ff18be688ffadb0cfc3','2026-02-25 05:24:18','2026-01-26 01:24:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(356,2,'9a97a909534824108a07942004b0efa5d7d3b72df69b0916586e2c1f31de1e76','2026-02-25 05:24:18','2026-01-26 01:24:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(357,2,'2fcd5f6f4a850378844e00b62d3d19187ef999eebfb2da1b981d4d13d41af94d','2026-02-25 05:24:26','2026-01-26 01:24:26',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(358,2,'49947e620f546bed4e7ce3b7bb4c7c9dfc715a847c29b67cb0996defd048292e','2026-02-25 05:24:28','2026-01-26 01:24:28',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(359,2,'ef776c069aad347902b692bf41d2d8256ed20aaf25c43c0fc1c7177cd92ef3ba','2026-02-25 05:24:30','2026-01-26 01:24:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(360,2,'c3009304b3e13bc570b0a6319bbd62aab089403e2f1a649408721c5e8b78ce31','2026-02-25 05:24:30','2026-01-26 01:24:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(361,2,'00804f65131a5ccc1fcc0fe341151e8231d48b920ce4da89ae3f1afcd9292054','2026-02-25 05:24:30','2026-01-26 01:24:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(362,2,'6af5703c342ec8c741de840de271408dad486f14122f54abdebee7570511da44','2026-02-25 05:24:38','2026-01-26 01:24:38',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(363,2,'039010105b69316d147d63a2a99158e6479b7545c686368ffb100c358eba5db5','2026-02-25 05:24:39','2026-01-26 01:24:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(364,2,'906f0b4502f8b69e32d12e8d611e8cd95d91079ae2526037e5188f898dd2fde5','2026-02-25 05:26:18','2026-01-26 01:26:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(365,2,'23fd73951e5650907a640bde333d760464dcaab57ebd37c12be22ee2d07f85ad','2026-02-25 05:47:17','2026-01-26 01:47:17',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(366,2,'a17258e9b1ea8eac6d0fef6ff95a9e4a83ceda1b4e7373057f3a1ef8f5920690','2026-02-25 05:47:17','2026-01-26 01:47:17',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(367,2,'facab3b0a8365046a64e23fa24c8a18adcb4d7edbeb0c0fabe19a3908f515d14','2026-02-25 05:47:17','2026-01-26 01:47:17',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(368,2,'cc7a283975529a1eec4aa18de3f2f5c7239f7febf6152849cc98030c945d4f4f','2026-02-25 05:47:24','2026-01-26 01:47:24',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(369,2,'5447a91c7fc1b4012c14d7b4da0f658fbb76515576df3fdd2a8dcc3bbdc655e4','2026-02-25 05:49:02','2026-01-26 01:49:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(370,2,'c67c66a4fc8700a552bcbd5d69d2b6a9220552c3ae8b5cf612d9760ff04ff4d5','2026-02-25 05:49:02','2026-01-26 01:49:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(371,2,'4773b6245ac0af17de4d1bc55df1bb281c6e10d2c6116208e88ba193a57527ec','2026-02-25 05:49:02','2026-01-26 01:49:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(372,5,'4108116cc31c749c0adacfec0f8faa5863e63c93b127a71ca026f63769c2412b','2026-02-27 03:41:46','2026-01-27 23:41:46',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(373,5,'c3f9b3f834176fe93c022d9a8890806bb5894f2ebb3f3a4bf16e71fcb24ce3be','2026-02-27 03:41:48','2026-01-27 23:41:48',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(374,5,'5a500c59e55f634c4414e57b98cf6284ad2b96c330229e6aa9cff209fd4223cf','2026-02-27 03:41:52','2026-01-27 23:41:52',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(375,5,'cb3d314cac04e7efa82143215f568a10383dead70026950035374c77a8befda2','2026-02-27 03:55:31','2026-01-27 23:55:31',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(376,5,'6d5335401319bda08be3ad6b3886828c0d94b792b20aef21b24352891be6cffc','2026-02-27 03:55:38','2026-01-27 23:55:38',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(377,5,'a6e44316b741e10d89bb81bd946e344fc87ec79d78c6bc4ef7f7427c0522a1f1','2026-02-27 04:09:26','2026-01-28 00:09:26',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(378,5,'f8550d65cbbc28bb92e9dd86f0582be9fb434e76b64344bc842afb29a55dae1c','2026-02-27 10:00:07','2026-01-28 06:00:07',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(379,5,'6584f71a4e4a23f3c300bd025206218e9d202579291cf86898babe785ec8bca8','2026-02-27 10:00:07','2026-01-28 06:00:07',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(380,5,'a351907323b54b49b690f49a14bd573c54fdc5e53263a63aad7974eba4bb2e42','2026-02-27 10:00:07','2026-01-28 06:00:07',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(381,5,'3b75532b62603424db8a94415b795ab66ca54af87259eed758b450437f014ef2','2026-02-27 10:00:12','2026-01-28 06:00:12',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(382,5,'315f40fa77e70080cc94aa47495d9e45e6ebff8e19fec75058f330ce82654491','2026-02-27 10:00:19','2026-01-28 06:00:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(383,5,'26913e57a3b665bcb5f5c98e0ebd408ad52ec5c63e5f1c94ec52884abac8bb5f','2026-02-27 10:01:39','2026-01-28 06:01:39',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(384,5,'04ec95cd8d797960f09ddba75f5528ea2931be2195a6d73dadb5ada3679617fc','2026-02-27 10:01:40','2026-01-28 06:01:40',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(385,5,'058bb689bafb8e2c667d0ff7faf6d6e0e730043272110bcbec230c3fe239edcd','2026-02-27 10:16:38','2026-01-28 06:16:38',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(386,5,'068b3dcedd7889eb224f0d31b3b26794154cb6b5515248a42d212f7c40854e07','2026-02-27 10:16:44','2026-01-28 06:16:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(387,5,'5eb365dbc347bf0576d91561d586ff620cf00d7f9490f42dd0f293f4726790ad','2026-02-27 10:16:50','2026-01-28 06:16:50',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(388,5,'a2ef7be35c7ca05b4aaf8ed9b65c39fc4d18438613b65d3175650d966e014bfb','2026-02-27 10:17:57','2026-01-28 06:17:57',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(389,5,'f2442077768c5d1db63b74f3836c77435aa38805e2cc0cd661c5cd215ca16ad7','2026-02-27 10:17:57','2026-01-28 06:17:57',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(390,5,'91e42f736dc69abaa53f52b7377803c5c284256c905729c9a066ca9813e33cd2','2026-02-27 10:18:00','2026-01-28 06:18:00',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(391,5,'6fbb0903b7d84e11bafc9ac6a1bc7a8afcd7da4c813df663daea21b35b78185a','2026-02-27 10:18:00','2026-01-28 06:18:00',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(392,5,'6b993f0a82c3949e92ac7c093ecd0486af9b9ad394184c46df6a9a2cd01fe4d0','2026-02-27 10:18:00','2026-01-28 06:18:00',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(393,5,'c40b3f97ec23c78f9ddede566991ee1e330657e59b7d94cf9d2ae0aa537d7f82','2026-02-27 10:18:35','2026-01-28 06:18:35',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(394,5,'a5e36b8f79af678f69bfc2e922c76a76755ef1fc30559f139078f546c2b82fbe','2026-02-27 10:18:36','2026-01-28 06:18:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(395,5,'21e9b9084da9fcae721c634e7e5a8fc1355b5ba0acea93fce72ecefdf03de76f','2026-02-27 10:18:36','2026-01-28 06:18:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1');
/*!40000 ALTER TABLE `usuario_refresh` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_reset_senha`
--

DROP TABLE IF EXISTS `usuario_reset_senha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_reset_senha` (
  `id_reset` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expira_em` datetime NOT NULL,
  `usado_em` datetime DEFAULT NULL,
  `ip_solicitacao` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_reset`),
  KEY `ix_urs_usuario` (`id_usuario`),
  KEY `ix_urs_expira` (`expira_em`),
  KEY `ix_urs_token` (`token_hash`),
  CONSTRAINT `fk_urs_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_reset_senha`
--

LOCK TABLES `usuario_reset_senha` WRITE;
/*!40000 ALTER TABLE `usuario_reset_senha` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_reset_senha` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_senha_historico`
--

DROP TABLE IF EXISTS `usuario_senha_historico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_senha_historico` (
  `id_usuario_senha_hist` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `hash_formato` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `motivo` enum('CRIACAO','TROCA','RESET_TI','RESET_ADMIN','MIGRACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `detalhe` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `id_usuario_executor` bigint DEFAULT NULL,
  PRIMARY KEY (`id_usuario_senha_hist`),
  KEY `idx_ush_usuario_data` (`id_usuario`,`criado_em`),
  KEY `idx_ush_motivo` (`motivo`,`criado_em`),
  KEY `fk_ush_sessao` (`id_sessao_usuario`),
  KEY `fk_ush_executor` (`id_usuario_executor`),
  CONSTRAINT `fk_ush_executor` FOREIGN KEY (`id_usuario_executor`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `fk_ush_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
  CONSTRAINT `fk_ush_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_senha_historico`
--

LOCK TABLES `usuario_senha_historico` WRITE;
/*!40000 ALTER TABLE `usuario_senha_historico` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_senha_historico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_senha_reset`
--

DROP TABLE IF EXISTS `usuario_senha_reset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_senha_reset` (
  `id_usuario_senha_reset` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `token_hash` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `expira_em` datetime NOT NULL,
  `usado_em` datetime DEFAULT NULL,
  `id_sessao_usuario_solicitante` bigint DEFAULT NULL,
  `id_usuario_solicitante` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario_senha_reset`),
  UNIQUE KEY `ux_usr_reset_token_hash` (`token_hash`),
  KEY `idx_usr_reset_usuario` (`id_usuario`),
  KEY `idx_usr_reset_expira` (`expira_em`),
  KEY `fk_usr_reset_sessao` (`id_sessao_usuario_solicitante`),
  KEY `fk_usr_reset_solicitante` (`id_usuario_solicitante`),
  CONSTRAINT `fk_usr_reset_sessao` FOREIGN KEY (`id_sessao_usuario_solicitante`) REFERENCES `sessao_usuario` (`id_sessao_usuario`) ON DELETE SET NULL,
  CONSTRAINT `fk_usr_reset_solicitante` FOREIGN KEY (`id_usuario_solicitante`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL,
  CONSTRAINT `fk_usr_reset_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_senha_reset`
--

LOCK TABLES `usuario_senha_reset` WRITE;
/*!40000 ALTER TABLE `usuario_senha_reset` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_senha_reset` ENABLE KEYS */;
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
INSERT INTO `usuario_sistema` VALUES (1,2,1,1,'2026-01-17 23:08:32'),(2,1,6,1,'2026-01-18 05:48:17'),(2,2,6,1,'2026-01-18 05:48:17'),(5,1,6,1,'2026-01-28 06:00:49'),(5,4,7,1,'2026-01-27 23:40:56'),(6,4,7,1,'2026-01-27 23:40:56'),(9,1,2,1,'2026-01-28 06:05:17'),(10,1,8,1,'2026-01-28 06:05:17'),(11,1,4,1,'2026-01-28 06:05:17');
/*!40000 ALTER TABLE `usuario_sistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_sistema_perfil`
--

DROP TABLE IF EXISTS `usuario_sistema_perfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_sistema_perfil` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `id_sistema` int NOT NULL,
  `perfil_slug` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `data_vinculo` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_sys` (`id_usuario`,`id_sistema`),
  CONSTRAINT `fk_usp_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_sistema_perfil`
--

LOCK TABLES `usuario_sistema_perfil` WRITE;
/*!40000 ALTER TABLE `usuario_sistema_perfil` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_sistema_perfil` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_unidade`
--

DROP TABLE IF EXISTS `usuario_unidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_unidade` (
  `id_usuario` bigint NOT NULL,
  `id_unidade` bigint NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`,`id_unidade`),
  KEY `idx_uu_unidade` (`id_unidade`),
  CONSTRAINT `fk_uu_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
  CONSTRAINT `fk_uu_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_unidade`
--

LOCK TABLES `usuario_unidade` WRITE;
/*!40000 ALTER TABLE `usuario_unidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_unidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venda`
--

DROP TABLE IF EXISTS `venda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venda` (
  `id_venda` bigint NOT NULL AUTO_INCREMENT,
  `id_caixa` bigint NOT NULL,
  `id_cliente` bigint DEFAULT NULL,
  `origem` enum('PDV_RUA','ATENDIMENTO_INTERNO') NOT NULL DEFAULT 'PDV_RUA',
  `status` enum('ABERTA','PAGA','CANCELADA') NOT NULL DEFAULT 'ABERTA',
  `total_itens` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_desconto` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_final` decimal(10,2) NOT NULL DEFAULT '0.00',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `pago_em` datetime DEFAULT NULL,
  `cancelado_em` datetime DEFAULT NULL,
  `criado_por` bigint DEFAULT NULL,
  PRIMARY KEY (`id_venda`),
  KEY `idx_venda_status` (`status`,`criado_em`),
  KEY `fk_venda_caixa` (`id_caixa`),
  KEY `fk_venda_cliente` (`id_cliente`),
  KEY `fk_venda_criado_por` (`criado_por`),
  CONSTRAINT `fk_venda_caixa` FOREIGN KEY (`id_caixa`) REFERENCES `caixa` (`id_caixa`),
  CONSTRAINT `fk_venda_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  CONSTRAINT `fk_venda_criado_por` FOREIGN KEY (`criado_por`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venda`
--

LOCK TABLES `venda` WRITE;
/*!40000 ALTER TABLE `venda` DISABLE KEYS */;
/*!40000 ALTER TABLE `venda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venda_evento`
--

DROP TABLE IF EXISTS `venda_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venda_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_venda` bigint NOT NULL,
  `tipo` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` bigint DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  KEY `idx_ve_venda` (`id_venda`,`criado_em`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venda_evento`
--

LOCK TABLES `venda_evento` WRITE;
/*!40000 ALTER TABLE `venda_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `venda_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venda_item`
--

DROP TABLE IF EXISTS `venda_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venda_item` (
  `id_venda_item` bigint NOT NULL AUTO_INCREMENT,
  `id_venda` bigint NOT NULL,
  `id_farmaco` bigint DEFAULT NULL,
  `id_lote` bigint DEFAULT NULL,
  `id_local_estoque` bigint DEFAULT NULL,
  `descricao` varchar(255) NOT NULL,
  `quantidade` int NOT NULL,
  `valor_unitario` decimal(10,2) NOT NULL,
  `desconto` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_linha` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_venda_item`),
  KEY `idx_vi_venda` (`id_venda`),
  KEY `idx_vi_farmaco` (`id_farmaco`,`id_lote`),
  KEY `fk_vi_lote` (`id_lote`),
  CONSTRAINT `fk_vi_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`),
  CONSTRAINT `fk_vi_lote` FOREIGN KEY (`id_lote`) REFERENCES `farmaco_lote` (`id_lote`),
  CONSTRAINT `fk_vi_venda` FOREIGN KEY (`id_venda`) REFERENCES `venda` (`id_venda`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venda_item`
--

LOCK TABLES `venda_item` WRITE;
/*!40000 ALTER TABLE `venda_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `venda_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venda_pagamento`
--

DROP TABLE IF EXISTS `venda_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venda_pagamento` (
  `id_venda_pagamento` bigint NOT NULL AUTO_INCREMENT,
  `id_venda` bigint NOT NULL,
  `id_forma_pagamento` int NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_venda_pagamento`),
  KEY `idx_vp_venda` (`id_venda`),
  KEY `fk_vp_forma` (`id_forma_pagamento`),
  CONSTRAINT `fk_vp_forma` FOREIGN KEY (`id_forma_pagamento`) REFERENCES `forma_pagamento` (`id_forma_pagamento`),
  CONSTRAINT `fk_vp_venda` FOREIGN KEY (`id_venda`) REFERENCES `venda` (`id_venda`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venda_pagamento`
--

LOCK TABLES `venda_pagamento` WRITE;
/*!40000 ALTER TABLE `venda_pagamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `venda_pagamento` ENABLE KEYS */;
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
-- Temporary view structure for view `vw_admin_sessoes_ativas`
--

DROP TABLE IF EXISTS `vw_admin_sessoes_ativas`;
/*!50001 DROP VIEW IF EXISTS `vw_admin_sessoes_ativas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_admin_sessoes_ativas` AS SELECT 
 1 AS `id_sessao_usuario`,
 1 AS `id_usuario`,
 1 AS `login`,
 1 AS `id_sistema`,
 1 AS `id_unidade`,
 1 AS `id_local_operacional`,
 1 AS `ip_acesso`,
 1 AS `iniciado_em`,
 1 AS `expira_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_laboratorio_protocolos_pendentes`
--

DROP TABLE IF EXISTS `vw_laboratorio_protocolos_pendentes`;
/*!50001 DROP VIEW IF EXISTS `vw_laboratorio_protocolos_pendentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_laboratorio_protocolos_pendentes` AS SELECT 
 1 AS `id_laboratorio_protocolo`,
 1 AS `id_ffa`,
 1 AS `id_gpat`,
 1 AS `id_pedido_item`,
 1 AS `codigo`,
 1 AS `status`,
 1 AS `criado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_laboratorio_protocolos_por_gpat`
--

DROP TABLE IF EXISTS `vw_laboratorio_protocolos_por_gpat`;
/*!50001 DROP VIEW IF EXISTS `vw_laboratorio_protocolos_por_gpat`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_laboratorio_protocolos_por_gpat` AS SELECT 
 1 AS `id_laboratorio_protocolo`,
 1 AS `id_ffa`,
 1 AS `id_gpat`,
 1 AS `id_pedido_item`,
 1 AS `codigo`,
 1 AS `barcode`,
 1 AS `status`,
 1 AS `sistema_externo`,
 1 AS `codigo_externo`,
 1 AS `criado_em`,
 1 AS `atualizado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_config_efetiva`
--

DROP TABLE IF EXISTS `vw_painel_config_efetiva`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_config_efetiva`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_config_efetiva` AS SELECT 
 1 AS `id_painel`,
 1 AS `painel_codigo`,
 1 AS `painel_tipo`,
 1 AS `chave`,
 1 AS `tipo_valor`,
 1 AS `valor_efetivo`,
 1 AS `atualizado_em`,
 1 AS `id_usuario`,
 1 AS `id_sessao_usuario`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_config_json`
--

DROP TABLE IF EXISTS `vw_painel_config_json`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_config_json`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_config_json` AS SELECT 
 1 AS `id_painel`,
 1 AS `painel_codigo`,
 1 AS `painel_tipo`,
 1 AS `config_json`,
 1 AS `atualizado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_senhas_chamando`
--

DROP TABLE IF EXISTS `vw_painel_senhas_chamando`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_senhas_chamando`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_senhas_chamando` AS SELECT 
 1 AS `codigo`,
 1 AS `lane`,
 1 AS `status`,
 1 AS `local_nome`,
 1 AS `chamada_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_senhas_chamando_por_painel`
--

DROP TABLE IF EXISTS `vw_painel_senhas_chamando_por_painel`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_senhas_chamando_por_painel`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_senhas_chamando_por_painel` AS SELECT 
 1 AS `id_painel`,
 1 AS `painel_codigo`,
 1 AS `painel_tipo`,
 1 AS `painel_nome`,
 1 AS `id_local_operacional`,
 1 AS `local_codigo`,
 1 AS `local_nome`,
 1 AS `local_tipo`,
 1 AS `local_sala`,
 1 AS `id_senha`,
 1 AS `senha_codigo`,
 1 AS `senha_lane`,
 1 AS `tipo_atendimento`,
 1 AS `prioridade`,
 1 AS `senha_status`,
 1 AS `chamada_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_rastreio_cat_por_ffa`
--

DROP TABLE IF EXISTS `vw_rastreio_cat_por_ffa`;
/*!50001 DROP VIEW IF EXISTS `vw_rastreio_cat_por_ffa`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_rastreio_cat_por_ffa` AS SELECT 
 1 AS `id_cat`,
 1 AS `id_ffa`,
 1 AS `id_gpat`,
 1 AS `status`,
 1 AS `criado_em`,
 1 AS `atualizado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_rastreio_ffa_gpat`
--

DROP TABLE IF EXISTS `vw_rastreio_ffa_gpat`;
/*!50001 DROP VIEW IF EXISTS `vw_rastreio_ffa_gpat`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_rastreio_ffa_gpat` AS SELECT 
 1 AS `id_ffa`,
 1 AS `id_gpat`,
 1 AS `codigo_gpat`,
 1 AS `barcode_gpat`,
 1 AS `gpat_criado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_senhas_ativas`
--

DROP TABLE IF EXISTS `vw_senhas_ativas`;
/*!50001 DROP VIEW IF EXISTS `vw_senhas_ativas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_senhas_ativas` AS SELECT 
 1 AS `id_senha`,
 1 AS `codigo`,
 1 AS `tipo_atendimento`,
 1 AS `lane`,
 1 AS `prioridade`,
 1 AS `status`,
 1 AS `origem`,
 1 AS `id_sistema`,
 1 AS `id_unidade`,
 1 AS `id_local_operacional`,
 1 AS `local_nome`,
 1 AS `exibe_em_painel_publico`,
 1 AS `gera_tts_publico`,
 1 AS `criada_em`,
 1 AS `posicionado_em`,
 1 AS `chamada_em`,
 1 AS `inicio_atendimento_em`,
 1 AS `finalizada_em`*/;
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
 1 AS `id_sistema`,
 1 AS `id_perfil`,
 1 AS `permissao`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_workflow_ffa_completo`
--

DROP TABLE IF EXISTS `vw_workflow_ffa_completo`;
/*!50001 DROP VIEW IF EXISTS `vw_workflow_ffa_completo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_workflow_ffa_completo` AS SELECT 
 1 AS `id_ffa`,
 1 AS `origem`,
 1 AS `entidade`,
 1 AS `id_entidade`,
 1 AS `tipo_evento`,
 1 AS `detalhe`,
 1 AS `id_sessao_usuario`,
 1 AS `criado_em`,
 1 AS `payload_json`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_workflow_ffa_eventos_materializado`
--

DROP TABLE IF EXISTS `vw_workflow_ffa_eventos_materializado`;
/*!50001 DROP VIEW IF EXISTS `vw_workflow_ffa_eventos_materializado`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_workflow_ffa_eventos_materializado` AS SELECT 
 1 AS `id_workflow_evento`,
 1 AS `id_ffa`,
 1 AS `origem`,
 1 AS `entidade`,
 1 AS `id_entidade`,
 1 AS `tipo_evento`,
 1 AS `detalhe`,
 1 AS `id_sessao_usuario`,
 1 AS `criado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `workflow_ffa_evento`
--

DROP TABLE IF EXISTS `workflow_ffa_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workflow_ffa_evento` (
  `id_workflow_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `origem` varchar(20) NOT NULL,
  `entidade` varchar(50) DEFAULT NULL,
  `id_entidade` bigint DEFAULT NULL,
  `tipo_evento` varchar(60) NOT NULL,
  `detalhe` text,
  `id_sessao_usuario` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL,
  `payload_json` json DEFAULT NULL,
  PRIMARY KEY (`id_workflow_evento`),
  KEY `ix_wf_ffa` (`id_ffa`,`criado_em`),
  KEY `ix_wf_tipo` (`tipo_evento`),
  KEY `ix_wf_origem` (`origem`),
  KEY `ix_wf_entidade` (`entidade`,`id_entidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_ffa_evento`
--

LOCK TABLES `workflow_ffa_evento` WRITE;
/*!40000 ALTER TABLE `workflow_ffa_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `workflow_ffa_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'pronto_atendimento'
--

--
-- Dumping routines for database 'pronto_atendimento'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_sha256i_hash` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_sha256i_hash`(
    p_senha     VARCHAR(255),
    p_salt_hex  CHAR(32),
    p_iter      INT
) RETURNS char(64) CHARSET utf8mb4
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_hash CHAR(64);
    DECLARE v_salt BINARY(16);

    IF p_senha IS NULL THEN
        RETURN NULL;
    END IF;

    IF p_salt_hex IS NULL OR LENGTH(p_salt_hex) <> 32 THEN
        RETURN NULL;
    END IF;

    IF p_iter IS NULL OR p_iter < 2000 THEN
        SET p_iter = 12000;
    END IF;

    SET v_salt = UNHEX(p_salt_hex);

    SET v_hash = SHA2(CONCAT(v_salt, p_senha), 256);

    WHILE i < p_iter DO
        SET v_hash = SHA2(CONCAT(UNHEX(v_hash), v_salt, p_senha), 256);
        SET i = i + 1;
    END WHILE;

    RETURN v_hash;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_admin_painel_filtros_seed_all` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`pa_owner`@`%` PROCEDURE `sp_admin_painel_filtros_seed_all`(
    IN p_id_sessao_usuario BIGINT,
    IN p_incluir_nd TINYINT
)
main: BEGIN
    -- Recepção: RECxx (ex.: REC01..)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'RECEPCAO', 'RECEPCAO', 'REC', NULL, p_incluir_nd);

    -- Triagem: TRIxx (ex.: TRI01..)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'TRIAGEM', 'TRIAGEM', 'TRI', NULL, p_incluir_nd);

    -- Médico Clínico: MEDCxx (ex.: MEDC01.. ou MEDC1..)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'MEDICO_CLINICO', 'MEDICO_CLINICO', 'MEDC', NULL, p_incluir_nd);

    -- Médico Pediátrico: MEDPxx (ex.: MEDP01.. ou MEDP1..)
    -- OBS: no schema atual, o tipo em local_operacional está como MEDICO_PEDIATRICO (não MEDICO_PEDI).
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'MEDICO_PEDI', 'MEDICO_PEDIATRICO', 'MEDP', NULL, p_incluir_nd);

    -- RX: RXxx (ex.: RX01..)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'RX', 'RX', 'RX', NULL, p_incluir_nd);

    -- Medicação (Adulto): MED0x/MEDxx (ex.: MED01..). Exclui prefixo pediátrico (MEDP)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'MEDICACAO_ADULTO', 'MEDICACAO', 'MED', 'MEDP', p_incluir_nd);

    -- Medicação (Pedi): MEDPxx (ex.: MEDP01..)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'MEDICACAO_PEDI', 'MEDICACAO', 'MEDP', NULL, p_incluir_nd);

    -- Medicação (Infantil): (se você usar código/prefixo diferente, ajuste aqui)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'MEDICACAO_INF', 'MEDICACAO', 'MEDP', NULL, p_incluir_nd);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_admin_sessao_revogar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_admin_sessao_revogar`(
    IN p_id_sessao_admin   BIGINT,
    IN p_id_sessao_alvo    BIGINT,
    IN p_motivo            VARCHAR(200)
)
BEGIN
    DECLARE v_id_usuario_alvo BIGINT DEFAULT NULL;

    -- exige sessão admin válida + permissão (ajuste o código da permissão conforme seed)
    CALL sp_sessao_assert(p_id_sessao_admin);
    -- Se ainda não seedou permissões, comente a linha abaixo temporariamente.
    -- CALL sp_permissao_assert(p_id_sessao_admin, 'ADMIN_SESSAO_REVOGAR');

    IF NOT EXISTS (SELECT 1 FROM sessao_usuario su WHERE su.id_sessao_usuario = p_id_sessao_alvo) THEN
        CALL sp_raise('SESSAO_ALVO_INEXISTENTE', CONCAT('Sessão alvo inexistente: ', p_id_sessao_alvo));
    END IF;

    SELECT su.id_usuario
      INTO v_id_usuario_alvo
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_alvo;

    UPDATE sessao_usuario
       SET ativo = 0,
           encerrado_em = NOW(),
           token = NULL
     WHERE id_sessao_usuario = p_id_sessao_alvo;

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_admin,
        'sessao_usuario',
        p_id_sessao_alvo,
        'SESSAO_REVOGADA',
        CONCAT('Admin forçou logout. Motivo: ', COALESCE(p_motivo,'(n/a)')),
        NULL,
        'sessao_usuario',
        v_id_usuario_alvo
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_assert_not_null` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_assert_not_null`(
    IN p_valor    TEXT,
    IN p_codigo   VARCHAR(50),
    IN p_mensagem VARCHAR(4000)
)
BEGIN
    IF p_valor IS NULL THEN
        CALL sp_raise(IFNULL(p_codigo,'PARAM'), IFNULL(p_mensagem,'Valor obrigatório (NULL).'));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_assert_true` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_assert_true`(
    IN p_condicao TINYINT,
    IN p_codigo   VARCHAR(50),
    IN p_mensagem VARCHAR(4000)
)
BEGIN
    -- Trata NULL como falso
    IF IFNULL(p_condicao, 0) = 0 THEN
        CALL sp_raise(IFNULL(p_codigo,'ASSERT'), IFNULL(p_mensagem,'Falha de asserção.'));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_auditar_erro_sql` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auditar_erro_sql`(
    IN p_id_sessao_usuario BIGINT,
    IN p_rotina VARCHAR(128),
    IN p_contexto VARCHAR(4000)
)
BEGIN
    DECLARE v_sqlstate VARCHAR(10) DEFAULT NULL;
    DECLARE v_errno INT DEFAULT NULL;
    DECLARE v_msg TEXT DEFAULT NULL;

    -- Preferir variáveis populadas pelo EXIT HANDLER da rotina chamadora
    IF @diag_sqlstate IS NOT NULL AND @diag_sqlstate <> '' THEN
        SET v_sqlstate = @diag_sqlstate;
    END IF;

    IF @diag_errno IS NOT NULL AND @diag_errno <> 0 THEN
        SET v_errno = CAST(@diag_errno AS SIGNED);
    END IF;

    IF @diag_msg IS NOT NULL AND @diag_msg <> '' THEN
        SET v_msg = @diag_msg;
    END IF;

    -- Limpa para não vazar para próximas chamadas
    SET @diag_sqlstate = NULL;
    SET @diag_errno    = NULL;
    SET @diag_msg      = NULL;

    -- Log dedicado (não pode falhar por FK)
    INSERT INTO auditoria_erro(
        id_sessao_usuario,
        rotina,
        `sqlstate`,
        `errno`,
        mensagem,
        contexto,
        criado_em
    ) VALUES (
        p_id_sessao_usuario,
        p_rotina,
        IFNULL(v_sqlstate,'(n/a)'),
        IFNULL(v_errno,0),
        IFNULL(v_msg,'(n/a)'),
        p_contexto,
        NOW()
    );

    -- Log genérico em auditoria_evento, se existir (mantém trilha transversal)
    IF EXISTS (
        SELECT 1
          FROM information_schema.tables
         WHERE table_schema = DATABASE()
           AND table_name = 'auditoria_evento'
    ) THEN
        INSERT INTO auditoria_evento(
            id_sessao_usuario,
            entidade,
            id_entidade,
            acao,
            detalhe,
            criado_em
        ) VALUES (
            p_id_sessao_usuario,
            'SQL',
            NULL,
            'ERRO_SQL',
            CONCAT(
                'ROTINA=', IFNULL(p_rotina,'(n/a)'),
                ' | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
                ' | ERRNO=', IFNULL(v_errno,0),
                ' | MSG=', IFNULL(v_msg,'(n/a)'),
                ' | CTX=', IFNULL(p_contexto,'(n/a)')
            ),
            NOW()
        );
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_auditoria_evento_registrar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auditoria_evento_registrar`(
    IN p_id_sessao_usuario  BIGINT,
    IN p_entidade           VARCHAR(80),
    IN p_id_entidade        BIGINT,
    IN p_acao               VARCHAR(80),
    IN p_detalhe            TEXT,
    IN p_id_usuario_exec    BIGINT,     -- opcional (se NULL e houver sessão, será inferido)
    IN p_tabela             VARCHAR(50),
    IN p_id_usuario_espelho BIGINT      -- opcional
)
BEGIN
    DECLARE v_id_usuario BIGINT DEFAULT NULL;

    IF p_id_usuario_exec IS NOT NULL THEN
        SET v_id_usuario = p_id_usuario_exec;
    ELSEIF p_id_sessao_usuario IS NOT NULL THEN
        SELECT su.id_usuario
          INTO v_id_usuario
          FROM sessao_usuario su
         WHERE su.id_sessao_usuario = p_id_sessao_usuario
         LIMIT 1;
    END IF;

    INSERT INTO auditoria_evento
        (id_sessao_usuario, entidade, id_entidade, acao, detalhe, id_usuario, tabela, id_usuario_espelho)
    VALUES
        (p_id_sessao_usuario, p_entidade, p_id_entidade, p_acao, p_detalhe, v_id_usuario, p_tabela,
         COALESCE(p_id_usuario_espelho, v_id_usuario));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cat_abrir_por_item` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cat_abrir_por_item`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_pedido_item    BIGINT,
    IN  p_id_usuario_resp   BIGINT,
    OUT p_id_cat            BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_pedido BIGINT;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_id_gpat BIGINT;
    DECLARE v_exige_cat TINYINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_cat_abrir_por_item', 'Falha ao abrir CAT');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_cat_abrir_por_item | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_cat = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_pedido_item IS NOT NULL, 'PARAM', 'id_pedido_item é obrigatório.');
    CALL sp_assert_true(p_id_usuario_resp IS NOT NULL, 'PARAM', 'id_usuario_resp é obrigatório.');

    START TRANSACTION;

    SELECT i.id_pedido_medico, i.exige_cat
      INTO v_id_pedido, v_exige_cat
      FROM pedido_medico_item i
     WHERE i.id_pedido_item = p_id_pedido_item
     LIMIT 1;

    CALL sp_assert_true(v_id_pedido IS NOT NULL, 'CAT', 'Item de pedido não encontrado.');
    CALL sp_assert_true(v_exige_cat = 1, 'CAT', 'Item não exige CAT.');

    SELECT p.id_ffa, p.id_gpat
      INTO v_id_ffa, v_id_gpat
      FROM pedido_medico p
     WHERE p.id_pedido_medico = v_id_pedido
     LIMIT 1;

    CALL sp_assert_true(v_id_ffa IS NOT NULL AND v_id_gpat IS NOT NULL, 'CAT', 'Pedido sem FFA/GPAT.');

    INSERT INTO cat_notificacao (id_ffa, id_gpat, id_pedido_item, id_usuario_responsavel, status)
    VALUES (v_id_ffa, v_id_gpat, p_id_pedido_item, p_id_usuario_resp, 'ABERTA');

    SET p_id_cat = LAST_INSERT_ID();

    INSERT INTO cat_evento (id_cat, id_sessao_usuario, evento, payload_json)
    VALUES (p_id_cat, p_id_sessao_usuario, 'CAT_ABERTA', JSON_OBJECT('id_pedido_item', p_id_pedido_item));

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'CAT_ABERTA', 'cat_notificacao', p_id_cat);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_codigo_emitir_interno` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigo_emitir_interno`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_dominio ENUM('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO'),
    IN  p_id_unidade BIGINT,
    IN  p_id_local_operacional BIGINT,
    IN  p_id_laboratorio BIGINT,
    IN  p_codigo_interno_manual VARCHAR(50),
    IN  p_id_ffa BIGINT,
    IN  p_id_senha BIGINT,
    IN  p_id_paciente BIGINT,
    IN  p_id_produto INT,
    IN  p_id_usuario BIGINT,
    IN  p_id_cliente BIGINT,
    IN  p_payload JSON,
    OUT p_id_codigo BIGINT,
    OUT p_codigo_interno VARCHAR(50)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_prefixo_5 CHAR(5);
    DECLARE v_chave_seq VARCHAR(80);
    DECLARE v_seq INT;
    DECLARE v_codigo VARCHAR(50);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_codigo_emitir_interno', 'Falha ao emitir código interno');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_codigo_emitir_interno | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    SET p_id_codigo = NULL;
    SET p_codigo_interno = NULL;

    START TRANSACTION;

    -- modo MANUAL: usa o código recebido e garante unicidade
    IF p_codigo_interno_manual IS NOT NULL AND TRIM(p_codigo_interno_manual) <> '' THEN
        SET v_codigo = TRIM(p_codigo_interno_manual);

        INSERT INTO codigo_universal(
          dominio, prefixo_5, sequencia, codigo_interno, barcode, origem_interno,
          id_ffa,id_senha,id_paciente,id_produto,id_usuario,id_cliente,
          status,payload,id_sessao_usuario
        ) VALUES (
          p_dominio, NULL, NULL, v_codigo, v_codigo, 'MANUAL',
          p_id_ffa,p_id_senha,p_id_paciente,p_id_produto,p_id_usuario,p_id_cliente,
          'ATIVO', p_payload, p_id_sessao_usuario
        );

        SET p_id_codigo = LAST_INSERT_ID();
        SET p_codigo_interno = v_codigo;

        CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'CODIGO_INTERNO_EMITIDO', JSON_OBJECT(
          'dominio', p_dominio,
          'modo', 'MANUAL',
          'id_codigo', p_id_codigo,
          'codigo_interno', p_codigo_interno
        ));

        COMMIT;
        LEAVE main;
    END IF;

    -- modo AUTO: resolve prefixo e gera sequencia via protocolo_sequencia (chave = DOMINIO|PREFIXO)
    CALL sp_codigo_prefixo_resolver(p_id_sessao_usuario, p_dominio, p_id_unidade, p_id_local_operacional, p_id_laboratorio, v_prefixo_5);

    SET v_chave_seq = CONCAT('CODIGO|', p_dominio, '|', v_prefixo_5);

    -- garante linha
    INSERT INTO protocolo_sequencia(chave, ultimo_numero)
    VALUES(v_chave_seq, 0)
    ON DUPLICATE KEY UPDATE atualizado_em = CURRENT_TIMESTAMP;

    -- incrementa e trava
    SELECT ultimo_numero INTO v_seq
      FROM protocolo_sequencia
     WHERE chave = v_chave_seq
     FOR UPDATE;

    SET v_seq = v_seq + 1;

    UPDATE protocolo_sequencia
       SET ultimo_numero = v_seq,
           atualizado_em = CURRENT_TIMESTAMP
     WHERE chave = v_chave_seq;

    -- formato NNNNN-0000 (seq com 4 dígitos)
    SET v_codigo = CONCAT(v_prefixo_5, '-', LPAD(v_seq, 4, '0'));

    INSERT INTO codigo_universal(
      dominio, prefixo_5, sequencia, codigo_interno, barcode, origem_interno,
      id_ffa,id_senha,id_paciente,id_produto,id_usuario,id_cliente,
      status,payload,id_sessao_usuario
    ) VALUES (
      p_dominio, v_prefixo_5, v_seq, v_codigo, v_codigo, 'AUTO',
      p_id_ffa,p_id_senha,p_id_paciente,p_id_produto,p_id_usuario,p_id_cliente,
      'ATIVO', p_payload, p_id_sessao_usuario
    );

    SET p_id_codigo = LAST_INSERT_ID();
    SET p_codigo_interno = v_codigo;

    -- também registra em protocolo_emissao para relatórios/compatibilidade
    INSERT INTO protocolo_emissao(tipo, chave, codigo, ano, data_ref, id_sessao_usuario, id_usuario, id_paciente, id_ffa, id_senha, id_cliente, id_codigo_universal)
    VALUES(
      p_dominio,
      v_chave_seq,
      v_codigo,
      YEAR(CURRENT_DATE),
      CURRENT_DATE,
      p_id_sessao_usuario,
      p_id_usuario,
      p_id_paciente,
      p_id_ffa,
      p_id_senha,
      p_id_cliente,
      p_id_codigo
    );

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'CODIGO_INTERNO_EMITIDO', JSON_OBJECT(
      'dominio', p_dominio,
      'modo', 'AUTO',
      'id_codigo', p_id_codigo,
      'codigo_interno', p_codigo_interno,
      'prefixo_5', v_prefixo_5,
      'sequencia', v_seq
    ));

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_codigo_mapear_externo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigo_mapear_externo`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_dominio ENUM('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO'),
    IN  p_sistema_externo VARCHAR(50),
    IN  p_codigo_externo VARCHAR(80),
    IN  p_id_unidade BIGINT,
    IN  p_id_local_operacional BIGINT,
    IN  p_id_laboratorio BIGINT,
    IN  p_codigo_interno_manual VARCHAR(50),
    IN  p_id_ffa BIGINT,
    IN  p_id_senha BIGINT,
    IN  p_id_paciente BIGINT,
    IN  p_id_produto INT,
    IN  p_id_usuario BIGINT,
    IN  p_id_cliente BIGINT,
    IN  p_payload JSON,
    OUT p_id_codigo BIGINT,
    OUT p_codigo_interno VARCHAR(50)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_codigo_existente BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_codigo_mapear_externo', 'Falha ao mapear código externo');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_codigo_mapear_externo | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_sistema_externo IS NOT NULL AND TRIM(p_sistema_externo) <> '', 'PARAM', 'sistema_externo é obrigatório.');
    CALL sp_assert_true(p_codigo_externo IS NOT NULL AND TRIM(p_codigo_externo) <> '', 'PARAM', 'codigo_externo é obrigatório.');

    SET p_id_codigo = NULL;
    SET p_codigo_interno = NULL;

    START TRANSACTION;

    -- se já existe mapeamento, devolve
    SELECT m.id_codigo
      INTO v_id_codigo_existente
      FROM codigo_externo_map m
     WHERE m.dominio = p_dominio
       AND m.sistema_externo = TRIM(p_sistema_externo)
       AND m.codigo_externo = TRIM(p_codigo_externo)
     LIMIT 1
     FOR UPDATE;

    IF v_id_codigo_existente IS NOT NULL THEN
        SELECT c.id_codigo, c.codigo_interno
          INTO p_id_codigo, p_codigo_interno
          FROM codigo_universal c
         WHERE c.id_codigo = v_id_codigo_existente
         LIMIT 1;

        COMMIT;
        LEAVE main;
    END IF;

    -- não existe: cria interno (AUTO ou MANUAL)
    CALL sp_codigo_emitir_interno(
      p_id_sessao_usuario,
      p_dominio,
      p_id_unidade,
      p_id_local_operacional,
      p_id_laboratorio,
      p_codigo_interno_manual,
      p_id_ffa,
      p_id_senha,
      p_id_paciente,
      p_id_produto,
      p_id_usuario,
      p_id_cliente,
      p_payload,
      p_id_codigo,
      p_codigo_interno
    );

    INSERT INTO codigo_externo_map(
      id_codigo, dominio, sistema_externo, codigo_externo, modo_cadastro, observacao, payload, id_sessao_usuario
    ) VALUES (
      p_id_codigo, p_dominio, TRIM(p_sistema_externo), TRIM(p_codigo_externo),
      'MANUAL', NULL, NULL, p_id_sessao_usuario
    );

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'CODIGO_EXTERNO_MAPEADO', JSON_OBJECT(
      'dominio', p_dominio,
      'sistema_externo', TRIM(p_sistema_externo),
      'codigo_externo', TRIM(p_codigo_externo),
      'id_codigo', p_id_codigo,
      'codigo_interno', p_codigo_interno
    ));

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_codigo_prefixo_resolver` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigo_prefixo_resolver`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_tipo              VARCHAR(30),
    IN  p_id_unidade        BIGINT,
    IN  p_id_local_operacional BIGINT,
    OUT p_prefixo5          CHAR(5)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_codigo_prefixo_resolver', 'Falha ao resolver prefixo');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_codigo_prefixo_resolver | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_prefixo5 = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_tipo IS NOT NULL AND CHAR_LENGTH(p_tipo)>0, 'PARAM', 'tipo é obrigatório.');

    START TRANSACTION;

    -- prioridade:
    -- 1) tipo + unidade + local
    -- 2) tipo + unidade
    -- 3) tipo global
    SELECT r.prefixo5
      INTO p_prefixo5
      FROM codigo_prefixo_regra r
     WHERE r.ativo = 1
       AND r.tipo = p_tipo
       AND ((p_id_unidade IS NULL AND r.id_unidade IS NULL) OR r.id_unidade = p_id_unidade)
       AND ((p_id_local_operacional IS NULL AND r.id_local_operacional IS NULL) OR r.id_local_operacional = p_id_local_operacional)
     ORDER BY
       (r.id_unidade IS NOT NULL) DESC,
       (r.id_local_operacional IS NOT NULL) DESC,
       r.id_regra DESC
     LIMIT 1;

    COMMIT;

    CALL sp_assert_true(p_prefixo5 IS NOT NULL, 'PREFIXO', 'Prefixo5 não configurado para este tipo/contexto.');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_codigo_prefixo_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigo_prefixo_set`(
    IN p_id_sessao_usuario BIGINT,
    IN p_dominio ENUM('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO'),
    IN p_prefixo_5 CHAR(5),
    IN p_id_unidade BIGINT,
    IN p_id_local_operacional BIGINT,
    IN p_id_laboratorio BIGINT,
    IN p_ativo TINYINT,
    IN p_observacao VARCHAR(255)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_codigo_prefixo_set', 'Falha ao setar prefixo');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_codigo_prefixo_set | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_prefixo_5 IS NOT NULL AND CHAR_LENGTH(p_prefixo_5)=5, 'PARAM', 'prefixo_5 deve ter 5 caracteres.');

    START TRANSACTION;

    INSERT INTO codigo_prefixo_config(dominio,prefixo_5,id_unidade,id_local_operacional,id_laboratorio,ativo,observacao)
    VALUES(p_dominio,p_prefixo_5,p_id_unidade,p_id_local_operacional,p_id_laboratorio,IFNULL(p_ativo,1),p_observacao)
    ON DUPLICATE KEY UPDATE
      ativo = VALUES(ativo),
      observacao = VALUES(observacao),
      atualizado_em = CURRENT_TIMESTAMP;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'CODIGO_PREFIXO_SET', JSON_OBJECT(
      'dominio', p_dominio,
      'prefixo_5', p_prefixo_5,
      'id_unidade', p_id_unidade,
      'id_local_operacional', p_id_local_operacional,
      'id_laboratorio', p_id_laboratorio,
      'ativo', IFNULL(p_ativo,1)
    ));

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_estoque_movimento_criar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estoque_movimento_criar`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_estoque_local  BIGINT,
    IN  p_tipo              VARCHAR(20),
    IN  p_origem            VARCHAR(40),
    IN  p_destino           VARCHAR(40),
    IN  p_observacao        VARCHAR(255),
    OUT p_id_movimento      BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_estoque_movimento_criar', 'Falha ao criar movimento');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_estoque_movimento_criar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_movimento = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_estoque_local IS NOT NULL, 'PARAM', 'id_estoque_local é obrigatório.');
    CALL sp_assert_true(p_tipo IS NOT NULL, 'PARAM', 'tipo é obrigatório.');

    START TRANSACTION;

    INSERT INTO estoque_movimento (id_estoque_local, tipo, origem, destino, observacao, id_sessao_usuario)
    VALUES (p_id_estoque_local, UPPER(p_tipo), p_origem, p_destino, p_observacao, p_id_sessao_usuario);

    SET p_id_movimento = LAST_INSERT_ID();

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'ESTOQUE_MOV_CRIADO', 'estoque_movimento', p_id_movimento);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_estoque_movimento_item_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estoque_movimento_item_add`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_movimento      BIGINT,
    IN p_id_produto        BIGINT,
    IN p_id_lote           BIGINT,
    IN p_quantidade        DECIMAL(14,3),
    IN p_valor_unitario    DECIMAL(14,4)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_tipo VARCHAR(20);
    DECLARE v_id_local BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_estoque_movimento_item_add', 'Falha ao inserir item movimento');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_estoque_movimento_item_add | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_movimento IS NOT NULL, 'PARAM', 'id_movimento é obrigatório.');
    CALL sp_assert_true(p_id_produto IS NOT NULL, 'PARAM', 'id_produto é obrigatório.');
    CALL sp_assert_true(p_quantidade IS NOT NULL AND p_quantidade <> 0, 'PARAM', 'quantidade inválida.');

    START TRANSACTION;

    SELECT m.tipo, m.id_estoque_local
      INTO v_tipo, v_id_local
      FROM estoque_movimento m
     WHERE m.id_movimento = p_id_movimento
     LIMIT 1;

    CALL sp_assert_true(v_tipo IS NOT NULL, 'MOV', 'Movimento não encontrado.');

    INSERT INTO estoque_movimento_item (id_movimento, id_produto, id_lote, quantidade, valor_unitario)
    VALUES (p_id_movimento, p_id_produto, p_id_lote, p_quantidade, p_valor_unitario);

    -- Atualiza lote (regra simples): ENTRADA soma, SAIDA subtrai, AJUSTE soma/sub conforme sinal
    IF v_tipo = 'ENTRADA' THEN
        UPDATE estoque_lote SET quantidade = quantidade + p_quantidade, atualizado_em = NOW()
         WHERE id_lote = p_id_lote;
    ELSEIF v_tipo = 'SAIDA' THEN
        UPDATE estoque_lote SET quantidade = quantidade - p_quantidade, atualizado_em = NOW()
         WHERE id_lote = p_id_lote;
    ELSE
        UPDATE estoque_lote SET quantidade = quantidade + p_quantidade, atualizado_em = NOW()
         WHERE id_lote = p_id_lote;
    END IF;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'ESTOQUE_MOV_ITEM_ADD', 'estoque_movimento_item', LAST_INSERT_ID());

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_estoque_produto_criar_com_codigo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estoque_produto_criar_com_codigo`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_nome              VARCHAR(255),
    IN  p_categoria         VARCHAR(120),
    IN  p_exige_receita     TINYINT,
    IN  p_controlado        TINYINT,
    OUT p_id_produto        BIGINT,
    OUT p_sku               VARCHAR(60),
    OUT p_barcode           VARCHAR(60)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_prefixo5 CHAR(5);

    DECLARE v_id_codigo BIGINT;
    DECLARE v_codigo VARCHAR(60);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_estoque_produto_criar_com_codigo', 'Falha ao criar produto');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_estoque_produto_criar_com_codigo | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_produto = NULL;
    SET p_sku = NULL;
    SET p_barcode = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_nome IS NOT NULL AND CHAR_LENGTH(p_nome)>1, 'PARAM', 'nome é obrigatório.');

    START TRANSACTION;

    SET v_id_unidade = NULL;
    SET v_id_local   = NULL;
    SELECT su.id_unidade, su.id_local_operacional
      INTO v_id_unidade, v_id_local
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
     LIMIT 1;

    CALL sp_codigo_prefixo_resolver(p_id_sessao_usuario, 'FARM_PRODUTO', v_id_unidade, v_id_local, v_prefixo5);

    CALL sp_codigo_emitir_interno(
        p_id_sessao_usuario,
        'FARM_PRODUTO',
        v_prefixo5,
        NULL, NULL, NULL,
        NULL,
        NULL, NULL, NULL, NULL, NULL,
        NULL,
        @out_id_codigo,
        @out_codigo_interno,
        @out_barcode
    );

    SET v_id_codigo = @out_id_codigo;
    SET v_codigo    = @out_codigo_interno;

    INSERT INTO estoque_produto (
        id_codigo_universal, sku_interno, barcode,
        nome, categoria, exige_receita, controlado, ativo
    ) VALUES (
        v_id_codigo, v_codigo, v_codigo,
        p_nome, p_categoria, IFNULL(p_exige_receita,0), IFNULL(p_controlado,0), 1
    );

    SET p_id_produto = LAST_INSERT_ID();
    SET p_sku = v_codigo;
    SET p_barcode = v_codigo;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'PRODUTO_CRIADO', 'estoque_produto', p_id_produto);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_estoque_produto_set_codigo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estoque_produto_set_codigo`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_produto INT,
    IN p_id_unidade BIGINT,
    IN p_id_local_operacional BIGINT,
    IN p_gtin_ean VARCHAR(30),
    IN p_codigo_interno_manual VARCHAR(50)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_codigo BIGINT;
    DECLARE v_codigo_interno VARCHAR(50);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_estoque_produto_set_codigo', 'Falha ao setar código produto');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_estoque_produto_set_codigo | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_produto IS NOT NULL, 'PARAM', 'id_produto é obrigatório.');

    START TRANSACTION;

    -- atualiza GTIN/EAN se vier
    IF p_gtin_ean IS NOT NULL AND TRIM(p_gtin_ean) <> '' THEN
      UPDATE estoque_produtos
         SET gtin_ean = TRIM(p_gtin_ean),
             codigo_ean = COALESCE(codigo_ean, TRIM(p_gtin_ean)),
             atualizado_em = CURRENT_TIMESTAMP
       WHERE id = p_id_produto;
    END IF;

    -- gera/usa interno (domínio ESTOQUE)
    CALL sp_codigo_emitir_interno(
      p_id_sessao_usuario,
      'ESTOQUE',
      p_id_unidade,
      p_id_local_operacional,
      NULL,
      p_codigo_interno_manual,
      NULL,
      NULL,
      NULL,
      p_id_produto,
      NULL,
      NULL,
      JSON_OBJECT('produto_id', p_id_produto),
      v_id_codigo,
      v_codigo_interno
    );

    UPDATE estoque_produtos
       SET codigo_interno = v_codigo_interno,
           barcode_interno = v_codigo_interno,
           atualizado_em = CURRENT_TIMESTAMP
     WHERE id = p_id_produto;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'ESTOQUE_PRODUTO_CODIGO_SET', JSON_OBJECT(
      'id_produto', p_id_produto,
      'gtin_ean', NULLIF(TRIM(p_gtin_ean),''),
      'codigo_interno', v_codigo_interno,
      'id_codigo', v_id_codigo
    ));

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_farm_dispensacao_criar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farm_dispensacao_criar`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_ffa            BIGINT,
    IN  p_id_estoque_local  BIGINT,
    IN  p_id_usuario_farmacia BIGINT,
    OUT p_id_dispensacao    BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_gpat BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_farm_dispensacao_criar', 'Falha ao criar dispensação');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_farm_dispensacao_criar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_dispensacao = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa é obrigatório.');
    CALL sp_assert_true(p_id_estoque_local IS NOT NULL, 'PARAM', 'id_estoque_local é obrigatório.');

    START TRANSACTION;

    SELECT f.id_gpat INTO v_id_gpat
      FROM ffa f
     WHERE f.id = p_id_ffa
     LIMIT 1;

    CALL sp_assert_true(v_id_gpat IS NOT NULL, 'GPAT', 'FFA sem GPAT.');

    INSERT INTO farm_dispensacao (id_ffa, id_gpat, id_estoque_local, status, id_usuario_farmacia)
    VALUES (p_id_ffa, v_id_gpat, p_id_estoque_local, 'ABERTA', p_id_usuario_farmacia);

    SET p_id_dispensacao = LAST_INSERT_ID();

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'FARM_DISP_CRIADA', 'farm_dispensacao', p_id_dispensacao);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_ffa_gpat_garantir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_gpat_garantir`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa            BIGINT,
    IN p_tipo_prefixo      VARCHAR(30) -- normalmente 'GPAT'
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_gpat BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_prefixo5 CHAR(5);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_ffa_gpat_garantir', 'Falha ao garantir GPAT');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_ffa_gpat_garantir | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa (ffa.id) é obrigatório.');

    START TRANSACTION;

    SELECT f.id_gpat INTO v_id_gpat
      FROM ffa f
     WHERE f.id = p_id_ffa
     LIMIT 1;

    IF v_id_gpat IS NOT NULL THEN
        COMMIT;
        LEAVE main;
    END IF;

    -- tenta pegar contexto da sessão (se existir)
    SET v_id_unidade = NULL;
    SET v_id_local   = NULL;
    SELECT su.id_unidade, su.id_local_operacional
      INTO v_id_unidade, v_id_local
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
     LIMIT 1;

    CALL sp_codigo_prefixo_resolver(p_id_sessao_usuario, IFNULL(p_tipo_prefixo,'GPAT'), v_id_unidade, v_id_local, v_prefixo5);

    -- chama SP canônica do pack 70–85 (já existente)
    CALL sp_ffa_gpat_gerar(p_id_sessao_usuario, p_id_ffa, v_prefixo5);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_ffa_gpat_gerar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_gpat_gerar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa            BIGINT,  -- referencia ffa.id
    IN p_prefixo_5         CHAR(5)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_codigo BIGINT;
    DECLARE v_codigo VARCHAR(50);
    DECLARE v_barcode VARCHAR(60);
    DECLARE v_id_gpat BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_ffa_gpat_gerar', 'Falha ao gerar GPAT');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_ffa_gpat_gerar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa (ffa.id) é obrigatório.');
    CALL sp_assert_true(p_prefixo_5 IS NOT NULL AND CHAR_LENGTH(p_prefixo_5)=5, 'PARAM', 'prefixo_5 deve ter 5 dígitos.');

    START TRANSACTION;

    SELECT f.id_gpat INTO v_id_gpat
      FROM ffa f
     WHERE f.id = p_id_ffa
     LIMIT 1;

    IF v_id_gpat IS NOT NULL THEN
        COMMIT;
        LEAVE main;
    END IF;

    -- Depende do teu pack 60-70: sp_codigo_emitir_interno
    CALL sp_codigo_emitir_interno(
        p_id_sessao_usuario,
        'GPAT',
        p_prefixo_5,
        NULL, NULL, NULL,
        p_id_ffa,
        NULL, NULL, NULL, NULL, NULL,
        NULL,
        @out_id_codigo,
        @out_codigo_interno,
        @out_barcode
    );

    SET v_id_codigo = @out_id_codigo;
    SET v_codigo    = @out_codigo_interno;
    SET v_barcode   = @out_barcode;

    INSERT INTO gpat (id_ffa, id_codigo_universal, codigo_gpat, barcode_gpat, origem)
    VALUES (p_id_ffa, v_id_codigo, v_codigo, v_barcode, 'AUTO');

    SET v_id_gpat = LAST_INSERT_ID();

    UPDATE ffa
       SET id_gpat = v_id_gpat
     WHERE id = p_id_ffa;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'GPAT_GERADO', 'gpat', v_id_gpat);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fila_chamar_proxima` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fila_chamar_proxima`(IN p_id_sessao_usuario BIGINT,
    IN p_tipo_fila VARCHAR(20),
    IN p_id_local_operacional BIGINT,
    OUT p_id_fila BIGINT,
    OUT p_id_ffa BIGINT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_local_sessao BIGINT;
    DECLARE v_id_local BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_fila_chamar_proxima', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_fila_chamar_proxima | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;


    SET p_id_fila = NULL;
    SET p_id_ffa  = NULL;

    CALL sp_assert_true(p_tipo_fila IS NOT NULL AND p_tipo_fila <> '', 'PARAM', 'tipo_fila é obrigatório.');

    SELECT su.id_usuario, su.id_local_operacional
      INTO v_id_usuario, v_id_local_sessao
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    SET v_id_local = IFNULL(p_id_local_operacional, v_id_local_sessao);
    CALL sp_assert_true(v_id_local IS NOT NULL, 'PARAM', 'Local operacional não definido.');

    SELECT fo.id_fila, fo.id_ffa
      INTO p_id_fila, p_id_ffa
      FROM fila_operacional fo
     WHERE fo.tipo = p_tipo_fila
       AND fo.substatus = 'AGUARDANDO'
       AND fo.id_local_operacional = v_id_local
     ORDER BY
       FIELD(fo.prioridade,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
       fo.data_entrada ASC,
       fo.id_fila ASC
     LIMIT 1
     FOR UPDATE;

    CALL sp_assert_true(p_id_fila IS NOT NULL, 'FILA', 'Nenhum item aguardando para este tipo/local.');

    UPDATE fila_operacional
       SET substatus = 'EM_EXECUCAO',
           data_inicio = IFNULL(data_inicio, NOW()),
           id_responsavel = v_id_usuario
     WHERE id_fila = p_id_fila;

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'CHAMAR', CONCAT('tipo=', p_tipo_fila, ' | local=', v_id_local), NOW());
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fila_finalizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fila_finalizar`(IN p_id_sessao_usuario BIGINT,
    IN p_id_fila BIGINT,
    IN p_detalhe VARCHAR(255))
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_fila_finalizar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_fila_finalizar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');
    UPDATE fila_operacional
       SET substatus = 'FINALIZADO',
           data_fim = NOW()
     WHERE id_fila = p_id_fila;
    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'FINALIZAR', p_detalhe, NOW());
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fila_tipo_por_local` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fila_tipo_por_local`(IN p_id_sessao_usuario BIGINT,
    IN p_id_local_operacional BIGINT,
    OUT p_tipo_fila VARCHAR(20))
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE v_tipo_local VARCHAR(40);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_fila_tipo_por_local', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_fila_tipo_por_local | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    SET p_tipo_fila = NULL;
    CALL sp_assert_true(p_id_local_operacional IS NOT NULL, 'PARAM', 'id_local_operacional é obrigatório.');
    SELECT lo.tipo INTO v_tipo_local
      FROM local_operacional lo
     WHERE lo.id_local_operacional = p_id_local_operacional
     LIMIT 1;
    CALL sp_assert_true(v_tipo_local IS NOT NULL, 'LOCAL', 'Local operacional não encontrado.');
    SET p_tipo_fila = CASE
        WHEN v_tipo_local = 'TRIAGEM' THEN 'TRIAGEM'
        WHEN v_tipo_local IN ('MEDICO_CLINICO','MEDICO_PEDIATRICO') THEN 'MEDICO'
        WHEN v_tipo_local = 'MEDICACAO' THEN 'MEDICACAO'
        WHEN v_tipo_local = 'RX' THEN 'RX'
        WHEN v_tipo_local = 'ECG' THEN 'ECG'
        WHEN v_tipo_local = 'OBSERVACAO' THEN 'OBSERVACAO'
        WHEN v_tipo_local IN ('LABORATORIO') THEN 'EXAME'
        ELSE 'PROCEDIMENTO'
    END;
    COMMIT;
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_ecg`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_resultado         TEXT
)
BEGIN
    CALL sp_finalizar_procedimento_geral(p_id_sessao_usuario, p_id_fila, p_resultado);
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_geral`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_resultado         TEXT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_id_usuario BIGINT;
    DECLARE v_tipo_fila ENUM('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO');
    DECLARE v_tipo_proto ENUM('EXAME','RX');
    DECLARE v_id_protocolo BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_finalizar_procedimento_geral', 'Falha ao finalizar procedimento');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_finalizar_procedimento_geral | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    START TRANSACTION;

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    SELECT fo.tipo INTO v_tipo_fila
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1;

    CALL sp_assert_true(v_tipo_fila IS NOT NULL, 'FILA', 'Fila operacional não encontrada.');

    UPDATE fila_operacional
       SET substatus = 'FINALIZADO',
           data_fim = NOW(),
           observacao = COALESCE(p_resultado, observacao),
           id_responsavel = COALESCE(id_responsavel, v_id_usuario)
     WHERE id_fila = p_id_fila;

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'FINALIZADO', CONCAT('Finalizado | Tipo=',v_tipo_fila), NOW());

    -- Se for EXAME/RX, fecha protocolo
    IF v_tipo_fila IN ('EXAME','RX') THEN
        SET v_tipo_proto = IF(v_tipo_fila='RX','RX','EXAME');

        SELECT pp.id_protocolo INTO v_id_protocolo
          FROM procedimento_protocolo pp
         WHERE pp.id_fila = p_id_fila
           AND pp.tipo = v_tipo_proto
         LIMIT 1;

        IF v_id_protocolo IS NOT NULL THEN
            UPDATE procedimento_protocolo
               SET status = 'FINALIZADO',
                   atualizado_em = NOW()
             WHERE id_protocolo = v_id_protocolo;

            INSERT INTO procedimento_protocolo_evento(id_protocolo, tipo_evento, detalhe, criado_em, id_sessao_usuario, id_usuario)
            VALUES (v_id_protocolo, 'FINALIZADO', LEFT(COALESCE(p_resultado,'(sem resultado)'), 2000), NOW(), p_id_sessao_usuario, v_id_usuario);
        END IF;
    END IF;

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'fila_operacional',
        p_id_fila,
        'PROCEDIMENTO_FINALIZADO',
        CONCAT('Finalizado | Tipo=',v_tipo_fila),
        NULL,
        'fila_operacional',
        v_id_usuario
    );

    COMMIT;
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_laboratorio`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_resultado         TEXT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_id_ffa BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_finalizar_procedimento_laboratorio', 'Falha ao finalizar laboratório');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_finalizar_procedimento_laboratorio | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    START TRANSACTION;

    SELECT fo.id_ffa INTO v_id_ffa
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1;

    CALL sp_assert_true(v_id_ffa IS NOT NULL, 'FILA', 'Fila operacional não encontrada.');

    -- finaliza a fila e o protocolo EXAME (se existir)
    CALL sp_finalizar_procedimento_geral(p_id_sessao_usuario, p_id_fila, p_resultado);

    -- marca lab como concluído (se existir amostra)
    UPDATE lab_protocolo_interno
       SET status_laboratorial = 'CONCLUIDO'
     WHERE id_ffa = v_id_ffa
       AND (status_laboratorial IS NULL OR status_laboratorial <> 'CONCLUIDO');

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gera_protocolo_lab` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gera_protocolo_lab`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_pedido_item    BIGINT,
    IN  p_sistema_externo   VARCHAR(50),   -- opcional
    IN  p_codigo_externo    VARCHAR(80),   -- opcional
    OUT p_codigo            VARCHAR(60),
    OUT p_barcode           VARCHAR(60)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_pedido BIGINT;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_id_gpat BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_unidade BIGINT;

    DECLARE v_prefixo5 CHAR(5);
    DECLARE v_id_codigo BIGINT;
    DECLARE v_codigo VARCHAR(60);
    DECLARE v_barcode VARCHAR(60);
    DECLARE v_id_proto BIGINT;

    DECLARE v_tipo_item VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_gera_protocolo_lab', 'Falha ao gerar protocolo LAB');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_gera_protocolo_lab | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_codigo  = NULL;
    SET p_barcode = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_pedido_item IS NOT NULL, 'PARAM', 'id_pedido_item é obrigatório.');

    START TRANSACTION;

    -- evita duplicidade
    SELECT lp.codigo, lp.barcode
      INTO p_codigo, p_barcode
      FROM laboratorio_protocolo lp
     WHERE lp.id_pedido_item = p_id_pedido_item
     LIMIT 1;

    IF p_codigo IS NOT NULL THEN
        COMMIT;
        LEAVE main;
    END IF;

    SELECT i.id_pedido_medico, i.tipo_item
      INTO v_id_pedido, v_tipo_item
      FROM pedido_medico_item i
     WHERE i.id_pedido_item = p_id_pedido_item
     LIMIT 1;

    CALL sp_assert_true(v_id_pedido IS NOT NULL, 'LAB', 'Item do pedido não encontrado.');
    -- regra: exame/procedimento gera protocolo lab; se quiser liberar outros, muda aqui
    CALL sp_assert_true(v_tipo_item IN ('EXAME','PROCEDIMENTO'), 'LAB', 'Item não é EXAME/PROCEDIMENTO.');

    SELECT p.id_ffa, p.id_gpat, p.id_local_operacional
      INTO v_id_ffa, v_id_gpat, v_id_local
      FROM pedido_medico p
     WHERE p.id_pedido_medico = v_id_pedido
     LIMIT 1;

    CALL sp_assert_true(v_id_ffa IS NOT NULL, 'LAB', 'Pedido sem id_ffa.');
    CALL sp_assert_true(v_id_gpat IS NOT NULL, 'LAB', 'Pedido sem GPAT. Garanta GPAT antes.');

    -- garantir GPAT na FFA (se alguém criou pedido errado no futuro)
    CALL sp_ffa_gpat_garantir(p_id_sessao_usuario, v_id_ffa, 'GPAT');

    -- resolve unidade/local via sessão (padrão), com fallback no local do pedido
    SET v_id_unidade = NULL;
    SELECT su.id_unidade
      INTO v_id_unidade
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
     LIMIT 1;

    CALL sp_codigo_prefixo_resolver(p_id_sessao_usuario, 'LAB', v_id_unidade, v_id_local, v_prefixo5);

    -- emite código interno (código + barcode). Regra: barcode = código.
    CALL sp_codigo_emitir_interno(
        p_id_sessao_usuario,
        'LAB',
        v_prefixo5,
        NULL, NULL, NULL,
        v_id_ffa,
        NULL, NULL, NULL, NULL, NULL,
        NULL,
        @out_id_codigo,
        @out_codigo_interno,
        @out_barcode
    );

    SET v_id_codigo = @out_id_codigo;
    SET v_codigo    = @out_codigo_interno;
    SET v_barcode   = @out_codigo_interno; -- força bater com o código humano (regra do projeto)

    INSERT INTO laboratorio_protocolo (
        id_ffa, id_gpat, id_pedido_item, id_codigo_universal,
        codigo, barcode, status,
        sistema_externo, codigo_externo
    ) VALUES (
        v_id_ffa, v_id_gpat, p_id_pedido_item, v_id_codigo,
        v_codigo, v_barcode, 'GERADO',
        p_sistema_externo, p_codigo_externo
    );

    SET v_id_proto = LAST_INSERT_ID();

    -- atualiza o item do pedido com o vínculo
    UPDATE pedido_medico_item
       SET id_codigo_universal = v_id_codigo,
           sistema_externo     = p_sistema_externo,
           codigo_externo      = p_codigo_externo,
           atualizado_em       = NOW()
     WHERE id_pedido_item = p_id_pedido_item;

    -- vinculo externo opcional (quando informado)
    IF p_sistema_externo IS NOT NULL AND p_codigo_externo IS NOT NULL THEN
        INSERT INTO codigo_externo_vinculo (tipo, sistema_externo, codigo_externo, id_codigo_universal, id_sessao_usuario, observacao)
        VALUES ('LAB', p_sistema_externo, p_codigo_externo, v_id_codigo, p_id_sessao_usuario, 'Protocolo LAB mapeado');
    END IF;

    INSERT INTO laboratorio_protocolo_evento (id_laboratorio_protocolo, id_sessao_usuario, evento, detalhe, payload_json)
    VALUES (v_id_proto, p_id_sessao_usuario, 'GERADO', NULL,
            JSON_OBJECT('id_pedido_item', p_id_pedido_item, 'codigo', v_codigo, 'barcode', v_barcode));

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'LAB_PROTOCOLO_GERADO', 'laboratorio_protocolo', v_id_proto);

    SET p_codigo  = v_codigo;
    SET p_barcode = v_barcode;

    COMMIT;
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_execucao_procedimento_rx`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_id_usuario BIGINT;
    DECLARE v_tipo ENUM('EXAME','RX');
    DECLARE v_dummy_id BIGINT;
    DECLARE v_codigo VARCHAR(50);
    DECLARE v_barcode VARCHAR(50);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_iniciar_execucao_procedimento_rx', 'Falha ao iniciar RX');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_iniciar_execucao_procedimento_rx | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    START TRANSACTION;

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    -- garante que a fila é RX
    CALL sp_assert_true(
        (SELECT fo.tipo FROM fila_operacional fo WHERE fo.id_fila = p_id_fila LIMIT 1) = 'RX',
        'FILA',
        'Fila informada não é RX.'
    );

    -- cria protocolo RX se necessário
    SET v_tipo = 'RX';
    CALL sp_procedimento_protocolo_criar(p_id_sessao_usuario, p_id_fila, v_tipo, v_dummy_id, v_codigo, v_barcode);

    UPDATE fila_operacional
       SET substatus = 'EM_EXECUCAO',
           data_inicio = COALESCE(data_inicio, NOW()),
           id_responsavel = v_id_usuario
     WHERE id_fila = p_id_fila;

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'INICIO_EXECUCAO', CONCAT('RX iniciado | Protocolo=',COALESCE(v_codigo,'(n/a)')), NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'fila_operacional',
        p_id_fila,
        'RX_INICIADO',
        CONCAT('Fila RX iniciada | Protocolo=',COALESCE(v_codigo,'(n/a)')),
        NULL,
        'fila_operacional',
        v_id_usuario
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_laboratorio_protocolo_evento_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_laboratorio_protocolo_evento_add`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_laboratorio_protocolo BIGINT,
    IN p_evento VARCHAR(40),
    IN p_detalhe VARCHAR(255),
    IN p_payload JSON
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_laboratorio_protocolo_evento_add', 'Falha ao registrar evento LAB');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_laboratorio_protocolo_evento_add | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_laboratorio_protocolo IS NOT NULL, 'PARAM', 'id_laboratorio_protocolo é obrigatório.');
    CALL sp_assert_true(p_evento IS NOT NULL AND CHAR_LENGTH(p_evento)>0, 'PARAM', 'evento é obrigatório.');

    START TRANSACTION;

    INSERT INTO laboratorio_protocolo_evento (id_laboratorio_protocolo, id_sessao_usuario, evento, detalhe, payload_json)
    VALUES (p_id_laboratorio_protocolo, p_id_sessao_usuario, UPPER(p_evento), p_detalhe, p_payload);

    SET v_status = NULL;
    SET v_status = CASE UPPER(p_evento)
        WHEN 'GERADO'   THEN 'GERADO'
        WHEN 'COLETADO' THEN 'COLETADO'
        WHEN 'ENVIADO'  THEN 'ENVIADO'
        WHEN 'RECEBIDO' THEN 'RECEBIDO'
        WHEN 'RESULTADO'THEN 'RESULTADO'
        WHEN 'CANCELADO'THEN 'CANCELADO'
        ELSE NULL
    END;

    IF v_status IS NOT NULL THEN
        UPDATE laboratorio_protocolo
           SET status = v_status,
               atualizado_em = NOW()
         WHERE id_laboratorio_protocolo = p_id_laboratorio_protocolo;
    END IF;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, CONCAT('LAB_PROTOCOLO_', UPPER(p_evento)), 'laboratorio_protocolo', p_id_laboratorio_protocolo);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_lab_protocolo_criar_ou_mapear` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_lab_protocolo_criar_ou_mapear`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_ffa BIGINT,
    IN  p_id_unidade BIGINT,
    IN  p_id_local_operacional BIGINT,
    IN  p_id_laboratorio BIGINT,
    IN  p_sistema_externo VARCHAR(50),
    IN  p_codigo_externo VARCHAR(80),
    IN  p_codigo_interno_manual VARCHAR(50),
    IN  p_tipo_material VARCHAR(50),
    OUT p_id_lab_protocolo BIGINT,
    OUT p_codigo_amostra VARCHAR(50)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_codigo BIGINT;
    DECLARE v_codigo_interno VARCHAR(50);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_lab_protocolo_criar_ou_mapear', 'Falha lab protocolo');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_lab_protocolo_criar_ou_mapear | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa é obrigatório.');

    SET p_id_lab_protocolo = NULL;
    SET p_codigo_amostra = NULL;

    START TRANSACTION;

    -- 1) resolve/cria código (com externo se vier)
    IF p_sistema_externo IS NOT NULL AND TRIM(p_sistema_externo) <> '' AND p_codigo_externo IS NOT NULL AND TRIM(p_codigo_externo) <> '' THEN
      CALL sp_codigo_mapear_externo(
        p_id_sessao_usuario,
        'LAB',
        p_sistema_externo,
        p_codigo_externo,
        p_id_unidade,
        p_id_local_operacional,
        p_id_laboratorio,
        p_codigo_interno_manual,
        p_id_ffa,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        JSON_OBJECT('tipo_material', p_tipo_material),
        v_id_codigo,
        v_codigo_interno
      );
    ELSE
      CALL sp_codigo_emitir_interno(
        p_id_sessao_usuario,
        'LAB',
        p_id_unidade,
        p_id_local_operacional,
        p_id_laboratorio,
        p_codigo_interno_manual,
        p_id_ffa,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        JSON_OBJECT('tipo_material', p_tipo_material),
        v_id_codigo,
        v_codigo_interno
      );
    END IF;

    -- 2) garante registro lab_protocolo_interno (1 por FFA por padrão; se quiser múltiplas amostras, muda regra depois)
    SELECT id, codigo_amostra
      INTO p_id_lab_protocolo, p_codigo_amostra
      FROM lab_protocolo_interno
     WHERE id_ffa = p_id_ffa
     LIMIT 1
     FOR UPDATE;

    IF p_id_lab_protocolo IS NULL THEN
      INSERT INTO lab_protocolo_interno(
        id_ffa, codigo_amostra, barcode, tipo_material, status_laboratorial, impresso,
        id_codigo_universal, sistema_externo, codigo_externo, coletado_em
      ) VALUES (
        p_id_ffa, v_codigo_interno, v_codigo_interno, p_tipo_material, 'COLETADO', 0,
        v_id_codigo,
        NULLIF(TRIM(p_sistema_externo),''),
        NULLIF(TRIM(p_codigo_externo),''),
        CURRENT_TIMESTAMP
      );
      SET p_id_lab_protocolo = LAST_INSERT_ID();
      SET p_codigo_amostra = v_codigo_interno;
    ELSE
      UPDATE lab_protocolo_interno
         SET codigo_amostra = v_codigo_interno,
             barcode = v_codigo_interno,
             tipo_material = COALESCE(p_tipo_material, tipo_material),
             id_codigo_universal = v_id_codigo,
             sistema_externo = NULLIF(TRIM(p_sistema_externo),''),
             codigo_externo  = NULLIF(TRIM(p_codigo_externo),''),
             atualizado_em = CURRENT_TIMESTAMP
       WHERE id = p_id_lab_protocolo;
      SET p_codigo_amostra = v_codigo_interno;
    END IF;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'LAB_PROTOCOLO_CRIADO', JSON_OBJECT(
      'id_ffa', p_id_ffa,
      'id_lab_protocolo', p_id_lab_protocolo,
      'id_codigo', v_id_codigo,
      'codigo_amostra', p_codigo_amostra,
      'sistema_externo', NULLIF(TRIM(p_sistema_externo),''),
      'codigo_externo', NULLIF(TRIM(p_codigo_externo),'')
    ));

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_local_operacional_seed_padrao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`pa_owner`@`%` PROCEDURE `sp_local_operacional_seed_padrao`(
    IN p_id_unidade BIGINT,
    IN p_id_sistema BIGINT
)
BEGIN
    -- UPSERT helper: atualiza sala somente se estiver NULL/vazia
    -- Observação: este seed é "vendável" (códigos canônicos) e pode ser reexecutado.

    -- ========== RECEPÇÃO (guichês) ==========
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'REC01','Recepção - Guichê 1','RECEPCAO','1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'REC02','Recepção - Guichê 2','RECEPCAO','2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'REC03','Recepção - Guichê 3','RECEPCAO','3',1,1,1,0),
      (p_id_unidade,p_id_sistema,'REC04','Recepção - Guichê 4','RECEPCAO','4',1,1,1,0),
      (p_id_unidade,p_id_sistema,'RECEPCAO_ND','[NAO DEFINIDA] RECEPÇÃO','RECEPCAO',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

    -- ========== TRIAGEM (salas) ==========
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'TRI01','Triagem - Sala 1','TRIAGEM','1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'TRI02','Triagem - Sala 2','TRIAGEM','2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'TRI03','Triagem - Sala 3','TRIAGEM','3',1,1,1,0),
      (p_id_unidade,p_id_sistema,'TRI04','Triagem - Sala 4','TRIAGEM','4',1,1,1,0),
      (p_id_unidade,p_id_sistema,'TRIAGEM_ND','[NAO DEFINIDA] TRIAGEM','TRIAGEM',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

    -- ========== MÉDICO CLÍNICO ==========
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'CLI01','Clínico - Sala 1','MEDICO_CLINICO','1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'CLI02','Clínico - Sala 2','MEDICO_CLINICO','2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'CLI03','Clínico - Sala 3','MEDICO_CLINICO','3',1,1,1,0),
      (p_id_unidade,p_id_sistema,'CLI04','Clínico - Sala 4','MEDICO_CLINICO','4',1,1,1,0),
      (p_id_unidade,p_id_sistema,'CLI05','Clínico - Sala 5','MEDICO_CLINICO','5',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDICO_CLINICO_ND','[NAO DEFINIDA] CLÍNICO','MEDICO_CLINICO',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

    -- ========== MÉDICO PEDIÁTRICO ==========
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'PED01','Pediatria - Sala 1','MEDICO_PEDIATRICO','1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'PED02','Pediatria - Sala 2','MEDICO_PEDIATRICO','2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'PED03','Pediatria - Sala 3','MEDICO_PEDIATRICO','3',1,1,1,0),
      (p_id_unidade,p_id_sistema,'PED04','Pediatria - Sala 4','MEDICO_PEDIATRICO','4',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDICO_PEDIATRICO_ND','[NAO DEFINIDA] PEDIATRIA','MEDICO_PEDIATRICO',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

    -- ========== MEDICAÇÃO (ADULTO) ==========
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'MED01','Medicação - Sala 1','MEDICACAO','1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MED02','Medicação - Sala 2','MEDICACAO','2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MED03','Medicação - Sala 3','MEDICACAO','3',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MED04','Medicação - Sala 4','MEDICACAO','4',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDICACAO_ND','[NAO DEFINIDA] MEDICAÇÃO','MEDICACAO',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

    
    -- ========== MEDICAÇÃO (PEDIÁTRICA / ALA INFANTIL) ==========
    -- Observação: usamos códigos MEDPxx para diferenciar ala/painel; o tipo permanece MEDICACAO (enum canônico).
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'MEDP01','Medicação Pediátrica - Sala 1','MEDICACAO','P1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDP02','Medicação Pediátrica - Sala 2','MEDICACAO','P2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDP03','Medicação Pediátrica - Sala 3','MEDICACAO','P3',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDP04','Medicação Pediátrica - Sala 4','MEDICACAO','P4',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDICACAO_PEDI_ND','[NAO DEFINIDA] MEDICAÇÃO PEDIÁTRICA','MEDICACAO',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

-- ========== RX ==========
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'RX01','Raio-X - Sala 1','RX','1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'RX02','Raio-X - Sala 2','RX','2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'RX_ND','[NAO DEFINIDA] RAIO-X','RX',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medicacao_cancelar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_cancelar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_motivo            TEXT
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_tipo VARCHAR(20);
    DECLARE v_id_ffa BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medicacao_cancelar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medicacao_cancelar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)')
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    SELECT fo.tipo, fo.id_ffa
      INTO v_tipo, v_id_ffa
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1
     FOR UPDATE;

    CALL sp_assert_true(v_tipo IS NOT NULL, 'NAO_ENCONTRADO', 'Fila não encontrada.');
    CALL sp_assert_true(v_tipo = 'MEDICACAO', 'REGRA', 'Fila informada não é MEDICACAO.');

    UPDATE fila_operacional
       SET substatus     = 'CANCELADO',
           data_fim      = NOW(),
           id_responsavel= NULL,
           observacao    = CASE
                             WHEN p_motivo IS NULL OR p_motivo = '' THEN observacao
                             WHEN observacao IS NULL OR observacao = '' THEN p_motivo
                             ELSE CONCAT(observacao, '\n', p_motivo)
                           END
     WHERE id_fila = p_id_fila;

    -- se existir reavaliação pendente, cancela
    UPDATE medicacao_reavaliacao
       SET status = 'CANCELADO',
           executado_em = NOW()
     WHERE id_fila_medicacao = p_id_fila
       AND status IN ('PENDENTE','EM_EXECUCAO');

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'CANCELAR', CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa), NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'CANCELAR',
        CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa),
        NULL,
        'fila_operacional',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medicacao_chamar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_chamar`(IN p_id_sessao_usuario BIGINT,
        IN p_id_local_operacional BIGINT,
        OUT p_id_fila BIGINT,
        OUT p_id_ffa BIGINT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medicacao_chamar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medicacao_chamar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_fila_chamar_proxima(p_id_sessao_usuario, 'MEDICACAO', p_id_local_operacional, p_id_fila, p_id_ffa);
    UPDATE senhas s
    JOIN ffa f ON f.id_senha = s.id
       SET s.status = 'CHAMANDO',
           s.id_usuario_chamada = (SELECT su.id_usuario FROM sessao_usuario su WHERE su.id_sessao_usuario = p_id_sessao_usuario LIMIT 1),
           s.chamada_em = NOW()
     WHERE f.id = p_id_ffa;

    INSERT INTO senha_eventos(id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em)
    SELECT p_id_sessao_usuario, f.id_senha, 'CHAMAR_SETOR',
           CONCAT('setor=MEDICACAO | id_fila=', p_id_fila),
           NULL, 'CHAMANDO', NOW()
      FROM ffa f
     WHERE f.id = p_id_ffa
       AND f.id_senha IS NOT NULL;

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'CHAMAR',
        CONCAT('setor=MEDICACAO | id_ffa=', p_id_ffa),
        NULL,
        'fila_operacional',
        NULL
    );
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medicacao_complementar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_complementar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_texto             TEXT
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_tipo VARCHAR(20);
    DECLARE v_id_ffa BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medicacao_complementar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medicacao_complementar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)')
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    SELECT fo.tipo, fo.id_ffa
      INTO v_tipo, v_id_ffa
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1
     FOR UPDATE;

    CALL sp_assert_true(v_tipo IS NOT NULL, 'NAO_ENCONTRADO', 'Fila não encontrada.');
    CALL sp_assert_true(v_tipo = 'MEDICACAO', 'REGRA', 'Fila informada não é MEDICACAO.');

    UPDATE fila_operacional
       SET observacao = CASE
                          WHEN p_texto IS NULL OR p_texto = '' THEN observacao
                          WHEN observacao IS NULL OR observacao = '' THEN p_texto
                          ELSE CONCAT(observacao, '\n', p_texto)
                        END
     WHERE id_fila = p_id_fila;

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'COMPLEMENTAR', CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa), NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'COMPLEMENTAR',
        CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa),
        NULL,
        'fila_operacional',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medicacao_em_execucao_obs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_em_execucao_obs`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_previsto_em       DATETIME,
    IN p_observacao        TEXT
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_tipo VARCHAR(20);
    DECLARE v_id_ffa BIGINT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_local_operacional BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medicacao_em_execucao_obs', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medicacao_em_execucao_obs | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)')
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');
    CALL sp_assert_true(p_previsto_em IS NOT NULL, 'PARAM', 'previsto_em é obrigatório.');

    SELECT su.id_usuario, su.id_local_operacional
      INTO v_id_usuario, v_id_local_operacional
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    SELECT fo.tipo, fo.id_ffa
      INTO v_tipo, v_id_ffa
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1
     FOR UPDATE;

    CALL sp_assert_true(v_tipo IS NOT NULL, 'NAO_ENCONTRADO', 'Fila não encontrada.');
    CALL sp_assert_true(v_tipo = 'MEDICACAO', 'REGRA', 'Fila informada não é MEDICACAO.');

    -- muda o substatus da fila (continua na MEDICAÇÃO)
    UPDATE fila_operacional
       SET substatus     = 'REAVALIAR',
           reavaliar_em  = p_previsto_em,
           observacao    = CASE
                             WHEN p_observacao IS NULL OR p_observacao = '' THEN observacao
                             WHEN observacao IS NULL OR observacao = '' THEN p_observacao
                             ELSE CONCAT(observacao, '\n', p_observacao)
                           END
     WHERE id_fila = p_id_fila;

    -- cria registro de reavaliação (se já existir pendente, não duplica)
    IF NOT EXISTS (
        SELECT 1
          FROM medicacao_reavaliacao mr
         WHERE mr.id_fila_medicacao = p_id_fila
           AND mr.status IN ('PENDENTE','EM_EXECUCAO')
    ) THEN
        INSERT INTO medicacao_reavaliacao(
            id_fila_medicacao, id_ffa, previsto_em, status,
            id_sessao_usuario, id_local_operacional,
            id_usuario_criador, observacao, criado_em
        ) VALUES (
            p_id_fila, v_id_ffa, p_previsto_em, 'PENDENTE',
            p_id_sessao_usuario, v_id_local_operacional,
            v_id_usuario, p_observacao, NOW()
        );
    END IF;

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (
        p_id_fila, p_id_sessao_usuario, 'EM_EXECUCAO_OBS',
        CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa, ' | previsto_em=', p_previsto_em),
        NOW()
    );

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'EM_EXECUCAO_OBS',
        CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa, ' | previsto_em=', p_previsto_em),
        NULL,
        'fila_operacional',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medicacao_finalizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_finalizar`(IN p_id_sessao_usuario BIGINT,
        IN p_id_fila BIGINT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medicacao_finalizar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medicacao_finalizar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_fila_finalizar(p_id_sessao_usuario, p_id_fila, 'setor=MEDICACAO');
    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'FINALIZAR',
        'setor=MEDICACAO',
        NULL,
        'fila_operacional',
        NULL
    );
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medicacao_marcar_executado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_marcar_executado`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_observacao        TEXT
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_tipo VARCHAR(20);
    DECLARE v_id_ffa BIGINT;
    DECLARE v_id_usuario BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medicacao_marcar_executado', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medicacao_marcar_executado | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)')
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    SELECT su.id_usuario
      INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    SELECT fo.tipo, fo.id_ffa
      INTO v_tipo, v_id_ffa
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1
     FOR UPDATE;

    CALL sp_assert_true(v_tipo IS NOT NULL, 'NAO_ENCONTRADO', 'Fila não encontrada.');
    CALL sp_assert_true(v_tipo = 'MEDICACAO', 'REGRA', 'Fila informada não é MEDICACAO.');

    UPDATE fila_operacional
       SET substatus     = 'FINALIZADO',
           data_fim      = NOW(),
           id_responsavel= IFNULL(id_responsavel, v_id_usuario),
           observacao    = CASE
                             WHEN p_observacao IS NULL OR p_observacao = '' THEN observacao
                             WHEN observacao IS NULL OR observacao = '' THEN p_observacao
                             ELSE CONCAT(observacao, '\n', p_observacao)
                           END
     WHERE id_fila = p_id_fila;

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'EXECUTADO', CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa), NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'EXECUTADO',
        CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa),
        NULL,
        'fila_operacional',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medicacao_nao_respondeu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_nao_respondeu`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_motivo            TEXT
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_tipo VARCHAR(20);
    DECLARE v_id_ffa BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medicacao_nao_respondeu', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medicacao_nao_respondeu | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)')
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    SELECT fo.tipo, fo.id_ffa
      INTO v_tipo, v_id_ffa
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1
     FOR UPDATE;

    CALL sp_assert_true(v_tipo IS NOT NULL, 'NAO_ENCONTRADO', 'Fila não encontrada.');
    CALL sp_assert_true(v_tipo = 'MEDICACAO', 'REGRA', 'Fila informada não é MEDICACAO.');

    UPDATE fila_operacional
       SET substatus         = 'NAO_COMPARECEU',
           nao_compareceu_em = NOW(),
           data_fim          = NULL,
           id_responsavel    = NULL,
           observacao        = CASE
                                 WHEN p_motivo IS NULL OR p_motivo = '' THEN observacao
                                 WHEN observacao IS NULL OR observacao = '' THEN p_motivo
                                 ELSE CONCAT(observacao, '\n', p_motivo)
                               END
     WHERE id_fila = p_id_fila;

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'NAO_RESPONDEU', CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa), NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'NAO_RESPONDEU',
        CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa),
        NULL,
        'fila_operacional',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medico_chamar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medico_chamar`(IN p_id_sessao_usuario BIGINT,
        IN p_id_local_operacional BIGINT,
        OUT p_id_fila BIGINT,
        OUT p_id_ffa BIGINT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medico_chamar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medico_chamar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_fila_chamar_proxima(p_id_sessao_usuario, 'MEDICO', p_id_local_operacional, p_id_fila, p_id_ffa);
    UPDATE senhas s
    JOIN ffa f ON f.id_senha = s.id
       SET s.status = 'CHAMANDO',
           s.id_usuario_chamada = (SELECT su.id_usuario FROM sessao_usuario su WHERE su.id_sessao_usuario = p_id_sessao_usuario LIMIT 1),
           s.chamada_em = NOW()
     WHERE f.id = p_id_ffa;

    INSERT INTO senha_eventos(id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em)
    SELECT p_id_sessao_usuario, f.id_senha, 'CHAMAR_SETOR',
           CONCAT('setor=MEDICO | id_fila=', p_id_fila),
           NULL, 'CHAMANDO', NOW()
      FROM ffa f
     WHERE f.id = p_id_ffa
       AND f.id_senha IS NOT NULL;

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'CHAMAR',
        CONCAT('setor=MEDICO | id_ffa=', p_id_ffa),
        NULL,
        'fila_operacional',
        NULL
    );
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medico_encaminhar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medico_encaminhar`(IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa BIGINT,
    IN p_id_local_operacional_destino BIGINT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medico_encaminhar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medico_encaminhar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_operacao_encaminhar(p_id_sessao_usuario, p_id_ffa, p_id_local_operacional_destino);
    UPDATE ffa
       SET status = 'ENCAMINHADO',
           atualizado_em = NOW(),
           id_usuario_alteracao = (SELECT su.id_usuario FROM sessao_usuario su WHERE su.id_sessao_usuario = p_id_sessao_usuario LIMIT 1)
     WHERE id = p_id_ffa;
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medico_finalizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medico_finalizar`(IN p_id_sessao_usuario BIGINT,
        IN p_id_fila BIGINT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medico_finalizar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medico_finalizar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_fila_finalizar(p_id_sessao_usuario, p_id_fila, 'setor=MEDICO');
    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'FINALIZAR',
        'setor=MEDICO',
        NULL,
        'fila_operacional',
        NULL
    );
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medico_marcar_retorno` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medico_marcar_retorno`(IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa BIGINT,
    IN p_minutos_janela INT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE v_id_senha BIGINT;
    DECLARE v_ate DATETIME;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medico_marcar_retorno', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medico_marcar_retorno | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    SET v_ate = DATE_ADD(NOW(), INTERVAL IFNULL(NULLIF(p_minutos_janela,0), 60) MINUTE);
    SELECT f.id_senha INTO v_id_senha FROM ffa f WHERE f.id = p_id_ffa LIMIT 1;
    CALL sp_assert_true(v_id_senha IS NOT NULL, 'FFA', 'FFA sem senha vinculada.');
    UPDATE senhas
       SET status = 'NAO_COMPARECEU',
           retorno_permitido_ate = v_ate,
           retorno_utilizado = 0
     WHERE id = v_id_senha;
    INSERT INTO senha_eventos(id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em)
    VALUES (p_id_sessao_usuario, v_id_senha, 'MARCAR_RETORNO', CONCAT('retorno_ate=', v_ate), NULL, 'NAO_COMPARECEU', NOW());
    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'SENHA',
        v_id_senha,
        'MARCAR_RETORNO',
        CONCAT('id_ffa=', p_id_ffa, ' | retorno_ate=', v_ate),
        NULL,
        'senhas',
        NULL
    );
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_operacao_encaminhar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_operacao_encaminhar`(IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa BIGINT,
    IN p_id_local_operacional_destino BIGINT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_local_sessao BIGINT;
    DECLARE v_id_local_destino BIGINT;
    DECLARE v_tipo_fila VARCHAR(20);
    DECLARE v_id_fila BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_operacao_encaminhar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_operacao_encaminhar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;


    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa é obrigatório.');
    SELECT su.id_usuario, su.id_local_operacional
      INTO v_id_usuario, v_id_local_sessao
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;
    SET v_id_local_destino = IFNULL(p_id_local_operacional_destino, v_id_local_sessao);
    CALL sp_assert_true(v_id_local_destino IS NOT NULL, 'PARAM', 'Local destino não definido (sessão ou parâmetro).');
    CALL sp_assert_true(EXISTS(SELECT 1 FROM local_operacional lo WHERE lo.id_local_operacional = v_id_local_destino), 'LOCAL', 'Local destino inválido.');

    CALL sp_fila_tipo_por_local(p_id_sessao_usuario, v_id_local_destino, v_tipo_fila);
    CALL sp_assert_true(v_tipo_fila IS NOT NULL, 'MAP', 'Não foi possível mapear tipo de fila para o local.');

    SELECT fo.id_fila INTO v_id_fila
      FROM fila_operacional fo
     WHERE fo.id_ffa = p_id_ffa
       AND fo.tipo = v_tipo_fila
     ORDER BY fo.id_fila DESC
     LIMIT 1;

    IF v_id_fila IS NULL THEN
        INSERT INTO fila_operacional(
            id_ffa, tipo, substatus, prioridade,
            data_entrada, entrada_original_em,
            id_local, id_local_operacional,
            observacao
        ) SELECT
            f.id, v_tipo_fila, 'AGUARDANDO',
            CASE
              WHEN f.classificacao_cor IN ('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') THEN f.classificacao_cor
              ELSE 'AZUL'
            END,
            NOW(), NOW(),
            NULL, v_id_local_destino,
            CONCAT('Encaminhado para ', v_tipo_fila)
          FROM ffa f
         WHERE f.id = p_id_ffa
         LIMIT 1;
        SET v_id_fila = LAST_INSERT_ID();
        INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
        VALUES (v_id_fila, p_id_sessao_usuario, 'ENCAMINHAR', CONCAT('local_destino=', v_id_local_destino, ' | tipo=', v_tipo_fila), NOW());
    ELSE
        UPDATE fila_operacional
           SET substatus = 'AGUARDANDO',
               data_entrada = NOW(),
               id_responsavel = NULL,
               data_inicio = NULL,
               data_fim = NULL,
               reavaliar_em = NULL,
               id_local_operacional = v_id_local_destino
         WHERE id_fila = v_id_fila;
        INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
        VALUES (v_id_fila, p_id_sessao_usuario, 'REENCAMINHAR', CONCAT('local_destino=', v_id_local_destino, ' | tipo=', v_tipo_fila), NOW());
    END IF;

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FFA',
        p_id_ffa,
        'ENCAMINHAR',
        CONCAT('tipo_fila=', v_tipo_fila, ' | id_fila=', v_id_fila, ' | local_destino=', v_id_local_destino),
        NULL,
        'ffa',
        NULL
    );
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_paciente_cns_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_paciente_cns_set`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_paciente       BIGINT,
    IN p_cns               VARCHAR(20),
    IN p_origem            VARCHAR(20),
    IN p_validado          TINYINT,
    IN p_observacao        VARCHAR(255)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_paciente_cns_set', 'Falha ao set CNS');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_paciente_cns_set | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_paciente IS NOT NULL, 'PARAM', 'id_paciente é obrigatório.');
    CALL sp_assert_true(p_cns IS NOT NULL AND CHAR_LENGTH(p_cns) >= 10, 'PARAM', 'CNS inválido.');

    START TRANSACTION;

    UPDATE paciente_cns
       SET status = 'INATIVO',
           atualizado_em = NOW()
     WHERE id_paciente = p_id_paciente
       AND status = 'ATIVO'
       AND cns <> p_cns;

    INSERT INTO paciente_cns (id_paciente, cns, status, validado, origem, data_validacao, observacao)
    VALUES (
        p_id_paciente, p_cns, 'ATIVO',
        IFNULL(p_validado,0),
        CASE
            WHEN p_origem IS NULL THEN 'MANUAL'
            WHEN UPPER(p_origem) IN ('MANUAL','IMPORTADO','SUS','INTEGRACAO') THEN UPPER(p_origem)
            ELSE 'MANUAL'
        END,
        CASE WHEN IFNULL(p_validado,0)=1 THEN NOW() ELSE NULL END,
        p_observacao
    );

    SET v_id = LAST_INSERT_ID();

    INSERT INTO paciente_cns_evento (id_paciente_cns, id_sessao_usuario, evento, detalhe, payload_json)
    VALUES (v_id, p_id_sessao_usuario, 'CNS_SET', p_observacao, JSON_OBJECT('cns', p_cns, 'validado', IFNULL(p_validado,0)));

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'CNS_SET', 'paciente_cns', v_id);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_painel_config_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_config_set`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_painel         BIGINT,
    IN p_chave             VARCHAR(80),
    IN p_valor_bool        TINYINT,
    IN p_valor_int         INT,
    IN p_valor_decimal     DECIMAL(12,4),
    IN p_valor_text        TEXT,
    IN p_valor_json        JSON,
    IN p_valor_enum        VARCHAR(80)
)
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_tipo VARCHAR(10);
    DECLARE v_enum_opcoes JSON;

    DECLARE v_valor_bool TINYINT;
    DECLARE v_valor_int INT;
    DECLARE v_valor_decimal DECIMAL(12,4);
    DECLARE v_valor_text TEXT;
    DECLARE v_valor_json JSON;
    DECLARE v_valor_enum VARCHAR(80);

    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate = RETURNED_SQLSTATE,
            v_errno    = MYSQL_ERRNO,
            v_msg      = MESSAGE_TEXT;

        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;

        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_painel_config_set', CONCAT('Falha ao setar config: ', IFNULL(p_chave,'(null)')));
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_painel_config_set | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=',IFNULL(v_errno,0),
            ' | MSG=',IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha ao setar config'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT su.id_usuario
      INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    CALL sp_assert_true(p_id_painel IS NOT NULL, 'PARAM', 'id_painel é obrigatório.');
    CALL sp_assert_true(p_chave IS NOT NULL AND LENGTH(TRIM(p_chave)) > 0, 'PARAM', 'chave é obrigatória.');

    CALL sp_assert_true(
        EXISTS (SELECT 1 FROM painel p WHERE p.id_painel = p_id_painel),
        'NOT_FOUND',
        'Painel não encontrado.'
    );

    SELECT d.tipo_valor, d.enum_opcoes_json
      INTO v_tipo, v_enum_opcoes
      FROM painel_config_def d
     WHERE d.chave = p_chave COLLATE utf8mb4_0900_ai_ci
       AND d.ativo = 1
     LIMIT 1;

    CALL sp_assert_true(v_tipo IS NOT NULL, 'NOT_FOUND', CONCAT('Chave não cadastrada/ativa em painel_config_def: ', p_chave));

    -- Copia valores de entrada para variáveis locais e zera conforme o tipo
    SET v_valor_bool    = p_valor_bool;
    SET v_valor_int     = p_valor_int;
    SET v_valor_decimal = p_valor_decimal;
    SET v_valor_text    = p_valor_text;
    SET v_valor_json    = p_valor_json;
    SET v_valor_enum    = p_valor_enum;

    IF v_tipo = 'BOOL' THEN
        CALL sp_assert_true(v_valor_bool IS NOT NULL, 'PARAM', 'valor_bool obrigatório para chave BOOL.');
        SET v_valor_int = NULL;
        SET v_valor_decimal = NULL;
        SET v_valor_text = NULL;
        SET v_valor_json = NULL;
        SET v_valor_enum = NULL;

    ELSEIF v_tipo = 'INT' THEN
        CALL sp_assert_true(v_valor_int IS NOT NULL, 'PARAM', 'valor_int obrigatório para chave INT.');
        SET v_valor_bool = NULL;
        SET v_valor_decimal = NULL;
        SET v_valor_text = NULL;
        SET v_valor_json = NULL;
        SET v_valor_enum = NULL;

    ELSEIF v_tipo = 'DECIMAL' THEN
        CALL sp_assert_true(v_valor_decimal IS NOT NULL, 'PARAM', 'valor_decimal obrigatório para chave DECIMAL.');
        SET v_valor_bool = NULL;
        SET v_valor_int = NULL;
        SET v_valor_text = NULL;
        SET v_valor_json = NULL;
        SET v_valor_enum = NULL;

    ELSEIF v_tipo = 'TEXT' THEN
        CALL sp_assert_true(v_valor_text IS NOT NULL, 'PARAM', 'valor_text obrigatório para chave TEXT.');
        SET v_valor_bool = NULL;
        SET v_valor_int = NULL;
        SET v_valor_decimal = NULL;
        SET v_valor_json = NULL;
        SET v_valor_enum = NULL;

    ELSEIF v_tipo = 'JSON' THEN
        CALL sp_assert_true(v_valor_json IS NOT NULL, 'PARAM', 'valor_json obrigatório para chave JSON.');
        SET v_valor_bool = NULL;
        SET v_valor_int = NULL;
        SET v_valor_decimal = NULL;
        SET v_valor_text = NULL;
        SET v_valor_enum = NULL;

    ELSEIF v_tipo = 'ENUM' THEN
        CALL sp_assert_true(v_valor_enum IS NOT NULL AND LENGTH(TRIM(v_valor_enum)) > 0, 'PARAM', 'valor_enum obrigatório para chave ENUM.');
        IF v_enum_opcoes IS NOT NULL THEN
            CALL sp_assert_true(
                JSON_CONTAINS(v_enum_opcoes, JSON_QUOTE(v_valor_enum), '$'),
                'PARAM',
                CONCAT('valor_enum inválido: ', v_valor_enum)
            );
        END IF;
        SET v_valor_bool = NULL;
        SET v_valor_int = NULL;
        SET v_valor_decimal = NULL;
        SET v_valor_text = NULL;
        SET v_valor_json = NULL;

    ELSE
        CALL sp_raise('PARAM', CONCAT('tipo_valor inválido em painel_config_def: ', IFNULL(v_tipo,'(null)')));
    END IF;

    START TRANSACTION;

    INSERT INTO painel_config(
        id_painel, chave,
        valor_bool, valor_int, valor_decimal, valor_text, valor_json, valor_enum,
        atualizado_em, id_sessao_usuario, id_usuario
    ) VALUES (
        p_id_painel, p_chave,
        v_valor_bool, v_valor_int, v_valor_decimal, v_valor_text, v_valor_json, v_valor_enum,
        NOW(), p_id_sessao_usuario, v_id_usuario
    )
    ON DUPLICATE KEY UPDATE
        valor_bool       = VALUES(valor_bool),
        valor_int        = VALUES(valor_int),
        valor_decimal    = VALUES(valor_decimal),
        valor_text       = VALUES(valor_text),
        valor_json       = VALUES(valor_json),
        valor_enum       = VALUES(valor_enum),
        atualizado_em    = VALUES(atualizado_em),
        id_sessao_usuario= VALUES(id_sessao_usuario),
        id_usuario       = VALUES(id_usuario);

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'PAINEL',
        p_id_painel,
        'CONFIG_SET',
        CONCAT('chave=',p_chave,' | tipo=',v_tipo),
        NULL,
        'painel_config',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_painel_filtro_locais_seed` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`pa_owner`@`%` PROCEDURE `sp_painel_filtro_locais_seed`(
    IN p_id_sessao_usuario BIGINT,
    IN p_painel_codigo     VARCHAR(60),
    IN p_local_tipo        VARCHAR(60),   -- pode ser NULL (não filtra por tipo)
    IN p_codigo_prefix     VARCHAR(60),   -- prefixo (ou código exato via prefixo), pode ser NULL
    IN p_excluir_prefix    VARCHAR(60),   -- prefixo a excluir (ex.: MEDP), pode ser NULL
    IN p_incluir_nd        TINYINT        -- 0 = não inclui ND, 1 = inclui ND
)
main: BEGIN
    DECLARE v_id_painel BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_sistema BIGINT;

    DECLARE v_json_text TEXT;
    DECLARE v_json_val  JSON;

    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_painel_filtro_locais_seed', 'Falha ao seedar filtro de locais do painel');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_painel_filtro_locais_seed | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=',IFNULL(v_errno,0),
            ' | MSG=',IFNULL(v_msg,'(n/a)'),
            ' | CTX=painel=',IFNULL(p_painel_codigo,'NULL')
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT p.id_painel, p.id_unidade, p.id_sistema
      INTO v_id_painel, v_id_unidade, v_id_sistema
      FROM painel p
     WHERE p.codigo COLLATE utf8mb4_0900_ai_ci = p_painel_codigo COLLATE utf8mb4_0900_ai_ci
     LIMIT 1;

    CALL sp_assert_true(v_id_painel IS NOT NULL, 'NOT_FOUND', CONCAT('Painel não encontrado: ', IFNULL(p_painel_codigo,'NULL')));

    /*
      Monta JSON (array de strings) via GROUP_CONCAT + JSON_QUOTE.
      Se não existir nenhum local, vira '[]'.
    */
    SELECT
      COALESCE(
        CONCAT(
          '[',
          GROUP_CONCAT(JSON_QUOTE(lo.codigo) ORDER BY lo.codigo SEPARATOR ','),
          ']'
        ),
        '[]'
      )
    INTO v_json_text
    FROM local_operacional lo
    WHERE lo.id_unidade = v_id_unidade
      AND lo.id_sistema = v_id_sistema
      AND lo.ativo = 1
      AND (p_local_tipo IS NULL OR lo.tipo COLLATE utf8mb4_0900_ai_ci = p_local_tipo COLLATE utf8mb4_0900_ai_ci)
      AND (p_incluir_nd = 1 OR IFNULL(lo.eh_nao_definida,0) = 0)
      AND (p_codigo_prefix IS NULL OR lo.codigo COLLATE utf8mb4_0900_ai_ci LIKE CONCAT(p_codigo_prefix COLLATE utf8mb4_0900_ai_ci, '%') COLLATE utf8mb4_0900_ai_ci)
      AND (p_excluir_prefix IS NULL OR lo.codigo COLLATE utf8mb4_0900_ai_ci NOT LIKE CONCAT(p_excluir_prefix COLLATE utf8mb4_0900_ai_ci, '%') COLLATE utf8mb4_0900_ai_ci);

    SET v_json_val = CAST(v_json_text AS JSON);

    START TRANSACTION;
      CALL sp_painel_config_set(
        p_id_sessao_usuario,
        v_id_painel,
        'FILTRO_LOCAIS_CODIGOS_JSON',
        NULL,  -- bool
        NULL,  -- int
        NULL,  -- decimal
        NULL,  -- text
        v_json_val, -- json
        NULL   -- enum
      );
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_painel_seed_especialidades` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`pa_owner`@`%` PROCEDURE `sp_painel_seed_especialidades`(
    IN p_id_unidade BIGINT,
    IN p_id_sistema BIGINT
)
BEGIN
    DECLARE v_id BIGINT;

    -- Helper: cria painel se não existir (por código) e retorna id
    -- OBS: tipo='PAINEL' (uso público). Se quiser painel interno, crie outro tipo mais tarde.
    -- Recepção Adulto
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_RECEPCAO_ADULTO','PAINEL','Recepção - Adulto',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_RECEPCAO_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_RECEPCAO_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('REC01','REC02','REC03','REC04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    -- lanes (adulto + prioritário)
    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'ADULTO'),(v_id,'PRIORITARIO');

    -- Recepção Pedi
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_RECEPCAO_PEDI','PAINEL','Recepção - Pediátrico',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_RECEPCAO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_RECEPCAO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('REC01','REC02','REC03','REC04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'PEDIATRICO'),(v_id,'PRIORITARIO');

    -- Triagem Adulto
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_TRIAGEM_ADULTO','PAINEL','Triagem - Adulto',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_TRIAGEM_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_TRIAGEM_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('TRI01','TRI02','TRI03','TRI04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'ADULTO'),(v_id,'PRIORITARIO');

    -- Triagem Pedi
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_TRIAGEM_PEDI','PAINEL','Triagem - Pediátrico',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_TRIAGEM_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_TRIAGEM_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('TRI01','TRI02','TRI03','TRI04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'PEDIATRICO'),(v_id,'PRIORITARIO');

    -- Médico Clínico
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_MEDICO_CLINICO','PAINEL','Médico - Clínico',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_MEDICO_CLINICO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_MEDICO_CLINICO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('CLI01','CLI02','CLI03','CLI04','CLI05'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'ADULTO'),(v_id,'PRIORITARIO');

    -- Médico Pediátrico
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_MEDICO_PEDI','PAINEL','Médico - Pediatria',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_MEDICO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_MEDICO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('PED01','PED02','PED03','PED04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'PEDIATRICO'),(v_id,'PRIORITARIO');

    -- Medicação Adulto
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_MEDICACAO_ADULTO','PAINEL','Medicação - Adulto',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_MEDICACAO_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_MEDICACAO_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('MED01','MED02','MED03','MED04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'ADULTO'),(v_id,'PRIORITARIO');

    -- Medicação Pedi
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_MEDICACAO_PEDI','PAINEL','Medicação - Pediátrica',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_MEDICACAO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_MEDICACAO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('MEDP01','MEDP02','MEDP03','MEDP04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'PEDIATRICO'),(v_id,'PRIORITARIO');

    -- RX (sem filtro de lane)
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_RX','PAINEL','Raio-X',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_RX' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_RX' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('RX01','RX02'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    -- opcional: não seta painel_lane -> mostra todas as lanes

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pdv_venda_criar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pdv_venda_criar`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_estoque_local  BIGINT,
    IN  p_id_cliente        BIGINT,
    OUT p_id_venda          BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_prefixo5 CHAR(5);
    DECLARE v_id_codigo BIGINT;
    DECLARE v_codigo VARCHAR(60);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_pdv_venda_criar', 'Falha ao criar venda');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_pdv_venda_criar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_venda = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_estoque_local IS NOT NULL, 'PARAM', 'id_estoque_local é obrigatório.');

    START TRANSACTION;

    SET v_id_unidade = NULL;
    SET v_id_local   = NULL;
    SELECT su.id_unidade, su.id_local_operacional
      INTO v_id_unidade, v_id_local
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
     LIMIT 1;

    CALL sp_codigo_prefixo_resolver(p_id_sessao_usuario, 'PDV', v_id_unidade, v_id_local, v_prefixo5);

    CALL sp_codigo_emitir_interno(
        p_id_sessao_usuario,
        'PDV',
        v_prefixo5,
        NULL, NULL, NULL,
        NULL,
        NULL, NULL, NULL, NULL, NULL,
        NULL,
        @out_id_codigo,
        @out_codigo_interno,
        @out_barcode
    );

    SET v_id_codigo = @out_id_codigo;
    SET v_codigo    = @out_codigo_interno;

    INSERT INTO pdv_venda (id_estoque_local, id_cliente, id_codigo_universal, codigo, barcode, status, id_sessao_usuario)
    VALUES (p_id_estoque_local, p_id_cliente, v_id_codigo, v_codigo, v_codigo, 'ABERTA', p_id_sessao_usuario);

    SET p_id_venda = LAST_INSERT_ID();

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'PDV_VENDA_CRIADA', 'pdv_venda', p_id_venda);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pedido_medico_criar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pedido_medico_criar`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_ffa            BIGINT, -- referencia ffa.id
    IN  p_id_usuario_solicitante BIGINT,
    IN  p_id_local_operacional BIGINT,
    OUT p_id_pedido_medico  BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE v_id_gpat BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_pedido_medico_criar', 'Falha ao criar pedido médico');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_pedido_medico_criar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_pedido_medico = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa (ffa.id) é obrigatório.');
    CALL sp_assert_true(p_id_usuario_solicitante IS NOT NULL, 'PARAM', 'id_usuario_solicitante é obrigatório.');

    START TRANSACTION;

    SELECT f.id_gpat INTO v_id_gpat
      FROM ffa f
     WHERE f.id = p_id_ffa
     LIMIT 1;

    CALL sp_assert_true(v_id_gpat IS NOT NULL, 'GPAT', 'FFA sem GPAT. Gere GPAT antes de criar pedido.');

    INSERT INTO pedido_medico (id_ffa, id_gpat, id_usuario_solicitante, id_local_operacional, status)
    VALUES (p_id_ffa, v_id_gpat, p_id_usuario_solicitante, p_id_local_operacional, 'ABERTO');

    SET p_id_pedido_medico = LAST_INSERT_ID();

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'PEDIDO_MEDICO_CRIADO', 'pedido_medico', p_id_pedido_medico);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pedido_medico_item_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pedido_medico_item_add`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_pedido_medico  BIGINT,
    IN  p_tipo_item         VARCHAR(20),
    IN  p_descricao         VARCHAR(500),
    IN  p_codigo_sigtap     VARCHAR(30),
    IN  p_competencia       CHAR(6),
    IN  p_exige_cat         TINYINT,
    IN  p_exige_sinan       TINYINT,
    OUT p_id_pedido_item    BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_exige_cat_calc TINYINT DEFAULT 0;
    DECLARE v_exige_sinan_calc TINYINT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_pedido_medico_item_add', 'Falha ao inserir item do pedido');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_pedido_medico_item_add | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_pedido_item = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_pedido_medico IS NOT NULL, 'PARAM', 'id_pedido_medico é obrigatório.');
    CALL sp_assert_true(p_tipo_item IS NOT NULL, 'PARAM', 'tipo_item é obrigatório.');

    START TRANSACTION;

    IF p_codigo_sigtap IS NOT NULL AND CHAR_LENGTH(p_codigo_sigtap) > 0 THEN
        SELECT 1 INTO v_exige_cat_calc
          FROM cat_regra_item r
         WHERE r.codigo_sigtap = p_codigo_sigtap
           AND r.ativo = 1
         LIMIT 1;

        IF v_exige_cat_calc IS NULL THEN
            SET v_exige_cat_calc = 0;
        END IF;

        IF v_exige_cat_calc = 0 AND p_competencia IS NOT NULL THEN
            SELECT IFNULL(s.exige_cat_default,0)
              INTO v_exige_cat_calc
              FROM sus_sigtap_procedimento s
             WHERE s.codigo = p_codigo_sigtap
               AND s.competencia = p_competencia
             LIMIT 1;
            IF v_exige_cat_calc IS NULL THEN
                SET v_exige_cat_calc = 0;
            END IF;
        END IF;

        IF p_competencia IS NOT NULL THEN
            SELECT IFNULL(s.exige_sinan_default,0)
              INTO v_exige_sinan_calc
              FROM sus_sigtap_procedimento s
             WHERE s.codigo = p_codigo_sigtap
               AND s.competencia = p_competencia
             LIMIT 1;
            IF v_exige_sinan_calc IS NULL THEN
                SET v_exige_sinan_calc = 0;
            END IF;
        END IF;
    END IF;

    INSERT INTO pedido_medico_item (
        id_pedido_medico, tipo_item, status,
        codigo_sigtap, competencia_sigtap,
        descricao, exige_cat, exige_sinan
    ) VALUES (
        p_id_pedido_medico,
        p_tipo_item,
        'PENDENTE',
        p_codigo_sigtap,
        p_competencia,
        p_descricao,
        CASE WHEN p_exige_cat IS NOT NULL THEN p_exige_cat ELSE v_exige_cat_calc END,
        CASE WHEN p_exige_sinan IS NOT NULL THEN p_exige_sinan ELSE v_exige_sinan_calc END
    );

    SET p_id_pedido_item = LAST_INSERT_ID();

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'PEDIDO_MEDICO_ITEM_ADD', 'pedido_medico_item', p_id_pedido_item);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_permissao_assert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_permissao_assert`(
    IN p_id_sessao_usuario BIGINT,
    IN p_permissao         VARCHAR(100)
)
BEGIN
    DECLARE v_ok TINYINT DEFAULT 0;

    CALL sp_sessao_tem_permissao(p_id_sessao_usuario, p_permissao, v_ok);

    IF IFNULL(v_ok, 0) = 0 THEN
        CALL sp_raise('SEM_PERMISSAO', CONCAT('Permissão necessária: ', p_permissao));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_procedimento_protocolo_criar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_procedimento_protocolo_criar`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_fila           BIGINT,
    IN  p_tipo              ENUM('EXAME','RX'),
    OUT p_id_protocolo      BIGINT,
    OUT p_codigo            VARCHAR(50),
    OUT p_barcode           VARCHAR(50)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_id_ffa BIGINT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_exist BIGINT;
    DECLARE v_chave VARCHAR(80);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_procedimento_protocolo_criar', 'Falha ao criar protocolo procedimento');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_procedimento_protocolo_criar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_protocolo = NULL;
    SET p_codigo = NULL;
    SET p_barcode = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    START TRANSACTION;

    SELECT fo.id_ffa INTO v_id_ffa
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1;

    CALL sp_assert_true(v_id_ffa IS NOT NULL, 'FILA', 'Fila operacional não encontrada.');

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    -- já existe?
    SELECT pp.id_protocolo INTO v_exist
      FROM procedimento_protocolo pp
     WHERE pp.id_fila = p_id_fila
       AND pp.tipo = p_tipo
     LIMIT 1;

    IF v_exist IS NOT NULL THEN
        SELECT pp.id_protocolo, pp.codigo, pp.barcode
          INTO p_id_protocolo, p_codigo, p_barcode
          FROM procedimento_protocolo pp
         WHERE pp.id_protocolo = v_exist
         LIMIT 1;
        COMMIT;
        LEAVE main;
    END IF;

    SET v_chave = CONCAT(p_tipo,'-', DATE_FORMAT(CURDATE(), '%Y%m%d'));

    -- usa o mesmo emissor (vai registrar em protocolo_emissao)
    CALL sp_protocolo_emitir(
        p_id_sessao_usuario,
        p_tipo,
        v_chave,
        CURDATE(),
        NULL,
        v_id_ffa,
        NULL,
        p_codigo
    );

    -- barcode: por padrão igual ao código (Code128 no front)
    SET p_barcode = p_codigo;

    INSERT INTO procedimento_protocolo(tipo, codigo, barcode, status, id_ffa, id_fila, id_sessao_criacao, id_usuario_criacao, criado_em, atualizado_em)
    VALUES (p_tipo, p_codigo, p_barcode, 'CRIADO', v_id_ffa, p_id_fila, p_id_sessao_usuario, v_id_usuario, NOW(), NOW());

    SET p_id_protocolo = LAST_INSERT_ID();

    INSERT INTO procedimento_protocolo_evento(id_protocolo, tipo_evento, detalhe, criado_em, id_sessao_usuario, id_usuario)
    VALUES (p_id_protocolo, 'PROTOCOLO_CRIADO', CONCAT('Tipo=',p_tipo,' | Código=',p_codigo), NOW(), p_id_sessao_usuario, v_id_usuario);

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'procedimento_protocolo',
        p_id_protocolo,
        'PROTOCOLO_CRIADO',
        CONCAT('Fila=',p_id_fila,' | Tipo=',p_tipo,' | Código=',p_codigo),
        NULL,
        'procedimento_protocolo',
        v_id_usuario
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_protocolo_emitir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_protocolo_emitir`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_tipo              VARCHAR(30),
    IN  p_chave             VARCHAR(80),
    IN  p_data_ref          DATE,
    IN  p_id_paciente       BIGINT,
    IN  p_id_ffa            BIGINT,
    IN  p_id_senha          BIGINT,
    OUT p_codigo            VARCHAR(50)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_num      INT;
    DECLARE v_ano      INT;
    DECLARE v_id_usuario BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_protocolo_emitir', 'Falha na emissão de protocolo');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_protocolo_emitir | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_codigo = NULL;
    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_tipo IS NOT NULL AND p_tipo <> '', 'PARAM', 'tipo é obrigatório.');
    CALL sp_assert_true(p_chave IS NOT NULL AND p_chave <> '', 'PARAM', 'chave é obrigatória.');

    START TRANSACTION;

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    SET v_ano = YEAR(COALESCE(p_data_ref, CURDATE()));

    -- sequência
    CALL sp_sequencia_proximo_numero(p_chave, v_num);

    -- formato padrão vendável: TIPO-AAAAMMDD-000001 (quando data_ref informada) senão TIPO-ANO-000001
    IF p_data_ref IS NOT NULL THEN
        SET p_codigo = CONCAT(UPPER(p_tipo), '-', DATE_FORMAT(p_data_ref, '%Y%m%d'), '-', LPAD(v_num, 6, '0'));
    ELSE
        SET p_codigo = CONCAT(UPPER(p_tipo), '-', v_ano, '-', LPAD(v_num, 6, '0'));
    END IF;

    INSERT INTO protocolo_emissao
        (tipo, chave, codigo, ano, data_ref, id_sessao_usuario, id_usuario, id_paciente, id_ffa, id_senha, criado_em)
    VALUES
        (UPPER(p_tipo), p_chave, p_codigo, v_ano, p_data_ref, p_id_sessao_usuario, v_id_usuario, p_id_paciente, p_id_ffa, p_id_senha, NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'protocolo_emissao',
        LAST_INSERT_ID(),
        'PROTOCOLO_EMITIDO',
        CONCAT('Tipo=',UPPER(p_tipo),' | Código=',p_codigo,' | Chave=',p_chave),
        NULL,
        'protocolo_emissao',
        v_id_usuario
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_raise` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_raise`(
    IN p_codigo   VARCHAR(50),
    IN p_mensagem VARCHAR(4000)
)
BEGIN
    DECLARE v_msg128 VARCHAR(128);

    -- Build message and truncate safely to 128 chars
    SET v_msg128 = LEFT(
        CONCAT('[', IFNULL(p_codigo,'ERRO'), '] ', IFNULL(p_mensagem,'Erro')),
        128
    );

    SIGNAL SQLSTATE '45000'
        SET MYSQL_ERRNO  = 1644,
            MESSAGE_TEXT = v_msg128;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_recepcao_complementar_e_abrir_ffa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_recepcao_complementar_e_abrir_ffa`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_senha BIGINT,

    -- Pessoa
    IN  p_nome_completo VARCHAR(200),
    IN  p_nome_social   VARCHAR(200),
    IN  p_cpf           VARCHAR(14),
    IN  p_cns           VARCHAR(20),
    IN  p_rg            VARCHAR(20),
    IN  p_data_nascimento DATE,
    IN  p_sexo          ENUM('M','F','O'),
    IN  p_nome_mae      VARCHAR(200),

    -- Contato
    IN  p_email         VARCHAR(200),
    IN  p_telefone      VARCHAR(20),

    -- Endereço (simples)
    IN  p_cep           VARCHAR(10),
    IN  p_logradouro    VARCHAR(200),
    IN  p_numero        VARCHAR(20),
    IN  p_complemento   VARCHAR(100),
    IN  p_bairro        VARCHAR(100),
    IN  p_cidade        VARCHAR(100),
    IN  p_uf            CHAR(2),

    -- OUTs
    OUT p_id_pessoa     BIGINT,
    OUT p_id_paciente   BIGINT,
    OUT p_id_atendimento BIGINT,
    OUT p_id_ffa        BIGINT,
    OUT p_gpat          VARCHAR(30)
)
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_local_operacional BIGINT;

    DECLARE v_id_unidade BIGINT;
    DECLARE v_origem VARCHAR(20);
    DECLARE v_tipo_atendimento VARCHAR(30);
    DECLARE v_lane VARCHAR(20);

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_status VARCHAR(30);

    DECLARE v_id_pessoa BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_atendimento BIGINT;
    DECLARE v_id_ffa BIGINT;

    DECLARE v_prontuario VARCHAR(30);
    DECLARE v_gpat VARCHAR(50);

    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_recepcao_complementar_e_abrir_ffa', 'Falha ao complementar e abrir FFA');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_recepcao_complementar_e_abrir_ffa | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)'),
                                         ' | CTX=Falha ao complementar e abrir FFA'));
    END;

    SET p_id_pessoa = NULL;
    SET p_id_paciente = NULL;
    SET p_id_atendimento = NULL;
    SET p_id_ffa = NULL;
    SET p_gpat = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_senha IS NOT NULL, 'PARAM', 'id_senha é obrigatório.');
    CALL sp_assert_true(p_nome_completo IS NOT NULL AND TRIM(p_nome_completo) <> '', 'PARAM', 'Nome completo é obrigatório.');

    SELECT su.id_usuario, su.id_local_operacional
      INTO v_id_usuario, v_id_local_operacional
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    START TRANSACTION;

    -- Lock da senha + captura metadados
    SELECT s.codigo, s.status, s.id_unidade, s.origem, s.tipo_atendimento, s.lane, s.id_paciente, s.id_ffa
      INTO v_codigo, v_status, v_id_unidade, v_origem, v_tipo_atendimento, v_lane, v_id_paciente, v_id_ffa
      FROM senhas s
     WHERE s.id = p_id_senha
     LIMIT 1
     FOR UPDATE;

    CALL sp_assert_true(v_codigo IS NOT NULL, 'NOT_FOUND', 'Senha não encontrada.');
    CALL sp_assert_true(v_status IN ('EM_COMPLEMENTACAO','CHAMANDO','AGUARDANDO'),
                        'STATE', CONCAT('Status inválido para complementar: ', IFNULL(v_status,'NULL')));

    CALL sp_assert_true(v_id_ffa IS NULL, 'STATE', 'Senha já possui FFA vinculada.');
    CALL sp_assert_true(v_id_paciente IS NULL, 'STATE', 'Senha já possui paciente vinculado.');


    -- ---------------------------
    -- Pessoa (merge por CPF > CNS)
    -- ---------------------------
    SET v_id_pessoa = NULL;

    IF p_cpf IS NOT NULL AND TRIM(p_cpf) <> '' THEN
        SELECT id_pessoa INTO v_id_pessoa
          FROM pessoa
         WHERE cpf = p_cpf
         LIMIT 1
         FOR UPDATE;
    END IF;

    IF v_id_pessoa IS NULL AND p_cns IS NOT NULL AND TRIM(p_cns) <> '' THEN
        SELECT id_pessoa INTO v_id_pessoa
          FROM pessoa
         WHERE cns = p_cns
         LIMIT 1
         FOR UPDATE;
    END IF;

    IF v_id_pessoa IS NULL THEN
        INSERT INTO pessoa(
            nome_completo, nome_social, cpf, cns, rg,
            data_nascimento, sexo, nome_mae,
            telefone, email,
            criado_em, atualizado_em
        ) VALUES (
            p_nome_completo, p_nome_social, p_cpf, p_cns, p_rg,
            p_data_nascimento, p_sexo, p_nome_mae,
            p_telefone, p_email,
            NOW(), NOW()
        );
        SET v_id_pessoa = LAST_INSERT_ID();
    ELSE
        UPDATE pessoa
           SET nome_completo    = COALESCE(p_nome_completo, nome_completo),
               nome_social      = COALESCE(p_nome_social, nome_social),
               cpf              = COALESCE(NULLIF(TRIM(p_cpf),''), cpf),
               cns              = COALESCE(NULLIF(TRIM(p_cns),''), cns),
               rg               = COALESCE(NULLIF(TRIM(p_rg),''), rg),
               data_nascimento  = COALESCE(p_data_nascimento, data_nascimento),
               sexo             = COALESCE(p_sexo, sexo),
               nome_mae         = COALESCE(p_nome_mae, nome_mae),
               telefone         = COALESCE(p_telefone, telefone),
               email            = COALESCE(p_email, email),
               atualizado_em    = NOW()
         WHERE id_pessoa = v_id_pessoa;
    END IF;

    -- Endereço principal (se informado algo)
    IF (p_logradouro IS NOT NULL AND TRIM(p_logradouro) <> '')
       OR (p_cep IS NOT NULL AND TRIM(p_cep) <> '') THEN
        INSERT INTO pessoa_endereco(
            id_pessoa, principal, cep, logradouro, numero, complemento, bairro, cidade, uf,
            criado_em, atualizado_em
        ) VALUES (
            v_id_pessoa, 1, p_cep, p_logradouro, p_numero, p_complemento, p_bairro, p_cidade, p_uf,
            NOW(), NOW()
        )
        ON DUPLICATE KEY UPDATE
            cep         = COALESCE(p_cep, cep),
            logradouro  = COALESCE(p_logradouro, logradouro),
            numero      = COALESCE(p_numero, numero),
            complemento = COALESCE(p_complemento, complemento),
            bairro      = COALESCE(p_bairro, bairro),
            cidade      = COALESCE(p_cidade, cidade),
            uf          = COALESCE(p_uf, uf),
            atualizado_em = NOW();
    END IF;

-- ---------------------------
    -- Paciente (1:1 por pessoa)
    -- ---------------------------
    SET v_id_paciente = NULL;

    SELECT id_paciente INTO v_id_paciente
      FROM paciente
     WHERE id_pessoa = v_id_pessoa
     LIMIT 1
     FOR UPDATE;

    IF v_id_paciente IS NULL THEN
        SET v_prontuario = CONCAT('PR', LPAD(v_id_pessoa, 10, '0'));
        INSERT INTO paciente(id_pessoa, prontuario, criado_em, atualizado_em)
        VALUES (v_id_pessoa, v_prontuario, NOW(), NOW());
        SET v_id_paciente = LAST_INSERT_ID();
    END IF;

    -- ---------------------------
    -- Atendimento + FFA
    -- ---------------------------
    -- GPAT determinístico (sem colisão) baseado em id_senha
    SET v_gpat = CONCAT('GPAT-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(p_id_senha, 10, '0'));

    INSERT INTO atendimento(
        id_unidade, id_paciente, id_senha, origem, protocolo, status,
        criado_em, atualizado_em, id_usuario_abertura
    ) VALUES (
        v_id_unidade, v_id_paciente, p_id_senha, v_origem, v_gpat, 'ABERTO',
        NOW(), NOW(), v_id_usuario
    );
    SET v_id_atendimento = LAST_INSERT_ID();

    INSERT INTO ffa(
        id_atendimento, id_paciente, id_senha, status, retorno_ativo, motivo,
        criado_em, atualizado_em, id_usuario_abertura
    ) VALUES (
        v_id_atendimento, v_id_paciente, p_id_senha, 'ABERTO', 0, NULL,
        NOW(), NOW(), v_id_usuario
    );
    SET v_id_ffa = LAST_INSERT_ID();

    -- Link na senha + finaliza complementação
    UPDATE senhas
       SET id_paciente               = v_id_paciente,
           id_ffa                    = v_id_ffa,
           status                    = 'ENCAMINHADO',
           fim_complementacao_em     = NOW(),
           id_usuario_complementacao_fim = v_id_usuario,
           id_usuario_operador       = v_id_usuario,
           atualizado_em             = NOW()
     WHERE id = p_id_senha;

    UPDATE fila_senha
       SET status = 'ENCAMINHADO'
     WHERE id_senha = p_id_senha;

    INSERT INTO senha_eventos(
        id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em
    ) VALUES (
        p_id_sessao_usuario, p_id_senha, 'COMPLEMENTAR_E_ABRIR_FFA',
        CONCAT('paciente=',v_id_paciente,' | atendimento=',v_id_atendimento,' | ffa=',v_id_ffa,' | gpat=',v_gpat),
        v_status, 'ENCAMINHADO', NOW()
    );

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FFA',
        v_id_ffa,
        'ABRIR',
        CONCAT('senha=',v_codigo,' | paciente=',v_id_paciente,' | atendimento=',v_id_atendimento,' | gpat=',v_gpat),
        NULL,
        'ffa',
        NULL
    );

    COMMIT;

    SET p_id_pessoa      = v_id_pessoa;
    SET p_id_paciente    = v_id_paciente;
    SET p_id_atendimento = v_id_atendimento;
    SET p_id_ffa         = v_id_ffa;
    SET p_gpat           = v_gpat;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_recepcao_encaminhar_ffa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_recepcao_encaminhar_ffa`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa BIGINT,
    IN p_tipo_destino VARCHAR(50) -- NULL -> TRIAGEM
)
main: BEGIN
    DECLARE v_destino VARCHAR(50);
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_recepcao_encaminhar_ffa', 'Falha ao encaminhar FFA');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_recepcao_encaminhar_ffa | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)'),
                                         ' | CTX=Falha ao encaminhar FFA'));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa é obrigatório.');

    SET v_destino = IFNULL(NULLIF(TRIM(p_tipo_destino),''), 'TRIAGEM');

    START TRANSACTION;
        -- usa local operacional da sessão (destino default)
        CALL sp_operacao_encaminhar(p_id_sessao_usuario, p_id_ffa, v_destino, NULL);
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_recepcao_iniciar_complementacao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_recepcao_iniciar_complementacao`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT
)
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_local_operacional BIGINT;

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_status VARCHAR(30);

    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_recepcao_iniciar_complementacao', 'Falha ao iniciar complementação');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_recepcao_iniciar_complementacao | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)'),
                                         ' | CTX=Falha ao iniciar complementação'));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT su.id_usuario, su.id_local_operacional
      INTO v_id_usuario, v_id_local_operacional
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    CALL sp_assert_true(p_id_senha IS NOT NULL, 'PARAM', 'id_senha é obrigatório.');

    START TRANSACTION;

    SELECT s.codigo, s.status
      INTO v_codigo, v_status
      FROM senhas s
     WHERE s.id = p_id_senha
     LIMIT 1
     FOR UPDATE;

    CALL sp_assert_true(v_codigo IS NOT NULL, 'NOT_FOUND', 'Senha não encontrada.');

    -- Permite iniciar complementação se estiver CHAMANDO (padrão) ou AGUARDANDO (caso operador pule a chamada)
    CALL sp_assert_true(v_status IN ('CHAMANDO','AGUARDANDO','EM_COMPLEMENTACAO'),
                        'STATE', CONCAT('Status inválido para iniciar complementação: ', IFNULL(v_status,'NULL')));

    UPDATE senhas
       SET status                   = 'EM_COMPLEMENTACAO',
           inicio_complementacao_em = IFNULL(inicio_complementacao_em, NOW()),
           id_usuario_complementacao= IFNULL(id_usuario_complementacao, v_id_usuario),
           id_usuario_operador      = v_id_usuario,
           atualizado_em            = NOW()
     WHERE id = p_id_senha;

    -- Se existir fila_senha, marca também (painel/recepção usa fila_senha)
    UPDATE fila_senha
       SET status = 'EM_COMPLEMENTACAO'
     WHERE id_senha = p_id_senha;

    INSERT INTO senha_eventos(
        id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em
    ) VALUES (
        p_id_sessao_usuario, p_id_senha, 'INICIAR_COMPLEMENTACAO',
        CONCAT('local_operacional=',IFNULL(v_id_local_operacional,'NULL')),
        v_status, 'EM_COMPLEMENTACAO', NOW()
    );

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'SENHA',
        p_id_senha,
        'INICIAR_COMPLEMENTACAO',
        CONCAT('codigo=',v_codigo,' | local_operacional=',IFNULL(v_id_local_operacional,'NULL')),
        NULL,
        'senhas',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_recepcao_nao_compareceu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_recepcao_nao_compareceu`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha          BIGINT,
    IN p_janela_minutos    INT,
    IN p_observacao        VARCHAR(255)
)
BEGIN
    -- regra: recepção marca a senha como NAO_COMPARECEU + abre janela de retorno
    CALL sp_senha_nao_compareceu(p_id_sessao_usuario, p_id_senha, p_janela_minutos,
                                 CONCAT('setor=RECEPCAO | ', IFNULL(p_observacao,'(n/a)')));
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_rechamar_procedimento`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_protocolo      BIGINT,
    IN p_motivo            VARCHAR(255)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_id_usuario BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_rechamar_procedimento', 'Falha ao rechamar procedimento');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_rechamar_procedimento | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_protocolo IS NOT NULL, 'PARAM', 'id_protocolo é obrigatório.');

    START TRANSACTION;

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    INSERT INTO procedimento_protocolo_evento(id_protocolo, tipo_evento, detalhe, criado_em, id_sessao_usuario, id_usuario)
    VALUES (p_id_protocolo, 'RECHAMADA', COALESCE(p_motivo,'(sem motivo)'), NOW(), p_id_sessao_usuario, v_id_usuario);

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'procedimento_protocolo',
        p_id_protocolo,
        'RECHAMADA',
        CONCAT('Rechamada | Motivo=',COALESCE(p_motivo,'(n/a)')),
        NULL,
        'procedimento_protocolo',
        v_id_usuario
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_rx_chamar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_rx_chamar`(IN p_id_sessao_usuario BIGINT,
        IN p_id_local_operacional BIGINT,
        OUT p_id_fila BIGINT,
        OUT p_id_ffa BIGINT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_rx_chamar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_rx_chamar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_fila_chamar_proxima(p_id_sessao_usuario, 'RX', p_id_local_operacional, p_id_fila, p_id_ffa);
    UPDATE senhas s
    JOIN ffa f ON f.id_senha = s.id
       SET s.status = 'CHAMANDO',
           s.id_usuario_chamada = (SELECT su.id_usuario FROM sessao_usuario su WHERE su.id_sessao_usuario = p_id_sessao_usuario LIMIT 1),
           s.chamada_em = NOW()
     WHERE f.id = p_id_ffa;

    INSERT INTO senha_eventos(id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em)
    SELECT p_id_sessao_usuario, f.id_senha, 'CHAMAR_SETOR',
           CONCAT('setor=RX | id_fila=', p_id_fila),
           NULL, 'CHAMANDO', NOW()
      FROM ffa f
     WHERE f.id = p_id_ffa
       AND f.id_senha IS NOT NULL;

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'CHAMAR',
        CONCAT('setor=RX | id_ffa=', p_id_ffa),
        NULL,
        'fila_operacional',
        NULL
    );
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_rx_finalizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_rx_finalizar`(IN p_id_sessao_usuario BIGINT,
        IN p_id_fila BIGINT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_rx_finalizar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_rx_finalizar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_fila_finalizar(p_id_sessao_usuario, p_id_fila, 'setor=RX');
    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'FINALIZAR',
        'setor=RX',
        NULL,
        'fila_operacional',
        NULL
    );
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_schema_add_column_if_missing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_schema_add_column_if_missing`(
    IN p_table_schema VARCHAR(64),
    IN p_table_name   VARCHAR(64),
    IN p_column_name  VARCHAR(64),
    IN p_column_ddl   TEXT
)
main: BEGIN
    DECLARE v_cnt INT DEFAULT 0;
    DECLARE v_sql TEXT;

    SELECT COUNT(*)
      INTO v_cnt
      FROM information_schema.COLUMNS c
     WHERE c.TABLE_SCHEMA = p_table_schema
       AND c.TABLE_NAME   = p_table_name
       AND c.COLUMN_NAME  = p_column_name;

    IF v_cnt = 0 THEN
        SET v_sql = CONCAT('ALTER TABLE `', p_table_schema, '`.`', p_table_name, '` ADD COLUMN ', p_column_ddl);
        SET @ddl_sql = v_sql;
        PREPARE stmt FROM @ddl_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SET @ddl_sql = NULL;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_schema_add_index_if_missing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_schema_add_index_if_missing`(
    IN p_table_schema VARCHAR(64),
    IN p_table_name   VARCHAR(64),
    IN p_index_name   VARCHAR(64),
    IN p_index_ddl    TEXT
)
main: BEGIN
    DECLARE v_cnt INT DEFAULT 0;
    DECLARE v_sql TEXT;

    SELECT COUNT(*)
      INTO v_cnt
      FROM information_schema.STATISTICS s
     WHERE s.TABLE_SCHEMA = p_table_schema
       AND s.TABLE_NAME   = p_table_name
       AND s.INDEX_NAME   = p_index_name;

    IF v_cnt = 0 THEN
        SET v_sql = CONCAT('ALTER TABLE `', p_table_schema, '`.`', p_table_name, '` ADD ', p_index_ddl);
        SET @ddl_sql = v_sql;
        PREPARE stmt FROM @ddl_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SET @ddl_sql = NULL;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_senha_cancelar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_cancelar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha          BIGINT,
    IN p_motivo            VARCHAR(255)
)
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_status_de VARCHAR(50);

    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_senha_cancelar', 'Falha ao cancelar senha');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_senha_cancelar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_not_null(p_id_senha, 'SENHA', 'Informe p_id_senha.');

    START TRANSACTION;

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
     LIMIT 1;

    SELECT s.status INTO v_status_de
      FROM senhas s
     WHERE s.id = p_id_senha
     FOR UPDATE;

    CALL sp_assert_true(v_status_de IS NOT NULL, 'SENHA', 'Senha não encontrada.');
    CALL sp_assert_true(v_status_de <> 'CANCELADO', 'SENHA', 'Senha já está cancelada.');
    CALL sp_assert_true(v_status_de <> 'FINALIZADO', 'SENHA', 'Senha já está finalizada.');

    UPDATE senhas
       SET status = 'CANCELADO',
           id_usuario_operador = v_id_usuario,
           finalizada_em = NOW()
     WHERE id = p_id_senha;

    INSERT INTO senha_eventos (id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em)
    VALUES (p_id_sessao_usuario, p_id_senha, 'CANCELAR',
            CONCAT('motivo=',IFNULL(p_motivo,'(n/a)')),
            v_status_de, 'CANCELADO', NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'SENHA',
        p_id_senha,
        'CANCELAR',
        CONCAT('status_de=',v_status_de,' | status_para=CANCELADO | motivo=',IFNULL(p_motivo,'(n/a)')),
        NULL,
        'senhas',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_senha_chamar_proxima` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_chamar_proxima`(
    IN  p_id_sessao_usuario     BIGINT,
    IN  p_id_local_operacional  BIGINT,      -- NULL -> usa local da sessão
    IN  p_lane                  VARCHAR(20), -- NULL -> qualquer; ADULTO|PEDIATRICO|PRIORITARIO
    OUT p_id_senha              BIGINT,
    OUT p_codigo                VARCHAR(10)
)
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_local   BIGINT;

    DECLARE v_id_senha BIGINT DEFAULT NULL;
    DECLARE v_codigo   VARCHAR(10) DEFAULT NULL;
    DECLARE v_status   VARCHAR(30) DEFAULT NULL;

    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    -- IMPORTANTE: DECLAREs (variáveis) vêm ANTES de handlers/cursors.
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SET v_id_senha = NULL;
        SET v_codigo   = NULL;
        SET v_status   = NULL;
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_senha_chamar_proxima', 'Falha ao chamar próxima senha');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_senha_chamar_proxima | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha ao chamar próxima senha'
        ));
    END;

    SET p_id_senha = NULL;
    SET p_codigo   = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT su.id_usuario, IFNULL(p_id_local_operacional, su.id_local_operacional)
      INTO v_id_usuario, v_id_local
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    CALL sp_assert_true(v_id_local IS NOT NULL, 'PARAM', 'Local operacional não definido (sessão ou parâmetro).');

    IF p_lane IS NOT NULL THEN
        CALL sp_assert_true(
            p_lane IN ('ADULTO','PEDIATRICO','PRIORITARIO'),
            'PARAM',
            CONCAT('lane inválida: ', IFNULL(p_lane,'NULL'))
        );
    END IF;

    START TRANSACTION;

    -- Seleciona 1 senha aguardando na fila do local (lock)
    SELECT fs.id_senha, s.codigo, s.status
      INTO v_id_senha, v_codigo, v_status
      FROM fila_senha fs
      JOIN senhas s ON s.id = fs.id_senha
     WHERE fs.status = 'AGUARDANDO'
       AND s.status  = 'AGUARDANDO'
       AND s.id_local_operacional = v_id_local
       AND (p_lane IS NULL OR s.lane = p_lane)
     ORDER BY s.prioridade DESC, fs.criado_em ASC, fs.id ASC
     LIMIT 1
     FOR UPDATE;

    IF v_id_senha IS NULL THEN
        COMMIT;
        LEAVE main;
    END IF;

    -- Atualiza senha (concorrência-safe)
    UPDATE senhas
       SET status = 'CHAMANDO',
           chamada_em = NOW(),
           id_usuario_chamada = v_id_usuario
     WHERE id = v_id_senha
       AND status = 'AGUARDANDO';

    CALL sp_assert_true(ROW_COUNT() = 1, 'CONCORRENCIA', 'Senha já não está AGUARDANDO (foi pega por outro operador).');

    UPDATE fila_senha
       SET status = 'CHAMANDO'
     WHERE id_senha = v_id_senha;

    INSERT INTO senha_eventos(
        id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em
    ) VALUES (
        p_id_sessao_usuario, v_id_senha, 'CHAMAR',
        CONCAT('local=', v_id_local, ' | lane=', IFNULL(p_lane,'(qualquer)')),
        v_status, 'CHAMANDO', NOW()
    );

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'SENHA',
        v_id_senha,
        'CHAMAR',
        CONCAT('codigo=', v_codigo, ' | local=', v_id_local, ' | lane=', IFNULL(p_lane,'(qualquer)')),
        NULL,
        'senhas',
        NULL
    );

    COMMIT;

    SET p_id_senha = v_id_senha;
    SET p_codigo   = v_codigo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_senha_emitir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_emitir`(
    IN  p_id_sessao_usuario     BIGINT,
    IN  p_tipo_atendimento      VARCHAR(20),   -- CLINICO|PEDIATRICO|PRIORITARIO|EMERGENCIA|VISITA|EXAME
    IN  p_origem                VARCHAR(20),   -- TOTEM|RECEPCAO|ADMIN|SAMU
    IN  p_id_local_operacional  BIGINT,        -- NULL -> usa o local da sessão
    OUT p_id_senha              BIGINT,
    OUT p_codigo                VARCHAR(10)
)
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_sistema BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local   BIGINT;

    DECLARE v_lane   VARCHAR(20);
    DECLARE v_prefix VARCHAR(5);
    DECLARE v_num    INT;
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_ultimo INT;

    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_ultimo = NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_senha_emitir', 'Falha ao emitir senha');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_senha_emitir | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)'),
                                         ' | CTX=Falha ao emitir senha'));
    END;

    SET p_id_senha = NULL;
    SET p_codigo   = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT su.id_usuario, su.id_sistema, su.id_unidade,
           IFNULL(p_id_local_operacional, su.id_local_operacional)
      INTO v_id_usuario, v_id_sistema, v_id_unidade, v_id_local
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    CALL sp_assert_true(v_id_local IS NOT NULL, 'PARAM', 'Local operacional não definido (sessão ou parâmetro).');

    -- validações
    CALL sp_assert_true(p_tipo_atendimento IN ('CLINICO','PEDIATRICO','PRIORITARIO','EMERGENCIA','VISITA','EXAME'),
                        'PARAM', CONCAT('tipo_atendimento inválido: ', IFNULL(p_tipo_atendimento,'NULL')));
    CALL sp_assert_true(p_origem IN ('TOTEM','RECEPCAO','ADMIN','SAMU'),
                        'PARAM', CONCAT('origem inválida: ', IFNULL(p_origem,'NULL')));

    -- lane / prefixo (canônico)
    IF p_tipo_atendimento = 'PEDIATRICO' THEN
        SET v_lane = 'PEDIATRICO';
        SET v_prefix = 'P';
    ELSEIF p_tipo_atendimento IN ('PRIORITARIO','EMERGENCIA') THEN
        SET v_lane = 'PRIORITARIO';
        SET v_prefix = 'PR';
    ELSEIF p_tipo_atendimento = 'EXAME' THEN
        SET v_lane = 'ADULTO';
        SET v_prefix = 'X';
    ELSEIF p_tipo_atendimento = 'VISITA' THEN
        SET v_lane = 'ADULTO';
        SET v_prefix = 'V';
    ELSE
        SET v_lane = 'ADULTO';
        SET v_prefix = 'A';
    END IF;

    START TRANSACTION;

    -- Sequência diária por (sistema, unidade, data_ref, prefixo)
    SELECT s.numero
      INTO v_ultimo
      FROM senhas s
     WHERE s.id_sistema = v_id_sistema
       AND s.id_unidade = v_id_unidade
       AND s.data_ref = CURDATE()
       AND s.prefixo = v_prefix
     ORDER BY s.numero DESC
     LIMIT 1
     FOR UPDATE;

    SET v_num = IFNULL(v_ultimo, 0) + 1;

    -- Código humano (até 10 chars)
    IF v_prefix = 'PR' THEN
        SET v_codigo = CONCAT(v_prefix, LPAD(v_num, 3, '0')); -- PR001
    ELSE
        SET v_codigo = CONCAT(v_prefix, LPAD(v_num, 3, '0')); -- A001 / P001 / X001 / V001 / E001
    END IF;

    INSERT INTO senhas (
        id_sistema, id_unidade, data_ref,
        numero, prefixo, codigo,
        tipo_atendimento, lane, prioridade,
        status, origem,
        id_local_operacional, id_usuario_operador,
        criada_em, posicionado_em
    ) VALUES (
        v_id_sistema, v_id_unidade, CURDATE(),
        v_num, v_prefix, v_codigo,
        p_tipo_atendimento, v_lane, 0,
        'AGUARDANDO', p_origem,
        v_id_local, v_id_usuario,
        NOW(), NOW()
    );

    SET p_id_senha = LAST_INSERT_ID();
    SET p_codigo   = v_codigo;

    -- Entra na fila_senha (recepção / painel)
    INSERT INTO fila_senha (id_senha, status, criado_em)
    VALUES (p_id_senha, 'AGUARDANDO', NOW())
    ON DUPLICATE KEY UPDATE
        status = 'AGUARDANDO';

    -- Evento semântico
    INSERT INTO senha_eventos(
        id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em
    ) VALUES (
        p_id_sessao_usuario, p_id_senha, 'EMITIR',
        CONCAT('origem=',p_origem,' | tipo=',p_tipo_atendimento,' | lane=',v_lane,' | local=',v_id_local),
        NULL, 'AGUARDANDO', NOW()
    );

    -- Auditoria genérica
    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'SENHA',
        p_id_senha,
        'EMITIR',
        CONCAT('codigo=',v_codigo,' | origem=',p_origem,' | tipo=',p_tipo_atendimento,' | lane=',v_lane,' | local=',v_id_local),
        NULL,
        'senhas',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_senha_finalizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_finalizar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha          BIGINT,
    IN p_motivo            VARCHAR(255)
)
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_status_de VARCHAR(50);

    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_senha_finalizar', 'Falha ao finalizar senha');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_senha_finalizar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_not_null(p_id_senha, 'SENHA', 'Informe p_id_senha.');

    START TRANSACTION;

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
     LIMIT 1;

    SELECT s.status INTO v_status_de
      FROM senhas s
     WHERE s.id = p_id_senha
     FOR UPDATE;

    CALL sp_assert_true(v_status_de IS NOT NULL, 'SENHA', 'Senha não encontrada.');
    CALL sp_assert_true(v_status_de <> 'FINALIZADO', 'SENHA', 'Senha já está finalizada.');
    CALL sp_assert_true(v_status_de <> 'CANCELADO', 'SENHA', 'Senha está cancelada.');

    UPDATE senhas
       SET status = 'FINALIZADO',
           id_usuario_operador = v_id_usuario,
           finalizada_em = NOW()
     WHERE id = p_id_senha;

    INSERT INTO senha_eventos (id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em)
    VALUES (p_id_sessao_usuario, p_id_senha, 'FINALIZAR',
            CONCAT('motivo=',IFNULL(p_motivo,'(n/a)')),
            v_status_de, 'FINALIZADO', NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'SENHA',
        p_id_senha,
        'FINALIZAR',
        CONCAT('status_de=',v_status_de,' | status_para=FINALIZADO | motivo=',IFNULL(p_motivo,'(n/a)')),
        NULL,
        'senhas',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_senha_iniciar_complementacao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_iniciar_complementacao`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT
)
main:BEGIN
    DECLARE v_status   VARCHAR(30);

    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate = RETURNED_SQLSTATE,
            v_errno    = MYSQL_ERRNO,
            v_msg      = MESSAGE_TEXT;

        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;

        ROLLBACK;

        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_senha_iniciar_complementacao', 'Falha ao iniciar complementação');

        CALL sp_raise(
            'ERRO_SQL',
            CONCAT(
                'ROTINA=sp_senha_iniciar_complementacao | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
                ' | ERRNO=', IFNULL(v_errno,0),
                ' | MSG=', IFNULL(v_msg,'(n/a)'),
                ' | CTX=Falha ao iniciar complementação'
            )
        );
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_senha IS NOT NULL, 'PARAM', 'id_senha é obrigatório.');

    START TRANSACTION;

    SELECT s.status
      INTO v_status
      FROM senhas s
     WHERE s.id = p_id_senha
     LIMIT 1
     FOR UPDATE;

    CALL sp_assert_true(v_status IS NOT NULL, 'NOT_FOUND', 'Senha não encontrada.');
    CALL sp_assert_true(v_status IN ('CHAMANDO','AGUARDANDO'), 'ESTADO', CONCAT('Senha em estado inválido: ', v_status));

    -- Corrigido: sem vírgula antes do WHERE
    UPDATE senhas
       SET status = 'EM_COMPLEMENTACAO'
     WHERE id = p_id_senha;

    UPDATE fila_senha
       SET status = 'EM_COMPLEMENTACAO'
     WHERE id_senha = p_id_senha;

    INSERT INTO senha_eventos(
        id_sessao_usuario,
        id_senha,
        tipo_evento,
        detalhe,
        status_de,
        status_para,
        criado_em
    ) VALUES (
        p_id_sessao_usuario,
        p_id_senha,
        'INICIAR_COMPLEMENTACAO',
        NULL,
        v_status,
        'EM_COMPLEMENTACAO',
        NOW()
    );

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'SENHA',
        p_id_senha,
        'INICIAR_COMPLEMENTACAO',
        NULL,
        NULL,
        'senhas',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_senha_nao_compareceu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_nao_compareceu`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha          BIGINT,
    IN p_janela_minutos    INT,
    IN p_observacao        VARCHAR(255)
)
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_status_de VARCHAR(50);
    DECLARE v_min INT;

    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_senha_nao_compareceu', 'Falha ao marcar não compareceu');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_senha_nao_compareceu | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_not_null(p_id_senha, 'SENHA', 'Informe p_id_senha.');

    SET v_min = IFNULL(p_janela_minutos, 60);
    CALL sp_assert_true(v_min BETWEEN 1 AND 240, 'SENHA', 'Janela inválida (1..240 minutos).');

    START TRANSACTION;

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
     LIMIT 1;

    SELECT s.status INTO v_status_de
      FROM senhas s
     WHERE s.id = p_id_senha
     FOR UPDATE;

    CALL sp_assert_true(v_status_de IS NOT NULL, 'SENHA', 'Senha não encontrada.');
    CALL sp_assert_true(v_status_de NOT IN ('CANCELADO','FINALIZADO'), 'SENHA', CONCAT('Não é permitido. Status atual=', v_status_de));

    UPDATE senhas
       SET status = 'NAO_COMPARECEU',
           id_usuario_operador = v_id_usuario,
           nao_compareceu_em = NOW(),
           retorno_permitido_ate = DATE_ADD(NOW(), INTERVAL v_min MINUTE),
           retorno_utilizado = 0,
           retorno_em = NULL
     WHERE id = p_id_senha;

    INSERT INTO senha_eventos (id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em)
    VALUES (p_id_sessao_usuario, p_id_senha, 'NAO_COMPARECEU',
            CONCAT('janela_min=',v_min,' | obs=',IFNULL(p_observacao,'(n/a)')),
            v_status_de, 'NAO_COMPARECEU', NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'SENHA',
        p_id_senha,
        'NAO_COMPARECEU',
        CONCAT('status_de=',v_status_de,' | status_para=NAO_COMPARECEU | janela_min=',v_min,' | obs=',IFNULL(p_observacao,'(n/a)')),
        NULL,
        'senhas',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_senha_rechamar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_rechamar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha          BIGINT,
    IN p_motivo            VARCHAR(255)
)
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_status_de VARCHAR(50);

    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_senha_rechamar', 'Falha ao rechamar senha');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_senha_rechamar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_not_null(p_id_senha, 'SENHA', 'Informe p_id_senha.');

    START TRANSACTION;

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
     LIMIT 1;

    SELECT s.status INTO v_status_de
      FROM senhas s
     WHERE s.id = p_id_senha
     FOR UPDATE;

    CALL sp_assert_true(v_status_de IS NOT NULL, 'SENHA', 'Senha não encontrada.');

    -- não rechama se já cancelou/finalizou
    CALL sp_assert_true(v_status_de NOT IN ('CANCELADO','FINALIZADO'), 'SENHA', CONCAT('Não é permitido rechamar. Status atual=', v_status_de));

    UPDATE senhas
       SET status = 'CHAMANDO',
           id_usuario_chamada = v_id_usuario,
           chamada_em = NOW()
     WHERE id = p_id_senha;

    INSERT INTO senha_eventos (id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em)
    VALUES (p_id_sessao_usuario, p_id_senha, 'RECHAMAR',
            CONCAT('motivo=',IFNULL(p_motivo,'(n/a)')),
            v_status_de, 'CHAMANDO', NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'SENHA',
        p_id_senha,
        'RECHAMAR',
        CONCAT('status_de=',v_status_de,' | status_para=CHAMANDO | motivo=',IFNULL(p_motivo,'(n/a)')),
        NULL,
        'senhas',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_senha_retorno_reinserir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_retorno_reinserir`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_senha BIGINT,
    IN  p_janela_retorno_min INT,
    OUT p_id_senha_result BIGINT,
    OUT p_codigo_result VARCHAR(10)
)
proc: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_tipo VARCHAR(20);
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_status VARCHAR(30);
    DECLARE v_retorno_ate DATETIME;
    DECLARE v_retorno_utilizado TINYINT;
    DECLARE v_janela INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario,'sp_senha_retorno_reinserir','Falha no retorno da senha');
    END;

    SET v_janela = IFNULL(NULLIF(p_janela_retorno_min,0), 60);
    IF v_janela < 1 THEN SET v_janela = 60; END IF;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT su.id_usuario, su.id_local_operacional
      INTO v_id_usuario, v_id_local
      FROM sessao_usuario su WHERE su.id_sessao_usuario = p_id_sessao_usuario;

    START TRANSACTION;

    SELECT s.codigo, s.status, s.retorno_permitido_ate, s.retorno_utilizado, s.tipo_atendimento, s.id_local_operacional
      INTO v_codigo, v_status, v_retorno_ate, v_retorno_utilizado, v_tipo, v_id_local
      FROM senhas s
     WHERE s.id = p_id_senha
     FOR UPDATE;

    IF v_codigo IS NULL THEN
        ROLLBACK;
        CALL sp_raise('SENHA_NAO_ENCONTRADA','Senha inexistente');
    END IF;

    IF v_status <> 'NAO_COMPARECEU' THEN
        ROLLBACK;
        CALL sp_raise('STATUS_INVALIDO', CONCAT('Senha não está em NAO_COMPARECEU: ', v_status));
    END IF;

    -- dentro da janela e ainda não usado => reinserir a mesma senha no fim da fila
    IF v_retorno_utilizado = 0 AND v_retorno_ate IS NOT NULL AND v_retorno_ate >= NOW() THEN

        UPDATE senhas
           SET status = 'AGUARDANDO',
               posicionado_em = NOW(),
               retorno_utilizado = 1,
               retorno_em = NOW()
         WHERE id = p_id_senha;

        INSERT INTO senha_eventos
            (id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em)
        VALUES
            (p_id_sessao_usuario, p_id_senha, 'RETORNO_REINSERIR',
             'Retorno dentro da janela: volta ao fim', 'NAO_COMPARECEU', 'AGUARDANDO', NOW());

        INSERT INTO auditoria_evento
            (id_sessao_usuario, entidade, id_entidade, acao, detalhe, tabela, id_usuario_espelho, criado_em)
        VALUES
            (p_id_sessao_usuario, 'senhas', p_id_senha, 'RETORNO_REINSERIR',
             CONCAT('Senha ', v_codigo, ' reinserida no fim da fila (retorno)'),
             'senhas', v_id_usuario, NOW());

        COMMIT;

        SET p_id_senha_result = p_id_senha;
        SET p_codigo_result = v_codigo;

        SELECT p_id_senha_result AS id_senha, p_codigo_result AS codigo, 'REINSERIDA' AS resultado;
        LEAVE proc;
    END IF;

    -- fora da janela => encerra a antiga e gera nova senha (mesma tipagem)
    UPDATE senhas
       SET status = 'FINALIZADA',
           finalizada_em = NOW()
     WHERE id = p_id_senha;

    INSERT INTO senha_eventos
        (id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em)
    VALUES
        (p_id_sessao_usuario, p_id_senha, 'RETORNO_EXPIRADO',
         CONCAT('Retorno expirado (janela ', v_janela, 'min) => nova senha'), 'NAO_COMPARECEU', 'FINALIZADA', NOW());

    INSERT INTO auditoria_evento
        (id_sessao_usuario, entidade, id_entidade, acao, detalhe, tabela, id_usuario_espelho, criado_em)
    VALUES
        (p_id_sessao_usuario, 'senhas', p_id_senha, 'RETORNO_EXPIRADO',
         CONCAT('Retorno expirado da senha ', v_codigo, ' => gerando nova senha'),
         'senhas', v_id_usuario, NOW());

    COMMIT;

    -- nova senha (origem=RECEPCAO por padrão no retorno)
    CALL sp_senha_emitir(p_id_sessao_usuario, v_tipo, 'RECEPCAO', v_id_local, p_id_senha_result, p_codigo_result);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_sequencia_proximo_numero` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sequencia_proximo_numero`(
    IN  p_chave   VARCHAR(100),
    OUT p_numero  BIGINT
)
BEGIN
    /*
      Tabela protocolo_sequencia:
        chave VARCHAR(100) PK
        ultimo_numero BIGINT
        criado_em / atualizado_em (auto)
    */
    INSERT INTO protocolo_sequencia(chave, ultimo_numero)
    VALUES (p_chave, LAST_INSERT_ID(1))
    ON DUPLICATE KEY UPDATE
        ultimo_numero = LAST_INSERT_ID(ultimo_numero + 1);

    SET p_numero = LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_sessao_abrir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_abrir`(
    IN  p_id_usuario          BIGINT,
    IN  p_id_sistema          BIGINT,
    IN  p_id_unidade          BIGINT,
    IN  p_id_local_operacional BIGINT,
    IN  p_token               TEXT,
    IN  p_ip_acesso           VARCHAR(45),
    IN  p_user_agent          TEXT,
    IN  p_expira_em           DATETIME,
    OUT p_id_sessao_usuario   BIGINT
)
BEGIN
    -- valida FKs básicas (para erro mais claro do que 1452)
    IF NOT EXISTS (SELECT 1 FROM usuario u WHERE u.id_usuario = p_id_usuario AND u.ativo = 1) THEN
        CALL sp_raise('USUARIO_INVALIDO', CONCAT('Usuário inexistente/inativo: ', p_id_usuario));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM sistema s WHERE s.id_sistema = p_id_sistema) THEN
        CALL sp_raise('SISTEMA_INVALIDO', CONCAT('Sistema inexistente: ', p_id_sistema));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM unidade un WHERE un.id_unidade = p_id_unidade) THEN
        CALL sp_raise('UNIDADE_INVALIDA', CONCAT('Unidade inexistente: ', p_id_unidade));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM local_operacional lo WHERE lo.id_local_operacional = p_id_local_operacional) THEN
        CALL sp_raise('LOCAL_INVALIDO', CONCAT('Local operacional inexistente: ', p_id_local_operacional));
    END IF;

    INSERT INTO sessao_usuario
        (id_usuario, id_sistema, id_unidade, id_local_operacional, token, ip_acesso, user_agent, iniciado_em, expira_em, ativo)
    VALUES
        (p_id_usuario, p_id_sistema, p_id_unidade, p_id_local_operacional, p_token, p_ip_acesso, p_user_agent, NOW(), p_expira_em, 1);

    SET p_id_sessao_usuario = LAST_INSERT_ID();

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'sessao_usuario',
        p_id_sessao_usuario,
        'SESSAO_ABERTA',
        CONCAT('Sessão aberta para usuario=', p_id_usuario, ' sistema=', p_id_sistema, ' unidade=', p_id_unidade, ' local=', p_id_local_operacional),
        p_id_usuario,
        'sessao_usuario',
        p_id_usuario
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_sessao_assert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_assert`(
    IN p_id_sessao_usuario BIGINT
)
BEGIN
    DECLARE v_ok TINYINT DEFAULT 0;

    -- Sessão precisa existir e estar ativa
    SELECT 1 INTO v_ok
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
       AND su.encerrado_em IS NULL
       AND (su.expira_em IS NULL OR su.expira_em > NOW())
     LIMIT 1;

    CALL sp_assert_true(v_ok = 1, 'SESSAO', 'Sessão inválida/inativa/expirada.');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_sessao_contexto_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_contexto_get`(
    IN p_id_sessao_usuario BIGINT
)
BEGIN
    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT
        su.id_sessao_usuario,
        su.id_usuario,
        su.id_sistema,
        su.id_unidade,
        su.id_local_operacional,
        su.ip_acesso,
        su.user_agent,
        su.iniciado_em,
        su.expira_em,
        su.ativo
    FROM sessao_usuario su
    WHERE su.id_sessao_usuario = p_id_sessao_usuario;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_sessao_encerrar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_encerrar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_motivo            VARCHAR(200)
)
BEGIN
    DECLARE v_id_usuario BIGINT;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT su.id_usuario
      INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario;

    UPDATE sessao_usuario
       SET ativo = 0,
           encerrado_em = NOW(),
           token = NULL
     WHERE id_sessao_usuario = p_id_sessao_usuario;

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'sessao_usuario',
        p_id_sessao_usuario,
        'SESSAO_ENCERRADA',
        CONCAT('Motivo: ', COALESCE(p_motivo,'(n/a)')),
        v_id_usuario,
        'sessao_usuario',
        v_id_usuario
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_sessao_tem_permissao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_tem_permissao`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_permissao         VARCHAR(100),
    OUT p_ok                TINYINT
)
BEGIN
    DECLARE v_id_usuario BIGINT;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT su.id_usuario
      INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario;

    CALL sp_usuario_tem_permissao(v_id_usuario, p_permissao, p_ok);
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_timeout_ffa`(
    IN p_id_sessao_usuario BIGINT,
    IN p_horas_limite      INT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_lim INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_timeout_ffa', 'Falha no timeout FFA');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_timeout_ffa | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SET v_lim = IFNULL(p_horas_limite, 14);
    IF v_lim < 1 THEN SET v_lim = 1; END IF;

    START TRANSACTION;

    UPDATE ffa f
       SET f.status = 'FINALIZADO',
           f.atualizado_em = NOW()
     WHERE f.status IN ('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','AGUARDANDO_RX','AGUARDANDO_COLETA','AGUARDANDO_ECG','AGUARDANDO_RETORNO')
       AND TIMESTAMPDIFF(HOUR, COALESCE(f.atualizado_em, f.criado_em), NOW()) >= v_lim;

    COMMIT;
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_timeout_procedimento_rx`(
    IN p_id_sessao_usuario BIGINT,
    IN p_horas_limite      INT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_lim INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_timeout_procedimento_rx', 'Falha no timeout RX');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_timeout_procedimento_rx | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SET v_lim = IFNULL(p_horas_limite, 8);
    IF v_lim < 1 THEN SET v_lim = 1; END IF;

    START TRANSACTION;

    UPDATE fila_operacional fo
       SET fo.substatus = 'REAVALIAR',
           fo.reavaliar_em = NOW()
     WHERE fo.tipo = 'RX'
       AND fo.substatus = 'EM_EXECUCAO'
       AND fo.data_inicio IS NOT NULL
       AND TIMESTAMPDIFF(HOUR, fo.data_inicio, NOW()) >= v_lim;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_triagem_chamar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_triagem_chamar`(IN p_id_sessao_usuario BIGINT,
        IN p_id_local_operacional BIGINT,
        OUT p_id_fila BIGINT,
        OUT p_id_ffa BIGINT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_triagem_chamar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_triagem_chamar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_fila_chamar_proxima(p_id_sessao_usuario, 'TRIAGEM', p_id_local_operacional, p_id_fila, p_id_ffa);
    UPDATE senhas s
    JOIN ffa f ON f.id_senha = s.id
       SET s.status = 'CHAMANDO',
           s.id_usuario_chamada = (SELECT su.id_usuario FROM sessao_usuario su WHERE su.id_sessao_usuario = p_id_sessao_usuario LIMIT 1),
           s.chamada_em = NOW()
     WHERE f.id = p_id_ffa;

    INSERT INTO senha_eventos(id_sessao_usuario, id_senha, tipo_evento, detalhe, status_de, status_para, criado_em)
    SELECT p_id_sessao_usuario, f.id_senha, 'CHAMAR_SETOR',
           CONCAT('setor=TRIAGEM | id_fila=', p_id_fila),
           NULL, 'CHAMANDO', NOW()
      FROM ffa f
     WHERE f.id = p_id_ffa
       AND f.id_senha IS NOT NULL;

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'CHAMAR',
        CONCAT('setor=TRIAGEM | id_ffa=', p_id_ffa),
        NULL,
        'fila_operacional',
        NULL
    );
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_triagem_finalizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_triagem_finalizar`(IN p_id_sessao_usuario BIGINT,
        IN p_id_fila BIGINT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_triagem_finalizar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_triagem_finalizar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_fila_finalizar(p_id_sessao_usuario, p_id_fila, 'setor=TRIAGEM');
    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'FINALIZAR',
        'setor=TRIAGEM',
        NULL,
        'fila_operacional',
        NULL
    );
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_definir_senha` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_definir_senha`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_usuario_alvo   BIGINT,
    IN  p_nova_senha        VARCHAR(255),
    IN  p_motivo            VARCHAR(255)  -- texto livre para auditoria
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_login VARCHAR(50);
    DECLARE v_hash_composto VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_usuario_definir_senha', 'Falha ao definir senha (TI)');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_usuario_definir_senha | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)'),
                                         ' | CTX=Falha ao definir senha (TI)'));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_usuario_alvo IS NOT NULL, 'PARAM', 'id_usuario_alvo é obrigatório.');
    CALL sp_assert_true(p_nova_senha IS NOT NULL AND LENGTH(p_nova_senha) >= 8, 'PARAM', 'Senha deve ter pelo menos 8 caracteres.');

    SELECT u.login INTO v_login
      FROM usuario u
     WHERE u.id_usuario = p_id_usuario_alvo
       AND u.ativo = 1
     LIMIT 1;

    CALL sp_assert_true(v_login IS NOT NULL, 'NOT_FOUND', 'Usuário alvo não encontrado/ativo.');

    -- regra: não permitir senha = login em definição manual (só em reset TI)
    CALL sp_assert_true(LOWER(p_nova_senha) <> LOWER(v_login), 'SEC', 'Senha não pode ser igual ao login (use reset TI para default).');

    START TRANSACTION;

    CALL sp_usuario_hash_gerar(p_nova_senha, 12000, v_hash_composto);
    CALL sp_assert_true(v_hash_composto IS NOT NULL, 'SEC', 'Falha ao gerar hash de senha.');

    UPDATE usuario
       SET senha_hash = v_hash_composto,
           primeiro_login = 0,
           forcar_troca_senha = 0,
           senha_expira_em = NULL,
           updated_at = CURRENT_TIMESTAMP
     WHERE id_usuario = p_id_usuario_alvo;

    CALL sp_assert_true(ROW_COUNT() = 1, 'NOT_FOUND', 'Usuário alvo não atualizado.');

    INSERT INTO usuario_senha_historico(id_usuario, hash_composto, motivo, id_sessao_usuario, criado_em)
    VALUES (p_id_usuario_alvo, v_hash_composto, 'CRIACAO', p_id_sessao_usuario, NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'USUARIO',
        p_id_usuario_alvo,
        'DEFINIR_SENHA_TI',
        CONCAT('login=',v_login,' | motivo=',IFNULL(p_motivo,'(n/a)')),
        NULL,
        'usuario',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_hash_gerar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_hash_gerar`(
    IN  p_senha VARCHAR(255),
    IN  p_iter  INT,
    OUT p_hash_composto VARCHAR(255)
)
    SQL SECURITY INVOKER
proc: BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_iter INT;
    DECLARE v_salt_hex CHAR(32);
    DECLARE v_hash_hex CHAR(64);

    -- validações
    IF p_senha IS NULL OR LENGTH(p_senha) = 0 THEN
        SET p_hash_composto = NULL;
        LEAVE proc;
    END IF;

    -- mínimo de iterações (ajustável)
    SET v_iter = IFNULL(p_iter, 12000);
    IF v_iter < 12000 THEN
        SET v_iter = 12000;
    END IF;

    -- salt 16 bytes -> 32 hex
    SET v_salt_hex = HEX(RANDOM_BYTES(16));
    IF v_salt_hex IS NULL OR LENGTH(v_salt_hex) <> 32 THEN
        -- fallback determinístico em tamanho (UUID sem hífen)
        SET v_salt_hex = REPLACE(UUID(), '-', '');
    END IF;

    -- primeiro round
    SET v_hash_hex = SHA2(CONCAT(UNHEX(v_salt_hex), p_senha), 256);

    -- rounds adicionais
    WHILE i < v_iter DO
        SET v_hash_hex = SHA2(CONCAT(UNHEX(v_hash_hex), UNHEX(v_salt_hex), p_senha), 256);
        SET i = i + 1;
    END WHILE;

    SET p_hash_composto = CONCAT('SHA256I$', v_iter, '$', v_salt_hex, '$', v_hash_hex);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_hash_verificar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_hash_verificar`(
    IN  p_senha VARCHAR(255),
    IN  p_hash_composto VARCHAR(255),
    OUT p_ok TINYINT
)
    SQL SECURITY INVOKER
proc: BEGIN
    DECLARE v_alg VARCHAR(20);
    DECLARE v_iter INT;
    DECLARE v_salt_hex CHAR(32);
    DECLARE v_hash_hex CHAR(64);

    DECLARE i INT DEFAULT 1;
    DECLARE v_hash_calc CHAR(64);

    SET p_ok = 0;

    IF p_senha IS NULL OR p_hash_composto IS NULL OR LENGTH(p_hash_composto) = 0 THEN
        LEAVE proc;
    END IF;

    -- parse: ALG$ITER$SALT$HASH
    SET v_alg = SUBSTRING_INDEX(p_hash_composto, '$', 1);
    IF v_alg <> 'SHA256I' THEN
        LEAVE proc;
    END IF;

    SET v_iter = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(p_hash_composto, '$', 2), '$', -1) AS UNSIGNED);
    SET v_salt_hex = SUBSTRING_INDEX(SUBSTRING_INDEX(p_hash_composto, '$', 3), '$', -1);
    SET v_hash_hex = SUBSTRING_INDEX(p_hash_composto, '$', -1);

    IF v_iter IS NULL OR v_iter < 12000 THEN
        LEAVE proc;
    END IF;
    IF v_salt_hex IS NULL OR LENGTH(v_salt_hex) <> 32 THEN
        LEAVE proc;
    END IF;
    IF v_hash_hex IS NULL OR LENGTH(v_hash_hex) <> 64 THEN
        LEAVE proc;
    END IF;

    -- calcula
    SET v_hash_calc = SHA2(CONCAT(UNHEX(v_salt_hex), p_senha), 256);
    WHILE i < v_iter DO
        SET v_hash_calc = SHA2(CONCAT(UNHEX(v_hash_calc), UNHEX(v_salt_hex), p_senha), 256);
        SET i = i + 1;
    END WHILE;

    IF v_hash_calc = v_hash_hex THEN
        SET p_ok = 1;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_reset_senha_ti` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_reset_senha_ti`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_usuario_alvo   BIGINT,
    IN p_motivo            VARCHAR(255)
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_login VARCHAR(50);
    DECLARE v_hash_composto VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_usuario_reset_senha_ti', 'Falha ao resetar senha (TI)');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_usuario_reset_senha_ti | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)'),
                                         ' | CTX=Falha ao resetar senha (TI)'));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_usuario_alvo IS NOT NULL, 'PARAM', 'id_usuario_alvo é obrigatório.');

    SELECT u.login INTO v_login
      FROM usuario u
     WHERE u.id_usuario = p_id_usuario_alvo
       AND u.ativo = 1
     LIMIT 1;

    CALL sp_assert_true(v_login IS NOT NULL, 'NOT_FOUND', 'Usuário alvo não encontrado/ativo.');

    START TRANSACTION;

    -- default = login
    CALL sp_usuario_hash_gerar(v_login, 12000, v_hash_composto);
    CALL sp_assert_true(v_hash_composto IS NOT NULL, 'SEC', 'Falha ao gerar hash de senha default.');

    UPDATE usuario
       SET senha_hash = v_hash_composto,
           primeiro_login = 1,
           forcar_troca_senha = 1,
           senha_expira_em = DATE_ADD(NOW(), INTERVAL 7 DAY), -- ajustável (7 dias p/ efetuar troca)
           updated_at = CURRENT_TIMESTAMP
     WHERE id_usuario = p_id_usuario_alvo;

    CALL sp_assert_true(ROW_COUNT() = 1, 'NOT_FOUND', 'Usuário alvo não atualizado.');

    INSERT INTO usuario_senha_historico(id_usuario, hash_composto, motivo, id_sessao_usuario, criado_em)
    VALUES (p_id_usuario_alvo, v_hash_composto, 'RESET_TI', p_id_sessao_usuario, NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'USUARIO',
        p_id_usuario_alvo,
        'RESET_SENHA_TI',
        CONCAT('login=',v_login,' | default=%username% | motivo=',IFNULL(p_motivo,'(n/a)')),
        NULL,
        'usuario',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_tem_permissao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_tem_permissao`(
    IN  p_id_usuario BIGINT,
    IN  p_permissao  VARCHAR(100),
    OUT p_ok         TINYINT
)
BEGIN
    DECLARE v_ok INT DEFAULT 0;

    SELECT 1
      INTO v_ok
      FROM vw_usuario_permissoes v
     WHERE v.id_usuario = p_id_usuario
       AND v.permissao = p_permissao
     LIMIT 1;

    SET p_ok = IFNULL(v_ok, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_trocar_senha` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_trocar_senha`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_usuario        BIGINT,
    IN p_senha_atual       VARCHAR(255),
    IN p_nova_senha        VARCHAR(255)
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_login VARCHAR(50);
    DECLARE v_hash_atual VARCHAR(255);
    DECLARE v_ok TINYINT DEFAULT 0;

    DECLARE v_hash_composto VARCHAR(255);

    -- para checar reuso
    DECLARE done INT DEFAULT 0;
    DECLARE v_hist_hash VARCHAR(255);
    DECLARE cur CURSOR FOR
        SELECT hash_composto
          FROM usuario_senha_historico
         WHERE id_usuario = p_id_usuario
         ORDER BY criado_em DESC
         LIMIT 10;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_usuario_trocar_senha', 'Falha ao trocar senha');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_usuario_trocar_senha | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)'),
                                         ' | CTX=Falha ao trocar senha'));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    CALL sp_assert_true(p_id_usuario IS NOT NULL, 'PARAM', 'id_usuario é obrigatório.');
    CALL sp_assert_true(p_senha_atual IS NOT NULL AND LENGTH(p_senha_atual) > 0, 'PARAM', 'Senha atual é obrigatória.');
    CALL sp_assert_true(p_nova_senha  IS NOT NULL AND LENGTH(p_nova_senha)  >= 8, 'PARAM', 'Nova senha deve ter pelo menos 8 caracteres.');
    CALL sp_assert_true(p_nova_senha <> p_senha_atual, 'SEC', 'Nova senha deve ser diferente da senha atual.');

    SELECT u.login, u.senha_hash
      INTO v_login, v_hash_atual
      FROM usuario u
     WHERE u.id_usuario = p_id_usuario
       AND u.ativo = 1
     LIMIT 1;

    CALL sp_assert_true(v_login IS NOT NULL, 'NOT_FOUND', 'Usuário não encontrado/ativo.');

    -- regra: não permitir nova senha = login
    CALL sp_assert_true(LOWER(p_nova_senha) <> LOWER(v_login), 'SEC', 'Nova senha não pode ser igual ao login.');

    -- valida senha atual
    CALL sp_usuario_hash_verificar(p_senha_atual, v_hash_atual, v_ok);
    CALL sp_assert_true(v_ok = 1, 'SEC', 'Senha atual inválida.');

    -- impede reutilização (re-hash com histórico)
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_hist_hash;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        SET v_ok = 0;
        CALL sp_usuario_hash_verificar(p_nova_senha, v_hist_hash, v_ok);
        IF v_ok = 1 THEN
            CLOSE cur;
            CALL sp_raise('SEC', 'Nova senha não pode reutilizar senhas anteriores (histórico).');
        END IF;
    END LOOP;
    CLOSE cur;

    START TRANSACTION;

    CALL sp_usuario_hash_gerar(p_nova_senha, 12000, v_hash_composto);
    CALL sp_assert_true(v_hash_composto IS NOT NULL, 'SEC', 'Falha ao gerar hash da nova senha.');

    UPDATE usuario
       SET senha_hash = v_hash_composto,
           primeiro_login = 0,
           forcar_troca_senha = 0,
           senha_expira_em = NULL,
           updated_at = CURRENT_TIMESTAMP
     WHERE id_usuario = p_id_usuario;

    CALL sp_assert_true(ROW_COUNT() = 1, 'NOT_FOUND', 'Usuário não atualizado.');

    INSERT INTO usuario_senha_historico(id_usuario, hash_composto, motivo, id_sessao_usuario, criado_em)
    VALUES (p_id_usuario, v_hash_composto, 'TROCA', p_id_sessao_usuario, NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'USUARIO',
        p_id_usuario,
        'TROCAR_SENHA',
        CONCAT('login=',v_login),
        NULL,
        'usuario',
        NULL
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_workflow_ffa_rebuild` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_workflow_ffa_rebuild`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa            BIGINT  -- ffa.id
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_workflow_ffa_rebuild', 'Falha ao rebuild workflow');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_workflow_ffa_rebuild | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa (ffa.id) é obrigatório.');

    START TRANSACTION;

    DELETE FROM workflow_ffa_evento WHERE id_ffa = p_id_ffa;

    INSERT INTO workflow_ffa_evento (
        id_ffa, origem, entidade, id_entidade, tipo_evento, detalhe, id_sessao_usuario, criado_em, payload_json
    )
    SELECT
        w.id_ffa, w.origem, w.entidade, w.id_entidade, w.tipo_evento, w.detalhe, w.id_sessao_usuario, w.criado_em, w.payload_json
    FROM vw_workflow_ffa_completo w
    WHERE w.id_ffa = p_id_ffa
    ORDER BY w.criado_em;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'WORKFLOW_REBUILD', 'workflow_ffa_evento', p_id_ffa);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vw_admin_sessoes_ativas`
--

/*!50001 DROP VIEW IF EXISTS `vw_admin_sessoes_ativas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `vw_admin_sessoes_ativas` AS select `su`.`id_sessao_usuario` AS `id_sessao_usuario`,`su`.`id_usuario` AS `id_usuario`,`u`.`login` AS `login`,`su`.`id_sistema` AS `id_sistema`,`su`.`id_unidade` AS `id_unidade`,`su`.`id_local_operacional` AS `id_local_operacional`,`su`.`ip_acesso` AS `ip_acesso`,`su`.`iniciado_em` AS `iniciado_em`,`su`.`expira_em` AS `expira_em` from (`sessao_usuario` `su` join `usuario` `u` on((`u`.`id_usuario` = `su`.`id_usuario`))) where ((`su`.`ativo` = 1) and (`su`.`encerrado_em` is null) and ((`su`.`expira_em` is null) or (`su`.`expira_em` > now()))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_laboratorio_protocolos_pendentes`
--

/*!50001 DROP VIEW IF EXISTS `vw_laboratorio_protocolos_pendentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_laboratorio_protocolos_pendentes` AS select `lp`.`id_laboratorio_protocolo` AS `id_laboratorio_protocolo`,`lp`.`id_ffa` AS `id_ffa`,`lp`.`id_gpat` AS `id_gpat`,`lp`.`id_pedido_item` AS `id_pedido_item`,`lp`.`codigo` AS `codigo`,`lp`.`status` AS `status`,`lp`.`criado_em` AS `criado_em` from `laboratorio_protocolo` `lp` where (`lp`.`status` in ('GERADO','COLETADO','ENVIADO')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_laboratorio_protocolos_por_gpat`
--

/*!50001 DROP VIEW IF EXISTS `vw_laboratorio_protocolos_por_gpat`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_laboratorio_protocolos_por_gpat` AS select `lp`.`id_laboratorio_protocolo` AS `id_laboratorio_protocolo`,`lp`.`id_ffa` AS `id_ffa`,`lp`.`id_gpat` AS `id_gpat`,`lp`.`id_pedido_item` AS `id_pedido_item`,`lp`.`codigo` AS `codigo`,`lp`.`barcode` AS `barcode`,`lp`.`status` AS `status`,`lp`.`sistema_externo` AS `sistema_externo`,`lp`.`codigo_externo` AS `codigo_externo`,`lp`.`criado_em` AS `criado_em`,`lp`.`atualizado_em` AS `atualizado_em` from `laboratorio_protocolo` `lp` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_config_efetiva`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_config_efetiva`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `vw_painel_config_efetiva` AS select `p`.`id_painel` AS `id_painel`,`p`.`codigo` AS `painel_codigo`,`p`.`tipo` AS `painel_tipo`,`d`.`chave` AS `chave`,`d`.`tipo_valor` AS `tipo_valor`,coalesce(`pc`.`valor_bool`,`pc`.`valor_int`,`pc`.`valor_decimal`,`pc`.`valor_text`,`pc`.`valor_json`,`pc`.`valor_enum`,`d`.`default_bool`,`d`.`default_int`,`d`.`default_decimal`,`d`.`default_text`,`d`.`default_json`,`d`.`default_enum`) AS `valor_efetivo`,`pc`.`atualizado_em` AS `atualizado_em`,`pc`.`id_usuario` AS `id_usuario`,`pc`.`id_sessao_usuario` AS `id_sessao_usuario` from ((`painel` `p` join `painel_config_def` `d` on(((`d`.`ativo` = 1) and (((convert(`d`.`aplica_em` using utf8mb4) collate utf8mb4_0900_ai_ci) = ('TODOS' collate utf8mb4_0900_ai_ci)) or ((convert(`d`.`aplica_em` using utf8mb4) collate utf8mb4_0900_ai_ci) = (convert(`p`.`tipo` using utf8mb4) collate utf8mb4_0900_ai_ci)))))) left join `painel_config` `pc` on(((`pc`.`id_painel` = `p`.`id_painel`) and ((convert(`pc`.`chave` using utf8mb4) collate utf8mb4_0900_ai_ci) = (convert(`d`.`chave` using utf8mb4) collate utf8mb4_0900_ai_ci))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_config_json`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_config_json`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `vw_painel_config_json` AS select `vw_painel_config_efetiva`.`id_painel` AS `id_painel`,`vw_painel_config_efetiva`.`painel_codigo` AS `painel_codigo`,`vw_painel_config_efetiva`.`painel_tipo` AS `painel_tipo`,json_objectagg(`vw_painel_config_efetiva`.`chave`,`vw_painel_config_efetiva`.`valor_efetivo`) AS `config_json`,max(`vw_painel_config_efetiva`.`atualizado_em`) AS `atualizado_em` from `vw_painel_config_efetiva` group by `vw_painel_config_efetiva`.`id_painel`,`vw_painel_config_efetiva`.`painel_codigo`,`vw_painel_config_efetiva`.`painel_tipo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_senhas_chamando`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_senhas_chamando`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `vw_painel_senhas_chamando` AS select `s`.`codigo` AS `codigo`,`s`.`lane` AS `lane`,`s`.`status` AS `status`,`lo`.`nome` AS `local_nome`,`s`.`chamada_em` AS `chamada_em` from (`senhas` `s` join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `s`.`id_local_operacional`))) where ((`lo`.`exibe_em_painel_publico` = 1) and (`lo`.`eh_nao_definida` = 0) and (`s`.`status` in ('CHAMANDO','EM_COMPLEMENTACAO','EM_ATENDIMENTO'))) order by `s`.`chamada_em` desc,`s`.`id` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_senhas_chamando_por_painel`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_senhas_chamando_por_painel`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `vw_painel_senhas_chamando_por_painel` AS select `p`.`id_painel` AS `id_painel`,`p`.`codigo` AS `painel_codigo`,`p`.`tipo` AS `painel_tipo`,`p`.`nome` AS `painel_nome`,`lo`.`id_local_operacional` AS `id_local_operacional`,`lo`.`codigo` AS `local_codigo`,`lo`.`nome` AS `local_nome`,`lo`.`tipo` AS `local_tipo`,`lo`.`sala` AS `local_sala`,`s`.`id` AS `id_senha`,`s`.`codigo` AS `senha_codigo`,`s`.`lane` AS `senha_lane`,`s`.`tipo_atendimento` AS `tipo_atendimento`,`s`.`prioridade` AS `prioridade`,`s`.`status` AS `senha_status`,`s`.`chamada_em` AS `chamada_em` from ((((`painel` `p` join `vw_painel_config_efetiva` `cfg` on(((`cfg`.`id_painel` = `p`.`id_painel`) and ((`cfg`.`chave` collate utf8mb4_0900_ai_ci) = ('FILTRO_LOCAIS_CODIGOS_JSON' collate utf8mb4_0900_ai_ci))))) join json_table(cast(`cfg`.`valor_efetivo` as json), '$[*]' columns (`local_codigo` varchar(30) character set utf8mb4 path '$')) `jt` on((1 = 1))) join `local_operacional` `lo` on(((`lo`.`id_unidade` = `p`.`id_unidade`) and (`lo`.`id_sistema` = `p`.`id_sistema`) and ((`lo`.`codigo` collate utf8mb4_0900_ai_ci) = (`jt`.`local_codigo` collate utf8mb4_0900_ai_ci))))) join `senhas` `s` on((`s`.`id_local_operacional` = `lo`.`id_local_operacional`))) where ((`p`.`ativo` = 1) and (`lo`.`ativo` = 1) and (`lo`.`exibe_em_painel_publico` = 1) and (`s`.`status` = 'CHAMANDO') and (exists(select 1 from `painel_lane` `plx` where (`plx`.`id_painel` = `p`.`id_painel`)) is false or exists(select 1 from `painel_lane` `pl2` where ((`pl2`.`id_painel` = `p`.`id_painel`) and ((`pl2`.`lane` collate utf8mb4_0900_ai_ci) = (`s`.`lane` collate utf8mb4_0900_ai_ci)))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_rastreio_cat_por_ffa`
--

/*!50001 DROP VIEW IF EXISTS `vw_rastreio_cat_por_ffa`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_rastreio_cat_por_ffa` AS select `c`.`id_cat` AS `id_cat`,`c`.`id_ffa` AS `id_ffa`,`c`.`id_gpat` AS `id_gpat`,`c`.`status` AS `status`,`c`.`criado_em` AS `criado_em`,`c`.`atualizado_em` AS `atualizado_em` from `cat_notificacao` `c` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_rastreio_ffa_gpat`
--

/*!50001 DROP VIEW IF EXISTS `vw_rastreio_ffa_gpat`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_rastreio_ffa_gpat` AS select `f`.`id` AS `id_ffa`,`f`.`id_gpat` AS `id_gpat`,`g`.`codigo_gpat` AS `codigo_gpat`,`g`.`barcode_gpat` AS `barcode_gpat`,`g`.`criado_em` AS `gpat_criado_em` from (`ffa` `f` left join `gpat` `g` on((`g`.`id_gpat` = `f`.`id_gpat`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_senhas_ativas`
--

/*!50001 DROP VIEW IF EXISTS `vw_senhas_ativas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `vw_senhas_ativas` AS select `s`.`id` AS `id_senha`,`s`.`codigo` AS `codigo`,`s`.`tipo_atendimento` AS `tipo_atendimento`,`s`.`lane` AS `lane`,`s`.`prioridade` AS `prioridade`,`s`.`status` AS `status`,`s`.`origem` AS `origem`,`s`.`id_sistema` AS `id_sistema`,`s`.`id_unidade` AS `id_unidade`,`s`.`id_local_operacional` AS `id_local_operacional`,`lo`.`nome` AS `local_nome`,`lo`.`exibe_em_painel_publico` AS `exibe_em_painel_publico`,`lo`.`gera_tts_publico` AS `gera_tts_publico`,`s`.`criada_em` AS `criada_em`,`s`.`posicionado_em` AS `posicionado_em`,`s`.`chamada_em` AS `chamada_em`,`s`.`inicio_atendimento_em` AS `inicio_atendimento_em`,`s`.`finalizada_em` AS `finalizada_em` from (`senhas` `s` left join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `s`.`id_local_operacional`))) where (`s`.`status` not in ('CANCELADA','FINALIZADA')) */;
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `vw_usuario_permissoes` AS select `us`.`id_usuario` AS `id_usuario`,`us`.`id_sistema` AS `id_sistema`,`us`.`id_perfil` AS `id_perfil`,coalesce(`pm`.`codigo`,`pp`.`permissao`) AS `permissao` from ((`usuario_sistema` `us` join `perfil_permissao` `pp` on((`pp`.`id_perfil` = `us`.`id_perfil`))) left join `permissao` `pm` on((`pm`.`id_permissao` = `pp`.`id_permissao`))) where ((`us`.`ativo` = 1) and (coalesce(`pm`.`codigo`,`pp`.`permissao`) is not null)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_workflow_ffa_completo`
--

/*!50001 DROP VIEW IF EXISTS `vw_workflow_ffa_completo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_workflow_ffa_completo` AS select `f`.`id` AS `id_ffa`,'SENHA' AS `origem`,'senha' AS `entidade`,`se`.`id_senha` AS `id_entidade`,`se`.`tipo_evento` AS `tipo_evento`,`se`.`detalhe` AS `detalhe`,`se`.`id_sessao_usuario` AS `id_sessao_usuario`,`se`.`criado_em` AS `criado_em`,NULL AS `payload_json` from (`senha_eventos` `se` join `ffa` `f` on((`f`.`id_senha` = `se`.`id_senha`))) union all select `fo`.`id_ffa` AS `id_ffa`,'FILA' AS `origem`,'fila_operacional' AS `entidade`,`fe`.`id_fila` AS `id_entidade`,`fe`.`tipo_evento` AS `tipo_evento`,`fe`.`detalhe` AS `detalhe`,`fe`.`id_sessao_usuario` AS `id_sessao_usuario`,`fe`.`criado_em` AS `criado_em`,NULL AS `payload_json` from (`fila_operacional_evento` `fe` join `fila_operacional` `fo` on((`fo`.`id_fila` = `fe`.`id_fila`))) union all select (case when (`ae`.`entidade` = 'ffa') then `ae`.`id_entidade` when (`ae`.`entidade` = 'pedido_medico') then `pm`.`id_ffa` when (`ae`.`entidade` = 'pedido_medico_item') then `pm2`.`id_ffa` when (`ae`.`entidade` = 'gpat') then `g`.`id_ffa` when (`ae`.`entidade` = 'pep_registro') then `pr`.`id_ffa` when (`ae`.`entidade` = 'cat_notificacao') then `cn`.`id_ffa` when (`ae`.`entidade` = 'sinan_notificacao') then `sn`.`id_ffa` else NULL end) AS `id_ffa`,'AUD' AS `origem`,`ae`.`entidade` AS `entidade`,`ae`.`id_entidade` AS `id_entidade`,`ae`.`acao` AS `tipo_evento`,`ae`.`detalhe` AS `detalhe`,`ae`.`id_sessao_usuario` AS `id_sessao_usuario`,`ae`.`criado_em` AS `criado_em`,NULL AS `payload_json` from (((((((`auditoria_evento` `ae` left join `pedido_medico` `pm` on(((`ae`.`entidade` = 'pedido_medico') and (`pm`.`id_pedido_medico` = `ae`.`id_entidade`)))) left join `pedido_medico_item` `pmi` on(((`ae`.`entidade` = 'pedido_medico_item') and (`pmi`.`id_pedido_item` = `ae`.`id_entidade`)))) left join `pedido_medico` `pm2` on((`pmi`.`id_pedido_medico` = `pm2`.`id_pedido_medico`))) left join `gpat` `g` on(((`ae`.`entidade` = 'gpat') and (`g`.`id_gpat` = `ae`.`id_entidade`)))) left join `pep_registro` `pr` on(((`ae`.`entidade` = 'pep_registro') and (`pr`.`id_pep_registro` = `ae`.`id_entidade`)))) left join `cat_notificacao` `cn` on(((`ae`.`entidade` = 'cat_notificacao') and (`cn`.`id_cat` = `ae`.`id_entidade`)))) left join `sinan_notificacao` `sn` on(((`ae`.`entidade` = 'sinan_notificacao') and (`sn`.`id_sinan` = `ae`.`id_entidade`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_workflow_ffa_eventos_materializado`
--

/*!50001 DROP VIEW IF EXISTS `vw_workflow_ffa_eventos_materializado`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_workflow_ffa_eventos_materializado` AS select `workflow_ffa_evento`.`id_workflow_evento` AS `id_workflow_evento`,`workflow_ffa_evento`.`id_ffa` AS `id_ffa`,`workflow_ffa_evento`.`origem` AS `origem`,`workflow_ffa_evento`.`entidade` AS `entidade`,`workflow_ffa_evento`.`id_entidade` AS `id_entidade`,`workflow_ffa_evento`.`tipo_evento` AS `tipo_evento`,`workflow_ffa_evento`.`detalhe` AS `detalhe`,`workflow_ffa_evento`.`id_sessao_usuario` AS `id_sessao_usuario`,`workflow_ffa_evento`.`criado_em` AS `criado_em` from `workflow_ffa_evento` */;
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

-- Dump completed on 2026-02-18 18:18:06
