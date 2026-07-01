-- MD-006 — EVENT SYSTEM UNIFICATION (REAL DUMP)
-- kernel_ledger será o único event store canônico

-- KERNEL_LEDGER - Event Store Canônico (MD-104)
CREATE TABLE IF NOT EXISTS kernel_ledger (
  id_evento bigint NOT NULL AUTO_INCREMENT,
  uuid_evento char(36) NOT NULL,
  tenant_id bigint unsigned NOT NULL,
  unidade_id bigint unsigned DEFAULT NULL,
  local_id bigint DEFAULT NULL,
  usuario_id bigint DEFAULT NULL,
  sessao_id char(36) DEFAULT NULL,
  app varchar(50) NOT NULL,
  acao varchar(100) NOT NULL,
  entidade_tipo varchar(50) NOT NULL,
  entidade_id bigint DEFAULT NULL,
  payload json NOT NULL,
  payload_resumo varchar(255) DEFAULT NULL,
  resultado enum('SUCESSO','ERRO','PARCIAL') DEFAULT 'SUCESSO',
  codigo_erro varchar(20) DEFAULT NULL,
  ip varchar(45) DEFAULT NULL,
  user_agent varchar(255) DEFAULT NULL,
  device_fingerprint varchar(255) DEFAULT NULL,
  timestamp datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  imutavel tinyint(1) DEFAULT '1',
  PRIMARY KEY (id_evento),
  UNIQUE KEY uk_uuid_evento (uuid_evento),
  KEY idx_tenant_acao (tenant_id, acao),
  KEY idx_usuario_acao (usuario_id, acao),
  KEY idx_timestamp (timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- EVENT ADAPTER - Bridge legacy events to kernel_ledger
CREATE TABLE IF NOT EXISTS event_adapter_log (
  id_bridge bigint NOT NULL AUTO_INCREMENT,
  evento_fonte varchar(100) NOT NULL,
  tabela_fonte varchar(100) NOT NULL,
  id_registro_origem bigint NOT NULL,
  evento_canonico_id bigint DEFAULT NULL,
  status enum('PENDENTE','CONVERTIDO','ERRO') DEFAULT 'PENDENTE',
  erro_detalhe text,
  processado_em datetime(6) DEFAULT NULL,
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_bridge),
  KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- VIEW: Event Unification Layer
CREATE OR REPLACE VIEW v_event_unificado AS
SELECT 
  id_evento as id,
  CONCAT('auditoria_', id_evento) as uuid_evento,
  id_entidade as tenant_id,
  id_unidade,
  id_usuario,
  'auditoria_evento' as app,
  tipo_evento as acao,
  dominio as entidade_tipo,
  id_referencia as entidade_id,
  payload,
  NULL as payload_resumo,
  'SUCESSO' as resultado,
  criado_em as timestamp
FROM auditoria_evento
UNION ALL
SELECT
  id_evento as id,
  CONCAT('atend_', id_evento) as uuid_evento,
  id_entidade as tenant_id,
  id_unidade,
  id_usuario,
  'ATENDIMENTO' as app,
  tipo_evento as acao,
  dominio as entidade_tipo,
  id_ffa as entidade_id,
  payload,
  NULL as payload_resumo,
  'SUCESSO' as resultado,
  criado_em as timestamp
FROM atendimento_evento;

-- EVENT TYPE CATALOG
CREATE TABLE IF NOT EXISTS evento_tipo_catalogo (
  id_tipo int NOT NULL AUTO_INCREMENT,
  app varchar(50) NOT NULL,
  acao varchar(100) NOT NULL,
  entidade_tipo varchar(50) NOT NULL,
  descricao varchar(255) DEFAULT NULL,
  evento_canonico tinyint(1) DEFAULT '0',
  PRIMARY KEY (id_tipo),
  UNIQUE KEY uk_app_acao (app, acao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;