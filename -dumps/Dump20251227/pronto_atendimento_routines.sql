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
-- Temporary view structure for view `vw_mapa_leitos`
--

DROP TABLE IF EXISTS `vw_mapa_leitos`;
/*!50001 DROP VIEW IF EXISTS `vw_mapa_leitos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_mapa_leitos` AS SELECT 
 1 AS `setor`,
 1 AS `leito`,
 1 AS `status`,
 1 AS `paciente`,
 1 AS `protocolo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_tempo_atendimento`
--

DROP TABLE IF EXISTS `vw_tempo_atendimento`;
/*!50001 DROP VIEW IF EXISTS `vw_tempo_atendimento`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_tempo_atendimento` AS SELECT 
 1 AS `id_atendimento`,
 1 AS `protocolo`,
 1 AS `tempo_minutos`*/;
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
 1 AS `protocolo`,
 1 AS `nome_completo`,
 1 AS `tipo`,
 1 AS `leito`,
 1 AS `status`,
 1 AS `data_entrada`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_produtividade_medico`
--

DROP TABLE IF EXISTS `vw_produtividade_medico`;
/*!50001 DROP VIEW IF EXISTS `vw_produtividade_medico`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_produtividade_medico` AS SELECT 
 1 AS `id_usuario`,
 1 AS `medico`,
 1 AS `atendimentos_realizados`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_fila_atual`
--

DROP TABLE IF EXISTS `vw_fila_atual`;
/*!50001 DROP VIEW IF EXISTS `vw_fila_atual`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_fila_atual` AS SELECT 
 1 AS `id_atendimento`,
 1 AS `protocolo`,
 1 AS `nome_completo`,
 1 AS `status_atendimento`,
 1 AS `local_atual`,
 1 AS `sala`,
 1 AS `data_abertura`,
 1 AS `tempo_espera_min`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_produtividade_medica`
--

DROP TABLE IF EXISTS `vw_produtividade_medica`;
/*!50001 DROP VIEW IF EXISTS `vw_produtividade_medica`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_produtividade_medica` AS SELECT 
 1 AS `id_usuario`,
 1 AS `medico`,
 1 AS `atendimentos_realizados`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_ocupacao_leitos`
--

DROP TABLE IF EXISTS `vw_ocupacao_leitos`;
/*!50001 DROP VIEW IF EXISTS `vw_ocupacao_leitos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_ocupacao_leitos` AS SELECT 
 1 AS `setor`,
 1 AS `total_leitos`,
 1 AS `ocupados`,
 1 AS `livres`,
 1 AS `taxa_ocupacao_percent`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_historico_paciente`
--

DROP TABLE IF EXISTS `vw_historico_paciente`;
/*!50001 DROP VIEW IF EXISTS `vw_historico_paciente`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_historico_paciente` AS SELECT 
 1 AS `id_atendimento`,
 1 AS `protocolo`,
 1 AS `data_abertura`,
 1 AS `data_fechamento`,
 1 AS `status_atendimento`,
 1 AS `nome_completo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_atendimentos_diarios`
--

DROP TABLE IF EXISTS `vw_atendimentos_diarios`;
/*!50001 DROP VIEW IF EXISTS `vw_atendimentos_diarios`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_atendimentos_diarios` AS SELECT 
 1 AS `dia`,
 1 AS `total`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_tempo_internacao`
--

DROP TABLE IF EXISTS `vw_tempo_internacao`;
/*!50001 DROP VIEW IF EXISTS `vw_tempo_internacao`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_tempo_internacao` AS SELECT 
 1 AS `tipo`,
 1 AS `total_pacientes`,
 1 AS `tempo_medio_horas`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_receitas_controladas`
--

DROP TABLE IF EXISTS `vw_receitas_controladas`;
/*!50001 DROP VIEW IF EXISTS `vw_receitas_controladas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_receitas_controladas` AS SELECT 
 1 AS `id_prescricao`,
 1 AS `protocolo`,
 1 AS `paciente`,
 1 AS `medico`,
 1 AS `data_hora`*/;
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
 1 AS `login`,
 1 AS `permissao`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_retorno_paciente`
--

DROP TABLE IF EXISTS `vw_retorno_paciente`;
/*!50001 DROP VIEW IF EXISTS `vw_retorno_paciente`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_retorno_paciente` AS SELECT 
 1 AS `id_atendimento`,
 1 AS `protocolo`,
 1 AS `nome_completo`,
 1 AS `data_retorno`,
 1 AS `motivo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_auditoria`
--

DROP TABLE IF EXISTS `vw_auditoria`;
/*!50001 DROP VIEW IF EXISTS `vw_auditoria`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_auditoria` AS SELECT 
 1 AS `data_hora`,
 1 AS `login`,
 1 AS `acao`,
 1 AS `tabela_afetada`,
 1 AS `id_registro`,
 1 AS `antes`,
 1 AS `depois`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_produtividade_enfermagem`
--

DROP TABLE IF EXISTS `vw_produtividade_enfermagem`;
/*!50001 DROP VIEW IF EXISTS `vw_produtividade_enfermagem`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_produtividade_enfermagem` AS SELECT 
 1 AS `id_usuario`,
 1 AS `profissional`,
 1 AS `triagens_realizadas`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_atendimentos_por_tipo`
--

DROP TABLE IF EXISTS `vw_atendimentos_por_tipo`;
/*!50001 DROP VIEW IF EXISTS `vw_atendimentos_por_tipo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_atendimentos_por_tipo` AS SELECT 
 1 AS `tipo_atendimento`,
 1 AS `total`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_base_faturamento`
--

DROP TABLE IF EXISTS `vw_base_faturamento`;
/*!50001 DROP VIEW IF EXISTS `vw_base_faturamento`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_base_faturamento` AS SELECT 
 1 AS `id_atendimento`,
 1 AS `protocolo`,
 1 AS `nome_completo`,
 1 AS `tipo_atendimento`,
 1 AS `data_abertura`,
 1 AS `data_fechamento`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_fila_triagem`
--

DROP TABLE IF EXISTS `vw_fila_triagem`;
/*!50001 DROP VIEW IF EXISTS `vw_fila_triagem`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_fila_triagem` AS SELECT 
 1 AS `id_atendimento`,
 1 AS `protocolo`,
 1 AS `nome_completo`,
 1 AS `prioridade`,
 1 AS `motivo_procura`,
 1 AS `data_abertura`*/;
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
 1 AS `tipo_atendimento`,
 1 AS `prioridade`,
 1 AS `status_atendimento`,
 1 AS `local_atual`,
 1 AS `data_abertura`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_gestor_atendimentos_status`
--

DROP TABLE IF EXISTS `vw_gestor_atendimentos_status`;
/*!50001 DROP VIEW IF EXISTS `vw_gestor_atendimentos_status`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_gestor_atendimentos_status` AS SELECT 
 1 AS `status_atendimento`,
 1 AS `total`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_origem_pacientes`
--

DROP TABLE IF EXISTS `vw_origem_pacientes`;
/*!50001 DROP VIEW IF EXISTS `vw_origem_pacientes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_origem_pacientes` AS SELECT 
 1 AS `chegada`,
 1 AS `total`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_tempo_medio_atendimento`
--

DROP TABLE IF EXISTS `vw_tempo_medio_atendimento`;
/*!50001 DROP VIEW IF EXISTS `vw_tempo_medio_atendimento`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_tempo_medio_atendimento` AS SELECT 
 1 AS `data`,
 1 AS `total_atendimentos`,
 1 AS `tempo_medio_min`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_nao_atendidos`
--

DROP TABLE IF EXISTS `vw_nao_atendidos`;
/*!50001 DROP VIEW IF EXISTS `vw_nao_atendidos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_nao_atendidos` AS SELECT 
 1 AS `protocolo`,
 1 AS `nome_completo`,
 1 AS `data_abertura`,
 1 AS `data_fechamento`,
 1 AS `tempo_espera`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_atendimentos_por_local`
--

DROP TABLE IF EXISTS `vw_atendimentos_por_local`;
/*!50001 DROP VIEW IF EXISTS `vw_atendimentos_por_local`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_atendimentos_por_local` AS SELECT 
 1 AS `local`,
 1 AS `total_atendimentos`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_tipo_atendimento`
--

DROP TABLE IF EXISTS `vw_tipo_atendimento`;
/*!50001 DROP VIEW IF EXISTS `vw_tipo_atendimento`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_tipo_atendimento` AS SELECT 
 1 AS `tipo_atendimento`,
 1 AS `total`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_auditoria_status`
--

DROP TABLE IF EXISTS `vw_auditoria_status`;
/*!50001 DROP VIEW IF EXISTS `vw_auditoria_status`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_auditoria_status` AS SELECT 
 1 AS `tabela_afetada`,
 1 AS `id_registro`,
 1 AS `antes`,
 1 AS `depois`,
 1 AS `data_hora`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_classificacao_risco`
--

DROP TABLE IF EXISTS `vw_classificacao_risco`;
/*!50001 DROP VIEW IF EXISTS `vw_classificacao_risco`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_classificacao_risco` AS SELECT 
 1 AS `cor`,
 1 AS `total`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_mapa_leitos`
--

/*!50001 DROP VIEW IF EXISTS `vw_mapa_leitos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mapa_leitos` AS select `s`.`nome` AS `setor`,`l`.`identificacao` AS `leito`,`l`.`status` AS `status`,`p`.`nome_completo` AS `paciente`,`a`.`protocolo` AS `protocolo` from ((((`leito` `l` join `setor` `s` on((`s`.`id_setor` = `l`.`id_setor`))) left join `internacao` `i` on(((`i`.`id_leito` = `l`.`id_leito`) and (`i`.`status` = 'ATIVA')))) left join `atendimento` `a` on((`a`.`id_atendimento` = `i`.`id_atendimento`))) left join `pessoa` `p` on((`p`.`id_pessoa` = `a`.`id_pessoa`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_tempo_atendimento`
--

/*!50001 DROP VIEW IF EXISTS `vw_tempo_atendimento`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_tempo_atendimento` AS select `atendimento`.`id_atendimento` AS `id_atendimento`,`atendimento`.`protocolo` AS `protocolo`,timestampdiff(MINUTE,`atendimento`.`data_abertura`,`atendimento`.`data_fechamento`) AS `tempo_minutos` from `atendimento` where (`atendimento`.`status_atendimento` = 'FINALIZADO') */;
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
/*!50001 VIEW `vw_pacientes_internados` AS select `i`.`id_internacao` AS `id_internacao`,`a`.`id_atendimento` AS `id_atendimento`,`a`.`protocolo` AS `protocolo`,`p`.`nome_completo` AS `nome_completo`,`i`.`tipo` AS `tipo`,`l`.`identificacao` AS `leito`,`i`.`status` AS `status`,`i`.`data_entrada` AS `data_entrada` from (((`internacao` `i` join `atendimento` `a` on((`a`.`id_atendimento` = `i`.`id_atendimento`))) join `pessoa` `p` on((`p`.`id_pessoa` = `a`.`id_pessoa`))) join `leito` `l` on((`l`.`id_leito` = `i`.`id_leito`))) where (`i`.`status` = 'ATIVA') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_produtividade_medico`
--

/*!50001 DROP VIEW IF EXISTS `vw_produtividade_medico`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_produtividade_medico` AS select `u`.`id_usuario` AS `id_usuario`,`p`.`nome_completo` AS `medico`,count(`a`.`id_atendimento`) AS `atendimentos_realizados` from (((`atendimento` `a` join `prescricao` `pr` on((`pr`.`id_atendimento` = `a`.`id_atendimento`))) join `usuario` `u` on((`u`.`id_usuario` = `pr`.`id_medico`))) join `pessoa` `p` on((`p`.`id_pessoa` = `u`.`id_pessoa`))) where (`a`.`status_atendimento` = 'FINALIZADO') group by `u`.`id_usuario`,`p`.`nome_completo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_fila_atual`
--

/*!50001 DROP VIEW IF EXISTS `vw_fila_atual`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_fila_atual` AS select `a`.`id_atendimento` AS `id_atendimento`,`a`.`protocolo` AS `protocolo`,`p`.`nome_completo` AS `nome_completo`,`a`.`status_atendimento` AS `status_atendimento`,`l`.`nome` AS `local_atual`,`s`.`nome_exibicao` AS `sala`,`a`.`data_abertura` AS `data_abertura`,timestampdiff(MINUTE,`a`.`data_abertura`,now()) AS `tempo_espera_min` from (((`atendimento` `a` join `pessoa` `p` on((`p`.`id_pessoa` = `a`.`id_pessoa`))) join `local_atendimento` `l` on((`l`.`id_local` = `a`.`id_local_atual`))) left join `sala` `s` on((`s`.`id_sala` = `a`.`id_sala_atual`))) where (`a`.`status_atendimento` in ('ABERTO','EM_ATENDIMENTO','EM_OBSERVACAO')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_produtividade_medica`
--

/*!50001 DROP VIEW IF EXISTS `vw_produtividade_medica`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_produtividade_medica` AS select `u`.`id_usuario` AS `id_usuario`,`pe`.`nome_completo` AS `medico`,count(distinct `a`.`id_atendimento`) AS `atendimentos_realizados` from (((`atendimento` `a` join (select `anamnese`.`id_atendimento` AS `id_atendimento`,`anamnese`.`id_usuario` AS `id_usuario` from `anamnese` union select `prescricao`.`id_atendimento` AS `id_atendimento`,`prescricao`.`id_medico` AS `id_usuario` from `prescricao`) `atos` on((`atos`.`id_atendimento` = `a`.`id_atendimento`))) join `usuario` `u` on((`u`.`id_usuario` = `atos`.`id_usuario`))) join `pessoa` `pe` on((`pe`.`id_pessoa` = `u`.`id_pessoa`))) where (`a`.`status_atendimento` = 'FINALIZADO') group by `u`.`id_usuario`,`pe`.`nome_completo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_ocupacao_leitos`
--

/*!50001 DROP VIEW IF EXISTS `vw_ocupacao_leitos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_ocupacao_leitos` AS select `s`.`nome` AS `setor`,count(`l`.`id_leito`) AS `total_leitos`,sum((case when (`l`.`status` = 'OCUPADO') then 1 else 0 end)) AS `ocupados`,sum((case when (`l`.`status` = 'LIVRE') then 1 else 0 end)) AS `livres`,round(((sum((case when (`l`.`status` = 'OCUPADO') then 1 else 0 end)) / count(`l`.`id_leito`)) * 100),2) AS `taxa_ocupacao_percent` from (`leito` `l` join `setor` `s` on((`s`.`id_setor` = `l`.`id_setor`))) group by `s`.`nome` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_historico_paciente`
--

/*!50001 DROP VIEW IF EXISTS `vw_historico_paciente`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_historico_paciente` AS select `a`.`id_atendimento` AS `id_atendimento`,`a`.`protocolo` AS `protocolo`,`a`.`data_abertura` AS `data_abertura`,`a`.`data_fechamento` AS `data_fechamento`,`a`.`status_atendimento` AS `status_atendimento`,`p`.`nome_completo` AS `nome_completo` from (`atendimento` `a` join `pessoa` `p` on((`p`.`id_pessoa` = `a`.`id_pessoa`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_atendimentos_diarios`
--

/*!50001 DROP VIEW IF EXISTS `vw_atendimentos_diarios`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_atendimentos_diarios` AS select cast(`atendimento`.`data_abertura` as date) AS `dia`,count(0) AS `total` from `atendimento` group by cast(`atendimento`.`data_abertura` as date) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_tempo_internacao`
--

/*!50001 DROP VIEW IF EXISTS `vw_tempo_internacao`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_tempo_internacao` AS select `i`.`tipo` AS `tipo`,count(0) AS `total_pacientes`,round(avg(timestampdiff(HOUR,`i`.`data_entrada`,ifnull(`i`.`data_saida`,now()))),2) AS `tempo_medio_horas` from `internacao` `i` group by `i`.`tipo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_receitas_controladas`
--

/*!50001 DROP VIEW IF EXISTS `vw_receitas_controladas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_receitas_controladas` AS select `pr`.`id_prescricao` AS `id_prescricao`,`a`.`protocolo` AS `protocolo`,`pe`.`nome_completo` AS `paciente`,`pm`.`nome_completo` AS `medico`,`pr`.`data_hora` AS `data_hora` from ((((`prescricao` `pr` join `atendimento` `a` on((`a`.`id_atendimento` = `pr`.`id_atendimento`))) join `pessoa` `pe` on((`pe`.`id_pessoa` = `a`.`id_pessoa`))) join `usuario` `um` on((`um`.`id_usuario` = `pr`.`id_medico`))) join `pessoa` `pm` on((`pm`.`id_pessoa` = `um`.`id_pessoa`))) where (`pr`.`tipo` = 'CONTROLADA') */;
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
/*!50001 VIEW `vw_usuario_permissoes` AS select `u`.`id_usuario` AS `id_usuario`,`u`.`login` AS `login`,`pe`.`codigo` AS `permissao` from (((`usuario` `u` join `usuario_perfil` `up` on((`up`.`id_usuario` = `u`.`id_usuario`))) join `perfil_permissao` `pp` on((`pp`.`id_perfil` = `up`.`id_perfil`))) join `permissao` `pe` on((`pe`.`id_permissao` = `pp`.`id_permissao`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_retorno_paciente`
--

/*!50001 DROP VIEW IF EXISTS `vw_retorno_paciente`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_retorno_paciente` AS select `a`.`id_atendimento` AS `id_atendimento`,`a`.`protocolo` AS `protocolo`,`p`.`nome_completo` AS `nome_completo`,`r`.`data_hora` AS `data_retorno`,`r`.`motivo` AS `motivo` from ((`reabertura_atendimento` `r` join `atendimento` `a` on((`a`.`id_atendimento` = `r`.`id_atendimento`))) join `pessoa` `p` on((`p`.`id_pessoa` = `a`.`id_pessoa`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_auditoria`
--

/*!50001 DROP VIEW IF EXISTS `vw_auditoria`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_auditoria` AS select `la`.`data_hora` AS `data_hora`,`u`.`login` AS `login`,`la`.`acao` AS `acao`,`la`.`tabela_afetada` AS `tabela_afetada`,`la`.`id_registro` AS `id_registro`,`la`.`antes` AS `antes`,`la`.`depois` AS `depois` from (`log_auditoria` `la` left join `usuario` `u` on((`u`.`id_usuario` = `la`.`id_usuario`))) order by `la`.`data_hora` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_produtividade_enfermagem`
--

/*!50001 DROP VIEW IF EXISTS `vw_produtividade_enfermagem`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_produtividade_enfermagem` AS select `u`.`id_usuario` AS `id_usuario`,`p`.`nome_completo` AS `profissional`,count(distinct `t`.`id_triagem`) AS `triagens_realizadas` from ((`triagem` `t` join `usuario` `u` on((`u`.`id_usuario` = `t`.`id_enfermeiro`))) join `pessoa` `p` on((`p`.`id_pessoa` = `u`.`id_pessoa`))) group by `u`.`id_usuario`,`p`.`nome_completo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_atendimentos_por_tipo`
--

/*!50001 DROP VIEW IF EXISTS `vw_atendimentos_por_tipo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_atendimentos_por_tipo` AS select `atendimento_recepcao`.`tipo_atendimento` AS `tipo_atendimento`,count(0) AS `total` from `atendimento_recepcao` group by `atendimento_recepcao`.`tipo_atendimento` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_base_faturamento`
--

/*!50001 DROP VIEW IF EXISTS `vw_base_faturamento`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_base_faturamento` AS select `a`.`id_atendimento` AS `id_atendimento`,`a`.`protocolo` AS `protocolo`,`p`.`nome_completo` AS `nome_completo`,`ar`.`tipo_atendimento` AS `tipo_atendimento`,`a`.`data_abertura` AS `data_abertura`,`a`.`data_fechamento` AS `data_fechamento` from ((`atendimento` `a` join `pessoa` `p` on((`p`.`id_pessoa` = `a`.`id_pessoa`))) join `atendimento_recepcao` `ar` on((`ar`.`id_atendimento` = `a`.`id_atendimento`))) where (`a`.`status_atendimento` = 'FINALIZADO') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_fila_triagem`
--

/*!50001 DROP VIEW IF EXISTS `vw_fila_triagem`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_fila_triagem` AS select `a`.`id_atendimento` AS `id_atendimento`,`a`.`protocolo` AS `protocolo`,`p`.`nome_completo` AS `nome_completo`,`ar`.`prioridade` AS `prioridade`,`ar`.`motivo_procura` AS `motivo_procura`,`a`.`data_abertura` AS `data_abertura` from (((`atendimento` `a` join `pessoa` `p` on((`p`.`id_pessoa` = `a`.`id_pessoa`))) join `atendimento_recepcao` `ar` on((`ar`.`id_atendimento` = `a`.`id_atendimento`))) left join `triagem` `t` on((`t`.`id_atendimento` = `a`.`id_atendimento`))) where ((`ar`.`destino_inicial` = 'TRIAGEM') and (`t`.`id_triagem` is null)) */;
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
/*!50001 VIEW `vw_fila_atendimento` AS select `a`.`id_atendimento` AS `id_atendimento`,`a`.`protocolo` AS `protocolo`,`p`.`nome_completo` AS `nome_completo`,`ar`.`tipo_atendimento` AS `tipo_atendimento`,`ar`.`prioridade` AS `prioridade`,`a`.`status_atendimento` AS `status_atendimento`,`l`.`nome` AS `local_atual`,`a`.`data_abertura` AS `data_abertura` from (((`atendimento` `a` join `pessoa` `p` on((`p`.`id_pessoa` = `a`.`id_pessoa`))) left join `atendimento_recepcao` `ar` on((`ar`.`id_atendimento` = `a`.`id_atendimento`))) join `local_atendimento` `l` on((`l`.`id_local` = `a`.`id_local_atual`))) where (`a`.`status_atendimento` in ('ABERTO','EM_ATENDIMENTO','EM_OBSERVACAO')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_gestor_atendimentos_status`
--

/*!50001 DROP VIEW IF EXISTS `vw_gestor_atendimentos_status`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_gestor_atendimentos_status` AS select `atendimento`.`status_atendimento` AS `status_atendimento`,count(0) AS `total` from `atendimento` group by `atendimento`.`status_atendimento` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_origem_pacientes`
--

/*!50001 DROP VIEW IF EXISTS `vw_origem_pacientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_origem_pacientes` AS select `atendimento_recepcao`.`chegada` AS `chegada`,count(0) AS `total` from `atendimento_recepcao` group by `atendimento_recepcao`.`chegada` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_tempo_medio_atendimento`
--

/*!50001 DROP VIEW IF EXISTS `vw_tempo_medio_atendimento`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_tempo_medio_atendimento` AS select cast(`a`.`data_abertura` as date) AS `data`,count(0) AS `total_atendimentos`,round(avg(timestampdiff(MINUTE,`a`.`data_abertura`,`a`.`data_fechamento`)),2) AS `tempo_medio_min` from `atendimento` `a` where (`a`.`status_atendimento` = 'FINALIZADO') group by cast(`a`.`data_abertura` as date) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_nao_atendidos`
--

/*!50001 DROP VIEW IF EXISTS `vw_nao_atendidos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_nao_atendidos` AS select `a`.`protocolo` AS `protocolo`,`p`.`nome_completo` AS `nome_completo`,`a`.`data_abertura` AS `data_abertura`,`a`.`data_fechamento` AS `data_fechamento`,timestampdiff(MINUTE,`a`.`data_abertura`,`a`.`data_fechamento`) AS `tempo_espera` from (`atendimento` `a` join `pessoa` `p` on((`p`.`id_pessoa` = `a`.`id_pessoa`))) where (`a`.`status_atendimento` = 'NAO_ATENDIDO') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_atendimentos_por_local`
--

/*!50001 DROP VIEW IF EXISTS `vw_atendimentos_por_local`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_atendimentos_por_local` AS select `l`.`nome` AS `local`,count(0) AS `total_atendimentos` from (`atendimento` `a` join `local_atendimento` `l` on((`l`.`id_local` = `a`.`id_local_atual`))) group by `l`.`nome` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_tipo_atendimento`
--

/*!50001 DROP VIEW IF EXISTS `vw_tipo_atendimento`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_tipo_atendimento` AS select `atendimento_recepcao`.`tipo_atendimento` AS `tipo_atendimento`,count(0) AS `total` from `atendimento_recepcao` group by `atendimento_recepcao`.`tipo_atendimento` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_auditoria_status`
--

/*!50001 DROP VIEW IF EXISTS `vw_auditoria_status`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_auditoria_status` AS select `log_auditoria`.`tabela_afetada` AS `tabela_afetada`,`log_auditoria`.`id_registro` AS `id_registro`,`log_auditoria`.`antes` AS `antes`,`log_auditoria`.`depois` AS `depois`,`log_auditoria`.`data_hora` AS `data_hora` from `log_auditoria` where (`log_auditoria`.`acao` = 'UPDATE_STATUS') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_classificacao_risco`
--

/*!50001 DROP VIEW IF EXISTS `vw_classificacao_risco`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_classificacao_risco` AS select `cr`.`cor` AS `cor`,count(`t`.`id_triagem`) AS `total` from (`triagem` `t` join `classificacao_risco` `cr` on((`cr`.`id_risco` = `t`.`id_risco`))) group by `cr`.`cor` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Dumping events for database 'pronto_atendimento'
--

--
-- Dumping routines for database 'pronto_atendimento'
--
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
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_gera_protocolo`() RETURNS varchar(30) CHARSET utf8mb4 COLLATE utf8mb4_general_ci
    READS SQL DATA
BEGIN
    DECLARE seq INT;

    INSERT INTO protocolo_sequencia VALUES (NULL);
    SET seq = LAST_INSERT_ID();

    RETURN CONCAT(
        YEAR(NOW()),
        'GPAT/',
        LPAD(seq, 6, '0')
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_abertura_recepcao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_abertura_recepcao`(
    IN p_nome VARCHAR(200),
    IN p_cpf VARCHAR(14),
    IN p_cns VARCHAR(20),
    IN p_data_nascimento DATE,
    IN p_sexo ENUM('M','F','O'),
    IN p_tipo ENUM('CLINICO','PEDIATRICO','EMERGENCIA','EXAME_EXTERNO','MEDICACAO_EXTERNA'),
    IN p_chegada ENUM('MEIOS_PROPRIOS','AMBULANCIA','POLICIA','OUTROS'),
    IN p_prioridade ENUM('AUTISTA','CRIANCA_COLO','GESTANTE','IDOSO','NORMAL'),
    IN p_motivo TEXT,
    IN p_destino ENUM('TRIAGEM','MEDICO','EMERGENCIA','RX','MEDICACAO'),
    IN p_usuario BIGINT
)
BEGIN
    DECLARE v_id_pessoa BIGINT;
    DECLARE v_id_senha BIGINT;
    DECLARE v_id_atendimento BIGINT;

    -- Pessoa
    CALL sp_buscar_ou_criar_pessoa(
        p_nome, p_cpf, p_cns, p_data_nascimento, p_sexo, v_id_pessoa
    );

    -- Senha
    CALL sp_gerar_senha('RECEPCAO');
    SET v_id_senha = LAST_INSERT_ID();

    -- Atendimento
    CALL sp_abre_atendimento(
        v_id_pessoa,
        v_id_senha,
        1, -- local inicial (ex: recepção)
        NULL
    );
    SET v_id_atendimento = LAST_INSERT_ID();

    -- Recepção
    CALL sp_registrar_recepcao(
        v_id_atendimento,
        p_tipo,
        p_chegada,
        p_prioridade,
        p_motivo,
        p_destino,
        p_usuario
    );
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_abrir_atendimento_segura` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_abrir_atendimento_segura`(
    IN p_id_usuario BIGINT,
    IN p_id_pessoa BIGINT,
    IN p_id_senha BIGINT,
    IN p_id_local INT,
    IN p_id_especialidade INT,
    OUT p_id_atendimento BIGINT
)
BEGIN
    -- Verifica permissão do usuário
    IF NOT EXISTS (
        SELECT 1
        FROM usuario_perfil up
        JOIN permissao_procedure pp ON up.id_perfil = pp.id_perfil
        WHERE up.id_usuario = p_id_usuario
          AND pp.procedure_nome = 'sp_abrir_atendimento'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Permissão negada para abrir atendimento';
    ELSE
        -- Chama a procedure real de abertura de atendimento
        CALL sp_abrir_atendimento(p_id_pessoa, p_id_senha, p_id_local, p_id_especialidade);
        
        -- Retorna o ID do atendimento criado
        SET p_id_atendimento = LAST_INSERT_ID();
    END IF;
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
    IN p_id_internacao BIGINT
)
BEGIN
    UPDATE internacao
    SET status = 'ENCERRADA', data_saida = NOW()
    WHERE id_internacao = p_id_internacao;

    UPDATE leito
    SET status = 'LIVRE'
    WHERE id_leito = (
        SELECT id_leito FROM internacao WHERE id_internacao = p_id_internacao
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_buscar_ficha_atendimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscar_ficha_atendimento`(
    IN p_id_atendimento BIGINT
)
BEGIN

    -- 1. DADOS BASE E PACIENTE (JOIN 1:1)
    SELECT
        a.protocolo,
        a.status_atendimento,
        a.data_abertura,
        p.nome_completo,
        p.cpf,
        p.cns,
        ar.motivo_procura,
        ar.tipo_atendimento
    FROM atendimento a
    JOIN pessoa p ON p.id_pessoa = a.id_pessoa
    LEFT JOIN atendimento_recepcao ar ON ar.id_atendimento = a.id_atendimento
    WHERE a.id_atendimento = p_id_atendimento;

    -- 2. DADOS DE TRIAGEM E RISCO (JOIN 1:1)
    SELECT
        t.queixa,
        t.sinais_vitais, -- Campo JSON
        cr.cor,
        cr.descricao AS risco_descricao,
        t.data_hora AS dt_triagem
    FROM triagem t
    JOIN classificacao_risco cr ON cr.id_risco = t.id_risco
    WHERE t.id_atendimento = p_id_atendimento;

    -- 3. ANAMNESES E EXAMES FÍSICOS (LISTA 1:N)
    (SELECT 'ANAMNESE' AS tipo, descricao, data_hora FROM anamnese WHERE id_atendimento = p_id_atendimento)
    UNION ALL
    (SELECT 'EXAME_FISICO' AS tipo, descricao, data_hora FROM exame_fisico WHERE id_atendimento = p_id_atendimento)
    ORDER BY data_hora DESC;

    -- 4. PRESCRIÇÕES ATIVAS (LISTA 1:N)
    -- Prescrição Mestra
    SELECT
        pc.id_prescricao,
        pc.tipo,
        pc.data_hora,
        GROUP_CONCAT(pi.descricao SEPARATOR '; ') AS itens_prescritos
    FROM prescricao_continua pc
    JOIN prescricao_item pi ON pi.id_prescricao = pc.id_prescricao
    WHERE pc.id_atendimento = p_id_atendimento AND pc.ativa = TRUE
    GROUP BY pc.id_prescricao
    ORDER BY pc.data_hora DESC;
    
    -- 5. SOLICITAÇÕES DE EXAME (LISTA 1:N)
    SELECT
        se.id_solicitacao,
        e.descricao AS exame_nome,
        se.status,
        se.data_hora
    FROM solicitacao_exame se
    JOIN exame e ON e.id_exame = se.id_exame
    WHERE se.id_atendimento = p_id_atendimento
    ORDER BY se.data_hora DESC;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_buscar_ou_criar_pessoa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscar_ou_criar_pessoa`(
    IN p_nome VARCHAR(200),
    IN p_cpf VARCHAR(14),
    IN p_cns VARCHAR(20),
    IN p_data_nascimento DATE,
    IN p_sexo ENUM('M','F','O'),
    OUT p_id_pessoa BIGINT
)
BEGIN
    -- 1. Tenta localizar por CPF
    IF p_cpf IS NOT NULL AND p_cpf <> '' THEN
        SELECT id_pessoa INTO p_id_pessoa
        FROM pessoa
        WHERE cpf = p_cpf
        LIMIT 1;
    END IF;

    -- 2. Se não achou, tenta CNS
    IF p_id_pessoa IS NULL AND p_cns IS NOT NULL AND p_cns <> '' THEN
        SELECT id_pessoa INTO p_id_pessoa
        FROM pessoa
        WHERE cns = p_cns
        LIMIT 1;
    END IF;

    -- 3. Se não existir, cria
    IF p_id_pessoa IS NULL THEN
        INSERT INTO pessoa (
            nome_completo,
            cpf,
            cns,
            data_nascimento,
            sexo
        ) VALUES (
            p_nome,
            p_cpf,
            p_cns,
            p_data_nascimento,
            p_sexo
        );

        SET p_id_pessoa = LAST_INSERT_ID();
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_chamar_paciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_chamar_paciente`(
    IN p_id_atendimento BIGINT,
    IN p_id_sala INT
)
BEGIN
    INSERT INTO chamada_painel (id_atendimento, id_sala)
    VALUES (p_id_atendimento, p_id_sala);

    UPDATE senha
    SET chamada = TRUE
    WHERE id_senha = (
        SELECT id_senha FROM atendimento
        WHERE id_atendimento = p_id_atendimento
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_entrar_observacao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_entrar_observacao`(
    IN p_id_atendimento BIGINT,
    IN p_tipo ENUM('OBSERVACAO','INTERNACAO'),
    IN p_id_leito INT
)
BEGIN
    UPDATE atendimento
    SET status_atendimento = 
        CASE 
            WHEN p_tipo = 'INTERNACAO' THEN 'INTERNADO'
            ELSE 'EM_OBSERVACAO'
        END
    WHERE id_atendimento = p_id_atendimento;

    INSERT INTO atendimento_observacao (
        id_atendimento,
        tipo,
        id_leito
    )
    VALUES (
        p_id_atendimento,
        p_tipo,
        p_id_leito
    );
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
    IN p_id_atendimento BIGINT
)
BEGIN
    UPDATE atendimento
    SET status_atendimento = 'FINALIZADO',
        data_fechamento = NOW()
    WHERE id_atendimento = p_id_atendimento;
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
    IN p_origem ENUM('TOTEM','RECEPCAO')
)
BEGIN
    DECLARE prox_num INT;

    SELECT IFNULL(MAX(numero),0) + 1 INTO prox_num FROM senha
    WHERE DATE(data_hora) = CURDATE();

    INSERT INTO senha (numero, origem)
    VALUES (prox_num, p_origem);
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
    IN p_id_atendimento BIGINT,
    IN p_id_leito INT,
    IN p_tipo ENUM('OBSERVACAO','INTERNACAO')
)
BEGIN
    INSERT INTO internacao (id_atendimento, id_leito, tipo)
    VALUES (p_id_atendimento, p_id_leito, p_tipo);

    UPDATE leito SET status = 'OCUPADO' WHERE id_leito = p_id_leito;
    UPDATE atendimento SET status_atendimento = 'INTERNADO'
    WHERE id_atendimento = p_id_atendimento;
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
/*!50003 DROP PROCEDURE IF EXISTS `sp_reabrir_atendimento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reabrir_atendimento`(
    IN p_id_atendimento BIGINT,
    IN p_usuario BIGINT,
    IN p_motivo TEXT
)
BEGIN
    INSERT INTO reabertura_atendimento (
        id_atendimento,
        id_usuario,
        motivo
    ) VALUES (
        p_id_atendimento,
        p_usuario,
        p_motivo
    );

    UPDATE atendimento
    SET status_atendimento = 'RETORNO',
        data_fechamento = NULL
    WHERE id_atendimento = p_id_atendimento;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_recepcao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_recepcao`(
    IN p_id_atendimento BIGINT,
    IN p_tipo ENUM('CLINICO','PEDIATRICO','EMERGENCIA','EXAME_EXTERNO','MEDICACAO_EXTERNA'),
    IN p_chegada ENUM('MEIOS_PROPRIOS','AMBULANCIA','POLICIA','OUTROS'),
    IN p_prioridade ENUM('AUTISTA','CRIANCA_COLO','GESTANTE','IDOSO','NORMAL'),
    IN p_motivo TEXT,
    IN p_destino ENUM('TRIAGEM','MEDICO','EMERGENCIA','RX','MEDICACAO'),
    IN p_usuario BIGINT
)
BEGIN
    -- Calcula prioridade automaticamente quando não fornecida
    DECLARE v_prioridade ENUM('AUTISTA','CRIANCA_COLO','GESTANTE','IDOSO','NORMAL');
    DECLARE v_data_nasc DATE;
    DECLARE v_idade INT;

    SET v_prioridade = p_prioridade;

    IF v_prioridade IS NULL OR v_prioridade = '' THEN
        SELECT pe.data_nascimento INTO v_data_nasc
        FROM pessoa pe
        JOIN atendimento a ON a.id_pessoa = pe.id_pessoa
        WHERE a.id_atendimento = p_id_atendimento
        LIMIT 1;

        IF v_data_nasc IS NOT NULL THEN
            SET v_idade = TIMESTAMPDIFF(YEAR, v_data_nasc, CURDATE());

            IF v_idade >= 60 THEN
                SET v_prioridade = 'IDOSO';
            ELSEIF v_idade <= 2 THEN
                SET v_prioridade = 'CRIANCA_COLO';
            ELSE
                SET v_prioridade = 'NORMAL';
            END IF;
        ELSE
            SET v_prioridade = 'NORMAL';
        END IF;
    END IF;

    INSERT INTO atendimento_recepcao (
        id_atendimento,
        tipo_atendimento,
        chegada,
        prioridade,
        motivo_procura,
        destino_inicial,
        id_recepcionista
    )
    VALUES (
        p_id_atendimento,
        p_tipo,
        p_chegada,
        v_prioridade,
        p_motivo,
        p_destino,
        p_usuario
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_triagem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_triagem`(
    IN p_id_atendimento BIGINT,
    IN p_id_risco INT,
    IN p_queixa TEXT,
    IN p_sinais JSON,
    IN p_obs TEXT,
    IN p_enfermeiro BIGINT
)
BEGIN
    INSERT INTO triagem (
        id_atendimento,
        id_risco,
        queixa,
        sinais_vitais,
        observacao,
        id_enfermeiro
    )
    VALUES (
        p_id_atendimento,
        p_id_risco,
        p_queixa,
        p_sinais,
        p_obs,
        p_enfermeiro
    );

    UPDATE atendimento
    SET status_atendimento = 'EM_ATENDIMENTO'
    WHERE id_atendimento = p_id_atendimento;
END ;;
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

-- Dump completed on 2025-12-27  0:45:00
