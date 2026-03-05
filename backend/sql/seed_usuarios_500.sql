-- ================================================================
-- SEED DE 500 USUÁRIOS PARA TESTE
-- Execute este arquivo para criar usuários de teste
-- ================================================================

USE `pronto_atendimento`;

-- ================================================================
-- 1. CRIAR PROCEDURE PARA GERAR USUÁRIOS
-- ================================================================

DELIMITER $$

DROP PROCEDURE IF EXISTS seed_usuarios_teste$$

CREATE PROCEDURE seed_usuarios_teste()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE nome VARCHAR(100);
    DECLARE login_valor VARCHAR(50);
    DECLARE perfil_id INT;
    
    -- Limpar usuários de teste anteriores (manter admin)
    DELETE FROM usuario WHERE login != 'admin';
    DELETE FROM usuario_perfil WHERE id_usuario > 1;
    DELETE FROM usuario_unidade WHERE id_usuario > 1;
    DELETE FROM usuario_sistema WHERE id_usuario > 1;
    DELETE FROM usuario_local_operacional WHERE id_usuario > 1;
    DELETE FROM usuario_contexto WHERE id_usuario > 1;
    
    -- Loop para criar 500 usuários
    WHILE i <= 500 DO
        -- Gerar nome aleatório
        SET nome = CONCAT(
            ELT(FLOOR(1 + RAND() * 10), 'João', 'Maria', 'José', 'Ana', 'Pedro', 'Paulo', 'Lucas', 'Fernanda', 'Carla', 'Roberto'),
            ' ',
            ELT(FLOOR(1 + RAND() * 15), 'Silva', 'Santos', 'Oliveira', 'Souza', 'Lima', 'Pereira', 'Almeida', 'Nascimento', 'Melo', 'Costa', 'Rodrigues', 'Ferreira', 'Araujo', 'Cardoso', 'Teixeira')
        );
        
        -- Gerar login
        SET login_valor = CONCAT(
            ELT(FLOOR(1 + RAND() * 6), 'medico', 'enfermeiro', 'recepcionista', 'tecnico', 'farmaceutico', 'admin'),
            LPAD(i, 4, '0')
        );
        
        -- Atribuir perfil baseado no tipo
        SET perfil_id = ELT(FLOOR(1 + RAND() * 6), 2, 3, 4, 5, 6, 1); -- MEDICO, ENFERMEIRO, RECEPCIONISTA, TECNICO, FARMACEUTICO, ADMIN
        
        -- Inserir usuário
        INSERT INTO usuario (id_usuario, nome, login, senha_hash, email, ativo, criado_em)
        VALUES (
            i + 1,
            nome,
            login_valor,
            '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a', -- senha: admin123
            CONCAT(login_valor, '@hospital.com'),
            1,
            NOW()
        );
        
        -- Vincular a unidade 1 (UPA)
        INSERT IGNORE INTO usuario_unidade (id_usuario, id_unidade, ativo)
        VALUES (i + 1, 1, 1);
        
        -- Vincular ao sistema 1
        INSERT IGNORE INTO usuario_sistema (id_usuario_sistema, id_usuario, id_sistema, id_perfil, ativo)
        VALUES (i + 1, i + 1, 1, perfil_id, 1);
        
        -- Vincular a um local operacional
        INSERT IGNORE INTO usuario_local_operacional (id_usuario, id_local_operacional)
        VALUES (i + 1, FLOOR(1 + RAND() * 20));
        
        SET i = i + 1;
    END WHILE;

END$$

DELIMITER ;

-- ================================================================
-- 2. EXECUTAR PROCEDURE
-- ================================================================

CALL seed_usuarios_teste();

-- ================================================================
-- 3. CRIAR USUÁRIOS IMPORTANTES PARA TESTE (sobrescrever alguns)
-- ================================================================

-- Admin principal
UPDATE usuario SET nome = 'Administrador Geral', login = 'admin', senha_hash = '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a' WHERE login = 'admin';

-- Criar usuários de teste importantes
INSERT INTO usuario (id_usuario, nome, login, senha_hash, email, ativo, criado_em)
VALUES 
(1001, 'Dr. João Silva', 'medico', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a', 'medico@hospital.com', 1, NOW())
ON DUPLICATE KEY UPDATE nome = 'Dr. João Silva';

INSERT IGNORE INTO usuario_unidade (id_usuario, id_unidade, ativo) VALUES (1001, 1, 1);
INSERT IGNORE INTO usuario_sistema (id_usuario_sistema, id_usuario, id_sistema, id_perfil, ativo) VALUES (1001, 1001, 1, 2, 1);
INSERT IGNORE INTO usuario_local_operacional (id_usuario, id_local_operacional) VALUES (1001, 4);

INSERT INTO usuario (id_usuario, nome, login, senha_hash, email, ativo, criado_em)
VALUES 
(1002, 'Maria Enfermeira', 'enfermeiro', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a', 'enfermeiro@hospital.com', 1, NOW())
ON DUPLICATE KEY UPDATE nome = 'Maria Enfermeira';

INSERT IGNORE INTO usuario_unidade (id_usuario, id_unidade, ativo) VALUES (1002, 1, 1);
INSERT IGNORE INTO usuario_sistema (id_usuario_sistema, id_usuario, id_sistema, id_perfil, ativo) VALUES (1002, 1002, 1, 3, 1);
INSERT IGNORE INTO usuario_local_operacional (id_usuario, id_local_operacional) VALUES (1002, 3);

INSERT INTO usuario (id_usuario, nome, login, senha_hash, email, ativo, criado_em)
VALUES 
(1003, 'João Recepcionista', 'recepcao', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a', 'recepcao@hospital.com', 1, NOW())
ON DUPLICATE KEY UPDATE nome = 'João Recepcionista';

INSERT IGNORE INTO usuario_unidade (id_usuario, id_unidade, ativo) VALUES (1003, 1, 1);
INSERT IGNORE INTO usuario_sistema (id_usuario_sistema, id_usuario, id_sistema, id_perfil, ativo) VALUES (1003, 1003, 1, 4, 1);
INSERT IGNORE INTO usuario_local_operacional (id_usuario, id_local_operacional) VALUES (1003, 2);

INSERT INTO usuario (id_usuario, nome, login, senha_hash, email, ativo, criado_em)
VALUES 
(1004, 'Ana Farmacêutica', 'farmacia', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a', 'farmacia@hospital.com', 1, NOW())
ON DUPLICATE KEY UPDATE nome = 'Ana Farmacêutica';

INSERT IGNORE INTO usuario_unidade (id_usuario, id_unidade, ativo) VALUES (1004, 1, 1);
INSERT IGNORE INTO usuario_sistema (id_usuario_sistema, id_usuario, id_sistema, id_perfil, ativo) VALUES (1004, 1004, 1, 6, 1);
INSERT IGNORE INTO usuario_local_operacional (id_usuario, id_local_operacional) VALUES (1004, 18);

-- ================================================================
-- 4. CRIAR CONTEXTOS PARA USUÁRIOS DE TESTE
-- ================================================================

-- Contextos para admin
INSERT IGNORE INTO usuario_contexto (id_entidade, id_usuario, id_unidade, id_sistema, id_perfil, id_local_operacional, ativo)
VALUES (1, 1, 1, 1, 1, 1, 1);

-- Contextos para médico
INSERT IGNORE INTO usuario_contexto (id_entidade, id_usuario, id_unidade, id_sistema, id_perfil, id_local_operacional, ativo)
VALUES (1, 1001, 1, 1, 2, 4, 1);

-- Contextos para enfermeiro
INSERT IGNORE INTO usuario_contexto (id_entidade, id_usuario, id_unidade, id_sistema, id_perfil, id_local_operacional, ativo)
VALUES (1, 1002, 1, 1, 3, 3, 1);

-- Contextos para recepção
INSERT IGNORE INTO usuario_contexto (id_entidade, id_usuario, id_unidade, id_sistema, id_perfil, id_local_operacional, ativo)
VALUES (1, 1003, 1, 1, 4, 2, 1);

-- Contextos para farmácia
INSERT IGNORE INTO usuario_contexto (id_entidade, id_usuario, id_unidade, id_sistema, id_perfil, id_local_operacional, ativo)
VALUES (1, 1004, 1, 1, 6, 18, 1);

-- ================================================================
-- 5. VERIFICAR USUÁRIOS CRIADOS
-- ================================================================

SELECT 'Total de usuários:' AS info, COUNT(*) AS total FROM usuario;

SELECT 'Usuários de teste importantes:' AS info;
SELECT id_usuario, nome, login, email FROM usuario WHERE id_usuario IN (1, 1001, 1002, 1003, 1004);

SELECT 'Perfis distribuidos:' AS info;
SELECT p.nome AS perfil, COUNT(*) AS total 
FROM usuario_perfil up 
JOIN perfil p ON p.id_perfil = up.id_perfil 
GROUP BY p.nome;

SELECT 'Seed de 500 usuários executado com sucesso!' AS resultado;
