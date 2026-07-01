# sp_master_cancelar_administracao_medicacao

Objetivo: master cancelar administracao medicacao conforme definida no dump SQL do sistema.

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
- SELECT: administracao_medicacao
- INSERT: (nenhuma)
- UPDATE: administracao_medicacao
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_ledger_evento_log

## Functions Utilizadas
- CONCAT
- IF
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- NOW
- UUID

## Views Utilizadas
- v_error_msg
- v_motivo_cancelamento
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
- **Linha 14**: Declaracao de variavel local v_id_administracao.
- **Linha 15**: Declaracao de variavel local v_id_atendimento.
- **Linha 16**: Declaracao de variavel local v_motivo_cancelamento.
- **Linha 18** (Comentario): =========================
- **Linha 19** (Comentario): HANDLER GLOBAL DE ERRO
- **Linha 20** (Comentario): =========================
- **Linha 21**: Declaracao de variavel local EXIT.
- **Linha 22**: inicio do bloco de execucao.
- **Linha 23**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 24**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 25**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 26**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 27**: ROLLBACK;
- **Linha 29**: Invoca a procedure sp_ledger_evento_log.
- **Linha 30**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'CANCELAR_ADMINISTRACAO_MEDICACAO',
- **Linha 31**: NULL, v_id_administracao, p_payload, 'ERRO', v_error_msg
- **Linha 32**: );
- **Linha 33**: Fim do bloco da procedure.
- **Linha 35** (Comentario): =========================
- **Linha 36** (Comentario): VALIDAR SESSÃO
- **Linha 37** (Comentario): =========================
- **Linha 38**: Estrutura condicional de controle de fluxo.
- **Linha 39**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 40**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 41**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 42**: Estrutura de repeticao/controle de loop.
- **Linha 43**: Estrutura condicional de controle de fluxo.
- **Linha 45** (Comentario): =========================
- **Linha 46** (Comentario): INICIAR TRANSAÇÃO
- **Linha 47** (Comentario): =========================
- **Linha 48**: START TRANSACTION;
- **Linha 50** (Comentario): =========================
- **Linha 51** (Comentario): EXTRair DADOS DO PAYLOAD
- **Linha 52** (Comentario): =========================
- **Linha 53**: atribuicao de valor Ã  variavel v_id_administracao.
- **Linha 54**: atribuicao de valor Ã  variavel v_id_atendimento.
- **Linha 55**: atribuicao de valor Ã  variavel v_motivo_cancelamento.
- **Linha 57** (Comentario): =========================
- **Linha 58** (Comentario): VALIDAR EXISTÊNCIA
- **Linha 59** (Comentario): =========================
- **Linha 60**: Estrutura condicional de controle de fluxo.
- **Linha 61**: execucao de query SELECT para consulta de dados.
- **Linha 62**: ) THEN
- **Linha 63**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 64**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 65**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 66**: Estrutura de repeticao/controle de loop.
- **Linha 67**: Estrutura condicional de controle de fluxo.
- **Linha 69** (Comentario): =========================
- **Linha 70** (Comentario): CANCELAR ADMINISTRAÇÃO
- **Linha 71** (Comentario): =========================
- **Linha 72**: UPDATE administracao_medicacao
- **Linha 73**: atribuicao de valor Ã  variavel cancelado_em.
- **Linha 74**: cancelado_por = p_id_usuario,
- **Linha 75**: motivo_cancelamento = v_motivo_cancelamento
- **Linha 76**: WHERE id_administracao = v_id_administracao;
- **Linha 78** (Comentario): =========================
- **Linha 79** (Comentario): REGISTRAR LEDGER
- **Linha 80** (Comentario): =========================
- **Linha 81**: Invoca a procedure sp_ledger_evento_log.
- **Linha 82**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'CANCELAR_ADMINISTRACAO_MEDICACAO',
- **Linha 83**: NULL, v_id_administracao, p_payload, 'SUCESSO',
- **Linha 84**: CONCAT('Administração cancelada: ', v_motivo_cancelamento)
- **Linha 85**: );
- **Linha 87** (Comentario): =========================
- **Linha 88** (Comentario): RETORNO PADRÃO
- **Linha 89** (Comentario): =========================
- **Linha 90**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 91**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 92**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 93**: 'id_administracao', v_id_administracao,
- **Linha 94**: 'id_atendimento', v_id_atendimento,
- **Linha 95**: 'motivo', v_motivo_cancelamento,
- **Linha 96**: 'uuid_transacao', v_uuid_transacao
- **Linha 97**: );
- **Linha 99** (Comentario): =========================
- **Linha 100** (Comentario): COMMIT TRANSAÇÃO
- **Linha 101** (Comentario): =========================
- **Linha 102**: COMMIT;
- **Linha 104**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_cancelar_administracao_medicacao`(
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
    DECLARE v_motivo_cancelamento VARCHAR(500) DEFAULT NULL;

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
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'CANCELAR_ADMINISTRACAO_MEDICACAO',
            NULL, v_id_administracao, p_payload, 'ERRO', v_error_msg
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
    SET v_id_administracao = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_administracao'));
    SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
    SET v_motivo_cancelamento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.motivo'));

    -- =========================
    -- VALIDAR EXISTÊNCIA
    -- =========================
    IF NOT EXISTS (
        SELECT 1 FROM administracao_medicacao WHERE id_administracao = v_id_administracao
    ) THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Administração não encontrada';
        SET p_resultado = JSON_OBJECT('id_administracao', v_id_administracao, 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    -- =========================
    -- CANCELAR ADMINISTRAÇÃO
    -- =========================
    UPDATE administracao_medicacao
    SET cancelado_em = NOW(6),
        cancelado_por = p_id_usuario,
        motivo_cancelamento = v_motivo_cancelamento
    WHERE id_administracao = v_id_administracao;

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'CANCELAR_ADMINISTRACAO_MEDICACAO',
        NULL, v_id_administracao, p_payload, 'SUCESSO',
        CONCAT('Administração cancelada: ', v_motivo_cancelamento)
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Administração de medicação cancelada com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_administracao', v_id_administracao,
        'id_atendimento', v_id_atendimento,
        'motivo', v_motivo_cancelamento,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

