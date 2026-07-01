# sp_gatekeeper_assistencial

Objetivo: gatekeeper assistencial conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_saas | BIGINT | IN | |
| p_id_unidade | BIGINT | IN | |
| p_acao | VARCHAR(80) | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: coordenador_estado_global
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_orquestrador_assistencial
- sp_sessao_assert

## Functions Utilizadas
- IF
- JSON_UNQUOTE
- RESIGNAL
- SIGNAL

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
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: fechamento da lista de Parametros.
- **Linha 8**: SQL SECURITY INVOKER
- **Linha 9**: inicio do bloco de execucao.
- **Linha 11**: Declaracao de variavel local v_lock.
- **Linha 13**: Declaracao de variavel local EXIT.
- **Linha 14**: inicio do bloco de execucao.
- **Linha 15**: ROLLBACK;
- **Linha 16**: RESIGNAL;
- **Linha 17**: Fim do bloco da procedure.
- **Linha 19**: /* ===============================
- **Linha 20**: Validação runtime básica
- **Linha 21**: =============================== */
- **Linha 23**: Invoca a procedure sp_sessao_assert.
- **Linha 25**: START TRANSACTION;
- **Linha 27**: /* Lock lógico anti concorrência básica */
- **Linha 29**: execucao de query SELECT para consulta de dados.
- **Linha 30**: INTO v_lock
- **Linha 31**: FROM coordenador_estado_global
- **Linha 32**: WHERE id_saas_entidade = p_id_saas
- **Linha 35**: LIMIT 1
- **Linha 36**: FOR UPDATE;
- **Linha 38**: Estrutura condicional de controle de fluxo.
- **Linha 39**: SIGNAL SQLSTATE '45000'
- **Linha 40**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 41**: Estrutura condicional de controle de fluxo.
- **Linha 43**: /* ===============================
- **Linha 44**: Encaminhamento para kernel
- **Linha 45**: =============================== */
- **Linha 47**: Invoca a procedure sp_orquestrador_assistencial.
- **Linha 48**: p_id_sessao_usuario,
- **Linha 49**: p_id_saas,
- **Linha 50**: p_id_unidade,
- **Linha 51**: NULL,
- **Linha 52**: JSON_UNQUOTE(p_payload->'$.id_senha'),
- **Linha 53**: p_acao,
- **Linha 54**: p_payload
- **Linha 55**: );
- **Linha 57**: COMMIT;
- **Linha 59**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gatekeeper_assistencial`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_saas BIGINT,
    IN p_id_unidade BIGINT,
    IN p_acao VARCHAR(80),
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_lock INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    /* ===============================
       Validação runtime básica
    =============================== */

    CALL sp_sessao_assert(p_id_sessao_usuario);

    START TRANSACTION;

    /* Lock lógico anti concorrência básica */

    SELECT 1
    INTO v_lock
    FROM coordenador_estado_global
    WHERE id_saas_entidade = p_id_saas
    AND id_unidade = p_id_unidade
    AND bloqueado = FALSE
    LIMIT 1
    FOR UPDATE;

    IF v_lock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Runtime assistencial bloqueado';
    END IF;

    /* ===============================
       Encaminhamento para kernel
    =============================== */

    CALL sp_orquestrador_assistencial(
        p_id_sessao_usuario,
        p_id_saas,
        p_id_unidade,
        NULL,
        JSON_UNQUOTE(p_payload->'$.id_senha'),
        p_acao,
        p_payload
    );

    COMMIT;

END ;;
```

