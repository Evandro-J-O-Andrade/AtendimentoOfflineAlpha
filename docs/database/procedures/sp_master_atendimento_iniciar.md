# sp_master_atendimento_iniciar

Objetivo: master atendimento iniciar conforme definida no dump SQL do sistema.

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
- INSERT: atendimento
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
- **Linha 16** (Comentario): =========================
- **Linha 17** (Comentario): HANDLER GLOBAL DE ERRO
- **Linha 18** (Comentario): =========================
- **Linha 19**: Declaracao de variavel local EXIT.
- **Linha 20**: inicio do bloco de execucao.
- **Linha 21**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 22**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 23**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 24**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 25**: ROLLBACK;
- **Linha 27**: Invoca a procedure sp_ledger_evento_log.
- **Linha 28**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_INICIAR',
- **Linha 29**: NULL, 'INICIADO', p_payload, 'ERRO', v_error_msg
- **Linha 30**: );
- **Linha 31**: Fim do bloco da procedure.
- **Linha 33** (Comentario): =========================
- **Linha 34** (Comentario): VALIDAR SESSÃO
- **Linha 35** (Comentario): =========================
- **Linha 36**: Estrutura condicional de controle de fluxo.
- **Linha 37**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 38**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 39**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 40**: Estrutura de repeticao/controle de loop.
- **Linha 41**: Estrutura condicional de controle de fluxo.
- **Linha 43** (Comentario): =========================
- **Linha 44** (Comentario): INICIAR TRANSAÇÃO
- **Linha 45** (Comentario): =========================
- **Linha 46**: START TRANSACTION;
- **Linha 48** (Comentario): =========================
- **Linha 49** (Comentario): OBTER DADOS DO ATENDIMENTO
- **Linha 50** (Comentario): =========================
- **Linha 51**: atribuicao de valor Ã  variavel v_id_atendimento.
- **Linha 53** (Comentario): =========================
- **Linha 54** (Comentario): INSERIR ATENDIMENTO INICIAL
- **Linha 55** (Comentario): =========================
- **Linha 56**: Insere um novo registro na tabela atendimento.
- **Linha 57**: id_atendimento,
- **Linha 58**: id_usuario_responsavel,
- **Linha 59**: id_perfil_responsavel,
- **Linha 60**: criado_em
- **Linha 61**: ) VALUES (
- **Linha 62**: v_id_atendimento,
- **Linha 63**: p_id_usuario,
- **Linha 64**: p_id_perfil,
- **Linha 65**: NOW(6)
- **Linha 66**: );
- **Linha 68** (Comentario): =========================
- **Linha 69** (Comentario): REGISTRAR LEDGER
- **Linha 70** (Comentario): =========================
- **Linha 71**: Invoca a procedure sp_ledger_evento_log.
- **Linha 72**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_INICIAR',
- **Linha 73**: NULL, 'INICIADO', p_payload, 'SUCESSO', 'Atendimento iniciado'
- **Linha 74**: );
- **Linha 76** (Comentario): =========================
- **Linha 77** (Comentario): RETORNO PADRÃO
- **Linha 78** (Comentario): =========================
- **Linha 79**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 80**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 81**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 82**: 'id_atendimento', v_id_atendimento,
- **Linha 83**: 'uuid_transacao', v_uuid_transacao
- **Linha 84**: );
- **Linha 86** (Comentario): =========================
- **Linha 87** (Comentario): COMMIT TRANSAÇÃO
- **Linha 88** (Comentario): =========================
- **Linha 89**: COMMIT;
- **Linha 91**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_atendimento_iniciar`(
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
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_INICIAR',
            NULL, 'INICIADO', p_payload, 'ERRO', v_error_msg
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
    -- OBTER DADOS DO ATENDIMENTO
    -- =========================
    SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));

    -- =========================
    -- INSERIR ATENDIMENTO INICIAL
    -- =========================
    INSERT INTO atendimento (
        id_atendimento,
        id_usuario_responsavel,
        id_perfil_responsavel,
        criado_em
    ) VALUES (
        v_id_atendimento,
        p_id_usuario,
        p_id_perfil,
        NOW(6)
    );

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'ATENDIMENTO_INICIAR',
        NULL, 'INICIADO', p_payload, 'SUCESSO', 'Atendimento iniciado'
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Atendimento iniciado';
    SET p_resultado = JSON_OBJECT(
        'id_atendimento', v_id_atendimento,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

