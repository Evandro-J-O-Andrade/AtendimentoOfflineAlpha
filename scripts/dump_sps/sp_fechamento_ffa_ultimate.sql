CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fechamento_ffa_ultimate`(
    IN p_horas_limite INT
)
BEGIN
    -- Variáveis do cursor
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_retorno_ativo INT;
    DECLARE v_paciente_internado INT;

    -- Cursor para todas as FFA abertas ou em atendimento que ultrapassaram o tempo limite
    DECLARE cur CURSOR FOR
        SELECT id_ffa, status, retorno_ativo
          FROM ffa
         WHERE status IN ('ABERTO','EM_ATENDIMENTO','EM_ATENDIMENTO_RETORNO')
           AND TIMESTAMPDIFF(HOUR, atualizado_em, NOW()) >= IFNULL(p_horas_limite,24);

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Define valor padrão de 24h
    IF p_horas_limite IS NULL OR p_horas_limite = 0 THEN
        SET p_horas_limite = 24;
    END IF;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id_ffa, v_status_atual, v_retorno_ativo;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Ignora FFA já encerradas ou canceladas
        IF v_status_atual IN ('ENCERRADO','CANCELADO','ENCERRADO_AUTOMATICO') THEN
            ITERATE read_loop;
        END IF;

        -- Checa se paciente está internado
        SELECT COUNT(*) 
          INTO v_paciente_internado
          FROM internacao
         WHERE id_paciente = (SELECT id_paciente FROM ffa WHERE id_ffa = v_id_ffa)
           AND status IN ('ATIVO','EM_ANDAMENTO');

        -- Verifica pendências críticas: medicação, exames, cuidados
        -- Cria fila de observação e alerta no painel
        INSERT INTO fila_observacao (
            id_ffa,
            tipo_evento,
            local_destino,
            criado_em,
            status
        )
        SELECT
            v_id_ffa,
            tipo_pendencia,
            local_destino,
            NOW(),
            'PENDENTE'
          FROM ffa_pendencias
         WHERE id_ffa = v_id_ffa
           AND status_pendencia IN ('PENDENTE','ATRASADO');

        UPDATE ffa_pendencias
           SET alerta_painel = 1
         WHERE id_ffa = v_id_ffa
           AND status_pendencia IN ('PENDENTE','ATRASADO');

        -- Se não houver retorno ativo ou paciente não internado, encerra automaticamente
        IF v_retorno_ativo = 0 OR v_paciente_internado = 0 THEN
            UPDATE ffa
               SET status = 'ENCERRADO_AUTOMATICO',
                   atualizado_em = NOW()
             WHERE id_ffa = v_id_ffa;

            -- Auditoria do fechamento
            INSERT INTO eventos_fluxo (
                id_ffa,
                evento,
                contexto,
                id_usuario,
                observacao,
                criado_em
            ) VALUES (
                v_id_ffa,
                'FECHAMENTO_AUTOMATICO',
                'SISTEMA',
                NULL,
                CONCAT('Fechamento automático após ', p_horas_limite, 'h sem movimentação. Status anterior: ', v_status_atual),
                NOW()
            );
        END IF;

        -- Gatilho de TTS e alertas do painel para pendências
        -- Se houver função/procedure TTS, chama aqui passando id_ffa e tipo de evento
        -- Exemplo: CALL sp_tts_alerta_painel(v_id_ffa);

        -- Atualiza medicações/exames atrasados automaticamente
        UPDATE ffa_pendencias
           SET status_pendencia = 'ATRASADO'
         WHERE id_ffa = v_id_ffa
           AND status_pendencia = 'PENDENTE'
           AND tipo_pendencia IN ('MEDICACAO','EXAME','CUIDADO');

    END LOOP;

    CLOSE cur;

END