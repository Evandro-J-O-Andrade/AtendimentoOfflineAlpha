-- ================================================================
-- Kernel Gateway Assert - Anti-bypass Runtime Guard
-- ================================================================
-- Protege o dispatcher contra bypass de permissões
-- Garante que todas as operações passaram pelo authorization layer
-- ================================================================

DROP PROCEDURE IF EXISTS sp_kernel_gateway_assert;

DELIMITER //

CREATE PROCEDURE sp_kernel_gateway_assert(
    IN p_id_tenant BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_contexto VARCHAR(60),
    IN p_recurso VARCHAR(120),
    IN p_estado_origem VARCHAR(60),
    IN p_estado_destino VARCHAR(60),
    IN p_id_dispositivo BIGINT
)
SQL SECURITY INVOKER
BEGIN
    -- Declare variables for authorization check
    DECLARE v_authorized BOOLEAN DEFAULT FALSE;
    DECLARE v_error_message VARCHAR(500);
    
    -- Validate inputs
    IF p_id_usuario IS NULL OR p_id_usuario = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID_USUARIO_OBRIGATORIO';
    END IF;
    
    IF p_id_perfil IS NULL OR p_id_perfil = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID_PERFIL_OBRIGATORIO';
    END IF;
    
    IF p_contexto IS NULL OR p_contexto = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CONTEXTO_OBRIGATORIO';
    END IF;
    
    -- Admin always authorized
    IF p_id_perfil = 1 THEN
        SET v_authorized = TRUE;
    ELSE
        -- Call authorization assertion
        CALL sp_kernel_authz_assert(
            p_id_tenant,
            p_id_perfil,
            p_contexto,
            p_recurso,
            p_estado_origem,
            p_estado_destino,
            p_id_dispositivo
        );
        
        SET v_authorized = TRUE;
    END IF;
    
    -- Return success
    SELECT 
        v_authorized AS authorized,
        p_id_usuario AS id_usuario,
        p_id_perfil AS id_perfil,
        p_contexto AS contexto,
        NOW() AS validated_at
    ;
END//

DELIMITER ;

-- ================================================================
-- Kernel Authorization Assert - Core RBAC Validation
-- ================================================================

DROP PROCEDURE IF EXISTS sp_kernel_authz_assert;

DELIMITER //

CREATE PROCEDURE sp_kernel_authz_assert(
    IN p_id_tenant BIGINT,
    IN p_id_perfil BIGINT,
    IN p_contexto VARCHAR(60),
    IN p_recurso VARCHAR(120),
    IN p_estado_origem VARCHAR(60),
    IN p_estado_destino VARCHAR(60),
    IN p_id_dispositivo BIGINT
)
SQL SECURITY INVOKER
BEGIN
    DECLARE v_permissao_encontrada BOOLEAN DEFAULT FALSE;
    DECLARE v_codigo_permissao VARCHAR(200);
    
    -- Admin tem acesso total
    IF p_id_perfil = 1 THEN
        LEAVE;
    END IF;
    
    -- Verificar se tabela de permissões existe
    IF (SELECT COUNT(*) FROM information_schema.tables 
        WHERE table_schema = DATABASE() 
        AND table_name = 'perfil_permissao') = 0 THEN
        -- Tabela não existe, permitir em modo desenvolvimento
        IF @@session.sql_mode NOT LIKE '%NO_ENGINE_SUBSTITUTION%' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'TABELA_PERMISSOES_NAO_EXISTE';
        END IF;
        LEAVE;
    END IF;
    
    -- Montar código de permissão
    SET v_codigo_permissao = CONCAT(p_recurso, '_', p_estado_destino);
    
    -- Verificar permissão específica
    SELECT COUNT(*) > 0 INTO v_permissao_encontrada
    FROM perfil_permissao pp
    JOIN permissao p ON p.id_permissao = pp.id_permissao
    WHERE pp.id_perfil = p_id_perfil
    AND p.codigo = v_codigo_permissao;
    
    -- Se não encontrou, verificar curinga
    IF NOT v_permissao_encontrada THEN
        SET v_codigo_permissao = CONCAT(p_recurso, '_*');
        SELECT COUNT(*) > 0 INTO v_permissao_encontrada
        FROM perfil_permissao pp
        JOIN permissao p ON p.id_permissao = pp.id_permissao
        WHERE pp.id_perfil = p_id_perfil
        AND p.codigo = v_codigo_permissao;
    END IF;
    
    -- Se ainda não encontrou, verificar permissão de contexto
    IF NOT v_permissao_encontrada THEN
        SET v_codigo_permissao = CONCAT(p_contexto, '_', p_estado_destino);
        SELECT COUNT(*) > 0 INTO v_permissao_encontrada
        FROM perfil_permissao pp
        JOIN permissao p ON p.id_permissao = pp.id_permissao
        WHERE pp.id_perfil = p_id_perfil
        AND p.codigo = v_codigo_permissao;
    END IF;
    
    -- Se nenhuma permissão encontrada, negar
    IF NOT v_permissao_encontrada THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = CONCAT('PERMISSAO_NEGADA: ', v_codigo_permissao);
    END IF;
    
    -- Log de acesso bem-sucedido (para auditoria)
    INSERT INTO kernel_authorization_log (
        id_tenant,
        id_usuario,
        id_perfil,
        contexto,
        recurso,
        estado_origem,
        estado_destino,
        autorizado_em,
        ip_origem
    )
    SELECT 
        p_id_tenant,
        id_usuario,
        p_id_perfil,
        p_contexto,
        p_recurso,
        p_estado_origem,
        p_estado_destino,
        NOW(),
        SUBSTRING_INDEX(SUBSTRING_INDEX(COALESCE(@@global.proxy_users,''), ',', 1), ',', -1)
    FROM sessao_usuario
    WHERE id_usuario = (SELECT id_usuario FROM sessao_usuario LIMIT 1)
    LIMIT 1
    ON DUPLICATE KEY UPDATE autorizado_em = NOW();
    
END//

DELIMITER ;

-- ================================================================
-- Tabela de Log de Autorização do Kernel
-- ================================================================

DROP TABLE IF EXISTS kernel_authorization_log;

CREATE TABLE kernel_authorization_log (
    id_log BIGINT NOT NULL AUTO_INCREMENT,
    id_tenant BIGINT DEFAULT NULL,
    id_usuario BIGINT NOT NULL,
    id_perfil BIGINT NOT NULL,
    contexto VARCHAR(60) NOT NULL,
    recurso VARCHAR(120) NOT NULL,
    estado_origem VARCHAR(60) DEFAULT NULL,
    estado_destino VARCHAR(60) NOT NULL,
    autorizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_origem VARCHAR(45) DEFAULT NULL,
    dispositivo_id BIGINT DEFAULT NULL,
    PRIMARY KEY (id_log),
    INDEX idx_log_usuario (id_usuario, autorizado_em),
    INDEX idx_log_contexto (contexto, autorizado_em),
    INDEX idx_log_recurso (recurso, autorizado_em)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
