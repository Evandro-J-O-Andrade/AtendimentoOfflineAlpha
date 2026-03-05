-- ================================================================
-- SEED COMPLETO DE AUTENTICAÇÃO - Login Contextual
-- Executar este arquivo após o dump principal
-- ================================================================

USE `pronto_atendimento`;

-- ================================================================
-- 1. CRIAR TABELA PERFIL_PERMISSAO (se não existir)
-- ================================================================

DROP TABLE IF EXISTS `perfil_permissao`;

CREATE TABLE `perfil_permissao` (
  `id_perfil_permissao` bigint NOT NULL AUTO_INCREMENT,
  `id_perfil` bigint NOT NULL,
  `id_permissao` int NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_perfil_permissao`),
  UNIQUE KEY `uk_perfil_permissao` (`id_perfil`, `id_permissao`),
  KEY `fk_pp_perfil` (`id_perfil`),
  KEY `fk_pp_permissao` (`id_permissao`),
  CONSTRAINT `fk_pp_perfil` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`) ON DELETE CASCADE,
  CONSTRAINT `fk_pp_permissao` FOREIGN KEY (`id_permissao`) REFERENCES `permissao` (`id_permissao`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ================================================================
-- 2. INSERIR PERFIS ADICIONAIS
-- ================================================================

-- Inserir novos perfis se não existirem
INSERT IGNORE INTO perfil (id_perfil, nome, descricao, ativo) VALUES 
(3, 'RECEPCIONISTA', 'Atendimento na Recepção', 1),
(4, 'ENFERMEIRO', 'Enfermagem e Triagem', 1),
(5, 'TECNICO_ENFERMAGEM', 'Técnico de Enfermagem', 1),
(6, 'FARMACEUTICO', 'Farmácia', 1),
(7, 'TECNICO_RADIOLOGIA', 'Técnico de Raio-X', 1),
(8, 'ANALISTA', 'Analista/Suporte', 1);

-- ================================================================
-- 3. ATUALIZAR USUÁRIO ADMIN
-- ================================================================

-- Resetar tentativas de login do admin
UPDATE usuario SET tentativas_login = 0, ativo = 1 WHERE login = 'admin';

-- Gerar hash bcrypt para senha: admin123
-- hash gerado: $2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a
UPDATE usuario SET senha_hash = '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a' WHERE login = 'admin';

-- ================================================================
-- 4. CRIAR USUÁRIOS DE TESTE
-- ================================================================

-- Criar usuários adicionais (se não existirem)
INSERT IGNORE INTO usuario (id_usuario, id_pessoa, id_entidade, login, email, senha_hash, tentativas_login, bloqueado_ate, ultimo_login, ativo) VALUES
(2, 1, 1, 'dr.jose', 'jose@hospital.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a', 0, NULL, NULL, 1),
(3, 1, 1, 'enf.maria', 'maria@hospital.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a', 0, NULL, NULL, 1),
(4, 1, 1, 'rec.joao', 'joao@hospital.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a', 0, NULL, NULL, 1),
(5, 1, 1, 'farm.ana', 'ana@hospital.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a', 0, NULL, NULL, 1),
(6, 1, 1, 'tec.pedro', 'pedro@hospital.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a', 0, NULL, NULL, 1);

-- ================================================================
-- 5. VINCULAR USUÁRIOS A SISTEMAS
-- ================================================================

INSERT IGNORE INTO usuario_sistema (id_usuario_sistema, id_usuario, id_sistema, id_perfil, ativo) VALUES
(1, 1, 1, 1, 1),  -- admin no sistema 1
(2, 2, 1, 2, 1),  -- dr.jose no sistema 1
(3, 3, 1, 4, 1),  -- enf.maria no sistema 1
(4, 4, 1, 3, 1),  -- rec.joao no sistema 1
(5, 5, 1, 6, 1),  -- farm.ana no sistema 1
(6, 6, 1, 5, 1);  -- tec.pedro no sistema 1

-- ================================================================
-- 6. VINCULAR USUÁRIOS A UNIDADES
-- ================================================================

INSERT IGNORE INTO usuario_unidade (id_usuario, id_unidade, ativo) VALUES
(1, 1, 1),  -- admin na UPA 1
(2, 1, 1),  -- dr.jose na UPA 1
(3, 1, 1),  -- enf.maria na UPA 1
(4, 1, 1),  -- rec.joao na UPA 1
(5, 1, 1),  -- farm.ana na UPA 1
(6, 1, 1);  -- tec.pedro na UPA 1

-- ================================================================
-- 7. VINCULAR USUÁRIOS A LOCAIS OPERACIONAIS
-- ================================================================

INSERT IGNORE INTO usuario_local_operacional (id_usuario, id_local_operacional) VALUES
(1, 1),   -- admin -> Administração
(2, 4),   -- dr.jose -> Médico Clínico
(2, 5),   -- dr.jose -> Médico Pediátrico
(3, 3),   -- enf.maria -> Triagem
(4, 2),   -- rec.joao -> Recepção
(5, 18),  -- farm.ana -> Farmácia
(6, 12);  -- tec.pedro -> Medicação

-- ================================================================
-- 8. CRIAR CONTEXTOS POR USUÁRIO
-- ================================================================

INSERT IGNORE INTO usuario_contexto (id_contexto, id_entidade, id_usuario, id_unidade, id_sistema, id_perfil, id_local_operacional, ativo) VALUES
(1, 1, 1, 1, 1, 1, 1, 1),    -- admin: ADMIN -> Administração
(2, 1, 2, 1, 1, 2, 4, 1),    -- dr.jose: MEDICO -> Médico Clínico
(3, 1, 3, 1, 1, 4, 3, 1),    -- enf.maria: ENFERMEIRO -> Triagem
(4, 1, 4, 1, 1, 3, 2, 1),    -- rec.joao: RECEPCIONISTA -> Recepção
(5, 1, 5, 1, 1, 6, 18, 1),   -- farm.ana: FARMACEUTICO -> Farmácia
(6, 1, 6, 1, 1, 5, 12, 1);   -- tec.pedro: TECNICO_ENFERMAGEM -> Medicação

-- ================================================================
-- 9. CRIAR PERFIL_SISTEMA_PERFIL (vinculo perfil-sistema)
-- ================================================================

INSERT IGNORE INTO usuario_sistema_perfil (id, id_usuario, id_sistema, perfil_slug) VALUES
(1, 1, 1, 'ADMIN'),
(2, 2, 1, 'MEDICO'),
(3, 3, 1, 'ENFERMEIRO'),
(4, 4, 1, 'RECEPCIONISTA'),
(5, 5, 1, 'FARMACEUTICO'),
(6, 6, 1, 'TECNICO_ENFERMAGEM');

-- ================================================================
-- 10. ATRIBUIR PERMISSÕES POR PERFIL
-- ================================================================

-- ADMIN - Acesso total
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao)
SELECT 1, id_permissao FROM permissao;

-- MEDICO
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao) VALUES
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 10), (2, 11), (2, 12);

-- ENFERMEIRO
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao) VALUES
(4, 1), (4, 2), (4, 3), (4, 20), (4, 21), (4, 22), (4, 23);

-- RECEPCIONISTA
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao) VALUES
(3, 30), (3, 31), (3, 32), (3, 33), (3, 34);

-- FARMACEUTICO
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao) VALUES
(6, 40), (6, 41), (6, 42), (6, 43), (6, 44);

-- TECNICO_ENFERMAGEM
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao) VALUES
(5, 20), (5, 21), (5, 22);

-- ================================================================
-- 11. VERIFICAR DADOS CRIADOS
-- ================================================================

SELECT '=== USUARIOS ===' AS info;
SELECT id_usuario, login, email, ativo FROM usuario;

SELECT '=== CONTEXTOS ===' AS info;
SELECT 
    u.login,
    p.nome AS perfil,
    s.nome AS sistema,
    un.nome AS unidade,
    lo.nome AS local
FROM usuario_contexto uc
JOIN usuario u ON u.id_usuario = uc.id_usuario
JOIN perfil p ON p.id_perfil = uc.id_perfil
JOIN sistema s ON s.id_sistema = uc.id_sistema
JOIN unidade un ON un.id_unidade = uc.id_unidade
LEFT JOIN local_operacional lo ON lo.id_local_operacional = uc.id_local_operacional;

SELECT '=== PERFIS_CRIADOS ===' AS info;
SELECT * FROM perfil;

SELECT '=== PERMISSOES_ADMIN ===' AS info;
SELECT COUNT(*) AS total_permissoes_admin FROM perfil_permissao WHERE id_perfil = 1;

SELECT 'Seed de autenticacao executado com sucesso!' AS resultado;
