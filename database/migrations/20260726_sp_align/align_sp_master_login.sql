-- Migration: align_sp_master_login
-- Data: 2026-07-26
-- Descricao: Alinha sp_master_login com o dump real de producao

DROP PROCEDURE IF EXISTS $sp;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_login`(
    IN p_acao VARCHAR(100),
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
proc: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_login VARCHAR(120);

