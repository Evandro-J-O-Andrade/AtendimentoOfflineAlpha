CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_estoque_lote` AS
    SELECT 
        `m`.`id_farmaco` AS `id_farmaco`,
        `m`.`id_lote` AS `id_lote`,
        `m`.`id_cidade` AS `id_cidade`,
        SUM((CASE
            WHEN (`m`.`tipo` = 'ENTRADA') THEN `m`.`quantidade`
            ELSE -(`m`.`quantidade`)
        END)) AS `estoque_lote`
    FROM
        `farmaco_movimentacao` `m`
    GROUP BY `m`.`id_farmaco` , `m`.`id_lote` , `m`.`id_cidade`