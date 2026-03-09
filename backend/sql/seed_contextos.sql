-- Script para criar contextos de exemplo para usuários existentes
-- Execute este script no banco de dados

-- Primeiro, verifica se a tabela usuario_contexto existe
CREATE TABLE IF NOT EXISTS usuario_contexto (
    id_usuario_contexto INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_unidade INT NOT NULL,
    id_local_operacional INT NOT NULL,
    id_perfil INT NOT NULL,
    id_sistema INT DEFAULT 1,
    ativo TINYINT(1) DEFAULT 1,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_usuario (id_usuario)
);

-- Insere contextos para usuários existentes (assumindo que existem usuários com id 1, 2, 3)
-- Ajuste os IDs conforme necessário

-- Contexto para ADMINISTRADOR (usuário ID 1)
INSERT INTO usuario_contexto (id_usuario, id_unidade, id_local_operacional, id_perfil, id_sistema, ativo)
SELECT 1, u.id_unidade, lo.id_local_operacional, p.id_perfil, 1, 1
FROM unidade u
CROSS JOIN local_operacional lo
CROSS JOIN perfil p
WHERE u.ativo = 1 
AND lo.ativo = 1
AND p.nome = 'ADMINISTRADOR'
LIMIT 1
ON DUPLICATE KEY UPDATE ativo = 1;

-- Contexto para RECEPCAO (usuário ID 2)
INSERT INTO usuario_contexto (id_usuario, id_unidade, id_local_operacional, id_perfil, id_sistema, ativo)
SELECT 2, u.id_unidade, lo.id_local_operacional, p.id_perfil, 1, 1
FROM unidade u
CROSS JOIN local_operacional lo
CROSS JOIN perfil p
WHERE u.ativo = 1 
AND lo.ativo = 1
AND p.nome = 'RECEPCIONISTA'
LIMIT 1
ON DUPLICATE KEY UPDATE ativo = 1;

-- Contexto para TRIAGEM (usuário ID 3)
INSERT INTO usuario_contexto (id_usuario, id_unidade, id_local_operacional, id_perfil, id_sistema, ativo)
SELECT 3, u.id_unidade, lo.id_local_operacional, p.id_perfil, 1, 1
FROM unidade u
CROSS JOIN local_operacional lo
CROSS JOIN perfil p
WHERE u.ativo = 1 
AND lo.ativo = 1
AND p.nome = 'ENFERMEIRO'
LIMIT 1
ON DUPLICATE KEY UPDATE ativo = 1;

-- Contexto para ENFERMAGEM (usuário ID 4)
INSERT INTO usuario_contexto (id_usuario, id_unidade, id_local_operacional, id_perfil, id_sistema, ativo)
SELECT 4, u.id_unidade, lo.id_local_operacional, p.id_perfil, 1, 1
FROM unidade u
CROSS JOIN local_operacional lo
CROSS JOIN perfil p
WHERE u.ativo = 1 
AND lo.ativo = 1
AND p.nome = 'ENFERMEIRO'
LIMIT 1
ON DUPLICATE KEY UPDATE ativo = 1;

-- Contexto para MEDICO (usuário ID 5)
INSERT INTO usuario_contexto (id_usuario, id_unidade, id_local_operacional, id_perfil, id_sistema, ativo)
SELECT 5, u.id_unidade, lo.id_local_operacional, p.id_perfil, 1, 1
FROM unidade u
CROSS JOIN local_operacional lo
CROSS JOIN perfil p
WHERE u.ativo = 1 
AND lo.ativo = 1
AND p.nome = 'MEDICO'
LIMIT 1
ON DUPLICATE KEY UPDATE ativo = 1;

-- Contexto para FARMACIA (usuário ID 6)
INSERT INTO usuario_contexto (id_usuario, id_unidade, id_local_operacional, id_perfil, id_sistema, ativo)
SELECT 6, u.id_unidade, lo.id_local_operacional, p.id_perfil, 1, 1
FROM unidade u
CROSS JOIN local_operacional lo
CROSS JOIN perfil p
WHERE u.ativo = 1 
AND lo.ativo = 1
AND p.nome = 'FARMACEUTICO'
LIMIT 1
ON DUPLICATE KEY UPDATE ativo = 1;

-- Verifica se existem registros
SELECT * FROM usuario_contexto LIMIT 10;
