# sp_executor_assistencial_atendimento_finalizar

Objetivo: executor assistencial atendimento finalizar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: atendimento, sessao_usuario
- INSERT: atendimento_diagnostico, atendimento_evolucao
- UPDATE: atendimento
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
- IF
- IFNULL
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- NOW
- SIGNAL

## Views Utilizadas
- v_cid
- v_device
- v_ip

## Eventos Gerados
- (nenhum)

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
- **Linha 10** (Comentario): ==========================================
- **Linha 11** (Comentario): CONTEXTO
- **Linha 12** (Comentario): ==========================================
- **Linha 13**: Declaracao de variavel local v_id_usuario.
- **Linha 14**: Declaracao de variavel local v_id_unidade.
- **Linha 15**: Declaracao de variavel local v_id_saas.
- **Linha 16**: Declaracao de variavel local v_id_atendimento.
- **Linha 18**: Declaracao de variavel local v_ip.
- **Linha 19**: Declaracao de variavel local v_device.
- **Linha 21**: Declaracao de variavel local v_diagnostico.
- **Linha 22**: Declaracao de variavel local v_conduta.
- **Linha 23**: Declaracao de variavel local v_cid.
- **Linha 25** (Comentario): ==========================================
- **Linha 26** (Comentario): EXTRAÇÃO CONTEXTO
- **Linha 27** (Comentario): ==========================================
- **Linha 28**: execucao de query SELECT para consulta de dados.
- **Linha 29**: INTO v_id_usuario, v_id_unidade, v_id_saas
- **Linha 30**: FROM sessao_usuario
- **Linha 31**: WHERE id_sessao_usuario = p_id_sessao
- **Linha 32**: LIMIT 1;
- **Linha 34** (Comentario): atendimento vinculado à FFA
- **Linha 35**: execucao de query SELECT para consulta de dados.
- **Linha 36**: INTO v_id_atendimento
- **Linha 37**: FROM atendimento
- **Linha 38**: WHERE id_ffa = p_id_referencia
- **Linha 39**: LIMIT 1;
- **Linha 41** (Comentario): ==========================================
- **Linha 42** (Comentario): PAYLOAD
- **Linha 43** (Comentario): ==========================================
- **Linha 44**: atribuicao de valor Ã  variavel v_ip.
- **Linha 45**: atribuicao de valor Ã  variavel v_device.
- **Linha 47**: atribuicao de valor Ã  variavel v_diagnostico.
- **Linha 48**: atribuicao de valor Ã  variavel v_conduta.
- **Linha 49**: atribuicao de valor Ã  variavel v_cid.
- **Linha 51** (Comentario): ==========================================
- **Linha 52** (Comentario): VALIDAÇÃO
- **Linha 53** (Comentario): ==========================================
- **Linha 54**: Estrutura condicional de controle de fluxo.
- **Linha 55**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'USUARIO_INVALIDO';
- **Linha 56**: Estrutura condicional de controle de fluxo.
- **Linha 58**: Estrutura condicional de controle de fluxo.
- **Linha 59**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FFA_OBRIGATORIA';
- **Linha 60**: Estrutura condicional de controle de fluxo.
- **Linha 62** (Comentario): ==========================================
- **Linha 63** (Comentario): EVOLUÇÃO (PRONTUÁRIO)
- **Linha 64** (Comentario): ==========================================
- **Linha 65**: Insere um novo registro na tabela atendimento_evolucao.
- **Linha 66**: id_saas_entidade,
- **Linha 67**: id_unidade,
- **Linha 68**: id_ffa,
- **Linha 69**: id_atendimento,
- **Linha 70**: id_usuario,
- **Linha 71**: id_sessao_usuario,
- **Linha 72**: tipo_profissional,
- **Linha 73**: texto_evolucao,
- **Linha 74**: ip_origem,
- **Linha 75**: device_info,
- **Linha 76**: criado_em
- **Linha 77**: ) VALUES (
- **Linha 78**: v_id_saas,
- **Linha 79**: v_id_unidade,
- **Linha 80**: p_id_referencia,
- **Linha 81**: v_id_atendimento,
- **Linha 82**: v_id_usuario,
- **Linha 83**: p_id_sessao,
- **Linha 84**: 'MEDICO',
- **Linha 85**: CONCAT(
- **Linha 86**: 'DIAGNOSTICO: ', IFNULL(v_diagnostico, 'N/A'), '\n',
- **Linha 87**: 'CONDUTA: ', IFNULL(v_conduta, 'N/A')
- **Linha 88**: ),
- **Linha 89**: v_ip,
- **Linha 90**: v_device,
- **Linha 91**: NOW(6)
- **Linha 92**: );
- **Linha 94** (Comentario): ==========================================
- **Linha 95** (Comentario): DIAGNÓSTICO (CID)
- **Linha 96** (Comentario): ==========================================
- **Linha 97**: Estrutura condicional de controle de fluxo.
- **Linha 98**: Insere um novo registro na tabela atendimento_diagnostico.
- **Linha 99**: id_saas_entidade,
- **Linha 100**: id_unidade,
- **Linha 101**: id_ffa,
- **Linha 102**: id_usuario,
- **Linha 103**: id_sessao_usuario,
- **Linha 104**: codigo_cid,
- **Linha 105**: principal,
- **Linha 106**: ip_origem,
- **Linha 107**: device_info,
- **Linha 108**: criado_em
- **Linha 109**: ) VALUES (
- **Linha 110**: v_id_saas,
- **Linha 111**: v_id_unidade,
- **Linha 112**: p_id_referencia,
- **Linha 113**: v_id_usuario,
- **Linha 114**: p_id_sessao,
- **Linha 115**: v_cid,
- **Linha 116**: 1,
- **Linha 117**: v_ip,
- **Linha 118**: v_device,
- **Linha 119**: NOW(6)
- **Linha 120**: );
- **Linha 121**: Estrutura condicional de controle de fluxo.
- **Linha 123** (Comentario): ==========================================
- **Linha 124** (Comentario): FINALIZA ATENDIMENTO
- **Linha 125** (Comentario): ==========================================
- **Linha 126**: UPDATE atendimento
- **Linha 127**: SET
- **Linha 128**: status_atendimento = 'FINALIZADO',
- **Linha 129**: data_fechamento = NOW(6)
- **Linha 130**: WHERE id_ffa = p_id_referencia;
- **Linha 132** (Comentario): ==========================================
- **Linha 133** (Comentario): RETORNO PADRÃO
- **Linha 134** (Comentario): ==========================================
- **Linha 135**: execucao de query SELECT para consulta de dados.
- **Linha 136**: 'status', 'SUCCESS',
- **Linha 137**: 'acao', 'ATENDIMENTO_FINALIZADO',
- **Linha 138**: 'ffa', p_id_referencia
- **Linha 139**: ) AS result;
- **Linha 141**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_assistencial_atendimento_finalizar`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT, -- id_ffa
    IN p_payload JSON
)
    SQL SECURITY INVOKER
main: BEGIN

    -- ==========================================
    -- CONTEXTO
    -- ==========================================
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_saas BIGINT;
    DECLARE v_id_atendimento BIGINT;

    DECLARE v_ip VARCHAR(45);
    DECLARE v_device VARCHAR(255);

    DECLARE v_diagnostico TEXT;
    DECLARE v_conduta TEXT;
    DECLARE v_cid VARCHAR(10);

    -- ==========================================
    -- EXTRAÇÃO CONTEXTO
    -- ==========================================
    SELECT id_usuario, id_unidade, id_saas_entidade
    INTO v_id_usuario, v_id_unidade, v_id_saas
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao
    LIMIT 1;

    -- atendimento vinculado à FFA
    SELECT id_atendimento
    INTO v_id_atendimento
    FROM atendimento
    WHERE id_ffa = p_id_referencia
    LIMIT 1;

    -- ==========================================
    -- PAYLOAD
    -- ==========================================
    SET v_ip = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem'));
    SET v_device = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info'));

    SET v_diagnostico = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.diagnostico'));
    SET v_conduta     = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.conduta'));
    SET v_cid         = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.cid'));

    -- ==========================================
    -- VALIDAÇÃO
    -- ==========================================
    IF v_id_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'USUARIO_INVALIDO';
    END IF;

    IF p_id_referencia IS NULL OR p_id_referencia = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FFA_OBRIGATORIA';
    END IF;

    -- ==========================================
    -- EVOLUÇÃO (PRONTUÁRIO)
    -- ==========================================
    INSERT INTO atendimento_evolucao (
        id_saas_entidade,
        id_unidade,
        id_ffa,
        id_atendimento,
        id_usuario,
        id_sessao_usuario,
        tipo_profissional,
        texto_evolucao,
        ip_origem,
        device_info,
        criado_em
    ) VALUES (
        v_id_saas,
        v_id_unidade,
        p_id_referencia,
        v_id_atendimento,
        v_id_usuario,
        p_id_sessao,
        'MEDICO',
        CONCAT(
            'DIAGNOSTICO: ', IFNULL(v_diagnostico, 'N/A'), '\n',
            'CONDUTA: ', IFNULL(v_conduta, 'N/A')
        ),
        v_ip,
        v_device,
        NOW(6)
    );

    -- ==========================================
    -- DIAGNÓSTICO (CID)
    -- ==========================================
    IF v_cid IS NOT NULL THEN
        INSERT INTO atendimento_diagnostico (
            id_saas_entidade,
            id_unidade,
            id_ffa,
            id_usuario,
            id_sessao_usuario,
            codigo_cid,
            principal,
            ip_origem,
            device_info,
            criado_em
        ) VALUES (
            v_id_saas,
            v_id_unidade,
            p_id_referencia,
            v_id_usuario,
            p_id_sessao,
            v_cid,
            1,
            v_ip,
            v_device,
            NOW(6)
        );
    END IF;

    -- ==========================================
    -- FINALIZA ATENDIMENTO
    -- ==========================================
    UPDATE atendimento
    SET 
        status_atendimento = 'FINALIZADO',
        data_fechamento = NOW(6)
    WHERE id_ffa = p_id_referencia;

    -- ==========================================
    -- RETORNO PADRÃO
    -- ==========================================
    SELECT JSON_OBJECT(
        'status', 'SUCCESS',
        'acao', 'ATENDIMENTO_FINALIZADO',
        'ffa', p_id_referencia
    ) AS result;

END ;;
```

