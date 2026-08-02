DROP PROCEDURE IF EXISTS sp_totem_gerar_senha;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_totem_gerar_senha`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_id_paciente BIGINT,
    IN p_tipo_atendimento VARCHAR(30),
    IN p_id_painel BIGINT,
    OUT p_id_senha BIGINT,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_numero_senha VARCHAR(20);
    DECLARE v_codigo_visual VARCHAR(10);
    DECLARE v_prefixo VARCHAR(5);
    DECLARE v_id_status BIGINT DEFAULT 1;
    DECLARE v_id_prioridade BIGINT DEFAULT 1;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_entidade BIGINT;
    DECLARE v_id_totem BIGINT;

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
        SET p_resultado = JSON_OBJECT('error','Sessão inválida','uuid_transacao',v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    IF p_tipo_atendimento IS NULL OR p_tipo_atendimento = '' THEN
        SET p_tipo_atendimento = 'CLINICO';
    END IF;

    SELECT su.id_unidade, su.id_entidade
      INTO v_id_unidade, v_id_entidade
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao
       AND su.ativo = 1
     LIMIT 1;

    IF v_id_unidade IS NULL THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Unidade não encontrada para a sessão';
        SET p_resultado = JSON_OBJECT('error','Unidade não encontrada','uuid_transacao',v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    SELECT tso.prefixo, tso.codigo
      INTO v_prefixo, v_codigo_visual
      FROM totem_senha_opcao tso
     WHERE tso.id_painel = p_id_painel
       AND tso.tipo_atendimento = p_tipo_atendimento
       AND tso.ativo = 1
     LIMIT 1;

    IF v_prefixo IS NULL OR v_codigo_visual IS NULL THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('Opção não encontrada: ', p_tipo_atendimento);
        SET p_resultado = JSON_OBJECT('error','Opção não encontrada','uuid_transacao',v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    SELECT ss.id_senha_status, ss.codigo
      INTO v_id_status, v_codigo_visual
      FROM senha_status ss
     WHERE ss.codigo = 'EMITIDA'
       AND ss.ativo = 1
     LIMIT 1;

    IF v_id_status IS NULL THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Status EMITIDA não encontrado';
        SET p_resultado = JSON_OBJECT('error','Status não encontrado','uuid_transacao',v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    SET v_numero_senha = CONCAT(
        v_prefixo,
        LPAD(
            IFNULL(
                (SELECT IFNULL(MAX(ultimo_numero), 0) + 1
                 FROM senha_sequencia
                 WHERE id_unidade = v_id_unidade
                   AND prefixo = v_prefixo
                   AND DATE(data_ref) = CURDATE()), 1), 3, '0'
        )
    );

    INSERT INTO senha (
        id_unidade,
        codigo_visual,
        id_paciente,
        origem_entrada,
        id_prioridade,
        id_fluxo_status,
        id_sessao_usuario,
        criado_em,
        uuid_sync,
        id_entidade
    ) VALUES (
        v_id_unidade,
        v_numero_senha,
        p_id_paciente,
        'RECEPCAO',
        v_id_prioridade,
        v_id_status,
        p_id_usuario,
        NOW(6),
        UUID(),
        v_id_entidade
    );

    SET p_id_senha = LAST_INSERT_ID();

    UPDATE senha_sequencia
       SET ultimo_numero = ultimo_numero + 1,
           data_ref = CURDATE()
     WHERE id_unidade = v_id_unidade
       AND prefixo = v_prefixo
       AND DATE(data_ref) = CURDATE();

    IF ROW_COUNT() = 0 THEN
        INSERT INTO senha_sequencia (
            id_sistema,
            id_unidade,
            data_ref,
            prefixo,
            ultimo_numero,
            id_entidade
        ) VALUES (
            1,
            v_id_unidade,
            CURDATE(),
            v_prefixo,
            1,
            v_id_entidade
        );
    END IF;

    CALL sp_ledger_evento_log(
        v_uuid_transacao,
        p_id_usuario,
        p_id_perfil,
        'GERAR_SENHA',
        NULL,
        p_id_senha,
        JSON_OBJECT('tipo_atendimento', p_tipo_atendimento, 'numero_senha', v_numero_senha, 'prefixo', v_prefixo),
        'SUCESSO',
        CONCAT('Senha gerada: ', v_numero_senha)
    );

    SELECT t.id_totem INTO v_id_totem
    FROM totem t
    WHERE t.id_unidade = v_id_unidade
      AND t.ativo = 1
    LIMIT 1;

    IF v_id_totem IS NULL THEN
        SET v_id_totem = 0;
    END IF;

    INSERT INTO totem_evento (
        id_totem,
        evento,
        detalhe,
        ip_acesso,
        criado_em,
        id_entidade
    ) VALUES (
        v_id_totem,
        'SENHA_GERADA',
        JSON_OBJECT('id_senha', p_id_senha, 'tipo_atendimento', p_tipo_atendimento),
        NULL,
        NOW(),
        v_id_entidade
    );

    COMMIT;

    SET p_sucesso = TRUE;
    SET p_mensagem = CONCAT('Senha gerada com sucesso: ', v_numero_senha);
    SET p_resultado = JSON_OBJECT(
        'id_senha', p_id_senha,
        'numero_senha', v_numero_senha,
        'tipo_atendimento', p_tipo_atendimento,
        'prefixo', v_prefixo,
        'uuid_transacao', v_uuid_transacao
    );

END ;;
DELIMITER ;
