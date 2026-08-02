-- =========================================================
-- AUDITORIA ESTRUTURAL — sp_auth_menu_get
-- DATA: 2026-07-27
-- CLASSIFICAÇÃO: OPÇÃO C — Ambos divergiram
-- =========================================================
--
-- RESUMO:
--   Dump canônico (Dump20260618.sql) não contém tabela `permissao`
--   com estrutura atual. Contém apenas `auth_grupo_permissao`
--   (estrutura antiga baseada em grupos).
--
--   Banco vivo possui tabela `permissao` com estrutura nova
--   (baseada em capabilities), mas sem as colunas que a SP
--   `sp_auth_menu_get` espera.
--
--   SP `sp_auth_menu_get` é canônica e correta em relação ao
--   design, mas referencia colunas inexistentes.
--
-- DIVERGÊNCIAS CLASSIFICADAS:
--
-- | Item                  | Dump Canônico | Banco Vivo | Classificação |
-- |-----------------------|---------------|------------|---------------|
-- | Tabela `permissao`    | Estrutura antiga | Estrutura nova | REUSE/ADAPT |
-- | Coluna `modulo`       | Não existe    | Não existe | PROPOSE |
-- | Coluna `flag_ativo`   | Não existe    | Não existe | PROPOSE |
-- | Coluna `flag_externo` | Não existe    | Não existe | PROPOSE |
-- | Coluna `flag_restrito`| Não existe    | Não existe | PROPOSE |
-- | Coluna `ordem`        | Não existe    | Não existe | PROPOSE |
-- | Tabela `menu_evento`  | Não existe    | Existe     | PROPOSE |
-- | Tabela `permissao_local` | Não existe | Existe     | PROPOSE |
--
-- AÇÃO: Migration canônica para adicionar colunas faltantes
--        na tabela `permissao` do banco vivo.
-- =========================================================

-- =========================================================
-- MD-REGISTRY-002-menu-flags.sql
-- STATUS: PROPOSED (requer aprovação)
-- =========================================================

ALTER TABLE `permissao`
  -- Módulo agrupador do menu (substitui grupo_menu para fins de menu)
  ADD COLUMN `modulo` VARCHAR(50) NOT NULL DEFAULT 'GERAL'
    COMMENT 'Módulo agrupador do menu (sp_auth_menu_get)',

  -- Flags de controle de exibição
  ADD COLUMN `flag_ativo` TINYINT(1) NOT NULL DEFAULT 1
    COMMENT 'Flag de ativo para menu (sp_auth_menu_get)',
  ADD COLUMN `flag_externo` TINYINT(1) NOT NULL DEFAULT 0
    COMMENT 'Flag de módulo externo (sp_auth_menu_get)',
  ADD COLUMN `flag_restrito` TINYINT(1) NOT NULL DEFAULT 0
    COMMENT 'Flag de módulo restrito (sp_auth_menu_get)',

  -- Ordem de exibição (mapeamento de ordem_menu)
  ADD COLUMN `ordem` INT NOT NULL DEFAULT 999
    COMMENT 'Ordem de exibição no menu (sp_auth_menu_get)';

-- Backfill defensivo: migrar dados existentes
UPDATE `permissao`
   SET `modulo` = COALESCE(`grupo_menu`, 'GERAL'),
       `flag_ativo` = COALESCE(`ativo`, 1),
       `ordem` = COALESCE(`ordem_menu`, 999)
 WHERE `modulo` = 'GERAL'
   AND `flag_ativo` = 1
   AND `ordem` = 999;

-- Índices para performance do menu
CREATE INDEX `idx_permissao_modulo` ON `permissao` (`modulo`);
CREATE INDEX `idx_permissao_flag_ativo` ON `permissao` (`flag_ativo`);
CREATE INDEX `idx_permissao_ordem` ON `permissao` (`ordem`);

-- =========================================================
-- FIM DA MIGRATION
-- =========================================================
