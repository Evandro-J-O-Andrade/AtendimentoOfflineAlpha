# sp_master_vincular_atendimento_paciente

Objetivo: master vincular atendimento paciente conforme definida no dump SQL do sistema.

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
- SELECT: atendimento
- INSERT: (nenhuma)
- UPDATE: atendimento
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_ledger_evento_log

## Functions Utilizadas
- CONCAT
- IF
- IFNULL
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- NOW
- UUID

## Views Utilizadas
- v_error_msg
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
- **Linha 14**: Declaracao de variavel local v_id_atendimento.
- **Linha 15**: Declaracao de variavel local v_id_paciente.
- **Linha 16**: Declaracao de variavel local v_paciente_anterior.
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
- **Linha 30**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_VINCULAR',
- **Linha 31**: v_paciente_anterior, v_id_paciente, p_payload, 'ERRO', v_error_msg
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
- **Linha 53**: atribuicao de valor Ã  variavel v_id_atendimento.
- **Linha 54**: atribuicao de valor Ã  variavel v_id_paciente.
- **Linha 56** (Comentario): =========================
- **Linha 57** (Comentario): OBTER PACIENTE ANTERIOR (se houver)
- **Linha 58** (Comentario): =========================
- **Linha 59**: execucao de query SELECT para consulta de dados.
- **Linha 60**: FROM atendimento
- **Linha 61**: WHERE id_atendimento = v_id_atendimento
- **Linha 62**: LIMIT 1;
- **Linha 64** (Comentario): =========================
- **Linha 65** (Comentario): ATUALIZAR VINCULO
- **Linha 66** (Comentario): =========================
- **Linha 67**: UPDATE atendimento
- **Linha 68**: atribuicao de valor Ã  variavel id_paciente.
- **Linha 69**: atualizado_em = NOW(6)
- **Linha 70**: WHERE id_atendimento = v_id_atendimento;
- **Linha 72** (Comentario): =========================
- **Linha 73** (Comentario): REGISTRAR LEDGER
- **Linha 74** (Comentario): =========================
- **Linha 75**: Invoca a procedure sp_ledger_evento_log.
- **Linha 76**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_VINCULAR',
- **Linha 77**: v_paciente_anterior, v_id_paciente, p_payload, 'SUCESSO',
- **Linha 78**: CONCAT('Atendimento vinculado: ', IFNULL(v_paciente_anterior, 'NULL'), ' -> ', v_id_paciente)
- **Linha 79**: );
- **Linha 81** (Comentario): =========================
- **Linha 82** (Comentario): RETORNO PADRÃO
- **Linha 83** (Comentario): =========================
- **Linha 84**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 85**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 86**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 87**: 'id_atendimento', v_id_atendimento,
- **Linha 88**: 'paciente_anterior', v_paciente_anterior,
- **Linha 89**: 'paciente_novo', v_id_paciente,
- **Linha 90**: 'uuid_transacao', v_uuid_transacao
- **Linha 91**: );
- **Linha 93** (Comentario): =========================
- **Linha 94** (Comentario): COMMIT TRANSAÇÃO
- **Linha 95** (Comentario): =========================
- **Linha 96**: COMMIT;
- **Linha 98**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_vincular_atendimento_paciente`(
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
    DECLARE v_id_atendimento BIGINT DEFAULT NULL;
    DECLARE v_id_paciente BIGINT DEFAULT NULL;
    DECLARE v_paciente_anterior BIGINT DEFAULT NULL;

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
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_VINCULAR',
            v_paciente_anterior, v_id_paciente, p_payload, 'ERRO', v_error_msg
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
    SET v_id_paciente = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_paciente'));

    -- =========================
    -- OBTER PACIENTE ANTERIOR (se houver)
    -- =========================
    SELECT id_paciente INTO v_paciente_anterior
    FROM atendimento
    WHERE id_atendimento = v_id_atendimento
    LIMIT 1;

    -- =========================
    -- ATUALIZAR VINCULO
    -- =========================
    UPDATE atendimento
    SET id_paciente = v_id_paciente,
        atualizado_em = NOW(6)
    WHERE id_atendimento = v_id_atendimento;

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_VINCULAR',
        v_paciente_anterior, v_id_paciente, p_payload, 'SUCESSO',
        CONCAT('Atendimento vinculado: ', IFNULL(v_paciente_anterior, 'NULL'), ' -> ', v_id_paciente)
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_mensagem = CONCAT('Atendimento vinculado ao paciente com sucesso');
    SET p_resultado = JSON_OBJECT(
        'id_atendimento', v_id_atendimento,
        'paciente_anterior', v_paciente_anterior,
        'paciente_novo', v_id_paciente,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

