DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_permissions_evaluate`(
    IN p_id_sessao BIGINT,
    OUT p_permissions JSON
)
BEGIN
    DECLARE v_id_usuario BIGINT UNSIGNED;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_id_unidade BIGINT UNSIGNED;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_entidade BIGINT UNSIGNED;
    DECLARE v_ativo TINYINT;
    DECLARE v_revogado TINYINT;
    DECLARE v_expira_em DATETIME(6);
    DECLARE v_erro_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_erro_msg = MESSAGE_TEXT;
        SET p_permissions = JSON_ARRAY();
    END;

    SELECT su.id_usuario, su.id_perfil, su.id_unidade, su.id_local, su.id_entidade, su.ativo, su.revogado, su.expira_em
      INTO v_id_usuario, v_id_perfil, v_id_unidade, v_id_local, v_id_entidade, v_ativo, v_revogado, v_expira_em
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao
       AND su.id_entidade IS NOT NULL
     LIMIT 1;

    IF v_id_usuario IS NULL OR v_id_perfil IS NULL OR v_id_unidade IS NULL OR v_id_entidade IS NULL THEN
        SET p_permissions = JSON_ARRAY();
        LEAVE sp_auth_permissions_evaluate;
    END IF;

    IF v_ativo <> 1 OR IFNULL(v_revogado,0) <> 0 OR v_expira_em IS NULL OR v_expira_em < NOW(6) OR v_id_unidade IS NULL THEN
        SET p_permissions = JSON_ARRAY();
        LEAVE sp_auth_permissions_evaluate;
    END IF;

    SET p_permissions = (
        SELECT JSON_ARRAYAGG(DISTINCT p.codigo)
          FROM permissao p
          JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
          LEFT JOIN permissao_local pl ON pl.id_permissao = p.id_permissao
         WHERE pp.id_perfil = v_id_perfil
           AND p.ativo = 1
           AND p.id_entidade = v_id_entidade
           AND (pl.id_local IS NULL OR pl.id_local = v_id_local)
    );

    IF p_permissions IS NULL THEN
        SET p_permissions = JSON_ARRAY();
    END IF;
END ;;
DELIMITER ;
