CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_solicitacoes_exame_pendentes` AS
    SELECT 
        `se`.`id_solicitacao` AS `id_solicitacao`,
        `se`.`status` AS `status`,
        `se`.`solicitado_em` AS `solicitado_em`,
        `sp`.`codigo` AS `codigo_sigpat`,
        `sp`.`descricao` AS `descricao`,
        `sp`.`setor_execucao` AS `setor_execucao`,
        `f`.`id` AS `id_ffa`,
        `pe`.`nome_completo` AS `paciente`
    FROM
        ((((`solicitacao_exame` `se`
        JOIN `sigpat_procedimento` `sp` ON ((`sp`.`id_sigpat` = `se`.`id_sigpat`)))
        JOIN `ffa` `f` ON ((`f`.`id` = `se`.`id_atendimento`)))
        JOIN `paciente` `pa` ON ((`pa`.`id` = `f`.`id_paciente`)))
        JOIN `pessoa` `pe` ON ((`pe`.`id_pessoa` = `pa`.`id_pessoa`)))
    WHERE
        (`se`.`status` IN ('SOLICITADO' , 'EM_ANALISE'))