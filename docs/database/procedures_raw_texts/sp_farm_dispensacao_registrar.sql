CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farm_dispensacao_registrar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_receita BIGINT,
    IN p_id_produto BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_estoque_local BIGINT,
    IN p_quantidade DECIMAL(14,3),
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_id_dispensacao BIGINT;
    DECLARE v_id_movimento BIGINT;
    DECLARE v_tipo_dispensacao VARCHAR(20);
    DECLARE v_exige_dupla TINYINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao registrar dispensacao';
    END;

    START TRANSACTION;

    -- Busca tipo de dispensacao pela receita
    SELECT fr.tipo, fo.exige_dupla_baixa INTO v_tipo_dispensacao, v_exige_dupla
    FROM farm_receita_controlada fr
    JOIN farm_operacao fo ON fo.id_operacao = fr.id_operacao
    WHERE fr.id_receita = p_id_receita;

    -- Cria dispensacao
    INSERT INTO farm_dispensacao (id_receita, tipo, status, criado_em)
    VALUES (p_id_receita, v_tipo_dispensacao, IF(v_exige_dupla, 'PARCIAL', 'FINALIZADA'), NOW());
    SET v_id_dispensacao = LAST_INSERT_ID();

    -- Cria item de dispensacao
    INSERT INTO farm_dispensacao_item (id_dispensacao, id_produto, lote, quantidade)
    VALUES (v_id_dispensacao, p_id_produto, p_id_lote, p_quantidade);

    -- Registra movimento append-only (permanente, imutável)
    INSERT INTO estoque_movimento (id_estoque_local, tipo, origem, id_documento, observacao, id_sessao_usuario, criado_em)
    VALUES (p_id_estoque_local, 'SAIDA', 'FARMACIA', v_id_dispensacao, p_observacao, p_id_sessao_usuario, NOW());
    SET v_id_movimento = LAST_INSERT_ID();

    -- Registra item de movimento
    INSERT INTO estoque_movimento_item (id_movimento, id_produto, id_lote, quantidade, criado_em)
    VALUES (v_id_movimento, p_id_produto, p_id_lote, p_quantidade, NOW());

    -- Se exige dupla baixa, cria reserva
    IF v_exige_dupla = 1 THEN
        INSERT INTO estoque_reserva (id_estoque_local, id_produto, id_lote, quantidade, origem_tipo, id_documento, status, id_sessao_criou, criado_em)
        VALUES (p_id_estoque_local, p_id_produto, p_id_lote, p_quantidade, 'FARM_DISP', v_id_dispensacao, 'ATIVA', p_id_sessao_usuario, NOW());
    ELSE
        -- Sem dupla: aplica movimento diretamente no lote
        UPDATE estoque_lote SET quantidade = quantidade - p_quantidade, atualizado_em = NOW()
        WHERE id_lote = p_id_lote;
    END IF;

    -- Auditoria
    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'FARM_DISP_REGISTRADA', 'farm_dispensacao', v_id_dispensacao);

    COMMIT;
END ;;