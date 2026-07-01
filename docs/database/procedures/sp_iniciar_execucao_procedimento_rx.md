# sp_iniciar_execucao_procedimento_rx

Objetivo: iniciar execucao procedimento rx conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_fila | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fila_operacional, sessao_usuario
- INSERT: fila_operacional_evento
- UPDATE: fila_operacional
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_procedimento_protocolo_criar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- COALESCE
- CONCAT
- IFNULL
- NOW

## Views Utilizadas
- v_barcode
- v_codigo
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
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: main: BEGIN
- **Linha 6**: Declaracao de variavel local v_sqlstate.
- **Linha 7**: Declaracao de variavel local v_errno.
- **Linha 8**: Declaracao de variavel local v_msg.
- **Linha 10**: Declaracao de variavel local v_id_usuario.
- **Linha 11**: Declaracao de variavel local v_tipo.
- **Linha 12**: Declaracao de variavel local v_dummy_id.
- **Linha 13**: Declaracao de variavel local v_codigo.
- **Linha 14**: Declaracao de variavel local v_barcode.
- **Linha 16**: Declaracao de variavel local EXIT.
- **Linha 17**: inicio do bloco de execucao.
- **Linha 18**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 19**: ROLLBACK;
- **Linha 20**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 21**: Invoca a procedure sp_raise.
- **Linha 22**: CONCAT('ROTINA=sp_iniciar_execucao_procedimento_rx | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
- **Linha 23**: ' | ERRNO=',IFNULL(v_errno,0),
- **Linha 24**: ' | MSG=',IFNULL(v_msg,'(n/a)')));
- **Linha 25**: Fim do bloco da procedure.
- **Linha 27**: Invoca a procedure sp_sessao_assert.
- **Linha 28**: Invoca a procedure sp_assert_true.
- **Linha 30**: START TRANSACTION;
- **Linha 32**: execucao de query SELECT para consulta de dados.
- **Linha 33**: FROM sessao_usuario su
- **Linha 34**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 36**: LIMIT 1;
- **Linha 38** (Comentario): garante que a fila é RX
- **Linha 39**: Invoca a procedure sp_assert_true.
- **Linha 40**: (SELECT fo.tipo FROM fila_operacional fo WHERE fo.id_fila = p_id_fila LIMIT 1) = 'RX',
- **Linha 41**: 'FILA',
- **Linha 42**: 'Fila informada não é RX.'
- **Linha 43**: );
- **Linha 45** (Comentario): cria protocolo RX se necessário
- **Linha 46**: atribuicao de valor Ã  variavel v_tipo.
- **Linha 47**: Invoca a procedure sp_procedimento_protocolo_criar.
- **Linha 49**: UPDATE fila_operacional
- **Linha 50**: atribuicao de valor Ã  variavel substatus.
- **Linha 51**: data_inicio = COALESCE(data_inicio, NOW()),
- **Linha 52**: id_responsavel = v_id_usuario
- **Linha 53**: WHERE id_fila = p_id_fila;
- **Linha 55**: Insere um novo registro na tabela fila_operacional_evento.
- **Linha 56**: VALUES (p_id_fila, p_id_sessao_usuario, 'INICIO_EXECUCAO', CONCAT('RX iniciado | Protocolo=',COALESCE(v_codigo,'(n/a)')), NOW());
- **Linha 58**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 59**: p_id_sessao_usuario,
- **Linha 60**: 'fila_operacional',
- **Linha 61**: p_id_fila,
- **Linha 62**: 'RX_INICIADO',
- **Linha 63**: CONCAT('Fila RX iniciada | Protocolo=',COALESCE(v_codigo,'(n/a)')),
- **Linha 64**: NULL,
- **Linha 65**: 'fila_operacional',
- **Linha 66**: v_id_usuario
- **Linha 67**: );
- **Linha 69**: COMMIT;
- **Linha 70**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_execucao_procedimento_rx`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_id_usuario BIGINT;
    DECLARE v_tipo ENUM('EXAME','RX');
    DECLARE v_dummy_id BIGINT;
    DECLARE v_codigo VARCHAR(50);
    DECLARE v_barcode VARCHAR(50);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_iniciar_execucao_procedimento_rx', 'Falha ao iniciar RX');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_iniciar_execucao_procedimento_rx | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    START TRANSACTION;

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    -- garante que a fila é RX
    CALL sp_assert_true(
        (SELECT fo.tipo FROM fila_operacional fo WHERE fo.id_fila = p_id_fila LIMIT 1) = 'RX',
        'FILA',
        'Fila informada não é RX.'
    );

    -- cria protocolo RX se necessário
    SET v_tipo = 'RX';
    CALL sp_procedimento_protocolo_criar(p_id_sessao_usuario, p_id_fila, v_tipo, v_dummy_id, v_codigo, v_barcode);

    UPDATE fila_operacional
       SET substatus = 'EM_EXECUCAO',
           data_inicio = COALESCE(data_inicio, NOW()),
           id_responsavel = v_id_usuario
     WHERE id_fila = p_id_fila;

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'INICIO_EXECUCAO', CONCAT('RX iniciado | Protocolo=',COALESCE(v_codigo,'(n/a)')), NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'fila_operacional',
        p_id_fila,
        'RX_INICIADO',
        CONCAT('Fila RX iniciada | Protocolo=',COALESCE(v_codigo,'(n/a)')),
        NULL,
        'fila_operacional',
        v_id_usuario
    );

    COMMIT;
END ;;
```

