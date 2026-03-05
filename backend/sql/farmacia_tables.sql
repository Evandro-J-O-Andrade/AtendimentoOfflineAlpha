-- ============================================================
-- Tabela de log de dispensação de farmácia
-- ============================================================

CREATE TABLE IF NOT EXISTS farmacia_dispensacao_log (
    id BIGINT NOT NULL AUTO_INCREMENT,
    id_prescricao_item BIGINT NOT NULL,
    id_sessao_usuario BIGINT NOT NULL,
    id_lote BIGINT DEFAULT NULL,
    quantidade DECIMAL(14,3) NOT NULL,
    criado_em DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    
    PRIMARY KEY (id),
    KEY idx_prescricao_item (id_prescricao_item),
    KEY idx_sessao_usuario (id_sessao_usuario),
    KEY idx_criado_em (criado_em),
    
    CONSTRAINT fk_fdl_prescricao_item FOREIGN KEY (id_prescricao_item) 
        REFERENCES prescricao_item (id_item) ON DELETE CASCADE,
    CONSTRAINT fk_fdl_sessao FOREIGN KEY (id_sessao_usuario) 
        REFERENCES sessao_usuario (id_sessao_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_fdl_lote FOREIGN KEY (id_lote) 
        REFERENCES lote (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
COMMENT='Log de dispensação de medicamentos pela farmácia';

-- ============================================================
-- Adicionar campos na tabela prescricao_item para farmácia
-- ============================================================

-- Verificar se a coluna id_lote já existe
SELECT COUNT(*) INTO @col_exists 
FROM information_schema.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME = 'prescricao_item' 
  AND COLUMN_NAME = 'id_lote';

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE prescricao_item ADD COLUMN id_lote BIGINT NULL AFTER observacao', 
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verificar se a coluna dispensado_em já existe
SELECT COUNT(*) INTO @col_exists 
FROM information_schema.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME = 'prescricao_item' 
  AND COLUMN_NAME = 'dispensado_em';

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE prescricao_item ADD COLUMN dispensado_em DATETIME(6) NULL AFTER id_lote', 
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verificar se a coluna id_usuario_dispensacao já existe
SELECT COUNT(*) INTO @col_exists 
FROM information_schema.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME = 'prescricao_item' 
  AND COLUMN_NAME = 'id_usuario_dispensacao';

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE prescricao_item ADD COLUMN id_usuario_dispensacao BIGINT NULL AFTER dispensado_em', 
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verificar se a coluna status já existe
SELECT COUNT(*) INTO @col_exists 
FROM information_schema.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME = 'prescricao_item' 
  AND COLUMN_NAME = 'status';

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE prescricao_item ADD COLUMN status VARCHAR(20) NULL DEFAULT ''PENDENTE'' AFTER id_usuario_dispensacao', 
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
