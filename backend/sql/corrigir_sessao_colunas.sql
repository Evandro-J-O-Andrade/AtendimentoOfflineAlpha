-- ================================================================
-- CORRIGIR COLUNAS DA TABELA SESSAO_USUARIO
-- Execute este script para adicionar colunas faltantes
-- ================================================================

USE `pronto_atendimento`;

-- Verificar e adicionar coluna token_runtime se não existir
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'pronto_atendimento' 
    AND TABLE_NAME = 'sessao_usuario' 
    AND COLUMN_NAME = 'token_runtime'
);

SET @sql = IF(@column_exists = 0, 
    'ALTER TABLE `sessao_usuario` ADD COLUMN `token_runtime` char(64) NULL AFTER `token`',
    'SELECT ''Coluna token_runtime já existe'' AS msg'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verificar e adicionar coluna expiracao_em se não existir
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'pronto_atendimento' 
    AND TABLE_NAME = 'sessao_usuario' 
    AND COLUMN_NAME = 'expiracao_em'
);

SET @sql = IF(@column_exists = 0, 
    'ALTER TABLE `sessao_usuario` ADD COLUMN `expiracao_em` datetime NULL AFTER `iniciado_em`',
    'SELECT ''Coluna expiracao_em já existe'' AS msg'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verificar e adicionar coluna ip_origem se não existir
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'pronto_atendimento' 
    AND TABLE_NAME = 'sessao_usuario' 
    AND COLUMN_NAME = 'ip_origem'
);

SET @sql = IF(@column_exists = 0, 
    'ALTER TABLE `sessao_usuario` ADD COLUMN `ip_origem` varchar(45) NULL',
    'SELECT ''Coluna ip_origem já existe'' AS msg'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT 'Colunas verificadas/adicionadas com sucesso!' AS resultado;
