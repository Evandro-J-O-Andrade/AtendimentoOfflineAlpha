DROP PROCEDURE IF EXISTS sp_ledger_evento_log;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ledger_evento_log`(
    IN p_uuid_transacao CHAR(36),
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_acao VARCHAR(100),
    IN p_estado_origem VARCHAR(50),
    IN p_estado_destino VARCHAR(50),
    IN p_payload JSON,
    IN p_status VARCHAR(20),
    IN p_mensagem VARCHAR(500)
)
BEGIN
    INSERT INTO atendimento_evento_ledger (
        uuid_transacao,
        sequencia_evento,
        id_usuario,
        id_sessao,
        id_perfil,
        modulo,
        acao,
        estado_origem,
        estado_destino,
        payload_original,
        status_evento,
        mensagem,
        id_atendimento,
        id_entidade,
        created_at
    ) VALUES (
        p_uuid_transacao,
        1,
        p_id_usuario,
        0,
        p_id_perfil,
        'TOTEM',
        p_acao,
        p_estado_origem,
        p_estado_destino,
        p_payload,
        p_status,
        p_mensagem,
        NULL,
        1,
        NOW(6)
    );
END ;;
DELIMITER ;
