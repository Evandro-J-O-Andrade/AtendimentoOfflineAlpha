CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fechar_ffa_automatico`()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_retorno_ativo TINYINT;
    DECLARE v_pendencias TINYINT;

    DECLARE cur CURSOR FOR 
        SELECT id_ffa, status, retorno_ativo
          FROM ffa
         WHERE status IN ('ABERTO', 'EM_ATENDIMENTO', 'EM_ATENDIMENTO_RETORNO')
           AND TIMESTAMPDIFF(HOUR, atualizado_em, NOW()) >= 24;
           
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id_ffa, v_status_atual, v_retorno_ativo;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- 1️⃣ Verifica pendências de medicação ou exames
        SELECT COUNT(*)
          INTO v_pendencias
          FROM ffa_itens
         WHERE id_ffa = v_id_ffa
           AND status IN ('PENDENTE', 'AGUARDANDO_MINISTRACAO');

        -- 2️⃣ Atualiza status da FFA
        UPDATE ffa
           SET status = CASE
                            WHEN v_retorno_ativo = 1 THEN 'EM_ATENDIMENTO_RETORNO'
                            WHEN v_pendencias > 0 THEN 'ABERTO_COM_PENDENCIAS'
                            ELSE 'ENCERRADO_AUTOMATICO'
                        END,
               atualizado_em = NOW()
         WHERE id_ffa = v_id_ffa;

        -- 3️⃣ Insere evento de auditoria
        INSERT INTO eventos_fluxo
            (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
        VALUES
            (v_id_ffa,
             CASE
                WHEN v_retorno_ativo = 1 THEN 'RETORNO_PENDENTE_24H'
                WHEN v_pendencias > 0 THEN 'FECHAMENTO_COM_PENDENCIAS'
                ELSE 'FECHAMENTO_AUTOMATICO'
             END,
             'SISTEMA',
             NULL,
             CONCAT('Fechamento automático após 24h. Pendências: ', v_pendencias, 
                    '. Retorno ativo: ', v_retorno_ativo),
             NOW());

        -- 4️⃣ Se houver pendências de medicação/exame, colocar na fila de observação/painel
        IF v_pendencias > 0 THEN
            INSERT INTO fila_observacao
                (id_ffa, tipo, status, criado_em)
            VALUES
                (v_id_ffa, 'MEDICACAO_EXAME_PENDENTE', 'PENDENTE', NOW());
        END IF;

    END LOOP;

    CLOSE cur;
END