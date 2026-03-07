-- ================================================================
-- VERIFICAR USUÁRIOS NO BANCO
-- Execute este script para verificar se os usuários existem
-- ================================================================

USE `pronto_atendimento`;

-- Verificar se a tabela usuario existe e tem dados
SELECT '=== TABELA USUARIO ===' AS info;
SELECT id_usuario, login, email, ativo, tentativas_login, bloqueado_ate FROM usuario;

-- Verificar se a tabela perfil existe e tem dados
SELECT '=== TABELA PERFIL ===' AS info;
SELECT * FROM perfil;

-- Verificar se a tabela sistema existe
SELECT '=== TABELA SISTEMA ===' AS info;
SELECT * FROM sistema;

-- Verificar se a tabela usuario_sistema existe
SELECT '=== TABELA USUARIO_SISTEMA ===' AS info;
SELECT * FROM usuario_sistema;

-- Verificar se a tabela unidade existe
SELECT '=== TABELA UNIDADE ===' AS info;
SELECT * FROM unidade;

-- Verificar se a tabela local_operacional existe
SELECT '=== TABELA LOCAL_OPERACIONAL ===' AS info;
SELECT * FROM local_operacional;

-- Verificar se a tabela sessao_usuario existe
SELECT '=== TABELA SESSAO_USUARIO ===' AS info;
SELECT id_sessao_usuario, id_usuario, ativo, expira_em FROM sessao_usuario LIMIT 10;
