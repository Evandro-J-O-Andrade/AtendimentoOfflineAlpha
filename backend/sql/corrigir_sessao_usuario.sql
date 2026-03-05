-- ================================================================
-- CORREÇÃO: Tabela sessao_usuario - Adicionar colunas de contexto
-- ================================================================
-- Problema: A procedure sp_sessao_abrir tenta inserir colunas
-- que não existem na tabela sessao_usuario
-- ================================================================

-- Verificar se as colunas já existem antes de adicionar
-- Se já existir, não faz nada (SAFE MODE)

-- 1. Adicionar id_sistema
-- ALTER TABLE sessao_usuario ADD COLUMN id_sistema BIGINT DEFAULT NULL AFTER id_usuario;
-- ALTER TABLE sessao_usuario ADD COLUMN id_unidade BIGINT DEFAULT NULL AFTER id_sistema;
-- ALTER TABLE sessao_usuario ADD COLUMN id_local_operacional BIGINT DEFAULT NULL AFTER id_unidade;
-- ALTER TABLE sessao_usuario ADD COLUMN id_cidade BIGINT DEFAULT NULL AFTER id_local_operacional;

-- Como a tabela pode ter dados, vamos fazer via procedure CORRIGIDA
-- que usa as colunas corretas existentes

-- ================================================================
-- Procedure sp_sessao_abrir CORRIGIDA para usar a estrutura real
-- ================================================================
DROP PROCEDURE IF EXISTS sp_sessao_abrir;

DELIMITER ;;
CREATE PROCEDURE sp_sessao_abrir(
    IN  p_id_usuario          BIGINT,
    IN  p_id_sistema          BIGINT,
    IN  p_id_unidade          BIGINT,
    IN  p_id_local_operacional BIGINT,
    IN  p_token_runtime       TEXT,
    IN  p_ip_origem           VARCHAR(45),
    IN  p_agente_usuario      TEXT,
    IN  p_expira_em           DATETIME,
    OUT p_id_sessao_usuario   BIGINT
)
BEGIN
    -- Valida FKs básicas
    IF NOT EXISTS (SELECT 1 FROM usuario u WHERE u.id_usuario = p_id_usuario AND u.ativo = 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário inexistente ou inativo';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM sistema s WHERE s.id_sistema = p_id_sistema) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sistema inexistente';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM unidade un WHERE un.id_unidade = p_id_unidade) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unidade inexistente';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM local_operacional lo WHERE lo.id_local_operacional = p_id_local_operacional) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Local operacional inexistente';
    END IF;

    -- Inserir sessão usando as colunas CORRETAS da tabela
    INSERT INTO sessao_usuario (
        id_usuario,
        id_saas_entidade,  -- Manter兼容 com estrutura existente
        token_runtime,
        setor_contexto,
        unidade_contexto,
        ip_origem,
        agente_usuario,
        ativo,
        expira_em,
        ultimo_heartbeat,
        tentativas_invalidas,
        criado_em
    ) VALUES (
        p_id_usuario,
        1,  -- id_saas_entidade default
        p_token_runtime,
        p_id_sistema,       -- setor_contexto = id_sistema
        p_id_unidade,       -- unidade_contexto = id_unidade
        p_ip_origem,
        p_agente_usuario,
        1,
        p_expira_em,
        NOW(),
        0,
        NOW()
    );

    SET p_id_sessao_usuario = LAST_INSERT_ID();

    -- Registrar no ledger (se existir)
    -- CALL sp_auditoria_evento_registrar(...);
END ;;
DELIMITER ;

-- ================================================================
-- Procedure sp_sessao_assert CORRIGIDA
-- ================================================================
DROP PROCEDURE IF EXISTS sp_sessao_assert;

DELIMITER ;;
CREATE PROCEDURE sp_sessao_assert(
    IN p_id_sessao_usuario BIGINT
)
BEGIN
    DECLARE v_expiracao DATETIME(6);
    DECLARE v_ativo TINYINT;
    DECLARE v_bloqueado_ate DATETIME(6);
    
    -- Busca dados da sessão
    SELECT 
        expira_em, 
        ativo, 
        bloqueado_ate 
    INTO 
        v_expiracao, 
        v_ativo, 
        v_bloqueado_ate 
    FROM sessao_usuario 
    WHERE id_sessao_usuario = p_id_sessao_usuario;
    
    -- Se sessão não existe
    IF v_expiracao IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sessão inexistente';
    END IF;
    
    -- Se sessão está inativa
    IF v_ativo = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sessão inativa';
    END IF;
    
    -- Se sessão está bloqueada
    IF v_bloqueado_ate IS NOT NULL AND v_bloqueado_ate > NOW(6) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sessão bloqueada temporariamente';
    END IF;
    
    -- Se sessão expirou
    IF v_expiracao < NOW(6) THEN
        -- Atualiza status para inativo
        UPDATE sessao_usuario SET ativo = 0 WHERE id_sessao_usuario = p_id_sessao_usuario;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sessão expirada';
    END IF;
END ;;
DELIMITER ;

-- ================================================================
-- Procedure sp_sessao_contexto_get CORRIGIDA
-- ================================================================
DROP PROCEDURE IF EXISTS sp_sessao_contexto_get;

DELIMITER ;;
CREATE PROCEDURE sp_sessao_contexto_get(
    IN p_id_sessao_usuario BIGINT
)
BEGIN
    -- Primeiro valida a sessão
    CALL sp_sessao_assert(p_id_sessao_usuario);
    
    -- Retorna contexto completo
    SELECT 
        su.id_sessao_usuario,
        su.id_usuario,
        su.setor_contexto AS id_sistema,
        su.unidade_contexto AS id_unidade,
        su.ip_origem,
        su.agente_usuario,
        su.ativo,
        su.expira_em,
        su.ultimo_heartbeat,
        su.criado_em
    FROM sessao_usuario su
    WHERE su.id_sessao_usuario = p_id_sessao_usuario;
    
    -- Atualiza heartbeat
    UPDATE sessao_usuario 
    SET ultimo_heartbeat = NOW(6) 
    WHERE id_sessao_usuario = p_id_sessao_usuario;
END ;;
DELIMITER ;

-- ================================================================
-- Procedure sp_sessao_fechar
-- ================================================================
DROP PROCEDURE IF EXISTS sp_sessao_fechar;

DELIMITER ;;
CREATE PROCEDURE sp_sessao_fechar(
    IN p_id_sessao_usuario BIGINT
)
BEGIN
    UPDATE sessao_usuario 
    SET ativo = 0, 
        atualizado_em = NOW(6) 
    WHERE id_sessao_usuario = p_id_sessao_usuario;
    
    -- Registrar fechamento no ledger
    -- CALL sp_auditoria_evento_registrar(...);
END ;;
DELIMITER ;

-- ================================================================
-- Procedure sp_sessao_heartbeat
-- ================================================================
DROP PROCEDURE IF EXISTS sp_sessao_heartbeat;

DELIMITER ;;
CREATE PROCEDURE sp_sessao_heartbeat(
    IN p_id_sessao_usuario BIGINT
)
BEGIN
    -- Valida sessão primeiro
    CALL sp_sessao_assert(p_id_sessao_usuario);
    
    -- Atualiza heartbeat
    UPDATE sessao_usuario 
    SET ultimo_heartbeat = NOW(6) 
    WHERE id_sessao_usuario = p_id_sessao_usuario;
    
    SELECT 'OK' AS status, NOW(6) AS heartbeat;
END ;;
DELIMITER ;

SELECT 'Procedures de sessao corrigidas com sucesso!' AS resultado;
