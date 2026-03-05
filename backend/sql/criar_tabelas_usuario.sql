-- ================================================================
-- Tabelas necessárias para Login Contextual
-- Executar este arquivo para adicionar tabelas faltantes
-- ================================================================

USE `pronto_atendimento`;

-- ================================================================
-- Tabela: usuario_unidade
-- ================================================================
DROP TABLE IF EXISTS `usuario_unidade`;

CREATE TABLE `usuario_unidade` (
  `id_usuario_unidade` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `id_unidade` bigint NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario_unidade`),
  UNIQUE KEY `uk_usuario_unidade` (`id_usuario`, `id_unidade`),
  KEY `fk_uu_usuario` (`id_usuario`),
  KEY `fk_uu_unidade` (`id_unidade`),
  CONSTRAINT `fk_uu_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE,
  CONSTRAINT `fk_uu_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- Tabela: usuario_local_operacional
-- ================================================================
DROP TABLE IF EXISTS `usuario_local_operacional`;

CREATE TABLE `usuario_local_operacional` (
  `id_usuario_local` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `id_local_operacional` bigint NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario_local`),
  UNIQUE KEY `uk_usuario_local` (`id_usuario`, `id_local_operacional`),
  KEY `fk_ulo_usuario` (`id_usuario`),
  KEY `fk_ulo_local` (`id_local_operacional`),
  CONSTRAINT `fk_ulo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE,
  CONSTRAINT `fk_ulo_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- Popular tabelas com dados existentes
-- ================================================================

-- Vincular usuarios as unidades (baseado em usuario_sistema)
INSERT IGNORE INTO usuario_unidade (id_usuario, id_unidade)
SELECT DISTINCT us.id_usuario, 1 AS id_unidade
FROM usuario_sistema us
WHERE us.ativo = 1;

-- Vincular usuarios aos locais operacionais (criar padrão = 1)
INSERT IGNORE INTO usuario_local_operacional (id_usuario, id_local_operacional)
SELECT DISTINCT us.id_usuario, 1 AS id_local_operacional
FROM usuario_sistema us
WHERE us.ativo = 1;

-- Se não houver dados, criar alguns padrões
INSERT IGNORE INTO usuario_unidade (id_usuario, id_unidade)
SELECT id_usuario, 1 FROM usuario WHERE ativo = 1;

INSERT IGNORE INTO usuario_local_operacional (id_usuario, id_local_operacional)
SELECT id_usuario, 1 FROM usuario WHERE ativo = 1;

SELECT 'Tabelas usuario_unidade e usuario_local_operacional criadas com sucesso!' AS resultado;
