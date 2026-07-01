# sp_fix_fk_unidade

Objetivo: fix fk unidade conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| - | - | - | nenhum parÃ¢metro declarado. |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: INFORMATION_SCHEMA, VARCHAR
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
- COUNT
- IF

## Views Utilizadas
- v_table

## Eventos Gerados
- evento
- ledger_evento

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: nao detectado
- Commit: nao detectado

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: inicio do bloco de execucao.
- **Linha 4**: Declaracao de variavel local done.
- **Linha 5**: Declaracao de variavel local v_table.
- **Linha 7** (Comentario): cursor com suas tabelas
- **Linha 8**: Declaracao de variavel local cur.
- **Linha 9**: execucao de query SELECT para consulta de dados.
- **Linha 10**: FROM (
- **Linha 11**: execucao de query SELECT para consulta de dados.
- **Linha 12**: execucao de query SELECT para consulta de dados.
- **Linha 13**: execucao de query SELECT para consulta de dados.
- **Linha 14**: execucao de query SELECT para consulta de dados.
- **Linha 15**: execucao de query SELECT para consulta de dados.
- **Linha 16**: execucao de query SELECT para consulta de dados.
- **Linha 17**: execucao de query SELECT para consulta de dados.
- **Linha 18**: execucao de query SELECT para consulta de dados.
- **Linha 19**: execucao de query SELECT para consulta de dados.
- **Linha 20**: execucao de query SELECT para consulta de dados.
- **Linha 21**: execucao de query SELECT para consulta de dados.
- **Linha 22**: execucao de query SELECT para consulta de dados.
- **Linha 23**: execucao de query SELECT para consulta de dados.
- **Linha 24**: execucao de query SELECT para consulta de dados.
- **Linha 25**: execucao de query SELECT para consulta de dados.
- **Linha 26**: execucao de query SELECT para consulta de dados.
- **Linha 27**: execucao de query SELECT para consulta de dados.
- **Linha 28**: execucao de query SELECT para consulta de dados.
- **Linha 29**: execucao de query SELECT para consulta de dados.
- **Linha 30**: execucao de query SELECT para consulta de dados.
- **Linha 31**: execucao de query SELECT para consulta de dados.
- **Linha 32**: execucao de query SELECT para consulta de dados.
- **Linha 33**: execucao de query SELECT para consulta de dados.
- **Linha 34**: execucao de query SELECT para consulta de dados.
- **Linha 35**: execucao de query SELECT para consulta de dados.
- **Linha 36**: execucao de query SELECT para consulta de dados.
- **Linha 37**: execucao de query SELECT para consulta de dados.
- **Linha 38**: execucao de query SELECT para consulta de dados.
- **Linha 39**: execucao de query SELECT para consulta de dados.
- **Linha 40**: execucao de query SELECT para consulta de dados.
- **Linha 41**: execucao de query SELECT para consulta de dados.
- **Linha 42**: execucao de query SELECT para consulta de dados.
- **Linha 43**: execucao de query SELECT para consulta de dados.
- **Linha 44**: execucao de query SELECT para consulta de dados.
- **Linha 45**: execucao de query SELECT para consulta de dados.
- **Linha 46**: execucao de query SELECT para consulta de dados.
- **Linha 47**: execucao de query SELECT para consulta de dados.
- **Linha 48**: execucao de query SELECT para consulta de dados.
- **Linha 49**: execucao de query SELECT para consulta de dados.
- **Linha 50**: execucao de query SELECT para consulta de dados.
- **Linha 51**: execucao de query SELECT para consulta de dados.
- **Linha 52**: execucao de query SELECT para consulta de dados.
- **Linha 53**: execucao de query SELECT para consulta de dados.
- **Linha 54**: execucao de query SELECT para consulta de dados.
- **Linha 55**: execucao de query SELECT para consulta de dados.
- **Linha 56**: ) t;
- **Linha 58**: Declaracao de variavel local CONTINUE.
- **Linha 60**: OPEN cur;
- **Linha 62**: Estrutura de repeticao/controle de loop.
- **Linha 64**: FETCH cur INTO v_table;
- **Linha 65**: Estrutura condicional de controle de fluxo.
- **Linha 66**: Estrutura de repeticao/controle de loop.
- **Linha 67**: Estrutura condicional de controle de fluxo.
- **Linha 69** (Comentario): 1. NORMALIZA DADOS
- **Linha 70**: SET @sql1 = CONCAT('
- **Linha 71**: UPDATE ', v_table, '
- **Linha 72**: atribuicao de valor Ã  variavel id_unidade.
- **Linha 73**: WHERE id_unidade IS NULL
- **Linha 76**: ');
- **Linha 78**: PREPARE stmt FROM @sql1;
- **Linha 79**: EXECUTE stmt;
- **Linha 80**: DEALLOCATE PREPARE stmt;
- **Linha 82** (Comentario): 2. AJUSTA TIPO
- **Linha 83**: SET @sql2 = CONCAT('
- **Linha 84**: ALTER TABLE ', v_table, '
- **Linha 85**: MODIFY COLUMN id_unidade BIGINT UNSIGNED NOT NULL
- **Linha 86**: ');
- **Linha 88**: PREPARE stmt FROM @sql2;
- **Linha 89**: EXECUTE stmt;
- **Linha 90**: DEALLOCATE PREPARE stmt;
- **Linha 92** (Comentario): 3. CRIA FK SE NÃO EXISTIR
- **Linha 93**: SET @fk = CONCAT('fk_', v_table, '_unidade');
- **Linha 95**: SET @check_fk = CONCAT('
- **Linha 96**: execucao de query SELECT para consulta de dados.
- **Linha 97**: FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
- **Linha 98**: WHERE CONSTRAINT_SCHEMA = DATABASE()
- **Linha 101**: ');
- **Linha 103**: PREPARE stmt FROM @check_fk;
- **Linha 104**: EXECUTE stmt;
- **Linha 105**: DEALLOCATE PREPARE stmt;
- **Linha 107**: Estrutura condicional de controle de fluxo.
- **Linha 109**: SET @sql3 = CONCAT('
- **Linha 110**: ALTER TABLE ', v_table, '
- **Linha 111**: ADD CONSTRAINT ', @fk, '
- **Linha 112**: FOREIGN KEY (id_unidade)
- **Linha 113**: REFERENCES unidade(id_unidade)
- **Linha 114**: ');
- **Linha 116**: PREPARE stmt FROM @sql3;
- **Linha 117**: EXECUTE stmt;
- **Linha 118**: DEALLOCATE PREPARE stmt;
- **Linha 120**: Estrutura condicional de controle de fluxo.
- **Linha 122**: END LOOP;
- **Linha 124**: CLOSE cur;
- **Linha 126**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
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
```

