CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_usuario_identidade` AS
    SELECT 
        `u`.`id_usuario` AS `id_usuario`,
        `u`.`login` AS `login`,
        `p`.`nome_completo` AS `nome_completo`,
        `u`.`ativo` AS `ativo`
    FROM
        (`usuario` `u`
        JOIN `pessoa` `p` ON ((`p`.`id_pessoa` = `u`.`id_pessoa`)))