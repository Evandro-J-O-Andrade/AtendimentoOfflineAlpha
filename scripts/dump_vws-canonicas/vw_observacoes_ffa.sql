CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_observacoes_ffa` AS
    SELECT 
        `o`.`id` AS `id`,
        `o`.`tipo` AS `tipo`,
        `o`.`contexto` AS `contexto`,
        `o`.`texto` AS `texto`,
        `o`.`criado_em` AS `criado_em`,
        COALESCE(`p`.`nome_social`, `p`.`nome_completo`) AS `autor`,
        `u`.`login` AS `autor_login`
    FROM
        ((`observacoes_eventos` `o`
        JOIN `usuario` `u` ON ((`u`.`id_usuario` = `o`.`id_usuario`)))
        JOIN `pessoa` `p` ON ((`p`.`id_pessoa` = `u`.`id_pessoa`)))
    WHERE
        (`o`.`entidade` = 'FFA')