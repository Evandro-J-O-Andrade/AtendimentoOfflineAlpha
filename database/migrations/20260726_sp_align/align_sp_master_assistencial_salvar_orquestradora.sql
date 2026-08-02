-- Migration: align_sp_master_assistencial_salvar_orquestradora
-- Data: 2026-07-26
-- Descricao: Alinha sp_master_assistencial_salvar_orquestradora com o dump real de producao

DROP PROCEDURE IF EXISTS $sp;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_assistencial_salvar_orquestradora`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_tabela_alvo VARCHAR(64);

