# sp_ffa_gpat_garantir

Objetivo: ffa gpat garantir conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_ffa | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: ffa, sessao_usuario
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_codigo_prefixo_resolver
- sp_ffa_gpat_gerar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IF
- IFNULL

## Views Utilizadas
- v_prefixo5
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
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: main: BEGIN
- **Linha 7**: Declaracao de variavel local v_sqlstate.
- **Linha 8**: Declaracao de variavel local v_errno.
- **Linha 9**: Declaracao de variavel local v_msg.
- **Linha 11**: Declaracao de variavel local v_id_gpat.
- **Linha 12**: Declaracao de variavel local v_id_unidade.
- **Linha 13**: Declaracao de variavel local v_id_local.
- **Linha 14**: Declaracao de variavel local v_prefixo5.
- **Linha 16**: Declaracao de variavel local EXIT.
- **Linha 17**: inicio do bloco de execucao.
- **Linha 18**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 19**: ROLLBACK;
- **Linha 20**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 21**: Invoca a procedure sp_raise.
- **Linha 22**: Fim do bloco da procedure.
- **Linha 24**: Invoca a procedure sp_sessao_assert.
- **Linha 25**: Invoca a procedure sp_assert_true.
- **Linha 27**: START TRANSACTION;
- **Linha 29**: execucao de query SELECT para consulta de dados.
- **Linha 30**: FROM ffa f
- **Linha 31**: WHERE f.id = p_id_ffa
- **Linha 32**: LIMIT 1;
- **Linha 34**: Estrutura condicional de controle de fluxo.
- **Linha 35**: COMMIT;
- **Linha 36**: Estrutura de repeticao/controle de loop.
- **Linha 37**: Estrutura condicional de controle de fluxo.
- **Linha 39** (Comentario): tenta pegar contexto da sessão (se existir)
- **Linha 40**: atribuicao de valor Ã  variavel v_id_unidade.
- **Linha 41**: atribuicao de valor Ã  variavel v_id_local.
- **Linha 42**: execucao de query SELECT para consulta de dados.
- **Linha 43**: INTO v_id_unidade, v_id_local
- **Linha 44**: FROM sessao_usuario su
- **Linha 45**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 46**: LIMIT 1;
- **Linha 48**: Invoca a procedure sp_codigo_prefixo_resolver.
- **Linha 50** (Comentario): chama SP canônica do pack 70–85 (já existente)
- **Linha 51**: Invoca a procedure sp_ffa_gpat_gerar.
- **Linha 53**: COMMIT;
- **Linha 54**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_gpat_garantir`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa            BIGINT,
    IN p_tipo_prefixo      VARCHAR(30) -- normalmente 'GPAT'
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_gpat BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_prefixo5 CHAR(5);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_ffa_gpat_garantir', 'Falha ao garantir GPAT');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_ffa_gpat_garantir | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa (ffa.id) é obrigatório.');

    START TRANSACTION;

    SELECT f.id_gpat INTO v_id_gpat
      FROM ffa f
     WHERE f.id = p_id_ffa
     LIMIT 1;

    IF v_id_gpat IS NOT NULL THEN
        COMMIT;
        LEAVE main;
    END IF;

    -- tenta pegar contexto da sessão (se existir)
    SET v_id_unidade = NULL;
    SET v_id_local   = NULL;
    SELECT su.id_unidade, su.id_local_operacional
      INTO v_id_unidade, v_id_local
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
     LIMIT 1;

    CALL sp_codigo_prefixo_resolver(p_id_sessao_usuario, IFNULL(p_tipo_prefixo,'GPAT'), v_id_unidade, v_id_local, v_prefixo5);

    -- chama SP canônica do pack 70–85 (já existente)
    CALL sp_ffa_gpat_gerar(p_id_sessao_usuario, p_id_ffa, v_prefixo5);

    COMMIT;
END ;;
```

