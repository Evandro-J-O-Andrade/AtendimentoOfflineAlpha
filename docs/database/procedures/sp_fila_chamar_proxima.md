# sp_fila_chamar_proxima

Objetivo: fila chamar proxima conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_setor | VARCHAR(50) | IN | |
| p_id_local_operacional | BIGINT | IN | |
| p_id_fila | BIGINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fila_operacional
- INSERT: fila_operacional_evento
- UPDATE: fila_operacional
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
- NOW

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
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: main: BEGIN
- **Linha 9**: Declaracao de variavel local v_sqlstate.
- **Linha 10**: Declaracao de variavel local v_errno.
- **Linha 11**: Declaracao de variavel local v_msg.
- **Linha 13**: Declaracao de variavel local v_id_fila.
- **Linha 15**: Declaracao de variavel local EXIT.
- **Linha 16**: inicio do bloco de execucao.
- **Linha 17**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 18**: ROLLBACK;
- **Linha 19**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 20**: Invoca a procedure sp_raise.
- **Linha 21**: Fim do bloco da procedure.
- **Linha 23**: atribuicao de valor Ã  variavel p_id_fila.
- **Linha 25**: Invoca a procedure sp_sessao_assert.
- **Linha 26**: Invoca a procedure sp_assert_true.
- **Linha 28**: START TRANSACTION;
- **Linha 30**: execucao de query SELECT para consulta de dados.
- **Linha 31**: INTO v_id_fila
- **Linha 32**: FROM fila_operacional fo
- **Linha 33**: WHERE fo.setor = p_setor
- **Linha 35**: ORDER BY fo.prioridade DESC, fo.criado_em ASC
- **Linha 36**: LIMIT 1
- **Linha 37**: FOR UPDATE;
- **Linha 39**: Invoca a procedure sp_assert_true.
- **Linha 41**: UPDATE fila_operacional
- **Linha 42**: atribuicao de valor Ã  variavel status.
- **Linha 43**: id_local_operacional = p_id_local_operacional,
- **Linha 44**: atualizado_em = NOW()
- **Linha 45**: WHERE id_fila = v_id_fila;
- **Linha 47**: Insere um novo registro na tabela fila_operacional_evento.
- **Linha 48**: id_fila, tipo_evento, descricao, id_sessao_usuario, criado_em
- **Linha 49**: ) VALUES (
- **Linha 50**: v_id_fila, 'CHAMAR', CONCAT('Chamando próximo para setor=', p_setor),
- **Linha 51**: p_id_sessao_usuario, NOW()
- **Linha 52**: );
- **Linha 54** (Comentario): Auditoria GLOBAL (núcleo imutável)
- **Linha 55**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 57**: atribuicao de valor Ã  variavel p_id_fila.
- **Linha 59**: COMMIT;
- **Linha 60**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fila_chamar_proxima`(
    IN p_id_sessao_usuario BIGINT,
    IN p_setor VARCHAR(50),
    IN p_id_local_operacional BIGINT,
    OUT p_id_fila BIGINT
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_fila BIGINT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_fila_chamar_proxima', 'Falha ao chamar próxima fila');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_fila_chamar_proxima | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_fila = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_setor IS NOT NULL AND p_setor <> '', 'PARAM', 'setor é obrigatório.');

    START TRANSACTION;

    SELECT fo.id_fila
      INTO v_id_fila
      FROM fila_operacional fo
     WHERE fo.setor = p_setor
       AND fo.status = 'AGUARDANDO'
     ORDER BY fo.prioridade DESC, fo.criado_em ASC
     LIMIT 1
     FOR UPDATE;

    CALL sp_assert_true(v_id_fila IS NOT NULL, 'FILA', 'Sem itens aguardando para o setor.');

    UPDATE fila_operacional
       SET status = 'CHAMANDO',
           id_local_operacional = p_id_local_operacional,
           atualizado_em = NOW()
     WHERE id_fila = v_id_fila;

    INSERT INTO fila_operacional_evento (
        id_fila, tipo_evento, descricao, id_sessao_usuario, criado_em
    ) VALUES (
        v_id_fila, 'CHAMAR', CONCAT('Chamando próximo para setor=', p_setor),
        p_id_sessao_usuario, NOW()
    );

    -- Auditoria GLOBAL (núcleo imutável)
    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'FILA_CHAMADA', 'fila_operacional', v_id_fila);

    SET p_id_fila = v_id_fila;

    COMMIT;
END ;;
```

