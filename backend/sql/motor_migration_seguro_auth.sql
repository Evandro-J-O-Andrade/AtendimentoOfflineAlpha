-- ============================================================================
-- MOTOR DE MIGRATION SEGURO - AUTH HIS SAAS
-- Idempotente, auditavel e reexecutavel
-- ============================================================================

-- 0) Infra de controle de patches
CREATE TABLE IF NOT EXISTS schema_patch_execucao (
    id_patch_execucao BIGINT NOT NULL AUTO_INCREMENT,
    patch_nome VARCHAR(120) NOT NULL,
    hash_patch VARCHAR(128) NULL,
    status_execucao ENUM('SUCESSO', 'ERRO') NOT NULL,
    detalhes JSON NULL,
    executado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_patch_execucao),
    KEY idx_patch_nome_data (patch_nome, executado_em)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELIMITER $$

-- 1) Utilitario de log de patch
DROP PROCEDURE IF EXISTS sp_patch_log $$
CREATE PROCEDURE sp_patch_log(
    IN p_patch_nome VARCHAR(120),
    IN p_status_execucao VARCHAR(20),
    IN p_detalhes JSON
)
BEGIN
    INSERT INTO schema_patch_execucao (
        patch_nome,
        status_execucao,
        detalhes
    )
    VALUES (
        p_patch_nome,
        p_status_execucao,
        p_detalhes
    );
END $$

-- 2) Patch idempotente da tabela permissao
DROP PROCEDURE IF EXISTS sp_patch_permissao $$
CREATE PROCEDURE sp_patch_permissao()
BEGIN
    DECLARE v_idx_exists INT DEFAULT 0;
    DECLARE v_col_dominio_exists INT DEFAULT 0;
    DECLARE v_col_metadata_exists INT DEFAULT 0;
    DECLARE v_dup_count INT DEFAULT 0;

    -- coluna dominio
    SELECT COUNT(*) INTO v_col_dominio_exists
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'permissao'
      AND column_name = 'dominio';

    IF v_col_dominio_exists = 0 THEN
        ALTER TABLE permissao
        ADD COLUMN dominio VARCHAR(40) DEFAULT 'GERAL';
    END IF;

    -- coluna metadata
    SELECT COUNT(*) INTO v_col_metadata_exists
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'permissao'
      AND column_name = 'metadata';

    IF v_col_metadata_exists = 0 THEN
        ALTER TABLE permissao
        ADD COLUMN metadata JSON NULL;
    END IF;

    -- remove indice antigo se existir
    SELECT COUNT(*) INTO v_idx_exists
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'permissao'
      AND index_name = 'uk_permissao_codigo';

    IF v_idx_exists > 0 THEN
        ALTER TABLE permissao DROP INDEX uk_permissao_codigo;
    END IF;

    -- protege criacao do indice unico contra dados duplicados
    SELECT COUNT(*) INTO v_dup_count
    FROM (
        SELECT codigo
        FROM permissao
        GROUP BY codigo
        HAVING COUNT(*) > 1
    ) t;

    IF v_dup_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'PATCH_PERMISSAO_DUPLICATE_CODIGO';
    END IF;

    ALTER TABLE permissao
    ADD UNIQUE INDEX uk_permissao_codigo (codigo);
END $$

-- 3) Executor central de patches (auth)
DROP PROCEDURE IF EXISTS sp_patch_run_all_auth $$
CREATE PROCEDURE sp_patch_run_all_auth()
BEGIN
    DECLARE v_error TEXT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;

        CALL sp_patch_log(
            'sp_patch_permissao',
            'ERRO',
            JSON_OBJECT(
                'erro', v_error,
                'executado_em', NOW()
            )
        );

        -- auditoria funcional (se existir)
        IF EXISTS (
            SELECT 1
            FROM information_schema.tables
            WHERE table_schema = DATABASE()
              AND table_name = 'auth_audit'
        ) THEN
            INSERT INTO auth_audit (
                acao,
                recurso,
                detalhes,
                sucesso,
                criado_em
            )
            VALUES (
                'PATCH_EXECUTADO',
                'permissao',
                JSON_OBJECT(
                    'procedimento', 'sp_patch_permissao',
                    'status', 'ERRO',
                    'erro', v_error,
                    'executado_em', NOW()
                ),
                0,
                NOW()
            );
        END IF;

        RESIGNAL;
    END;

    CALL sp_patch_permissao();

    CALL sp_patch_log(
        'sp_patch_permissao',
        'SUCESSO',
        JSON_OBJECT('executado_em', NOW())
    );

    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = DATABASE()
          AND table_name = 'auth_audit'
    ) THEN
        INSERT INTO auth_audit (
            acao,
            recurso,
            detalhes,
            sucesso,
            criado_em
        )
        VALUES (
            'PATCH_EXECUTADO',
            'permissao',
            JSON_OBJECT(
                'procedimento', 'sp_patch_permissao',
                'status', 'SUCESSO',
                'executado_em', NOW()
            ),
            1,
            NOW()
        );
    END IF;
END $$

DELIMITER ;

-- Execucao:
-- CALL sp_patch_run_all_auth();
