# sp_master_agenda_disponibilidade

Objetivo: master agenda disponibilidade conforme definida no dump SQL do sistema.

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
- INSERT: agenda_disponibilidade
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
- **Linha 14**: Declaracao de variavel local v_id_disponibilidade.
- **Linha 15**: Declaracao de variavel local v_id_profissional.
- **Linha 16**: Declaracao de variavel local v_id_unidade.
- **Linha 17**: Declaracao de variavel local v_data_inicio.
- **Linha 18**: Declaracao de variavel local v_data_fim.
- **Linha 19**: Declaracao de variavel local v_status.
- **Linha 21**: Declaracao de variavel local EXIT.
- **Linha 22**: inicio do bloco de execucao.
- **Linha 23**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 24**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 25**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 26**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 27**: ROLLBACK;
- **Linha 29**: Invoca a procedure sp_ledger_evento_log.
- **Linha 30**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'AGENDA_DISPONIBILIDADE',
- **Linha 31**: NULL, v_id_disponibilidade, p_payload, 'ERRO', v_error_msg
- **Linha 32**: );
- **Linha 33**: Fim do bloco da procedure.
- **Linha 35**: Estrutura condicional de controle de fluxo.
- **Linha 36**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 37**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 38**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 39**: Estrutura de repeticao/controle de loop.
- **Linha 40**: Estrutura condicional de controle de fluxo.
- **Linha 42**: START TRANSACTION;
- **Linha 44**: atribuicao de valor Ã  variavel v_id_profissional.
- **Linha 45**: atribuicao de valor Ã  variavel v_id_unidade.
- **Linha 46**: atribuicao de valor Ã  variavel v_data_inicio.
- **Linha 47**: atribuicao de valor Ã  variavel v_data_fim.
- **Linha 48**: atribuicao de valor Ã  variavel v_status.
- **Linha 50**: Insere um novo registro na tabela agenda_disponibilidade.
- **Linha 51**: id_profissional,
- **Linha 52**: id_unidade,
- **Linha 53**: data_inicio,
- **Linha 54**: data_fim,
- **Linha 55**: status,
- **Linha 56**: criado_por,
- **Linha 57**: criado_em
- **Linha 58**: ) VALUES (
- **Linha 59**: v_id_profissional,
- **Linha 60**: v_id_unidade,
- **Linha 61**: v_data_inicio,
- **Linha 62**: v_data_fim,
- **Linha 63**: v_status,
- **Linha 64**: p_id_usuario,
- **Linha 65**: NOW(6)
- **Linha 66**: );
- **Linha 68**: atribuicao de valor Ã  variavel v_id_disponibilidade.
- **Linha 70**: Invoca a procedure sp_ledger_evento_log.
- **Linha 71**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'AGENDA_DISPONIBILIDADE',
- **Linha 72**: NULL, v_id_disponibilidade, p_payload, 'SUCESSO',
- **Linha 73**: CONCAT('Disponibilidade registrada para profissional ', v_id_profissional)
- **Linha 74**: );
- **Linha 76**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 77**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 78**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 79**: 'id_disponibilidade', v_id_disponibilidade,
- **Linha 80**: 'id_profissional', v_id_profissional,
- **Linha 81**: 'id_unidade', v_id_unidade,
- **Linha 82**: 'data_inicio', v_data_inicio,
- **Linha 83**: 'data_fim', v_data_fim,
- **Linha 84**: 'status', v_status,
- **Linha 85**: 'uuid_transacao', v_uuid_transacao
- **Linha 86**: );
- **Linha 88**: COMMIT;
- **Linha 90**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_agenda_disponibilidade`(
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
    DECLARE v_id_disponibilidade BIGINT DEFAULT NULL;
    DECLARE v_id_profissional BIGINT DEFAULT NULL;
    DECLARE v_id_unidade BIGINT DEFAULT NULL;
    DECLARE v_data_inicio DATETIME DEFAULT NULL;
    DECLARE v_data_fim DATETIME DEFAULT NULL;
    DECLARE v_status VARCHAR(50) DEFAULT 'ATIVA';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'AGENDA_DISPONIBILIDADE',
            NULL, v_id_disponibilidade, p_payload, 'ERRO', v_error_msg
        );
    END;

    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    SET v_id_profissional = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_profissional'));
    SET v_id_unidade = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade'));
    SET v_data_inicio = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data_inicio'));
    SET v_data_fim = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data_fim'));
    SET v_status = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.status'));

    INSERT INTO agenda_disponibilidade (
        id_profissional,
        id_unidade,
        data_inicio,
        data_fim,
        status,
        criado_por,
        criado_em
    ) VALUES (
        v_id_profissional,
        v_id_unidade,
        v_data_inicio,
        v_data_fim,
        v_status,
        p_id_usuario,
        NOW(6)
    );

    SET v_id_disponibilidade = LAST_INSERT_ID();

    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'AGENDA_DISPONIBILIDADE',
        NULL, v_id_disponibilidade, p_payload, 'SUCESSO',
        CONCAT('Disponibilidade registrada para profissional ', v_id_profissional)
    );

    SET p_sucesso = TRUE;
    SET p_mensagem = 'Disponibilidade registrada com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_disponibilidade', v_id_disponibilidade,
        'id_profissional', v_id_profissional,
        'id_unidade', v_id_unidade,
        'data_inicio', v_data_inicio,
        'data_fim', v_data_fim,
        'status', v_status,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;

END ;;
```

