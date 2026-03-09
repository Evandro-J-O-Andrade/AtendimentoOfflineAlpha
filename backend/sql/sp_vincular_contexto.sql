-- ================================================================
-- SP: Vincular usuário ao contexto
-- Base tudoado no dump - via SP
-- ================================================================

DELIMITER ;;

-- ================================================================
-- SP: Vincular usuário ao sistema
-- ================================================================
DROP PROCEDURE IF EXISTS sp_usuario_vincular_sistema;;
CREATE PROCEDURE sp_usuario_vincular_sistema(
    IN p_id_usuario BIGINT,
    IN p_id_sistema BIGINT,
    IN p_id_perfil BIGINT
)
BEGIN
    INSERT INTO usuario_sistema (
        id_usuario,
        id_sistema,
        id_perfil,
        ativo,
        criado_em
    ) VALUES (
        p_id_usuario,
        p_id_sistema,
        p_id_perfil,
        1,
        NOW()
    )
    ON DUPLICATE KEY UPDATE
        id_perfil = VALUES(id_perfil),
        ativo = 1;
END ;;

-- ================================================================
-- SP: Vincular usuário à unidade
-- ================================================================
DROP PROCEDURE IF EXISTS sp_usuario_vincular_unidade;;
CREATE PROCEDURE sp_usuario_vincular_unidade(
    IN p_id_usuario BIGINT,
    IN p_id_unidade BIGINT
)
BEGIN
    INSERT INTO usuario_unidade (
        id_usuario,
        id_unidade,
        ativo,
        criado_em
    ) VALUES (
        p_id_usuario,
        p_id_unidade,
        1,
        NOW()
    )
    ON DUPLICATE KEY UPDATE
        ativo = 1;
END ;;

-- ================================================================
-- SP: Vincular usuário ao local operacional
-- ================================================================
DROP PROCEDURE IF EXISTS sp_usuario_vincular_local;;
CREATE PROCEDURE sp_usuario_vincular_local(
    IN p_id_usuario BIGINT,
    IN p_id_local_operacional BIGINT
)
BEGIN
    INSERT INTO usuario_local_operacional (
        id_usuario,
        id_local_operacional,
        criado_em
    ) VALUES (
        p_id_usuario,
        p_id_local_operacional,
        NOW()
    )
    ON DUPLICATE KEY UPDATE
        id_local_operacional = VALUES(id_local_operacional);
END ;;

-- ================================================================
-- SP: Criar contexto completo do usuário
-- ================================================================
DROP PROCEDURE IF EXISTS sp_usuario_criar_contexto;;
CREATE PROCEDURE sp_usuario_criar_contexto(
    IN p_login VARCHAR(60),
    IN p_id_sistema BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local_operacional BIGINT,
    IN p_id_perfil BIGINT
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    
    -- Busca ID do usuário
    SELECT id_usuario INTO v_id_usuario
    FROM usuario
    WHERE login = p_login
    LIMIT 1;
    
    IF v_id_usuario IS NULL THEN
        SELECT 'USUARIO_NAO_ENCONTRADO' as erro;
    ELSE
        -- Vincula ao sistema
        CALL sp_usuario_vincular_sistema(v_id_usuario, p_id_sistema, p_id_perfil);
        
        -- Vincula à unidade
        CALL sp_usuario_vincular_unidade(v_id_usuario, p_id_unidade);
        
        -- Vincula ao local
        CALL sp_usuario_vincular_local(v_id_usuario, p_id_local_operacional);
        
        -- Cria contexto
        INSERT INTO usuario_contexto (
            id_usuario,
            id_sistema,
            id_unidade,
            id_local_operacional,
            id_perfil,
            ativo,
            criado_em
        ) VALUES (
            v_id_usuario,
            p_id_sistema,
            p_id_unidade,
            p_id_local_operacional,
            p_id_perfil,
            1,
            NOW()
        )
        ON DUPLICATE KEY UPDATE
            id_sistema = VALUES(id_sistema),
            id_unidade = VALUES(id_unidade),
            id_local_operacional = VALUES(id_local_operacional),
            id_perfil = VALUES(id_perfil),
            ativo = 1;
        
        SELECT 'SUCESSO' as resultado, v_id_usuario as id_usuario;
    END IF;
END ;;

-- ================================================================
-- Executa para criar contexto do usuário evandro.andrade
-- ================================================================
CALL sp_usuario_criar_contexto('evandro.andrade', 1, 1, 1, 1);

-- Verifica o resultado
SELECT 
    u.id_usuario,
    u.login,
    u.nome,
    us.id_sistema,
    us.id_perfil,
    uu.id_unidade,
    ulo.id_local_operacional,
    uc.id_perfil as contexto_perfil
FROM usuario u
LEFT JOIN usuario_sistema us ON us.id_usuario = u.id_usuario
LEFT JOIN usuario_unidade uu ON uu.id_usuario = u.id_usuario
LEFT JOIN usuario_local_operacional ulo ON ulo.id_usuario = u.id_usuario
LEFT JOIN usuario_contexto uc ON uc.id_usuario = u.id_usuario
WHERE u.login = 'evandro.andrade';

DELIMITER ;
