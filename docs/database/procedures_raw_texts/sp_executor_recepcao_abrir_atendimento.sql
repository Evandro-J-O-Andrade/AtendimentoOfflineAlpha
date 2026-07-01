CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_recepcao_abrir_atendimento`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_id_saas BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_ffa BIGINT;

    -- CONTEXTO
    SELECT id_saas_entidade, id_unidade, id_usuario
    INTO v_id_saas, v_id_unidade, v_id_usuario
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao
    LIMIT 1;

    SET v_id_paciente = JSON_EXTRACT(p_payload, '$.id_paciente');

    -- NEGÓCIO
    INSERT INTO ffa (
        id_saas_entidade,
        id_unidade,
        id_paciente,
        contexto_fluxo,
        criado_em
    ) VALUES (
        v_id_saas,
        v_id_unidade,
        v_id_paciente,
        'AGUARDANDO_TRIAGEM',
        NOW(6)
    );

    SET v_id_ffa = LAST_INSERT_ID();

    -- RETORNO
    SELECT JSON_OBJECT(
        'status','SUCCESS',
        'id_ffa', v_id_ffa
    ) AS result;

END ;;