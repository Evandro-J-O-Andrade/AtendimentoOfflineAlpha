# sp_estoque_produto_set_codigo

Objetivo: estoque produto set codigo conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_produto | INT | IN | |
| p_id_unidade | BIGINT | IN | |
| p_id_local_operacional | BIGINT | IN | |
| p_gtin_ean | VARCHAR(30) | IN | |
| p_codigo_interno_manual | VARCHAR(50) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: (nenhuma)
- UPDATE: estoque_produtos
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_codigo_emitir_interno
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- COALESCE
- CONCAT
- CURRENT_TIMESTAMP
- IF
- IFNULL
- JSON_OBJECT
- NULLIF
- TRIM

## Views Utilizadas
- v_codigo_interno
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
- **Linha 8**: fechamento da lista de Parametros.
- **Linha 9**: main: BEGIN
- **Linha 10**: Declaracao de variavel local v_sqlstate.
- **Linha 11**: Declaracao de variavel local v_errno.
- **Linha 12**: Declaracao de variavel local v_msg.
- **Linha 14**: Declaracao de variavel local v_id_codigo.
- **Linha 15**: Declaracao de variavel local v_codigo_interno.
- **Linha 17**: Declaracao de variavel local EXIT.
- **Linha 18**: inicio do bloco de execucao.
- **Linha 19**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 20**: ROLLBACK;
- **Linha 21**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 22**: Invoca a procedure sp_raise.
- **Linha 23**: Fim do bloco da procedure.
- **Linha 25**: Invoca a procedure sp_sessao_assert.
- **Linha 26**: Invoca a procedure sp_assert_true.
- **Linha 28**: START TRANSACTION;
- **Linha 30** (Comentario): atualiza GTIN/EAN se vier
- **Linha 31**: Estrutura condicional de controle de fluxo.
- **Linha 32**: UPDATE estoque_produtos
- **Linha 33**: atribuicao de valor Ã  variavel gtin_ean.
- **Linha 34**: codigo_ean = COALESCE(codigo_ean, TRIM(p_gtin_ean)),
- **Linha 35**: atualizado_em = CURRENT_TIMESTAMP
- **Linha 36**: WHERE id = p_id_produto;
- **Linha 37**: Estrutura condicional de controle de fluxo.
- **Linha 39** (Comentario): gera/usa interno (domínio ESTOQUE)
- **Linha 40**: Invoca a procedure sp_codigo_emitir_interno.
- **Linha 41**: p_id_sessao_usuario,
- **Linha 42**: 'ESTOQUE',
- **Linha 43**: p_id_unidade,
- **Linha 44**: p_id_local_operacional,
- **Linha 45**: NULL,
- **Linha 46**: p_codigo_interno_manual,
- **Linha 47**: NULL,
- **Linha 48**: NULL,
- **Linha 49**: NULL,
- **Linha 50**: p_id_produto,
- **Linha 51**: NULL,
- **Linha 52**: NULL,
- **Linha 53**: JSON_OBJECT('produto_id', p_id_produto),
- **Linha 54**: v_id_codigo,
- **Linha 55**: v_codigo_interno
- **Linha 56**: );
- **Linha 58**: UPDATE estoque_produtos
- **Linha 59**: atribuicao de valor Ã  variavel codigo_interno.
- **Linha 60**: barcode_interno = v_codigo_interno,
- **Linha 61**: atualizado_em = CURRENT_TIMESTAMP
- **Linha 62**: WHERE id = p_id_produto;
- **Linha 64**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 65**: 'id_produto', p_id_produto,
- **Linha 66**: 'gtin_ean', NULLIF(TRIM(p_gtin_ean),''),
- **Linha 67**: 'codigo_interno', v_codigo_interno,
- **Linha 68**: 'id_codigo', v_id_codigo
- **Linha 69**: ));
- **Linha 71**: COMMIT;
- **Linha 72**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estoque_produto_set_codigo`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_produto INT,
    IN p_id_unidade BIGINT,
    IN p_id_local_operacional BIGINT,
    IN p_gtin_ean VARCHAR(30),
    IN p_codigo_interno_manual VARCHAR(50)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_codigo BIGINT;
    DECLARE v_codigo_interno VARCHAR(50);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_estoque_produto_set_codigo', 'Falha ao setar código produto');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_estoque_produto_set_codigo | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_produto IS NOT NULL, 'PARAM', 'id_produto é obrigatório.');

    START TRANSACTION;

    -- atualiza GTIN/EAN se vier
    IF p_gtin_ean IS NOT NULL AND TRIM(p_gtin_ean) <> '' THEN
      UPDATE estoque_produtos
         SET gtin_ean = TRIM(p_gtin_ean),
             codigo_ean = COALESCE(codigo_ean, TRIM(p_gtin_ean)),
             atualizado_em = CURRENT_TIMESTAMP
       WHERE id = p_id_produto;
    END IF;

    -- gera/usa interno (domínio ESTOQUE)
    CALL sp_codigo_emitir_interno(
      p_id_sessao_usuario,
      'ESTOQUE',
      p_id_unidade,
      p_id_local_operacional,
      NULL,
      p_codigo_interno_manual,
      NULL,
      NULL,
      NULL,
      p_id_produto,
      NULL,
      NULL,
      JSON_OBJECT('produto_id', p_id_produto),
      v_id_codigo,
      v_codigo_interno
    );

    UPDATE estoque_produtos
       SET codigo_interno = v_codigo_interno,
           barcode_interno = v_codigo_interno,
           atualizado_em = CURRENT_TIMESTAMP
     WHERE id = p_id_produto;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'ESTOQUE_PRODUTO_CODIGO_SET', JSON_OBJECT(
      'id_produto', p_id_produto,
      'gtin_ean', NULLIF(TRIM(p_gtin_ean),''),
      'codigo_interno', v_codigo_interno,
      'id_codigo', v_id_codigo
    ));

    COMMIT;
END ;;
```

