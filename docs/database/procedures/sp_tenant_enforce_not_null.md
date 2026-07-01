# sp_tenant_enforce_not_null

Objetivo: tenant enforce not null conforme definida no dump SQL do sistema.

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
- SELECT: AND, information_schema, VARCHAR
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
- COUNT
- IF
- IFNULL

## Views Utilizadas
- v_table

## Eventos Gerados
- (nenhum)

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: nao detectado
- Commit: nao detectado

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: inicio do bloco de execucao.
- **Linha 3**: Declaracao de variavel local done.
- **Linha 4**: Declaracao de variavel local v_table.
- **Linha 5**: Declaracao de variavel local v_nulls.
- **Linha 6**: Declaracao de variavel local v_is_pk.
- **Linha 8**: Declaracao de variavel local cur.
- **Linha 9**: execucao de query SELECT para consulta de dados.
- **Linha 10**: FROM information_schema.COLUMNS
- **Linha 11**: WHERE TABLE_SCHEMA = DATABASE()
- **Linha 14**: Declaracao de variavel local CONTINUE.
- **Linha 16**: OPEN cur;
- **Linha 18**: Estrutura de repeticao/controle de loop.
- **Linha 19**: FETCH cur INTO v_table;
- **Linha 20**: Estrutura condicional de controle de fluxo.
- **Linha 21**: Estrutura de repeticao/controle de loop.
- **Linha 22**: Estrutura condicional de controle de fluxo.
- **Linha 24** (Comentario): ==========================================
- **Linha 25** (Comentario): CONTAR NULLS (FORMA CORRETA)
- **Linha 26** (Comentario): ==========================================
- **Linha 27**: SET @sql_check = CONCAT(
- **Linha 28**: 'SELECT COUNT(*) INTO @v_nulls FROM `', v_table, '` WHERE id_entidade IS NULL'
- **Linha 29**: );
- **Linha 31**: PREPARE stmt FROM @sql_check;
- **Linha 32**: EXECUTE stmt;
- **Linha 33**: DEALLOCATE PREPARE stmt;
- **Linha 35**: atribuicao de valor Ã  variavel v_nulls.
- **Linha 37** (Comentario): ==========================================
- **Linha 38** (Comentario): VERIFICAR SE FAZ PARTE DA PK
- **Linha 39** (Comentario): ==========================================
- **Linha 40**: execucao de query SELECT para consulta de dados.
- **Linha 41**: INTO v_is_pk
- **Linha 42**: FROM information_schema.KEY_COLUMN_USAGE
- **Linha 43**: WHERE TABLE_SCHEMA = DATABASE()
- **Linha 48** (Comentario): ==========================================
- **Linha 49** (Comentario): APLICAR NOT NULL SOMENTE SE SEGURO
- **Linha 50** (Comentario): ==========================================
- **Linha 51**: Estrutura condicional de controle de fluxo.
- **Linha 53**: SET @sql = CONCAT(
- **Linha 54**: 'ALTER TABLE `', v_table,
- **Linha 55**: '` MODIFY id_entidade BIGINT UNSIGNED NOT NULL;'
- **Linha 56**: );
- **Linha 58**: PREPARE stmt FROM @sql;
- **Linha 59**: EXECUTE stmt;
- **Linha 60**: DEALLOCATE PREPARE stmt;
- **Linha 62**: Estrutura condicional de controle de fluxo.
- **Linha 64**: END LOOP;
- **Linha 66**: CLOSE cur;
- **Linha 67**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_tenant_enforce_not_null`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_table VARCHAR(255);
    DECLARE v_nulls BIGINT DEFAULT 0;
    DECLARE v_is_pk INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT DISTINCT TABLE_NAME
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND COLUMN_NAME = 'id_entidade';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    loop_tables: LOOP
        FETCH cur INTO v_table;
        IF done THEN 
            LEAVE loop_tables; 
        END IF;

        -- ==========================================
        -- CONTAR NULLS (FORMA CORRETA)
        -- ==========================================
        SET @sql_check = CONCAT(
            'SELECT COUNT(*) INTO @v_nulls FROM `', v_table, '` WHERE id_entidade IS NULL'
        );

        PREPARE stmt FROM @sql_check;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        SET v_nulls = IFNULL(@v_nulls, 0);

        -- ==========================================
        -- VERIFICAR SE FAZ PARTE DA PK
        -- ==========================================
        SELECT COUNT(*)
        INTO v_is_pk
        FROM information_schema.KEY_COLUMN_USAGE
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = v_table
          AND COLUMN_NAME = 'id_entidade'
          AND CONSTRAINT_NAME = 'PRIMARY';

        -- ==========================================
        -- APLICAR NOT NULL SOMENTE SE SEGURO
        -- ==========================================
        IF v_nulls = 0 THEN

            SET @sql = CONCAT(
                'ALTER TABLE `', v_table,
                '` MODIFY id_entidade BIGINT UNSIGNED NOT NULL;'
            );

            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

        END IF;

    END LOOP;

    CLOSE cur;
END ;;
```

