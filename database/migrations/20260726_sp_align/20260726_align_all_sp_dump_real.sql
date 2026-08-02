-- Migration: 20260726_align_all_sp_dump_real
-- Data: 2026-07-26
-- Descricao: Alinha todas as stored procedures divergentes entre o dump canônico e o dump real
-- Escopo: 7 SPs divergentes + 1 SP nova
-- Status: PENDENTE APROVACAO

-- ==========================================
-- 1. sp_master_login
-- ==========================================
DROP PROCEDURE IF EXISTS `sp_master_login`;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_login`(
    IN p_acao VARCHAR(100),
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
proc: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_login VARCHAR(120);
    DECLARE v_hash_senha VARCHAR(255);
    DECLARE v_senha_temp TINYINT;
    DECLARE v_primeiro_acesso TINYINT;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_id_unidade BIGINT UNSIGNED;
    DECLARE v_id_local BIGINT;
    DECLARE v_ativo TINYINT;
    DECLARE v_id_sessao BIGINT;
    DECLARE v_uuid_transacao CHAR(36);
    DECLARE v_token_expiracao DATETIME;
    DECLARE v_refresh_token CHAR(64);
    DECLARE v_ip VARCHAR(45);
    DECLARE v_device VARCHAR(255);
    DECLARE v_contexto JSON;
    DECLARE v_permissoes JSON;
    DECLARE v_nome_perfil VARCHAR(80);
    DECLARE v_nome_unidade VARCHAR(120);
    DECLARE v_nome_local VARCHAR(120);
    DECLARE v_menus JSON;
    DECLARE v_resultado JSON;
    DECLARE v_mensagem TEXT;
    DECLARE v_sucesso BOOLEAN DEFAULT FALSE;

    SET v_ip = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem'));
    SET v_device = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info'));
    SET v_uuid_transacao = UUID();

    IF p_acao = 'LOGIN' THEN
        SET v_login = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.login'));
        SET v_hash_senha = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.senha'));

        IF v_login IS NULL OR v_hash_senha IS NULL THEN
            SET p_mensagem = 'LOGIN_E_SENHA_OBRIGATORIOS';
            SET p_sucesso = FALSE;
            LEAVE proc;
        END IF;

        SELECT id_usuario, senha_hash, senha_temp, primeiro_acesso, ativo
        INTO v_id_usuario, v_hash_senha, v_senha_temp, v_primeiro_acesso, v_ativo
        FROM usuario
        WHERE login = v_login AND ativo = 1
        LIMIT 1;

        IF v_id_usuario IS NULL THEN
            SET p_mensagem = 'USUARIO_NAO_ENCONTRADO';
            SET p_sucesso = FALSE;
            LEAVE proc;
        END IF;

        IF v_ativo = 0 THEN
            SET p_mensagem = 'USUARIO_INATIVO';
            SET p_sucesso = FALSE;
            LEAVE proc;
        END IF;

        IF v_hash_senha != SHA2(v_hash_senha, 256) THEN
            SET p_mensagem = 'SENHA_INCORRETA';
            SET p_sucesso = FALSE;
            LEAVE proc;
        END IF;

        SET v_id_sessao = NULL;
        INSERT INTO sessao_usuario (
            id_usuario, token, refresh_token, expira_em, ip_origem, device_info, ativo, uuid_transacao
        ) VALUES (
            v_id_usuario, UUID(), UUID(), DATE_ADD(NOW(), INTERVAL 8 HOUR),
            v_ip, v_device, 1, v_uuid_transacao
        );
        SET v_id_sessao = LAST_INSERT_ID();

        SELECT id_perfil, id_unidade, id_local
        INTO v_id_perfil, v_id_unidade, v_id_local
        FROM usuario_perfil up
        WHERE up.id_usuario = v_id_usuario AND up.ativo = 1
        LIMIT 1;

        IF v_id_unidade IS NULL THEN
            SELECT id_unidade INTO v_id_unidade FROM unidade LIMIT 1;
        END IF;

        IF v_id_local IS NULL THEN
            SELECT id_local INTO v_id_local FROM local_operacional
            WHERE id_unidade = v_id_unidade LIMIT 1;
        END IF;

        UPDATE sessao_usuario
        SET id_perfil = v_id_perfil,
            id_unidade = v_id_unidade,
            id_local = v_id_local
        WHERE id_sessao_usuario = v_id_sessao;

        SET v_contexto = JSON_OBJECT(
            'id_sessao', v_id_sessao,
            'id_usuario', v_id_usuario,
            'id_perfil', v_id_perfil,
            'id_unidade', v_id_unidade,
            'id_local', v_id_local,
            'login', v_login
        );

        SET v_resultado = JSON_OBJECT(
            'id_sessao', v_id_sessao,
            'token', v_uuid_transacao,
            'contexto', v_contexto,
            'primeiro_acesso', v_primeiro_acesso,
            'senha_temp', v_senha_temp
        );

        SET p_resultado = v_resultado;
        SET p_sucesso = TRUE;
        SET p_mensagem = 'LOGIN_SUCESSO';
    ELSE
        SET p_mensagem = 'ACAO_NAO_SUPORTADA';
        SET p_sucesso = FALSE;
    END IF;
END ;;
DELIMITER ;

-- ==========================================
-- 2. sp_auth_contexto_get
-- ==========================================
DROP PROCEDURE IF EXISTS `sp_auth_contexto_get`;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_contexto_get`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_tenant BIGINT,
    IN p_id_contexto BIGINT,
    IN p_capability_codigo VARCHAR(80)
)
main_flow: BEGIN
    DECLARE v_id_perfil BIGINT;
    DECLARE v_id_unidade BIGINT UNSIGNED;
    DECLARE v_id_local BIGINT;
    DECLARE v_ativo TINYINT;
    DECLARE v_revogado TINYINT;
    DECLARE v_expira_em DATETIME(6);
    DECLARE v_contexto JSON;
    DECLARE v_permissoes JSON;
    DECLARE v_nome_perfil VARCHAR(80);
    DECLARE v_nome_unidade VARCHAR(120);
    DECLARE v_nome_local VARCHAR(120);
    DECLARE v_menus JSON;
    DECLARE v_resultado JSON;

    IF p_id_sessao IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SESSAO_INVALIDA';
    END IF;

    SELECT id_usuario, id_perfil, id_unidade, id_local, ativo
    INTO v_id_perfil, v_id_unidade, v_id_local, v_ativo
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao
    LIMIT 1;

    IF v_id_perfil IS NULL OR v_ativo = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SESSAO_INVALIDA';
    END IF;

    SET v_contexto = JSON_OBJECT(
        'id_sessao', p_id_sessao,
        'id_usuario', v_id_perfil,
        'id_unidade', v_id_unidade,
        'id_local', v_id_local
    );

    SET v_resultado = JSON_OBJECT(
        'contexto', v_contexto,
        'permissoes', v_permissoes,
        'menus', v_menus
    );

    SELECT v_resultado;
END ;;
DELIMITER ;

-- ==========================================
-- 3. sp_auth_contexto_set
-- ==========================================
DROP PROCEDURE IF EXISTS `sp_auth_contexto_set`;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_contexto_set`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_tenant BIGINT,
    IN p_id_contexto BIGINT,
    IN p_capability_codigo VARCHAR(80),
    IN p_id_perfil BIGINT,
    IN p_id_sistema BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local BIGINT
)
main_flow: BEGIN
    DECLARE v_id_perfil_atual BIGINT;
    DECLARE v_id_unidade_atual BIGINT UNSIGNED;
    DECLARE v_id_local_atual BIGINT;
    DECLARE v_ativo TINYINT;

    IF p_id_sessao IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SESSAO_INVALIDA';
    END IF;

    SELECT id_perfil, id_unidade, id_local, ativo
    INTO v_id_perfil_atual, v_id_unidade_atual, v_id_local_atual, v_ativo
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao
    LIMIT 1;

    IF v_id_perfil_atual IS NULL OR v_ativo = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SESSAO_INVALIDA';
    END IF;

    UPDATE sessao_usuario
    SET id_perfil = p_id_perfil,
        id_unidade = p_id_unidade,
        id_local = p_id_local
    WHERE id_sessao_usuario = p_id_sessao;

    SELECT JSON_OBJECT(
        'id_sessao', p_id_sessao,
        'id_perfil', p_id_perfil,
        'id_sistema', p_id_sistema,
        'id_unidade', p_id_unidade,
        'id_local', p_id_local
    ) AS resultado;
END ;;
DELIMITER ;

-- ==========================================
-- 4. sp_master_dispatcher
-- ==========================================
DROP PROCEDURE IF EXISTS `sp_master_dispatcher`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_dispatcher`(
    IN p_id_sessao BIGINT,
    IN p_uuid_transacao CHAR(36),
    IN p_dominio VARCHAR(50),
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
main: BEGIN
    DECLARE v_id_usuario, v_id_unidade, v_id_saas, v_id_local, v_id_perfil BIGINT;
    DECLARE v_ativo TINYINT;
    DECLARE v_nome_sp VARCHAR(120);
    DECLARE v_uuid CHAR(36);
    DECLARE v_hash CHAR(64);
    DECLARE v_id_evento BIGINT DEFAULT 0;
    DECLARE v_estado_atual, v_estado_destino VARCHAR(50);
    DECLARE v_msg TEXT;
    DECLARE v_id_atendimento_vinculo BIGINT;
    DECLARE v_ip VARCHAR(45);
    DECLARE v_device VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT;
        INSERT INTO erro_evento (
            id_sessao_usuario, dominio, acao, mensagem_erro, payload_tentativa, stack_trace, uuid_transacao
        ) VALUES (
            p_id_sessao, p_dominio, p_acao, v_msg, p_payload,
            JSON_OBJECT('executor', v_nome_sp, 'hash', v_hash), v_uuid
        );
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END;

    SET v_uuid = IFNULL(p_uuid_transacao, UUID());
    SET p_payload = IFNULL(p_payload, JSON_OBJECT());
    SET v_hash = SHA2(CONCAT(v_uuid, CAST(p_payload AS CHAR)), 256);

    SELECT id_usuario, id_unidade, id_entidade, id_local, id_perfil, ativo
    INTO v_id_usuario, v_id_unidade, v_id_saas, v_id_local, v_id_perfil, v_ativo
    FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao LIMIT 1;

    IF v_id_usuario IS NULL OR v_ativo = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SESSAO_INVALIDA';
    END IF;

    SET v_ip = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem'));
    SET v_device = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info'));

    IF p_uuid_transacao IS NOT NULL AND EXISTS (
        SELECT 1 FROM atendimento_evento WHERE uuid_transacao = p_uuid_transacao LIMIT 1
    ) THEN
        SELECT JSON_OBJECT('status','SUCCESS','idempotente',1,'uuid', v_uuid) AS result;
        LEAVE main;
    END IF;

    SELECT nome_procedure INTO v_nome_sp FROM permissao
    WHERE codigo = CONCAT(UPPER(p_dominio), '.', UPPER(p_acao)) AND ativo = 1 LIMIT 1;

    IF v_nome_sp IS NULL OR v_nome_sp NOT LIKE 'sp_executor_%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'EXECUTOR_INVALIDO_OU_NAO_MAPEADO';
    END IF;

    IF p_id_referencia > 0 THEN
        SELECT id_atendimento INTO v_id_atendimento_vinculo
        FROM atendimento_vinculo
        WHERE id_ffa = p_id_referencia AND ativo = 1 LIMIT 1;

        SET p_payload = JSON_SET(p_payload,
            '$.id_atendimento', v_id_atendimento_vinculo,
            '$.id_saas_entidade', v_id_saas,
            '$.id_unidade', v_id_unidade
        );
    END IF;

    CALL sp_master_registrar_evento(
        p_id_sessao, p_dominio, p_acao, p_id_referencia, p_payload,
        JSON_OBJECT('id_saas', v_id_saas, 'id_unidade', v_id_unidade, 'ip', v_ip, 'device', v_device),
        v_uuid, v_id_evento
    );

    SET @p_sessao = p_id_sessao;
    SET @p_acao = p_acao;
    SET @p_ref = p_id_referencia;
    SET @p_pay = p_payload;

    SET @sql_call = CONCAT('CALL ', v_nome_sp, '(?, ?, ?, ?)');

    PREPARE stmt FROM @sql_call;
    EXECUTE stmt USING @p_sessao, @p_acao, @p_ref, @p_pay;
    DEALLOCATE PREPARE stmt;

    SELECT JSON_OBJECT(
        'status', 'SUCCESS',
        'uuid', v_uuid,
        'id_evento', v_id_evento,
        'executor', v_nome_sp,
        'timestamp', NOW()
    ) AS result;

END ;;
DELIMITER ;

-- ==========================================
-- 5. sp_master_assistencial_salvar_orquestradora
-- ==========================================
DROP PROCEDURE IF EXISTS `sp_master_assistencial_salvar_orquestradora`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_assistencial_salvar_orquestradora`(
    IN p_id_sessao BIGINT,
    IN p_dominio VARCHAR(50),
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_unidade BIGINT UNSIGNED;
    DECLARE v_id_saas BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_ativo TINYINT;
    DECLARE v_uuid CHAR(36);
    DECLARE v_hash CHAR(64);
    DECLARE v_id_evento BIGINT DEFAULT 0;
    DECLARE v_nome_sp VARCHAR(120);
    DECLARE v_ip VARCHAR(45);
    DECLARE v_device VARCHAR(255);
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT;
        INSERT INTO erro_evento (
            id_sessao_usuario, dominio, acao, mensagem_erro, payload_tentativa, stack_trace, uuid_transacao
        ) VALUES (
            p_id_sessao, p_dominio, p_acao, v_msg, p_payload,
            JSON_OBJECT('executor', v_nome_sp, 'hash', v_hash), v_uuid
        );
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END;

    SET v_uuid = UUID();
    SET p_payload = IFNULL(p_payload, JSON_OBJECT());
    SET v_hash = SHA2(CONCAT(v_uuid, CAST(p_payload AS CHAR)), 256);

    SELECT id_usuario, id_unidade, id_entidade, id_local, id_perfil, ativo
    INTO v_id_usuario, v_id_unidade, v_id_saas, v_id_local, v_id_perfil, v_ativo
    FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao LIMIT 1;

    IF v_id_usuario IS NULL OR v_ativo = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SESSAO_INVALIDA';
    END IF;

    SET v_ip = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem'));
    SET v_device = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info'));

    SELECT nome_procedure INTO v_nome_sp FROM permissao
    WHERE codigo = CONCAT(UPPER(p_dominio), '.', UPPER(p_acao)) AND ativo = 1 LIMIT 1;

    IF v_nome_sp IS NULL OR v_nome_sp NOT LIKE 'sp_executor_%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'EXECUTOR_INVALIDO_OU_NAO_MAPEADO';
    END IF;

    CALL sp_master_registrar_evento(
        p_id_sessao, p_dominio, p_acao, p_id_referencia, p_payload,
        JSON_OBJECT('id_saas', v_id_saas, 'id_unidade', v_id_unidade, 'ip', v_ip, 'device', v_device),
        v_uuid, v_id_evento
    );

    SET @p_sessao = p_id_sessao;
    SET @p_acao = p_acao;
    SET @p_ref = p_id_referencia;
    SET @p_pay = p_payload;

    SET @sql_call = CONCAT('CALL ', v_nome_sp, '(?, ?, ?, ?)');

    PREPARE stmt FROM @sql_call;
    EXECUTE stmt USING @p_sessao, @p_acao, @p_ref, @p_pay;
    DEALLOCATE PREPARE stmt;

    SET p_resultado = JSON_OBJECT(
        'status', 'SUCCESS',
        'uuid', v_uuid,
        'id_evento', v_id_evento,
        'executor', v_nome_sp,
        'timestamp', NOW()
    );
    SET p_sucesso = TRUE;
    SET p_mensagem = 'EXECUCAO_SUCESSO';
END ;;
DELIMITER ;

-- ==========================================
-- 6. sp_orquestrador_assistencial
-- ==========================================
DROP PROCEDURE IF EXISTS `sp_orquestrador_assistencial`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_orquestrador_assistencial`(
    IN p_id_sessao BIGINT,
    IN p_dominio VARCHAR(50),
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_unidade BIGINT UNSIGNED;
    DECLARE v_id_saas BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_ativo TINYINT;
    DECLARE v_fluxo_origem VARCHAR(50);
    DECLARE v_fluxo_destino VARCHAR(50);
    DECLARE v_uuid CHAR(36);
    DECLARE v_hash CHAR(64);
    DECLARE v_id_evento BIGINT DEFAULT 0;
    DECLARE v_nome_sp VARCHAR(120);
    DECLARE v_ip VARCHAR(45);
    DECLARE v_device VARCHAR(255);
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT;
        INSERT INTO erro_evento (
            id_sessao_usuario, dominio, acao, mensagem_erro, payload_tentativa, stack_trace, uuid_transacao
        ) VALUES (
            p_id_sessao, p_dominio, p_acao, v_msg, p_payload,
            JSON_OBJECT('executor', v_nome_sp, 'hash', v_hash), v_uuid
        );
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END;

    SET v_uuid = UUID();
    SET p_payload = IFNULL(p_payload, JSON_OBJECT());
    SET v_hash = SHA2(CONCAT(v_uuid, CAST(p_payload AS CHAR)), 256);

    SELECT id_usuario, id_unidade, id_entidade, id_local, id_perfil, ativo
    INTO v_id_usuario, v_id_unidade, v_id_saas, v_id_local, v_id_perfil, v_ativo
    FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao LIMIT 1;

    IF v_id_usuario IS NULL OR v_ativo = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SESSAO_INVALIDA';
    END IF;

    SET v_fluxo_origem = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.fluxo_origem'));
    IF v_fluxo_origem IS NULL THEN
        SET v_fluxo_origem = 'INICIO';
    END IF;

    SELECT fluxo_destino INTO v_fluxo_destino
    FROM fluxo_transicao_matriz
    WHERE fluxo_origem = v_fluxo_origem
    AND acao_permitida = p_acao
    AND ativo = TRUE
    LIMIT 1;

    IF v_fluxo_destino IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'TRANSICAO_NAO_PERMITIDA';
    END IF;

    SET p_payload = JSON_SET(p_payload, '$.fluxo_destino', v_fluxo_destino);

    SET v_ip = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem'));
    SET v_device = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info'));

    CALL sp_master_registrar_evento(
        p_id_sessao, p_dominio, p_acao, p_id_referencia, p_payload,
        JSON_OBJECT('id_saas', v_id_saas, 'id_unidade', v_id_unidade, 'ip', v_ip, 'device', v_device),
        v_uuid, v_id_evento
    );

    SET p_resultado = JSON_OBJECT(
        'fluxo_destino', v_fluxo_destino,
        'id_evento', v_id_evento
    );
    SET p_sucesso = TRUE;
    SET p_mensagem = 'ORQUESTRACAO_SUCESSO';
END ;;
DELIMITER ;

-- ==========================================
-- 7. sp_executor_assistencial_atendimento_finalizar
-- ==========================================
DROP PROCEDURE IF EXISTS `sp_executor_assistencial_atendimento_finalizar`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_assistencial_atendimento_finalizar`(
    IN p_id_sessao BIGINT,
    IN p_dominio VARCHAR(50),
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_atendimento BIGINT;
    DECLARE v_uuid CHAR(36);
    DECLARE v_hash CHAR(64);
    DECLARE v_id_evento BIGINT DEFAULT 0;
    DECLARE v_nome_sp VARCHAR(120);
    DECLARE v_ip VARCHAR(45);
    DECLARE v_device VARCHAR(255);
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT;
        INSERT INTO erro_evento (
            id_sessao_usuario, dominio, acao, mensagem_erro, payload_tentativa, stack_trace, uuid_transacao
        ) VALUES (
            p_id_sessao, p_dominio, p_acao, v_msg, p_payload,
            JSON_OBJECT('executor', v_nome_sp, 'hash', v_hash), v_uuid
        );
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END;

    SET v_uuid = UUID();
    SET p_payload = IFNULL(p_payload, JSON_OBJECT());
    SET v_hash = SHA2(CONCAT(v_uuid, CAST(p_payload AS CHAR)), 256);

    SELECT id_usuario
    INTO v_id_usuario
    FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao LIMIT 1;

    IF v_id_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SESSAO_INVALIDA';
    END IF;

    SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));

    IF v_id_atendimento IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID_ATENDIMENTO_OBRIGATORIO';
    END IF;

    UPDATE atendimento
    SET status_execucao = 'CONCLUIDO',
        finalizado_em = NOW(),
        atualizado_em = NOW()
    WHERE id_atendimento = v_id_atendimento;

    INSERT INTO atendimento_evolucao (
        id_atendimento, id_entidade, texto_evolucao, criado_em
    ) VALUES (
        v_id_atendimento, 1, JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.evolucao')), NOW()
    );

    SET v_ip = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem'));
    SET v_device = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info'));

    CALL sp_master_registrar_evento(
        p_id_sessao, p_dominio, p_acao, v_id_atendimento, p_payload,
        JSON_OBJECT('id_atendimento', v_id_atendimento, 'ip', v_ip, 'device', v_device),
        v_uuid, v_id_evento
    );

    SET p_resultado = JSON_OBJECT(
        'id_atendimento', v_id_atendimento,
        'status', 'CONCLUIDO',
        'id_evento', v_id_evento
    );
    SET p_sucesso = TRUE;
    SET p_mensagem = 'ATENDIMENTO_FINALIZADO';
END ;;
DELIMITER ;

-- ==========================================
-- 8. sp_auth_permissions_evaluate (NOVA)
-- ==========================================
DROP PROCEDURE IF EXISTS `sp_auth_permissions_evaluate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_permissions_evaluate`(
    IN  p_id_sessao          BIGINT,
    IN  p_id_usuario         BIGINT,
    IN  p_id_tenant          BIGINT,
    IN  p_id_contexto        BIGINT,
    IN  p_capability_codigo  VARCHAR(80),
    OUT p_allowed            BOOLEAN,
    OUT p_capability         VARCHAR(80),
    OUT p_context            JSON,
    OUT p_reason             TEXT,
    OUT p_audit_ref          VARCHAR(64)
)
main_flow: BEGIN
    DECLARE v_id_perfil      BIGINT;
    DECLARE v_id_unidade     BIGINT UNSIGNED;
    DECLARE v_id_local       BIGINT;
    DECLARE v_ativo          TINYINT;
    DECLARE v_revogado       TINYINT;
    DECLARE v_expira_em      DATETIME(6);
    DECLARE v_contexto       JSON;
    DECLARE v_permissoes     JSON;
    DECLARE v_nome_perfil    VARCHAR(80);
    DECLARE v_nome_unidade   VARCHAR(120);
    DECLARE v_nome_local     VARCHAR(120);
    DECLARE v_menus          JSON;
    DECLARE v_resultado      JSON;
    DECLARE v_allowed        BOOLEAN DEFAULT FALSE;
    DECLARE v_reason         TEXT DEFAULT 'PERMISSAO_NAO_AVALIADA';
    DECLARE v_audit_ref      VARCHAR(64);

    IF p_id_sessao IS NULL THEN
        SET p_allowed = FALSE;
        SET p_reason = 'SESSAO_INVALIDA';
        LEAVE main_flow;
    END IF;

    SELECT id_perfil, id_unidade, id_local, ativo
    INTO v_id_perfil, v_id_unidade, v_id_local, v_ativo
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao
    LIMIT 1;

    IF v_id_perfil IS NULL OR v_ativo = 0 THEN
        SET p_allowed = FALSE;
        SET p_reason = 'SESSAO_INVALIDA';
        LEAVE main_flow;
    END IF;

    SET v_contexto = JSON_OBJECT(
        'id_sessao', p_id_sessao,
        'id_usuario', p_id_usuario,
        'id_perfil', v_id_perfil,
        'id_unidade', v_id_unidade,
        'id_local', v_id_local,
        'id_tenant', p_id_tenant,
        'id_contexto', p_id_contexto
    );

    SET p_allowed = v_allowed;
    SET p_capability = p_capability_codigo;
    SET p_context = v_contexto;
    SET p_reason = v_reason;
    SET p_audit_ref = v_audit_ref;
END ;;
DELIMITER ;
