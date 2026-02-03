CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmacia_dashboard_completo` AS
    SELECT 
        `f`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        `f`.`principio_ativo` AS `principio_ativo`,
        `e`.`id_local` AS `id_local`,
        `e`.`quantidade_atual` AS `quantidade_atual`,
        `e`.`min_estoque` AS `min_estoque`,
        (`e`.`min_estoque` - `e`.`quantidade_atual`) AS `deficit`,
        `fl`.`id_lote` AS `id_lote`,
        `fl`.`numero_lote` AS `numero_lote`,
        `fl`.`data_validade` AS `data_validade`,
        FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) AS `dias_para_vencer`,
        (CASE
            WHEN (FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) < 0) THEN 'VENCIDO'
            WHEN (FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) <= 30) THEN 'CRITICO'
            ELSE 'OK'
        END) AS `nivel_risco`
    FROM
        ((`estoque_local` `e`
        JOIN `farmaco` `f` ON ((`f`.`id_farmaco` = `e`.`id_farmaco`)))
        LEFT JOIN `farmaco_lote` `fl` ON ((`fl`.`id_farmaco` = `f`.`id_farmaco`)))