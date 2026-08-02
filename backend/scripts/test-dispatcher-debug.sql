DROP PROCEDURE IF EXISTS test_dispatcher_debug;
DELIMITER ;;
CREATE PROCEDURE test_dispatcher_debug()
BEGIN
    DECLARE v_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT;
        INSERT INTO erro_evento (
            id_sessao_usuario, dominio, acao, mensagem_erro, payload_tentativa, stack_trace, uuid_transacao
        ) VALUES (
            201, 'TOTEM', 'GERAR_SENHA', LEFT(v_msg, 4000), '{}', JSON_OBJECT('test', 1), UUID()
        );
        SELECT LEFT(v_msg, 4000) AS real_error;
    END;

    SET @p_sessao = 201;
    SET @p_uuid = UUID();
    SET @p_dominio = 'TOTEM';
    SET @p_acao = 'GERAR_SENHA';
    SET @p_ref = 1;
    SET @p_pay = JSON_OBJECT('id_opcao', 1, 'id_unidade', 2, 'id_local_operacional', 1);

    CALL sp_master_dispatcher(@p_sessao, @p_uuid, @p_dominio, @p_acao, @p_ref, @p_pay);
    SELECT 'success' AS result;
END ;;
DELIMITER ;
