# sp_master_registrar_alerta

Objetivo: master registrar alerta conforme definida no dump SQL do sistema.

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
- INSERT: alerta
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
- v_tipo_alerta
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
- **Linha 14**: Declaracao de variavel local v_id_alerta.
- **Linha 15**: Declaracao de variavel local v_tipo_alerta.
- **Linha 16**: Declaracao de variavel local v_descricao.
- **Linha 17**: Declaracao de variavel local v_prioridade.
- **Linha 18**: Declaracao de variavel local v_id_destinatario.
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
- **Linha 32**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'REGISTRAR_ALERTA',
- **Linha 33**: NULL, v_id_alerta, p_payload, 'ERRO', v_error_msg
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
- **Linha 55**: atribuicao de valor Ã  variavel v_tipo_alerta.
- **Linha 56**: atribuicao de valor Ã  variavel v_descricao.
- **Linha 57**: atribuicao de valor Ã  variavel v_prioridade.
- **Linha 58**: atribuicao de valor Ã  variavel v_id_destinatario.
- **Linha 60** (Comentario): =========================
- **Linha 61** (Comentario): INSERIR ALERTA
- **Linha 62** (Comentario): =========================
- **Linha 63**: Insere um novo registro na tabela alerta.
- **Linha 64**: tipo_alerta,
- **Linha 65**: descricao,
- **Linha 66**: prioridade,
- **Linha 67**: id_destinatario,
- **Linha 68**: criado_por,
- **Linha 69**: criado_em
- **Linha 70**: ) VALUES (
- **Linha 71**: v_tipo_alerta,
- **Linha 72**: v_descricao,
- **Linha 73**: v_prioridade,
- **Linha 74**: v_id_destinatario,
- **Linha 75**: p_id_usuario,
- **Linha 76**: NOW(6)
- **Linha 77**: );
- **Linha 79**: atribuicao de valor Ã  variavel v_id_alerta.
- **Linha 81** (Comentario): =========================
- **Linha 82** (Comentario): REGISTRAR LEDGER
- **Linha 83** (Comentario): =========================
- **Linha 84**: Invoca a procedure sp_ledger_evento_log.
- **Linha 85**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'REGISTRAR_ALERTA',
- **Linha 86**: NULL, v_id_alerta, p_payload, 'SUCESSO',
- **Linha 87**: CONCAT('Alerta registrado: ', v_tipo_alerta)
- **Linha 88**: );
- **Linha 90** (Comentario): =========================
- **Linha 91** (Comentario): RETORNO PADRÃO
- **Linha 92** (Comentario): =========================
- **Linha 93**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 94**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 95**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 96**: 'id_alerta', v_id_alerta,
- **Linha 97**: 'tipo_alerta', v_tipo_alerta,
- **Linha 98**: 'descricao', v_descricao,
- **Linha 99**: 'prioridade', v_prioridade,
- **Linha 100**: 'id_destinatario', v_id_destinatario,
- **Linha 101**: 'uuid_transacao', v_uuid_transacao
- **Linha 102**: );
- **Linha 104** (Comentario): =========================
- **Linha 105** (Comentario): COMMIT TRANSAÇÃO
- **Linha 106** (Comentario): =========================
- **Linha 107**: COMMIT;
- **Linha 109**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_registrar_alerta`(
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
    DECLARE v_id_alerta BIGINT DEFAULT NULL;
    DECLARE v_tipo_alerta VARCHAR(100) DEFAULT NULL;
    DECLARE v_descricao TEXT DEFAULT NULL;
    DECLARE v_prioridade INT DEFAULT 1;
    DECLARE v_id_destinatario BIGINT DEFAULT NULL;

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
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'REGISTRAR_ALERTA',
            NULL, v_id_alerta, p_payload, 'ERRO', v_error_msg
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
    SET v_tipo_alerta = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo'));
    SET v_descricao = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.descricao'));
    SET v_prioridade = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.prioridade'));
    SET v_id_destinatario = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_destinatario'));

    -- =========================
    -- INSERIR ALERTA
    -- =========================
    INSERT INTO alerta (
        tipo_alerta,
        descricao,
        prioridade,
        id_destinatario,
        criado_por,
        criado_em
    ) VALUES (
        v_tipo_alerta,
        v_descricao,
        v_prioridade,
        v_id_destinatario,
        p_id_usuario,
        NOW(6)
    );

    SET v_id_alerta = LAST_INSERT_ID();

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'REGISTRAR_ALERTA',
        NULL, v_id_alerta, p_payload, 'SUCESSO',
        CONCAT('Alerta registrado: ', v_tipo_alerta)
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Alerta registrado com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_alerta', v_id_alerta,
        'tipo_alerta', v_tipo_alerta,
        'descricao', v_descricao,
        'prioridade', v_prioridade,
        'id_destinatario', v_id_destinatario,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

