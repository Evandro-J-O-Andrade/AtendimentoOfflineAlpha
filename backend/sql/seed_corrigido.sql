-- ================================================================
-- SEED CORRIGIDO - Dados mínimos para autenticação funcionar
-- ================================================================

-- 1. Desbloquear usuário admin (resetar tentativas)
UPDATE usuario SET tentativas_login = 0, ativo = 1 WHERE login = 'admin';

-- 2. Criar vínculos do admin com sistema, unidade e local
-- Primeiro verificar se já existem
SELECT 'Verificando vínculos existentes...' AS info;

-- 2.1 Vincular admin ao sistema operacional (id_sistema = 1)
INSERT IGNORE INTO usuario_sistema (id_usuario, id_sistema, id_perfil, ativo)
VALUES (1, 1, 1, 1);

-- 2.2 Vincular admin à unidade (id_unidade = 10)
INSERT IGNORE INTO usuario_unidade (id_usuario, id_unidade, ativo)
VALUES (1, 10, 1);

-- 2.3 Vincular admin ao local operacional (id_local = 1)
INSERT IGNORE INTO usuario_local_operacional (id_usuario, id_local_operacional)
VALUES (1, 1);

-- 2.4 Vincular admin ao perfil no sistema
INSERT IGNORE INTO usuario_sistema_perfil (id_usuario, id_sistema, perfil_slug)
VALUES (1, 1, 'ADMIN');

-- 2.5 Salvar contexto do usuário
INSERT IGNORE INTO usuario_contexto (id_usuario, id_unidade, id_sistema, id_local_operacional, id_perfil)
VALUES (1, 10, 1, 1, 1);

SELECT 'Vínculos criados com sucesso!' AS resultado;

-- Verificar dados
SELECT 
    u.id_usuario,
    u.login,
    u.tentativas_login,
    u.ativo,
    us.id_sistema,
    uu.id_unidade,
    ulo.id_local_operacional,
    uc.id_perfil
FROM usuario u
LEFT JOIN usuario_sistema us ON us.id_usuario = u.id_usuario
LEFT JOIN usuario_unidade uu ON uu.id_usuario = u.id_usuario
LEFT JOIN usuario_local_operacional ulo ON ulo.id_usuario = u.id_usuario
LEFT JOIN usuario_contexto uc ON uc.id_usuario = u.id_usuario
WHERE u.login = 'admin';
