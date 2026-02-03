CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_estoque_total` AS
    SELECT 
        `vw_farmaco_estoque_lote`.`id_farmaco` AS `id_farmaco`,
        `vw_farmaco_estoque_lote`.`id_cidade` AS `id_cidade`,
        SUM(`vw_farmaco_estoque_lote`.`estoque_lote`) AS `estoque_total`
    FROM
        `vw_farmaco_estoque_lote`
    GROUP BY `vw_farmaco_estoque_lote`.`id_farmaco` , `vw_farmaco_estoque_lote`.`id_cidade`