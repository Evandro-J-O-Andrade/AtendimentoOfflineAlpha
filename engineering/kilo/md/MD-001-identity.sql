-- MD-001 — IDENTITY & MULTITENANCY (REAL DUMP)
-- Canonizado a partir do dump real existente

CREATE TABLE IF NOT EXISTS saas_entidade (
  id_entidade bigint unsigned NOT NULL,
  nome_fantasia varchar(200) NOT NULL,
  razao_social varchar(200) DEFAULT NULL,
  cnpj varchar(20) DEFAULT NULL,
  tipo_entidade enum('PREFEITURA','HOSPITAL','UPA','UBS','CLINICA','FARMACIA','OPERADORA') DEFAULT NULL,
  ativo tinyint DEFAULT '1',
  criado_em datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id_entidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS usuario (
  id_usuario bigint NOT NULL AUTO_INCREMENT,
  id_pessoa bigint DEFAULT NULL,
  id_entidade bigint unsigned NOT NULL,
  login varchar(80) NOT NULL,
  senha_hash varchar(255) NOT NULL,
  ativo tinyint DEFAULT '1',
  criado_em datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id_usuario),
  UNIQUE KEY uk_usuario_login (login),
  KEY fk_usuario_entidade (id_entidade),
  CONSTRAINT fk_usuario_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS sessao_usuario (
  id_sessao_usuario bigint NOT NULL AUTO_INCREMENT,
  uuid_sessao char(36) NOT NULL,
  id_usuario bigint NOT NULL,
  id_perfil bigint DEFAULT NULL,
  id_sistema bigint NOT NULL,
  id_unidade bigint unsigned NOT NULL,
  token_jwt varchar(512) NOT NULL,
  expira_em datetime(6) NOT NULL,
  ativo tinyint(1) DEFAULT '1',
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_sessao_usuario),
  UNIQUE KEY uk_sessao_uuid (uuid_sessao),
  KEY idx_sessao_usuario (id_usuario),
  CONSTRAINT fk_sessao_usuario_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS perfil (
  id_perfil bigint NOT NULL AUTO_INCREMENT,
  nome varchar(100) NOT NULL,
  ativo tinyint(1) DEFAULT '1',
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_perfil)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;