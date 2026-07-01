CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_ecg`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_resultado         TEXT
)
BEGIN
    CALL sp_finalizar_procedimento_geral(p_id_sessao_usuario, p_id_fila, p_resultado);
END ;;