# sp_executor_assistencial_runtime

Objetivo: executor assistencial runtime conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_id_referencia | BIGINT | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: (nenhuma)
- UPDATE: ffa
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- IF
- JSON_OBJECT
- NOW
- UPPER

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
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: inicio do bloco de execucao.
- **Linha 10**: Estrutura condicional de controle de fluxo.
- **Linha 12**: UPDATE ffa
- **Linha 13**: atribuicao de valor Ã  variavel contexto_fluxo.
- **Linha 14**: atualizado_em = NOW(6)
- **Linha 15**: WHERE id_ffa = p_id_referencia;
- **Linha 17**: Estrutura condicional de controle de fluxo.
- **Linha 19**: UPDATE ffa
- **Linha 20**: atribuicao de valor Ã  variavel contexto_fluxo.
- **Linha 21**: atualizado_em = NOW(6)
- **Linha 22**: WHERE id_ffa = p_id_referencia;
- **Linha 24**: Estrutura condicional de controle de fluxo.
- **Linha 26**: UPDATE ffa
- **Linha 27**: atribuicao de valor Ã  variavel contexto_fluxo.
- **Linha 28**: atualizado_em = NOW(6)
- **Linha 29**: WHERE id_ffa = p_id_referencia;
- **Linha 31**: Estrutura condicional de controle de fluxo.
- **Linha 33**: UPDATE ffa
- **Linha 34**: atribuicao de valor Ã  variavel contexto_fluxo.
- **Linha 35**: atualizado_em = NOW(6)
- **Linha 36**: WHERE id_ffa = p_id_referencia;
- **Linha 38**: Estrutura condicional de controle de fluxo.
- **Linha 40**: execucao de query SELECT para consulta de dados.
- **Linha 41**: 'status','SUCCESS',
- **Linha 42**: 'acao',p_acao
- **Linha 43**: ) AS result;
- **Linha 45**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_assistencial_runtime`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN

    IF UPPER(p_acao) = 'TRIAGEM_FINALIZAR' THEN

        UPDATE ffa
        SET contexto_fluxo = 'AGUARDANDO_ATENDIMENTO',
            atualizado_em = NOW(6)
        WHERE id_ffa = p_id_referencia;

    ELSEIF UPPER(p_acao) = 'ATENDIMENTO_INICIAR' THEN

        UPDATE ffa
        SET contexto_fluxo = 'EM_ATENDIMENTO',
            atualizado_em = NOW(6)
        WHERE id_ffa = p_id_referencia;

    ELSEIF UPPER(p_acao) = 'ATENDIMENTO_FINALIZAR' THEN

        UPDATE ffa
        SET contexto_fluxo = 'ALTA',
            atualizado_em = NOW(6)
        WHERE id_ffa = p_id_referencia;

    ELSEIF UPPER(p_acao) = 'REGISTRAR_EVASAO' THEN

        UPDATE ffa
        SET contexto_fluxo = 'EVASAO',
            atualizado_em = NOW(6)
        WHERE id_ffa = p_id_referencia;

    END IF;

    SELECT JSON_OBJECT(
        'status','SUCCESS',
        'acao',p_acao
    ) AS result;

END ;;
```

