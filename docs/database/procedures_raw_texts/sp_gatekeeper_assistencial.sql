CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gatekeeper_assistencial`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_saas BIGINT,
    IN p_id_unidade BIGINT,
    IN p_acao VARCHAR(80),
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_lock INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    /* ===============================
       Validação runtime básica
    =============================== */

    CALL sp_sessao_assert(p_id_sessao_usuario);

    START TRANSACTION;

    /* Lock lógico anti concorrência básica */

    SELECT 1
    INTO v_lock
    FROM coordenador_estado_global
    WHERE id_saas_entidade = p_id_saas
    AND id_unidade = p_id_unidade
    AND bloqueado = FALSE
    LIMIT 1
    FOR UPDATE;

    IF v_lock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Runtime assistencial bloqueado';
    END IF;

    /* ===============================
       Encaminhamento para kernel
    =============================== */

    CALL sp_orquestrador_assistencial(
        p_id_sessao_usuario,
        p_id_saas,
        p_id_unidade,
        NULL,
        JSON_UNQUOTE(p_payload->'$.id_senha'),
        p_acao,
        p_payload
    );

    COMMIT;

END ;;