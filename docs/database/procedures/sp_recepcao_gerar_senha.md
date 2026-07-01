# sp_recepcao_gerar_senha

Objetivo: recepcao gerar senha conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_guiche | INT | IN | |
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
- CURRENT_DATE
- IF
- JSON_OBJECT
- LAST_INSERT_ID
- MAX
- NOW
- UUID

## Views Utilizadas
- v_error_msg
- v_hora_entrada
- v_prefixo
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
- **Linha 15**: Declaracao de variavel local v_id_senha.
- **Linha 16**: Declaracao de variavel local v_numero_senha.
- **Linha 17**: Declaracao de variavel local v_prefixo.
- **Linha 18**: Declaracao de variavel local v_hora_entrada.
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
- **Linha 32**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'RECEPCAO_GERAR_SENHA',
- **Linha 33**: NULL, v_id_senha, JSON_OBJECT('tipo', p_tipo_atendimento, 'guiche', p_guiche), 'ERRO', v_error_msg
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
- **Linha 53** (Comentario): DEFINIR PREFIXO DA SENHA
- **Linha 54** (Comentario): =========================
- **Linha 55**: atribuicao de valor Ã  variavel v_prefixo.
- **Linha 56**: WHEN p_tipo_atendimento = 'ADULTO' THEN 'A'
- **Linha 57**: WHEN p_tipo_atendimento = 'CRIANCA' THEN 'C'
- **Linha 58**: WHEN p_tipo_atendimento = 'ESPECIAL' THEN 'E'
- **Linha 59**: WHEN p_tipo_atendimento = 'SAMU' THEN 'S'
- **Linha 60**: Estrutura condicional de controle de fluxo.
- **Linha 61**: Fim do bloco da procedure.
- **Linha 63** (Comentario): =========================
- **Linha 64** (Comentario): GERAR NUMERO SEQUENCIAL RESET DIÁRIO
- **Linha 65** (Comentario): =========================
- **Linha 66**: execucao de query SELECT para consulta de dados.
- **Linha 67**: INTO v_numero_senha
- **Linha 68**: FROM senha
- **Linha 69**: WHERE prefixo = v_prefixo
- **Linha 72** (Comentario): =========================
- **Linha 73** (Comentario): INSERIR SENHA
- **Linha 74** (Comentario): =========================
- **Linha 75**: Insere um novo registro na tabela senha.
- **Linha 76**: prefixo,
- **Linha 77**: numero,
- **Linha 78**: id_guiche,
- **Linha 79**: criado_por,
- **Linha 80**: criado_em,
- **Linha 81**: status
- **Linha 82**: ) VALUES (
- **Linha 83**: v_prefixo,
- **Linha 84**: v_numero_senha,
- **Linha 85**: p_guiche,
- **Linha 86**: p_id_usuario,
- **Linha 87**: v_hora_entrada,
- **Linha 88**: 'GERADA'
- **Linha 89**: );
- **Linha 91**: atribuicao de valor Ã  variavel v_id_senha.
- **Linha 93** (Comentario): =========================
- **Linha 94** (Comentario): REGISTRAR LEDGER
- **Linha 95** (Comentario): =========================
- **Linha 96**: Invoca a procedure sp_ledger_evento_log.
- **Linha 97**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'RECEPCAO_GERAR_SENHA',
- **Linha 98**: NULL, v_id_senha, JSON_OBJECT('tipo', p_tipo_atendimento, 'guiche', p_guiche), 'SUCESSO',
- **Linha 99**: CONCAT('Senha gerada: ', v_prefixo, '-', LPAD(v_numero_senha, 3, '0'))
- **Linha 100**: );
- **Linha 102** (Comentario): =========================
- **Linha 103** (Comentario): RETORNO PADRÃO
- **Linha 104** (Comentario): =========================
- **Linha 105**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 106**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 107**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 108**: 'id_senha', v_id_senha,
- **Linha 109**: 'numero', v_numero_senha,
- **Linha 110**: 'prefixo', v_prefixo,
- **Linha 111**: 'guiche', p_guiche,
- **Linha 112**: 'hora_entrada', v_hora_entrada,
- **Linha 113**: 'uuid_transacao', v_uuid_transacao
- **Linha 114**: );
- **Linha 116** (Comentario): =========================
- **Linha 117** (Comentario): COMMIT TRANSAÇÃO
- **Linha 118** (Comentario): =========================
- **Linha 119**: COMMIT;
- **Linha 121**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_recepcao_gerar_senha`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_tipo_atendimento VARCHAR(50), -- 'ADULTO', 'CRIANCA', 'ESPECIAL', 'SAMU'
    IN p_guiche INT,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
    SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_senha BIGINT DEFAULT NULL;
    DECLARE v_numero_senha INT DEFAULT NULL;
    DECLARE v_prefixo CHAR(10) DEFAULT NULL;
    DECLARE v_hora_entrada DATETIME DEFAULT NOW(6);

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
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'RECEPCAO_GERAR_SENHA',
            NULL, v_id_senha, JSON_OBJECT('tipo', p_tipo_atendimento, 'guiche', p_guiche), 'ERRO', v_error_msg
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
    -- DEFINIR PREFIXO DA SENHA
    -- =========================
    SET v_prefixo = CASE 
        WHEN p_tipo_atendimento = 'ADULTO' THEN 'A'
        WHEN p_tipo_atendimento = 'CRIANCA' THEN 'C'
        WHEN p_tipo_atendimento = 'ESPECIAL' THEN 'E'
        WHEN p_tipo_atendimento = 'SAMU' THEN 'S'
        ELSE 'N'
    END;

    -- =========================
    -- GERAR NUMERO SEQUENCIAL RESET DIÁRIO
    -- =========================
    SELECT COALESCE(MAX(numero), 0) + 1
    INTO v_numero_senha
    FROM senha
    WHERE prefixo = v_prefixo
      AND DATE(criado_em) = CURRENT_DATE;

    -- =========================
    -- INSERIR SENHA
    -- =========================
    INSERT INTO senha (
        prefixo,
        numero,
        id_guiche,
        criado_por,
        criado_em,
        status
    ) VALUES (
        v_prefixo,
        v_numero_senha,
        p_guiche,
        p_id_usuario,
        v_hora_entrada,
        'GERADA'
    );

    SET v_id_senha = LAST_INSERT_ID();

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'RECEPCAO_GERAR_SENHA',
        NULL, v_id_senha, JSON_OBJECT('tipo', p_tipo_atendimento, 'guiche', p_guiche), 'SUCESSO',
        CONCAT('Senha gerada: ', v_prefixo, '-', LPAD(v_numero_senha, 3, '0'))
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Senha gerada com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_senha', v_id_senha,
        'numero', v_numero_senha,
        'prefixo', v_prefixo,
        'guiche', p_guiche,
        'hora_entrada', v_hora_entrada,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

