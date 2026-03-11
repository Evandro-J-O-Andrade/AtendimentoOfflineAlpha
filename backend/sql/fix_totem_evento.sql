-- =====================================================
-- CORREÇÃO: Tabela totem_evento faltando colunas
-- Executar no banco de dados
-- =====================================================

-- 1. Adicionar coluna ip_acesso se não existir
ALTER TABLE totem_evento 
ADD COLUMN ip_acesso VARCHAR(45) NULL AFTER detalhe;

-- 2. Adicionar novos valores ao enum de eventos (se não existirem)
-- Primeiro verificamos a estrutura atual
-- ALTER TABLE totem_evento MODIFY COLUMN evento ENUM('ONLINE','OFFLINE','EMITIU_SENHA','ERRO','SENHA_GERADA','SENHA_CHAMADA','SENHA_ATENDIDA','SENHA_CANCELADA','SENHA_REAUTUADA') NOT NULL;

-- Se o ALTER acima der erro (porque já existe), use:
ALTER TABLE totem_evento MODIFY COLUMN evento ENUM('ONLINE','OFFLINE','EMITIU_SENHA','ERRO','SENHA_GERADA','SENHA_CHAMADA','SENHA_ATENDIDA','SENHA_CANCELADA','SENHA_REAUTUADA') NOT NULL;

-- Verificar a estrutura após correção
DESCRIBE totem_evento;
