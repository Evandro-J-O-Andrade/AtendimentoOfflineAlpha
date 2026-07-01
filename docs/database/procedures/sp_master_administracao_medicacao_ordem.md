# sp_master_administracao_medicacao_ordem

Objetivo: master administracao medicacao ordem conforme definida no dump SQL do sistema.

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
- INSERT: administracao_medicacao_ordem
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
- v_frequencia
- v_quantidade
- v_status
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
- **Linha 14**: Declaracao de variavel local v_id_ordem.
- **Linha 15**: Declaracao de variavel local v_id_medicacao.
- **Linha 16**: Declaracao de variavel local v_id_atendimento.
- **Linha 17**: Declaracao de variavel local v_id_unidade.
- **Linha 18**: Declaracao de variavel local v_id_funcionario.
- **Linha 19**: Declaracao de variavel local v_quantidade.
- **Linha 20**: Declaracao de variavel local v_frequencia.
- **Linha 21**: Declaracao de variavel local v_status.
- **Linha 23** (Comentario): =========================
- **Linha 24** (Comentario): HANDLER GLOBAL DE ERRO
- **Linha 25** (Comentario): =========================
- **Linha 26**: Declaracao de variavel local EXIT.
- **Linha 27**: inicio do bloco de execucao.
- **Linha 28**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 29**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 30**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 31**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 32**: ROLLBACK;
- **Linha 34**: Invoca a procedure sp_ledger_evento_log.
- **Linha 35**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO_ORDEM',
- **Linha 36**: NULL, v_id_ordem, p_payload, 'ERRO', v_error_msg
- **Linha 37**: );
- **Linha 38**: Fim do bloco da procedure.
- **Linha 40** (Comentario): =========================
- **Linha 41** (Comentario): VALIDAR SESSÃO
- **Linha 42** (Comentario): =========================
- **Linha 43**: Estrutura condicional de controle de fluxo.
- **Linha 44**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 45**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 46**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 47**: Estrutura de repeticao/controle de loop.
- **Linha 48**: Estrutura condicional de controle de fluxo.
- **Linha 50** (Comentario): =========================
- **Linha 51** (Comentario): INICIAR TRANSAÇÃO
- **Linha 52** (Comentario): =========================
- **Linha 53**: START TRANSACTION;
- **Linha 55** (Comentario): =========================
- **Linha 56** (Comentario): EXTRair DADOS DO PAYLOAD
- **Linha 57** (Comentario): =========================
- **Linha 58**: atribuicao de valor Ã  variavel v_id_medicacao.
- **Linha 59**: atribuicao de valor Ã  variavel v_id_atendimento.
- **Linha 60**: atribuicao de valor Ã  variavel v_id_unidade.
- **Linha 61**: atribuicao de valor Ã  variavel v_id_funcionario.
- **Linha 62**: atribuicao de valor Ã  variavel v_quantidade.
- **Linha 63**: atribuicao de valor Ã  variavel v_frequencia.
- **Linha 64**: atribuicao de valor Ã  variavel v_status.
- **Linha 66** (Comentario): =========================
- **Linha 67** (Comentario): INSERIR ORDEM DE MEDICAÇÃO
- **Linha 68** (Comentario): =========================
- **Linha 69**: Insere um novo registro na tabela administracao_medicacao_ordem.
- **Linha 70**: id_medicacao,
- **Linha 71**: id_atendimento,
- **Linha 72**: id_unidade,
- **Linha 73**: id_funcionario,
- **Linha 74**: quantidade,
- **Linha 75**: frequencia,
- **Linha 76**: status,
- **Linha 77**: criado_por,
- **Linha 78**: criado_em
- **Linha 79**: ) VALUES (
- **Linha 80**: v_id_medicacao,
- **Linha 81**: v_id_atendimento,
- **Linha 82**: v_id_unidade,
- **Linha 83**: v_id_funcionario,
- **Linha 84**: v_quantidade,
- **Linha 85**: v_frequencia,
- **Linha 86**: v_status,
- **Linha 87**: p_id_usuario,
- **Linha 88**: NOW(6)
- **Linha 89**: );
- **Linha 91**: atribuicao de valor Ã  variavel v_id_ordem.
- **Linha 93** (Comentario): =========================
- **Linha 94** (Comentario): REGISTRAR LEDGER
- **Linha 95** (Comentario): =========================
- **Linha 96**: Invoca a procedure sp_ledger_evento_log.
- **Linha 97**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO_ORDEM',
- **Linha 98**: NULL, v_id_ordem, p_payload, 'SUCESSO',
- **Linha 99**: CONCAT('Ordem de medicação registrada: ', v_quantidade, ' doses, ', v_frequencia)
- **Linha 100**: );
- **Linha 102** (Comentario): =========================
- **Linha 103** (Comentario): RETORNO PADRÃO
- **Linha 104** (Comentario): =========================
- **Linha 105**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 106**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 107**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 108**: 'id_ordem', v_id_ordem,
- **Linha 109**: 'id_medicacao', v_id_medicacao,
- **Linha 110**: 'id_atendimento', v_id_atendimento,
- **Linha 111**: 'id_unidade', v_id_unidade,
- **Linha 112**: 'id_funcionario', v_id_funcionario,
- **Linha 113**: 'quantidade', v_quantidade,
- **Linha 114**: 'frequencia', v_frequencia,
- **Linha 115**: 'status', v_status,
- **Linha 116**: 'uuid_transacao', v_uuid_transacao
- **Linha 117**: );
- **Linha 119** (Comentario): =========================
- **Linha 120** (Comentario): COMMIT TRANSAÇÃO
- **Linha 121** (Comentario): =========================
- **Linha 122**: COMMIT;
- **Linha 124**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_administracao_medicacao_ordem`(
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
    DECLARE v_id_ordem BIGINT DEFAULT NULL;
    DECLARE v_id_medicacao BIGINT DEFAULT NULL;
    DECLARE v_id_atendimento BIGINT DEFAULT NULL;
    DECLARE v_id_unidade BIGINT DEFAULT NULL;
    DECLARE v_id_funcionario BIGINT DEFAULT NULL;
    DECLARE v_quantidade DECIMAL(10,2) DEFAULT NULL;
    DECLARE v_frequencia VARCHAR(50) DEFAULT NULL;
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
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO_ORDEM',
            NULL, v_id_ordem, p_payload, 'ERRO', v_error_msg
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
    SET v_id_medicacao = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_medicacao'));
    SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
    SET v_id_unidade = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade'));
    SET v_id_funcionario = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_funcionario'));
    SET v_quantidade = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.quantidade'));
    SET v_frequencia = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.frequencia'));
    SET v_status = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.status'));

    -- =========================
    -- INSERIR ORDEM DE MEDICAÇÃO
    -- =========================
    INSERT INTO administracao_medicacao_ordem (
        id_medicacao,
        id_atendimento,
        id_unidade,
        id_funcionario,
        quantidade,
        frequencia,
        status,
        criado_por,
        criado_em
    ) VALUES (
        v_id_medicacao,
        v_id_atendimento,
        v_id_unidade,
        v_id_funcionario,
        v_quantidade,
        v_frequencia,
        v_status,
        p_id_usuario,
        NOW(6)
    );

    SET v_id_ordem = LAST_INSERT_ID();

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ADMINISTRACAO_MEDICACAO_ORDEM',
        NULL, v_id_ordem, p_payload, 'SUCESSO',
        CONCAT('Ordem de medicação registrada: ', v_quantidade, ' doses, ', v_frequencia)
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Ordem de medicação registrada com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_ordem', v_id_ordem,
        'id_medicacao', v_id_medicacao,
        'id_atendimento', v_id_atendimento,
        'id_unidade', v_id_unidade,
        'id_funcionario', v_id_funcionario,
        'quantidade', v_quantidade,
        'frequencia', v_frequencia,
        'status', v_status,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

