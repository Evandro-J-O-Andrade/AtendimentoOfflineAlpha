-- ============================================================
-- PATCH DEFINITIVO para sp_master_login
-- Execute este arquivo no seu banco de dados MySQL
-- ============================================================

DROP PROCEDURE IF EXISTS sp_master_login;

DELIMITER $$

CREATE PROCEDURE sp_master_login(
    IN p_acao VARCHAR(50),
    IN p_payload TEXT,
    OUT p_resultado TEXT,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
proc: BEGIN  -- Rótulo 'proc' para LEAVE

    -- VARIÁVEIS
    DECLARE v_login VARCHAR(120);
    DECLARE v_senha VARCHAR(255);
    DECLARE v_ip VARCHAR(45);
    DECLARE v_device VARCHAR(100);
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_hash VARCHAR(255);
    DECLARE v_ativo TINYINT;
    DECLARE v_id_sessao BIGINT;
    DECLARE v_tentativas INT DEFAULT 0;
    DECLARE v_uuid_sessao VARCHAR(36);
    DECLARE v_token_jwt VARCHAR(512);

    -- DEFAULTS
    SET p_sucesso = FALSE;
    SET p_mensagem = '';
    SET p_resultado = JSON_OBJECT();

    -- ====================
    -- LOGIN
    -- ====================
    IF p_acao = 'LOGIN' THEN

        -- Extrai payload JSON
        SET v_login  = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.login'));
        SET v_senha  = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.senha'));
        SET v_ip     = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip'));
        SET v_device = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device'));
        SET v_id_unidade = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade'));
        SET v_id_local   = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_local'));
        SET v_id_perfil  = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_perfil'));

        IF v_login IS NULL OR v_senha IS NULL THEN
            SET p_mensagem = 'CREDENCIAIS_OBRIGATORIAS';
            LEAVE proc;
        END IF;

        -- Busca usuário
        SELECT u.id_usuario, u.senha_hash, u.ativo
        INTO v_id_usuario, v_hash, v_ativo
        FROM usuario u
        WHERE u.login = v_login
        LIMIT 1;

        IF v_id_usuario IS NULL THEN
            SET p_mensagem = 'USUARIO_NAO_ENCONTRADO';
            LEAVE proc;
        END IF;

        IF v_ativo <> 1 THEN
            SET p_mensagem = 'USUARIO_INATIVO';
            LEAVE proc;
        END IF;

        -- Bloqueio temporário
        SELECT COUNT(*) INTO v_tentativas
        FROM login_tentativa
        WHERE id_usuario = v_id_usuario
          AND sucesso = 0
          AND criado_em >= NOW() - INTERVAL 15 MINUTE;

        IF v_tentativas >= 5 THEN
            SET p_mensagem = 'USUARIO_BLOQUEADO_TEMP';
            LEAVE proc;
        END IF;

        -- Valida senha
        IF NOT (v_hash = v_senha) THEN
            INSERT INTO login_tentativa (
                id_usuario, login, ip_origem, dispositivo_origem, sucesso, metadata, criado_em
            ) VALUES (
                v_id_usuario, v_login, v_ip, v_device, 0,
                JSON_OBJECT('motivo','senha_invalida','unidade',v_id_unidade,'local',v_id_local,'perfil',v_id_perfil),
                NOW(6)
            );

            INSERT INTO auditoria_evento (
                id_usuario, entidade, id_entidade, acao, detalhe, criado_em
            ) VALUES (
                v_id_usuario, 'auth', NULL, 'LOGIN_FAIL',
                JSON_OBJECT('login',v_login,'ip',v_ip,'device',v_device,'unidade',v_id_unidade,'local',v_id_local,'perfil',v_id_perfil),
                NOW(6)
            );

            SET p_mensagem = 'SENHA_INVALIDA';
            LEAVE proc;
        END IF;

        -- Login OK
        INSERT INTO login_tentativa (
            id_usuario, login, ip_origem, dispositivo_origem, sucesso, metadata, criado_em
        ) VALUES (
            v_id_usuario, v_login, v_ip, v_device, 1,
            JSON_OBJECT('status','sucesso','unidade',v_id_unidade,'local',v_id_local,'perfil',v_id_perfil),
            NOW(6)
        );

        INSERT INTO auditoria_evento (
            id_usuario, entidade, id_entidade, acao, detalhe, criado_em
        ) VALUES (
            v_id_usuario, 'auth', NULL, 'LOGIN_SUCCESS',
            JSON_OBJECT('login',v_login,'ip',v_ip,'device',v_device,'unidade',v_id_unidade,'local',v_id_local,'perfil',v_id_perfil),
            NOW(6)
        );

        -- Gera UUID e token
        SET v_uuid_sessao = UUID();
        SET v_token_jwt = TO_BASE64(v_uuid_sessao);

        -- Cria sessão
        INSERT INTO sessao_usuario (
            uuid_sessao, id_usuario, id_perfil, id_sistema,
            id_unidade, id_local, ip_origem, user_agent,
            token_jwt, iniciado_em, expira_em, criado_em
        ) VALUES (
            v_uuid_sessao, v_id_usuario, v_id_perfil, 1,
            v_id_unidade, v_id_local, v_ip, v_device,
            v_token_jwt, NOW(6), DATE_ADD(NOW(6), INTERVAL 24 HOUR), NOW(6)
        );

        SET v_id_sessao = LAST_INSERT_ID();

        SET p_resultado = JSON_OBJECT(
            'sessao', JSON_OBJECT('id_sessao_usuario',v_id_sessao,'uuid_sessao',v_uuid_sessao,'id_usuario',v_id_usuario,'token',v_token_jwt),
            'usuario', JSON_OBJECT('id_usuario',v_id_usuario,'login',v_login,'unidade',v_id_unidade,'local',v_id_local,'perfil',v_id_perfil)
        );

        SET p_sucesso = TRUE;
        SET p_mensagem = 'LOGIN_OK';

    -- ====================
    -- LOGOUT
    -- ====================
    ELSEIF p_acao = 'LOGOUT' THEN

        SET v_id_sessao = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_sessao_usuario'));

        IF v_id_sessao IS NULL THEN
            SET p_mensagem = 'SESSAO_OBRIGATORIA';
            LEAVE proc;
        END IF;

        UPDATE sessao_usuario
        SET finalizado_em = NOW(6), motivo_finalizacao = 'LOGOUT', ativo = 0, revogado = 1
        WHERE id_sessao_usuario = v_id_sessao;

        INSERT INTO auditoria_evento (
            id_usuario, entidade, id_entidade, acao, detalhe, criado_em
        ) VALUES (
            NULL, 'auth', NULL, 'LOGOUT',
            JSON_OBJECT('id_sessao_usuario',v_id_sessao),
            NOW(6)
        );

        SET p_sucesso = TRUE;
        SET p_mensagem = 'LOGOUT_OK';
        SET p_resultado = JSON_OBJECT('id_sessao_usuario',v_id_sessao);

    ELSE
        SET p_mensagem = 'ACAO_INVALIDA';
    END IF;

END$$

DELIMITER ;