DROP TABLE IF EXISTS atendimento_evento_ledger;

CREATE TABLE atendimento_evento_ledger (
    id_evento BIGINT NOT NULL AUTO_INCREMENT,

    uuid_transacao CHAR(36) NOT NULL,
    uuid_transacao_pai CHAR(36) DEFAULT NULL,

    sequencia_evento INT NOT NULL,

    id_usuario BIGINT NOT NULL,
    id_sessao BIGINT NOT NULL,
    id_perfil BIGINT NOT NULL,

    nome_usuario VARCHAR(100),

    acao VARCHAR(100) NOT NULL,
    modulo VARCHAR(50) NOT NULL,
    sub_modulo VARCHAR(50),

    estado_origem VARCHAR(50),
    estado_destino VARCHAR(50),

    estado_anterior JSON,
    estado_novo JSON,

    payload_original JSON,
    payload_processado JSON,

    -- Materialized clinical pointer (RECOMENDADO)
    id_atendimento BIGINT GENERATED ALWAYS AS (
        JSON_UNQUOTE(JSON_EXTRACT(payload_original,'$.id_atendimento'))
    ) STORED,

    status_evento ENUM(
        'SUCESSO',
        'ERRO',
        'AVISO',
        'CANCELADO',
        'ROLLBACK'
    ) NOT NULL DEFAULT 'SUCESSO',

    codigo_erro VARCHAR(50),
    mensagem VARCHAR(1000),

    ip_origem VARCHAR(45),
    user_agent VARCHAR(500),
    hostname VARCHAR(100),

    processing_time_ms INT,

    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    PRIMARY KEY (id_evento),

    UNIQUE KEY uk_chain_evento (
        uuid_transacao,
        sequencia_evento
    ),

    INDEX idx_chain_pai (uuid_transacao_pai),
    INDEX idx_usuario (id_usuario),
    INDEX idx_sessao (id_sessao),
    INDEX idx_perfil (id_perfil),
    INDEX idx_modulo (modulo),
    INDEX idx_acao (acao),
    INDEX idx_created (created_at),
    INDEX idx_atendimento (id_atendimento),
    INDEX idx_status (status_evento)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci
COMMENT='Kernel Clinical Decision Ledger Append Only';