# sp_recepcao_encaminhar_ffa

Objetivo: recepcao encaminhar ffa conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_ffa | BIGINT | IN | |

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
- sp_assert_true
- sp_auditar_erro_sql
- sp_operacao_encaminhar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IFNULL
- NULLIF
- TRIM

## Views Utilizadas
- v_destino
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
- **Linha 7**: Declaracao de variavel local v_destino.
- **Linha 8**: Declaracao de variavel local v_sqlstate.
- **Linha 9**: Declaracao de variavel local v_errno.
- **Linha 10**: Declaracao de variavel local v_msg.
- **Linha 12**: Declaracao de variavel local EXIT.
- **Linha 13**: inicio do bloco de execucao.
- **Linha 14**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 15**: SET @diag_sqlstate = v_sqlstate;
- **Linha 16**: SET @diag_errno    = v_errno;
- **Linha 17**: SET @diag_msg      = v_msg;
- **Linha 18**: ROLLBACK;
- **Linha 19**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 20**: Invoca a procedure sp_raise.
- **Linha 21**: ' | ERRNO=',IFNULL(v_errno,0),
- **Linha 22**: ' | MSG=',IFNULL(v_msg,'(n/a)'),
- **Linha 23**: ' | CTX=Falha ao encaminhar FFA'));
- **Linha 24**: Fim do bloco da procedure.
- **Linha 26**: Invoca a procedure sp_sessao_assert.
- **Linha 27**: Invoca a procedure sp_assert_true.
- **Linha 29**: atribuicao de valor Ã  variavel v_destino.
- **Linha 31**: START TRANSACTION;
- **Linha 32** (Comentario): usa local operacional da sessão (destino default)
- **Linha 33**: Invoca a procedure sp_operacao_encaminhar.
- **Linha 34**: COMMIT;
- **Linha 35**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_recepcao_encaminhar_ffa`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa BIGINT,
    IN p_tipo_destino VARCHAR(50) -- NULL -> TRIAGEM
)
main: BEGIN
    DECLARE v_destino VARCHAR(50);
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
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_recepcao_encaminhar_ffa', 'Falha ao encaminhar FFA');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_recepcao_encaminhar_ffa | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)'),
                                         ' | CTX=Falha ao encaminhar FFA'));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa é obrigatório.');

    SET v_destino = IFNULL(NULLIF(TRIM(p_tipo_destino),''), 'TRIAGEM');

    START TRANSACTION;
        -- usa local operacional da sessão (destino default)
        CALL sp_operacao_encaminhar(p_id_sessao_usuario, p_id_ffa, v_destino, NULL);
    COMMIT;
END ;;
```

