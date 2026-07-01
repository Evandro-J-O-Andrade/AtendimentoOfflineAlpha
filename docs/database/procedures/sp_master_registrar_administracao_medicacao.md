# sp_master_registrar_administracao_medicacao

Objetivo: master registrar administracao medicacao conforme definida no dump SQL do sistema.

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
- v_medicamento
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
- **Linha 14**: Declaracao de variavel local v_id_administracao.
- **Linha 15**: Declaracao de variavel local v_id_atendimento.
- **Linha 16**: Declaracao de variavel local v_medicamento.
- **Linha 17**: Declaracao de variavel local v_dose.
- **Linha 18**: Declaracao de variavel local v_via_administracao.
- **Linha 20** (Comentario): =========================
- **Linha 21** (Comentario): HANDLER GLOBAL DE ERRO
- **Linha 22** (Comentario): =========================
- **Linha 23**: Declaracao de variavel local EXIT.
- **Linha 24**: inicio do bloco de execucao.
- **Linha 25**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 26**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 27**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 28**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 29**: ROLLBACK;
- **Linha 31**: Invoca a procedure sp_ledger_evento_log.
- **Linha 32**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO',
- **Linha 33**: NULL, NULL, p_payload, 'ERRO', v_error_msg
- **Linha 34**: );
- **Linha 35**: Fim do bloco da procedure.
- **Linha 37** (Comentario): =========================
- **Linha 38** (Comentario): VALIDAR SESSÃO
- **Linha 39** (Comentario): =========================
- **Linha 40**: Estrutura condicional de controle de fluxo.
- **Linha 41**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 42**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 43**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 44**: Estrutura de repeticao/controle de loop.
- **Linha 45**: Estrutura condicional de controle de fluxo.
- **Linha 47** (Comentario): =========================
- **Linha 48** (Comentario): INICIAR TRANSAÇÃO
- **Linha 49** (Comentario): =========================
- **Linha 50**: START TRANSACTION;
- **Linha 52** (Comentario): =========================
- **Linha 53** (Comentario): EXTRair DADOS DO PAYLOAD
- **Linha 54** (Comentario): =========================
- **Linha 55**: atribuicao de valor Ã  variavel v_id_atendimento.
- **Linha 56**: atribuicao de valor Ã  variavel v_medicamento.
- **Linha 57**: atribuicao de valor Ã  variavel v_dose.
- **Linha 58**: atribuicao de valor Ã  variavel v_via_administracao.
- **Linha 60** (Comentario): =========================
- **Linha 61** (Comentario): INSERIR ADMINISTRAÇÃO
- **Linha 62** (Comentario): =========================
- **Linha 63**: Insere um novo registro na tabela administracao_medicacao.
- **Linha 64**: id_atendimento,
- **Linha 65**: medicamento,
- **Linha 66**: dose,
- **Linha 67**: via_administracao,
- **Linha 68**: criado_em,
- **Linha 69**: criado_por
- **Linha 70**: fechamento da lista de Parametros.
- **Linha 71**: VALUES (
- **Linha 72**: v_id_atendimento,
- **Linha 73**: v_medicamento,
- **Linha 74**: v_dose,
- **Linha 75**: v_via_administracao,
- **Linha 76**: NOW(6),
- **Linha 77**: p_id_usuario
- **Linha 78**: );
- **Linha 80**: atribuicao de valor Ã  variavel v_id_administracao.
- **Linha 82** (Comentario): =========================
- **Linha 83** (Comentario): REGISTRAR LEDGER
- **Linha 84** (Comentario): =========================
- **Linha 85**: Invoca a procedure sp_ledger_evento_log.
- **Linha 86**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO',
- **Linha 87**: NULL, v_id_administracao, p_payload, 'SUCESSO',
- **Linha 88**: CONCAT('Administração registrada: ', v_medicamento, ' ', v_dose, ' via ', v_via_administracao)
- **Linha 89**: );
- **Linha 91** (Comentario): =========================
- **Linha 92** (Comentario): RETORNO PADRÃO
- **Linha 93** (Comentario): =========================
- **Linha 94**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 95**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 96**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 97**: 'id_administracao', v_id_administracao,
- **Linha 98**: 'id_atendimento', v_id_atendimento,
- **Linha 99**: 'medicamento', v_medicamento,
- **Linha 100**: 'dose', v_dose,
- **Linha 101**: 'via', v_via_administracao,
- **Linha 102**: 'uuid_transacao', v_uuid_transacao
- **Linha 103**: );
- **Linha 105** (Comentario): =========================
- **Linha 106** (Comentario): COMMIT TRANSAÇÃO
- **Linha 107** (Comentario): =========================
- **Linha 108**: COMMIT;
- **Linha 110**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_registrar_administracao_medicacao`(
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
    DECLARE v_id_administracao BIGINT DEFAULT NULL;
    DECLARE v_id_atendimento BIGINT DEFAULT NULL;
    DECLARE v_medicamento VARCHAR(200) DEFAULT NULL;
    DECLARE v_dose VARCHAR(50) DEFAULT NULL;
    DECLARE v_via_administracao VARCHAR(50) DEFAULT NULL;

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
            NULL, NULL, p_payload, 'ERRO', v_error_msg
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
    SET v_medicamento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.medicamento'));
    SET v_dose = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.dose'));
    SET v_via_administracao = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.via'));

    -- =========================
    -- INSERIR ADMINISTRAÇÃO
    -- =========================
    INSERT INTO administracao_medicacao (
        id_atendimento,
        medicamento,
        dose,
        via_administracao,
        criado_em,
        criado_por
    )
    VALUES (
        v_id_atendimento,
        v_medicamento,
        v_dose,
        v_via_administracao,
        NOW(6),
        p_id_usuario
    );

    SET v_id_administracao = LAST_INSERT_ID();

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO',
        NULL, v_id_administracao, p_payload, 'SUCESSO',
        CONCAT('Administração registrada: ', v_medicamento, ' ', v_dose, ' via ', v_via_administracao)
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Administração de medicação registrada com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_administracao', v_id_administracao,
        'id_atendimento', v_id_atendimento,
        'medicamento', v_medicamento,
        'dose', v_dose,
        'via', v_via_administracao,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

