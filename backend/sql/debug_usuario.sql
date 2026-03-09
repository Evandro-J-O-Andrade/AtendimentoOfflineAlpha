-- ================================================================
-- Debug: Verificar vínculos do usuário
-- ================================================================

-- 1. Buscar o usuário pelo login
SELECT id_usuario, login, nome, email, ativo
FROM usuario 
WHERE login = 'evandro.andrade'
LIMIT 1;

-- 2. Verificar vínculos com sistema
SELECT us.id_usuario, us.id_sistema, us.id_perfil, s.nome as sistema_nome
FROM usuario_sistema us
JOIN sistema s ON s.id_sistema = us.id_sistema
WHERE us.id_usuario = (SELECT id_usuario FROM usuario WHERE login = 'evandro.andrade' LIMIT 1);

-- 3. Verificar vínculos com unidade
SELECT uu.id_usuario, uu.id_unidade, u.nome as unidade_nome
FROM usuario_unidade uu
JOIN unidade u ON u.id_unidade = uu.id_unidade
WHERE uu.id_usuario = (SELECT id_usuario FROM usuario WHERE login = 'evandro.andrade' LIMIT 1);

-- 4. Verificar vínculos com local operacional
SELECT ulo.id_usuario, ulo.id_local_operacional, l.nome as local_nome
FROM usuario_local_operacional ulo
JOIN local_operacional l ON l.id_local_operacional = ulo.id_local_operacional
WHERE ulo.id_usuario = (SELECT id_usuario FROM usuario WHERE login = 'evandro.andrade' LIMIT 1);

-- 5. Verificar contextos
SELECT uc.id_usuario, uc.id_sistema, uc.id_unidade, uc.id_local_operacional, uc.id_perfil
FROM usuario_contexto uc
WHERE uc.id_usuario = (SELECT id_usuario FROM usuario WHERE login = 'evandro.andrade' LIMIT 1);

-- 6. Criar vínculos se não existirem
-- Buscar ID do usuário
SET @id_usuario = (SELECT id_usuario FROM usuario WHERE login = 'evandro.andrade' LIMIT 1);

-- Vincular ao sistema 1 como ADMIN (perfil 1)
INSERT IGNORE INTO usuario_sistema (id_usuario, id_sistema, id_perfil, ativo)
VALUES (@id_usuario, 1, 1, 1);

-- Vincular à unidade 1
INSERT IGNORE INTO usuario_unidade (id_usuario, id_unidade, ativo)
VALUES (@id_usuario, 1, 1);

-- Vincular ao local operacional 1 (Administração)
INSERT IGNORE INTO usuario_local_operacional (id_usuario, id_local_operacional)
VALUES (@id_usuario, 1);

-- Criar contexto completo
INSERT IGNORE INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)
VALUES (@id_usuario, 1, 1, 1, 1, 1);

-- Verificar resultado
SELECT 'Vínculos criados com sucesso!' as resultado;
