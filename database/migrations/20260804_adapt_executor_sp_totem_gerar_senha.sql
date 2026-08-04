-- Migration: adapt_executor_sp_totem_gerar_senha
-- Data: 2026-08-04
-- Descrição: Adapta sp_executor_totem_gerar_senha para contrato do Dispatcher
-- Base: ADR-007, MD-GOV-001

DROP PROCEDURE IF EXISTS sp_executor_totem_gerar_senha ;;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_totem_gerar_senha`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
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
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_tipo_atendimento VARCHAR(30);
    DECLARE v_id_painel BIGINT;
    DECLARE v_id_totem BIGINT;
    DECLARE v_sucesso TINYINT DEFAULT 0;
    DECLARE v_mensagem VARCHAR(500) DEFAULT '';
    DECLARE v_resultado JSON DEFAULT JSON_OBJECT();
    DECLARE v_id_senha BIGINT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET v_sucesso = FALSE;
        SET v_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET v_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;
    END;

    -- =========================
    -- EXTRAIR PAYLOAD DO DISPATCHER
    -- =========================
    SET v_id_usuario = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_usuario'));
    SET v_id_perfil = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_perfil'));
    SET v_id_paciente = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_paciente'));
    SET v_tipo_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo_atendimento'));
    SET v_id_painel = JSON_UNQUOTE(JSON_EXCEPT(p_payload, '$.id_painel'));

    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET v_sucesso = FALSE;
        SET v_mensagem = 'Sessao invalida';
        SET v_resultado = JSON_OBJECT('error','Sessao invalida','uuid_transacao',v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    IF v_tipo_atendimento IS NULL OR v_tipo_atendimento = '' THEN
        SET v_tipo_atendimento = 'CLINICO';
    END IF;

    -- =========================
    -- VALIDAR SESSÃO
    -- =========================
    SELECT su.id_unidade, su.id_entidade, su.id_usuario, su.id_perfil
      INTO v_id_unidade, v_id_entidade, v_id_usuario, v_id_perfil
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao
       AND su.ativo = 1
     LIMIT 1;

    IF v_id_unidade IS NULL THEN
        SET v_sucesso = FALSE;
        SET v_mensagem = 'Unidade nao encontrada para a sessao';
        SET v_resultado = JSON_OBJECT('error','Unidade nao encontrada','uuid_transacao',v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    -- =========================
    -- BUSCAR CONFIGURAÇÃO DO PAINEL
    -- =========================
    IF v_id_painel IS NULL OR v_id_painel = 0 THEN
        SELECT id_painel INTO v_id_painel
        FROM painel
        WHERE tipo = 'TOTEM'
          AND id_unidade = v_id_unidade
          AND ativo = 1
        LIMIT 1;
    END IF;

    SELECT tso.prefixo, tso.codigo
      INTO v_prefixo, v_codigo_visual
      FROM totem_senha_opcao tso
     WHERE tso.id_painel = v_id_painel
       AND tso.tipo_atendimento = v_tipo_atendimento
       AND tso.ativo = 1
     LIMIT 1;

    IF v_prefixo IS NULL OR v_codigo_visual IS NULL THEN
        SET v_sucesso = FALSE;
        SET v_mensagem = CONCAT('Opcao nao encontrada para painel ', v_id_painel, ' tipo ', v_tipo_atendimento);
        SET v_resultado = JSON_OBJECT('error','Opcao nao encontrada','uuid_transacao',v_uuid_transacao);
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
        SET v_sucesso = FALSE;
        SET v_mensagem = 'Status EMITIDA nao encontrado';
        SET v_resultado = JSON_OBJECT('error','Status nao encontrado','uuid_transacao',v_uuid_transacao);
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
        COALESCE(v_id_paciente, NULL),
        'RECEPCAO',
        v_id_prioridade,
        v_id_status,
        v_id_usuario,
        NOW(6),
        UUID(),
        v_id_entidade
    );

    SET v_id_senha = LAST_INSERT_ID();

    -- =========================
    -- ATUALIZAR SEQUÊNCIA
    -- =========================
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

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao,
        v_id_usuario,
        v_id_perfil,
        'GERAR_SENHA',
        NULL,
        v_id_senha,
        JSON_OBJECT('tipo_atendimento', v_tipo_atendimento, 'numero_senha', v_numero_senha, 'prefixo', v_prefixo, 'dispatcher', p_payload),
        'SUCESSO',
        CONCAT('Senha gerada: ', v_numero_senha)
    );

    -- =========================
    -- EVENTO TOTEM
    -- =========================
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
        JSON_OBJECT('id_senha', v_id_senha, 'tipo_atendimento', v_tipo_atendimento),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem')),
        NOW(),
        v_id_entidade
    );

    COMMIT;

    SET v_sucesso = TRUE;
    SET v_mensagem = CONCAT('Senha gerada com sucesso: ', v_numero_senha);
    SET v_resultado = JSON_OBJECT(
        'id_senha', v_id_senha,
        'numero_senha', v_numero_senha,
        'tipo_atendimento', v_tipo_atendimento,
        'prefixo', v_prefixo,
        'uuid_transacao', v_uuid_transacao
    );

    SELECT JSON_OBJECT(
        'status', IF(v_sucesso, 'SUCCESS', 'ERROR'),
        'sucesso', v_sucesso,
        'resultado', v_resultado,
        'mensagem', v_mensagem,
        'id_senha', v_id_senha,
        'uuid', v_uuid_transacao,
        'executor', 'sp_executor_totem_gerar_senha'
    ) AS result;

END ;;
DELIMITER ;
