# sp_atendimento_finalizar_evasao

Objetivo: atendimento finalizar evasao conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_ffa | BIGINT | IN | |
| p_observacao | TEXT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: (nenhuma)
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_atendimento_transicionar
- sp_sessao_assert

## Functions Utilizadas
- NOW
- RESIGNAL

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- (nenhum)

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).
- Uso de SIGNAL/RESIGNAL para gerar Erros customizados.

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
- **Linha 7**: main: BEGIN
- **Linha 9**: Declaracao de variavel local v_id_usuario.
- **Linha 11**: Declaracao de variavel local EXIT.
- **Linha 12**: inicio do bloco de execucao.
- **Linha 13**: ROLLBACK;
- **Linha 14**: RESIGNAL;
- **Linha 15**: Fim do bloco da procedure.
- **Linha 17**: Invoca a procedure sp_sessao_assert.
- **Linha 19**: START TRANSACTION;
- **Linha 21**: execucao de query SELECT para consulta de dados.
- **Linha 22**: INTO v_id_usuario
- **Linha 23**: FROM sessao_usuario
- **Linha 24**: WHERE id_sessao_usuario = p_id_sessao_usuario
- **Linha 25**: LIMIT 1;
- **Linha 27** (Comentario): 1. Transiciona workflow
- **Linha 28**: Invoca a procedure sp_atendimento_transicionar.
- **Linha 29**: p_id_sessao_usuario,
- **Linha 30**: p_id_ffa,
- **Linha 31**: 'EVASAO',
- **Linha 32**: 'SISTEMA',
- **Linha 33**: p_observacao
- **Linha 34**: );
- **Linha 36** (Comentario): 2. Cancela senha vinculada
- **Linha 37**: UPDATE senha
- **Linha 38**: SET
- **Linha 39**: cancelado = TRUE,
- **Linha 40**: cancelado_em = NOW(6),
- **Linha 41**: cancelado_por = v_id_usuario,
- **Linha 42**: contexto_fluxo = 'FINALIZADO_EVASAO',
- **Linha 43**: atualizado_em = NOW(6)
- **Linha 44**: WHERE id_ffa = p_id_ffa
- **Linha 48**: COMMIT;
- **Linha 50**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_atendimento_finalizar_evasao`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa BIGINT,
    IN p_observacao TEXT
)
    SQL SECURITY INVOKER
main: BEGIN

    DECLARE v_id_usuario BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    START TRANSACTION;

    SELECT id_usuario
    INTO v_id_usuario
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao_usuario
    LIMIT 1;

    -- 1. Transiciona workflow
    CALL sp_atendimento_transicionar(
        p_id_sessao_usuario,
        p_id_ffa,
        'EVASAO',
        'SISTEMA',
        p_observacao
    );

    -- 2. Cancela senha vinculada
    UPDATE senha
    SET
        cancelado = TRUE,
        cancelado_em = NOW(6),
        cancelado_por = v_id_usuario,
        contexto_fluxo = 'FINALIZADO_EVASAO',
        atualizado_em = NOW(6)
    WHERE id_ffa = p_id_ffa
    AND cancelado = FALSE
    AND executado_em IS NULL;

    COMMIT;

END ;;
```

