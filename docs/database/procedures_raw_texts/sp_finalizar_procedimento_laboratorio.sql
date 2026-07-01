CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_laboratorio`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_resultado         TEXT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_id_ffa BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_finalizar_procedimento_laboratorio', 'Falha ao finalizar laboratório');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_finalizar_procedimento_laboratorio | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    START TRANSACTION;

    SELECT fo.id_ffa INTO v_id_ffa
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1;

    CALL sp_assert_true(v_id_ffa IS NOT NULL, 'FILA', 'Fila operacional não encontrada.');

    -- finaliza a fila e o protocolo EXAME (se existir)
    CALL sp_finalizar_procedimento_geral(p_id_sessao_usuario, p_id_fila, p_resultado);

    -- marca lab como concluído (se existir amostra)
    UPDATE lab_protocolo_interno
       SET status_laboratorial = 'CONCLUIDO'
     WHERE id_ffa = v_id_ffa
       AND (status_laboratorial IS NULL OR status_laboratorial <> 'CONCLUIDO');

    COMMIT;
END ;;