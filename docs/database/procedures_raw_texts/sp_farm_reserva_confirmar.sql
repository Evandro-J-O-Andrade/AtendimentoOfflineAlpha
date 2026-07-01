CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farm_reserva_confirmar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_reserva BIGINT,
    IN p_id_usuario_confirmador BIGINT,
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_id_lote BIGINT;
    DECLARE v_id_dispensacao BIGINT;
    DECLARE v_quantidade DECIMAL(14,3);
    DECLARE v_reserva_status VARCHAR(40);
    DECLARE v_msg VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET v_msg = 'Erro ao confirmar reserva';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END;

    START TRANSACTION;

    -- Busca reserva (com lock)
    SELECT id_lote, id_documento, quantidade, status
    INTO v_id_lote, v_id_dispensacao, v_quantidade, v_reserva_status
    FROM estoque_reserva
    WHERE id_reserva = p_id_reserva
    FOR UPDATE;

    -- Valida estado
    IF v_reserva_status NOT IN ('ATIVA', 'CONFIRMADA') THEN
        SET v_msg = CONCAT('Reserva invalida: ', IFNULL(v_reserva_status,'NULL'));
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END IF;

    -- Aplica baixa do lote
    UPDATE estoque_lote
    SET quantidade = quantidade - v_quantidade,
        atualizado_em = NOW()
    WHERE id_lote = v_id_lote;

    -- Marca reserva como efetivada
    UPDATE estoque_reserva
    SET status = 'CONFIRMADA',
        id_sessao_finalizou = p_id_sessao_usuario,
        finalizado_em = NOW(),
        motivo = p_observacao
    WHERE id_reserva = p_id_reserva;

    -- Atualiza dispensacao: marca segunda baixa
    UPDATE farm_dispensacao
    SET status = 'FINALIZADA',
        id_usuario_segunda_baixa = p_id_usuario_confirmador,
        segunda_baixa_em = NOW()
    WHERE id_dispensacao = v_id_dispensacao;

    -- Auditoria
    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FARM_RESERVA_CONFIRMADA',
        'estoque_reserva',
        p_id_reserva
    );

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FARM_DISP_FINALIZADA',
        'farm_dispensacao',
        v_id_dispensacao
    );

    COMMIT;
END ;;