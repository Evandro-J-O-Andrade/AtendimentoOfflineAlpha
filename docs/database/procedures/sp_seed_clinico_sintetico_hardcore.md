# sp_seed_clinico_sintetico_hardcore

Objetivo: seed clinico sintetico hardcore conforme definida no dump SQL do sistema.

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
- SELECT: (nenhuma)
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- (nenhum)

## Tratamento de Erros

- Sem Tratamento de erro explicito detectado.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: nao detectado
- Commit: Sim

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: inicio do bloco de execucao.
- **Linha 4**: Declaracao de variavel local v_i.
- **Linha 5**: Declaracao de variavel local v_sql.
- **Linha 7**: START TRANSACTION;
- **Linha 9**: Estrutura de repeticao/controle de loop.
- **Linha 11**: atribuicao de valor Ã  variavel v_sql.
- **Linha 12**: 'INSERT IGNORE INTO paciente (nome) VALUES (',
- **Linha 13**: QUOTE(CONCAT('PACIENTE_CLINICO_SYN_', LPAD(v_i,6,'0'))),
- **Linha 14**: ')'
- **Linha 15**: );
- **Linha 17**: SET @stmt = v_sql;
- **Linha 19**: PREPARE stmt FROM @stmt;
- **Linha 20**: EXECUTE stmt;
- **Linha 21**: DEALLOCATE PREPARE stmt;
- **Linha 23**: atribuicao de valor Ã  variavel v_i.
- **Linha 25**: END WHILE;
- **Linha 27**: COMMIT;
- **Linha 29**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_seed_clinico_sintetico_hardcore`()
BEGIN

    DECLARE v_i INT DEFAULT 1;
    DECLARE v_sql TEXT;

    START TRANSACTION;

    WHILE v_i <= 10000 DO

        SET v_sql = CONCAT(
            'INSERT IGNORE INTO paciente (nome) VALUES (',
            QUOTE(CONCAT('PACIENTE_CLINICO_SYN_', LPAD(v_i,6,'0'))),
            ')'
        );

        SET @stmt = v_sql;

        PREPARE stmt FROM @stmt;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        SET v_i = v_i + 1;

    END WHILE;

    COMMIT;

END ;;
```

