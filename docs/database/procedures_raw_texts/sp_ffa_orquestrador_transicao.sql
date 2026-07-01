CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_orquestrador_transicao`(
    IN p_id_ffa BIGINT,
    IN p_estado_atual VARCHAR(60),
    IN p_evento VARCHAR(60),
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_id_sistema BIGINT,
    IN p_contexto VARCHAR(50),
    IN p_id_sessao_usuario BIGINT,
    OUT p_estado_novo VARCHAR(60)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_estado_destino VARCHAR(60);

    /* ===============================
       1. RBAC Guardião
    =============================== */

    CALL sp_fluxo_guardiao_transicao(
        p_id_usuario,
        p_id_sistema,
        CONCAT('sp_ffa_orquestrador_transicao'),
        p_contexto,
        p_id_sessao_usuario
    );

    /* ===============================
       2. Resolver Matriz
    =============================== */

    CALL sp_fluxo_executor_matriz(
        p_estado_atual,
        p_evento,
        p_id_perfil,
        p_contexto,
        p_id_sistema,
        p_id_sessao_usuario,
        v_estado_destino
    );

    /* ===============================
       3. Atualizar FFA (Estado global)
    =============================== */

    UPDATE ffa
    SET estado = v_estado_destino,
        atualizado_em = CURRENT_TIMESTAMP(6)
    WHERE id_ffa = p_id_ffa;

    /* ===============================
       4. Ledger append-only (auditabilidade federal)
    =============================== */

    INSERT INTO atendimento_evento(
        id_ffa,
        evento,
        estado_origem,
        estado_destino,
        id_usuario,
        id_sessao_usuario,
        criado_em
    )
    VALUES(
        p_id_ffa,
        p_evento,
        p_estado_atual,
        v_estado_destino,
        p_id_usuario,
        p_id_sessao_usuario,
        CURRENT_TIMESTAMP(6)
    );

    SET p_estado_novo = v_estado_destino;

END ;;