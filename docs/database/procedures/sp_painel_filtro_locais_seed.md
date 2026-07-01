# sp_painel_filtro_locais_seed

Objetivo: painel filtro locais seed conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_painel_codigo | VARCHAR(60) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: local_operacional, painel
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_painel_config_set
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CAST
- COALESCE
- CONCAT
- IFNULL

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
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: fechamento da lista de Parametros.
- **Linha 9**: main: BEGIN
- **Linha 10**: Declaracao de variavel local v_id_painel.
- **Linha 11**: Declaracao de variavel local v_id_unidade.
- **Linha 12**: Declaracao de variavel local v_id_sistema.
- **Linha 14**: Declaracao de variavel local v_json_text.
- **Linha 15**: Declaracao de variavel local v_json_val.
- **Linha 17**: Declaracao de variavel local v_sqlstate.
- **Linha 18**: Declaracao de variavel local v_errno.
- **Linha 19**: Declaracao de variavel local v_msg.
- **Linha 21**: Declaracao de variavel local EXIT.
- **Linha 22**: inicio do bloco de execucao.
- **Linha 23**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 24**: ROLLBACK;
- **Linha 25**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 26**: Invoca a procedure sp_raise.
- **Linha 27**: 'ROTINA=sp_painel_filtro_locais_seed | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
- **Linha 28**: ' | ERRNO=',IFNULL(v_errno,0),
- **Linha 29**: ' | MSG=',IFNULL(v_msg,'(n/a)'),
- **Linha 30**: ' | CTX=painel=',IFNULL(p_painel_codigo,'NULL')
- **Linha 31**: ));
- **Linha 32**: Fim do bloco da procedure.
- **Linha 34**: Invoca a procedure sp_sessao_assert.
- **Linha 36**: execucao de query SELECT para consulta de dados.
- **Linha 37**: INTO v_id_painel, v_id_unidade, v_id_sistema
- **Linha 38**: FROM painel p
- **Linha 39**: WHERE p.codigo COLLATE utf8mb4_0900_ai_ci = p_painel_codigo COLLATE utf8mb4_0900_ai_ci
- **Linha 40**: LIMIT 1;
- **Linha 42**: Invoca a procedure sp_assert_true.
- **Linha 44**: /*
- **Linha 45**: Monta JSON (array de strings) via GROUP_CONCAT + JSON_QUOTE.
- **Linha 46**: Se não existir nenhum local, vira '[]'.
- **Linha 47**: */
- **Linha 48**: SELECT
- **Linha 49**: COALESCE(
- **Linha 50**: CONCAT(
- **Linha 51**: '[',
- **Linha 52**: GROUP_CONCAT(JSON_QUOTE(lo.codigo) ORDER BY lo.codigo SEPARATOR ','),
- **Linha 53**: ']'
- **Linha 54**: ),
- **Linha 55**: '[]'
- **Linha 56**: fechamento da lista de Parametros.
- **Linha 57**: INTO v_json_text
- **Linha 58**: FROM local_operacional lo
- **Linha 59**: WHERE lo.id_unidade = v_id_unidade
- **Linha 67**: atribuicao de valor Ã  variavel v_json_val.
- **Linha 69**: START TRANSACTION;
- **Linha 70**: Invoca a procedure sp_painel_config_set.
- **Linha 71**: p_id_sessao_usuario,
- **Linha 72**: v_id_painel,
- **Linha 73**: 'FILTRO_LOCAIS_CODIGOS_JSON',
- **Linha 74**: NULL,  -- bool
- **Linha 75**: NULL,  -- int
- **Linha 76**: NULL,  -- decimal
- **Linha 77**: NULL,  -- text
- **Linha 78**: v_json_val, -- json
- **Linha 79**: NULL   -- enum
- **Linha 80**: );
- **Linha 81**: COMMIT;
- **Linha 82**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`pa_owner`@`%` PROCEDURE `sp_painel_filtro_locais_seed`(
    IN p_id_sessao_usuario BIGINT,
    IN p_painel_codigo     VARCHAR(60),
    IN p_local_tipo        VARCHAR(60),   -- pode ser NULL (não filtra por tipo)
    IN p_codigo_prefix     VARCHAR(60),   -- prefixo (ou código exato via prefixo), pode ser NULL
    IN p_excluir_prefix    VARCHAR(60),   -- prefixo a excluir (ex.: MEDP), pode ser NULL
    IN p_incluir_nd        TINYINT        -- 0 = não inclui ND, 1 = inclui ND
)
main: BEGIN
    DECLARE v_id_painel BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_sistema BIGINT;

    DECLARE v_json_text TEXT;
    DECLARE v_json_val  JSON;

    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_painel_filtro_locais_seed', 'Falha ao seedar filtro de locais do painel');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_painel_filtro_locais_seed | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=',IFNULL(v_errno,0),
            ' | MSG=',IFNULL(v_msg,'(n/a)'),
            ' | CTX=painel=',IFNULL(p_painel_codigo,'NULL')
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT p.id_painel, p.id_unidade, p.id_sistema
      INTO v_id_painel, v_id_unidade, v_id_sistema
      FROM painel p
     WHERE p.codigo COLLATE utf8mb4_0900_ai_ci = p_painel_codigo COLLATE utf8mb4_0900_ai_ci
     LIMIT 1;

    CALL sp_assert_true(v_id_painel IS NOT NULL, 'NOT_FOUND', CONCAT('Painel não encontrado: ', IFNULL(p_painel_codigo,'NULL')));

    /*
      Monta JSON (array de strings) via GROUP_CONCAT + JSON_QUOTE.
      Se não existir nenhum local, vira '[]'.
    */
    SELECT
      COALESCE(
        CONCAT(
          '[',
          GROUP_CONCAT(JSON_QUOTE(lo.codigo) ORDER BY lo.codigo SEPARATOR ','),
          ']'
        ),
        '[]'
      )
    INTO v_json_text
    FROM local_operacional lo
    WHERE lo.id_unidade = v_id_unidade
      AND lo.id_sistema = v_id_sistema
      AND lo.ativo = 1
      AND (p_local_tipo IS NULL OR lo.tipo COLLATE utf8mb4_0900_ai_ci = p_local_tipo COLLATE utf8mb4_0900_ai_ci)
      AND (p_incluir_nd = 1 OR IFNULL(lo.eh_nao_definida,0) = 0)
      AND (p_codigo_prefix IS NULL OR lo.codigo COLLATE utf8mb4_0900_ai_ci LIKE CONCAT(p_codigo_prefix COLLATE utf8mb4_0900_ai_ci, '%') COLLATE utf8mb4_0900_ai_ci)
      AND (p_excluir_prefix IS NULL OR lo.codigo COLLATE utf8mb4_0900_ai_ci NOT LIKE CONCAT(p_excluir_prefix COLLATE utf8mb4_0900_ai_ci, '%') COLLATE utf8mb4_0900_ai_ci);

    SET v_json_val = CAST(v_json_text AS JSON);

    START TRANSACTION;
      CALL sp_painel_config_set(
        p_id_sessao_usuario,
        v_id_painel,
        'FILTRO_LOCAIS_CODIGOS_JSON',
        NULL,  -- bool
        NULL,  -- int
        NULL,  -- decimal
        NULL,  -- text
        v_json_val, -- json
        NULL   -- enum
      );
    COMMIT;
END ;;
```

