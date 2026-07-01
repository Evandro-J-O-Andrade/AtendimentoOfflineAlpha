# sp_painel_inserir_senha

Objetivo: painel inserir senha conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
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
- **Linha 9**: fechamento da lista de Parametros.
- **Linha 10**: SQL SECURITY INVOKER
- **Linha 11**: proc_block: BEGIN
- **Linha 12**: Declaracao de variavel local v_uuid_transacao.
- **Linha 13**: Declaracao de variavel local v_error_msg.
- **Linha 14**: Declaracao de variavel local v_status_atual.
- **Linha 16**: Declaracao de variavel local EXIT.
- **Linha 17**: inicio do bloco de execucao.
- **Linha 18**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 19**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 20**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 21**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 22**: ROLLBACK;
- **Linha 23**: Fim do bloco da procedure.
- **Linha 25** (Comentario): validar sessão
- **Linha 26**: Estrutura condicional de controle de fluxo.
- **Linha 27**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 28**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 29**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 30**: Estrutura de repeticao/controle de loop.
- **Linha 31**: Estrutura condicional de controle de fluxo.
- **Linha 33**: START TRANSACTION;
- **Linha 35** (Comentario): bloquear senha
- **Linha 36**: execucao de query SELECT para consulta de dados.
- **Linha 37**: FROM senha
- **Linha 38**: WHERE id_senha = p_id_senha
- **Linha 39**: LIMIT 1
- **Linha 40**: FOR UPDATE;
- **Linha 42**: Estrutura condicional de controle de fluxo.
- **Linha 43**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 44**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 45**: Estrutura de repeticao/controle de loop.
- **Linha 46**: Estrutura condicional de controle de fluxo.
- **Linha 48** (Comentario): atualizar status para inserido no painel
- **Linha 49**: UPDATE senha
- **Linha 50**: atribuicao de valor Ã  variavel status.
- **Linha 51**: chamado_em = NOW(6)
- **Linha 52**: WHERE id_senha = p_id_senha;
- **Linha 54**: Invoca a procedure sp_ledger_evento_log.
- **Linha 55**: v_uuid_transacao,
- **Linha 56**: p_id_usuario,
- **Linha 57**: p_id_perfil,
- **Linha 58**: 'INSERIR_PAINEL',
- **Linha 59**: v_status_atual,
- **Linha 60**: p_id_senha,
- **Linha 61**: JSON_OBJECT(),
- **Linha 62**: 'SUCESSO',
- **Linha 63**: CONCAT('Senha inserida no painel')
- **Linha 64**: );
- **Linha 66**: COMMIT;
- **Linha 68**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 69**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 70**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 72**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_inserir_senha`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_id_senha BIGINT,
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

    -- validar sessão
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error','Sessão inválida','uuid_transacao',v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    -- bloquear senha
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

    -- atualizar status para inserido no painel
    UPDATE senha
    SET status = 'PENDENTE',
        chamado_em = NOW(6)
    WHERE id_senha = p_id_senha;

    CALL sp_ledger_evento_log(
        v_uuid_transacao,
        p_id_usuario,
        p_id_perfil,
        'INSERIR_PAINEL',
        v_status_atual,
        p_id_senha,
        JSON_OBJECT(),
        'SUCESSO',
        CONCAT('Senha inserida no painel')
    );

    COMMIT;

    SET p_sucesso = TRUE;
    SET p_mensagem = 'Senha inserida no painel com sucesso';
    SET p_resultado = JSON_OBJECT('id_senha', p_id_senha, 'uuid_transacao', v_uuid_transacao);

END ;;
```

