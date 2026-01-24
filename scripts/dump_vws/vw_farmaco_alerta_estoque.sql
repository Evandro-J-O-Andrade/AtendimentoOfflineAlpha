CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_alerta_estoque` AS
    SELECT 
        `f`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        `f`.`principio_ativo` AS `principio_ativo`,
        `el`.`id_local` AS `id_local`,
        `el`.`quantidade_atual` AS `estoque_atual`,
        `el`.`min_estoque` AS `min_estoque`,
        (`el`.`min_estoque` - `el`.`quantidade_atual`) AS `deficit`
    FROM
        (`farmaco` `f`
        JOIN `estoque_local` `el` ON ((`el`.`id_farmaco` = `f`.`id_farmaco`)))
    WHERE
        (`el`.`quantidade_atual` < `el`.`min_estoque`)