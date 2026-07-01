CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fluxo_estoque`(
    IN p_id_unidade BIGINT,
    IN p_id_local BIGINT,
    IN p_contexto VARCHAR(30),
    IN p_id_item BIGINT,
    IN p_id_lote BIGINT,
    IN p_quantidade DECIMAL(15,4),
    IN p_acao ENUM('RESERVAR', 'DISPENSAR', 'ESTORNAR_RESERVA'),
    IN p_id_referencia BIGINT,
    IN p_id_sessao BIGINT
)
BEGIN
    DECLARE v_hash CHAR(64);
    DECLARE v_fis, v_res DECIMAL(15,4);

    -- 1. VALIDAÇÃO DE SESSÃO (CORE REQUIREMENT)
    IF p_id_sessao IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LEI_IMUTAVEL: Sessao obrigatoria';
    END IF;

    -- 2. HASH IDEMPOTENTE (ANTI-REPLAY)
    SET v_hash = SHA2(CONCAT(p_id_unidade, p_id_local, p_id_item, p_id_lote, p_quantidade, p_acao, p_id_referencia, p_id_sessao), 256);

    -- 3. LOCK DE PIPELINE COM LEASE (ANTI-DUPLA EXECUÇÃO)
    INSERT INTO estoque_execucao_pipeline (pipeline_hash, estado, lease_expira_em)
    VALUES (v_hash, 'PROCESSANDO', NOW() + INTERVAL 30 SECOND)
    ON DUPLICATE KEY UPDATE lease_expira_em = NOW() + INTERVAL 30 SECOND;

    START TRANSACTION;

        -- 4. MATERIALIZAÇÃO DE SALDO (GARANTE EXISTÊNCIA NO RUNTIME)
        INSERT INTO estoque_saldo (id_unidade, id_local, contexto_tipo, id_item, id_lote, id_sessao_usuario)
        VALUES (p_id_unidade, p_id_local, p_contexto, p_id_item, p_id_lote, p_id_sessao)
        ON DUPLICATE KEY UPDATE id_saldo = id_saldo;

        -- 5. LOCK PESSIMISTA DO ESTADO ATUAL
        SELECT qtd_fisica, qtd_reservada INTO v_fis, v_res
        FROM estoque_saldo
        WHERE id_unidade = p_id_unidade AND id_local = p_id_local 
        AND id_item = p_id_item AND id_lote = p_id_lote
        FOR UPDATE;

        -- 6. MOTOR LOGÍSTICO (DECISÃO ATÔMICA)
        CASE p_acao
            WHEN 'RESERVAR' THEN
                IF (v_fis - v_res) < p_quantidade THEN
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SALDO_PROJETADO_INSUFICIENTE';
                END IF;
                UPDATE estoque_saldo SET qtd_reservada = qtd_reservada + p_quantidade
                WHERE id_unidade = p_id_unidade AND id_local = p_id_local AND id_item = p_id_item AND id_lote = p_id_lote;

            WHEN 'DISPENSAR' THEN
                IF v_fis < p_quantidade THEN
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SALDO_FISICO_INSUFICIENTE';
                END IF;
                UPDATE estoque_saldo 
                SET qtd_fisica = qtd_fisica - p_quantidade, 
                    qtd_reservada = GREATEST(qtd_reservada - p_quantidade, 0)
                WHERE id_unidade = p_id_unidade AND id_local = p_id_local AND id_item = p_id_item AND id_lote = p_id_lote;

            WHEN 'ESTORNAR_RESERVA' THEN
                UPDATE estoque_saldo SET qtd_reservada = GREATEST(qtd_reservada - p_quantidade, 0)
                WHERE id_unidade = p_id_unidade AND id_local = p_id_local AND id_item = p_id_item AND id_lote = p_id_lote;
        END CASE;

        -- 7. AUDITORIA SEMÂNTICA (IMUTABILIDADE DO EVENTO)
        INSERT INTO estoque_audit_stream (id_referencia_externa, entidade_tipo, evento_tipo, payload, hash_pipeline)
        VALUES (p_id_referencia, 'ESTOQUE', p_acao, JSON_OBJECT('qtd', p_quantidade, 'sessao', p_id_sessao, 'contexto', p_contexto), v_hash);

        -- 8. FINALIZAÇÃO DO ESTADO DO PIPELINE
        UPDATE estoque_execucao_pipeline SET estado = 'CONCLUIDO' WHERE pipeline_hash = v_hash;

    COMMIT;
END ;;