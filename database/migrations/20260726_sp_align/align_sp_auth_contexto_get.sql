-- Migration: align_sp_auth_contexto_get
-- Data: 2026-07-26
-- Descricao: Alinha sp_auth_contexto_get com o dump real de producao

DROP PROCEDURE IF EXISTS $sp;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_contexto_get`(
    IN p_id_sessao_usuario BIGINT UNSIGNED
)
BEGIN
    DECLARE v_id_usuario  BIGINT UNSIGNED;
    DECLARE v_id_entidade BIGINT UNSIGNED;
    DECLARE v_id_unidade_atual BIGINT;
    DECLARE v_id_local_atual  BIGINT;

    -- ==========================================
    -- 1. VALIDAR SESSÃO
    -- ==========================================
    SELECT su.id_usuario, su.id_entidade, su.id_unidade, su.id_local
    INTO v_id_usuario, v_id_entidade, v_id_unidade_atual, v_id_local_atual
    FROM sessao_usuario su
    WHERE su.id_sessao_usuario = p_id_sessao_usuario
      AND su.id_entidade IS NOT NULL
    LIMIT 1;

    IF v_id_usuario IS NULL OR v_id_entidade IS NULL THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'SESSAO_INVALIDA_OU_SEM_TENANT';
    END IF;

    -- ==========================================
    -- 2. UNIDADES
    -- ==========================================
    SELECT DISTINCT
        uu.id_unidade,
        un.nome AS nome_unidade
    FROM usuario_unidade uu
    INNER JOIN unidade un
        ON un.id_unidade  = uu.id_unidade
       AND un.id_entidade = uu.id_entidade
    WHERE uu.id_usuario  = v_id_usuario
      AND uu.id_entidade = v_id_entidade
    ORDER BY un.nome;

    -- ==========================================
    -- 3. PERFIS
    -- ==========================================
    SELECT DISTINCT
        up.id_perfil,
        p.nome AS nome_perfil,
        up.id_unidade
    FROM usuario_perfil up
    INNER JOIN perfil p
        ON p.id_perfil   = up.id_perfil
       AND p.id_entidade = up.id_entidade
    INNER JOIN usuario_unidade uu
        ON uu.id_unidade  = up.id_unidade
       AND uu.id_usuario  = up.id_usuario
       AND uu.id_entidade = up.id_entidade
    WHERE up.id_usuario  = v_id_usuario
      AND up.id_entidade = v_id_entidade
    ORDER BY p.nome;

    -- ==========================================
    -- 4. LOCAIS / SALAS (com fallback "Não Definida")
    -- ==========================================
    SELECT DISTINCT
        COALESCE(ul.id_local, 0) AS id_sala,
        COALESCE(l.nome, 'Não Definida') AS nome_sala,
        ul.id_unidade
    FROM usuario_local ul
    LEFT JOIN local l
        ON l.id_local     = ul.id_local
       AND l.id_entidade  = ul.id_entidade
    INNER JOIN usuario_unidade uu
        ON uu.id_unidade  = ul.id_unidade
       AND uu.id_usuario  = ul.id_usuario
       AND uu.id_entidade = ul.id_entidade
    WHERE ul.id_usuario  = v_id_usuario
      AND ul.id_entidade = v_id_entidade
    ORDER BY nome_sala;

    -- ==========================================
    -- 5. CONTEXTO ATUAL DA SESSÃO
    -- ==========================================
    SELECT
        v_id_unidade_atual AS id_unidade_atual,
        v_id_local_atual   AS id_sala_atual;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_auth_contexto_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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

