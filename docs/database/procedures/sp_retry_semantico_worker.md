# sp_retry_semantico_worker

Objetivo: retry semantico worker conforme definida no dump SQL do sistema.

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
- SELECT: retry_semantico_controle
- INSERT: (nenhuma)
- UPDATE: retry_semantico_controle
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CURRENT_TIMESTAMP
- DATE_ADD
- IF
- POWER

## Views Utilizadas
- v_evento

## Eventos Gerados
- evento

## Tratamento de Erros

- Sem Tratamento de erro explicito detectado.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: nao detectado
- Commit: nao detectado

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: SQL SECURITY INVOKER
- **Linha 3**: inicio do bloco de execucao.
- **Linha 5**: Declaracao de variavel local v_id_retry.
- **Linha 6**: Declaracao de variavel local v_id_ffa.
- **Linha 7**: Declaracao de variavel local v_evento.
- **Linha 9**: execucao de query SELECT para consulta de dados.
- **Linha 10**: INTO v_id_retry, v_id_ffa, v_evento
- **Linha 11**: FROM retry_semantico_controle
- **Linha 12**: WHERE bloqueado = 0
- **Linha 16**: ORDER BY proxima_tentativa ASC
- **Linha 17**: LIMIT 1;
- **Linha 19**: Estrutura condicional de controle de fluxo.
- **Linha 20**: inicio do bloco de execucao.
- **Linha 21**: Fim do bloco da procedure.
- **Linha 22**: Estrutura condicional de controle de fluxo.
- **Linha 24**: /* Aqui você chamaria novamente o executor hardcore */
- **Linha 26**: UPDATE retry_semantico_controle
- **Linha 27**: atribuicao de valor Ã  variavel tentativas.
- **Linha 28**: proxima_tentativa = DATE_ADD(
- **Linha 29**: CURRENT_TIMESTAMP(6),
- **Linha 30**: INTERVAL POWER(2, tentativas) MINUTE
- **Linha 31**: fechamento da lista de Parametros.
- **Linha 32**: WHERE id_retry = v_id_retry;
- **Linha 34**: Estrutura condicional de controle de fluxo.
- **Linha 36**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_retry_semantico_worker`()
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_id_retry BIGINT;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_evento VARCHAR(60);

    SELECT id_retry, id_ffa, evento
    INTO v_id_retry, v_id_ffa, v_evento
    FROM retry_semantico_controle
    WHERE bloqueado = 0
    AND (proxima_tentativa IS NULL
         OR proxima_tentativa <= CURRENT_TIMESTAMP(6))
    AND tentativas < max_tentativas
    ORDER BY proxima_tentativa ASC
    LIMIT 1;

    IF v_id_retry IS NULL THEN
        BEGIN
        END;
    ELSE

        /* Aqui você chamaria novamente o executor hardcore */

        UPDATE retry_semantico_controle
        SET tentativas = tentativas + 1,
            proxima_tentativa = DATE_ADD(
                CURRENT_TIMESTAMP(6),
                INTERVAL POWER(2, tentativas) MINUTE
            )
        WHERE id_retry = v_id_retry;

    END IF;

END ;;
```

