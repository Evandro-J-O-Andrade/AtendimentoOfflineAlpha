# sp_master_dispatcher

Objetivo: master dispatcher conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_uuid_transacao | CHAR(36) | IN | |
| p_dominio | VARCHAR(50) | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_id_referencia | BIGINT | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: atendimento_evento, atendimento_vinculo, permissao, sessao_usuario
- INSERT: erro_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_master_registrar_evento

## Functions Utilizadas
- CAST
- CONCAT
- IF
- IFNULL
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- NOW
- SHA2
- SIGNAL
- UPPER
- UUID

## Views Utilizadas
- v_device
- v_estado_atual
- v_estado_destino
- v_hash
- v_id_local
- v_id_painel
- v_id_perfil
- v_id_saas
- v_id_unidade
- v_id_usuario
- v_ip
- v_nome_sp
- v_uuid

## Eventos Gerados
- evento

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).
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
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: fechamento da lista de Parametros.
- **Linha 9**: SQL SECURITY INVOKER
- **Linha 10**: main: BEGIN
- **Linha 12** (Comentario): ==========================================
- **Linha 13** (Comentario): 1. DECLARAÇÕES
- **Linha 14** (Comentario): ==========================================
- **Linha 15**: DECLARE v_id_usuario, v_id_unidade, v_id_saas, v_id_local, v_id_painel, v_id_perfil BIGINT;
- **Linha 16**: Declaracao de variavel local v_ativo.
- **Linha 17**: Declaracao de variavel local v_nome_sp.
- **Linha 18**: Declaracao de variavel local v_uuid.
- **Linha 19**: Declaracao de variavel local v_hash.
- **Linha 20**: Declaracao de variavel local v_id_evento.
- **Linha 21**: DECLARE v_estado_atual, v_estado_destino VARCHAR(50);
- **Linha 22**: Declaracao de variavel local v_msg.
- **Linha 24**: Declaracao de variavel local v_id_atendimento_vinculo.
- **Linha 25**: Declaracao de variavel local v_ip.
- **Linha 26**: Declaracao de variavel local v_device.
- **Linha 28** (Comentario): ==========================================
- **Linha 29** (Comentario): 2. HANDLER GLOBAL
- **Linha 30** (Comentario): ==========================================
- **Linha 31**: Declaracao de variavel local EXIT.
- **Linha 32**: inicio do bloco de execucao.
- **Linha 33**: GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT;
- **Linha 34**: Insere um novo registro na tabela erro_evento.
- **Linha 35**: id_sessao_usuario, dominio, tipo_evento, mensagem_erro, payload, metadata, uuid_transacao
- **Linha 36**: ) VALUES (
- **Linha 37**: p_id_sessao, p_dominio, p_acao, v_msg, p_payload,
- **Linha 38**: JSON_OBJECT('executor', v_nome_sp, 'hash', v_hash), v_uuid
- **Linha 39**: );
- **Linha 40**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
- **Linha 41**: Fim do bloco da procedure.
- **Linha 43** (Comentario): ==========================================
- **Linha 44** (Comentario): 3. INIT & CONTEXTO
- **Linha 45** (Comentario): ==========================================
- **Linha 46**: atribuicao de valor Ã  variavel v_uuid.
- **Linha 47**: atribuicao de valor Ã  variavel p_payload.
- **Linha 48**: atribuicao de valor Ã  variavel v_hash.
- **Linha 50**: execucao de query SELECT para consulta de dados.
- **Linha 51**: INTO v_id_usuario, v_id_unidade, v_id_saas, v_id_local, v_id_painel, v_id_perfil, v_ativo
- **Linha 52**: FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao LIMIT 1;
- **Linha 54**: Estrutura condicional de controle de fluxo.
- **Linha 55**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SESSAO_INVALIDA';
- **Linha 56**: Estrutura condicional de controle de fluxo.
- **Linha 58**: atribuicao de valor Ã  variavel v_ip.
- **Linha 59**: atribuicao de valor Ã  variavel v_device.
- **Linha 61** (Comentario): ==========================================
- **Linha 62** (Comentario): 4. IDEMPOTÊNCIA
- **Linha 63** (Comentario): ==========================================
- **Linha 64**: Estrutura condicional de controle de fluxo.
- **Linha 65**: execucao de query SELECT para consulta de dados.
- **Linha 66**: ) THEN
- **Linha 67**: execucao de query SELECT para consulta de dados.
- **Linha 68**: Estrutura de repeticao/controle de loop.
- **Linha 69**: Estrutura condicional de controle de fluxo.
- **Linha 71** (Comentario): ==========================================
- **Linha 72** (Comentario): 5. RESOLVER EXECUTOR
- **Linha 73** (Comentario): ==========================================
- **Linha 74**: execucao de query SELECT para consulta de dados.
- **Linha 75**: WHERE codigo = CONCAT(UPPER(p_dominio), '.', UPPER(p_acao)) AND ativo = 1 LIMIT 1;
- **Linha 77**: Estrutura condicional de controle de fluxo.
- **Linha 78**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'EXECUTOR_INVALIDO_OU_NAO_MAPEADO';
- **Linha 79**: Estrutura condicional de controle de fluxo.
- **Linha 81** (Comentario): ==========================================
- **Linha 82** (Comentario): 6. RESOLVER VÍNCULO DE ATENDIMENTO
- **Linha 83** (Comentario): ==========================================
- **Linha 84**: Estrutura condicional de controle de fluxo.
- **Linha 85**: execucao de query SELECT para consulta de dados.
- **Linha 86**: FROM atendimento_vinculo
- **Linha 87**: WHERE id_ffa = p_id_referencia AND ativo = 1 LIMIT 1;
- **Linha 89**: atribuicao de valor Ã  variavel p_payload.
- **Linha 90**: '$.id_atendimento', v_id_atendimento_vinculo,
- **Linha 91**: '$.id_saas_entidade', v_id_saas,
- **Linha 92**: '$.id_unidade', v_id_unidade
- **Linha 93**: );
- **Linha 94**: Estrutura condicional de controle de fluxo.
- **Linha 96** (Comentario): ==========================================
- **Linha 97** (Comentario): 7. REGISTRO NO LEDGER
- **Linha 98** (Comentario): ==========================================
- **Linha 99**: Invoca a procedure sp_master_registrar_evento.
- **Linha 100**: p_id_sessao, p_dominio, p_acao, p_id_referencia, p_payload,
- **Linha 101**: JSON_OBJECT('id_saas', v_id_saas, 'id_unidade', v_id_unidade, 'ip', v_ip, 'device', v_device),
- **Linha 102**: v_uuid, v_id_evento
- **Linha 103**: );
- **Linha 105** (Comentario): ==========================================
- **Linha 106** (Comentario): 8. EXECUÇÃO DINÂMICA (CORREÇÃO AQUI)
- **Linha 107** (Comentario): ==========================================
- **Linha 108** (Comentario): Passamos os valores para variáveis de usuário (@) para o PREPARE não falhar
- **Linha 109**: SET @p_sessao = p_id_sessao;
- **Linha 110**: SET @p_acao = p_acao;
- **Linha 111**: SET @p_ref = p_id_referencia;
- **Linha 112**: SET @p_pay = p_payload;
- **Linha 114**: SET @sql_call = CONCAT('CALL ', v_nome_sp, '(?, ?, ?, ?)');
- **Linha 116**: PREPARE stmt FROM @sql_call;
- **Linha 117**: EXECUTE stmt USING @p_sessao, @p_acao, @p_ref, @p_pay;
- **Linha 118**: DEALLOCATE PREPARE stmt;
- **Linha 120** (Comentario): ==========================================
- **Linha 121** (Comentario): 9. RETORNO PADRÃO
- **Linha 122** (Comentario): ==========================================
- **Linha 123**: execucao de query SELECT para consulta de dados.
- **Linha 124**: 'status', 'SUCCESS',
- **Linha 125**: 'uuid', v_uuid,
- **Linha 126**: 'id_evento', v_id_evento,
- **Linha 127**: 'executor', v_nome_sp,
- **Linha 128**: 'timestamp', NOW()
- **Linha 129**: ) AS result;
- **Linha 131**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_dispatcher`(
    IN p_id_sessao BIGINT,
    IN p_uuid_transacao CHAR(36),
    IN p_dominio VARCHAR(50),
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
main: BEGIN

    -- ==========================================
    -- 1. DECLARAÇÕES
    -- ==========================================
    DECLARE v_id_usuario, v_id_unidade, v_id_saas, v_id_local, v_id_painel, v_id_perfil BIGINT;
    DECLARE v_ativo TINYINT;
    DECLARE v_nome_sp VARCHAR(120);
    DECLARE v_uuid CHAR(36);
    DECLARE v_hash CHAR(64);
    DECLARE v_id_evento BIGINT DEFAULT 0;
    DECLARE v_estado_atual, v_estado_destino VARCHAR(50);
    DECLARE v_msg TEXT;
    
    DECLARE v_id_atendimento_vinculo BIGINT;
    DECLARE v_ip VARCHAR(45);
    DECLARE v_device VARCHAR(255);

    -- ==========================================
    -- 2. HANDLER GLOBAL
    -- ==========================================
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT;
        INSERT INTO erro_evento (
            id_sessao_usuario, dominio, tipo_evento, mensagem_erro, payload, metadata, uuid_transacao
        ) VALUES (
            p_id_sessao, p_dominio, p_acao, v_msg, p_payload, 
            JSON_OBJECT('executor', v_nome_sp, 'hash', v_hash), v_uuid
        );
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END;

    -- ==========================================
    -- 3. INIT & CONTEXTO
    -- ==========================================
    SET v_uuid = IFNULL(p_uuid_transacao, UUID());
    SET p_payload = IFNULL(p_payload, JSON_OBJECT());
    SET v_hash = SHA2(CONCAT(v_uuid, CAST(p_payload AS CHAR)), 256);

    SELECT id_usuario, id_unidade, id_saas_entidade, id_local, id_painel, id_perfil, ativo
    INTO v_id_usuario, v_id_unidade, v_id_saas, v_id_local, v_id_painel, v_id_perfil, v_ativo
    FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao LIMIT 1;

    IF v_id_usuario IS NULL OR v_ativo = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SESSAO_INVALIDA';
    END IF;

    SET v_ip = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem'));
    SET v_device = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info'));

    -- ==========================================
    -- 4. IDEMPOTÊNCIA
    -- ==========================================
    IF p_uuid_transacao IS NOT NULL AND EXISTS (
        SELECT 1 FROM atendimento_evento WHERE uuid_transacao = p_uuid_transacao LIMIT 1
    ) THEN
        SELECT JSON_OBJECT('status','SUCCESS','idempotente',1,'uuid', v_uuid) AS result;
        LEAVE main;
    END IF;

    -- ==========================================
    -- 5. RESOLVER EXECUTOR
    -- ==========================================
    SELECT nome_procedure INTO v_nome_sp FROM permissao
    WHERE codigo = CONCAT(UPPER(p_dominio), '.', UPPER(p_acao)) AND ativo = 1 LIMIT 1;

    IF v_nome_sp IS NULL OR v_nome_sp NOT LIKE 'sp_executor_%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'EXECUTOR_INVALIDO_OU_NAO_MAPEADO';
    END IF;

    -- ==========================================
    -- 6. RESOLVER VÍNCULO DE ATENDIMENTO
    -- ==========================================
    IF p_id_referencia > 0 THEN
        SELECT id_atendimento INTO v_id_atendimento_vinculo
        FROM atendimento_vinculo 
        WHERE id_ffa = p_id_referencia AND ativo = 1 LIMIT 1;

        SET p_payload = JSON_SET(p_payload, 
            '$.id_atendimento', v_id_atendimento_vinculo,
            '$.id_saas_entidade', v_id_saas,
            '$.id_unidade', v_id_unidade
        );
    END IF;

    -- ==========================================
    -- 7. REGISTRO NO LEDGER
    -- ==========================================
    CALL sp_master_registrar_evento(
        p_id_sessao, p_dominio, p_acao, p_id_referencia, p_payload,
        JSON_OBJECT('id_saas', v_id_saas, 'id_unidade', v_id_unidade, 'ip', v_ip, 'device', v_device),
        v_uuid, v_id_evento
    );

    -- ==========================================
    -- 8. EXECUÇÃO DINÂMICA (CORREÇÃO AQUI)
    -- ==========================================
    -- Passamos os valores para variáveis de usuário (@) para o PREPARE não falhar
    SET @p_sessao = p_id_sessao;
    SET @p_acao = p_acao;
    SET @p_ref = p_id_referencia;
    SET @p_pay = p_payload;

    SET @sql_call = CONCAT('CALL ', v_nome_sp, '(?, ?, ?, ?)');
    
    PREPARE stmt FROM @sql_call;
    EXECUTE stmt USING @p_sessao, @p_acao, @p_ref, @p_pay;
    DEALLOCATE PREPARE stmt;

    -- ==========================================
    -- 9. RETORNO PADRÃO
    -- ==========================================
    SELECT JSON_OBJECT(
        'status', 'SUCCESS',
        'uuid', v_uuid,
        'id_evento', v_id_evento,
        'executor', v_nome_sp,
        'timestamp', NOW()
    ) AS result;

END ;;
```

