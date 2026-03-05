DROP DATABASE IF EXISTS his_kernel_sandbox;
-- (Opcional — use apenas se estiver rebuildando do zero)

DELIMITER //

/* ============================================================
   REGISTRY MULTI-TENANT
   ============================================================ */

DROP TABLE IF EXISTS tenant_registry;

CREATE TABLE tenant_registry (
    id_tenant BIGINT AUTO_INCREMENT,
    uuid_tenant CHAR(36) NOT NULL DEFAULT (UUID()),

    nome_fantasia VARCHAR(200) NOT NULL,
    razao_social VARCHAR(300) NOT NULL,
    cnpj VARCHAR(20),
    cnes VARCHAR(20),

    instancia_primary BOOLEAN DEFAULT TRUE,
    regiao VARCHAR(50),
    pais VARCHAR(50) DEFAULT 'BR',

    status ENUM('ATIVO','SUSPENSO','MIGRANDO','INATIVO') DEFAULT 'ATIVO',

    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6),

    PRIMARY KEY(id_tenant),
    UNIQUE KEY uk_uuid(uuid_tenant),
    UNIQUE KEY uk_cnes(cnes),
    INDEX idx_status(status),
    INDEX idx_regiao(regiao)
) ENGINE=InnoDB;

/* ============================================================
   KERNEL LOCK ENGINE
   ============================================================ */

DROP TABLE IF EXISTS runtime_kernel_locks;

CREATE TABLE runtime_kernel_locks(
    id BIGINT AUTO_INCREMENT,
    uuid_runtime CHAR(36) NOT NULL,
    locked_by INT NOT NULL,
    acquired_at DATETIME(6) NOT NULL,
    expires_at DATETIME(6) NOT NULL,

    PRIMARY KEY(id),
    INDEX idx_runtime(uuid_runtime, expires_at)
) ENGINE=InnoDB;

/* ============================================================
   LOCK WRITER
   ============================================================ */

DROP PROCEDURE IF EXISTS sp_kernel_writer_lock //

CREATE PROCEDURE sp_kernel_writer_lock(
    IN p_uuid_runtime CHAR(36),
    OUT p_lock_id BIGINT
)
BEGIN
    DECLARE v_lock_exists INT;

    SELECT COUNT(*)
    INTO v_lock_exists
    FROM runtime_kernel_locks
    WHERE uuid_runtime = p_uuid_runtime
      AND expires_at > NOW(6);

    IF v_lock_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='RUNTIME_LOCK_ALREADY_HELD';
    END IF;

    INSERT INTO runtime_kernel_locks
    (uuid_runtime,locked_by,acquired_at,expires_at)
    VALUES
    (p_uuid_runtime,CONNECTION_ID(),
     NOW(6),
     DATE_ADD(NOW(6),INTERVAL 60 SECOND));

    SET p_lock_id = LAST_INSERT_ID();
END //

DROP PROCEDURE IF EXISTS sp_kernel_writer_unlock //

CREATE PROCEDURE sp_kernel_writer_unlock(
    IN p_lock_id BIGINT
)
BEGIN
    DELETE FROM runtime_kernel_locks
    WHERE id = p_lock_id;
END //

/* ============================================================
   FINGERPRINT ENGINE
   ============================================================ */

DROP FUNCTION IF EXISTS fn_decision_fingerprint //

CREATE FUNCTION fn_decision_fingerprint(
    p_acao VARCHAR(100),
    p_id_tenant BIGINT,
    p_id_usuario BIGINT,
    p_payload JSON
) RETURNS CHAR(64)
DETERMINISTIC
BEGIN
    RETURN SHA2(
        CONCAT(
            IFNULL(p_acao,''),
            '|',
            IFNULL(p_id_tenant,0),
            '|',
            IFNULL(p_id_usuario,0),
            '|',
            JSON_UNQUOTE(JSON_SORT(IFNULL(p_payload,'{}')))
        ),
    256);
END //

/* ============================================================
   EXECUTION QUEUE
   ============================================================ */

DROP TABLE IF EXISTS runtime_execution_queue;

CREATE TABLE runtime_execution_queue(
    id_queue BIGINT AUTO_INCREMENT,
    uuid_transacao CHAR(36) NOT NULL DEFAULT (UUID()),
    uuid_execution CHAR(36) NOT NULL DEFAULT (UUID()),

    id_tenant BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_perfil BIGINT NOT NULL,
    id_sessao BIGINT NOT NULL,

    worker_type ENUM(
        'ATENDIMENTO','SENHA','TRIAGEM',
        'PRESCRICAO','FARMACIA','ENFERMAGEM',
        'GENERIC'
    ) NOT NULL,

    acao VARCHAR(100) NOT NULL,
    payload JSON NOT NULL,

    status ENUM(
        'PENDENTE','PROCESSANDO',
        'CONCLUIDO','FALHOU','CANCELADO'
    ) DEFAULT 'PENDENTE',

    tentativas INT DEFAULT 0,
    max_tentativas INT DEFAULT 3,
    erro_mensagem VARCHAR(1000),

    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    started_at DATETIME(6),
    finished_at DATETIME(6),

    result_payload JSON,
    decision_fingerprint CHAR(64),

    PRIMARY KEY(id_queue),
    UNIQUE KEY uk_uuid_exec(uuid_execution),
    INDEX idx_tenant_status(id_tenant,status),
    INDEX idx_worker(worker_type,status),
    INDEX idx_created(created_at),
    INDEX idx_fingerprint(decision_fingerprint)
) ENGINE=InnoDB;

/* ============================================================
   WORKERS DOMAIN
   ============================================================ */

/* -------- ATENDIMENTO WORKER -------- */

DROP PROCEDURE IF EXISTS sp_worker_atendimento //

CREATE PROCEDURE sp_worker_atendimento(
    IN p_id_queue BIGINT,
    IN p_uuid_execution CHAR(36),
    IN p_id_tenant BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN
)
BEGIN
    DECLARE v_id BIGINT;
    DECLARE v_acao VARCHAR(50);

    SET v_id = JSON_UNQUOTE(JSON_EXTRACT(p_payload,'$.id_atendimento'));
    SET v_acao = JSON_UNQUOTE(JSON_EXTRACT(p_payload,'$.acao'));

    IF v_acao = 'INICIAR' THEN

        UPDATE atendimento
        SET status='EM_ANDAMENTO',
            updated_at=NOW(6)
        WHERE id_atendimento=v_id;

        SET p_resultado=JSON_OBJECT('status','INICIADO');
        SET p_sucesso=TRUE;

    ELSEIF v_acao='TRANSICIONAR' THEN

        UPDATE atendimento
        SET status=JSON_UNQUOTE(JSON_EXTRACT(p_payload,'$.novo_status')),
            updated_at=NOW(6)
        WHERE id_atendimento=v_id;

        SET p_resultado=JSON_OBJECT('status','TRANSICIONADO');
        SET p_sucesso=TRUE;

    ELSE
        SET p_resultado=JSON_OBJECT('erro','ACAO_DESCONHECIDA');
        SET p_sucesso=FALSE;
    END IF;

    UPDATE runtime_execution_queue
    SET status=IF(p_sucesso,'CONCLUIDO','FALHOU'),
        finished_at=NOW(6),
        result_payload=p_resultado
    WHERE id_queue=p_id_queue;

END //

/* ============================================================
   DISPATCHER KERNEL
   ============================================================ */

DROP PROCEDURE IF EXISTS sp_dispatcher_kernel //

CREATE PROCEDURE sp_dispatcher_kernel(
    IN p_id_tenant BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_id_sessao BIGINT,
    IN p_worker_type VARCHAR(50),
    IN p_acao VARCHAR(100),
    IN p_payload JSON,
    OUT p_uuid_execution CHAR(36),
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
BEGIN

    DECLARE v_uuid CHAR(36);
    DECLARE v_lock BIGINT;
    DECLARE v_fingerprint CHAR(64);

    SET v_uuid = UUID();

    SET v_fingerprint =
        fn_decision_fingerprint(
            p_acao,
            p_id_tenant,
            p_id_usuario,
            p_payload
        );

    CALL sp_kernel_writer_lock(v_uuid,v_lock);

    INSERT INTO runtime_execution_queue
    (
        uuid_transacao,
        uuid_execution,
        id_tenant,
        id_usuario,
        id_perfil,
        id_sessao,
        worker_type,
        acao,
        payload,
        decision_fingerprint,
        status
    )
    VALUES
    (
        v_uuid,
        v_uuid,
        p_id_tenant,
        p_id_usuario,
        p_id_perfil,
        p_id_sessao,
        p_worker_type,
        p_acao,
        p_payload,
        v_fingerprint,
        'PENDENTE'
    );

    CALL sp_kernel_writer_unlock(v_lock);

    SET p_uuid_execution = v_uuid;
    SET p_sucesso = TRUE;
    SET p_mensagem = 'EXEC_ENFILEIRADA';

END //

DELIMITER ;