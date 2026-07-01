-- MD-002 — SENHA & FILA (REAL DUMP)
-- Canonizado a partir do dump real existente

CREATE TABLE IF NOT EXISTS unidade (
  id_unidade bigint unsigned NOT NULL AUTO_INCREMENT,
  id_entidade bigint unsigned NOT NULL,
  nome varchar(200) DEFAULT NULL,
  tipo varchar(100) DEFAULT NULL,
  ativo tinyint DEFAULT '1',
  PRIMARY KEY (id_unidade),
  CONSTRAINT fk_unidade_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS senha (
  id_senha bigint unsigned NOT NULL AUTO_INCREMENT,
  id_unidade bigint unsigned NOT NULL,
  codigo_visual varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  id_paciente bigint unsigned DEFAULT NULL,
  origem_entrada enum('RECEPCAO','AGENDAMENTO','UBS','SAMU','TRANSFERENCIA','REGULACAO','FARMACIA','OUTRO') COLLATE utf8mb4_unicode_ci NOT NULL,
  id_prioridade bigint unsigned NOT NULL DEFAULT '1',
  id_fluxo_status bigint unsigned NOT NULL DEFAULT '1',
  uuid_sync char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  hash_estado char(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  id_ffa bigint unsigned DEFAULT NULL,
  id_entidade bigint unsigned NOT NULL,
  criado_em datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id_senha),
  CONSTRAINT fk_senha_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade),
  CONSTRAINT fk_senha_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade),
  CONSTRAINT fk_senha_ffa FOREIGN KEY (id_ffa) REFERENCES ffa (id_ffa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- MISSING TABLE - senha_status (precisa ser criada)
CREATE TABLE IF NOT EXISTS senha_status (
  id_senha_status bigint unsigned NOT NULL AUTO_INCREMENT,
  codigo varchar(20) NOT NULL,
  nome varchar(50) NOT NULL,
  descricao varchar(200) DEFAULT NULL,
  ordem int NOT NULL DEFAULT '0',
  ativo tinyint(1) DEFAULT '1',
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_senha_status),
  UNIQUE KEY uk_status_codigo (codigo, id_entidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS fila_operacional (
  id_fila bigint NOT NULL AUTO_INCREMENT,
  id_ffa bigint NOT NULL,
  tipo enum('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO') NOT NULL,
  substatus enum('AGUARDANDO','EM_EXECUCAO','REAVALIAR','FINALIZADO','CANCELADO','NAO_COMPARECEU') NOT NULL,
  prioridade enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') DEFAULT 'AZUL',
  data_entrada datetime NOT NULL,
  id_unidade bigint unsigned NOT NULL,
  id_local bigint DEFAULT NULL,
  PRIMARY KEY (id_fila),
  KEY idx_ffa_tipo_substatus (id_ffa,tipo,substatus),
  CONSTRAINT fk_fila_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;