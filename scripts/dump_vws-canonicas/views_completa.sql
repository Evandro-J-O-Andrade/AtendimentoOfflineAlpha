CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmacia_dashboard_completo` AS
    SELECT 
        `f`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        `f`.`principio_ativo` AS `principio_ativo`,
        `e`.`id_local` AS `id_local`,
        `e`.`quantidade_atual` AS `quantidade_atual`,
        `e`.`min_estoque` AS `min_estoque`,
        (`e`.`min_estoque` - `e`.`quantidade_atual`) AS `deficit`,
        `fl`.`id_lote` AS `id_lote`,
        `fl`.`numero_lote` AS `numero_lote`,
        `fl`.`data_validade` AS `data_validade`,
        FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) AS `dias_para_vencer`,
        (CASE
            WHEN (FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) < 0) THEN 'VENCIDO'
            WHEN (FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) <= 30) THEN 'CRITICO'
            ELSE 'OK'
        END) AS `nivel_risco`
    FROM
        ((`estoque_local` `e`
        JOIN `farmaco` `f` ON ((`f`.`id_farmaco` = `e`.`id_farmaco`)))
        LEFT JOIN `farmaco_lote` `fl` ON ((`fl`.`id_farmaco` = `f`.`id_farmaco`)));
        
        CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmacia_dashboard_critico` AS
    SELECT 
        `f`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        `f`.`principio_ativo` AS `principio_ativo`,
        `e`.`id_local` AS `id_local`,
        `e`.`quantidade_atual` AS `estoque_atual`,
        `e`.`min_estoque` AS `min_estoque`,
        (`e`.`min_estoque` - `e`.`quantidade_atual`) AS `deficit`
    FROM
        (`estoque_local` `e`
        JOIN `farmaco` `f` ON ((`f`.`id_farmaco` = `e`.`id_farmaco`)))
    WHERE
        ((`e`.`min_estoque` IS NOT NULL)
            AND (`e`.`quantidade_atual` < `e`.`min_estoque`));
            
            
 CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_alerta_estoque` AS
    SELECT 
        `f`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        `f`.`principio_ativo` AS `principio_ativo`,
        `el`.`id_local` AS `id_local`,
        `el`.`quantidade_atual` AS `estoque_atual`,
        `el`.`min_estoque` AS `min_estoque`,
        (`el`.`min_estoque` - `el`.`quantidade_atual`) AS `deficit`
    FROM
        (`farmaco` `f`
        JOIN `estoque_local` `el` ON ((`el`.`id_farmaco` = `f`.`id_farmaco`)))
    WHERE
        (`el`.`quantidade_atual` < `el`.`min_estoque`);
        
        
 CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_consumo_periodo` AS
    SELECT 
        `m`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        `m`.`id_cidade` AS `id_cidade`,
        CAST(`m`.`data_mov` AS DATE) AS `data_consumo`,
        SUM(`m`.`quantidade`) AS `total_consumido`
    FROM
        (`farmaco_movimentacao` `m`
        JOIN `farmaco` `f` ON ((`f`.`id_farmaco` = `m`.`id_farmaco`)))
    WHERE
        ((`m`.`tipo` = 'SAIDA')
            AND (`m`.`origem` = 'PACIENTE'))
    GROUP BY `m`.`id_farmaco` , `m`.`id_cidade` , CAST(`m`.`data_mov` AS DATE);
    
    CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_consumo_por_ffa` AS
    SELECT 
        `m`.`id_ffa` AS `id_ffa`,
        `m`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        SUM(`m`.`quantidade`) AS `quantidade`
    FROM
        (`farmaco_movimentacao` `m`
        JOIN `farmaco` `f` ON ((`f`.`id_farmaco` = `m`.`id_farmaco`)))
    WHERE
        (`m`.`origem` = 'PACIENTE')
    GROUP BY `m`.`id_ffa` , `m`.`id_farmaco`;
    
    
    CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_estoque_lote` AS
    SELECT 
        `m`.`id_farmaco` AS `id_farmaco`,
        `m`.`id_lote` AS `id_lote`,
        `m`.`id_cidade` AS `id_cidade`,
        SUM((CASE
            WHEN (`m`.`tipo` = 'ENTRADA') THEN `m`.`quantidade`
            ELSE -(`m`.`quantidade`)
        END)) AS `estoque_lote`
    FROM
        `farmaco_movimentacao` `m`
    GROUP BY `m`.`id_farmaco` , `m`.`id_lote` , `m`.`id_cidade`;
    
    CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_estoque_total` AS
    SELECT 
        `vw_farmaco_estoque_lote`.`id_farmaco` AS `id_farmaco`,
        `vw_farmaco_estoque_lote`.`id_cidade` AS `id_cidade`,
        SUM(`vw_farmaco_estoque_lote`.`estoque_lote`) AS `estoque_total`
    FROM
        `vw_farmaco_estoque_lote`
    GROUP BY `vw_farmaco_estoque_lote`.`id_farmaco` , `vw_farmaco_estoque_lote`.`id_cidade`;
    
    CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_lote_vencimento_proximo` AS
    SELECT 
        `l`.`id_lote` AS `id_lote`,
        `l`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        `l`.`numero_lote` AS `numero_lote`,
        `l`.`data_validade` AS `data_validade`,
        (TO_DAYS(`l`.`data_validade`) - TO_DAYS(CURDATE())) AS `dias_para_vencer`,
        `e`.`id_cidade` AS `id_cidade`,
        `e`.`estoque_lote` AS `estoque_lote`
    FROM
        ((`farmaco_lote` `l`
        JOIN `vw_farmaco_estoque_lote` `e` ON ((`e`.`id_lote` = `l`.`id_lote`)))
        JOIN `farmaco` `f` ON ((`f`.`id_farmaco` = `l`.`id_farmaco`)))
    WHERE
        ((`l`.`data_validade` >= CURDATE())
            AND ((TO_DAYS(`l`.`data_validade`) - TO_DAYS(CURDATE())) <= 60)
            AND (`e`.`estoque_lote` > 0));
            
            CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_farmaco_risco_sanitario` AS
    SELECT 
        `f`.`id_farmaco` AS `id_farmaco`,
        `f`.`nome_comercial` AS `nome_comercial`,
        `f`.`principio_ativo` AS `principio_ativo`,
        `fl`.`id_lote` AS `id_lote`,
        `fl`.`numero_lote` AS `numero_lote`,
        `fl`.`data_validade` AS `data_validade`,
        FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) AS `dias_para_vencer`,
        (CASE
            WHEN (FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) < 0) THEN 'VENCIDO'
            WHEN (FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) <= 30) THEN 'CRITICO'
            WHEN (FN_DIAS_PARA_VENCIMENTO(`fl`.`data_validade`) <= 90) THEN 'ALERTA'
            ELSE 'OK'
        END) AS `nivel_risco`
    FROM
        (`farmaco_lote` `fl`
        JOIN `farmaco` `f` ON ((`f`.`id_farmaco` = `fl`.`id_farmaco`)));
        
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
        (`a`.`status_atendimento` IN ('ABERTO' , 'EM_ATENDIMENTO', 'EM_OBSERVACAO'));
        
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
    ORDER BY `oa`.`prioridade` DESC , `oa`.`iniciado_em`;
    
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
    ORDER BY `oa`.`prioridade` DESC , `oa`.`iniciado_em`;
    
    CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_fila_operacional_atual` AS
    SELECT 
        `f`.`id_fila` AS `id_fila`,
        `f`.`id_ffa` AS `id_ffa`,
        `f`.`tipo` AS `tipo`,
        `f`.`substatus` AS `substatus`,
        `f`.`prioridade` AS `prioridade`,
        `f`.`data_entrada` AS `data_entrada`,
        `f`.`data_inicio` AS `data_inicio`,
        `f`.`data_fim` AS `data_fim`,
        `f`.`id_responsavel` AS `id_responsavel`,
        `u`.`login` AS `responsavel_login`,
        `f`.`id_local` AS `id_local`,
        `l`.`nome` AS `local_nome`,
        `f`.`observacao` AS `observacao`
    FROM
        ((`fila_operacional` `f`
        LEFT JOIN `usuario` `u` ON ((`u`.`id_usuario` = `f`.`id_responsavel`)))
        LEFT JOIN `local_atendimento` `l` ON ((`l`.`id_local` = `f`.`id_local`)))
    WHERE
        (`f`.`substatus` <> 'FINALIZADO');
        
        CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_historico_ordens_assistenciais` AS
    SELECT 
        `oa`.`id` AS `id`,
        `oa`.`id_ffa` AS `id_ffa`,
        `oa`.`tipo_ordem` AS `tipo_ordem`,
        `oa`.`status` AS `status`,
        `oa`.`criado_por` AS `criado_por`,
        `oa`.`iniciado_em` AS `iniciado_em`,
        `oa`.`encerrado_em` AS `encerrado_em`
    FROM
        `ordem_assistencial` `oa`;
        
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
        (`o`.`entidade` = 'FFA');
        
        CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_ordens_assistenciais_ativas` AS
    SELECT 
        `oa`.`id` AS `id_ordem`,
        `oa`.`id_ffa` AS `id_ffa`,
        `oa`.`tipo_ordem` AS `tipo_ordem`,
        `oa`.`prioridade` AS `prioridade`,
        `oa`.`status` AS `status`,
        `oa`.`payload_clinico` AS `payload_clinico`,
        `oa`.`criado_por` AS `criado_por`,
        `oa`.`iniciado_em` AS `iniciado_em`,
        `f`.`status` AS `status_ffa`
    FROM
        (`ordem_assistencial` `oa`
        JOIN `ffa` `f` ON ((`f`.`id` = `oa`.`id_ffa`)))
    WHERE
        (`oa`.`status` = 'ATIVA');
        
        CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_ordens_medicas` AS
    SELECT 
        `oa`.`id` AS `id_ordem`,
        `oa`.`id_ffa` AS `id_ffa`,
        `oa`.`tipo_ordem` AS `tipo_ordem`,
        `oa`.`status` AS `status`,
        `oa`.`prioridade` AS `prioridade`,
        `oa`.`payload_clinico` AS `payload_clinico`,
        `oa`.`iniciado_em` AS `iniciado_em`,
        `oa`.`encerrado_em` AS `encerrado_em`
    FROM
        `ordem_assistencial` `oa`;
        
        CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_pacientes_internados` AS
    SELECT 
        `i`.`id_internacao` AS `id_internacao`,
        `a`.`id_atendimento` AS `id_atendimento`,
        `p`.`nome_completo` AS `paciente`,
        `l`.`identificacao` AS `leito`,
        `i`.`tipo` AS `tipo`,
        `i`.`data_entrada` AS `data_entrada`,
        `i`.`status` AS `status`
    FROM
        (((`internacao` `i`
        JOIN `atendimento` `a` ON ((`a`.`id_ffa` = `i`.`id_ffa`)))
        JOIN `pessoa` `p` ON ((`p`.`id_pessoa` = `a`.`id_pessoa`)))
        JOIN `leito` `l` ON ((`l`.`id_leito` = `i`.`id_leito`)))
    WHERE
        (`i`.`status` = 'ATIVA');
        
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
    ORDER BY `cp`.`data_hora` DESC;
    
    CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_procedimentos_pendentes` AS
    SELECT 
        `p`.`id_procedimento` AS `id_procedimento`,
        `p`.`id_ffa` AS `id_ffa`,
        `p`.`tipo` AS `tipo`,
        `p`.`status` AS `status`,
        `p`.`prioridade` AS `prioridade`,
        `p`.`criado_em` AS `criado_em`
    FROM
        `ffa_procedimento` `p`
    WHERE
        (`p`.`status` IN ('SOLICITADO' , 'EM_FILA', 'EM_EXECUCAO'));
        
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
        (`se`.`status` IN ('SOLICITADO' , 'EM_ANALISE'));
        
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
        JOIN `pessoa` `p` ON ((`p`.`id_pessoa` = `u`.`id_pessoa`)));
        
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
        (`us`.`ativo` = 1);
        
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
        (`us`.`ativo` = 1);
        
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
        (`u`.`ativo` = 1);
            