CREATE DEFINER=`root`@`localhost` FUNCTION `fn_farmaco_estoque_atual`(
    p_id_farmaco BIGINT,
    p_id_cidade BIGINT
) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_estoque INT;

    SELECT IFNULL(estoque_total,0)
    INTO v_estoque
    FROM vw_farmaco_estoque_total
    WHERE id_farmaco = p_id_farmaco
      AND id_cidade  = p_id_cidade;

    RETURN v_estoque;
END