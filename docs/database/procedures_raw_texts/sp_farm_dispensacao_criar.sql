CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farm_dispensacao_criar`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_ffa            BIGINT,
    IN  p_id_estoque_local  BIGINT,
    IN  p_id_usuario_farmacia BIGINT,
    OUT p_id_dispensacao    BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_gpat BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_farm_dispensacao_criar', 'Falha ao criar dispensação');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_farm_dispensacao_criar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_dispensacao = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa é obrigatório.');
    CALL sp_assert_true(p_id_estoque_local IS NOT NULL, 'PARAM', 'id_estoque_local é obrigatório.');

    START TRANSACTION;

    SELECT f.id_gpat INTO v_id_gpat
      FROM ffa f
     WHERE f.id = p_id_ffa
     LIMIT 1;

    CALL sp_assert_true(v_id_gpat IS NOT NULL, 'GPAT', 'FFA sem GPAT.');

    INSERT INTO farm_dispensacao (id_ffa, id_gpat, id_estoque_local, status, id_usuario_farmacia)
    VALUES (p_id_ffa, v_id_gpat, p_id_estoque_local, 'ABERTA', p_id_usuario_farmacia);

    SET p_id_dispensacao = LAST_INSERT_ID();

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'FARM_DISP_CRIADA', 'farm_dispensacao', p_id_dispensacao);

    COMMIT;
END ;;