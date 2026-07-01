# sp_senha_retorno_reinserir

Objetivo: senha retorno reinserir conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: (nenhuma)
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_sessao_assert

## Functions Utilizadas
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
- Commit: Sim

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: SQL SECURITY INVOKER
- **Linha 6**: inicio do bloco de execucao.
- **Linha 8**: Invoca a procedure sp_sessao_assert.
- **Linha 10**: START TRANSACTION;
- **Linha 12**: UPDATE senha
- **Linha 13**: SET
- **Linha 14**: nao_compareceu = FALSE,
- **Linha 15**: retorno_utilizado = TRUE,
- **Linha 16**: retorno_em = NOW(6),
- **Linha 17**: id_fluxo_status = 1,
- **Linha 18**: chamada_sequencial = 0,
- **Linha 19**: atualizado_em = NOW(6)
- **Linha 20**: WHERE id_senha = p_id_senha
- **Linha 23**: COMMIT;
- **Linha 25**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_retorno_reinserir`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT
)
    SQL SECURITY INVOKER
BEGIN

    CALL sp_sessao_assert(p_id_sessao_usuario);

    START TRANSACTION;

    UPDATE senha
    SET
        nao_compareceu = FALSE,
        retorno_utilizado = TRUE,
        retorno_em = NOW(6),
        id_fluxo_status = 1,
        chamada_sequencial = 0,
        atualizado_em = NOW(6)
    WHERE id_senha = p_id_senha
    AND nao_compareceu = TRUE;

    COMMIT;

END ;;
```

