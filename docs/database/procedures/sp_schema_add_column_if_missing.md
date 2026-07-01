# sp_schema_add_column_if_missing

Objetivo: schema add column if missing conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_table_schema | VARCHAR(64) | IN | |
| p_table_name | VARCHAR(64) | IN | |
| p_column_name | VARCHAR(64) | IN | |
| p_column_ddl | TEXT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: information_schema
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
- (nenhuma)

## Eventos Gerados
- (nenhum)

## Tratamento de Erros

- Sem Tratamento de erro explicito detectado.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: nao detectado
- Commit: nao detectado

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: main: BEGIN
- **Linha 8**: Declaracao de variavel local v_cnt.
- **Linha 9**: Declaracao de variavel local v_sql.
- **Linha 11**: execucao de query SELECT para consulta de dados.
- **Linha 12**: INTO v_cnt
- **Linha 13**: FROM information_schema.COLUMNS c
- **Linha 14**: WHERE c.TABLE_SCHEMA = p_table_schema
- **Linha 18**: Estrutura condicional de controle de fluxo.
- **Linha 19**: atribuicao de valor Ã  variavel v_sql.
- **Linha 20**: SET @ddl_sql = v_sql;
- **Linha 21**: PREPARE stmt FROM @ddl_sql;
- **Linha 22**: EXECUTE stmt;
- **Linha 23**: DEALLOCATE PREPARE stmt;
- **Linha 24**: SET @ddl_sql = NULL;
- **Linha 25**: Estrutura condicional de controle de fluxo.
- **Linha 26**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_schema_add_column_if_missing`(
    IN p_table_schema VARCHAR(64),
    IN p_table_name   VARCHAR(64),
    IN p_column_name  VARCHAR(64),
    IN p_column_ddl   TEXT
)
main: BEGIN
    DECLARE v_cnt INT DEFAULT 0;
    DECLARE v_sql TEXT;

    SELECT COUNT(*)
      INTO v_cnt
      FROM information_schema.COLUMNS c
     WHERE c.TABLE_SCHEMA = p_table_schema
       AND c.TABLE_NAME   = p_table_name
       AND c.COLUMN_NAME  = p_column_name;

    IF v_cnt = 0 THEN
        SET v_sql = CONCAT('ALTER TABLE `', p_table_schema, '`.`', p_table_name, '` ADD COLUMN ', p_column_ddl);
        SET @ddl_sql = v_sql;
        PREPARE stmt FROM @ddl_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SET @ddl_sql = NULL;
    END IF;
END ;;
```

