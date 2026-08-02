DROP PROCEDURE IF EXISTS sp_master_registrar_evento;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_registrar_evento`(
    IN p_id_sessao BIGINT,
    IN p_dominio VARCHAR(50),
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON,
    IN p_metadata JSON,
    IN p_uuid_transacao CHAR(36),
    OUT o_id_evento BIGINT
)
BEGIN
    DECLARE v_hash_evento CHAR(64);
    DECLARE v_id_saas BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_atendimento BIGINT;
    DECLARE v_estado_origem VARCHAR(50);
    DECLARE v_estado_destino VARCHAR(50);

    SET v_id_saas     = JSON_UNQUOTE(JSON_EXTRACT(p_metadata, '$.id_saas'));
    SET v_id_unidade  = JSON_UNQUOTE(JSON_EXTRACT(p_metadata, '$.id_unidade'));
    SET v_id_usuario  = JSON_UNQUOTE(JSON_EXTRACT(p_metadata, '$.id_usuario'));

    IF p_id_referencia > 0 THEN
        SELECT f.id_paciente, a.id_atendimento, f.contexto_fluxo
        INTO v_id_paciente, v_id_atendimento, v_estado_origem
        FROM ffa f
        LEFT JOIN atendimento a ON a.id_ffa = f.id_ffa
        WHERE f.id_ffa = p_id_referencia
        LIMIT 1;
    END IF;

    SET v_estado_destino = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.estado_destino'));

    SET v_hash_evento = SHA2(CONCAT(
        p_uuid_transacao,
        p_dominio,
        p_acao,
        CAST(p_payload AS CHAR),
        v_id_usuario
    ), 256);

    INSERT INTO atendimento_evento (
        uuid_transacao,
        id_entidade,
        id_unidade,
        id_ffa,
        id_atendimento,
        id_paciente,
        dominio,
        tipo_evento,
        estado_origem,
        estado_destino,
        contexto_fluxo,
        payload,
        id_sessao_usuario,
        id_usuario,
        hash_evento,
        criado_em
    ) VALUES (
        p_uuid_transacao,
        v_id_saas,
        v_id_unidade,
        p_id_referencia,
        v_id_atendimento,
        v_id_paciente,
        UPPER(p_dominio),
        UPPER(p_acao),
        v_estado_origem,
        v_estado_destino,
        v_estado_destino,
        p_payload,
        p_id_sessao,
        v_id_usuario,
        v_hash_evento,
        NOW(6)
    );

    SET o_id_evento = LAST_INSERT_ID();
END ;;
DELIMITER ;
