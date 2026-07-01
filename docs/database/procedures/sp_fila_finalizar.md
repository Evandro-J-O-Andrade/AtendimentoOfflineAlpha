# sp_fila_finalizar

Objetivo: fila finalizar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_fila | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: fila_operacional_evento
- UPDATE: fila_operacional
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IFNULL
- NOW

## Views Utilizadas
- v_sqlstate

## Eventos Gerados
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
- **Linha 17**: 'ROTINA=sp_fila_finalizar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
- **Linha 18**: ' | ERRNO=', IFNULL(v_errno,0),
- **Linha 19**: ' | MSG=', IFNULL(v_msg,'(n/a)'),
- **Linha 20**: ' | CTX=Falha na rotina'
- **Linha 21**: ));
- **Linha 22**: Fim do bloco da procedure.
- **Linha 24**: Invoca a procedure sp_sessao_assert.
- **Linha 25**: START TRANSACTION;
- **Linha 27**: Invoca a procedure sp_assert_true.
- **Linha 28**: UPDATE fila_operacional
- **Linha 29**: atribuicao de valor Ã  variavel substatus.
- **Linha 30**: data_fim = NOW()
- **Linha 31**: WHERE id_fila = p_id_fila;
- **Linha 32**: Insere um novo registro na tabela fila_operacional_evento.
- **Linha 33**: VALUES (p_id_fila, p_id_sessao_usuario, 'FINALIZAR', p_detalhe, NOW());
- **Linha 34**: COMMIT;
- **Linha 35**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fila_finalizar`(IN p_id_sessao_usuario BIGINT,
    IN p_id_fila BIGINT,
    IN p_detalhe VARCHAR(255))
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
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_fila_finalizar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_fila_finalizar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');
    UPDATE fila_operacional
       SET substatus = 'FINALIZADO',
           data_fim = NOW()
     WHERE id_fila = p_id_fila;
    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'FINALIZAR', p_detalhe, NOW());
    COMMIT;
END ;;
```

