# sp_runtime_resiliente_execucao

Objetivo: runtime resiliente execucao conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_contexto | VARCHAR(50) | IN | |
| p_sql_operacao | TEXT | IN | |

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
- sp_runtime_feedback

## Functions Utilizadas
- (nenhuma)

## Views Utilizadas
- v_error_code

## Eventos Gerados
- (nenhum)

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: Sim
- Commit: Sim

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: inicio do bloco de execucao.
- **Linha 9**: Declaracao de variavel local v_error_code.
- **Linha 10**: Declaracao de variavel local v_error_msg.
- **Linha 12**: Declaracao de variavel local EXIT.
- **Linha 13**: inicio do bloco de execucao.
- **Linha 15**: GET DIAGNOSTICS CONDITION 1
- **Linha 16**: v_error_code = RETURNED_SQLSTATE,
- **Linha 17**: v_error_msg = MESSAGE_TEXT;
- **Linha 19**: Invoca a procedure sp_runtime_feedback.
- **Linha 20**: p_id_sessao_usuario,
- **Linha 21**: p_contexto,
- **Linha 22**: v_error_code,
- **Linha 23**: v_error_msg
- **Linha 24**: );
- **Linha 26**: ROLLBACK;
- **Linha 28**: Fim do bloco da procedure.
- **Linha 30**: START TRANSACTION;
- **Linha 32**: SET @runtime_sql = p_sql_operacao;
- **Linha 34**: PREPARE stmt FROM @runtime_sql;
- **Linha 35**: EXECUTE stmt;
- **Linha 36**: DEALLOCATE PREPARE stmt;
- **Linha 38**: COMMIT;
- **Linha 40**: execucao de query SELECT para consulta de dados.
- **Linha 42**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_runtime_resiliente_execucao`(
    IN p_id_sessao_usuario BIGINT,
    IN p_contexto VARCHAR(50),
    IN p_sql_operacao TEXT
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_error_code VARCHAR(50);
    DECLARE v_error_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN

        GET DIAGNOSTICS CONDITION 1
            v_error_code = RETURNED_SQLSTATE,
            v_error_msg = MESSAGE_TEXT;

        CALL sp_runtime_feedback(
            p_id_sessao_usuario,
            p_contexto,
            v_error_code,
            v_error_msg
        );

        ROLLBACK;

    END;

    START TRANSACTION;

    SET @runtime_sql = p_sql_operacao;

    PREPARE stmt FROM @runtime_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    COMMIT;

    SELECT 'EXECUCAO_ASSISTENCIAL_OK' AS runtime_status;

END ;;
```

