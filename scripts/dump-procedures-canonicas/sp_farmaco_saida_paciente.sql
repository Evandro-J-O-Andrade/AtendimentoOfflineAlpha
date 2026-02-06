CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmaco_saida_paciente`(
    IN p_id_farmaco BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_local BIGINT,
    IN p_quantidade INT,
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_cliente BIGINT
)
BEGIN
    DECLARE v_saldo_atual INT DEFAULT 0;
    DECLARE v_posologia INT DEFAULT 1;
    DECLARE v_dias INT DEFAULT 1;
    DECLARE v_total_permitido INT;

    -- 1️⃣ Bloqueio sanitário
    IF fn_farmaco_lote_valido(p_id_lote) = FALSE THEN
        INSERT INTO farmaco_auditoria_bloqueio
            (id_farmaco, id_lote, id_cidade, quantidade, id_ffa, usuario, motivo)
        VALUES
            (p_id_farmaco, p_id_lote, p_id_local, p_quantidade, p_id_ffa, p_id_usuario,
             'Tentativa de saída com lote vencido');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lote vencido. Saída bloqueada.';
    END IF;

    -- 2️⃣ Verifica saldo
    SELECT quantidade_atual
      INTO v_saldo_atual
      FROM estoque_local
     WHERE id_farmaco = p_id_farmaco
       AND id_local = p_id_local
     FOR UPDATE;

    IF v_saldo_atual IS NULL OR v_saldo_atual < p_quantidade THEN
        INSERT INTO farmaco_auditoria_bloqueio
            (id_farmaco, id_lote, id_cidade, quantidade, id_ffa, usuario, motivo)
        VALUES
            (p_id_farmaco, p_id_lote, p_id_local, p_quantidade, p_id_ffa, p_id_usuario,
             'Tentativa de saída sem saldo suficiente');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente.';
    END IF;

    -- 3️⃣ Verifica prescrição / posologia
    SELECT posologia, dias
      INTO v_posologia, v_dias
      FROM ffa_medicacao
     WHERE id_ffa = p_id_ffa
       AND id_farmaco = p_id_farmaco;

    SET v_total_permitido = v_posologia * v_dias;

    IF p_quantidade > v_total_permitido THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantidade acima da prescrição permitida.';
    END IF;

    -- 4️⃣ Debita estoque
    UPDATE estoque_local
       SET quantidade_atual = quantidade_atual - p_quantidade
     WHERE id_farmaco = p_id_farmaco
       AND id_local = p_id_local;

    -- 5️⃣ Registra movimentação
    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, id_ffa, realizado_por, id_cliente)
    VALUES
        (p_id_farmaco, p_id_lote, p_id_local, 'SAIDA', p_quantidade,
         'PACIENTE', p_id_ffa, p_id_usuario, p_id_cliente);

END