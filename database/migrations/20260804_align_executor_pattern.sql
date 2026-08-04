-- Migration: align_executor_pattern
-- Data: 2026-08-04
-- Descrição: Renomeia SPs para padrão sp_executor_* e alimenta permissao.nome_procedure
-- Base: MD-GOV-001, ADR-007

-- 1. Criar sp_executor_totem_gerar_senha (renomeado de sp_totem_gerar_senha)
DROP PROCEDURE IF EXISTS sp_executor_totem_gerar_senha ;;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_totem_gerar_senha`(
    IN p_id_sessao BIGINT,
    IN p_uuid_transacao CHAR(36),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
proc_block: BEGIN

    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_uuid_transacao CHAR(36);
    DECLARE v_numero_senha VARCHAR(20);
    DECLARE v_codigo_visual VARCHAR(10);
    DECLARE v_prefixo VARCHAR(5);
    DECLARE v_id_status BIGINT DEFAULT 1;
    DECLARE v_id_prioridade BIGINT DEFAULT 1;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_entidade BIGINT;
    DECLARE v_id_totem BIGINT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_painel BIGINT;
    DECLARE v_tipo_atendimento VARCHAR(30);
    DECLARE v_resultado JSON;
    DECLARE v_id_senha BIGINT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET v_resultado = JSON_OBJECT('error', v_error_msg);
        INSERT INTO erro_evento (
            id_sessao_usuario, dominio, acao, mensagem_erro, payload_tentativa, stack_trace, uuid_transacao
        ) VALUES (
            p_id_sessao, 'TOTEM', 'GERAR_SENHA', v_error_msg, p_payload, 
            JSON_OBJECT('executor', 'sp_executor_totem_gerar_senha'), p_uuid_transacao
        );
        RESIGNAL;
    END;

    SET v_uuid_transacao = IFNULL(p_uuid_transacao, UUID());
    
    SELECT id_usuario, id_unidade, id_entidade, id_local
      INTO v_id_usuario, v_id_unidade, v_id_entidade, v_id_painel
      FROM sessao_usuario
     WHERE id_sessao_usuario = p_id_sessao
       AND ativo = 1
     LIMIT 1;

    IF v_id_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SESSAO_INVALIDA';
    END IF;

    SET v_id_paciente = JSON_EXTRACT(p_payload, '$.id_paciente');
    SET v_tipo_atendimento = COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo_atendimento')), 'CLINICO');
    SET v_id_painel = COALESCE(JSON_EXTRACT(p_payload, '$.id_painel'), 9);

    SELECT tso.prefixo, tso.codigo
      INTO v_prefixo, v_codigo_visual
      FROM totem_senha_opcao tso
     WHERE tso.id_painel = v_id_painel
       AND tso.tipo_atendimento = v_tipo_atendimento
       AND tso.ativo = 1
     LIMIT 1;

    IF v_prefixo IS NULL OR v_codigo_visual IS NULL THEN
        SET v_resultado = JSON_OBJECT('error', CONCAT('Opcao nao encontrada: ', COALESCE(v_tipo_atendimento, '')));
        SELECT JSON_OBJECT('status', 'ERROR', 'mensagem', CONCAT('Opcao nao encontrada: ', COALESCE(v_tipo_atendimento, '')), 'uuid', v_uuid_transacao) AS result;
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    SELECT ss.id_senha_status
      INTO v_id_status
      FROM senha_status ss
     WHERE ss.codigo = 'EMITIDA'
       AND ss.ativo = 1
     LIMIT 1;

    IF v_id_status IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Status EMITIDA nao encontrado';
    END IF;

    SET v_numero_senha = CONCAT(
        v_prefixo,
        LPAD(
            IFNULL(
                (SELECT IFNULL(MAX(ultimo_numero), 0) + 1
                 FROM senha_sequencia
                 WHERE id_unidade = v_id_unidade
                   AND prefixo = v_prefixo
                   AND DATE(data_ref) = CURDATE()), 1), 3, '0'
            )
    );

    INSERT INTO senha (
        id_unidade,
        codigo_visual,
        id_paciente,
        origem_entrada,
        id_prioridade,
        id_fluxo_status,
        id_sessao_usuario,
        criado_em,
        uuid_sync,
        id_entidade
    ) VALUES (
        v_id_unidade,
        v_numero_senha,
        IFNULL(v_id_paciente, 0),
        'OUTRO',
        v_id_prioridade,
        v_id_status,
        p_id_sessao,
        NOW(6),
        UUID(),
        v_id_entidade
    );

    SET v_id_senha = LAST_INSERT_ID();

    UPDATE senha_sequencia
       SET ultimo_numero = ultimo_numero + 1,
           data_ref = CURDATE()
     WHERE id_unidade = v_id_unidade
       AND prefixo = v_prefixo
       AND DATE(data_ref) = CURDATE();

    IF ROW_COUNT() = 0 THEN
        INSERT INTO senha_sequencia (
            id_sistema,
            id_unidade,
            data_ref,
            prefixo,
            ultimo_numero,
            id_entidade
        ) VALUES (
            1,
            v_id_unidade,
            CURDATE(),
            v_prefixo,
            1,
            v_id_entidade
        );
    END IF;

    SELECT t.id_totem INTO v_id_totem
    FROM totem t
    WHERE t.id_unidade = v_id_unidade
      AND t.ativo = 1
    LIMIT 1;

    IF v_id_totem IS NULL THEN
        SET v_id_totem = 0;
    END IF;

    INSERT INTO totem_evento (
        id_totem,
        evento,
        detalhe,
        ip_acesso,
        criado_em,
        id_entidade
    ) VALUES (
        v_id_totem,
        'SENHA_GERADA',
        JSON_OBJECT('id_senha', v_id_senha, 'tipo_atendimento', v_tipo_atendimento),
        NULL,
        NOW(),
        v_id_entidade
    );

    COMMIT;

    SET @executor_result = JSON_OBJECT(
        'status', 'SUCCESS',
        'uuid', v_uuid_transacao,
        'id_senha', v_id_senha,
        'numero_senha', v_numero_senha,
        'tipo_atendimento', v_tipo_atendimento,
        'prefixo', v_prefixo,
        'uuid_transacao', v_uuid_transacao
    );

    SELECT JSON_EXTRACT(@executor_result, '$') AS result;

END ;;
DELIMITER ;

-- 2. Preencher permissao.nome_procedure para capability pattern (DOMINIO.ACAO)
UPDATE permissao 
SET nome_procedure = 'sp_executor_totem_gerar_senha'
WHERE codigo = 'TOTEM.GERAR_SENHA' AND ativo = 1;

UPDATE permissao 
SET nome_procedure = 'sp_executor_totem_opcoes_get'
WHERE codigo = 'TOTEM.OPCOES_GET' AND ativo = 1;

UPDATE permissao 
SET nome_procedure = 'sp_executor_totem_plantao_medico_get'
WHERE codigo = 'TOTEM.PLANTAO_MEDICO_GET' AND ativo = 1;

-- 4. Atualizar sp_master_dispatcher para propagar resultado do executor
DROP PROCEDURE IF EXISTS sp_master_dispatcher ;;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_dispatcher`(
    IN p_id_sessao BIGINT,
    IN p_uuid_transacao CHAR(36),
    IN p_dominio VARCHAR(50),
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
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
    DECLARE v_resultado_executor JSON DEFAULT NULL;

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
        JSON_OBJECT('id_saas', v_id_saas, 'id_unidade', v_id_unidade, 'id_local', v_id_local, 'id_perfil', v_id_perfil, 'ip', v_ip, 'device', v_device),
        v_uuid, v_id_evento
    );

    SET @p_sessao = p_id_sessao;
    SET @p_acao = p_acao;
    SET @p_ref = p_id_referencia;
    SET @p_pay = p_payload;
    SET @p_uuid_exec = v_uuid;

    SET @sql_call = CONCAT('CALL ', v_nome_sp, '(@p_sessao, @p_uuid_exec, @p_ref, @p_pay)');
    SET @sql_select = CONCAT(v_nome_sp, '_get_result(?)');

    PREPARE stmt FROM @sql_call;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Capturar resultado do executor via variavel de sessao
    SET v_resultado_executor = @executor_result;

    SELECT JSON_OBJECT(
        'status', 'SUCCESS',
        'uuid', v_uuid,
        'id_evento', v_id_evento,
        'executor', v_nome_sp,
        'timestamp', NOW(),
        'resultado', JSON_EXTRACT(@executor_result, '$')
    ) AS result;

END ;;
DELIMITER ;

-- 3. Verificação
SELECT codigo, nome_procedure FROM permissao WHERE nome_procedure IS NOT NULL;

-- 5. Atualizar sp_executor_totem_opcoes_get assinatura
DROP PROCEDURE IF EXISTS sp_executor_totem_opcoes_get ;;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_totem_opcoes_get`(
    IN p_id_sessao BIGINT,
    IN p_uuid_transacao CHAR(36),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
BEGIN
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_painel BIGINT;

    SET v_id_unidade = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')) AS UNSIGNED);
    SET v_id_local = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_local_operacional')) AS UNSIGNED);

    SELECT id_painel INTO v_id_painel
    FROM painel
    WHERE tipo = 'TOTEM'
      AND id_unidade = v_id_unidade
      AND (id_local_operacional = v_id_local OR id_local_operacional IS NULL)
    LIMIT 1;

    SET @executor_result = (
        SELECT JSON_OBJECT(
            'status', 'SUCCESS',
            'opcoes', JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id_opcao', id_opcao,
                    'codigo', codigo,
                    'label', label,
                    'lane', lane,
                    'tipo_atendimento', tipo_atendimento,
                    'prefixo', prefixo,
                    'ordem', ordem,
                    'ativo', ativo
                )
            )
        )
        FROM totem_senha_opcao
        WHERE id_painel = v_id_painel
          AND ativo = 1
        ORDER BY ordem ASC
    );

    SELECT JSON_EXTRACT(@executor_result, '$') AS result;

END ;;

-- 6. Atualizar sp_executor_totem_plantao_medico_get assinatura
DROP PROCEDURE IF EXISTS sp_executor_totem_plantao_medico_get ;;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_totem_plantao_medico_get`(
    IN p_id_sessao BIGINT,
    IN p_uuid_transacao CHAR(36),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
BEGIN
    DECLARE v_id_unidade BIGINT;
    DECLARE v_data DATE;

    SET v_id_unidade = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')) AS UNSIGNED);
    IF JSON_EXTRACT(p_payload, '$.data') IS NOT NULL AND JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data')) != 'null' THEN
        SET v_data = DATE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data')));
    ELSE
        SET v_data = CURDATE();
    END IF;

    SET @executor_result = (
        SELECT JSON_OBJECT(
            'status', 'SUCCESS',
            'plantao', JSON_ARRAYAGG(
                JSON_OBJECT(
                    'especialidade', 'CLINICO',
                    'medico_nome', COALESCE(p.nome, 'MEDICO DE PLANTAO'),
                    'crm', COALESCE(epa.registro_profissional, 'N/A')
                )
            )
        )
        FROM escala_plantao_atual epa
        JOIN funcionario f ON f.id_funcionario = epa.id_usuario
        JOIN pessoa p ON p.id_pessoa = f.id_pessoa
        WHERE epa.id_unidade = v_id_unidade
          AND epa.status_plantao = 'ATIVO'
          AND DATE(epa.data_inicio) = v_data
    );

    SELECT JSON_EXTRACT(@executor_result, '$') AS result;

END ;;
