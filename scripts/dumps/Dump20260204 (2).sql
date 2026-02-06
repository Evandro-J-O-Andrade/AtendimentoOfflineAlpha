CREATE DATABASE  IF NOT EXISTS `pronto_atendimento` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atendimento`
--

LOCK TABLES `atendimento` WRITE;
/*!40000 ALTER TABLE `atendimento` DISABLE KEYS */;
INSERT INTO `atendimento` VALUES (1,'20260128061710',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:17:10',NULL,'ABERTO'),(2,'20260128061737',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:17:37',NULL,'ABERTO'),(3,'20260128062016',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:20:16',NULL,'ABERTO'),(4,'20260128062042',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:20:42',NULL,'ABERTO'),(5,'20260128062125',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:21:25',NULL,'ABERTO'),(6,'20260128062157',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:21:57',NULL,'ABERTO'),(7,'20260128062220',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:22:20',NULL,'ABERTO'),(8,'20260128062254',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:22:54',NULL,'ABERTO'),(9,'20260128062606',NULL,8,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:26:06',NULL,'ABERTO'),(10,'20249999',NULL,31,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:29:42',NULL,'ABERTO'),(11,'20260128063019',NULL,33,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:30:20',NULL,'ABERTO'),(12,'20260128063119',NULL,33,2,NULL,'ABERTO',NULL,NULL,NULL,'2026-01-28 06:31:19',NULL,'ABERTO');
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
  `id_sessao` bigint NOT NULL,
  `dominio` enum('FILA','ASSISTENCIAL','FINANCEIRO','ESTOQUE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `acao` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tabela_afetada` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_registro` bigint DEFAULT NULL,
  `valor_anterior` json DEFAULT NULL,
  `valor_novo` json DEFAULT NULL,
  `motivo_alteracao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `data_evento` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_audit_sessao` (`id_sessao`),
  CONSTRAINT `fk_audit_sessao` FOREIGN KEY (`id_sessao`) REFERENCES `sessao_operacional` (`id`)
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cidade`
--

LOCK TABLES `cidade` WRITE;
/*!40000 ALTER TABLE `cidade` DISABLE KEYS */;
INSERT INTO `cidade` VALUES (2,'São Paulo','SP',NULL,1);
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
-- Table structure for table `config_sistema_alpha`
--

DROP TABLE IF EXISTS `config_sistema_alpha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_sistema_alpha` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_unidade` bigint NOT NULL,
  `parametro` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `valor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_config_unid` (`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_sistema_alpha`
--

LOCK TABLES `config_sistema_alpha` WRITE;
/*!40000 ALTER TABLE `config_sistema_alpha` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_sistema_alpha` ENABLE KEYS */;
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
  `origem` enum('COMPRA','TRANSFERENCIA','PACIENTE','AJUSTE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `status` enum('ABERTA','EM_REVISAO','FECHADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ABERTA',
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
  `substatus` enum('AGUARDANDO','EM_EXECUCAO','EM_OBSERVACAO','FINALIZADO','CRITICO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'AGUARDANDO' COMMENT 'Substatus do paciente nesta fila',
  `prioridade` enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'AZUL' COMMENT 'Prioridade de Manchester',
  `data_entrada` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Chegada na fila',
  `entrada_original_em` datetime DEFAULT NULL,
  `nao_compareceu_em` datetime DEFAULT NULL,
  `retorno_permitido_ate` datetime DEFAULT NULL,
  `retorno_utilizado` tinyint(1) NOT NULL DEFAULT '0',
  `retorno_em` datetime DEFAULT NULL,
  `data_inicio` datetime DEFAULT NULL COMMENT 'Início do atendimento/exame',
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
  KEY `idx_fs_senha` (`id_senha`),
  CONSTRAINT `fk_fs_senhas` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fila_senha`
--

LOCK TABLES `fila_senha` WRITE;
/*!40000 ALTER TABLE `fila_senha` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forma_pagamento`
--

LOCK TABLES `forma_pagamento` WRITE;
/*!40000 ALTER TABLE `forma_pagamento` DISABLE KEYS */;
INSERT INTO `forma_pagamento` VALUES (1,'DINHEIRO','Dinheiro'),(2,'PIX','PIX'),(3,'DEBITO','Cartão de débito'),(4,'CREDITO','Cartão de crédito');
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
  PRIMARY KEY (`id`),
  KEY `fk_mov_internacao` (`id_internacao`),
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
-- Table structure for table `lab_pedido_alpha`
--

DROP TABLE IF EXISTS `lab_pedido_alpha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lab_pedido_alpha` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint DEFAULT NULL,
  `protocolo_interno` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `codigo_barras` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('CRIADO','COLETADO','ENVIADO','CONCLUIDO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'CRIADO',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_protocolo` (`protocolo_interno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lab_pedido_alpha`
--

LOCK TABLES `lab_pedido_alpha` WRITE;
/*!40000 ALTER TABLE `lab_pedido_alpha` DISABLE KEYS */;
/*!40000 ALTER TABLE `lab_pedido_alpha` ENABLE KEYS */;
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
  CONSTRAINT `fk_lab_protocolo_ffa_v1` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`)
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
  `id_local_estoque` bigint DEFAULT NULL,
  `sala` varchar(50) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_local_operacional`),
  UNIQUE KEY `uk_localop` (`id_unidade`,`id_sistema`,`codigo`),
  KEY `idx_localop_unidade` (`id_unidade`),
  KEY `idx_localop_sistema` (`id_sistema`),
  KEY `idx_localop_estoque` (`id_local_estoque`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `local_operacional`
--

LOCK TABLES `local_operacional` WRITE;
/*!40000 ALTER TABLE `local_operacional` DISABLE KEYS */;
INSERT INTO `local_operacional` VALUES (1,2,4,'ADM01','Administração','ADMIN',NULL,NULL,1,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(2,2,4,'REC01','Recepção','RECEPCAO',NULL,NULL,1,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(3,2,4,'TRI01','Triagem','TRIAGEM',NULL,NULL,1,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(4,2,4,'MEDC1','Médico Clínico','MEDICO_CLINICO',NULL,NULL,1,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(5,2,4,'MEDP1','Médico Pediátrico','MEDICO_PEDIATRICO',NULL,NULL,1,'2026-01-27 23:40:56','2026-01-27 23:40:56'),(6,2,4,'TOT01','Totem','OUTRO',NULL,NULL,1,'2026-01-27 23:40:56','2026-01-27 23:40:56');
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
-- Table structure for table `medico`
--

DROP TABLE IF EXISTS `medico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medico` (
  `id_usuario` bigint NOT NULL,
  `crm` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `uf_crm` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `nome` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `crm` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  PRIMARY KEY (`id`)
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
-- Table structure for table `ordem_assistencial_item`
--

DROP TABLE IF EXISTS `ordem_assistencial_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordem_assistencial_item` (
  `id_item` bigint NOT NULL AUTO_INCREMENT,
  `id_ordem` bigint NOT NULL,
  `id_farmaco` bigint NOT NULL,
  `dose` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `posologia` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dias` int DEFAULT NULL,
  `quantidade_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` enum('ATIVO','SUSPENSO','ENCERRADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATIVO',
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_por` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_por` bigint DEFAULT NULL,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_item`),
  KEY `idx_item_ordem` (`id_ordem`),
  KEY `idx_item_farmaco` (`id_farmaco`),
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
-- Table structure for table `painel`
--

DROP TABLE IF EXISTS `painel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel` (
  `id_painel` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('PAINEL','TOTEM','TV') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PAINEL',
  `nome` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painel`
--

LOCK TABLES `painel` WRITE;
/*!40000 ALTER TABLE `painel` DISABLE KEYS */;
INSERT INTO `painel` VALUES (1,'RECEPCAO','PAINEL','Painel Recepção','Fila de senha (chamada manual) + últimos chamados',NULL,NULL,1,20,1,'2026-02-03 05:52:46',NULL,120,NULL),(2,'TRIAGEM','PAINEL','Painel Triagem','Fila setorial TRIAGEM (somente leitura)',NULL,NULL,1,20,1,'2026-02-03 05:52:46',NULL,120,NULL),(3,'CLINICO','PAINEL','Painel Clínico','Fila do médico clínico (adulto)',NULL,NULL,1,20,1,'2026-02-03 05:52:46',NULL,120,NULL),(4,'PEDIATRICO','PAINEL','Painel Pediátrico','Fila do médico pediátrico',NULL,NULL,1,20,1,'2026-02-03 05:52:46',NULL,120,NULL),(5,'MEDICACAO','PAINEL','Painel Medicação','Fila setorial MEDICACAO',NULL,NULL,1,20,1,'2026-02-03 05:52:46',NULL,120,NULL),(6,'COLETA','PAINEL','Painel Coleta','Fila setorial EXAME/COLETA',NULL,NULL,1,20,1,'2026-02-03 05:52:46',NULL,120,NULL),(7,'RX','PAINEL','Painel RX','Fila setorial RX',NULL,NULL,1,20,1,'2026-02-03 05:52:46',NULL,120,NULL),(8,'CONFORTO','PAINEL','Painel Conforto','Resumo de espera e últimas chamadas (sala de espera)',NULL,NULL,1,20,1,'2026-02-03 05:52:46',NULL,120,NULL),(9,'TOTEM_SENHA','TOTEM','Totem Senha','Geração de senha + banner plantão do dia',NULL,NULL,0,0,1,'2026-02-03 05:52:46',NULL,120,NULL),(10,'TOTEM_SATISFACAO','TOTEM','Totem Satisfação','Coleta de feedback do paciente',NULL,NULL,0,0,1,'2026-02-03 05:52:46',NULL,120,NULL),(11,'TV_ROTATIVO','TV','TV Rotativo','TV única rotativa (2 min por tela)',NULL,NULL,1,20,1,'2026-02-03 05:52:46',NULL,120,NULL),(23,'MEDICO_CLINICO','PAINEL','Painel Médico Clínico',NULL,NULL,NULL,0,20,1,'2026-02-03 06:19:42',NULL,0,NULL),(24,'MEDICO_PEDI','PAINEL','Painel Médico Pediátrico',NULL,NULL,NULL,0,20,1,'2026-02-03 06:19:42',NULL,0,NULL),(78,'MEDICACAO_ADULTO','PAINEL','Painel Medicação Adulto',NULL,NULL,NULL,1,20,1,'2026-02-03 23:59:51',NULL,0,NULL),(79,'MEDICACAO_PEDI','PAINEL','Painel Medicação Pediátrica',NULL,NULL,NULL,1,20,1,'2026-02-03 23:59:51',NULL,0,NULL),(150,'MEDICACAO_INF','PAINEL','Painel Medicação Infantil',NULL,NULL,NULL,1,20,1,'2026-02-04 00:02:19',NULL,0,NULL),(221,'RX_2','PAINEL','Painel RX 2',NULL,1,123,1,20,1,'2026-02-04 00:05:17',NULL,0,NULL),(247,'MEDICO_CLINICO_SALA3','PAINEL','Painel Médico Clínico - Sala 3',NULL,1,123,0,20,1,'2026-02-04 01:43:20',NULL,0,NULL),(249,'TV_CLINICO','TV','TV Rotativa - Clínico',NULL,NULL,NULL,0,20,1,'2026-02-04 04:03:41',NULL,120,NULL),(250,'MONITOR_MEDICOS','PAINEL','Painel Monitoramento Médicos','Mosaico/KPIs por especialidade/local',NULL,NULL,1,20,1,'2026-02-04 07:01:23',NULL,15,NULL);
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
  `codigo` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `nome` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
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
-- Table structure for table `painel_mensagem`
--

DROP TABLE IF EXISTS `painel_mensagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painel_mensagem` (
  `id_mensagem` bigint NOT NULL AUTO_INCREMENT,
  `id_painel` bigint NOT NULL,
  `tipo` enum('ALERTA','CHAMAR_MEDICO','INFO','URGENTE') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ALERTA',
  `titulo` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `texto` text COLLATE utf8mb4_general_ci NOT NULL,
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
  `consumido_por` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfil`
--

LOCK TABLES `perfil` WRITE;
/*!40000 ALTER TABLE `perfil` DISABLE KEYS */;
INSERT INTO `perfil` VALUES (1,'ADMIN'),(7,'ADMIN_MASTER'),(3,'ENFERMAGEM'),(6,'MASTER'),(4,'MEDICO'),(5,'PAINEL'),(2,'RECEPCAO'),(8,'TRIAGEM');
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
INSERT INTO `perfil_permissao` VALUES (2,8,NULL),(4,2,NULL),(4,7,NULL),(5,3,NULL),(5,4,NULL),(5,5,NULL),(7,9,NULL),(7,15,'ACESSO_TOTAL'),(7,16,'SELECIONAR_CONTEXTO'),(7,17,'OPERAR_FILA'),(7,18,'ADMIN_USUARIOS');
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissao`
--

LOCK TABLES `permissao` WRITE;
/*!40000 ALTER TABLE `permissao` DISABLE KEYS */;
INSERT INTO `permissao` VALUES (1,'ABRIR_ATENDIMENTO','Abrir atendimento'),(2,'REGISTRAR_TRIAGEM','Registrar triagem'),(3,'REALIZAR_ANAMNESE','Registrar anamnese'),(4,'PRESCREVER','Emitir prescrição'),(5,'FINALIZAR_ATENDIMENTO','Finalizar atendimento'),(6,'REABRIR_ATENDIMENTO','Reabrir atendimento'),(7,'ADMINISTRAR_MEDICACAO','Administrar medicação'),(8,'VER_RELATORIOS','Acessar relatórios'),(9,'VER_AUDITORIA','Visualizar auditoria'),(15,'ACESSO_TOTAL','Acesso total ao sistema'),(16,'SELECIONAR_CONTEXTO','Selecionar contexto operacional (sistema/unidade/local)'),(17,'OPERAR_FILA','Operar fila (chamar/iniciar/finalizar/não atendeu/encaminhar)'),(18,'ADMIN_USUARIOS','Administrar usuários (criar/ativar/inativar/vincular perfil)');
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa`
--

LOCK TABLES `pessoa` WRITE;
/*!40000 ALTER TABLE `pessoa` DISABLE KEYS */;
INSERT INTO `pessoa` VALUES (1,'Teste Usuario',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'Yasnanakase Master','Yasnanakase',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'Yasnanakase Master','Yasnanakase',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,'Yasnanakase Master','Yasnanakase',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,'Administrador do Sistema',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,'TOTEM (Sistema)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,'GESTOR EINSTEIN','ADMIN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,'PACIENTE TESTE EINSTEIN',NULL,'12345678901',NULL,NULL,NULL,'1990-01-01',NULL,NULL,NULL,NULL,NULL,NULL),(9,'ADMINISTRADOR ALPHA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,'PACIENTE TESTE EINSTEIN',NULL,'999.999.999-99',NULL,NULL,NULL,'1990-05-20',NULL,NULL,NULL,NULL,NULL,NULL),(11,'MARIA RECEPCAO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(12,'JOAO ENFERMEIRO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(13,'DR EINSTEIN MEDICO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(14,'MARIA RECEPCAO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(15,'JOAO ENFERMEIRO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(16,'DR EINSTEIN MEDICO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(17,'PACIENTE TESTE EINSTEIN',NULL,'123.456.789-00',NULL,NULL,NULL,'1990-01-01',NULL,NULL,NULL,NULL,NULL,NULL),(31,'PACIENTE REAL V2',NULL,'000.000.000-00',NULL,NULL,NULL,'1995-05-05',NULL,NULL,NULL,NULL,NULL,NULL),(33,'PACIENTE TESTE EINSTEIN',NULL,'853.965.365-00',NULL,NULL,NULL,'1990-01-01',NULL,NULL,NULL,NULL,NULL,NULL);
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
  `nome_medico` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_plantao` enum('CLINICO','PEDIATRIA','EMERGENCIA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
  `turno` enum('DIA','NOITE','24H','CUSTOM') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
-- Table structure for table `senha_eventos`
--

DROP TABLE IF EXISTS `senha_eventos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `senha_eventos` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_senha` bigint NOT NULL,
  `id_sessao_usuario` bigint NOT NULL,
  `status_anterior` varchar(50) DEFAULT NULL,
  `status_novo` varchar(50) DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `fk_evento_senha` (`id_senha`),
  CONSTRAINT `fk_evento_senha` FOREIGN KEY (`id_senha`) REFERENCES `senhas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `senha_eventos`
--

LOCK TABLES `senha_eventos` WRITE;
/*!40000 ALTER TABLE `senha_eventos` DISABLE KEYS */;
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
  `status` enum('GERADA','AGUARDANDO','CHAMANDO','EM_COMPLEMENTACAO','FINALIZADO','NAO_COMPARECEU','CANCELADO','EM_ATENDIMENTO') NOT NULL DEFAULT 'GERADA',
  `prioridade` tinyint DEFAULT '0',
  `id_paciente` bigint DEFAULT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `id_usuario_operador` bigint DEFAULT NULL,
  `id_usuario_chamada` bigint DEFAULT NULL,
  `criada_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `posicionado_em` datetime DEFAULT NULL,
  `chamada_em` datetime DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `senhas`
--

LOCK TABLES `senhas` WRITE;
/*!40000 ALTER TABLE `senhas` DISABLE KEYS */;
INSERT INTO `senhas` VALUES (1,1,NULL,2,1,'A','A001','2026-01-28','CLINICO','ADULTO','RECEPCAO','AGUARDANDO',0,8,NULL,NULL,NULL,NULL,'2026-01-28 06:01:27','2026-01-28 06:01:27',NULL,NULL,NULL,NULL,NULL,0,NULL);
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
-- Table structure for table `sessao`
--

DROP TABLE IF EXISTS `sessao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessao` (
  `id_sessao` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `token` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
-- Table structure for table `sessao_operacional`
--

DROP TABLE IF EXISTS `sessao_operacional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessao_operacional` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `id_unidade` int NOT NULL,
  `id_local` int NOT NULL,
  `ip_maquina` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `token_sessao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `inicio_sessao` datetime DEFAULT CURRENT_TIMESTAMP,
  `fim_sessao` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sessao_usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessao_operacional`
--

LOCK TABLES `sessao_operacional` WRITE;
/*!40000 ALTER TABLE `sessao_operacional` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessao_operacional` ENABLE KEYS */;
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
  `encerrado_em` datetime DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_sessao_usuario`),
  KEY `idx_su_usuario` (`id_usuario`),
  KEY `idx_su_contexto` (`id_sistema`,`id_unidade`,`id_local_operacional`),
  KEY `fk_su_unidade` (`id_unidade`),
  KEY `fk_su_localop` (`id_local_operacional`),
  KEY `idx_sessao_ativa_v2` (`ativo`,`id_sistema`,`id_unidade`,`id_local_operacional`,`iniciado_em`),
  KEY `idx_sessao_token` (`token`(255)),
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema`
--

LOCK TABLES `sistema` WRITE;
/*!40000 ALTER TABLE `sistema` DISABLE KEYS */;
INSERT INTO `sistema` VALUES (1,'','PA','Pronto Atendimento',1,'2026-01-17 22:59:54'),(2,'','UBS','Unidade Básica de Saúde',1,'2026-01-17 22:59:54'),(4,'PA','Pronto Atendimento','Contexto operacional do PA',1,'2026-01-27 23:40:56');
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
-- Table structure for table `triagem_alpha`
--

DROP TABLE IF EXISTS `triagem_alpha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `triagem_alpha` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_usuario_enfermeiro` bigint NOT NULL,
  `pa_sistolica` int DEFAULT NULL,
  `pa_diastolica` int DEFAULT NULL,
  `temperatura` decimal(4,1) DEFAULT NULL,
  `frequencia_cardiaca` int DEFAULT NULL,
  `frequencia_respiratoria` int DEFAULT NULL,
  `saturacao` int DEFAULT NULL,
  `glicemia` int DEFAULT NULL,
  `peso` decimal(5,2) DEFAULT NULL,
  `classificacao_cor` enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `queixa_principal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_triagem_atend` (`id_atendimento`),
  CONSTRAINT `fk_triagem_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `triagem_alpha`
--

LOCK TABLES `triagem_alpha` WRITE;
/*!40000 ALTER TABLE `triagem_alpha` DISABLE KEYS */;
/*!40000 ALTER TABLE `triagem_alpha` ENABLE KEYS */;
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
  `codigo_tela` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
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
  `tipo` enum('UPA','HOSPITAL','PA','CLINICA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_unidade`),
  KEY `id_cidade` (`id_cidade`),
  KEY `id_sistema` (`id_sistema`),
  CONSTRAINT `unidade_ibfk_1` FOREIGN KEY (`id_cidade`) REFERENCES `cidade` (`id_cidade`),
  CONSTRAINT `unidade_ibfk_2` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unidade`
--

LOCK TABLES `unidade` WRITE;
/*!40000 ALTER TABLE `unidade` DISABLE KEYS */;
INSERT INTO `unidade` VALUES (2,4,2,'Unidade Principal','PA',1);
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
INSERT INTO `usuario_refresh` VALUES (1,1,'7558537e0f4678dc571d37461ddd4555bf280e5bcaf43edce1e638398be9be30','2026-02-03 07:47:25','2026-01-04 03:47:25',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(2,1,'038e6bddb719e4a51cc0e1a575a71db374ccfe0ff7483e4f19bd25684540cfa1','2026-02-03 07:47:54','2026-01-04 03:47:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(3,8,'0ed677b9f9c732b6970b679389ec573a7221e265976b7a7fa1e1dbeb472b1072','2026-02-03 07:49:00','2026-01-04 03:49:00',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(4,9,'8181ee9d9b37e8463f84891ac6e1107d2b03a9173600559a3a53c1106f32cde0','2026-02-03 07:49:19','2026-01-04 03:49:19',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(5,9,'6d2b06a8740ca74fdaf5198193eab9493e863f5dd89b5d91173cbd565b78bfe8','2026-02-03 07:49:26','2026-01-04 03:49:26',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(6,1,'e9368a2fa2cd9c794d113943b69e0ea15379e8ab3f392fd44ce06733683366fc','2026-02-03 07:49:36','2026-01-04 03:49:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(7,1,'3c6d3785a575a5329bbc2cbab2ac77c4e383f378a2c402f606158241a87dca3a','2026-02-03 07:56:23','2026-01-04 03:56:23',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(8,1,'aeeae656c5031a47cc723b57dce6ab2192c79c48da906185e3a997b8a7d38876','2026-02-03 07:56:35','2026-01-04 03:56:35',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(9,10,'63a9134e1f7c6212363617256966779a99347fa0d48fa5989fa2751c9138720d','2026-02-03 07:56:43','2026-01-04 03:56:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(10,10,'75ecf45da83ef65781bdaf830659747744a4171898481213b1e6927de5bc6452','2026-02-03 07:56:47','2026-01-04 03:56:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(11,1,'3b271a484feac2c3d70edbc30b0d2f0b63a943ec5181cd5f6da2cd2076a5e813','2026-02-03 07:56:54','2026-01-04 03:56:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(12,1,'a72d64a7a3f2fe19fa98374b60c0e2a0048e735e2f3caf39f0212ed89ed6acfa','2026-02-03 08:40:46','2026-01-04 04:40:46',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','192.168.1.98'),(13,1,'d9888ebd86d886a9da4450d9ed1449ce5a0919b0bf6d7a95e434b4c5c9f9654d','2026-02-03 08:55:54','2026-01-04 04:55:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(14,1,'9403ed66083c17ad2c7f184908f86b1a987c5e0a15a268f40e0dd75057246d02','2026-02-03 09:03:02','2026-01-04 05:03:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(15,1,'348ef17cab1bfecbda0958766585249ad583c689828ba3b6d64477b449639ca1','2026-02-03 09:10:33','2026-01-04 05:10:33',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(16,1,'d7b840c8101f2fb18af2b40c4a7f72f2a8e3c92c2cd7deb18ca18dd5e4a16b41','2026-02-03 09:37:58','2026-01-04 05:37:58',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','192.168.1.83'),(17,1,'52f96f976bee6753fb807d424ba46b1db9f1afc0f70f0b15c64d499020bfc111','2026-02-03 10:09:34','2026-01-04 06:09:34',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(18,1,'ea39406997ed7e387ed802ec4038830190e6f83ae6cca3c0f8059e8ee96e68f2','2026-02-03 10:59:19','2026-01-04 06:59:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(19,1,'311e38f8349d2deac3cfb8821a0135b0fb441def0d9b4f9c900c63d88b3a02fb','2026-02-03 10:59:52','2026-01-04 06:59:52',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(20,1,'dc57186ddcc023147184e19d8c446ef334cd8f8ec56211c0cee30385e9f4c9ce','2026-02-05 03:35:43','2026-01-05 23:35:43',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(21,1,'1d66ce3913a2c1679fdad13bef71dd1dea554b9ca755dea92adc5f71812ec347','2026-02-05 05:39:13','2026-01-06 01:39:13',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(22,1,'03517b7bc56313c2b8c59caf2a80368f2a391343173bbd293e16aab445fc9ac7','2026-02-05 05:39:19','2026-01-06 01:39:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(23,1,'ee256159aebaf39ef214a3283db5044c982e07c3d2e2bf2fd48273b4c7a11609','2026-02-05 06:02:20','2026-01-06 02:02:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(24,1,'a41916d0eff118e627c0f6489d72e7173855b92f53ba287ea897c621744711eb','2026-02-05 07:01:20','2026-01-06 03:01:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(25,1,'f3d363567013537917c9ab2a7aebb0c82c96a72545a74e21be24ced484b0a4e1','2026-02-05 07:45:34','2026-01-06 03:45:34',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(26,1,'8ebe10c569aa8a2976daee030c961d53a6a8c4ddfeb6f768ac855370dbd75f6d','2026-02-05 07:46:19','2026-01-06 03:46:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(27,1,'57217d8839b1be180d4e03495e9748b5e4bb6042cfdfb70fa7da6ca8165e62ca','2026-02-05 07:46:32','2026-01-06 03:46:32',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(28,1,'00c1f42e7a7d81001f5a3d952084799f33ca4e444bf35842d4a13e312f921739','2026-02-05 07:46:41','2026-01-06 03:46:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(29,1,'581cc1c545bdae9c748ea4c926319c397ae362a911bdcc23e6813fbbd7d11dd9','2026-02-05 07:47:31','2026-01-06 03:47:31',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(30,1,'7bf2b7083ecf6fcbcb950453197cc8aee6fc21d2024c6625c58e070f571bb92c','2026-02-05 08:19:14','2026-01-06 04:19:14',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(31,1,'8f393bd2e02ced0104c43ee67d5bf2b404c4f78b261df515c135bc6f968d3ccc','2026-02-05 09:18:14','2026-01-06 05:18:14',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(32,1,'f3d8913e6fbc5ddc48905ae9766aca03dfdf0fb890100be507b9c099b305ca29','2026-02-05 10:17:14','2026-01-06 06:17:14',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(33,9,'d7838e2c89646f13d3553d8f98e8db59d6e3adeac5eff1048d11957d249a1899','2026-02-05 10:17:28','2026-01-06 06:17:28',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(34,9,'be9cbb4df4cf4f0b8d7bd1b4acea368f3afdc20b899913c1cc69a5f33dfadec4','2026-02-05 10:17:34','2026-01-06 06:17:34',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(35,9,'12870eb9471c765edca5e0e4242a279642943420902372d5efb008a33d2bc0bf','2026-02-05 10:17:36','2026-01-06 06:17:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(36,9,'84a4b423e59734a4fab04cf176c58b55ee62397a104635bcc98ff0c1e9498af4','2026-02-05 10:17:37','2026-01-06 06:17:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(37,9,'b6d826e9f9ceb47d498e0dc0b0e362f72e74c8c9f81992631c4020a6aab385ce','2026-02-05 10:17:37','2026-01-06 06:17:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(38,9,'e6d8338ab872c353469dece8096c2f45cff4dd11d5b48c4ca7a6a37f824748aa','2026-02-05 10:17:37','2026-01-06 06:17:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(39,9,'1f379535720b142656c2efb4019ee650716b4f7d9af0678d66ccd573500f6d64','2026-02-05 10:17:37','2026-01-06 06:17:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(40,6,'51cb714ad7807cf99597b91abc9d87902b758b7c52a489a8185e7fca072284b4','2026-02-05 10:17:55','2026-01-06 06:17:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(41,1,'1953f070894b37241bfeafc790a7b54256463a395dbbe2bc8e9d5a2f3e833eb0','2026-02-05 10:18:22','2026-01-06 06:18:22',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(42,1,'40d2e61b2fc0bd21f4f927692c85532f2394c5a53e95780a870c2bf4c013fc3b','2026-02-05 11:01:45','2026-01-06 07:01:45',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:145.0) Gecko/20100101 Firefox/145.0','127.0.0.1'),(43,1,'8e28a51d2b913801b7aba51d402ddaf8b504702e90737b3417a657e6cba2dcd8','2026-02-09 01:19:28','2026-01-09 21:19:28',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(44,1,'906142e77b5770025a1b7db289c0409febf339f533b44e8b7335553f9003683c','2026-02-09 01:19:37','2026-01-09 21:19:37',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(45,1,'36995ed65a5c9fcac7d2d6f4da83bdc7ea2c48d94c93c4cbed56c9244479e743','2026-02-09 07:11:48','2026-01-10 03:11:48',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(46,1,'aedcf9e4bd3536423e13b8f538c19adb6f0fa7eadac665525793d23056347fe8','2026-02-09 08:10:48','2026-01-10 04:10:48',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(47,1,'feea122448a8853c3db4caed0043690004b3bfbd44283234bef804a23985f5a5','2026-02-09 09:09:48','2026-01-10 05:09:48',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(48,1,'070ec9d1a5ca9461c3c6c86afd776d08a04af12562d0fc5c96294e35dfffb27b','2026-02-09 10:08:48','2026-01-10 06:08:48',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(49,1,'72fd90b1591f9410c9e6faf2962598a58609fb1a364b0c6060874318d022e17a','2026-02-09 10:55:28','2026-01-10 06:55:28',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(50,1,'2084f9fbe0a8b537a657d1fef5446b598da103002343d1b67a20b3b5652930eb','2026-02-11 07:15:54','2026-01-12 03:15:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(51,9,'d507a83024bb63bd4b66cdff812dcb2a55307891c54ae28596ffb8d1b09d47e7','2026-02-11 08:18:22','2026-01-12 04:18:22',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(52,9,'49918ff5e246e93c0404cd17365beda6b6513859bd6ad74d0e91426620483d2a','2026-02-11 08:18:24','2026-01-12 04:18:24',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(53,9,'b462b9fd7c9e6da461c482e3a3e02d7a4864e29b432852ae0c59ecf37d0db111','2026-02-11 08:18:42','2026-01-12 04:18:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(54,9,'1a311de7e4d7ace23cd2179e7d33fbfeeb8d0a48880c330f8c4869b3d38b8b61','2026-02-11 08:18:49','2026-01-12 04:18:49',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(55,9,'38c801f4d0dd814b28eba61007e9f8bc54d494e3196b2b45ece906a1df3e311b','2026-02-11 08:18:55','2026-01-12 04:18:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(56,9,'1426ca475a9665b6c95ec239224ea01061f001407fde70963172b424c35eb61c','2026-02-11 08:19:12','2026-01-12 04:19:12',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(57,9,'bb8b4da62577c423ddef1258c27addb516004c535e534518e321fa1efbc87bfb','2026-02-11 08:19:12','2026-01-12 04:19:12',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(58,9,'37a8e64c61f6b06c521b8ec71c18bb7d2cde585e3ef0ec32ff796a735df87f70','2026-02-11 08:19:13','2026-01-12 04:19:13',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(59,6,'d1281e617a3732cba039d0e305526cbc7d86d6743b53eae22ae743808b8f3799','2026-02-11 08:19:34','2026-01-12 04:19:34',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(60,6,'e2df6880ff92e59474e535adeef8c0185f2fc9525350696328b1497168cce41d','2026-02-11 08:19:59','2026-01-12 04:19:59',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(61,6,'f1478e7695763643f54639810e75effac10a853dd79209ec4413d9243312cbac','2026-02-11 08:20:11','2026-01-12 04:20:11',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(62,6,'070dd52096fec865b813207ea38176c2b317703119c1d7c63c33e098dc2c79fd','2026-02-11 08:20:11','2026-01-12 04:20:11',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(63,6,'25720c5143280141554fb82ad680f2befad3ca659d2800bfe21b02347483fad6','2026-02-11 08:25:31','2026-01-12 04:25:31',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(64,6,'7ab9b78b2a186f5504a43ee646ea78a8d1afd6b5a777b312c83d5abbb33cd834','2026-02-11 08:25:40','2026-01-12 04:25:40',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(65,6,'3e3837880892c5a977b2d2d9904e3b17b0f41bbdfbc238eed37dac4468007404','2026-02-11 08:25:41','2026-01-12 04:25:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(66,6,'12fe977e086fd978930cb3f7db01b6a843c6afc9f0edc8e29b6230410724c590','2026-02-11 08:25:41','2026-01-12 04:25:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(67,6,'21ea13efe2335a3fbab2171beb5340ef407d88ece397495c34a83eafc0b01335','2026-02-11 08:25:41','2026-01-12 04:25:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(68,6,'ad6d37a12747acef40db7518bf06d7a3ed05f04e851a2a4907eecbad633b3614','2026-02-11 08:25:41','2026-01-12 04:25:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(69,6,'5d8180fea541cefdcdd7a7bfc5a6f95938119331e8fc989d3b2df6cad071c938','2026-02-11 08:25:42','2026-01-12 04:25:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(70,6,'6cda0c0c3dca930d87a49eab062dfd3de36b65d5af322eb3c9a8dce8fded48a2','2026-02-11 08:25:44','2026-01-12 04:25:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(71,6,'914260c29590383bc32414e4f0505082a9aadb4cada462eb2ae33a1314cda657','2026-02-11 08:25:53','2026-01-12 04:25:53',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(72,6,'c29fccda1724ddeaff7497f7b1806414d252697a3670ec6a35a134e5ad912382','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(73,6,'d1e3e0e7d80c76da1ba4f6094d570419f91e6add7b5a82c881e3b756d58256f4','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(74,6,'10e9039baf6c7c11635560b62f8610de16fbeb793e0e572681c4ba015755ac95','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(75,6,'94574135a85aac1825caab15b79e29caf43a45bff49fdee33f6da0b5e9e9f62b','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(76,6,'0c3bdf6ac5d9b1d8666c1e6e93f29f2b2b447c528b476b43b1737026432f55e9','2026-02-11 08:25:54','2026-01-12 04:25:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(77,6,'ca58bb6979d2db73325727fa66497d126551e90a9290d3f1047d94f0e6ce2ff9','2026-02-11 08:25:56','2026-01-12 04:25:56',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(78,6,'6f77471aa30e9ab7548d0d21590e2b8fc6ed6e810174b03f9595adc21ababf89','2026-02-11 08:26:01','2026-01-12 04:26:01',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(79,6,'762b0bb8cd9473c517af47679b1a07c2de403d19e09df8dad0710161e9a8d067','2026-02-11 08:26:02','2026-01-12 04:26:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(80,6,'bf4ce66a148916e36b5c6e6342dec2dfe43aac1ecad07ae6529d8b6bbc4ad143','2026-02-11 08:26:03','2026-01-12 04:26:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(81,6,'d34e00218427322962b7b8aee6fb56feef0763fe3c8212176eb707eee4b51f43','2026-02-11 08:26:03','2026-01-12 04:26:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(82,6,'f79b08173346ed0805a920de28131c574196f093d588deadec242f3c7098c67f','2026-02-11 08:26:03','2026-01-12 04:26:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(83,6,'b030c57c7410e16e3c9971bc12c25c952834c841462eff2d988f93b6433d72c6','2026-02-11 08:26:03','2026-01-12 04:26:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(84,6,'e6ce897ffd2057164509970b1a455c3da6f9922ab683f6ab71a80462ee33ffb4','2026-02-11 08:26:08','2026-01-12 04:26:08',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(85,6,'2bd06e019559ac33011f5a600eb17101a388c9dc9c7ca3d6ac387ff6b03fbb72','2026-02-11 08:26:14','2026-01-12 04:26:14',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(86,6,'ce5c36f6c9d998b54e5ceee3f98452be94a99ee2d73c24e2ea7672c3c03fc6a7','2026-02-11 08:26:15','2026-01-12 04:26:15',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(87,6,'7095f7786748fe10920f29771ede16c8a6680e4b2a46bbd80c9824555b928aaf','2026-02-11 08:29:03','2026-01-12 04:29:03',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(88,6,'57464255823e39f8dedcf796c3081b2fb94d2731d1f927d82480494f9208279e','2026-02-11 08:29:12','2026-01-12 04:29:12',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(89,6,'2fabb92c67247b5d43f4db2af5b3d81aace895413ba1e3eb491384e973809f8b','2026-02-11 08:29:14','2026-01-12 04:29:14',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','::1'),(90,6,'4dd5e00ed82c9f2c81d3a61ae2f358cfcdf4764e8703bbd011f09b6bf0275eda','2026-02-11 08:30:08','2026-01-12 04:30:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(91,6,'fc1c20001b687df734b6768ee7e56b8534f0ad07f9860593dcebb2c92606bf1c','2026-02-11 08:30:10','2026-01-12 04:30:10',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(92,6,'f62b31214b4347c532f3675134d1152e1abcaf440ce216f42dcaa62d348e0c28','2026-02-11 08:30:38','2026-01-12 04:30:38',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(93,6,'15c3dc358ffbdcfe57b97c19f81f43dcf969a458547aa0a27311690988fed43a','2026-02-11 09:11:12','2026-01-12 05:11:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(94,6,'d12881cae2a46e8465bb4b8ec184a21cdbdd1eff517e83122eb5db5dcec798f8','2026-02-11 09:11:14','2026-01-12 05:11:14',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(95,5,'91cdec337f63b6e3be867efa8138ea4a639f5c278b643dfe3476f44669fca388','2026-02-11 09:11:28','2026-01-12 05:11:28',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(96,5,'324a00e210e6fd1382220309a5de756b59111e07ede519cc03a8bfed334aea4d','2026-02-11 09:11:29','2026-01-12 05:11:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(97,5,'9fdf1d8c7293933af277437a7b48b89722a73eaeffa6b46de3f1cf1832ca268c','2026-02-11 09:11:29','2026-01-12 05:11:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(98,5,'88efd5f097dd322e882a2a4099ea10462ad78e3cbed34f802268f6356e5f2dc3','2026-02-11 09:11:29','2026-01-12 05:11:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(99,5,'e52817159d23f6695aa015eb400ad4803f3508e263a7820a6c4f0309e9a19707','2026-02-11 09:11:35','2026-01-12 05:11:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(100,5,'8512d0481b97a13a55e7f8b4dd147a76360bb1590cd013d39ce06feea3fe5009','2026-02-11 09:11:35','2026-01-12 05:11:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(101,5,'51660744b4d70608b39b37f1cb415d498bc7638ed51711bf6f440bc683610d48','2026-02-11 09:11:35','2026-01-12 05:11:35',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(102,5,'73c343fc65c46782603988bbef554ce59c400342fc28fd1c1281902ffcf8d2ac','2026-02-11 09:11:39','2026-01-12 05:11:39',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(103,5,'a87b84b6d930191c1a1f402e18ce251ed0bf768f280b2334c824cd9597de7eca','2026-02-11 09:11:39','2026-01-12 05:11:39',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(104,5,'0ef31550675f02a1efa8c65661f4994b2b79c36c4b19fe77f42d747db37f28e8','2026-02-11 09:11:41','2026-01-12 05:11:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(105,5,'b9982783dd3e603787155bfb153f044023ebbaa1ea0deb1e02c00550c0ad4474','2026-02-11 09:11:41','2026-01-12 05:11:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(106,5,'8e5b3285d3b359a854404b1d5aed305f59d6ee795be2a2bf2a11aaa7d40bb153','2026-02-11 09:11:41','2026-01-12 05:11:41',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(107,5,'ac5827a41a266652be828c03eb6e8093c87869cfaf1296838badc1aa178416ff','2026-02-11 09:11:44','2026-01-12 05:11:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(108,5,'176ccfc22dd5034ca0f152f9a57c90d844f71122e7f14b76eef2b412dadb17e0','2026-02-11 09:11:45','2026-01-12 05:11:45',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(109,5,'afa87680b3f99d6420a782fc884145085b2fb63c2f78d14422184e4d87c058f0','2026-02-11 09:11:45','2026-01-12 05:11:45',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(110,5,'25051f2af500d1e6ffcc3fa0c55be4af8f7b2841dc3c1eacec49722105502e99','2026-02-11 09:11:45','2026-01-12 05:11:45',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(111,8,'69453c39bfcdf86bfd8e8d7de906a42eaa2cd3dbb4e2c72e4586ec22b26a4dd8','2026-02-11 09:12:02','2026-01-12 05:12:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(112,8,'0b583d4a490cb824a008c890c6f0965e559f64b2930af88352ae824200373539','2026-02-11 09:12:03','2026-01-12 05:12:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(113,8,'3f363635cf4af260a9b05428701335a2d2a69d53cb44dc97f4a1c0bcb98339f1','2026-02-11 09:12:13','2026-01-12 05:12:13',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(114,8,'3c422ef5eac5457adb9fbb86876cb7d214fccd42937e9fbc676094a3012fb1a2','2026-02-11 09:12:15','2026-01-12 05:12:15',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(115,8,'e34f3f340dad669262172749be9f943ad5ff7cf3cd8655097b93ada7cdaa402d','2026-02-11 09:12:24','2026-01-12 05:12:24',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(116,6,'d947462c7c6d2e13f53de694ceb9aef1fba103f0c0fe8f213bc010ced8719c18','2026-02-11 09:15:40','2026-01-12 05:15:40',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(117,6,'d01885bdfa50af6d665f1d49228fe83aa617216c085c8a2ae0ca6452d0fcfe30','2026-02-11 09:31:36','2026-01-12 05:31:36',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(118,6,'019f196fb8664a16f8c1ec8a7e67a8a87fb69b2da025fb7195ed953151fd8a78','2026-02-11 09:31:37','2026-01-12 05:31:37',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(119,6,'f8611b3f8d1432787af0cae33a923c9a8072a22adae68686d82bf074ccdc726b','2026-02-11 09:31:37','2026-01-12 05:31:37',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(120,6,'25ca807f66df4cd6f296fe68597b9c83a000fdccd5e566bb0e4a6b855b7d757c','2026-02-11 09:31:40','2026-01-12 05:31:40',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(121,2,'6368d62430fd7b96cc4d897cb4543c9f29bb95eb1b7714310a0aacd151fa09f8','2026-02-17 09:49:30','2026-01-18 05:49:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(122,2,'e03afcbb24745af9aa08d771f609dc99b6f960d30c5b0a4d005833660aaf1164','2026-02-17 09:49:51','2026-01-18 05:49:51',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(123,2,'9abe2b53f875daed265c8b1c5cf3038dd102555fa56f42e6e7b19271cc9c6e58','2026-02-17 09:49:54','2026-01-18 05:49:54',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(124,2,'7085f83fbdaf2eede109d8a7e516b3208fbeb1dafba89db5b1c42355586441ac','2026-02-17 09:52:05','2026-01-18 05:52:05',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(125,2,'ce083803948344c42b02d58c6e079eb7ea1105c2f1bdd08e9cf4b0fcf7176363','2026-02-17 09:52:06','2026-01-18 05:52:06',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(126,2,'359be9e79355674f676f31721fad7321ff36a25535a0dda91e169c51ac1e4e77','2026-02-17 09:52:07','2026-01-18 05:52:07',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(127,2,'cd1b3598d836023249164b4a67b4381049ada6a5862e10d62aca68be3558b889','2026-02-17 09:56:16','2026-01-18 05:56:16',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(128,2,'9b346fb80b5715879509e323fbf50fee3954de615086a7e6c4d30e6bcfe65c40','2026-02-17 09:56:17','2026-01-18 05:56:17',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(129,2,'aa9575472660784c10976134112faaef50971ed42109f7ee3deae9ecf8562c55','2026-02-17 09:56:18','2026-01-18 05:56:18',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(130,2,'42c1b4b6021a427d7d1f12130f83587cb304d62b6c2a55fc7d7fcbafe09a2df1','2026-02-17 09:56:21','2026-01-18 05:56:21',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(131,2,'3ecfe4fa17d3bf57ecd14d148d56e2631db68c7246335e413a01abb91205a338','2026-02-17 09:56:22','2026-01-18 05:56:22',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(132,2,'78042a1c483a227c751f1438f06aaa421fa03e2887c52c8222cc12844d231aa6','2026-02-17 09:56:38','2026-01-18 05:56:38',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(133,2,'8d9d893c127fef03da1556f5483b1a4037edc268e76de6f17126c58f2534fc90','2026-02-17 09:58:48','2026-01-18 05:58:48',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(134,2,'7633e743bd2cc4c92d85e024dc67e2cf41a59eef821c336efb2b1b3d23036137','2026-02-17 09:58:49','2026-01-18 05:58:49',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(135,2,'fe5710ced0240337130292f1d2902a7f1815aed23ab80d2b365244f8d55f1a96','2026-02-17 09:58:49','2026-01-18 05:58:49',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(136,2,'f54ea515d9bc10272d1d96b4e7e6cb37009a0c37da7855b2cd5c021341fbd6fa','2026-02-17 09:58:51','2026-01-18 05:58:51',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(137,2,'f85176f6c4bac73c7d131e31fef07aa25a3d1ecf224ba62ed131ee1a46667b6c','2026-02-17 09:59:01','2026-01-18 05:59:01',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(138,2,'5b454d2acd48856d734d3a00007694015c33faf4c8fb51e6bfe3a7580561ad5c','2026-02-17 10:01:15','2026-01-18 06:01:15',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(139,2,'697d0f7d56b9060c4836dcf5e91cdbf83825b2785ef25ee6fd090bf08b0f88a3','2026-02-17 10:01:16','2026-01-18 06:01:16',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(140,2,'d28dd772110d95f5c1122fbe492a4849bfdc96a9b5402a979b8105276b40df9c','2026-02-17 10:01:16','2026-01-18 06:01:16',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(141,2,'2ba1669fad7086cbb8450f84b9e17887781ce0d31c61822656eb4cf8cf19adfb','2026-02-17 10:01:17','2026-01-18 06:01:17',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(142,2,'b5fea72d3e8160f2f7f5cc72b38b8ed175219a9b6a41acb14851a9e65a61d810','2026-02-17 10:01:18','2026-01-18 06:01:18',1,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(143,2,'f31ea5ab67b6ccf1b5491b9341737d1d6af538ddcc53c1cbe602b3850be1ea3e','2026-02-17 10:01:26','2026-01-18 06:01:26',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(144,2,'eac87987348814886a7aac97918d78c2b34a7a4f818e64a10edbbb6023a5062e','2026-02-17 10:01:35','2026-01-18 06:01:35',0,'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','127.0.0.1'),(145,2,'f8964696351c457e761e0bfd6522826e3f15f312474f6e0ea62b8612584d5ce8','2026-02-17 10:02:49','2026-01-18 06:02:49',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(146,2,'62f3cce0688999009b9d03251b65d0b34b3deed1e84b29072ceb1d7136028886','2026-02-17 10:03:02','2026-01-18 06:03:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(147,2,'b54b9ac3d72558f2252238e4b11edbdf8a7766668a4bdc8057a1e36c507cffe3','2026-02-17 10:03:03','2026-01-18 06:03:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(148,2,'499ee0f9a7a0a249d857fa96efc19057911ede6071712650151d3e30bf939a7f','2026-02-17 10:16:54','2026-01-18 06:16:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(149,2,'cb814b888a86717a346fe34cbb79b3dc38ef8f0083e3f1941ed573d1593efcb5','2026-02-17 10:16:54','2026-01-18 06:16:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(150,2,'906b9561986891560b8d4eaf3305673f5f1cbda6794b0ee38be705834ffe6d81','2026-02-17 10:16:55','2026-01-18 06:16:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(151,2,'d2ed1392dc84fda9b62c5316751c9c2a88dedd6327d83c74dbbc162e912cd4b2','2026-02-17 10:21:46','2026-01-18 06:21:46',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(152,2,'a4b48910390d5bea3f2cb3bc71c770dd56a9e58fc69985e265c338fb450a9d02','2026-02-19 09:45:16','2026-01-20 05:45:16',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(153,2,'37a32d9b86d6afb0a5692890310885a3e32a5c2065babe914dbdd801e58ded3a','2026-02-19 09:45:18','2026-01-20 05:45:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(154,2,'a113965758de45e57ebe1355a59db0ab9150ffc898217d8540e1db38620fadb3','2026-02-19 09:45:19','2026-01-20 05:45:19',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(155,2,'45c9ce3160c3ff0c7c7b25aa4aabc1de7161f84253ba77efeb562f89c1a13d1e','2026-02-19 09:45:19','2026-01-20 05:45:19',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(156,2,'7fc9e059e6b43cd40a6a0959e441ec2b83f81e4dcd27a757cfd3a48c5a11aa8a','2026-02-19 09:45:20','2026-01-20 05:45:20',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(157,2,'e54b4c49a7159462a75974639cebaaf35cd23804f96bb2d57477bcdd6ceb9a0e','2026-02-19 09:46:14','2026-01-20 05:46:14',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(158,2,'d5124f4e60954c2e5a4f1d82a764328ed93bb62ecf5ab7beb480b8f422d96b3c','2026-02-19 09:46:18','2026-01-20 05:46:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(159,2,'9b59e1cb03c23a9093ef317b1d2248e0ddca8246549e2e73feac5ac49297c3df','2026-02-19 09:55:04','2026-01-20 05:55:04',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(160,2,'2a7f802829e3fdcb6437ba2228a1614562f4a32ca8de5deef440377c80f201f0','2026-02-19 09:57:07','2026-01-20 05:57:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(161,2,'cb264c27157c0820b241e25c1a1560fdd0d72842074589000ae4756340a4cdf2','2026-02-19 09:57:08','2026-01-20 05:57:08',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(162,2,'6260c13ec2ef95e01c8e285f89c5f602edcaac9e807e6ae6530debd4a7951009','2026-02-19 09:57:08','2026-01-20 05:57:08',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(163,2,'3540b7120674443e63bb623ba571c7e00bd8d578154629c5f0d9a054342b6ee7','2026-02-19 09:57:09','2026-01-20 05:57:09',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(164,2,'aad2b9552f1b85f33cb0d5f7677f418b997606ae1962474909e0cd8a660de381','2026-02-19 09:57:27','2026-01-20 05:57:27',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(165,2,'67ced5f69f6785e44ddc4ababa9b6a8f29df785ebbe809486a3a1c57d4a721ca','2026-02-19 09:57:38','2026-01-20 05:57:38',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(166,2,'3956f7f6d9bcbefac8cad3cb437559f6c4fb41e59ec5e54e4d7d9ea3ef5cf73c','2026-02-19 09:58:36','2026-01-20 05:58:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(167,2,'2bece4e92041e671592d22ae0c6a82527d00dd0d6ee794d54dccfca9a469ddc5','2026-02-19 09:58:36','2026-01-20 05:58:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(168,2,'1f8a79d1c65faa493860c7ba95e51a8ba7492158a627c1640ae0f527ff603764','2026-02-19 09:58:36','2026-01-20 05:58:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(169,2,'59aab0e60a9f536661c2750e37b258da87b0abf4478a935899c40a7036f1df6c','2026-02-19 09:58:39','2026-01-20 05:58:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(170,2,'7cf3d0e34fed0f50e9bcfa1856a0aa94969c3a272869660875d9cdf868b33d4c','2026-02-19 09:58:39','2026-01-20 05:58:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(171,2,'3b8c05257cbaa07a28c8bdde47b6a144e743c1cdfd59cadc7377409a04980f3b','2026-02-19 09:58:44','2026-01-20 05:58:44',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(172,2,'17ef8eba37d96a560550ba6418a107bcf2916cc08f50ff181230b45b9df3c7de','2026-02-19 09:58:45','2026-01-20 05:58:45',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(173,2,'6a55c7ba48ad7dfd08824195da011948112c4ce93f855c3275112251961cc6a5','2026-02-19 09:58:45','2026-01-20 05:58:45',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(174,2,'657b968be9c49fa2c40a9b1aba7da5578df9079cab0d775dbd60467d08f84dad','2026-02-19 10:10:52','2026-01-20 06:10:52',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(175,2,'0de66d99991420a5e4b5ede1ff85944d03af30e2fccde5d9819758e323ad27b1','2026-02-19 10:11:08','2026-01-20 06:11:08',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(176,2,'0dc6d9b1fe4a38a103743abe87fa7475fbe88f7fa49c6ab38971c2c416c11d31','2026-02-19 10:14:29','2026-01-20 06:14:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(177,2,'eb87e1e59026a5b946d99d336470e1437fd82d3085d068b24dc9f60d2e56a016','2026-02-19 10:14:31','2026-01-20 06:14:31',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(178,2,'1cbe3ff5f6f8d40eeb7e3359108154b285d2781532e774f31ec79bec7dd6acf7','2026-02-19 10:14:58','2026-01-20 06:14:58',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(179,2,'51810c71741f8b8e373db566aacd788f70c22f090ddc6f1fbedab39928f70086','2026-02-19 10:15:00','2026-01-20 06:15:00',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(180,2,'ae5ab725df29265ab6022fcb3401d4aa1f367b4305eec6ba29d38cadda91691f','2026-02-19 10:16:25','2026-01-20 06:16:25',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(181,2,'fc3187ecc9e4f9ff653bb54837a961f60b1037e8ec79da2b3fdfb31e48827355','2026-02-19 10:16:26','2026-01-20 06:16:26',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(182,2,'5667f955acd512c0e5c79f6610282d43329a4a8e7d49ac455b7f72f60927b2bc','2026-02-19 10:16:26','2026-01-20 06:16:26',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(183,2,'0029f8082fc51d9d35dec1da810b8e4a35babce618d3adfc82c5812bcf037e59','2026-02-19 10:16:27','2026-01-20 06:16:27',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(184,2,'058ad6fd27cd017f3bba793e11e045cf40cd0c560e6c43efafb71b8776298083','2026-02-19 10:20:25','2026-01-20 06:20:25',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(185,2,'d19e240666ff78e4d4b87035ce5bdef26b2d0a5b33b2a71a615d7c55d7572407','2026-02-19 10:20:25','2026-01-20 06:20:25',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(186,2,'aee66802956240db2d95f7f6c098ecb2d1e6e9cb550e2aa72a0283fecfd48fbc','2026-02-19 10:20:49','2026-01-20 06:20:49',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(187,2,'eb326964921447925c22907c58887ef89226ca6a7f400e0348bc1795440ac30a','2026-02-19 10:21:04','2026-01-20 06:21:04',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(188,2,'87f9cc7410ebd959929f8ef5201488bd9b60fc72bd965cec9a0056734baa9a52','2026-02-19 10:21:27','2026-01-20 06:21:27',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(189,2,'12e7bd0d5afa3df43a2f4ebbe413633bde03984d10b2af68bf9af7e40b7ad98b','2026-02-19 10:21:37','2026-01-20 06:21:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(190,2,'0780bbcc32fe153832d47eb885c24d9fbe47738f73b8a219356b1ebcaf137edd','2026-02-19 10:22:02','2026-01-20 06:22:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(191,2,'9e70ca05b76c8f1582e15e4907fc91c44075eb68c72074ba2a0e1c56a8f46406','2026-02-19 10:23:37','2026-01-20 06:23:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(192,2,'bcccf2b311afc78fb5d573b2b36d8f677a5132e80a367e78a5dd3548e731e4fb','2026-02-19 10:23:57','2026-01-20 06:23:57',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(193,2,'28025db5072b714e59bc3a2b56e0be609a1fec43caceb2890c9f2a3c819c10f2','2026-02-19 10:29:12','2026-01-20 06:29:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(194,2,'46a2eb7b3135599eb468abbd57694dd0f758483d4b7fd1820e3ddeca865f7275','2026-02-19 10:29:13','2026-01-20 06:29:13',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(195,2,'0d2caf878cfed5bf8b65c21b8e27623341af9b5bf48491091216b03ec6f7de07','2026-02-19 10:31:18','2026-01-20 06:31:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(196,2,'4cec22ae6269fc3e61ce4a0b93efd5bdfd618fc8310b064f39638daeb1c6a2fe','2026-02-19 10:31:20','2026-01-20 06:31:20',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(197,2,'cd290b3bfad4deb73cf0c2666178d33b5b780145957417e24260f293be3923f0','2026-02-19 10:31:21','2026-01-20 06:31:21',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(198,2,'136423ec8dd4cb198a702a215c0e1b4bd155a06371bda59bbc4d4608affd28cc','2026-02-19 10:31:29','2026-01-20 06:31:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(199,2,'65f29ff22d8e95113a8e11018ac02fe4d5ec4e4ca0beb855c6491e4f00454f1f','2026-02-19 10:31:30','2026-01-20 06:31:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(200,2,'b59a37bf04f3c691e26ba5ff1d0678046884f24a482db0bd3fb8b7c97b4c3922','2026-02-19 10:31:30','2026-01-20 06:31:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(201,2,'d4df4852206200f8327b4167878fc88ace3db9894a1ebd9372d2121b47b21e20','2026-02-19 10:31:41','2026-01-20 06:31:41',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(202,2,'4da690da83a173133e9161bbc72f771715143ef8688eccd9f34975de94ff06fc','2026-02-19 10:31:43','2026-01-20 06:31:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(203,2,'fba2fd13f57e35ae51b1f77df61e9bb9778cd265a19ebe2865f63de84a12e975','2026-02-19 10:31:44','2026-01-20 06:31:44',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(204,2,'58e7cede61bf62128476e2c84e75730b7b0a877f74168812dd184e6895b35d1b','2026-02-19 10:35:17','2026-01-20 06:35:17',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(205,2,'dac52dd22b042155bc3b05cab1f8e6be9517e24009b9c944fb85b0e8153d9908','2026-02-19 10:35:20','2026-01-20 06:35:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(206,2,'0a7a5a70781b33be827df61a4f8a032038d671c3f0f14adb0e571991d0b45dcc','2026-02-19 10:35:21','2026-01-20 06:35:21',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(207,2,'246d8c56aafa537fe6f931c977e33070baa75a37e72d55a76767c40d2a9c82ea','2026-02-19 10:35:21','2026-01-20 06:35:21',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(208,2,'32db5f567491a6fdc93afe67e8427941facee75fbc20aafd283bc3a9fd16f0d7','2026-02-19 10:35:21','2026-01-20 06:35:21',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(209,2,'36f9d1e45bb3f4d930d61222ea1f04d5ee6af7b3ed8e8fbfc6fc02ea4ac46133','2026-02-19 10:35:30','2026-01-20 06:35:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(210,2,'bcfaa4bba056958f95bf88b1477869d3c97aa2af82177cc49a6e597199463224','2026-02-19 10:35:32','2026-01-20 06:35:32',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(211,2,'282454dcc807e29fb041a79c3813ef29cd467c02106fc1c66887d38fc744d9dc','2026-02-19 10:35:36','2026-01-20 06:35:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(212,2,'1dc03c233fd16b0a70afe113826f9b95910017dbe3269b3cf8ade14388f9726b','2026-02-19 10:40:08','2026-01-20 06:40:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(213,2,'92fa568c6e5ccfe7fd4dd2807f218310232569d4eb5bb1aee0a5b7ff5ee85f7f','2026-02-19 10:40:08','2026-01-20 06:40:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(214,2,'13d0bd31eea4e2c9e1f0437abc3f27aa5aa74d34a674f894898170aeab32d8e0','2026-02-19 10:40:08','2026-01-20 06:40:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(215,2,'677551e3008ed0c24b7df270b4af594b0d7f64b40aac61e18ddb8c34746e464a','2026-02-19 10:40:17','2026-01-20 06:40:17',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(216,2,'35ca5c4a22b84ceaecb8ae13ba9339df83573fea4bba104a5e6c187df882e696','2026-02-19 10:40:19','2026-01-20 06:40:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(217,2,'3addd2b4d36996317d0dc5140a6d1e13e55cf00a043928b886cfe4cc98623d7c','2026-02-19 10:40:46','2026-01-20 06:40:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(218,2,'adaa7b0c66dba030faf34d33518bf779ee03c39674527ba1be56b5ce34504aa1','2026-02-19 10:40:47','2026-01-20 06:40:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(219,2,'a80f7f1f96ddb94e4af23dbc682689fa8054abf632a81a211b632d3a14cb6145','2026-02-19 10:40:55','2026-01-20 06:40:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(220,2,'b4903d24f9f5e2ad5f6aee366c201929f3308428248208f007ffac3aed250c78','2026-02-19 10:40:56','2026-01-20 06:40:56',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(221,2,'4152c8c19be5200db0c117b680dd177121fe0e618a4e36a7a3de1f37bbe9e036','2026-02-19 10:40:56','2026-01-20 06:40:56',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(222,2,'fce0d15ea859acacc78a2c0885a6488996bfa5f7a244b595001776161e4fd2b0','2026-02-19 10:40:56','2026-01-20 06:40:56',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(223,2,'ba0906289859d1fe3c13a4ef6cfba6bfc3cc5b3e9c3a1b51fe7a5e68eb50cdcd','2026-02-19 10:41:07','2026-01-20 06:41:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(224,2,'43f4dbf46f5b9aa3b87807b911d2a00a8e7f34ce3d534a2724365bc5e7ec2479','2026-02-19 10:41:10','2026-01-20 06:41:10',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(225,2,'58360af9c4d1755012d8f8c93cf7390610932bb0d808047a756622e384f1c314','2026-02-19 10:41:14','2026-01-20 06:41:14',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(226,2,'662b4205a79f5e0e182912d07318336dacbd48570c05c458095b2c409cb77d6b','2026-02-19 10:41:29','2026-01-20 06:41:29',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(227,2,'5593c897b5c6a57ee91fc8356d5decabd7fcaeda6072b61c279c8e55fc4a320a','2026-02-19 10:41:30','2026-01-20 06:41:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(228,2,'70c71a2a80af22c47ce032d781b54ab7abbe72d2c15cbb81bf4c01aad0fe041d','2026-02-19 10:41:30','2026-01-20 06:41:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(229,2,'858fe27f2f6b2e42619a6f6d2c929c2aa3d4159b8c180ac2203dcae93996da9e','2026-02-19 10:41:37','2026-01-20 06:41:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(230,2,'402d3d280b1d8bdc4910053dcfc79a75f9730fb4d51067289b651d92e40b686a','2026-02-19 10:41:43','2026-01-20 06:41:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(231,2,'0dc638b82e3f0335781874fe867b43de8a1fef71f7092891e798812a7e4895b5','2026-02-19 10:41:45','2026-01-20 06:41:45',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(232,2,'e26376847d0ab4c0161ead9f02ad3b8baeaf1616f2b8f54efc01191604c180a7','2026-02-19 10:41:46','2026-01-20 06:41:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(233,2,'6a0d1959b06d35074052f6930b3e331722c633a6f5e5c3444b25410f6b1f4c27','2026-02-19 10:41:47','2026-01-20 06:41:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(234,2,'9d497c31bc4eec2a037e409f0dcd2b5c3f70e59c5e5c097b659e3934f81a78a0','2026-02-19 10:41:47','2026-01-20 06:41:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(235,2,'ecd107d9ff405cfbb883bed16b4315ca375aadec470e913a5f472abb93bda8fa','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(236,2,'451454265690ccaae02a8cad2a893d8dc1077fd9ce111eaeb87ca01cb167029e','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(237,2,'05a6aa46c31ab616b694172ad4d7b7137fa21d4c476deaf9eb42fd820e537666','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(238,2,'f7a80fed0149c5998ca36bfd09ff29054dcc744f266a216759c0f4961635ff6b','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(239,2,'4816f3699389816f7021b2e27dc290f55a01c461d74377a56556cf0cbb7e0dad','2026-02-19 10:41:48','2026-01-20 06:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(240,2,'f511b65a536e7ecc256b5429aaf67eb743f434b0be1576979339c762818d09dd','2026-02-19 10:41:51','2026-01-20 06:41:51',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(241,2,'aa1c6d8cf47a8c2cf6ca0bbe1324248b69221274b71aae6da6988fe1bcb13d2f','2026-02-19 10:42:02','2026-01-20 06:42:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(242,2,'15d1b8b2cbb2e9cea9215266a6d94dffa9e4f5773544e4ee967212a720525ce2','2026-02-19 10:42:05','2026-01-20 06:42:05',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','::1'),(243,2,'78a7f3f5801afe8a177920241cae68b972fb66bb2a348d508e01d42cd70d646a','2026-02-19 10:42:44','2026-01-20 06:42:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(244,2,'a416cf5ae7fb338f24b330ac59eadae92d59780bd959df0937102ba0613c81f0','2026-02-19 10:46:18','2026-01-20 06:46:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(245,2,'7574d71bfa61bcb92fbff4459554a8708f20b646740b7a8c108e093df85b938e','2026-02-19 10:46:18','2026-01-20 06:46:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(246,2,'6f31c069a5f6ea858e14fdb34332225a4437a503e1b9c8f7bc4a5f3ef4318a9b','2026-02-19 10:46:18','2026-01-20 06:46:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(247,2,'970951462d4d9267a963698a260e58056f37169719d0367f089d30ede15dafb2','2026-02-19 10:46:28','2026-01-20 06:46:28',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(248,2,'ddc927dfaee9546e5f33a2676cd7418a039c11e044ef3ca71bb443fe60111e39','2026-02-19 10:46:32','2026-01-20 06:46:32',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(249,2,'9c4de3ab09de81a2857e5107084e391316329d98085b48cb9f7dca9ae95f3939','2026-02-19 10:46:32','2026-01-20 06:46:32',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(250,2,'2655008e1dc52f6933f7a2f4adca69a72b00da10baa33b1b72527e96919501ab','2026-02-19 10:46:32','2026-01-20 06:46:32',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(251,2,'8a2feac352f89ee8905e13f26d2e10e061e512f2c85682ff0d0d80f60ddb5b27','2026-02-19 10:48:35','2026-01-20 06:48:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(252,2,'958f509fd564506c39d4b126f08b2d66eaa9f0a1e54348a14aa4e1c357271527','2026-02-19 10:48:37','2026-01-20 06:48:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(253,2,'51cb9c1db4e84be15ac39dd7254adccc2bbbfcefca7ac1674f16b36eb6b1bc11','2026-02-19 10:48:43','2026-01-20 06:48:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(254,2,'678614a595bee34019be4b1fac596c95bfeec906700795bf03f870ee75a65b99','2026-02-19 10:48:46','2026-01-20 06:48:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(255,2,'fa409e27c795721df2b5837e807a689df742a8b7ad9064acde65ea376af2e2a8','2026-02-19 10:48:47','2026-01-20 06:48:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(256,2,'b5b3abfb650f246cbf34c47fa76a270b08474c84655424aac8a5b381427c2bb3','2026-02-19 10:48:51','2026-01-20 06:48:51',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(257,2,'90b15c644f90f474ca982f90d4453b958bc2180eb69d94690c78e5aed878f7dc','2026-02-19 10:48:52','2026-01-20 06:48:52',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(258,2,'515181143f0bbac33a401604ba3fbee14e44c19b87515b50b67d19e512f9af9c','2026-02-19 10:48:53','2026-01-20 06:48:53',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(259,2,'801901a59ec4178b9035d52f10a7e360b637908fe67183d2b0beeac0b320eb84','2026-02-19 10:48:53','2026-01-20 06:48:53',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(260,2,'78ffae89a1324ee8796ed7ccf9e45ab8f071ad4fab026423f3c6e9baff37d2b2','2026-02-19 10:48:54','2026-01-20 06:48:54',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(261,2,'3762d92ac07d8f891a8652be81bac06517c546c2cba451e2727f993940bf3acd','2026-02-19 10:48:54','2026-01-20 06:48:54',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(262,2,'0ac6d64976fb6da64263b025a8241c356872949e34ac5709f55fefa485813af1','2026-02-19 10:48:54','2026-01-20 06:48:54',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(263,2,'5c1e50bfd507deb891489ef4c06f78c5921e5069e31e1e9a410d6f5ae7a0b779','2026-02-19 10:48:54','2026-01-20 06:48:54',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(264,2,'18b9368c26fcd00322b938cb06a1dc7bb01ff196c77f3f554e1fffffe3efe263','2026-02-19 10:48:55','2026-01-20 06:48:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(265,2,'fb5fff63d5eabe313044eba7a9c0ea0dd92ec418ef683261c424fca32af7717d','2026-02-19 10:48:55','2026-01-20 06:48:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(266,2,'30a29807f3d77d5ad69650ec0d011aa98a498d185be5f0ddc6163c4e816f3c21','2026-02-19 10:48:55','2026-01-20 06:48:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(267,2,'ddd04295f4f5b1de86d439c72ae5e67aa28c9e393ad630a3dd30894c02dc9865','2026-02-19 10:49:10','2026-01-20 06:49:10',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(268,2,'1d7cad92ce841374999b0c9f2a1b023bbf53a0c608772b69821a7a08100d296f','2026-02-19 10:49:12','2026-01-20 06:49:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(269,2,'fd337eb7cdd67b27d5a4732b32e88a381500a3b4c62f600ae70e01665c3b898d','2026-02-19 11:00:18','2026-01-20 07:00:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(270,2,'f447e2127f897187b36206fcc057a4cee1dbc915442d29a0774e7e7428b75d6d','2026-02-19 11:00:20','2026-01-20 07:00:20',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(271,2,'4da196ee30a1378065e866b05901f41c691bbc0a6f6e7cc185b945112cad11a6','2026-02-19 11:01:52','2026-01-20 07:01:52',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(272,2,'6f577ae499ccd223980d8e91356404ebe577261552aee10bd1c3857c255a3766','2026-02-19 11:01:53','2026-01-20 07:01:53',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(273,2,'81defdb5b7d7d533e36f259c6f8fd3258d81b1b7d942454f8d4f3681dfeb56b2','2026-02-19 11:01:55','2026-01-20 07:01:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(274,2,'b8d865c28ea82810f15d3bca45765885c4d46a4ff4014186d51cf36b5bef304c','2026-02-19 11:01:55','2026-01-20 07:01:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(275,2,'2290ca59071510ef78bffafc44a5edd5bd0467e7f519df5a68c5745cc5def17e','2026-02-19 11:01:55','2026-01-20 07:01:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(276,2,'4262d01fc6e3dd0807e747ab65c2034d1866701ccad4edaab4db0bb0ec611a91','2026-02-19 11:02:09','2026-01-20 07:02:09',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(277,2,'74539220cd02d493e42ef2e98b58c83239337efe12e68ff67b7a50e5a1599062','2026-02-19 11:02:12','2026-01-20 07:02:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(278,2,'35f68ac2bffdae38c51aafbb028d90c0568025fd40df767d30279fdb26649857','2026-02-19 11:02:16','2026-01-20 07:02:16',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(279,2,'f8246ecf3cab5528526c75d67d998a7410130670190b6d012dc59c14c3462f97','2026-02-19 11:02:20','2026-01-20 07:02:20',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(280,2,'a5c79a87355018d27099404acb8537c8d0adee57bc5debb5d19a4fae095a888e','2026-02-19 11:06:44','2026-01-20 07:06:44',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(281,2,'0490d37c760c1f93f63a6d12242a587f7130693642e5fde972afec21f6bffa20','2026-02-19 11:09:07','2026-01-20 07:09:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(282,2,'25501a113f65cf3a150efb1fab4fb48fcb493a19f6ca343843474eb1826c1bbc','2026-02-19 11:09:08','2026-01-20 07:09:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','127.0.0.1'),(283,2,'aab966f2eef41f34481bdad0d22779e39c1e28d1cc1072fdb682302e8c3c5002','2026-02-23 05:16:03','2026-01-24 01:16:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(284,2,'6287808509c19b89eeeeb630604686c529beecf0e9a08456543b5200736d6c18','2026-02-23 05:16:03','2026-01-24 01:16:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(285,2,'a24b9a6be393bf65301a014e7ccf8db3d3f660f3fa64ee26755a3f718cc2201a','2026-02-23 05:16:03','2026-01-24 01:16:03',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(286,2,'90b5cf4bd69a2cafcaeacff1b0e19141a80d7f3050036d43c97d3e91dd580c35','2026-02-23 05:16:15','2026-01-24 01:16:15',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(287,2,'0a4e22bce52aa2e95d1a66607f8907306abcf36e83c771b94b1b45d4ad855062','2026-02-23 05:16:16','2026-01-24 01:16:16',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(288,2,'6bb01960c9f274a7f409dd992840990ec1c516739b8c2461d5e0b3af4213dfd2','2026-02-23 08:03:42','2026-01-24 04:03:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(289,2,'784d0e003c78162d26c7dc4e215d94a7b93ebb55b91c5c4a8671440f1237e8fa','2026-02-23 08:03:42','2026-01-24 04:03:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(290,2,'f3c86357ecfe91f2e1f00430882e204328dc1f92a702a36aa7fde08a9897a412','2026-02-23 08:03:42','2026-01-24 04:03:42',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(291,2,'217aa0f2adc426341655415ae37c7b23312a4ee7f04e4e326fcaef9b02fb3714','2026-02-23 08:03:53','2026-01-24 04:03:53',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(292,2,'7f92b98cb7d91b72bee1b053492d275a07942f19f97de4d95d038594ef151397','2026-02-23 08:14:19','2026-01-24 04:14:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(293,2,'e032489a41dde53b0acfb380e327ab6fd60c0f637064da1dad52003a607dedba','2026-02-23 08:14:19','2026-01-24 04:14:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(294,2,'a654f8084f18b008de2a16340fd224489fa75df49ba5d39a24b1a9845faf8ab5','2026-02-23 08:14:19','2026-01-24 04:14:19',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(295,2,'cbf089a6592a721c4589a212f495d71a43954d87c257360cdbe3009c3f104d28','2026-02-23 08:14:48','2026-01-24 04:14:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(296,2,'24ca911aec3f8f82a04124d778df8fbe57e13e8a9614bf90f4ef190f9e547213','2026-02-23 08:14:50','2026-01-24 04:14:50',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(297,2,'f6dd1dbc12aee6d3a04b946dbc48d1e6d3d1728e641366d923068332a1a72588','2026-02-23 08:28:36','2026-01-24 04:28:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(298,2,'206aad7be354be91706724e11f9afd960567d6bf17effbfa755765bb16c15608','2026-02-23 08:28:36','2026-01-24 04:28:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(299,2,'3177bd2f6eed3e08c9e2669a5895dc3d4e2b3d9772faa1c509a5d89ceaa0f66e','2026-02-23 08:28:36','2026-01-24 04:28:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(300,2,'9d84c74de72c1c18c75b27ff7bdb882770d7e188cc27605ee0879e0a47b3897e','2026-02-23 08:28:55','2026-01-24 04:28:55',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(301,2,'bb6f1657beec1a70b01ff87b7e429b3e5b7be83fcf1b85a1080ff0c9ef3774a4','2026-02-23 10:17:18','2026-01-24 06:17:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(302,2,'6d56f86fc874978890041875d724f4fc449184ac7d61b034116b701ba05badc1','2026-02-23 10:17:18','2026-01-24 06:17:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(303,2,'193d6e8f3bdbb7b9f8fc2f8e50d48b867a960740af52f6a0b6d6d90f1c0f789b','2026-02-23 10:17:18','2026-01-24 06:17:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(304,2,'8b149f5433535d8e6be3bf4d6cf7a59c24da637fe44857b2c163392d827b2506','2026-02-23 10:17:27','2026-01-24 06:17:27',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(305,2,'8e03b74fdd5d5e19715b8630c3575454956023837ebe8bdaad23418ad52dc818','2026-02-23 10:17:28','2026-01-24 06:17:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(306,2,'3c6993e44ee49fcdb90af282fb9594ccdf13006e85fb034ac1ad53d00777cf7f','2026-02-23 10:17:58','2026-01-24 06:17:58',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(307,2,'f7d4f33f56a3da337b9f8ecc7f95a91a1c36d4e577a7964ca5daabdc94f8925c','2026-02-23 10:17:58','2026-01-24 06:17:58',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(308,2,'b380b0216a90c6ef06466bd8c7f616c8c6fa4b2ec0180ad99896ae28cacc8518','2026-02-23 10:17:58','2026-01-24 06:17:58',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(309,2,'d324fd9826b9000e8c291e620067f86cd137488077e70f17735e3e0206733596','2026-02-23 10:18:06','2026-01-24 06:18:06',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(310,2,'7242ce4546ec0e8314e1b8b0aeb8e728a1dfa1957d4c2b5d777446ed0a8ea212','2026-02-23 10:18:08','2026-01-24 06:18:08',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(311,2,'55909c4f5c55089022400e89c8a66cdd3464e77b99600b2b6d58b1cff52139bb','2026-02-23 10:23:48','2026-01-24 06:23:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(312,2,'94b5af9c1cb20fbd882545f5d8c21ef58ac98eb163ae48b888cf65275a158ac1','2026-02-23 10:24:02','2026-01-24 06:24:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(313,2,'3f6a15616731f168638f7ba4c6cb8a9b0ffd828de17074175e4d9836abfa3a4d','2026-02-23 10:26:07','2026-01-24 06:26:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(314,2,'c8b73a7f7c277240b442b9e476b69405fe079b622748f8c920fee3a023a43f57','2026-02-23 10:26:09','2026-01-24 06:26:09',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(315,2,'53066d2c592e95c16388e28a8351638573c184bae3f129878fa96a8987149827','2026-02-23 10:26:29','2026-01-24 06:26:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(316,2,'02ec24b1cb7268c939b1c1c9eb6f134d1c97f14d14845fc119be07caa1dd8691','2026-02-23 10:27:10','2026-01-24 06:27:10',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(317,2,'4437225b207b8da218e9dfa105b76e1117a4d3c6a15fa14e78456403f8e40d4e','2026-02-23 10:34:20','2026-01-24 06:34:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(318,2,'9804dd126e7a624b87d299685138dfd92ebf14104815efddbc82181380ddb054','2026-02-23 10:34:20','2026-01-24 06:34:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(319,2,'e48a05d35d2e694635bb972860218faf84d4714e57c319143c38e339f204df2f','2026-02-23 10:34:20','2026-01-24 06:34:20',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(320,2,'eb26c8a8fbfe9a5e886dc53ef93fe5baa0eef221ba668dcde6c0c7679f80d3fa','2026-02-23 10:34:34','2026-01-24 06:34:34',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(321,2,'fec41786fde5ee7f09dbaa7f4128b0392a9eb6401d5ddf000ed9431c88715d34','2026-02-23 10:34:36','2026-01-24 06:34:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(322,2,'307ae4394a2f72fd81c47b9a507d3ceb825034cd8e502f74ea7ea39be23b77e0','2026-02-23 10:34:37','2026-01-24 06:34:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(323,2,'787c00ef155e5a4d068cfe4a2e5bb3b340dc609fc74a06ae370f8358123d76c0','2026-02-23 10:34:46','2026-01-24 06:34:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(324,2,'4a5260a8b49a64a22378c3ae1fbced5076e2928009a296da06092a9bac6b8cf4','2026-02-23 10:35:17','2026-01-24 06:35:17',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(325,2,'5b447c0f27cd497fedad664e7ad14c5e5017043a16ea86a6fc25bf2f41eb2519','2026-02-23 10:35:18','2026-01-24 06:35:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(326,2,'2d959210c89c419b965458af5592f187d9630b5468234c18fc22085c145571dd','2026-02-23 10:35:18','2026-01-24 06:35:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(327,2,'57a8016dd2e8dc28417a3d07969dda010e1b38a50d2a307b3f480630579a501a','2026-02-23 10:37:44','2026-01-24 06:37:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(328,2,'005bccfe783e762ef43825c054c14089daf52ce2e49ac8208b519b2f4b489b9f','2026-02-23 10:37:44','2026-01-24 06:37:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(329,2,'36fbaa72a9947fb272a1be597094bb7e21ec4063c574c2a1720bd69f216f0464','2026-02-23 10:37:44','2026-01-24 06:37:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(330,2,'fdd1c03dd95c4f979a39c9aa3b94362ea4ee189566ab2689d21a1017bc996cb1','2026-02-23 10:37:55','2026-01-24 06:37:55',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(331,2,'e7c85686ff710de5b7f210d30b6ba282805f6407928e05ffcda6a7dcad14ec72','2026-02-23 10:37:57','2026-01-24 06:37:57',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(332,2,'9849e66adbd13b76215f07c3a1c531e4d1a98362c5cedcc181124b5c814c67c6','2026-02-23 10:39:07','2026-01-24 06:39:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(333,2,'36c01e995c6fed0fbd449b5ec72da86e8c4f5a0da6058dee1dfc88149f41006e','2026-02-23 10:39:11','2026-01-24 06:39:11',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(334,2,'60349705a3ed005a37f68bb99087b13fe4ca1af46f9d7724df8171eab3ba2461','2026-02-23 10:39:29','2026-01-24 06:39:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(335,2,'3cf858640e6bc0caed5b682dde791e2ae4d68ad5e062773ef41f6f2bf36ae551','2026-02-23 10:39:29','2026-01-24 06:39:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(336,2,'5aa1c0ff4877c368cc989b8c504ee7340204a24f6f94a2f3f3251a10669a2475','2026-02-23 10:39:30','2026-01-24 06:39:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(337,2,'099f22a72d55f3a7af69cdaad8bbd38230d7c8da6b62831416fdcc59d5bfefe4','2026-02-23 10:39:35','2026-01-24 06:39:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(338,2,'f19247de589a591fa7032d28c86e8a44a32a9f245b2f5b2f7bdac2d06061e5f2','2026-02-23 10:39:39','2026-01-24 06:39:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(339,2,'1c5d5c6db888e3cf8a569ede1e5c00025b7a822cd218fe3a03703801c3301c8a','2026-02-23 10:40:41','2026-01-24 06:40:41',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(340,2,'12d9f59aadc2992988c2568ff92a31cfe3eaab216fa94cd57683c017a6a7666b','2026-02-23 10:40:42','2026-01-24 06:40:42',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(341,2,'6b621f4966bb676e5fabcd095ee7ca9186777a1e55ecab74cd57f1afd37736af','2026-02-23 10:42:13','2026-01-24 06:42:13',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(342,2,'3e8d69c90457b56125ec9d6864aade7a964690a5393c0e82819580938a6ec5f3','2026-02-23 10:42:56','2026-01-24 06:42:56',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(343,2,'9f989ba878404d217661178179f2a9ce6cb786c00814ab5dd94054812b3a1a09','2026-02-23 10:42:57','2026-01-24 06:42:57',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(344,2,'61850d796f81397fefcf9fb34d635c4bbafe44836109f1185def8692630661c1','2026-02-23 10:42:57','2026-01-24 06:42:57',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(345,2,'2eab1548f8441cdff66f4f6259003f00e919e64761b8b2bc7fecb7c1cf2a1254','2026-02-23 10:48:35','2026-01-24 06:48:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(346,2,'db605f6006b5ff32739684d38002ac43847616604bdea13fb21ba89cb48efec9','2026-02-23 10:48:37','2026-01-24 06:48:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(347,2,'9790cd6e4f72d48f87b4aa134aa5b52b7b87496ec2850a2d23a4dccfd9a611dd','2026-02-23 10:49:35','2026-01-24 06:49:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(348,2,'a22fb6d5561ec76c0daa75516056a1f2b042d2ddc3e4d790d8d4bc71e8f334ac','2026-02-23 10:50:04','2026-01-24 06:50:04',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(349,2,'b30a788fcc71004e44f55cd327d35b5f9e153a3e1a6701fb5ee0575f943209a4','2026-02-23 10:50:38','2026-01-24 06:50:38',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(350,2,'9e20d346beef513edeac61728bfd2f86faedde304b53164f567f162684f16e0f','2026-02-23 10:51:24','2026-01-24 06:51:24',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(351,2,'f13f7f10210c54eb459b11fb308926c690904d17e21f7d41bab1cb8d878b35a3','2026-02-23 11:01:13','2026-01-24 07:01:13',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(352,2,'f186aef3d3764ede8932983e3e72998412239419dc00849fd9490720b3304c4f','2026-02-23 11:01:14','2026-01-24 07:01:14',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(353,2,'7f1a8fb7a57cc3f24be4b166c76df16e6529371cde00d9b2b54eee52abd5b2bd','2026-02-23 11:03:30','2026-01-24 07:03:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(354,2,'2036cf8ef86595fac3809a0e096a367b37d1a6bbbb2e377888f7a5aac715ae23','2026-02-25 05:24:18','2026-01-26 01:24:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(355,2,'cbc3f3991c594adf6ff478ec590d549d8c1eac2fce0a0ff18be688ffadb0cfc3','2026-02-25 05:24:18','2026-01-26 01:24:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(356,2,'9a97a909534824108a07942004b0efa5d7d3b72df69b0916586e2c1f31de1e76','2026-02-25 05:24:18','2026-01-26 01:24:18',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(357,2,'2fcd5f6f4a850378844e00b62d3d19187ef999eebfb2da1b981d4d13d41af94d','2026-02-25 05:24:26','2026-01-26 01:24:26',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(358,2,'49947e620f546bed4e7ce3b7bb4c7c9dfc715a847c29b67cb0996defd048292e','2026-02-25 05:24:28','2026-01-26 01:24:28',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(359,2,'ef776c069aad347902b692bf41d2d8256ed20aaf25c43c0fc1c7177cd92ef3ba','2026-02-25 05:24:30','2026-01-26 01:24:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(360,2,'c3009304b3e13bc570b0a6319bbd62aab089403e2f1a649408721c5e8b78ce31','2026-02-25 05:24:30','2026-01-26 01:24:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(361,2,'00804f65131a5ccc1fcc0fe341151e8231d48b920ce4da89ae3f1afcd9292054','2026-02-25 05:24:30','2026-01-26 01:24:30',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(362,2,'6af5703c342ec8c741de840de271408dad486f14122f54abdebee7570511da44','2026-02-25 05:24:38','2026-01-26 01:24:38',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(363,2,'039010105b69316d147d63a2a99158e6479b7545c686368ffb100c358eba5db5','2026-02-25 05:24:39','2026-01-26 01:24:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(364,2,'906f0b4502f8b69e32d12e8d611e8cd95d91079ae2526037e5188f898dd2fde5','2026-02-25 05:26:18','2026-01-26 01:26:18',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(365,2,'23fd73951e5650907a640bde333d760464dcaab57ebd37c12be22ee2d07f85ad','2026-02-25 05:47:17','2026-01-26 01:47:17',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(366,2,'a17258e9b1ea8eac6d0fef6ff95a9e4a83ceda1b4e7373057f3a1ef8f5920690','2026-02-25 05:47:17','2026-01-26 01:47:17',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(367,2,'facab3b0a8365046a64e23fa24c8a18adcb4d7edbeb0c0fabe19a3908f515d14','2026-02-25 05:47:17','2026-01-26 01:47:17',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(368,2,'cc7a283975529a1eec4aa18de3f2f5c7239f7febf6152849cc98030c945d4f4f','2026-02-25 05:47:24','2026-01-26 01:47:24',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(369,2,'5447a91c7fc1b4012c14d7b4da0f658fbb76515576df3fdd2a8dcc3bbdc655e4','2026-02-25 05:49:02','2026-01-26 01:49:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(370,2,'c67c66a4fc8700a552bcbd5d69d2b6a9220552c3ae8b5cf612d9760ff04ff4d5','2026-02-25 05:49:02','2026-01-26 01:49:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(371,2,'4773b6245ac0af17de4d1bc55df1bb281c6e10d2c6116208e88ba193a57527ec','2026-02-25 05:49:02','2026-01-26 01:49:02',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(372,5,'4108116cc31c749c0adacfec0f8faa5863e63c93b127a71ca026f63769c2412b','2026-02-27 03:41:46','2026-01-27 23:41:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(373,5,'c3f9b3f834176fe93c022d9a8890806bb5894f2ebb3f3a4bf16e71fcb24ce3be','2026-02-27 03:41:48','2026-01-27 23:41:48',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(374,5,'5a500c59e55f634c4414e57b98cf6284ad2b96c330229e6aa9cff209fd4223cf','2026-02-27 03:41:52','2026-01-27 23:41:52',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(375,5,'cb3d314cac04e7efa82143215f568a10383dead70026950035374c77a8befda2','2026-02-27 03:55:31','2026-01-27 23:55:31',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(376,5,'6d5335401319bda08be3ad6b3886828c0d94b792b20aef21b24352891be6cffc','2026-02-27 03:55:38','2026-01-27 23:55:38',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(377,5,'a6e44316b741e10d89bb81bd946e344fc87ec79d78c6bc4ef7f7427c0522a1f1','2026-02-27 04:09:26','2026-01-28 00:09:26',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(378,5,'f8550d65cbbc28bb92e9dd86f0582be9fb434e76b64344bc842afb29a55dae1c','2026-02-27 10:00:07','2026-01-28 06:00:07',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(379,5,'6584f71a4e4a23f3c300bd025206218e9d202579291cf86898babe785ec8bca8','2026-02-27 10:00:07','2026-01-28 06:00:07',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(380,5,'a351907323b54b49b690f49a14bd573c54fdc5e53263a63aad7974eba4bb2e42','2026-02-27 10:00:07','2026-01-28 06:00:07',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(381,5,'3b75532b62603424db8a94415b795ab66ca54af87259eed758b450437f014ef2','2026-02-27 10:00:12','2026-01-28 06:00:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(382,5,'315f40fa77e70080cc94aa47495d9e45e6ebff8e19fec75058f330ce82654491','2026-02-27 10:00:19','2026-01-28 06:00:19',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(383,5,'26913e57a3b665bcb5f5c98e0ebd408ad52ec5c63e5f1c94ec52884abac8bb5f','2026-02-27 10:01:39','2026-01-28 06:01:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(384,5,'04ec95cd8d797960f09ddba75f5528ea2931be2195a6d73dadb5ada3679617fc','2026-02-27 10:01:40','2026-01-28 06:01:40',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(385,5,'058bb689bafb8e2c667d0ff7faf6d6e0e730043272110bcbec230c3fe239edcd','2026-02-27 10:16:38','2026-01-28 06:16:38',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(386,5,'068b3dcedd7889eb224f0d31b3b26794154cb6b5515248a42d212f7c40854e07','2026-02-27 10:16:44','2026-01-28 06:16:44',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(387,5,'5eb365dbc347bf0576d91561d586ff620cf00d7f9490f42dd0f293f4726790ad','2026-02-27 10:16:50','2026-01-28 06:16:50',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(388,5,'a2ef7be35c7ca05b4aaf8ed9b65c39fc4d18438613b65d3175650d966e014bfb','2026-02-27 10:17:57','2026-01-28 06:17:57',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(389,5,'f2442077768c5d1db63b74f3836c77435aa38805e2cc0cd661c5cd215ca16ad7','2026-02-27 10:17:57','2026-01-28 06:17:57',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(390,5,'91e42f736dc69abaa53f52b7377803c5c284256c905729c9a066ca9813e33cd2','2026-02-27 10:18:00','2026-01-28 06:18:00',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(391,5,'6fbb0903b7d84e11bafc9ac6a1bc7a8afcd7da4c813df663daea21b35b78185a','2026-02-27 10:18:00','2026-01-28 06:18:00',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(392,5,'6b993f0a82c3949e92ac7c093ecd0486af9b9ad394184c46df6a9a2cd01fe4d0','2026-02-27 10:18:00','2026-01-28 06:18:00',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','127.0.0.1'),(393,5,'c40b3f97ec23c78f9ddede566991ee1e330657e59b7d94cf9d2ae0aa537d7f82','2026-02-27 10:18:35','2026-01-28 06:18:35',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(394,5,'a5e36b8f79af678f69bfc2e922c76a76755ef1fc30559f139078f546c2b82fbe','2026-02-27 10:18:36','2026-01-28 06:18:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1'),(395,5,'21e9b9084da9fcae721c634e7e5a8fc1355b5ba0acea93fce72ecefdf03de76f','2026-02-27 10:18:36','2026-01-28 06:18:36',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','::1');
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
-- Table structure for table `venda_item`
--

DROP TABLE IF EXISTS `venda_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venda_item` (
  `id_venda_item` bigint NOT NULL AUTO_INCREMENT,
  `id_venda` bigint NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `quantidade` int NOT NULL,
  `valor_unitario` decimal(10,2) NOT NULL,
  `desconto` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_linha` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_venda_item`),
  KEY `idx_vi_venda` (`id_venda`),
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
-- Temporary view structure for view `vw_agenda_disponibilidade`
--

DROP TABLE IF EXISTS `vw_agenda_disponibilidade`;
/*!50001 DROP VIEW IF EXISTS `vw_agenda_disponibilidade`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_agenda_disponibilidade` AS SELECT 
 1 AS `id_disponibilidade`,
 1 AS `id_sistema`,
 1 AS `id_unidade`,
 1 AS `id_profissional`,
 1 AS `id_local_operacional`,
 1 AS `tipo`,
 1 AS `inicio_em`,
 1 AS `fim_em`,
 1 AS `recorrente`,
 1 AS `dia_semana`,
 1 AS `ativo`,
 1 AS `profissional_login`,
 1 AS `local_nome`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_agendamento_detalhado`
--

DROP TABLE IF EXISTS `vw_agendamento_detalhado`;
/*!50001 DROP VIEW IF EXISTS `vw_agendamento_detalhado`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_agendamento_detalhado` AS SELECT 
 1 AS `id_agendamento`,
 1 AS `id_sistema`,
 1 AS `id_unidade`,
 1 AS `id_local_operacional`,
 1 AS `id_profissional`,
 1 AS `id_paciente`,
 1 AS `id_ffa`,
 1 AS `id_senha`,
 1 AS `id_servico`,
 1 AS `servico_codigo`,
 1 AS `servico_nome`,
 1 AS `servico_tipo`,
 1 AS `inicio_em`,
 1 AS `fim_em`,
 1 AS `status`,
 1 AS `origem`,
 1 AS `observacao`,
 1 AS `criado_em`,
 1 AS `atualizado_em`,
 1 AS `criado_por`,
 1 AS `id_sessao_criacao`,
 1 AS `profissional_login`,
 1 AS `criado_por_login`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alerta_atraso_clinico`
--

DROP TABLE IF EXISTS `vw_alerta_atraso_clinico`;
/*!50001 DROP VIEW IF EXISTS `vw_alerta_atraso_clinico`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alerta_atraso_clinico` AS SELECT 
 1 AS `nome_completo`,
 1 AS `classificacao_cor`,
 1 AS `tempo_limite`,
 1 AS `tempo_atrasado`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_alerta_news`
--

DROP TABLE IF EXISTS `vw_alpha_alerta_news`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_alerta_news`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_alerta_news` AS SELECT 
 1 AS `id_atendimento`,
 1 AS `pontuacao_gravidade`,
 1 AS `data_registro`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_auditoria_faturamento`
--

DROP TABLE IF EXISTS `vw_alpha_auditoria_faturamento`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_auditoria_faturamento`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_auditoria_faturamento` AS SELECT 
 1 AS `conta_id`,
 1 AS `protocolo`,
 1 AS `convenio`,
 1 AS `qtd_exames`,
 1 AS `valor_total`,
 1 AS `status_conta`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_bi_custo_atendimento`
--

DROP TABLE IF EXISTS `vw_alpha_bi_custo_atendimento`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_bi_custo_atendimento`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_bi_custo_atendimento` AS SELECT 
 1 AS `id_atendimento`,
 1 AS `id_pessoa`,
 1 AS `custo_total_insumos`,
 1 AS `repasse_previsto_sus`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_bi_custos`
--

DROP TABLE IF EXISTS `vw_alpha_bi_custos`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_bi_custos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_bi_custos` AS SELECT 
 1 AS `id_unidade`,
 1 AS `qtd_atendimentos`,
 1 AS `total_medicoes`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_bi_gestao_publica`
--

DROP TABLE IF EXISTS `vw_alpha_bi_gestao_publica`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_bi_gestao_publica`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_bi_gestao_publica` AS SELECT 
 1 AS `unidade`,
 1 AS `total_atendimentos`,
 1 AS `casos_criticos`,
 1 AS `tempo_medio_espera_minutos`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_censo_hospitalar`
--

DROP TABLE IF EXISTS `vw_alpha_censo_hospitalar`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_censo_hospitalar`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_censo_hospitalar` AS SELECT 
 1 AS `unidade`,
 1 AS `tipo_leito`,
 1 AS `total_leitos`,
 1 AS `ocupados`,
 1 AS `disponiveis`,
 1 AS `taxa_ocupacao`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_custo_atendimento`
--

DROP TABLE IF EXISTS `vw_alpha_custo_atendimento`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_custo_atendimento`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_custo_atendimento` AS SELECT 
 1 AS `id_atendimento`,
 1 AS `paciente`,
 1 AS `custo_total_insumos`,
 1 AS `status_final`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_eficiencia_hospitalar`
--

DROP TABLE IF EXISTS `vw_alpha_eficiencia_hospitalar`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_eficiencia_hospitalar`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_eficiencia_hospitalar` AS SELECT 
 1 AS `ffa_id`,
 1 AS `id_pessoa`,
 1 AS `status_atual`,
 1 AS `classificacao_cor`,
 1 AS `entrada`,
 1 AS `horas_permanencia`,
 1 AS `risco_operacional`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_financeiro_mensal`
--

DROP TABLE IF EXISTS `vw_alpha_financeiro_mensal`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_financeiro_mensal`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_financeiro_mensal` AS SELECT 
 1 AS `medico`,
 1 AS `total_atendimentos`,
 1 AS `total_a_pagar`,
 1 AS `mes_referencia`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_kpi_reinternacao`
--

DROP TABLE IF EXISTS `vw_alpha_kpi_reinternacao`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_kpi_reinternacao`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_kpi_reinternacao` AS SELECT 
 1 AS `id_pessoa`,
 1 AS `id_alta_anterior`,
 1 AS `id_retorno`,
 1 AS `data_alta_anterior`,
 1 AS `data_retorno`,
 1 AS `horas_intervalo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_line_gestao`
--

DROP TABLE IF EXISTS `vw_alpha_line_gestao`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_line_gestao`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_line_gestao` AS SELECT 
 1 AS `senha_id`,
 1 AS `paciente`,
 1 AS `prioridade`,
 1 AS `status`,
 1 AS `id_servico`,
 1 AS `id_unidade`,
 1 AS `espera_minutos`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_line_resumo`
--

DROP TABLE IF EXISTS `vw_alpha_line_resumo`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_line_resumo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_line_resumo` AS SELECT 
 1 AS `id_unidade`,
 1 AS `total_adulto_espera`,
 1 AS `total_pediatrico_espera`,
 1 AS `total_prioritario_espera`,
 1 AS `emergencias_em_curso`,
 1 AS `tempo_medio_espera_geral`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_mapa_calor_setores`
--

DROP TABLE IF EXISTS `vw_alpha_mapa_calor_setores`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_mapa_calor_setores`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_mapa_calor_setores` AS SELECT 
 1 AS `setor`,
 1 AS `status`,
 1 AS `quantidade`,
 1 AS `tempo_medio_espera_atual`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_painel_chamada`
--

DROP TABLE IF EXISTS `vw_alpha_painel_chamada`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_painel_chamada`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_painel_chamada` AS SELECT 
 1 AS `senha`,
 1 AS `lane`,
 1 AS `status`,
 1 AS `hora_gerada`,
 1 AS `tempo_espera_min`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_painel_espera`
--

DROP TABLE IF EXISTS `vw_alpha_painel_espera`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_painel_espera`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_painel_espera` AS SELECT 
 1 AS `senha_formatada`,
 1 AS `lane`,
 1 AS `status`,
 1 AS `prioridade`,
 1 AS `hora_chegada`,
 1 AS `minutos_espera`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_passagem_plantao`
--

DROP TABLE IF EXISTS `vw_alpha_passagem_plantao`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_passagem_plantao`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_passagem_plantao` AS SELECT 
 1 AS `leito`,
 1 AS `paciente`,
 1 AS `status_clinico`,
 1 AS `alerta_principal`,
 1 AS `ultima_prescricao`,
 1 AS `horas_de_internacao`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_performance_fila`
--

DROP TABLE IF EXISTS `vw_alpha_performance_fila`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_performance_fila`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_performance_fila` AS SELECT 
 1 AS `id_unidade`,
 1 AS `tipo_atendimento`,
 1 AS `total_senhas_hoje`,
 1 AS `avg_espera_chamada_min`,
 1 AS `avg_duracao_atendimento_min`,
 1 AS `maior_espera_atual_min`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_plantao_atual`
--

DROP TABLE IF EXISTS `vw_alpha_plantao_atual`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_plantao_atual`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_plantao_atual` AS SELECT 
 1 AS `medico`,
 1 AS `turno`,
 1 AS `status_presenca`,
 1 AS `unidade`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_produtividade_plantoes`
--

DROP TABLE IF EXISTS `vw_alpha_produtividade_plantoes`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_produtividade_plantoes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_produtividade_plantoes` AS SELECT 
 1 AS `profissional`,
 1 AS `total_atendimentos`,
 1 AS `tempo_medio_prontuario`,
 1 AS `casos_criticos`,
 1 AS `primeiro_movimento`,
 1 AS `ultimo_movimento`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_alpha_visao_360_paciente`
--

DROP TABLE IF EXISTS `vw_alpha_visao_360_paciente`;
/*!50001 DROP VIEW IF EXISTS `vw_alpha_visao_360_paciente`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_alpha_visao_360_paciente` AS SELECT 
 1 AS `id_pessoa`,
 1 AS `paciente_nome`,
 1 AS `alertas_ativos`,
 1 AS `pa_sistolica`,
 1 AS `pa_diastolica`,
 1 AS `temperatura`,
 1 AS `saturacao_o2`,
 1 AS `ultima_medicao`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_assistencia_social_alertas`
--

DROP TABLE IF EXISTS `vw_assistencia_social_alertas`;
/*!50001 DROP VIEW IF EXISTS `vw_assistencia_social_alertas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_assistencia_social_alertas` AS SELECT 
 1 AS `nome_completo`,
 1 AS `tipo`,
 1 AS `data_entrada`,
 1 AS `dias_internado`,
 1 AS `previsao_alta`,
 1 AS `medico_responsavel`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_auditoria_exames_heranca`
--

DROP TABLE IF EXISTS `vw_auditoria_exames_heranca`;
/*!50001 DROP VIEW IF EXISTS `vw_auditoria_exames_heranca`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_auditoria_exames_heranca` AS SELECT 
 1 AS `etiqueta_lab`,
 1 AS `senha_origem`,
 1 AS `gpat_ffa`,
 1 AS `atendimento_protocolo`,
 1 AS `paciente`,
 1 AS `situacao_exame`,
 1 AS `data_solicitacao`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_auditoria_faturamento_farmacia`
--

DROP TABLE IF EXISTS `vw_auditoria_faturamento_farmacia`;
/*!50001 DROP VIEW IF EXISTS `vw_auditoria_faturamento_farmacia`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_auditoria_faturamento_farmacia` AS SELECT 
 1 AS `id_atendimento`,
 1 AS `paciente`,
 1 AS `medicamento`,
 1 AS `quantidade_dispensada`,
 1 AS `farmaceutico`,
 1 AS `data_hora_dispensacao`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_censo_hospitalar_luxo`
--

DROP TABLE IF EXISTS `vw_censo_hospitalar_luxo`;
/*!50001 DROP VIEW IF EXISTS `vw_censo_hospitalar_luxo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_censo_hospitalar_luxo` AS SELECT 
 1 AS `unidade`,
 1 AS `tipo_unidade`,
 1 AS `setor`,
 1 AS `leito`,
 1 AS `situacao_leito`,
 1 AS `paciente`,
 1 AS `precaucao`,
 1 AS `modalidade`,
 1 AS `dias_internado`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_estatistica_evasao_totem`
--

DROP TABLE IF EXISTS `vw_estatistica_evasao_totem`;
/*!50001 DROP VIEW IF EXISTS `vw_estatistica_evasao_totem`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_estatistica_evasao_totem` AS SELECT 
 1 AS `total_senhas`,
 1 AS `desistencias_totem`,
 1 AS `porcentagem_evasao`*/;
SET character_set_client = @saved_cs_client;

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
 1 AS `quantidade_atual`,
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
-- Temporary view structure for view `vw_farmacia_medicacao_pendentes`
--

DROP TABLE IF EXISTS `vw_farmacia_medicacao_pendentes`;
/*!50001 DROP VIEW IF EXISTS `vw_farmacia_medicacao_pendentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_farmacia_medicacao_pendentes` AS SELECT 
 1 AS `id_ordem`,
 1 AS `id_item`,
 1 AS `id_ffa`,
 1 AS `ordem_status`,
 1 AS `ordem_prioridade`,
 1 AS `item_status`,
 1 AS `id_farmaco`,
 1 AS `farmaco_nome`,
 1 AS `dose`,
 1 AS `via`,
 1 AS `posologia`,
 1 AS `dias`,
 1 AS `quantidade_total`,
 1 AS `quantidade_dispensada`,
 1 AS `quantidade_pendente`,
 1 AS `ffa_status`,
 1 AS `gpat`,
 1 AS `senha_codigo`,
 1 AS `paciente_nome`,
 1 AS `paciente_nome_social`,
 1 AS `criado_em`*/;
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
 1 AS `id_lote`,
 1 AS `data_validade`,
 1 AS `dias_para_vencer`,
 1 AS `nivel_risco`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_faturamento_gasoterapia_pendente`
--

DROP TABLE IF EXISTS `vw_faturamento_gasoterapia_pendente`;
/*!50001 DROP VIEW IF EXISTS `vw_faturamento_gasoterapia_pendente`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_faturamento_gasoterapia_pendente` AS SELECT 
 1 AS `protocolo`,
 1 AS `paciente`,
 1 AS `tipo_gas`,
 1 AS `data_inicio`,
 1 AS `data_referencia`,
 1 AS `total_horas`,
 1 AS `total_litros_consumidos`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_fila_aguardando_recepcao`
--

DROP TABLE IF EXISTS `vw_fila_aguardando_recepcao`;
/*!50001 DROP VIEW IF EXISTS `vw_fila_aguardando_recepcao`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_fila_aguardando_recepcao` AS SELECT 
 1 AS `id_senha`,
 1 AS `ticket`,
 1 AS `lane`,
 1 AS `hora_chegada`,
 1 AS `tempo_espera_min`*/;
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
 1 AS `prioridade`,
 1 AS `iniciado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_fila_medica_priorizada`
--

DROP TABLE IF EXISTS `vw_fila_medica_priorizada`;
/*!50001 DROP VIEW IF EXISTS `vw_fila_medica_priorizada`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_fila_medica_priorizada` AS SELECT 
 1 AS `id_ficha`,
 1 AS `paciente`,
 1 AS `classificacao_cor`,
 1 AS `hora_entrada`,
 1 AS `minutos_para_vencer`,
 1 AS `status_prazo`*/;
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
 1 AS `prioridade_real`,
 1 AS `data_entrada`,
 1 AS `data_inicio`,
 1 AS `data_fim`,
 1 AS `id_local_operacional`,
 1 AS `local_nome`,
 1 AS `nao_compareceu_em`,
 1 AS `retorno_permitido_ate`,
 1 AS `retorno_utilizado`,
 1 AS `retorno_em`,
 1 AS `is_retorno`,
 1 AS `prioridade_rank_real`,
 1 AS `tempo_max_min`,
 1 AS `espera_min`,
 1 AS `prioridade_rank_efetiva`,
 1 AS `elevada_por_tempo`,
 1 AS `prioridade_efetiva`,
 1 AS `paciente_nome`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_fila_operacional_manchester`
--

DROP TABLE IF EXISTS `vw_fila_operacional_manchester`;
/*!50001 DROP VIEW IF EXISTS `vw_fila_operacional_manchester`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_fila_operacional_manchester` AS SELECT 
 1 AS `id_fila`,
 1 AS `id_ffa`,
 1 AS `tipo`,
 1 AS `substatus`,
 1 AS `prioridade_real`,
 1 AS `data_entrada`,
 1 AS `data_inicio`,
 1 AS `data_fim`,
 1 AS `id_responsavel`,
 1 AS `id_local`,
 1 AS `tempo_max_min`,
 1 AS `minutos_espera`,
 1 AS `elevou_por_tempo`,
 1 AS `prioridade_efetiva`,
 1 AS `prioridade_rank_efetiva`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_fila_recepcao`
--

DROP TABLE IF EXISTS `vw_fila_recepcao`;
/*!50001 DROP VIEW IF EXISTS `vw_fila_recepcao`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_fila_recepcao` AS SELECT 
 1 AS `id_senha`,
 1 AS `ticket`,
 1 AS `lane`,
 1 AS `status`,
 1 AS `id_local_operacional`,
 1 AS `hora_chegada`,
 1 AS `tempo_espera_min`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_front_farmacia_alertas`
--

DROP TABLE IF EXISTS `vw_front_farmacia_alertas`;
/*!50001 DROP VIEW IF EXISTS `vw_front_farmacia_alertas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_front_farmacia_alertas` AS SELECT 
 1 AS `id_farmaco`,
 1 AS `nome_comercial`,
 1 AS `principio_ativo`,
 1 AS `estoque_real`,
 1 AS `min_estoque`,
 1 AS `status_estoque`,
 1 AS `lotes_vencendo_30d`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_gestao_chamados_hospitalares`
--

DROP TABLE IF EXISTS `vw_gestao_chamados_hospitalares`;
/*!50001 DROP VIEW IF EXISTS `vw_gestao_chamados_hospitalares`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_gestao_chamados_hospitalares` AS SELECT 
 1 AS `id_chamado`,
 1 AS `unidade`,
 1 AS `area_responsavel`,
 1 AS `titulo`,
 1 AS `prioridade`,
 1 AS `status`,
 1 AS `aberto_por`,
 1 AS `horas_aberto`,
 1 AS `ticket_externo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_guia_laboratorio_integrada`
--

DROP TABLE IF EXISTS `vw_guia_laboratorio_integrada`;
/*!50001 DROP VIEW IF EXISTS `vw_guia_laboratorio_integrada`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_guia_laboratorio_integrada` AS SELECT 
 1 AS `scanner_code`,
 1 AS `senha_numero`,
 1 AS `gpat_identificador`,
 1 AS `paciente`,
 1 AS `protocolo_atendimento`,
 1 AS `status_exame`*/;
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
-- Temporary view structure for view `vw_kpi_tempos_processo`
--

DROP TABLE IF EXISTS `vw_kpi_tempos_processo`;
/*!50001 DROP VIEW IF EXISTS `vw_kpi_tempos_processo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_kpi_tempos_processo` AS SELECT 
 1 AS `dia`,
 1 AS `tipo_setor`,
 1 AS `total_registros`,
 1 AS `avg_espera_ate_inicio_min`,
 1 AS `avg_duracao_execucao_min`,
 1 AS `maior_espera_atual_min`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_medicacao_itens_por_ffa`
--

DROP TABLE IF EXISTS `vw_medicacao_itens_por_ffa`;
/*!50001 DROP VIEW IF EXISTS `vw_medicacao_itens_por_ffa`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_medicacao_itens_por_ffa` AS SELECT 
 1 AS `id_ffa`,
 1 AS `id_ordem`,
 1 AS `id_item`,
 1 AS `ordem_status`,
 1 AS `item_status`,
 1 AS `id_farmaco`,
 1 AS `farmaco_nome`,
 1 AS `dose`,
 1 AS `via`,
 1 AS `posologia`,
 1 AS `dias`,
 1 AS `quantidade_total`,
 1 AS `quantidade_dispensada`,
 1 AS `quantidade_pendente`,
 1 AS `criado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_medico_fila`
--

DROP TABLE IF EXISTS `vw_medico_fila`;
/*!50001 DROP VIEW IF EXISTS `vw_medico_fila`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_medico_fila` AS SELECT 
 1 AS `id_fila`,
 1 AS `id_ffa`,
 1 AS `substatus`,
 1 AS `prioridade_real`,
 1 AS `data_entrada`,
 1 AS `data_inicio`,
 1 AS `data_fim`,
 1 AS `id_responsavel`,
 1 AS `gpat`,
 1 AS `status_ffa`,
 1 AS `classificacao_cor`,
 1 AS `tempo_limite`,
 1 AS `senha_codigo`,
 1 AS `tipo_atendimento`,
 1 AS `id_paciente`,
 1 AS `nome_social`,
 1 AS `nome_completo`,
 1 AS `paciente_nome`*/;
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
 1 AS `paciente`,
 1 AS `leito`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_chamada_voz`
--

DROP TABLE IF EXISTS `vw_painel_chamada_voz`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_chamada_voz`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_chamada_voz` AS SELECT 
 1 AS `origem`,
 1 AS `id_evento`,
 1 AS `painel_codigo`,
 1 AS `id_local_operacional`,
 1 AS `id_senha`,
 1 AS `senha_codigo`,
 1 AS `lane`,
 1 AS `tipo_atendimento`,
 1 AS `chamado_em`,
 1 AS `segundos_desde_chamada`,
 1 AS `texto_tts`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_chamadas_ativas`
--

DROP TABLE IF EXISTS `vw_painel_chamadas_ativas`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_chamadas_ativas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_chamadas_ativas` AS SELECT 
 1 AS `origem`,
 1 AS `id_evento`,
 1 AS `painel_codigo`,
 1 AS `id_local_operacional`,
 1 AS `id_senha`,
 1 AS `senha_codigo`,
 1 AS `lane`,
 1 AS `tipo_atendimento`,
 1 AS `chamado_em`,
 1 AS `texto_tts`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_chamadas_recentes`
--

DROP TABLE IF EXISTS `vw_painel_chamadas_recentes`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_chamadas_recentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_chamadas_recentes` AS SELECT 
 1 AS `id_evento`,
 1 AS `id_fila`,
 1 AS `tipo`,
 1 AS `id_local_operacional`,
 1 AS `local_nome`,
 1 AS `id_ffa`,
 1 AS `gpat`,
 1 AS `senha_codigo`,
 1 AS `paciente_nome`,
 1 AS `tipo_evento`,
 1 AS `detalhe`,
 1 AS `criado_em`,
 1 AS `blink_ate`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_fila`
--

DROP TABLE IF EXISTS `vw_painel_fila`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_fila`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_fila` AS SELECT 
 1 AS `painel_codigo`,
 1 AS `origem`,
 1 AS `id_fila`,
 1 AS `id_ffa`,
 1 AS `tipo`,
 1 AS `substatus`,
 1 AS `prioridade_rank_efetiva`,
 1 AS `prioridade_rank_real`,
 1 AS `elevada_por_tempo`,
 1 AS `prioridade_efetiva`,
 1 AS `espera_min`,
 1 AS `data_entrada`,
 1 AS `data_inicio`,
 1 AS `data_fim`,
 1 AS `id_local_operacional`,
 1 AS `local_nome`,
 1 AS `is_retorno`,
 1 AS `retorno_permitido_ate`,
 1 AS `ffa_status`,
 1 AS `gpat`,
 1 AS `senha_codigo`,
 1 AS `lane`,
 1 AS `tipo_atendimento`,
 1 AS `paciente_nome`,
 1 AS `paciente_nome_social`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_fila_recepcao`
--

DROP TABLE IF EXISTS `vw_painel_fila_recepcao`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_fila_recepcao`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_fila_recepcao` AS SELECT 
 1 AS `painel_codigo`,
 1 AS `tipo`,
 1 AS `substatus`,
 1 AS `prioridade_rank_efetiva`,
 1 AS `prioridade_rank_real`,
 1 AS `elevada_por_tempo`,
 1 AS `prioridade_efetiva`,
 1 AS `espera_min`,
 1 AS `data_entrada`,
 1 AS `data_inicio`,
 1 AS `data_fim`,
 1 AS `id_local_operacional`,
 1 AS `local_nome`,
 1 AS `is_retorno`,
 1 AS `retorno_permitido_ate`,
 1 AS `ffa_status`,
 1 AS `gpat`,
 1 AS `senha_codigo`,
 1 AS `lane`,
 1 AS `tipo_atendimento`,
 1 AS `paciente_nome`,
 1 AS `paciente_nome_social`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_fila_setor`
--

DROP TABLE IF EXISTS `vw_painel_fila_setor`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_fila_setor`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_fila_setor` AS SELECT 
 1 AS `painel_codigo`,
 1 AS `id_fila`,
 1 AS `id_ffa`,
 1 AS `tipo`,
 1 AS `substatus`,
 1 AS `prioridade_real`,
 1 AS `prioridade_rank_real`,
 1 AS `prioridade_rank_efetiva`,
 1 AS `elevada_por_tempo`,
 1 AS `prioridade_efetiva`,
 1 AS `tempo_max_min`,
 1 AS `espera_min`,
 1 AS `data_entrada`,
 1 AS `data_inicio`,
 1 AS `data_fim`,
 1 AS `id_local_operacional`,
 1 AS `local_nome`,
 1 AS `is_retorno`,
 1 AS `nao_compareceu_em`,
 1 AS `retorno_permitido_ate`,
 1 AS `retorno_utilizado`,
 1 AS `retorno_em`,
 1 AS `ffa_status`,
 1 AS `gpat`,
 1 AS `senha_codigo`,
 1 AS `lane`,
 1 AS `tipo_atendimento`,
 1 AS `paciente_nome`,
 1 AS `paciente_nome_social`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_mensagens_pendentes`
--

DROP TABLE IF EXISTS `vw_painel_mensagens_pendentes`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_mensagens_pendentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_mensagens_pendentes` AS SELECT 
 1 AS `painel_codigo`,
 1 AS `id_mensagem`,
 1 AS `tipo`,
 1 AS `titulo`,
 1 AS `texto`,
 1 AS `prioridade`,
 1 AS `criado_em`,
 1 AS `expira_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_monitor_kpis`
--

DROP TABLE IF EXISTS `vw_painel_monitor_kpis`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_monitor_kpis`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_monitor_kpis` AS SELECT 
 1 AS `painel_codigo`,
 1 AS `id_painel`,
 1 AS `id_unidade`,
 1 AS `id_local_operacional`,
 1 AS `id_especialidade`,
 1 AS `especialidade`,
 1 AS `id_local_config`,
 1 AS `qtd_aguardando`,
 1 AS `qtd_em_execucao`,
 1 AS `qtd_nao_atendido`,
 1 AS `primeiro_aguardando_em`,
 1 AS `ultima_entrada_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_monitor_medicos_agora`
--

DROP TABLE IF EXISTS `vw_painel_monitor_medicos_agora`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_monitor_medicos_agora`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_monitor_medicos_agora` AS SELECT 
 1 AS `painel_codigo`,
 1 AS `id_painel`,
 1 AS `id_unidade`,
 1 AS `id_local_operacional`,
 1 AS `dia`,
 1 AS `id_especialidade`,
 1 AS `especialidade`,
 1 AS `id_local_config`,
 1 AS `local_config_nome`,
 1 AS `qtd_medicos_agora`,
 1 AS `medicos`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_monitoramento_medico`
--

DROP TABLE IF EXISTS `vw_painel_monitoramento_medico`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_monitoramento_medico`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_monitoramento_medico` AS SELECT 
 1 AS `grupo_codigo`,
 1 AS `grupo_nome`,
 1 AS `tipo_setor`,
 1 AS `qtd_total`,
 1 AS `qtd_aguardando`,
 1 AS `qtd_chamando`,
 1 AS `qtd_em_execucao`,
 1 AS `avg_espera_atual_min`,
 1 AS `avg_duracao_min`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_monitoramento_medico_kpis`
--

DROP TABLE IF EXISTS `vw_painel_monitoramento_medico_kpis`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_monitoramento_medico_kpis`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_monitoramento_medico_kpis` AS SELECT 
 1 AS `tipo_fila`,
 1 AS `qtd_total`,
 1 AS `qtd_aguardando`,
 1 AS `qtd_em_execucao`,
 1 AS `qtd_finalizado`,
 1 AS `qtd_nao_compareceu`,
 1 AS `media_espera_min`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_tts_pendentes`
--

DROP TABLE IF EXISTS `vw_painel_tts_pendentes`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_tts_pendentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_tts_pendentes` AS SELECT 
 1 AS `origem`,
 1 AS `id_evento`,
 1 AS `painel_codigo`,
 1 AS `id_local_operacional`,
 1 AS `local_nome`,
 1 AS `senha_codigo`,
 1 AS `id_fila`,
 1 AS `tipo_fila`,
 1 AS `criado_em`,
 1 AS `texto_tts`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_painel_tv_rotativo_lista`
--

DROP TABLE IF EXISTS `vw_painel_tv_rotativo_lista`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_tv_rotativo_lista`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_tv_rotativo_lista` AS SELECT 
 1 AS `tela`,
 1 AS `id_fila`,
 1 AS `id_ffa`,
 1 AS `tipo`,
 1 AS `substatus`,
 1 AS `prioridade_real`,
 1 AS `prioridade_rank_real`,
 1 AS `prioridade_rank_efetiva`,
 1 AS `elevada_por_tempo`,
 1 AS `prioridade_efetiva`,
 1 AS `tempo_max_min`,
 1 AS `espera_min`,
 1 AS `data_entrada`,
 1 AS `data_inicio`,
 1 AS `data_fim`,
 1 AS `id_local_operacional`,
 1 AS `local_nome`,
 1 AS `is_retorno`,
 1 AS `nao_compareceu_em`,
 1 AS `retorno_permitido_ate`,
 1 AS `retorno_utilizado`,
 1 AS `retorno_em`,
 1 AS `ffa_status`,
 1 AS `gpat`,
 1 AS `senha_codigo`,
 1 AS `lane`,
 1 AS `tipo_atendimento`,
 1 AS `paciente_nome`,
 1 AS `paciente_nome_social`,
 1 AS `rn`*/;
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
-- Temporary view structure for view `vw_profissionais_ativos`
--

DROP TABLE IF EXISTS `vw_profissionais_ativos`;
/*!50001 DROP VIEW IF EXISTS `vw_profissionais_ativos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_profissionais_ativos` AS SELECT 
 1 AS `nome_completo`,
 1 AS `login`,
 1 AS `tipo_registro`,
 1 AS `numero_registro`,
 1 AS `carimbo_completo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_prontuario_espelho`
--

DROP TABLE IF EXISTS `vw_prontuario_espelho`;
/*!50001 DROP VIEW IF EXISTS `vw_prontuario_espelho`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_prontuario_espelho` AS SELECT 
 1 AS `id_atendimento`,
 1 AS `paciente`,
 1 AS `data_registro`,
 1 AS `texto_evolucao`,
 1 AS `profissional`,
 1 AS `conselho`,
 1 AS `nro_registro`,
 1 AS `assinatura_formata`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_protocolo_pendentes`
--

DROP TABLE IF EXISTS `vw_protocolo_pendentes`;
/*!50001 DROP VIEW IF EXISTS `vw_protocolo_pendentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_protocolo_pendentes` AS SELECT 
 1 AS `id_protocolo`,
 1 AS `tipo`,
 1 AS `codigo`,
 1 AS `barcode`,
 1 AS `status`,
 1 AS `criado_em`,
 1 AS `atualizado_em`,
 1 AS `id_ffa`,
 1 AS `gpat`,
 1 AS `senha_codigo`,
 1 AS `local_nome`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_resumo_beira_leito`
--

DROP TABLE IF EXISTS `vw_resumo_beira_leito`;
/*!50001 DROP VIEW IF EXISTS `vw_resumo_beira_leito`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_resumo_beira_leito` AS SELECT 
 1 AS `leito`,
 1 AS `paciente`,
 1 AS `precaucao`,
 1 AS `ult_sat`,
 1 AS `ult_pa`,
 1 AS `ultima_nota`*/;
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
-- Temporary view structure for view `vw_totem_plantao_banner`
--

DROP TABLE IF EXISTS `vw_totem_plantao_banner`;
/*!50001 DROP VIEW IF EXISTS `vw_totem_plantao_banner`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_totem_plantao_banner` AS SELECT 
 1 AS `dia`,
 1 AS `setor`,
 1 AS `medico_nome`,
 1 AS `crm`,
 1 AS `especialidade`,
 1 AS `periodo`,
 1 AS `inicio`,
 1 AS `fim`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_totem_satisfacao_resumo_hoje`
--

DROP TABLE IF EXISTS `vw_totem_satisfacao_resumo_hoje`;
/*!50001 DROP VIEW IF EXISTS `vw_totem_satisfacao_resumo_hoje`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_totem_satisfacao_resumo_hoje` AS SELECT 
 1 AS `dia`,
 1 AS `painel_tipo`,
 1 AS `avaliacao`,
 1 AS `qtd`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_totem_senha_opcoes`
--

DROP TABLE IF EXISTS `vw_totem_senha_opcoes`;
/*!50001 DROP VIEW IF EXISTS `vw_totem_senha_opcoes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_totem_senha_opcoes` AS SELECT 
 1 AS `painel_codigo`,
 1 AS `opcao_codigo`,
 1 AS `opcao_label`,
 1 AS `lane`,
 1 AS `tipo_atendimento`,
 1 AS `prefixo`,
 1 AS `ordem`,
 1 AS `ativo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_tv_rotativo_telas_ativas`
--

DROP TABLE IF EXISTS `vw_tv_rotativo_telas_ativas`;
/*!50001 DROP VIEW IF EXISTS `vw_tv_rotativo_telas_ativas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_tv_rotativo_telas_ativas` AS SELECT 
 1 AS `id_painel_tv`,
 1 AS `painel_tv_codigo`,
 1 AS `ordem`,
 1 AS `codigo_tela`,
 1 AS `duracao_seg`,
 1 AS `ativo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_usuario_contextos_master`
--

DROP TABLE IF EXISTS `vw_usuario_contextos_master`;
/*!50001 DROP VIEW IF EXISTS `vw_usuario_contextos_master`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_usuario_contextos_master` AS SELECT 
 1 AS `id_usuario`,
 1 AS `login`,
 1 AS `id_sistema`,
 1 AS `perfil_slug`,
 1 AS `unidade_nome`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_usuario_contextos_v2`
--

DROP TABLE IF EXISTS `vw_usuario_contextos_v2`;
/*!50001 DROP VIEW IF EXISTS `vw_usuario_contextos_v2`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_usuario_contextos_v2` AS SELECT 
 1 AS `id_usuario`,
 1 AS `id_sistema`,
 1 AS `sistema`,
 1 AS `id_unidade`,
 1 AS `unidade`,
 1 AS `id_local_operacional`,
 1 AS `codigo`,
 1 AS `nome`,
 1 AS `tipo`,
 1 AS `ativo_vinculo`*/;
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
 1 AS `login`,
 1 AS `id_sistema`,
 1 AS `sistema`,
 1 AS `id_perfil`,
 1 AS `perfil`,
 1 AS `ativo_vinculo`*/;
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
-- Temporary view structure for view `vw_usuario_permissoes_v2`
--

DROP TABLE IF EXISTS `vw_usuario_permissoes_v2`;
/*!50001 DROP VIEW IF EXISTS `vw_usuario_permissoes_v2`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_usuario_permissoes_v2` AS SELECT 
 1 AS `id_usuario`,
 1 AS `id_sistema`,
 1 AS `perfil`,
 1 AS `permissao`,
 1 AS `descricao`*/;
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
/*!50003 DROP FUNCTION IF EXISTS `fn_alpha_calcular_idade` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_alpha_calcular_idade`(p_data_nascimento DATE) RETURNS int
    DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_alpha_pode_reabrir_ffa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_alpha_pode_reabrir_ffa`(p_id_ffa BIGINT, p_horas_limite INT) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE v_pode TINYINT(1);
    SELECT IF(TIMESTAMPDIFF(HOUR, atualizado_em, NOW()) <= p_horas_limite, 1, 0) INTO v_pode
    FROM ffa 
    WHERE id = p_id_ffa AND status = 'FINALIZADO';
    RETURN IFNULL(v_pode, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_calcula_idade` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_calcula_idade`(p_data_nascimento DATE) RETURNS int
    DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_dias_para_vencimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_dias_para_vencimento`(p_data_validade DATE) RETURNS int
    DETERMINISTIC
BEGIN
    RETURN DATEDIFF(p_data_validade, CURDATE());
END ;;
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
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_farmaco_estoque_atual`(p_id_farmaco BIGINT, p_id_cidade BIGINT) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_estoque INT;
    SELECT IFNULL(estoque_total,0) INTO v_estoque
    FROM vw_farmaco_estoque_total
    WHERE id_farmaco = p_id_farmaco AND id_cidade = p_id_cidade;
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
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_farmaco_lote_valido`(p_id_lote BIGINT) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE v_validade DATE;
    SELECT data_validade INTO v_validade FROM farmaco_lote WHERE id_lote = p_id_lote;
    IF v_validade < CURDATE() THEN RETURN FALSE; END IF;
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
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_gera_protocolo`(p_id_usuario BIGINT) RETURNS varchar(30) CHARSET utf8mb4 COLLATE utf8mb4_general_ci
    DETERMINISTIC
BEGIN
    DECLARE seq INT;
    INSERT INTO protocolo_sequencia (id) VALUES (NULL);
    SET seq = LAST_INSERT_ID();
    RETURN CONCAT(YEAR(NOW()), 'GPAT/', LPAD(seq, 6, '0'));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_gera_protocolo_alpha` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_gera_protocolo_alpha`(p_unidade INT) RETURNS varchar(50) CHARSET utf8mb4 COLLATE utf8mb4_general_ci
    DETERMINISTIC
BEGIN
    DECLARE v_novo_proto VARCHAR(50);
    DECLARE v_ultimo_id INT;
    
    SELECT IFNULL(MAX(id), 0) + 1 INTO v_ultimo_id FROM atendimento;
    
    SET v_novo_proto = CONCAT(YEAR(NOW()), 'ALPHA', LPAD(v_ultimo_id, 6, '0'));
    RETURN v_novo_proto;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_idade_anos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_idade_anos`(p_data DATE) RETURNS int
    DETERMINISTIC
BEGIN
  IF p_data IS NULL THEN
    RETURN NULL;
  END IF;
  RETURN TIMESTAMPDIFF(YEAR, p_data, CURDATE());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_idade_anos_meses` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_idade_anos_meses`(p_data DATE) RETURNS varchar(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci
    DETERMINISTIC
BEGIN
  DECLARE v_anos INT;
  DECLARE v_meses INT;
  IF p_data IS NULL THEN
    RETURN NULL;
  END IF;
  SET v_anos  = TIMESTAMPDIFF(YEAR, p_data, CURDATE());
  SET v_meses = TIMESTAMPDIFF(MONTH, p_data, CURDATE()) - (v_anos * 12);
  RETURN CONCAT(v_anos, 'a', v_meses, 'm');
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
/*!50003 DROP FUNCTION IF EXISTS `fn_prioridade_score` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_prioridade_score`(p_prioridade ENUM('NORMAL','IDOSO','CRIANCA_COLO','ESPECIAL','EMERGENCIA')) RETURNS int
    DETERMINISTIC
BEGIN
    CASE p_prioridade
        WHEN 'EMERGENCIA' THEN RETURN 5;
        WHEN 'IDOSO' THEN RETURN 4;
        WHEN 'CRIANCA_COLO' THEN RETURN 3;
        WHEN 'ESPECIAL' THEN RETURN 2;
        ELSE RETURN 1;
    END CASE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_proxima_dose` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_proxima_dose`(p_ultima_dose DATETIME, p_frequencia_horas INT) RETURNS datetime
    DETERMINISTIC
BEGIN
    RETURN DATE_ADD(p_ultima_dose, INTERVAL p_frequencia_horas HOUR);
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
  IN p_id_sessao_usuario BIGINT,
  IN p_id_senha BIGINT,
  IN p_layout VARCHAR(50)
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_unidade BIGINT;
  DECLARE v_id_local_operacional BIGINT;
  DECLARE v_id_sistema BIGINT;

  DECLARE v_id_ffa BIGINT;
  DECLARE v_gpat VARCHAR(30);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_abrir_ffa_por_senha', v_id_usuario);
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT su.id_usuario, su.id_sistema, su.id_unidade, su.id_local_operacional
    INTO v_id_usuario, v_id_sistema, v_id_unidade, v_id_local_operacional
  FROM sessao_usuario su
  WHERE su.id_sessao_usuario = p_id_sessao_usuario
    AND su.ativo = 1
  LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA', 'Sessao inexistente ou inativa');
  END IF;

  CALL sp__ffa_criar_por_senha_core(
    p_id_sessao_usuario,
    p_id_senha,
    v_id_usuario,
    v_id_unidade,
    v_id_local_operacional,
    p_layout,
    v_id_ffa,
    v_gpat
  );

  COMMIT;

  SELECT p_id_senha AS id_senha, v_id_ffa AS id_ffa, v_gpat AS gpat;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_admin_drop_all_triggers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_admin_drop_all_triggers`()
BEGIN
  DECLARE v_trigger_name VARCHAR(255);
  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT trigger_name
      FROM information_schema.triggers
     WHERE trigger_schema = DATABASE();

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;

  read_loop: LOOP
    FETCH cur INTO v_trigger_name;
    IF done = 1 THEN
      LEAVE read_loop;
    END IF;

    SET @drop_sql = CONCAT('DROP TRIGGER IF EXISTS `', v_trigger_name, '`');
    PREPARE drop_stmt FROM @drop_sql;
    EXECUTE drop_stmt;
    DEALLOCATE PREPARE drop_stmt;
  END LOOP;

  CLOSE cur;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agendamento_cancelar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_agendamento_cancelar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_agendamento BIGINT,
  IN p_motivo TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_sistema BIGINT;
  DECLARE v_id_unidade BIGINT;
  DECLARE v_old_status VARCHAR(30);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_raise('ERRO_SQL', 'sp_agendamento_cancelar');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_sistema, id_unidade
    INTO v_id_usuario, v_id_sistema, v_id_unidade
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario AND ativa = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  SELECT status INTO v_old_status
    FROM agendamentos
   WHERE id_agendamento = p_id_agendamento
     AND id_sistema = v_id_sistema
     AND id_unidade = v_id_unidade
   FOR UPDATE;

  IF v_old_status IS NULL THEN
    CALL sp_raise('ERRO_INTERNO', 'agendamento_nao_encontrado');
  END IF;

  IF v_old_status IN ('CONCLUIDO','CANCELADO') THEN
    CALL sp_raise('ERRO_SENHA_STATUS_INVALIDO', v_old_status);
  END IF;

  UPDATE agendamentos
     SET status = 'CANCELADO',
         atualizado_em = NOW()
   WHERE id_agendamento = p_id_agendamento;

  INSERT INTO agendamentos_eventos (id_agendamento, tipo, detalhe, de_status, para_status, id_usuario, id_sessao_usuario)
  VALUES (p_id_agendamento, 'CANCELADO', p_motivo, v_old_status, 'CANCELADO', v_id_usuario, p_id_sessao_usuario);

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'agendamentos', p_id_agendamento, 'CANCELAR',
    CONCAT('Cancelado. status ', v_old_status, ' -> CANCELADO'));

  COMMIT;

  SELECT p_id_agendamento AS id_agendamento, 'CANCELADO' AS status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agendamento_checkin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_agendamento_checkin`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_agendamento BIGINT,
  IN p_obs TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_sistema BIGINT;
  DECLARE v_id_unidade BIGINT;
  DECLARE v_old_status VARCHAR(30);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_raise('ERRO_SQL', 'sp_agendamento_checkin');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_sistema, id_unidade
    INTO v_id_usuario, v_id_sistema, v_id_unidade
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario AND ativa = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  SELECT status INTO v_old_status
    FROM agendamentos
   WHERE id_agendamento = p_id_agendamento
     AND id_sistema = v_id_sistema
     AND id_unidade = v_id_unidade
   FOR UPDATE;

  IF v_old_status IS NULL THEN
    CALL sp_raise('ERRO_INTERNO', 'agendamento_nao_encontrado');
  END IF;

  IF v_old_status <> 'MARCADO' THEN
    CALL sp_raise('ERRO_SENHA_STATUS_INVALIDO', v_old_status);
  END IF;

  UPDATE agendamentos
     SET status = 'CHECKIN',
         atualizado_em = NOW()
   WHERE id_agendamento = p_id_agendamento;

  INSERT INTO agendamentos_eventos (id_agendamento, tipo, detalhe, de_status, para_status, id_usuario, id_sessao_usuario)
  VALUES (p_id_agendamento, 'CHECKIN', p_obs, v_old_status, 'CHECKIN', v_id_usuario, p_id_sessao_usuario);

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'agendamentos', p_id_agendamento, 'CHECKIN',
    CONCAT('Check-in. status ', v_old_status, ' -> CHECKIN'));

  COMMIT;

  SELECT p_id_agendamento AS id_agendamento, 'CHECKIN' AS status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agendamento_concluir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_agendamento_concluir`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_agendamento BIGINT,
  IN p_obs TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_sistema BIGINT;
  DECLARE v_id_unidade BIGINT;
  DECLARE v_old_status VARCHAR(30);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_raise('ERRO_SQL', 'sp_agendamento_concluir');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_sistema, id_unidade
    INTO v_id_usuario, v_id_sistema, v_id_unidade
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario AND ativa = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  SELECT status INTO v_old_status
    FROM agendamentos
   WHERE id_agendamento = p_id_agendamento
     AND id_sistema = v_id_sistema
     AND id_unidade = v_id_unidade
   FOR UPDATE;

  IF v_old_status IS NULL THEN
    CALL sp_raise('ERRO_INTERNO', 'agendamento_nao_encontrado');
  END IF;

  IF v_old_status <> 'EM_ATENDIMENTO' THEN
    CALL sp_raise('ERRO_SENHA_STATUS_INVALIDO', v_old_status);
  END IF;

  UPDATE agendamentos
     SET status = 'CONCLUIDO',
         atualizado_em = NOW()
   WHERE id_agendamento = p_id_agendamento;

  INSERT INTO agendamentos_eventos (id_agendamento, tipo, detalhe, de_status, para_status, id_usuario, id_sessao_usuario)
  VALUES (p_id_agendamento, 'CONCLUIDO', p_obs, v_old_status, 'CONCLUIDO', v_id_usuario, p_id_sessao_usuario);

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'agendamentos', p_id_agendamento, 'CONCLUIR',
    CONCAT('Concluído. status ', v_old_status, ' -> CONCLUIDO'));

  COMMIT;

  SELECT p_id_agendamento AS id_agendamento, 'CONCLUIDO' AS status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agendamento_iniciar_atendimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_agendamento_iniciar_atendimento`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_agendamento BIGINT,
  IN p_obs TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_sistema BIGINT;
  DECLARE v_id_unidade BIGINT;
  DECLARE v_old_status VARCHAR(30);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_raise('ERRO_SQL', 'sp_agendamento_iniciar_atendimento');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_sistema, id_unidade
    INTO v_id_usuario, v_id_sistema, v_id_unidade
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario AND ativa = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  SELECT status INTO v_old_status
    FROM agendamentos
   WHERE id_agendamento = p_id_agendamento
     AND id_sistema = v_id_sistema
     AND id_unidade = v_id_unidade
   FOR UPDATE;

  IF v_old_status IS NULL THEN
    CALL sp_raise('ERRO_INTERNO', 'agendamento_nao_encontrado');
  END IF;

  IF v_old_status NOT IN ('MARCADO','CHECKIN') THEN
    CALL sp_raise('ERRO_SENHA_STATUS_INVALIDO', v_old_status);
  END IF;

  UPDATE agendamentos
     SET status = 'EM_ATENDIMENTO',
         atualizado_em = NOW()
   WHERE id_agendamento = p_id_agendamento;

  INSERT INTO agendamentos_eventos (id_agendamento, tipo, detalhe, de_status, para_status, id_usuario, id_sessao_usuario)
  VALUES (p_id_agendamento, 'INICIADO', p_obs, v_old_status, 'EM_ATENDIMENTO', v_id_usuario, p_id_sessao_usuario);

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'agendamentos', p_id_agendamento, 'INICIAR',
    CONCAT('Iniciado. status ', v_old_status, ' -> EM_ATENDIMENTO'));

  COMMIT;

  SELECT p_id_agendamento AS id_agendamento, 'EM_ATENDIMENTO' AS status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agendamento_marcar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_agendamento_marcar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_servico BIGINT,
  IN p_inicio_em DATETIME,
  IN p_fim_em DATETIME,

  IN p_id_profissional BIGINT,
  IN p_id_local_operacional BIGINT,

  IN p_id_paciente BIGINT,
  IN p_id_ffa BIGINT,
  IN p_id_senha BIGINT,

  IN p_origem ENUM('RECEPCAO','TELEFONE','INTERNET','RETORNO','OUTRO'),
  IN p_observacao TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_sistema BIGINT;
  DECLARE v_id_unidade BIGINT;
  DECLARE v_id_local BIGINT;

  DECLARE v_duracao INT;
  DECLARE v_exige_prof TINYINT;

  DECLARE v_fim DATETIME;
  DECLARE v_new_id BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_raise('ERRO_SQL', 'sp_agendamento_marcar');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_sistema, id_unidade, id_local_operacional
    INTO v_id_usuario, v_id_sistema, v_id_unidade, v_id_local
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario AND ativa = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  SELECT duracao_minutos, exige_profissional
    INTO v_duracao, v_exige_prof
    FROM servico_agendamento
   WHERE id_servico = p_id_servico
     AND id_sistema = v_id_sistema
     AND id_unidade = v_id_unidade
     AND ativo = 1
   LIMIT 1;

  IF v_duracao IS NULL THEN
    CALL sp_raise('ERRO_INTERNO', 'servico_invalido');
  END IF;

  IF p_inicio_em IS NULL THEN
    CALL sp_raise('ERRO_INTERNO', 'inicio_em_obrigatorio');
  END IF;

  SET v_fim = COALESCE(p_fim_em, DATE_ADD(p_inicio_em, INTERVAL v_duracao MINUTE));

  IF v_fim <= p_inicio_em THEN
    CALL sp_raise('ERRO_INTERNO', 'fim_invalido');
  END IF;

  IF v_exige_prof = 1 AND (p_id_profissional IS NULL OR p_id_profissional = 0) THEN
    CALL sp_raise('ERRO_INTERNO', 'profissional_obrigatorio');
  END IF;

  -- Observação: aqui NÃO travamos "UBS" nem "PA".
  -- Quem decide o contexto é a sessão (id_sistema/id_unidade) + permissões.
  INSERT INTO agendamentos (
    id_sistema, id_unidade, id_local_operacional,
    id_profissional, id_paciente, id_ffa, id_senha,
    id_servico, inicio_em, fim_em,
    status, origem, observacao,
    criado_por, id_sessao_criacao
  ) VALUES (
    v_id_sistema, v_id_unidade, COALESCE(p_id_local_operacional, v_id_local),
    p_id_profissional, p_id_paciente, p_id_ffa, p_id_senha,
    p_id_servico, p_inicio_em, v_fim,
    'MARCADO', COALESCE(p_origem,'RECEPCAO'), p_observacao,
    v_id_usuario, p_id_sessao_usuario
  );

  SET v_new_id = LAST_INSERT_ID();

  INSERT INTO agendamentos_eventos (id_agendamento, tipo, detalhe, de_status, para_status, id_usuario, id_sessao_usuario)
  VALUES (v_new_id, 'CRIADO', p_observacao, NULL, 'MARCADO', v_id_usuario, p_id_sessao_usuario);

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'agendamentos', v_new_id, 'CRIAR',
    CONCAT('Agendamento criado. servico=', p_id_servico, ' inicio=', DATE_FORMAT(p_inicio_em,'%Y-%m-%d %H:%i')));

  COMMIT;

  SELECT v_new_id AS id_agendamento;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agendamento_nao_compareceu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_agendamento_nao_compareceu`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_agendamento BIGINT,
  IN p_obs TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_sistema BIGINT;
  DECLARE v_id_unidade BIGINT;
  DECLARE v_old_status VARCHAR(30);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_raise('ERRO_SQL', 'sp_agendamento_nao_compareceu');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_sistema, id_unidade
    INTO v_id_usuario, v_id_sistema, v_id_unidade
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario AND ativa = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  SELECT status INTO v_old_status
    FROM agendamentos
   WHERE id_agendamento = p_id_agendamento
     AND id_sistema = v_id_sistema
     AND id_unidade = v_id_unidade
   FOR UPDATE;

  IF v_old_status IS NULL THEN
    CALL sp_raise('ERRO_INTERNO', 'agendamento_nao_encontrado');
  END IF;

  IF v_old_status IN ('CONCLUIDO','CANCELADO','NAO_COMPARECEU') THEN
    CALL sp_raise('ERRO_SENHA_STATUS_INVALIDO', v_old_status);
  END IF;

  UPDATE agendamentos
     SET status = 'NAO_COMPARECEU',
         atualizado_em = NOW()
   WHERE id_agendamento = p_id_agendamento;

  INSERT INTO agendamentos_eventos (id_agendamento, tipo, detalhe, de_status, para_status, id_usuario, id_sessao_usuario)
  VALUES (p_id_agendamento, 'NAO_COMPARECEU', p_obs, v_old_status, 'NAO_COMPARECEU', v_id_usuario, p_id_sessao_usuario);

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'agendamentos', p_id_agendamento, 'NAO_COMPARECEU',
    CONCAT('Não compareceu. status ', v_old_status, ' -> NAO_COMPARECEU'));

  COMMIT;

  SELECT p_id_agendamento AS id_agendamento, 'NAO_COMPARECEU' AS status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agendamento_reagendar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_agendamento_reagendar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_agendamento BIGINT,
  IN p_novo_inicio DATETIME,
  IN p_novo_fim DATETIME,
  IN p_observacao TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_sistema BIGINT;
  DECLARE v_id_unidade BIGINT;

  DECLARE v_old_status VARCHAR(30);
  DECLARE v_old_inicio DATETIME;
  DECLARE v_old_fim DATETIME;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_raise('ERRO_SQL', 'sp_agendamento_reagendar');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_sistema, id_unidade
    INTO v_id_usuario, v_id_sistema, v_id_unidade
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario AND ativa = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  SELECT status, inicio_em, fim_em
    INTO v_old_status, v_old_inicio, v_old_fim
    FROM agendamentos
   WHERE id_agendamento = p_id_agendamento
     AND id_sistema = v_id_sistema
     AND id_unidade = v_id_unidade
   FOR UPDATE;

  IF v_old_status IS NULL THEN
    CALL sp_raise('ERRO_INTERNO', 'agendamento_nao_encontrado');
  END IF;

  IF v_old_status IN ('CANCELADO','CONCLUIDO','NAO_COMPARECEU') THEN
    CALL sp_raise('ERRO_SENHA_STATUS_INVALIDO', v_old_status);
  END IF;

  IF p_novo_inicio IS NULL OR p_novo_fim IS NULL OR p_novo_fim <= p_novo_inicio THEN
    CALL sp_raise('ERRO_INTERNO', 'intervalo_invalido');
  END IF;

  UPDATE agendamentos
     SET inicio_em = p_novo_inicio,
         fim_em = p_novo_fim,
         atualizado_em = NOW()
   WHERE id_agendamento = p_id_agendamento;

  INSERT INTO agendamentos_eventos (id_agendamento, tipo, detalhe, de_status, para_status, id_usuario, id_sessao_usuario)
  VALUES (p_id_agendamento, 'REAGENDADO',
          CONCAT('De ', DATE_FORMAT(v_old_inicio,'%Y-%m-%d %H:%i'), ' para ', DATE_FORMAT(p_novo_inicio,'%Y-%m-%d %H:%i'), '. ', p_observacao),
          v_old_status, v_old_status,
          v_id_usuario, p_id_sessao_usuario);

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'agendamentos', p_id_agendamento, 'REAGENDAR',
    CONCAT('Reagendado. inicio=', DATE_FORMAT(p_novo_inicio,'%Y-%m-%d %H:%i')));

  COMMIT;

  SELECT p_id_agendamento AS id_agendamento, v_old_status AS status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agenda_disponibilidade_criar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_agenda_disponibilidade_criar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_profissional BIGINT,
  IN p_id_local_operacional BIGINT,
  IN p_tipo ENUM('ATENDIMENTO','BLOQUEIO'),
  IN p_inicio_em DATETIME,
  IN p_fim_em DATETIME,
  IN p_recorrente TINYINT,
  IN p_dia_semana TINYINT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_sistema BIGINT;
  DECLARE v_id_unidade BIGINT;
  DECLARE v_id_local BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_raise('ERRO_SQL', 'sp_agenda_disponibilidade_criar');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_sistema, id_unidade, id_local_operacional
    INTO v_id_usuario, v_id_sistema, v_id_unidade, v_id_local
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario AND ativa = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  IF p_inicio_em IS NULL OR p_fim_em IS NULL OR p_fim_em <= p_inicio_em THEN
    CALL sp_raise('ERRO_INTERNO', 'intervalo_invalido');
  END IF;

  INSERT INTO agenda_disponibilidade (
    id_sistema, id_unidade, id_profissional, id_local_operacional,
    tipo, inicio_em, fim_em, recorrente, dia_semana,
    ativo, id_usuario_criador, id_sessao_criador
  ) VALUES (
    v_id_sistema, v_id_unidade, p_id_profissional, p_id_local_operacional,
    p_tipo, p_inicio_em, p_fim_em, COALESCE(p_recorrente,0), p_dia_semana,
    1, v_id_usuario, p_id_sessao_usuario
  );

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'agenda_disponibilidade', LAST_INSERT_ID(), 'CRIAR',
    CONCAT('Disponibilidade ', p_tipo, ' ', DATE_FORMAT(p_inicio_em,'%Y-%m-%d %H:%i'), ' - ', DATE_FORMAT(p_fim_em,'%Y-%m-%d %H:%i')));

  COMMIT;

  SELECT LAST_INSERT_ID() AS id_disponibilidade;
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_auditar_erro_sql` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auditar_erro_sql`(
  IN p_id_sessao_usuario BIGINT,
  IN p_origem VARCHAR(80),
  IN p_contexto TEXT
)
BEGIN
  DECLARE v_errno INT DEFAULT 0;
  DECLARE v_msg TEXT DEFAULT NULL;

  GET DIAGNOSTICS CONDITION 1
    v_errno = MYSQL_ERRNO,
    v_msg   = MESSAGE_TEXT;

  -- NÃO falha se auditoria_evento não existir (mas aqui existe no seu schema)
  INSERT INTO auditoria_evento(
    id_sessao_usuario, id_usuario, id_usuario_espelho,
    entidade, id_entidade, acao, detalhe, tabela, criado_em
  )
  SELECT
    p_id_sessao_usuario,
    s.id_usuario,
    s.id_usuario,
    'SQL',
    NULL,
    CONCAT('ERRO_SQL@', p_origem),
    CONCAT('errno=', v_errno, ' msg=', COALESCE(v_msg,''), ' ctx=', COALESCE(p_contexto,'')),
    'SQL',
    NOW()
  FROM sessao_usuario s
  WHERE s.id_sessao_usuario = p_id_sessao_usuario
  LIMIT 1;
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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auditoria_evento_registrar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_entidade VARCHAR(80),
  IN p_id_entidade BIGINT,
  IN p_acao VARCHAR(80),
  IN p_detalhe TEXT,
  IN p_tabela VARCHAR(50)
)
BEGIN
  DECLARE v_id_usuario BIGINT;

  SELECT id_usuario INTO v_id_usuario
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario
   LIMIT 1;

  INSERT INTO auditoria_evento
    (id_sessao_usuario, entidade, id_entidade, acao, detalhe, criado_em, id_usuario, tabela, id_usuario_espelho)
  VALUES
    (p_id_sessao_usuario, p_entidade, p_id_entidade, p_acao, p_detalhe, NOW(), v_id_usuario, p_tabela, v_id_usuario);
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
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_sistema BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local   BIGINT;

    DECLARE v_status_old VARCHAR(40);
    DECLARE v_id_sistema_senha BIGINT;
    DECLARE v_id_unidade_senha BIGINT;
    DECLARE v_id_local_senha BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_chamar_senha', v_id_usuario);
        CALL sp_raise('ERRO_SQL', 'sp_chamar_senha');
    END;

    START TRANSACTION;

    -- Sessão ativa
    SELECT id_usuario, id_sistema, id_unidade, id_local_operacional
      INTO v_id_usuario, v_id_sistema, v_id_unidade, v_id_local
      FROM sessao_usuario
     WHERE id_sessao_usuario = p_id_sessao_usuario
       AND ativo = 1
     LIMIT 1;

    IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL OR v_id_local IS NULL THEN
        CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
    END IF;

    -- Trava a senha
    SELECT status, id_sistema, id_unidade, id_local_operacional
      INTO v_status_old, v_id_sistema_senha, v_id_unidade_senha, v_id_local_senha
      FROM senhas
     WHERE id = p_id_senha
     FOR UPDATE;

    IF v_status_old IS NULL THEN
        CALL sp_raise('ERRO_SENHA_NAO_ENCONTRADA', NULL);
    END IF;

    IF v_id_sistema_senha <> v_id_sistema OR v_id_unidade_senha <> v_id_unidade THEN
        CALL sp_raise('ERRO_SENHA_FORA_CONTEXTO', NULL);
    END IF;

    IF v_id_local_senha IS NOT NULL AND v_id_local_senha <> v_id_local THEN
        CALL sp_raise('ERRO_SENHA_FORA_LOCAL', NULL);
    END IF;

    -- Anti-má-fé: NAO_COMPARECEU não pode ser chamado "direto" (tem que reentrar no fim via SP de retorno)
    IF v_status_old = 'NAO_COMPARECEU' THEN
        CALL sp_raise('ERRO_USE_RETORNO_NAO_COMPARECEU', NULL);
    END IF;

    IF v_status_old NOT IN ('GERADA','AGUARDANDO') THEN
        CALL sp_raise('ERRO_SENHA_STATUS_INVALIDO', v_status_old);
    END IF;

    UPDATE senhas
       SET status = 'CHAMANDO',
           chamada_em = NOW(),
           id_usuario_chamada = v_id_usuario,
           id_usuario_operador = COALESCE(id_usuario_operador, v_id_usuario),
           id_local_operacional = COALESCE(id_local_operacional, v_id_local)
     WHERE id = p_id_senha;

    INSERT INTO senha_eventos (id_senha, id_sessao_usuario, status_anterior, status_novo, criado_em)
    VALUES (p_id_senha, p_id_sessao_usuario, v_status_old, 'CHAMANDO', NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'senhas', p_id_senha, 'CHAMAR',
        CONCAT('Chamada manual. status ', v_status_old, ' -> CHAMANDO')
    );

    COMMIT;

    SELECT p_id_senha AS id, 'CHAMANDO' AS status;
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_dar_alta_paciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_dar_alta_paciente`(IN p_id_internacao BIGINT, IN p_id_usuario BIGINT)
BEGIN
    UPDATE internacao SET data_saida = NOW(), status = 'ENCERRADA' WHERE id_internacao = p_id_internacao;
    INSERT INTO auditoria_evento (id_usuario, acao, tabela, id_registro) VALUES (p_id_usuario, 'ALTA', 'internacao', p_id_internacao);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_ddl_add_column_if_missing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ddl_add_column_if_missing`(
  IN p_table  VARCHAR(128),
  IN p_column VARCHAR(128),
  IN p_sql    TEXT
)
BEGIN
  DECLARE v_cnt INT DEFAULT 0;

  SELECT COUNT(*)
    INTO v_cnt
    FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_NAME = p_table
     AND COLUMN_NAME = p_column;

  IF v_cnt = 0 THEN
    SET @ddl = p_sql;
    PREPARE stmt FROM @ddl;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_encaminhar_senha` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_encaminhar_senha`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT,
    IN p_id_local_destino BIGINT
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_sistema BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;

    DECLARE v_status_old VARCHAR(40);
    DECLARE v_id_sistema_senha BIGINT;
    DECLARE v_id_unidade_senha BIGINT;

    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_encaminhar_senha', v_id_usuario);
        CALL sp_raise('ERRO_SQL', 'sp_encaminhar_senha');
    END;

    START TRANSACTION;

    SELECT id_usuario, id_sistema, id_unidade, id_local_operacional
      INTO v_id_usuario, v_id_sistema, v_id_unidade, v_id_local
      FROM sessao_usuario
     WHERE id_sessao_usuario = p_id_sessao_usuario
       AND ativo = 1
     LIMIT 1;

    IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL OR v_id_local IS NULL THEN
        CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
    END IF;

    SELECT status, id_sistema, id_unidade
      INTO v_status_old, v_id_sistema_senha, v_id_unidade_senha
      FROM senhas
     WHERE id = p_id_senha
     FOR UPDATE;

    IF v_status_old IS NULL THEN
        CALL sp_raise('ERRO_SENHA_NAO_ENCONTRADA', NULL);
    END IF;

    IF v_id_sistema_senha <> v_id_sistema OR v_id_unidade_senha <> v_id_unidade THEN
        CALL sp_raise('ERRO_SENHA_FORA_CONTEXTO', NULL);
    END IF;

    IF v_status_old IN ('CANCELADO','FINALIZADO') THEN
        CALL sp_raise('ERRO_SENHA_STATUS_INVALIDO', v_status_old);
    END IF;

    -- destino precisa existir e pertencer ao mesmo sistema/unidade
    SELECT COUNT(*) INTO v_existe
      FROM local_operacional
     WHERE id_local_operacional = p_id_local_destino
       AND id_sistema = v_id_sistema
       AND id_unidade = v_id_unidade
       AND ativo = 1;

    IF v_existe = 0 THEN
        CALL sp_raise('ERRO_LOCAL_DESTINO_INVALIDO', NULL);
    END IF;

    UPDATE senhas
       SET id_local_operacional = p_id_local_destino,
           status = 'AGUARDANDO',
           id_usuario_operador = COALESCE(id_usuario_operador, v_id_usuario)
     WHERE id = p_id_senha;

    INSERT INTO senha_eventos (id_senha, id_sessao_usuario, status_anterior, status_novo, criado_em)
    VALUES (p_id_senha, p_id_sessao_usuario, v_status_old, 'AGUARDANDO', NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'senhas', p_id_senha, 'ENCAMINHAR',
        CONCAT('Destino local_operacional=', p_id_local_destino, ' | status ', v_status_old, ' -> AGUARDANDO')
    );

    COMMIT;

    SELECT p_id_senha AS id, 'AGUARDANDO' AS status, p_id_local_destino AS id_local_destino;
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_exame_finalizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_exame_finalizar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa BIGINT,
  IN p_observacao TEXT
)
BEGIN
  DECLARE v_id_fila BIGINT;

  CALL sp_setor_finalizar(p_id_sessao_usuario, p_id_ffa, 'EXAME', p_observacao);

  SELECT id_fila INTO v_id_fila
    FROM fila_operacional
   WHERE id_ffa = p_id_ffa AND tipo='EXAME'
   ORDER BY id_fila DESC
   LIMIT 1;

  UPDATE procedimento_protocolo
     SET status='FINALIZADO', atualizado_em=NOW()
   WHERE id_fila = v_id_fila AND tipo='EXAME';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_exame_iniciar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_exame_iniciar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa BIGINT,
  OUT p_codigo VARCHAR(50)
)
BEGIN
  CALL sp_setor_iniciar(p_id_sessao_usuario, p_id_ffa, 'EXAME');
  CALL sp_protocolo_criar_por_ffa(p_id_sessao_usuario, p_id_ffa, 'EXAME', p_codigo);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_farmacia_liberar_medicacao_item` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmacia_liberar_medicacao_item`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_item           BIGINT,
  IN p_id_lote           BIGINT,
  IN p_quantidade        DECIMAL(10,2),
  IN p_observacao        TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_local_operacional BIGINT;
  DECLARE v_id_local_estoque BIGINT;

  DECLARE v_id_ordem BIGINT;
  DECLARE v_id_ffa BIGINT;
  DECLARE v_id_farmaco BIGINT;

  DECLARE v_id_farmaco_lote BIGINT;
  DECLARE v_id_estoque BIGINT;
  DECLARE v_saldo INT;

  DECLARE v_pendentes INT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditoria_evento_registrar(
      p_id_sessao_usuario,'ORDEM_ITEM',p_id_item,'ERRO_LIBERAR_MEDICACAO',
      'Falha SQL ao dispensar item; tabela=dispensacao_medicacao'
    );
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT su.id_usuario, su.id_local_operacional
    INTO v_id_usuario, v_id_local_operacional
    FROM sessao_usuario su
   WHERE su.id_sessao_usuario=p_id_sessao_usuario AND su.ativo=1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente/inativa');
  END IF;

  SELECT lo.id_local_estoque
    INTO v_id_local_estoque
    FROM local_operacional lo
   WHERE lo.id_local_operacional = v_id_local_operacional
   LIMIT 1;

  IF v_id_local_estoque IS NULL THEN
    CALL sp_raise('LOCAL_SEM_ESTOQUE','Local operacional não possui id_local_estoque configurado');
  END IF;

  IF (SELECT tipo FROM local_operacional WHERE id_local_operacional=v_id_local_operacional) <> 'FARMACIA' THEN
    CALL sp_raise('LOCAL_NAO_FARMACIA','Esta sessão não é de FARMÁCIA');
  END IF;

  IF NOT EXISTS (
    SELECT 1
      FROM usuario_sistema us
      JOIN perfil pf ON pf.id_perfil = us.id_perfil
     WHERE us.id_usuario = v_id_usuario
       AND us.ativo=1
       AND (pf.nome COLLATE utf8mb4_general_ci LIKE 'FARMACIA%' OR pf.nome COLLATE utf8mb4_general_ci = 'FARMACEUTICO')
  ) THEN
    CALL sp_raise('SEM_PERFIL_FARMACIA','Usuário sem perfil de farmácia/farmacêutico');
  END IF;

  IF p_quantidade IS NULL OR p_quantidade <= 0 THEN
    CALL sp_raise('QUANTIDADE_INVALIDA','Quantidade deve ser > 0');
  END IF;

  SELECT i.id_ordem, o.id_ffa, i.id_farmaco
    INTO v_id_ordem, v_id_ffa, v_id_farmaco
    FROM ordem_assistencial_item i
    JOIN ordem_assistencial o ON o.id = i.id_ordem
   WHERE i.id_item = p_id_item
     AND i.status = 'ATIVO'
     AND o.status COLLATE utf8mb4_general_ci = 'ATIVA'
     AND o.tipo_ordem COLLATE utf8mb4_general_ci = 'MEDICACAO'
   LIMIT 1
   FOR UPDATE;

  IF v_id_ordem IS NULL THEN
    CALL sp_raise('ITEM_INEXISTENTE','Item não encontrado/ativo ou ordem não está ativa');
  END IF;

  SELECT id_farmaco INTO v_id_farmaco_lote
    FROM farmaco_lote
   WHERE id_lote = p_id_lote
   LIMIT 1;

  IF v_id_farmaco_lote IS NULL THEN
    CALL sp_raise('LOTE_INEXISTENTE','Lote não encontrado');
  END IF;

  IF v_id_farmaco_lote <> v_id_farmaco THEN
    CALL sp_raise('LOTE_FARMACO_DIVERGENTE','Lote não pertence ao fármaco do item');
  END IF;

  IF fn_farmaco_lote_valido(p_id_lote) = 0 THEN
    CALL sp_raise('LOTE_VENCIDO','Lote vencido/bloqueado');
  END IF;

  SELECT id_estoque, quantidade_atual
    INTO v_id_estoque, v_saldo
    FROM estoque_local
   WHERE id_farmaco = v_id_farmaco
     AND id_local  = v_id_local_estoque
   LIMIT 1
   FOR UPDATE;

  IF v_id_estoque IS NULL THEN
    CALL sp_raise('SEM_ESTOQUE','Não existe estoque_local para este fármaco/local');
  END IF;

  IF v_saldo < p_quantidade THEN
    CALL sp_raise('SALDO_INSUFICIENTE', CONCAT('Saldo=',v_saldo,' solicitado=',p_quantidade));
  END IF;

  UPDATE estoque_local
     SET quantidade_atual = quantidade_atual - p_quantidade
   WHERE id_estoque = v_id_estoque;

  INSERT INTO dispensacao_medicacao
    (id_ordem, id_item, id_farmaco, id_lote, quantidade, id_usuario_dispensador, data_hora, observacao, status)
  VALUES
    (v_id_ordem, p_id_item, v_id_farmaco, p_id_lote, p_quantidade, v_id_usuario, NOW(), p_observacao, 'ENTREGUE');

  INSERT INTO farmaco_movimentacao
    (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, id_ffa, observacao, realizado_por, data_mov)
  VALUES
    (v_id_farmaco, p_id_lote, v_id_local_estoque, 'SAIDA', p_quantidade, 'PACIENTE', v_id_ffa,
     CONCAT('DISP_MED|item=',p_id_item,'|',LEFT(COALESCE(p_observacao,''),120)), v_id_usuario, NOW());

  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', v_id_ffa, 'MEDICACAO_LIBERADA_ITEM',
          CONCAT('Dispensado item=',p_id_item,' lote=',p_id_lote,' qtd=',p_quantidade),
          v_id_usuario, NULL, 'FARMACIA', NOW());

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,'ORDEM_ASSISTENCIAL_ITEM',p_id_item,'DISPENSAR_MEDICACAO_ITEM',
    CONCAT('ordem=',v_id_ordem,';ffa=',v_id_ffa,';lote=',p_id_lote,';qtd=',p_quantidade,';tabela=dispensacao_medicacao')
  );

  SELECT COUNT(*) INTO v_pendentes
    FROM ordem_assistencial_item i2
    JOIN ordem_assistencial o2 ON o2.id = i2.id_ordem
    LEFT JOIN (
      SELECT id_item, SUM(quantidade) qtd
        FROM dispensacao_medicacao
       WHERE id_item IS NOT NULL
       GROUP BY id_item
    ) d2 ON d2.id_item=i2.id_item
   WHERE o2.id_ffa = v_id_ffa
     AND o2.status COLLATE utf8mb4_general_ci = 'ATIVA'
     AND o2.tipo_ordem COLLATE utf8mb4_general_ci = 'MEDICACAO'
     AND i2.status='ATIVO'
     AND COALESCE(d2.qtd,0) < i2.quantidade_total;

  IF v_pendentes = 0 THEN
    UPDATE ffa_substatus
       SET ativo=0
     WHERE id_ffa = v_id_ffa
       AND categoria='FARMACIA'
       AND ativo=1;

    INSERT INTO ffa_substatus (id_ffa, categoria, status, descricao, criado_em, criado_por, ativo)
    VALUES (v_id_ffa, 'FARMACIA', 'LIBERADA', 'Todos os itens de medicação dispensados', NOW(), v_id_usuario, 1);

    CALL sp_auditoria_evento_registrar(
      p_id_sessao_usuario,'FFA',v_id_ffa,'FARMACIA_LIBERADA',
      'Todos os itens dispensados -> LIBERADA; tabela=ffa_substatus'
    );
  END IF;

  COMMIT;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmacia_saida_estoque`(IN p_id_farmaco BIGINT, IN p_qtd INT)
BEGIN
    UPDATE farmaco_lote SET estoque_atual = estoque_atual - p_qtd 
    WHERE id_farmaco = p_id_farmaco AND estoque_atual >= p_qtd 
    ORDER BY data_validade ASC LIMIT 1;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmaco_saida_paciente`(IN p_id_ffa BIGINT, IN p_id_farmaco BIGINT, IN p_id_usuario BIGINT)
BEGIN
    INSERT INTO ffa_medicacao_administrada (id_ffa, id_farmaco, id_usuario, data_administracao)
    VALUES (p_id_ffa, p_id_farmaco, p_id_usuario, NOW());
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
    IN p_id_conta BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    -- 1. Verifica se a conta existe e está aberta
    IF NOT EXISTS (SELECT 1 FROM faturamento_conta WHERE id_conta = p_id_conta AND status = 'ABERTA') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conta não encontrada ou já encerrada.';
    END IF;

    -- 2. Verifica pendências de itens (Não pode fechar se houver medicação não faturada)
    IF EXISTS (SELECT 1 FROM faturamento_item WHERE id_conta = p_id_conta AND status = 'ABERTO') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existem itens pendentes de consolidação.';
    END IF;

    -- 3. Fecha a conta e registra quem fechou (Auditoria)
    UPDATE faturamento_conta 
    SET status = 'FECHADA', 
        fechado_por = p_id_usuario, 
        fechado_em = NOW(),
        valor_total = (SELECT SUM(valor_total) FROM faturamento_item WHERE id_conta = p_id_conta)
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
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_faturamento_obter_conta`(
    IN p_tipo_conta ENUM('FFA','INTERNACAO'), 
    IN p_id_ffa BIGINT, 
    IN p_id_internacao BIGINT, 
    IN p_id_usuario BIGINT, 
    OUT p_id_conta BIGINT
)
BEGIN
    SELECT id_conta INTO p_id_conta FROM faturamento_conta
    WHERE status = 'ABERTA' 
    AND ((p_tipo_conta = 'FFA' AND id_ffa = p_id_ffa) OR (p_tipo_conta = 'INTERNACAO' AND id_internacao = p_id_internacao))
    LIMIT 1;

    IF p_id_conta IS NULL THEN
        INSERT INTO faturamento_conta (tipo_conta, id_ffa, id_internacao, status, valor_total, aberta_em)
        VALUES (p_tipo_conta, p_id_ffa, p_id_internacao, 'ABERTA', 0, NOW());
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
    IN p_id_usuario BIGINT
)
BEGIN
    -- 1. Muda status do FFA
    UPDATE ffa SET status = 'AGUARDANDO_FECHAMENTO', atualizado_em = NOW() WHERE id = p_id_ffa;

    -- 2. Lógica de Faturamento (Corrigindo nomes de tabelas do dump)
    -- Inserindo procedimentos realizados
    INSERT INTO conta_paciente_itens (id_atendimento, descricao, valor, data_lancamento)
    SELECT f.id_atendimento, fp.descricao, fp.valor, NOW()
    FROM ffa_procedimento fp
    JOIN ffa f ON fp.id_ffa = f.id
    WHERE f.id = p_id_ffa;

    -- 3. Auditoria Imutável
    INSERT INTO evento_ffa (id_ffa, evento, id_usuario, criado_em)
    VALUES (p_id_ffa, 'FECHAMENTO_FFA', p_id_usuario, NOW());
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_complementar_alertas_permissao`(IN p_id_ffa BIGINT)
BEGIN
    -- Ajustado para ler da ffa_procedimento que é a real do dump
    SELECT id, descricao FROM ffa_procedimento WHERE id_ffa = p_id_ffa;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fila_operacional_nao_compareceu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fila_operacional_nao_compareceu`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_fila BIGINT
)
BEGIN
  DECLARE v_substatus VARCHAR(20);
  DECLARE v_id_local BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_fila_operacional_nao_compareceu', CONCAT('id_fila=', p_id_fila));
    RESIGNAL;
  END;

  IF p_id_sessao_usuario IS NULL OR p_id_sessao_usuario = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_sessao_usuario');
  END IF;
  IF p_id_fila IS NULL OR p_id_fila = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_fila');
  END IF;

  START TRANSACTION;

  SELECT s.id_local_operacional
    INTO v_id_local
    FROM sessao_usuario s
   WHERE s.id_sessao_usuario = p_id_sessao_usuario
   LIMIT 1;

  SELECT substatus
    INTO v_substatus
    FROM fila_operacional
   WHERE id_fila = p_id_fila
   FOR UPDATE;

  IF v_substatus IS NULL THEN
    CALL sp_raise('ERRO_FILA_NAO_ENCONTRADA', CAST(p_id_fila AS CHAR));
  END IF;

  IF v_substatus NOT IN ('AGUARDANDO','CRITICO') THEN
    CALL sp_raise('ERRO_STATUS_INVALIDO', CONCAT('esperado=AGUARDANDO/CRITICO atual=', v_substatus));
  END IF;

  UPDATE fila_operacional
     SET nao_compareceu_em = NOW(),
         retorno_permitido_ate = DATE_ADD(NOW(), INTERVAL 60 MINUTE),
         retorno_utilizado = 0,
         retorno_em = NULL
   WHERE id_fila = p_id_fila;

  INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
  VALUES (p_id_fila, p_id_sessao_usuario, 'NAO_COMPARECEU', 'Janela=60min', NOW());

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,
    'FILA_OPERACIONAL',
    p_id_fila,
    'NAO_COMPARECEU',
    CONCAT('substatus=', v_substatus, '; janela=60min; local=', COALESCE(v_id_local,'NULL'))
  );

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fila_operacional_retorno_nao_compareceu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fila_operacional_retorno_nao_compareceu`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_fila BIGINT
)
BEGIN
  DECLARE v_limite DATETIME;
  DECLARE v_utilizado TINYINT;
  DECLARE v_id_local BIGINT;
  DECLARE v_move_fim TINYINT DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_fila_operacional_retorno_nao_compareceu', CONCAT('id_fila=', p_id_fila));
    RESIGNAL;
  END;

  IF p_id_sessao_usuario IS NULL OR p_id_sessao_usuario = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_sessao_usuario');
  END IF;
  IF p_id_fila IS NULL OR p_id_fila = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_fila');
  END IF;

  START TRANSACTION;

  SELECT s.id_local_operacional
    INTO v_id_local
    FROM sessao_usuario s
   WHERE s.id_sessao_usuario = p_id_sessao_usuario
   LIMIT 1;

  SELECT retorno_permitido_ate, retorno_utilizado
    INTO v_limite, v_utilizado
    FROM fila_operacional
   WHERE id_fila = p_id_fila
   FOR UPDATE;

  IF v_utilizado = 1 THEN
    CALL sp_raise('ERRO_RETORNO_JA_UTILIZADO', CAST(p_id_fila AS CHAR));
  END IF;

  IF v_limite IS NULL OR NOW() > v_limite THEN
    SET v_move_fim = 1;
  END IF;

  UPDATE fila_operacional
     SET retorno_utilizado = 1,
         retorno_em = NOW(),
         data_entrada = CASE WHEN v_move_fim = 1 THEN NOW() ELSE data_entrada END
   WHERE id_fila = p_id_fila;

  INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
  VALUES (p_id_fila, p_id_sessao_usuario, 'RETORNO_NAO_COMPARECEU', CONCAT('move_fim=', v_move_fim), NOW());

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,
    'FILA_OPERACIONAL',
    p_id_fila,
    'RETORNO_NAO_COMPARECEU',
    CONCAT('move_fim=', v_move_fim, '; limite=', COALESCE(DATE_FORMAT(v_limite,'%Y-%m-%d %H:%i:%s'),'NULL'),
           '; local=', COALESCE(v_id_local,'NULL'))
  );

  COMMIT;
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
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa BIGINT,
  IN p_id_risco INT,
  IN p_queixa TEXT,
  IN p_sinais_vitais JSON,
  IN p_observacao TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_local   BIGINT;

  DECLARE v_cor ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL');
  DECLARE v_tempo_max INT;

  DECLARE v_id_fila_triagem BIGINT;
  DECLARE v_id_fila_medico BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_finalizar_triagem', v_id_usuario);
    CALL sp_raise('ERRO_SQL', 'sp_finalizar_triagem');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_local_operacional
    INTO v_id_usuario, v_id_local
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario
     AND ativo = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_local IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  -- risco -> cor + tempo_max
  SELECT cor, tempo_max
    INTO v_cor, v_tempo_max
    FROM classificacao_risco
   WHERE id_risco = p_id_risco
   LIMIT 1;

  IF v_cor IS NULL THEN
    CALL sp_raise('ERRO_RISCO_INVALIDO', NULL);
  END IF;

  -- atualiza FFA (cor real + tempo limite)
  UPDATE ffa
     SET classificacao_cor        = v_cor,
         classificacao_manchester = v_cor,
         tempo_limite             = IF(v_tempo_max IS NULL, NULL, DATE_ADD(NOW(), INTERVAL v_tempo_max MINUTE)),
         status                   = 'AGUARDANDO_CHAMADA_MEDICO',
         atualizado_em            = NOW()
   WHERE id = p_id_ffa;

  -- registra trilha de triagem
  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES (
    'FFA',
    p_id_ffa,
    'TRIAGEM_FINALIZADA',
    JSON_OBJECT('id_risco', p_id_risco, 'cor', v_cor, 'queixa', p_queixa, 'sinais', p_sinais_vitais, 'obs', p_observacao),
    v_id_usuario, NULL, 'TRIAGEM', NOW()
  );

  INSERT INTO auditoria_evento (id_sessao_usuario, entidade, id_entidade, acao, detalhe, id_usuario, tabela, id_usuario_espelho)
  VALUES (
    p_id_sessao_usuario,
    'FFA',
    p_id_ffa,
    'FINALIZAR_TRIAGEM',
    JSON_OBJECT('id_risco', p_id_risco, 'cor', v_cor, 'tempo_max', v_tempo_max),
    v_id_usuario,
    'ffa',
    v_id_usuario
  );

  -- finaliza fila TRIAGEM do paciente (se existir)
  SELECT id_fila
    INTO v_id_fila_triagem
    FROM fila_operacional
   WHERE id_ffa = p_id_ffa
     AND tipo = 'TRIAGEM'
     AND substatus IN ('EM_EXECUCAO','EM_OBSERVACAO','CRITICO','AGUARDANDO')
   ORDER BY data_entrada DESC
   LIMIT 1
   FOR UPDATE;

  IF v_id_fila_triagem IS NOT NULL THEN
    UPDATE fila_operacional
       SET substatus = 'FINALIZADO',
           data_fim  = NOW(),
           observacao = COALESCE(p_observacao, observacao)
     WHERE id_fila = v_id_fila_triagem;
  END IF;

  -- cria fila MEDICO aguardando
  INSERT INTO fila_operacional (id_ffa, tipo, prioridade, substatus, id_local, data_entrada)
  VALUES (p_id_ffa, 'MEDICO', v_cor, 'AGUARDANDO', NULL, NOW());

  SET v_id_fila_medico = LAST_INSERT_ID();

  INSERT INTO auditoria_evento (id_sessao_usuario, entidade, id_entidade, acao, detalhe, id_usuario, tabela, id_usuario_espelho)
  VALUES (
    p_id_sessao_usuario,
    'FILA_OPERACIONAL',
    v_id_fila_medico,
    'CRIAR_FILA_MEDICO',
    JSON_OBJECT('id_ffa', p_id_ffa, 'prioridade', v_cor),
    v_id_usuario,
    'fila_operacional',
    v_id_usuario
  );

  COMMIT;

  SELECT v_id_fila_medico AS id_fila_medico;
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
    IN p_id_sessao_usuario BIGINT,
    IN p_origem ENUM('TOTEM','RECEPCAO','ADMIN','SAMU'),
    IN p_tipo_atendimento ENUM('CLINICO','PEDIATRICO','PRIORITARIO','EMERGENCIA','VISITA','EXAME'),
    IN p_prioridade TINYINT
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_sistema BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local   BIGINT;

    DECLARE v_prefixo VARCHAR(5);
    DECLARE v_lane ENUM('ADULTO','PEDIATRICO','PRIORITARIO');
    DECLARE v_ultimo INT;
    DECLARE v_numero INT;
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_id_senha BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_gerar_senha', v_id_usuario);
        CALL sp_raise('ERRO_SQL', 'sp_gerar_senha');
    END;

    START TRANSACTION;

    -- Sessão ativa (fonte da verdade)
    SELECT id_usuario, id_sistema, id_unidade, id_local_operacional
      INTO v_id_usuario, v_id_sistema, v_id_unidade, v_id_local
      FROM sessao_usuario
     WHERE id_sessao_usuario = p_id_sessao_usuario
       AND ativo = 1
     LIMIT 1;

    IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL THEN
        CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
    END IF;

    -- Prefixo e lane canônicos (sem COUNT)
    SET v_prefixo =
        CASE
            WHEN p_tipo_atendimento = 'EXAME' THEN 'E'
            WHEN p_tipo_atendimento IN ('PRIORITARIO','EMERGENCIA') OR COALESCE(p_prioridade,0) > 0 THEN 'P'
            WHEN p_tipo_atendimento = 'PEDIATRICO' THEN 'I'
            ELSE 'A'
        END;

    SET v_lane =
        CASE
            WHEN p_tipo_atendimento = 'PEDIATRICO' THEN 'PEDIATRICO'
            WHEN p_tipo_atendimento IN ('PRIORITARIO','EMERGENCIA') OR COALESCE(p_prioridade,0) > 0 THEN 'PRIORITARIO'
            ELSE 'ADULTO'
        END;

    -- Garante linha da sequência do dia/prefixo
    INSERT INTO senha_sequencia (id_sistema, id_unidade, data_ref, prefixo, ultimo_numero)
    VALUES (v_id_sistema, v_id_unidade, CURDATE(), v_prefixo, 0)
    ON DUPLICATE KEY UPDATE ultimo_numero = ultimo_numero;

    -- Trava a sequência
    SELECT ultimo_numero
      INTO v_ultimo
      FROM senha_sequencia
     WHERE id_sistema = v_id_sistema
       AND id_unidade = v_id_unidade
       AND data_ref = CURDATE()
       AND prefixo = v_prefixo
     FOR UPDATE;

    SET v_numero = v_ultimo + 1;

    UPDATE senha_sequencia
       SET ultimo_numero = v_numero
     WHERE id_sistema = v_id_sistema
       AND id_unidade = v_id_unidade
       AND data_ref = CURDATE()
       AND prefixo = v_prefixo;

    SET v_codigo = CONCAT(v_prefixo, LPAD(v_numero, 3, '0'));

    -- Insere a senha (entidade primária)
    INSERT INTO senhas (
        id_sistema, id_unidade,
        numero, prefixo, codigo, data_ref,
        tipo_atendimento, lane, origem,
        status, prioridade,
        id_local_operacional,
        id_usuario_operador,
        posicionado_em
    ) VALUES (
        v_id_sistema, v_id_unidade,
        v_numero, v_prefixo, v_codigo, CURDATE(),
        p_tipo_atendimento, v_lane, p_origem,
        'GERADA', COALESCE(p_prioridade, 0),
        v_id_local,
        v_id_usuario,
        NOW()
    );

    SET v_id_senha = LAST_INSERT_ID();

    -- Evento de geração
    INSERT INTO senha_eventos (id_senha, id_sessao_usuario, status_anterior, status_novo, criado_em)
    VALUES (v_id_senha, p_id_sessao_usuario, 'NOVA', 'GERADA', NOW());

    -- Auditoria por sessão
    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'senhas', v_id_senha, 'GERAR',
        CONCAT('Senha gerada: ', v_codigo,
               ' (tipo=', p_tipo_atendimento,
               ', lane=', v_lane,
               ', origem=', p_origem,
               ', prioridade=', COALESCE(p_prioridade,0),
               ')')
    );

    COMMIT;

    SELECT v_id_senha AS id, v_codigo AS codigo, 'GERADA' AS status;
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
    IN p_id_ffa BIGINT,
    IN p_id_unidade INT,
    OUT p_protocolo_final VARCHAR(100)
)
BEGIN
    DECLARE v_seq INT;
    DECLARE v_prefixo VARCHAR(20);
    
    -- Pega o total de pedidos do dia para gerar o sequencial
    SELECT COUNT(*) + 1 INTO v_seq 
    FROM lab_pedido_alpha 
    WHERE DATE(criado_em) = CURDATE() AND id_unidade = p_id_unidade;
    
    -- Monta o protocolo: LAB-IDUNIDADE-DATA-SEQUENCIAL
    SET p_protocolo_final = CONCAT('LAB-', p_id_unidade, '-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(v_seq, 4, '0'));
    
    -- Insere o pedido
    INSERT INTO lab_pedido_alpha (id_ffa, protocolo_interno, id_unidade, status)
    VALUES (p_id_ffa, p_protocolo_final, p_id_unidade, 'CRIADO');
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_historico_fila_ffa`(IN p_id_ffa BIGINT)
BEGIN
    -- Em vez de view inexistente, fazemos o JOIN real que respeita sua herança
    SELECT h.*, u.login 
    FROM evento_ffa h 
    JOIN usuario u ON h.id_usuario = u.id_usuario 
    WHERE h.id_ffa = p_id_ffa ORDER BY h.criado_em DESC;
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_iniciar_gasoterapia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_gasoterapia`(
    IN p_id_ffa BIGINT,
    IN p_tipo_gas VARCHAR(50),
    IN p_litros_minuto DECIMAL(10,2),
    IN p_id_usuario BIGINT
)
BEGIN
    INSERT INTO ffa_gasoterapia (id_ffa, tipo_gas, litros_minuto, id_usuario_inicio, data_inicio, status)
    VALUES (p_id_ffa, p_tipo_gas, p_litros_minuto, p_id_usuario, NOW(), 'EM_USO');
    
    INSERT INTO evento_ffa (id_ffa, evento, id_usuario, criado_em)
    VALUES (p_id_ffa, CONCAT('INICIO_GASO_', p_tipo_gas), p_id_usuario, NOW());
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
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa BIGINT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_local   BIGINT;

  DECLARE v_id_fila BIGINT;
  DECLARE v_substatus_old VARCHAR(20);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_inicio_triagem', v_id_usuario);
    CALL sp_raise('ERRO_SQL', 'sp_inicio_triagem');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_local_operacional
    INTO v_id_usuario, v_id_local
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario
     AND ativo = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_local IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  -- tenta pegar uma fila TRIAGEM existente
  SELECT id_fila, substatus
    INTO v_id_fila, v_substatus_old
    FROM fila_operacional
   WHERE id_ffa = p_id_ffa
     AND tipo = 'TRIAGEM'
     AND substatus IN ('AGUARDANDO','CRITICO','EM_OBSERVACAO')
   ORDER BY data_entrada DESC
   LIMIT 1
   FOR UPDATE;

  IF v_id_fila IS NULL THEN
    INSERT INTO fila_operacional (id_ffa, tipo, prioridade, substatus, id_local, data_entrada)
    VALUES (p_id_ffa, 'TRIAGEM', 'AZUL', 'AGUARDANDO', v_id_local, NOW());

    SET v_id_fila = LAST_INSERT_ID();
    SET v_substatus_old = 'AGUARDANDO';
  END IF;

  UPDATE fila_operacional
     SET substatus      = 'EM_EXECUCAO',
         data_inicio    = COALESCE(data_inicio, NOW()),
         id_responsavel = v_id_usuario,
         id_local       = COALESCE(id_local, v_id_local)
   WHERE id_fila = v_id_fila;

  UPDATE ffa SET status='EM_TRIAGEM', atualizado_em=NOW() WHERE id = p_id_ffa;

  INSERT INTO auditoria_evento (id_sessao_usuario, entidade, id_entidade, acao, detalhe, id_usuario, tabela, id_usuario_espelho)
  VALUES (
    p_id_sessao_usuario,
    'FILA_OPERACIONAL',
    v_id_fila,
    'INICIAR_TRIAGEM',
    JSON_OBJECT('id_ffa', p_id_ffa, 'substatus_old', v_substatus_old),
    v_id_usuario,
    'fila_operacional',
    v_id_usuario
  );

  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', p_id_ffa, 'TRIAGEM_INICIADA', 'Triagem iniciada', v_id_usuario, NULL, 'TRIAGEM', NOW());

  COMMIT;

  SELECT v_id_fila AS id_fila_triagem;
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_lab_receber_resultado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_lab_receber_resultado`(
    IN p_protocolo_interno VARCHAR(30),
    IN p_resultado_link TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    -- Localiza o pedido pelo seu código de barras
    UPDATE lab_pedido 
    SET status = 'FINALIZADO', atualizado_em = NOW() 
    WHERE protocolo_interno = p_protocolo_interno;

    -- Avisa o FFA que o resultado chegou para o médico ver no painel
    INSERT INTO evento_ffa (id_ffa, evento, id_usuario, criado_em)
    SELECT id_ffa, 'RESULTADO_LAB_DISPONIVEL', p_id_usuario, NOW()
    FROM lab_pedido WHERE protocolo_interno = p_protocolo_interno;
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
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_liberar_medicacao_farmacia`(
    IN p_id_ordem BIGINT, IN p_id_usuario BIGINT, IN p_lote VARCHAR(50), 
    IN p_validade DATE, IN p_observacao TEXT
)
BEGIN
    DECLARE v_id_ffa BIGINT;
    SELECT id_ffa INTO v_id_ffa FROM ordem_assistencial WHERE id = p_id_ordem AND status = 'ATIVA';
    
    IF v_id_ffa IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ordem inválida ou não ativa';
    END IF;

    INSERT INTO dispensacao_medicacao (id_ordem, id_ffa, lote, validade, liberado_por, liberado_em, observacao)
    VALUES (p_id_ordem, v_id_ffa, p_lote, p_validade, p_id_usuario, NOW(), p_observacao);
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
  IN p_id_sessao_usuario BIGINT,
  IN p_tipo VARCHAR(40)
)
BEGIN
  DECLARE v_id_local BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_listar_fila_operacional', CONCAT('tipo=', p_tipo));
    RESIGNAL;
  END;

  IF p_id_sessao_usuario IS NULL OR p_id_sessao_usuario = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_sessao_usuario');
  END IF;

  SELECT s.id_local_operacional
    INTO v_id_local
    FROM sessao_usuario s
   WHERE s.id_sessao_usuario = p_id_sessao_usuario
   LIMIT 1;

  -- Fila ATIVA: exclui NAO_COMPARECEU pendente (retorno_utilizado=0)
  SELECT *
    FROM vw_fila_operacional_atual
   WHERE tipo = p_tipo
     AND substatus IN ('AGUARDANDO','CRITICO','EM_EXECUCAO','EM_OBSERVACAO')
     AND id_local_operacional = v_id_local
     AND (nao_compareceu_em IS NULL OR retorno_utilizado = 1)
   ORDER BY prioridade_rank_efetiva DESC, data_entrada ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medicacao_iniciar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_iniciar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa            BIGINT
)
BEGIN
  DECLARE v_pendentes INT DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditoria_evento_registrar(
      p_id_sessao_usuario,'FFA',p_id_ffa,'ERRO_MEDICACAO_INICIAR',
      'Falha SQL ao iniciar medicação; tabela=fila_operacional'
    );
    RESIGNAL;
  END;

  START TRANSACTION;

  IF (SELECT COUNT(*) FROM ordem_assistencial o
       WHERE o.id_ffa=p_id_ffa
         AND o.tipo_ordem COLLATE utf8mb4_general_ci='MEDICACAO'
         AND o.status COLLATE utf8mb4_general_ci='ATIVA') > 0 THEN

    SELECT COUNT(*) INTO v_pendentes
      FROM ordem_assistencial_item i
      JOIN ordem_assistencial o ON o.id=i.id_ordem
      LEFT JOIN (SELECT id_item, SUM(quantidade) qtd FROM dispensacao_medicacao WHERE id_item IS NOT NULL GROUP BY id_item) d
        ON d.id_item=i.id_item
     WHERE o.id_ffa=p_id_ffa
       AND o.tipo_ordem COLLATE utf8mb4_general_ci='MEDICACAO'
       AND o.status COLLATE utf8mb4_general_ci='ATIVA'
       AND i.status='ATIVO'
       AND COALESCE(d.qtd,0) < i.quantidade_total;

    IF v_pendentes > 0 THEN
      CALL sp_raise('MEDICACAO_PENDENTE_FARMACIA','Ainda existem itens pendentes de dispensação na farmácia');
    END IF;
  END IF;

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medicacao_ordem_encerrar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_ordem_encerrar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ordem          BIGINT,
  IN p_motivo            TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_ffa BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditoria_evento_registrar(
      p_id_sessao_usuario,'ORDEM_ASSISTENCIAL',p_id_ordem,'ERRO_ENCERRAR_ORDEM',
      'Falha SQL ao encerrar ordem; tabela=ordem_assistencial'
    );
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT su.id_usuario INTO v_id_usuario
    FROM sessao_usuario su
   WHERE su.id_sessao_usuario=p_id_sessao_usuario AND su.ativo=1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente/inativa');
  END IF;

  SELECT id_ffa INTO v_id_ffa
    FROM ordem_assistencial
   WHERE id=p_id_ordem
   LIMIT 1
   FOR UPDATE;

  IF v_id_ffa IS NULL THEN
    CALL sp_raise('ORDEM_INEXISTENTE','Ordem não encontrada');
  END IF;

  UPDATE ordem_assistencial
     SET status='ENCERRADA',
         motivo_encerramento=p_motivo,
         encerrado_em=NOW(),
         atualizado_por=v_id_usuario,
         atualizado_em=NOW()
   WHERE id=p_id_ordem;

  UPDATE ordem_assistencial_item
     SET status='ENCERRADO',
         atualizado_por=v_id_usuario,
         atualizado_em=NOW()
   WHERE id_ordem=p_id_ordem;

  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', v_id_ffa, 'ORDEM_MEDICACAO_ENCERRADA',
          CONCAT('Ordem medicação encerrada (ordem=',p_id_ordem,'): ', LEFT(COALESCE(p_motivo,''),200)),
          v_id_usuario, NULL, 'MEDICACAO', NOW());

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,'ORDEM_ASSISTENCIAL',p_id_ordem,'ENCERRAR_ORDEM_MEDICACAO',
    CONCAT('motivo=',LEFT(COALESCE(p_motivo,''),500),';tabela=ordem_assistencial')
  );

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medicacao_ordem_suspender` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_ordem_suspender`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ordem          BIGINT,
  IN p_motivo            TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_ffa BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditoria_evento_registrar(
      p_id_sessao_usuario,'ORDEM_ASSISTENCIAL',p_id_ordem,'ERRO_SUSPENDER_ORDEM',
      'Falha SQL ao suspender ordem; tabela=ordem_assistencial'
    );
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT su.id_usuario INTO v_id_usuario
    FROM sessao_usuario su
   WHERE su.id_sessao_usuario=p_id_sessao_usuario AND su.ativo=1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente/inativa');
  END IF;

  SELECT id_ffa INTO v_id_ffa
    FROM ordem_assistencial
   WHERE id=p_id_ordem
   LIMIT 1
   FOR UPDATE;

  IF v_id_ffa IS NULL THEN
    CALL sp_raise('ORDEM_INEXISTENTE','Ordem não encontrada');
  END IF;

  UPDATE ordem_assistencial
     SET status='SUSPENSA',
         motivo_suspensao=p_motivo,
         atualizado_por=v_id_usuario,
         atualizado_em=NOW()
   WHERE id=p_id_ordem;

  UPDATE ordem_assistencial_item
     SET status='SUSPENSO',
         atualizado_por=v_id_usuario,
         atualizado_em=NOW()
   WHERE id_ordem=p_id_ordem;

  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', v_id_ffa, 'ORDEM_MEDICACAO_SUSPENSA',
          CONCAT('Ordem medicação suspensa (ordem=',p_id_ordem,'): ', LEFT(COALESCE(p_motivo,''),200)),
          v_id_usuario, NULL, 'MEDICACAO', NOW());

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,'ORDEM_ASSISTENCIAL',p_id_ordem,'SUSPENDER_ORDEM_MEDICACAO',
    CONCAT('motivo=',LEFT(COALESCE(p_motivo,''),500),';tabela=ordem_assistencial')
  );

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medicacao_registrar_administracao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_registrar_administracao`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_item           BIGINT,
  IN p_quantidade        DECIMAL(10,2),
  IN p_observacao        TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_ffa BIGINT;
  DECLARE v_id_ordem BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditoria_evento_registrar(
      p_id_sessao_usuario,'ORDEM_ITEM',p_id_item,'ERRO_ADMINISTRAR',
      'Falha SQL ao registrar administração; tabela=administracao_medicacao_ordem'
    );
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT su.id_usuario INTO v_id_usuario
    FROM sessao_usuario su
   WHERE su.id_sessao_usuario=p_id_sessao_usuario AND su.ativo=1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente/inativa');
  END IF;

  IF p_quantidade IS NULL OR p_quantidade <= 0 THEN
    CALL sp_raise('QUANTIDADE_INVALIDA','Quantidade deve ser > 0');
  END IF;

  SELECT o.id, o.id_ffa
    INTO v_id_ordem, v_id_ffa
    FROM ordem_assistencial_item i
    JOIN ordem_assistencial o ON o.id=i.id_ordem
   WHERE i.id_item=p_id_item
   LIMIT 1;

  IF v_id_ffa IS NULL THEN
    CALL sp_raise('ITEM_INEXISTENTE','Item não encontrado');
  END IF;

  INSERT INTO administracao_medicacao_ordem (id_item, quantidade, realizado_em, id_usuario, observacao, status)
  VALUES (p_id_item, p_quantidade, NOW(), v_id_usuario, p_observacao, 'ADMINISTRADO');

  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', v_id_ffa, 'MEDICACAO_ADMINISTRADA',
          CONCAT('Administração registrada item=',p_id_item,' qtd=',p_quantidade,' (ordem=',v_id_ordem,')'),
          v_id_usuario, NULL, 'MEDICACAO', NOW());

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,'ORDEM_ASSISTENCIAL_ITEM',p_id_item,'ADMINISTRAR_MEDICACAO_ITEM',
    CONCAT('item=',p_id_item,';qtd=',p_quantidade,';ordem=',v_id_ordem,';tabela=administracao_medicacao_ordem')
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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medico_chamar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa BIGINT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_fila BIGINT;
  DECLARE v_status VARCHAR(50);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario,'FFA',p_id_ffa,'ERRO_MEDICO_CHAMAR',
      'Falha SQL em sp_medico_chamar','ffa');
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT id_usuario INTO v_id_usuario
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario AND ativo=1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente ou inativa');
  END IF;

  SELECT status INTO v_status FROM ffa WHERE id = p_id_ffa FOR UPDATE;
  IF v_status IS NULL THEN
    CALL sp_raise('FFA_NAO_ENCONTRADA','FFA inexistente');
  END IF;

  SELECT id_fila INTO v_id_fila
    FROM fila_operacional
   WHERE id_ffa = p_id_ffa AND tipo='MEDICO' AND substatus='AGUARDANDO'
   ORDER BY id_fila DESC
   LIMIT 1
   FOR UPDATE;

  IF v_id_fila IS NULL THEN
    CALL sp_raise('FILA_MEDICO_INEXISTENTE','Sem registro AGUARDANDO em fila_operacional');
  END IF;

  UPDATE ffa
     SET status='CHAMANDO_MEDICO',
         id_usuario_alteracao=v_id_usuario,
         atualizado_em=NOW()
   WHERE id = p_id_ffa;

  INSERT INTO fila_operacional_evento (id_fila, id_sessao_usuario, tipo_evento, detalhe)
  VALUES (v_id_fila, p_id_sessao_usuario, 'CHAMADA', CONCAT('CHAMADA_MEDICO|ffa=',p_id_ffa));

  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', p_id_ffa, 'CHAMADA_MEDICO', 'Chamada do médico', v_id_usuario, NULL, 'MEDICO', NOW());

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario,'FFA',p_id_ffa,'MEDICO_CHAMAR',
    CONCAT('id_fila=',v_id_fila), 'ffa');

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medico_definir_desfecho` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medico_definir_desfecho`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa BIGINT,
  IN p_desfecho ENUM('ALTA','TRANSFERENCIA','INTERNACAO'),
  IN p_observacao TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario,'FFA',p_id_ffa,'ERRO_DESFECHO',
      'Falha SQL em sp_medico_definir_desfecho','ffa');
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT id_usuario INTO v_id_usuario
    FROM sessao_usuario
   WHERE id_sessao_usuario=p_id_sessao_usuario AND ativo=1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente ou inativa');
  END IF;

  -- atualiza FFA
  UPDATE ffa
     SET status=p_desfecho,
         id_usuario_alteracao=v_id_usuario,
         atualizado_em=NOW()
   WHERE id=p_id_ffa;

  IF ROW_COUNT() = 0 THEN
    CALL sp_raise('FFA_NAO_ENCONTRADA','FFA inexistente');
  END IF;

  -- fecha filas operacionais ainda abertas (idempotente)
  UPDATE fila_operacional
     SET substatus='FINALIZADO',
         data_fim=COALESCE(data_fim, NOW())
   WHERE id_ffa=p_id_ffa
     AND substatus <> 'FINALIZADO';

  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', p_id_ffa, CONCAT('DESFECHO_',p_desfecho), CONCAT('Desfecho: ',p_desfecho), v_id_usuario, NULL, 'MEDICO', NOW());

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario,'FFA',p_id_ffa,'MEDICO_DESFECHO',
    CONCAT('desfecho=',p_desfecho,'; obs=',COALESCE(p_observacao,'')), 'ffa');

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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medico_encaminhar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa BIGINT,
  IN p_destino ENUM('MEDICACAO','RX','EXAME','ECG','PROCEDIMENTO','OBSERVACAO'),
  IN p_observacao TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_fila_medico BIGINT;
  DECLARE v_prio ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL');
  DECLARE v_status_dest VARCHAR(50);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario,'FFA',p_id_ffa,'ERRO_MEDICO_ENCAMINHAR',
      'Falha SQL em sp_medico_encaminhar','fila_operacional');
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT id_usuario INTO v_id_usuario
    FROM sessao_usuario
   WHERE id_sessao_usuario=p_id_sessao_usuario AND ativo=1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente ou inativa');
  END IF;

  SELECT classificacao_cor INTO v_prio
    FROM ffa
   WHERE id=p_id_ffa
   FOR UPDATE;

  IF v_prio IS NULL THEN
    SET v_prio = 'AZUL';
  END IF;

  SELECT id_fila INTO v_id_fila_medico
    FROM fila_operacional
   WHERE id_ffa=p_id_ffa AND tipo='MEDICO' AND substatus IN ('AGUARDANDO','EM_EXECUCAO','EM_OBSERVACAO','CRITICO')
   ORDER BY id_fila DESC
   LIMIT 1
   FOR UPDATE;

  IF v_id_fila_medico IS NULL THEN
    CALL sp_raise('FILA_MEDICO_INEXISTENTE','Não existe fila MEDICO ativa para esta FFA');
  END IF;

  -- finaliza fila do médico
  UPDATE fila_operacional
     SET substatus='FINALIZADO',
         data_fim=NOW()
   WHERE id_fila=v_id_fila_medico;

  INSERT INTO fila_operacional_evento (id_fila, id_sessao_usuario, tipo_evento, detalhe)
  VALUES (v_id_fila_medico, p_id_sessao_usuario, 'FINALIZAR', CONCAT('ENCAMINHADO_PARA=',p_destino,'|',COALESCE(p_observacao,'')));

  -- cria fila destino (local NULL: setor "captura" ao iniciar)
  INSERT INTO fila_operacional (id_ffa, tipo, substatus, prioridade, data_entrada, id_responsavel, id_local_operacional)
  VALUES (p_id_ffa, p_destino, 'AGUARDANDO', v_prio, NOW(), NULL, NULL);

  -- status destino da FFA (sem criar automação; só refletir destino)
  SET v_status_dest =
    CASE p_destino
      WHEN 'MEDICACAO' THEN 'AGUARDANDO_MEDICACAO'
      WHEN 'RX'        THEN 'AGUARDANDO_RX'
      WHEN 'EXAME'     THEN 'AGUARDANDO_COLETA'
      WHEN 'ECG'       THEN 'AGUARDANDO_ECG'
      WHEN 'OBSERVACAO'THEN 'OBSERVACAO'
      ELSE 'ABERTO'
    END;

  UPDATE ffa
     SET status=v_status_dest,
         id_usuario_alteracao=v_id_usuario,
         atualizado_em=NOW()
   WHERE id=p_id_ffa;

  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', p_id_ffa, CONCAT('ENCAMINHAR_',p_destino), CONCAT('Encaminhado para ',p_destino), v_id_usuario, NULL, 'MEDICO', NOW());

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario,'FFA',p_id_ffa,'MEDICO_ENCAMINHAR',
    CONCAT('destino=',p_destino,'; obs=',COALESCE(p_observacao,'')), 'fila_operacional');

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medico_iniciar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medico_iniciar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa BIGINT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_fila BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario,'FFA',p_id_ffa,'ERRO_MEDICO_INICIAR',
      'Falha SQL em sp_medico_iniciar','ffa');
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT id_usuario INTO v_id_usuario
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario AND ativo=1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente ou inativa');
  END IF;

  SELECT id_fila INTO v_id_fila
    FROM fila_operacional
   WHERE id_ffa = p_id_ffa AND tipo='MEDICO' AND substatus='AGUARDANDO'
   ORDER BY id_fila DESC
   LIMIT 1
   FOR UPDATE;

  IF v_id_fila IS NULL THEN
    CALL sp_raise('FILA_MEDICO_INEXISTENTE','Sem registro AGUARDANDO em fila_operacional');
  END IF;

  UPDATE fila_operacional
     SET substatus='EM_EXECUCAO',
         data_inicio=COALESCE(data_inicio, NOW()),
         id_responsavel=v_id_usuario,
         id_local_operacional = COALESCE(id_local_operacional, (SELECT id_local_operacional FROM sessao_usuario WHERE id_sessao_usuario=p_id_sessao_usuario LIMIT 1))
   WHERE id_fila = v_id_fila;

  UPDATE ffa
     SET status='EM_ATENDIMENTO_MEDICO',
         id_usuario_alteracao=v_id_usuario,
         atualizado_em=NOW()
   WHERE id = p_id_ffa;

  INSERT INTO fila_operacional_evento (id_fila, id_sessao_usuario, tipo_evento, detalhe)
  VALUES (v_id_fila, p_id_sessao_usuario, 'INICIO', CONCAT('INICIO_MEDICO|ffa=',p_id_ffa));

  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', p_id_ffa, 'INICIO_MEDICO', 'Início do atendimento médico', v_id_usuario, NULL, 'MEDICO', NOW());

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario,'FFA',p_id_ffa,'MEDICO_INICIAR',
    CONCAT('id_fila=',v_id_fila), 'ffa');

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medico_listar_fila` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medico_listar_fila`(
  IN p_id_sessao_usuario BIGINT,
  IN p_limite INT
)
BEGIN
  DECLARE v_tipo_local VARCHAR(30);
  DECLARE v_id_local BIGINT;

  IF p_limite IS NULL OR p_limite <= 0 THEN
    SET p_limite = 50;
  END IF;

  SELECT lo.tipo, su.id_local_operacional
    INTO v_tipo_local, v_id_local
    FROM sessao_usuario su
    JOIN local_operacional lo ON lo.id_local_operacional = su.id_local_operacional
   WHERE su.id_sessao_usuario = p_id_sessao_usuario
     AND su.ativo = 1
   LIMIT 1;

  IF v_id_local IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA', 'Sessão inexistente ou inativa');
  END IF;

  -- Preferir vw_fila_operacional_atual (Manchester efetivo) se existir
  IF EXISTS (
    SELECT 1
      FROM information_schema.views
     WHERE table_schema = DATABASE()
       AND table_name = 'vw_fila_operacional_atual'
  ) THEN
    SET @sql := CONCAT(
      "SELECT a.id_fila, a.id_ffa, a.substatus, a.prioridade_real, a.prioridade_efetiva, a.elevada_por_tempo, ",
      "a.data_entrada, a.data_inicio, a.id_responsavel, m.gpat, m.status_ffa, m.classificacao_cor, m.tempo_limite, ",
      "m.senha_codigo, m.tipo_atendimento, m.paciente_nome ",
      "FROM vw_fila_operacional_atual a ",
      "JOIN vw_medico_fila m ON m.id_fila = a.id_fila ",
      "WHERE a.tipo = 'MEDICO' AND a.substatus = 'AGUARDANDO' ",
      "AND (a.id_local_operacional IS NULL OR a.id_local_operacional = ", v_id_local, ") ",
      "AND (", 
        "('", v_tipo_local, "' = 'MEDICO_PEDIATRICO' AND m.tipo_atendimento = 'PEDIATRICO') ",
        "OR ('", v_tipo_local, "' = 'MEDICO_CLINICO' AND m.tipo_atendimento <> 'PEDIATRICO') ",
        "OR ('", v_tipo_local, "' NOT IN ('MEDICO_CLINICO','MEDICO_PEDIATRICO'))",
      ") ",
      "ORDER BY a.prioridade_rank_efetiva DESC, a.data_entrada ASC ",
      "LIMIT ", p_limite
    );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  ELSE
    -- fallback simples: prioridade real e data_entrada
    SELECT
      m.id_fila, m.id_ffa, m.substatus,
      m.classificacao_cor AS prioridade_real,
      m.data_entrada, m.data_inicio, m.id_responsavel,
      m.gpat, m.status_ffa, m.tempo_limite,
      m.senha_codigo, m.tipo_atendimento, m.paciente_nome
    FROM vw_medico_fila m
    WHERE m.substatus = 'AGUARDANDO'
      AND (m.id_fila IS NOT NULL)
    ORDER BY FIELD(m.classificacao_cor,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'), m.data_entrada ASC
    LIMIT p_limite;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_medico_salvar_evolucao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medico_salvar_evolucao`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa BIGINT,
  IN p_texto LONGTEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario,'FFA',p_id_ffa,'ERRO_EVOLUCAO',
      'Falha SQL em sp_medico_salvar_evolucao','ffa_evolucao');
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT id_usuario INTO v_id_usuario
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario AND ativo=1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente ou inativa');
  END IF;

  IF p_texto IS NULL OR LENGTH(TRIM(p_texto)) = 0 THEN
    CALL sp_raise('EVOLUCAO_VAZIA','Texto da evolução é obrigatório');
  END IF;

  -- garante que a FFA existe
  IF NOT EXISTS (SELECT 1 FROM ffa WHERE id=p_id_ffa) THEN
    CALL sp_raise('FFA_NAO_ENCONTRADA','FFA inexistente');
  END IF;

  INSERT INTO ffa_evolucao (id_ffa, id_sessao_usuario, id_usuario, texto)
  VALUES (p_id_ffa, p_id_sessao_usuario, v_id_usuario, p_texto);

  UPDATE ffa
     SET id_usuario_alteracao=v_id_usuario,
         atualizado_em=NOW()
   WHERE id=p_id_ffa;

  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', p_id_ffa, 'EVOLUCAO', 'Evolução registrada', v_id_usuario, NULL, 'MEDICO', NOW());

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario,'FFA',p_id_ffa,'MEDICO_EVOLUCAO',
    CONCAT('len=',LENGTH(p_texto)), 'ffa_evolucao');

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_motorista_iniciar_remocao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_motorista_iniciar_remocao`(
    IN p_id_remocao BIGINT,
    IN p_id_motorista BIGINT,
    IN p_veiculo VARCHAR(50)
)
BEGIN
    -- Atualiza a remoção com os dados do motorista e o tempo real
    UPDATE remocao_logistica 
    SET id_motorista = p_id_motorista,
        veiculo_identificacao = p_veiculo,
        status = 'EM_TRANSITO',
        data_saida = NOW()
    WHERE id_remocao = p_id_remocao;
    
    -- Muda o status da internação/leito para 'EM_REMOCAO' para o Censo saber onde o paciente está
    UPDATE internacao i
    JOIN remocao_logistica r ON i.id_internacao = r.id_internacao
    SET i.status = 'TRANSFERIDA' -- Ou um status novo que você queira criar
    WHERE r.id_remocao = p_id_remocao;

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
/*!50003 DROP PROCEDURE IF EXISTS `sp_padroniza_datas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_padroniza_datas`()
BEGIN
    IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_NAME='atendimento' AND COLUMN_NAME='data_hora' AND TABLE_SCHEMA=DATABASE()) THEN
        ALTER TABLE `atendimento` CHANGE `data_hora` `criado_em` DATETIME DEFAULT CURRENT_TIMESTAMP;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_painel_consumir_mensagem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_consumir_mensagem`(
  IN p_id_painel       BIGINT,
  IN p_id_mensagem     BIGINT,
  IN p_id_sessao_usuario BIGINT
)
BEGIN
  DECLARE v_id_usuario BIGINT;

  IF p_id_sessao_usuario IS NOT NULL AND p_id_sessao_usuario > 0 THEN
    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;
  END IF;

  INSERT IGNORE INTO painel_mensagem_consumo (id_mensagem, id_painel, consumido_em)
  VALUES (p_id_mensagem, p_id_painel, NOW());

  IF v_id_usuario IS NOT NULL THEN
    CALL sp_auditoria_evento_registrar(
      p_id_sessao_usuario,
      'PAINEL_MENSAGEM', p_id_mensagem,
      'CONSUMIR_MENSAGEM',
      CONCAT('painel_id=',p_id_painel,';mensagem=',p_id_mensagem),
      'painel_mensagem_consumo'
    );
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_painel_consumir_tts_evento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_consumir_tts_evento`(
  IN p_painel_codigo VARCHAR(50),
  IN p_origem        VARCHAR(50),
  IN p_id_evento     BIGINT,
  IN p_id_sessao_usuario BIGINT
)
BEGIN
  DECLARE v_id_usuario BIGINT;

  -- sessão é opcional (painel pode ser "anonimo"), mas se vier validamos para auditoria
  IF p_id_sessao_usuario IS NOT NULL AND p_id_sessao_usuario > 0 THEN
    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;
  END IF;

  INSERT IGNORE INTO painel_consumo_evento (origem, id_evento, painel_tipo, id_local_operacional, consumido_em)
  VALUES (p_origem, p_id_evento, p_painel_codigo, NULL, NOW());

  IF v_id_usuario IS NOT NULL THEN
    CALL sp_auditoria_evento_registrar(
      p_id_sessao_usuario,
      'PAINEL_TTS', p_id_evento,
      'CONSUMIR_TTS',
      CONCAT('painel=',p_painel_codigo,';origem=',p_origem,';id_evento=',p_id_evento),
      'painel_consumo_evento'
    );
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_painel_enviar_mensagem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_enviar_mensagem`(
  IN  p_id_sessao_usuario BIGINT,
  IN  p_codigo_painel     VARCHAR(50),
  IN  p_titulo            VARCHAR(120),
  IN  p_texto             TEXT,
  IN  p_nivel             ENUM('INFO','ALERTA','URGENTE')
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_painel BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario,'PAINEL_MENSAGEM',NULL,'ERRO_ENVIAR_MENSAGEM',
      'Falha SQL ao enviar mensagem','painel_mensagem');
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT su.id_usuario INTO v_id_usuario
    FROM sessao_usuario su
   WHERE su.id_sessao_usuario = p_id_sessao_usuario
     AND su.ativo = 1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente/inativa');
  END IF;

  SELECT p.id_painel INTO v_id_painel
    FROM painel p
   WHERE p.codigo = p_codigo_painel
     AND p.ativo = 1
   LIMIT 1;

  IF v_id_painel IS NULL THEN
    CALL sp_raise('PAINEL_INVALIDO', CONCAT('painel.codigo=', COALESCE(p_codigo_painel,'NULL')));
  END IF;

  INSERT INTO painel_mensagem (id_painel, titulo, texto, nivel, criado_por, criado_em, ativo)
  VALUES (v_id_painel, p_titulo, p_texto, COALESCE(p_nivel,'INFO'), v_id_usuario, NOW(), 1);

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,
    'PAINEL_MENSAGEM', LAST_INSERT_ID(),
    'ENVIAR_MENSAGEM',
    CONCAT('painel=',p_codigo_painel,';titulo=',COALESCE(p_titulo,'')),
    'painel_mensagem'
  );

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_painel_mensagem_consumir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_mensagem_consumir`(
  IN p_codigo_painel VARCHAR(50),
  IN p_id_mensagem   BIGINT,
  IN p_consumido_por VARCHAR(80)
)
BEGIN
  DECLARE v_id_painel BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT p.id_painel INTO v_id_painel
    FROM painel p
   WHERE p.codigo COLLATE utf8mb4_general_ci = p_codigo_painel COLLATE utf8mb4_general_ci
     AND p.ativo = 1
   LIMIT 1;

  IF v_id_painel IS NULL THEN
    CALL sp_raise('PAINEL_INVALIDO','Painel não encontrado/inativo');
  END IF;

  INSERT IGNORE INTO painel_mensagem_consumo (id_mensagem, id_painel, consumido_por)
  VALUES (p_id_mensagem, v_id_painel, p_consumido_por);

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_painel_mensagem_enviar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_mensagem_enviar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_codigo_painel     VARCHAR(50),
  IN p_tipo              VARCHAR(30),   -- 'ALERTA'|'CHAMAR_MEDICO'|'INFO'|'URGENTE'
  IN p_titulo            VARCHAR(120),
  IN p_texto             TEXT,
  IN p_prioridade        INT,
  IN p_expira_min        INT            -- NULL/0 = não expira
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_painel  BIGINT;
  DECLARE v_expira     DATETIME;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario,'PAINEL',NULL,'ERRO_ENVIAR_MENSAGEM',
      CONCAT('painel=',p_codigo_painel,';tipo=',p_tipo),'painel_mensagem');
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT su.id_usuario INTO v_id_usuario
    FROM sessao_usuario su
   WHERE su.id_sessao_usuario = p_id_sessao_usuario
     AND su.ativo = 1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente/inativa');
  END IF;

  SELECT p.id_painel INTO v_id_painel
    FROM painel p
   WHERE p.codigo COLLATE utf8mb4_general_ci = p_codigo_painel COLLATE utf8mb4_general_ci
     AND p.ativo = 1
   LIMIT 1;

  IF v_id_painel IS NULL THEN
    CALL sp_raise('PAINEL_INVALIDO','Painel não encontrado/inativo');
  END IF;

  IF p_expira_min IS NULL OR p_expira_min <= 0 THEN
    SET v_expira = NULL;
  ELSE
    SET v_expira = DATE_ADD(NOW(), INTERVAL p_expira_min MINUTE);
  END IF;

  INSERT INTO painel_mensagem (id_painel, tipo, titulo, texto, prioridade, expira_em, criado_por, id_sessao_usuario)
  VALUES (v_id_painel,
          CAST(p_tipo AS CHAR CHARACTER SET utf8mb4) COLLATE utf8mb4_general_ci,
          p_titulo,
          p_texto,
          COALESCE(p_prioridade,0),
          v_expira,
          v_id_usuario,
          p_id_sessao_usuario);

  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario,'PAINEL_MENSAGEM',LAST_INSERT_ID(),'ENVIAR_MENSAGEM',
    CONCAT('painel=',p_codigo_painel,';tipo=',p_tipo,';prioridade=',COALESCE(p_prioridade,0)),'painel_mensagem');

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_painel_tts_consumir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_tts_consumir`(
  IN p_id_sessao_usuario    BIGINT,
  IN p_origem               VARCHAR(30),  -- 'SENHA_EVENTOS' ou 'FILA_OPERACIONAL_EVENTO'
  IN p_id_evento            BIGINT,
  IN p_painel_tipo          VARCHAR(30),  -- 'RECEPCAO' ou tipo da fila (TRIAGEM/MEDICO/RX/MEDICACAO/...)
  IN p_id_local_operacional BIGINT
)
BEGIN
  DECLARE v_id_usuario BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditoria_evento_registrar(
      p_id_sessao_usuario,'PAINEL_CONSUMO_EVENTO',p_id_evento,'ERRO_CONSUMIR_TTS',
      CONCAT('origem=',COALESCE(p_origem,''),';painel=',COALESCE(p_painel_tipo,''),';local=',COALESCE(p_id_local_operacional,0))
    );
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT su.id_usuario INTO v_id_usuario
    FROM sessao_usuario su
   WHERE su.id_sessao_usuario=p_id_sessao_usuario AND su.ativo=1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente/inativa');
  END IF;

  INSERT IGNORE INTO painel_consumo_evento
    (origem, id_evento, painel_tipo, id_local_operacional, consumido_em, consumido_por)
  VALUES
    (p_origem, p_id_evento, p_painel_tipo, p_id_local_operacional, NOW(), v_id_usuario);

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,'PAINEL_CONSUMO_EVENTO',p_id_evento,'CONSUMIR_TTS',
    CONCAT('origem=',COALESCE(p_origem,''),';painel=',COALESCE(p_painel_tipo,''),';local=',COALESCE(p_id_local_operacional,0),';tabela=painel_consumo_evento')
  );

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_painel_tts_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_tts_listar`(
  IN p_id_sessao_usuario   BIGINT,
  IN p_painel_tipo         VARCHAR(30),   -- ex: 'RECEPCAO','TRIAGEM','MEDICO','RX','MEDICACAO'
  IN p_id_local_operacional BIGINT,
  IN p_limite              INT
)
BEGIN
  DECLARE v_ok INT DEFAULT 0;

  IF p_limite IS NULL OR p_limite <= 0 THEN
    SET p_limite = 10;
  END IF;

  SELECT 1 INTO v_ok
    FROM sessao_usuario su
   WHERE su.id_sessao_usuario=p_id_sessao_usuario AND su.ativo=1
   LIMIT 1;

  IF v_ok = 0 THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente/inativa');
  END IF;

  -- RECEPCAO: usa origem SENHA_EVENTOS
  IF p_painel_tipo COLLATE utf8mb4_general_ci = 'RECEPCAO' THEN
    SELECT origem, id_evento, id_local_operacional, local_nome, senha_codigo, id_fila, tipo_fila, criado_em, texto_tts
      FROM vw_painel_tts_pendentes
     WHERE origem='SENHA_EVENTOS'
       AND (p_id_local_operacional IS NULL OR id_local_operacional = p_id_local_operacional)
     ORDER BY criado_em ASC
     LIMIT p_limite;
  ELSE
    -- Setores: usa origem FILA_OPERACIONAL_EVENTO e filtra tipo_fila
    SELECT origem, id_evento, id_local_operacional, local_nome, senha_codigo, id_fila, tipo_fila, criado_em, texto_tts
      FROM vw_painel_tts_pendentes
     WHERE origem='FILA_OPERACIONAL_EVENTO'
       AND tipo_fila COLLATE utf8mb4_general_ci = p_painel_tipo COLLATE utf8mb4_general_ci
       AND (p_id_local_operacional IS NULL OR id_local_operacional = p_id_local_operacional)
     ORDER BY criado_em ASC
     LIMIT p_limite;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_protocolo_criar_por_ffa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_protocolo_criar_por_ffa`(
  IN  p_id_sessao_usuario BIGINT,
  IN  p_id_ffa BIGINT,
  IN  p_tipo ENUM('EXAME','RX'),
  OUT p_codigo VARCHAR(50)
)
proc_main: BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_fila BIGINT;
  DECLARE v_id_unidade BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_raise('PROTOCOLO_CRIAR_ERRO','Falha SQL ao criar protocolo');
  END;

  START TRANSACTION;

  SELECT su.id_usuario, su.id_unidade
    INTO v_id_usuario, v_id_unidade
    FROM sessao_usuario su
   WHERE su.id_sessao_usuario = p_id_sessao_usuario
     AND su.ativo = 1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente/inativa');
  END IF;

  -- encontra a fila do tipo (AGUARDANDO/EM_EXECUCAO)
  SELECT fo.id_fila INTO v_id_fila
    FROM fila_operacional fo
   WHERE fo.id_ffa = p_id_ffa
     AND fo.tipo = p_tipo
     AND fo.substatus IN ('AGUARDANDO','EM_EXECUCAO')
   ORDER BY fo.id_fila DESC
   LIMIT 1
   FOR UPDATE;

  IF v_id_fila IS NULL THEN
    CALL sp_raise('FILA_INEXISTENTE','Não existe fila do tipo para gerar protocolo');
  END IF;

  -- idempotência: se já existe protocolo para esta fila+tipo, retorna
  SELECT codigo INTO p_codigo
    FROM procedimento_protocolo
   WHERE id_fila = v_id_fila
     AND tipo = p_tipo
     AND status IN ('CRIADO','EM_EXECUCAO','FINALIZADO')
   LIMIT 1;

  IF p_codigo IS NOT NULL THEN
    COMMIT;
    LEAVE proc_main;
  END IF;

  -- gerar novo (sp_protocolo_gerar já deve existir pelo Stage7 original)
  CALL sp_protocolo_gerar(p_id_sessao_usuario, p_tipo, v_id_unidade, p_codigo);

  INSERT INTO procedimento_protocolo
    (tipo, codigo, barcode, status, id_ffa, id_fila, id_sessao_criacao, id_usuario_criacao, criado_em)
  VALUES
    (p_tipo, p_codigo, p_codigo, 'CRIADO', p_id_ffa, v_id_fila, p_id_sessao_usuario, v_id_usuario, NOW());

  -- evento assistencial
  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', p_id_ffa, CONCAT('PROTOCOLO_',p_tipo), CONCAT('Protocolo gerado: ', p_codigo), v_id_usuario, NULL, p_tipo, NOW());

  -- auditoria
  INSERT INTO auditoria_evento (id_sessao_usuario, entidade, id_entidade, acao, detalhe, criado_em, id_usuario, tabela)
  VALUES (p_id_sessao_usuario, 'PROCEDIMENTO_PROTOCOLO', LAST_INSERT_ID(), CONCAT('CRIAR_PROTOCOLO_',p_tipo),
          CONCAT('ffa=',p_id_ffa,';fila=',v_id_fila,';codigo=',p_codigo), NOW(), v_id_usuario, 'procedimento_protocolo');

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_protocolo_gerar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_protocolo_gerar`(
  IN  p_id_sessao_usuario BIGINT,
  IN  p_tipo ENUM('EXAME','RX'),
  IN  p_id_unidade BIGINT,
  OUT p_codigo VARCHAR(50)
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_unidade BIGINT;
  DECLARE v_data CHAR(8);
  DECLARE v_prefixo VARCHAR(5);
  DECLARE v_chave VARCHAR(80);
  DECLARE v_seq INT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_raise('PROTOCOLO_ERRO_SQL','Falha ao gerar protocolo');
  END;

  START TRANSACTION;

  SELECT su.id_usuario, su.id_unidade
    INTO v_id_usuario, v_id_unidade
    FROM sessao_usuario su
   WHERE su.id_sessao_usuario = p_id_sessao_usuario
     AND su.ativo = 1
   LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente/inativa');
  END IF;

  IF p_id_unidade IS NOT NULL THEN
    SET v_id_unidade = p_id_unidade;
  END IF;

  IF v_id_unidade IS NULL THEN
    SET v_id_unidade = 0;
  END IF;

  SET v_data = DATE_FORMAT(CURDATE(), '%Y%m%d');
  SET v_prefixo = CASE p_tipo WHEN 'EXAME' THEN 'LAB' ELSE 'RX' END;

  SET v_chave = CONCAT(v_prefixo,'|',v_data,'|U',v_id_unidade);

  -- lock da chave
  SELECT ultimo_numero INTO v_seq
    FROM protocolo_sequencia
   WHERE chave = v_chave
   FOR UPDATE;

  IF v_seq IS NULL THEN
    INSERT INTO protocolo_sequencia (chave, ultimo_numero) VALUES (v_chave, 1);
    SET v_seq = 1;
  ELSE
    SET v_seq = v_seq + 1;
    UPDATE protocolo_sequencia SET ultimo_numero = v_seq WHERE chave = v_chave;
  END IF;

  SET p_codigo = CONCAT(v_prefixo,'-',v_data,'-U',v_id_unidade,'-',LPAD(v_seq,4,'0'));

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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_raise`(IN p_codigo VARCHAR(50), IN p_detalhe TEXT)
BEGIN
  DECLARE v_msg TEXT;
  SET v_msg = CONCAT(p_codigo, ':', COALESCE(p_detalhe, ''));
  SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = v_msg;
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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_recepcao_iniciar_complementacao`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_senha BIGINT
)
BEGIN
  -- alias canônico (front pode chamar tanto um quanto outro)
  CALL sp_senha_iniciar_complementacao(p_id_sessao_usuario, p_id_senha);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_recepcao_salvar_complementacao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_recepcao_salvar_complementacao`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_senha BIGINT,

  IN p_nome_completo VARCHAR(255),
  IN p_nome_social  VARCHAR(255),
  IN p_cpf          VARCHAR(14),
  IN p_cns          VARCHAR(20),
  IN p_rg           VARCHAR(20),
  IN p_rg_uf        CHAR(2),
  IN p_data_nascimento DATE,
  IN p_sexo         ENUM('M','F','O'),
  IN p_nome_mae     VARCHAR(255),
  IN p_telefone     VARCHAR(30),
  IN p_email        VARCHAR(150),

  IN p_tipo_atendimento ENUM('CLINICO','PEDIATRICO','EMERGENCIA','SAMU','EXTERNO'),
  IN p_observacao TEXT,
  IN p_layout VARCHAR(50)
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_sistema BIGINT;
  DECLARE v_id_unidade BIGINT;
  DECLARE v_id_local_operacional BIGINT;
  DECLARE v_tipo_local VARCHAR(50);

  DECLARE v_status VARCHAR(50);
  DECLARE v_id_pessoa BIGINT;
  DECLARE v_id_paciente BIGINT;
  DECLARE v_id_ffa BIGINT;
  DECLARE v_gpat VARCHAR(30);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_recepcao_salvar_complementacao', v_id_usuario);
    RESIGNAL;
  END;

  START TRANSACTION;

  -- sessão/contexto
  SELECT su.id_usuario, su.id_sistema, su.id_unidade, su.id_local_operacional
    INTO v_id_usuario, v_id_sistema, v_id_unidade, v_id_local_operacional
  FROM sessao_usuario su
  WHERE su.id_sessao_usuario = p_id_sessao_usuario
    AND su.ativo = 1
  LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA', 'Sessao inexistente ou inativa');
  END IF;

  SELECT lo.tipo INTO v_tipo_local
  FROM local_operacional lo
  WHERE lo.id_local_operacional = v_id_local_operacional
  LIMIT 1;

  IF v_tipo_local <> 'RECEPCAO' THEN
    CALL sp_raise('LOCAL_INVALIDO', 'Esta acao so pode ser executada na RECEPCAO');
  END IF;

  -- trava a senha
  SELECT s.status INTO v_status
  FROM senhas s
  WHERE s.id = p_id_senha
  FOR UPDATE;

  IF v_status IS NULL THEN
    CALL sp_raise('SENHA_NAO_ENCONTRADA', CONCAT('id=', p_id_senha));
  END IF;

  IF v_status <> 'EM_COMPLEMENTACAO' THEN
    CALL sp_raise('STATUS_INVALIDO', CONCAT('Esperado=EM_COMPLEMENTACAO, atual=', v_status));
  END IF;

  IF p_nome_completo IS NULL OR LENGTH(TRIM(p_nome_completo)) < 3 THEN
    CALL sp_raise('NOME_INVALIDO', 'nome_completo obrigatorio');
  END IF;

  -- 1) encontra/cria pessoa (cpf/cns são chaves únicas quando informados)
  SET v_id_pessoa = NULL;

  IF p_cpf IS NOT NULL AND LENGTH(TRIM(p_cpf)) > 0 THEN
    SELECT id_pessoa INTO v_id_pessoa
    FROM pessoa
    WHERE cpf = p_cpf
    LIMIT 1;
  END IF;

  IF v_id_pessoa IS NULL AND p_cns IS NOT NULL AND LENGTH(TRIM(p_cns)) > 0 THEN
    SELECT id_pessoa INTO v_id_pessoa
    FROM pessoa
    WHERE cns = p_cns
    LIMIT 1;
  END IF;

  IF v_id_pessoa IS NULL THEN
    INSERT INTO pessoa (
      nome_completo, nome_social, cpf, cns, rg, rg_uf, data_nascimento, sexo, nome_mae, telefone, email, dt_nascimento
    ) VALUES (
      p_nome_completo, p_nome_social, p_cpf, p_cns, p_rg, p_rg_uf, p_data_nascimento, p_sexo, p_nome_mae, p_telefone, p_email, p_data_nascimento
    );
    SET v_id_pessoa = LAST_INSERT_ID();
  ELSE
    -- update "não destrutivo": só preenche campos vazios
    UPDATE pessoa
       SET nome_completo    = COALESCE(NULLIF(nome_completo,''), p_nome_completo),
           nome_social      = COALESCE(nome_social, p_nome_social),
           rg              = COALESCE(rg, p_rg),
           rg_uf           = COALESCE(rg_uf, p_rg_uf),
           data_nascimento = COALESCE(data_nascimento, p_data_nascimento),
           dt_nascimento   = COALESCE(dt_nascimento, p_data_nascimento),
           sexo            = COALESCE(sexo, p_sexo),
           nome_mae        = COALESCE(nome_mae, p_nome_mae),
           telefone        = COALESCE(telefone, p_telefone),
           email           = COALESCE(email, p_email)
     WHERE id_pessoa = v_id_pessoa;
  END IF;

  -- 2) garante paciente
  SELECT id INTO v_id_paciente
  FROM paciente
  WHERE id_pessoa = v_id_pessoa
  LIMIT 1;

  IF v_id_paciente IS NULL THEN
    INSERT INTO paciente (id_pessoa, prontuario)
    VALUES (v_id_pessoa, CONCAT('P', LPAD(v_id_pessoa, 8, '0')));
    SET v_id_paciente = LAST_INSERT_ID();
  END IF;

  -- 3) vincula a senha ao paciente (regra: paciente só existe após senha)
  UPDATE senhas
     SET id_paciente = v_id_paciente,
         tipo_atendimento = COALESCE(p_tipo_atendimento, tipo_atendimento),
         id_usuario_operador = v_id_usuario
   WHERE id = p_id_senha;

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,
    'SENHA',
    p_id_senha,
    'SALVAR_COMPLEMENTACAO',
    CONCAT('pessoa=', v_id_pessoa, ', paciente=', v_id_paciente, ', tipo=', p_tipo_atendimento)
  );

  -- 4) cria FFA se ainda não existir (canônico) e retorna ids
  CALL sp__ffa_criar_por_senha_core(
    p_id_sessao_usuario,
    p_id_senha,
    v_id_usuario,
    v_id_unidade,
    v_id_local_operacional,
    p_layout,
    v_id_ffa,
    v_gpat
  );

  -- 5) observação (opcional) como evento
  IF p_observacao IS NOT NULL AND LENGTH(TRIM(p_observacao)) > 0 THEN
    INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
    VALUES ('SENHA', p_id_senha, 'OBS_COMPLEMENTACAO', p_observacao, v_id_usuario, NULL, 'RECEPCAO', NOW());
  END IF;

  COMMIT;

  SELECT
    p_id_senha    AS id_senha,
    v_id_pessoa   AS id_pessoa,
    v_id_paciente AS id_paciente,
    v_id_ffa      AS id_ffa,
    v_gpat        AS gpat,
    'OK'          AS resultado;
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_acesso_prontuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_acesso_prontuario`(
    IN p_id_usuario BIGINT,
    IN p_id_ffa BIGINT,
    IN p_motivo VARCHAR(255)
)
BEGIN
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, observacao, criado_em)
    VALUES (p_id_ffa, p_id_usuario, 'VISUALIZACAO_PRONTUARIO', p_motivo, NOW());
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
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_paciente`(
    IN p_nome_completo VARCHAR(200),
    IN p_cpf VARCHAR(14),
    IN p_data_nascimento DATE,
    IN p_id_usuario BIGINT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM usuario_sistema WHERE id_usuario = p_id_usuario) THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Permissão negada';
    END IF;
    INSERT INTO pessoa (nome_completo, cpf, data_nascimento) VALUES (p_nome_completo, p_cpf, p_data_nascimento);
    INSERT INTO paciente (id_pessoa) VALUES (LAST_INSERT_ID());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reset_senha_padrao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reset_senha_padrao`(IN p_id_usuario BIGINT)
BEGIN
    -- Define a senha como o próprio login em MD5
    UPDATE usuario 
    SET senha = MD5(login),
        forcar_troca_senha = 1 -- Para o usuário mudar no 1º acesso
    WHERE id_usuario = p_id_usuario;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_retorno_procedimento_critico`(IN p_id_ffa BIGINT, IN p_id_usuario BIGINT)
BEGIN
  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', p_id_ffa, 'RETORNO_PROCEDIMENTO_CRITICO', 'Retorno de procedimento (crítico) - evento', p_id_usuario, NULL, 'PROCEDIMENTO', NOW());
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_retorno_procedimento_normal`(IN p_id_ffa BIGINT, IN p_id_usuario BIGINT)
BEGIN
  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', p_id_ffa, 'RETORNO_PROCEDIMENTO_NORMAL', 'Retorno de procedimento (normal) - evento', p_id_usuario, NULL, 'PROCEDIMENTO', NOW());
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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_rx_finalizar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa BIGINT,
  IN p_observacao TEXT
)
BEGIN
  DECLARE v_id_fila BIGINT;

  CALL sp_setor_finalizar(p_id_sessao_usuario, p_id_ffa, 'RX', p_observacao);

  SELECT id_fila INTO v_id_fila
    FROM fila_operacional
   WHERE id_ffa = p_id_ffa AND tipo='RX'
   ORDER BY id_fila DESC
   LIMIT 1;

  UPDATE procedimento_protocolo
     SET status='FINALIZADO', atualizado_em=NOW()
   WHERE id_fila = v_id_fila AND tipo='RX';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_rx_iniciar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_rx_iniciar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa BIGINT,
  OUT p_codigo VARCHAR(50)
)
BEGIN
  CALL sp_setor_iniciar(p_id_sessao_usuario, p_id_ffa, 'RX');
  CALL sp_protocolo_criar_por_ffa(p_id_sessao_usuario, p_id_ffa, 'RX', p_codigo);
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
    IN p_id_senha BIGINT
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_sistema BIGINT;
    DECLARE v_id_unidade BIGINT;

    DECLARE v_status_old VARCHAR(40);
    DECLARE v_id_sistema_senha BIGINT;
    DECLARE v_id_unidade_senha BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_senha_cancelar', v_id_usuario);
        CALL sp_raise('ERRO_SQL', 'sp_senha_cancelar');
    END;

    START TRANSACTION;

    SELECT id_usuario, id_sistema, id_unidade
      INTO v_id_usuario, v_id_sistema, v_id_unidade
      FROM sessao_usuario
     WHERE id_sessao_usuario = p_id_sessao_usuario
       AND ativo = 1
     LIMIT 1;

    IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL THEN
        CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
    END IF;

    SELECT status, id_sistema, id_unidade
      INTO v_status_old, v_id_sistema_senha, v_id_unidade_senha
      FROM senhas
     WHERE id = p_id_senha
     FOR UPDATE;

    IF v_status_old IS NULL THEN
        CALL sp_raise('ERRO_SENHA_NAO_ENCONTRADA', NULL);
    END IF;

    IF v_id_sistema_senha <> v_id_sistema OR v_id_unidade_senha <> v_id_unidade THEN
        CALL sp_raise('ERRO_SENHA_FORA_CONTEXTO', NULL);
    END IF;

    IF v_status_old IN ('FINALIZADO','CANCELADO') THEN
        CALL sp_raise('ERRO_SENHA_STATUS_INVALIDO', v_status_old);
    END IF;

    UPDATE senhas
       SET status = 'CANCELADO',
           finalizada_em = COALESCE(finalizada_em, NOW()),
           id_usuario_operador = COALESCE(id_usuario_operador, v_id_usuario)
     WHERE id = p_id_senha;

    INSERT INTO senha_eventos (id_senha, id_sessao_usuario, status_anterior, status_novo, criado_em)
    VALUES (p_id_senha, p_id_sessao_usuario, v_status_old, 'CANCELADO', NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'senhas', p_id_senha, 'CANCELAR',
        CONCAT('Cancelamento. status ', v_status_old, ' -> CANCELADO')
    );

    COMMIT;

    SELECT p_id_senha AS id, 'CANCELADO' AS status;
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
    IN p_id_senha BIGINT
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_sistema BIGINT;
    DECLARE v_id_unidade BIGINT;

    DECLARE v_status_old VARCHAR(40);
    DECLARE v_id_sistema_senha BIGINT;
    DECLARE v_id_unidade_senha BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_ffa BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_senha_finalizar', v_id_usuario);
        CALL sp_raise('ERRO_SQL', 'sp_senha_finalizar');
    END;

    START TRANSACTION;

    SELECT id_usuario, id_sistema, id_unidade
      INTO v_id_usuario, v_id_sistema, v_id_unidade
      FROM sessao_usuario
     WHERE id_sessao_usuario = p_id_sessao_usuario
       AND ativo = 1
     LIMIT 1;

    IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL THEN
        CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
    END IF;

    SELECT status, id_sistema, id_unidade, id_paciente, id_ffa
      INTO v_status_old, v_id_sistema_senha, v_id_unidade_senha, v_id_paciente, v_id_ffa
      FROM senhas
     WHERE id = p_id_senha
     FOR UPDATE;

    IF v_status_old IS NULL THEN
        CALL sp_raise('ERRO_SENHA_NAO_ENCONTRADA', NULL);
    END IF;

    IF v_id_sistema_senha <> v_id_sistema OR v_id_unidade_senha <> v_id_unidade THEN
        CALL sp_raise('ERRO_SENHA_FORA_CONTEXTO', NULL);
    END IF;

    IF v_status_old IN ('FINALIZADO','CANCELADO') THEN
        CALL sp_raise('ERRO_SENHA_STATUS_INVALIDO', v_status_old);
    END IF;

    IF v_id_paciente IS NULL THEN
        CALL sp_raise('ERRO_SENHA_SEM_VINCULO_PACIENTE', NULL);
    END IF;

    IF v_id_ffa IS NULL THEN
        CALL sp_raise('ERRO_SENHA_SEM_VINCULO_FFA', NULL);
    END IF;

    UPDATE senhas
       SET status = 'FINALIZADO',
           finalizada_em = COALESCE(finalizada_em, NOW()),
           id_usuario_operador = COALESCE(id_usuario_operador, v_id_usuario)
     WHERE id = p_id_senha;

    INSERT INTO senha_eventos (id_senha, id_sessao_usuario, status_anterior, status_novo, criado_em)
    VALUES (p_id_senha, p_id_sessao_usuario, v_status_old, 'FINALIZADO', NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'senhas', p_id_senha, 'FINALIZAR',
        CONCAT('status ', v_status_old, ' -> FINALIZADO')
    );

    COMMIT;

    SELECT p_id_senha AS id, 'FINALIZADO' AS status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_senha_iniciar_atendimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_iniciar_atendimento`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_sistema BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local   BIGINT;

    DECLARE v_status_old VARCHAR(40);
    DECLARE v_id_sistema_senha BIGINT;
    DECLARE v_id_unidade_senha BIGINT;
    DECLARE v_id_local_senha BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_senha_iniciar_atendimento', v_id_usuario);
        CALL sp_raise('ERRO_SQL', 'sp_senha_iniciar_atendimento');
    END;

    START TRANSACTION;

    SELECT id_usuario, id_sistema, id_unidade, id_local_operacional
      INTO v_id_usuario, v_id_sistema, v_id_unidade, v_id_local
      FROM sessao_usuario
     WHERE id_sessao_usuario = p_id_sessao_usuario
       AND ativo = 1
     LIMIT 1;

    IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL OR v_id_local IS NULL THEN
        CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
    END IF;

    SELECT status, id_sistema, id_unidade, id_local_operacional
      INTO v_status_old, v_id_sistema_senha, v_id_unidade_senha, v_id_local_senha
      FROM senhas
     WHERE id = p_id_senha
     FOR UPDATE;

    IF v_status_old IS NULL THEN
        CALL sp_raise('ERRO_SENHA_NAO_ENCONTRADA', NULL);
    END IF;

    IF v_id_sistema_senha <> v_id_sistema OR v_id_unidade_senha <> v_id_unidade THEN
        CALL sp_raise('ERRO_SENHA_FORA_CONTEXTO', NULL);
    END IF;

    IF v_id_local_senha IS NOT NULL AND v_id_local_senha <> v_id_local THEN
        CALL sp_raise('ERRO_SENHA_FORA_LOCAL', NULL);
    END IF;

    IF v_status_old NOT IN ('CHAMANDO','EM_COMPLEMENTACAO','AGUARDANDO') THEN
        CALL sp_raise('ERRO_SENHA_STATUS_INVALIDO', v_status_old);
    END IF;

    UPDATE senhas
       SET status = 'EM_ATENDIMENTO',
           inicio_atendimento_em = COALESCE(inicio_atendimento_em, NOW()),
           id_usuario_operador = COALESCE(id_usuario_operador, v_id_usuario)
     WHERE id = p_id_senha;

    INSERT INTO senha_eventos (id_senha, id_sessao_usuario, status_anterior, status_novo, criado_em)
    VALUES (p_id_senha, p_id_sessao_usuario, v_status_old, 'EM_ATENDIMENTO', NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'senhas', p_id_senha, 'INICIAR_ATENDIMENTO',
        CONCAT('status ', v_status_old, ' -> EM_ATENDIMENTO')
    );

    COMMIT;

    SELECT p_id_senha AS id, 'EM_ATENDIMENTO' AS status;
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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_iniciar_complementacao`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_senha BIGINT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_sistema BIGINT;
  DECLARE v_id_unidade BIGINT;
  DECLARE v_id_local_operacional BIGINT;
  DECLARE v_tipo_local VARCHAR(50);
  DECLARE v_status_atual VARCHAR(50);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_senha_iniciar_complementacao', v_id_usuario);
    RESIGNAL;
  END;

  START TRANSACTION;

  -- sessão/contexto
  SELECT su.id_usuario, su.id_sistema, su.id_unidade, su.id_local_operacional
    INTO v_id_usuario, v_id_sistema, v_id_unidade, v_id_local_operacional
  FROM sessao_usuario su
  WHERE su.id_sessao_usuario = p_id_sessao_usuario
    AND su.ativo = 1
  LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA', 'Sessao inexistente ou inativa');
  END IF;

  SELECT lo.tipo INTO v_tipo_local
  FROM local_operacional lo
  WHERE lo.id_local_operacional = v_id_local_operacional
  LIMIT 1;

  IF v_tipo_local <> 'RECEPCAO' THEN
    CALL sp_raise('LOCAL_INVALIDO', 'Esta acao so pode ser executada na RECEPCAO');
  END IF;

  -- trava a senha
  SELECT s.status INTO v_status_atual
  FROM senhas s
  WHERE s.id = p_id_senha
  FOR UPDATE;

  IF v_status_atual IS NULL THEN
    CALL sp_raise('SENHA_NAO_ENCONTRADA', CONCAT('id=', p_id_senha));
  END IF;

  IF v_status_atual <> 'CHAMANDO' THEN
    CALL sp_raise('STATUS_INVALIDO', CONCAT('Esperado=CHAMANDO, atual=', v_status_atual));
  END IF;

  UPDATE senhas
     SET status = 'EM_COMPLEMENTACAO',
         id_usuario_operador = v_id_usuario,
         id_local_operacional = v_id_local_operacional
   WHERE id = p_id_senha;

  INSERT INTO senha_eventos (id_senha, id_sessao_usuario, status_anterior, status_novo)
  VALUES (p_id_senha, p_id_sessao_usuario, v_status_atual, 'EM_COMPLEMENTACAO');

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,
    'SENHA',
    p_id_senha,
    'INICIAR_COMPLEMENTACAO',
    CONCAT('status ', v_status_atual, ' -> EM_COMPLEMENTACAO (local=', v_id_local_operacional, ')')
  );

  COMMIT;

  SELECT p_id_senha AS id_senha, 'OK' AS resultado;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_senha_listar_fila_local` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_listar_fila_local`(
    IN p_id_sessao_usuario BIGINT,
    IN p_status_csv VARCHAR(200),   -- ex: 'GERADA,AGUARDANDO,CHAMANDO,EM_COMPLEMENTACAO'
    IN p_lane VARCHAR(20),          -- NULL para todas | 'ADULTO'|'PEDIATRICO'|'PRIORITARIO'
    IN p_limit INT                  -- NULL/0 = 200
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_sistema BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local   BIGINT;

    DECLARE v_lim INT;

    SELECT id_usuario, id_sistema, id_unidade, id_local_operacional
      INTO v_id_usuario, v_id_sistema, v_id_unidade, v_id_local
      FROM sessao_usuario
     WHERE id_sessao_usuario = p_id_sessao_usuario
       AND ativo = 1
     LIMIT 1;

    IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL OR v_id_local IS NULL THEN
        CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
    END IF;

    SET v_lim = COALESCE(NULLIF(p_limit,0), 200);
    IF v_lim > 500 THEN SET v_lim = 500; END IF;

    -- Default de statuses
    IF p_status_csv IS NULL OR p_status_csv = '' THEN
        SET p_status_csv = 'GERADA,AGUARDANDO,CHAMANDO,EM_COMPLEMENTACAO,EM_ATENDIMENTO';
    END IF;

    SELECT
        s.id              AS id_senha,
        s.codigo          AS codigo,
        s.lane            AS lane,
        s.status          AS status,
        s.prioridade      AS prioridade,
        s.tipo_atendimento AS tipo_atendimento,
        s.origem          AS origem,
        s.id_paciente     AS id_paciente,
        p.id_pessoa       AS id_pessoa,
        pe.nome_completo  AS nome_pessoa,
        DATE_FORMAT(COALESCE(s.posicionado_em, s.criada_em), '%H:%i') AS hora_fila,
        TIMESTAMPDIFF(MINUTE, COALESCE(s.posicionado_em, s.criada_em), NOW()) AS minutos_espera,
        s.nao_compareceu_em,
        s.retorno_permitido_ate,
        s.retorno_utilizado
    FROM senhas s
    LEFT JOIN paciente p ON p.id_paciente = s.id_paciente
    LEFT JOIN pessoa pe  ON pe.id_pessoa  = p.id_pessoa
    WHERE s.id_sistema = v_id_sistema
      AND s.id_unidade = v_id_unidade
      AND s.id_local_operacional = v_id_local
      AND FIND_IN_SET(s.status, p_status_csv) > 0
      AND (p_lane IS NULL OR p_lane = '' OR s.lane = p_lane)
    ORDER BY
        CASE WHEN s.status = 'CHAMANDO' THEN 1
             WHEN s.status = 'EM_COMPLEMENTACAO' THEN 2
             WHEN s.status = 'EM_ATENDIMENTO' THEN 3
             ELSE 4 END,
        s.prioridade DESC,
        COALESCE(s.posicionado_em, s.criada_em) ASC
    LIMIT v_lim;
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
  IN p_id_senha BIGINT
)
BEGIN
  DECLARE v_status_anterior VARCHAR(50);
  DECLARE v_id_local BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_senha_nao_compareceu', CONCAT('id_senha=', p_id_senha));
    RESIGNAL;
  END;

  IF p_id_sessao_usuario IS NULL OR p_id_sessao_usuario = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_sessao_usuario');
  END IF;
  IF p_id_senha IS NULL OR p_id_senha = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_senha');
  END IF;

  START TRANSACTION;

  SELECT s.id_local_operacional
    INTO v_id_local
    FROM sessao_usuario s
   WHERE s.id_sessao_usuario = p_id_sessao_usuario
   LIMIT 1;

  SELECT status
    INTO v_status_anterior
    FROM senhas
   WHERE id = p_id_senha
   FOR UPDATE;

  IF v_status_anterior IS NULL THEN
    CALL sp_raise('ERRO_SENHA_NAO_ENCONTRADA', CAST(p_id_senha AS CHAR));
  END IF;

  UPDATE senhas
     SET status = 'NAO_COMPARECEU',
         nao_compareceu_em = NOW(),
         retorno_permitido_ate = DATE_ADD(NOW(), INTERVAL 60 MINUTE),
         retorno_utilizado = 0,
         retorno_em = NULL
   WHERE id = p_id_senha;

  INSERT INTO senha_eventos(id_senha, id_sessao_usuario, status_anterior, status_novo, criado_em)
  VALUES (p_id_senha, p_id_sessao_usuario, v_status_anterior, 'NAO_COMPARECEU', NOW());

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,
    'SENHA',
    p_id_senha,
    'NAO_COMPARECEU',
    CONCAT('status_anterior=', v_status_anterior, '; janela=60min; local=', COALESCE(v_id_local,'NULL'))
  );

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_senha_retorno_nao_compareceu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_retorno_nao_compareceu`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_senha BIGINT
)
BEGIN
  DECLARE v_status_anterior VARCHAR(50);
  DECLARE v_pos DATETIME;
  DECLARE v_limite DATETIME;
  DECLARE v_utilizado TINYINT;
  DECLARE v_id_local BIGINT;
  DECLARE v_move_fim TINYINT DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_senha_retorno_nao_compareceu', CONCAT('id_senha=', p_id_senha));
    RESIGNAL;
  END;

  IF p_id_sessao_usuario IS NULL OR p_id_sessao_usuario = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_sessao_usuario');
  END IF;
  IF p_id_senha IS NULL OR p_id_senha = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_senha');
  END IF;

  START TRANSACTION;

  SELECT s.id_local_operacional
    INTO v_id_local
    FROM sessao_usuario s
   WHERE s.id_sessao_usuario = p_id_sessao_usuario
   LIMIT 1;

  SELECT status, posicionado_em, retorno_permitido_ate, retorno_utilizado
    INTO v_status_anterior, v_pos, v_limite, v_utilizado
    FROM senhas
   WHERE id = p_id_senha
   FOR UPDATE;

  IF v_status_anterior IS NULL THEN
    CALL sp_raise('ERRO_SENHA_NAO_ENCONTRADA', CAST(p_id_senha AS CHAR));
  END IF;

  IF v_status_anterior <> 'NAO_COMPARECEU' THEN
    CALL sp_raise('ERRO_STATUS_INVALIDO', CONCAT('esperado=NAO_COMPARECEU atual=', v_status_anterior));
  END IF;

  IF v_utilizado = 1 THEN
    CALL sp_raise('ERRO_RETORNO_JA_UTILIZADO', CAST(p_id_senha AS CHAR));
  END IF;

  -- se não tem limite, trata como expirado -> vai pro fim
  IF v_limite IS NULL OR NOW() > v_limite THEN
    SET v_move_fim = 1;
  END IF;

  UPDATE senhas
     SET status = 'AGUARDANDO',
         retorno_utilizado = 1,
         retorno_em = NOW(),
         posicionado_em = CASE WHEN v_move_fim = 1 THEN NOW() ELSE v_pos END
   WHERE id = p_id_senha;

  INSERT INTO senha_eventos(id_senha, id_sessao_usuario, status_anterior, status_novo, criado_em)
  VALUES (p_id_senha, p_id_sessao_usuario, 'NAO_COMPARECEU', 'AGUARDANDO', NOW());

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,
    'SENHA',
    p_id_senha,
    'RETORNO_NAO_COMPARECEU',
    CONCAT('move_fim=', v_move_fim, '; pos_original=', COALESCE(DATE_FORMAT(v_pos,'%Y-%m-%d %H:%i:%s'),'NULL'),
           '; limite=', COALESCE(DATE_FORMAT(v_limite,'%Y-%m-%d %H:%i:%s'),'NULL'),
           '; local=', COALESCE(v_id_local,'NULL'))
  );

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_servico_agendamento_upsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_servico_agendamento_upsert`(
  IN p_id_sessao_usuario BIGINT,
  IN p_codigo VARCHAR(50),
  IN p_nome VARCHAR(120),
  IN p_duracao_minutos INT,
  IN p_categoria VARCHAR(30),
  IN p_tipo ENUM('CONSULTA','PROCEDIMENTO','EXAME','RETORNO','OUTRO'),
  IN p_exige_profissional TINYINT,
  IN p_ativo TINYINT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_sistema BIGINT;
  DECLARE v_id_unidade BIGINT;
  DECLARE v_id_local BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_raise('ERRO_SQL', 'sp_servico_agendamento_upsert');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_sistema, id_unidade, id_local_operacional
    INTO v_id_usuario, v_id_sistema, v_id_unidade, v_id_local
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario AND ativa = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_sistema IS NULL OR v_id_unidade IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  INSERT INTO servico_agendamento (id_sistema, id_unidade, codigo, nome, duracao_minutos, categoria, tipo, exige_profissional, ativo)
  VALUES (v_id_sistema, v_id_unidade, p_codigo, p_nome, COALESCE(p_duracao_minutos,15), p_categoria, COALESCE(p_tipo,'CONSULTA'), COALESCE(p_exige_profissional,1), COALESCE(p_ativo,1))
  ON DUPLICATE KEY UPDATE
    nome = VALUES(nome),
    duracao_minutos = VALUES(duracao_minutos),
    categoria = VALUES(categoria),
    tipo = VALUES(tipo),
    exige_profissional = VALUES(exige_profissional),
    ativo = VALUES(ativo);

  -- Auditoria (entidade: servico_agendamento, id_entidade não é trivial sem lookup; registra por código)
  CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'servico_agendamento', 0, 'UPSERT',
    CONCAT('Servico ', p_codigo, ' atualizado/criado: ', p_nome));

  COMMIT;

  SELECT 1 AS ok;
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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_abrir`(
  IN p_id_usuario BIGINT,
  IN p_id_sistema BIGINT,
  IN p_id_unidade BIGINT,
  IN p_id_local_operacional BIGINT,
  IN p_ip VARCHAR(45),
  IN p_user_agent VARCHAR(255)
)
BEGIN
  DECLARE v_token VARCHAR(255);
  DECLARE v_id_sessao BIGINT;
  DECLARE v_ok INT DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_raise('ERRO_SESSAO_ABRIR_INTERNO', NULL);
  END;

  -- Valida parâmetros
  IF p_id_usuario IS NULL OR p_id_usuario = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_usuario');
  END IF;
  IF p_id_sistema IS NULL OR p_id_sistema = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_sistema');
  END IF;
  IF p_id_unidade IS NULL OR p_id_unidade = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_unidade');
  END IF;
  IF p_id_local_operacional IS NULL OR p_id_local_operacional = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_local_operacional');
  END IF;

  -- Usuário ativo
  SELECT 1 INTO v_ok FROM usuario u WHERE u.id_usuario = p_id_usuario AND u.ativo = 1 LIMIT 1;
  IF v_ok IS NULL OR v_ok = 0 THEN
    CALL sp_raise('ERRO_USUARIO_INATIVO_OU_INEXISTENTE', CAST(p_id_usuario AS CHAR));
  END IF;

  -- Sistema/unidade ativos
  SELECT 1 INTO v_ok FROM sistema s WHERE s.id_sistema = p_id_sistema AND s.ativo = 1 LIMIT 1;
  IF v_ok IS NULL OR v_ok = 0 THEN
    CALL sp_raise('ERRO_SISTEMA_INVALIDO', CAST(p_id_sistema AS CHAR));
  END IF;

  SELECT 1 INTO v_ok FROM unidade un WHERE un.id_unidade = p_id_unidade AND un.ativo = 1 LIMIT 1;
  IF v_ok IS NULL OR v_ok = 0 THEN
    CALL sp_raise('ERRO_UNIDADE_INVALIDA', CAST(p_id_unidade AS CHAR));
  END IF;

  -- Local pertence ao sistema+unidade
  SELECT 1 INTO v_ok
    FROM local_operacional lo
   WHERE lo.id_local_operacional = p_id_local_operacional
     AND lo.ativo = 1
     AND lo.id_sistema = p_id_sistema
     AND lo.id_unidade = p_id_unidade
   LIMIT 1;

  IF v_ok IS NULL OR v_ok = 0 THEN
    CALL sp_raise('ERRO_LOCAL_INVALIDO_OU_FORA_DO_CONTEXTO', CAST(p_id_local_operacional AS CHAR));
  END IF;

  START TRANSACTION;

    -- Fecha sessões ativas antigas do usuário
    UPDATE sessao_usuario
       SET ativa = 0,
           encerrado_em = COALESCE(encerrado_em, NOW())
     WHERE id_usuario = p_id_usuario
       AND ativa = 1;

    SET v_token = SHA2(CONCAT(UUID(), '|', p_id_usuario, '|', NOW(6)), 256);

    INSERT INTO sessao_usuario(
      id_usuario,
      id_sistema,
      id_unidade,
      id_local_operacional,
      token,
      ip_acesso,
      user_agent,
      iniciado_em,
      encerrado_em,
      ativa
    ) VALUES (
      p_id_usuario,
      p_id_sistema,
      p_id_unidade,
      p_id_local_operacional,
      v_token,
      p_ip,
      p_user_agent,
      NOW(),
      NULL,
      1
    );

    SET v_id_sessao = LAST_INSERT_ID();

    CALL sp_auditoria_evento_registrar(v_id_sessao, 'SESSAO', v_id_sessao, 'ABRIR', CONCAT('ip=',IFNULL(p_ip,'')));

  COMMIT;

  SELECT v_id_sessao AS id_sessao_usuario, v_token AS token;
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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_encerrar`(
  IN p_id_usuario BIGINT,
  IN p_id_sessao_usuario BIGINT
)
BEGIN
  DECLARE v_ok INT DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_raise('ERRO_SESSAO_ENCERRAR_INTERNO', NULL);
  END;

  IF p_id_usuario IS NULL OR p_id_usuario = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_usuario');
  END IF;
  IF p_id_sessao_usuario IS NULL OR p_id_sessao_usuario = 0 THEN
    CALL sp_raise('ERRO_PARAMETRO_OBRIGATORIO', 'id_sessao_usuario');
  END IF;

  SELECT 1 INTO v_ok
    FROM sessao_usuario s
   WHERE s.id_sessao_usuario = p_id_sessao_usuario
     AND s.id_usuario = p_id_usuario
   LIMIT 1;

  IF v_ok IS NULL OR v_ok = 0 THEN
    CALL sp_raise('ERRO_SESSAO_USUARIO_INVALIDA', CAST(p_id_sessao_usuario AS CHAR));
  END IF;

  START TRANSACTION;

    UPDATE sessao_usuario
       SET ativa = 0,
           encerrado_em = NOW()
     WHERE id_sessao_usuario = p_id_sessao_usuario;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'SESSAO', p_id_sessao_usuario, 'ENCERRAR', NULL);

  COMMIT;

  SELECT 1 AS ok;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setor_finalizar_atendimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setor_finalizar_atendimento`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_fila BIGINT,
  IN p_observacao TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_local   BIGINT;

  DECLARE v_id_ffa BIGINT;
  DECLARE v_tipo  VARCHAR(20);
  DECLARE v_substatus_old VARCHAR(20);
  DECLARE v_local_fila BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_setor_finalizar_atendimento', v_id_usuario);
    CALL sp_raise('ERRO_SQL', 'sp_setor_finalizar_atendimento');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_local_operacional
    INTO v_id_usuario, v_id_local
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario
     AND ativo = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_local IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  SELECT id_ffa, tipo, substatus, id_local
    INTO v_id_ffa, v_tipo, v_substatus_old, v_local_fila
    FROM fila_operacional
   WHERE id_fila = p_id_fila
   FOR UPDATE;

  IF v_id_ffa IS NULL THEN
    CALL sp_raise('ERRO_FILA_NAO_ENCONTRADA', NULL);
  END IF;

  IF v_local_fila IS NOT NULL AND v_local_fila <> v_id_local THEN
    CALL sp_raise('ERRO_FILA_LOCAL_DIFERENTE', NULL);
  END IF;

  IF v_substatus_old NOT IN ('EM_EXECUCAO','EM_OBSERVACAO','CRITICO') THEN
    CALL sp_raise('ERRO_FILA_STATUS_INVALIDO', v_substatus_old);
  END IF;

  UPDATE fila_operacional
     SET substatus   = 'FINALIZADO',
         data_fim    = NOW(),
         observacao  = COALESCE(p_observacao, observacao)
   WHERE id_fila = p_id_fila;

  -- Atualiza status de FFA (mínimo, sem adivinhar próximo setor)
  IF v_tipo = 'TRIAGEM' THEN
    UPDATE ffa SET status='AGUARDANDO_CHAMADA_MEDICO', atualizado_em=NOW() WHERE id = v_id_ffa;
  END IF;

  INSERT INTO auditoria_evento (id_sessao_usuario, entidade, id_entidade, acao, detalhe, id_usuario, tabela, id_usuario_espelho)
  VALUES (
    p_id_sessao_usuario,
    'FILA_OPERACIONAL',
    p_id_fila,
    'FINALIZAR',
    JSON_OBJECT('tipo', v_tipo, 'id_ffa', v_id_ffa, 'substatus_old', v_substatus_old, 'obs', p_observacao),
    v_id_usuario,
    'fila_operacional',
    v_id_usuario
  );

  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FILA_OPERACIONAL', p_id_fila, CONCAT('SETOR_FINALIZAR_', v_tipo), 'Finalização de atendimento no setor', v_id_usuario, NULL, v_tipo, NOW());

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setor_iniciar_atendimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setor_iniciar_atendimento`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_fila BIGINT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_local   BIGINT;

  DECLARE v_id_ffa BIGINT;
  DECLARE v_tipo  VARCHAR(20);
  DECLARE v_substatus_old VARCHAR(20);
  DECLARE v_local_fila BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_setor_iniciar_atendimento', v_id_usuario);
    CALL sp_raise('ERRO_SQL', 'sp_setor_iniciar_atendimento');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_local_operacional
    INTO v_id_usuario, v_id_local
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario
     AND ativo = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_local IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  SELECT id_ffa, tipo, substatus, id_local
    INTO v_id_ffa, v_tipo, v_substatus_old, v_local_fila
    FROM fila_operacional
   WHERE id_fila = p_id_fila
   FOR UPDATE;

  IF v_id_ffa IS NULL THEN
    CALL sp_raise('ERRO_FILA_NAO_ENCONTRADA', NULL);
  END IF;

  IF v_local_fila IS NOT NULL AND v_local_fila <> v_id_local THEN
    CALL sp_raise('ERRO_FILA_LOCAL_DIFERENTE', NULL);
  END IF;

  IF v_substatus_old NOT IN ('AGUARDANDO','CRITICO','EM_OBSERVACAO') THEN
    CALL sp_raise('ERRO_FILA_STATUS_INVALIDO', v_substatus_old);
  END IF;

  UPDATE fila_operacional
     SET substatus      = 'EM_EXECUCAO',
         data_inicio    = COALESCE(data_inicio, NOW()),
         id_responsavel = v_id_usuario,
         id_local       = COALESCE(id_local, v_id_local)
   WHERE id_fila = p_id_fila;

  -- Atualiza status de FFA (mínimo, sem automatizar fluxo)
  IF v_tipo = 'TRIAGEM' THEN
    UPDATE ffa SET status='EM_TRIAGEM', atualizado_em=NOW() WHERE id = v_id_ffa;
  ELSEIF v_tipo = 'MEDICO' THEN
    UPDATE ffa SET status='EM_ATENDIMENTO_MEDICO', atualizado_em=NOW() WHERE id = v_id_ffa;
  END IF;

  INSERT INTO auditoria_evento (id_sessao_usuario, entidade, id_entidade, acao, detalhe, id_usuario, tabela, id_usuario_espelho)
  VALUES (
    p_id_sessao_usuario,
    'FILA_OPERACIONAL',
    p_id_fila,
    'INICIAR',
    JSON_OBJECT('tipo', v_tipo, 'id_ffa', v_id_ffa, 'substatus_old', v_substatus_old),
    v_id_usuario,
    'fila_operacional',
    v_id_usuario
  );

  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FILA_OPERACIONAL', p_id_fila, CONCAT('SETOR_INICIAR_', v_tipo), 'Início de atendimento no setor', v_id_usuario, NULL, v_tipo, NOW());

  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setor_listar_fila` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setor_listar_fila`(
  IN p_id_sessao_usuario BIGINT,
  IN p_tipo ENUM('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO'),
  IN p_limit INT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_local   BIGINT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_setor_listar_fila', v_id_usuario);
    CALL sp_raise('ERRO_SQL', 'sp_setor_listar_fila');
  END;

  START TRANSACTION;

  SELECT id_usuario, id_local_operacional
    INTO v_id_usuario, v_id_local
    FROM sessao_usuario
   WHERE id_sessao_usuario = p_id_sessao_usuario
     AND ativo = 1
   LIMIT 1;

  IF v_id_usuario IS NULL OR v_id_local IS NULL THEN
    CALL sp_raise('ERRO_SESSAO_INVALIDA', NULL);
  END IF;

  IF p_limit IS NULL OR p_limit <= 0 OR p_limit > 200 THEN
    SET p_limit = 50;
  END IF;

  -- Retorna a fila do LOCAL da sessão (front não decide por conta própria)
  SELECT
    vfm.id_fila,
    vfm.id_ffa,
    vfm.tipo,
    vfm.substatus,
    vfm.prioridade_real,
    vfm.prioridade_efetiva,
    vfm.elevou_por_tempo,
    vfm.tempo_max_min,
    vfm.minutos_espera,
    vfm.data_entrada,
    vfm.data_inicio,
    vfm.data_fim,
    vfm.id_responsavel
  FROM vw_fila_operacional_manchester vfm
  WHERE vfm.tipo = p_tipo
    AND (vfm.id_local = v_id_local OR (p_tipo='MEDICO' AND vfm.id_local IS NULL))
    AND vfm.substatus IN ('AGUARDANDO','EM_EXECUCAO','EM_OBSERVACAO','CRITICO')
  ORDER BY
    vfm.prioridade_rank_efetiva DESC,
    vfm.data_entrada ASC
  LIMIT p_limit;

  COMMIT;
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_totem_listar_plantao_banner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_totem_listar_plantao_banner`(IN p_limite INT)
BEGIN
  IF p_limite IS NULL OR p_limite <= 0 THEN
    SET p_limite = 10;
  END IF;

  SELECT *
    FROM vw_totem_plantao_banner
   ORDER BY setor, inicio
   LIMIT p_limite;
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_transferir_paciente_leito` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_transferir_paciente_leito`(
    IN p_id_internacao BIGINT,
    IN p_id_leito_novo BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_leito_antigo BIGINT;

    -- 1. Pega o leito onde o paciente está agora
    SELECT id_leito INTO v_id_leito_antigo 
    FROM internacao 
    WHERE id_internacao = p_id_internacao;

    -- INÍCIO DA MÁGICA
    START TRANSACTION;

    -- 2. Libera o leito antigo (Coloca em LIMPEZA para a hotelaria trabalhar)
    UPDATE leito SET status = 'LIMPEZA' WHERE id_leito = v_id_leito_antigo;

    -- 3. Ocupa o novo leito
    UPDATE leito SET status = 'OCUPADO' WHERE id_leito = p_id_leito_novo;

    -- 4. Atualiza a internação principal
    UPDATE internacao SET id_leito = p_id_leito_novo WHERE id_internacao = p_id_internacao;

    -- 5. Audita a movimentação (Rastreabilidade total)
    INSERT INTO log_auditoria (id_usuario, acao, tabela_afetada, id_registro, comentario)
    VALUES (p_id_usuario, 'TRANSFERENCIA_LEITO', 'internacao', p_id_internacao, 
            CONCAT('Paciente movido do leito ', v_id_leito_antigo, ' para o ', p_id_leito_novo));

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_triagem_finalizar_manchester` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_triagem_finalizar_manchester`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa BIGINT,
  IN p_cor_real ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
  IN p_linha_assistencial VARCHAR(50),
  IN p_observacao TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_local_operacional BIGINT;
  DECLARE v_tipo_local VARCHAR(50);

  DECLARE v_tempo_max INT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_triagem_finalizar_manchester', v_id_usuario);
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT su.id_usuario, su.id_local_operacional
    INTO v_id_usuario, v_id_local_operacional
  FROM sessao_usuario su
  WHERE su.id_sessao_usuario = p_id_sessao_usuario
    AND su.ativo = 1
  LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA', 'Sessao inexistente ou inativa');
  END IF;

  SELECT lo.tipo INTO v_tipo_local
  FROM local_operacional lo
  WHERE lo.id_local_operacional = v_id_local_operacional
  LIMIT 1;

  IF v_tipo_local <> 'TRIAGEM' THEN
    CALL sp_raise('LOCAL_INVALIDO', 'Esta acao so pode ser executada na TRIAGEM');
  END IF;

  IF p_cor_real IS NULL THEN
    SET p_cor_real = 'AZUL';
  END IF;

  -- tempo_max (min) via tabela de risco se existir; fallback por CASE
  SET v_tempo_max = NULL;
  SELECT tempo_max INTO v_tempo_max
  FROM classificacao_risco
  WHERE cor = p_cor_real
  LIMIT 1;

  IF v_tempo_max IS NULL THEN
    SET v_tempo_max =
      (CASE p_cor_real
        WHEN 'VERMELHO' THEN 0
        WHEN 'LARANJA'  THEN 10
        WHEN 'AMARELO'  THEN 60
        WHEN 'VERDE'    THEN 120
        ELSE 240
      END);
  END IF;

  UPDATE ffa
     SET classificacao_manchester = p_cor_real,
         classificacao_cor = p_cor_real,
         linha_assistencial = COALESCE(NULLIF(p_linha_assistencial,''), linha_assistencial, 'PA'),
         tempo_limite = DATE_ADD(NOW(), INTERVAL v_tempo_max MINUTE),
         id_usuario_alteracao = v_id_usuario,
         atualizado_em = NOW()
   WHERE id = p_id_ffa;

  -- finaliza fila_operacional TRIAGEM
  UPDATE fila_operacional
     SET substatus = 'FINALIZADO',
         prioridade = p_cor_real,
         data_fim = NOW(),
         id_responsavel = COALESCE(id_responsavel, v_id_usuario),
         id_local_operacional = COALESCE(id_local_operacional, v_id_local_operacional),
         observacao = COALESCE(observacao, p_observacao)
   WHERE id_ffa = p_id_ffa
     AND tipo = 'TRIAGEM'
     AND substatus IN ('AGUARDANDO','EM_EXECUCAO','CRITICO','EM_OBSERVACAO');

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,
    'FFA',
    p_id_ffa,
    'TRIAGEM_FINALIZAR',
    CONCAT('Manchester real=', p_cor_real, ', tempo_max_min=', v_tempo_max)
  );

  IF p_observacao IS NOT NULL AND LENGTH(TRIM(p_observacao)) > 0 THEN
    INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
    VALUES ('FFA', p_id_ffa, 'TRIAGEM_OBS', p_observacao, v_id_usuario, NULL, 'TRIAGEM', NOW());
  END IF;

  COMMIT;

  SELECT p_id_ffa AS id_ffa, p_cor_real AS manchester_real, v_tempo_max AS tempo_max_min, 'OK' AS resultado;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_triagem_iniciar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_triagem_iniciar`(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_ffa BIGINT,
  IN p_observacao TEXT
)
BEGIN
  DECLARE v_id_usuario BIGINT;
  DECLARE v_id_unidade BIGINT;
  DECLARE v_id_local_operacional BIGINT;
  DECLARE v_tipo_local VARCHAR(50);

  DECLARE v_prioridade ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL');

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_triagem_iniciar', v_id_usuario);
    RESIGNAL;
  END;

  START TRANSACTION;

  SELECT su.id_usuario, su.id_unidade, su.id_local_operacional
    INTO v_id_usuario, v_id_unidade, v_id_local_operacional
  FROM sessao_usuario su
  WHERE su.id_sessao_usuario = p_id_sessao_usuario
    AND su.ativo = 1
  LIMIT 1;

  IF v_id_usuario IS NULL THEN
    CALL sp_raise('SESSAO_INVALIDA', 'Sessao inexistente ou inativa');
  END IF;

  SELECT lo.tipo INTO v_tipo_local
  FROM local_operacional lo
  WHERE lo.id_local_operacional = v_id_local_operacional
  LIMIT 1;

  IF v_tipo_local <> 'TRIAGEM' THEN
    CALL sp_raise('LOCAL_INVALIDO', 'Esta acao so pode ser executada na TRIAGEM');
  END IF;

  -- prioridade inicial = cor real (ou AZUL)
  SELECT COALESCE(f.classificacao_manchester, 'AZUL') INTO v_prioridade
  FROM ffa f
  WHERE f.id = p_id_ffa
  LIMIT 1;

  IF v_prioridade IS NULL THEN
    CALL sp_raise('FFA_NAO_ENCONTRADA', CONCAT('id=', p_id_ffa));
  END IF;

  -- se já existir fila ativa de triagem, só marca em execução
  IF EXISTS (
    SELECT 1 FROM fila_operacional
     WHERE id_ffa = p_id_ffa
       AND tipo = 'TRIAGEM'
       AND substatus IN ('AGUARDANDO','EM_EXECUCAO','CRITICO','EM_OBSERVACAO')
     LIMIT 1
  ) THEN
    UPDATE fila_operacional
       SET substatus = 'EM_EXECUCAO',
           data_inicio = COALESCE(data_inicio, NOW()),
           id_responsavel = v_id_usuario,
           id_local_operacional = v_id_local_operacional,
           observacao = COALESCE(observacao, p_observacao)
     WHERE id_ffa = p_id_ffa
       AND tipo = 'TRIAGEM'
       AND substatus IN ('AGUARDANDO','EM_EXECUCAO','CRITICO','EM_OBSERVACAO')
     LIMIT 1;
  ELSE
    INSERT INTO fila_operacional (
      id_ffa, tipo, substatus, prioridade, data_entrada, data_inicio, id_responsavel, observacao, id_local_operacional
    ) VALUES (
      p_id_ffa, 'TRIAGEM', 'EM_EXECUCAO', v_prioridade, NOW(), NOW(), v_id_usuario, p_observacao, v_id_local_operacional
    );
  END IF;

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,
    'FFA',
    p_id_ffa,
    'TRIAGEM_INICIAR',
    CONCAT('fila_operacional TRIAGEM em execucao (local=', v_id_local_operacional, ')')
  );

  COMMIT;

  SELECT p_id_ffa AS id_ffa, 'OK' AS resultado;
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_tv_rotativo_listar_telas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_tv_rotativo_listar_telas`(
  IN p_id_sessao_usuario BIGINT
)
BEGIN
  DECLARE v_ok INT DEFAULT 0;

  SELECT 1 INTO v_ok
    FROM sessao_usuario su
   WHERE su.id_sessao_usuario=p_id_sessao_usuario AND su.ativo=1
   LIMIT 1;

  IF v_ok = 0 THEN
    CALL sp_raise('SESSAO_INVALIDA','Sessão inexistente/inativa');
  END IF;

  SELECT * FROM vw_tv_rotativo_telas_ativas ORDER BY ordem;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_tv_rotativo_seed_default` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_tv_rotativo_seed_default`(IN p_codigo_tv VARCHAR(50))
BEGIN
  DECLARE v_id_tv BIGINT;

  SELECT id_painel INTO v_id_tv
    FROM painel
   WHERE codigo = p_codigo_tv
   LIMIT 1;

  IF v_id_tv IS NULL THEN
    CALL sp_raise('TV_ROTATIVO_INEXISTENTE', CONCAT('painel.codigo=', COALESCE(p_codigo_tv,'NULL')));
  END IF;

  -- idempotente: limpa e recria
  DELETE FROM tv_rotativo_tela WHERE id_painel = v_id_tv;

  INSERT INTO tv_rotativo_tela (id_painel, codigo_tela, ordem, duracao_seg, ativo)
  VALUES
    (v_id_tv,'MEDICO_CLINICO',1,120,1),
    (v_id_tv,'MEDICACAO',     2,120,1),
    (v_id_tv,'COLETA',        3,120,1),
    (v_id_tv,'MEDICO_CLINICO',4,120,1),
    (v_id_tv,'RX',            5,120,1),
    (v_id_tv,'TRIAGEM',       6,120,1),
    (v_id_tv,'RECEPCAO',      7,120,1),
    (v_id_tv,'MEDICO_PEDI',   8,120,1);
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_reset_padrao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_reset_padrao`(
    IN p_id_usuario BIGINT
)
BEGIN
    -- Reset para o login em MD5 e força a troca no próximo acesso
    UPDATE usuario 
    SET senha = MD5(login), 
        forcar_troca_senha = 1
    WHERE id_usuario = p_id_usuario;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_reset_senha` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_reset_senha`(
    IN p_id_usuario BIGINT,
    IN p_id_usuario_suporte BIGINT
)
BEGIN
    -- Atualiza a senha para ser exatamente igual ao login
    UPDATE usuario 
    SET senha = MD5(login), -- Ou apenas login se não usar hash ainda
        alterado_em = NOW()
    WHERE id_usuario = p_id_usuario;

    -- Auditoria do Reset (Fundamental para conformidade)
    INSERT INTO log_auditoria (id_usuario, acao, tabela_afetada, id_registro, comentario)
    VALUES (p_id_usuario_suporte, 'RESET_SENHA', 'usuario', p_id_usuario, 'Senha resetada para o padrão (mesmo que o login)');

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_reset_senha_login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_reset_senha_login`(
    IN p_id_usuario BIGINT
)
BEGIN
    -- Atualiza a senha para ser igual ao login (usando MD5 para segurança)
    -- E já marca que o suporte alterou
    UPDATE usuario 
    SET senha = MD5(login), 
        forcar_troca_senha = 1 -- Coluna que adicionamos para segurança
    WHERE id_usuario = p_id_usuario;
    
    -- Registra no log de auditoria que você já tem no banco
    INSERT INTO log_auditoria (id_usuario, acao, tabela_afetada, id_registro, data_hora)
    VALUES (NULL, 'RESET_SENHA_PADRAO', 'usuario', p_id_usuario, NOW());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_validar_acesso_unidade` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validar_acesso_unidade`(
    IN p_id_usuario BIGINT,
    IN p_id_unidade BIGINT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM usuario_unidade 
        WHERE id_usuario = p_id_usuario AND id_unidade = p_id_unidade AND ativo = 1
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Acesso Negado: Usuário não alocado nesta unidade.';
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_verificar_exames_pendentes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_verificar_exames_pendentes`(
    IN p_id_ffa BIGINT
)
BEGIN
    -- Busca todos os exames do protocolo 30000... vinculados a este FFA
    SELECT 
        protocolo_interno, 
        status, 
        criado_em,
        CASE 
            WHEN status = 'FINALIZADO' THEN 'RESULTADO DISPONÍVEL'
            ELSE 'AGUARDANDO LABORATÓRIO'
        END AS alerta_clinico
    FROM lab_pedido 
    WHERE id_ffa = p_id_ffa;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp__ffa_criar_por_senha_core` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp__ffa_criar_por_senha_core`(
  IN  p_id_sessao_usuario BIGINT,
  IN  p_id_senha BIGINT,
  IN  p_id_usuario BIGINT,
  IN  p_id_unidade BIGINT,
  IN  p_id_local_operacional BIGINT,
  IN  p_layout VARCHAR(50),
  OUT o_id_ffa BIGINT,
  OUT o_gpat VARCHAR(30)
)
BEGIN
  DECLARE v_id_paciente BIGINT;
  DECLARE v_id_ffa_existente BIGINT;
  DECLARE v_id_pessoa BIGINT;
  DECLARE v_id_atendimento BIGINT;
  DECLARE v_layout VARCHAR(50);

  -- trava a senha (FOR UPDATE), e captura vínculos
  SELECT s.id_paciente, s.id_ffa
    INTO v_id_paciente, v_id_ffa_existente
  FROM senhas s
  WHERE s.id = p_id_senha
  FOR UPDATE;

  IF v_id_paciente IS NULL THEN
    CALL sp_raise('PACIENTE_INEXISTENTE', 'Complementacao obrigatoria antes de abrir FFA');
  END IF;

  IF v_id_ffa_existente IS NOT NULL THEN
    SET o_id_ffa = v_id_ffa_existente;
    -- tenta retornar o gpat existente
    SELECT f.gpat INTO o_gpat FROM ffa f WHERE f.id = v_id_ffa_existente LIMIT 1;
  ELSE

  -- pessoa do paciente
  SELECT p.id_pessoa INTO v_id_pessoa
  FROM paciente pa
  JOIN pessoa p ON p.id_pessoa = pa.id_pessoa
  WHERE pa.id = v_id_paciente
  LIMIT 1;

  IF v_id_pessoa IS NULL THEN
    CALL sp_raise('PESSOA_INCONSISTENTE', 'Paciente sem pessoa vinculada');
  END IF;

  SET o_gpat = fn_gera_protocolo(p_id_usuario);
  SET v_layout = COALESCE(NULLIF(p_layout,''), 'PA');

  -- atendimento (legado compatível)
  INSERT INTO atendimento (protocolo, id_pessoa, id_unidade, id_senha, status_atendimento, id_local_atual, data_abertura)
  VALUES (o_gpat, v_id_pessoa, p_id_unidade, p_id_senha, 'ABERTO', p_id_local_operacional, NOW());
  SET v_id_atendimento = LAST_INSERT_ID();

  -- FFA
  INSERT INTO ffa (
    id_atendimento,
    id_paciente,
    gpat,
    status,
    layout,
    id_usuario_criacao,
    id_usuario_alteracao,
    criado_em,
    atualizado_em,
    classificacao_manchester,
    linha_assistencial,
    id_senha,
    classificacao_cor,
    data_criacao
  ) VALUES (
    v_id_atendimento,
    v_id_paciente,
    o_gpat,
    'ABERTO',
    v_layout,
    p_id_usuario,
    p_id_usuario,
    NOW(),
    NOW(),
    'AZUL',
    'PA',
    p_id_senha,
    'AZUL',
    NOW()
  );

  SET o_id_ffa = LAST_INSERT_ID();

  UPDATE atendimento
     SET id_ffa = o_id_ffa
   WHERE id_atendimento = v_id_atendimento;

  UPDATE senhas
     SET id_ffa = o_id_ffa
   WHERE id = p_id_senha;

  CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,
    'FFA',
    o_id_ffa,
    'CRIAR_FFA_POR_SENHA',
    CONCAT('gpat=', o_gpat, ', id_senha=', p_id_senha, ', id_atendimento=', v_id_atendimento)
  );

  INSERT INTO eventos_fluxo (entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora)
  VALUES ('FFA', o_id_ffa, 'FFA_CRIADA', CONCAT('FFA criada por senha (gpat=', o_gpat, ')'), p_id_usuario, NULL, 'RECEPCAO', NOW());
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vw_agenda_disponibilidade`
--

/*!50001 DROP VIEW IF EXISTS `vw_agenda_disponibilidade`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_agenda_disponibilidade` AS select `d`.`id_disponibilidade` AS `id_disponibilidade`,`d`.`id_sistema` AS `id_sistema`,`d`.`id_unidade` AS `id_unidade`,`d`.`id_profissional` AS `id_profissional`,`d`.`id_local_operacional` AS `id_local_operacional`,`d`.`tipo` AS `tipo`,`d`.`inicio_em` AS `inicio_em`,`d`.`fim_em` AS `fim_em`,`d`.`recorrente` AS `recorrente`,`d`.`dia_semana` AS `dia_semana`,`d`.`ativo` AS `ativo`,`u`.`login` AS `profissional_login`,`lo`.`nome` AS `local_nome` from ((`agenda_disponibilidade` `d` join `usuario` `u` on((`u`.`id_usuario` = `d`.`id_profissional`))) left join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `d`.`id_local_operacional`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_agendamento_detalhado`
--

/*!50001 DROP VIEW IF EXISTS `vw_agendamento_detalhado`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_agendamento_detalhado` AS select `a`.`id_agendamento` AS `id_agendamento`,`a`.`id_sistema` AS `id_sistema`,`a`.`id_unidade` AS `id_unidade`,`a`.`id_local_operacional` AS `id_local_operacional`,`a`.`id_profissional` AS `id_profissional`,`a`.`id_paciente` AS `id_paciente`,`a`.`id_ffa` AS `id_ffa`,`a`.`id_senha` AS `id_senha`,`a`.`id_servico` AS `id_servico`,`s`.`codigo` AS `servico_codigo`,`s`.`nome` AS `servico_nome`,`s`.`tipo` AS `servico_tipo`,`a`.`inicio_em` AS `inicio_em`,`a`.`fim_em` AS `fim_em`,`a`.`status` AS `status`,`a`.`origem` AS `origem`,`a`.`observacao` AS `observacao`,`a`.`criado_em` AS `criado_em`,`a`.`atualizado_em` AS `atualizado_em`,`a`.`criado_por` AS `criado_por`,`a`.`id_sessao_criacao` AS `id_sessao_criacao`,`up`.`login` AS `profissional_login`,`uc`.`login` AS `criado_por_login` from (((`agendamentos` `a` join `servico_agendamento` `s` on((`s`.`id_servico` = `a`.`id_servico`))) left join `usuario` `up` on((`up`.`id_usuario` = `a`.`id_profissional`))) join `usuario` `uc` on((`uc`.`id_usuario` = `a`.`criado_por`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alerta_atraso_clinico`
--

/*!50001 DROP VIEW IF EXISTS `vw_alerta_atraso_clinico`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alerta_atraso_clinico` AS select `p`.`nome_completo` AS `nome_completo`,`f`.`classificacao_cor` AS `classificacao_cor`,`f`.`tempo_limite` AS `tempo_limite`,timediff(now(),`f`.`tempo_limite`) AS `tempo_atrasado` from ((`ffa` `f` join `atendimento` `a` on((`f`.`id_atendimento` = `a`.`id_atendimento`))) join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) where ((`f`.`status` = 'AGUARDANDO_MEDICO') and (now() > `f`.`tempo_limite`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_alerta_news`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_alerta_news`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_alerta_news` AS select `atendimento_sinais_vitais`.`id_atendimento` AS `id_atendimento`,((((case when (`atendimento_sinais_vitais`.`saturacao_o2` < 92) then 3 when (`atendimento_sinais_vitais`.`saturacao_o2` < 95) then 1 else 0 end) + (case when ((`atendimento_sinais_vitais`.`temperatura` < 35.1) or (`atendimento_sinais_vitais`.`temperatura` > 39.0)) then 3 else 0 end)) + (case when (`atendimento_sinais_vitais`.`pa_sistolica` < 90) then 3 when (`atendimento_sinais_vitais`.`pa_sistolica` < 100) then 2 else 0 end)) + (case when ((`atendimento_sinais_vitais`.`frequencia_cardiaca` > 130) or (`atendimento_sinais_vitais`.`frequencia_cardiaca` < 41)) then 3 else 0 end)) AS `pontuacao_gravidade`,`atendimento_sinais_vitais`.`data_registro` AS `data_registro` from `atendimento_sinais_vitais` where (`atendimento_sinais_vitais`.`data_registro` >= (now() - interval 24 hour)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_auditoria_faturamento`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_auditoria_faturamento`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_auditoria_faturamento` AS select `c`.`id` AS `conta_id`,`a`.`protocolo` AS `protocolo`,`cv`.`nome_fantasia` AS `convenio`,count(`e`.`id`) AS `qtd_exames`,`c`.`valor_total` AS `valor_total`,`c`.`status_conta` AS `status_conta` from (((`faturamento_conta_paciente` `c` join `atendimento` `a` on((`c`.`id_atendimento` = `a`.`id_atendimento`))) join `faturamento_convenios` `cv` on((`c`.`id_convenio` = `cv`.`id`))) left join `atendimento_pedidos_exame` `e` on((`a`.`id_atendimento` = `e`.`id_atendimento`))) group by `c`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_bi_custo_atendimento`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_bi_custo_atendimento`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_bi_custo_atendimento` AS select `a`.`id_atendimento` AS `id_atendimento`,`a`.`id_pessoa` AS `id_pessoa`,ifnull(sum((`ei`.`quantidade_saida` * `ac`.`valor_unitario_compra`)),0) AS `custo_total_insumos`,ifnull(`s`.`valor_sa`,0) AS `repasse_previsto_sus` from ((((`atendimento` `a` left join `estoque_movimentacao_itens` `ei` on((`a`.`id_atendimento` = `ei`.`id_atendimento`))) left join `estoque_almoxarifado_central` `ac` on((`ei`.`id_produto` = `ac`.`id_produto`))) left join `faturamento_producao_sus` `fps` on((`a`.`id_atendimento` = `fps`.`id_atendimento`))) left join `faturamento_sigtap` `s` on((`fps`.`id_sigtap` = `s`.`id`))) group by `a`.`id_atendimento`,`a`.`id_pessoa`,`s`.`valor_sa` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_bi_custos`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_bi_custos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_bi_custos` AS select `s`.`id_unidade` AS `id_unidade`,count(`s`.`id`) AS `qtd_atendimentos`,(select count(0) from (`atendimento_sinais_vitais` `sv` join `senhas` `s2` on((`s2`.`id_ffa` = `sv`.`id_atendimento`))) where (`s2`.`id_unidade` = `s`.`id_unidade`)) AS `total_medicoes` from `senhas` `s` group by `s`.`id_unidade` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_bi_gestao_publica`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_bi_gestao_publica`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_bi_gestao_publica` AS select `u`.`nome` AS `unidade`,count(distinct `a`.`id_atendimento`) AS `total_atendimentos`,count(distinct (case when (`t`.`classificacao_cor` = 'VERMELHO') then `t`.`id` end)) AS `casos_criticos`,avg(timestampdiff(MINUTE,`s`.`criada_em`,`a`.`data_abertura`)) AS `tempo_medio_espera_minutos` from (((`atendimento` `a` join `unidade` `u` on((`a`.`id_unidade` = `u`.`id_unidade`))) join `senhas` `s` on((`a`.`id_senha` = `s`.`id`))) left join `triagem_alpha` `t` on((`t`.`id_atendimento` = `a`.`id_atendimento`))) group by `u`.`id_unidade`,`u`.`nome` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_censo_hospitalar`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_censo_hospitalar`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_censo_hospitalar` AS select `u`.`nome` AS `unidade`,`l`.`tipo_leito` AS `tipo_leito`,count(`l`.`id_leito`) AS `total_leitos`,sum((case when (`l`.`status` = 'OCUPADO') then 1 else 0 end)) AS `ocupados`,sum((case when (`l`.`status` = 'LIVRE') then 1 else 0 end)) AS `disponiveis`,round(((sum((case when (`l`.`status` = 'OCUPADO') then 1 else 0 end)) / count(`l`.`id_leito`)) * 100),2) AS `taxa_ocupacao` from (`hospital_leitos` `l` join `unidade` `u` on((`l`.`id_unidade` = `u`.`id_unidade`))) group by `u`.`id_unidade`,`l`.`tipo_leito` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_custo_atendimento`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_custo_atendimento`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_custo_atendimento` AS select `a`.`id_atendimento` AS `id_atendimento`,`p`.`nome_completo` AS `paciente`,ifnull(sum(`e`.`valor_unitario_compra`),0) AS `custo_total_insumos`,`f`.`status` AS `status_final` from ((((`atendimento` `a` join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) join `ffa` `f` on((`a`.`id_atendimento` = `f`.`id_atendimento`))) join `prescricao_medica` `pm` on((`a`.`id_atendimento` = `pm`.`id_atendimento`))) left join `estoque_almoxarifado_central` `e` on((`pm`.`item_nome` = `e`.`lote`))) group by `a`.`id_atendimento`,`p`.`nome_completo`,`f`.`status` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_eficiencia_hospitalar`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_eficiencia_hospitalar`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_eficiencia_hospitalar` AS select `f`.`id` AS `ffa_id`,`p`.`id_pessoa` AS `id_pessoa`,`f`.`status` AS `status_atual`,`f`.`classificacao_cor` AS `classificacao_cor`,`f`.`criado_em` AS `entrada`,timestampdiff(HOUR,`f`.`criado_em`,now()) AS `horas_permanencia`,(case when (timestampdiff(HOUR,`f`.`criado_em`,now()) > 6) then 'CRÍTICO' when (timestampdiff(HOUR,`f`.`criado_em`,now()) > 3) then 'ALERTA' else 'NORMAL' end) AS `risco_operacional` from ((`ffa` `f` join `atendimento` `a` on((`f`.`id_atendimento` = `a`.`id_atendimento`))) join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) where (`f`.`status` not in ('FINALIZADO','ALTA','OBITO')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_financeiro_mensal`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_financeiro_mensal`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_financeiro_mensal` AS select `u`.`login` AS `medico`,count(`r`.`id`) AS `total_atendimentos`,sum(`r`.`valor_final_medico`) AS `total_a_pagar`,date_format(`r`.`data_competencia`,'%m/%Y') AS `mes_referencia` from (`financeiro_repasse_medico` `r` join `usuario` `u` on((`r`.`id_usuario_medico` = `u`.`id_usuario`))) group by `u`.`id_usuario`,`mes_referencia` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_kpi_reinternacao`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_kpi_reinternacao`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_kpi_reinternacao` AS select `a1`.`id_pessoa` AS `id_pessoa`,`a1`.`id_atendimento` AS `id_alta_anterior`,`a2`.`id_atendimento` AS `id_retorno`,`a1`.`data_fechamento` AS `data_alta_anterior`,`a2`.`data_abertura` AS `data_retorno`,timestampdiff(HOUR,`a1`.`data_fechamento`,`a2`.`data_abertura`) AS `horas_intervalo` from (`atendimento` `a1` join `atendimento` `a2` on((`a1`.`id_pessoa` = `a2`.`id_pessoa`))) where ((`a1`.`id_atendimento` <> `a2`.`id_atendimento`) and (`a1`.`status_atendimento` = 'FINALIZADO') and (`a2`.`data_abertura` > `a1`.`data_fechamento`) and (timestampdiff(HOUR,`a1`.`data_fechamento`,`a2`.`data_abertura`) <= 24)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_line_gestao`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_line_gestao`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_line_gestao` AS select `s`.`id` AS `senha_id`,`p`.`nome_completo` AS `paciente`,`s`.`prioridade` AS `prioridade`,`s`.`status` AS `status`,`s`.`id_servico` AS `id_servico`,`s`.`id_unidade` AS `id_unidade`,timestampdiff(MINUTE,`s`.`criada_em`,now()) AS `espera_minutos` from ((`senhas` `s` left join `atendimento` `a` on((`a`.`id_senha` = `s`.`id`))) left join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) where (`s`.`status` not in ('FINALIZADO','CANCELADO','CONCLUIDO')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_line_resumo`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_line_resumo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_line_resumo` AS select `senhas`.`id_unidade` AS `id_unidade`,count((case when ((`senhas`.`lane` = 'ADULTO') and (`senhas`.`status` = 'AGUARDANDO')) then 1 end)) AS `total_adulto_espera`,count((case when ((`senhas`.`lane` = 'PEDIATRICO') and (`senhas`.`status` = 'AGUARDANDO')) then 1 end)) AS `total_pediatrico_espera`,count((case when ((`senhas`.`lane` = 'PRIORITARIO') and (`senhas`.`status` = 'AGUARDANDO')) then 1 end)) AS `total_prioritario_espera`,count((case when ((`senhas`.`tipo_atendimento` = 'EMERGENCIA') and (`senhas`.`status` = 'CHAMANDO')) then 1 end)) AS `emergencias_em_curso`,avg(timestampdiff(MINUTE,`senhas`.`criada_em`,now())) AS `tempo_medio_espera_geral` from `senhas` where (`senhas`.`status` not in ('FINALIZADO','CANCELADO')) group by `senhas`.`id_unidade` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_mapa_calor_setores`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_mapa_calor_setores`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_mapa_calor_setores` AS select `senhas`.`lane` AS `setor`,`senhas`.`status` AS `status`,count(0) AS `quantidade`,round(avg(timestampdiff(MINUTE,`senhas`.`criada_em`,now())),0) AS `tempo_medio_espera_atual` from `senhas` where ((`senhas`.`status` not in ('FINALIZADO','CANCELADO')) and (cast(`senhas`.`criada_em` as date) = curdate())) group by `senhas`.`lane`,`senhas`.`status` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_painel_chamada`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_painel_chamada`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_painel_chamada` AS select `s`.`codigo` AS `senha`,`s`.`lane` AS `lane`,`s`.`status` AS `status`,date_format(`s`.`criada_em`,'%H:%i') AS `hora_gerada`,timestampdiff(MINUTE,coalesce(`s`.`posicionado_em`,`s`.`criada_em`),now()) AS `tempo_espera_min` from `senhas` `s` where ((`s`.`status` in ('CHAMANDO','AGUARDANDO')) and (cast(`s`.`data_ref` as date) = curdate())) order by (case when (`s`.`status` = 'CHAMANDO') then 1 else 2 end),`s`.`prioridade` desc,coalesce(`s`.`posicionado_em`,`s`.`criada_em`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_painel_espera`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_painel_espera`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_painel_espera` AS select `s`.`codigo` AS `senha_formatada`,`s`.`lane` AS `lane`,`s`.`status` AS `status`,`s`.`prioridade` AS `prioridade`,date_format(coalesce(`s`.`posicionado_em`,`s`.`criada_em`),'%H:%i') AS `hora_chegada`,timestampdiff(MINUTE,coalesce(`s`.`posicionado_em`,`s`.`criada_em`),now()) AS `minutos_espera` from `senhas` `s` where ((`s`.`status` in ('AGUARDANDO','CHAMANDO')) and (cast(`s`.`data_ref` as date) = curdate())) order by `s`.`prioridade` desc,coalesce(`s`.`posicionado_em`,`s`.`criada_em`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_passagem_plantao`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_passagem_plantao`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_passagem_plantao` AS select `l`.`identificacao` AS `leito`,`p`.`nome_completo` AS `paciente`,`f`.`status` AS `status_clinico`,(select `paciente_alertas`.`descricao` from `paciente_alertas` where (`paciente_alertas`.`id_pessoa` = `p`.`id_pessoa`) limit 1) AS `alerta_principal`,(select `prescricao_medica`.`item_nome` from `prescricao_medica` where ((`prescricao_medica`.`id_atendimento` = `f`.`id_atendimento`) and (`prescricao_medica`.`status` = 'ATIVA')) limit 1) AS `ultima_prescricao`,timestampdiff(HOUR,`f`.`criado_em`,now()) AS `horas_de_internacao` from (((`ffa` `f` join `atendimento` `a` on((`f`.`id_atendimento` = `a`.`id_atendimento`))) join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) left join `config_leitos` `l` on((`l`.`id_atendimento_atual` = `a`.`id_atendimento`))) where (`f`.`status` not in ('FINALIZADO','CANCELADO')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_performance_fila`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_performance_fila`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_performance_fila` AS select `s`.`id_unidade` AS `id_unidade`,`s`.`tipo_atendimento` AS `tipo_atendimento`,count(`s`.`id`) AS `total_senhas_hoje`,round(avg(timestampdiff(MINUTE,`s`.`criada_em`,`x`.`primeira_chamada_em`)),0) AS `avg_espera_chamada_min`,round(avg(timestampdiff(MINUTE,`x`.`inicio_em`,`x`.`fim_em`)),0) AS `avg_duracao_atendimento_min`,max(timestampdiff(MINUTE,`s`.`criada_em`,now())) AS `maior_espera_atual_min` from (`senhas` `s` left join (select `se`.`id_senha` AS `id_senha`,min((case when (`se`.`status_novo` = 'CHAMANDO') then `se`.`criado_em` end)) AS `primeira_chamada_em`,min((case when (`se`.`status_novo` = 'EM_ATENDIMENTO') then `se`.`criado_em` end)) AS `inicio_em`,min((case when (`se`.`status_novo` in ('FINALIZADO','ENCERRADO','ATENDIDO')) then `se`.`criado_em` end)) AS `fim_em` from `senha_eventos` `se` group by `se`.`id_senha`) `x` on((`x`.`id_senha` = `s`.`id`))) where ((cast(`s`.`criada_em` as date) = curdate()) and (`s`.`status` <> 'CANCELADO') and (`x`.`primeira_chamada_em` is not null)) group by `s`.`id_unidade`,`s`.`tipo_atendimento` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_plantao_atual`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_plantao_atual`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_plantao_atual` AS select `u`.`login` AS `medico`,`e`.`turno` AS `turno`,`e`.`status_presenca` AS `status_presenca`,`un`.`nome` AS `unidade` from ((`escala_medica` `e` join `usuario` `u` on((`e`.`id_usuario_medico` = `u`.`id_usuario`))) join `unidade` `un` on((`e`.`id_unidade` = `un`.`id_unidade`))) where (`e`.`data_plantao` = curdate()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_produtividade_plantoes`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_produtividade_plantoes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_produtividade_plantoes` AS select `u`.`login` AS `profissional`,count(`f`.`id`) AS `total_atendimentos`,sec_to_time(avg(time_to_sec(timediff(`f`.`atualizado_em`,`f`.`criado_em`)))) AS `tempo_medio_prontuario`,sum((case when (`f`.`classificacao_cor` = 'VERMELHO') then 1 else 0 end)) AS `casos_criticos`,min(`f`.`criado_em`) AS `primeiro_movimento`,max(`f`.`atualizado_em`) AS `ultimo_movimento` from (`ffa` `f` join `usuario` `u` on((`f`.`id_usuario_criacao` = `u`.`id_usuario`))) where (`f`.`status` in ('FINALIZADO','ALTA','INTERNACAO')) group by `u`.`id_usuario`,`u`.`login` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_alpha_visao_360_paciente`
--

/*!50001 DROP VIEW IF EXISTS `vw_alpha_visao_360_paciente`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_alpha_visao_360_paciente` AS select `p`.`id_pessoa` AS `id_pessoa`,`p`.`nome_completo` AS `paciente_nome`,(select group_concat(`paciente_alertas`.`descricao` separator ',') from `paciente_alertas` where (`paciente_alertas`.`id_pessoa` = `p`.`id_pessoa`)) AS `alertas_ativos`,`sv`.`pa_sistolica` AS `pa_sistolica`,`sv`.`pa_diastolica` AS `pa_diastolica`,`sv`.`temperatura` AS `temperatura`,`sv`.`saturacao_o2` AS `saturacao_o2`,`sv`.`data_registro` AS `ultima_medicao` from (((`atendimento` `a` join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) join `ffa` `f` on((`f`.`id_atendimento` = `a`.`id_atendimento`))) left join `atendimento_sinais_vitais` `sv` on((`a`.`id_atendimento` = `sv`.`id_atendimento`))) where ((`f`.`status` not in ('FINALIZADO','CANCELADO')) and ((`sv`.`id` = (select max(`atendimento_sinais_vitais`.`id`) from `atendimento_sinais_vitais` where (`atendimento_sinais_vitais`.`id_atendimento` = `a`.`id_atendimento`))) or (`sv`.`id` is null))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_assistencia_social_alertas`
--

/*!50001 DROP VIEW IF EXISTS `vw_assistencia_social_alertas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_assistencia_social_alertas` AS select `p`.`nome_completo` AS `nome_completo`,`i`.`tipo` AS `tipo`,`i`.`data_entrada` AS `data_entrada`,(to_days(now()) - to_days(`i`.`data_entrada`)) AS `dias_internado`,`i`.`previsao_alta` AS `previsao_alta`,`med`.`nome_completo` AS `medico_responsavel` from (((((`internacao` `i` join `ffa` `f` on((`i`.`id_ffa` = `f`.`id`))) join `atendimento` `a` on((`f`.`id` = `a`.`id_ffa`))) join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) left join `usuario` `u_med` on((`i`.`id_medico_responsavel` = `u_med`.`id_usuario`))) left join `pessoa` `med` on((`u_med`.`id_pessoa` = `med`.`id_pessoa`))) where ((`i`.`status` = 'ATIVA') and ((to_days(now()) - to_days(`i`.`data_entrada`)) > 3)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_auditoria_exames_heranca`
--

/*!50001 DROP VIEW IF EXISTS `vw_auditoria_exames_heranca`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_auditoria_exames_heranca` AS select `ep`.`codigo_interno` AS `etiqueta_lab`,`s`.`id` AS `senha_origem`,`f`.`gpat` AS `gpat_ffa`,`a`.`protocolo` AS `atendimento_protocolo`,`p`.`nome_completo` AS `paciente`,`ep`.`status` AS `situacao_exame`,`ep`.`criado_em` AS `data_solicitacao` from ((((`exame_pedido` `ep` join `senhas` `s` on((`ep`.`id_senha` = `s`.`id`))) join `ffa` `f` on((`ep`.`id_ffa` = `f`.`id`))) join `atendimento` `a` on((`ep`.`id_atendimento` = `a`.`id_atendimento`))) join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_auditoria_faturamento_farmacia`
--

/*!50001 DROP VIEW IF EXISTS `vw_auditoria_faturamento_farmacia`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_auditoria_faturamento_farmacia` AS select `a`.`id_atendimento` AS `id_atendimento`,`p`.`nome_completo` AS `paciente`,`fm`.`nome_comercial` AS `medicamento`,`df`.`quantidade_dispensada` AS `quantidade_dispensada`,`u`.`login` AS `farmaceutico`,`df`.`data_hora_dispensacao` AS `data_hora_dispensacao` from (((((`dispensacao_farmacia` `df` join `farmaco` `fm` on((`df`.`id_farmaco` = `fm`.`id_farmaco`))) join `prescricao` `pr` on((`df`.`id_prescricao` = `pr`.`id_prescricao`))) join `atendimento` `a` on((`pr`.`id_atendimento` = `a`.`id_atendimento`))) join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) join `usuario` `u` on((`df`.`id_usuario_farmaceutico` = `u`.`id_usuario`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_censo_hospitalar_luxo`
--

/*!50001 DROP VIEW IF EXISTS `vw_censo_hospitalar_luxo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_censo_hospitalar_luxo` AS select `un`.`nome` AS `unidade`,`un`.`tipo` AS `tipo_unidade`,`s`.`nome` AS `setor`,`l`.`identificacao` AS `leito`,`l`.`status` AS `situacao_leito`,(case when (`i`.`status` = 'ATIVA') then `p`.`nome_completo` else 'DISPONÍVEL' end) AS `paciente`,`i`.`precaucao` AS `precaucao`,`i`.`tipo` AS `modalidade`,(case when (`i`.`status` = 'ATIVA') then (to_days(now()) - to_days(`i`.`data_entrada`)) else 0 end) AS `dias_internado` from ((((((`leito` `l` join `setor` `s` on((`l`.`id_setor` = `s`.`id_setor`))) join `unidade` `un` on((`s`.`id_unidade` = `un`.`id_unidade`))) left join `internacao` `i` on(((`l`.`id_leito` = `i`.`id_leito`) and (`i`.`status` = 'ATIVA')))) left join `ffa` `f` on((`i`.`id_ffa` = `f`.`id`))) left join `atendimento` `a` on((`f`.`id_atendimento` = `a`.`id_atendimento`))) left join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) order by `un`.`nome`,`s`.`nome`,`l`.`identificacao` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_estatistica_evasao_totem`
--

/*!50001 DROP VIEW IF EXISTS `vw_estatistica_evasao_totem`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_estatistica_evasao_totem` AS select count(`senhas`.`id`) AS `total_senhas`,sum((case when ((`senhas`.`id_paciente` is null) and (`senhas`.`status` = 'CANCELADO')) then 1 else 0 end)) AS `desistencias_totem`,round(((sum((case when ((`senhas`.`id_paciente` is null) and (`senhas`.`status` = 'CANCELADO')) then 1 else 0 end)) / count(`senhas`.`id`)) * 100),2) AS `porcentagem_evasao` from `senhas` where (`senhas`.`criada_em` > (now() - interval 24 hour)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

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
/*!50001 VIEW `vw_farmacia_dashboard_completo` AS select `f`.`id_farmaco` AS `id_farmaco`,`f`.`nome_comercial` AS `nome_comercial`,`e`.`quantidade_atual` AS `quantidade_atual`,`FN_DIAS_PARA_VENCIMENTO`(`fl`.`data_validade`) AS `dias_para_vencer`,(case when (`FN_DIAS_PARA_VENCIMENTO`(`fl`.`data_validade`) < 0) then 'VENCIDO' when (`FN_DIAS_PARA_VENCIMENTO`(`fl`.`data_validade`) <= 30) then 'CRITICO' else 'OK' end) AS `nivel_risco` from ((`estoque_local` `e` join `farmaco` `f` on((`f`.`id_farmaco` = `e`.`id_farmaco`))) left join `farmaco_lote` `fl` on((`fl`.`id_farmaco` = `f`.`id_farmaco`))) */;
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
-- Final view structure for view `vw_farmacia_medicacao_pendentes`
--

/*!50001 DROP VIEW IF EXISTS `vw_farmacia_medicacao_pendentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_farmacia_medicacao_pendentes` AS select `o`.`id` AS `id_ordem`,`i`.`id_item` AS `id_item`,`o`.`id_ffa` AS `id_ffa`,`o`.`status` AS `ordem_status`,`o`.`prioridade` AS `ordem_prioridade`,`i`.`status` AS `item_status`,`i`.`id_farmaco` AS `id_farmaco`,`f`.`nome_comercial` AS `farmaco_nome`,`i`.`dose` AS `dose`,`i`.`via` AS `via`,`i`.`posologia` AS `posologia`,`i`.`dias` AS `dias`,`i`.`quantidade_total` AS `quantidade_total`,coalesce(`d`.`qtd_dispensada`,0) AS `quantidade_dispensada`,(`i`.`quantidade_total` - coalesce(`d`.`qtd_dispensada`,0)) AS `quantidade_pendente`,`fa`.`status` AS `ffa_status`,`fa`.`gpat` AS `gpat`,`s`.`codigo` AS `senha_codigo`,`p`.`nome_completo` AS `paciente_nome`,`p`.`nome_social` AS `paciente_nome_social`,`o`.`criado_em` AS `criado_em` from (((((((`ordem_assistencial` `o` join `ordem_assistencial_item` `i` on((`i`.`id_ordem` = `o`.`id`))) join `farmaco` `f` on((`f`.`id_farmaco` = `i`.`id_farmaco`))) join `ffa` `fa` on((`fa`.`id` = `o`.`id_ffa`))) left join `senhas` `s` on((`s`.`id` = `fa`.`id_senha`))) left join `paciente` `pa` on((`pa`.`id` = `fa`.`id_paciente`))) left join `pessoa` `p` on((`p`.`id_pessoa` = `pa`.`id_pessoa`))) left join (select `dispensacao_medicacao`.`id_item` AS `id_item`,sum(`dispensacao_medicacao`.`quantidade`) AS `qtd_dispensada` from `dispensacao_medicacao` where (`dispensacao_medicacao`.`id_item` is not null) group by `dispensacao_medicacao`.`id_item`) `d` on((`d`.`id_item` = `i`.`id_item`))) where (((`o`.`tipo_ordem` collate utf8mb4_general_ci) = 'MEDICACAO') and ((`o`.`status` collate utf8mb4_general_ci) = 'ATIVA') and (`i`.`status` = 'ATIVO') and (coalesce(`d`.`qtd_dispensada`,0) < `i`.`quantidade_total`)) */;
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
/*!50001 VIEW `vw_farmaco_risco_sanitario` AS select `f`.`id_farmaco` AS `id_farmaco`,`f`.`nome_comercial` AS `nome_comercial`,`fl`.`id_lote` AS `id_lote`,`fl`.`data_validade` AS `data_validade`,`fn_dias_para_vencimento`(`fl`.`data_validade`) AS `dias_para_vencer`,(case when (`fn_dias_para_vencimento`(`fl`.`data_validade`) < 0) then 'VENCIDO' when (`fn_dias_para_vencimento`(`fl`.`data_validade`) <= 30) then 'CRITICO' else 'OK' end) AS `nivel_risco` from (`farmaco_lote` `fl` join `farmaco` `f` on((`f`.`id_farmaco` = `fl`.`id_farmaco`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_faturamento_gasoterapia_pendente`
--

/*!50001 DROP VIEW IF EXISTS `vw_faturamento_gasoterapia_pendente`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_faturamento_gasoterapia_pendente` AS select `a`.`protocolo` AS `protocolo`,`p`.`nome_completo` AS `paciente`,`g`.`tipo_gas` AS `tipo_gas`,`g`.`data_inicio` AS `data_inicio`,ifnull(`g`.`data_fim`,now()) AS `data_referencia`,timestampdiff(HOUR,`g`.`data_inicio`,ifnull(`g`.`data_fim`,now())) AS `total_horas`,(timestampdiff(MINUTE,`g`.`data_inicio`,ifnull(`g`.`data_fim`,now())) * `g`.`litros_por_minuto`) AS `total_litros_consumidos` from ((`gasoterapia_consumo` `g` join `atendimento` `a` on((`g`.`id_atendimento` = `a`.`id_atendimento`))) join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) where (`g`.`status` = 'EM_USO') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_fila_aguardando_recepcao`
--

/*!50001 DROP VIEW IF EXISTS `vw_fila_aguardando_recepcao`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_fila_aguardando_recepcao` AS select `senhas`.`id` AS `id_senha`,`senhas`.`codigo` AS `ticket`,`senhas`.`lane` AS `lane`,date_format(`senhas`.`criada_em`,'%H:%i') AS `hora_chegada`,timestampdiff(MINUTE,`senhas`.`criada_em`,now()) AS `tempo_espera_min` from `senhas` where ((`senhas`.`id_paciente` is null) and (`senhas`.`status` in ('AGUARDANDO','CHAMANDO','EM_COMPLEMENTACAO'))) order by (case when (`senhas`.`lane` = 'PRIORITARIO') then 1 else 2 end),`senhas`.`criada_em` */;
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
/*!50001 VIEW `vw_fila_enfermagem` AS select `oa`.`id` AS `id_ordem`,`oa`.`id_ffa` AS `id_ffa`,`oa`.`tipo_ordem` AS `tipo_ordem`,`oa`.`prioridade` AS `prioridade`,json_unquote(json_extract(`oa`.`payload_clinico`,'$.descricao')) AS `descricao`,`oa`.`iniciado_em` AS `iniciado_em` from `ordem_assistencial` `oa` where ((`oa`.`status` = 'ATIVA') and (`oa`.`tipo_ordem` in ('MEDICACAO','CUIDADO','DIETA','OXIGENIO'))) order by `oa`.`prioridade` desc,`oa`.`iniciado_em` */;
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
/*!50001 VIEW `vw_fila_farmacia` AS select `oa`.`id` AS `id_ordem`,`oa`.`id_ffa` AS `id_ffa`,coalesce(json_unquote(json_extract(`oa`.`payload_clinico`,'$.medicamento')),'N/A') AS `medicamento`,coalesce(json_unquote(json_extract(`oa`.`payload_clinico`,'$.dose')),'Conforme protocolo') AS `dose`,`oa`.`prioridade` AS `prioridade`,`oa`.`iniciado_em` AS `iniciado_em` from `ordem_assistencial` `oa` where ((`oa`.`status` = 'ATIVA') and (`oa`.`tipo_ordem` = 'MEDICACAO')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_fila_medica_priorizada`
--

/*!50001 DROP VIEW IF EXISTS `vw_fila_medica_priorizada`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_fila_medica_priorizada` AS select `f`.`id` AS `id_ficha`,`p`.`nome_completo` AS `paciente`,`f`.`classificacao_cor` AS `classificacao_cor`,date_format(`a`.`data_abertura`,'%H:%i') AS `hora_entrada`,timestampdiff(MINUTE,now(),`f`.`tempo_limite`) AS `minutos_para_vencer`,(case when (`f`.`tempo_limite` is null) then 'AGUARDANDO TRIAGEM' when (now() > `f`.`tempo_limite`) then 'ATRASADO' else 'NO PRAZO' end) AS `status_prazo` from ((`ffa` `f` join `atendimento` `a` on((`f`.`id_atendimento` = `a`.`id_atendimento`))) join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) where (`f`.`status` = 'AGUARDANDO_MEDICO') order by field(`f`.`classificacao_cor`,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),`a`.`data_abertura` */;
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
/*!50001 VIEW `vw_fila_operacional_atual` AS select `fo`.`id_fila` AS `id_fila`,`fo`.`id_ffa` AS `id_ffa`,`fo`.`tipo` AS `tipo`,`fo`.`substatus` AS `substatus`,`fo`.`prioridade` AS `prioridade_real`,`fo`.`data_entrada` AS `data_entrada`,`fo`.`data_inicio` AS `data_inicio`,`fo`.`data_fim` AS `data_fim`,`fo`.`id_local_operacional` AS `id_local_operacional`,`lo`.`nome` AS `local_nome`,`fo`.`nao_compareceu_em` AS `nao_compareceu_em`,`fo`.`retorno_permitido_ate` AS `retorno_permitido_ate`,`fo`.`retorno_utilizado` AS `retorno_utilizado`,`fo`.`retorno_em` AS `retorno_em`,(case when (`fo`.`nao_compareceu_em` is not null) then 1 else 0 end) AS `is_retorno`,(case `fo`.`prioridade` when 'VERMELHO' then 5 when 'LARANJA' then 4 when 'AMARELO' then 3 when 'VERDE' then 2 else 1 end) AS `prioridade_rank_real`,`cr`.`tempo_max` AS `tempo_max_min`,timestampdiff(MINUTE,`fo`.`data_entrada`,now()) AS `espera_min`,(case when ((`cr`.`tempo_max` is not null) and (`fo`.`substatus` = 'AGUARDANDO') and (timestampdiff(MINUTE,`fo`.`data_entrada`,now()) > `cr`.`tempo_max`)) then least(((case `fo`.`prioridade` when 'VERMELHO' then 5 when 'LARANJA' then 4 when 'AMARELO' then 3 when 'VERDE' then 2 else 1 end) + 1),5) else (case `fo`.`prioridade` when 'VERMELHO' then 5 when 'LARANJA' then 4 when 'AMARELO' then 3 when 'VERDE' then 2 else 1 end) end) AS `prioridade_rank_efetiva`,(case when ((`cr`.`tempo_max` is not null) and (`fo`.`substatus` = 'AGUARDANDO') and (timestampdiff(MINUTE,`fo`.`data_entrada`,now()) > `cr`.`tempo_max`)) then 1 else 0 end) AS `elevada_por_tempo`,(case when ((case when ((`cr`.`tempo_max` is not null) and (`fo`.`substatus` = 'AGUARDANDO') and (timestampdiff(MINUTE,`fo`.`data_entrada`,now()) > `cr`.`tempo_max`)) then least(((case `fo`.`prioridade` when 'VERMELHO' then 5 when 'LARANJA' then 4 when 'AMARELO' then 3 when 'VERDE' then 2 else 1 end) + 1),5) else (case `fo`.`prioridade` when 'VERMELHO' then 5 when 'LARANJA' then 4 when 'AMARELO' then 3 when 'VERDE' then 2 else 1 end) end) = 5) then 'VERMELHO' when ((case when ((`cr`.`tempo_max` is not null) and (`fo`.`substatus` = 'AGUARDANDO') and (timestampdiff(MINUTE,`fo`.`data_entrada`,now()) > `cr`.`tempo_max`)) then least(((case `fo`.`prioridade` when 'VERMELHO' then 5 when 'LARANJA' then 4 when 'AMARELO' then 3 when 'VERDE' then 2 else 1 end) + 1),5) else (case `fo`.`prioridade` when 'VERMELHO' then 5 when 'LARANJA' then 4 when 'AMARELO' then 3 when 'VERDE' then 2 else 1 end) end) = 4) then 'LARANJA' when ((case when ((`cr`.`tempo_max` is not null) and (`fo`.`substatus` = 'AGUARDANDO') and (timestampdiff(MINUTE,`fo`.`data_entrada`,now()) > `cr`.`tempo_max`)) then least(((case `fo`.`prioridade` when 'VERMELHO' then 5 when 'LARANJA' then 4 when 'AMARELO' then 3 when 'VERDE' then 2 else 1 end) + 1),5) else (case `fo`.`prioridade` when 'VERMELHO' then 5 when 'LARANJA' then 4 when 'AMARELO' then 3 when 'VERDE' then 2 else 1 end) end) = 3) then 'AMARELO' when ((case when ((`cr`.`tempo_max` is not null) and (`fo`.`substatus` = 'AGUARDANDO') and (timestampdiff(MINUTE,`fo`.`data_entrada`,now()) > `cr`.`tempo_max`)) then least(((case `fo`.`prioridade` when 'VERMELHO' then 5 when 'LARANJA' then 4 when 'AMARELO' then 3 when 'VERDE' then 2 else 1 end) + 1),5) else (case `fo`.`prioridade` when 'VERMELHO' then 5 when 'LARANJA' then 4 when 'AMARELO' then 3 when 'VERDE' then 2 else 1 end) end) = 2) then 'VERDE' else 'AZUL' end) AS `prioridade_efetiva`,`pes`.`nome_completo` AS `paciente_nome` from (((((`fila_operacional` `fo` left join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `fo`.`id_local_operacional`))) left join `classificacao_risco` `cr` on((`cr`.`cor` = `fo`.`prioridade`))) left join `ffa` `f` on((`f`.`id` = `fo`.`id_ffa`))) left join `paciente` `pa` on((`pa`.`id` = `f`.`id_paciente`))) left join `pessoa` `pes` on((`pes`.`id_pessoa` = `pa`.`id_pessoa`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_fila_operacional_manchester`
--

/*!50001 DROP VIEW IF EXISTS `vw_fila_operacional_manchester`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_fila_operacional_manchester` AS select `fo`.`id_fila` AS `id_fila`,`fo`.`id_ffa` AS `id_ffa`,`fo`.`tipo` AS `tipo`,`fo`.`substatus` AS `substatus`,`fo`.`prioridade` AS `prioridade_real`,`fo`.`data_entrada` AS `data_entrada`,`fo`.`data_inicio` AS `data_inicio`,`fo`.`data_fim` AS `data_fim`,`fo`.`id_responsavel` AS `id_responsavel`,`fo`.`id_local` AS `id_local`,`cr`.`tempo_max` AS `tempo_max_min`,timestampdiff(MINUTE,`fo`.`data_entrada`,now()) AS `minutos_espera`,(case when (`cr`.`tempo_max` is null) then 0 when (timestampdiff(MINUTE,`fo`.`data_entrada`,now()) > `cr`.`tempo_max`) then 1 else 0 end) AS `elevou_por_tempo`,(case when (`cr`.`tempo_max` is null) then `fo`.`prioridade` when (timestampdiff(MINUTE,`fo`.`data_entrada`,now()) <= `cr`.`tempo_max`) then `fo`.`prioridade` else (case `fo`.`prioridade` when 'AZUL' then 'VERDE' when 'VERDE' then 'AMARELO' when 'AMARELO' then 'LARANJA' when 'LARANJA' then 'VERMELHO' else 'VERMELHO' end) end) AS `prioridade_efetiva`,(case when (`cr`.`tempo_max` is null) then (case `fo`.`prioridade` when 'VERMELHO' then 5 when 'LARANJA' then 4 when 'AMARELO' then 3 when 'VERDE' then 2 else 1 end) when (timestampdiff(MINUTE,`fo`.`data_entrada`,now()) <= `cr`.`tempo_max`) then (case `fo`.`prioridade` when 'VERMELHO' then 5 when 'LARANJA' then 4 when 'AMARELO' then 3 when 'VERDE' then 2 else 1 end) else (case when (`fo`.`prioridade` = 'AZUL') then 2 when (`fo`.`prioridade` = 'VERDE') then 3 when (`fo`.`prioridade` = 'AMARELO') then 4 else 5 end) end) AS `prioridade_rank_efetiva` from (`fila_operacional` `fo` left join `classificacao_risco` `cr` on((`cr`.`cor` = `fo`.`prioridade`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_fila_recepcao`
--

/*!50001 DROP VIEW IF EXISTS `vw_fila_recepcao`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_fila_recepcao` AS select `s`.`id` AS `id_senha`,`s`.`codigo` AS `ticket`,`s`.`lane` AS `lane`,`s`.`status` AS `status`,`s`.`id_local_operacional` AS `id_local_operacional`,date_format(coalesce(`s`.`posicionado_em`,`s`.`criada_em`),'%H:%i') AS `hora_chegada`,timestampdiff(MINUTE,coalesce(`s`.`posicionado_em`,`s`.`criada_em`),now()) AS `tempo_espera_min` from `senhas` `s` where (`s`.`status` in ('AGUARDANDO','CHAMANDO','EM_COMPLEMENTACAO')) order by (case when (`s`.`status` = 'CHAMANDO') then 1 else 2 end),`s`.`lane` desc,coalesce(`s`.`posicionado_em`,`s`.`criada_em`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_front_farmacia_alertas`
--

/*!50001 DROP VIEW IF EXISTS `vw_front_farmacia_alertas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_front_farmacia_alertas` AS select `f`.`id_farmaco` AS `id_farmaco`,`f`.`nome_comercial` AS `nome_comercial`,`f`.`principio_ativo` AS `principio_ativo`,`el`.`quantidade_atual` AS `estoque_real`,`el`.`min_estoque` AS `min_estoque`,(case when (`el`.`quantidade_atual` <= 0) then 'SEM ESTOQUE' when (`el`.`quantidade_atual` <= `el`.`min_estoque`) then 'ABAIXO DO MINIMO' else 'OK' end) AS `status_estoque`,(select count(0) from `farmaco_lote` `fl` where ((`fl`.`id_farmaco` = `f`.`id_farmaco`) and (`fl`.`data_validade` <= (curdate() + interval 30 day)))) AS `lotes_vencendo_30d` from (`farmaco` `f` join `estoque_local` `el` on((`f`.`id_farmaco` = `el`.`id_farmaco`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_gestao_chamados_hospitalares`
--

/*!50001 DROP VIEW IF EXISTS `vw_gestao_chamados_hospitalares`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_gestao_chamados_hospitalares` AS select `c`.`id_chamado` AS `id_chamado`,`un`.`nome` AS `unidade`,`c`.`area_responsavel` AS `area_responsavel`,`c`.`titulo` AS `titulo`,`c`.`prioridade` AS `prioridade`,`c`.`status` AS `status`,`u_ab`.`login` AS `aberto_por`,timestampdiff(HOUR,`c`.`criado_em`,now()) AS `horas_aberto`,`c`.`glpi_ticket_id` AS `ticket_externo` from ((`chamado` `c` join `unidade` `un` on((`c`.`id_unidade` = `un`.`id_unidade`))) join `usuario` `u_ab` on((`c`.`id_usuario_abertura` = `u_ab`.`id_usuario`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_guia_laboratorio_integrada`
--

/*!50001 DROP VIEW IF EXISTS `vw_guia_laboratorio_integrada`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_guia_laboratorio_integrada` AS select `ep`.`codigo_interno` AS `scanner_code`,`s`.`id` AS `senha_numero`,`f`.`gpat` AS `gpat_identificador`,`p`.`nome_completo` AS `paciente`,`a`.`protocolo` AS `protocolo_atendimento`,`ep`.`status` AS `status_exame` from ((((`exame_pedido` `ep` join `senhas` `s` on((`ep`.`id_senha` = `s`.`id`))) join `ffa` `f` on((`ep`.`id_ffa` = `f`.`id`))) join `atendimento` `a` on((`ep`.`id_atendimento` = `a`.`id_atendimento`))) join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) */;
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
-- Final view structure for view `vw_kpi_tempos_processo`
--

/*!50001 DROP VIEW IF EXISTS `vw_kpi_tempos_processo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_kpi_tempos_processo` AS select cast(now() as date) AS `dia`,`fo`.`tipo` AS `tipo_setor`,count(0) AS `total_registros`,round(avg(timestampdiff(MINUTE,`fo`.`data_entrada`,`fo`.`data_inicio`)),0) AS `avg_espera_ate_inicio_min`,round(avg(timestampdiff(MINUTE,`fo`.`data_inicio`,`fo`.`data_fim`)),0) AS `avg_duracao_execucao_min`,max(timestampdiff(MINUTE,`fo`.`data_entrada`,now())) AS `maior_espera_atual_min` from `fila_operacional` `fo` where ((`fo`.`data_entrada` is not null) and (cast(`fo`.`data_entrada` as date) = curdate()) and (`fo`.`substatus` in ('AGUARDANDO','CHAMANDO','EM_EXECUCAO','FINALIZADO','NAO_COMPARECEU')) and (`fo`.`tipo` is not null)) group by `fo`.`tipo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_medicacao_itens_por_ffa`
--

/*!50001 DROP VIEW IF EXISTS `vw_medicacao_itens_por_ffa`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_medicacao_itens_por_ffa` AS select `o`.`id_ffa` AS `id_ffa`,`o`.`id` AS `id_ordem`,`i`.`id_item` AS `id_item`,`o`.`status` AS `ordem_status`,`i`.`status` AS `item_status`,`i`.`id_farmaco` AS `id_farmaco`,`f`.`nome_comercial` AS `farmaco_nome`,`i`.`dose` AS `dose`,`i`.`via` AS `via`,`i`.`posologia` AS `posologia`,`i`.`dias` AS `dias`,`i`.`quantidade_total` AS `quantidade_total`,coalesce(`d`.`qtd_dispensada`,0) AS `quantidade_dispensada`,(`i`.`quantidade_total` - coalesce(`d`.`qtd_dispensada`,0)) AS `quantidade_pendente`,`o`.`criado_em` AS `criado_em` from (((`ordem_assistencial` `o` join `ordem_assistencial_item` `i` on((`i`.`id_ordem` = `o`.`id`))) join `farmaco` `f` on((`f`.`id_farmaco` = `i`.`id_farmaco`))) left join (select `dispensacao_medicacao`.`id_item` AS `id_item`,sum(`dispensacao_medicacao`.`quantidade`) AS `qtd_dispensada` from `dispensacao_medicacao` where (`dispensacao_medicacao`.`id_item` is not null) group by `dispensacao_medicacao`.`id_item`) `d` on((`d`.`id_item` = `i`.`id_item`))) where ((`o`.`tipo_ordem` collate utf8mb4_general_ci) = 'MEDICACAO') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_medico_fila`
--

/*!50001 DROP VIEW IF EXISTS `vw_medico_fila`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_medico_fila` AS select `fo`.`id_fila` AS `id_fila`,`fo`.`id_ffa` AS `id_ffa`,`fo`.`substatus` AS `substatus`,`fo`.`prioridade` AS `prioridade_real`,`fo`.`data_entrada` AS `data_entrada`,`fo`.`data_inicio` AS `data_inicio`,`fo`.`data_fim` AS `data_fim`,`fo`.`id_responsavel` AS `id_responsavel`,`f`.`gpat` AS `gpat`,`f`.`status` AS `status_ffa`,`f`.`classificacao_cor` AS `classificacao_cor`,`f`.`tempo_limite` AS `tempo_limite`,`s`.`codigo` AS `senha_codigo`,`s`.`tipo_atendimento` AS `tipo_atendimento`,`p`.`id` AS `id_paciente`,`pe`.`nome_social` AS `nome_social`,`pe`.`nome_completo` AS `nome_completo`,coalesce(`pe`.`nome_social`,`pe`.`nome_completo`) AS `paciente_nome` from ((((`fila_operacional` `fo` join `ffa` `f` on((`f`.`id` = `fo`.`id_ffa`))) left join `senhas` `s` on((`s`.`id` = `f`.`id_senha`))) left join `paciente` `p` on((`p`.`id` = `f`.`id_paciente`))) left join `pessoa` `pe` on((`pe`.`id_pessoa` = `p`.`id_pessoa`))) where (`fo`.`tipo` = 'MEDICO') */;
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
/*!50001 VIEW `vw_pacientes_internados` AS select `i`.`id_internacao` AS `id_internacao`,`p`.`nome_completo` AS `paciente`,`l`.`identificacao` AS `leito`,`i`.`status` AS `status` from (((`internacao` `i` join `atendimento` `a` on((`a`.`id_ffa` = `i`.`id_ffa`))) join `pessoa` `p` on((`p`.`id_pessoa` = `a`.`id_pessoa`))) join `leito` `l` on((`l`.`id_leito` = `i`.`id_leito`))) where (`i`.`status` = 'ATIVA') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_chamada_voz`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_chamada_voz`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_painel_chamada_voz` AS select `vw_painel_chamadas_ativas`.`origem` AS `origem`,`vw_painel_chamadas_ativas`.`id_evento` AS `id_evento`,`vw_painel_chamadas_ativas`.`painel_codigo` AS `painel_codigo`,`vw_painel_chamadas_ativas`.`id_local_operacional` AS `id_local_operacional`,`vw_painel_chamadas_ativas`.`id_senha` AS `id_senha`,`vw_painel_chamadas_ativas`.`senha_codigo` AS `senha_codigo`,`vw_painel_chamadas_ativas`.`lane` AS `lane`,`vw_painel_chamadas_ativas`.`tipo_atendimento` AS `tipo_atendimento`,`vw_painel_chamadas_ativas`.`chamado_em` AS `chamado_em`,timestampdiff(SECOND,`vw_painel_chamadas_ativas`.`chamado_em`,now()) AS `segundos_desde_chamada`,`vw_painel_chamadas_ativas`.`texto_tts` AS `texto_tts` from `vw_painel_chamadas_ativas` */;
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_painel_chamadas_ativas` AS select 'SENHA_EVENTOS' AS `origem`,`se`.`id_evento` AS `id_evento`,'RECEPCAO' AS `painel_codigo`,`s`.`id_local_operacional` AS `id_local_operacional`,`s`.`id` AS `id_senha`,`s`.`codigo` AS `senha_codigo`,`s`.`lane` AS `lane`,`s`.`tipo_atendimento` AS `tipo_atendimento`,`se`.`criado_em` AS `chamado_em`,concat('Senha ',`s`.`codigo`,', dirigir-se à ',coalesce(`lo`.`sala`,`lo`.`nome`)) AS `texto_tts` from (((`senha_eventos` `se` join `senhas` `s` on((`s`.`id` = `se`.`id_senha`))) left join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `s`.`id_local_operacional`))) left join `painel_consumo_evento` `pc` on((((`pc`.`origem` collate utf8mb4_general_ci) = 'SENHA_EVENTOS') and (`pc`.`id_evento` = `se`.`id_evento`) and ((`pc`.`painel_tipo` collate utf8mb4_general_ci) = 'RECEPCAO')))) where (((`se`.`status_novo` collate utf8mb4_general_ci) = 'CHAMANDO') and (`pc`.`id_consumo` is null)) union all select 'FILA_OPERACIONAL_EVENTO' AS `origem`,`e`.`id_evento` AS `id_evento`,(case when ((`fo`.`tipo` = 'MEDICO') and (`s`.`lane` = 'PEDIATRICO')) then 'MEDICO_PEDI' when (`fo`.`tipo` = 'MEDICO') then 'MEDICO_CLINICO' when (`fo`.`tipo` = 'EXAME') then 'COLETA' else `fo`.`tipo` end) AS `painel_codigo`,`fo`.`id_local_operacional` AS `id_local_operacional`,`s`.`id` AS `id_senha`,`s`.`codigo` AS `senha_codigo`,`s`.`lane` AS `lane`,`s`.`tipo_atendimento` AS `tipo_atendimento`,`e`.`criado_em` AS `chamado_em`,concat('Senha ',`s`.`codigo`,', dirigir-se à ',coalesce(`lo`.`sala`,`lo`.`nome`)) AS `texto_tts` from (((((`fila_operacional_evento` `e` join `fila_operacional` `fo` on((`fo`.`id_fila` = `e`.`id_fila`))) join `ffa` `f` on((`f`.`id` = `fo`.`id_ffa`))) join `senhas` `s` on((`s`.`id` = `f`.`id_senha`))) left join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `fo`.`id_local_operacional`))) left join `painel_consumo_evento` `pc` on((((`pc`.`origem` collate utf8mb4_general_ci) = 'FILA_OPERACIONAL_EVENTO') and (`pc`.`id_evento` = `e`.`id_evento`) and ((`pc`.`painel_tipo` collate utf8mb4_general_ci) = (case when ((`fo`.`tipo` = 'MEDICO') and (`s`.`lane` = 'PEDIATRICO')) then 'MEDICO_PEDI' when (`fo`.`tipo` = 'MEDICO') then 'MEDICO_CLINICO' when (`fo`.`tipo` = 'EXAME') then 'COLETA' else `fo`.`tipo` end))))) where (((`e`.`tipo_evento` collate utf8mb4_general_ci) = 'CHAMADA') and (`pc`.`id_consumo` is null)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_chamadas_recentes`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_chamadas_recentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_painel_chamadas_recentes` AS select `e`.`id_evento` AS `id_evento`,`e`.`id_fila` AS `id_fila`,`fo`.`tipo` AS `tipo`,`fo`.`id_local_operacional` AS `id_local_operacional`,`lo`.`nome` AS `local_nome`,`f`.`id` AS `id_ffa`,`f`.`gpat` AS `gpat`,`s`.`codigo` AS `senha_codigo`,`pe`.`nome_completo` AS `paciente_nome`,`e`.`tipo_evento` AS `tipo_evento`,`e`.`detalhe` AS `detalhe`,`e`.`criado_em` AS `criado_em`,(`e`.`criado_em` + interval 15 second) AS `blink_ate` from ((((((`fila_operacional_evento` `e` join `fila_operacional` `fo` on((`fo`.`id_fila` = `e`.`id_fila`))) left join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `fo`.`id_local_operacional`))) join `ffa` `f` on((`f`.`id` = `fo`.`id_ffa`))) left join `senhas` `s` on((`s`.`id` = `f`.`id_senha`))) join `paciente` `pa` on((`pa`.`id` = `f`.`id_paciente`))) join `pessoa` `pe` on((`pe`.`id_pessoa` = `pa`.`id_pessoa`))) where ((`e`.`tipo_evento` = 'CHAMADA') and (`e`.`criado_em` >= (now() - interval 30 minute))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_fila`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_fila`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_painel_fila` AS select (cast(`vw_painel_fila_setor`.`painel_codigo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `painel_codigo`,(cast('SETOR' as char charset utf8mb4) collate utf8mb4_general_ci) AS `origem`,`vw_painel_fila_setor`.`id_fila` AS `id_fila`,`vw_painel_fila_setor`.`id_ffa` AS `id_ffa`,(cast(`vw_painel_fila_setor`.`tipo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `tipo`,(cast(`vw_painel_fila_setor`.`substatus` as char charset utf8mb4) collate utf8mb4_general_ci) AS `substatus`,`vw_painel_fila_setor`.`prioridade_rank_efetiva` AS `prioridade_rank_efetiva`,`vw_painel_fila_setor`.`prioridade_rank_real` AS `prioridade_rank_real`,`vw_painel_fila_setor`.`elevada_por_tempo` AS `elevada_por_tempo`,`vw_painel_fila_setor`.`prioridade_efetiva` AS `prioridade_efetiva`,`vw_painel_fila_setor`.`espera_min` AS `espera_min`,`vw_painel_fila_setor`.`data_entrada` AS `data_entrada`,`vw_painel_fila_setor`.`data_inicio` AS `data_inicio`,`vw_painel_fila_setor`.`data_fim` AS `data_fim`,`vw_painel_fila_setor`.`id_local_operacional` AS `id_local_operacional`,(cast(`vw_painel_fila_setor`.`local_nome` as char charset utf8mb4) collate utf8mb4_general_ci) AS `local_nome`,`vw_painel_fila_setor`.`is_retorno` AS `is_retorno`,`vw_painel_fila_setor`.`retorno_permitido_ate` AS `retorno_permitido_ate`,(cast(`vw_painel_fila_setor`.`ffa_status` as char charset utf8mb4) collate utf8mb4_general_ci) AS `ffa_status`,(cast(`vw_painel_fila_setor`.`gpat` as char charset utf8mb4) collate utf8mb4_general_ci) AS `gpat`,(cast(`vw_painel_fila_setor`.`senha_codigo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `senha_codigo`,(cast(`vw_painel_fila_setor`.`lane` as char charset utf8mb4) collate utf8mb4_general_ci) AS `lane`,(cast(`vw_painel_fila_setor`.`tipo_atendimento` as char charset utf8mb4) collate utf8mb4_general_ci) AS `tipo_atendimento`,(cast(`vw_painel_fila_setor`.`paciente_nome` as char charset utf8mb4) collate utf8mb4_general_ci) AS `paciente_nome`,(cast(`vw_painel_fila_setor`.`paciente_nome_social` as char charset utf8mb4) collate utf8mb4_general_ci) AS `paciente_nome_social` from `vw_painel_fila_setor` union all select (cast(`vw_painel_fila_recepcao`.`painel_codigo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `painel_codigo`,(cast('SENHAS' as char charset utf8mb4) collate utf8mb4_general_ci) AS `origem`,NULL AS `id_fila`,NULL AS `id_ffa`,(cast(`vw_painel_fila_recepcao`.`tipo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `tipo`,(cast(`vw_painel_fila_recepcao`.`substatus` as char charset utf8mb4) collate utf8mb4_general_ci) AS `substatus`,`vw_painel_fila_recepcao`.`prioridade_rank_efetiva` AS `prioridade_rank_efetiva`,`vw_painel_fila_recepcao`.`prioridade_rank_real` AS `prioridade_rank_real`,`vw_painel_fila_recepcao`.`elevada_por_tempo` AS `elevada_por_tempo`,`vw_painel_fila_recepcao`.`prioridade_efetiva` AS `prioridade_efetiva`,`vw_painel_fila_recepcao`.`espera_min` AS `espera_min`,`vw_painel_fila_recepcao`.`data_entrada` AS `data_entrada`,`vw_painel_fila_recepcao`.`data_inicio` AS `data_inicio`,`vw_painel_fila_recepcao`.`data_fim` AS `data_fim`,`vw_painel_fila_recepcao`.`id_local_operacional` AS `id_local_operacional`,(cast(`vw_painel_fila_recepcao`.`local_nome` as char charset utf8mb4) collate utf8mb4_general_ci) AS `local_nome`,`vw_painel_fila_recepcao`.`is_retorno` AS `is_retorno`,`vw_painel_fila_recepcao`.`retorno_permitido_ate` AS `retorno_permitido_ate`,(cast(`vw_painel_fila_recepcao`.`ffa_status` as char charset utf8mb4) collate utf8mb4_general_ci) AS `ffa_status`,(cast(`vw_painel_fila_recepcao`.`gpat` as char charset utf8mb4) collate utf8mb4_general_ci) AS `gpat`,(cast(`vw_painel_fila_recepcao`.`senha_codigo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `senha_codigo`,(cast(`vw_painel_fila_recepcao`.`lane` as char charset utf8mb4) collate utf8mb4_general_ci) AS `lane`,(cast(`vw_painel_fila_recepcao`.`tipo_atendimento` as char charset utf8mb4) collate utf8mb4_general_ci) AS `tipo_atendimento`,(cast(`vw_painel_fila_recepcao`.`paciente_nome` as char charset utf8mb4) collate utf8mb4_general_ci) AS `paciente_nome`,(cast(`vw_painel_fila_recepcao`.`paciente_nome_social` as char charset utf8mb4) collate utf8mb4_general_ci) AS `paciente_nome_social` from `vw_painel_fila_recepcao` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_fila_recepcao`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_fila_recepcao`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_painel_fila_recepcao` AS select coalesce((select `p`.`codigo` from `painel` `p` where ((`p`.`ativo` = 1) and (`p`.`tipo` = 'PAINEL') and (`p`.`codigo` like 'RECEPCAO%') and ((`p`.`id_local_operacional` = `s`.`id_local_operacional`) or (`p`.`id_local_operacional` is null)) and ((`p`.`id_unidade` = `s`.`id_unidade`) or (`p`.`id_unidade` is null))) order by (`p`.`id_local_operacional` is not null) desc,(`p`.`id_unidade` is not null) desc,`p`.`id_painel` limit 1),'RECEPCAO') AS `painel_codigo`,'RECEPCAO' AS `tipo`,`s`.`status` AS `substatus`,`s`.`prioridade` AS `prioridade_rank_efetiva`,`s`.`prioridade` AS `prioridade_rank_real`,0 AS `elevada_por_tempo`,`s`.`prioridade` AS `prioridade_efetiva`,timestampdiff(MINUTE,coalesce(`s`.`posicionado_em`,`s`.`criada_em`),now()) AS `espera_min`,coalesce(`s`.`posicionado_em`,`s`.`criada_em`) AS `data_entrada`,`s`.`inicio_atendimento_em` AS `data_inicio`,`s`.`finalizada_em` AS `data_fim`,`s`.`id_local_operacional` AS `id_local_operacional`,`lo`.`nome` AS `local_nome`,ifnull(`s`.`retorno_utilizado`,0) AS `is_retorno`,`s`.`retorno_permitido_ate` AS `retorno_permitido_ate`,`f`.`status` AS `ffa_status`,`f`.`gpat` AS `gpat`,`s`.`codigo` AS `senha_codigo`,`s`.`lane` AS `lane`,`s`.`tipo_atendimento` AS `tipo_atendimento`,`pe`.`nome_completo` AS `paciente_nome`,`pe`.`nome_social` AS `paciente_nome_social` from ((((`senhas` `s` left join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `s`.`id_local_operacional`))) left join `ffa` `f` on((`f`.`id` = `s`.`id_ffa`))) left join `paciente` `pa` on((`pa`.`id` = `s`.`id_paciente`))) left join `pessoa` `pe` on((`pe`.`id_pessoa` = `pa`.`id_pessoa`))) where (`s`.`status` in ('GERADA','AGUARDANDO','CHAMANDO','EM_ATENDIMENTO','EM_COMPLEMENTACAO','NAO_COMPARECEU')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_fila_setor`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_fila_setor`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_painel_fila_setor` AS select `p`.`codigo` AS `painel_codigo`,`vfo`.`id_fila` AS `id_fila`,`vfo`.`id_ffa` AS `id_ffa`,`vfo`.`tipo` AS `tipo`,`vfo`.`substatus` AS `substatus`,`vfo`.`prioridade_real` AS `prioridade_real`,`vfo`.`prioridade_rank_real` AS `prioridade_rank_real`,`vfo`.`prioridade_rank_efetiva` AS `prioridade_rank_efetiva`,`vfo`.`elevada_por_tempo` AS `elevada_por_tempo`,`vfo`.`prioridade_efetiva` AS `prioridade_efetiva`,`vfo`.`tempo_max_min` AS `tempo_max_min`,`vfo`.`espera_min` AS `espera_min`,`vfo`.`data_entrada` AS `data_entrada`,`vfo`.`data_inicio` AS `data_inicio`,`vfo`.`data_fim` AS `data_fim`,`vfo`.`id_local_operacional` AS `id_local_operacional`,`vfo`.`local_nome` AS `local_nome`,`vfo`.`is_retorno` AS `is_retorno`,`vfo`.`nao_compareceu_em` AS `nao_compareceu_em`,`vfo`.`retorno_permitido_ate` AS `retorno_permitido_ate`,`vfo`.`retorno_utilizado` AS `retorno_utilizado`,`vfo`.`retorno_em` AS `retorno_em`,`f`.`status` AS `ffa_status`,`f`.`gpat` AS `gpat`,`s`.`codigo` AS `senha_codigo`,`s`.`lane` AS `lane`,`s`.`tipo_atendimento` AS `tipo_atendimento`,`pe`.`nome_completo` AS `paciente_nome`,`pe`.`nome_social` AS `paciente_nome_social` from (((((((`vw_fila_operacional_atual` `vfo` join `ffa` `f` on((`f`.`id` = `vfo`.`id_ffa`))) left join `senhas` `s` on((`s`.`id` = `f`.`id_senha`))) left join `paciente` `pa` on((`pa`.`id` = `f`.`id_paciente`))) left join `pessoa` `pe` on((`pe`.`id_pessoa` = `pa`.`id_pessoa`))) join `painel_fila_tipo` `pft` on(((`pft`.`tipo_fila` collate utf8mb4_general_ci) = (`vfo`.`tipo` collate utf8mb4_general_ci)))) join `painel` `p` on(((`p`.`id_painel` = `pft`.`id_painel`) and (`p`.`ativo` = 1) and ((`p`.`tipo` collate utf8mb4_general_ci) = ('PAINEL' collate utf8mb4_general_ci))))) left join `painel_lane` `pl` on(((`pl`.`id_painel` = `p`.`id_painel`) and ((`pl`.`lane` collate utf8mb4_general_ci) = (`s`.`lane` collate utf8mb4_general_ci))))) where (((`p`.`id_local_operacional` is null) or (`p`.`id_local_operacional` = `vfo`.`id_local_operacional`)) and ((`p`.`id_unidade` is null) or (`p`.`id_unidade` = `s`.`id_unidade`)) and (exists(select 1 from `painel_lane` `x` where (`x`.`id_painel` = `p`.`id_painel`)) is false or (`pl`.`lane` is not null))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_mensagens_pendentes`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_mensagens_pendentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_painel_mensagens_pendentes` AS select `p`.`codigo` AS `painel_codigo`,`pm`.`id_mensagem` AS `id_mensagem`,`pm`.`tipo` AS `tipo`,`pm`.`titulo` AS `titulo`,`pm`.`texto` AS `texto`,`pm`.`prioridade` AS `prioridade`,`pm`.`criado_em` AS `criado_em`,`pm`.`expira_em` AS `expira_em` from ((`painel_mensagem` `pm` join `painel` `p` on((`p`.`id_painel` = `pm`.`id_painel`))) left join `painel_mensagem_consumo` `c` on(((`c`.`id_mensagem` = `pm`.`id_mensagem`) and (`c`.`id_painel` = `pm`.`id_painel`)))) where ((`pm`.`ativo` = 1) and (`c`.`id_consumo` is null) and ((`pm`.`expira_em` is null) or (`pm`.`expira_em` > now()))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_monitor_kpis`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_monitor_kpis`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_painel_monitor_kpis` AS select (cast(`pn`.`codigo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `painel_codigo`,`pn`.`id_painel` AS `id_painel`,`pn`.`id_unidade` AS `id_unidade`,`pn`.`id_local_operacional` AS `id_local_operacional`,`pme`.`id_especialidade` AS `id_especialidade`,(cast(coalesce(`e`.`nome`,'(SEM ESPECIALIDADE)') as char charset utf8mb4) collate utf8mb4_general_ci) AS `especialidade`,`pme`.`id_local_operacional` AS `id_local_config`,sum((case when (`fo`.`substatus` = 'AGUARDANDO') then 1 else 0 end)) AS `qtd_aguardando`,sum((case when (`fo`.`substatus` = 'EM_EXECUCAO') then 1 else 0 end)) AS `qtd_em_execucao`,sum((case when (`fo`.`substatus` like 'NAO_%') then 1 else 0 end)) AS `qtd_nao_atendido`,min((case when (`fo`.`substatus` = 'AGUARDANDO') then `fo`.`data_entrada` end)) AS `primeiro_aguardando_em`,max(`fo`.`data_entrada`) AS `ultima_entrada_em` from (((`painel` `pn` join `painel_monitoramento_especialidade` `pme` on(((`pme`.`id_painel` = `pn`.`id_painel`) and (`pme`.`ativo` = 1)))) left join `especialidade` `e` on((`e`.`id_especialidade` = `pme`.`id_especialidade`))) left join `fila_operacional` `fo` on(((`fo`.`id_local_operacional` = `pme`.`id_local_operacional`) and (`fo`.`tipo` = 'MEDICO') and (`fo`.`substatus` in ('AGUARDANDO','EM_EXECUCAO','FINALIZADO','NAO_COMPARECEU','NAO_ATENDIDO'))))) where ((`pn`.`ativo` = 1) and (`pn`.`codigo` like 'MONITOR_MEDICOS%')) group by `pn`.`codigo`,`pn`.`id_painel`,`pn`.`id_unidade`,`pn`.`id_local_operacional`,`pme`.`id_especialidade`,`e`.`nome`,`pme`.`id_local_operacional` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_monitor_medicos_agora`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_monitor_medicos_agora`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_painel_monitor_medicos_agora` AS select (cast(`pn`.`codigo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `painel_codigo`,`pn`.`id_painel` AS `id_painel`,`pn`.`id_unidade` AS `id_unidade`,`pn`.`id_local_operacional` AS `id_local_operacional`,cast(curdate() as date) AS `dia`,`pme`.`id_especialidade` AS `id_especialidade`,(cast(coalesce(`e`.`nome`,'(SEM ESPECIALIDADE)') as char charset utf8mb4) collate utf8mb4_general_ci) AS `especialidade`,`pme`.`id_local_operacional` AS `id_local_config`,(cast(coalesce(`lo`.`nome`,`lo`.`sala`,'') as char charset utf8mb4) collate utf8mb4_general_ci) AS `local_config_nome`,count(distinct `pa`.`id_plantao`) AS `qtd_medicos_agora`,(cast(group_concat(distinct concat(`pa`.`medico_nome`,' - CRM: ',coalesce(`pa`.`crm`,'?')) order by `pa`.`inicio_plantao` ASC separator ' | ') as char charset utf8mb4) collate utf8mb4_general_ci) AS `medicos` from ((((`painel` `pn` join `painel_monitoramento_especialidade` `pme` on(((`pme`.`id_painel` = `pn`.`id_painel`) and (`pme`.`ativo` = 1)))) left join `especialidade` `e` on((`e`.`id_especialidade` = `pme`.`id_especialidade`))) left join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `pme`.`id_local_operacional`))) left join (select `p`.`id` AS `id_plantao`,`p`.`id_medico` AS `id_medico`,`p`.`inicio_plantao` AS `inicio_plantao`,`p`.`fim_plantao` AS `fim_plantao`,coalesce(`m`.`nome`,`p`.`nome_medico`) AS `medico_nome`,`m`.`crm` AS `crm`,`m`.`id_especialidade` AS `id_especialidade` from (`plantao` `p` left join `medicos` `m` on((`m`.`id_medico` = `p`.`id_medico`))) where ((`p`.`ativo` = 1) and (cast(`p`.`inicio_plantao` as date) = curdate()) and (now() >= `p`.`inicio_plantao`) and (now() <= `p`.`fim_plantao`))) `pa` on((`pa`.`id_especialidade` = `pme`.`id_especialidade`))) where ((`pn`.`ativo` = 1) and (`pn`.`codigo` like 'MONITOR_MEDICOS%')) group by `pn`.`codigo`,`pn`.`id_painel`,`pn`.`id_unidade`,`pn`.`id_local_operacional`,`pme`.`id_especialidade`,`e`.`nome`,`pme`.`id_local_operacional`,`lo`.`nome`,`lo`.`sala`,cast(curdate() as date) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_monitoramento_medico`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_monitoramento_medico`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_painel_monitoramento_medico` AS select `g`.`codigo` AS `grupo_codigo`,`g`.`nome` AS `grupo_nome`,`fo`.`tipo` AS `tipo_setor`,count(0) AS `qtd_total`,sum((case when (`fo`.`substatus` = 'AGUARDANDO') then 1 else 0 end)) AS `qtd_aguardando`,sum((case when (`fo`.`substatus` = 'CHAMANDO') then 1 else 0 end)) AS `qtd_chamando`,sum((case when (`fo`.`substatus` = 'EM_EXECUCAO') then 1 else 0 end)) AS `qtd_em_execucao`,round(avg(timestampdiff(MINUTE,`fo`.`data_entrada`,coalesce(`fo`.`data_inicio`,now()))),0) AS `avg_espera_atual_min`,round(avg((case when ((`fo`.`data_inicio` is not null) and (`fo`.`data_fim` is not null)) then timestampdiff(MINUTE,`fo`.`data_inicio`,`fo`.`data_fim`) else NULL end)),0) AS `avg_duracao_min` from ((`fila_operacional` `fo` join `painel_grupo_local` `gl` on((`gl`.`id_local_operacional` = `fo`.`id_local_operacional`))) join `painel_grupo` `g` on(((`g`.`id_grupo` = `gl`.`id_grupo`) and (`g`.`ativo` = 1)))) where ((`fo`.`data_entrada` is not null) and (cast(`fo`.`data_entrada` as date) = curdate())) group by `g`.`codigo`,`g`.`nome`,`fo`.`tipo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_monitoramento_medico_kpis`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_monitoramento_medico_kpis`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_painel_monitoramento_medico_kpis` AS select (cast(`fo`.`tipo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `tipo_fila`,count(0) AS `qtd_total`,sum((`fo`.`substatus` = 'AGUARDANDO')) AS `qtd_aguardando`,sum((`fo`.`substatus` = 'EM_EXECUCAO')) AS `qtd_em_execucao`,sum((`fo`.`substatus` = 'FINALIZADO')) AS `qtd_finalizado`,sum((`fo`.`substatus` = 'NAO_COMPARECEU')) AS `qtd_nao_compareceu`,round(avg(timestampdiff(MINUTE,`fo`.`data_entrada`,now())),2) AS `media_espera_min` from `fila_operacional` `fo` where ((`fo`.`tipo` in ('MEDICO','TRIAGEM','MEDICACAO','RX','COLETA')) and (`fo`.`substatus` in ('AGUARDANDO','EM_EXECUCAO','FINALIZADO','NAO_COMPARECEU'))) group by `fo`.`tipo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_tts_pendentes`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_tts_pendentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_painel_tts_pendentes` AS select (cast('SENHA_EVENTOS' as char charset utf8mb4) collate utf8mb4_general_ci) AS `origem`,`se`.`id_evento` AS `id_evento`,(cast(`p`.`codigo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `painel_codigo`,`p`.`id_local_operacional` AS `id_local_operacional`,(cast(coalesce(`lo`.`nome`,`p`.`nome`) as char charset utf8mb4) collate utf8mb4_general_ci) AS `local_nome`,(cast(`s`.`codigo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `senha_codigo`,NULL AS `id_fila`,(cast('RECEPCAO' as char charset utf8mb4) collate utf8mb4_general_ci) AS `tipo_fila`,`se`.`criado_em` AS `criado_em`,(cast(concat('Senha ',`s`.`codigo`,', dirigir-se à ',coalesce(`lo`.`sala`,`lo`.`nome`,`p`.`nome`)) as char charset utf8mb4) collate utf8mb4_general_ci) AS `texto_tts` from (((((`senha_eventos` `se` join `senhas` `s` on((`s`.`id` = `se`.`id_senha`))) join `painel_fila_tipo` `pft` on(((`pft`.`tipo_fila` collate utf8mb4_general_ci) = ('RECEPCAO' collate utf8mb4_general_ci)))) join `painel` `p` on(((`p`.`id_painel` = `pft`.`id_painel`) and (`p`.`ativo` = 1) and (`p`.`tts_habilitado` = 1)))) left join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `p`.`id_local_operacional`))) left join `painel_consumo_evento` `pc` on(((`pc`.`origem` = 'SENHA_EVENTOS') and (`pc`.`id_evento` = `se`.`id_evento`) and ((`pc`.`painel_tipo` collate utf8mb4_general_ci) = (`p`.`codigo` collate utf8mb4_general_ci))))) where (((`se`.`status_novo` collate utf8mb4_general_ci) = ('CHAMANDO' collate utf8mb4_general_ci)) and (`pc`.`id_consumo` is null)) union all select (cast('FILA_OPERACIONAL_EVENTO' as char charset utf8mb4) collate utf8mb4_general_ci) AS `origem`,`e`.`id_evento` AS `id_evento`,(cast(`p`.`codigo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `painel_codigo`,`p`.`id_local_operacional` AS `id_local_operacional`,(cast(coalesce(`lo`.`nome`,`p`.`nome`) as char charset utf8mb4) collate utf8mb4_general_ci) AS `local_nome`,(cast(`s`.`codigo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `senha_codigo`,`e`.`id_fila` AS `id_fila`,(cast(`fo`.`tipo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `tipo_fila`,`e`.`criado_em` AS `criado_em`,(cast(concat('Senha ',`s`.`codigo`,', dirigir-se à ',coalesce(`lo`.`sala`,`lo`.`nome`,`p`.`nome`)) as char charset utf8mb4) collate utf8mb4_general_ci) AS `texto_tts` from (((((((`fila_operacional_evento` `e` join `fila_operacional` `fo` on((`fo`.`id_fila` = `e`.`id_fila`))) join `painel_fila_tipo` `pft` on(((`pft`.`tipo_fila` collate utf8mb4_general_ci) = (`fo`.`tipo` collate utf8mb4_general_ci)))) join `painel` `p` on(((`p`.`id_painel` = `pft`.`id_painel`) and (`p`.`ativo` = 1) and (`p`.`tts_habilitado` = 1)))) left join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `p`.`id_local_operacional`))) join `ffa` `f` on((`f`.`id` = `fo`.`id_ffa`))) left join `senhas` `s` on((`s`.`id` = `f`.`id_senha`))) left join `painel_consumo_evento` `pc` on(((`pc`.`origem` = 'FILA_OPERACIONAL_EVENTO') and (`pc`.`id_evento` = `e`.`id_evento`) and ((`pc`.`painel_tipo` collate utf8mb4_general_ci) = (`p`.`codigo` collate utf8mb4_general_ci))))) where (((`e`.`tipo_evento` collate utf8mb4_general_ci) = ('CHAMADA' collate utf8mb4_general_ci)) and ((`p`.`id_local_operacional` is null) or (`p`.`id_local_operacional` = `fo`.`id_local_operacional`)) and (`pc`.`id_consumo` is null)) union all select (cast('PAINEL_MENSAGEM' as char charset utf8mb4) collate utf8mb4_general_ci) AS `origem`,`pm`.`id_mensagem` AS `id_evento`,(cast(`p`.`codigo` as char charset utf8mb4) collate utf8mb4_general_ci) AS `painel_codigo`,`p`.`id_local_operacional` AS `id_local_operacional`,(cast(coalesce(`lo`.`nome`,`p`.`nome`) as char charset utf8mb4) collate utf8mb4_general_ci) AS `local_nome`,(cast(NULL as char charset utf8mb4) collate utf8mb4_general_ci) AS `senha_codigo`,NULL AS `id_fila`,(cast('MENSAGEM' as char charset utf8mb4) collate utf8mb4_general_ci) AS `tipo_fila`,`pm`.`criado_em` AS `criado_em`,(cast(trim(concat(coalesce(`pm`.`titulo`,''),' ',coalesce(`pm`.`texto`,''))) as char charset utf8mb4) collate utf8mb4_general_ci) AS `texto_tts` from (((`painel_mensagem` `pm` join `painel` `p` on(((`p`.`id_painel` = `pm`.`id_painel`) and (`p`.`ativo` = 1) and (`p`.`tts_habilitado` = 1)))) left join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `p`.`id_local_operacional`))) left join `painel_mensagem_consumo` `c` on(((`c`.`id_mensagem` = `pm`.`id_mensagem`) and (`c`.`id_painel` = `pm`.`id_painel`)))) where (`c`.`id_consumo` is null) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_painel_tv_rotativo_lista`
--

/*!50001 DROP VIEW IF EXISTS `vw_painel_tv_rotativo_lista`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_painel_tv_rotativo_lista` AS select `z`.`tela` AS `tela`,`z`.`id_fila` AS `id_fila`,`z`.`id_ffa` AS `id_ffa`,`z`.`tipo` AS `tipo`,`z`.`substatus` AS `substatus`,`z`.`prioridade_real` AS `prioridade_real`,`z`.`prioridade_rank_real` AS `prioridade_rank_real`,`z`.`prioridade_rank_efetiva` AS `prioridade_rank_efetiva`,`z`.`elevada_por_tempo` AS `elevada_por_tempo`,`z`.`prioridade_efetiva` AS `prioridade_efetiva`,`z`.`tempo_max_min` AS `tempo_max_min`,`z`.`espera_min` AS `espera_min`,`z`.`data_entrada` AS `data_entrada`,`z`.`data_inicio` AS `data_inicio`,`z`.`data_fim` AS `data_fim`,`z`.`id_local_operacional` AS `id_local_operacional`,`z`.`local_nome` AS `local_nome`,`z`.`is_retorno` AS `is_retorno`,`z`.`nao_compareceu_em` AS `nao_compareceu_em`,`z`.`retorno_permitido_ate` AS `retorno_permitido_ate`,`z`.`retorno_utilizado` AS `retorno_utilizado`,`z`.`retorno_em` AS `retorno_em`,`z`.`ffa_status` AS `ffa_status`,`z`.`gpat` AS `gpat`,`z`.`senha_codigo` AS `senha_codigo`,`z`.`lane` AS `lane`,`z`.`tipo_atendimento` AS `tipo_atendimento`,`z`.`paciente_nome` AS `paciente_nome`,`z`.`paciente_nome_social` AS `paciente_nome_social`,`z`.`rn` AS `rn` from (select (case when ((`v`.`tipo` = 'MEDICO') and (`v`.`lane` = 'ADULTO')) then 'CLINICO' when ((`v`.`tipo` = 'MEDICO') and (`v`.`lane` = 'PEDIATRICO')) then 'PEDIATRICO' when (`v`.`tipo` = 'RX') then 'RX' when (`v`.`tipo` = 'MEDICACAO') then 'MEDICACAO' else NULL end) AS `tela`,`v`.`id_fila` AS `id_fila`,`v`.`id_ffa` AS `id_ffa`,`v`.`tipo` AS `tipo`,`v`.`substatus` AS `substatus`,`v`.`prioridade_real` AS `prioridade_real`,`v`.`prioridade_rank_real` AS `prioridade_rank_real`,`v`.`prioridade_rank_efetiva` AS `prioridade_rank_efetiva`,`v`.`elevada_por_tempo` AS `elevada_por_tempo`,`v`.`prioridade_efetiva` AS `prioridade_efetiva`,`v`.`tempo_max_min` AS `tempo_max_min`,`v`.`espera_min` AS `espera_min`,`v`.`data_entrada` AS `data_entrada`,`v`.`data_inicio` AS `data_inicio`,`v`.`data_fim` AS `data_fim`,`v`.`id_local_operacional` AS `id_local_operacional`,`v`.`local_nome` AS `local_nome`,`v`.`is_retorno` AS `is_retorno`,`v`.`nao_compareceu_em` AS `nao_compareceu_em`,`v`.`retorno_permitido_ate` AS `retorno_permitido_ate`,`v`.`retorno_utilizado` AS `retorno_utilizado`,`v`.`retorno_em` AS `retorno_em`,`v`.`ffa_status` AS `ffa_status`,`v`.`gpat` AS `gpat`,`v`.`senha_codigo` AS `senha_codigo`,`v`.`lane` AS `lane`,`v`.`tipo_atendimento` AS `tipo_atendimento`,`v`.`paciente_nome` AS `paciente_nome`,`v`.`paciente_nome_social` AS `paciente_nome_social`,row_number() OVER (PARTITION BY (case when ((`v`.`tipo` = 'MEDICO') and (`v`.`lane` = 'ADULTO')) then 'CLINICO' when ((`v`.`tipo` = 'MEDICO') and (`v`.`lane` = 'PEDIATRICO')) then 'PEDIATRICO' when (`v`.`tipo` = 'RX') then 'RX' when (`v`.`tipo` = 'MEDICACAO') then 'MEDICACAO' else 'OUTROS' end) ORDER BY `v`.`prioridade_rank_efetiva` desc,`v`.`data_entrada` )  AS `rn` from `vw_painel_fila_setor` `v` where (((`v`.`tipo` = 'MEDICO') and (`v`.`lane` in ('ADULTO','PEDIATRICO'))) or (`v`.`tipo` in ('RX','MEDICACAO')))) `z` where ((`z`.`tela` is not null) and (`z`.`rn` <= 10)) */;
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
-- Final view structure for view `vw_profissionais_ativos`
--

/*!50001 DROP VIEW IF EXISTS `vw_profissionais_ativos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_profissionais_ativos` AS select `p`.`nome_completo` AS `nome_completo`,`u`.`login` AS `login`,`cp`.`sigla` AS `tipo_registro`,`u`.`registro_profissional` AS `numero_registro`,concat(`cp`.`sigla`,'/',`cp`.`uf`,' ',`u`.`registro_profissional`) AS `carimbo_completo` from ((`usuario` `u` join `pessoa` `p` on((`u`.`id_pessoa` = `p`.`id_pessoa`))) join `conselho_profissional` `cp` on((`u`.`id_conselho` = `cp`.`id_conselho`))) where (`u`.`ativo` = 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_prontuario_espelho`
--

/*!50001 DROP VIEW IF EXISTS `vw_prontuario_espelho`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_prontuario_espelho` AS select `e`.`id_atendimento` AS `id_atendimento`,`p_pac`.`nome_completo` AS `paciente`,`e`.`criado_em` AS `data_registro`,`e`.`texto_evolucao` AS `texto_evolucao`,`p_prof`.`nome_completo` AS `profissional`,`cp`.`sigla` AS `conselho`,`u`.`registro_profissional` AS `nro_registro`,concat(`p_prof`.`nome_completo`,' (',`cp`.`sigla`,': ',`u`.`registro_profissional`,')') AS `assinatura_formata` from (((((`prontuario_evolucao` `e` join `atendimento` `a` on((`e`.`id_atendimento` = `a`.`id_atendimento`))) join `pessoa` `p_pac` on((`a`.`id_pessoa` = `p_pac`.`id_pessoa`))) join `usuario` `u` on((`e`.`id_usuario` = `u`.`id_usuario`))) join `pessoa` `p_prof` on((`u`.`id_pessoa` = `p_prof`.`id_pessoa`))) join `conselho_profissional` `cp` on((`u`.`id_conselho` = `cp`.`id_conselho`))) where (`e`.`status` = 'ATIVO') order by `e`.`criado_em` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_protocolo_pendentes`
--

/*!50001 DROP VIEW IF EXISTS `vw_protocolo_pendentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_protocolo_pendentes` AS select `pp`.`id_protocolo` AS `id_protocolo`,`pp`.`tipo` AS `tipo`,`pp`.`codigo` AS `codigo`,`pp`.`barcode` AS `barcode`,`pp`.`status` AS `status`,`pp`.`criado_em` AS `criado_em`,`pp`.`atualizado_em` AS `atualizado_em`,`pp`.`id_ffa` AS `id_ffa`,`f`.`gpat` AS `gpat`,`s`.`codigo` AS `senha_codigo`,`lo`.`nome` AS `local_nome` from ((((`procedimento_protocolo` `pp` join `ffa` `f` on((`f`.`id` = `pp`.`id_ffa`))) left join `senhas` `s` on((`s`.`id` = `f`.`id_senha`))) left join `fila_operacional` `fo` on((`fo`.`id_fila` = `pp`.`id_fila`))) left join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `fo`.`id_local_operacional`))) where (`pp`.`status` in ('CRIADO','EM_EXECUCAO')) order by `pp`.`criado_em` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_resumo_beira_leito`
--

/*!50001 DROP VIEW IF EXISTS `vw_resumo_beira_leito`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_resumo_beira_leito` AS select `l`.`identificacao` AS `leito`,`p`.`nome_completo` AS `paciente`,`i`.`precaucao` AS `precaucao`,(select concat(`sinais_vitais`.`saturacao_o2`,'%') from `sinais_vitais` where (`sinais_vitais`.`id_atendimento` = `a`.`id_atendimento`) order by `sinais_vitais`.`criado_em` desc limit 1) AS `ult_sat`,(select concat(`sinais_vitais`.`pressao_sistolica`,'/',`sinais_vitais`.`pressao_diastolica`) from `sinais_vitais` where (`sinais_vitais`.`id_atendimento` = `a`.`id_atendimento`) order by `sinais_vitais`.`criado_em` desc limit 1) AS `ult_pa`,(select `prontuario_evolucao`.`texto_evolucao` from `prontuario_evolucao` where (`prontuario_evolucao`.`id_atendimento` = `a`.`id_atendimento`) order by `prontuario_evolucao`.`criado_em` desc limit 1) AS `ultima_nota` from ((((`leito` `l` join `internacao` `i` on(((`l`.`id_leito` = `i`.`id_leito`) and (`i`.`status` = 'ATIVA')))) join `ffa` `f` on((`i`.`id_ffa` = `f`.`id`))) join `atendimento` `a` on((`f`.`id_atendimento` = `a`.`id_atendimento`))) join `pessoa` `p` on((`a`.`id_pessoa` = `p`.`id_pessoa`))) */;
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
-- Final view structure for view `vw_totem_plantao_banner`
--

/*!50001 DROP VIEW IF EXISTS `vw_totem_plantao_banner`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_totem_plantao_banner` AS select cast(`p`.`inicio_plantao` as date) AS `dia`,(cast(`p`.`tipo_plantao` as char charset utf8mb4) collate utf8mb4_general_ci) AS `setor`,(cast(coalesce(`m`.`nome`,`p`.`nome_medico`) as char charset utf8mb4) collate utf8mb4_general_ci) AS `medico_nome`,(cast(`m`.`crm` as char charset utf8mb4) collate utf8mb4_general_ci) AS `crm`,(cast(`e`.`nome` as char charset utf8mb4) collate utf8mb4_general_ci) AS `especialidade`,(cast(concat(convert(date_format(`p`.`inicio_plantao`,'%H:%i') using utf8mb4),' - ',convert(date_format(`p`.`fim_plantao`,'%H:%i') using utf8mb4)) as char charset utf8mb4) collate utf8mb4_general_ci) AS `periodo`,`p`.`inicio_plantao` AS `inicio`,`p`.`fim_plantao` AS `fim` from ((`plantao` `p` left join `medicos` `m` on((`m`.`id_medico` = `p`.`id_medico`))) left join `especialidade` `e` on((`e`.`id_especialidade` = `m`.`id_especialidade`))) where ((`p`.`ativo` = 1) and (cast(`p`.`inicio_plantao` as date) = curdate())) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_totem_satisfacao_resumo_hoje`
--

/*!50001 DROP VIEW IF EXISTS `vw_totem_satisfacao_resumo_hoje`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_totem_satisfacao_resumo_hoje` AS select cast(`tf`.`data_hora` as date) AS `dia`,(cast(`tf`.`origem` as char charset utf8mb4) collate utf8mb4_general_ci) AS `painel_tipo`,`tf`.`nota` AS `avaliacao`,count(0) AS `qtd` from `totem_feedback` `tf` where ((`tf`.`data_hora` >= curdate()) and (`tf`.`data_hora` < (curdate() + interval 1 day))) group by cast(`tf`.`data_hora` as date),`tf`.`origem`,`tf`.`nota` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_totem_senha_opcoes`
--

/*!50001 DROP VIEW IF EXISTS `vw_totem_senha_opcoes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_totem_senha_opcoes` AS select `p`.`codigo` AS `painel_codigo`,`o`.`codigo` AS `opcao_codigo`,`o`.`label` AS `opcao_label`,`o`.`lane` AS `lane`,`o`.`tipo_atendimento` AS `tipo_atendimento`,`o`.`prefixo` AS `prefixo`,`o`.`ordem` AS `ordem`,`o`.`ativo` AS `ativo` from (`totem_senha_opcao` `o` join `painel` `p` on((`p`.`id_painel` = `o`.`id_painel`))) where (`p`.`codigo` = 'TOTEM_SENHA') order by `o`.`ordem` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_tv_rotativo_telas_ativas`
--

/*!50001 DROP VIEW IF EXISTS `vw_tv_rotativo_telas_ativas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_tv_rotativo_telas_ativas` AS select `p`.`id_painel` AS `id_painel_tv`,`p`.`codigo` AS `painel_tv_codigo`,`t`.`ordem` AS `ordem`,`t`.`codigo_tela` AS `codigo_tela`,`t`.`duracao_seg` AS `duracao_seg`,`t`.`ativo` AS `ativo` from (`painel` `p` join `tv_rotativo_tela` `t` on((`t`.`id_painel` = `p`.`id_painel`))) where ((`p`.`codigo` = 'TV_ROTATIVO') and (`p`.`ativo` = 1) and (`t`.`ativo` = 1)) order by `t`.`ordem` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_usuario_contextos_master`
--

/*!50001 DROP VIEW IF EXISTS `vw_usuario_contextos_master`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_usuario_contextos_master` AS select `u`.`id_usuario` AS `id_usuario`,`u`.`login` AS `login`,`usp`.`id_sistema` AS `id_sistema`,`usp`.`perfil_slug` AS `perfil_slug`,`un`.`nome` AS `unidade_nome` from ((`usuario` `u` join `usuario_sistema_perfil` `usp` on((`u`.`id_usuario` = `usp`.`id_usuario`))) join `unidade` `un`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_usuario_contextos_v2`
--

/*!50001 DROP VIEW IF EXISTS `vw_usuario_contextos_v2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_usuario_contextos_v2` AS select `ulo`.`id_usuario` AS `id_usuario`,`lo`.`id_sistema` AS `id_sistema`,`s`.`nome` AS `sistema`,`lo`.`id_unidade` AS `id_unidade`,`un`.`nome` AS `unidade`,`lo`.`id_local_operacional` AS `id_local_operacional`,`lo`.`codigo` AS `codigo`,`lo`.`nome` AS `nome`,`lo`.`tipo` AS `tipo`,`ulo`.`ativo` AS `ativo_vinculo` from (((`usuario_local_operacional` `ulo` join `local_operacional` `lo` on((`lo`.`id_local_operacional` = `ulo`.`id_local_operacional`))) join `unidade` `un` on((`un`.`id_unidade` = `lo`.`id_unidade`))) join `sistema` `s` on((`s`.`id_sistema` = `lo`.`id_sistema`))) */;
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
/*!50001 VIEW `vw_usuario_perfis_v2` AS select `us`.`id_usuario` AS `id_usuario`,`u`.`login` AS `login`,`us`.`id_sistema` AS `id_sistema`,`s`.`nome` AS `sistema`,`us`.`id_perfil` AS `id_perfil`,`p`.`nome` AS `perfil`,`us`.`ativo` AS `ativo_vinculo` from (((`usuario_sistema` `us` join `usuario` `u` on((`u`.`id_usuario` = `us`.`id_usuario`))) join `sistema` `s` on((`s`.`id_sistema` = `us`.`id_sistema`))) join `perfil` `p` on((`p`.`id_perfil` = `us`.`id_perfil`))) */;
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
-- Final view structure for view `vw_usuario_permissoes_v2`
--

/*!50001 DROP VIEW IF EXISTS `vw_usuario_permissoes_v2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_usuario_permissoes_v2` AS select `us`.`id_usuario` AS `id_usuario`,`us`.`id_sistema` AS `id_sistema`,`p`.`nome` AS `perfil`,`pe`.`codigo` AS `permissao`,`pe`.`descricao` AS `descricao` from ((((`usuario_sistema` `us` join `perfil` `pf` on((`pf`.`id_perfil` = `us`.`id_perfil`))) join `perfil_permissao` `pp` on((`pp`.`id_perfil` = `pf`.`id_perfil`))) join `permissao` `pe` on((`pe`.`id_permissao` = `pp`.`id_permissao`))) join `perfil` `p` on((`p`.`id_perfil` = `us`.`id_perfil`))) */;
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

-- Dump completed on 2026-02-04 10:07:28
