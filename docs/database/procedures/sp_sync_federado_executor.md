# sp_sync_federado_executor

Objetivo: sync federado executor conforme definida no dump SQL do sistema.

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
- SELECT: sincronizacao_federada_evento
- INSERT: (nenhuma)
- UPDATE: sincronizacao_federada_evento
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- IF

## Views Utilizadas
- v_estado_destino
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
- **Linha 5**: Declaracao de variavel local v_id_ffa.
- **Linha 6**: Declaracao de variavel local v_evento.
- **Linha 7**: Declaracao de variavel local v_estado_destino.
- **Linha 9**: /* Processa eventos não sincronizados */
- **Linha 11**: execucao de query SELECT para consulta de dados.
- **Linha 12**: INTO v_id_ffa, v_evento, v_estado_destino
- **Linha 13**: FROM sincronizacao_federada_evento
- **Linha 14**: WHERE sincronizado = 0
- **Linha 15**: ORDER BY criado_em
- **Linha 16**: LIMIT 1;
- **Linha 18**: /* Se não houver evento, encerra execução da procedure */
- **Linha 19**: Estrutura condicional de controle de fluxo.
- **Linha 20**: inicio do bloco de execucao.
- **Linha 21** (Comentario): apenas encerra o bloco
- **Linha 22**: Fim do bloco da procedure.
- **Linha 23**: Estrutura condicional de controle de fluxo.
- **Linha 25**: UPDATE sincronizacao_federada_evento
- **Linha 26**: atribuicao de valor Ã  variavel sincronizado.
- **Linha 27**: WHERE id_ffa = v_id_ffa
- **Linha 30**: Estrutura condicional de controle de fluxo.
- **Linha 32**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sync_federado_executor`()
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_id_ffa BIGINT;
    DECLARE v_evento VARCHAR(60);
    DECLARE v_estado_destino VARCHAR(60);

    /* Processa eventos não sincronizados */

    SELECT id_ffa, evento, estado_destino
    INTO v_id_ffa, v_evento, v_estado_destino
    FROM sincronizacao_federada_evento
    WHERE sincronizado = 0
    ORDER BY criado_em
    LIMIT 1;

    /* Se não houver evento, encerra execução da procedure */
    IF v_id_ffa IS NULL THEN
        BEGIN
            -- apenas encerra o bloco
        END;
    ELSE

        UPDATE sincronizacao_federada_evento
        SET sincronizado = 1
        WHERE id_ffa = v_id_ffa
        AND evento = v_evento;

    END IF;

END ;;
```

