# sp_ffa_gpat_gerar

Objetivo: ffa gpat gerar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_prefixo_5 | CHAR(5) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: ffa
- INSERT: gpat
- UPDATE: ffa
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_codigo_emitir_interno
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CHAR_LENGTH
- CONCAT
- IF
- IFNULL
- LAST_INSERT_ID

## Views Utilizadas
- v_barcode
- v_codigo
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
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: main: BEGIN
- **Linha 7**: Declaracao de variavel local v_sqlstate.
- **Linha 8**: Declaracao de variavel local v_errno.
- **Linha 9**: Declaracao de variavel local v_msg.
- **Linha 11**: Declaracao de variavel local v_id_codigo.
- **Linha 12**: Declaracao de variavel local v_codigo.
- **Linha 13**: Declaracao de variavel local v_barcode.
- **Linha 14**: Declaracao de variavel local v_id_gpat.
- **Linha 16**: Declaracao de variavel local EXIT.
- **Linha 17**: inicio do bloco de execucao.
- **Linha 18**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 19**: ROLLBACK;
- **Linha 20**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 21**: Invoca a procedure sp_raise.
- **Linha 22**: Fim do bloco da procedure.
- **Linha 24**: Invoca a procedure sp_sessao_assert.
- **Linha 25**: Invoca a procedure sp_assert_true.
- **Linha 26**: Invoca a procedure sp_assert_true.
- **Linha 28**: START TRANSACTION;
- **Linha 30**: execucao de query SELECT para consulta de dados.
- **Linha 31**: FROM ffa f
- **Linha 32**: WHERE f.id = p_id_ffa
- **Linha 33**: LIMIT 1;
- **Linha 35**: Estrutura condicional de controle de fluxo.
- **Linha 36**: COMMIT;
- **Linha 37**: Estrutura de repeticao/controle de loop.
- **Linha 38**: Estrutura condicional de controle de fluxo.
- **Linha 40** (Comentario): Depende do teu pack 60-70: sp_codigo_emitir_interno
- **Linha 41**: Invoca a procedure sp_codigo_emitir_interno.
- **Linha 42**: p_id_sessao_usuario,
- **Linha 43**: 'GPAT',
- **Linha 44**: p_prefixo_5,
- **Linha 45**: NULL, NULL, NULL,
- **Linha 46**: p_id_ffa,
- **Linha 47**: NULL, NULL, NULL, NULL, NULL,
- **Linha 48**: NULL,
- **Linha 49**: @out_id_codigo,
- **Linha 50**: @out_codigo_interno,
- **Linha 51**: @out_barcode
- **Linha 52**: );
- **Linha 54**: atribuicao de valor Ã  variavel v_id_codigo.
- **Linha 55**: atribuicao de valor Ã  variavel v_codigo.
- **Linha 56**: atribuicao de valor Ã  variavel v_barcode.
- **Linha 58**: Insere um novo registro na tabela gpat.
- **Linha 59**: VALUES (p_id_ffa, v_id_codigo, v_codigo, v_barcode, 'AUTO');
- **Linha 61**: atribuicao de valor Ã  variavel v_id_gpat.
- **Linha 63**: UPDATE ffa
- **Linha 64**: atribuicao de valor Ã  variavel id_gpat.
- **Linha 65**: WHERE id = p_id_ffa;
- **Linha 67**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 69**: COMMIT;
- **Linha 70**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_gpat_gerar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa            BIGINT,  -- referencia ffa.id
    IN p_prefixo_5         CHAR(5)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_codigo BIGINT;
    DECLARE v_codigo VARCHAR(50);
    DECLARE v_barcode VARCHAR(60);
    DECLARE v_id_gpat BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_ffa_gpat_gerar', 'Falha ao gerar GPAT');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_ffa_gpat_gerar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa (ffa.id) é obrigatório.');
    CALL sp_assert_true(p_prefixo_5 IS NOT NULL AND CHAR_LENGTH(p_prefixo_5)=5, 'PARAM', 'prefixo_5 deve ter 5 dígitos.');

    START TRANSACTION;

    SELECT f.id_gpat INTO v_id_gpat
      FROM ffa f
     WHERE f.id = p_id_ffa
     LIMIT 1;

    IF v_id_gpat IS NOT NULL THEN
        COMMIT;
        LEAVE main;
    END IF;

    -- Depende do teu pack 60-70: sp_codigo_emitir_interno
    CALL sp_codigo_emitir_interno(
        p_id_sessao_usuario,
        'GPAT',
        p_prefixo_5,
        NULL, NULL, NULL,
        p_id_ffa,
        NULL, NULL, NULL, NULL, NULL,
        NULL,
        @out_id_codigo,
        @out_codigo_interno,
        @out_barcode
    );

    SET v_id_codigo = @out_id_codigo;
    SET v_codigo    = @out_codigo_interno;
    SET v_barcode   = @out_barcode;

    INSERT INTO gpat (id_ffa, id_codigo_universal, codigo_gpat, barcode_gpat, origem)
    VALUES (p_id_ffa, v_id_codigo, v_codigo, v_barcode, 'AUTO');

    SET v_id_gpat = LAST_INSERT_ID();

    UPDATE ffa
       SET id_gpat = v_id_gpat
     WHERE id = p_id_ffa;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'GPAT_GERADO', 'gpat', v_id_gpat);

    COMMIT;
END ;;
```

