# sp_medico_encaminhar

Objetivo: medico encaminhar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_ffa | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: (nenhuma)
- UPDATE: ffa
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_auditar_erro_sql
- sp_operacao_encaminhar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IFNULL
- NOW

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
- **Linha 4**: main: BEGIN
- **Linha 5**: Declaracao de variavel local v_sqlstate.
- **Linha 6**: Declaracao de variavel local v_errno.
- **Linha 7**: Declaracao de variavel local v_msg.
- **Linha 8**: Declaracao de variavel local EXIT.
- **Linha 9**: inicio do bloco de execucao.
- **Linha 10**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 11**: SET @diag_sqlstate = v_sqlstate;
- **Linha 12**: SET @diag_errno    = v_errno;
- **Linha 13**: SET @diag_msg      = v_msg;
- **Linha 14**: ROLLBACK;
- **Linha 15**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 16**: Invoca a procedure sp_raise.
- **Linha 17**: 'ROTINA=sp_medico_encaminhar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
- **Linha 18**: ' | ERRNO=', IFNULL(v_errno,0),
- **Linha 19**: ' | MSG=', IFNULL(v_msg,'(n/a)'),
- **Linha 20**: ' | CTX=Falha na rotina'
- **Linha 21**: ));
- **Linha 22**: Fim do bloco da procedure.
- **Linha 24**: Invoca a procedure sp_sessao_assert.
- **Linha 25**: START TRANSACTION;
- **Linha 27**: Invoca a procedure sp_operacao_encaminhar.
- **Linha 28**: UPDATE ffa
- **Linha 29**: atribuicao de valor Ã  variavel status.
- **Linha 30**: atualizado_em = NOW(),
- **Linha 31**: id_usuario_alteracao = (SELECT su.id_usuario FROM sessao_usuario su WHERE su.id_sessao_usuario = p_id_sessao_usuario LIMIT 1)
- **Linha 32**: WHERE id = p_id_ffa;
- **Linha 33**: COMMIT;
- **Linha 34**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medico_encaminhar`(IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa BIGINT,
    IN p_id_local_operacional_destino BIGINT)
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
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medico_encaminhar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medico_encaminhar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_operacao_encaminhar(p_id_sessao_usuario, p_id_ffa, p_id_local_operacional_destino);
    UPDATE ffa
       SET status = 'ENCAMINHADO',
           atualizado_em = NOW(),
           id_usuario_alteracao = (SELECT su.id_usuario FROM sessao_usuario su WHERE su.id_sessao_usuario = p_id_sessao_usuario LIMIT 1)
     WHERE id = p_id_ffa;
    COMMIT;
END ;;
```

