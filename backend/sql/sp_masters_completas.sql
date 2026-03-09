-- ============================================================
-- STORED PROCEDURES COMPLETAS - PADRÃO DISPATCHER + LEDGER
-- Todas seguem: UUID + TRANSACTION + HANDLER + AUDITORIA
-- ============================================================

DELIMITER $$

-- ============================================================
-- 1. SP MASTER ATENDIMENTO INICIAR
-- ============================================================
DROP PROCEDURE IF EXISTS sp_master_atendimento_iniciar$$

CREATE PROCEDURE sp_master_atendimento_iniciar(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_atendimento BIGINT DEFAULT NULL;
    DECLARE v_protocolo VARCHAR(30) DEFAULT NULL;

    -- HANDLER GLOBAL DE ERRO
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_master_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_INICIAR',
            NULL, 'INICIADO', p_payload, 'ERRO', v_error_msg
        );
    END;

    -- VALIDAR SESSÃO
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- EXTRAIR DADOS DO PAYLOAD
    SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
    
    -- GERAR PROTOCOLO
    SET v_protocolo = CONCAT('ATD-', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'));

    -- INSERIR ATENDIMENTO
    INSERT INTO atendimento (
        id_atendimento,
        protocolo,
        id_pessoa,
        id_unidade,
        status_atendimento,
        status,
        data_abertura
    ) VALUES (
        COALESCE(v_id_atendimento, (SELECT MAX(id_atendimento) + 1 FROM atendimento)),
        v_protocolo,
        COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_pessoa')), 0),
        COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')), 1),
        'ABERTO',
        'ABERTO',
        NOW()
    );

    SET v_id_atendimento = LAST_INSERT_ID();

    -- REGISTRAR NO LEDGER
    CALL sp_master_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_INICIAR',
        NULL, 'INICIADO', p_payload, 'SUCESSO', CONCAT('Atendimento ', v_id_atendimento, ' iniciado')
    );

    -- RETORNO
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Atendimento iniciado com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_atendimento', v_id_atendimento,
        'protocolo', v_protocolo,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END$$

-- ============================================================
-- 2. SP MASTER ATENDIMENTO TRANSICIONAR
-- ============================================================
DROP PROCEDURE IF EXISTS sp_master_atendimento_transicionar$$

CREATE PROCEDURE sp_master_atendimento_transicionar(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_atendimento BIGINT DEFAULT NULL;
    DECLARE v_estado_origem VARCHAR(50) DEFAULT NULL;
    DECLARE v_estado_destino VARCHAR(50) DEFAULT NULL;
    DECLARE v_id_fluxo_status BIGINT DEFAULT NULL;

    -- HANDLER GLOBAL DE ERRO
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_master_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_TRANSICIONAR',
            v_estado_origem, v_estado_destino, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- VALIDAR SESSÃO
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- EXTRAIR DADOS DO PAYLOAD
    SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
    SET v_estado_destino = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.status'));

    -- BUSCAR ESTADO ATUAL
    SELECT fs.codigo INTO v_estado_origem
    FROM senha s
    JOIN fluxo_status fs ON fs.id_fluxo_status = s.id_fluxo_status
    WHERE s.id_atendimento = v_id_atendimento
    ORDER BY s.criado_em DESC
    LIMIT 1;

    -- SE NÃO TIVER STATUS ANTERIOR, USA INICIO
    IF v_estado_origem IS NULL THEN
        SET v_estado_origem = 'INICIO';
    END IF;

    -- BUSCAR ID DO FLUXO STATUS
    SELECT id_fluxo_status INTO v_id_fluxo_status
    FROM fluxo_status
    WHERE codigo = v_estado_destino
    LIMIT 1;

    -- SE NÃO EXISTIR, CRIA NOVO REGISTRO
    IF v_id_fluxo_status IS NULL THEN
        INSERT INTO fluxo_status (codigo, descricao, tipo, ativo, criado_em)
        VALUES (v_estado_destino, CONCAT('Status: ', v_estado_destino), 'OPERACIONAL', 1, NOW(6));
        SET v_id_fluxo_status = LAST_INSERT_ID();
    END IF;

    -- INSERIR NOVO STATUS NA SENHA
    INSERT INTO senha (
        id_atendimento,
        id_fluxo_status,
        id_pessoa,
        codigo_visual,
        contexto_fluxo,
        prioridade,
        ordem_fila,
        uuid_sync,
        criado_em
    ) VALUES (
        v_id_atendimento,
        v_id_fluxo_status,
        COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_pessoa')), 0),
        CONCAT('ATD-', LPAD(v_id_atendimento, 6, '0')),
        v_estado_destino,
        0,
        0,
        v_uuid_transacao,
        NOW(6)
    );

    -- ATUALIZAR ATENDIMENTO
    UPDATE atendimento
    SET status_atendimento = v_estado_destino,
        status = v_estado_destino
    WHERE id_atendimento = v_id_atendimento;

    -- REGISTRAR NO LEDGER
    CALL sp_master_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_TRANSICIONAR',
        v_estado_origem, v_estado_destino, p_payload, 'SUCESSO',
        CONCAT('Transição: ', v_estado_origem, ' -> ', v_estado_destino)
    );

    -- RETORNO
    SET p_sucesso = TRUE;
    SET p_mensagem = CONCAT('Atendimento transicionado para ', v_estado_destino);
    SET p_resultado = JSON_OBJECT(
        'id_atendimento', v_id_atendimento,
        'status_anterior', v_estado_origem,
        'status_novo', v_estado_destino,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END$$

-- ============================================================
-- 3. SP MASTER ATENDIMENTO FINALIZAR
-- ============================================================
DROP PROCEDURE IF EXISTS sp_master_atendimento_finalizar$$

CREATE PROCEDURE sp_master_atendimento_finalizar(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_atendimento BIGINT DEFAULT NULL;
    DECLARE v_estado_origem VARCHAR(50) DEFAULT NULL;
    DECLARE v_estado_destino VARCHAR(50) DEFAULT 'FINALIZADO';

    -- HANDLER GLOBAL DE ERRO
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_master_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_FINALIZAR',
            v_estado_origem, v_estado_destino, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- VALIDAR SESSÃO
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- EXTRAIR DADOS DO PAYLOAD
    SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));

    -- BUSCAR ESTADO ATUAL
    SELECT fs.codigo INTO v_estado_origem
    FROM senha s
    JOIN fluxo_status fs ON fs.id_fluxo_status = s.id_fluxo_status
    WHERE s.id_atendimento = v_id_atendimento
    ORDER BY s.criado_em DESC
    LIMIT 1;

    -- INSERIR STATUS FINALIZADO
    INSERT INTO senha (
        id_atendimento,
        id_fluxo_status,
        codigo_visual,
        contexto_fluxo,
        uuid_sync,
        criado_em
    ) VALUES (
        v_id_atendimento,
        (SELECT id_fluxo_status FROM fluxo_status WHERE codigo = 'FINALIZADO' LIMIT 1),
        CONCAT('ATD-', LPAD(v_id_atendimento, 6, '0')),
        'FINALIZADO',
        v_uuid_transacao,
        NOW(6)
    );

    -- ATUALIZAR ATENDIMENTO
    UPDATE atendimento
    SET status_atendimento = 'FINALIZADO',
        status = 'FINALIZADO',
        data_fechamento = NOW()
    WHERE id_atendimento = v_id_atendimento;

    -- REGISTRAR NO LEDGER
    CALL sp_master_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_FINALIZAR',
        v_estado_origem, v_estado_destino, p_payload, 'SUCESSO',
        CONCAT('Atendimento ', v_id_atendimento, ' finalizado')
    );

    -- RETORNO
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Atendimento finalizado com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_atendimento', v_id_atendimento,
        'status_anterior', v_estado_origem,
        'status_novo', v_estado_destino,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END$$

-- ============================================================
-- 4. SP MASTER ATENDIMENTO CANCELAR
-- ============================================================
DROP PROCEDURE IF EXISTS sp_master_atendimento_cancelar$$

CREATE PROCEDURE sp_master_atendimento_cancelar(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_atendimento BIGINT DEFAULT NULL;
    DECLARE v_estado_origem VARCHAR(50) DEFAULT NULL;
    DECLARE v_estado_destino VARCHAR(50) DEFAULT 'EVASAO';
    DECLARE v_motivo VARCHAR(500) DEFAULT NULL;

    -- HANDLER GLOBAL DE ERRO
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_master_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_CANCELAR',
            v_estado_origem, v_estado_destino, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- VALIDAR SESSÃO
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- EXTRAIR DADOS DO PAYLOAD
    SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
    SET v_motivo = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.motivo'));

    -- BUSCAR ESTADO ATUAL
    SELECT fs.codigo INTO v_estado_origem
    FROM senha s
    JOIN fluxo_status fs ON fs.id_fluxo_status = s.id_fluxo_status
    WHERE s.id_atendimento = v_id_atendimento
    ORDER BY s.criado_em DESC
    LIMIT 1;

    -- INSERIR STATUS CANCELADO/EVASAO
    INSERT INTO senha (
        id_atendimento,
        id_fluxo_status,
        codigo_visual,
        contexto_fluxo,
        cancelado,
        cancelado_em,
        cancelado_por,
        uuid_sync,
        criado_em
    ) VALUES (
        v_id_atendimento,
        (SELECT id_fluxo_status FROM fluxo_status WHERE codigo = 'EVASAO' LIMIT 1),
        CONCAT('ATD-', LPAD(v_id_atendimento, 6, '0')),
        'EVASAO',
        1,
        NOW(6),
        p_id_usuario,
        v_uuid_transacao,
        NOW(6)
    );

    -- ATUALIZAR ATENDIMENTO
    UPDATE atendimento
    SET status_atendimento = 'FINALIZADO',
        status = 'CANCELADO',
        data_fechamento = NOW()
    WHERE id_atendimento = v_id_atendimento;

    -- REGISTRAR NO LEDGER
    CALL sp_master_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_CANCELAR',
        v_estado_origem, v_estado_destino, p_payload, 'SUCESSO',
        CONCAT('Atendimento ', v_id_atendimento, ' cancelado. Motivo: ', COALESCE(v_motivo, 'Não informado'))
    );

    -- RETORNO
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Atendimento cancelado com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_atendimento', v_id_atendimento,
        'status_anterior', v_estado_origem,
        'status_novo', v_estado_destino,
        'motivo', v_motivo,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END$$

-- ============================================================
-- 5. SP MASTER ATUALIZAR PACIENTE
-- ============================================================
DROP PROCEDURE IF EXISTS sp_master_atualizar_paciente$$

CREATE PROCEDURE sp_master_atualizar_paciente(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_paciente BIGINT DEFAULT NULL;
    DECLARE v_nome_anterior VARCHAR(255) DEFAULT NULL;
    DECLARE v_nome_novo VARCHAR(255) DEFAULT NULL;

    -- HANDLER GLOBAL DE ERRO
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_master_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'PACIENTE_ATUALIZAR',
            v_nome_anterior, v_nome_novo, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- VALIDAR SESSÃO
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- EXTRAIR DADOS DO PAYLOAD
    SET v_id_paciente = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_paciente'));
    SET v_nome_novo = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.nome'));

    -- BUSCAR NOME ANTERIOR
    SELECT nome INTO v_nome_anterior
    FROM paciente
    WHERE id = v_id_paciente;

    -- ATUALIZAR PACIENTE
    UPDATE paciente
    SET nome = v_nome_novo
    WHERE id = v_id_paciente;

    -- REGISTRAR NO LEDGER
    CALL sp_master_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'PACIENTE_ATUALIZAR',
        v_nome_anterior, v_nome_novo, p_payload, 'SUCESSO',
        CONCAT('Paciente atualizado: ', v_nome_anterior, ' -> ', v_nome_novo)
    );

    -- RETORNO
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Paciente atualizado com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_paciente', v_id_paciente,
        'nome_anterior', v_nome_anterior,
        'nome_novo', v_nome_novo,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END$$

-- ============================================================
-- 6. SP MASTER VINCULAR ATENDIMENTO PACIENTE
-- ============================================================
DROP PROCEDURE IF EXISTS sp_master_vincular_atendimento_paciente$$

CREATE PROCEDURE sp_master_vincular_atendimento_paciente(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_atendimento BIGINT DEFAULT NULL;
    DECLARE v_id_paciente BIGINT DEFAULT NULL;
    DECLARE v_paciente_anterior BIGINT DEFAULT NULL;

    -- HANDLER GLOBAL DE ERRO
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_master_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_VINCULAR_PACIENTE',
            v_paciente_anterior, v_id_paciente, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- VALIDAR SESSÃO
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- EXTRAIR DADOS DO PAYLOAD
    SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
    SET v_id_paciente = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_paciente'));

    -- BUSCAR PACIENTE ANTERIOR
    SELECT id_pessoa INTO v_paciente_anterior
    FROM atendimento
    WHERE id_atendimento = v_id_atendimento;

    -- VINCULAR PACIENTE (atualiza id_pessoa na tabela atendimento)
    UPDATE atendimento
    SET id_pessoa = v_id_paciente
    WHERE id_atendimento = v_id_atendimento;

    -- ATUALIZAR TAMBÉM NA SENHA
    UPDATE senha
    SET id_pessoa = v_id_paciente
    WHERE id_atendimento = v_id_atendimento;

    -- REGISTRAR NO LEDGER
    CALL sp_master_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_VINCULAR_PACIENTE',
        CAST(v_paciente_anterior AS CHAR), CAST(v_id_paciente AS CHAR), p_payload, 'SUCESSO',
        CONCAT('Atendimento ', v_id_atendimento, ' vinculado ao paciente ', v_id_paciente)
    );

    -- RETORNO
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Paciente vinculado ao atendimento com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_atendimento', v_id_atendimento,
        'paciente_anterior', v_paciente_anterior,
        'paciente_novo', v_id_paciente,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END$$

-- ============================================================
-- 7. SP MASTER REGISTRAR ADMINISTRAÇÃO MEDICAÇÃO
-- ============================================================
DROP PROCEDURE IF EXISTS sp_master_registrar_administracao_medicacao$$

CREATE PROCEDURE sp_master_registrar_administracao_medicacao(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_administracao BIGINT DEFAULT NULL;
    DECLARE v_id_atendimento BIGINT DEFAULT NULL;
    DECLARE v_medicamento VARCHAR(200) DEFAULT NULL;

    -- HANDLER GLOBAL DE ERRO
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_master_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO',
            NULL, NULL, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- VALIDAR SESSÃO
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- EXTRAIR DADOS DO PAYLOAD
    SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
    SET v_medicamento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.medicamento'));

    -- INSERIR ADMINISTRAÇÃO
    INSERT INTO administracao_medicacao (
        id_prescricao,
        id_enfermeiro,
        dose,
        via,
        data_hora,
        observacao
    ) VALUES (
        COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_prescricao')), 0),
        p_id_usuario,
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.dose')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.via')),
        NOW(),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.observacao'))
    );

    SET v_id_administracao = LAST_INSERT_ID();

    -- REGISTRAR NO LEDGER
    CALL sp_master_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO',
        NULL, CAST(v_id_administracao AS CHAR), p_payload, 'SUCESSO',
        CONCAT('Administração registrada: ', v_medicamento)
    );

    -- RETORNO
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Administração de medicação registrada com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_administracao', v_id_administracao,
        'id_atendimento', v_id_atendimento,
        'medicamento', v_medicamento,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END$$

-- ============================================================
-- 8. SP MASTER CANCELAR ADMINISTRAÇÃO MEDICAÇÃO
-- ============================================================
DROP PROCEDURE IF EXISTS sp_master_cancelar_administracao_medicacao$$

CREATE PROCEDURE sp_master_cancelar_administracao_medicacao(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_administracao BIGINT DEFAULT NULL;
    DECLARE v_motivo_cancelamento VARCHAR(500) DEFAULT NULL;

    -- HANDLER GLOBAL DE ERRO
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_master_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'CANCELAR_ADMINISTRACAO_MEDICACAO',
            NULL, CAST(v_id_administracao AS CHAR), p_payload, 'ERRO', v_error_msg
        );
    END;

    -- VALIDAR SESSÃO
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- EXTRAIR DADOS DO PAYLOAD
    SET v_id_administracao = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_administracao'));
    SET v_motivo_cancelamento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.motivo'));

    -- VALIDAR EXISTÊNCIA
    IF v_id_administracao IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM administracao_medicacao WHERE id_admin = v_id_administracao
    ) THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Administração não encontrada';
        SET p_resultado = JSON_OBJECT('id_administracao', v_id_administracao, 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    -- REGISTRAR NO LEDGER (a tabela não tem campo de cancelamento)
    CALL sp_master_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'CANCELAR_ADMINISTRACAO_MEDICACAO',
        NULL, CAST(v_id_administracao AS CHAR), p_payload, 'SUCESSO',
        CONCAT('Administração cancelada: ', v_motivo_cancelamento)
    );

    -- RETORNO
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Administração de medicação cancelada com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_administracao', v_id_administracao,
        'motivo', v_motivo_cancelamento,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END$$

-- ============================================================
-- 9. SP MASTER REGISTRAR ALERTA
-- ============================================================
DROP PROCEDURE IF EXISTS sp_master_registrar_alerta$$

CREATE PROCEDURE sp_master_registrar_alerta(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_alerta BIGINT DEFAULT NULL;
    DECLARE v_tipo_alerta VARCHAR(100) DEFAULT NULL;

    -- HANDLER GLOBAL DE ERRO
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_master_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'REGISTRAR_ALERTA',
            NULL, NULL, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- VALIDAR SESSÃO
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- EXTRAIR DADOS DO PAYLOAD
    SET v_tipo_alerta = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo'));

    -- INSERIR ALERTA
    INSERT INTO alerta (
        tipo_alerta,
        descricao,
        prioridade,
        id_destinatario,
        criado_por,
        criado_em
    ) VALUES (
        v_tipo_alerta,
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.descricao')),
        COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.prioridade')), 1),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_destinatario')),
        p_id_usuario,
        NOW()
    );

    SET v_id_alerta = LAST_INSERT_ID();

    -- REGISTRAR NO LEDGER
    CALL sp_master_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'REGISTRAR_ALERTA',
        NULL, CAST(v_id_alerta AS CHAR), p_payload, 'SUCESSO',
        CONCAT('Alerta registrado: ', v_tipo_alerta)
    );

    -- RETORNO
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Alerta registrado com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_alerta', v_id_alerta,
        'tipo_alerta', v_tipo_alerta,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END$$

-- ============================================================
-- 10. SP MASTER AGENDA DISPONIBILIDADE
-- ============================================================
DROP PROCEDURE IF EXISTS sp_master_agenda_disponibilidade$$

CREATE PROCEDURE sp_master_agenda_disponibilidade(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_disponibilidade BIGINT DEFAULT NULL;

    -- HANDLER GLOBAL DE ERRO
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_master_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'AGENDA_DISPONIBILIDADE',
            NULL, NULL, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- VALIDAR SESSÃO
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- INSERIR DISPONIBILIDADE
    INSERT INTO agenda_disponibilidade (
        id_sistema,
        id_unidade,
        id_profissional,
        inicio_em,
        fim_em,
        tipo,
        ativo,
        criado_em,
        id_usuario_criador,
        id_sessao_usuario
    ) VALUES (
        COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_sistema')), 1),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_profissional')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data_inicio')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data_fim')),
        COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo')), 'ATENDIMENTO'),
        1,
        NOW(),
        p_id_usuario,
        p_id_sessao
    );

    SET v_id_disponibilidade = LAST_INSERT_ID();

    -- REGISTRAR NO LEDGER
    CALL sp_master_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'AGENDA_DISPONIBILIDADE',
        NULL, CAST(v_id_disponibilidade AS CHAR), p_payload, 'SUCESSO',
        CONCAT('Disponibilidade registrada para profissional ', JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_profissional')))
    );

    -- RETORNO
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Disponibilidade registrada com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_disponibilidade', v_id_disponibilidade,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END$$

-- ============================================================
-- 11. SP MASTER ALERTA CONSUMO
-- ============================================================
DROP PROCEDURE IF EXISTS sp_master_alerta_consumo$$

CREATE PROCEDURE sp_master_alerta_consumo(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_alerta BIGINT DEFAULT NULL;
    DECLARE v_tipo_alerta VARCHAR(50) DEFAULT NULL;

    -- HANDLER GLOBAL DE ERRO
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_master_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'ALERTA_CONSUMO',
            NULL, NULL, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- VALIDAR SESSÃO
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- EXTRAIR DADOS DO PAYLOAD
    SET v_tipo_alerta = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo_alerta'));

    -- INSERIR ALERTA DE CONSUMO
    INSERT INTO alerta_consumo (
        tipo_alerta,
        descricao,
        id_unidade,
        id_funcionario,
        status,
        criado_por,
        criado_em
    ) VALUES (
        v_tipo_alerta,
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.descricao')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_funcionario')),
        COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.status')), 'ABERTO'),
        p_id_usuario,
        NOW()
    );

    SET v_id_alerta = LAST_INSERT_ID();

    -- REGISTRAR NO LEDGER
    CALL sp_master_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ALERTA_CONSUMO',
        NULL, CAST(v_id_alerta AS CHAR), p_payload, 'SUCESSO',
        CONCAT('Alerta de consumo registrado: ', v_tipo_alerta)
    );

    -- RETORNO
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Alerta de consumo registrado com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_alerta_consumo', v_id_alerta,
        'tipo_alerta', v_tipo_alerta,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END$$

-- ============================================================
-- 12. SP MASTER ADMINISTRAÇÃO MEDICAÇÃO ORDEM
-- ============================================================
DROP PROCEDURE IF EXISTS sp_master_administracao_medicacao_ordem$$

CREATE PROCEDURE sp_master_administracao_medicacao_ordem(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_ordem BIGINT DEFAULT NULL;

    -- HANDLER GLOBAL DE ERRO
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_master_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO_ORDEM',
            NULL, NULL, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- VALIDAR SESSÃO
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- INSERIR ORDEM DE MEDICAÇÃO
    INSERT INTO administracao_medicacao_ordem (
        id_medicacao,
        id_atendimento,
        quantidade,
        frequencia,
        status,
        criado_em,
        criado_por
    ) VALUES (
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_medicacao')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.quantidade')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.frequencia')),
        COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.status')), 'PENDENTE'),
        NOW(),
        p_id_usuario
    );

    SET v_id_ordem = LAST_INSERT_ID();

    -- REGISTRAR NO LEDGER
    CALL sp_master_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO_ORDEM',
        NULL, CAST(v_id_ordem AS CHAR), p_payload, 'SUCESSO',
        CONCAT('Ordem de medicação registrada: ', JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.quantidade')))
    );

    -- RETORNO
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Ordem de medicação registrada com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_ordem', v_id_ordem,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END$$

-- ============================================================
-- 13. SP MASTER AGEND-- ============================================================
AMENTO EVENTOS
DROP PROCEDURE IF EXISTS sp_master_agendamento_eventos$$

CREATE PROCEDURE sp_master_agendamento_eventos(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_evento BIGINT DEFAULT NULL;

    -- HANDLER GLOBAL DE ERRO
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_master_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'AGENDAMENTO_EVENTO',
            NULL, NULL, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- VALIDAR SESSÃO
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- INSERIR EVENTO DE AGENDAMENTO
    INSERT INTO agendamento_eventos (
        id_agenda,
        tipo_evento,
        descricao,
        data_evento,
        status,
        criado_em,
        criado_por
    ) VALUES (
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_agenda')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo_evento')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.descricao')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data_evento')),
        COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.status')), 'PENDENTE'),
        NOW(),
        p_id_usuario
    );

    SET v_id_evento = LAST_INSERT_ID();

    -- REGISTRAR NO LEDGER
    CALL sp_master_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'AGENDAMENTO_EVENTO',
        NULL, CAST(v_id_evento AS CHAR), p_payload, 'SUCESSO',
        CONCAT('Evento registrado: ', JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo_evento')))
    );

    -- RETORNO
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Evento de agendamento registrado com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_evento', v_id_evento,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END$$

-- ============================================================
-- 14. SP MASTER LEDGER EVENTO LOG (AUDITORIA)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_master_ledger_evento_log$$

CREATE PROCEDURE sp_master_ledger_evento_log(
    IN p_uuid_transacao CHAR(36),
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_acao VARCHAR(100),
    IN p_estado_origem VARCHAR(50),
    IN p_estado_destino VARCHAR(50),
    IN p_payload JSON,
    IN p_status VARCHAR(20),
    IN p_mensagem VARCHAR(500)
)
BEGIN
    INSERT INTO atendimento_evento_ledger (
        uuid_transacao,
        id_usuario,
        id_perfil,
        acao,
        estado_origem,
        estado_destino,
        payload,
        status_evento,
        mensagem,
        created_at
    ) VALUES (
        p_uuid_transacao,
        p_id_usuario,
        p_id_perfil,
        p_acao,
        p_estado_origem,
        p_estado_destino,
        p_payload,
        p_status,
        p_mensagem,
        NOW(6)
    );
END$$

DELIMITER ;
