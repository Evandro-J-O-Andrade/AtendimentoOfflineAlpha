CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_usuario_sistemas` AS
    SELECT 
        `u`.`id_usuario` AS `id_usuario`,
        `u`.`login` AS `login`,
        `s`.`id_sistema` AS `id_sistema`,
        `s`.`nome` AS `sistema`,
        `p`.`id_perfil` AS `id_perfil`,
        `p`.`nome` AS `perfil`
    FROM
        (((`usuario` `u`
        JOIN `usuario_sistema` `us` ON (((`us`.`id_usuario` = `u`.`id_usuario`)
            AND (`us`.`ativo` = 1))))
        JOIN `sistema` `s` ON (((`s`.`id_sistema` = `us`.`id_sistema`)
            AND (`s`.`ativo` = 1))))
        JOIN `perfil` `p` ON ((`p`.`id_perfil` = `us`.`id_perfil`)))
    WHERE
        (`u`.`ativo` = 1)