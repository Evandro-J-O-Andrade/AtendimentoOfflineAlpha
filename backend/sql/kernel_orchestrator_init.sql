DROP TABLE IF EXISTS usuario_contexto;

DROP TABLE IF EXISTS usuario_contexto;

CREATE TABLE usuario_contexto (
    id_contexto BIGINT NOT NULL AUTO_INCREMENT,
    id_entidade BIGINT DEFAULT 1,
    id_usuario BIGINT NOT NULL,
    id_unidade BIGINT DEFAULT 0,
    id_sistema BIGINT DEFAULT 0,
    id_local_operacional BIGINT DEFAULT 0,
    id_perfil BIGINT DEFAULT 0,

    ativo BOOLEAN DEFAULT TRUE,

    criado_em DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    atualizado_em DATETIME(6) NULL ON UPDATE CURRENT_TIMESTAMP(6),

    -- Hash de unicidade runtime
    contexto_hash CHAR(64) GENERATED ALWAYS AS (
        SHA2(
            CONCAT(
                id_usuario,'|',
                id_unidade,'|',
                id_sistema,'|',
                id_local_operacional
            ),256
        )
    ) STORED,

    PRIMARY KEY (id_contexto),

    UNIQUE KEY uk_usuario_contexto_hash (contexto_hash),

    INDEX idx_ctx_usuario (id_usuario),
    INDEX idx_ctx_unidade (id_unidade),
    INDEX idx_ctx_sistema (id_sistema),
    INDEX idx_ctx_perfil (id_perfil)

) ENGINE=InnoDB;

----------------------------------------------------

DROP TABLE IF EXISTS perfil_permissao;

CREATE TABLE perfil_permissao (
    id_perfil_permissao BIGINT AUTO_INCREMENT,

    id_perfil BIGINT NOT NULL,
    id_permissao BIGINT NOT NULL,

    ativo BOOLEAN DEFAULT TRUE,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_perfil_permissao),

    UNIQUE KEY uk_perfil_permissao (
        id_perfil,
        id_permissao
    ),

    CONSTRAINT fk_pp_perfil
        FOREIGN KEY (id_perfil)
        REFERENCES perfil(id_perfil)
        ON DELETE CASCADE,

    CONSTRAINT fk_pp_permissao
        FOREIGN KEY (id_permissao)
        REFERENCES permissao(id_permissao)
        ON DELETE CASCADE

) ENGINE=InnoDB;