# sp_finalizar_procedimento_laboratorio

Objetivo: finalizar procedimento laboratorio conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_fila | BIGINT | IN | |
| p_resultado | TEXT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fila_operacional
- INSERT: (nenhuma)
- UPDATE: lab_protocolo_interno
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_finalizar_procedimento_geral
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IFNULL

## Views Utilizadas
- v_sqlstate

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
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: main: BEGIN
- **Linha 7**: Declaracao de variavel local v_sqlstate.
- **Linha 8**: Declaracao de variavel local v_errno.
- **Linha 9**: Declaracao de variavel local v_msg.
- **Linha 11**: Declaracao de variavel local v_id_ffa.
- **Linha 13**: Declaracao de variavel local EXIT.
- **Linha 14**: inicio do bloco de execucao.
- **Linha 15**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 16**: ROLLBACK;
- **Linha 17**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 18**: Invoca a procedure sp_raise.
- **Linha 19**: CONCAT('ROTINA=sp_finalizar_procedimento_laboratorio | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
- **Linha 20**: ' | ERRNO=',IFNULL(v_errno,0),
- **Linha 21**: ' | MSG=',IFNULL(v_msg,'(n/a)')));
- **Linha 22**: Fim do bloco da procedure.
- **Linha 24**: Invoca a procedure sp_sessao_assert.
- **Linha 25**: Invoca a procedure sp_assert_true.
- **Linha 27**: START TRANSACTION;
- **Linha 29**: execucao de query SELECT para consulta de dados.
- **Linha 30**: FROM fila_operacional fo
- **Linha 31**: WHERE fo.id_fila = p_id_fila
- **Linha 32**: LIMIT 1;
- **Linha 34**: Invoca a procedure sp_assert_true.
- **Linha 36** (Comentario): finaliza a fila e o protocolo EXAME (se existir)
- **Linha 37**: Invoca a procedure sp_finalizar_procedimento_geral.
- **Linha 39** (Comentario): marca lab como concluído (se existir amostra)
- **Linha 40**: UPDATE lab_protocolo_interno
- **Linha 41**: atribuicao de valor Ã  variavel status_laboratorial.
- **Linha 42**: WHERE id_ffa = v_id_ffa
- **Linha 45**: COMMIT;
- **Linha 46**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_laboratorio`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_resultado         TEXT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_id_ffa BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_finalizar_procedimento_laboratorio', 'Falha ao finalizar laboratório');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_finalizar_procedimento_laboratorio | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    START TRANSACTION;

    SELECT fo.id_ffa INTO v_id_ffa
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1;

    CALL sp_assert_true(v_id_ffa IS NOT NULL, 'FILA', 'Fila operacional não encontrada.');

    -- finaliza a fila e o protocolo EXAME (se existir)
    CALL sp_finalizar_procedimento_geral(p_id_sessao_usuario, p_id_fila, p_resultado);

    -- marca lab como concluído (se existir amostra)
    UPDATE lab_protocolo_interno
       SET status_laboratorial = 'CONCLUIDO'
     WHERE id_ffa = v_id_ffa
       AND (status_laboratorial IS NULL OR status_laboratorial <> 'CONCLUIDO');

    COMMIT;
END ;;
```

