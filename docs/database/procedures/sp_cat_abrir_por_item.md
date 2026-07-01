# sp_cat_abrir_por_item

Objetivo: cat abrir por item conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_pedido_item | BIGINT | IN | |
| p_id_usuario_resp | BIGINT | IN | |
| p_id_cat | BIGINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: pedido_medico, pedido_medico_item
- INSERT: cat_evento, cat_notificacao
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
- JSON_OBJECT
- LAST_INSERT_ID

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
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: main: BEGIN
- **Linha 8**: Declaracao de variavel local v_sqlstate.
- **Linha 9**: Declaracao de variavel local v_errno.
- **Linha 10**: Declaracao de variavel local v_msg.
- **Linha 12**: Declaracao de variavel local v_id_pedido.
- **Linha 13**: Declaracao de variavel local v_id_ffa.
- **Linha 14**: Declaracao de variavel local v_id_gpat.
- **Linha 15**: Declaracao de variavel local v_exige_cat.
- **Linha 17**: Declaracao de variavel local EXIT.
- **Linha 18**: inicio do bloco de execucao.
- **Linha 19**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 20**: ROLLBACK;
- **Linha 21**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 22**: Invoca a procedure sp_raise.
- **Linha 23**: Fim do bloco da procedure.
- **Linha 25**: atribuicao de valor Ã  variavel p_id_cat.
- **Linha 27**: Invoca a procedure sp_sessao_assert.
- **Linha 28**: Invoca a procedure sp_assert_true.
- **Linha 29**: Invoca a procedure sp_assert_true.
- **Linha 31**: START TRANSACTION;
- **Linha 33**: execucao de query SELECT para consulta de dados.
- **Linha 34**: INTO v_id_pedido, v_exige_cat
- **Linha 35**: FROM pedido_medico_item i
- **Linha 36**: WHERE i.id_pedido_item = p_id_pedido_item
- **Linha 37**: LIMIT 1;
- **Linha 39**: Invoca a procedure sp_assert_true.
- **Linha 40**: Invoca a procedure sp_assert_true.
- **Linha 42**: execucao de query SELECT para consulta de dados.
- **Linha 43**: INTO v_id_ffa, v_id_gpat
- **Linha 44**: FROM pedido_medico p
- **Linha 45**: WHERE p.id_pedido_medico = v_id_pedido
- **Linha 46**: LIMIT 1;
- **Linha 48**: Invoca a procedure sp_assert_true.
- **Linha 50**: Insere um novo registro na tabela cat_notificacao.
- **Linha 51**: VALUES (v_id_ffa, v_id_gpat, p_id_pedido_item, p_id_usuario_resp, 'ABERTA');
- **Linha 53**: atribuicao de valor Ã  variavel p_id_cat.
- **Linha 55**: Insere um novo registro na tabela cat_evento.
- **Linha 56**: VALUES (p_id_cat, p_id_sessao_usuario, 'CAT_ABERTA', JSON_OBJECT('id_pedido_item', p_id_pedido_item));
- **Linha 58**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 60**: COMMIT;
- **Linha 61**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cat_abrir_por_item`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_pedido_item    BIGINT,
    IN  p_id_usuario_resp   BIGINT,
    OUT p_id_cat            BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_pedido BIGINT;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_id_gpat BIGINT;
    DECLARE v_exige_cat TINYINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_cat_abrir_por_item', 'Falha ao abrir CAT');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_cat_abrir_por_item | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_cat = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_pedido_item IS NOT NULL, 'PARAM', 'id_pedido_item é obrigatório.');
    CALL sp_assert_true(p_id_usuario_resp IS NOT NULL, 'PARAM', 'id_usuario_resp é obrigatório.');

    START TRANSACTION;

    SELECT i.id_pedido_medico, i.exige_cat
      INTO v_id_pedido, v_exige_cat
      FROM pedido_medico_item i
     WHERE i.id_pedido_item = p_id_pedido_item
     LIMIT 1;

    CALL sp_assert_true(v_id_pedido IS NOT NULL, 'CAT', 'Item de pedido não encontrado.');
    CALL sp_assert_true(v_exige_cat = 1, 'CAT', 'Item não exige CAT.');

    SELECT p.id_ffa, p.id_gpat
      INTO v_id_ffa, v_id_gpat
      FROM pedido_medico p
     WHERE p.id_pedido_medico = v_id_pedido
     LIMIT 1;

    CALL sp_assert_true(v_id_ffa IS NOT NULL AND v_id_gpat IS NOT NULL, 'CAT', 'Pedido sem FFA/GPAT.');

    INSERT INTO cat_notificacao (id_ffa, id_gpat, id_pedido_item, id_usuario_responsavel, status)
    VALUES (v_id_ffa, v_id_gpat, p_id_pedido_item, p_id_usuario_resp, 'ABERTA');

    SET p_id_cat = LAST_INSERT_ID();

    INSERT INTO cat_evento (id_cat, id_sessao_usuario, evento, payload_json)
    VALUES (p_id_cat, p_id_sessao_usuario, 'CAT_ABERTA', JSON_OBJECT('id_pedido_item', p_id_pedido_item));

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'CAT_ABERTA', 'cat_notificacao', p_id_cat);

    COMMIT;
END ;;
```

