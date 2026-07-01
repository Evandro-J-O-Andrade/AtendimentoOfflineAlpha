# sp_executor_assistencial_triagem_salvar

Objetivo: executor assistencial triagem salvar conforme definida no dump SQL do sistema.

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
- INSERT: atendimento_triagem
- UPDATE: ffa
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CAST
- JSON_EXTRACT
- JSON_UNQUOTE
- NOW
- NULLIF

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- (nenhum)

## Tratamento de Erros

- Sem Tratamento de erro explicito detectado.

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
- **Linha 8**: inicio do bloco de execucao.
- **Linha 9** (Comentario): ==========================================
- **Linha 10** (Comentario): 1. DECLARAÇÕES
- **Linha 11** (Comentario): ==========================================
- **Linha 12**: Declaracao de variavel local v_id_usuario.
- **Linha 13**: Declaracao de variavel local v_msg.
- **Linha 15** (Comentario): ==========================================
- **Linha 16** (Comentario): 2. CONTEXTO
- **Linha 17** (Comentario): ==========================================
- **Linha 18**: execucao de query SELECT para consulta de dados.
- **Linha 19**: FROM sessao_usuario
- **Linha 20**: WHERE id_sessao_usuario = p_id_sessao LIMIT 1;
- **Linha 22** (Comentario): ==========================================
- **Linha 23** (Comentario): 3. EXECUÇÃO DO INSERT (TODOS OS CAMPOS DO DUMP)
- **Linha 24** (Comentario): ==========================================
- **Linha 25**: Insere um novo registro na tabela atendimento_triagem.
- **Linha 26**: id_saas_entidade,
- **Linha 27**: id_unidade,
- **Linha 28**: id_ffa,
- **Linha 29**: id_atendimento,
- **Linha 30**: id_usuario,
- **Linha 31**: id_sessao_usuario,
- **Linha 33** (Comentario): Sinais Vitais e Dados Clínicos
- **Linha 34**: peso,
- **Linha 35**: altura,
- **Linha 36**: pressao_arterial,
- **Linha 37**: frequencia_cardiaca,
- **Linha 38**: frequencia_respiratoria,
- **Linha 39**: temperatura,
- **Linha 40**: saturacao,
- **Linha 41**: hgt, -- Hemoglicoteste (Glicemia)
- **Linha 43** (Comentario): Classificação
- **Linha 44**: queixa_principal,
- **Linha 45**: id_protocolo_manchester,
- **Linha 46**: prioridade_cor,
- **Linha 48** (Comentario): Auditoria
- **Linha 49**: ip_origem,
- **Linha 50**: device_info,
- **Linha 51**: criado_em
- **Linha 52**: ) VALUES (
- **Linha 53** (Comentario): Dados injetados pelo Dispatcher no JSON
- **Linha 54**: CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_saas_entidade')) AS UNSIGNED),
- **Linha 55**: CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')) AS UNSIGNED),
- **Linha 56**: p_id_referencia,
- **Linha 57**: CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento')) AS UNSIGNED),
- **Linha 59** (Comentario): Dados da Sessão
- **Linha 60**: v_id_usuario,
- **Linha 61**: p_id_sessao,
- **Linha 63** (Comentario): Dados Clínicos (Vêm do Front-end via Payload)
- **Linha 64**: CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.peso')), '') AS DECIMAL(5,2)),
- **Linha 65**: CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.altura')), '') AS DECIMAL(3,2)),
- **Linha 66**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.pressao_arterial')),
- **Linha 67**: CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.frequencia_cardiaca')), '') AS UNSIGNED),
- **Linha 68**: CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.frequencia_respiratoria')), '') AS UNSIGNED),
- **Linha 69**: CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.temperatura')), '') AS DECIMAL(4,2)),
- **Linha 70**: CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.saturacao')), '') AS UNSIGNED),
- **Linha 71**: CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.hgt')), '') AS UNSIGNED),
- **Linha 73** (Comentario): Queixa e Protocolo
- **Linha 74**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.queixa_principal')),
- **Linha 75**: CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_protocolo_manchester')), '') AS UNSIGNED),
- **Linha 76**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.prioridade_cor')),
- **Linha 78** (Comentario): Auditoria (Injetado pelo Dispatcher ou vindo do Front)
- **Linha 79**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem')),
- **Linha 80**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info')),
- **Linha 81**: NOW(6)
- **Linha 82**: );
- **Linha 84** (Comentario): ==========================================
- **Linha 85** (Comentario): 4. ATUALIZAÇÃO OPCIONAL DE FLUXO
- **Linha 86** (Comentario): ==========================================
- **Linha 87** (Comentario): Aqui você pode atualizar o estado da FFA para 'AGUARDANDO_MEDICO'
- **Linha 88**: Atualiza registros existentes na tabela ffa.
- **Linha 90**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_assistencial_triagem_salvar`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),    -- Necessário para compatibilidade com o Dispatcher
    IN p_id_referencia BIGINT, -- id_ffa
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN
    -- ==========================================
    -- 1. DECLARAÇÕES
    -- ==========================================
    DECLARE v_id_usuario BIGINT;
    DECLARE v_msg TEXT;

    -- ==========================================
    -- 2. CONTEXTO
    -- ==========================================
    SELECT id_usuario INTO v_id_usuario 
    FROM sessao_usuario 
    WHERE id_sessao_usuario = p_id_sessao LIMIT 1;

    -- ==========================================
    -- 3. EXECUÇÃO DO INSERT (TODOS OS CAMPOS DO DUMP)
    -- ==========================================
    INSERT INTO atendimento_triagem (
        id_saas_entidade,
        id_unidade,
        id_ffa,
        id_atendimento,
        id_usuario,
        id_sessao_usuario,
        
        -- Sinais Vitais e Dados Clínicos
        peso,
        altura,
        pressao_arterial,
        frequencia_cardiaca,
        frequencia_respiratoria,
        temperatura,
        saturacao,
        hgt, -- Hemoglicoteste (Glicemia)
        
        -- Classificação
        queixa_principal,
        id_protocolo_manchester,
        prioridade_cor,
        
        -- Auditoria
        ip_origem,
        device_info,
        criado_em
    ) VALUES (
        -- Dados injetados pelo Dispatcher no JSON
        CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_saas_entidade')) AS UNSIGNED),
        CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')) AS UNSIGNED),
        p_id_referencia,
        CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento')) AS UNSIGNED),
        
        -- Dados da Sessão
        v_id_usuario,
        p_id_sessao,
        
        -- Dados Clínicos (Vêm do Front-end via Payload)
        CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.peso')), '') AS DECIMAL(5,2)),
        CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.altura')), '') AS DECIMAL(3,2)),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.pressao_arterial')),
        CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.frequencia_cardiaca')), '') AS UNSIGNED),
        CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.frequencia_respiratoria')), '') AS UNSIGNED),
        CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.temperatura')), '') AS DECIMAL(4,2)),
        CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.saturacao')), '') AS UNSIGNED),
        CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.hgt')), '') AS UNSIGNED),
        
        -- Queixa e Protocolo
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.queixa_principal')),
        CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_protocolo_manchester')), '') AS UNSIGNED),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.prioridade_cor')),
        
        -- Auditoria (Injetado pelo Dispatcher ou vindo do Front)
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info')),
        NOW(6)
    );

    -- ==========================================
    -- 4. ATUALIZAÇÃO OPCIONAL DE FLUXO
    -- ==========================================
    -- Aqui você pode atualizar o estado da FFA para 'AGUARDANDO_MEDICO'
    UPDATE ffa SET contexto_fluxo = 'AGUARDANDO_MEDICO' WHERE id_ffa = p_id_referencia;

END ;;
```

