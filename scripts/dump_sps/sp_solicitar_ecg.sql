CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_ecg`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    CALL sp_solicitar_exame_generico(p_id_ffa, 'ECG', p_id_usuario, p_observacao);
END