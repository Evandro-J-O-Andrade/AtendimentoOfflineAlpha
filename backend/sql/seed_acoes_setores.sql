-- Script para inserir ações de permissão para os novos setores
-- Execute este script no banco de dados

-- Verificar se já existem as ações antes de inserir
-- Ações para Ambulância
INSERT IGNORE INTO acao (id, descricao, acao, modulo, id_sistema, ativo, created_at, updated_at)
VALUES 
(61, 'Painel Ambulância', 'painel_ambulancia', 'AMBULANCIA', 1, 1, NOW(), NOW()),
(62, 'Painel Remoção', 'painel_remocao', 'REMOCAO', 1, 1, NOW(), NOW()),
(63, 'Painel Manutenção', 'painel_manutencao', 'MANUTENCAO', 1, 1, NOW(), NOW()),
(64, 'Painel Gasoterapia', 'painel_gasoterapia', 'GASOTERAPIA', 1, 1, NOW(), NOW()),
(65, 'Painel Assistência Social', 'painel_assistencia_social', 'ASSISTENCIA_SOCIAL', 1, 1, NOW(), NOW()),
(66, 'Painel Faturamento', 'painel_faturamento', 'FATURAMENTO', 1, 1, NOW(), NOW()),
(67, 'Painel CAT', 'painel_cat', 'CAT', 1, 1, NOW(), NOW()),
(68, 'Painel Óbito', 'painel_obito', 'OBITO', 1, 1, NOW(), NOW()),
(69, 'Painel PDV', 'painel_pdv', 'PDV', 1, 1, NOW(), NOW()),
(70, 'Painel Nutrição', 'painel_nutricao', 'NUTRICAO', 1, 1, NOW(), NOW()),
(71, 'Painel Interconsulta', 'painel_interconsulta', 'INTERCONSULTA', 1, 1, NOW(), NOW());
