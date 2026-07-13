CREATE PROCEDURE `sp_auth_permissions_evaluate`(
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
    DECLARE v_id_permissao   BIGINT;
    DECLARE v_audit_id       CHAR(36);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_allowed     = FALSE;
        SET p_capability  = p_capability_codigo;
        SET p_context     = JSON_OBJECT();
        SET p_reason      = 'INTERNAL_ERROR';
        SET p_audit_ref   = UUID();
    END;

    SET v_audit_id = UUID();
    SET p_audit_ref = v_audit_id;

    SELECT su.id_perfil, su.id_unidade, su.id_local,
           su.ativo, IFNULL(su.revogado, 0), su.expira_em
      INTO v_id_perfil, v_id_unidade, v_id_local,
           v_ativo, v_revogado, v_expira_em
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao
       AND su.id_usuario   = p_id_usuario
       AND su.id_entidade  = p_id_tenant
       AND su.id_entidade IS NOT NULL
     LIMIT 1;

    IF v_id_perfil IS NULL OR v_ativo <> 1
       OR v_revogado <> 0 OR v_expira_em IS NULL
       OR v_expira_em < NOW(6) THEN
        SET p_allowed     = FALSE;
        SET p_capability  = p_capability_codigo;
        SET p_context     = JSON_OBJECT('id_contexto', p_id_contexto);
        SET p_reason      = 'SESSION_INVALID';
        LEAVE main_flow;
    END IF;

    SELECT p.id_permissao
      INTO v_id_permissao
      FROM permissao p
     WHERE p.codigo     = p_capability_codigo
       AND p.ativo      = 1
       AND (p.id_entidade = p_id_tenant OR p.id_entidade IS NULL)
     LIMIT 1;

    IF v_id_permissao IS NULL THEN
        SET p_allowed     = FALSE;
        SET p_capability  = p_capability_codigo;
        SET p_context     = JSON_OBJECT('id_contexto', p_id_contexto);
        SET p_reason      = 'CAPABILITY_NOT_FOUND';
        LEAVE main_flow;
    END IF;

    IF EXISTS (
        SELECT 1
          FROM perfil_permissao pp
         WHERE pp.id_perfil    = v_id_perfil
           AND pp.id_permissao = v_id_permissao
           AND (pp.id_entidade = p_id_tenant OR pp.id_entidade IS NULL)
    ) THEN
        SET p_allowed     = TRUE;
        SET p_capability  = p_capability_codigo;
        SET p_context     = JSON_OBJECT(
            'id_contexto',  p_id_contexto,
            'id_local',     v_id_local,
            'id_unidade',   v_id_unidade
        );
        SET p_reason      = 'PERMISSION_GRANTED';
    ELSE
        SET p_allowed     = FALSE;
        SET p_capability  = p_capability_codigo;
        SET p_context     = JSON_OBJECT('id_contexto', p_id_contexto);
        SET p_reason      = 'PERMISSION_DENIED';
    END IF;
END main_flow
