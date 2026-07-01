# sp_admin_sessao_revogar

Objetivo: admin sessao revogar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_sessao_alvo | BIGINT | IN | |
| p_motivo | VARCHAR(255) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: (nenhuma)
- UPDATE: sessao_usuario
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IFNULL
- NOW
- ROW_COUNT

## Views Utilizadas
- v_sqlstate

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
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: main: BEGIN
- **Linha 8**: Declaracao de variavel local v_sqlstate.
- **Linha 9**: Declaracao de variavel local v_errno.
- **Linha 10**: Declaracao de variavel local v_msg.
- **Linha 12**: Declaracao de variavel local EXIT.
- **Linha 13**: inicio do bloco de execucao.
- **Linha 14**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 15**: ROLLBACK;
- **Linha 16**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 17**: Invoca a procedure sp_raise.
- **Linha 18**: Fim do bloco da procedure.
- **Linha 20**: Invoca a procedure sp_sessao_assert.
- **Linha 21**: Invoca a procedure sp_assert_true.
- **Linha 23**: START TRANSACTION;
- **Linha 25**: UPDATE sessao_usuario
- **Linha 26**: atribuicao de valor Ã  variavel ativo.
- **Linha 27**: revogado_em = NOW(),
- **Linha 28**: revogado_por = p_id_sessao_usuario,
- **Linha 29**: revogado_motivo = p_motivo
- **Linha 30**: WHERE id_sessao_usuario = p_id_sessao_alvo;
- **Linha 32**: Invoca a procedure sp_assert_true.
- **Linha 34**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 36**: COMMIT;
- **Linha 37**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_admin_sessao_revogar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_sessao_alvo    BIGINT,
    IN p_motivo            VARCHAR(255)
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_admin_sessao_revogar', 'Falha ao revogar sessão');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_admin_sessao_revogar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_sessao_alvo IS NOT NULL, 'PARAM', 'id_sessao_alvo é obrigatório.');

    START TRANSACTION;

    UPDATE sessao_usuario
       SET ativo = 0,
           revogado_em = NOW(),
           revogado_por = p_id_sessao_usuario,
           revogado_motivo = p_motivo
     WHERE id_sessao_usuario = p_id_sessao_alvo;

    CALL sp_assert_true(ROW_COUNT()=1, 'SESSAO', 'Sessão alvo não encontrada.');

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'SESSAO_REVOGADA', 'sessao_usuario', p_id_sessao_alvo);

    COMMIT;
END ;;
```

