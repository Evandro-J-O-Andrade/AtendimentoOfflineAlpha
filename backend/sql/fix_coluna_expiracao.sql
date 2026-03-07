-- Script simples para adicionar coluna que falta
USE `pronto_atendimento`;

-- Adicionar coluna expiracao_em se não existir
ALTER TABLE `sessao_usuario` ADD COLUMN `expiracao_em` datetime NULL AFTER `ativo`;

SELECT 'Coluna expiracao_em adicionada com sucesso!' AS resultado;
