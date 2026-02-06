CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_procedimentos_pendentes` AS
    SELECT 
        `p`.`id_procedimento` AS `id_procedimento`,
        `p`.`id_ffa` AS `id_ffa`,
        `p`.`tipo` AS `tipo`,
        `p`.`status` AS `status`,
        `p`.`prioridade` AS `prioridade`,
        `p`.`criado_em` AS `criado_em`
    FROM
        `ffa_procedimento` `p`
    WHERE
        (`p`.`status` IN ('SOLICITADO' , 'EM_FILA', 'EM_EXECUCAO'))