-- ============================================================
-- Script para verificar e corrigir problemas de login
-- Execute este script no banco de dados para restaurar acessos
-- ============================================================

-- 1. Verificar se a tabela usuario_contexto existe e tem dados
SELECT '=== Verificando tabela usuario_contexto ===' as info;
SELECT COUNT(*) as total_contextos FROM usuario_contexto;

-- 2. Ver todos os contextos existentes
SELECT 
    uc.id_usuario_contexto,
    uc.id_usuario,
    u.login,
    uc.id_sistema,
    uc.id_unidade,
    uc.id_local_operacional,
    uc.id_perfil,
    p.nome as perfil_nome,
    uc.ativo
FROM usuario_contexto uc
JOIN usuario u ON u.id_usuario = uc.id_usuario
LEFT JOIN perfil p ON p.id_perfil = uc.id_perfil
ORDER BY uc.id_usuario;

-- 3. Verificar se existem usuários sem contexto
SELECT u.id_usuario, u.login, u.nome
FROM usuario u
LEFT JOIN usuario_contexto uc ON uc.id_usuario = u.id_usuario AND uc.ativo = 1
WHERE uc.id_usuario_contexto IS NULL AND u.ativo = 1;

-- 4. Verificar tabela perfil - quais perfis existem
SELECT * FROM perfil ORDER BY id_perfil;

-- 5. Verificar tabela local_operacional
SELECT id_local_operacional, nome, tipo, ativo FROM local_operacional WHERE ativo = 1;

-- ============================================================
-- CORREÇÕES
-- ============================================================

-- 6. Criar contextos para ADMIN (id_usuario=1) se não existir
INSERT IGNORE INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)
VALUES (1, 1, 1, 1, 1, 1);

-- 7. Criar contexto para evandro.andrade (buscar ID primeiro)
-- Execute esta query para encontrar o ID:
-- SELECT id_usuario, login FROM usuario WHERE login LIKE '%evandro%';

-- Exemplo: Se o ID for 5, execute:
-- INSERT IGNORE INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)
-- VALUES (5, 1, 1, 3, 2, 1);  -- Consultório médico

-- 8. Se não existir nenhum contexto, inserir contextos padrão baseados nos usuários existentes
-- Verificar se existe perfil ADMIN (id_perfil=1)
INSERT IGNORE INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)
SELECT u.id_usuario, 1, 1, 1, 1, 1
FROM usuario u
WHERE u.ativo = 1
AND NOT EXISTS (
    SELECT 1 FROM usuario_contexto WHERE id_usuario = u.id_usuario
);

-- 9. Verificar se os contextos inseridos estão corretos
SELECT 
    u.login,
    uc.id_local_operacional,
    uc.id_perfil,
    p.nome as perfil_nome,
    lo.nome as local_nome
FROM usuario_contexto uc
JOIN usuario u ON u.id_usuario = uc.id_usuario
LEFT JOIN perfil p ON p.id_perfil = uc.id_perfil
LEFT JOIN local_operacional lo ON lo.id_local_operacional = uc.id_local_operacional
WHERE u.ativo = 1;

-- 10. Verificar se existem usuários ativos sem contexto válido
SELECT u.id_usuario, u.login, u.nome
FROM usuario u
WHERE u.ativo = 1
AND NOT EXISTS (
    SELECT 1 FROM usuario_contexto 
    WHERE id_usuario = u.id_usuario 
    AND ativo = 1 
    AND id_local_operacional IS NOT NULL
    AND id_perfil IS NOT NULL
);
