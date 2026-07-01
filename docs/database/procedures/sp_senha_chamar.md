# sp_senha_chamar

Objetivo: senha chamar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_unidade | BIGINT | IN | |
| p_id_local | BIGINT | IN | |
| p_id_saas_entidade | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: senha
- INSERT: (nenhuma)
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CURRENT_TIMESTAMP
- IF

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
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: inicio do bloco de execucao.
- **Linha 10**: Declaracao de variavel local v_id_senha.
- **Linha 12**: START TRANSACTION;
- **Linha 14**: /* Seleciona próxima senha da fila universal */
- **Linha 16**: execucao de query SELECT para consulta de dados.
- **Linha 17**: INTO v_id_senha
- **Linha 18**: FROM senha
- **Linha 19**: WHERE
- **Linha 20**: id_saas_entidade = p_id_saas_entidade
- **Linha 25**: ORDER BY prioridade DESC,
- **Linha 26**: ordem_fila ASC,
- **Linha 27**: criado_em ASC
- **Linha 28**: LIMIT 1
- **Linha 29**: FOR UPDATE;
- **Linha 31**: /* Atualiza estado operacional */
- **Linha 33**: Estrutura condicional de controle de fluxo.
- **Linha 35**: UPDATE senha
- **Linha 36**: SET
- **Linha 37**: chamada_sequencial = chamada_sequencial + 1,
- **Linha 38**: chamada_em = CURRENT_TIMESTAMP(6),
- **Linha 39**: id_sessao_usuario = p_id_sessao_usuario
- **Linha 40**: WHERE id_senha = v_id_senha;
- **Linha 42**: Estrutura condicional de controle de fluxo.
- **Linha 44**: COMMIT;
- **Linha 46**: execucao de query SELECT para consulta de dados.
- **Linha 48**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_chamar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local BIGINT,
    IN p_id_saas_entidade BIGINT
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_id_senha BIGINT;

    START TRANSACTION;

    /* Seleciona próxima senha da fila universal */

    SELECT id_senha
    INTO v_id_senha
    FROM senha
    WHERE
        id_saas_entidade = p_id_saas_entidade
        AND id_unidade = p_id_unidade
        AND (p_id_local IS NULL OR id_local = p_id_local)
        AND cancelado = FALSE
        AND executado_em IS NULL
    ORDER BY prioridade DESC,
             ordem_fila ASC,
             criado_em ASC
    LIMIT 1
    FOR UPDATE;

    /* Atualiza estado operacional */

    IF v_id_senha IS NOT NULL THEN

        UPDATE senha
        SET
            chamada_sequencial = chamada_sequencial + 1,
            chamada_em = CURRENT_TIMESTAMP(6),
            id_sessao_usuario = p_id_sessao_usuario
        WHERE id_senha = v_id_senha;

    END IF;

    COMMIT;

    SELECT * FROM senha WHERE id_senha = v_id_senha;

END ;;
```

