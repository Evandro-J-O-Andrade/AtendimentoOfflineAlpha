CREATE DEFINER=`root`@`localhost` FUNCTION `fn_proxima_senha`(p_tipo ENUM('CLINICO','PEDIATRICO','PRIORITARIO','EMERGENCIA','VISITA','EXAME')) RETURNS bigint
    DETERMINISTIC
BEGIN
    DECLARE proxima BIGINT;
    SELECT IFNULL(MAX(numero),0)+1 INTO proxima
    FROM senhas
    WHERE tipo_atendimento = p_tipo;
    RETURN proxima;
END