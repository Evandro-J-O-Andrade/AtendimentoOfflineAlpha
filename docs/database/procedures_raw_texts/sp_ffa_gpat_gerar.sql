CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_gpat_gerar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa            BIGINT,  -- referencia ffa.id
    IN p_prefixo_5         CHAR(5)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_codigo BIGINT;
    DECLARE v_codigo VARCHAR(50);
    DECLARE v_barcode VARCHAR(60);
    DECLARE v_id_gpat BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_ffa_gpat_gerar', 'Falha ao gerar GPAT');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_ffa_gpat_gerar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa (ffa.id) é obrigatório.');
    CALL sp_assert_true(p_prefixo_5 IS NOT NULL AND CHAR_LENGTH(p_prefixo_5)=5, 'PARAM', 'prefixo_5 deve ter 5 dígitos.');

    START TRANSACTION;

    SELECT f.id_gpat INTO v_id_gpat
      FROM ffa f
     WHERE f.id = p_id_ffa
     LIMIT 1;

    IF v_id_gpat IS NOT NULL THEN
        COMMIT;
        LEAVE main;
    END IF;

    -- Depende do teu pack 60-70: sp_codigo_emitir_interno
    CALL sp_codigo_emitir_interno(
        p_id_sessao_usuario,
        'GPAT',
        p_prefixo_5,
        NULL, NULL, NULL,
        p_id_ffa,
        NULL, NULL, NULL, NULL, NULL,
        NULL,
        @out_id_codigo,
        @out_codigo_interno,
        @out_barcode
    );

    SET v_id_codigo = @out_id_codigo;
    SET v_codigo    = @out_codigo_interno;
    SET v_barcode   = @out_barcode;

    INSERT INTO gpat (id_ffa, id_codigo_universal, codigo_gpat, barcode_gpat, origem)
    VALUES (p_id_ffa, v_id_codigo, v_codigo, v_barcode, 'AUTO');

    SET v_id_gpat = LAST_INSERT_ID();

    UPDATE ffa
       SET id_gpat = v_id_gpat
     WHERE id = p_id_ffa;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'GPAT_GERADO', 'gpat', v_id_gpat);

    COMMIT;
END ;;