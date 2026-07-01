CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_gpat_garantir`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa            BIGINT,
    IN p_tipo_prefixo      VARCHAR(30) -- normalmente 'GPAT'
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_gpat BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_prefixo5 CHAR(5);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_ffa_gpat_garantir', 'Falha ao garantir GPAT');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_ffa_gpat_garantir | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa (ffa.id) é obrigatório.');

    START TRANSACTION;

    SELECT f.id_gpat INTO v_id_gpat
      FROM ffa f
     WHERE f.id = p_id_ffa
     LIMIT 1;

    IF v_id_gpat IS NOT NULL THEN
        COMMIT;
        LEAVE main;
    END IF;

    -- tenta pegar contexto da sessão (se existir)
    SET v_id_unidade = NULL;
    SET v_id_local   = NULL;
    SELECT su.id_unidade, su.id_local_operacional
      INTO v_id_unidade, v_id_local
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
     LIMIT 1;

    CALL sp_codigo_prefixo_resolver(p_id_sessao_usuario, IFNULL(p_tipo_prefixo,'GPAT'), v_id_unidade, v_id_local, v_prefixo5);

    -- chama SP canônica do pack 70–85 (já existente)
    CALL sp_ffa_gpat_gerar(p_id_sessao_usuario, p_id_ffa, v_prefixo5);

    COMMIT;
END ;;