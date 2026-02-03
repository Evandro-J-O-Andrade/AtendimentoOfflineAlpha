CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_risco_sanitario` AS
    SELECT 
        `f`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        `f`.`principio_ativo` AS `principio_ativo`,
        `fl`.`id_lote` AS `id_lote`,
        `fl`.`numero_lote` AS `numero_lote`,
        `fl`.`data_validade` AS `data_validade`,
        FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) AS `dias_para_vencer`,
        (CASE
            WHEN (FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) < 0) THEN 'VENCIDO'
            WHEN (FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) <= 30) THEN 'CRITICO'
            WHEN (FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) <= 90) THEN 'ALERTA'
            ELSE 'OK'
        END) AS `nivel_risco`
    FROM
        (`farmaco_lote` `fl`
        JOIN `farmaco` `f` ON ((`f`.`id_farmaco` = `fl`.`id_farmaco`)))