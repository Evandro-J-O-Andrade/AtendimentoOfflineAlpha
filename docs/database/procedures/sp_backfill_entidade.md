# sp_backfill_entidade

Objetivo: backfill entidade conforme definida no dump SQL do sistema.

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
- SELECT: information_schema, usuario, VARCHAR
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
- IF

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
- **Linha 6**: Declaracao de variavel local cur.
- **Linha 7**: execucao de query SELECT para consulta de dados.
- **Linha 8**: FROM information_schema.COLUMNS
- **Linha 9**: WHERE COLUMN_NAME = 'id_entidade'
- **Linha 13**: Declaracao de variavel local CONTINUE.
- **Linha 15**: OPEN cur;
- **Linha 17**: read_loop: LOOP
- **Linha 18**: FETCH cur INTO v_table;
- **Linha 19**: Estrutura condicional de controle de fluxo.
- **Linha 20**: Estrutura de repeticao/controle de loop.
- **Linha 21**: Estrutura condicional de controle de fluxo.
- **Linha 23**: SET @sql = CONCAT(
- **Linha 24**: 'UPDATE `', v_table, '` t ',
- **Linha 25**: 'JOIN usuario u ON u.id_usuario = t.id_usuario ',
- **Linha 26**: 'SET t.id_entidade = u.id_entidade ',
- **Linha 27**: 'WHERE t.id_entidade IS NULL;'
- **Linha 28**: );
- **Linha 30**: PREPARE stmt FROM @sql;
- **Linha 31**: EXECUTE stmt;
- **Linha 32**: DEALLOCATE PREPARE stmt;
- **Linha 34**: END LOOP;
- **Linha 36**: CLOSE cur;
- **Linha 37**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_backfill_entidade`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_table VARCHAR(255);

    DECLARE cur CURSOR FOR
        SELECT TABLE_NAME
        FROM information_schema.COLUMNS
        WHERE COLUMN_NAME = 'id_entidade'
          AND TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME <> 'usuario'; -- usuario já é fonte

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_table;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET @sql = CONCAT(
            'UPDATE `', v_table, '` t ',
            'JOIN usuario u ON u.id_usuario = t.id_usuario ',
            'SET t.id_entidade = u.id_entidade ',
            'WHERE t.id_entidade IS NULL;'
        );

        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

    END LOOP;

    CLOSE cur;
END ;;
```

