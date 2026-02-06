CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_ordens_medicas` AS
    SELECT 
        `oa`.`id` AS `id_ordem`,
        `oa`.`id_ffa` AS `id_ffa`,
        `oa`.`tipo_ordem` AS `tipo_ordem`,
        `oa`.`status` AS `status`,
        `oa`.`prioridade` AS `prioridade`,
        `oa`.`payload_clinico` AS `payload_clinico`,
        `oa`.`iniciado_em` AS `iniciado_em`,
        `oa`.`encerrado_em` AS `encerrado_em`
    FROM
        `ordem_assistencial` `oa`