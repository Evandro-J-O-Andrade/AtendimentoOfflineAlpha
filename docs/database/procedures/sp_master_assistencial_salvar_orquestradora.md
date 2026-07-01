# sp_master_assistencial_salvar_orquestradora

Objetivo: master assistencial salvar orquestradora conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: atendimento_evento
- UPDATE: ffa
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CAST
- CONCAT
- IF
- JSON_EXTRACT
- JSON_UNQUOTE
- NOW
- SIGNAL

## Views Utilizadas
- v_dev
- v_ffa
- v_ip
- v_novo_fluxo
- v_pay
- v_saas
- v_sessao
- v_tabela_alvo
- v_unidade
- v_user

## Eventos Gerados
- evento

## Tratamento de Erros

- Uso de SIGNAL/RESIGNAL para gerar Erros customizados.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: nao detectado
- Commit: nao detectado

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: main: BEGIN
- **Linha 9** (Comentario): ==========================================
- **Linha 10** (Comentario): 1. DECLARAÇÕES E CONTEXTO
- **Linha 11** (Comentario): ==========================================
- **Linha 12**: Declaracao de variavel local v_id_usuario.
- **Linha 13**: Declaracao de variavel local v_tabela_alvo.
- **Linha 14**: Declaracao de variavel local v_novo_fluxo.
- **Linha 15**: Declaracao de variavel local v_tem_dor.
- **Linha 16**: Declaracao de variavel local v_escala_dor.
- **Linha 18** (Comentario): Captura contexto do usuário
- **Linha 19**: execucao de query SELECT para consulta de dados.
- **Linha 20**: FROM sessao_usuario
- **Linha 21**: WHERE id_sessao_usuario = p_id_sessao LIMIT 1;
- **Linha 23**: Estrutura condicional de controle de fluxo.
- **Linha 24**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_MASTER: SESSAO_INVALIDA';
- **Linha 25**: Estrutura condicional de controle de fluxo.
- **Linha 27** (Comentario): ==========================================
- **Linha 28** (Comentario): 2. ENGINE DE ROTEAMENTO (TABELA ALVO + NOVO FLUXO)
- **Linha 29** (Comentario): ==========================================
- **Linha 30**: atribuicao de valor Ã  variavel v_tabela_alvo.
- **Linha 31**: WHEN p_acao = 'TRIAGEM_SALVAR'     THEN 'atendimento_triagem'
- **Linha 32**: WHEN p_acao = 'EVOLUCAO_SALVAR'    THEN 'atendimento_evolucao'
- **Linha 33**: WHEN p_acao = 'ANAMNESE_SALVAR'    THEN 'atendimento_anamnese'
- **Linha 34**: WHEN p_acao = 'DIAGNOSTICO_SALVAR' THEN 'pep_registro'
- **Linha 35**: Estrutura condicional de controle de fluxo.
- **Linha 36**: Fim do bloco da procedure.
- **Linha 38**: atribuicao de valor Ã  variavel v_novo_fluxo.
- **Linha 39**: WHEN p_acao = 'TRIAGEM_SALVAR'     THEN 'AGUARDANDO_MEDICO'
- **Linha 40**: WHEN p_acao = 'EVOLUCAO_SALVAR'    THEN 'EM_ATENDIMENTO_MEDICO'
- **Linha 41**: WHEN p_acao = 'DIAGNOSTICO_SALVAR' THEN 'AGUARDANDO_DESFECHO'
- **Linha 42**: Estrutura condicional de controle de fluxo.
- **Linha 43**: Fim do bloco da procedure.
- **Linha 45**: Estrutura condicional de controle de fluxo.
- **Linha 46**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_MASTER: ACAO_NAO_MAPEADA';
- **Linha 47**: Estrutura condicional de controle de fluxo.
- **Linha 49** (Comentario): ==========================================
- **Linha 50** (Comentario): 3. TRATAMENTO COLUNA ESCALA_DOR
- **Linha 51** (Comentario): ==========================================
- **Linha 52**: Estrutura condicional de controle de fluxo.
- **Linha 54**: atribuicao de valor Ã  variavel v_tem_dor.
- **Linha 55**: atribuicao de valor Ã  variavel v_escala_dor.
- **Linha 56**: Estrutura condicional de controle de fluxo.
- **Linha 58** (Comentario): ==========================================
- **Linha 59** (Comentario): 4. EXECUÇÃO DINÂMICA COM PARAMETROS TIPADOS
- **Linha 60** (Comentario): ==========================================
- **Linha 61**: SET @sql_dinamico = CONCAT(
- **Linha 62**: 'INSERT INTO ', v_tabela_alvo, ' (
- **Linha 63**: id_saas_entidade, id_unidade, id_ffa, id_usuario, id_sessao_usuario, ',
- **Linha 64**: Estrutura condicional de controle de fluxo.
- **Linha 65**: 'payload_bruto, ip_origem, device_info, criado_em
- **Linha 66**: ) VALUES (',
- **Linha 67**: Estrutura condicional de controle de fluxo.
- **Linha 68**: ')'
- **Linha 69**: );
- **Linha 71** (Comentario): Variáveis bind
- **Linha 72**: SET @v_saas    = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_saas_entidade')) AS UNSIGNED);
- **Linha 73**: SET @v_unidade = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')) AS UNSIGNED);
- **Linha 74**: SET @v_ffa     = p_id_referencia;
- **Linha 75**: SET @v_user    = v_id_usuario;
- **Linha 76**: SET @v_sessao  = p_id_sessao;
- **Linha 77**: SET @v_pay     = p_payload;
- **Linha 78**: SET @v_ip      = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem'));
- **Linha 79**: SET @v_dev     = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info'));
- **Linha 81**: PREPARE stmt FROM @sql_dinamico;
- **Linha 83**: Estrutura condicional de controle de fluxo.
- **Linha 84**: EXECUTE stmt USING @v_saas, @v_unidade, @v_ffa, @v_user, @v_sessao, @v_escala_dor, @v_pay, @v_ip, @v_dev;
- **Linha 85**: Estrutura condicional de controle de fluxo.
- **Linha 86**: EXECUTE stmt USING @v_saas, @v_unidade, @v_ffa, @v_user, @v_sessao, @v_pay, @v_ip, @v_dev;
- **Linha 87**: Estrutura condicional de controle de fluxo.
- **Linha 89**: DEALLOCATE PREPARE stmt;
- **Linha 91** (Comentario): ==========================================
- **Linha 92** (Comentario): 5. LEDGER DE AUDITORIA DETALHADO
- **Linha 93** (Comentario): ==========================================
- **Linha 94**: Insere um novo registro na tabela atendimento_evento.
- **Linha 95**: id_saas_entidade, id_unidade, id_ffa, id_usuario,
- **Linha 96**: tipo_evento, descricao, payload_snapshot, fluxo_apos
- **Linha 97**: ) VALUES (
- **Linha 98**: @v_saas, @v_unidade, @v_ffa, @v_user,
- **Linha 99**: p_acao, CONCAT('Registro em ', v_tabela_alvo),
- **Linha 100**: p_payload, v_novo_fluxo
- **Linha 101**: );
- **Linha 103** (Comentario): ==========================================
- **Linha 104** (Comentario): 6. ORQUESTRAÇÃO DE FLUXO (WORKFLOW)
- **Linha 105** (Comentario): ==========================================
- **Linha 106**: Estrutura condicional de controle de fluxo.
- **Linha 107**: UPDATE ffa
- **Linha 108**: atribuicao de valor Ã  variavel contexto_fluxo.
- **Linha 109**: atualizado_em = NOW()
- **Linha 110**: WHERE id_ffa = p_id_referencia;
- **Linha 111**: Estrutura condicional de controle de fluxo.
- **Linha 113**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_assistencial_salvar_orquestradora`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),    -- Ex: 'TRIAGEM_SALVAR'
    IN p_id_referencia BIGINT, -- id_ffa
    IN p_payload JSON
)
    SQL SECURITY INVOKER
main: BEGIN
    -- ==========================================
    -- 1. DECLARAÇÕES E CONTEXTO
    -- ==========================================
    DECLARE v_id_usuario BIGINT;
    DECLARE v_tabela_alvo VARCHAR(64);
    DECLARE v_novo_fluxo VARCHAR(50);
    DECLARE v_tem_dor BOOLEAN DEFAULT FALSE;
    DECLARE v_escala_dor INT DEFAULT NULL;

    -- Captura contexto do usuário
    SELECT id_usuario INTO v_id_usuario 
    FROM sessao_usuario 
    WHERE id_sessao_usuario = p_id_sessao LIMIT 1;

    IF v_id_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_MASTER: SESSAO_INVALIDA';
    END IF;

    -- ==========================================
    -- 2. ENGINE DE ROTEAMENTO (TABELA ALVO + NOVO FLUXO)
    -- ==========================================
    SET v_tabela_alvo = CASE 
        WHEN p_acao = 'TRIAGEM_SALVAR'     THEN 'atendimento_triagem'
        WHEN p_acao = 'EVOLUCAO_SALVAR'    THEN 'atendimento_evolucao'
        WHEN p_acao = 'ANAMNESE_SALVAR'    THEN 'atendimento_anamnese'
        WHEN p_acao = 'DIAGNOSTICO_SALVAR' THEN 'pep_registro'
        ELSE NULL 
    END;

    SET v_novo_fluxo = CASE 
        WHEN p_acao = 'TRIAGEM_SALVAR'     THEN 'AGUARDANDO_MEDICO'
        WHEN p_acao = 'EVOLUCAO_SALVAR'    THEN 'EM_ATENDIMENTO_MEDICO'
        WHEN p_acao = 'DIAGNOSTICO_SALVAR' THEN 'AGUARDANDO_DESFECHO'
        ELSE NULL 
    END;

    IF v_tabela_alvo IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_MASTER: ACAO_NAO_MAPEADA';
    END IF;

    -- ==========================================
    -- 3. TRATAMENTO COLUNA ESCALA_DOR
    -- ==========================================
    IF v_tabela_alvo IN ('atendimento_triagem', 'atendimento_evolucao') 
       AND JSON_CONTAINS_PATH(p_payload, 'one', '$.escala_dor') THEN
        SET v_tem_dor = TRUE;
        SET v_escala_dor = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.escala_dor')) AS UNSIGNED);
    END IF;

    -- ==========================================
    -- 4. EXECUÇÃO DINÂMICA COM PARAMETROS TIPADOS
    -- ==========================================
    SET @sql_dinamico = CONCAT(
        'INSERT INTO ', v_tabela_alvo, ' (
            id_saas_entidade, id_unidade, id_ffa, id_usuario, id_sessao_usuario, ',
        IF(v_tem_dor, 'escala_dor, ', ''),
        'payload_bruto, ip_origem, device_info, criado_em
        ) VALUES (',
        IF(v_tem_dor, '?, ?, ?, ?, ?, ?, ?, ?, NOW(6)', '?, ?, ?, ?, ?, ?, ?, NOW(6)'),
        ')'
    );

    -- Variáveis bind
    SET @v_saas    = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_saas_entidade')) AS UNSIGNED);
    SET @v_unidade = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')) AS UNSIGNED);
    SET @v_ffa     = p_id_referencia;
    SET @v_user    = v_id_usuario;
    SET @v_sessao  = p_id_sessao;
    SET @v_pay     = p_payload;
    SET @v_ip      = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem'));
    SET @v_dev     = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info'));

    PREPARE stmt FROM @sql_dinamico;

    IF v_tem_dor THEN
        EXECUTE stmt USING @v_saas, @v_unidade, @v_ffa, @v_user, @v_sessao, @v_escala_dor, @v_pay, @v_ip, @v_dev;
    ELSE
        EXECUTE stmt USING @v_saas, @v_unidade, @v_ffa, @v_user, @v_sessao, @v_pay, @v_ip, @v_dev;
    END IF;

    DEALLOCATE PREPARE stmt;

    -- ==========================================
    -- 5. LEDGER DE AUDITORIA DETALHADO
    -- ==========================================
    INSERT INTO atendimento_evento (
        id_saas_entidade, id_unidade, id_ffa, id_usuario, 
        tipo_evento, descricao, payload_snapshot, fluxo_apos
    ) VALUES (
        @v_saas, @v_unidade, @v_ffa, @v_user,
        p_acao, CONCAT('Registro em ', v_tabela_alvo),
        p_payload, v_novo_fluxo
    );

    -- ==========================================
    -- 6. ORQUESTRAÇÃO DE FLUXO (WORKFLOW)
    -- ==========================================
    IF v_novo_fluxo IS NOT NULL THEN
        UPDATE ffa 
        SET contexto_fluxo = v_novo_fluxo,
            atualizado_em = NOW() 
        WHERE id_ffa = p_id_referencia;
    END IF;

END ;;
```

