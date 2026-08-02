DROP PROCEDURE IF EXISTS test_dispatcher_step_by_step;
DELIMITER ;;
CREATE PROCEDURE test_dispatcher_step_by_step()
BEGIN
    DECLARE v_id_usuario, v_id_unidade, v_id_saas, v_id_local, v_id_perfil BIGINT;
    DECLARE v_ativo TINYINT;
    DECLARE v_nome_sp VARCHAR(120);
    DECLARE v_uuid CHAR(36);
    DECLARE v_hash CHAR(64);
    DECLARE v_id_evento BIGINT DEFAULT 0;
    DECLARE v_estado_atual, v_estado_destino VARCHAR(50);
    DECLARE v_msg TEXT;
    
    DECLARE v_id_atendimento_vinculo BIGINT;
    DECLARE v_ip VARCHAR(45);
    DECLARE v_device VARCHAR(255);

    SET v_uuid = UUID();
    SET @p_pay = JSON_OBJECT('id_opcao', 1, 'id_unidade', 2, 'id_local_operacional', 1);

    SELECT 'step1' AS step, v_uuid AS uuid;

    SELECT id_usuario, id_unidade, id_entidade, id_local, id_perfil, ativo
    INTO v_id_usuario, v_id_unidade, v_id_saas, v_id_local, v_id_perfil, v_ativo
    FROM sessao_usuario WHERE id_sessao_usuario = 201 LIMIT 1;

    SELECT 'step2' AS step, v_id_usuario AS id_usuario, v_id_unidade AS id_unidade, v_id_saas AS id_saas;

    SET v_hash = SHA2(CONCAT(v_uuid, CAST(@p_pay AS CHAR)), 256);

    SELECT nome_procedure INTO v_nome_sp FROM permissao
    WHERE codigo = CONCAT(UPPER('TOTEM'), '.', UPPER('GERAR_SENHA')) AND ativo = 1 LIMIT 1;

    SELECT 'step3' AS step, v_nome_sp AS nome_sp;

    SET @p_sessao = 201;
    SET @p_acao = 'GERAR_SENHA';
    SET @p_ref = 1;
    SET @p_pay = JSON_OBJECT('id_opcao', 1, 'id_unidade', 2, 'id_local_operacional', 1);

    SET @sql_call = CONCAT('CALL ', v_nome_sp, '(?, ?, ?, ?)');
    
    SELECT 'step4' AS step, @sql_call AS sql_call;

    PREPARE stmt FROM @sql_call;
    EXECUTE stmt USING @p_sessao, @p_acao, @p_ref, @p_pay;
    DEALLOCATE PREPARE stmt;

    SELECT 'step5' AS step, 'executor_ok' AS status;
END ;;
DELIMITER ;
