# sp_workflow_ffa_rebuild

Objetivo: workflow ffa rebuild conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: vw_workflow_ffa_completo, workflow_ffa_evento
- INSERT: workflow_ffa_evento
- UPDATE: (nenhuma)
- DELETE: workflow_ffa_evento

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IFNULL

## Views Utilizadas
- v_sqlstate
- vw_workflow_ffa_completo

## Eventos Gerados
- auditoria_evento
- evento

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: Sim
- Commit: Sim

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: main: BEGIN
- **Linha 6**: Declaracao de variavel local v_sqlstate.
- **Linha 7**: Declaracao de variavel local v_errno.
- **Linha 8**: Declaracao de variavel local v_msg.
- **Linha 10**: Declaracao de variavel local EXIT.
- **Linha 11**: inicio do bloco de execucao.
- **Linha 12**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 13**: ROLLBACK;
- **Linha 14**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 15**: Invoca a procedure sp_raise.
- **Linha 16**: Fim do bloco da procedure.
- **Linha 18**: Invoca a procedure sp_sessao_assert.
- **Linha 19**: Invoca a procedure sp_assert_true.
- **Linha 21**: START TRANSACTION;
- **Linha 23**: Remove registros da tabela workflow_ffa_evento.
- **Linha 25**: Insere um novo registro na tabela workflow_ffa_evento.
- **Linha 26**: id_ffa, origem, entidade, id_entidade, tipo_evento, detalhe, id_sessao_usuario, criado_em, payload_json
- **Linha 27**: fechamento da lista de Parametros.
- **Linha 28**: SELECT
- **Linha 29**: w.id_ffa, w.origem, w.entidade, w.id_entidade, w.tipo_evento, w.detalhe, w.id_sessao_usuario, w.criado_em, w.payload_json
- **Linha 30**: FROM vw_workflow_ffa_completo w
- **Linha 31**: WHERE w.id_ffa = p_id_ffa
- **Linha 32**: ORDER BY w.criado_em;
- **Linha 34**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 36**: COMMIT;
- **Linha 37**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_workflow_ffa_rebuild`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa            BIGINT  -- ffa.id
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_workflow_ffa_rebuild', 'Falha ao rebuild workflow');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_workflow_ffa_rebuild | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa (ffa.id) é obrigatório.');

    START TRANSACTION;

    DELETE FROM workflow_ffa_evento WHERE id_ffa = p_id_ffa;

    INSERT INTO workflow_ffa_evento (
        id_ffa, origem, entidade, id_entidade, tipo_evento, detalhe, id_sessao_usuario, criado_em, payload_json
    )
    SELECT
        w.id_ffa, w.origem, w.entidade, w.id_entidade, w.tipo_evento, w.detalhe, w.id_sessao_usuario, w.criado_em, w.payload_json
    FROM vw_workflow_ffa_completo w
    WHERE w.id_ffa = p_id_ffa
    ORDER BY w.criado_em;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'WORKFLOW_REBUILD', 'workflow_ffa_evento', p_id_ffa);

    COMMIT;
END ;;
```

