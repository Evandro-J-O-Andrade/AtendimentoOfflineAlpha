-- ================================================================
-- Runtime API Session Token Table
-- ================================================================
-- Token de sessão para API runtime
-- ================================================================

DROP TABLE IF EXISTS runtime_api_session_token;

CREATE TABLE runtime_api_session_token (
    id_token BIGINT NOT NULL AUTO_INCREMENT,
    id_usuario BIGINT NOT NULL,
    uuid_runtime VARCHAR(36) NOT NULL,
    token_hash VARCHAR(255) NOT NULL,
    expira_em DATETIME NOT NULL,
    device_id VARCHAR(100) DEFAULT NULL,
    tenant_id BIGINT DEFAULT 1,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    ultimo_acesso DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id_token),
    UNIQUE KEY uk_uuid_runtime (uuid_runtime),
    INDEX idx_token_hash (token_hash),
    INDEX idx_id_usuario (id_usuario),
    INDEX idx_expira (expira_em)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- Kernel Runtime Heartbeat
-- ================================================================
-- Mantém sessões ativas com heartbeat
-- Tenant aware e Device aware
-- ================================================================

DROP PROCEDURE IF EXISTS sp_kernel_runtime_heartbeat;

DELIMITER //

CREATE PROCEDURE sp_kernel_runtime_heartbeat(
    IN p_id_sessao BIGINT,
    IN p_uuid_runtime VARCHAR(36),
    IN p_id_dispositivo BIGINT
)
SQL SECURITY INVOKER
BEGIN
    DECLARE v_expira_em DATETIME;
    DECLARE v_id_usuario BIGINT;
    
    -- Validar parâmetros
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID_SESSAO_OBRIGATORIO';
    END IF;
    
    -- Buscar informações da sessão
    SELECT id_usuario, expira_em INTO v_id_usuario, v_expira_em
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao;
    
    IF v_id_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'SESSAO_NAO_ENCONTRADA';
    END IF;
    
    -- Verificar se expirou
    IF v_expira_em < NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'SESSAO_EXPIRADA';
    END IF;
    
    -- Atualizar último acesso na sessão
    UPDATE sessao_usuario
    SET ultimo_acesso = NOW()
    WHERE id_sessao_usuario = p_id_sessao;
    
    -- Atualizar heartbeat no token API se existir
    IF p_uuid_runtime IS NOT NULL THEN
        UPDATE runtime_api_session_token
        SET ultimo_acesso = NOW()
        WHERE uuid_runtime = p_uuid_runtime
        AND ativo = 1;
    END IF;
    
    -- Retornar status
    SELECT 
        p_id_sessao AS id_sessao,
        v_id_usuario AS id_usuario,
        v_expira_em AS expira_em,
        'ATIVO' AS status,
        TIMESTAMPDIFF(SECOND, NOW(), v_expira_em) AS segundos_restantes,
        NOW() AS heartbeat_at;
    
END//

DELIMITER ;

-- ================================================================
-- Fila de Execução do Runtime
-- ================================================================

DROP TABLE IF EXISTS runtime_execution_queue;

CREATE TABLE runtime_execution_queue (
    id VARCHAR(36) NOT NULL,
    id_sessao BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_perfil BIGINT NOT NULL,
    acao VARCHAR(100) NOT NULL,
    contexto VARCHAR(60) DEFAULT 'DEFAULT',
    payload JSON,
    status ENUM('PENDENTE', 'PROCESSANDO', 'CONCLUIDO', 'ERRO', 'CANCELADO') DEFAULT 'PENDENTE',
    prioridade INT DEFAULT 0,
    retry_count INT DEFAULT 0,
    ultimo_erro TEXT,
    duracao_ms INT DEFAULT NULL,
    resultado TEXT,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_status (status, criado_em),
    INDEX idx_usuario (id_usuario),
    INDEX idx_sessao (id_sessao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- Kernel Ledger - Immutable Audit Trail
-- ================================================================

DROP TABLE IF EXISTS kernel_ledger;

CREATE TABLE kernel_ledger (
    id_transacao VARCHAR(36) NOT NULL,
    id_sessao BIGINT,
    id_usuario BIGINT NOT NULL,
    id_perfil BIGINT NOT NULL,
    acao VARCHAR(100) NOT NULL,
    contexto VARCHAR(60) DEFAULT 'DEFAULT',
    payload JSON,
    status VARCHAR(20) NOT NULL,
    duracao_ms INT DEFAULT NULL,
    mensagem TEXT,
    id_tenant BIGINT DEFAULT 1,
    registrado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_transacao),
    INDEX idx_usuario (id_usuario, registrado_em),
    INDEX idx_acao (acao, registrado_em),
    INDEX idx_contexto (contexto, registrado_em),
    INDEX idx_status (status, registrado_em),
    INDEX idx_tenant (id_tenant, registrado_em)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- Procedure para limpar sessões expiradas
-- ================================================================

DROP PROCEDURE IF EXISTS sp_kernel_cleanup_expired;

DELIMITER //

CREATE PROCEDURE sp_kernel_cleanup_expired()
SQL SECURITY INVOKER
BEGIN
    DECLARE v_sessoes_removidas INT DEFAULT 0;
    DECLARE v_tokens_removidos INT DEFAULT 0;
    
    -- Remover sessões expiradas
    DELETE FROM sessao_usuario WHERE expira_em < NOW();
    SET v_sessoes_removidas = ROW_COUNT();
    
    -- Remover tokens expirados
    DELETE FROM runtime_api_session_token WHERE expira_em < NOW();
    SET v_tokens_removidos = ROW_COUNT();
    
    -- Limpar filas antigas
    DELETE FROM runtime_execution_queue 
    WHERE status IN ('CONCLUIDO', 'ERRO') 
    AND atualizado_em < DATE_SUB(NOW(), INTERVAL 7 DAY);
    
    SELECT 
        v_sessoes_removidas AS sessoes_removidas,
        v_tokens_removidos AS tokens_removidos,
        NOW() AS cleanup_at;
    
END//

DELIMITER ;
