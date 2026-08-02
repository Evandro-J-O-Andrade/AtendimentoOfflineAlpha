-- Migration: align_sp_executor_assistencial_atendimento_finalizar
-- Data: 2026-07-26
-- Descricao: Alinha sp_executor_assistencial_atendimento_finalizar com o dump real de producao

DROP PROCEDURE IF EXISTS $sp;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_assistencial_atendimento_finalizar`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
main: BEGIN

    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_saas BIGINT;
    DECLARE v_id_atendimento BIGINT;

    DECLARE v_ip VARCHAR(45);

