-- ================================================================
-- Script para garantir dados mínimos do sistema
-- Execute este script para criar contextos automaticamente
-- ================================================================

-- Verifica se existe pelo menos um sistema
SELECT * FROM sistema LIMIT 1;

-- Se não existir, cria o sistema padrão
INSERT IGNORE INTO sistema (id_sistema, nome, sigla, ativo) 
VALUES (1, 'Gestão Alpha', 'GPA', 1);

-- Verifica se existe pelo menos uma unidade
SELECT * FROM unidade LIMIT 1;

-- Se não existir, cria a unidade padrão
INSERT IGNORE INTO unidade (id_unidade, nome, ativo) 
VALUES (1, 'Hospital Guido Guida', 1);

-- Verifica se existe pelo menos um perfil
SELECT * FROM perfil LIMIT 1;

-- Se não existir, cria os perfis padrão
INSERT IGNORE INTO perfil (id_perfil, nome, ativo) VALUES (1, 'ADMINISTRADOR', 1);
INSERT IGNORE INTO perfil (id_perfil, nome, ativo) VALUES (2, 'MEDICO', 1);
INSERT IGNORE INTO perfil (id_perfil, nome, ativo) VALUES (3, 'ENFERMEIRO', 1);
INSERT IGNORE INTO perfil (id_perfil, nome, ativo) VALUES (4, 'RECEPCIONISTA', 1);
INSERT IGNORE INTO perfil (id_perfil, nome, ativo) VALUES (5, 'TECNICO_ENFERMAGEM', 1);
INSERT IGNORE INTO perfil (id_perfil, nome, ativo) VALUES (6, 'FARMACEUTICO', 1);

-- Verifica se existe pelo menos um local operacional
SELECT * FROM local_operacional LIMIT 1;

-- Se não existir, cria os locais operacionais padrão
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (1, 'Administração', 'ADMINISTRACAO', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (2, 'Recepção', 'RECEPCAO', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (3, 'Triagem', 'TRIAGEM', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (4, 'Consultório 1', 'CONSULTORIO', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (5, 'Consultório 2', 'CONSULTORIO', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (6, 'Sala de Medicação', 'SALAMEDICACAO', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (7, 'Farmácia', 'FARMACIA', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (8, 'Raio-X', 'RAIOX', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (9, 'ECG', 'ECG', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (10, 'Coleta', 'COLETA', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (11, 'Observação', 'OBSERVACAO', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (12, 'Ala Masculina', 'ENFERMARIA', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (13, 'Ala Feminina', 'ENFERMARIA', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (14, 'Pediatria', 'PEDIATRIA', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (15, 'Geral', 'PRONTO_SOCORRO', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (16, 'Almoxarifado', 'ALMOXARIFADO', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (17, 'Painel', 'PAINEL', 1);
INSERT IGNORE INTO local_operacional (id_local_operacional, nome, tipo, ativo) VALUES (18, 'Totem', 'TOTEM', 1);

-- Cria contextos para todos os usuários ativos
-- Para cada usuário, cria contexto com todas as combinações

-- Primeiro, vincula usuários às tabelas de acesso se não existirem
INSERT IGNORE INTO usuario_sistema (id_usuario, id_sistema, id_perfil, ativo)
SELECT u.id_usuario, 1, 1, 1
FROM usuario u WHERE u.ativo = 1
AND NOT EXISTS (SELECT 1 FROM usuario_sistema WHERE id_usuario = u.id_usuario);

INSERT IGNORE INTO usuario_unidade (id_usuario, id_unidade, ativo)
SELECT u.id_usuario, 1, 1
FROM usuario u WHERE u.ativo = 1
AND NOT EXISTS (SELECT 1 FROM usuario_unidade WHERE id_usuario = u.id_usuario);

INSERT IGNORE INTO usuario_local_operacional (id_usuario, id_local_operacional)
SELECT u.id_usuario, 1
FROM usuario u WHERE u.ativo = 1
AND NOT EXISTS (SELECT 1 FROM usuario_local_operacional WHERE id_usuario = u.id_usuario);

-- Cria contexto para cada usuário
INSERT IGNORE INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)
SELECT u.id_usuario, 1, 1, 1, COALESCE(us.id_perfil, 1), 1
FROM usuario u
LEFT JOIN usuario_sistema us ON us.id_usuario = u.id_usuario AND us.id_sistema = 1
WHERE u.ativo = 1
AND NOT EXISTS (
    SELECT 1 FROM usuario_contexto WHERE id_usuario = u.id_usuario
);

-- Verifica os contextos criados
SELECT 
    u.id_usuario,
    u.login,
    u.nome,
    uc.id_sistema,
    uc.id_unidade,
    uc.id_local_operacional,
    uc.id_perfil,
    p.nome as perfil_nome
FROM usuario u
LEFT JOIN usuario_contexto uc ON uc.id_usuario = u.id_usuario
LEFT JOIN perfil p ON p.id_perfil = uc.id_perfil
WHERE u.ativo = 1
LIMIT 20;
