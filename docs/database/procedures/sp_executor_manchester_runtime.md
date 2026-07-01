# sp_executor_manchester_runtime

Objetivo: executor manchester runtime conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fluxo_transicao_matriz, sessao_usuario
- INSERT: (nenhuma)
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_ledger_evento_log

## Functions Utilizadas
- CAST
- CONCAT
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- NOW
- SIGNAL
- TIMESTAMPDIFF
- UUID

## Views Utilizadas
- v_uuid

## Eventos Gerados
- evento
- ledger_evento

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).
- Uso de SIGNAL/RESIGNAL para gerar Erros customizados.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: Sim
- Commit: Sim

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: fechamento da lista de Parametros.
- **Linha 4**: SQL SECURITY INVOKER
- **Linha 5**: inicio do bloco de execucao.
- **Linha 7** (Comentario): =========================
- **Linha 8** (Comentario): 1. DECLARAÇÕES
- **Linha 9** (Comentario): =========================
- **Linha 10**: Declaracao de variavel local v_id_usuario.
- **Linha 11**: Declaracao de variavel local v_id_perfil.
- **Linha 13**: Declaracao de variavel local v_uuid.
- **Linha 15**: Declaracao de variavel local v_msg.
- **Linha 16**: Declaracao de variavel local v_msg_final.
- **Linha 18** (Comentario): =========================
- **Linha 19** (Comentario): 2. HANDLER
- **Linha 20** (Comentario): =========================
- **Linha 21**: Declaracao de variavel local EXIT.
- **Linha 22**: inicio do bloco de execucao.
- **Linha 23**: GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT;
- **Linha 24**: ROLLBACK;
- **Linha 26**: atribuicao de valor Ã  variavel v_msg_final.
- **Linha 28**: SIGNAL SQLSTATE '45000'
- **Linha 29**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 30**: Fim do bloco da procedure.
- **Linha 32** (Comentario): =========================
- **Linha 33** (Comentario): 3. CONTEXTO
- **Linha 34** (Comentario): =========================
- **Linha 35**: execucao de query SELECT para consulta de dados.
- **Linha 36**: INTO v_id_usuario, v_id_perfil
- **Linha 37**: FROM sessao_usuario
- **Linha 38**: WHERE id_sessao_usuario = p_id_sessao
- **Linha 39**: LIMIT 1;
- **Linha 41**: START TRANSACTION;
- **Linha 43** (Comentario): =========================
- **Linha 44** (Comentario): 4. ESCALONAMENTO DINÂMICO
- **Linha 45** (Comentario): =========================
- **Linha 46**: UPDATE senha s
- **Linha 47**: JOIN fluxo_transicao_matriz f
- **Linha 48**: CondiÃ§Ã£o de chave ou Tratamento de duplicidade.
- **Linha 52**: SET
- **Linha 53**: s.risco_dinamico = JSON_UNQUOTE(JSON_EXTRACT(f.condicao_validacao, '$.risco_resultante')),
- **Linha 54**: s.risco_dinamico_em = NOW(6),
- **Linha 55**: s.risco_dinamico_origem = 'SISTEMA',
- **Linha 57**: s.prioridade = CASE JSON_UNQUOTE(JSON_EXTRACT(f.condicao_validacao, '$.risco_resultante'))
- **Linha 58**: WHEN 'VERMELHO' THEN 100
- **Linha 59**: WHEN 'LARANJA' THEN 80
- **Linha 60**: WHEN 'AMARELO' THEN 50
- **Linha 61**: WHEN 'VERDE' THEN 20
- **Linha 62**: Estrutura condicional de controle de fluxo.
- **Linha 63**: END
- **Linha 65**: WHERE
- **Linha 66**: s.executado_em IS NULL
- **Linha 70**: CAST(JSON_UNQUOTE(JSON_EXTRACT(f.condicao_validacao, '$.tempo_max')) AS UNSIGNED);
- **Linha 72** (Comentario): =========================
- **Linha 73** (Comentario): 5. REORDENAÇÃO
- **Linha 74** (Comentario): =========================
- **Linha 75**: SET @ordem := 0;
- **Linha 77**: UPDATE senha
- **Linha 78**: atribuicao de valor Ã  variavel ordem_fila.
- **Linha 79**: WHERE executado_em IS NULL
- **Linha 82**: ORDER BY prioridade DESC, criado_em ASC;
- **Linha 84** (Comentario): =========================
- **Linha 85** (Comentario): 6. LEDGER
- **Linha 86** (Comentario): =========================
- **Linha 87**: atribuicao de valor Ã  variavel v_uuid.
- **Linha 89**: Invoca a procedure sp_ledger_evento_log.
- **Linha 90**: v_uuid,
- **Linha 91**: v_id_usuario,
- **Linha 92**: v_id_perfil,
- **Linha 93**: 'MANCHESTER_AUTO',
- **Linha 94**: NULL,
- **Linha 95**: 'EXECUTADO',
- **Linha 96**: JSON_OBJECT('tipo', 'RECLASSIFICACAO_AUTOMATICA'),
- **Linha 97**: 'SUCESSO',
- **Linha 98**: 'ESCALONAMENTO_SLA'
- **Linha 99**: );
- **Linha 101**: COMMIT;
- **Linha 103**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_manchester_runtime`(
    IN p_id_sessao BIGINT
)
    SQL SECURITY INVOKER
BEGIN

    -- =========================
    -- 1. DECLARAÇÕES
    -- =========================
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_perfil BIGINT;

    DECLARE v_uuid CHAR(36);

    DECLARE v_msg TEXT;
    DECLARE v_msg_final TEXT;

    -- =========================
    -- 2. HANDLER
    -- =========================
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT;
        ROLLBACK;

        SET v_msg_final = CONCAT('MANCHESTER_FAIL: ', v_msg);

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = v_msg_final;
    END;

    -- =========================
    -- 3. CONTEXTO
    -- =========================
    SELECT id_usuario, id_perfil
    INTO v_id_usuario, v_id_perfil
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao
    LIMIT 1;

    START TRANSACTION;

    -- =========================
    -- 4. ESCALONAMENTO DINÂMICO
    -- =========================
    UPDATE senha s
    JOIN fluxo_transicao_matriz f
        ON f.dominio_fluxo = 'FILA'
       AND f.estado_origem COLLATE utf8mb4_0900_ai_ci = s.contexto_fluxo
       AND f.ativo = 1

    SET 
        s.risco_dinamico = JSON_UNQUOTE(JSON_EXTRACT(f.condicao_validacao, '$.risco_resultante')),
        s.risco_dinamico_em = NOW(6),
        s.risco_dinamico_origem = 'SISTEMA',

        s.prioridade = CASE JSON_UNQUOTE(JSON_EXTRACT(f.condicao_validacao, '$.risco_resultante'))
            WHEN 'VERMELHO' THEN 100
            WHEN 'LARANJA' THEN 80
            WHEN 'AMARELO' THEN 50
            WHEN 'VERDE' THEN 20
            ELSE s.prioridade
        END

    WHERE
        s.executado_em IS NULL
        AND s.cancelado = 0
        AND s.nao_compareceu = 0
        AND TIMESTAMPDIFF(MINUTE, s.criado_em, NOW()) >
            CAST(JSON_UNQUOTE(JSON_EXTRACT(f.condicao_validacao, '$.tempo_max')) AS UNSIGNED);

    -- =========================
    -- 5. REORDENAÇÃO
    -- =========================
    SET @ordem := 0;

    UPDATE senha
    SET ordem_fila = (@ordem := @ordem + 1)
    WHERE executado_em IS NULL
      AND cancelado = 0
      AND nao_compareceu = 0
    ORDER BY prioridade DESC, criado_em ASC;

    -- =========================
    -- 6. LEDGER
    -- =========================
    SET v_uuid = UUID();

    CALL sp_ledger_evento_log(
        v_uuid,
        v_id_usuario,
        v_id_perfil,
        'MANCHESTER_AUTO',
        NULL,
        'EXECUTADO',
        JSON_OBJECT('tipo', 'RECLASSIFICACAO_AUTOMATICA'),
        'SUCESSO',
        'ESCALONAMENTO_SLA'
    );

    COMMIT;

END ;;
```

