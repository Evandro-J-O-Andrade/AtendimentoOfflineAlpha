# sp_master_atendimento_finalizar

Objetivo: master atendimento finalizar conforme definida no dump SQL do sistema.

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
- SELECT: fluxo_status, senha
- INSERT: senha
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
- NOW
- UUID

## Views Utilizadas
- v_error_msg
- v_estado_destino
- v_estado_origem
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
- **Linha 15**: Declaracao de variavel local v_estado_origem.
- **Linha 16**: Declaracao de variavel local v_estado_destino.
- **Linha 17**: Declaracao de variavel local v_id_fluxo_status.
- **Linha 19** (Comentario): =========================
- **Linha 20** (Comentario): HANDLER GLOBAL DE ERRO
- **Linha 21** (Comentario): =========================
- **Linha 22**: Declaracao de variavel local EXIT.
- **Linha 23**: inicio do bloco de execucao.
- **Linha 24**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 25**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 26**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 27**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 28**: ROLLBACK;
- **Linha 30**: Invoca a procedure sp_ledger_evento_log.
- **Linha 31**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_FINALIZAR',
- **Linha 32**: v_estado_origem, v_estado_destino, p_payload, 'ERRO', v_error_msg
- **Linha 33**: );
- **Linha 34**: Fim do bloco da procedure.
- **Linha 36** (Comentario): =========================
- **Linha 37** (Comentario): VALIDAR SESSÃO
- **Linha 38** (Comentario): =========================
- **Linha 39**: Estrutura condicional de controle de fluxo.
- **Linha 40**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 41**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 42**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 43**: Estrutura de repeticao/controle de loop.
- **Linha 44**: Estrutura condicional de controle de fluxo.
- **Linha 46** (Comentario): =========================
- **Linha 47** (Comentario): INICIAR TRANSAÇÃO
- **Linha 48** (Comentario): =========================
- **Linha 49**: START TRANSACTION;
- **Linha 51** (Comentario): =========================
- **Linha 52** (Comentario): OBTER ID DO ATENDIMENTO
- **Linha 53** (Comentario): =========================
- **Linha 54**: atribuicao de valor Ã  variavel v_id_atendimento.
- **Linha 56** (Comentario): =========================
- **Linha 57** (Comentario): OBTER ESTADO ORIGEM
- **Linha 58** (Comentario): =========================
- **Linha 59**: execucao de query SELECT para consulta de dados.
- **Linha 60**: FROM senha
- **Linha 61**: WHERE id_atendimento = v_id_atendimento
- **Linha 62**: ORDER BY criado_em DESC
- **Linha 63**: LIMIT 1;
- **Linha 65** (Comentario): =========================
- **Linha 66** (Comentario): INSERIR STATUS FINAL
- **Linha 67** (Comentario): =========================
- **Linha 68**: Insere um novo registro na tabela senha.
- **Linha 69**: VALUES (
- **Linha 70**: v_id_atendimento,
- **Linha 71**: (SELECT id_fluxo_status FROM fluxo_status WHERE codigo = v_estado_destino LIMIT 1),
- **Linha 72**: NOW(6)
- **Linha 73**: );
- **Linha 75** (Comentario): =========================
- **Linha 76** (Comentario): REGISTRAR LEDGER
- **Linha 77** (Comentario): =========================
- **Linha 78**: Invoca a procedure sp_ledger_evento_log.
- **Linha 79**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_FINALIZAR',
- **Linha 80**: v_estado_origem, v_estado_destino, p_payload, 'SUCESSO',
- **Linha 81**: CONCAT('Transição: ', v_estado_origem, ' -> ', v_estado_destino)
- **Linha 82**: );
- **Linha 84** (Comentario): =========================
- **Linha 85** (Comentario): RETORNO PADRÃO
- **Linha 86** (Comentario): =========================
- **Linha 87**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 88**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 89**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 90**: 'id_atendimento', v_id_atendimento,
- **Linha 91**: 'status_anterior', v_estado_origem,
- **Linha 92**: 'status_novo', v_estado_destino,
- **Linha 93**: 'uuid_transacao', v_uuid_transacao
- **Linha 94**: );
- **Linha 96** (Comentario): =========================
- **Linha 97** (Comentario): COMMIT TRANSAÇÃO
- **Linha 98** (Comentario): =========================
- **Linha 99**: COMMIT;
- **Linha 101**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_atendimento_finalizar`(
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
    DECLARE v_estado_origem VARCHAR(50) DEFAULT NULL;
    DECLARE v_estado_destino VARCHAR(50) DEFAULT 'FINALIZADO';
    DECLARE v_id_fluxo_status BIGINT DEFAULT NULL;

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
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_FINALIZAR',
            v_estado_origem, v_estado_destino, p_payload, 'ERRO', v_error_msg
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
    -- OBTER ID DO ATENDIMENTO
    -- =========================
    SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));

    -- =========================
    -- OBTER ESTADO ORIGEM
    -- =========================
    SELECT id_fluxo_status, codigo INTO v_id_fluxo_status, v_estado_origem
    FROM senha
    WHERE id_atendimento = v_id_atendimento
    ORDER BY criado_em DESC
    LIMIT 1;

    -- =========================
    -- INSERIR STATUS FINAL
    -- =========================
    INSERT INTO senha (id_atendimento, id_fluxo_status, criado_em)
    VALUES (
        v_id_atendimento,
        (SELECT id_fluxo_status FROM fluxo_status WHERE codigo = v_estado_destino LIMIT 1),
        NOW(6)
    );

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_FINALIZAR',
        v_estado_origem, v_estado_destino, p_payload, 'SUCESSO',
        CONCAT('Transição: ', v_estado_origem, ' -> ', v_estado_destino)
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_mensagem = CONCAT('Atendimento finalizado com sucesso');
    SET p_resultado = JSON_OBJECT(
        'id_atendimento', v_id_atendimento,
        'status_anterior', v_estado_origem,
        'status_novo', v_estado_destino,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

