CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fecha_ffa`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_id_senha BIGINT;

    /* ===============================
       1️⃣ Valida FFA existente
       =============================== */
    SELECT status, id_senha
      INTO v_status_atual, v_id_senha
      FROM ffa
     WHERE id_ffa = p_id_ffa
     FOR UPDATE;

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'FFA inexistente';
    END IF;

    IF v_status_atual = 'FINALIZADO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA já está finalizada';
    END IF;

    /* ===============================
       2️⃣ Fecha todos os itens em andamento
       =============================== */
    -- Itens de faturamento
    CALL sp_fechar_conta_ffa(p_id_ffa, p_id_usuario);

    -- Libera estados de execução em aberto (exames, procedimentos)
    CALL sp_liberar_estado_pos_execucao(p_id_ffa);

    /* ===============================
       3️⃣ Atualiza status da FFA
       =============================== */
    UPDATE ffa
       SET status = 'FINALIZADO',
           atualizado_em = NOW()
     WHERE id_ffa = p_id_ffa;

    /* ===============================
       4️⃣ Registra evento de fechamento
       =============================== */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FECHAMENTO_FFA',
        'SISTEMA',
        p_id_usuario,
        IFNULL(p_motivo, 'Fechamento automático'),
        NOW()
    );

    /* ===============================
       5️⃣ Atualiza status da senha associada
       =============================== */
    UPDATE senhas
       SET status = 'FINALIZADA'
     WHERE id = v_id_senha;

    /* ===============================
       6️⃣ Atualiza fila de senha (painel / guichê)
       =============================== */
    UPDATE fila_senha
       SET status = 'FINALIZADA'
     WHERE id_senha = v_id_senha;

    /* ===============================
       7️⃣ Auditoria final
       =============================== */
    INSERT INTO auditoria_ffa (
        id_ffa,
        id_usuario,
        acao,
        motivo,
        criado_em
    ) VALUES (
        p_id_ffa,
        p_id_usuario,
        'FECHAMENTO_FFA',
        IFNULL(p_motivo, 'Fechamento automático'),
        NOW()
    );

END