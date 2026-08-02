-- Migration: align_sp_orquestrador_assistencial
-- Data: 2026-07-26
-- Descricao: Alinha sp_orquestrador_assistencial com o dump real de producao

DROP PROCEDURE IF EXISTS $sp;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_orquestrador_assistencial`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_saas_entidade BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local BIGINT,
    IN p_id_senha BIGINT,
    IN p_acao VARCHAR(60),
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_fluxo_origem BIGINT;
    DECLARE v_fluxo_destino BIGINT;

    START TRANSACTION;

    SELECT id_fluxo_status
    INTO v_fluxo_origem
    FROM senha
    WHERE id_senha = p_id_senha
    AND id_saas_entidade = p_id_saas_entidade
    AND id_unidade = p_id_unidade
    FOR UPDATE;

    SELECT fluxo_destino
    INTO v_fluxo_destino
    FROM fluxo_transicao_matriz
    WHERE fluxo_origem = v_fluxo_origem
    AND acao_permitida = p_acao
    AND ativo = TRUE
    LIMIT 1;

    IF v_fluxo_destino IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transicao nao permitida pelo orquestrador';
    END IF;

    UPDATE senha
    SET
        id_fluxo_status = v_fluxo_destino,
        estado_snapshot = p_payload,
        hash_estado = SHA2(IFNULL(JSON_UNQUOTE(p_payload), ''), 256),
        id_sessao_usuario = p_id_sessao_usuario,
        atualizado_em = CURRENT_TIMESTAMP(6)
    WHERE id_senha = p_id_senha;

    INSERT INTO atendimento_evento (
        id_entidade,
        id_ffa,
        tipo_evento,
        contexto_fluxo,
        payload,
        id_sessao_usuario
    )
    SELECT
        p_id_saas_entidade,
        id_ffa,
        p_acao,
        contexto_fluxo,
        p_payload,
        p_id_sessao_usuario
    FROM senha
    WHERE id_senha = p_id_senha;

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

