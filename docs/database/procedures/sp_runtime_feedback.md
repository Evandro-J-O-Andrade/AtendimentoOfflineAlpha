# sp_runtime_feedback

Objetivo: runtime feedback conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_contexto | VARCHAR(50) | IN | |
| p_codigo_erro | VARCHAR(50) | IN | |
| p_mensagem | TEXT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: atendimento_evento_ledger
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
- JSON_OBJECT
- NOW

## Views Utilizadas
- (nenhuma)

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
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: inicio do bloco de execucao.
- **Linha 10**: Insere um novo registro na tabela atendimento_evento_ledger.
- **Linha 11**: id_sessao_usuario,
- **Linha 12**: dominio_evento,
- **Linha 13**: codigo_evento,
- **Linha 14**: payload_evento
- **Linha 15**: fechamento da lista de Parametros.
- **Linha 16**: VALUES (
- **Linha 17**: p_id_sessao_usuario,
- **Linha 18**: 'ERRO_RUNTIME',
- **Linha 19**: p_codigo_erro,
- **Linha 20**: JSON_OBJECT(
- **Linha 21**: 'contexto', p_contexto,
- **Linha 22**: 'mensagem', p_mensagem,
- **Linha 23**: 'timestamp', NOW(6)
- **Linha 24**: fechamento da lista de Parametros.
- **Linha 25**: );
- **Linha 27**: execucao de query SELECT para consulta de dados.
- **Linha 29**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_runtime_feedback`(
    IN p_id_sessao_usuario BIGINT,
    IN p_contexto VARCHAR(50),
    IN p_codigo_erro VARCHAR(50),
    IN p_mensagem TEXT
)
    SQL SECURITY INVOKER
BEGIN

    INSERT INTO atendimento_evento_ledger (
        id_sessao_usuario,
        dominio_evento,
        codigo_evento,
        payload_evento
    )
    VALUES (
        p_id_sessao_usuario,
        'ERRO_RUNTIME',
        p_codigo_erro,
        JSON_OBJECT(
            'contexto', p_contexto,
            'mensagem', p_mensagem,
            'timestamp', NOW(6)
        )
    );

    SELECT CONCAT('FALHA CONTROLADA: ', p_mensagem) AS feedback_runtime;

END ;;
```

