-- Migration: align_sp_auth_contexto_set
-- Data: 2026-07-26
-- Descricao: Alinha sp_auth_contexto_set com o dump real de producao

DROP PROCEDURE IF EXISTS $sp;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_contexto_set`(
    IN p_id_sessao_usuario BIGINT UNSIGNED,
    IN p_id_unidade        BIGINT UNSIGNED,
    IN p_id_perfil         BIGINT UNSIGNED,
    IN p_id_local          BIGINT UNSIGNED
)
BEGIN
    DECLARE v_id_usuario   BIGINT UNSIGNED;
    DECLARE v_id_entidade  BIGINT UNSIGNED;
    DECLARE v_exists       INT;

    -- ==========================================
    -- 1. VALIDAR SESSAO + TENANT
    -- ==========================================
    SELECT su.id_usuario, su.id_entidade
    INTO v_id_usuario, v_id_entidade
    FROM sessao_usuario su
    WHERE su.id_sessao_usuario = p_id_sessao_usuario
      AND su.id_entidade IS NOT NULL
    LIMIT 1;

    IF v_id_usuario IS NULL OR v_id_entidade IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'SESSAO_INVALIDA_OU_SEM_TENANT';
    END IF;

    -- ==========================================
    -- 2. VALIDAR UNIDADE
    -- ==========================================
    SELECT COUNT(*) INTO v_exists
    FROM usuario_unidade uu
    WHERE uu.id_usuario  = v_id_usuario
      AND uu.id_unidade  = p_id_unidade
      AND uu.id_entidade = v_id_entidade;

    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'USUARIO_NAO_VINCULADO_UNIDADE';
    END IF;

    -- ==========================================
    -- 3. VALIDAR PERFIL
    -- ==========================================
    SELECT COUNT(*) INTO v_exists
    FROM usuario_perfil up
    WHERE up.id_usuario  = v_id_usuario
      AND up.id_perfil   = p_id_perfil
      AND up.id_entidade = v_id_entidade;

    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'PERFIL_INVALIDO_PARA_UNIDADE';
    END IF;

    -- ==========================================
    -- 4. VALIDAR LOCAL (com fallback "Nao Definida" se necessario)
    -- ==========================================
    IF p_id_local IS NULL THEN
        SET p_id_local = 0;
    ELSE
        SELECT COUNT(*) INTO v_exists
        FROM usuario_local ul
        WHERE ul.id_usuario  = v_id_usuario
          AND ul.id_local    = p_id_local
          AND ul.id_entidade = v_id_entidade;

        IF v_exists = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'LOCAL_INVALIDO_PARA_UNIDADE';
        END IF;
    END IF;

    -- ==========================================
    -- 5. ATUALIZAR CONTEXTO DA SESSAO
    -- ==========================================
    -- 6. ATUALIZAR CONTEXTO DA SESSAO
    -- ==========================================
    UPDATE sessao_usuario
    SET id_unidade     = p_id_unidade,
        id_local       = p_id_local,
        id_perfil      = p_id_perfil,
        atualizado_em  = NOW(6)
    WHERE id_sessao_usuario = p_id_sessao_usuario
      AND id_entidade       = v_id_entidade;

    -- ==========================================
    -- 7. PERSISTIR CONTEXTO (SNAPSHOT)
    -- ==========================================
    INSERT INTO usuario_contexto (
        id_usuario,
        id_sistema,
        id_entidade,
        id_unidade,
        id_local_operacional,
        id_perfil,
        criado_em
    ) VALUES (
        v_id_usuario,
        1,
        v_id_entidade,
        p_id_unidade,
        p_id_local,
        p_id_perfil,
        NOW(6)
    );

