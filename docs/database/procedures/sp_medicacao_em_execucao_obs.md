# sp_medicacao_em_execucao_obs

Objetivo: medicacao em execucao obs conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_fila | BIGINT | IN | |
| p_previsto_em | DATETIME | IN | |
| p_observacao | TEXT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fila_operacional, medicacao_reavaliacao, sessao_usuario
- INSERT: fila_operacional_evento, medicacao_reavaliacao
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
- IF
- IFNULL
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
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: main: BEGIN
- **Linha 9**: Declaracao de variavel local v_sqlstate.
- **Linha 10**: Declaracao de variavel local v_errno.
- **Linha 11**: Declaracao de variavel local v_msg.
- **Linha 13**: Declaracao de variavel local v_tipo.
- **Linha 14**: Declaracao de variavel local v_id_ffa.
- **Linha 15**: Declaracao de variavel local v_id_usuario.
- **Linha 16**: Declaracao de variavel local v_id_local_operacional.
- **Linha 18**: Declaracao de variavel local EXIT.
- **Linha 19**: inicio do bloco de execucao.
- **Linha 20**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 21**: ROLLBACK;
- **Linha 22**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 23**: Invoca a procedure sp_raise.
- **Linha 24**: 'ROTINA=sp_medicacao_em_execucao_obs | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
- **Linha 25**: ' | ERRNO=', IFNULL(v_errno,0),
- **Linha 26**: ' | MSG=', IFNULL(v_msg,'(n/a)')
- **Linha 27**: ));
- **Linha 28**: Fim do bloco da procedure.
- **Linha 30**: Invoca a procedure sp_sessao_assert.
- **Linha 31**: START TRANSACTION;
- **Linha 33**: Invoca a procedure sp_assert_true.
- **Linha 34**: Invoca a procedure sp_assert_true.
- **Linha 36**: execucao de query SELECT para consulta de dados.
- **Linha 37**: INTO v_id_usuario, v_id_local_operacional
- **Linha 38**: FROM sessao_usuario su
- **Linha 39**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 41**: LIMIT 1;
- **Linha 43**: execucao de query SELECT para consulta de dados.
- **Linha 44**: INTO v_tipo, v_id_ffa
- **Linha 45**: FROM fila_operacional fo
- **Linha 46**: WHERE fo.id_fila = p_id_fila
- **Linha 47**: LIMIT 1
- **Linha 48**: FOR UPDATE;
- **Linha 50**: Invoca a procedure sp_assert_true.
- **Linha 51**: Invoca a procedure sp_assert_true.
- **Linha 53** (Comentario): muda o substatus da fila (continua na MEDICAÇÃO)
- **Linha 54**: UPDATE fila_operacional
- **Linha 55**: atribuicao de valor Ã  variavel substatus.
- **Linha 56**: reavaliar_em  = p_previsto_em,
- **Linha 57**: observacao    = CASE
- **Linha 58**: WHEN p_observacao IS NULL OR p_observacao = '' THEN observacao
- **Linha 59**: WHEN observacao IS NULL OR observacao = '' THEN p_observacao
- **Linha 60**: Estrutura condicional de controle de fluxo.
- **Linha 61**: END
- **Linha 62**: WHERE id_fila = p_id_fila;
- **Linha 64** (Comentario): cria registro de reavaliação (se já existir pendente, não duplica)
- **Linha 65**: Estrutura condicional de controle de fluxo.
- **Linha 66**: execucao de query SELECT para consulta de dados.
- **Linha 67**: FROM medicacao_reavaliacao mr
- **Linha 68**: WHERE mr.id_fila_medicacao = p_id_fila
- **Linha 70**: ) THEN
- **Linha 71**: Insere um novo registro na tabela medicacao_reavaliacao.
- **Linha 72**: id_fila_medicacao, id_ffa, previsto_em, status,
- **Linha 73**: id_sessao_usuario, id_local_operacional,
- **Linha 74**: id_usuario_criador, observacao, criado_em
- **Linha 75**: ) VALUES (
- **Linha 76**: p_id_fila, v_id_ffa, p_previsto_em, 'PENDENTE',
- **Linha 77**: p_id_sessao_usuario, v_id_local_operacional,
- **Linha 78**: v_id_usuario, p_observacao, NOW()
- **Linha 79**: );
- **Linha 80**: Estrutura condicional de controle de fluxo.
- **Linha 82**: Insere um novo registro na tabela fila_operacional_evento.
- **Linha 83**: VALUES (
- **Linha 84**: p_id_fila, p_id_sessao_usuario, 'EM_EXECUCAO_OBS',
- **Linha 85**: CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa, ' | previsto_em=', p_previsto_em),
- **Linha 86**: NOW()
- **Linha 87**: );
- **Linha 89**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 90**: p_id_sessao_usuario,
- **Linha 91**: 'FILA_OPERACIONAL',
- **Linha 92**: p_id_fila,
- **Linha 93**: 'EM_EXECUCAO_OBS',
- **Linha 94**: CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa, ' | previsto_em=', p_previsto_em),
- **Linha 95**: NULL,
- **Linha 96**: 'fila_operacional',
- **Linha 97**: NULL
- **Linha 98**: );
- **Linha 100**: COMMIT;
- **Linha 101**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_em_execucao_obs`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_previsto_em       DATETIME,
    IN p_observacao        TEXT
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_tipo VARCHAR(20);
    DECLARE v_id_ffa BIGINT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_local_operacional BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medicacao_em_execucao_obs', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medicacao_em_execucao_obs | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)')
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');
    CALL sp_assert_true(p_previsto_em IS NOT NULL, 'PARAM', 'previsto_em é obrigatório.');

    SELECT su.id_usuario, su.id_local_operacional
      INTO v_id_usuario, v_id_local_operacional
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    SELECT fo.tipo, fo.id_ffa
      INTO v_tipo, v_id_ffa
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1
     FOR UPDATE;

    CALL sp_assert_true(v_tipo IS NOT NULL, 'NAO_ENCONTRADO', 'Fila não encontrada.');
    CALL sp_assert_true(v_tipo = 'MEDICACAO', 'REGRA', 'Fila informada não é MEDICACAO.');

    -- muda o substatus da fila (continua na MEDICAÇÃO)
    UPDATE fila_operacional
       SET substatus     = 'REAVALIAR',
           reavaliar_em  = p_previsto_em,
           observacao    = CASE
                             WHEN p_observacao IS NULL OR p_observacao = '' THEN observacao
                             WHEN observacao IS NULL OR observacao = '' THEN p_observacao
                             ELSE CONCAT(observacao, '\n', p_observacao)
                           END
     WHERE id_fila = p_id_fila;

    -- cria registro de reavaliação (se já existir pendente, não duplica)
    IF NOT EXISTS (
        SELECT 1
          FROM medicacao_reavaliacao mr
         WHERE mr.id_fila_medicacao = p_id_fila
           AND mr.status IN ('PENDENTE','EM_EXECUCAO')
    ) THEN
        INSERT INTO medicacao_reavaliacao(
            id_fila_medicacao, id_ffa, previsto_em, status,
            id_sessao_usuario, id_local_operacional,
            id_usuario_criador, observacao, criado_em
        ) VALUES (
            p_id_fila, v_id_ffa, p_previsto_em, 'PENDENTE',
            p_id_sessao_usuario, v_id_local_operacional,
            v_id_usuario, p_observacao, NOW()
        );
    END IF;

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (
        p_id_fila, p_id_sessao_usuario, 'EM_EXECUCAO_OBS',
        CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa, ' | previsto_em=', p_previsto_em),
        NOW()
    );

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'EM_EXECUCAO_OBS',
        CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa, ' | previsto_em=', p_previsto_em),
        NULL,
        'fila_operacional',
        NULL
    );

    COMMIT;
END ;;
```

