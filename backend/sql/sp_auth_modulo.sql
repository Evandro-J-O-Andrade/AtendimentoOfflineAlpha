-- ============================================================================
-- MÓDULO DE AUTENTICAÇÃO - STORED PROCEDURES
-- SistemaHIS - CMDPro
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- SP: sp_auth_login
-- Realiza login e cria sessão
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_auth_login;

DELIMITER $$

CREATE PROCEDURE sp_auth_login(
    IN p_login VARCHAR(120),
    IN p_senha VARCHAR(120),
    IN p_id_sistema BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local_operacional BIGINT,
    IN p_id_dispositivo BIGINT,
    IN p_ip_origem VARCHAR(45),
    IN p_user_agent VARCHAR(255)
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_hash_senha VARCHAR(255);
    DECLARE v_token_runtime VARCHAR(120);
    DECLARE v_expira DATETIME;
    DECLARE v_id_sessao BIGINT;

    -- Procura usuário
    SELECT id_usuario, senha_hash
    INTO v_id_usuario, v_hash_senha
    FROM usuario
    WHERE login = p_login AND ativo = 1
    LIMIT 1;

    IF v_id_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'USUARIO_NAO_ENCONTRADO';
    END IF;

    -- Valida senha (suporta bcrypt, sha256 e texto plano)
    IF v_hash_senha IS NULL OR v_hash_senha = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'SENHA_INVALIDA';
    END IF;

    -- Gera token runtime
    SET v_token_runtime = REPLACE(UUID(), '-', '');
    SET v_expira = DATE_ADD(NOW(), INTERVAL 12 HOUR);

    -- Cria sessão
    INSERT INTO sessao_usuario (
        id_usuario,
        id_sistema,
        id_unidade,
        id_local,
        id_dispositivo,
        token_runtime,
        token_jwt,
        ip_origem,
        user_agent,
        iniciado_em,
        expiracao_em,
        atualizado_em,
        ativo
    ) VALUES (
        v_id_usuario,
        p_id_sistema,
        p_id_unidade,
        p_id_local_operacional,
        p_id_dispositivo,
        v_token_runtime,
        NULL,
        p_ip_origem,
        p_user_agent,
        NOW(),
        v_expira,
        NOW(),
        1
    );

    SET v_id_sessao = LAST_INSERT_ID();

    -- Retorna dados da sessão
    SELECT 
        v_id_sessao AS id_sessao_usuario,
        v_id_usuario AS id_usuario,
        p_id_sistema AS id_sistema,
        p_id_unidade AS id_unidade,
        p_id_local_operacional AS id_local_operacional,
        v_token_runtime AS token_runtime,
        v_expira AS expiracao_em;
END$$

DELIMITER ;

-- ============================================================================
-- SP: sp_auth_permissoes
-- Retorna permissões do usuário logado
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_auth_permissoes;

DELIMITER $$

CREATE PROCEDURE sp_auth_permissoes(
    IN p_token_runtime VARCHAR(120)
)
BEGIN
    SELECT 
        su.id_sessao_usuario,
        su.id_usuario,
        su.id_sistema,
        p.id_perfil,
        p.nome AS perfil_nome,
        pm.codigo,
        pm.nome AS permissao_nome,
        pm.nome_procedure,
        pm.rota_api,
        pm.tipo
    FROM sessao_usuario su
    JOIN usuario_sistema us ON us.id_usuario = su.id_usuario AND us.id_sistema = su.id_sistema
    JOIN perfil p ON p.id_perfil = us.id_perfil
    JOIN perfil_permissao pp ON pp.id_perfil = p.id_perfil AND pp.ativo = 1
    JOIN permissao pm ON pm.id_permissao = pp.id_permissao AND pm.ativo = 1
    WHERE su.token_runtime = p_token_runtime
      AND su.ativo = 1
      AND su.expiracao_em > NOW();
END$$

DELIMITER ;

-- ============================================================================
-- SP: sp_auth_validar_sessao
-- Valida se sessão está ativa
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_auth_validar_sessao;

DELIMITER $$

CREATE PROCEDURE sp_auth_validar_sessao(
    IN p_token_runtime VARCHAR(120)
)
BEGIN
    SELECT 
        id_sessao_usuario,
        id_usuario,
        id_sistema,
        id_unidade,
        id_local_operacional,
        expiracao_em
    FROM sessao_usuario
    WHERE token_runtime = p_token_runtime
      AND ativo = 1
      AND expiracao_em > NOW()
    LIMIT 1;
END$$

DELIMITER ;

-- ============================================================================
-- SP: sp_auth_logout
-- Encerra sessão
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_auth_logout;

DELIMITER $$

CREATE PROCEDURE sp_auth_logout(
    IN p_id_sessao BIGINT
)
BEGIN
    UPDATE sessao_usuario 
    SET ativo = 0, 
        finalized_em = NOW() 
    WHERE id_sessao_usuario = p_id_sessao;
    
    SELECT p_id_sessao AS id_sessao_usuario, 'LOGOUT_OK' AS status;
END$$

DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- FIM DO MÓDULO DE AUTENTICAÇÃO
-- ============================================================================
