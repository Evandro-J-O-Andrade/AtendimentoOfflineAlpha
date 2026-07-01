# sp_finalizar_procedimento_geral

Objetivo: finalizar procedimento geral conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_fila | BIGINT | IN | |
| p_resultado | TEXT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fila_operacional, procedimento_protocolo, sessao_usuario
- INSERT: fila_operacional_evento, procedimento_protocolo_evento
- UPDATE: fila_operacional, procedimento_protocolo
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- COALESCE
- CONCAT
- IF
- IFNULL
- LEFT
- NOW

## Views Utilizadas
- v_sqlstate
- v_tipo_fila
- v_tipo_proto

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
- **Linha 11**: Declaracao de variavel local v_id_usuario.
- **Linha 12**: Declaracao de variavel local v_tipo_fila.
- **Linha 13**: Declaracao de variavel local v_tipo_proto.
- **Linha 14**: Declaracao de variavel local v_id_protocolo.
- **Linha 16**: Declaracao de variavel local EXIT.
- **Linha 17**: inicio do bloco de execucao.
- **Linha 18**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 19**: ROLLBACK;
- **Linha 20**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 21**: Invoca a procedure sp_raise.
- **Linha 22**: CONCAT('ROTINA=sp_finalizar_procedimento_geral | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
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
- **Linha 38**: execucao de query SELECT para consulta de dados.
- **Linha 39**: FROM fila_operacional fo
- **Linha 40**: WHERE fo.id_fila = p_id_fila
- **Linha 41**: LIMIT 1;
- **Linha 43**: Invoca a procedure sp_assert_true.
- **Linha 45**: UPDATE fila_operacional
- **Linha 46**: atribuicao de valor Ã  variavel substatus.
- **Linha 47**: data_fim = NOW(),
- **Linha 48**: observacao = COALESCE(p_resultado, observacao),
- **Linha 49**: id_responsavel = COALESCE(id_responsavel, v_id_usuario)
- **Linha 50**: WHERE id_fila = p_id_fila;
- **Linha 52**: Insere um novo registro na tabela fila_operacional_evento.
- **Linha 53**: VALUES (p_id_fila, p_id_sessao_usuario, 'FINALIZADO', CONCAT('Finalizado | Tipo=',v_tipo_fila), NOW());
- **Linha 55** (Comentario): Se for EXAME/RX, fecha protocolo
- **Linha 56**: Estrutura condicional de controle de fluxo.
- **Linha 57**: atribuicao de valor Ã  variavel v_tipo_proto.
- **Linha 59**: execucao de query SELECT para consulta de dados.
- **Linha 60**: FROM procedimento_protocolo pp
- **Linha 61**: WHERE pp.id_fila = p_id_fila
- **Linha 63**: LIMIT 1;
- **Linha 65**: Estrutura condicional de controle de fluxo.
- **Linha 66**: UPDATE procedimento_protocolo
- **Linha 67**: atribuicao de valor Ã  variavel status.
- **Linha 68**: atualizado_em = NOW()
- **Linha 69**: WHERE id_protocolo = v_id_protocolo;
- **Linha 71**: Insere um novo registro na tabela procedimento_protocolo_evento.
- **Linha 72**: VALUES (v_id_protocolo, 'FINALIZADO', LEFT(COALESCE(p_resultado,'(sem resultado)'), 2000), NOW(), p_id_sessao_usuario, v_id_usuario);
- **Linha 73**: Estrutura condicional de controle de fluxo.
- **Linha 74**: Estrutura condicional de controle de fluxo.
- **Linha 76**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 77**: p_id_sessao_usuario,
- **Linha 78**: 'fila_operacional',
- **Linha 79**: p_id_fila,
- **Linha 80**: 'PROCEDIMENTO_FINALIZADO',
- **Linha 81**: CONCAT('Finalizado | Tipo=',v_tipo_fila),
- **Linha 82**: NULL,
- **Linha 83**: 'fila_operacional',
- **Linha 84**: v_id_usuario
- **Linha 85**: );
- **Linha 87**: COMMIT;
- **Linha 88**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_geral`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_resultado         TEXT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_id_usuario BIGINT;
    DECLARE v_tipo_fila ENUM('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO');
    DECLARE v_tipo_proto ENUM('EXAME','RX');
    DECLARE v_id_protocolo BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_finalizar_procedimento_geral', 'Falha ao finalizar procedimento');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_finalizar_procedimento_geral | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
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

    SELECT fo.tipo INTO v_tipo_fila
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1;

    CALL sp_assert_true(v_tipo_fila IS NOT NULL, 'FILA', 'Fila operacional não encontrada.');

    UPDATE fila_operacional
       SET substatus = 'FINALIZADO',
           data_fim = NOW(),
           observacao = COALESCE(p_resultado, observacao),
           id_responsavel = COALESCE(id_responsavel, v_id_usuario)
     WHERE id_fila = p_id_fila;

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'FINALIZADO', CONCAT('Finalizado | Tipo=',v_tipo_fila), NOW());

    -- Se for EXAME/RX, fecha protocolo
    IF v_tipo_fila IN ('EXAME','RX') THEN
        SET v_tipo_proto = IF(v_tipo_fila='RX','RX','EXAME');

        SELECT pp.id_protocolo INTO v_id_protocolo
          FROM procedimento_protocolo pp
         WHERE pp.id_fila = p_id_fila
           AND pp.tipo = v_tipo_proto
         LIMIT 1;

        IF v_id_protocolo IS NOT NULL THEN
            UPDATE procedimento_protocolo
               SET status = 'FINALIZADO',
                   atualizado_em = NOW()
             WHERE id_protocolo = v_id_protocolo;

            INSERT INTO procedimento_protocolo_evento(id_protocolo, tipo_evento, detalhe, criado_em, id_sessao_usuario, id_usuario)
            VALUES (v_id_protocolo, 'FINALIZADO', LEFT(COALESCE(p_resultado,'(sem resultado)'), 2000), NOW(), p_id_sessao_usuario, v_id_usuario);
        END IF;
    END IF;

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'fila_operacional',
        p_id_fila,
        'PROCEDIMENTO_FINALIZADO',
        CONCAT('Finalizado | Tipo=',v_tipo_fila),
        NULL,
        'fila_operacional',
        v_id_usuario
    );

    COMMIT;
END ;;
```

