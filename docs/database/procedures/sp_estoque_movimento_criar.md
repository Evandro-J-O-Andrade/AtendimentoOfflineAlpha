# sp_estoque_movimento_criar

Objetivo: estoque movimento criar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_estoque_local | BIGINT | IN | |
| p_tipo | VARCHAR(20) | IN | |
| p_origem | VARCHAR(40) | IN | |
| p_destino | VARCHAR(40) | IN | |
| p_observacao | VARCHAR(255) | IN | |
| p_id_movimento | BIGINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: estoque_movimento
- UPDATE: (nenhuma)
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
- LAST_INSERT_ID
- UPPER

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
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: fechamento da lista de Parametros.
- **Linha 10**: main: BEGIN
- **Linha 11**: Declaracao de variavel local v_sqlstate.
- **Linha 12**: Declaracao de variavel local v_errno.
- **Linha 13**: Declaracao de variavel local v_msg.
- **Linha 15**: Declaracao de variavel local EXIT.
- **Linha 16**: inicio do bloco de execucao.
- **Linha 17**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 18**: ROLLBACK;
- **Linha 19**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 20**: Invoca a procedure sp_raise.
- **Linha 21**: Fim do bloco da procedure.
- **Linha 23**: atribuicao de valor Ã  variavel p_id_movimento.
- **Linha 25**: Invoca a procedure sp_sessao_assert.
- **Linha 26**: Invoca a procedure sp_assert_true.
- **Linha 27**: Invoca a procedure sp_assert_true.
- **Linha 29**: START TRANSACTION;
- **Linha 31**: Insere um novo registro na tabela estoque_movimento.
- **Linha 32**: VALUES (p_id_estoque_local, UPPER(p_tipo), p_origem, p_destino, p_observacao, p_id_sessao_usuario);
- **Linha 34**: atribuicao de valor Ã  variavel p_id_movimento.
- **Linha 36**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 38**: COMMIT;
- **Linha 39**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estoque_movimento_criar`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_estoque_local  BIGINT,
    IN  p_tipo              VARCHAR(20),
    IN  p_origem            VARCHAR(40),
    IN  p_destino           VARCHAR(40),
    IN  p_observacao        VARCHAR(255),
    OUT p_id_movimento      BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_estoque_movimento_criar', 'Falha ao criar movimento');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_estoque_movimento_criar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_movimento = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_estoque_local IS NOT NULL, 'PARAM', 'id_estoque_local é obrigatório.');
    CALL sp_assert_true(p_tipo IS NOT NULL, 'PARAM', 'tipo é obrigatório.');

    START TRANSACTION;

    INSERT INTO estoque_movimento (id_estoque_local, tipo, origem, destino, observacao, id_sessao_usuario)
    VALUES (p_id_estoque_local, UPPER(p_tipo), p_origem, p_destino, p_observacao, p_id_sessao_usuario);

    SET p_id_movimento = LAST_INSERT_ID();

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'ESTOQUE_MOV_CRIADO', 'estoque_movimento', p_id_movimento);

    COMMIT;
END ;;
```

