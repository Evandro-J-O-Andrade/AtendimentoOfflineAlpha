CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fluxo_executor_matriz`(
    IN p_estado_atual VARCHAR(60),
    IN p_evento VARCHAR(60),
    IN p_id_perfil BIGINT,
    IN p_contexto VARCHAR(50),
    IN p_id_sistema BIGINT,
    IN p_id_sessao_usuario BIGINT,
    OUT p_estado_destino VARCHAR(60)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_destino VARCHAR(60);

    /* ===============================
       Consulta determinística da matriz
    =============================== */

    SELECT ftd.estado_destino
    INTO v_destino
    FROM fluxo_transicao_matriz ftd
    WHERE ftd.estado_origem = p_estado_atual
      AND ftd.evento = p_evento
      AND ftd.id_perfil = p_id_perfil
      AND ftd.contexto = p_contexto
      AND ftd.id_sistema = p_id_sistema
      AND ftd.ativo = 1
    ORDER BY ftd.prioridade DESC
    LIMIT 1;

    IF v_destino IS NULL THEN

        INSERT INTO auditoria_evento(
            id_sessao_usuario,
            evento,
            sucesso,
            descricao
        )
        VALUES(
            p_id_sessao_usuario,
            'TRANSICAO_BLOQUEADA',
            0,
            CONCAT(
                'Origem=',p_estado_atual,
                '|Evento=',p_evento,
                '|Perfil=',p_id_perfil
            )
        );

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transição inválida pela matriz de fluxo';

    END IF;

    SET p_estado_destino = v_destino;

END ;;