CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_senha`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT
)
BEGIN
    -- Finaliza senha
    UPDATE senha
    SET status = 'FINALIZADO', finalizado_em = NOW()
    WHERE id = p_id_senha;

    -- Auditoria
    INSERT INTO auditoria_evento (id_sessao_usuario, entidade, id_entidade, acao, criado_em)
    VALUES (p_id_sessao_usuario, 'senha', p_id_senha, 'FINALIZE', NOW());

    -- Evento semântico
    INSERT INTO senha_eventos (id_senha, id_sessao_usuario, evento, criado_em)
    VALUES (p_id_senha, p_id_sessao_usuario, 'SENHA_FINALIZADA', NOW());

END ;;