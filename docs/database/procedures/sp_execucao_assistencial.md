# sp_execucao_assistencial

Objetivo: execucao assistencial conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_saas_entidade | BIGINT | IN | |
| p_id_unidade | BIGINT | IN | |
| p_id_local | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: senha
- INSERT: atendimento_evento
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CURRENT_TIMESTAMP
- IF
- IFNULL
- JSON_UNQUOTE
- SHA2
- SIGNAL

## Views Utilizadas
- v_estado

## Eventos Gerados
- evento

## Tratamento de Erros

- Uso de SIGNAL/RESIGNAL para gerar Erros customizados.

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
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: fechamento da lista de Parametros.
- **Linha 9**: SQL SECURITY INVOKER
- **Linha 10**: inicio do bloco de execucao.
- **Linha 12**: Declaracao de variavel local v_estado.
- **Linha 14**: START TRANSACTION;
- **Linha 16**: /* ===== Validação da sessão ===== */
- **Linha 18**: Estrutura condicional de controle de fluxo.
- **Linha 19**: SIGNAL SQLSTATE '45000'
- **Linha 20**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 21**: Estrutura condicional de controle de fluxo.
- **Linha 23**: /* ===== Busca fila ===== */
- **Linha 25**: execucao de query SELECT para consulta de dados.
- **Linha 26**: INTO v_estado
- **Linha 27**: FROM senha
- **Linha 28**: WHERE id_senha = p_id_senha
- **Linha 34**: FOR UPDATE;
- **Linha 36**: Estrutura condicional de controle de fluxo.
- **Linha 37**: SIGNAL SQLSTATE '45000'
- **Linha 38**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 39**: Estrutura condicional de controle de fluxo.
- **Linha 41**: /* ===== Atualiza estado operacional ===== */
- **Linha 43**: UPDATE senha
- **Linha 44**: SET
- **Linha 45**: executado_em = CURRENT_TIMESTAMP(6),
- **Linha 46**: id_sessao_usuario = p_id_sessao_usuario,
- **Linha 47**: estado_snapshot = p_payload,
- **Linha 48**: hash_estado = SHA2(IFNULL(JSON_UNQUOTE(p_payload), ''), 256)
- **Linha 49**: WHERE id_senha = p_id_senha;
- **Linha 51**: /* ===== Ledger futuro (append-only reservado) ===== */
- **Linha 53**: Insere um novo registro na tabela atendimento_evento.
- **Linha 54**: id_saas_entidade,
- **Linha 55**: id_ffa,
- **Linha 56**: tipo_evento,
- **Linha 57**: contexto_fluxo,
- **Linha 58**: payload,
- **Linha 59**: id_sessao_usuario
- **Linha 60**: fechamento da lista de Parametros.
- **Linha 61**: SELECT
- **Linha 62**: p_id_saas_entidade,
- **Linha 63**: id_ffa,
- **Linha 64**: 'EXECUCAO_ASSISTENCIAL',
- **Linha 65**: contexto_fluxo,
- **Linha 66**: p_payload,
- **Linha 67**: p_id_sessao_usuario
- **Linha 68**: FROM senha
- **Linha 69**: WHERE id_senha = p_id_senha;
- **Linha 71**: COMMIT;
- **Linha 73**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_execucao_assistencial`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_saas_entidade BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local BIGINT,
    IN p_id_senha BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_estado VARCHAR(40);

    START TRANSACTION;

    /* ===== Validação da sessão ===== */

    IF p_id_sessao_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sessao invalida';
    END IF;

    /* ===== Busca fila ===== */

    SELECT contexto_fluxo
    INTO v_estado
    FROM senha
    WHERE id_senha = p_id_senha
      AND id_saas_entidade = p_id_saas_entidade
      AND id_unidade = p_id_unidade
      AND (p_id_local IS NULL OR id_local = p_id_local)
      AND cancelado = FALSE
      AND executado_em IS NULL
    FOR UPDATE;

    IF v_estado IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha nao elegivel para execucao';
    END IF;

    /* ===== Atualiza estado operacional ===== */

    UPDATE senha
    SET
        executado_em = CURRENT_TIMESTAMP(6),
        id_sessao_usuario = p_id_sessao_usuario,
        estado_snapshot = p_payload,
        hash_estado = SHA2(IFNULL(JSON_UNQUOTE(p_payload), ''), 256)
    WHERE id_senha = p_id_senha;

    /* ===== Ledger futuro (append-only reservado) ===== */

    INSERT INTO atendimento_evento (
        id_saas_entidade,
        id_ffa,
        tipo_evento,
        contexto_fluxo,
        payload,
        id_sessao_usuario
    )
    SELECT
        p_id_saas_entidade,
        id_ffa,
        'EXECUCAO_ASSISTENCIAL',
        contexto_fluxo,
        p_payload,
        p_id_sessao_usuario
    FROM senha
    WHERE id_senha = p_id_senha;

    COMMIT;

END ;;
```

