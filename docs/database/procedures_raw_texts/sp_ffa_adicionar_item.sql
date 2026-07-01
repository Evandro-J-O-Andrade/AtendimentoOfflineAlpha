CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_adicionar_item`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_id_ffa BIGINT,
    IN p_tipo_item VARCHAR(50),
    IN p_descricao_item VARCHAR(255),
    IN p_quantidade INT,
    OUT p_id_item BIGINT,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
    SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;
    END;

    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    INSERT INTO ffa_item (
        id_ffa,
        tipo_item,
        descricao_item,
        quantidade,
        criado_por,
        criado_em
    ) VALUES (
        p_id_ffa,
        p_tipo_item,
        p_descricao_item,
        p_quantidade,
        p_id_usuario,
        NOW(6)
    );

    SET p_id_item = LAST_INSERT_ID();

    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'FFA_ADICIONAR_ITEM',
        NULL, p_id_item,
        JSON_OBJECT('id_ffa', p_id_ffa, 'tipo_item', p_tipo_item),
        'SUCESSO', 'Item adicionado à FFA'
    );

    SET p_sucesso = TRUE;
    SET p_mensagem = 'Item adicionado à FFA com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_item', p_id_item,
        'id_ffa', p_id_ffa,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;
END ;;