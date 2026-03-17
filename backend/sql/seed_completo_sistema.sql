-- =====================================================
-- SEED COMPLETO DO SISTEMA PRONTO ATENDIMENTO
-- Execute este script para popular o banco de dados
-- =====================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- 1. UNIDADES
-- =====================================================
INSERT IGNORE INTO unidade (id_unidade, nome, tipo, ativo, criado_em, id_entidade) VALUES
(1, 'Hospital Central', 'HOSPITAL', 1, NOW(), 1),
(2, 'UPA 24h', 'UPA', 1, NOW(), 1),
(3, 'UBS Norte', 'UBS', 1, NOW(), 1),
(4, 'UBS Sul', 'UBS', 1, NOW(), 1),
(5, 'Centro de Especialidades', 'AMBULATORIO', 1, NOW(), 1);

-- =====================================================
-- 2. TIPOS DE LOCAL
-- =====================================================
INSERT IGNORE INTO tipo_local (id_tipo_local, descricao) VALUES
(1, 'Recepção'),
(2, 'Triagem'),
(3, 'Consultório'),
(4, 'Enfermaria'),
(5, 'Sala de Emergência'),
(6, 'Laboratório'),
(7, 'Farmácia'),
(8, 'Estoque'),
(9, 'Ambulância'),
(10, 'Recepção Emergência'),
(11, 'Sala de Espera'),
(12, 'Administração'),
(13, 'Nutrição'),
(14, 'Serviço Social'),
(15, 'Faturamento'),
(16, 'CAT'),
(17, 'Óbito'),
(18, 'PDV'),
(19, 'Gasoterapia'),
(20, 'Manutenção');

-- =====================================================
-- 3. LOCAIS DE TRABALHO
-- =====================================================
INSERT IGNORE INTO local (id_local, id_unidade, id_tipo_local, nome, codigo, ativo, criado_em) VALUES
-- Unidade 1 - Hospital Central
(1, 1, 1, 'Recepção Principal', 'HC-REC-01', 1, NOW()),
(2, 1, 2, 'Sala de Triagem', 'HC-TRI-01', 1, NOW()),
(3, 1, 3, 'Consultório Médico 1', 'HC-MED-01', 1, NOW()),
(4, 1, 3, 'Consultório Médico 2', 'HC-MED-02', 1, NOW()),
(5, 1, 4, 'Enfermaria A', 'HC-ENF-A', 1, NOW()),
(6, 1, 4, 'Enfermaria B', 'HC-ENF-B', 1, NOW()),
(7, 1, 5, 'Sala de Emergência', 'HC-EME-01', 1, NOW()),
(8, 1, 6, 'Laboratório', 'HC-LAB-01', 1, NOW()),
(9, 1, 7, 'Farmácia Central', 'HC-FAR-01', 1, NOW()),
(10, 1, 8, 'Estoque Geral', 'HC-EST-01', 1, NOW()),
-- Unidade 2 - UPA
(11, 2, 1, 'Recepção UPA', 'UPA-REC-01', 1, NOW()),
(12, 2, 2, 'Triagem UPA', 'UPA-TRI-01', 1, NOW()),
(13, 2, 5, 'Emergência UPA', 'UPA-EME-01', 1, NOW()),
(14, 2, 7, 'Farmácia UPA', 'UPA-FAR-01', 1, NOW()),
-- Setores específicos
(15, 1, 9, 'Frota Ambulâncias', 'HC-AMB-01', 1, NOW()),
(16, 1, 13, 'Nutrição', 'HC-NUT-01', 1, NOW()),
(17, 1, 14, 'Assistência Social', 'HC-SOC-01', 1, NOW()),
(18, 1, 15, 'Faturamento', 'HC-FAT-01', 1, NOW()),
(19, 1, 16, 'CAT', 'HC-CAT-01', 1, NOW()),
(20, 1, 17, 'Serviço de Óbito', 'HC-OBT-01', 1, NOW()),
(21, 1, 18, 'PDV/Vendas', 'HC-PDV-01', 1, NOW()),
(22, 1, 19, 'Gasoterapia', 'HC-GAS-01', 1, NOW()),
(23, 1, 20, 'Manutenção', 'HC-MAN-01', 1, NOW()),
(24, 1, 12, 'Administração', 'HC-ADM-01', 1, NOW());

-- =====================================================
-- 4. PERFIS
-- =====================================================
INSERT IGNORE INTO perfil (id_perfil, nome, codigo, descricao, contexto, ativo, criado_em) VALUES
(1, 'Administrador', 'ADMIN', 'Acesso total ao sistema', 'GERAL', 1, NOW()),
(2, 'Recepcionista', 'RECEPCAO', 'Atendimento na recepção', 'ATENDIMENTO', 1, NOW()),
(3, 'Enfermeiro', 'ENFERMAGEM', 'Triagem e enfermagem', 'ATENDIMENTO', 1, NOW()),
(4, 'Médico', 'MEDICO', 'Atendimento médico', 'ATENDIMENTO', 1, NOW()),
(5, 'Farmacêutico', 'FARMACIA', 'Dispensação de medicamentos', 'FARMACIA', 1, NOW()),
(6, 'Técnico de Laboratório', 'LABORATORIO', 'Análises laboratoriais', 'LABORATORIO', 1, NOW()),
(7, 'Auxiliar de Enfermagem', 'AUX_ENF', 'Apoio à enfermagem', 'ATENDIMENTO', 1, NOW()),
(8, 'Estoquista', 'ESTOQUE', 'Gestão de estoque', 'ESTOQUE', 1, NOW()),
(9, 'Técnico de Ambulância', 'AMBULANCIA', 'Transporte de pacientes', 'AMBULANCIA', 1, NOW()),
(10, 'Assistente Social', 'ASSIST_SOCIAL', 'Serviço social', 'SOCIAL', 1, NOW()),
(11, 'Nutricionista', 'NUTRICAO', 'Nutrição e dietas', 'NUTRICAO', 1, NOW()),
(12, 'Faturista', 'FATURAMENTO', 'Faturamento', 'FATURAMENTO', 1, NOW()),
(13, 'Técnico de Manutenção', 'MANUTENCAO', 'Manutenção', 'MANUTENCAO', 1, NOW()),
(14, 'Gasoterapeuta', 'GASOTERAPIA', 'Gasoterapia', 'GASOTERAPIA', 1, NOW()),
(15, 'Atendente PDV', 'PDV', 'Ponto de venda', 'COMERCIAL', 1, NOW()),
(16, 'Coordenador', 'COORDENADOR', 'Coordenação de setor', 'GERAL', 1, NOW());

-- =====================================================
-- 5. PERMISSÕES
-- =====================================================
INSERT IGNORE INTO permissao (codigo, nome, acao_frontend, dominio, grupo_menu, ativo, criado_em) VALUES
-- Ações existentes
('ADMIN', 'Painel Admin', 'painel_admin', 'GERAL', 'ADMIN', 1, NOW()),
('DASHBOARD', 'Dashboard', 'painel_dashboard', 'GERAL', 'DASHBOARD', 1, NOW()),
('RECEPCAO', 'Recepção', 'painel_recepcao', 'RECEPCAO', 'ATENDIMENTO', 1, NOW()),
('TRIAGEM', 'Triagem', 'painel_triagem', 'ATENDIMENTO', 'ATENDIMENTO', 1, NOW()),
('ENFERMAGEM', 'Enfermagem', 'painel_enfermagem', 'ATENDIMENTO', 'ATENDIMENTO', 1, NOW()),
('MEDICO', 'Atendimento Médico', 'painel_medico', 'ATENDIMENTO', 'ATENDIMENTO', 1, NOW()),
('FARMACIA', 'Farmácia', 'painel_farmacia', 'FARMACIA', 'FARMACIA', 1, NOW()),
('LABORATORIO', 'Laboratório', 'painel_laboratorio', 'LABORATORIO', 'LABORATORIO', 1, NOW()),
('INTERNACAO', 'Internação', 'painel_internacao', 'INTERNACAO', 'INTERNACAO', 1, NOW()),
('ESTOQUE', 'Estoque', 'painel_estoque', 'ESTOQUE', 'ESTOQUE', 1, NOW()),
-- Novas ações
('AMBULANCIA', 'Ambulância', 'painel_ambulancia', 'AMBULANCIA', 'AMBULANCIA', 1, NOW()),
('REMOCAO', 'Remoção', 'painel_remocao', 'REMOCAO', 'AMBULANCIA', 1, NOW()),
('MANUTENCAO', 'Manutenção', 'painel_manutencao', 'MANUTENCAO', 'OPERACIONAL', 1, NOW()),
('GASOTERAPIA', 'Gasoterapia', 'painel_gasoterapia', 'GASOTERAPIA', 'CLINICO', 1, NOW()),
('ASSISTENCIA_SOCIAL', 'Assistência Social', 'painel_assistencia_social', 'ASSISTENCIA_SOCIAL', 'SOCIAL', 1, NOW()),
('FATURAMENTO', 'Faturamento', 'painel_faturamento', 'FATURAMENTO', 'ADMINISTRATIVO', 1, NOW()),
('CAT', 'CAT', 'painel_cat', 'CAT', 'ATENDIMENTO', 1, NOW()),
('OBITO', 'Óbito', 'painel_obito', 'OBITO', 'ADMINISTRATIVO', 1, NOW()),
('PDV', 'PDV', 'painel_pdv', 'PDV', 'COMERCIAL', 1, NOW()),
('NUTRICAO', 'Nutrição', 'painel_nutricao', 'NUTRICAO', 'CLINICO', 1, NOW()),
('INTERCONSULTA', 'Interconsulta', 'painel_interconsulta', 'INTERCONSULTA', 'ATENDIMENTO', 1, NOW());

-- =====================================================
-- 6. VINCULAR PERMISSÕES AOS PERFIS
-- =====================================================
-- Administrador (1) - Todas as permissões
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 1, id_permissao, NOW() FROM permissao;

-- Recepcionista (2) - RECEPCAO, DASHBOARD
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 2, id_permissao, NOW() FROM permissao WHERE codigo IN ('RECEPCAO', 'DASHBOARD');

-- Enfermeiro (3) - TRIAGEM, ENFERMAGEM, DASHBOARD
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 3, id_permissao, NOW() FROM permissao WHERE codigo IN ('TRIAGEM', 'ENFERMAGEM', 'DASHBOARD');

-- Médico (4) - MEDICO, DASHBOARD
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 4, id_permissao, NOW() FROM permissao WHERE codigo IN ('MEDICO', 'DASHBOARD');

-- Farmacêutico (5) - FARMACIA, DASHBOARD
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 5, id_permissao, NOW() FROM permissao WHERE codigo IN ('FARMACIA', 'DASHBOARD');

-- Técnico de Laboratório (6) - LABORATORIO, DASHBOARD
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 6, id_permissao, NOW() FROM permissao WHERE codigo IN ('LABORATORIO', 'DASHBOARD');

-- Auxiliar de Enfermagem (7) - ENFERMAGEM, TRIAGEM
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 7, id_permissao, NOW() FROM permissao WHERE codigo IN ('ENFERMAGEM', 'TRIAGEM');

-- Estoquista (8) - ESTOQUE, DASHBOARD
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 8, id_permissao, NOW() FROM permissao WHERE codigo IN ('ESTOQUE', 'DASHBOARD');

-- Técnico de Ambulância (9) - AMBULANCIA, REMOCAO, DASHBOARD
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 9, id_permissao, NOW() FROM permissao WHERE codigo IN ('AMBULANCIA', 'REMOCAO', 'DASHBOARD');

-- Assistente Social (10) - ASSISTENCIA_SOCIAL, DASHBOARD
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 10, id_permissao, NOW() FROM permissao WHERE codigo IN ('ASSISTENCIA_SOCIAL', 'DASHBOARD');

-- Nutricionista (11) - NUTRICAO, DASHBOARD
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 11, id_permissao, NOW() FROM permissao WHERE codigo IN ('NUTRICAO', 'DASHBOARD');

-- Faturista (12) - FATURAMENTO, DASHBOARD
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 12, id_permissao, NOW() FROM permissao WHERE codigo IN ('FATURAMENTO', 'DASHBOARD');

-- Técnico de Manutenção (13) - MANUTENCAO, DASHBOARD
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 13, id_permissao, NOW() FROM permissao WHERE codigo IN ('MANUTENCAO', 'DASHBOARD');

-- Gasoterapeuta (14) - GASOTERAPIA, DASHBOARD
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 14, id_permissao, NOW() FROM permissao WHERE codigo IN ('GASOTERAPIA', 'DASHBOARD');

-- Atendente PDV (15) - PDV, DASHBOARD
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 15, id_permissao, NOW() FROM permissao WHERE codigo IN ('PDV', 'DASHBOARD');

-- Coordenador (16) - Múltiplos
INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
SELECT 16, id_permissao, NOW() FROM permissao WHERE codigo IN ('ADMIN', 'DASHBOARD', 'RECEPCAO', 'TRIAGEM', 'ENFERMAGEM', 'MEDICO', 'FARMACIA', 'LABORATORIO', 'INTERNACAO', 'ESTOQUE');

-- =====================================================
-- 7. PESSOAS (FUNCIONÁRIOS)
-- =====================================================
INSERT IGNORE INTO pessoa (id_pessoa, nome, tipo_pessoa, ativo, criado_em, id_entidade) VALUES
(1, 'Administrador Sistema', 'FUNCIONARIO', 1, NOW(), 1),
(2, 'Maria da Silva', 'FUNCIONARIO', 1, NOW(), 1),
(3, 'João Santos', 'FUNCIONARIO', 1, NOW(), 1),
(4, 'Ana Paula Oliveira', 'FUNCIONARIO', 1, NOW(), 1),
(5, 'Carlos Pereira', 'FUNCIONARIO', 1, NOW(), 1),
(6, 'Juliana Costa', 'FUNCIONARIO', 1, NOW(), 1),
(7, 'Roberto Ferreira', 'FUNCIONARIO', 1, NOW(), 1),
(8, 'Patrícia Almeida', 'FUNCIONARIO', 1, NOW(), 1),
(9, 'Marcos Rodrigues', 'FUNCIONARIO', 1, NOW(), 1),
(10, 'Luciana Martins', 'FUNCIONARIO', 1, NOW(), 1),
(11, 'Fernanda Souza', 'FUNCIONARIO', 1, NOW(), 1),
(12, 'Ricardo Lima', 'FUNCIONARIO', 1, NOW(), 1),
(13, 'Carla Dias', 'FUNCIONARIO', 1, NOW(), 1),
(14, 'Bruno Castro', 'FUNCIONARIO', 1, NOW(), 1),
(15, 'Tatiana Reis', 'FUNCIONARIO', 1, NOW(), 1);

-- =====================================================
-- 8. USUÁRIOS
-- =====================================================
-- Senha: admin123 (hash bcrypt)
INSERT IGNORE INTO usuario (id_usuario, id_pessoa, login, senha_hash, ativo, tentativas_login, criado_em) VALUES
(1, 1, 'admin', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(2, 2, 'maria.silva', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(3, 3, 'joao.santos', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(4, 4, 'ana.paula', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(5, 5, 'carlos.pereira', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(6, 6, 'juliana.costa', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(7, 7, 'roberto.ferreira', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(8, 8, 'patricia.almeida', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(9, 9, 'marcos.rodrigues', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(10, 10, 'luciana.martins', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(11, 11, 'fernanda.souza', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(12, 12, 'ricardo.lima', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(13, 13, 'carla.dias', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(14, 14, 'bruno.castro', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW()),
(15, 15, 'tatiana.reis', '$2a$10$Qf8vD2tC.4BmsoseuYU4DOETo./bUvHtFbBKQ4Ooq6D4q8AZ0PH2K', 1, 0, NOW());

-- =====================================================
-- 9. VINCULAR USUÁRIOS AOS PERFIS
-- =====================================================
INSERT IGNORE INTO usuario_perfil (id_usuario, id_perfil, criado_em) VALUES
(1, 1, NOW()),
(2, 2, NOW()),
(3, 3, NOW()),
(4, 4, NOW()),
(5, 5, NOW()),
(6, 6, NOW()),
(7, 7, NOW()),
(8, 8, NOW()),
(9, 9, NOW()),
(10, 10, NOW()),
(11, 11, NOW()),
(12, 12, NOW()),
(13, 13, NOW()),
(14, 14, NOW()),
(15, 15, NOW());

-- =====================================================
-- 10. VINCULAR USUÁRIOS AOS LOCAIS
-- =====================================================
INSERT IGNORE INTO usuario_local (id_usuario, id_local, criado_em) VALUES
(1, 1, NOW()),
(2, 1, NOW()),
(3, 2, NOW()),
(4, 3, NOW()),
(5, 9, NOW()),
(6, 8, NOW()),
(7, 2, NOW()),
(8, 10, NOW()),
(9, 15, NOW()),
(10, 17, NOW()),
(11, 16, NOW()),
(12, 18, NOW()),
(13, 23, NOW()),
(14, 22, NOW()),
(15, 21, NOW());

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- RESUMO DO SEED
-- =====================================================
/*
Unidades: 5
Tipos de Local: 20
Locais de Trabalho: 24
Perfis: 16
Permissões: 21
Usuários: 15

USUÁRIOS PARA TESTE:
- admin / admin123 (Administrador)
- maria.silva / 123456 (Recepcionista)
- joao.santos / 123456 (Enfermeiro)
- ana.paula / 123456 (Médico)
- carlos.pereira / 123456 (Farmacêutico)
- juliana.costa / 123456 (Técnico Lab)
- marcos.rodrigues / 123456 (Ambulância)
- luciana.martins / 123456 (Assist. Social)
- fernanda.souza / 123456 (Nutricionista)
- ricardo.lima / 123456 (Faturista)
- tatiana.reis / 123456 (Atendente PDV)
*/
