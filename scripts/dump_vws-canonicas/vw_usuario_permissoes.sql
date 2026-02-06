CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_usuario_permissoes` AS
    SELECT 
        `us`.`id_usuario` AS `id_usuario`,
        (CASE
            WHEN (`pe`.`nome` = 'MASTER') THEN 'ADMIN_MASTER'
            ELSE `pe`.`nome`
        END) AS `perfil`,
        `pr`.`id_permissao` AS `id_permissao`,
        `pr`.`codigo` AS `permissao_codigo`,
        `pr`.`descricao` AS `permissao_descricao`
    FROM
        (((`usuario_sistema` `us`
        JOIN `perfil` `pe` ON ((`pe`.`id_perfil` = `us`.`id_perfil`)))
        JOIN `perfil_permissao` `pp` ON ((`pp`.`id_perfil` = `pe`.`id_perfil`)))
        JOIN `permissao` `pr` ON ((`pr`.`id_permissao` = `pp`.`id_permissao`)))
    WHERE
        (`us`.`ativo` = 1)