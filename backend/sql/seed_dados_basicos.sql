-- Script para criar dados básicos essenciais para o login funcionar
-- Execute no banco de dados MySQL

-- 1. Verificar se existe sistema
SELECT * FROM sistema LIMIT 1;

-- 2. Criar sistema padrão se não existir
INSERT INTO sistema (id_sistema, nome, descricao, ativo)
SELECT 1, 'PRONTO_ATENDIMENTO', 'Sistema de Pronto Atendimento', 1
WHERE NOT EXISTS (SELECT 1 FROM sistema WHERE id_sistema = 1);

-- 3. Verificar se existe unidade
SELECT * FROM unidade LIMIT 1;

-- 4. Criar unidade padrão se não existir
INSERT INTO unidade (id_unidade, id_sistema, nome, cnpj, endereco, ativo)
SELECT 1, 1, 'UPA CENTRAL', '00.000.000/0001-00', 'Rua Principal, 100', 1
WHERE NOT EXISTS (SELECT 1 FROM unidade WHERE id_unidade = 1);

-- 5. Verificar se existe local
SELECT * FROM local_operacional LIMIT 1;

-- 6. Criar locais operacionais padrão
INSERT INTO local_operacional (id_local_operacional, id_sistema, id_unidade, descricao, tipo, ativo)
SELECT 1, 1, 1, 'RECEPÇÃO', 'RECEPCAO', 1 WHERE NOT EXISTS (SELECT 1 FROM local_operacional WHERE id_local_operacional = 1);

INSERT INTO local_operacional (id_local_operacional, id_sistema, id_unidade, descricao, tipo, ativo)
SELECT 2, 1, 1, 'TRIAGEM', 'TRIAGEM', 1 WHERE NOT EXISTS (SELECT 1 FROM local_operacional WHERE id_local_operacional = 2);

INSERT INTO local_operacional (id_local_operacional, id_sistema, id_unidade, descricao, tipo, ativo)
SELECT 3, 1, 1, 'CONSULTÓRIO 1', 'MEDICO_CLINICO', 1 WHERE NOT EXISTS (SELECT 1 FROM local_operacional WHERE id_local_operacional = 3);

INSERT INTO local_operacional (id_local_operacional, id_sistema, id_unidade, descricao, tipo, ativo)
SELECT 4, 1, 1, 'CONSULTÓRIO 2', 'MEDICO_CLINICO', 1 WHERE NOT EXISTS (SELECT 1 FROM local_operacional WHERE id_local_operacional = 4);

INSERT INTO local_operacional (id_local_operacional, id_sistema, id_unidade, descricao, tipo, ativo)
SELECT 5, 1, 1, 'SALA DE MEDICAÇÃO', 'MEDICACAO', 1 WHERE NOT EXISTS (SELECT 1 FROM local_operacional WHERE id_local_operacional = 5);

INSERT INTO local_operacional (id_local_operacional, id_sistema, id_unidade, descricao, tipo, ativo)
SELECT 6, 1, 1, 'FARMÁCIA', 'FARMACIA', 1 WHERE NOT EXISTS (SELECT 1 FROM local_operacional WHERE id_local_operacional = 6);

INSERT INTO local_operacional (id_local_operacional, id_sistema, id_unidade, descricao, tipo, ativo)
SELECT 7, 1, 1, 'LABORATÓRIO', 'LABORATORIO', 1 WHERE NOT EXISTS (SELECT 1 FROM local_operacional WHERE id_local_operacional = 7);

INSERT INTO local_operacional (id_local_operacional, id_sistema, id_unidade, descricao, tipo, ativo)
SELECT 8, 1, 1, 'RAIO-X', 'RX', 1 WHERE NOT EXISTS (SELECT 1 FROM local_operacional WHERE id_local_operacional = 8);

-- 7. Verificar perfil
SELECT * FROM perfil WHERE id_perfil = 1;

-- 8. Criar perfil ADMIN se não existir
INSERT INTO perfil (id_perfil, nome, descricao, ativo)
SELECT 1, 'ADMIN', 'Administrador do Sistema', 1
WHERE NOT EXISTS (SELECT 1 FROM perfil WHERE id_perfil = 1);

-- 9. Vincular usuario ao perfil
INSERT INTO usuario_perfil (id_usuario, id_perfil, ativo)
SELECT 1, 1, 1
WHERE NOT EXISTS (SELECT 1 FROM usuario_perfil WHERE id_usuario = 1 AND id_perfil = 1);

-- 10. Criar contexto do usuário
INSERT INTO usuario_contexto (id_usuario, id_unidade, id_local_operacional, id_perfil, id_sistema, ativo)
SELECT 1, 1, 1, 1, 1, 1
WHERE NOT EXISTS (SELECT 1 FROM usuario_contexto WHERE id_usuario = 1 AND id_perfil = 1);

-- Verificar dados criados
SELECT 'Sistema' as tipo, COUNT(*) as total FROM sistema
UNION ALL
SELECT 'Unidade', COUNT(*) FROM unidade
UNION ALL
SELECT 'Local', COUNT(*) FROM local_operacional
UNION ALL
SELECT 'Perfil', COUNT(*) FROM perfil
UNION ALL
SELECT 'Usuario Perfil', COUNT(*) FROM usuario_perfil
UNION ALL
SELECT 'Usuario Contexto', COUNT(*) FROM usuario_contexto;
