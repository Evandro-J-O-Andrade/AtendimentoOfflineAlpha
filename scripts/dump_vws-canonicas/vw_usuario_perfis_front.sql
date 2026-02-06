CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_usuario_perfis_front` AS
    SELECT 
        `us`.`id_usuario` AS `id_usuario`,
        (CASE
            WHEN (`p`.`nome` = 'MASTER') THEN 'ADMIN_MASTER'
            ELSE `p`.`nome`
        END) AS `perfil`
    FROM
        (`usuario_sistema` `us`
        JOIN `perfil` `p` ON ((`p`.`id_perfil` = `us`.`id_perfil`)))
    WHERE
        (`us`.`ativo` = 1)