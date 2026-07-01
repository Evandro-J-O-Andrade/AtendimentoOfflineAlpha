CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fila_chamar_proxima`(
    IN p_id_sessao_usuario BIGINT,
    IN p_setor VARCHAR(50),
    IN p_id_local_operacional BIGINT,
    OUT p_id_fila BIGINT
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_fila BIGINT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_fila_chamar_proxima', 'Falha ao chamar próxima fila');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_fila_chamar_proxima | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_fila = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_setor IS NOT NULL AND p_setor <> '', 'PARAM', 'setor é obrigatório.');

    START TRANSACTION;

    SELECT fo.id_fila
      INTO v_id_fila
      FROM fila_operacional fo
     WHERE fo.setor = p_setor
       AND fo.status = 'AGUARDANDO'
     ORDER BY fo.prioridade DESC, fo.criado_em ASC
     LIMIT 1
     FOR UPDATE;

    CALL sp_assert_true(v_id_fila IS NOT NULL, 'FILA', 'Sem itens aguardando para o setor.');

    UPDATE fila_operacional
       SET status = 'CHAMANDO',
           id_local_operacional = p_id_local_operacional,
           atualizado_em = NOW()
     WHERE id_fila = v_id_fila;

    INSERT INTO fila_operacional_evento (
        id_fila, tipo_evento, descricao, id_sessao_usuario, criado_em
    ) VALUES (
        v_id_fila, 'CHAMAR', CONCAT('Chamando próximo para setor=', p_setor),
        p_id_sessao_usuario, NOW()
    );

    -- Auditoria GLOBAL (núcleo imutável)
    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'FILA_CHAMADA', 'fila_operacional', v_id_fila);

    SET p_id_fila = v_id_fila;

    COMMIT;
END ;;