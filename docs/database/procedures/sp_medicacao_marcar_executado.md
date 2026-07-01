# sp_medicacao_marcar_executado

Objetivo: medicacao marcar executado conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_fila | BIGINT | IN | |
| p_observacao | TEXT | IN | |

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
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
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
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: main: BEGIN
- **Linha 8**: Declaracao de variavel local v_sqlstate.
- **Linha 9**: Declaracao de variavel local v_errno.
- **Linha 10**: Declaracao de variavel local v_msg.
- **Linha 12**: Declaracao de variavel local v_tipo.
- **Linha 13**: Declaracao de variavel local v_id_ffa.
- **Linha 14**: Declaracao de variavel local v_id_usuario.
- **Linha 16**: Declaracao de variavel local EXIT.
- **Linha 17**: inicio do bloco de execucao.
- **Linha 18**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 19**: ROLLBACK;
- **Linha 20**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 21**: Invoca a procedure sp_raise.
- **Linha 22**: 'ROTINA=sp_medicacao_marcar_executado | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
- **Linha 23**: ' | ERRNO=', IFNULL(v_errno,0),
- **Linha 24**: ' | MSG=', IFNULL(v_msg,'(n/a)')
- **Linha 25**: ));
- **Linha 26**: Fim do bloco da procedure.
- **Linha 28**: Invoca a procedure sp_sessao_assert.
- **Linha 29**: START TRANSACTION;
- **Linha 31**: Invoca a procedure sp_assert_true.
- **Linha 33**: execucao de query SELECT para consulta de dados.
- **Linha 34**: INTO v_id_usuario
- **Linha 35**: FROM sessao_usuario su
- **Linha 36**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 38**: LIMIT 1;
- **Linha 40**: execucao de query SELECT para consulta de dados.
- **Linha 41**: INTO v_tipo, v_id_ffa
- **Linha 42**: FROM fila_operacional fo
- **Linha 43**: WHERE fo.id_fila = p_id_fila
- **Linha 44**: LIMIT 1
- **Linha 45**: FOR UPDATE;
- **Linha 47**: Invoca a procedure sp_assert_true.
- **Linha 48**: Invoca a procedure sp_assert_true.
- **Linha 50**: UPDATE fila_operacional
- **Linha 51**: atribuicao de valor Ã  variavel substatus.
- **Linha 52**: data_fim      = NOW(),
- **Linha 53**: id_responsavel= IFNULL(id_responsavel, v_id_usuario),
- **Linha 54**: observacao    = CASE
- **Linha 55**: WHEN p_observacao IS NULL OR p_observacao = '' THEN observacao
- **Linha 56**: WHEN observacao IS NULL OR observacao = '' THEN p_observacao
- **Linha 57**: Estrutura condicional de controle de fluxo.
- **Linha 58**: END
- **Linha 59**: WHERE id_fila = p_id_fila;
- **Linha 61**: Insere um novo registro na tabela fila_operacional_evento.
- **Linha 62**: VALUES (p_id_fila, p_id_sessao_usuario, 'EXECUTADO', CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa), NOW());
- **Linha 64**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 65**: p_id_sessao_usuario,
- **Linha 66**: 'FILA_OPERACIONAL',
- **Linha 67**: p_id_fila,
- **Linha 68**: 'EXECUTADO',
- **Linha 69**: CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa),
- **Linha 70**: NULL,
- **Linha 71**: 'fila_operacional',
- **Linha 72**: NULL
- **Linha 73**: );
- **Linha 75**: COMMIT;
- **Linha 76**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_marcar_executado`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
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

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medicacao_marcar_executado', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medicacao_marcar_executado | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)')
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    SELECT su.id_usuario
      INTO v_id_usuario
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

    UPDATE fila_operacional
       SET substatus     = 'FINALIZADO',
           data_fim      = NOW(),
           id_responsavel= IFNULL(id_responsavel, v_id_usuario),
           observacao    = CASE
                             WHEN p_observacao IS NULL OR p_observacao = '' THEN observacao
                             WHEN observacao IS NULL OR observacao = '' THEN p_observacao
                             ELSE CONCAT(observacao, '\n', p_observacao)
                           END
     WHERE id_fila = p_id_fila;

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'EXECUTADO', CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa), NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'EXECUTADO',
        CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa),
        NULL,
        'fila_operacional',
        NULL
    );

    COMMIT;
END ;;
```

