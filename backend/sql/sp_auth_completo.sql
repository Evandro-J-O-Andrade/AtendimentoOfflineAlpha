-- ================================================================
-- Stored Procedures de Autenticação e Contexto
-- Baseado na arquitetura do dump
-- ================================================================

DELIMITER ;;

-- ================================================================
-- SP: Validar usuário e senha
-- ================================================================
DROP PROCEDURE IF EXISTS sp_auth_validar;;
CREATE PROCEDURE sp_auth_validar(
    IN p_login VARCHAR(60),
    IN p_senha VARCHAR(200)
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_senha_hash VARCHAR(255);
    DECLARE v_ativo TINYINT;

    SELECT id_usuario, senha_hash, ativo
    INTO v_id_usuario, v_senha_hash, v_ativo
    FROM usuario
    WHERE login = p_login
    LIMIT 1;

    IF v_id_usuario IS NULL THEN
        SELECT NULL as id_usuario, 'USUARIO_NAO_ENCONTRADO' as erro;
    ELSEIF v_ativo = 0 THEN
        SELECT v_id_usuario as id_usuario, 'USUARIO_INATIVO' as erro;
    ELSEIF v_senha_hash IS NULL OR v_senha_hash = '' THEN
        SELECT v_id_usuario as id_usuario, 'SENHA_NAO_CADASTRADA' as erro;
    ELSE
        -- Valida senha com bcrypt
        IF bcrypt_verify(p_senha, v_senha_hash) = 1 THEN
            SELECT v_id_usuario as id_usuario, NULL as erro;
        ELSE
            SELECT v_id_usuario as id_usuario, 'SENHA_INCORRETA' as erro;
        END IF;
    END IF;
END ;;

-- ================================================================
-- SP: Criar sessão de usuário
-- ================================================================
DROP PROCEDURE IF EXISTS sp_sessao_criar;;
CREATE PROCEDURE sp_sessao_criar(
    IN p_id_usuario BIGINT,
    IN p_ip_origem VARCHAR(45),
    IN p_agente_usuario TEXT,
    OUT p_id_sessao BIGINT
)
BEGIN
    -- Valida se usuário existe e está ativo
    IF NOT EXISTS (SELECT 1 FROM usuario u WHERE u.id_usuario = p_id_usuario AND u.ativo = 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário inexistente ou inativo';
    END IF;

    -- Inserir sessão
    INSERT INTO sessao_usuario (
        id_usuario,
        token_runtime,
        ip_origem,
        agente_usuario,
        ativo,
        expira_em,
        ultimo_heartbeat,
        criado_em
    ) VALUES (
        p_id_usuario,
        MD5(CONCAT(RAND(), NOW())),
        p_ip_origem,
        p_agente_usuario,
        1,
        DATE_ADD(NOW(), INTERVAL 8 HOUR),
        NOW(),
        NOW()
    );

    SET p_id_sessao = LAST_INSERT_ID();
END ;;

-- ================================================================
-- SP: Ativar contexto da sessão
-- ================================================================
DROP PROCEDURE IF EXISTS sp_sessao_ativar_contexto;;
CREATE PROCEDURE sp_sessao_ativar_contexto(
    IN p_id_sessao BIGINT,
    IN p_id_sistema BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local_operacional BIGINT,
    IN p_id_perfil BIGINT
)
BEGIN
    -- Valida se sessão existe
    IF NOT EXISTS (SELECT 1 FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao AND ativo = 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sessão inexistente ou inativa';
    END IF;

    -- Valida sistema
    IF p_id_sistema IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sistema WHERE id_sistema = p_id_sistema) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sistema inexistente';
    END IF;

    -- Valida unidade
    IF p_id_unidade IS NOT NULL AND NOT EXISTS (SELECT 1 FROM unidade WHERE id_unidade = p_id_unidade) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unidade inexistente';
    END IF;

    -- Valida local operacional
    IF p_id_local_operacional IS NOT NULL AND NOT EXISTS (SELECT 1 FROM local_operacional WHERE id_local_operacional = p_id_local_operacional) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Local operacional inexistente';
    END IF;

    -- Atualiza contexto da sessão
    UPDATE sessao_usuario
    SET id_sistema = COALESCE(p_id_sistema, id_sistema),
        id_unidade = COALESCE(p_id_unidade, id_unidade),
        id_local_operacional = COALESCE(p_id_local_operacional, id_local_operacional),
        id_perfil = COALESCE(p_id_perfil, id_perfil),
        ultimo_heartbeat = NOW()
    WHERE id_sessao_usuario = p_id_sessao;

    -- Registra evento de ativação de contexto
    INSERT INTO sessao_usuario_evento (
        id_sessao_usuario,
        tipo_evento,
        detalhes,
        criado_em
    ) VALUES (
        p_id_sessao,
        'CONTEXTO_ATIVADO',
        JSON_OBJECT('id_sistema', p_id_sistema, 'id_unidade', p_id_unidade, 'id_local', p_id_local_operacional),
        NOW()
    );
END ;;

-- ================================================================
-- SP: Validar sessão (usada no runtime guard)
-- ================================================================
DROP PROCEDURE IF EXISTS sp_sessao_assert;;
CREATE PROCEDURE sp_sessao_assert(
    IN p_id_sessao BIGINT
)
BEGIN
    DECLARE v_ativo TINYINT;
    DECLARE v_expira_em DATETIME;

    SELECT ativo, expira_em
    INTO v_ativo, v_expira_em
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao;

    IF v_ativo IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sessão inexistente';
    END IF;

    IF v_ativo = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sessão inativa';
    END IF;

    IF v_expira_em < NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sessão expirada';
    END IF;
END ;;

-- ================================================================
-- SP: Buscar contexto do usuário
-- ================================================================
DROP PROCEDURE IF EXISTS sp_usuario_contexto_listar;;
CREATE PROCEDURE sp_usuario_contexto_listar(
    IN p_id_usuario BIGINT
)
BEGIN
    -- Sistemas
    SELECT DISTINCT s.id_sistema, s.nome as nome
    FROM usuario_sistema us
    JOIN sistema s ON s.id_sistema = us.id_sistema
    WHERE us.id_usuario = p_id_usuario AND us.ativo = 1;

    -- Unidades
    SELECT DISTINCT u.id_unidade, u.nome
    FROM usuario_unidade uu
    JOIN unidade u ON u.id_unidade = uu.id_unidade
    WHERE uu.id_usuario = p_id_usuario AND uu.ativo = 1;

    -- Locais
    SELECT DISTINCT l.id_local_operacional, l.nome, l.tipo
    FROM usuario_local_operacional ulo
    JOIN local_operacional l ON l.id_local_operacional = ulo.id_local_operacional
    WHERE ulo.id_usuario = p_id_usuario AND l.ativo = 1;

    -- Perfis
    SELECT DISTINCT p.id_perfil, p.nome as nome
    FROM usuario_perfil up
    JOIN perfil p ON p.id_perfil = up.id_perfil
    WHERE up.id_usuario = p_id_usuario AND p.ativo = 1;
END ;;

-- ================================================================
-- SP: Criar contexto para usuário
-- ================================================================
DROP PROCEDURE IF EXISTS sp_usuario_contexto_criar;;
CREATE PROCEDURE sp_usuario_contexto_criar(
    IN p_id_usuario BIGINT,
    IN p_id_sistema BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local_operacional BIGINT,
    IN p_id_perfil BIGINT
)
BEGIN
    INSERT INTO usuario_contexto (
        id_usuario,
        id_sistema,
        id_unidade,
        id_local_operacional,
        id_perfil,
        ativo,
        criado_em
    ) VALUES (
        p_id_usuario,
        COALESCE(p_id_sistema, 1),
        COALESCE(p_id_unidade, 1),
        COALESCE(p_id_local_operacional, 1),
        COALESCE(p_id_perfil, 1),
        1,
        NOW()
    )
    ON DUPLICATE KEY UPDATE
        id_sistema = VALUES(id_sistema),
        id_unidade = VALUES(id_unidade),
        id_local_operacional = VALUES(id_local_operacional),
        id_perfil = VALUES(id_perfil),
        ativo = 1;
END ;;

DELIMITER ;
