CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fluxo_guardiao_transicao`(
    IN p_id_usuario BIGINT,
    IN p_id_sistema BIGINT,
    IN p_nome_procedure VARCHAR(150),
    IN p_contexto VARCHAR(50),
    IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa BIGINT,
    IN p_evento VARCHAR(60)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_permitido INT DEFAULT 0;
    DECLARE v_tombstone INT DEFAULT 0;
    DECLARE v_hash_existente INT DEFAULT 0;
    DECLARE v_fingerprint CHAR(64);

    /* =====================================================
       RBAC CENTRAL
    ===================================================== */

    SELECT COUNT(1)
    INTO v_permitido
    FROM vw_usuario_permissoes vp
    WHERE vp.id_usuario = p_id_usuario
      AND vp.id_sistema = p_id_sistema
      AND vp.nome_procedure = p_nome_procedure
      AND vp.permitido = 1;

    IF v_permitido = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Acesso negado pelo guardião de fluxo';
    END IF;

    /* =====================================================
       TOMBSTONE ASSISTENCIAL
    ===================================================== */

    SELECT COUNT(1)
    INTO v_tombstone
    FROM tombstone_evento_assistencial
    WHERE id_ffa = p_id_ffa
    AND evento = p_evento;

    IF v_tombstone > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Evento bloqueado por tombstone assistencial';
    END IF;

    /* =====================================================
       HASH ASSISTENCIAL (IDEMPOTÊNCIA FORTE)
    ===================================================== */

    SET v_fingerprint = SHA2(
        CONCAT(
            p_id_ffa,
            '|',
            p_evento,
            '|',
            p_id_usuario
        ),
        256
    );

    SELECT COUNT(1)
    INTO v_hash_existente
    FROM assistencial_evento_hash
    WHERE hash_fingerprint = v_fingerprint;

    IF v_hash_existente > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Evento bloqueado por idempotência assistencial';
    END IF;

    INSERT INTO assistencial_evento_hash(
        hash_fingerprint,
        id_ffa,
        evento
    )
    VALUES(
        v_fingerprint,
        p_id_ffa,
        p_evento
    );

    /* =====================================================
       CHECKPOINT GLOBAL (CALL INTERNO)
    ===================================================== */

    CALL sp_checkpoint_global_validar(
        p_id_ffa,
        p_evento,
        p_id_sessao_usuario
    );

    /* =====================================================
       OBSERVABILIDADE OPERACIONAL (BEST EFFORT)
    ===================================================== */

    INSERT INTO auditoria_evento(
        id_sessao_usuario,
        evento,
        sucesso,
        descricao
    )
    VALUES(
        p_id_sessao_usuario,
        'GUARDIAO_OK',
        1,
        CONCAT(
            'Procedure=',p_nome_procedure,
            '|Contexto=',p_contexto
        )
    );

END ;;