CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmaco_entrada`(
    IN p_id_farmaco BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_local BIGINT,
    IN p_quantidade INT,
    IN p_origem ENUM('COMPRA','TRANSFERENCIA','AJUSTE'),
    IN p_usuario BIGINT
)
BEGIN
    DECLARE v_saldo_atual INT DEFAULT 0;

    -- 1️⃣ Validação de lote
    IF fn_farmaco_lote_valido(p_id_lote) = FALSE THEN
        INSERT INTO farmaco_auditoria_bloqueio
            (id_farmaco, id_lote, id_cidade, quantidade, usuario, motivo)
        VALUES
            (p_id_farmaco, p_id_lote, p_id_local, p_quantidade, p_usuario,
             'Tentativa de entrada com lote inválido');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lote inválido. Entrada bloqueada.';
    END IF;

    -- 2️⃣ Verifica estoque existente
    SELECT quantidade_atual
      INTO v_saldo_atual
      FROM estoque_local
     WHERE id_farmaco = p_id_farmaco
       AND id_local = p_id_local
     FOR UPDATE;

    -- 3️⃣ Atualiza ou insere estoque
    IF v_saldo_atual IS NULL THEN
        INSERT INTO estoque_local
            (id_farmaco, id_local, quantidade_atual)
        VALUES
            (p_id_farmaco, p_id_local, p_quantidade);
    ELSE
        UPDATE estoque_local
           SET quantidade_atual = quantidade_atual + p_quantidade
         WHERE id_farmaco = p_id_farmaco
           AND id_local = p_id_local;
    END IF;

    -- 4️⃣ Registra movimentação
    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, realizado_por)
    VALUES
        (p_id_farmaco, p_id_lote, p_id_local, 'ENTRADA', p_quantidade, p_origem, p_usuario);

END