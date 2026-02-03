CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_fila_operacional_atual` AS
    SELECT 
        `f`.`id_fila` AS `id_fila`,
        `f`.`id_ffa` AS `id_ffa`,
        `f`.`tipo` AS `tipo`,
        `f`.`substatus` AS `substatus`,
        `f`.`prioridade` AS `prioridade`,
        `f`.`data_entrada` AS `data_entrada`,
        `f`.`data_inicio` AS `data_inicio`,
        `f`.`data_fim` AS `data_fim`,
        `f`.`id_responsavel` AS `id_responsavel`,
        `u`.`login` AS `responsavel_login`,
        `f`.`id_local` AS `id_local`,
        `l`.`nome` AS `local_nome`,
        `f`.`observacao` AS `observacao`
    FROM
        ((`fila_operacional` `f`
        LEFT JOIN `usuario` `u` ON ((`u`.`id_usuario` = `f`.`id_responsavel`)))
        LEFT JOIN `local_atendimento` `l` ON ((`l`.`id_local` = `f`.`id_local`)))
    WHERE
        (`f`.`substatus` <> 'FINALIZADO')