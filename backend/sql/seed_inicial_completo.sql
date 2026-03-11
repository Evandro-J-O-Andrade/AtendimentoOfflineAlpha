-- ================================================================
-- SEED INICIAL COMPLETO - SISTEMA PRONTO ATENDIMENTO
-- Executar este arquivo para popular o banco e testar o frontend
-- ================================================================

USE `pronto_atendimento`;

-- ================================================================
-- 1. GARANTIR UNIDADE PADRÃO
-- ================================================================

-- Verificar se existe unidade, se não cria
INSERT INTO unidade (id_unidade, nome, cnes, ativo)
SELECT 1, 'UPA Principal', '1234567', 1
WHERE NOT EXISTS (SELECT 1 FROM unidade WHERE id_unidade = 1);

-- ================================================================
-- 2. GARANTIR SISTEMA PADRÃO
-- ================================================================

INSERT INTO sistema (id_sistema, nome, descricao, ativo)
SELECT 1, 'PRONTO_ATENDIMENTO', 'Sistema de Pronto Atendimento', 1
WHERE NOT EXISTS (SELECT 1 FROM sistema WHERE id_sistema = 1);

-- ================================================================
-- 3. GARANTIR PERFIS BÁSICOS
-- ================================================================

INSERT INTO perfil (id_perfil, nome, descricao, ativo) VALUES
(1, 'ADMIN', 'Administrador do Sistema', 1),
(2, 'MEDICO', 'Médico', 1),
(3, 'ENFERMEIRO', 'Enfermeiro', 1),
(4, 'RECEPCIONISTA', 'Recepcionista', 1),
(5, 'TECNICO_ENFERMAGEM', 'Técnico de Enfermagem', 1),
(6, 'FARMACEUTICO', 'Farmacêutico', 1),
(7, 'ADMINISTRATIVO', 'Pessoal Administrativo', 1),
(8, 'SUPORTE_TI', 'Suporte de TI', 1),
(9, 'DIRETOR', 'Diretor Clínico', 1),
(10, 'PEDAGOGICO', 'Pedagógico', 1)
ON DUPLICATE KEY UPDATE nome = VALUES(nome);

-- ================================================================
-- 4. GARANTIR LOCAIS OPERACIONAIS
-- ================================================================

INSERT INTO local_operacional (id_local_operacional, id_unidade, nome, tipo, complexidade, exibe_em_painel_publico, gera_tts_publico, ativo) VALUES
(1, 1, 'Recepção', 'RECEPCAO', 'BASICA', 1, 1, 1),
(2, 1, 'Triagem', 'TRIAGEM', 'MEDIA', 1, 1, 1),
(3, 1, 'Consultório 1', 'CONSULTORIO', 'ALTA', 1, 1, 1),
(4, 1, 'Consultório 2', 'CONSULTORIO', 'ALTA', 1, 1, 1),
(5, 1, 'Consultório 3', 'CONSULTORIO', 'ALTA', 1, 1, 1),
(6, 1, 'Consultório Pediátrico', 'CONSULTORIO', 'ALTA', 1, 1, 1),
(7, 1, 'Sala de Medicação', 'MEDICACAO', 'MEDIA', 1, 1, 1),
(8, 1, 'Farmácia', 'FARMACIA', 'MEDIA', 0, 0, 1),
(9, 1, 'Sala de Gesso', 'PROCEDIMENTO', 'MEDIA', 0, 0, 1),
(10, 1, 'Sala de Raio-X', 'RX', 'ALTA', 0, 0, 1),
(11, 1, 'Laboratório', 'LABORATORIO', 'ALTA', 0, 0, 1),
(12, 1, 'Sala de Observação', 'OBSERVACAO', 'ALTA', 0, 0, 1),
(13, 1, 'Não Definido', 'NAO_DEFINIDO', 'BASICA', 0, 0, 1)
ON DUPLICATE KEY UPDATE nome = VALUES(nome);

-- ================================================================
-- 5. CRIAR USUÁRIOS DE TESTE
-- ================================================================

-- Usuário Admin (ID 1)
INSERT INTO usuario (id_usuario, id_pessoa, login, senha_hash, ativo, primeiro_login, criado_em)
SELECT 1, 1, 'admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.RSGr2F/.LhGiR5J2u', 1, 0, NOW()
WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = 1);

-- Recepcionista (ID 2)
INSERT INTO usuario (id_usuario, id_pessoa, login, senha_hash, ativo, primeiro_login, criado_em) VALUES
(2, 2, 'recepcao.req', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.RSGr2F/.LhGiR5J2u', 1, 0, NOW())
ON DUPLICATE KEY UPDATE login = VALUES(login);

-- Enfermeiro Chefe (ID 3)
INSERT INTO usuario (id_usuario, id_pessoa, login, senha_hash, ativo, primeiro_login, criado_em) VALUES
(3, 3, 'enfermeiro.chefe', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.RSGr2F/.LhGiR5J2u', 1, 0, NOW())
ON DUPLICATE KEY UPDATE login = VALUES(login);

-- Médico Clínico (ID 4)
INSERT INTO usuario (id_usuario, id_pessoa, login, senha_hash, ativo, primeiro_login, criado_em) VALUES
(4, 4, 'medico.clinico', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.RSGr2F/.LhGiR5J2u', 1, 0, NOW())
ON DUPLICATE KEY UPDATE login = VALUES(login);

-- Médico Pediatra (ID 5)
INSERT INTO usuario (id_usuario, id_pessoa, login, senha_hash, ativo, primeiro_login, criado_em) VALUES
(5, 5, 'medico.pediatra', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.RSGr2F/.LhGiR5J2u', 1, 0, NOW())
ON DUPLICATE KEY UPDATE login = VALUES(login);

-- Técnico de Enfermagem (ID 6)
INSERT INTO usuario (id_usuario, id_pessoa, login, senha_hash, ativo, primeiro_login, criado_em) VALUES
(6, 6, 'tecnico.enfermagem', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.RSGr2F/.LhGiR5J2u', 1, 0, NOW())
ON DUPLICATE KEY UPDATE login = VALUES(login);

-- Farmacêutico (ID 7)
INSERT INTO usuario (id_usuario, id_pessoa, login, senha_hash, ativo, primeiro_login, criado_em) VALUES
(7, 7, 'farmaceutico', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.RSGr2F/.LhGiR5J2u', 1, 0, NOW())
ON DUPLICATE KEY UPDATE login = VALUES(login);

-- ================================================================
-- 6. CRIAR PESSOAS PARA USUÁRIOS
-- ================================================================

-- Admin
INSERT INTO pessoa (id_pessoa, nome_completo, cpf, data_nascimento, sexo, email, telefone, ativo)
VALUES (1, 'Administrador do Sistema', '00000000000', '1980-01-01', 'M', 'admin@upa.com', '11999999999', 1)
ON DUPLICATE KEY UPDATE nome_completo = VALUES(nome_completo);

-- Recepcionista
INSERT INTO pessoa (id_pessoa, nome_completo, cpf, data_nascimento, sexo, email, telefone, ativo)
VALUES (2, 'Maria da Conceição', '11111111111', '1990-05-15', 'F', 'maria.conceicao@upa.com', '11988888888', 1)
ON DUPLICATE KEY UPDATE nome_completo = VALUES(nome_completo);

-- Enfermeiro
INSERT INTO pessoa (id_pessoa, nome_completo, cpf, data_nascimento, sexo, email, telefone, ativo)
VALUES (3, 'José Silva Santos', '22222222222', '1985-08-20', 'M', 'jose.silva@upa.com', '11977777777', 1)
ON DUPLICATE KEY UPDATE nome_completo = VALUES(nome_completo);

-- Médico Clínico
INSERT INTO pessoa (id_pessoa, nome_completo, cpf, data_nascimento, sexo, email, telefone, ativo)
VALUES (4, 'Dr. Pedro Alves', '33333333333', '1975-03-10', 'M', 'pedro.alves@upa.com', '11966666666', 1)
ON DUPLICATE KEY UPDATE nome_completo = VALUES(nome_completo);

-- Médico Pediatra
INSERT INTO pessoa (id_pessoa, nome_completo, cpf, data_nascimento, sexo, email, telefone, ativo)
VALUES (5, 'Dra. Ana Paula', '44444444444', '1980-11-25', 'F', 'ana.paula@upa.com', '11955555555', 1)
ON DUPLICATE KEY UPDATE nome_completo = VALUES(nome_completo);

-- Técnico de Enfermagem
INSERT INTO pessoa (id_pessoa, nome_completo, cpf, data_nascimento, sexo, email, telefone, ativo)
VALUES (6, 'Carlos Oliveira', '55555555555', '1995-02-14', 'M', 'carlos.oliveira@upa.com', '11944444444', 1)
ON DUPLICATE KEY UPDATE nome_completo = VALUES(nome_completo);

-- Farmac INTO pessoa (idêutico
INSERT_pessoa, nome_completo, cpf, data_nascimento, sexo, email, telefone, ativo)
VALUES (7, 'Fernanda Lima', '66666666666', '1988-07-30', 'F', 'fernanda.lima@upa.com', '11933333333', 1)
ON DUPLICATE KEY UPDATE nome_completo = VALUES(nome_completo);

-- ================================================================
-- 7. CRIAR PACIENTES DE TESTE
-- ================================================================

INSERT INTO pessoa (id_pessoa, nome_completo, cpf, cns, data_nascimento, sexo, nome_mae, email, telefone, ativo) VALUES
(101, 'João Pedro Santos', '12345678901', '123456789012345', '1985-03-15', 'M', 'Maria Santos', 'joao.santos@email.com', '11911111111', 1),
(102, 'Ana Carolina Oliveira', '23456789012', '234567890123456', '1990-07-22', 'F', 'José Oliveira', 'ana.oliveira@email.com', '11922222222', 1),
(103, 'Carlos Eduardo Silva', '34567890123', '345678901234567', '1978-11-08', 'M', 'Pedro Silva', 'carlos.silva@email.com', '11933333333', 1),
(104, 'Maria Helena Costa', '45678901234', '456789012345678', '2010-05-18', 'F', 'Lucas Costa', 'maria.costa@email.com', '11944444444', 1),
(105, 'Pedro Henrique Alves', '56789012345', '567890123456789', '2015-09-12', 'M', 'Ana Alves', 'pedro.alves@email.com', '11955555555', 1),
(106, 'Juliana Ferreira', '67890123456', '678901234567890', '1992-01-30', 'F', 'Carlos Ferreira', 'juliana.ferreira@email.com', '11966666666', 1),
(107, 'Roberto Carlos', '78901234567', '789012345678901', '1965-04-25', 'M', 'Francisco Carlos', 'roberto.carlos@email.com', '11977777777', 1),
(108, 'Carla Souza', '89012345678', '890123456789012', '1988-12-05', 'F', 'Paulo Souza', 'carla.souza@email.com', '11988888888', 1),
(109, 'Lucas Martins', '90123456789', '901234567890123', '2020-06-14', 'M', 'Fernanda Martins', 'lucas.martins@email.com', '11999999999', 1),
(110, 'Beatriz Rodrigues', '01234567890', '012345678901234', '1995-08-03', 'F', 'Ricardo Rodrigues', 'beatriz.rodrigues@email.com', '11910101010', 1)
ON DUPLICATE KEY UPDATE nome_completo = VALUES(nome_completo);

-- Criar pacientes a partir das pessoas
INSERT INTO paciente (id, id_pessoa, prontuario, ativo)
SELECT 101, 101, 'PR000101', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE id = 101)
UNION ALL
SELECT 102, 102, 'PR000102', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE id = 102)
UNION ALL
SELECT 103, 103, 'PR000103', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE id = 103)
UNION ALL
SELECT 104, 104, 'PR000104', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE id = 104)
UNION ALL
SELECT 105, 105, 'PR000105', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE id = 105)
UNION ALL
SELECT 106, 106, 'PR000106', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE id = 106)
UNION ALL
SELECT 107, 107, 'PR000107', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE id = 107)
UNION ALL
SELECT 108, 108, 'PR000108', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE id = 108)
UNION ALL
SELECT 109, 109, 'PR000109', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE id = 109)
UNION ALL
SELECT 110, 110, 'PR000110', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE id = 110);

-- ================================================================
-- 8. CRIAR CONTEXTO PARA USUÁRIOS
-- ================================================================

-- Admin - Acesso a tudo
INSERT INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo) VALUES
(1, 1, 1, 1, 1, 1),
(1, 1, 1, 2, 1, 1),
(1, 1, 1, 3, 1, 1),
(1, 1, 1, 8, 1, 1)
ON DUPLICATE KEY UPDATE ativo = 1;

-- Recepcionista - Recepção
INSERT INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo) VALUES
(2, 1, 1, 1, 4, 1)
ON DUPLICATE KEY UPDATE ativo = 1;

-- Enfermeiro - Triagem e Medicação
INSERT INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo) VALUES
(3, 1, 1, 2, 3, 1),
(3, 1, 1, 7, 3, 1)
ON DUPLICATE KEY UPDATE ativo = 1;

-- Médico Clínico - Consultório 1 e 2
INSERT INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo) VALUES
(4, 1, 1, 3, 2, 1),
(4, 1, 1, 4, 2, 1)
ON DUPLICATE KEY UPDATE ativo = 1;

-- Médico Pediatra - Consultório Pediátrico
INSERT INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo) VALUES
(5, 1, 1, 6, 2, 1)
ON DUPLICATE KEY UPDATE ativo = 1;

-- Técnico de Enfermagem - Sala de Medicação
INSERT INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo) VALUES
(6, 1, 1, 7, 5, 1)
ON DUPLICATE KEY UPDATE ativo = 1;

-- Farmacêutico - Farmácia
INSERT INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo) VALUES
(7, 1, 1, 8, 6, 1)
ON DUPLICATE KEY UPDATE ativo = 1;

-- ================================================================
-- 9. VINCULAR USUÁRIOS AOS LOCAIS OPERACIONAIS
-- ================================================================

INSERT INTO usuario_local_operacional (id_usuario, id_local_operacional) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10), (1, 11), (1, 12),
(2, 1),
(3, 2), (3, 7),
(4, 3), (4, 4),
(5, 6),
(6, 7),
(7, 8)
ON DUPLICATE KEY UPDATE id_local_operacional = VALUES(id_local_operacional);

-- ================================================================
-- 10. CRIAR PAINÉIS
-- ================================================================

INSERT INTO painel (codigo, tipo, nome, id_unidade, id_sistema, intervalo_segundos, emite_som, tts_habilitado, ativo) VALUES
('PAINEL_RECEPCAO', 'PAINEL', 'Painel Recepção', 1, 1, 10, 1, 1, 1),
('PAINEL_TRIAGEM', 'PAINEL', 'Painel Triagem', 1, 1, 10, 1, 1, 1),
('PAINEL_CLINICO', 'PAINEL', 'Painel Consultório Clínico', 1, 1, 10, 1, 1, 1),
('PAINEL_PEDIATRICO', 'PAINEL', 'Painel Consultório Pediátrico', 1, 1, 10, 1, 1, 1),
('TV_ROTATIVA', 'TV', 'TV Rotativa Geral', 1, 1, 15, 1, 1, 1)
ON DUPLICATE KEY UPDATE nome = VALUES(nome);

-- ================================================================
-- 11. CRIAR MEDICAMENTOS BÁSICOS
-- ================================================================

INSERT INTO farmaco (codigo, nome, principio_ativo, concentracao, unidade_padrao, fabricante, lote, validade, preco_unitario, ativo) VALUES
('MED001', 'Dipirona Sódica 500mg', 'Dipirona Sódica', '500mg', 'COMPRIMIDO', 'Medley', 'LOTE001', '2027-12-31', 0.15, 1),
('MED002', 'Paracetamol 500mg', 'Paracetamol', '500mg', 'COMPRIMIDO', 'Medley', 'LOTE002', '2027-12-31', 0.10, 1),
('MED003', 'Ibuprofeno 600mg', 'Ibuprofeno', '600mg', 'COMPRIMIDO', 'Eurofarma', 'LOTE003', '2027-12-31', 0.25, 1),
('MED004', 'Amoxicilina 500mg', 'Amoxicilina', '500mg', 'CÁPSULA', 'Eurofarma', 'LOTE004', '2027-12-31', 0.45, 1),
('MED005', 'Dipirona 500mg/mL', 'Dipirona Sódica', '500mg/mL', 'AMPOLA', 'Hipolabor', 'LOTE005', '2027-12-31', 0.80, 1),
('MED006', 'Soro Fisiológico 0,9%', 'Cloreto de Sódio', '0,9%', 'FRASCO', 'Halex Istar', 'LOTE006', '2027-12-31', 3.50, 1),
('MED007', 'Álcool 70%', 'Álcool Etílico', '70%', 'FRASCO', 'Rioquímica', 'LOTE007', '2027-12-31', 5.00, 1),
('MED008', 'Soro Glicosado 5%', 'Glicose', '5%', 'FRASCO', 'Halex Istar', 'LOTE008', '2027-12-31', 4.00, 1),
('MED009', 'Omeprazol 20mg', 'Omeprazol', '20mg', 'CÁPSULA', 'Eurofarma', 'LOTE009', '2027-12-31', 0.35, 1),
('MED010', 'Ranitidina 150mg', 'Ranitidina', '150mg', 'COMPRIMIDO', 'Medley', 'LOTE010', '2027-12-31', 0.28, 1)
ON DUPLICATE KEY UPDATE nome = VALUES(nome);

-- Criar lotes para medicamentos
INSERT INTO farmaco_lote (id_farmaco, lote, fabricacao, validade, quantidade, quantidade_saldo, status, nf_entrada, ativo) VALUES
(1, 'LOTE001', '2025-01-01', '2027-12-31', 10000, 10000, 'ATIVO', 'NF001', 1),
(2, 'LOTE002', '2025-01-01', '2027-12-31', 15000, 15000, 'ATIVO', 'NF002', 1),
(3, 'LOTE003', '2025-01-01', '2027-12-31', 8000, 8000, 'ATIVO', 'NF003', 1),
(4, 'LOTE004', '2025-01-01', '2027-12-31', 5000, 5000, 'ATIVO', 'NF004', 1),
(5, 'LOTE005', '2025-01-01', '2027-12-31', 3000, 3000, 'ATIVO', 'NF005', 1),
(6, 'LOTE006', '2025-01-01', '2027-12-31', 2000, 2000, 'ATIVO', 'NF006', 1),
(7, 'LOTE007', '2025-01-01', '2027-12-31', 1000, 1000, 'ATIVO', 'NF007', 1),
(8, 'LOTE008', '2025-01-01', '2027-12-31', 1500, 1500, 'ATIVO', 'NF008', 1),
(9, 'LOTE009', '2025-01-01', '2027-12-31', 6000, 6000, 'ATIVO', 'NF009', 1),
(10, 'LOTE010', '2025-01-01', '2027-12-31', 7000, 7000, 'ATIVO', 'NF010', 1)
ON DUPLICATE KEY UPDATE quantidade_saldo = VALUES(quantidade_saldo);

-- ================================================================
-- 12. CRIAR ALGUMAS SENHAS INICIAIS
-- ================================================================

INSERT INTO senhas (id_sistema, id_unidade, numero, prefixo, codigo, data_ref, status, tipo_atendimento, prioridade, origem, id_local_operacional, criada_em) VALUES
(1, 1, 1, 'A', 'A001', CURDATE(), 'AGUARDANDO', 'CLINICO', 0, 'TOTEM', 1, NOW()),
(1, 1, 2, 'A', 'A002', CURDATE(), 'AGUARDANDO', 'CLINICO', 0, 'TOTEM', 1, NOW()),
(1, 1, 3, 'P', 'P001', CURDATE(), 'AGUARDANDO', 'PEDIATRICO', 0, 'TOTEM', 1, NOW()),
(1, 1, 4, 'A', 'A003', CURDATE(), 'CHAMANDO', 'CLINICO', 0, 'RECEPCAO', 3, NOW())
ON DUPLICATE KEY UPDATE status = VALUES(status);

-- ================================================================
-- 13. CRIAR FILA OPERACIONAL COM ALGUNS PACIENTES
-- ================================================================

-- Inserir na fila de recepção
INSERT INTO fila_operacional (id_ffa, id_paciente, id_unidade, id_local_operacional, tipo, substatus, prioridade, posicao, data_entrada, entrada_original_em) VALUES
(1, 101, 1, 1, 'RECEPCAO', 'AGUARDANDO', 'VERDE', 1, NOW(), NOW()),
(2, 102, 1, 1, 'RECEPCAO', 'AGUARDANDO', 'AMARELO', 2, NOW(), NOW())
ON DUPLICATE KEY UPDATE substatus = VALUES(substatus);

-- ================================================================
-- VERIFICAÇÃO FINAL
-- ================================================================

SELECT '=== USUÁRIOS CRIADOS ===' AS msg;
SELECT id_usuario, login, ativo FROM usuario ORDER BY id_usuario;

SELECT '=== CONTEXTOS CRIADOS ===' AS msg;
SELECT uc.id_usuario, u.login, un.nome AS unidade, lo.nome AS local, p.nome AS perfil
FROM usuario_contexto uc
JOIN usuario u ON u.id_usuario = uc.id_usuario
JOIN unidade un ON un.id_unidade = uc.id_unidade
JOIN local_operacional lo ON lo.id_local_operacional = uc.id_local_operacional
JOIN perfil p ON p.id_perfil = uc.id_perfil
ORDER BY uc.id_usuario;

SELECT '=== PACIENTES CRIADOS ===' AS msg;
SELECT p.id, p.prontuario, pes.nome_completo, pes.cpf, pes.data_nascimento
FROM paciente p
JOIN pessoa pes ON pes.id_pessoa = p.id_pessoa
ORDER BY p.id;

SELECT '=== SENHAS CRIADAS ===' AS msg;
SELECT id, codigo, status, tipo_atendimento, data_ref FROM senhas ORDER BY id DESC LIMIT 10;

SELECT '=== PAINÉIS CRIADOS ===' AS msg;
SELECT id_painel, codigo, nome, tipo, ativo FROM painel;

SELECT '=== MEDICAMENTOS CRIADOS ===' AS msg;
SELECT id, nome, principio_ativo, concentracao, quantidade_saldo FROM farmaco;

SELECT '=== SEED CONCLUÍDO COM SUCESSO! ===' AS msg;
