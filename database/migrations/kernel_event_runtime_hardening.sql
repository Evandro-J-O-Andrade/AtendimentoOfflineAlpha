-- Migration: kernel_event_runtime_hardening
-- Data: 2026-07-29
-- Descricao: Corrige Event Runtime para eventos pré-atendimento, integridade de sessão/tenant e collation do Dispatcher
-- Escopo: GATE-KERNEL-XXX

-- =========================
-- 1. EVENT RUNTIME
-- =========================

ALTER TABLE atendimento_evento
  MODIFY COLUMN id_atendimento bigint unsigned DEFAULT NULL;

ALTER TABLE atendimento_evento
  DROP FOREIGN KEY fk_atendimento_evento_atendimento;

ALTER TABLE atendimento_evento
  ADD CONSTRAINT fk_atendimento_evento_atendimento
    FOREIGN KEY (id_atendimento)
    REFERENCES atendimento (id_atendimento)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE atendimento_evento_ledger
  DROP FOREIGN KEY fk_atendimento_evento_ledger_atendimento;

ALTER TABLE atendimento_evento_ledger
  MODIFY COLUMN id_atendimento bigint unsigned DEFAULT NULL;

ALTER TABLE atendimento_evento_ledger
  ADD CONSTRAINT fk_atendimento_evento_ledger_atendimento
    FOREIGN KEY (id_atendimento)
    REFERENCES atendimento (id_atendimento)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

DROP PROCEDURE IF EXISTS sp_master_registrar_evento;
DELIMITER ;;
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

    SET v_id_saas     = JSON_UNQUOTE(JSON_EXTRACT(p_metadata, '$.id_saas'));
    SET v_id_unidade  = JSON_UNQUOTE(JSON_EXTRACT(p_metadata, '$.id_unidade'));
    SET v_id_usuario  = JSON_UNQUOTE(JSON_EXTRACT(p_metadata, '$.id_usuario'));

    IF p_id_referencia > 0 THEN
        SELECT f.id_paciente, a.id_atendimento, f.contexto_fluxo
        INTO v_id_paciente, v_id_atendimento, v_estado_origem
        FROM ffa f
        LEFT JOIN atendimento a ON a.id_ffa = f.id_ffa
        WHERE f.id_ffa = p_id_referencia
        LIMIT 1;
    END IF;

    SET v_estado_destino = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.estado_destino'));

    SET v_hash_evento = SHA2(CONCAT(
        p_uuid_transacao,
        p_dominio,
        p_acao,
        CAST(p_payload AS CHAR),
        v_id_usuario
    ), 256);

    INSERT INTO atendimento_evento (
        uuid_transacao,
        id_entidade,
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
        p_uuid_transacao,
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
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ledger_evento_log;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ledger_evento_log`(
    IN p_uuid_transacao CHAR(36),
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_acao VARCHAR(100),
    IN p_estado_origem VARCHAR(50),
    IN p_estado_destino VARCHAR(50),
    IN p_payload JSON,
    IN p_status VARCHAR(20),
    IN p_mensagem VARCHAR(500)
)
BEGIN
    INSERT INTO atendimento_evento_ledger (
        uuid_transacao,
        sequencia_evento,
        id_usuario,
        id_sessao,
        id_perfil,
        modulo,
        acao,
        estado_origem,
        estado_destino,
        payload_original,
        status_evento,
        mensagem,
        id_atendimento,
        id_entidade,
        created_at
    ) VALUES (
        p_uuid_transacao,
        1,
        p_id_usuario,
        0,
        p_id_perfil,
        'TOTEM',
        p_acao,
        p_estado_origem,
        p_estado_destino,
        p_payload,
        p_status,
        p_mensagem,
        NULL,
        1,
        NOW(6)
    );
END ;;
DELIMITER ;

-- =========================
-- 2. SESSAO / TENANT
-- =========================

UPDATE sessao_usuario
SET id_entidade = (
    SELECT sa.id_entidade
    FROM usuario u
    JOIN saas_entidade sa ON sa.id_entidade = u.id_entidade
    WHERE u.id_usuario = sessao_usuario.id_usuario
    LIMIT 1
)
WHERE id_entidade = 0 OR id_entidade IS NULL;

-- =========================
-- 3. DISPATCHER COLLATION
-- =========================

ALTER TABLE permissao
  MODIFY COLUMN codigo varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL;

ALTER TABLE permissao
  MODIFY COLUMN nome_procedure varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL;

ALTER TABLE totem_senha_opcao
  MODIFY COLUMN codigo varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  MODIFY COLUMN label varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  MODIFY COLUMN lane varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  MODIFY COLUMN tipo_atendimento varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  MODIFY COLUMN prefixo varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL;
