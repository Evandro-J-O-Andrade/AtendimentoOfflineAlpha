# sp_orquestrador_assistencial

Objetivo: orquestrador assistencial conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_saas_entidade | BIGINT | IN | |
| p_id_unidade | BIGINT | IN | |
| p_id_local | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
| p_acao | VARCHAR(60) | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fluxo_transicao_matriz, senha
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
- (nenhuma)

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
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: fechamento da lista de Parametros.
- **Linha 10**: SQL SECURITY INVOKER
- **Linha 11**: inicio do bloco de execucao.
- **Linha 13**: Declaracao de variavel local v_fluxo_origem.
- **Linha 14**: Declaracao de variavel local v_fluxo_destino.
- **Linha 16**: START TRANSACTION;
- **Linha 18**: /* ===== Bloqueio concorrente da fila ===== */
- **Linha 20**: execucao de query SELECT para consulta de dados.
- **Linha 21**: INTO v_fluxo_origem
- **Linha 22**: FROM senha
- **Linha 23**: WHERE id_senha = p_id_senha
- **Linha 26**: FOR UPDATE;
- **Linha 28**: /* ===== Determina próximo estado (regra matriz) ===== */
- **Linha 30**: execucao de query SELECT para consulta de dados.
- **Linha 31**: INTO v_fluxo_destino
- **Linha 32**: FROM fluxo_transicao_matriz
- **Linha 33**: WHERE fluxo_origem = v_fluxo_origem
- **Linha 36**: LIMIT 1;
- **Linha 38**: Estrutura condicional de controle de fluxo.
- **Linha 39**: SIGNAL SQLSTATE '45000'
- **Linha 40**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 41**: Estrutura condicional de controle de fluxo.
- **Linha 43**: /* ===== Atualiza fila universal ===== */
- **Linha 45**: UPDATE senha
- **Linha 46**: SET
- **Linha 47**: id_fluxo_status = v_fluxo_destino,
- **Linha 48**: estado_snapshot = p_payload,
- **Linha 49**: hash_estado = SHA2(IFNULL(JSON_UNQUOTE(p_payload), ''), 256),
- **Linha 50**: id_sessao_usuario = p_id_sessao_usuario,
- **Linha 51**: atualizado_em = CURRENT_TIMESTAMP(6)
- **Linha 52**: WHERE id_senha = p_id_senha;
- **Linha 54**: /* ===== Ledger assistencial append-only ===== */
- **Linha 56**: Insere um novo registro na tabela atendimento_evento.
- **Linha 57**: id_saas_entidade,
- **Linha 58**: id_ffa,
- **Linha 59**: tipo_evento,
- **Linha 60**: contexto_fluxo,
- **Linha 61**: payload,
- **Linha 62**: id_sessao_usuario
- **Linha 63**: fechamento da lista de Parametros.
- **Linha 64**: SELECT
- **Linha 65**: p_id_saas_entidade,
- **Linha 66**: id_ffa,
- **Linha 67**: p_acao,
- **Linha 68**: contexto_fluxo,
- **Linha 69**: p_payload,
- **Linha 70**: p_id_sessao_usuario
- **Linha 71**: FROM senha
- **Linha 72**: WHERE id_senha = p_id_senha;
- **Linha 74**: COMMIT;
- **Linha 76**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_orquestrador_assistencial`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_saas_entidade BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local BIGINT,
    IN p_id_senha BIGINT,
    IN p_acao VARCHAR(60),
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_fluxo_origem BIGINT;
    DECLARE v_fluxo_destino BIGINT;

    START TRANSACTION;

    /* ===== Bloqueio concorrente da fila ===== */

    SELECT id_fluxo_status
    INTO v_fluxo_origem
    FROM senha
    WHERE id_senha = p_id_senha
    AND id_saas_entidade = p_id_saas_entidade
    AND id_unidade = p_id_unidade
    FOR UPDATE;

    /* ===== Determina próximo estado (regra matriz) ===== */

    SELECT fluxo_destino
    INTO v_fluxo_destino
    FROM fluxo_transicao_matriz
    WHERE fluxo_origem = v_fluxo_origem
    AND acao_permitida = p_acao
    AND ativo = TRUE
    LIMIT 1;

    IF v_fluxo_destino IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transicao nao permitida pelo orquestrador';
    END IF;

    /* ===== Atualiza fila universal ===== */

    UPDATE senha
    SET
        id_fluxo_status = v_fluxo_destino,
        estado_snapshot = p_payload,
        hash_estado = SHA2(IFNULL(JSON_UNQUOTE(p_payload), ''), 256),
        id_sessao_usuario = p_id_sessao_usuario,
        atualizado_em = CURRENT_TIMESTAMP(6)
    WHERE id_senha = p_id_senha;

    /* ===== Ledger assistencial append-only ===== */

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
        p_acao,
        contexto_fluxo,
        p_payload,
        p_id_sessao_usuario
    FROM senha
    WHERE id_senha = p_id_senha;

    COMMIT;

END ;;
```

