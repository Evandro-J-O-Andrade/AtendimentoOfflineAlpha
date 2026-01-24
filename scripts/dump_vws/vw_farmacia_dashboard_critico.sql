CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmacia_dashboard_critico` AS
    SELECT 
        `f`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        `f`.`principio_ativo` AS `principio_ativo`,
        `e`.`id_local` AS `id_local`,
        `e`.`quantidade_atual` AS `estoque_atual`,
        `e`.`min_estoque` AS `min_estoque`,
        (`e`.`min_estoque` - `e`.`quantidade_atual`) AS `deficit`
    FROM
        (`estoque_local` `e`
        JOIN `farmaco` `f` ON ((`f`.`id_farmaco` = `e`.`id_farmaco`)))
    WHERE
        ((`e`.`min_estoque` IS NOT NULL)
            AND (`e`.`quantidade_atual` < `e`.`min_estoque`))