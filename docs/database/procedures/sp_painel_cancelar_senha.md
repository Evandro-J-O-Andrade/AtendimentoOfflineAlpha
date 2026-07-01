# sp_painel_cancelar_senha

Objetivo: painel cancelar senha conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
| p_motivo_cancelamento | VARCHAR(500) | IN | |
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
- v_status_atual
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
- **Linha 10**: fechamento da lista de Parametros.
- **Linha 11**: SQL SECURITY INVOKER
- **Linha 12**: proc_block: BEGIN
- **Linha 13**: Declaracao de variavel local v_uuid_transacao.
- **Linha 14**: Declaracao de variavel local v_error_msg.
- **Linha 15**: Declaracao de variavel local v_status_atual.
- **Linha 17**: Declaracao de variavel local EXIT.
- **Linha 18**: inicio do bloco de execucao.
- **Linha 19**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 20**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 21**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 22**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 23**: ROLLBACK;
- **Linha 24**: Fim do bloco da procedure.
- **Linha 26**: Estrutura condicional de controle de fluxo.
- **Linha 27**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 28**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 29**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 30**: Estrutura de repeticao/controle de loop.
- **Linha 31**: Estrutura condicional de controle de fluxo.
- **Linha 33**: Estrutura condicional de controle de fluxo.
- **Linha 34**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 35**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 36**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 37**: Estrutura de repeticao/controle de loop.
- **Linha 38**: Estrutura condicional de controle de fluxo.
- **Linha 40**: START TRANSACTION;
- **Linha 42**: execucao de query SELECT para consulta de dados.
- **Linha 43**: FROM senha
- **Linha 44**: WHERE id_senha = p_id_senha
- **Linha 45**: LIMIT 1
- **Linha 46**: FOR UPDATE;
- **Linha 48**: Estrutura condicional de controle de fluxo.
- **Linha 49**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 50**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 51**: Estrutura de repeticao/controle de loop.
- **Linha 52**: Estrutura condicional de controle de fluxo.
- **Linha 54**: UPDATE senha
- **Linha 55**: atribuicao de valor Ã  variavel status.
- **Linha 56**: motivo_cancelamento = p_motivo_cancelamento,
- **Linha 57**: chamado_em = NOW(6)
- **Linha 58**: WHERE id_senha = p_id_senha;
- **Linha 60**: Invoca a procedure sp_ledger_evento_log.
- **Linha 61**: v_uuid_transacao,
- **Linha 62**: p_id_usuario,
- **Linha 63**: p_id_perfil,
- **Linha 64**: 'CANCELAR_SENHA',
- **Linha 65**: v_status_atual,
- **Linha 66**: p_id_senha,
- **Linha 67**: JSON_OBJECT('motivo', p_motivo_cancelamento),
- **Linha 68**: 'SUCESSO',
- **Linha 69**: CONCAT('Senha cancelada com motivo: ', p_motivo_cancelamento)
- **Linha 70**: );
- **Linha 72**: COMMIT;
- **Linha 74**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 75**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 76**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 78**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_cancelar_senha`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_id_senha BIGINT,
    IN p_motivo_cancelamento VARCHAR(500),
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
    SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_status_atual VARCHAR(50) DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;
    END;

    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error','Sessão inválida','uuid_transacao',v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    IF p_motivo_cancelamento IS NULL OR p_motivo_cancelamento = '' THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Motivo de cancelamento obrigatório';
        SET p_resultado = JSON_OBJECT('error','Motivo de cancelamento obrigatório','uuid_transacao',v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    SELECT status INTO v_status_atual
    FROM senha
    WHERE id_senha = p_id_senha
    LIMIT 1
    FOR UPDATE;

    IF v_status_atual IS NULL THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Senha não encontrada';
        LEAVE proc_block;
    END IF;

    UPDATE senha
    SET status = 'CANCELADA',
        motivo_cancelamento = p_motivo_cancelamento,
        chamado_em = NOW(6)
    WHERE id_senha = p_id_senha;

    CALL sp_ledger_evento_log(
        v_uuid_transacao,
        p_id_usuario,
        p_id_perfil,
        'CANCELAR_SENHA',
        v_status_atual,
        p_id_senha,
        JSON_OBJECT('motivo', p_motivo_cancelamento),
        'SUCESSO',
        CONCAT('Senha cancelada com motivo: ', p_motivo_cancelamento)
    );

    COMMIT;

    SET p_sucesso = TRUE;
    SET p_mensagem = CONCAT('Senha cancelada com sucesso: ', p_motivo_cancelamento);
    SET p_resultado = JSON_OBJECT('id_senha', p_id_senha, 'uuid_transacao', v_uuid_transacao);

END ;;
```

