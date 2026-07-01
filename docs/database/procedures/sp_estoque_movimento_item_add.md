# sp_estoque_movimento_item_add

Objetivo: estoque movimento item add conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_movimento | BIGINT | IN | |
| p_id_produto | BIGINT | IN | |
| p_id_lote | BIGINT | IN | |
| p_quantidade | DECIMAL(14,3) | IN | |
| p_valor_unitario | DECIMAL(14,4) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: estoque_movimento
- INSERT: estoque_movimento_item
- UPDATE: estoque_lote
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IF
- IFNULL
- LAST_INSERT_ID
- NOW

## Views Utilizadas
- v_sqlstate
- v_tipo

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
- **Linha 8**: fechamento da lista de Parametros.
- **Linha 9**: main: BEGIN
- **Linha 10**: Declaracao de variavel local v_sqlstate.
- **Linha 11**: Declaracao de variavel local v_errno.
- **Linha 12**: Declaracao de variavel local v_msg.
- **Linha 14**: Declaracao de variavel local v_tipo.
- **Linha 15**: Declaracao de variavel local v_id_local.
- **Linha 17**: Declaracao de variavel local EXIT.
- **Linha 18**: inicio do bloco de execucao.
- **Linha 19**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 20**: ROLLBACK;
- **Linha 21**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 22**: Invoca a procedure sp_raise.
- **Linha 23**: Fim do bloco da procedure.
- **Linha 25**: Invoca a procedure sp_sessao_assert.
- **Linha 26**: Invoca a procedure sp_assert_true.
- **Linha 27**: Invoca a procedure sp_assert_true.
- **Linha 28**: Invoca a procedure sp_assert_true.
- **Linha 30**: START TRANSACTION;
- **Linha 32**: execucao de query SELECT para consulta de dados.
- **Linha 33**: INTO v_tipo, v_id_local
- **Linha 34**: FROM estoque_movimento m
- **Linha 35**: WHERE m.id_movimento = p_id_movimento
- **Linha 36**: LIMIT 1;
- **Linha 38**: Invoca a procedure sp_assert_true.
- **Linha 40**: Insere um novo registro na tabela estoque_movimento_item.
- **Linha 41**: VALUES (p_id_movimento, p_id_produto, p_id_lote, p_quantidade, p_valor_unitario);
- **Linha 43** (Comentario): Atualiza lote (regra simples): ENTRADA soma, SAIDA subtrai, AJUSTE soma/sub conforme sinal
- **Linha 44**: Estrutura condicional de controle de fluxo.
- **Linha 45**: Atualiza registros existentes na tabela estoque_lote.
- **Linha 46**: WHERE id_lote = p_id_lote;
- **Linha 47**: Estrutura condicional de controle de fluxo.
- **Linha 48**: Atualiza registros existentes na tabela estoque_lote.
- **Linha 49**: WHERE id_lote = p_id_lote;
- **Linha 50**: Estrutura condicional de controle de fluxo.
- **Linha 51**: Atualiza registros existentes na tabela estoque_lote.
- **Linha 52**: WHERE id_lote = p_id_lote;
- **Linha 53**: Estrutura condicional de controle de fluxo.
- **Linha 55**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 57**: COMMIT;
- **Linha 58**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estoque_movimento_item_add`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_movimento      BIGINT,
    IN p_id_produto        BIGINT,
    IN p_id_lote           BIGINT,
    IN p_quantidade        DECIMAL(14,3),
    IN p_valor_unitario    DECIMAL(14,4)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_tipo VARCHAR(20);
    DECLARE v_id_local BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_estoque_movimento_item_add', 'Falha ao inserir item movimento');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_estoque_movimento_item_add | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_movimento IS NOT NULL, 'PARAM', 'id_movimento é obrigatório.');
    CALL sp_assert_true(p_id_produto IS NOT NULL, 'PARAM', 'id_produto é obrigatório.');
    CALL sp_assert_true(p_quantidade IS NOT NULL AND p_quantidade <> 0, 'PARAM', 'quantidade inválida.');

    START TRANSACTION;

    SELECT m.tipo, m.id_estoque_local
      INTO v_tipo, v_id_local
      FROM estoque_movimento m
     WHERE m.id_movimento = p_id_movimento
     LIMIT 1;

    CALL sp_assert_true(v_tipo IS NOT NULL, 'MOV', 'Movimento não encontrado.');

    INSERT INTO estoque_movimento_item (id_movimento, id_produto, id_lote, quantidade, valor_unitario)
    VALUES (p_id_movimento, p_id_produto, p_id_lote, p_quantidade, p_valor_unitario);

    -- Atualiza lote (regra simples): ENTRADA soma, SAIDA subtrai, AJUSTE soma/sub conforme sinal
    IF v_tipo = 'ENTRADA' THEN
        UPDATE estoque_lote SET quantidade = quantidade + p_quantidade, atualizado_em = NOW()
         WHERE id_lote = p_id_lote;
    ELSEIF v_tipo = 'SAIDA' THEN
        UPDATE estoque_lote SET quantidade = quantidade - p_quantidade, atualizado_em = NOW()
         WHERE id_lote = p_id_lote;
    ELSE
        UPDATE estoque_lote SET quantidade = quantidade + p_quantidade, atualizado_em = NOW()
         WHERE id_lote = p_id_lote;
    END IF;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'ESTOQUE_MOV_ITEM_ADD', 'estoque_movimento_item', LAST_INSERT_ID());

    COMMIT;
END ;;
```

