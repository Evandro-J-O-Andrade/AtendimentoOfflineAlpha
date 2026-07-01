# sp_fila_tipo_por_local

Objetivo: fila tipo por local conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_local_operacional | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: local_operacional
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IFNULL

## Views Utilizadas
- v_sqlstate
- v_tipo_local

## Eventos Gerados
- (nenhum)

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
- **Linha 4**: main: BEGIN
- **Linha 5**: Declaracao de variavel local v_sqlstate.
- **Linha 6**: Declaracao de variavel local v_errno.
- **Linha 7**: Declaracao de variavel local v_msg.
- **Linha 8**: Declaracao de variavel local v_tipo_local.
- **Linha 10**: Declaracao de variavel local EXIT.
- **Linha 11**: inicio do bloco de execucao.
- **Linha 12**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 13**: SET @diag_sqlstate = v_sqlstate;
- **Linha 14**: SET @diag_errno    = v_errno;
- **Linha 15**: SET @diag_msg      = v_msg;
- **Linha 16**: ROLLBACK;
- **Linha 17**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 18**: Invoca a procedure sp_raise.
- **Linha 19**: 'ROTINA=sp_fila_tipo_por_local | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
- **Linha 20**: ' | ERRNO=', IFNULL(v_errno,0),
- **Linha 21**: ' | MSG=', IFNULL(v_msg,'(n/a)'),
- **Linha 22**: ' | CTX=Falha na rotina'
- **Linha 23**: ));
- **Linha 24**: Fim do bloco da procedure.
- **Linha 26**: Invoca a procedure sp_sessao_assert.
- **Linha 27**: START TRANSACTION;
- **Linha 29**: atribuicao de valor Ã  variavel p_tipo_fila.
- **Linha 30**: Invoca a procedure sp_assert_true.
- **Linha 31**: execucao de query SELECT para consulta de dados.
- **Linha 32**: FROM local_operacional lo
- **Linha 33**: WHERE lo.id_local_operacional = p_id_local_operacional
- **Linha 34**: LIMIT 1;
- **Linha 35**: Invoca a procedure sp_assert_true.
- **Linha 36**: atribuicao de valor Ã  variavel p_tipo_fila.
- **Linha 37**: WHEN v_tipo_local = 'TRIAGEM' THEN 'TRIAGEM'
- **Linha 38**: WHEN v_tipo_local IN ('MEDICO_CLINICO','MEDICO_PEDIATRICO') THEN 'MEDICO'
- **Linha 39**: WHEN v_tipo_local = 'MEDICACAO' THEN 'MEDICACAO'
- **Linha 40**: WHEN v_tipo_local = 'RX' THEN 'RX'
- **Linha 41**: WHEN v_tipo_local = 'ECG' THEN 'ECG'
- **Linha 42**: WHEN v_tipo_local = 'OBSERVACAO' THEN 'OBSERVACAO'
- **Linha 43**: WHEN v_tipo_local IN ('LABORATORIO') THEN 'EXAME'
- **Linha 44**: Estrutura condicional de controle de fluxo.
- **Linha 45**: Fim do bloco da procedure.
- **Linha 46**: COMMIT;
- **Linha 47**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fila_tipo_por_local`(IN p_id_sessao_usuario BIGINT,
    IN p_id_local_operacional BIGINT,
    OUT p_tipo_fila VARCHAR(20))
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE v_tipo_local VARCHAR(40);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_fila_tipo_por_local', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_fila_tipo_por_local | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    SET p_tipo_fila = NULL;
    CALL sp_assert_true(p_id_local_operacional IS NOT NULL, 'PARAM', 'id_local_operacional é obrigatório.');
    SELECT lo.tipo INTO v_tipo_local
      FROM local_operacional lo
     WHERE lo.id_local_operacional = p_id_local_operacional
     LIMIT 1;
    CALL sp_assert_true(v_tipo_local IS NOT NULL, 'LOCAL', 'Local operacional não encontrado.');
    SET p_tipo_fila = CASE
        WHEN v_tipo_local = 'TRIAGEM' THEN 'TRIAGEM'
        WHEN v_tipo_local IN ('MEDICO_CLINICO','MEDICO_PEDIATRICO') THEN 'MEDICO'
        WHEN v_tipo_local = 'MEDICACAO' THEN 'MEDICACAO'
        WHEN v_tipo_local = 'RX' THEN 'RX'
        WHEN v_tipo_local = 'ECG' THEN 'ECG'
        WHEN v_tipo_local = 'OBSERVACAO' THEN 'OBSERVACAO'
        WHEN v_tipo_local IN ('LABORATORIO') THEN 'EXAME'
        ELSE 'PROCEDIMENTO'
    END;
    COMMIT;
END ;;
```

