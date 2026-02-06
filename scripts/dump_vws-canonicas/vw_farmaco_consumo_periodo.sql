CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_consumo_periodo` AS
    SELECT 
        `m`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        `m`.`id_cidade` AS `id_cidade`,
        CAST(`m`.`data_mov` AS DATE) AS `data_consumo`,
        SUM(`m`.`quantidade`) AS `total_consumido`
    FROM
        (`farmaco_movimentacao` `m`
        JOIN `farmaco` `f` ON ((`f`.`id_farmaco` = `m`.`id_farmaco`)))
    WHERE
        ((`m`.`tipo` = 'SAIDA')
            AND (`m`.`origem` = 'PACIENTE'))
    GROUP BY `m`.`id_farmaco` , `m`.`id_cidade` , CAST(`m`.`data_mov` AS DATE)