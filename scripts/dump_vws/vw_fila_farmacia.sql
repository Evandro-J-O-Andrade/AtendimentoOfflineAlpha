CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_fila_farmacia` AS
    SELECT 
        `oa`.`id` AS `id_ordem`,
        `oa`.`id_ffa` AS `id_ffa`,
        JSON_UNQUOTE(JSON_EXTRACT(`oa`.`payload_clinico`, '$.medicamento')) AS `medicamento`,
        JSON_EXTRACT(`oa`.`payload_clinico`, '$.dose') AS `dose`,
        JSON_EXTRACT(`oa`.`payload_clinico`, '$.via') AS `via`,
        `oa`.`prioridade` AS `prioridade`,
        `oa`.`iniciado_em` AS `iniciado_em`
    FROM
        `ordem_assistencial` `oa`
    WHERE
        ((`oa`.`status` = 'ATIVA')
            AND (`oa`.`tipo_ordem` = 'MEDICACAO'))
    ORDER BY `oa`.`prioridade` DESC , `oa`.`iniciado_em`