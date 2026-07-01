-- MD-003 — FFA CORE WORKFLOW ENGINE (REAL DUMP)
-- Canonizado a partir do dump real existente

CREATE TABLE IF NOT EXISTS ffa (
  id_ffa bigint unsigned NOT NULL AUTO_INCREMENT,
  id_unidade bigint unsigned NOT NULL,
  id_paciente bigint unsigned NOT NULL,
  estado_clinico enum('AGUARDANDO_TRIAGEM','EM_TRIAGEM','AGUARDANDO_ATENDIMENTO','EM_ATENDIMENTO','OBSERVACAO','MEDICACAO','EXAMES','ALTA','EVASAO','TRANSFERENCIA','INTERNACAO','FINALIZADO') COLLATE utf8mb4_unicode_ci NOT NULL,
  contexto_fluxo json DEFAULT NULL,
  id_sessao_usuario_abertura bigint unsigned DEFAULT NULL,
  id_entidade bigint unsigned NOT NULL,
  criado_em datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id_ffa),
  CONSTRAINT fk_ffa_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade),
  CONSTRAINT fk_ffa_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ffa_estado derivado de estado_clinico
CREATE TABLE IF NOT EXISTS ffa_estado (
  id_ffa bigint unsigned NOT NULL,
  id_senha bigint unsigned NOT NULL,
  estado_atual varchar(60) NOT NULL,
  estado_destino varchar(60) DEFAULT NULL,
  atualizado_em datetime(6) DEFAULT NULL,
  atualizado_por bigint DEFAULT NULL,
  PRIMARY KEY (id_ffa),
  CONSTRAINT fk_ffa_estado_ffa FOREIGN KEY (id_ffa) REFERENCES ffa (id_ffa),
  CONSTRAINT fk_ffa_estado_senha FOREIGN KEY (id_senha) REFERENCES senha (id_senha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS atendimento_evento (
  id_evento bigint NOT NULL AUTO_INCREMENT,
  id_unidade bigint unsigned NOT NULL,
  id_ffa bigint DEFAULT NULL,
  id_atendimento bigint unsigned NOT NULL,
  dominio varchar(40) NOT NULL,
  tipo_evento varchar(60) NOT NULL,
  estado_origem varchar(40) DEFAULT NULL,
  estado_destino varchar(40) DEFAULT NULL,
  id_sessao_usuario bigint DEFAULT NULL,
  hash_evento char(64) DEFAULT NULL,
  criado_em datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_evento),
  CONSTRAINT fk_aevt_unid FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade),
  CONSTRAINT fk_atendimento_evento_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- tabela MISSING: ffa_etapa (derivada)
CREATE TABLE IF NOT EXISTS ffa_etapa (
  id_etapa bigint unsigned NOT NULL AUTO_INCREMENT,
  id_ffa bigint unsigned NOT NULL,
  numero_etapa int NOT NULL,
  nome_etapa varchar(50) NOT NULL,
  status_etapa enum('PENDENTE','EM_ANDAMENTO','CONCLUIDA','CANCELADA') NOT NULL,
  criado_em datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  concluido_em datetime(6) DEFAULT NULL,
  PRIMARY KEY (id_etapa),
  KEY idx_ffa_etapa (id_ffa),
  CONSTRAINT fk_etapa_ffa FOREIGN KEY (id_ffa) REFERENCES ffa (id_ffa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;