CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fila_tipo_por_local`(IN p_id_sessao_usuario BIGINT,
    IN p_id_local_operacional BIGINT,
    OUT p_tipo_fila VARCHAR(20))
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE v_tipo_local VARCHAR(40);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_fila_tipo_por_local', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_fila_tipo_por_local | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha na rotina'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    SET p_tipo_fila = NULL;
    CALL sp_assert_true(p_id_local_operacional IS NOT NULL, 'PARAM', 'id_local_operacional é obrigatório.');
    SELECT lo.tipo INTO v_tipo_local
      FROM local_operacional lo
     WHERE lo.id_local_operacional = p_id_local_operacional
     LIMIT 1;
    CALL sp_assert_true(v_tipo_local IS NOT NULL, 'LOCAL', 'Local operacional não encontrado.');
    SET p_tipo_fila = CASE
        WHEN v_tipo_local = 'TRIAGEM' THEN 'TRIAGEM'
        WHEN v_tipo_local IN ('MEDICO_CLINICO','MEDICO_PEDIATRICO') THEN 'MEDICO'
        WHEN v_tipo_local = 'MEDICACAO' THEN 'MEDICACAO'
        WHEN v_tipo_local = 'RX' THEN 'RX'
        WHEN v_tipo_local = 'ECG' THEN 'ECG'
        WHEN v_tipo_local = 'OBSERVACAO' THEN 'OBSERVACAO'
        WHEN v_tipo_local IN ('LABORATORIO') THEN 'EXAME'
        ELSE 'PROCEDIMENTO'
    END;
    COMMIT;
END ;;