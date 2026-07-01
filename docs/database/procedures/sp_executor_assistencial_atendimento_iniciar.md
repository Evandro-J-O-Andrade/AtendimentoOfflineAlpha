# sp_executor_assistencial_atendimento_iniciar

Objetivo: executor assistencial atendimento iniciar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_id_ffa | BIGINT | IN | |
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
- JSON_OBJECT
- NOW

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
- **Linha 10**: UPDATE ffa
- **Linha 11**: atribuicao de valor Ã  variavel contexto_fluxo.
- **Linha 12**: atualizado_em = NOW(6)
- **Linha 13**: WHERE id_ffa = p_id_ffa;
- **Linha 15**: execucao de query SELECT para consulta de dados.
- **Linha 16**: 'status','SUCCESS',
- **Linha 17**: 'estado','EM_ATENDIMENTO'
- **Linha 18**: ) AS result;
- **Linha 20**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_assistencial_atendimento_iniciar`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_ffa BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN

    UPDATE ffa
    SET contexto_fluxo = 'EM_ATENDIMENTO',
        atualizado_em = NOW(6)
    WHERE id_ffa = p_id_ffa;

    SELECT JSON_OBJECT(
        'status','SUCCESS',
        'estado','EM_ATENDIMENTO'
    ) AS result;

END ;;
```

