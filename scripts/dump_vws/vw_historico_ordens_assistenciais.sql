CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_historico_ordens_assistenciais` AS
    SELECT 
        `oa`.`id` AS `id`,
        `oa`.`id_ffa` AS `id_ffa`,
        `oa`.`tipo_ordem` AS `tipo_ordem`,
        `oa`.`status` AS `status`,
        `oa`.`criado_por` AS `criado_por`,
        `oa`.`iniciado_em` AS `iniciado_em`,
        `oa`.`encerrado_em` AS `encerrado_em`
    FROM
        `ordem_assistencial` `oa`