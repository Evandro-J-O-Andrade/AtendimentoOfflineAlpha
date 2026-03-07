-- ================================================================
-- TABELAS PARA CONTEXTO DE LOGIN - Dispositivos Autenticados
-- Executar este arquivo para adicionar suporte a dispositivos
-- ================================================================

USE `pronto_atendimento`;

-- ================================================================
-- 0. Primeiro, verificar e adicionar locais operacionais necessários
-- ================================================================
-- O banco atual só tem 1 local (Recepção). Precisamos criar os outros.

INSERT INTO local_operacional (id_unidade, nome, tipo, ativo) 
SELECT 1, 'Triagem', 'TRIAGEM', 1
WHERE NOT EXISTS (SELECT 1 FROM local_operacional WHERE nome = 'Triagem');

INSERT INTO local_operacional (id_unidade, nome, tipo, ativo) 
SELECT 1, 'Consultório', 'CONSULTORIO', 1
WHERE NOT EXISTS (SELECT 1 FROM local_operacional WHERE nome = 'Consultório');

INSERT INTO local_operacional (id_unidade, nome, tipo, ativo) 
SELECT 1, 'Farmácia', 'FARMACIA', 1
WHERE NOT EXISTS (SELECT 1 FROM local_operacional WHERE nome = 'Farmácia');

INSERT INTO local_operacional (id_unidade, nome, tipo, ativo) 
SELECT 1, 'Medicação', 'MEDICACAO', 1
WHERE NOT EXISTS (SELECT 1 FROM local_operacional WHERE nome = 'Medicação');

-- ================================================================
-- 1. Tabela: dispositivo (painel, totem, terminal)
-- ================================================================
DROP TABLE IF EXISTS `dispositivo`;

CREATE TABLE `dispositivo` (
  `id_dispositivo` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(120) NOT NULL,
  `tipo` enum('PAINEL','TOTEM','TERMINAL','TABLET','MOBILE','DESKTOP') NOT NULL,
  `mac_address` varchar(45) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `id_unidade` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `token_auth` varchar(128) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `ultima_conexao` datetime DEFAULT NULL,
  PRIMARY KEY (`id_dispositivo`),
  KEY `fk_dispositivo_unidade` (`id_unidade`),
  KEY `fk_dispositivo_local` (`id_local_operacional`),
  CONSTRAINT `fk_dispositivo_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`) ON DELETE SET NULL,
  CONSTRAINT `fk_dispositivo_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 2. Atualizar sessao_usuario para incluir dispositivo
-- ================================================================
-- Verificar se as colunas já existem antes de adicionar

-- Adicionar id_dispositivo se não existir
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'pronto_atendimento' 
    AND TABLE_NAME = 'sessao_usuario' 
    AND COLUMN_NAME = 'id_dispositivo'
);

SET @sql = IF(@column_exists = 0, 
    'ALTER TABLE `sessao_usuario` ADD COLUMN `id_dispositivo` bigint NULL AFTER `id_local_operacional`',
    'SELECT ''Coluna id_dispositivo já existe'' AS msg'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Adicionar tipo_dispositivo se não existir
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'pronto_atendimento' 
    AND TABLE_NAME = 'sessao_usuario' 
    AND COLUMN_NAME = 'tipo_dispositivo'
);

SET @sql = IF(@column_exists = 0, 
    'ALTER TABLE `sessao_usuario` ADD COLUMN `tipo_dispositivo` varchar(50) NULL AFTER `id_dispositivo`',
    'SELECT ''Coluna tipo_dispositivo já existe'' AS msg'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Adicionar chave estrangeira se não existir
SET @fk_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE TABLE_SCHEMA = 'pronto_atendimento' 
    AND TABLE_NAME = 'sessao_usuario' 
    AND CONSTRAINT_NAME = 'fk_sessao_dispositivo'
);

SET @sql = IF(@fk_exists = 0,
    'ALTER TABLE `sessao_usuario` ADD CONSTRAINT `fk_sessao_dispositivo` FOREIGN KEY (`id_dispositivo`) REFERENCES `dispositivo` (`id_dispositivo`) ON DELETE SET NULL',
    'SELECT ''FK fk_sessao_dispositivo já existe'' AS msg'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ================================================================
-- 3. Criar dispositivos de exemplo
-- ================================================================
INSERT INTO dispositivo (nome, tipo, id_unidade, id_local_operacional, ativo) VALUES
('Painel Recepção Principal', 'PAINEL', 1, 1, 1),
('Painel Triagem', 'PAINEL', 1, (SELECT id_local_operacional FROM local_operacional WHERE nome = 'Triagem' LIMIT 1), 1),
('Painel Consultório', 'PAINEL', 1, (SELECT id_local_operacional FROM local_operacional WHERE nome = 'Consultório' LIMIT 1), 1),
('Painel Farmácia', 'PAINEL', 1, (SELECT id_local_operacional FROM local_operacional WHERE nome = 'Farmácia' LIMIT 1), 1),
('Totem Autoatendimento', 'TOTEM', 1, 1, 1),
('Terminal Recepção 1', 'TERMINAL', 1, 1, 1),
('Terminal Recepção 2', 'TERMINAL', 1, 1, 1),
('Tablet Triagem 1', 'TABLET', 1, (SELECT id_local_operacional FROM local_operacional WHERE nome = 'Triagem' LIMIT 1), 1),
('Tablet Triagem 2', 'TABLET', 1, (SELECT id_local_operacional FROM local_operacional WHERE nome = 'Triagem' LIMIT 1), 1),
('Mobile Médico', 'MOBILE', 1, (SELECT id_local_operacional FROM local_operacional WHERE nome = 'Consultório' LIMIT 1), 1);

-- ================================================================
-- 4. Tabela: dispositivo_tipo (catálogo de tipos)
-- ================================================================
DROP TABLE IF EXISTS `dispositivo_tipo`;

CREATE TABLE `dispositivo_tipo` (
  `id_tipo` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `descricao` varchar(200) DEFAULT NULL,
  `permite_login_usuario` tinyint(1) DEFAULT '1',
  `requer_autenticacao` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO dispositivo_tipo (nome, descricao, permite_login_usuario, requer_autenticacao) VALUES
('PAINEL', 'Painel de affichagem para chamadas', 0, 1),
('TOTEM', 'Totem de autoatendimento', 1, 1),
('TERMINAL', 'Terminal fixo de atendimento', 1, 1),
('TABLET', 'Tablet móvel', 1, 1),
('MOBILE', 'Dispositivo mobile', 1, 1),
('DESKTOP', 'Computador desktop', 1, 1);

SELECT 'Tabelas de dispositivo criadas com sucesso!' AS resultado;
