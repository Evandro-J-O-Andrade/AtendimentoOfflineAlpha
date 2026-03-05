-- ============================================================
-- Master Dispatcher Runtime - Ponto central de entrada
-- Todas as ações do sistema passam por esta procedure
-- ============================================================

DELIMITER //

-- Procedure principal do dispatcher
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
BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_estado_origem VARCHAR(50) DEFAULT NULL;
    DECLARE v_estado_destino VARCHAR(50) DEFAULT NULL;
    DECLARE v_id_atendimento BIGINT DEFAULT NULL;
    DECLARE v_id_senha BIGINT DEFAULT NULL;
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        
        -- Log do erro no ledger
        CALL sp_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
            v_estado_origem, v_estado_destino, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- Iniciar transação
    START TRANSACTION;

    -- Validar sessão
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida');
        ROLLBACK;
    END IF;

    -- Validar permissão por contexto
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
        -- Não bloquear, apenas logar aviso
        SET p_mensagem = CONCAT('AVISO: Perfil ', p_id_perfil, ' pode não ter permissão para ', p_acao);
    END IF;

    -- Processar ação específica
    CASE p_acao
        -- ==================== SESSÃO ====================
        WHEN 'SESSION_HEARTBEAT' THEN
            UPDATE sessao_usuario 
            SET ultimo_heartbeat = NOW(6) 
            WHERE id_sessao_usuario = p_id_sessao;
            
            SET p_sucesso = TRUE;
            SET p_mensagem = 'Heartbeat registrado';
            SET p_resultado = JSON_OBJECT('id_sessao', p_id_sessao, 'timestamp', NOW(6));

        -- ==================== ATENDIMENTO ====================
        WHEN 'ATENDIMENTO_INICIAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            
            -- Log do evento
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

        WHEN 'ATENDIMENTO_TRANSICIONAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            SET v_estado_destino = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.status'));
            
            -- Buscar estado atual
            SELECT MAX(id_fluxo_status) INTO v_estado_origem
            FROM senha 
            WHERE id_atendimento = v_id_atendimento 
            ORDER BY criado_em DESC LIMIT 1;
            
            -- Atualizar senha com novo status
            UPDATE senha SET
                id_fluxo_status = (
                    SELECT id_fluxo_status FROM fluxo_status 
                    WHERE codigo = v_estado_destino LIMIT 1
                )
            WHERE id_atendimento = v_id_atendimento;
            
            -- Log do evento
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

        -- ==================== SENHA ====================
        WHEN 'SENHA_CRIAR' THEN
            SET v_id_senha = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_senha'));
            
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, 'CRIADA', p_payload, 'SUCESSO', 'Senha criada'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = 'Senha criada';
            SET p_resultado = JSON_OBJECT('id_senha', v_id_senha);

        WHEN 'SENHA_CHAMAR' THEN
            SET v_id_senha = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_senha'));
            
            UPDATE senha SET
                chamada_em = NOW(6),
                chamada_sequencial = chamada_sequencial + 1
            WHERE id_senha = v_id_senha;
            
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                'AGUARDANDO', 'CHAMADA', p_payload, 'SUCESSO', 'Senha chamada'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = 'Senha chamada';
            SET p_resultado = JSON_OBJECT('id_senha', v_id_senha);

        WHEN 'SENHA_ATENDER' THEN
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
            SET p_resultado = JSON_OBJECT('id_senha', v_id_senha);

        -- ==================== TRIAGEM ====================
        WHEN 'TRIAGEM_REGISTRAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            
            -- Registrar sinais vitais
            INSERT INTO atendimento_sinais_vitais (
                id_atendimento, id_usuario_registro,
                pa_sistolica, pa_diastolica, frequencia_cardiaca,
                temperatura, respiracao, spo2, peso, altura,
                created_at
            ) VALUES (
                v_id_atendimento, p_id_usuario,
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
            SET p_resultado = JSON_OBJECT('id_atendimento', v_id_atendimento);

        -- ==================== PRESCRIÇÃO ====================
        WHEN 'PRESCRICAO_CRIAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            
            INSERT INTO atendimento_prescricao (
                id_atendimento, id_medico, medicamento, dose, via, frequencia,
                observacao, data_prescricao, status
            ) VALUES (
                v_id_atendimento, p_id_usuario,
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.medicamento')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.dose')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.via')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.frequencia')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.observacao')),
                NOW(6), 'ATIVO'
            );
            
            SET p_resultado = JSON_OBJECT(
                'id_atendimento', v_id_atendimento,
                'last_insert_id', LAST_INSERT_ID()
            );
            
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, 'ATIVO', p_payload, 'SUCESSO', 'Prescrição criada'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = 'Prescrição criada';

        -- ==================== FARMÁCIA ====================
        WHEN 'FARMACIA_DISPENSAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            
            -- Atualizar status da prescrição
            UPDATE atendimento_prescricao SET
                status = 'CONCLUIDO'
            WHERE id = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_prescricao'))
              AND id_atendimento = v_id_atendimento;
            
            -- Registrar dispensação
            INSERT INTO dispensacao_medicacao (
                id_ordem, id_item, id_farmaco, quantidade,
                id_usuario_dispensador, data_hora, status, observacao
            ) VALUES (
                v_id_atendimento,
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_prescricao')),
                NULL, 1, p_id_usuario, NOW(6), 'ENTREGUE',
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.observacao'))
            );
            
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                'ATIVO', 'CONCLUIDO', p_payload, 'SUCESSO', 'Medicamento dispensado'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = 'Medicamento dispensado';
            SET p_resultado = JSON_OBJECT('id_atendimento', v_id_atendimento);

        -- ==================== ENFERMAGEM ====================
        WHEN 'ENFERMAGEM_REGISTRAR' THEN
            SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
            
            INSERT INTO atendimento_procedimento_enfermagem (
                id_atendimento, id_usuario_enfermeiro,
                procedimento, observacao, data_hora, status
            ) VALUES (
                v_id_atendimento, p_id_usuario,
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.procedimento')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.observacao')),
                NOW(6), 'REALIZADO'
            );
            
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, 'REALIZADO', p_payload, 'SUCESSO', 'Procedimento registrado'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = 'Procedimento registrado';
            SET p_resultado = JSON_OBJECT('id_atendimento', v_id_atendimento);

        -- ==================== DEFAULT ====================
        ELSE
            -- Ação genérica - apenas log
            CALL sp_ledger_evento_log(
                v_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
                NULL, NULL, p_payload, 'SUCESSO', 'Ação genérica executada'
            );
            
            SET p_sucesso = TRUE;
            SET p_mensagem = CONCAT('Ação ', p_acao, ' executada');
            SET p_resultado = JSON_OBJECT('acao', p_acao, 'contexto', p_contexto);
    END CASE;

    -- Commit da transação
    COMMIT;
    
    -- Adicionar uuid_transacao ao resultado
    IF p_resultado IS NOT NULL THEN
        SET p_resultado = JSON_INSERT(p_resultado, '$.uuid_transacao', v_uuid_transacao);
    END IF;

END //

-- Procedure auxiliar para logging no ledger
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
        uuid_transacao, id_usuario, id_perfil, acao,
        estado_origem, estado_destino, payload,
        status_evento, mensagem, created_at
    ) VALUES (
        p_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
        p_estado_origem, p_estado_destino, p_payload,
        p_status, p_mensagem, NOW(6)
    );
END //

-- Procedure para validar permissão de ação por perfil
CREATE PROCEDURE sp_permissao_validar(
    IN p_id_perfil BIGINT,
    IN p_acao VARCHAR(100),
    IN p_contexto VARCHAR(50),
    OUT p_tem_permissao BOOLEAN
)
BEGIN
    SET p_tem_permissao = EXISTS (
        SELECT 1 FROM fluxo_transicao ft
        JOIN fluxo_status fs_origem ON fs_origem.id_fluxo_status = ft.id_status_origem
        JOIN fluxo_status fs_destino ON fs_destino.id_fluxo_status = ft.id_status_destino
        WHERE ft.id_perfil_requerido = p_id_perfil
          AND ft.ativo = 1
          AND (fs_origem.codigo LIKE CONCAT(p_contexto, '%') 
               OR fs_destino.codigo LIKE CONCAT(p_contexto, '%'))
    );
END //

DELIMITER ;

-- ============================================================
-- Tabela de Ledger de Eventos (se não existir)
-- ============================================================

CREATE TABLE IF NOT EXISTS atendimento_evento_ledger (
    id_evento BIGINT NOT NULL AUTO_INCREMENT,
    uuid_transacao CHAR(36) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_perfil BIGINT NOT NULL,
    acao VARCHAR(100) NOT NULL,
    estado_origem VARCHAR(50) DEFAULT NULL,
    estado_destino VARCHAR(50) DEFAULT NULL,
    payload JSON DEFAULT NULL,
    status_evento VARCHAR(20) DEFAULT 'SUCESSO',
    mensagem VARCHAR(500) DEFAULT NULL,
    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id_evento),
    INDEX idx_transacao (uuid_transacao),
    INDEX idx_usuario (id_usuario),
    INDEX idx_acao (acao),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
COMMENT='Ledger de auditoria de todas as ações do sistema';
