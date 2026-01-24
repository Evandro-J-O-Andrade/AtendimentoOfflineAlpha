CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_pacientes_internados` AS
    SELECT 
        `i`.`id_internacao` AS `id_internacao`,
        `a`.`id_atendimento` AS `id_atendimento`,
        `p`.`nome_completo` AS `paciente`,
        `l`.`identificacao` AS `leito`,
        `i`.`tipo` AS `tipo`,
        `i`.`data_entrada` AS `data_entrada`,
        `i`.`status` AS `status`
    FROM
        (((`internacao` `i`
        JOIN `atendimento` `a` ON ((`a`.`id_ffa` = `i`.`id_ffa`)))
        JOIN `pessoa` `p` ON ((`p`.`id_pessoa` = `a`.`id_pessoa`)))
        JOIN `leito` `l` ON ((`l`.`id_leito` = `i`.`id_leito`)))
    WHERE
        (`i`.`status` = 'ATIVA')