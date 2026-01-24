CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fechar_ffa`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_tipo_fechamento ENUM('FECHAMENTO_NORMAL','ENCERRADO_AUTOMATICO','FECHAMENTO_CANCELADO'),
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_permite_reabrir BOOLEAN DEFAULT FALSE;
    DECLARE v_id_paciente BIGINT;

    -- 1️⃣ Bloqueia a FFA para atualização
    SELECT status, id_paciente
      INTO v_status_atual, v_id_paciente
      FROM ffa
     WHERE id_ffa = p_id_ffa
     FOR UPDATE;

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FFA inexistente';
    END IF;

    -- 2️⃣ Valida permissões
    IF p_tipo_fechamento = 'FECHAMENTO_CANCELADO' THEN
        -- Cancelamento só pode TI / usuário master
        IF NOT EXISTS (
            SELECT 1
              FROM usuario
             WHERE id_usuario = p_id_usuario
               AND perfil = 'MASTER'
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Usuário sem permissão para cancelar FFA';
        END IF;
    ELSE
        -- Fechamento normal ou automático: médico, recepção, triagem, enfermagem, técnicos
        IF NOT EXISTS (
            SELECT 1
              FROM usuario
             WHERE id_usuario = p_id_usuario
               AND perfil IN ('MEDICO','RECEPCAO','TRIAGEM','ENFERMAGEM','TECNICO')
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Usuário sem permissão para fechar FFA';
        END IF;
    END IF;

    -- 3️⃣ Determina status final
    CASE p_tipo_fechamento
        WHEN 'FECHAMENTO_NORMAL' THEN
            SET v_status_atual = 'ENCERRADO';
            SET v_permite_reabrir = TRUE;
        WHEN 'ENCERRADO_AUTOMATICO' THEN
            SET v_status_atual = 'ENCERRADO';
            SET v_permite_reabrir = TRUE;
        WHEN 'FECHAMENTO_CANCELADO' THEN
            SET v_status_atual = 'CANCELADO';
            SET v_permite_reabrir = FALSE;
    END CASE;

    -- 4️⃣ Atualiza FFA
    UPDATE ffa
       SET status = v_status_atual,
           atualizado_em = NOW()
     WHERE id_ffa = p_id_ffa;

    -- 5️⃣ Registra evento no histórico
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        CONCAT('FECHAMENTO: ', p_tipo_fechamento),
        'SISTEMA',
        p_id_usuario,
        p_motivo,
        NOW()
    );

    -- 6️⃣ Auditoria de exames/medicação pendentes
    INSERT INTO ffa_auditoria_pendencias (
        id_ffa,
        id_paciente,
        tipo_pendencia,
        criado_em
    )
    SELECT p_id_ffa, v_id_paciente, 'EXAMES/MEDICACAO', NOW()
      FROM ffa_medicacao fm
     WHERE fm.id_ffa = p_id_ffa
       AND (fm.status IS NULL OR fm.status <> 'MINISTRADO');

END