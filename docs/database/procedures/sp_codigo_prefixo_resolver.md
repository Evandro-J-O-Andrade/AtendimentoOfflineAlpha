# sp_codigo_prefixo_resolver

Objetivo: codigo prefixo resolver conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_tipo | VARCHAR(30) | IN | |
| p_id_unidade | BIGINT | IN | |
| p_id_local_operacional | BIGINT | IN | |
| p_prefixo5 | CHAR(5) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: codigo_prefixo_regra
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CHAR_LENGTH
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
- **Linha 7**: fechamento da lista de Parametros.
- **Linha 8**: main: BEGIN
- **Linha 9**: Declaracao de variavel local v_sqlstate.
- **Linha 10**: Declaracao de variavel local v_errno.
- **Linha 11**: Declaracao de variavel local v_msg.
- **Linha 13**: Declaracao de variavel local EXIT.
- **Linha 14**: inicio do bloco de execucao.
- **Linha 15**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 16**: ROLLBACK;
- **Linha 17**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 18**: Invoca a procedure sp_raise.
- **Linha 19**: Fim do bloco da procedure.
- **Linha 21**: atribuicao de valor Ã  variavel p_prefixo5.
- **Linha 23**: Invoca a procedure sp_sessao_assert.
- **Linha 24**: Invoca a procedure sp_assert_true.
- **Linha 26**: START TRANSACTION;
- **Linha 28** (Comentario): prioridade:
- **Linha 29** (Comentario): 1) tipo + unidade + local
- **Linha 30** (Comentario): 2) tipo + unidade
- **Linha 31** (Comentario): 3) tipo global
- **Linha 32**: execucao de query SELECT para consulta de dados.
- **Linha 33**: INTO p_prefixo5
- **Linha 34**: FROM codigo_prefixo_regra r
- **Linha 35**: WHERE r.ativo = 1
- **Linha 39**: ORDER BY
- **Linha 40**: (r.id_unidade IS NOT NULL) DESC,
- **Linha 41**: (r.id_local_operacional IS NOT NULL) DESC,
- **Linha 42**: r.id_regra DESC
- **Linha 43**: LIMIT 1;
- **Linha 45**: COMMIT;
- **Linha 47**: Invoca a procedure sp_assert_true.
- **Linha 48**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigo_prefixo_resolver`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_tipo              VARCHAR(30),
    IN  p_id_unidade        BIGINT,
    IN  p_id_local_operacional BIGINT,
    OUT p_prefixo5          CHAR(5)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_codigo_prefixo_resolver', 'Falha ao resolver prefixo');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_codigo_prefixo_resolver | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_prefixo5 = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_tipo IS NOT NULL AND CHAR_LENGTH(p_tipo)>0, 'PARAM', 'tipo é obrigatório.');

    START TRANSACTION;

    -- prioridade:
    -- 1) tipo + unidade + local
    -- 2) tipo + unidade
    -- 3) tipo global
    SELECT r.prefixo5
      INTO p_prefixo5
      FROM codigo_prefixo_regra r
     WHERE r.ativo = 1
       AND r.tipo = p_tipo
       AND ((p_id_unidade IS NULL AND r.id_unidade IS NULL) OR r.id_unidade = p_id_unidade)
       AND ((p_id_local_operacional IS NULL AND r.id_local_operacional IS NULL) OR r.id_local_operacional = p_id_local_operacional)
     ORDER BY
       (r.id_unidade IS NOT NULL) DESC,
       (r.id_local_operacional IS NOT NULL) DESC,
       r.id_regra DESC
     LIMIT 1;

    COMMIT;

    CALL sp_assert_true(p_prefixo5 IS NOT NULL, 'PREFIXO', 'Prefixo5 não configurado para este tipo/contexto.');
END ;;
```

