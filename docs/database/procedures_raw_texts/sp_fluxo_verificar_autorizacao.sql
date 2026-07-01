CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fluxo_verificar_autorizacao`(
    IN p_id_usuario BIGINT,
    IN p_id_sistema BIGINT,
    IN p_nome_procedure VARCHAR(150)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_permitido INT DEFAULT 0;

    SELECT COUNT(1)
    INTO v_permitido
    FROM vw_usuario_permissoes vp
    WHERE vp.id_usuario = p_id_usuario
      AND vp.id_sistema = p_id_sistema
      AND vp.nome_procedure = p_nome_procedure
      AND vp.permitido = 1;

    IF v_permitido = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Acesso negado ao fluxo operacional';
    END IF;

END ;;