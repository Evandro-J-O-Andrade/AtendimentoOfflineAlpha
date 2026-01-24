CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_fila_atendimento` AS
    SELECT 
        `a`.`id_atendimento` AS `id_atendimento`,
        `a`.`protocolo` AS `protocolo`,
        `p`.`nome_completo` AS `nome_completo`,
        `a`.`status_atendimento` AS `status_atendimento`,
        `l`.`nome` AS `local`
    FROM
        ((`atendimento` `a`
        JOIN `pessoa` `p` ON ((`p`.`id_pessoa` = `a`.`id_pessoa`)))
        JOIN `local_atendimento` `l` ON ((`l`.`id_local` = `a`.`id_local_atual`)))
    WHERE
        (`a`.`status_atendimento` IN ('ABERTO' , 'EM_ATENDIMENTO', 'EM_OBSERVACAO'))