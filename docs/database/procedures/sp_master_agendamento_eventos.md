# sp_master_agendamento_eventos

Objetivo: master agendamento eventos conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_payload | JSON | IN | |
| p_resultado | JSON | OUT | |
| p_sucesso | BOOLEAN | OUT | |
| p_mensagem | VARCHAR(500) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: agendamento_eventos
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_ledger_evento_log

## Functions Utilizadas
- CONCAT
- IF
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- LAST_INSERT_ID
- NOW
- UUID

## Views Utilizadas
- v_error_msg
- v_status
- v_tipo_evento
- v_uuid_transacao

## Eventos Gerados
- evento
- ledger_evento

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
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: fechamento da lista de Parametros.
- **Linha 10**: SQL SECURITY INVOKER
- **Linha 11**: proc_block: BEGIN
- **Linha 12**: Declaracao de variavel local v_uuid_transacao.
- **Linha 13**: Declaracao de variavel local v_error_msg.
- **Linha 14**: Declaracao de variavel local v_id_evento.
- **Linha 15**: Declaracao de variavel local v_id_agenda.
- **Linha 16**: Declaracao de variavel local v_tipo_evento.
- **Linha 17**: Declaracao de variavel local v_descricao.
- **Linha 18**: Declaracao de variavel local v_data_evento.
- **Linha 19**: Declaracao de variavel local v_status.
- **Linha 21** (Comentario): =========================
- **Linha 22** (Comentario): HANDLER GLOBAL DE ERRO
- **Linha 23** (Comentario): =========================
- **Linha 24**: Declaracao de variavel local EXIT.
- **Linha 25**: inicio do bloco de execucao.
- **Linha 26**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 27**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 28**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 29**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 30**: ROLLBACK;
- **Linha 32**: Invoca a procedure sp_ledger_evento_log.
- **Linha 33**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'AGENDAMENTO_EVENTO',
- **Linha 34**: NULL, v_id_evento, p_payload, 'ERRO', v_error_msg
- **Linha 35**: );
- **Linha 36**: Fim do bloco da procedure.
- **Linha 38** (Comentario): =========================
- **Linha 39** (Comentario): VALIDAR SESSÃO
- **Linha 40** (Comentario): =========================
- **Linha 41**: Estrutura condicional de controle de fluxo.
- **Linha 42**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 43**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 44**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 45**: Estrutura de repeticao/controle de loop.
- **Linha 46**: Estrutura condicional de controle de fluxo.
- **Linha 48** (Comentario): =========================
- **Linha 49** (Comentario): INICIAR TRANSAÇÃO
- **Linha 50** (Comentario): =========================
- **Linha 51**: START TRANSACTION;
- **Linha 53** (Comentario): =========================
- **Linha 54** (Comentario): EXTRAIR DADOS DO PAYLOAD
- **Linha 55** (Comentario): =========================
- **Linha 56**: atribuicao de valor Ã  variavel v_id_agenda.
- **Linha 57**: atribuicao de valor Ã  variavel v_tipo_evento.
- **Linha 58**: atribuicao de valor Ã  variavel v_descricao.
- **Linha 59**: atribuicao de valor Ã  variavel v_data_evento.
- **Linha 60**: atribuicao de valor Ã  variavel v_status.
- **Linha 62** (Comentario): =========================
- **Linha 63** (Comentario): INSERIR EVENTO DE AGENDAMENTO
- **Linha 64** (Comentario): =========================
- **Linha 65**: Insere um novo registro na tabela agendamento_eventos.
- **Linha 66**: id_agenda,
- **Linha 67**: tipo_evento,
- **Linha 68**: descricao,
- **Linha 69**: data_evento,
- **Linha 70**: status,
- **Linha 71**: criado_por,
- **Linha 72**: criado_em
- **Linha 73**: ) VALUES (
- **Linha 74**: v_id_agenda,
- **Linha 75**: v_tipo_evento,
- **Linha 76**: v_descricao,
- **Linha 77**: v_data_evento,
- **Linha 78**: v_status,
- **Linha 79**: p_id_usuario,
- **Linha 80**: NOW(6)
- **Linha 81**: );
- **Linha 83**: atribuicao de valor Ã  variavel v_id_evento.
- **Linha 85** (Comentario): =========================
- **Linha 86** (Comentario): REGISTRAR LEDGER
- **Linha 87** (Comentario): =========================
- **Linha 88**: Invoca a procedure sp_ledger_evento_log.
- **Linha 89**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'AGENDAMENTO_EVENTO',
- **Linha 90**: NULL, v_id_evento, p_payload, 'SUCESSO',
- **Linha 91**: CONCAT('Evento registrado: ', v_tipo_evento, ' para agenda ', v_id_agenda)
- **Linha 92**: );
- **Linha 94** (Comentario): =========================
- **Linha 95** (Comentario): RETORNO PADRÃO
- **Linha 96** (Comentario): =========================
- **Linha 97**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 98**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 99**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 100**: 'id_evento', v_id_evento,
- **Linha 101**: 'id_agenda', v_id_agenda,
- **Linha 102**: 'tipo_evento', v_tipo_evento,
- **Linha 103**: 'descricao', v_descricao,
- **Linha 104**: 'data_evento', v_data_evento,
- **Linha 105**: 'status', v_status,
- **Linha 106**: 'uuid_transacao', v_uuid_transacao
- **Linha 107**: );
- **Linha 109** (Comentario): =========================
- **Linha 110** (Comentario): COMMIT TRANSAÇÃO
- **Linha 111** (Comentario): =========================
- **Linha 112**: COMMIT;
- **Linha 114**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_agendamento_eventos`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
    SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_evento BIGINT DEFAULT NULL;
    DECLARE v_id_agenda BIGINT DEFAULT NULL;
    DECLARE v_tipo_evento VARCHAR(50) DEFAULT NULL;
    DECLARE v_descricao TEXT DEFAULT NULL;
    DECLARE v_data_evento DATETIME DEFAULT NULL;
    DECLARE v_status VARCHAR(50) DEFAULT 'PENDENTE';

    -- =========================
    -- HANDLER GLOBAL DE ERRO
    -- =========================
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'AGENDAMENTO_EVENTO',
            NULL, v_id_evento, p_payload, 'ERRO', v_error_msg
        );
    END;

    -- =========================
    -- VALIDAR SESSÃO
    -- =========================
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    -- =========================
    -- INICIAR TRANSAÇÃO
    -- =========================
    START TRANSACTION;

    -- =========================
    -- EXTRAIR DADOS DO PAYLOAD
    -- =========================
    SET v_id_agenda = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_agenda'));
    SET v_tipo_evento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo_evento'));
    SET v_descricao = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.descricao'));
    SET v_data_evento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data_evento'));
    SET v_status = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.status'));

    -- =========================
    -- INSERIR EVENTO DE AGENDAMENTO
    -- =========================
    INSERT INTO agendamento_eventos (
        id_agenda,
        tipo_evento,
        descricao,
        data_evento,
        status,
        criado_por,
        criado_em
    ) VALUES (
        v_id_agenda,
        v_tipo_evento,
        v_descricao,
        v_data_evento,
        v_status,
        p_id_usuario,
        NOW(6)
    );

    SET v_id_evento = LAST_INSERT_ID();

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'AGENDAMENTO_EVENTO',
        NULL, v_id_evento, p_payload, 'SUCESSO',
        CONCAT('Evento registrado: ', v_tipo_evento, ' para agenda ', v_id_agenda)
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Evento de agendamento registrado com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_evento', v_id_evento,
        'id_agenda', v_id_agenda,
        'tipo_evento', v_tipo_evento,
        'descricao', v_descricao,
        'data_evento', v_data_evento,
        'status', v_status,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

