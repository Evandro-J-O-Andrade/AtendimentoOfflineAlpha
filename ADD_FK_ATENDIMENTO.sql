-- ============================================================
-- DDL: Garantir coluna id_atendimento + FK canônica em todas as tabelas da lista
-- Data: 27/03/2026
-- Regras: nomes canônicos (fk_<tabela>_atendimento), sem sufixos/versionamentos
-- Sem procedures, compatível com MySQL 5.7+ (usa checks no information_schema)
-- ============================================================

USE `pronto_atendimento`;
SET FOREIGN_KEY_CHECKS = 0;
-- atendimento_anamnese
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_anamnese'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_anamnese` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_anamnese";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_anamnese'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_anamnese` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_anamnese";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_anamnese` ADD CONSTRAINT `fk_atendimento_anamnese_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_balanco_hidrico
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_balanco_hidrico'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_balanco_hidrico` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_balanco_hidrico";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_balanco_hidrico'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_balanco_hidrico` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_balanco_hidrico";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_balanco_hidrico` ADD CONSTRAINT `fk_atendimento_balanco_hidrico_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_checagem
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_checagem'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_checagem` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_checagem";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_checagem'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_checagem` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_checagem";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_checagem` ADD CONSTRAINT `fk_atendimento_checagem_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_desfecho
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_desfecho'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_desfecho` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_desfecho";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_desfecho'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_desfecho` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_desfecho";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_desfecho` ADD CONSTRAINT `fk_atendimento_desfecho_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_diagnostico
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_diagnostico'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_diagnostico` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_diagnostico";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_diagnostico'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_diagnostico` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_diagnostico";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_diagnostico` ADD CONSTRAINT `fk_atendimento_diagnostico_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_escalas_risco
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_escalas_risco'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_escalas_risco` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_escalas_risco";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_escalas_risco'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_escalas_risco` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_escalas_risco";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_escalas_risco` ADD CONSTRAINT `fk_atendimento_escalas_risco_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_estado_ativo
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_estado_ativo'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_estado_ativo` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_estado_ativo";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_estado_ativo'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_estado_ativo` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_estado_ativo";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_estado_ativo` ADD CONSTRAINT `fk_atendimento_estado_ativo_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_evento
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_evento'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_evento` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_evento";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_evento'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_evento` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_evento";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_evento` ADD CONSTRAINT `fk_atendimento_evento_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_evento_ledger
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_evento_ledger'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_evento_ledger` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_evento_ledger";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_evento_ledger'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_evento_ledger` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_evento_ledger";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_evento_ledger` ADD CONSTRAINT `fk_atendimento_evento_ledger_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_evolucao
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_evolucao'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_evolucao` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_evolucao";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_evolucao'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_evolucao` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_evolucao";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_evolucao` ADD CONSTRAINT `fk_atendimento_evolucao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_exame_fisico
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_exame_fisico'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_exame_fisico` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_exame_fisico";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_exame_fisico'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_exame_fisico` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_exame_fisico";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_exame_fisico` ADD CONSTRAINT `fk_atendimento_exame_fisico_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_identidade_fluxo
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_identidade_fluxo'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_identidade_fluxo` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_identidade_fluxo";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_identidade_fluxo'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_identidade_fluxo` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_identidade_fluxo";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_identidade_fluxo` ADD CONSTRAINT `fk_atendimento_identidade_fluxo_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_movimentacao
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_movimentacao'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_movimentacao` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_movimentacao";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_movimentacao'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_movimentacao` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_movimentacao";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_movimentacao` ADD CONSTRAINT `fk_atendimento_movimentacao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_observacao
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_observacao'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_observacao` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_observacao";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_observacao'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_observacao` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_observacao";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_observacao` ADD CONSTRAINT `fk_atendimento_observacao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_pedidos_exame
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_pedidos_exame'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_pedidos_exame` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_pedidos_exame";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_pedidos_exame'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_pedidos_exame` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_pedidos_exame";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_pedidos_exame` ADD CONSTRAINT `fk_atendimento_pedidos_exame_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_pre_hospitalar
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_pre_hospitalar'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_pre_hospitalar` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_pre_hospitalar";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_pre_hospitalar'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_pre_hospitalar` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_pre_hospitalar";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_pre_hospitalar` ADD CONSTRAINT `fk_atendimento_pre_hospitalar_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_prescricao
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_prescricao'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_prescricao` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_prescricao";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_prescricao'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_prescricao` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_prescricao";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_prescricao` ADD CONSTRAINT `fk_atendimento_prescricao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_profissional
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_profissional'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_profissional` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_profissional";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_profissional'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_profissional` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_profissional";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_profissional` ADD CONSTRAINT `fk_atendimento_profissional_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_recepcao
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_recepcao'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_recepcao` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_recepcao";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_recepcao'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_recepcao` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_recepcao";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_recepcao` ADD CONSTRAINT `fk_atendimento_recepcao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_sinais_vitais
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_sinais_vitais'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_sinais_vitais` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_sinais_vitais";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_sinais_vitais'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_sinais_vitais` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_sinais_vitais";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_sinais_vitais` ADD CONSTRAINT `fk_atendimento_sinais_vitais_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_sumario_alta
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_sumario_alta'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_sumario_alta` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_sumario_alta";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_sumario_alta'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_sumario_alta` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_sumario_alta";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_sumario_alta` ADD CONSTRAINT `fk_atendimento_sumario_alta_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_transicao_ledger
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_transicao_ledger'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_transicao_ledger` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_transicao_ledger";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_transicao_ledger'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_transicao_ledger` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_transicao_ledger";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_transicao_ledger` ADD CONSTRAINT `fk_atendimento_transicao_ledger_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_triagem
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_triagem'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_triagem` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_triagem";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_triagem'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_triagem` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_triagem";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_triagem` ADD CONSTRAINT `fk_atendimento_triagem_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- atendimento_vinculo
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'atendimento_vinculo'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `atendimento_vinculo` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em atendimento_vinculo";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'atendimento_vinculo'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `atendimento_vinculo` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em atendimento_vinculo";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `atendimento_vinculo` ADD CONSTRAINT `fk_atendimento_vinculo_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- gpat_atendimento
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'gpat_atendimento'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `gpat_atendimento` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em gpat_atendimento";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'gpat_atendimento'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `gpat_atendimento` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em gpat_atendimento";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `gpat_atendimento` ADD CONSTRAINT `fk_gpat_atendimento_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- farm_atendimento_externo
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'farm_atendimento_externo'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `farm_atendimento_externo` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em farm_atendimento_externo";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'farm_atendimento_externo'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `farm_atendimento_externo` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em farm_atendimento_externo";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `farm_atendimento_externo` ADD CONSTRAINT `fk_farm_atendimento_externo_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- farmacia_atendimento_externo_dispensacao
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'farmacia_atendimento_externo_dispensacao'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `farmacia_atendimento_externo_dispensacao` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em farmacia_atendimento_externo_dispensacao";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'farmacia_atendimento_externo_dispensacao'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `farmacia_atendimento_externo_dispensacao` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em farmacia_atendimento_externo_dispensacao";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `farmacia_atendimento_externo_dispensacao` ADD CONSTRAINT `fk_farmacia_atendimento_externo_dispensacao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- assistencial_checkpoint_global
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'assistencial_checkpoint_global'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `assistencial_checkpoint_global` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em assistencial_checkpoint_global";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'assistencial_checkpoint_global'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `assistencial_checkpoint_global` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em assistencial_checkpoint_global";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `assistencial_checkpoint_global` ADD CONSTRAINT `fk_assistencial_checkpoint_global_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- assistencial_runtime_panel
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'assistencial_runtime_panel'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `assistencial_runtime_panel` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em assistencial_runtime_panel";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'assistencial_runtime_panel'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `assistencial_runtime_panel` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em assistencial_runtime_panel";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `assistencial_runtime_panel` ADD CONSTRAINT `fk_assistencial_runtime_panel_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- assistencial_runtime_federado
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'assistencial_runtime_federado'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `assistencial_runtime_federado` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em assistencial_runtime_federado";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'assistencial_runtime_federado'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `assistencial_runtime_federado` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em assistencial_runtime_federado";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `assistencial_runtime_federado` ADD CONSTRAINT `fk_assistencial_runtime_federado_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- assistencial_simulacao_futura
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'assistencial_simulacao_futura'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `assistencial_simulacao_futura` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em assistencial_simulacao_futura";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'assistencial_simulacao_futura'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `assistencial_simulacao_futura` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em assistencial_simulacao_futura";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `assistencial_simulacao_futura` ADD CONSTRAINT `fk_assistencial_simulacao_futura_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- assistencial_snapshot_runtime
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'assistencial_snapshot_runtime'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `assistencial_snapshot_runtime` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em assistencial_snapshot_runtime";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'assistencial_snapshot_runtime'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `assistencial_snapshot_runtime` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em assistencial_snapshot_runtime";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `assistencial_snapshot_runtime` ADD CONSTRAINT `fk_assistencial_snapshot_runtime_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- assistencial_telemetria_runtime
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'assistencial_telemetria_runtime'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `assistencial_telemetria_runtime` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em assistencial_telemetria_runtime";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'assistencial_telemetria_runtime'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `assistencial_telemetria_runtime` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em assistencial_telemetria_runtime";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `assistencial_telemetria_runtime` ADD CONSTRAINT `fk_assistencial_telemetria_runtime_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- assistencial_watchdog_fila
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'assistencial_watchdog_fila'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `assistencial_watchdog_fila` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em assistencial_watchdog_fila";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'assistencial_watchdog_fila'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `assistencial_watchdog_fila` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em assistencial_watchdog_fila";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `assistencial_watchdog_fila` ADD CONSTRAINT `fk_assistencial_watchdog_fila_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- internacao
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'internacao'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `internacao` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em internacao";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'internacao'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `internacao` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em internacao";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `internacao` ADD CONSTRAINT `fk_internacao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- internacao_medicacao_administracao
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'internacao_medicacao_administracao'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `internacao_medicacao_administracao` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em internacao_medicacao_administracao";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'internacao_medicacao_administracao'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `internacao_medicacao_administracao` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em internacao_medicacao_administracao";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `internacao_medicacao_administracao` ADD CONSTRAINT `fk_internacao_medicacao_administracao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- internacao_movimentacao
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'internacao_movimentacao'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `internacao_movimentacao` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em internacao_movimentacao";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'internacao_movimentacao'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `internacao_movimentacao` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em internacao_movimentacao";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `internacao_movimentacao` ADD CONSTRAINT `fk_internacao_movimentacao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- internacao_prescricao
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'internacao_prescricao'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `internacao_prescricao` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em internacao_prescricao";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'internacao_prescricao'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `internacao_prescricao` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em internacao_prescricao";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `internacao_prescricao` ADD CONSTRAINT `fk_internacao_prescricao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- internacao_prescricao_item
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'internacao_prescricao_item'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `internacao_prescricao_item` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em internacao_prescricao_item";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'internacao_prescricao_item'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `internacao_prescricao_item` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em internacao_prescricao_item";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `internacao_prescricao_item` ADD CONSTRAINT `fk_internacao_prescricao_item_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- internacao_registro_enfermagem
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'internacao_registro_enfermagem'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `internacao_registro_enfermagem` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em internacao_registro_enfermagem";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'internacao_registro_enfermagem'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `internacao_registro_enfermagem` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em internacao_registro_enfermagem";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `internacao_registro_enfermagem` ADD CONSTRAINT `fk_internacao_registro_enfermagem_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- internacao_turno_registro
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'internacao_turno_registro'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `internacao_turno_registro` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em internacao_turno_registro";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'internacao_turno_registro'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `internacao_turno_registro` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em internacao_turno_registro";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `internacao_turno_registro` ADD CONSTRAINT `fk_internacao_turno_registro_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- ordem_assistencial
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'ordem_assistencial'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `ordem_assistencial` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em ordem_assistencial";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'ordem_assistencial'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `ordem_assistencial` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em ordem_assistencial";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `ordem_assistencial` ADD CONSTRAINT `fk_ordem_assistencial_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- ordem_assistencial_item
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'ordem_assistencial_item'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `ordem_assistencial_item` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em ordem_assistencial_item";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'ordem_assistencial_item'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `ordem_assistencial_item` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em ordem_assistencial_item";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `ordem_assistencial_item` ADD CONSTRAINT `fk_ordem_assistencial_item_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- ordem_assistencial_aprazamento
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'ordem_assistencial_aprazamento'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `ordem_assistencial_aprazamento` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em ordem_assistencial_aprazamento";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'ordem_assistencial_aprazamento'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `ordem_assistencial_aprazamento` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em ordem_assistencial_aprazamento";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `ordem_assistencial_aprazamento` ADD CONSTRAINT `fk_ordem_assistencial_aprazamento_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- ordem_assistencial_execucao
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'ordem_assistencial_execucao'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `ordem_assistencial_execucao` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em ordem_assistencial_execucao";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'ordem_assistencial_execucao'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `ordem_assistencial_execucao` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em ordem_assistencial_execucao";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `ordem_assistencial_execucao` ADD CONSTRAINT `fk_ordem_assistencial_execucao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- protocolo_assistencial_global
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'protocolo_assistencial_global'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `protocolo_assistencial_global` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em protocolo_assistencial_global";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'protocolo_assistencial_global'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `protocolo_assistencial_global` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em protocolo_assistencial_global";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `protocolo_assistencial_global` ADD CONSTRAINT `fk_protocolo_assistencial_global_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- triagem
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'triagem'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `triagem` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em triagem";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'triagem'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `triagem` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em triagem";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `triagem` ADD CONSTRAINT `fk_triagem_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- reabertura_atendimento
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'reabertura_atendimento'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `reabertura_atendimento` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em reabertura_atendimento";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'reabertura_atendimento'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `reabertura_atendimento` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em reabertura_atendimento";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `reabertura_atendimento` ADD CONSTRAINT `fk_reabertura_atendimento_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- retorno_atendimento
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'retorno_atendimento'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `retorno_atendimento` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em retorno_atendimento";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'retorno_atendimento'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `retorno_atendimento` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em retorno_atendimento";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `retorno_atendimento` ADD CONSTRAINT `fk_retorno_atendimento_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
-- fluxo_orquestrador_canonico
SET @need_col := (SELECT COUNT(*) = 0 FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'fluxo_orquestrador_canonico'
                     AND COLUMN_NAME = 'id_atendimento');
SET @sql := IF(@need_col,
  'ALTER TABLE `fluxo_orquestrador_canonico` ADD COLUMN `id_atendimento` BIGINT UNSIGNED NOT NULL;',
  'SELECT "coluna id_atendimento já existe em fluxo_orquestrador_canonico";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_name := (SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = 'fluxo_orquestrador_canonico'
                    AND CONSTRAINT_TYPE = "FOREIGN KEY"
                    AND CONSTRAINT_NAME LIKE "fk%atendimento%"
                  LIMIT 1);
SET @drop_sql := IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE `fluxo_orquestrador_canonico` DROP FOREIGN KEY `', @fk_name, '`;'),
  'SELECT "sem fk para dropar em fluxo_orquestrador_canonico";');
PREPARE stmt FROM @drop_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @add_fk := 'ALTER TABLE `fluxo_orquestrador_canonico` ADD CONSTRAINT `fk_fluxo_orquestrador_canonico_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento`(`id_atendimento`) ON UPDATE CASCADE ON DELETE CASCADE;';
PREPARE stmt FROM @add_fk; EXECUTE stmt; DEALLOCATE PREPARE stmt;
\nSET FOREIGN_KEY_CHECKS = 1;\n
