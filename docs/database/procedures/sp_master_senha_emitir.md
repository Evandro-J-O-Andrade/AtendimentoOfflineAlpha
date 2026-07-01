# sp_master_senha_emitir

Objetivo: master senha emitir conforme definida no dump SQL do sistema.

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
- LAST_INSERT_ID
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
- **Linha 17**: Declaracao de variavel local v_prefixo.
- **Linha 18**: Declaracao de variavel local v_status.
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
- **Linha 32**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'SENHA_EMITIR',
- **Linha 33**: NULL, v_id_senha, p_payload, 'ERRO', v_error_msg
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
- **Linha 53** (Comentario): EXTRAIR DADOS DO PAYLOAD
- **Linha 54** (Comentario): =========================
- **Linha 55**: atribuicao de valor Ã  variavel v_id_unidade.
- **Linha 56**: atribuicao de valor Ã  variavel v_numero_senha.
- **Linha 58** (Comentario): =========================
- **Linha 59** (Comentario): INSERIR SENHA NA FILA
- **Linha 60** (Comentario): =========================
- **Linha 61**: Insere um novo registro na tabela senha.
- **Linha 62**: id_unidade,
- **Linha 63**: numero,
- **Linha 64**: prefixo,
- **Linha 65**: status,
- **Linha 66**: criado_por,
- **Linha 67**: criado_em
- **Linha 68**: ) VALUES (
- **Linha 69**: v_id_unidade,
- **Linha 70**: v_numero_senha,
- **Linha 71**: v_prefixo,
- **Linha 72**: v_status,
- **Linha 73**: p_id_usuario,
- **Linha 74**: NOW(6)
- **Linha 75**: );
- **Linha 77**: atribuicao de valor Ã  variavel v_id_senha.
- **Linha 79** (Comentario): =========================
- **Linha 80** (Comentario): REGISTRAR LEDGER
- **Linha 81** (Comentario): =========================
- **Linha 82**: Invoca a procedure sp_ledger_evento_log.
- **Linha 83**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'SENHA_EMITIR',
- **Linha 84**: NULL, v_id_senha, p_payload, 'SUCESSO',
- **Linha 85**: CONCAT('Senha emitida: ', v_prefixo, v_numero_senha)
- **Linha 86**: );
- **Linha 88** (Comentario): =========================
- **Linha 89** (Comentario): RETORNO PADRÃO
- **Linha 90** (Comentario): =========================
- **Linha 91**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 92**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 93**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 94**: 'id_senha', v_id_senha,
- **Linha 95**: 'id_unidade', v_id_unidade,
- **Linha 96**: 'numero_senha', v_numero_senha,
- **Linha 97**: 'prefixo', v_prefixo,
- **Linha 98**: 'status', v_status,
- **Linha 99**: 'uuid_transacao', v_uuid_transacao
- **Linha 100**: );
- **Linha 102** (Comentario): =========================
- **Linha 103** (Comentario): COMMIT TRANSAÇÃO
- **Linha 104** (Comentario): =========================
- **Linha 105**: COMMIT;
- **Linha 107**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_senha_emitir`(
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
    DECLARE v_prefixo CHAR(5) DEFAULT 'PA00';
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
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'SENHA_EMITIR',
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
    SET v_numero_senha = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.numero'));

    -- =========================
    -- INSERIR SENHA NA FILA
    -- =========================
    INSERT INTO senha (
        id_unidade,
        numero,
        prefixo,
        status,
        criado_por,
        criado_em
    ) VALUES (
        v_id_unidade,
        v_numero_senha,
        v_prefixo,
        v_status,
        p_id_usuario,
        NOW(6)
    );

    SET v_id_senha = LAST_INSERT_ID();

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'SENHA_EMITIR',
        NULL, v_id_senha, p_payload, 'SUCESSO',
        CONCAT('Senha emitida: ', v_prefixo, v_numero_senha)
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Senha emitida com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_senha', v_id_senha,
        'id_unidade', v_id_unidade,
        'numero_senha', v_numero_senha,
        'prefixo', v_prefixo,
        'status', v_status,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

