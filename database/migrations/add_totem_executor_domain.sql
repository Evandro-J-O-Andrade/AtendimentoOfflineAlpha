-- Migration: add_totem_executor_domain
-- Data: 2026-07-29
-- Descricao: Cria executores Totem e registry no Dispatcher para as capabilities TOTEM.GERAR_SENHA, TOTEM.OPCOES_GET, TOTEM.PLANTAO_MEDICO_GET
-- Observacao: sp_totem_gerar_senha permanece em HOLD para auditoria de schema. Este arquivo apenas cria a camada Executor/Registry.
-- Atencao: sp_totem_gerar_senha referencia colunas (tipo_senha, numero_senha, status, gerado_por) que devem existir na tabela senha. Validar alinhamento de schema antes do teste ponta a ponta.

-- =========================
-- EXECUTOR: GERAR_SENHA
-- =========================
DROP PROCEDURE IF EXISTS sp_executor_totem_gerar_senha;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_totem_gerar_senha`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_painel BIGINT;
    DECLARE v_id_opcao BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_tipo_senha VARCHAR(20);
    DECLARE v_id_senha BIGINT;
    DECLARE v_resultado JSON;
    DECLARE v_sucesso BOOLEAN;
    DECLARE v_mensagem VARCHAR(500);

    -- Resolve contexto da sessão
    SELECT id_usuario, id_perfil, id_unidade, id_local
    INTO v_id_usuario, v_id_perfil, v_id_unidade, v_id_local
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao
    LIMIT 1;

    -- Extrai payload
    SET v_id_opcao = CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_opcao')), 'null') AS UNSIGNED);
    SET v_id_paciente = CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_paciente')), 'null') AS UNSIGNED);

    -- Resolve painel do totem pela unidade/local
    SELECT id_painel INTO v_id_painel
    FROM painel
    WHERE tipo = 'TOTEM'
      AND id_unidade = v_id_unidade
      AND (id_local_operacional = v_id_local OR id_local_operacional IS NULL)
    LIMIT 1;

    -- Resolve tipo_senha a partir da opção
    SELECT tipo_atendimento INTO v_tipo_senha
    FROM totem_senha_opcao
    WHERE id_opcao = v_id_opcao
      AND id_painel = v_id_painel
      AND ativo = 1
    LIMIT 1;

    -- Fallback
    IF v_tipo_senha IS NULL OR v_tipo_senha = '' THEN
        SET v_tipo_senha = 'NORMAL';
    END IF;

    -- Chama SP canônica
    CALL sp_totem_gerar_senha(
        p_id_sessao,
        v_id_usuario,
        v_id_perfil,
        v_id_paciente,
        v_tipo_senha,
        v_id_painel,
        v_id_senha,
        v_resultado,
        v_sucesso,
        v_mensagem
    );

    -- Se a SP canônica retornar falha, sinaliza erro para o Dispatcher
    IF NOT v_sucesso THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_mensagem;
    END IF;

    -- Retorna dados para propagação
    SELECT JSON_OBJECT(
        'status', 'SUCCESS',
        'id_senha', v_id_senha,
        'numero_senha', JSON_UNQUOTE(JSON_EXTRACT(v_resultado, '$.numero_senha')),
        'tipo_senha', v_tipo_senha,
        'uuid_transacao', JSON_UNQUOTE(JSON_EXTRACT(v_resultado, '$.uuid_transacao')),
        'mensagem', v_mensagem
    ) AS result;
END ;;
DELIMITER ;

-- =========================
-- EXECUTOR: OPCOES_GET
-- =========================
DROP PROCEDURE IF EXISTS sp_executor_totem_opcoes_get;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_totem_opcoes_get`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
BEGIN
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_painel BIGINT;

    SET v_id_unidade = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')) AS UNSIGNED);
    SET v_id_local = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_local_operacional')) AS UNSIGNED);

    -- Resolve painel do totem
    SELECT id_painel INTO v_id_painel
    FROM painel
    WHERE tipo = 'TOTEM'
      AND id_unidade = v_id_unidade
      AND (id_local_operacional = v_id_local OR id_local_operacional IS NULL)
    LIMIT 1;

    SELECT JSON_OBJECT(
        'status', 'SUCCESS',
        'opcoes', JSON_ARRAYAGG(
            JSON_OBJECT(
                'id_opcao', id_opcao,
                'codigo', codigo,
                'label', label,
                'lane', lane,
                'tipo_atendimento', tipo_atendimento,
                'prefixo', prefixo,
                'ordem', ordem,
                'ativo', ativo
            )
        )
    ) AS result
    FROM totem_senha_opcao
    WHERE id_painel = v_id_painel
      AND ativo = 1
    ORDER BY ordem ASC;
END ;;
DELIMITER ;

-- =========================
-- EXECUTOR: PLANTAO_MEDICO_GET
-- =========================
DROP PROCEDURE IF EXISTS sp_executor_totem_plantao_medico_get;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_totem_plantao_medico_get`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
BEGIN
    DECLARE v_id_unidade BIGINT;
    DECLARE v_data DATE;

    SET v_id_unidade = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')) AS UNSIGNED);
    SET v_data = DATE(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data')));

    IF v_data IS NULL THEN
        SET v_data = CURDATE();
    END IF;

    SELECT JSON_OBJECT(
        'status', 'SUCCESS',
        'plantao', JSON_ARRAYAGG(
            JSON_OBJECT(
                'especialidade', 'CLINICO',
                'medico_nome', COALESCE(p.nome, 'MEDICO DE PLANTAO'),
                'crm', COALESCE(epa.registro_profissional, 'N/A')
            )
        )
    ) AS result
    FROM escala_plantao_atual epa
    JOIN funcionario f ON f.id_funcionario = epa.id_usuario
    JOIN pessoa p ON p.id_pessoa = f.id_pessoa
    WHERE epa.id_unidade = v_id_unidade
      AND epa.status_plantao = 'ATIVO'
      AND DATE(epa.data_inicio) = v_data
    ORDER BY p.nome;
END ;;
DELIMITER ;

-- =========================
-- REGISTRY: CAPABILITIES TOTEM
-- =========================
INSERT IGNORE INTO permissao (codigo, nome, descricao, dominio, nome_procedure, acao_frontend, metadata, ativo, criado_em)
VALUES
('TOTEM.GERAR_SENHA', 'Gerar Senha Totem', 'Gera senha de atendimento via totem', 'TOTEM', 'sp_executor_totem_gerar_senha', 'gerar_senha', NULL, 1, NOW(6)),
('TOTEM.OPCOES_GET', 'Opções Totem', 'Lista opções de atendimento do totem', 'TOTEM', 'sp_executor_totem_opcoes_get', 'opcoes_get', NULL, 1, NOW(6)),
('TOTEM.PLANTAO_MEDICO_GET', 'Plantão Médico Totem', 'Lista plantão médico do dia para o totem', 'TOTEM', 'sp_executor_totem_plantao_medico_get', 'plantao_medico_get', NULL, 1, NOW(6));
