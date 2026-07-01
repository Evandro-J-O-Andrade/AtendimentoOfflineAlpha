# sp_triagem_finalizar

Objetivo: triagem finalizar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| - | - | - | nenhum parÃ¢metro declarado. |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_fila_finalizar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IFNULL

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
- **Linha 3**: main: BEGIN
- **Linha 4**: Declaracao de variavel local v_sqlstate.
- **Linha 5**: Declaracao de variavel local v_errno.
- **Linha 6**: Declaracao de variavel local v_msg.
- **Linha 7**: Declaracao de variavel local EXIT.
- **Linha 8**: inicio do bloco de execucao.
- **Linha 9**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 10**: SET @diag_sqlstate = v_sqlstate;
- **Linha 11**: SET @diag_errno    = v_errno;
- **Linha 12**: SET @diag_msg      = v_msg;
- **Linha 13**: ROLLBACK;
- **Linha 14**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 15**: Invoca a procedure sp_raise.
- **Linha 16**: 'ROTINA=sp_triagem_finalizar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
- **Linha 17**: ' | ERRNO=', IFNULL(v_errno,0),
- **Linha 18**: ' | MSG=', IFNULL(v_msg,'(n/a)'),
- **Linha 19**: ' | CTX=Falha na rotina'
- **Linha 20**: ));
- **Linha 21**: Fim do bloco da procedure.
- **Linha 23**: Invoca a procedure sp_sessao_assert.
- **Linha 24**: START TRANSACTION;
- **Linha 26**: Invoca a procedure sp_fila_finalizar.
- **Linha 27**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 28**: p_id_sessao_usuario,
- **Linha 29**: 'FILA_OPERACIONAL',
- **Linha 30**: p_id_fila,
- **Linha 31**: 'FINALIZAR',
- **Linha 32**: 'setor=TRIAGEM',
- **Linha 33**: NULL,
- **Linha 34**: 'fila_operacional',
- **Linha 35**: NULL
- **Linha 36**: );
- **Linha 37**: COMMIT;
- **Linha 38**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_triagem_finalizar`(IN p_id_sessao_usuario BIGINT,
        IN p_id_fila BIGINT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_triagem_finalizar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_triagem_finalizar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_fila_finalizar(p_id_sessao_usuario, p_id_fila, 'setor=TRIAGEM');
    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'FINALIZAR',
        'setor=TRIAGEM',
        NULL,
        'fila_operacional',
        NULL
    );
    COMMIT;
END ;;
```

