DELIMITER $$

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

END$$

DELIMITER ;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE sp_ffa_complementar_alertas_permissao(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_acao VARCHAR(50) -- 'REABRIR', 'CANCELAR', 'TTS', 'OBSERVACAO'
)
BEGIN
    -- 1️⃣ Declara variáveis obrigatórias logo após BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_permissao INT DEFAULT 0;
    DECLARE v_tem_pendencia INT;

    -- 2️⃣ Pega status atual da FFA
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id_ffa = p_id_ffa
     FOR UPDATE;

    -- 3️⃣ Valida permissões de acordo com ação
    IF p_acao = 'REABRIR' THEN
        IF v_status_atual = 'CANCELADO' THEN
            -- Só TI pode reabrir cancelada
            SELECT CASE WHEN EXISTS (
                SELECT 1 FROM usuario_sistema 
                 WHERE id_usuario = p_id_usuario AND sistema = 'TI'
            ) THEN 1 ELSE 0 END
            INTO v_permissao;
            IF v_permissao = 0 THEN
                SIGNAL SQLSTATE '45000' 
                SET MESSAGE_TEXT = 'Somente TI pode reabrir FFA cancelada';
            END IF;
        ELSE
            -- Médicos, enfermeiros, recepção, TI podem reabrir FFA normal
            SELECT CASE WHEN EXISTS (
                SELECT 1 FROM usuario_sistema 
                 WHERE id_usuario = p_id_usuario 
                   AND sistema IN ('MEDICO','ENFERMAGEM','RECEPCAO','TI')
            ) THEN 1 ELSE 0 END
            INTO v_permissao;
            IF v_permissao = 0 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Usuário não tem permissão para reabrir esta FFA';
            END IF;
        END IF;

        -- Atualiza status e auditoria
        UPDATE ffa
           SET status = 'EM_ATENDIMENTO'
         WHERE id_ffa = p_id_ffa;

        INSERT INTO eventos_fluxo (
            id_ffa, evento, contexto, id_usuario, observacao, criado_em
        ) VALUES (
            p_id_ffa, 'REABERTURA_MANUAL', 'SISTEMA', p_id_usuario, 'Reabertura via SP complementar', NOW()
        );
    END IF;

    -- 4️⃣ TTS / alerta do painel
    IF p_acao = 'TTS' THEN
        SELECT COUNT(*) 
          INTO v_tem_pendencia
          FROM ffa_pendencias
         WHERE id_ffa = p_id_ffa
           AND status_pendencia IN ('PENDENTE','ATRASADO');

        IF v_tem_pendencia > 0 THEN
            INSERT INTO eventos_fluxo (
                id_ffa, evento, contexto, id_usuario, observacao, criado_em
            ) VALUES (
                p_id_ffa, 'TTS_ALERTA', 'PAINEL', p_id_usuario, 
                CONCAT('Alerta de pendências TTS para FFA ', p_id_ffa), NOW()
            );
        END IF;
    END IF;

    -- 5️⃣ Cria/atualiza observações na fila para novas pendências
    IF p_acao = 'OBSERVACAO' THEN
        INSERT INTO fila_observacao (id_ffa, tipo_evento, local_destino, criado_em, status)
        SELECT v.id_ffa, v.tipo_pendencia, v.local_destino, NOW(), 'PENDENTE'
          FROM ffa_pendencias v
         WHERE v.id_ffa = p_id_ffa
           AND v.status_pendencia IN ('PENDENTE','ATRASADO')
        ON DUPLICATE KEY UPDATE criado_em = NOW(), status = 'PENDENTE';
    END IF;

END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_ffa_complementar_alertas_permissao` $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_complementar_alertas_permissao`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_acao VARCHAR(50) -- 'REABRIR', 'CANCELAR', 'OBSERVACAO', 'TTS'
)
BEGIN
    -- 1️⃣ Declara variáveis obrigatórias
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_permissao INT DEFAULT 0;
    DECLARE v_tem_pendencia INT;

    -- 2️⃣ Pega status atual da FFA
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id_ffa = p_id_ffa
     FOR UPDATE;

    -- 3️⃣ Valida permissões de acordo com ação
    IF p_acao = 'REABRIR' THEN
        IF v_status_atual = 'CANCELADO' THEN
            -- Só TI pode reabrir FFA cancelada
            SELECT CASE WHEN EXISTS (
                SELECT 1 
                  FROM usuario_sistema 
                 WHERE id_usuario = p_id_usuario 
                   AND sistema = 'TI'
            ) THEN 1 ELSE 0 END
            INTO v_permissao;
            IF v_permissao = 0 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Somente TI pode reabrir FFA cancelada';
            END IF;
        ELSE
            -- Médicos, enfermeiros, recepção, TI podem reabrir FFA normal
            SELECT CASE WHEN EXISTS (
                SELECT 1 
                  FROM usuario_sistema 
                 WHERE id_usuario = p_id_usuario 
                   AND sistema IN ('MEDICO','ENFERMAGEM','RECEPCAO','TI')
            ) THEN 1 ELSE 0 END
            INTO v_permissao;
            IF v_permissao = 0 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Usuário não tem permissão para reabrir esta FFA';
            END IF;
        END IF;

        -- Atualiza status e auditoria
        UPDATE ffa
           SET status = 'EM_ATENDIMENTO',
               atualizado_em = NOW()
         WHERE id_ffa = p_id_ffa;

        INSERT INTO eventos_fluxo (
            id_ffa, evento, contexto, id_usuario, observacao, criado_em
        ) VALUES (
            p_id_ffa, 'REABERTURA_MANUAL', 'SISTEMA', p_id_usuario, 
            'Reabertura via SP complementar', NOW()
        );
    END IF;

    -- 4️⃣ Cancelamento
    IF p_acao = 'CANCELAR' THEN
        -- Só TI pode cancelar
        SELECT CASE WHEN EXISTS (
            SELECT 1 
              FROM usuario_sistema 
             WHERE id_usuario = p_id_usuario 
               AND sistema = 'TI'
        ) THEN 1 ELSE 0 END
        INTO v_permissao;
        IF v_permissao = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Somente TI pode cancelar FFA';
        END IF;

        -- Atualiza status e auditoria
        UPDATE ffa
           SET status = 'CANCELADO',
               atualizado_em = NOW()
         WHERE id_ffa = p_id_ffa;

        INSERT INTO eventos_fluxo (
            id_ffa, evento, contexto, id_usuario, observacao, criado_em
        ) VALUES (
            p_id_ffa, 'CANCELAMENTO_MANUAL', 'SISTEMA', p_id_usuario, 
            'Cancelamento da FFA pelo TI', NOW()
        );
    END IF;

    -- 5️⃣ Observação / Pendências
    IF p_acao = 'OBSERVACAO' THEN
        -- Cria/atualiza observações para todas as pendências abertas ou atrasadas
        INSERT INTO fila_observacao (id_ffa, tipo_evento, local_destino, criado_em, status)
        SELECT v.id_ffa, v.tipo_pendencia, v.local_destino, NOW(), 'PENDENTE'
          FROM ffa_pendencias v
         WHERE v.id_ffa = p_id_ffa
           AND v.status_pendencia IN ('PENDENTE','ATRASADO')
        ON DUPLICATE KEY UPDATE criado_em = NOW(), status = 'PENDENTE';

        -- Marca alerta visual no painel (bolinha preta)
        UPDATE ffa_pendencias
           SET alerta_painel = 1
         WHERE id_ffa = p_id_ffa
           AND status_pendencia IN ('PENDENTE','ATRASADO');

        INSERT INTO eventos_fluxo (
            id_ffa, evento, contexto, id_usuario, observacao, criado_em
        ) VALUES (
            p_id_ffa, 'OBSERVACAO_ADICIONADA', 'SISTEMA', p_id_usuario,
            'Observação/pendência adicionada na FFA', NOW()
        );
    END IF;

    -- 6️⃣ TTS / alerta do painel
    IF p_acao = 'TTS' THEN
        SELECT COUNT(*) 
          INTO v_tem_pendencia
          FROM ffa_pendencias
         WHERE id_ffa = p_id_ffa
           AND status_pendencia IN ('PENDENTE','ATRASADO');

        IF v_tem_pendencia > 0 THEN
            INSERT INTO eventos_fluxo (
                id_ffa, evento, contexto, id_usuario, observacao, criado_em
            ) VALUES (
                p_id_ffa, 'TTS_ALERTA', 'PAINEL', p_id_usuario,
                CONCAT('Alerta de pendências TTS para FFA ', p_id_ffa), NOW()
            );
        END IF;

        -- Aqui pode ser integrado com TTS externo (Google TTS ou outro) via backend
    END IF;

END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_fechamento_ffa_completo;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE sp_fechamento_ffa_completo(
    IN p_horas_limite INT
)
BEGIN
    -- 1️⃣ Declara todas as variáveis e cursores primeiro
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_retorno_ativo INT;
    DECLARE v_paciente_internado INT;

    DECLARE cur CURSOR FOR
        SELECT id_ffa, status, retorno_ativo
          FROM ffa
         WHERE status IN ('ABERTO','EM_ATENDIMENTO','EM_ATENDIMENTO_RETORNO')
           AND TIMESTAMPDIFF(HOUR, atualizado_em, NOW()) >= p_horas_limite;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- 2️⃣ Define 24h como padrão se parâmetro não informado
    IF p_horas_limite IS NULL OR p_horas_limite = 0 THEN
        SET p_horas_limite = 24;
    END IF;

    -- 3️⃣ Abre cursor
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

        -- Se não houver retorno ativo ou paciente não internado, encerra automaticamente
        IF v_retorno_ativo = 0 OR v_paciente_internado = 0 THEN
            UPDATE ffa
               SET status = 'ENCERRADO_AUTOMATICO',
                   atualizado_em = NOW()
             WHERE id_ffa = v_id_ffa;

            -- Auditoria do fechamento
            INSERT INTO eventos_fluxo (
                id_ffa, evento, contexto, id_usuario, observacao, criado_em
            ) VALUES (
                v_id_ffa, 'FECHAMENTO_AUTOMATICO', 'SISTEMA', NULL,
                CONCAT('Fechamento automático após ', p_horas_limite, 'h sem movimentação. Status anterior: ', v_status_atual),
                NOW()
            );

            -- Chama SP complementar para criar observações e alertas
            CALL sp_ffa_complementar_alertas_permissao(v_id_ffa, NULL, 'OBSERVACAO');
            CALL sp_ffa_complementar_alertas_permissao(v_id_ffa, NULL, 'TTS');
        END IF;

    END LOOP;

    CLOSE cur;
END$$
DELIMITER ;




SELECT * FROM sistema;
SELECT * FROM usuario WHERE login='yasnanakase';
SELECT * FROM usuario_sistema WHERE id_usuario = 2;
SELECT * FROM usuario_perfil WHERE id_usuario = 2;
SELECT * FROM perfil;
