# sp_painel_chamar_senha

Objetivo: painel chamar senha conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
| p_id_guiche | BIGINT | IN | |
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
- **Linha 33**: START TRANSACTION;
- **Linha 35**: execucao de query SELECT para consulta de dados.
- **Linha 36**: FROM senha
- **Linha 37**: WHERE id_senha = p_id_senha
- **Linha 38**: LIMIT 1
- **Linha 39**: FOR UPDATE;
- **Linha 41**: Estrutura condicional de controle de fluxo.
- **Linha 42**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 43**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 44**: Estrutura de repeticao/controle de loop.
- **Linha 45**: Estrutura condicional de controle de fluxo.
- **Linha 47**: Estrutura condicional de controle de fluxo.
- **Linha 48**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 49**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 50**: Estrutura de repeticao/controle de loop.
- **Linha 51**: Estrutura condicional de controle de fluxo.
- **Linha 53**: UPDATE senha
- **Linha 54**: atribuicao de valor Ã  variavel status.
- **Linha 55**: id_guiche = p_id_guiche,
- **Linha 56**: chamado_em = NOW(6)
- **Linha 57**: WHERE id_senha = p_id_senha;
- **Linha 59**: Invoca a procedure sp_ledger_evento_log.
- **Linha 60**: v_uuid_transacao,
- **Linha 61**: p_id_usuario,
- **Linha 62**: p_id_perfil,
- **Linha 63**: 'CHAMAR_SENHA',
- **Linha 64**: v_status_atual,
- **Linha 65**: p_id_senha,
- **Linha 66**: JSON_OBJECT('id_guiche', p_id_guiche),
- **Linha 67**: 'SUCESSO',
- **Linha 68**: CONCAT('Senha chamada no guichê ', p_id_guiche)
- **Linha 69**: );
- **Linha 71**: COMMIT;
- **Linha 73**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 74**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 75**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 77**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_chamar_senha`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_id_senha BIGINT,
    IN p_id_guiche BIGINT,
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

    IF v_status_atual IN ('CHAMADA','EM_COMPLEMENTACAO') THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('Senha já está em status ', v_status_atual);
        LEAVE proc_block;
    END IF;

    UPDATE senha
    SET status = 'CHAMADA',
        id_guiche = p_id_guiche,
        chamado_em = NOW(6)
    WHERE id_senha = p_id_senha;

    CALL sp_ledger_evento_log(
        v_uuid_transacao,
        p_id_usuario,
        p_id_perfil,
        'CHAMAR_SENHA',
        v_status_atual,
        p_id_senha,
        JSON_OBJECT('id_guiche', p_id_guiche),
        'SUCESSO',
        CONCAT('Senha chamada no guichê ', p_id_guiche)
    );

    COMMIT;

    SET p_sucesso = TRUE;
    SET p_mensagem = CONCAT('Senha chamada no guichê ', p_id_guiche);
    SET p_resultado = JSON_OBJECT('id_senha', p_id_senha, 'uuid_transacao', v_uuid_transacao);

END ;;
```

