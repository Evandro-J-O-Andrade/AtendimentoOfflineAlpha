CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_consumo_por_ffa` AS
    SELECT 
        `m`.`id_ffa` AS `id_ffa`,
        `m`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        SUM(`m`.`quantidade`) AS `quantidade`
    FROM
        (`farmaco_movimentacao` `m`
        JOIN `farmaco` `f` ON ((`f`.`id_farmaco` = `m`.`id_farmaco`)))
    WHERE
        (`m`.`origem` = 'PACIENTE')
    GROUP BY `m`.`id_ffa` , `m`.`id_farmaco`