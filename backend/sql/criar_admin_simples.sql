-- ================================================================
-- CRIAR USUÁRIO ADMIN SIMPLES
-- Execute este script para criar um usuário admin de teste
-- ================================================================

USE `pronto_atendimento`;

-- Criar usuário admin se não existir
INSERT INTO usuario (id_usuario, id_pessoa, login, senha_hash, ativo, tentativas_login)
VALUES (99, NULL, 'admin', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a', 1, 0)
ON DUPLICATE KEY UPDATE ativo = 1, tentativas_login = 0;

-- Vincular ao sistema 1 como ADMIN (perfil 1)
INSERT INTO usuario_sistema (id_usuario_sistema, id_usuario, id_sistema, id_perfil, ativo)
VALUES (99, 99, 1, 1, 1)
ON DUPLICATE KEY UPDATE ativo = 1;

-- Vincular à unidade 1
INSERT INTO usuario_unidade (id_usuario, id_unidade, ativo)
VALUES (99, 1, 1)
ON DUPLICATE KEY UPDATE ativo = 1;

-- Criar contexto admin
INSERT INTO usuario_contexto (id_contexto, id_entidade, id_usuario, id_unidade, id_sistema, id_perfil, id_local_operacional, ativo)
VALUES (99, 1, 99, 1, 1, 1, 1, 1)
ON DUPLICATE KEY UPDATE ativo = 1;

SELECT 'Usuário admin criado/atualizado com sucesso!' AS resultado;
SELECT 'Login: admin | Senha: admin123' AS credenciais;
