# sp_master_chamar_senha

Objetivo: master chamar senha conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
| p_id_guiche | BIGINT | IN | |
| p_acao | ENUM('CHAMAR','CANCELAR','NAO_ATENDIDA') | IN | |
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
- SELECT: senha
- INSERT: (nenhuma)
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_ledger_evento_log

## Functions Utilizadas
- CONCAT
- IF
- JSON_OBJECT
- NOW
- UUID

## Views Utilizadas
- v_error_msg
- v_status_anterior
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
- **Linha 9**: Declaracao de parÃ¢metro.
- **Linha 10**: Declaracao de parÃ¢metro.
- **Linha 11**: Declaracao de parÃ¢metro.
- **Linha 12**: fechamento da lista de Parametros.
- **Linha 13**: SQL SECURITY INVOKER
- **Linha 14**: proc_block: BEGIN
- **Linha 15**: Declaracao de variavel local v_uuid_transacao.
- **Linha 16**: Declaracao de variavel local v_error_msg.
- **Linha 17**: Declaracao de variavel local v_status_anterior.
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
- **Linha 31**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'CHAMAR_SENHA',
- **Linha 32**: v_status_anterior, p_id_senha, JSON_OBJECT('acao', p_acao, 'id_guiche', p_id_guiche), 'ERRO', v_error_msg
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
- **Linha 52** (Comentario): VERIFICAR STATUS ATUAL DA SENHA
- **Linha 53** (Comentario): =========================
- **Linha 54**: execucao de query SELECT para consulta de dados.
- **Linha 55**: FROM senha
- **Linha 56**: WHERE id_senha = p_id_senha
- **Linha 57**: LIMIT 1
- **Linha 58**: FOR UPDATE; -- bloqueio para evitar chamada simultânea
- **Linha 60**: Estrutura condicional de controle de fluxo.
- **Linha 61**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 62**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 63**: Estrutura de repeticao/controle de loop.
- **Linha 64**: Estrutura condicional de controle de fluxo.
- **Linha 66** (Comentario): =========================
- **Linha 67** (Comentario): PROCESSAR AÇÃO
- **Linha 68** (Comentario): =========================
- **Linha 69**: CASE
- **Linha 70**: WHEN p_acao = 'CHAMAR' THEN
- **Linha 71**: Estrutura condicional de controle de fluxo.
- **Linha 72**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 73**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 74**: Estrutura de repeticao/controle de loop.
- **Linha 75**: Estrutura condicional de controle de fluxo.
- **Linha 77**: UPDATE senha
- **Linha 78**: atribuicao de valor Ã  variavel status.
- **Linha 79**: id_guiche = p_id_guiche,
- **Linha 80**: chamado_em = NOW(6)
- **Linha 81**: WHERE id_senha = p_id_senha;
- **Linha 83**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 85**: WHEN p_acao = 'CANCELAR' THEN
- **Linha 86**: Estrutura condicional de controle de fluxo.
- **Linha 87**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 88**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 89**: Estrutura de repeticao/controle de loop.
- **Linha 90**: Estrutura condicional de controle de fluxo.
- **Linha 92**: UPDATE senha
- **Linha 93**: atribuicao de valor Ã  variavel status.
- **Linha 94**: motivo_cancelamento = p_motivo_cancelamento,
- **Linha 95**: chamado_em = NOW(6)
- **Linha 96**: WHERE id_senha = p_id_senha;
- **Linha 98**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 100**: WHEN p_acao = 'NAO_ATENDIDA' THEN
- **Linha 101**: UPDATE senha
- **Linha 102**: atribuicao de valor Ã  variavel status.
- **Linha 103**: chamado_em = NOW(6)
- **Linha 104**: WHERE id_senha = p_id_senha;
- **Linha 106**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 108**: Estrutura condicional de controle de fluxo.
- **Linha 109**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 110**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 111**: Estrutura de repeticao/controle de loop.
- **Linha 112**: END CASE;
- **Linha 114** (Comentario): =========================
- **Linha 115** (Comentario): REGISTRAR LEDGER
- **Linha 116** (Comentario): =========================
- **Linha 117**: Invoca a procedure sp_ledger_evento_log.
- **Linha 118**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'CHAMAR_SENHA',
- **Linha 119**: v_status_anterior, p_id_senha, JSON_OBJECT('acao', p_acao, 'id_guiche', p_id_guiche), 'SUCESSO', p_mensagem
- **Linha 120**: );
- **Linha 122** (Comentario): =========================
- **Linha 123** (Comentario): RETORNO PADRÃO
- **Linha 124** (Comentario): =========================
- **Linha 125**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 126**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 127**: 'id_senha', p_id_senha,
- **Linha 128**: 'acao', p_acao,
- **Linha 129**: 'status_anterior', v_status_anterior,
- **Linha 130**: 'mensagem', p_mensagem,
- **Linha 131**: 'uuid_transacao', v_uuid_transacao
- **Linha 132**: );
- **Linha 134** (Comentario): =========================
- **Linha 135** (Comentario): COMMIT TRANSAÇÃO
- **Linha 136** (Comentario): =========================
- **Linha 137**: COMMIT;
- **Linha 139**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_chamar_senha`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_id_senha BIGINT,
    IN p_id_guiche BIGINT,
    IN p_acao ENUM('CHAMAR','CANCELAR','NAO_ATENDIDA'),
    IN p_motivo_cancelamento VARCHAR(500), -- NULL permitido
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
    SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_status_anterior VARCHAR(50) DEFAULT NULL;

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
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'CHAMAR_SENHA',
            v_status_anterior, p_id_senha, JSON_OBJECT('acao', p_acao, 'id_guiche', p_id_guiche), 'ERRO', v_error_msg
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
    -- VERIFICAR STATUS ATUAL DA SENHA
    -- =========================
    SELECT status INTO v_status_anterior
    FROM senha
    WHERE id_senha = p_id_senha
    LIMIT 1
    FOR UPDATE; -- bloqueio para evitar chamada simultânea

    IF v_status_anterior IS NULL THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Senha não encontrada';
        LEAVE proc_block;
    END IF;

    -- =========================
    -- PROCESSAR AÇÃO
    -- =========================
    CASE
        WHEN p_acao = 'CHAMAR' THEN
            IF v_status_anterior IN ('CHAMADA','EM_COMPLEMENTACAO') THEN
                SET p_sucesso = FALSE;
                SET p_mensagem = CONCAT('Senha já está em status ', v_status_anterior);
                LEAVE proc_block;
            END IF;

            UPDATE senha
            SET status = 'CHAMADA',
                id_guiche = p_id_guiche,
                chamado_em = NOW(6)
            WHERE id_senha = p_id_senha;

            SET p_mensagem = CONCAT('Senha chamada no guichê ', p_id_guiche);

        WHEN p_acao = 'CANCELAR' THEN
            IF p_motivo_cancelamento IS NULL OR p_motivo_cancelamento = '' THEN
                SET p_sucesso = FALSE;
                SET p_mensagem = 'Motivo de cancelamento obrigatório';
                LEAVE proc_block;
            END IF;

            UPDATE senha
            SET status = 'CANCELADA',
                motivo_cancelamento = p_motivo_cancelamento,
                chamado_em = NOW(6)
            WHERE id_senha = p_id_senha;

            SET p_mensagem = CONCAT('Senha cancelada com motivo: ', p_motivo_cancelamento);

        WHEN p_acao = 'NAO_ATENDIDA' THEN
            UPDATE senha
            SET status = 'NAO_ATENDIDA',
                chamado_em = NOW(6)
            WHERE id_senha = p_id_senha;

            SET p_mensagem = 'Senha marcada como não atendida';

        ELSE
            SET p_sucesso = FALSE;
            SET p_mensagem = CONCAT('Ação inválida: ', p_acao);
            LEAVE proc_block;
    END CASE;

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'CHAMAR_SENHA',
        v_status_anterior, p_id_senha, JSON_OBJECT('acao', p_acao, 'id_guiche', p_id_guiche), 'SUCESSO', p_mensagem
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_resultado = JSON_OBJECT(
        'id_senha', p_id_senha,
        'acao', p_acao,
        'status_anterior', v_status_anterior,
        'mensagem', p_mensagem,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

