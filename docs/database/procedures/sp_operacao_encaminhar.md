# sp_operacao_encaminhar

Objetivo: operacao encaminhar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_ffa | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: ffa, fila_operacional, local_operacional, sessao_usuario
- INSERT: fila_operacional, fila_operacional_evento
- UPDATE: fila_operacional
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_fila_tipo_por_local
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IF
- IFNULL
- LAST_INSERT_ID
- NOW

## Views Utilizadas
- v_sqlstate
- v_tipo_fila

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
- **Linha 4**: main: BEGIN
- **Linha 5**: Declaracao de variavel local v_sqlstate.
- **Linha 6**: Declaracao de variavel local v_errno.
- **Linha 7**: Declaracao de variavel local v_msg.
- **Linha 8**: Declaracao de variavel local v_id_usuario.
- **Linha 9**: Declaracao de variavel local v_id_local_sessao.
- **Linha 10**: Declaracao de variavel local v_id_local_destino.
- **Linha 11**: Declaracao de variavel local v_tipo_fila.
- **Linha 12**: Declaracao de variavel local v_id_fila.
- **Linha 14**: Declaracao de variavel local EXIT.
- **Linha 15**: inicio do bloco de execucao.
- **Linha 16**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 17**: SET @diag_sqlstate = v_sqlstate;
- **Linha 18**: SET @diag_errno    = v_errno;
- **Linha 19**: SET @diag_msg      = v_msg;
- **Linha 20**: ROLLBACK;
- **Linha 21**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 22**: Invoca a procedure sp_raise.
- **Linha 23**: 'ROTINA=sp_operacao_encaminhar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
- **Linha 24**: ' | ERRNO=', IFNULL(v_errno,0),
- **Linha 25**: ' | MSG=', IFNULL(v_msg,'(n/a)'),
- **Linha 26**: ' | CTX=Falha na rotina'
- **Linha 27**: ));
- **Linha 28**: Fim do bloco da procedure.
- **Linha 30**: Invoca a procedure sp_sessao_assert.
- **Linha 31**: START TRANSACTION;
- **Linha 34**: Invoca a procedure sp_assert_true.
- **Linha 35**: execucao de query SELECT para consulta de dados.
- **Linha 36**: INTO v_id_usuario, v_id_local_sessao
- **Linha 37**: FROM sessao_usuario su
- **Linha 38**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 40**: LIMIT 1;
- **Linha 41**: atribuicao de valor Ã  variavel v_id_local_destino.
- **Linha 42**: Invoca a procedure sp_assert_true.
- **Linha 43**: Invoca a procedure sp_assert_true.
- **Linha 45**: Invoca a procedure sp_fila_tipo_por_local.
- **Linha 46**: Invoca a procedure sp_assert_true.
- **Linha 48**: execucao de query SELECT para consulta de dados.
- **Linha 49**: FROM fila_operacional fo
- **Linha 50**: WHERE fo.id_ffa = p_id_ffa
- **Linha 52**: ORDER BY fo.id_fila DESC
- **Linha 53**: LIMIT 1;
- **Linha 55**: Estrutura condicional de controle de fluxo.
- **Linha 56**: Insere um novo registro na tabela fila_operacional.
- **Linha 57**: id_ffa, tipo, substatus, prioridade,
- **Linha 58**: data_entrada, entrada_original_em,
- **Linha 59**: id_local, id_local_operacional,
- **Linha 60**: observacao
- **Linha 61**: ) SELECT
- **Linha 62**: f.id, v_tipo_fila, 'AGUARDANDO',
- **Linha 63**: CASE
- **Linha 64**: WHEN f.classificacao_cor IN ('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') THEN f.classificacao_cor
- **Linha 65**: Estrutura condicional de controle de fluxo.
- **Linha 66**: END,
- **Linha 67**: NOW(), NOW(),
- **Linha 68**: NULL, v_id_local_destino,
- **Linha 69**: CONCAT('Encaminhado para ', v_tipo_fila)
- **Linha 70**: FROM ffa f
- **Linha 71**: WHERE f.id = p_id_ffa
- **Linha 72**: LIMIT 1;
- **Linha 73**: atribuicao de valor Ã  variavel v_id_fila.
- **Linha 74**: Insere um novo registro na tabela fila_operacional_evento.
- **Linha 75**: VALUES (v_id_fila, p_id_sessao_usuario, 'ENCAMINHAR', CONCAT('local_destino=', v_id_local_destino, ' | tipo=', v_tipo_fila), NOW());
- **Linha 76**: Estrutura condicional de controle de fluxo.
- **Linha 77**: UPDATE fila_operacional
- **Linha 78**: atribuicao de valor Ã  variavel substatus.
- **Linha 79**: data_entrada = NOW(),
- **Linha 80**: id_responsavel = NULL,
- **Linha 81**: data_inicio = NULL,
- **Linha 82**: data_fim = NULL,
- **Linha 83**: reavaliar_em = NULL,
- **Linha 84**: id_local_operacional = v_id_local_destino
- **Linha 85**: WHERE id_fila = v_id_fila;
- **Linha 86**: Insere um novo registro na tabela fila_operacional_evento.
- **Linha 87**: VALUES (v_id_fila, p_id_sessao_usuario, 'REENCAMINHAR', CONCAT('local_destino=', v_id_local_destino, ' | tipo=', v_tipo_fila), NOW());
- **Linha 88**: Estrutura condicional de controle de fluxo.
- **Linha 90**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 91**: p_id_sessao_usuario,
- **Linha 92**: 'FFA',
- **Linha 93**: p_id_ffa,
- **Linha 94**: 'ENCAMINHAR',
- **Linha 95**: CONCAT('tipo_fila=', v_tipo_fila, ' | id_fila=', v_id_fila, ' | local_destino=', v_id_local_destino),
- **Linha 96**: NULL,
- **Linha 97**: 'ffa',
- **Linha 98**: NULL
- **Linha 99**: );
- **Linha 100**: COMMIT;
- **Linha 101**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_operacao_encaminhar`(IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa BIGINT,
    IN p_id_local_operacional_destino BIGINT)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_local_sessao BIGINT;
    DECLARE v_id_local_destino BIGINT;
    DECLARE v_tipo_fila VARCHAR(20);
    DECLARE v_id_fila BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_operacao_encaminhar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_operacao_encaminhar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;


    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa é obrigatório.');
    SELECT su.id_usuario, su.id_local_operacional
      INTO v_id_usuario, v_id_local_sessao
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;
    SET v_id_local_destino = IFNULL(p_id_local_operacional_destino, v_id_local_sessao);
    CALL sp_assert_true(v_id_local_destino IS NOT NULL, 'PARAM', 'Local destino não definido (sessão ou parâmetro).');
    CALL sp_assert_true(EXISTS(SELECT 1 FROM local_operacional lo WHERE lo.id_local_operacional = v_id_local_destino), 'LOCAL', 'Local destino inválido.');

    CALL sp_fila_tipo_por_local(p_id_sessao_usuario, v_id_local_destino, v_tipo_fila);
    CALL sp_assert_true(v_tipo_fila IS NOT NULL, 'MAP', 'Não foi possível mapear tipo de fila para o local.');

    SELECT fo.id_fila INTO v_id_fila
      FROM fila_operacional fo
     WHERE fo.id_ffa = p_id_ffa
       AND fo.tipo = v_tipo_fila
     ORDER BY fo.id_fila DESC
     LIMIT 1;

    IF v_id_fila IS NULL THEN
        INSERT INTO fila_operacional(
            id_ffa, tipo, substatus, prioridade,
            data_entrada, entrada_original_em,
            id_local, id_local_operacional,
            observacao
        ) SELECT
            f.id, v_tipo_fila, 'AGUARDANDO',
            CASE
              WHEN f.classificacao_cor IN ('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') THEN f.classificacao_cor
              ELSE 'AZUL'
            END,
            NOW(), NOW(),
            NULL, v_id_local_destino,
            CONCAT('Encaminhado para ', v_tipo_fila)
          FROM ffa f
         WHERE f.id = p_id_ffa
         LIMIT 1;
        SET v_id_fila = LAST_INSERT_ID();
        INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
        VALUES (v_id_fila, p_id_sessao_usuario, 'ENCAMINHAR', CONCAT('local_destino=', v_id_local_destino, ' | tipo=', v_tipo_fila), NOW());
    ELSE
        UPDATE fila_operacional
           SET substatus = 'AGUARDANDO',
               data_entrada = NOW(),
               id_responsavel = NULL,
               data_inicio = NULL,
               data_fim = NULL,
               reavaliar_em = NULL,
               id_local_operacional = v_id_local_destino
         WHERE id_fila = v_id_fila;
        INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
        VALUES (v_id_fila, p_id_sessao_usuario, 'REENCAMINHAR', CONCAT('local_destino=', v_id_local_destino, ' | tipo=', v_tipo_fila), NOW());
    END IF;

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FFA',
        p_id_ffa,
        'ENCAMINHAR',
        CONCAT('tipo_fila=', v_tipo_fila, ' | id_fila=', v_id_fila, ' | local_destino=', v_id_local_destino),
        NULL,
        'ffa',
        NULL
    );
    COMMIT;
END ;;
```

