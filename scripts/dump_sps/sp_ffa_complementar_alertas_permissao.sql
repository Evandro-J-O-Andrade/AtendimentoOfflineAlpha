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

END