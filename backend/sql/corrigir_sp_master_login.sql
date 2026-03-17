-- ============================================================
-- Script para corrigir sp_master_login no banco de dados
-- Problemas identificados:
-- 1. Usa 'u.senha' mas tabela tem 'senha_hash'
-- 2. Usa 'evento' e 'payload' mas tabela 'auditoria_evento' tem 'acao' e 'detalhe'
-- ============================================================

-- Primeiro, tenta deletar a SP se existir
DROP PROCEDURE IF EXISTS sp_master_login$$

-- Cria a SP corrigida
CREATE PROCEDURE sp_master_login(
    IN p_acao VARCHAR(50),          -- 'LOGIN' ou 'LOGOUT'
    IN p_payload JSON,              -- JSON do frontend
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
proc: BEGIN
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

    SET p_sucesso = FALSE;
    SET p_mensagem = '';
    SET p_resultado = JSON_OBJECT();

    IF p_acao = 'LOGIN' THEN

        -- Extrai payload
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

        -- Busca usuário (CORRIGIDO: usa senha_hash)
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

        -- Bloqueio temporário (verifica se tabela existe)
        SELECT COUNT(*) INTO v_tentativas
        FROM login_tentativa
        WHERE id_usuario = v_id_usuario
          AND sucesso = 0
          AND criado_em >= NOW() - INTERVAL 15 MINUTE;

        IF v_tentativas >= 5 THEN
            SET p_mensagem = 'USUARIO_BLOQUEADO_TEMP';
            LEAVE proc;
        END IF;

        -- Valida senha (COMPARA DIRETO - sem bcrypt)
        IF NOT (v_hash = v_senha) THEN
            -- Insere tentativa falhada
            INSERT INTO login_tentativa (
                id_usuario, login, ip_origem, dispositivo_origem, sucesso, metadata, criado_em
            ) VALUES (
                v_id_usuario, v_login, v_ip, v_device, 0,
                JSON_OBJECT('motivo','senha_invalida','unidade',v_id_unidade,'local',v_id_local,'perfil',v_id_perfil),
                NOW(6)
            );

            -- Auditoria (CORRIGIDO: usa 'acao' e 'detalhe')
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

        -- Login OK - insere tentativa bem sucedida
        INSERT INTO login_tentativa (
            id_usuario, login, ip_origem, dispositivo_origem, sucesso, metadata, criado_em
        ) VALUES (
            v_id_usuario, v_login, v_ip, v_device, 1,
            JSON_OBJECT('status','sucesso','unidade',v_id_unidade,'local',v_id_local,'perfil',v_id_perfil),
            NOW(6)
        );

        -- Auditoria (CORRIGIDO: usa 'acao' e 'detalhe')
        INSERT INTO auditoria_evento (
            id_usuario, entidade, id_entidade, acao, detalhe, criado_em
        ) VALUES (
            v_id_usuario, 'auth', NULL, 'LOGIN_SUCCESS',
            JSON_OBJECT('login',v_login,'ip',v_ip,'device',v_device,'unidade',v_id_unidade,'local',v_id_local,'perfil',v_id_perfil),
            NOW(6)
        );

        -- Cria sessão
        INSERT INTO sessao_usuario (
            id_usuario, id_unidade, id_local, id_perfil, ip_origem, dispositivo_origem, criado_em
        ) VALUES (
            v_id_usuario, v_id_unidade, v_id_local, v_id_perfil, v_ip, v_device, NOW(6)
        );

        SET v_id_sessao = LAST_INSERT_ID();

        SET p_resultado = JSON_OBJECT(
            'sessao', JSON_OBJECT('id_sessao_usuario',v_id_sessao,'id_usuario',v_id_usuario),
            'usuario', JSON_OBJECT('id_usuario',v_id_usuario,'login',v_login,'unidade',v_id_unidade,'local',v_id_local,'perfil',v_id_perfil)
        );

        SET p_sucesso = TRUE;
        SET p_mensagem = 'LOGIN_OK';

    ELSEIF p_acao = 'LOGOUT' THEN

        SET v_id_sessao = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_sessao_usuario'));
        SET v_id_usuario = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_usuario'));

        IF v_id_sessao IS NULL THEN
            SET p_mensagem = 'SESSAO_OBRIGATORIA';
            LEAVE proc;
        END IF;

        DELETE FROM sessao_usuario WHERE id_sessao_usuario = v_id_sessao;

        -- Auditoria logout
        INSERT INTO auditoria_evento (
            id_usuario, entidade, id_entidade, acao, detalhe, criado_em
        ) VALUES (
            v_id_usuario, 'auth', NULL, 'LOGOUT',
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
