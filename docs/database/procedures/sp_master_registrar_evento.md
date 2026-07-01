# sp_master_registrar_evento

Objetivo: master registrar evento conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_dominio | VARCHAR(50) | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_id_referencia | BIGINT | IN | |
| p_payload | JSON | IN | |
| p_metadata | JSON | IN | |
| p_uuid_transacao | CHAR(36) | IN | |
| o_id_evento | BIGINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: ffa
- INSERT: atendimento_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CAST
- CONCAT
- IF
- JSON_EXTRACT
- JSON_UNQUOTE
- LAST_INSERT_ID
- NOW
- SHA2
- UPPER

## Views Utilizadas
- v_estado_destino
- v_estado_origem
- v_hash_evento

## Eventos Gerados
- evento

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
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: Declaracao de parÃ¢metro.
- **Linha 10**: fechamento da lista de Parametros.
- **Linha 11**: inicio do bloco de execucao.
- **Linha 13**: Declaracao de variavel local v_hash_evento.
- **Linha 14**: Declaracao de variavel local v_id_saas.
- **Linha 15**: Declaracao de variavel local v_id_unidade.
- **Linha 16**: Declaracao de variavel local v_id_usuario.
- **Linha 17**: Declaracao de variavel local v_id_paciente.
- **Linha 18**: Declaracao de variavel local v_id_atendimento.
- **Linha 19**: Declaracao de variavel local v_estado_origem.
- **Linha 20**: Declaracao de variavel local v_estado_destino.
- **Linha 22** (Comentario): =========================
- **Linha 23** (Comentario): 1. CONTEXTO (JSON CORRETO)
- **Linha 24** (Comentario): =========================
- **Linha 25**: atribuicao de valor Ã  variavel v_id_saas.
- **Linha 26**: atribuicao de valor Ã  variavel v_id_unidade.
- **Linha 27**: atribuicao de valor Ã  variavel v_id_usuario.
- **Linha 29** (Comentario): =========================
- **Linha 30** (Comentario): 2. ESTADO ORIGEM (FFA)
- **Linha 31** (Comentario): =========================
- **Linha 32**: Estrutura condicional de controle de fluxo.
- **Linha 33**: execucao de query SELECT para consulta de dados.
- **Linha 34**: INTO v_id_paciente, v_id_atendimento, v_estado_origem
- **Linha 35**: FROM ffa
- **Linha 36**: WHERE id_ffa = p_id_referencia
- **Linha 37**: LIMIT 1;
- **Linha 38**: Estrutura condicional de controle de fluxo.
- **Linha 40** (Comentario): =========================
- **Linha 41** (Comentario): 3. ESTADO DESTINO
- **Linha 42** (Comentario): =========================
- **Linha 43**: atribuicao de valor Ã  variavel v_estado_destino.
- **Linha 45** (Comentario): =========================
- **Linha 46** (Comentario): 4. HASH (LEDGER)
- **Linha 47** (Comentario): =========================
- **Linha 48**: atribuicao de valor Ã  variavel v_hash_evento.
- **Linha 49**: p_uuid_transacao,
- **Linha 50**: p_dominio,
- **Linha 51**: p_acao,
- **Linha 52**: CAST(p_payload AS CHAR),
- **Linha 53**: v_id_usuario
- **Linha 54**: ), 256);
- **Linha 56** (Comentario): =========================
- **Linha 57** (Comentario): 5. INSERT CANÔNICO
- **Linha 58** (Comentario): =========================
- **Linha 59**: Insere um novo registro na tabela atendimento_evento.
- **Linha 60**: id_saas_entidade,
- **Linha 61**: id_unidade,
- **Linha 62**: id_ffa,
- **Linha 63**: id_atendimento,
- **Linha 64**: id_paciente,
- **Linha 65**: dominio,
- **Linha 66**: tipo_evento,
- **Linha 67**: estado_origem,
- **Linha 68**: estado_destino,
- **Linha 69**: contexto_fluxo,
- **Linha 70**: payload,
- **Linha 71**: id_sessao_usuario,
- **Linha 72**: id_usuario,
- **Linha 73**: hash_evento,
- **Linha 74**: criado_em
- **Linha 75**: ) VALUES (
- **Linha 76**: v_id_saas,
- **Linha 77**: v_id_unidade,
- **Linha 78**: p_id_referencia,
- **Linha 79**: v_id_atendimento,
- **Linha 80**: v_id_paciente,
- **Linha 81**: UPPER(p_dominio),
- **Linha 82**: UPPER(p_acao),
- **Linha 83**: v_estado_origem,
- **Linha 84**: v_estado_destino,
- **Linha 85**: v_estado_destino,
- **Linha 86**: p_payload,
- **Linha 87**: p_id_sessao,
- **Linha 88**: v_id_usuario,
- **Linha 89**: v_hash_evento,
- **Linha 90**: NOW(6)
- **Linha 91**: );
- **Linha 93**: atribuicao de valor Ã  variavel o_id_evento.
- **Linha 95**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_registrar_evento`(
    IN p_id_sessao BIGINT,
    IN p_dominio VARCHAR(50),
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON,
    IN p_metadata JSON,
    IN p_uuid_transacao CHAR(36),
    OUT o_id_evento BIGINT
)
BEGIN

    DECLARE v_hash_evento CHAR(64);
    DECLARE v_id_saas BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_atendimento BIGINT;
    DECLARE v_estado_origem VARCHAR(50);
    DECLARE v_estado_destino VARCHAR(50);

    -- =========================
    -- 1. CONTEXTO (JSON CORRETO)
    -- =========================
    SET v_id_saas     = JSON_UNQUOTE(JSON_EXTRACT(p_metadata, '$.id_saas'));
    SET v_id_unidade  = JSON_UNQUOTE(JSON_EXTRACT(p_metadata, '$.id_unidade'));
    SET v_id_usuario  = JSON_UNQUOTE(JSON_EXTRACT(p_metadata, '$.id_usuario'));

    -- =========================
    -- 2. ESTADO ORIGEM (FFA)
    -- =========================
    IF p_id_referencia > 0 THEN
        SELECT id_paciente, id_atendimento, contexto_fluxo
        INTO v_id_paciente, v_id_atendimento, v_estado_origem
        FROM ffa
        WHERE id_ffa = p_id_referencia
        LIMIT 1;
    END IF;

    -- =========================
    -- 3. ESTADO DESTINO
    -- =========================
    SET v_estado_destino = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.estado_destino'));

    -- =========================
    -- 4. HASH (LEDGER)
    -- =========================
    SET v_hash_evento = SHA2(CONCAT(
        p_uuid_transacao,
        p_dominio,
        p_acao,
        CAST(p_payload AS CHAR),
        v_id_usuario
    ), 256);

    -- =========================
    -- 5. INSERT CANÔNICO
    -- =========================
    INSERT INTO atendimento_evento (
        id_saas_entidade,
        id_unidade,
        id_ffa,
        id_atendimento,
        id_paciente,
        dominio,
        tipo_evento,
        estado_origem,
        estado_destino,
        contexto_fluxo,
        payload,
        id_sessao_usuario,
        id_usuario,
        hash_evento,
        criado_em
    ) VALUES (
        v_id_saas,
        v_id_unidade,
        p_id_referencia,
        v_id_atendimento,
        v_id_paciente,
        UPPER(p_dominio),
        UPPER(p_acao),
        v_estado_origem,
        v_estado_destino,
        v_estado_destino,
        p_payload,
        p_id_sessao,
        v_id_usuario,
        v_hash_evento,
        NOW(6)
    );

    SET o_id_evento = LAST_INSERT_ID();

END ;;
```

