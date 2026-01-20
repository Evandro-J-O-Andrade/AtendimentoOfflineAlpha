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
-- Temporary view structure for view `vw_painel_chamadas_ativas`
--

DROP TABLE IF EXISTS `vw_painel_chamadas_ativas`;
/*!50001 DROP VIEW IF EXISTS `vw_painel_chamadas_ativas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_painel_chamadas_ativas` AS SELECT 
 1 AS `id_chamada`,
 1 AS `id_atendimento`,
 1 AS `id_senha`,
 1 AS `numero_senha`,
 1 AS `prefixo`,
 1 AS `id_sala`,
 1 AS `sala`,
 1 AS `chamado_em`*/;
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
-- Temporary view structure for view `vw_usuario_permissoes`
--

DROP TABLE IF EXISTS `vw_usuario_permissoes`;
/*!50001 DROP VIEW IF EXISTS `vw_usuario_permissoes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_usuario_permissoes` AS SELECT 
 1 AS `id_usuario`,
 1 AS `login`,
 1 AS `ativo`,
 1 AS `primeiro_login`,
 1 AS `senha_expira_em`,
 1 AS `perfis`*/;
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
/*!50001 VIEW `vw_painel_chamadas_ativas` AS select `cp`.`id_chamada` AS `id_chamada`,`a`.`id_atendimento` AS `id_atendimento`,`s`.`id` AS `id_senha`,`s`.`numero` AS `numero_senha`,`s`.`prefixo` AS `prefixo`,`sa`.`id_sala` AS `id_sala`,`sa`.`nome_exibicao` AS `sala`,`cp`.`data_hora` AS `chamado_em` from (((`chamada_painel` `cp` join `atendimento` `a` on((`a`.`id_atendimento` = `cp`.`id_atendimento`))) join `senhas` `s` on((`s`.`id` = `a`.`id_senha`))) left join `sala` `sa` on((`sa`.`id_sala` = `cp`.`id_sala`))) where (`cp`.`status` = 'CHAMANDO') order by `cp`.`data_hora` desc */;
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
/*!50001 VIEW `vw_usuario_permissoes` AS select `u`.`id_usuario` AS `id_usuario`,`u`.`login` AS `login`,`u`.`ativo` AS `ativo`,`u`.`primeiro_login` AS `primeiro_login`,`u`.`senha_expira_em` AS `senha_expira_em`,group_concat(`p`.`nome` order by `p`.`nome` ASC separator ',') AS `perfis` from ((`usuario` `u` left join `usuario_perfil` `up` on((`u`.`id_usuario` = `up`.`id_usuario`))) left join `perfil` `p` on((`up`.`id_perfil` = `p`.`id_perfil`))) group by `u`.`id_usuario`,`u`.`login`,`u`.`ativo`,`u`.`primeiro_login`,`u`.`senha_expira_em` */;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_usuario_tem_perfil`(
    p_id_usuario BIGINT,
    p_nome_perfil VARCHAR(50)
) RETURNS tinyint
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_count
    FROM usuario_perfil up
    JOIN perfil p ON up.id_perfil = up.id_perfil
    WHERE up.id_usuario = p_id_usuario
      AND p.nome = p_nome_perfil;

    RETURN IF(v_count > 0, 1, 0);
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
    IN p_id_local INT
)
BEGIN
    DECLARE v_id_farmaco BIGINT;
    DECLARE v_validade DATE;
    DECLARE v_dias INT;
    DECLARE v_risco VARCHAR(20);
    DECLARE v_estoque INT;

    -- Dados do lote
    SELECT id_farmaco, data_validade
      INTO v_id_farmaco, v_validade
    FROM lote
    WHERE id_lote = p_id_lote;

    SET v_dias = fn_dias_para_vencimento(v_validade);

    SET v_risco =
        CASE
            WHEN v_dias < 0 THEN 'VENCIDO'
            WHEN v_dias <= 30 THEN 'CRITICO'
            ELSE 'OK'
        END;

    -- Bloqueio sanitário
    IF v_risco = 'VENCIDO' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Saída bloqueada: medicamento vencido';
    END IF;

    -- Estoque atual
    SELECT quantidade_atual
      INTO v_estoque
    FROM estoque_local
    WHERE id_farmaco = v_id_farmaco
      AND id_local = p_id_local
    FOR UPDATE;

    IF v_estoque < p_quantidade THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estoque insuficiente';
    END IF;

    -- Atualiza estoque
    UPDATE estoque_local
       SET quantidade_atual = quantidade_atual - p_quantidade
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local;

    -- Auditoria
    INSERT INTO auditoria_estoque_sanitario
        (id_farmaco, id_lote, id_local, quantidade, nivel_risco, criado_por)
    VALUES
        (v_id_farmaco, p_id_lote, p_id_local, p_quantidade, v_risco, p_id_usuario);

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
    IN p_id_cidade BIGINT,
    IN p_quantidade INT,
    IN p_origem ENUM('COMPRA','TRANSFERENCIA','AJUSTE'),
    IN p_usuario BIGINT
)
BEGIN
    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, realizado_por)
    VALUES
        (p_id_farmaco, p_id_lote, p_id_cidade, 'ENTRADA', p_quantidade, p_origem, p_usuario);
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
    IN p_id_local INT,
    IN p_quantidade INT,
    IN p_id_ffa BIGINT,
    IN p_usuario BIGINT
)
BEGIN
    DECLARE v_saldo_atual INT DEFAULT 0;

    /* 1. BLOQUEIO SANITÁRIO */
    IF fn_farmaco_lote_valido(p_id_lote) = FALSE THEN

        INSERT INTO farmaco_auditoria_bloqueio
            (id_farmaco, id_lote, id_cidade, quantidade, id_ffa, usuario, motivo)
        VALUES
            (p_id_farmaco, p_id_lote, p_id_local, p_quantidade, p_id_ffa, p_usuario,
             'Tentativa de saída com lote vencido');

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lote vencido. Saída bloqueada.';
    END IF;

    /* 2. VERIFICA SALDO */
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
            (p_id_farmaco, p_id_lote, p_id_local, p_quantidade, p_id_ffa, p_usuario,
             'Tentativa de saída sem saldo suficiente');

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque insuficiente.';
    END IF;

    /* 3. DEBITA ESTOQUE */
    UPDATE estoque_local
       SET quantidade_atual = quantidade_atual - p_quantidade
     WHERE id_farmaco = p_id_farmaco
       AND id_local = p_id_local;

    /* 4. REGISTRA MOVIMENTAÇÃO */
    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, id_ffa, realizado_por)
    VALUES
        (p_id_farmaco, p_id_lote, p_id_local, 'SAIDA', p_quantidade,
         'PACIENTE', p_id_ffa, p_usuario);

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
    INSERT INTO farmaco_unidade
        (id_farmaco, id_cidade, cota_minima, atualizado_por)
    VALUES
        (p_id_farmaco, p_id_cidade, p_cota_minima, p_usuario)
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
    IN p_id_ordem     BIGINT,
    IN p_id_usuario   BIGINT,
    IN p_lote         VARCHAR(50),
    IN p_validade     DATE,
    IN p_observacao   TEXT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    /* 1️⃣ Valida ordem */
    SELECT id_ffa
      INTO v_id_ffa
      FROM ordem_assistencial
     WHERE id = p_id_ordem
       AND tipo_ordem = 'MEDICACAO'
       AND status = 'ATIVA';

    IF v_id_ffa IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ordem de medicação inválida ou não ativa';
    END IF;

    /* 2️⃣ Registra liberação */
    INSERT INTO dispensacao_medicacao (
        id_ordem,
        id_ffa,
        lote,
        validade,
        liberado_por,
        observacao,
        liberado_em
    ) VALUES (
        p_id_ordem,
        v_id_ffa,
        p_lote,
        p_validade,
        p_id_usuario,
        p_observacao,
        NOW()
    );

    /* 3️⃣ Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        v_id_ffa,
        'LIBERACAO_MEDICACAO',
        'FARMACIA',
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
    ORDER BY
        prioridade DESC,
        iniciado_em ASC;
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-17 22:11:56
