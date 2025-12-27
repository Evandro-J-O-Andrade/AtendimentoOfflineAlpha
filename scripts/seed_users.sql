-- scripts/seed_users.sql
-- Idempotent SQL seed to create profiles and users for local dev
-- Run in Workbench: Open this file and execute

START TRANSACTION;

-- Ensure column seed_password exists (works on older MySQL versions)
SET @col_exists = (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'usuario' AND COLUMN_NAME = 'seed_password'
);

SET @sql = IF(@col_exists = 0,
  'ALTER TABLE usuario ADD COLUMN seed_password VARCHAR(255) NULL DEFAULT NULL',
  'SELECT "seed_password_already_exists"'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Create profiles if not exists
INSERT INTO perfil (nome)
SELECT 'ADMIN_MASTER' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM perfil WHERE nome = 'ADMIN_MASTER');
INSERT INTO perfil (nome)
SELECT 'SUPORTE_MASTER' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM perfil WHERE nome = 'SUPORTE_MASTER');
INSERT INTO perfil (nome)
SELECT 'SUPORTE' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM perfil WHERE nome = 'SUPORTE');
INSERT INTO perfil (nome)
SELECT 'ADM_RECEPCAO' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM perfil WHERE nome = 'ADM_RECEPCAO');
INSERT INTO perfil (nome)
SELECT 'TOTEM_CALLER' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM perfil WHERE nome = 'TOTEM_CALLER');
INSERT INTO perfil (nome)
SELECT 'MEDICO' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM perfil WHERE nome = 'MEDICO');
INSERT INTO perfil (nome)
SELECT 'ENFERMAGEM' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM perfil WHERE nome = 'ENFERMAGEM');
INSERT INTO perfil (nome)
SELECT 'RECEPCAO' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM perfil WHERE nome = 'RECEPCAO');
INSERT INTO perfil (nome)
SELECT 'AUDITORIA' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM perfil WHERE nome = 'AUDITORIA');

-- Helper: create pessoa if not exists and return id via variable
-- For Workbench, we'll do individual idempotent inserts

-- Create persons
INSERT INTO pessoa (nome_completo)
SELECT 'Administrador Master' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM pessoa WHERE nome_completo = 'Administrador Master');
INSERT INTO pessoa (nome_completo)
SELECT 'Suporte Master' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM pessoa WHERE nome_completo = 'Suporte Master');
INSERT INTO pessoa (nome_completo)
SELECT 'Suporte Comum' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM pessoa WHERE nome_completo = 'Suporte Comum');
INSERT INTO pessoa (nome_completo)
SELECT 'ADM Recepção' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM pessoa WHERE nome_completo = 'ADM Recepção');
INSERT INTO pessoa (nome_completo)
SELECT 'Totem Caller' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM pessoa WHERE nome_completo = 'Totem Caller');
INSERT INTO pessoa (nome_completo)
SELECT 'Recepcionista Teste' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM pessoa WHERE nome_completo = 'Recepcionista Teste');
INSERT INTO pessoa (nome_completo)
SELECT 'Médico Clínico Teste' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM pessoa WHERE nome_completo = 'Médico Clínico Teste');
INSERT INTO pessoa (nome_completo)
SELECT 'Médico Pediatria Teste' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM pessoa WHERE nome_completo = 'Médico Pediatria Teste');
INSERT INTO pessoa (nome_completo)
SELECT 'Enfermeiro Teste' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM pessoa WHERE nome_completo = 'Enfermeiro Teste');

-- Create users with seed_password = 'Senha123!'
-- Insert only if login not exists

INSERT INTO usuario (login, senha_hash, seed_password, id_pessoa, ativo)
SELECT 'admin', '', 'Senha123!', (SELECT id_pessoa FROM pessoa WHERE nome_completo = 'Administrador Master' LIMIT 1), 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE login = 'admin');

INSERT INTO usuario (login, senha_hash, seed_password, id_pessoa, ativo)
SELECT 'suporte_master', '', 'Senha123!', (SELECT id_pessoa FROM pessoa WHERE nome_completo = 'Suporte Master' LIMIT 1), 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE login = 'suporte_master');

INSERT INTO usuario (login, senha_hash, seed_password, id_pessoa, ativo)
SELECT 'suporte', '', 'Senha123!', (SELECT id_pessoa FROM pessoa WHERE nome_completo = 'Suporte Comum' LIMIT 1), 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE login = 'suporte');

INSERT INTO usuario (login, senha_hash, seed_password, id_pessoa, ativo)
SELECT 'adm_recepcao', '', 'Senha123!', (SELECT id_pessoa FROM pessoa WHERE nome_completo = 'ADM Recepção' LIMIT 1), 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE login = 'adm_recepcao');

INSERT INTO usuario (login, senha_hash, seed_password, id_pessoa, ativo)
SELECT 'totem01', '', 'Senha123!', (SELECT id_pessoa FROM pessoa WHERE nome_completo = 'Totem Caller' LIMIT 1), 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE login = 'totem01');

INSERT INTO usuario (login, senha_hash, seed_password, id_pessoa, ativo)
SELECT 'recepcao1', '', 'Senha123!', (SELECT id_pessoa FROM pessoa WHERE nome_completo = 'Recepcionista Teste' LIMIT 1), 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE login = 'recepcao1');

INSERT INTO usuario (login, senha_hash, seed_password, id_pessoa, ativo)
SELECT 'medico_clinico', '', 'Senha123!', (SELECT id_pessoa FROM pessoa WHERE nome_completo = 'Médico Clínico Teste' LIMIT 1), 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE login = 'medico_clinico');

INSERT INTO usuario (login, senha_hash, seed_password, id_pessoa, ativo)
SELECT 'medico_pediatria', '', 'Senha123!', (SELECT id_pessoa FROM pessoa WHERE nome_completo = 'Médico Pediatria Teste' LIMIT 1), 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE login = 'medico_pediatria');

INSERT INTO usuario (login, senha_hash, seed_password, id_pessoa, ativo)
SELECT 'enfermagem1', '', 'Senha123!', (SELECT id_pessoa FROM pessoa WHERE nome_completo = 'Enfermeiro Teste' LIMIT 1), 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE login = 'enfermagem1');

-- Assign profiles to users (only if mapping doesn't exist)
-- admin: ADMIN_MASTER, SUPORTE_MASTER
INSERT INTO usuario_perfil (id_usuario, id_perfil)
SELECT u.id_usuario, p.id_perfil
FROM usuario u JOIN perfil p ON p.nome = 'ADMIN_MASTER'
WHERE u.login = 'admin' AND NOT EXISTS (SELECT 1 FROM usuario_perfil up WHERE up.id_usuario = u.id_usuario AND up.id_perfil = p.id_perfil);

INSERT INTO usuario_perfil (id_usuario, id_perfil)
SELECT u.id_usuario, p.id_perfil
FROM usuario u JOIN perfil p ON p.nome = 'SUPORTE_MASTER'
WHERE u.login = 'admin' AND NOT EXISTS (SELECT 1 FROM usuario_perfil up WHERE up.id_usuario = u.id_usuario AND up.id_perfil = p.id_perfil);

-- suporte_master: SUPORTE_MASTER
INSERT INTO usuario_perfil (id_usuario, id_perfil)
SELECT u.id_usuario, p.id_perfil
FROM usuario u JOIN perfil p ON p.nome = 'SUPORTE_MASTER'
WHERE u.login = 'suporte_master' AND NOT EXISTS (SELECT 1 FROM usuario_perfil up WHERE up.id_usuario = u.id_usuario AND up.id_perfil = p.id_perfil);

-- suporte: SUPORTE
INSERT INTO usuario_perfil (id_usuario, id_perfil)
SELECT u.id_usuario, p.id_perfil
FROM usuario u JOIN perfil p ON p.nome = 'SUPORTE'
WHERE u.login = 'suporte' AND NOT EXISTS (SELECT 1 FROM usuario_perfil up WHERE up.id_usuario = u.id_usuario AND up.id_perfil = p.id_perfil);

-- adm_recepcao: ADM_RECEPCAO
INSERT INTO usuario_perfil (id_usuario, id_perfil)
SELECT u.id_usuario, p.id_perfil
FROM usuario u JOIN perfil p ON p.nome = 'ADM_RECEPCAO'
WHERE u.login = 'adm_recepcao' AND NOT EXISTS (SELECT 1 FROM usuario_perfil up WHERE up.id_usuario = u.id_usuario AND up.id_perfil = p.id_perfil);

-- totem01: TOTEM_CALLER
INSERT INTO usuario_perfil (id_usuario, id_perfil)
SELECT u.id_usuario, p.id_perfil
FROM usuario u JOIN perfil p ON p.nome = 'TOTEM_CALLER'
WHERE u.login = 'totem01' AND NOT EXISTS (SELECT 1 FROM usuario_perfil up WHERE up.id_usuario = u.id_usuario AND up.id_perfil = p.id_perfil);

-- recepcao1: RECEPCAO
INSERT INTO usuario_perfil (id_usuario, id_perfil)
SELECT u.id_usuario, p.id_perfil
FROM usuario u JOIN perfil p ON p.nome = 'RECEPCAO'
WHERE u.login = 'recepcao1' AND NOT EXISTS (SELECT 1 FROM usuario_perfil up WHERE up.id_usuario = u.id_usuario AND up.id_perfil = p.id_perfil);

-- medico_clinico & medico_pediatria: MEDICO
INSERT INTO usuario_perfil (id_usuario, id_perfil)
SELECT u.id_usuario, p.id_perfil
FROM usuario u JOIN perfil p ON p.nome = 'MEDICO'
WHERE u.login IN ('medico_clinico','medico_pediatria') AND NOT EXISTS (SELECT 1 FROM usuario_perfil up WHERE up.id_usuario = u.id_usuario AND up.id_perfil = p.id_perfil);

-- enfermagem1: ENFERMAGEM
INSERT INTO usuario_perfil (id_usuario, id_perfil)
SELECT u.id_usuario, p.id_perfil
FROM usuario u JOIN perfil p ON p.nome = 'ENFERMAGEM'
WHERE u.login = 'enfermagem1' AND NOT EXISTS (SELECT 1 FROM usuario_perfil up WHERE up.id_usuario = u.id_usuario AND up.id_perfil = p.id_perfil);

COMMIT;

-- Note: Seed password is 'Senha123!' for all seed users. On first login the API will convert it to a secure hash and remove seed_password.
