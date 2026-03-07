-- ============================================================================
-- PATCH DE CONVERGENCIA - LEI IMUTAVEL DO CORE HIS SAAS
-- Base: Dump20260307 (1).sql + modulos existentes em backend/sql
-- Objetivo:
-- 1) eliminar drift de schema/procedures de auth
-- 2) corrigir nomenclatura canonica
-- 3) manter trilha de auditoria de patch
-- ============================================================================

USE `pronto_atendimento`;

-- ----------------------------------------------------------------------------
-- 0) Tabela de log de convergencia (idempotente)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS schema_convergencia_log (
    id_log BIGINT NOT NULL AUTO_INCREMENT,
    patch_nome VARCHAR(120) NOT NULL,
    status_execucao ENUM('SUCESSO','ERRO') NOT NULL,
    detalhes JSON NULL,
    criado_em DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id_log),
    KEY idx_patch_nome_data (patch_nome, criado_em)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 1) SESSAO_USUARIO: compatibilidade entre dumps/modulos legados
-- ----------------------------------------------------------------------------

-- token_runtime (usado por authService + sp_auth_permissoes)
SET @col_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'sessao_usuario'
      AND column_name = 'token_runtime'
);
SET @sql = IF(
    @col_exists = 0,
    "ALTER TABLE sessao_usuario ADD COLUMN token_runtime CHAR(64) NULL",
    "SELECT 'token_runtime ja existe' AS msg"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- expiracao_em (compat com scripts legados; dump canônico usa expira_em)
SET @col_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'sessao_usuario'
      AND column_name = 'expiracao_em'
);
SET @sql = IF(
    @col_exists = 0,
    "ALTER TABLE sessao_usuario ADD COLUMN expiracao_em DATETIME(6) NULL",
    "SELECT 'expiracao_em ja existe' AS msg"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- finalized_em (nome legado; dump canônico usa finalizado_em)
SET @col_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'sessao_usuario'
      AND column_name = 'finalized_em'
);
SET @sql = IF(
    @col_exists = 0,
    "ALTER TABLE sessao_usuario ADD COLUMN finalized_em DATETIME(6) NULL",
    "SELECT 'finalized_em ja existe' AS msg"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ultimo_heartbeat (usado por dispatcher/runtime)
SET @col_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'sessao_usuario'
      AND column_name = 'ultimo_heartbeat'
);
SET @sql = IF(
    @col_exists = 0,
    "ALTER TABLE sessao_usuario ADD COLUMN ultimo_heartbeat DATETIME(6) NULL",
    "SELECT 'ultimo_heartbeat ja existe' AS msg"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- indice canonico de token_runtime
SET @idx_exists = (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'sessao_usuario'
      AND index_name = 'idx_sessao_token_runtime'
);
SET @sql = IF(
    @idx_exists = 0,
    "ALTER TABLE sessao_usuario ADD INDEX idx_sessao_token_runtime (token_runtime)",
    "SELECT 'idx_sessao_token_runtime ja existe' AS msg"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ----------------------------------------------------------------------------
-- 2) NOME CANONICO: remover sufixo versionado (_v1)
-- ----------------------------------------------------------------------------
-- Se houver FK com nome versionado, remove primeiro
SET @fk_exists = (
    SELECT COUNT(*)
    FROM information_schema.table_constraints
    WHERE table_schema = DATABASE()
      AND table_name = 'lab_protocolo_interno'
      AND constraint_type = 'FOREIGN KEY'
      AND constraint_name = 'fk_lab_protocolo_ffa_v1'
);
SET @sql = IF(
    @fk_exists > 0,
    "ALTER TABLE lab_protocolo_interno DROP FOREIGN KEY fk_lab_protocolo_ffa_v1",
    "SELECT 'FK fk_lab_protocolo_ffa_v1 nao existia' AS msg"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Depois remove indice versionado (se existir)
SET @idx_exists = (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'lab_protocolo_interno'
      AND index_name = 'fk_lab_protocolo_ffa_v1'
);
SET @sql = IF(
    @idx_exists > 0,
    "ALTER TABLE lab_protocolo_interno DROP INDEX fk_lab_protocolo_ffa_v1",
    "SELECT 'indice fk_lab_protocolo_ffa_v1 nao existia' AS msg"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_exists = (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'lab_protocolo_interno'
      AND index_name = 'idx_lab_protocolo_ffa'
);
SET @sql = IF(
    @idx_exists = 0,
    "ALTER TABLE lab_protocolo_interno ADD INDEX idx_lab_protocolo_ffa (id_ffa)",
    "SELECT 'idx_lab_protocolo_ffa ja existe' AS msg"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ----------------------------------------------------------------------------
-- 3) Tabelas auxiliares de auth (somente se ausentes)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS auth_parametro (
    chave VARCHAR(120) NOT NULL,
    valor VARCHAR(255) NOT NULL,
    descricao VARCHAR(255) NULL,
    categoria VARCHAR(80) NULL,
    ativo TINYINT(1) DEFAULT 1,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (chave)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS auth_log (
    id_log BIGINT NOT NULL AUTO_INCREMENT,
    id_usuario BIGINT NULL,
    tipo_evento VARCHAR(60) NOT NULL,
    ip_origem VARCHAR(45) NULL,
    user_agent TEXT NULL,
    mensagem TEXT NULL,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_log),
    KEY idx_auth_log_usuario_data (id_usuario, criado_em)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS auth_tentativa_login (
    id_tentativa BIGINT NOT NULL AUTO_INCREMENT,
    login VARCHAR(80) NOT NULL,
    ip_origem VARCHAR(45) NULL,
    user_agent TEXT NULL,
    sucesso TINYINT(1) NOT NULL DEFAULT 0,
    motivo_falha VARCHAR(120) NULL,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_tentativa),
    KEY idx_auth_tentativa_login_data (login, criado_em)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS auth_bloqueio (
    id_bloqueio BIGINT NOT NULL AUTO_INCREMENT,
    id_usuario BIGINT NOT NULL,
    tipo_bloqueio VARCHAR(60) NOT NULL,
    motivo TEXT NULL,
    expira_em DATETIME NULL,
    ativo TINYINT(1) DEFAULT 1,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_bloqueio),
    KEY idx_auth_bloqueio_usuario_ativo (id_usuario, ativo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO auth_parametro(chave, valor, descricao, categoria, ativo)
VALUES
('login_tentativas_maximas','5','Maximo de tentativas de login','BLOQUEIO',1),
('login_bloqueio_minutos','30','Tempo de bloqueio apos exceder tentativas','BLOQUEIO',1)
ON DUPLICATE KEY UPDATE
valor = VALUES(valor),
descricao = VALUES(descricao),
categoria = VALUES(categoria),
ativo = VALUES(ativo);

-- ----------------------------------------------------------------------------
-- 4) Procedures de AUTH convergentes (sem quebrar core existente)
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_auth_login;
DELIMITER $$
CREATE PROCEDURE sp_auth_login(
    IN p_login VARCHAR(120),
    IN p_senha VARCHAR(255),
    IN p_id_sistema BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local_operacional BIGINT,
    IN p_id_dispositivo BIGINT,
    IN p_ip_origem VARCHAR(45),
    IN p_user_agent VARCHAR(255)
)
main: BEGIN
    DECLARE v_id_usuario BIGINT DEFAULT NULL;
    DECLARE v_hash_senha VARCHAR(255);
    DECLARE v_id_perfil BIGINT DEFAULT NULL;
    DECLARE v_id_sistema BIGINT DEFAULT NULL;
    DECLARE v_id_unidade BIGINT DEFAULT NULL;
    DECLARE v_id_local BIGINT DEFAULT NULL;
    DECLARE v_tentativas INT DEFAULT 0;
    DECLARE v_bloqueado_ate DATETIME(6);
    DECLARE v_max_tentativas INT DEFAULT 5;
    DECLARE v_bloqueio_min INT DEFAULT 30;
    DECLARE v_token_runtime CHAR(64);
    DECLARE v_expira DATETIME(6);
    DECLARE v_id_sessao BIGINT;

    -- parametros de bloqueio
    SELECT CAST(valor AS UNSIGNED) INTO v_max_tentativas
    FROM auth_parametro WHERE chave = 'login_tentativas_maximas' AND ativo = 1 LIMIT 1;
    SELECT CAST(valor AS UNSIGNED) INTO v_bloqueio_min
    FROM auth_parametro WHERE chave = 'login_bloqueio_minutos' AND ativo = 1 LIMIT 1;

    SELECT id_usuario, senha_hash, COALESCE(tentativas_login,0), bloqueado_ate
      INTO v_id_usuario, v_hash_senha, v_tentativas, v_bloqueado_ate
      FROM usuario
     WHERE login = p_login
       AND ativo = 1
     LIMIT 1;

    IF v_id_usuario IS NULL THEN
        INSERT INTO auth_tentativa_login(login, ip_origem, user_agent, sucesso, motivo_falha)
        VALUES (p_login, p_ip_origem, p_user_agent, 0, 'USUARIO_NAO_ENCONTRADO');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'USUARIO_NAO_ENCONTRADO';
        LEAVE main;
    END IF;

    IF v_bloqueado_ate IS NOT NULL AND v_bloqueado_ate > NOW(6) THEN
        INSERT INTO auth_tentativa_login(login, ip_origem, user_agent, sucesso, motivo_falha)
        VALUES (p_login, p_ip_origem, p_user_agent, 0, 'USUARIO_BLOQUEADO');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'USUARIO_BLOQUEADO';
        LEAVE main;
    END IF;

    -- A validacao de senha JA foi feita pelo JavaScript (bcrypt/SHA256)
    -- Aqui apenas verificamos se o usuario existe e esta ativo
    -- A procedure cria a sessao se o usuario for valido
    
    IF v_id_usuario IS NULL THEN
        INSERT INTO auth_tentativa_login(login, ip_origem, user_agent, sucesso, motivo_falha)
        VALUES (p_login, p_ip_origem, p_user_agent, 0, 'USUARIO_NAO_ENCONTRADO');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'USUARIO_NAO_ENCONTRADO';
        LEAVE main;
    END IF;

    -- resolve contexto preferindo entrada explicita; fallback usuario_contexto
    SET v_id_sistema = p_id_sistema;
    SET v_id_unidade = p_id_unidade;
    SET v_id_local = p_id_local_operacional;

    IF v_id_sistema IS NULL OR v_id_unidade IS NULL OR v_id_local IS NULL THEN
        SELECT uc.id_sistema, uc.id_unidade, uc.id_local_operacional, uc.id_perfil
          INTO v_id_sistema, v_id_unidade, v_id_local, v_id_perfil
          FROM usuario_contexto uc
         WHERE uc.id_usuario = v_id_usuario
           AND uc.ativo = 1
         ORDER BY uc.id_usuario_contexto
         LIMIT 1;
    END IF;

    IF v_id_sistema IS NULL OR v_id_unidade IS NULL OR v_id_local IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SEM_CONTEXTO';
        LEAVE main;
    END IF;

    IF v_id_perfil IS NULL THEN
        SELECT us.id_perfil
          INTO v_id_perfil
          FROM usuario_sistema us
         WHERE us.id_usuario = v_id_usuario
           AND us.id_sistema = v_id_sistema
           AND us.ativo = 1
         LIMIT 1;
    END IF;

    -- sucesso de login
    UPDATE usuario
       SET tentativas_login = 0,
           bloqueado_ate = NULL,
           ultimo_login = NOW(6),
           ultimo_ip = p_ip_origem
     WHERE id_usuario = v_id_usuario
     ORDER BY id_usuario
     LIMIT 1;

    SET v_token_runtime = LOWER(REPLACE(UUID(), '-', ''));
    SET v_expira = DATE_ADD(NOW(6), INTERVAL 8 HOUR);

    INSERT INTO sessao_usuario(
        id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil,
        id_dispositivo, token_runtime, token_jwt, ip_origem, user_agent,
        iniciado_em, expira_em, expiracao_em, ativo, revogado, criado_em, atualizado_em, ultimo_heartbeat
    ) VALUES (
        v_id_usuario, v_id_sistema, v_id_unidade, v_id_local, v_id_perfil,
        p_id_dispositivo, v_token_runtime, NULL, p_ip_origem, p_user_agent,
        NOW(6), v_expira, v_expira, 1, 0, NOW(6), NOW(6), NOW(6)
    );

    SET v_id_sessao = LAST_INSERT_ID();

    INSERT INTO auth_tentativa_login(login, ip_origem, user_agent, sucesso, motivo_falha)
    VALUES (p_login, p_ip_origem, p_user_agent, 1, NULL);

    INSERT INTO auth_log(id_usuario, tipo_evento, ip_origem, user_agent, mensagem)
    VALUES (v_id_usuario, 'LOGIN_SUCESSO', p_ip_origem, p_user_agent, 'Login realizado com sucesso');

    SELECT
        v_id_sessao AS id_sessao_usuario,
        v_id_usuario AS id_usuario,
        v_id_sistema AS id_sistema,
        v_id_unidade AS id_unidade,
        v_id_local AS id_local_operacional,
        v_token_runtime AS token_runtime,
        v_expira AS expiracao_em;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_auth_permissoes;
DELIMITER $$
CREATE PROCEDURE sp_auth_permissoes(IN p_token_runtime VARCHAR(120))
BEGIN
    SELECT
        su.id_sessao_usuario,
        su.id_usuario,
        su.id_sistema,
        uc.id_perfil,
        p.nome AS perfil_nome,
        pm.codigo,
        pm.nome AS permissao_nome,
        pm.nome_procedure
    FROM sessao_usuario su
    JOIN usuario_contexto uc
      ON uc.id_usuario = su.id_usuario
     AND uc.id_sistema = su.id_sistema
     AND uc.ativo = 1
    JOIN perfil p
      ON p.id_perfil = uc.id_perfil
    JOIN perfil_permissao pp
      ON pp.id_perfil = p.id_perfil
    JOIN permissao pm
      ON pm.id_permissao = pp.id_permissao
     AND pm.ativo = 1
    WHERE su.ativo = 1
      AND su.revogado = 0
      AND su.token_runtime = p_token_runtime
      AND COALESCE(su.expiracao_em, su.expira_em) > NOW(6);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_auth_validar_sessao;
DELIMITER $$
CREATE PROCEDURE sp_auth_validar_sessao(IN p_token_runtime VARCHAR(120))
BEGIN
    SELECT
        id_sessao_usuario,
        id_usuario,
        id_sistema,
        id_unidade,
        id_local_operacional,
        COALESCE(expiracao_em, expira_em) AS expiracao_em
    FROM sessao_usuario
    WHERE ativo = 1
      AND revogado = 0
      AND token_runtime = p_token_runtime
      AND COALESCE(expiracao_em, expira_em) > NOW(6)
    LIMIT 1;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_auth_logout;
DELIMITER $$
CREATE PROCEDURE sp_auth_logout(IN p_id_sessao BIGINT)
BEGIN
    UPDATE sessao_usuario
       SET ativo = 0,
           revogado = 1,
           finalizado_em = NOW(6),
           finalized_em = NOW(6),
           atualizado_em = NOW(6)
     WHERE id_sessao_usuario = p_id_sessao;

    SELECT p_id_sessao AS id_sessao_usuario, 'LOGOUT_OK' AS status;
END$$
DELIMITER ;

-- ----------------------------------------------------------------------------
-- 5) Visao canônica de eventos (sem remover tabelas existentes)
-- ----------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_evento_assistencial_unificado;
CREATE VIEW vw_evento_assistencial_unificado AS
SELECT 'workflow_ffa_evento' AS origem_tabela, w.id_ffa, w.tipo_evento AS evento, w.detalhe, w.id_sessao_usuario, w.criado_em
  FROM workflow_ffa_evento w
UNION ALL
SELECT
    'atendimento_evento' AS origem_tabela,
    a.id_ffa,
    a.tipo_evento AS evento,
    CONCAT(
        COALESCE(a.estado_origem, '(null)'),
        ' -> ',
        COALESCE(a.estado_destino, '(null)')
    ) AS detalhe,
    a.id_sessao_usuario,
    a.criado_em
  FROM atendimento_evento a
UNION ALL
SELECT
    'fila_operacional_evento' AS origem_tabela,
    fo.id_ffa,
    fe.tipo_evento AS evento,
    fe.detalhe,
    fe.id_sessao_usuario,
    fe.criado_em
  FROM fila_operacional_evento fe
  JOIN fila_operacional fo
    ON fo.id_fila = fe.id_fila;

-- ----------------------------------------------------------------------------
-- 6) Log final
-- ----------------------------------------------------------------------------
INSERT INTO schema_convergencia_log (patch_nome, status_execucao, detalhes)
VALUES (
    'patch_convergencia_lei_imutavel',
    'SUCESSO',
    JSON_OBJECT(
        'escopo', 'auth+sessao+nomenclatura+visao_eventos',
        'executado_em', NOW(6)
    )
);

-- FIM
