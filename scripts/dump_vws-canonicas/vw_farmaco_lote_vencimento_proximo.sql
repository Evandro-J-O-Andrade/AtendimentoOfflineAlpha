CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_lote_vencimento_proximo` AS
    SELECT 
        `l`.`id_lote` AS `id_lote`,
        `l`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        `l`.`numero_lote` AS `numero_lote`,
        `l`.`data_validade` AS `data_validade`,
        (TO_DAYS(`l`.`data_validade`) - TO_DAYS(CURDATE())) AS `dias_para_vencer`,
        `e`.`id_cidade` AS `id_cidade`,
        `e`.`estoque_lote` AS `estoque_lote`
    FROM
        ((`farmaco_lote` `l`
        JOIN `vw_farmaco_estoque_lote` `e` ON ((`e`.`id_lote` = `l`.`id_lote`)))
        JOIN `farmaco` `f` ON ((`f`.`id_farmaco` = `l`.`id_farmaco`)))
    WHERE
        ((`l`.`data_validade` >= CURDATE())
            AND ((TO_DAYS(`l`.`data_validade`) - TO_DAYS(CURDATE())) <= 60)
            AND (`e`.`estoque_lote` > 0))