# sp_complementar_senha

Objetivo: complementar senha conforme definida no dump SQL do sistema.

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
- INSERT: gpat
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
- **Linha 25**: Estrutura condicional de controle de fluxo.
- **Linha 26**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 27**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 28**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 29**: Estrutura de repeticao/controle de loop.
- **Linha 30**: Estrutura condicional de controle de fluxo.
- **Linha 32**: START TRANSACTION;
- **Linha 34**: execucao de query SELECT para consulta de dados.
- **Linha 35**: FROM senha
- **Linha 36**: WHERE id_senha = p_id_senha
- **Linha 37**: LIMIT 1
- **Linha 38**: FOR UPDATE;
- **Linha 40**: Estrutura condicional de controle de fluxo.
- **Linha 41**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 42**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 43**: Estrutura de repeticao/controle de loop.
- **Linha 44**: Estrutura condicional de controle de fluxo.
- **Linha 46** (Comentario): atualizar status para COMPLEMENTADA
- **Linha 47**: UPDATE senha
- **Linha 48**: atribuicao de valor Ã  variavel status.
- **Linha 49**: chamado_em = NOW(6)
- **Linha 50**: WHERE id_senha = p_id_senha;
- **Linha 52** (Comentario): gerar GPAT
- **Linha 53**: Insere um novo registro na tabela gpat.
- **Linha 54**: VALUES (p_id_senha, p_id_usuario, NOW(6));
- **Linha 56**: Invoca a procedure sp_ledger_evento_log.
- **Linha 57**: v_uuid_transacao,
- **Linha 58**: p_id_usuario,
- **Linha 59**: p_id_perfil,
- **Linha 60**: 'COMPLEMENTAR_SENHA',
- **Linha 61**: v_status_atual,
- **Linha 62**: p_id_senha,
- **Linha 63**: JSON_OBJECT(),
- **Linha 64**: 'SUCESSO',
- **Linha 65**: 'Senha complementar vinculada à FFA e GPAT gerado'
- **Linha 66**: );
- **Linha 68**: COMMIT;
- **Linha 70**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 71**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 72**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 74**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_complementar_senha`(
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

    -- atualizar status para COMPLEMENTADA
    UPDATE senha
    SET status = 'COMPLEMENTADA',
        chamado_em = NOW(6)
    WHERE id_senha = p_id_senha;

    -- gerar GPAT
    INSERT INTO gpat (id_senha, gerado_por, criado_em)
    VALUES (p_id_senha, p_id_usuario, NOW(6));

    CALL sp_ledger_evento_log(
        v_uuid_transacao,
        p_id_usuario,
        p_id_perfil,
        'COMPLEMENTAR_SENHA',
        v_status_atual,
        p_id_senha,
        JSON_OBJECT(),
        'SUCESSO',
        'Senha complementar vinculada à FFA e GPAT gerado'
    );

    COMMIT;

    SET p_sucesso = TRUE;
    SET p_mensagem = 'Senha complementar finalizada com sucesso';
    SET p_resultado = JSON_OBJECT('id_senha', p_id_senha, 'uuid_transacao', v_uuid_transacao);

END ;;
```

