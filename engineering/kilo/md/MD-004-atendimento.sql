-- MD-004 — ATENDIMENTO CLÍNICO (REAL DUMP)
-- Canonizado a partir do dump real existente

CREATE TABLE IF NOT EXISTS atendimento (
  id_atendimento bigint unsigned NOT NULL AUTO_INCREMENT,
  id_senha bigint unsigned NOT NULL,
  id_ffa bigint unsigned NOT NULL,
  id_unidade bigint unsigned NOT NULL,
  id_paciente bigint unsigned NOT NULL,
  status enum('ABERTO','EM_ANDAMENTO','FINALIZADO','CANCELADO') NOT NULL,
  tipo enum('URGENCIA','ELETIVO','RETORNO') DEFAULT 'URGENCIA',
  id_usuario_responsavel bigint DEFAULT NULL,
  criado_em datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_atendimento),
  CONSTRAINT fk_atendimento_senha FOREIGN KEY (id_senha) REFERENCES senha (id_senha),
  CONSTRAINT fk_atendimento_ffa FOREIGN KEY (id_ffa) REFERENCES ffa (id_ffa),
  CONSTRAINT fk_atendimento_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS triagem (
  id_triagem bigint NOT NULL AUTO_INCREMENT,
  id_atendimento bigint unsigned NOT NULL,
  id_risco int NOT NULL,
  queixa text,
  sinais_vitais json DEFAULT NULL,
  id_enfermeiro bigint NOT NULL,
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_triagem),
  CONSTRAINT fk_triagem_atendimento FOREIGN KEY (id_atendimento) REFERENCES atendimento (id_atendimento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS classificacao_risco (
  id_risco int NOT NULL AUTO_INCREMENT,
  cor enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') NOT NULL,
  descricao varchar(100) NOT NULL,
  tempo_max_minutos int DEFAULT NULL,
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_risco)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prescricao_medicacao (
  id_prescricao bigint NOT NULL AUTO_INCREMENT,
  id_ffa bigint NOT NULL,
  id_medico bigint NOT NULL,
  descricao text NOT NULL,
  controlada tinyint(1) DEFAULT '0',
  ativa tinyint(1) DEFAULT '1',
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_prescricao),
  CONSTRAINT fk_prescricao_ffa FOREIGN KEY (id_ffa) REFERENCES ffa (id_ffa),
  CONSTRAINT fk_prescricao_medico FOREIGN KEY (id_medico) REFERENCES usuario (id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;