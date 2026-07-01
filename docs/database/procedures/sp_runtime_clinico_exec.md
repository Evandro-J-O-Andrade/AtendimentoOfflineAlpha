# sp_runtime_clinico_exec

Objetivo: runtime clinico exec conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_contexto | VARCHAR(60) | IN | |
| p_recurso | VARCHAR(120) | IN | |
| p_acao | VARCHAR(60) | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: atendimento_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
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
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: fechamento da lista de Parametros.
- **Linha 8**: inicio do bloco de execucao.
- **Linha 10**: Insere um novo registro na tabela atendimento_evento.
- **Linha 11**: id_sessao_usuario,
- **Linha 12**: contexto,
- **Linha 13**: recurso,
- **Linha 14**: acao,
- **Linha 15**: payload,
- **Linha 16**: criado_em
- **Linha 17**: fechamento da lista de Parametros.
- **Linha 18**: VALUES (
- **Linha 19**: p_id_sessao_usuario,
- **Linha 20**: p_contexto,
- **Linha 21**: p_recurso,
- **Linha 22**: p_acao,
- **Linha 23**: p_payload,
- **Linha 24**: NOW()
- **Linha 25**: );
- **Linha 27**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_runtime_clinico_exec`(
    IN p_id_sessao_usuario BIGINT,
    IN p_contexto VARCHAR(60),
    IN p_recurso VARCHAR(120),
    IN p_acao VARCHAR(60),
    IN p_payload JSON
)
BEGIN

    INSERT INTO atendimento_evento (
        id_sessao_usuario,
        contexto,
        recurso,
        acao,
        payload,
        criado_em
    )
    VALUES (
        p_id_sessao_usuario,
        p_contexto,
        p_recurso,
        p_acao,
        p_payload,
        NOW()
    );

END ;;
```

