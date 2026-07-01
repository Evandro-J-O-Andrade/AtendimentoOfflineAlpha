CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fix_fk_unidade`()
BEGIN

    DECLARE done INT DEFAULT FALSE;
    DECLARE v_table VARCHAR(255);

    -- cursor com suas tabelas
    DECLARE cur CURSOR FOR
        SELECT table_name
        FROM (
            SELECT 'codigo_prefixo_regra' AS table_name UNION
            SELECT 'config_leitos' UNION
            SELECT 'config_locais' UNION
            SELECT 'config_sistema' UNION
            SELECT 'coordenador_estado_global' UNION
            SELECT 'documento_emissao' UNION
            SELECT 'escala_medica' UNION
            SELECT 'escala_plantao' UNION
            SELECT 'escala_plantao_atual' UNION
            SELECT 'escala_profissional' UNION
            SELECT 'estoque_local' UNION
            SELECT 'estoque_movimento' UNION
            SELECT 'estoque_saldo' UNION
            SELECT 'estoque_saldo_central' UNION
            SELECT 'estoque_saldo_master' UNION
            SELECT 'evento_geral' UNION
            SELECT 'faturamento_conta' UNION
            SELECT 'ffa_item' UNION
            SELECT 'funcionario_unidade' UNION
            SELECT 'gaso_solicitacao' UNION
            SELECT 'guardiao_runtime_final' UNION
            SELECT 'internacao_movimentacao' UNION
            SELECT 'ledger_evento_sincronizacao' UNION
            SELECT 'ledger_evento_sincronizacao_local' UNION
            SELECT 'ledger_global_sincronismo' UNION
            SELECT 'painel' UNION
            SELECT 'plantao' UNION
            SELECT 'plantao_escala' UNION
            SELECT 'produtividade_evento' UNION
            SELECT 'reg_export_lote' UNION
            SELECT 'remocao' UNION
            SELECT 'runtime_contexto' UNION
            SELECT 'runtime_edge_evento' UNION
            SELECT 'runtime_invariant_log' UNION
            SELECT 'runtime_sync_log' UNION
            SELECT 'sala_notificacao' UNION
            SELECT 'senha_sequencia' UNION
            SELECT 'servico_agendamento' UNION
            SELECT 'sessao_usuario' UNION
            SELECT 'setor' UNION
            SELECT 'totem' UNION
            SELECT 'tv_rotativo' UNION
            SELECT 'usuario_contexto' UNION
            SELECT 'usuario_unidade' UNION
            SELECT 'viatura'
        ) t;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    loop_tables: LOOP

        FETCH cur INTO v_table;
        IF done THEN
            LEAVE loop_tables;
        END IF;

        -- 1. NORMALIZA DADOS
        SET @sql1 = CONCAT('
            UPDATE ', v_table, '
            SET id_unidade = 1
            WHERE id_unidade IS NULL
               OR id_unidade <= 0
               OR id_unidade REGEXP "[^0-9]"
        ');

        PREPARE stmt FROM @sql1;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        -- 2. AJUSTA TIPO
        SET @sql2 = CONCAT('
            ALTER TABLE ', v_table, '
            MODIFY COLUMN id_unidade BIGINT UNSIGNED NOT NULL
        ');

        PREPARE stmt FROM @sql2;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        -- 3. CRIA FK SE NÃO EXISTIR
        SET @fk = CONCAT('fk_', v_table, '_unidade');

        SET @check_fk = CONCAT('
            SELECT COUNT(*) INTO @fk_exists
            FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            WHERE CONSTRAINT_SCHEMA = DATABASE()
              AND TABLE_NAME = "', v_table, '"
              AND CONSTRAINT_NAME = "', @fk, '"
        ');

        PREPARE stmt FROM @check_fk;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        IF @fk_exists = 0 THEN

            SET @sql3 = CONCAT('
                ALTER TABLE ', v_table, '
                ADD CONSTRAINT ', @fk, '
                FOREIGN KEY (id_unidade)
                REFERENCES unidade(id_unidade)
            ');

            PREPARE stmt FROM @sql3;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

        END IF;

    END LOOP;

    CLOSE cur;

END ;;