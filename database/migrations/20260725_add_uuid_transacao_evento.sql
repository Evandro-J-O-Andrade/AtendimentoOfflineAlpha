-- Migration: add_uuid_transacao_evento
-- Data: 2026-07-25
-- Descricao: Adiciona coluna uuid_transacao em atendimento_evento para suporte a idempotencia

-- Adiciona coluna uuid_transacao
ALTER TABLE atendimento_evento
ADD COLUMN uuid_transacao CHAR(36) NULL AFTER payload,
ADD INDEX idx_evento_uuid (uuid_transacao);

-- Atualiza sp_master_dispatcher para incluir verificacao de idempotencia
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
