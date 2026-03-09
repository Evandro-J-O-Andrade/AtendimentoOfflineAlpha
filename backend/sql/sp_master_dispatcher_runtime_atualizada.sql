-- ============================================================
-- Master Dispatcher Runtime - ATUALIZADA
-- Todas as ações do sistema passam por esta procedure
-- Inclui: atendimento, paciente, agenda, medicação, alertas
-- ============================================================

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_master_dispatcher_runtime$$

CREATE PROCEDURE sp_master_dispatcher_runtime(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_acao VARCHAR(100),
    IN p_contexto VARCHAR(50),
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_estado_origem VARCHAR(50) DEFAULT NULL;
    DECLARE v_estado_destino VARCHAR(50) DEFAULT NULL;
    DECLARE v_id_atendimento BIGINT DEFAULT NULL;
    DECLARE v_id_senha BIGINT DEFAULT NULL;
    DECLARE v_id_paciente BIGINT DEFAULT NULL;

    -- =========================
    -- HANDLER GLOBAL DE ERRO
    -- =========================
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
            v_estado_origem, v_estado_destino, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- =========================
    -- VALIDAR SESSÃO
    -- =========================
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    -- =========================
    -- INICIAR TRANSAÇÃO
    -- =========================
    START TRANSACTION;

    -- =========================
    -- VALIDAR PERMISSÃO
    -- =========================
    IF NOT EXISTS (
        SELECT 1 FROM fluxo_transicao ft
        WHERE ft.id_perfil_requerido = p_id_perfil
          AND ft.ativo = 1
          AND EXISTS (
              SELECT 1 FROM fluxo_status fs_origem
              WHERE fs_origem.id_fluxo_status = ft.id_status_origem
                AND fs_origem.codigo LIKE CONCAT(p_contexto, '%')
          )
    ) AND p_acao != 'SESSION_HEARTBEAT' THEN
        SET p_mensagem = CONCAT('AVISO: Perfil ', p_id_perfil, ' pode não ter permissão para ', p_acao);
        CALL sp_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
            NULL, NULL, p_payload, 'AVISO', p_mensagem
        );
    END IF;

    -- =========================
    -- EXECUTAR AÇÃO
    -- =========================
    CASE
        -- ==================== SESSÃO ====================
        WHEN p_acao = 'SESSION_HEARTBEAT' THEN
            UPDATE sessao_usuario
            SET ultimo_heartbeat = NOW(6)
            WHERE id_sessao_usuario = p_id_sessao;

            SET p_sucesso = TRUE;
            SET p_mensagem = 'Heartbeat registrado';
            SET p_resultado = JSON_OBJECT('id_sessao', p_id_sessao, 'timestamp', NOW(6));

        -- ==================== ATENDIMENTO ====================
        WHEN p_acao = 'ATENDIMENTO_INICIAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            
            -- Inserir atendimento inicial
            INSERT INTO atendimento (
                id_atendimento,
                protocolo,
                id_pessoa,
                id_unidade,
                status_atendimento,
                status,
                data_abertura
            ) VALUES (
                v_id_atendimento,
                CONCAT('ATD-', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_pessoa')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')),
                'ABERTO',
                'ABERTO',
                NOW()
            );

            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, 'INICIADO', p_payload, 'SUCESSO', 'Atendimento iniciado'
            );

            SET p_sucesso = TRUE;
            SET p_mensagem = 'Atendimento iniciado';
            SET p_resultado = JSON_OBJECT(
                'id_atendimento', v_id_atendimento,
                'uuid_transacao', v_uuid_transacao
            );

        WHEN p_acao = 'ATENDIMENTO_TRANSICIONAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            SET v_estado_destino = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.status'));

            -- Buscar estado atual
            SELECT id_fluxo_status INTO v_estado_origem
            FROM senha
            WHERE id_atendimento = v_id_atendimento
            ORDER BY criado_em DESC
            LIMIT 1;

            -- Inserir novo status na senha
            INSERT INTO senha (id_atendimento, id_fluxo_status, criado_em)
            VALUES (
                v_id_atendimento,
                (SELECT id_fluxo_status FROM fluxo_status WHERE codigo = v_estado_destino LIMIT 1),
                NOW(6)
            );

            -- Atualizar status do atendimento
            UPDATE atendimento
            SET status_atendimento = v_estado_destino
            WHERE id_atendimento = v_id_atendimento;

            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                v_estado_origem, v_estado_destino, p_payload, 'SUCESSO',
                CONCAT('Transição: ', v_estado_origem, ' -> ', v_estado_destino)
            );

            SET p_sucesso = TRUE;
            SET p_mensagem = CONCAT('Atendimento transicionado para ', v_estado_destino);
            SET p_resultado = JSON_OBJECT(
                'id_atendimento', v_id_atendimento,
                'status_anterior', v_estado_origem,
                'status_novo', v_estado_destino,
                'uuid_transacao', v_uuid_transacao
            );

        WHEN p_acao = 'ATENDIMENTO_FINALIZAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            SET v_estado_destino = 'FINALIZADO';

            -- Buscar estado atual
            SELECT id_fluxo_status INTO v_estado_origem
            FROM senha
            WHERE id_atendimento = v_id_atendimento
            ORDER BY criado_em DESC
            LIMIT 1;

            -- Inserir status FINALIZADO
            INSERT INTO senha (id_atendimento, id_fluxo_status, criado_em)
            VALUES (
                v_id_atendimento,
                (SELECT id_fluxo_status FROM fluxo_status WHERE codigo = 'FINALIZADO' LIMIT 1),
                NOW(6)
            );

            -- Atualizar atendimento
            UPDATE atendimento
            SET status_atendimento = 'FINALIZADO',
                status = 'FINALIZADO',
                data_fechamento = NOW()
            WHERE id_atendimento = v_id_atendimento;

            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                v_estado_origem, v_estado_destino, p_payload, 'SUCESSO',
                CONCAT('Transição: ', v_estado_origem, ' -> ', v_estado_destino)
            );

            SET p_sucesso = TRUE;
            SET p_mensagem = 'Atendimento finalizado';
            SET p_resultado = JSON_OBJECT(
                'id_atendimento', v_id_atendimento,
                'status_anterior', v_estado_origem,
                'status_novo', v_estado_destino,
                'uuid_transacao', v_uuid_transacao
            );

        WHEN p_acao = 'ATENDIMENTO_CANCELAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            SET v_estado_destino = 'CANCELADO';

            -- Buscar estado atual
            SELECT id_fluxo_status INTO v_estado_origem
            FROM senha
            WHERE id_atendimento = v_id_atendimento
            ORDER BY criado_em DESC
            LIMIT 1;

            -- Inserir status CANCELADO
            INSERT INTO senha (id_atendimento, id_fluxo_status, criado_em)
            VALUES (
                v_id_atendimento,
                (SELECT id_fluxo_status FROM fluxo_status WHERE codigo = 'EVASAO' LIMIT 1),
                NOW(6)
            );

            -- Atualizar atendimento
            UPDATE atendimento
            SET status_atendimento = 'FINALIZADO',
                status = 'CANCELADO',
                data_fechamento = NOW()
            WHERE id_atendimento = v_id_atendimento;

            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                v_estado_origem, v_estado_destino, p_payload, 'SUCESSO',
                CONCAT('Transição: ', v_estado_origem, ' -> ', v_estado_destino)
            );

            SET p_sucesso = TRUE;
            SET p_mensagem = 'Atendimento cancelado';
            SET p_resultado = JSON_OBJECT(
                'id_atendimento', v_id_atendimento,
                'status_anterior', v_estado_origem,
                'status_novo', v_estado_destino,
                'uuid_transacao', v_uuid_transacao
            );

        -- ==================== PACIENTE ====================
        WHEN p_acao = 'PACIENTE_ATUALIZAR' THEN
            SET v_id_paciente = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_paciente'));
            
            -- Atualizar paciente (usando id como PK)
            UPDATE paciente
            SET nome = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.nome'))
            WHERE id = v_id_paciente;

            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, NULL, p_payload, 'SUCESSO', CONCAT('Paciente ', v_id_paciente, ' atualizado')
            );

            SET p_sucesso = TRUE;
            SET p_mensagem = 'Paciente atualizado';
            SET p_resultado = JSON_OBJECT(
                'id_paciente', v_id_paciente,
                'uuid_transacao', v_uuid_transacao
            );

        WHEN p_acao = 'ATENDIMENTO_VINCULAR_PACIENTE' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            SET v_id_paciente = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_paciente'));

            -- Atualizar vínculo na tabela senha (campo id_paciente)
            UPDATE senha
            SET id_paciente = v_id_paciente
            WHERE id_atendimento = v_id_atendimento;

            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, NULL, p_payload, 'SUCESSO',
                CONCAT('Atendimento ', v_id_atendimento, ' vinculado ao paciente ', v_id_paciente)
            );

            SET p_sucesso = TRUE;
            SET p_mensagem = 'Paciente vinculado ao atendimento';
            SET p_resultado = JSON_OBJECT(
                'id_atendimento', v_id_atendimento,
                'id_paciente', v_id_paciente,
                'uuid_transacao', v_uuid_transacao
            );

        -- ==================== SENHA ====================
        WHEN p_acao = 'SENHA_CRIAR' THEN
            SET v_id_senha = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_senha'));
            
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, 'CRIADA', p_payload, 'SUCESSO', 'Senha criada'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = 'Senha criada';
            SET p_resultado = JSON_OBJECT('id_senha', v_id_senha, 'uuid_transacao', v_uuid_transacao);

        WHEN p_acao = 'SENHA_CHAMAR' THEN
            SET v_id_senha = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_senha'));
            
            UPDATE senha SET
                chamada_em = NOW(6),
                chamada_sequencial = IFNULL(chamada_sequencial, 0) + 1
            WHERE id_senha = v_id_senha;
            
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                'AGUARDANDO', 'CHAMADA', p_payload, 'SUCESSO', 'Senha chamada'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = 'Senha chamada';
            SET p_resultado = JSON_OBJECT('id_senha', v_id_senha, 'uuid_transacao', v_uuid_transacao);

        WHEN p_acao = 'SENHA_ATENDER' THEN
            SET v_id_senha = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_senha'));
            
            UPDATE senha SET
                executado_em = NOW(6)
            WHERE id_senha = v_id_senha;
            
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                'CHAMADA', 'ATENDIDA', p_payload, 'SUCESSO', 'Senha atendida'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = 'Senha atendida';
            SET p_resultado = JSON_OBJECT('id_senha', v_id_senha, 'uuid_transacao', v_uuid_transacao);

        -- ==================== AGENDA ====================
        WHEN p_acao = 'AGENDA_DISPONIBILIDADE_CRIAR' THEN
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

            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, NULL, p_payload, 'SUCESSO', 'Disponibilidade registrada'
            );

            SET p_sucesso = TRUE;
            SET p_mensagem = 'Disponibilidade registrada';
            SET p_resultado = JSON_OBJECT(
                'id_disponibilidade', LAST_INSERT_ID(),
                'uuid_transacao', v_uuid_transacao
            );

        WHEN p_acao = 'AGENDAMENTO_EVENTO_CRIAR' THEN
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

            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, NULL, p_payload, 'SUCESSO', 'Evento de agendamento registrado'
            );

            SET p_sucesso = TRUE;
            SET p_mensagem = 'Evento de agendamento registrado';
            SET p_resultado = JSON_OBJECT(
                'id_evento', LAST_INSERT_ID(),
                'uuid_transacao', v_uuid_transacao
            );

        -- ==================== MEDICAÇÃO ====================
        WHEN p_acao = 'ADMINISTRACAO_MEDICACAO_REGISTRAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));

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

            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, NULL, p_payload, 'SUCESSO', 'Administração de medicação registrada'
            );

            SET p_sucesso = TRUE;
            SET p_mensagem = 'Administração de medicação registrada';
            SET p_resultado = JSON_OBJECT(
                'id_administracao', LAST_INSERT_ID(),
                'id_atendimento', v_id_atendimento,
                'uuid_transacao', v_uuid_transacao
            );

        WHEN p_acao = 'ADMINISTRACAO_MEDICACAO_CANCELAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            
            -- A tabela administracao_medicacao não tem campos de cancelamento
            -- Então apenas registramos no ledger
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, NULL, p_payload, 'SUCESSO', 
                CONCAT('Administração cancelada: ', JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.motivo')))
            );

            SET p_sucesso = TRUE;
            SET p_mensagem = 'Administração de medicação cancelada';
            SET p_resultado = JSON_OBJECT(
                'uuid_transacao', v_uuid_transacao
            );

        WHEN p_acao = 'ADMINISTRACAO_MEDICACAO_ORDEM' THEN
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

            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, NULL, p_payload, 'SUCESSO', 'Ordem de medicação registrada'
            );

            SET p_sucesso = TRUE;
            SET p_mensagem = 'Ordem de medicação registrada';
            SET p_resultado = JSON_OBJECT(
                'id_ordem', LAST_INSERT_ID(),
                'uuid_transacao', v_uuid_transacao
            );

        -- ==================== ALERTAS ====================
        WHEN p_acao = 'ALERTA_REGISTRAR' THEN
            INSERT INTO alerta (
                tipo_alerta,
                descricao,
                prioridade,
                id_destinatario,
                criado_por,
                criado_em
            ) VALUES (
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.descricao')),
                COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.prioridade')), 1),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_destinatario')),
                p_id_usuario,
                NOW()
            );

            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, NULL, p_payload, 'SUCESSO', CONCAT('Alerta registrado: ', JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo')))
            );

            SET p_sucesso = TRUE;
            SET p_mensagem = 'Alerta registrado';
            SET p_resultado = JSON_OBJECT(
                'id_alerta', LAST_INSERT_ID(),
                'uuid_transacao', v_uuid_transacao
            );

        WHEN p_acao = 'ALERTA_CONSUMO' THEN
            INSERT INTO alerta_consumo (
                tipo_alerta,
                descricao,
                id_unidade,
                id_funcionario,
                status,
                criado_por,
                criado_em
            ) VALUES (
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo_alerta')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.descricao')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_funcionario')),
                COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.status')), 'ABERTO'),
                p_id_usuario,
                NOW()
            );

            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, NULL, p_payload, 'SUCESSO', 'Alerta de consumo registrado'
            );

            SET p_sucesso = TRUE;
            SET p_mensagem = 'Alerta de consumo registrado';
            SET p_resultado = JSON_OBJECT(
                'id_alerta_consumo', LAST_INSERT_ID(),
                'uuid_transacao', v_uuid_transacao
            );

        -- ==================== TRIAGEM ====================
        WHEN p_acao = 'TRIAGEM_REGISTRAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            
            -- Inserir na tabela de sinais vitais
            INSERT INTO atendimento_sinais_vitais (
                id_atendimento,
                id_usuario_registro,
                pa_sistolica,
                pa_diastolica,
                frequencia_cardiaca,
                temperatura,
                respiracao,
                spo2,
                peso,
                altura,
                created_at
            ) VALUES (
                v_id_atendimento,
                p_id_usuario,
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.pa_sistolica')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.pa_diastolica')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.frequencia_cardiaca')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.temperatura')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.respiracao')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.spo2')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.peso')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.altura')),
                NOW(6)
            );
            
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, 'REGISTRADA', p_payload, 'SUCESSO', 'Triagem registrada'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = 'Triagem registrada';
            SET p_resultado = JSON_OBJECT('id_atendimento', v_id_atendimento, 'uuid_transacao', v_uuid_transacao);

        -- ==================== PRESCRIÇÃO ====================
        WHEN p_acao = 'PRESCRICAO_CRIAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            
            INSERT INTO atendimento_prescricao (
                id_atendimento,
                id_medico,
                medicamento,
                dose,
                via,
                frequencia,
                observacao,
                data_prescricao,
                status
            ) VALUES (
                v_id_atendimento,
                p_id_usuario,
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.medicamento')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.dose')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.via')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.frequencia')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.observacao')),
                NOW(6),
                'ATIVO'
            );
            
            SET p_resultado = JSON_OBJECT(
                'id_atendimento', v_id_atendimento,
                'id_prescricao', LAST_INSERT_ID(),
                'uuid_transacao', v_uuid_transacao
            );
            
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, 'ATIVO', p_payload, 'SUCESSO', 'Prescrição criada'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = 'Prescrição criada';

        -- ==================== FARMÁCIA ====================
        WHEN p_acao = 'FARMACIA_DISPENSAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            
            -- Atualizar status da prescrição
            UPDATE atendimento_prescricao SET
                status = 'CONCLUIDO'
            WHERE id = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_prescricao'))
              AND id_atendimento = v_id_atendimento;
            
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                'ATIVO', 'CONCLUIDO', p_payload, 'SUCESSO', 'Medicamento dispensado'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = 'Medicamento dispensado';
            SET p_resultado = JSON_OBJECT('id_atendimento', v_id_atendimento, 'uuid_transacao', v_uuid_transacao);

        -- ==================== ENFERMAGEM ====================
        WHEN p_acao = 'ENFERMAGEM_REGISTRAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            
            INSERT INTO atendimento_procedimento_enfermagem (
                id_atendimento,
                id_usuario_enfermeiro,
                procedimento,
                observacao,
                data_hora,
                status
            ) VALUES (
                v_id_atendimento,
                p_id_usuario,
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.procedimento')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.observacao')),
                NOW(6),
                'REALIZADO'
            );
            
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, 'REALIZADO', p_payload, 'SUCESSO', 'Procedimento registrado'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = 'Procedimento registrado';
            SET p_resultado = JSON_OBJECT('id_atendimento', v_id_atendimento, 'uuid_transacao', v_uuid_transacao);

        -- ==================== DEFAULT ====================
        ELSE
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, NULL, p_payload, 'SUCESSO', 'Ação genérica executada'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = CONCAT('Ação ', p_acao, ' executada');
            SET p_resultado = JSON_OBJECT('acao', p_acao, 'contexto', p_contexto, 'uuid_transacao', v_uuid_transacao);
    END CASE;

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END$$

DELIMITER ;

-- =========================
-- PROCEDURE DE LEDGER
-- =========================
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_ledger_evento_log$$

CREATE PROCEDURE sp_ledger_evento_log(
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
