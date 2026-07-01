# sp_master_administracao_medicacao

Objetivo: master administracao medicacao conforme definida no dump SQL do sistema.

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
- INSERT: administracao_medicacao
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
- v_dose
- v_error_msg
- v_status
- v_uuid_transacao
- v_via_administracao

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
- **Linha 14**: Declaracao de variavel local v_id_medicacao.
- **Linha 15**: Declaracao de variavel local v_id_atendimento.
- **Linha 16**: Declaracao de variavel local v_id_unidade.
- **Linha 17**: Declaracao de variavel local v_id_funcionario.
- **Linha 18**: Declaracao de variavel local v_dose.
- **Linha 19**: Declaracao de variavel local v_via_administracao.
- **Linha 20**: Declaracao de variavel local v_status.
- **Linha 22** (Comentario): =========================
- **Linha 23** (Comentario): HANDLER GLOBAL DE ERRO
- **Linha 24** (Comentario): =========================
- **Linha 25**: Declaracao de variavel local EXIT.
- **Linha 26**: inicio do bloco de execucao.
- **Linha 27**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 28**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 29**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 30**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 31**: ROLLBACK;
- **Linha 33**: Invoca a procedure sp_ledger_evento_log.
- **Linha 34**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO',
- **Linha 35**: NULL, v_id_medicacao, p_payload, 'ERRO', v_error_msg
- **Linha 36**: );
- **Linha 37**: Fim do bloco da procedure.
- **Linha 39** (Comentario): =========================
- **Linha 40** (Comentario): VALIDAR SESSÃO
- **Linha 41** (Comentario): =========================
- **Linha 42**: Estrutura condicional de controle de fluxo.
- **Linha 43**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 44**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 45**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 46**: Estrutura de repeticao/controle de loop.
- **Linha 47**: Estrutura condicional de controle de fluxo.
- **Linha 49** (Comentario): =========================
- **Linha 50** (Comentario): INICIAR TRANSAÇÃO
- **Linha 51** (Comentario): =========================
- **Linha 52**: START TRANSACTION;
- **Linha 54** (Comentario): =========================
- **Linha 55** (Comentario): EXTRair DADOS DO PAYLOAD
- **Linha 56** (Comentario): =========================
- **Linha 57**: atribuicao de valor Ã  variavel v_id_atendimento.
- **Linha 58**: atribuicao de valor Ã  variavel v_id_unidade.
- **Linha 59**: atribuicao de valor Ã  variavel v_id_funcionario.
- **Linha 60**: atribuicao de valor Ã  variavel v_dose.
- **Linha 61**: atribuicao de valor Ã  variavel v_via_administracao.
- **Linha 62**: atribuicao de valor Ã  variavel v_status.
- **Linha 64** (Comentario): =========================
- **Linha 65** (Comentario): INSERIR ADMINISTRAÇÃO
- **Linha 66** (Comentario): =========================
- **Linha 67**: Insere um novo registro na tabela administracao_medicacao.
- **Linha 68**: id_atendimento,
- **Linha 69**: id_unidade,
- **Linha 70**: id_funcionario,
- **Linha 71**: dose,
- **Linha 72**: via_administracao,
- **Linha 73**: status,
- **Linha 74**: criado_por,
- **Linha 75**: criado_em
- **Linha 76**: ) VALUES (
- **Linha 77**: v_id_atendimento,
- **Linha 78**: v_id_unidade,
- **Linha 79**: v_id_funcionario,
- **Linha 80**: v_dose,
- **Linha 81**: v_via_administracao,
- **Linha 82**: v_status,
- **Linha 83**: p_id_usuario,
- **Linha 84**: NOW(6)
- **Linha 85**: );
- **Linha 87**: atribuicao de valor Ã  variavel v_id_medicacao.
- **Linha 89** (Comentario): =========================
- **Linha 90** (Comentario): REGISTRAR LEDGER
- **Linha 91** (Comentario): =========================
- **Linha 92**: Invoca a procedure sp_ledger_evento_log.
- **Linha 93**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO',
- **Linha 94**: NULL, v_id_medicacao, p_payload, 'SUCESSO',
- **Linha 95**: CONCAT('Administração de medicação registrada: ', v_dose, ' via ', v_via_administracao)
- **Linha 96**: );
- **Linha 98** (Comentario): =========================
- **Linha 99** (Comentario): RETORNO PADRÃO
- **Linha 100** (Comentario): =========================
- **Linha 101**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 102**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 103**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 104**: 'id_medicacao', v_id_medicacao,
- **Linha 105**: 'id_atendimento', v_id_atendimento,
- **Linha 106**: 'id_unidade', v_id_unidade,
- **Linha 107**: 'id_funcionario', v_id_funcionario,
- **Linha 108**: 'dose', v_dose,
- **Linha 109**: 'via_administracao', v_via_administracao,
- **Linha 110**: 'status', v_status,
- **Linha 111**: 'uuid_transacao', v_uuid_transacao
- **Linha 112**: );
- **Linha 114** (Comentario): =========================
- **Linha 115** (Comentario): COMMIT TRANSAÇÃO
- **Linha 116** (Comentario): =========================
- **Linha 117**: COMMIT;
- **Linha 119**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_administracao_medicacao`(
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
    DECLARE v_id_medicacao BIGINT DEFAULT NULL;
    DECLARE v_id_atendimento BIGINT DEFAULT NULL;
    DECLARE v_id_unidade BIGINT DEFAULT NULL;
    DECLARE v_id_funcionario BIGINT DEFAULT NULL;
    DECLARE v_dose VARCHAR(50) DEFAULT NULL;
    DECLARE v_via_administracao VARCHAR(50) DEFAULT NULL;
    DECLARE v_status VARCHAR(20) DEFAULT 'PENDENTE';

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
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO',
            NULL, v_id_medicacao, p_payload, 'ERRO', v_error_msg
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
    -- EXTRair DADOS DO PAYLOAD
    -- =========================
    SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
    SET v_id_unidade = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade'));
    SET v_id_funcionario = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_funcionario'));
    SET v_dose = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.dose'));
    SET v_via_administracao = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.via_administracao'));
    SET v_status = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.status'));

    -- =========================
    -- INSERIR ADMINISTRAÇÃO
    -- =========================
    INSERT INTO administracao_medicacao (
        id_atendimento,
        id_unidade,
        id_funcionario,
        dose,
        via_administracao,
        status,
        criado_por,
        criado_em
    ) VALUES (
        v_id_atendimento,
        v_id_unidade,
        v_id_funcionario,
        v_dose,
        v_via_administracao,
        v_status,
        p_id_usuario,
        NOW(6)
    );

    SET v_id_medicacao = LAST_INSERT_ID();

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO',
        NULL, v_id_medicacao, p_payload, 'SUCESSO',
        CONCAT('Administração de medicação registrada: ', v_dose, ' via ', v_via_administracao)
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Administração de medicação registrada com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_medicacao', v_id_medicacao,
        'id_atendimento', v_id_atendimento,
        'id_unidade', v_id_unidade,
        'id_funcionario', v_id_funcionario,
        'dose', v_dose,
        'via_administracao', v_via_administracao,
        'status', v_status,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

