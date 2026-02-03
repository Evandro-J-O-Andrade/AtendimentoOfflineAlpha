CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_painel_chamadas_ativas` AS
    SELECT 
        `cp`.`id_chamada` AS `id_chamada`,
        `a`.`id_atendimento` AS `id_atendimento`,
        `s`.`id` AS `id_senha`,
        `s`.`numero` AS `numero_senha`,
        `s`.`prefixo` AS `prefixo`,
        `sa`.`id_sala` AS `id_sala`,
        `sa`.`nome_exibicao` AS `sala`,
        `cp`.`data_hora` AS `chamado_em`
    FROM
        (((`chamada_painel` `cp`
        JOIN `atendimento` `a` ON ((`a`.`id_atendimento` = `cp`.`id_atendimento`)))
        JOIN `senhas` `s` ON ((`s`.`id` = `a`.`id_senha`)))
        LEFT JOIN `sala` `sa` ON ((`sa`.`id_sala` = `cp`.`id_sala`)))
    WHERE
        (`cp`.`status` = 'CHAMANDO')
    ORDER BY `cp`.`data_hora` DESC