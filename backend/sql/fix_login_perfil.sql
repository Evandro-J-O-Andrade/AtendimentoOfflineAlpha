-- Script para corrigir o problema de login
-- Execute no banco de dados MySQL

-- 1. Primeiro, verificar se o perfil 1 existe
SELECT * FROM perfil WHERE id_perfil = 1;

-- 2. Se não existir, criar o perfil ADMIN com id 1
INSERT INTO perfil (id_perfil, nome, descricao, ativo) 
SELECT 1, 'ADMIN', 'Administrador', 1
WHERE NOT EXISTS (SELECT 1 FROM perfil WHERE id_perfil = 1);

-- 3. Vincular o perfil 1 ao usuário evandro.andrade (se ainda não vinculado)
INSERT INTO usuario_perfil (id_usuario, id_perfil, ativo)
SELECT u.id_usuario, 1, 1
FROM usuario u
WHERE u.login = 'evandro.andrade'
AND NOT EXISTS (
    SELECT 1 FROM usuario_perfil 
    WHERE id_usuario = u.id_usuario AND id_perfil = 1
);

-- 4. Criar contexto para o usuário com perfil 1
INSERT INTO usuario_contexto (id_usuario, id_unidade, id_local_operacional, id_perfil, id_sistema, ativo)
SELECT u.id_usuario, 1, 1, 1, 1, 1
FROM usuario u
WHERE u.login = 'evandro.andrade'
AND NOT EXISTS (
    SELECT 1 FROM usuario_contexto 
    WHERE id_usuario = u.id_usuario AND id_perfil = 1
);

-- 5. Verificar os dados
SELECT u.id_usuario, u.login, up.id_perfil, p.nome as nome_perfil
FROM usuario u
LEFT JOIN usuario_perfil up ON up.id_usuario = u.id_usuario
LEFT JOIN perfil p ON p.id_perfil = up.id_perfil
WHERE u.login = 'evandro.andrade';
