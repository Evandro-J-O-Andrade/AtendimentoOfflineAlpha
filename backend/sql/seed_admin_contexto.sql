-- Script para criar contexto para o usuário admin (evandro.andrade)
-- Execute este script no banco de dados

-- Primeiro, vamos verificar qual é o ID do usuário evandro.andrade
SELECT id_usuario, login FROM usuario WHERE login = 'evandro.andrade';

-- Inserir contexto para o admin usando subconsulta
-- Isso假设存在unidade, local_operacional, sistema e perfil
INSERT INTO usuario_contexto (
    id_usuario,
    id_sistema,
    id_unidade,
    id_local_operacional,
    id_perfil,
    ativo
)
SELECT 
    u.id_usuario,
    1 AS id_sistema,  -- Sistema operacional
    un.id_unidade,
    lo.id_local_operacional,
    p.id_perfil,
    1 AS ativo
FROM usuario u
CROSS JOIN (
    SELECT id_unidade FROM unidade WHERE ativo = 1 LIMIT 1
) un
CROSS JOIN (
    SELECT id_local_operacional FROM local_operacional WHERE ativo = 1 LIMIT 1
) lo
CROSS JOIN (
    SELECT id_perfil FROM perfil WHERE nome LIKE '%ADMIN%' OR nome = 'ROOT_ADMIN' LIMIT 1
) p
WHERE u.login = 'evandro.andrade'
ON DUPLICATE KEY UPDATE ativo = 1;

-- Verificar se funcionou
SELECT 
    uc.id_usuario_contexto,
    uc.id_usuario,
    uc.id_sistema,
    uc.id_unidade,
    uc.id_local_operacional,
    uc.id_perfil,
    uc.ativo,
    u.login
FROM usuario_contexto uc
JOIN usuario u ON u.id_usuario = uc.id_usuario
WHERE u.login = 'evandro.andrade';
