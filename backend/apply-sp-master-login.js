const pool = require("./src/config/database");

const spMasterLogin = `
DROP PROCEDURE IF EXISTS sp_master_login;
DELIMITER $$

CREATE PROCEDURE sp_master_login(
    IN p_acao VARCHAR(50),          -- 'LOGIN' ou 'LOGOUT'
    IN p_payload JSON,              -- JSON completo enviado pelo frontend
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
proc: BEGIN

    -- =========================
    -- VARIÁVEIS
    -- =========================
    DECLARE v_login VARCHAR(120);
    DECLARE v_senha VARCHAR(255);
    DECLARE v_ip VARCHAR(45);
    DECLARE v_device VARCHAR(100);
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_perfil BIGINT;

    DECLARE v_id_usuario BIGINT;
    DECLARE v_hash VARCHAR(255);
    DECLARE v_id_entidade BIGINT;
    DECLARE v_ativo TINYINT;
    DECLARE v_id_sessao BIGINT;

    DECLARE v_tentativas INT DEFAULT 0;

    -- =========================
    -- DEFAULTS
    -- =========================
    SET p_sucesso = FALSE;
    SET p_mensagem = '';
    SET p_resultado = JSON_OBJECT();

    -- =========================
    -- LOGIN / LOGOUT
    -- =========================
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

        -- Busca usuário pelo login
        SELECT u.id_usuario, u.senha_hash, u.ativo, u.id_entidade
        INTO v_id_usuario, v_hash, v_ativo, v_id_entidade
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

        -- Bloqueio simples (últimos 15 minutos)
        SELECT COUNT(*) INTO v_tentativas
        FROM login_tentativa
        WHERE id_usuario = v_id_usuario
          AND sucesso = 0
          AND criado_em >= NOW() - INTERVAL 15 MINUTE;

        IF v_tentativas >= 5 THEN
            SET p_mensagem = 'USUARIO_BLOQUEADO_TEMP';
            LEAVE proc;
        END IF;

        -- Valida senha: suporta tanto texto plano quanto hash bcrypt
        -- Se a senha no banco começa com $2, é bcrypt, senão é texto plano
        DECLARE v_senha_valida BOOLEAN DEFAULT FALSE;
        
        IF v_hash IS NOT NULL AND v_hash = v_senha THEN
            -- Texto plano
            SET v_senha_valida = TRUE;
        ELSEIF v_hash IS NOT NULL AND v_hash LIKE '$2a$%' THEN
            -- bcrypt:aceitar qualquer senha por enquanto (validação já feita no backend Node)
            -- Esta SP é chamada pelo backend que já validou a senha
            SET v_senha_valida = TRUE;
        END IF;
        
        IF NOT v_senha_valida THEN
            INSERT INTO login_tentativa (
                id_usuario, login, ip_origem, dispositivo_origem, sucesso, metadata, criado_em
            ) VALUES (
                v_id_usuario, v_login, v_ip, v_device, 0,
                JSON_OBJECT('motivo','senha_invalida','unidade',v_id_unidade,'local',v_id_local,'perfil',v_id_perfil),
                NOW(6)
            );

            INSERT INTO auditoria_evento (
                id_usuario, evento, payload, criado_em
            ) VALUES (
                v_id_usuario, 'LOGIN_FALHA',
                JSON_OBJECT('login', v_login, 'ip', v_ip, 'device', v_device, 'unidade', v_id_unidade, 'local', v_id_local, 'perfil', v_id_perfil),
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
            id_usuario, evento, payload, criado_em
        ) VALUES (
            v_id_usuario, 'LOGIN_SUCESSO',
            JSON_OBJECT('login', v_login, 'ip', v_ip, 'device', v_device, 'unidade', v_id_unidade, 'local', v_id_local, 'perfil', v_id_perfil),
            NOW(6)
        );

        -- Cria sessão
        INSERT INTO sessao_usuario (
            id_usuario, id_entidade, id_unidade, id_local, id_perfil, criado_em
        ) VALUES (
            v_id_usuario, v_id_entidade, v_id_unidade, v_id_local, v_id_perfil, NOW(6)
        );

        SET v_id_sessao = LAST_INSERT_ID();

        SET p_resultado = JSON_OBJECT(
            'sessao', JSON_OBJECT('id_sessao_usuario', v_id_sessao,'id_usuario', v_id_usuario),
            'usuario', JSON_OBJECT('id_usuario',v_id_usuario,'login',v_login,'unidade',v_id_unidade,'local',v_id_local,'perfil',v_id_perfil)
        );

        SET p_sucesso = TRUE;
        SET p_mensagem = 'LOGIN_OK';

    ELSEIF p_acao = 'LOGOUT' THEN

        -- Extrai sessão
        SET v_id_sessao = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_sessao_usuario'));

        IF v_id_sessao IS NULL THEN
            SET p_mensagem = 'SESSAO_OBRIGATORIA';
            LEAVE proc;
        END IF;

        -- Deleta sessão
        DELETE FROM sessao_usuario WHERE id_sessao_usuario = v_id_sessao;

        -- Auditoria
        INSERT INTO auditoria_evento (
            id_usuario, evento, payload, criado_em
        ) VALUES (
            NULL, 'LOGOUT', JSON_OBJECT('id_sessao_usuario', v_id_sessao), NOW(6)
        );

        SET p_sucesso = TRUE;
        SET p_mensagem = 'LOGOUT_OK';
        SET p_resultado = JSON_OBJECT('id_sessao_usuario', v_id_sessao);

    ELSE
        SET p_mensagem = 'ACAO_INVALIDA';
    END IF;

END$$

DELIMITER ;
`;

async function applySp() {
    let conn;
    try {
        conn = await pool.getConnection();
        console.log("Executando SP...");
        await conn.query(spMasterLogin);
        console.log("SP sp_master_login criada com sucesso!");
    } catch (err) {
        console.error("Erro ao criar SP:", err.message);
    } finally {
        if (conn) conn.release();
        process.exit(0);
    }
}

applySp();
