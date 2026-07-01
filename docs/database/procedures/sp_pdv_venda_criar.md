# sp_pdv_venda_criar

Objetivo: pdv venda criar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_estoque_local | BIGINT | IN | |
| p_id_cliente | BIGINT | IN | |
| p_id_venda | BIGINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: pdv_venda
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_codigo_emitir_interno
- sp_codigo_prefixo_resolver
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IFNULL
- LAST_INSERT_ID

## Views Utilizadas
- v_codigo
- v_prefixo5
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
- **Linha 12**: Declaracao de variavel local v_id_unidade.
- **Linha 13**: Declaracao de variavel local v_id_local.
- **Linha 14**: Declaracao de variavel local v_prefixo5.
- **Linha 15**: Declaracao de variavel local v_id_codigo.
- **Linha 16**: Declaracao de variavel local v_codigo.
- **Linha 18**: Declaracao de variavel local EXIT.
- **Linha 19**: inicio do bloco de execucao.
- **Linha 20**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 21**: ROLLBACK;
- **Linha 22**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 23**: Invoca a procedure sp_raise.
- **Linha 24**: Fim do bloco da procedure.
- **Linha 26**: atribuicao de valor Ã  variavel p_id_venda.
- **Linha 28**: Invoca a procedure sp_sessao_assert.
- **Linha 29**: Invoca a procedure sp_assert_true.
- **Linha 31**: START TRANSACTION;
- **Linha 33**: atribuicao de valor Ã  variavel v_id_unidade.
- **Linha 34**: atribuicao de valor Ã  variavel v_id_local.
- **Linha 35**: execucao de query SELECT para consulta de dados.
- **Linha 36**: INTO v_id_unidade, v_id_local
- **Linha 37**: FROM sessao_usuario su
- **Linha 38**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 39**: LIMIT 1;
- **Linha 41**: Invoca a procedure sp_codigo_prefixo_resolver.
- **Linha 43**: Invoca a procedure sp_codigo_emitir_interno.
- **Linha 44**: p_id_sessao_usuario,
- **Linha 45**: 'PDV',
- **Linha 46**: v_prefixo5,
- **Linha 47**: NULL, NULL, NULL,
- **Linha 48**: NULL,
- **Linha 49**: NULL, NULL, NULL, NULL, NULL,
- **Linha 50**: NULL,
- **Linha 51**: @out_id_codigo,
- **Linha 52**: @out_codigo_interno,
- **Linha 53**: @out_barcode
- **Linha 54**: );
- **Linha 56**: atribuicao de valor Ã  variavel v_id_codigo.
- **Linha 57**: atribuicao de valor Ã  variavel v_codigo.
- **Linha 59**: Insere um novo registro na tabela pdv_venda.
- **Linha 60**: VALUES (p_id_estoque_local, p_id_cliente, v_id_codigo, v_codigo, v_codigo, 'ABERTA', p_id_sessao_usuario);
- **Linha 62**: atribuicao de valor Ã  variavel p_id_venda.
- **Linha 64**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 66**: COMMIT;
- **Linha 67**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pdv_venda_criar`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_estoque_local  BIGINT,
    IN  p_id_cliente        BIGINT,
    OUT p_id_venda          BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_prefixo5 CHAR(5);
    DECLARE v_id_codigo BIGINT;
    DECLARE v_codigo VARCHAR(60);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_pdv_venda_criar', 'Falha ao criar venda');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_pdv_venda_criar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_venda = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_estoque_local IS NOT NULL, 'PARAM', 'id_estoque_local é obrigatório.');

    START TRANSACTION;

    SET v_id_unidade = NULL;
    SET v_id_local   = NULL;
    SELECT su.id_unidade, su.id_local_operacional
      INTO v_id_unidade, v_id_local
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
     LIMIT 1;

    CALL sp_codigo_prefixo_resolver(p_id_sessao_usuario, 'PDV', v_id_unidade, v_id_local, v_prefixo5);

    CALL sp_codigo_emitir_interno(
        p_id_sessao_usuario,
        'PDV',
        v_prefixo5,
        NULL, NULL, NULL,
        NULL,
        NULL, NULL, NULL, NULL, NULL,
        NULL,
        @out_id_codigo,
        @out_codigo_interno,
        @out_barcode
    );

    SET v_id_codigo = @out_id_codigo;
    SET v_codigo    = @out_codigo_interno;

    INSERT INTO pdv_venda (id_estoque_local, id_cliente, id_codigo_universal, codigo, barcode, status, id_sessao_usuario)
    VALUES (p_id_estoque_local, p_id_cliente, v_id_codigo, v_codigo, v_codigo, 'ABERTA', p_id_sessao_usuario);

    SET p_id_venda = LAST_INSERT_ID();

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'PDV_VENDA_CRIADA', 'pdv_venda', p_id_venda);

    COMMIT;
END ;;
```

