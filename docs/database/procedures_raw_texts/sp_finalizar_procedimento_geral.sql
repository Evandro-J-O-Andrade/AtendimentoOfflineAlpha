CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_geral`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_resultado         TEXT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_id_usuario BIGINT;
    DECLARE v_tipo_fila ENUM('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO');
    DECLARE v_tipo_proto ENUM('EXAME','RX');
    DECLARE v_id_protocolo BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_finalizar_procedimento_geral', 'Falha ao finalizar procedimento');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_finalizar_procedimento_geral | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    START TRANSACTION;

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    SELECT fo.tipo INTO v_tipo_fila
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1;

    CALL sp_assert_true(v_tipo_fila IS NOT NULL, 'FILA', 'Fila operacional não encontrada.');

    UPDATE fila_operacional
       SET substatus = 'FINALIZADO',
           data_fim = NOW(),
           observacao = COALESCE(p_resultado, observacao),
           id_responsavel = COALESCE(id_responsavel, v_id_usuario)
     WHERE id_fila = p_id_fila;

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'FINALIZADO', CONCAT('Finalizado | Tipo=',v_tipo_fila), NOW());

    -- Se for EXAME/RX, fecha protocolo
    IF v_tipo_fila IN ('EXAME','RX') THEN
        SET v_tipo_proto = IF(v_tipo_fila='RX','RX','EXAME');

        SELECT pp.id_protocolo INTO v_id_protocolo
          FROM procedimento_protocolo pp
         WHERE pp.id_fila = p_id_fila
           AND pp.tipo = v_tipo_proto
         LIMIT 1;

        IF v_id_protocolo IS NOT NULL THEN
            UPDATE procedimento_protocolo
               SET status = 'FINALIZADO',
                   atualizado_em = NOW()
             WHERE id_protocolo = v_id_protocolo;

            INSERT INTO procedimento_protocolo_evento(id_protocolo, tipo_evento, detalhe, criado_em, id_sessao_usuario, id_usuario)
            VALUES (v_id_protocolo, 'FINALIZADO', LEFT(COALESCE(p_resultado,'(sem resultado)'), 2000), NOW(), p_id_sessao_usuario, v_id_usuario);
        END IF;
    END IF;

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'fila_operacional',
        p_id_fila,
        'PROCEDIMENTO_FINALIZADO',
        CONCAT('Finalizado | Tipo=',v_tipo_fila),
        NULL,
        'fila_operacional',
        v_id_usuario
    );

    COMMIT;
END ;;