-- Script para inserir contextos para usuários existentes
-- Execute no banco de dados MySQL

-- Verifica se existem usuarios
SELECT id_usuario, login, nome FROM usuario WHERE ativo = 1 LIMIT 10;

-- Verifica se existem unidades
SELECT id_unidade, nome FROM unidade WHERE ativo = 1 LIMIT 5;

-- Verifica se existem locais operacionais
SELECT id_local_operacional, nome, tipo FROM local_operacional WHERE ativo = 1 LIMIT 5;

-- Verifica se existem perfis
SELECT id_perfil, nome FROM perfil;

-- Insere contextos para o admin (id_usuario = 1)
-- Ajuste os IDs conforme os dados existentes no banco
INSERT IGNORE INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)
VALUES 
(1, 1, 1, 1, 1, 1),  -- Admin: sistema 1, unidade 1, local 1, perfil 1
(1, 1, 1, 2, 1, 1);  -- Admin: sistema 1, unidade 1, local 2, perfil 1

-- Insere contextos para usuario 2 (Recepcionista)
INSERT IGNORE INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)
VALUES 
(2, 1, 1, 2, 4, 1);  -- Recepção: sistema 1, unidade 1, local 2, perfil 4

-- Insere contextos para usuario 3 (Enfermeiro)
INSERT IGNORE INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)
VALUES 
(3, 1, 1, 3, 3, 1);  -- Triagem: sistema 1, unidade 1, local 3, perfil 3

-- Insere contextos para usuario 4 (Enfermeiro)
INSERT IGNORE INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)
VALUES 
(4, 1, 1, 4, 3, 1);  -- Enfermagem: sistema 1, unidade 1, local 4, perfil 3

-- Insere contextos para usuario 5 (Médico)
INSERT IGNORE INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)
VALUES 
(5, 1, 1, 5, 2, 1);  -- Médico: sistema 1, unidade 1, local 5, perfil 2

-- Insere contextos para usuario 6 (Farmacêutico)
INSERT IGNORE INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)
VALUES 
(6, 1, 1, 18, 6, 1);  -- Farmácia: sistema 1, unidade 1, local 18, perfil 6

-- Verifica os contextos inseridos
SELECT * FROM usuario_contexto;
