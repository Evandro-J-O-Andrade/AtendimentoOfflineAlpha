# sp_estoque_produto_criar_com_codigo

Objetivo: estoque produto criar com codigo conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_nome | VARCHAR(255) | IN | |
| p_categoria | VARCHAR(120) | IN | |
| p_exige_receita | TINYINT | IN | |
| p_controlado | TINYINT | IN | |
| p_id_produto | BIGINT | OUT | |
| p_sku | VARCHAR(60) | OUT | |
| p_barcode | VARCHAR(60) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: estoque_produto
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
- CHAR_LENGTH
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
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: Declaracao de parÃ¢metro.
- **Linha 10**: fechamento da lista de Parametros.
- **Linha 11**: main: BEGIN
- **Linha 12**: Declaracao de variavel local v_sqlstate.
- **Linha 13**: Declaracao de variavel local v_errno.
- **Linha 14**: Declaracao de variavel local v_msg.
- **Linha 16**: Declaracao de variavel local v_id_unidade.
- **Linha 17**: Declaracao de variavel local v_id_local.
- **Linha 18**: Declaracao de variavel local v_prefixo5.
- **Linha 20**: Declaracao de variavel local v_id_codigo.
- **Linha 21**: Declaracao de variavel local v_codigo.
- **Linha 23**: Declaracao de variavel local EXIT.
- **Linha 24**: inicio do bloco de execucao.
- **Linha 25**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 26**: ROLLBACK;
- **Linha 27**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 28**: Invoca a procedure sp_raise.
- **Linha 29**: Fim do bloco da procedure.
- **Linha 31**: atribuicao de valor Ã  variavel p_id_produto.
- **Linha 32**: atribuicao de valor Ã  variavel p_sku.
- **Linha 33**: atribuicao de valor Ã  variavel p_barcode.
- **Linha 35**: Invoca a procedure sp_sessao_assert.
- **Linha 36**: Invoca a procedure sp_assert_true.
- **Linha 38**: START TRANSACTION;
- **Linha 40**: atribuicao de valor Ã  variavel v_id_unidade.
- **Linha 41**: atribuicao de valor Ã  variavel v_id_local.
- **Linha 42**: execucao de query SELECT para consulta de dados.
- **Linha 43**: INTO v_id_unidade, v_id_local
- **Linha 44**: FROM sessao_usuario su
- **Linha 45**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 46**: LIMIT 1;
- **Linha 48**: Invoca a procedure sp_codigo_prefixo_resolver.
- **Linha 50**: Invoca a procedure sp_codigo_emitir_interno.
- **Linha 51**: p_id_sessao_usuario,
- **Linha 52**: 'FARM_PRODUTO',
- **Linha 53**: v_prefixo5,
- **Linha 54**: NULL, NULL, NULL,
- **Linha 55**: NULL,
- **Linha 56**: NULL, NULL, NULL, NULL, NULL,
- **Linha 57**: NULL,
- **Linha 58**: @out_id_codigo,
- **Linha 59**: @out_codigo_interno,
- **Linha 60**: @out_barcode
- **Linha 61**: );
- **Linha 63**: atribuicao de valor Ã  variavel v_id_codigo.
- **Linha 64**: atribuicao de valor Ã  variavel v_codigo.
- **Linha 66**: Insere um novo registro na tabela estoque_produto.
- **Linha 67**: id_codigo_universal, sku_interno, barcode,
- **Linha 68**: nome, categoria, exige_receita, controlado, ativo
- **Linha 69**: ) VALUES (
- **Linha 70**: v_id_codigo, v_codigo, v_codigo,
- **Linha 71**: p_nome, p_categoria, IFNULL(p_exige_receita,0), IFNULL(p_controlado,0), 1
- **Linha 72**: );
- **Linha 74**: atribuicao de valor Ã  variavel p_id_produto.
- **Linha 75**: atribuicao de valor Ã  variavel p_sku.
- **Linha 76**: atribuicao de valor Ã  variavel p_barcode.
- **Linha 78**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 80**: COMMIT;
- **Linha 81**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estoque_produto_criar_com_codigo`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_nome              VARCHAR(255),
    IN  p_categoria         VARCHAR(120),
    IN  p_exige_receita     TINYINT,
    IN  p_controlado        TINYINT,
    OUT p_id_produto        BIGINT,
    OUT p_sku               VARCHAR(60),
    OUT p_barcode           VARCHAR(60)
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
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_estoque_produto_criar_com_codigo', 'Falha ao criar produto');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_estoque_produto_criar_com_codigo | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_produto = NULL;
    SET p_sku = NULL;
    SET p_barcode = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_nome IS NOT NULL AND CHAR_LENGTH(p_nome)>1, 'PARAM', 'nome é obrigatório.');

    START TRANSACTION;

    SET v_id_unidade = NULL;
    SET v_id_local   = NULL;
    SELECT su.id_unidade, su.id_local_operacional
      INTO v_id_unidade, v_id_local
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
     LIMIT 1;

    CALL sp_codigo_prefixo_resolver(p_id_sessao_usuario, 'FARM_PRODUTO', v_id_unidade, v_id_local, v_prefixo5);

    CALL sp_codigo_emitir_interno(
        p_id_sessao_usuario,
        'FARM_PRODUTO',
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

    INSERT INTO estoque_produto (
        id_codigo_universal, sku_interno, barcode,
        nome, categoria, exige_receita, controlado, ativo
    ) VALUES (
        v_id_codigo, v_codigo, v_codigo,
        p_nome, p_categoria, IFNULL(p_exige_receita,0), IFNULL(p_controlado,0), 1
    );

    SET p_id_produto = LAST_INSERT_ID();
    SET p_sku = v_codigo;
    SET p_barcode = v_codigo;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'PRODUTO_CRIADO', 'estoque_produto', p_id_produto);

    COMMIT;
END ;;
```

