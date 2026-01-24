CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_liberar_medicacao_farmacia`(
    IN p_id_ordem BIGINT,
    IN p_id_usuario BIGINT,
    IN p_lote BIGINT,
    IN p_quantidade INT,
    IN p_id_local BIGINT,
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_id_ffa BIGINT;
    DECLARE v_id_farmaco BIGINT;
    DECLARE v_validade DATE;
    DECLARE v_saldo_atual INT DEFAULT 0;
    DECLARE v_dias INT;
    DECLARE v_risco VARCHAR(20);

    -- 1️⃣ Valida perfil do usuário
    IF NOT EXISTS (
        SELECT 1
          FROM usuario_perfil up
          JOIN perfil p ON up.id_perfil = p.id_perfil
         WHERE up.id_usuario = p_id_usuario
           AND p.nome IN ('FARMACEUTICO','FARMACIA_PA','FARMACIA_UBS','FARMACIA_RUA')
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário sem permissão para liberar medicação';
    END IF;

    -- 2️⃣ Valida ordem de medicação
    SELECT id_ffa
      INTO v_id_ffa
      FROM ordem_assistencial
     WHERE id = p_id_ordem
       AND tipo_ordem = 'MEDICACAO'
       AND status = 'ATIVA';

    IF v_id_ffa IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ordem de medicação inválida ou não ativa';
    END IF;

    -- 3️⃣ Valida lote e farmaco
    SELECT id_farmaco, data_validade
      INTO v_id_farmaco, v_validade
      FROM lote
     WHERE id_lote = p_lote;

    IF v_id_farmaco IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lote inválido';
    END IF;

    -- 4️⃣ Bloqueio sanitário
    SET v_dias = DATEDIFF(v_validade, NOW());

    SET v_risco = CASE
        WHEN v_dias < 0 THEN 'VENCIDO'
        WHEN v_dias <= 30 THEN 'CRITICO'
        ELSE 'OK'
    END;

    IF v_risco = 'VENCIDO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lote vencido. Liberação bloqueada';
    END IF;

    -- 5️⃣ Verifica estoque
    SELECT quantidade_atual
      INTO v_saldo_atual
      FROM estoque_local
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local
     FOR UPDATE;

    IF v_saldo_atual IS NULL OR v_saldo_atual < p_quantidade THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente';
    END IF;

    -- 6️⃣ Debita estoque
    UPDATE estoque_local
       SET quantidade_atual = quantidade_atual - p_quantidade
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local;

    -- 7️⃣ Registra dispensação
    INSERT INTO dispensacao_medicacao
        (id_ordem, id_ffa, lote, quantidade, liberado_por, observacao, liberado_em)
    VALUES
        (p_id_ordem, v_id_ffa, p_lote, p_quantidade, p_id_usuario, p_observacao, NOW());

    -- 8️⃣ Auditoria completa
    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
    VALUES
        (v_id_ffa, 'LIBERACAO_MEDICACAO', 'FARMACIA', p_id_usuario, p_observacao, NOW());

END