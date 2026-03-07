-- ============================================================================
-- AJUSTE DAS COLUNAS DA TABELA sessao_usuario
-- Needed: finalized_em, updated_em (atualizado_em)
-- ============================================================================

-- Adicionar coluna finalized_em se não existir
ALTER TABLE `sessao_usuario` 
ADD COLUMN `finalized_em` datetime(6) NULL AFTER `expiracao_em`;

-- Adicionar coluna atualizado_em se não existir
ALTER TABLE `sessao_usuario` 
ADD COLUMN `atualizado_em` datetime(6) NULL AFTER `finalized_em`;

-- Adicionar coluna id_dispositivo se não existir
ALTER TABLE `sessao_usuario` 
ADD COLUMN `id_dispositivo` BIGINT NULL AFTER `id_local_operacional`;

-- Adicionar índice para token_runtime
ALTER TABLE `sessao_usuario` 
ADD INDEX `idx_token_runtime` (`token_runtime`);

-- ============================================================================
-- CRIAR TABELAS SE NÃO EXISTIREM
-- ============================================================================

-- Tabela perfil
CREATE TABLE IF NOT EXISTS perfil (
    id_perfil BIGINT AUTO_INCREMENT,
    nome VARCHAR(120) NOT NULL,
    descricao VARCHAR(255),
    nivel_acesso INT DEFAULT 1,
    ativo TINYINT(1) DEFAULT 1,
    criado_em DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id_perfil),
    UNIQUE KEY uk_perfil_nome (nome)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela permissao
CREATE TABLE IF NOT EXISTS permissao (
    id_permissao BIGINT AUTO_INCREMENT,
    codigo VARCHAR(120) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    descricao VARCHAR(255),
    modulo VARCHAR(100),
    nome_procedure VARCHAR(150),
    rota_api VARCHAR(150),
    tipo ENUM('PROCEDURE', 'API', 'TELA', 'RELATORIO', 'OPERACAO') DEFAULT 'PROCEDURE',
    ativo TINYINT(1) DEFAULT 1,
    criado_em DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id_permissao),
    UNIQUE KEY uk_perm_codigo (codigo),
    INDEX idx_perm_modulo (modulo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela perfil_permissao
CREATE TABLE IF NOT EXISTS perfil_permissao (
    id_perfil_permissao BIGINT AUTO_INCREMENT,
    id_perfil BIGINT NOT NULL,
    id_permissao BIGINT NOT NULL,
    ativo TINYINT(1) DEFAULT 1,
    criado_em DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id_perfil_permissao),
    UNIQUE KEY uk_perfil_perm (id_perfil, id_permissao),
    INDEX idx_pp_perfil (id_perfil),
    INDEX idx_pp_perm (id_permissao),
    CONSTRAINT fk_pp_perfil FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil),
    CONSTRAINT fk_pp_permissao FOREIGN KEY (id_permissao) REFERENCES permissao(id_permissao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- VIEW de permissões
DROP VIEW IF EXISTS vw_usuario_permissoes;

CREATE VIEW vw_usuario_permissoes AS
SELECT
    su.id_sessao_usuario,
    su.id_usuario,
    su.id_sistema,
    p.id_perfil,
    p.nome AS perfil_nome,
    pm.codigo,
    pm.nome AS permissao_nome,
    pm.nome_procedure,
    pm.rota_api,
    pm.tipo
FROM sessao_usuario su
JOIN usuario_sistema us ON us.id_usuario = su.id_usuario AND us.id_sistema = su.id_sistema
JOIN perfil p ON p.id_perfil = us.id_perfil
JOIN perfil_permissao pp ON pp.id_perfil = p.id_perfil AND pp.ativo = 1
JOIN permissao pm ON pm.id_permissao = pp.id_permissao AND pm.ativo = 1
WHERE su.ativo = 1;

-- ============================================================================
-- EXECUTAR AS STORED PROCEDURES
-- ============================================================================

-- Execute o arquivo sp_auth_modulo.sql depois deste
