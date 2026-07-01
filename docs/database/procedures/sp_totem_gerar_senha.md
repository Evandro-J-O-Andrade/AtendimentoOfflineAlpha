# sp_totem_gerar_senha

Objetivo: totem gerar senha conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_id_paciente | BIGINT | IN | |
| p_id_senha | BIGINT | OUT | |
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
- CAST
- CONCAT
- IF
- IFNULL
- JSON_OBJECT
- LAST_INSERT_ID
- MAX
- NOW
- SUBSTRING
- UUID

## Views Utilizadas
- v_error_msg
- v_numero_senha
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
- **Linha 11**: fechamento da lista de Parametros.
- **Linha 12**: SQL SECURITY INVOKER
- **Linha 13**: proc_block: BEGIN
- **Linha 15** (Comentario): =========================
- **Linha 16** (Comentario): DECLARAR VARIÁVEIS E HANDLERS NO TOPO
- **Linha 17** (Comentario): =========================
- **Linha 18**: Declaracao de variavel local v_uuid_transacao.
- **Linha 19**: Declaracao de variavel local v_error_msg.
- **Linha 20**: Declaracao de variavel local v_numero_senha.
- **Linha 22**: Declaracao de variavel local EXIT.
- **Linha 23**: inicio do bloco de execucao.
- **Linha 24**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 25**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 26**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 27**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 28**: ROLLBACK;
- **Linha 29**: Fim do bloco da procedure.
- **Linha 31** (Comentario): =========================
- **Linha 32** (Comentario): TRATAR VALOR DEFAULT
- **Linha 33** (Comentario): =========================
- **Linha 34**: Estrutura condicional de controle de fluxo.
- **Linha 35**: atribuicao de valor Ã  variavel p_tipo_senha.
- **Linha 36**: Estrutura condicional de controle de fluxo.
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
- **Linha 54** (Comentario): GERAR NÚMERO DE SENHA SEQUENCIAL COM RESET DIÁRIO
- **Linha 55** (Comentario): =========================
- **Linha 56**: atribuicao de valor Ã  variavel v_numero_senha.
- **Linha 57**: CASE p_tipo_senha
- **Linha 58**: WHEN 'NORMAL' THEN 'CLINI-'
- **Linha 59**: WHEN 'PRIORITARIO' THEN 'CLINI-PRI-'
- **Linha 60**: WHEN 'PEDIATRIA' THEN 'PED-'
- **Linha 61**: Estrutura condicional de controle de fluxo.
- **Linha 62**: END,
- **Linha 63**: LPAD(
- **Linha 64**: Estrutura condicional de controle de fluxo.
- **Linha 65**: (SELECT MAX(CAST(SUBSTRING(numero_senha, -3) AS UNSIGNED))
- **Linha 66**: FROM senha
- **Linha 67**: WHERE DATE(criado_em) = CURDATE()
- **Linha 69**: ) + 1, 3, '0'
- **Linha 70**: fechamento da lista de Parametros.
- **Linha 71**: );
- **Linha 73** (Comentario): =========================
- **Linha 74** (Comentario): INSERIR SENHA
- **Linha 75** (Comentario): =========================
- **Linha 76**: Insere um novo registro na tabela senha.
- **Linha 77**: id_paciente,
- **Linha 78**: tipo_senha,
- **Linha 79**: numero_senha,
- **Linha 80**: status,
- **Linha 81**: gerado_por,
- **Linha 82**: criado_em
- **Linha 83**: ) VALUES (
- **Linha 84**: p_id_paciente,
- **Linha 85**: p_tipo_senha,
- **Linha 86**: v_numero_senha,
- **Linha 87**: 'GERADA',
- **Linha 88**: p_id_usuario,
- **Linha 89**: NOW(6)
- **Linha 90**: );
- **Linha 92**: atribuicao de valor Ã  variavel p_id_senha.
- **Linha 94** (Comentario): =========================
- **Linha 95** (Comentario): REGISTRAR LEDGER
- **Linha 96** (Comentario): =========================
- **Linha 97**: Invoca a procedure sp_ledger_evento_log.
- **Linha 98**: v_uuid_transacao,
- **Linha 99**: p_id_usuario,
- **Linha 100**: p_id_perfil,
- **Linha 101**: 'GERAR_SENHA',
- **Linha 102**: NULL,
- **Linha 103**: p_id_senha,
- **Linha 104**: JSON_OBJECT('tipo_senha', p_tipo_senha,'numero_senha',v_numero_senha),
- **Linha 105**: 'SUCESSO',
- **Linha 106**: CONCAT('Senha gerada: ', v_numero_senha)
- **Linha 107**: );
- **Linha 109** (Comentario): =========================
- **Linha 110** (Comentario): COMMIT E RETORNO
- **Linha 111** (Comentario): =========================
- **Linha 112**: COMMIT;
- **Linha 114**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 115**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 116**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 117**: 'id_senha', p_id_senha,
- **Linha 118**: 'numero_senha', v_numero_senha,
- **Linha 119**: 'tipo_senha', p_tipo_senha,
- **Linha 120**: 'uuid_transacao', v_uuid_transacao
- **Linha 121**: );
- **Linha 123**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_totem_gerar_senha`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_id_paciente BIGINT,
    IN p_tipo_senha VARCHAR(20), -- tratar default internamente
    OUT p_id_senha BIGINT,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
    SQL SECURITY INVOKER
proc_block: BEGIN

    -- =========================
    -- DECLARAR VARIÁVEIS E HANDLERS NO TOPO
    -- =========================
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_numero_senha VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;
    END;

    -- =========================
    -- TRATAR VALOR DEFAULT
    -- =========================
    IF p_tipo_senha IS NULL OR p_tipo_senha = '' THEN
        SET p_tipo_senha = 'NORMAL';
    END IF;

    -- =========================
    -- VALIDAR SESSÃO
    -- =========================
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error','Sessão inválida','uuid_transacao',v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    -- =========================
    -- INICIAR TRANSAÇÃO
    -- =========================
    START TRANSACTION;

    -- =========================
    -- GERAR NÚMERO DE SENHA SEQUENCIAL COM RESET DIÁRIO
    -- =========================
    SET v_numero_senha = CONCAT(
        CASE p_tipo_senha
            WHEN 'NORMAL' THEN 'CLINI-'
            WHEN 'PRIORITARIO' THEN 'CLINI-PRI-'
            WHEN 'PEDIATRIA' THEN 'PED-'
            ELSE 'CLINI-'
        END,
        LPAD(
            IFNULL(
                (SELECT MAX(CAST(SUBSTRING(numero_senha, -3) AS UNSIGNED))
                 FROM senha
                 WHERE DATE(criado_em) = CURDATE()
                 AND tipo_senha = p_tipo_senha),0
            ) + 1, 3, '0'
        )
    );

    -- =========================
    -- INSERIR SENHA
    -- =========================
    INSERT INTO senha (
        id_paciente,
        tipo_senha,
        numero_senha,
        status,
        gerado_por,
        criado_em
    ) VALUES (
        p_id_paciente,
        p_tipo_senha,
        v_numero_senha,
        'GERADA',
        p_id_usuario,
        NOW(6)
    );

    SET p_id_senha = LAST_INSERT_ID();

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao,
        p_id_usuario,
        p_id_perfil,
        'GERAR_SENHA',
        NULL,
        p_id_senha,
        JSON_OBJECT('tipo_senha', p_tipo_senha,'numero_senha',v_numero_senha),
        'SUCESSO',
        CONCAT('Senha gerada: ', v_numero_senha)
    );

    -- =========================
    -- COMMIT E RETORNO
    -- =========================
    COMMIT;

    SET p_sucesso = TRUE;
    SET p_mensagem = CONCAT('Senha gerada com sucesso: ', v_numero_senha);
    SET p_resultado = JSON_OBJECT(
        'id_senha', p_id_senha,
        'numero_senha', v_numero_senha,
        'tipo_senha', p_tipo_senha,
        'uuid_transacao', v_uuid_transacao
    );

END ;;
```

