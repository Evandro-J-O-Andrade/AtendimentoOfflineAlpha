# sp_executor_assistencial_triagem_finalizar

Objetivo: executor assistencial triagem finalizar conforme definida no dump SQL do sistema.

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
- INSERT: triagem
- UPDATE: ffa
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- JSON_EXTRACT
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
- **Linha 10**: Insere um novo registro na tabela triagem.
- **Linha 11**: id_ffa,
- **Linha 12**: temperatura,
- **Linha 13**: pressao,
- **Linha 14**: criado_em
- **Linha 15**: ) VALUES (
- **Linha 16**: p_id_ffa,
- **Linha 17**: JSON_EXTRACT(p_payload, '$.temperatura'),
- **Linha 18**: JSON_EXTRACT(p_payload, '$.pressao'),
- **Linha 19**: NOW(6)
- **Linha 20**: );
- **Linha 22**: UPDATE ffa
- **Linha 23**: atribuicao de valor Ã  variavel contexto_fluxo.
- **Linha 24**: atualizado_em = NOW(6)
- **Linha 25**: WHERE id_ffa = p_id_ffa;
- **Linha 27**: execucao de query SELECT para consulta de dados.
- **Linha 28**: 'status','SUCCESS',
- **Linha 29**: 'estado','AGUARDANDO_ATENDIMENTO'
- **Linha 30**: ) AS result;
- **Linha 32**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_assistencial_triagem_finalizar`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_ffa BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN

    INSERT INTO triagem (
        id_ffa,
        temperatura,
        pressao,
        criado_em
    ) VALUES (
        p_id_ffa,
        JSON_EXTRACT(p_payload, '$.temperatura'),
        JSON_EXTRACT(p_payload, '$.pressao'),
        NOW(6)
    );

    UPDATE ffa
    SET contexto_fluxo = 'AGUARDANDO_ATENDIMENTO',
        atualizado_em = NOW(6)
    WHERE id_ffa = p_id_ffa;

    SELECT JSON_OBJECT(
        'status','SUCCESS',
        'estado','AGUARDANDO_ATENDIMENTO'
    ) AS result;

END ;;
```

