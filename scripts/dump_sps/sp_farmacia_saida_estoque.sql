CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmacia_saida_estoque`(
    IN p_id_lote BIGINT,
    IN p_quantidade INT,
    IN p_id_usuario BIGINT,
    IN p_id_local BIGINT
)
BEGIN
    DECLARE v_id_farmaco BIGINT;
    DECLARE v_validade DATE;
    DECLARE v_dias INT;
    DECLARE v_risco VARCHAR(20);
    DECLARE v_estoque INT;

    SELECT id_farmaco, data_validade
      INTO v_id_farmaco, v_validade
      FROM lote
     WHERE id_lote = p_id_lote;

    SET v_dias = fn_dias_para_vencimento(v_validade);

    SET v_risco = CASE
        WHEN v_dias < 0 THEN 'VENCIDO'
        WHEN v_dias <= 30 THEN 'CRITICO'
        ELSE 'OK'
    END;

    IF v_risco = 'VENCIDO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saída bloqueada: medicamento vencido';
    END IF;

    SELECT quantidade_atual
      INTO v_estoque
      FROM estoque_local
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local
     FOR UPDATE;

    IF v_estoque IS NULL OR v_estoque < p_quantidade THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente';
    END IF;

    UPDATE estoque_local
       SET quantidade_atual = quantidade_atual - p_quantidade
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local;

    INSERT INTO auditoria_estoque_sanitario
        (id_farmaco, id_lote, id_local, quantidade, nivel_risco, criado_por)
    VALUES
        (v_id_farmaco, p_id_lote, p_id_local, p_quantidade, v_risco, p_id_usuario);

    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, realizado_por)
    VALUES
        (v_id_farmaco, p_id_lote, p_id_local, 'SAIDA', p_quantidade, 'FARMACIA', p_id_usuario);

END