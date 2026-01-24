CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_fila_enfermagem` AS
    SELECT 
        `oa`.`id` AS `id_ordem`,
        `oa`.`id_ffa` AS `id_ffa`,
        `oa`.`tipo_ordem` AS `tipo_ordem`,
        `oa`.`prioridade` AS `prioridade`,
        JSON_UNQUOTE(JSON_EXTRACT(`oa`.`payload_clinico`, '$.descricao')) AS `descricao`,
        JSON_EXTRACT(`oa`.`payload_clinico`, '$.frequencia') AS `frequencia`,
        `oa`.`iniciado_em` AS `iniciado_em`
    FROM
        `ordem_assistencial` `oa`
    WHERE
        ((`oa`.`status` = 'ATIVA')
            AND (`oa`.`tipo_ordem` IN ('MEDICACAO' , 'CUIDADO', 'DIETA', 'OXIGENIO')))
    ORDER BY `oa`.`prioridade` DESC , `oa`.`iniciado_em`