-- Migration: align_sp_auth_permissions_evaluate
-- Data: 2026-07-26
-- Descricao: Adiciona sp_auth_permissions_evaluate do dump real de producao

DROP PROCEDURE IF EXISTS sp_auth_permissions_evaluate;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_permissions_evaluate`(
    IN  p_id_sessao          BIGINT,
    IN  p_id_usuario         BIGINT,
    IN  p_id_tenant          BIGINT,
    IN  p_id_contexto        BIGINT,
    IN  p_capability_codigo  VARCHAR(80),
    OUT p_allowed            BOOLEAN,
    OUT p_capability         VARCHAR(80),
    OUT p_context            JSON,
    OUT p_reason             TEXT,
    OUT p_audit_ref          VARCHAR(64)
)
main_flow: BEGIN
    DECLARE v_id_perfil      BIGINT;
    DECLARE v_id_unidade     BIGINT UNSIGNED;
    DECLARE v_id_local       BIGINT;
    DECLARE v_ativo          TINYINT;
    DECLARE v_revogado       TINYINT;
    DECLARE v_expira_em      DATETIME(6);

