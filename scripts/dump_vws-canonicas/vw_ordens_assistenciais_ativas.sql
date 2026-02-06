CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_ordens_assistenciais_ativas` AS
    SELECT 
        `oa`.`id` AS `id_ordem`,
        `oa`.`id_ffa` AS `id_ffa`,
        `oa`.`tipo_ordem` AS `tipo_ordem`,
        `oa`.`prioridade` AS `prioridade`,
        `oa`.`status` AS `status`,
        `oa`.`payload_clinico` AS `payload_clinico`,
        `oa`.`criado_por` AS `criado_por`,
        `oa`.`iniciado_em` AS `iniciado_em`,
        `f`.`status` AS `status_ffa`
    FROM
        (`ordem_assistencial` `oa`
        JOIN `ffa` `f` ON ((`f`.`id` = `oa`.`id_ffa`)))
    WHERE
        (`oa`.`status` = 'ATIVA')