-- MD-005 — FARMACIA & ESTOQUE (REAL DUMP)
-- Canonizado a partir do dump real existente

CREATE TABLE IF NOT EXISTS farm_dispensacao (
  id_dispensacao bigint NOT NULL AUTO_INCREMENT,
  id_ffa bigint NOT NULL,
  id_gpat bigint NOT NULL,
  status enum('ABERTA','EM_EXECUCAO','CONCLUIDO','CANCELADO') NOT NULL,
  id_usuario_farmacia bigint DEFAULT NULL,
  criado_em datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_dispensacao),
  CONSTRAINT fk_farm_dispensacao_ffa FOREIGN KEY (id_ffa) REFERENCES ffa (id_ffa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS estoque_produto (
  id_produto bigint NOT NULL AUTO_INCREMENT,
  nome varchar(200) NOT NULL,
  codigo varchar(50) DEFAULT NULL,
  tipo enum('MEDICAMENTO','MATERIAL','EQUIPAMENTO','OUTRO') NOT NULL,
  controlado tinyint(1) DEFAULT '0',
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_produto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS estoque_lote (
  id_lote bigint NOT NULL AUTO_INCREMENT,
  id_produto bigint NOT NULL,
  numero_lote varchar(100) NOT NULL,
  data_validade date NOT NULL,
  quantidade_atual decimal(15,4) NOT NULL,
  quantidade_minima decimal(15,4) DEFAULT '0',
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_lote),
  CONSTRAINT fk_lote_produto FOREIGN KEY (id_produto) REFERENCES estoque_produto (id_produto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS estoque_local (
  id_estoque_local bigint NOT NULL AUTO_INCREMENT,
  id_unidade bigint unsigned NOT NULL,
  nome varchar(100) NOT NULL,
  tipo enum('CENTRAL','FARMACIA','UTI','LEITO','AMBULATORIO') NOT NULL,
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_estoque_local),
  CONSTRAINT fk_estoque_local_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS estoque_saldo (
  id_saldo bigint NOT NULL AUTO_INCREMENT,
  id_unidade bigint unsigned NOT NULL,
  id_local bigint NOT NULL,
  contexto_tipo enum('CENTRAL','FARMACIA','ASSISTENCIAL','LEITO','UTI','FATURAMENTO') NOT NULL,
  id_item bigint NOT NULL,
  id_lote bigint NOT NULL,
  qtd_fisica decimal(15,4) NOT NULL DEFAULT '0.0000',
  qtd_reservada decimal(15,4) NOT NULL DEFAULT '0.0000',
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_saldo),
  CONSTRAINT fk_estoque_saldo_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS estoque_reserva (
  id_reserva bigint NOT NULL AUTO_INCREMENT,
  id_estoque_local bigint NOT NULL,
  id_produto bigint NOT NULL,
  id_lote bigint NOT NULL,
  quantidade decimal(15,4) NOT NULL,
  origem_tipo enum('FARM_DISP','PDV','AJUSTE','TRANSFERENCIA','OUTRO') NOT NULL,
  status enum('ATIVA','FINALIZADA','CANCELADA') NOT NULL,
  hash_atual char(64) NOT NULL,
  id_sessao_usuario bigint NOT NULL,
  id_entidade bigint unsigned NOT NULL,
  PRIMARY KEY (id_reserva),
  CONSTRAINT fk_reserva_local FOREIGN KEY (id_estoque_local) REFERENCES estoque_local (id_estoque_local)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;