-- Script para verificar e corrigir o contexto do usuário triagem
-- Execute este script no banco de dados

-- 1. Verificar o ID do usuário triagem
SELECT id_usuario, login, nome FROM usuario WHERE login = 'triagem';

-- 2. Verificar os contextos atuais do usuário triagem
SELECT uc.*, p.nome as perfil_nome, lo.nome as local_nome
FROM usuario_contexto uc
JOIN perfil p ON p.id_perfil = uc.id_perfil
JOIN local_operacional lo ON lo.id_local_operacional = uc.id_local_operacional
WHERE uc.id_usuario = (SELECT id_usuario FROM usuario WHERE login = 'triagem');

-- 3. Se não existir, inserir o contexto de TRIAGEM para o usuário triagem
-- Substitua o ID do usuário conforme necessário
INSERT INTO usuario_contexto (id_usuario, id_unidade, id_local_operacional, id_perfil, id_sistema, ativo)
SELECT 
    u.id_usuario,
    1 as id_unidade,
    3 as id_local_operacional,  -- Triagem (conforme seed_inicial)
    3 as id_perfil,            -- TRIAGEM
    1 as id_sistema,
    1 as ativo
FROM usuario u
WHERE u.login = 'triagem'
AND NOT EXISTS (
    SELECT 1 FROM usuario_contexto 
    WHERE id_usuario = u.id_usuario 
    AND id_local_operacional = 3 
    AND id_perfil = 3
);

-- 4. Verificar se o perfil TRIAGEM existe na tabela perfil
SELECT * FROM perfil WHERE nome = 'TRIAGEM';

-- 5. Verificar se o local operacional Triagem existe
SELECT * FROM local_operacional WHERE tipo = 'TRIAGEM';
