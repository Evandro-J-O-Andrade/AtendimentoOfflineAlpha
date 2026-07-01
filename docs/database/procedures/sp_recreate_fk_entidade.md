# sp_recreate_fk_entidade

Objetivo: recreate fk entidade conforme definida no dump SQL do sistema.

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
- SELECT: information_schema, VARCHAR
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
- **Linha 24**: 'ALTER TABLE `', v_table,
- **Linha 25**: '` ADD CONSTRAINT `fk_', v_table, '_entidade` ',
- **Linha 26**: 'FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade`(`id_entidade`);'
- **Linha 27**: );
- **Linha 29**: PREPARE stmt FROM @sql;
- **Linha 30**: EXECUTE stmt;
- **Linha 31**: DEALLOCATE PREPARE stmt;
- **Linha 33**: END LOOP;
- **Linha 35**: CLOSE cur;
- **Linha 36**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_recreate_fk_entidade`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_table VARCHAR(255);

    DECLARE cur CURSOR FOR
        SELECT DISTINCT TABLE_NAME
        FROM information_schema.COLUMNS
        WHERE COLUMN_NAME = 'id_entidade'
          AND TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME <> 'saas_entidade';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_table;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET @sql = CONCAT(
            'ALTER TABLE `', v_table,
            '` ADD CONSTRAINT `fk_', v_table, '_entidade` ',
            'FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade`(`id_entidade`);'
        );

        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

    END LOOP;

    CLOSE cur;
END ;;
```

