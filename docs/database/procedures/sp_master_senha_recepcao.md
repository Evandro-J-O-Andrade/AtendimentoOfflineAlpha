# sp_master_senha_recepcao

Objetivo: master senha recepcao conforme definida no dump SQL do sistema.

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
- SELECT: senha
- INSERT: senha
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_ledger_evento_log

## Functions Utilizadas
- COALESCE
- CONCAT
- IF
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- LAST_INSERT_ID
- MAX
- NOW
- UUID

## Views Utilizadas
- v_error_msg
- v_prefixo
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
- **Linha 14**: Declaracao de variavel local v_id_senha.
- **Linha 15**: Declaracao de variavel local v_id_unidade.
- **Linha 16**: Declaracao de variavel local v_numero_senha.
- **Linha 17**: Declaracao de variavel local v_guiche.
- **Linha 18**: Declaracao de variavel local v_prefixo.
- **Linha 19**: Declaracao de variavel local v_status.
- **Linha 21** (Comentario): =========================
- **Linha 22** (Comentario): HANDLER GLOBAL DE ERRO
- **Linha 23** (Comentario): =========================
- **Linha 24**: Declaracao de variavel local EXIT.
- **Linha 25**: inicio do bloco de execucao.
- **Linha 26**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 27**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 28**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 29**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 30**: ROLLBACK;
- **Linha 32**: Invoca a procedure sp_ledger_evento_log.
- **Linha 33**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'SENHA_RECEPCAO',
- **Linha 34**: NULL, v_id_senha, p_payload, 'ERRO', v_error_msg
- **Linha 35**: );
- **Linha 36**: Fim do bloco da procedure.
- **Linha 38** (Comentario): =========================
- **Linha 39** (Comentario): VALIDAR SESSÃO
- **Linha 40** (Comentario): =========================
- **Linha 41**: Estrutura condicional de controle de fluxo.
- **Linha 42**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 43**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 44**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 45**: Estrutura de repeticao/controle de loop.
- **Linha 46**: Estrutura condicional de controle de fluxo.
- **Linha 48** (Comentario): =========================
- **Linha 49** (Comentario): INICIAR TRANSAÇÃO
- **Linha 50** (Comentario): =========================
- **Linha 51**: START TRANSACTION;
- **Linha 53** (Comentario): =========================
- **Linha 54** (Comentario): EXTRAIR DADOS DO PAYLOAD
- **Linha 55** (Comentario): =========================
- **Linha 56**: atribuicao de valor Ã  variavel v_id_unidade.
- **Linha 57**: atribuicao de valor Ã  variavel v_guiche.
- **Linha 59** (Comentario): =========================
- **Linha 60** (Comentario): GERAR NUMERO DA SENHA
- **Linha 61** (Comentario): =========================
- **Linha 62**: execucao de query SELECT para consulta de dados.
- **Linha 63**: INTO v_numero_senha
- **Linha 64**: FROM senha
- **Linha 65**: WHERE id_unidade = v_id_unidade
- **Linha 68**: atribuicao de valor Ã  variavel v_prefixo.
- **Linha 70** (Comentario): =========================
- **Linha 71** (Comentario): INSERIR SENHA INTERNA
- **Linha 72** (Comentario): =========================
- **Linha 73**: Insere um novo registro na tabela senha.
- **Linha 74**: id_unidade,
- **Linha 75**: numero,
- **Linha 76**: prefixo,
- **Linha 77**: status,
- **Linha 78**: guiche,
- **Linha 79**: criado_por,
- **Linha 80**: criado_em
- **Linha 81**: ) VALUES (
- **Linha 82**: v_id_unidade,
- **Linha 83**: v_numero_senha,
- **Linha 84**: v_prefixo,
- **Linha 85**: v_status,
- **Linha 86**: v_guiche,
- **Linha 87**: p_id_usuario,
- **Linha 88**: NOW(6)
- **Linha 89**: );
- **Linha 91**: atribuicao de valor Ã  variavel v_id_senha.
- **Linha 93** (Comentario): =========================
- **Linha 94** (Comentario): REGISTRAR LEDGER
- **Linha 95** (Comentario): =========================
- **Linha 96**: Invoca a procedure sp_ledger_evento_log.
- **Linha 97**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'SENHA_RECEPCAO',
- **Linha 98**: NULL, v_id_senha, p_payload, 'SUCESSO',
- **Linha 99**: CONCAT('Senha interna gerada pelo guichê ', v_guiche, ': ', v_prefixo, v_numero_senha)
- **Linha 100**: );
- **Linha 102** (Comentario): =========================
- **Linha 103** (Comentario): RETORNO PADRÃO
- **Linha 104** (Comentario): =========================
- **Linha 105**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 106**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 107**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 108**: 'id_senha', v_id_senha,
- **Linha 109**: 'id_unidade', v_id_unidade,
- **Linha 110**: 'numero_senha', v_numero_senha,
- **Linha 111**: 'prefixo', v_prefixo,
- **Linha 112**: 'guiche', v_guiche,
- **Linha 113**: 'status', v_status,
- **Linha 114**: 'uuid_transacao', v_uuid_transacao
- **Linha 115**: );
- **Linha 117** (Comentario): =========================
- **Linha 118** (Comentario): COMMIT TRANSAÇÃO
- **Linha 119** (Comentario): =========================
- **Linha 120**: COMMIT;
- **Linha 122**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_senha_recepcao`(
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
    DECLARE v_id_senha BIGINT DEFAULT NULL;
    DECLARE v_id_unidade BIGINT DEFAULT NULL;
    DECLARE v_numero_senha INT DEFAULT NULL;
    DECLARE v_guiche INT DEFAULT NULL;
    DECLARE v_prefixo CHAR(5) DEFAULT 'RX00';
    DECLARE v_status VARCHAR(20) DEFAULT 'EM_ESPERA';

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
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'SENHA_RECEPCAO',
            NULL, v_id_senha, p_payload, 'ERRO', v_error_msg
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
    -- EXTRAIR DADOS DO PAYLOAD
    -- =========================
    SET v_id_unidade = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade'));
    SET v_guiche = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.guiche'));

    -- =========================
    -- GERAR NUMERO DA SENHA
    -- =========================
    SELECT COALESCE(MAX(numero), 0) + 1
    INTO v_numero_senha
    FROM senha
    WHERE id_unidade = v_id_unidade
      AND prefixo = CONCAT('RX', LPAD(v_guiche, 2, '0'));

    SET v_prefixo = CONCAT('RX', LPAD(v_guiche, 2, '0'));

    -- =========================
    -- INSERIR SENHA INTERNA
    -- =========================
    INSERT INTO senha (
        id_unidade,
        numero,
        prefixo,
        status,
        guiche,
        criado_por,
        criado_em
    ) VALUES (
        v_id_unidade,
        v_numero_senha,
        v_prefixo,
        v_status,
        v_guiche,
        p_id_usuario,
        NOW(6)
    );

    SET v_id_senha = LAST_INSERT_ID();

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'SENHA_RECEPCAO',
        NULL, v_id_senha, p_payload, 'SUCESSO',
        CONCAT('Senha interna gerada pelo guichê ', v_guiche, ': ', v_prefixo, v_numero_senha)
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Senha interna da recepção gerada com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_senha', v_id_senha,
        'id_unidade', v_id_unidade,
        'numero_senha', v_numero_senha,
        'prefixo', v_prefixo,
        'guiche', v_guiche,
        'status', v_status,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

