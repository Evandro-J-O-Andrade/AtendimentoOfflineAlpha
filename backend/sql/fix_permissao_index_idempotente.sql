-- ============================================================================
-- Patch idempotente: permissao.dominio, permissao.metadata e uk_permissao_codigo
-- Pode ser executado múltiplas vezes sem erro.
-- ============================================================================

-- 1) Adiciona coluna dominio se ainda não existir
SET @col_dominio_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'permissao'
      AND column_name = 'dominio'
);

SET @sql = IF(
    @col_dominio_exists = 0,
    "ALTER TABLE permissao ADD COLUMN dominio VARCHAR(40) DEFAULT 'GERAL'",
    "SELECT 'COLUNA dominio JÁ EXISTE'"
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2) Adiciona coluna metadata se ainda não existir
SET @col_metadata_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'permissao'
      AND column_name = 'metadata'
);

SET @sql = IF(
    @col_metadata_exists = 0,
    "ALTER TABLE permissao ADD COLUMN metadata JSON NULL",
    "SELECT 'COLUNA metadata JÁ EXISTE'"
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3) Remove índice se existir
SET @idx_exists = (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'permissao'
      AND index_name = 'uk_permissao_codigo'
);

SET @sql = IF(
    @idx_exists > 0,
    "ALTER TABLE permissao DROP INDEX uk_permissao_codigo",
    "SELECT 'INDEX uk_permissao_codigo NÃO EXISTIA'"
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4) Cria índice único novamente
ALTER TABLE permissao
ADD UNIQUE INDEX uk_permissao_codigo (codigo);
