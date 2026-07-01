CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_manchester_runtime`(
    IN p_id_sessao BIGINT
)
    SQL SECURITY INVOKER
BEGIN

    -- =========================
    -- 1. DECLARAÇÕES
    -- =========================
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_perfil BIGINT;

    DECLARE v_uuid CHAR(36);

    DECLARE v_msg TEXT;
    DECLARE v_msg_final TEXT;

    -- =========================
    -- 2. HANDLER
    -- =========================
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT;
        ROLLBACK;

        SET v_msg_final = CONCAT('MANCHESTER_FAIL: ', v_msg);

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = v_msg_final;
    END;

    -- =========================
    -- 3. CONTEXTO
    -- =========================
    SELECT id_usuario, id_perfil
    INTO v_id_usuario, v_id_perfil
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao
    LIMIT 1;

    START TRANSACTION;

    -- =========================
    -- 4. ESCALONAMENTO DINÂMICO
    -- =========================
    UPDATE senha s
    JOIN fluxo_transicao_matriz f
        ON f.dominio_fluxo = 'FILA'
       AND f.estado_origem COLLATE utf8mb4_0900_ai_ci = s.contexto_fluxo
       AND f.ativo = 1

    SET 
        s.risco_dinamico = JSON_UNQUOTE(JSON_EXTRACT(f.condicao_validacao, '$.risco_resultante')),
        s.risco_dinamico_em = NOW(6),
        s.risco_dinamico_origem = 'SISTEMA',

        s.prioridade = CASE JSON_UNQUOTE(JSON_EXTRACT(f.condicao_validacao, '$.risco_resultante'))
            WHEN 'VERMELHO' THEN 100
            WHEN 'LARANJA' THEN 80
            WHEN 'AMARELO' THEN 50
            WHEN 'VERDE' THEN 20
            ELSE s.prioridade
        END

    WHERE
        s.executado_em IS NULL
        AND s.cancelado = 0
        AND s.nao_compareceu = 0
        AND TIMESTAMPDIFF(MINUTE, s.criado_em, NOW()) >
            CAST(JSON_UNQUOTE(JSON_EXTRACT(f.condicao_validacao, '$.tempo_max')) AS UNSIGNED);

    -- =========================
    -- 5. REORDENAÇÃO
    -- =========================
    SET @ordem := 0;

    UPDATE senha
    SET ordem_fila = (@ordem := @ordem + 1)
    WHERE executado_em IS NULL
      AND cancelado = 0
      AND nao_compareceu = 0
    ORDER BY prioridade DESC, criado_em ASC;

    -- =========================
    -- 6. LEDGER
    -- =========================
    SET v_uuid = UUID();

    CALL sp_ledger_evento_log(
        v_uuid,
        v_id_usuario,
        v_id_perfil,
        'MANCHESTER_AUTO',
        NULL,
        'EXECUTADO',
        JSON_OBJECT('tipo', 'RECLASSIFICACAO_AUTOMATICA'),
        'SUCESSO',
        'ESCALONAMENTO_SLA'
    );

    COMMIT;

END ;;